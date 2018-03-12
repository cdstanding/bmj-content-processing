<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	version="2.0">

	<xsl:template match="tx-options[parent::treatment]">
		
		<xsl:element name="timeframes">
			<xsl:for-each 
				select="
				tx-option[@timeframe='acute'][1] |
				tx-option[@timeframe='ongoing'][1] |
				tx-option[@timeframe='presumptive'][1]  
				">
				<xsl:variable name="section" select="name()"/>
				<xsl:variable name="group" select="@strength | @key-factor | @order | @timeframe"/>
				<xsl:variable name="name" select="name($group)"/>
		
				<xsl:element name="{$name}">
					<xsl:attribute name="type" select="$group"/>
					<xsl:choose>
						<xsl:when test="name()='tx-option'">
							<xsl:element name="pt-groups">
								<xsl:apply-templates select="parent::*/*[name()=$section and @*=$group]"/>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="parent::*/*[name()=$section and @*=$group]"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				
			</xsl:for-each>
		</xsl:element>		
	</xsl:template>
	
	<!--[parent::tx-options/parent::treatment]-->
	<xsl:template match="tx-option">
		<xsl:variable name="current-pt-group" select="translate(normalize-space(pt-group), $upper, $lower)"/>
		<xsl:variable name="current-tx-line-group-name" select="concat(name(@tx-line), '-', @tx-line)"/>
		
		<xsl:variable name="preceding-tx-option-id" select="generate-id(preceding-sibling::tx-option[position()=1])"/>
		<xsl:variable name="following-tx-option-id" select="generate-id(following-sibling::tx-option[position()=1])"/>
		
		<!-- open pt-group with disable-output-escaping -->
		<xsl:choose>
			
			<!-- (first or no preceding matching pt-group) and (last or no following matching pt-group) -->
			<!-- note output from here is only going to have one pt-group -->
			<xsl:when test="
				(position() = 1 
					or preceding-sibling::tx-option[generate-id(.)=$preceding-tx-option-id and translate(normalize-space(pt-group), $upper, $lower) != $current-pt-group])
				and (following-sibling::tx-option[generate-id(.)=$following-tx-option-id and translate(normalize-space(pt-group), $upper, $lower) != $current-pt-group] 
					or position() = last()) 
				">
				<xsl:element name="pt-group">
					<xsl:attribute name="generated-id" select="generate-id(.)"/>
					<xsl:element name="name">
						<xsl:apply-templates select="pt-group/node()" />	
					</xsl:element>
					<xsl:choose>
						<xsl:when test="
							parent::tx-options/parent::tx-option
							or (parent::tx-options/parent::treatment
								and tx-type[string-length(normalize-space(.))!=0]
								and @tx-line != 'unset')
							">
							<xsl:element name="tx-options">
								<xsl:attribute name="tx-line" select="@tx-line"/>
								<xsl:call-template name="process-tx-option-body"/>
							</xsl:element>	
						</xsl:when>
						<xsl:otherwise>
							<xsl:comment>
								<xsl:text>removed blank parent tx-option with id </xsl:text>
								<xsl:value-of select="@id"/>
							</xsl:comment>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="tx-options/tx-option">
						<xsl:element name="pt-groups">
							<xsl:apply-templates select="tx-options/tx-option"/>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:when>
			
			<!-- folloing matching pt-group and (first or no preceding matching pt-group) -->
			<xsl:when test="
				following-sibling::tx-option[generate-id(.)=$following-tx-option-id and translate(normalize-space(pt-group), $upper, $lower) = $current-pt-group]
					and (position() = 1 
						or preceding-sibling::tx-option[generate-id(.)=$preceding-tx-option-id and translate(normalize-space(pt-group), $upper, $lower) != $current-pt-group]) 
				">
				<xsl:text disable-output-escaping="yes">&#13;&lt;pt-group generated-id="</xsl:text>
				<xsl:value-of select="generate-id(.)"/>
				<xsl:text disable-output-escaping="yes">"&gt;&#13;</xsl:text>
				<xsl:element name="name">
					<xsl:apply-templates select="pt-group/node()" />	
				</xsl:element>
				<xsl:call-template name="process-tx-option-tier-group">
					<xsl:with-param name="new-pt-group">true</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			
			<!-- process tx-options in between group --> 
			<xsl:otherwise>
				<xsl:call-template name="process-tx-option-tier-group">
					<xsl:with-param name="new-pt-group">false</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

		<!-- preceding matching pt-group and (last or no following matching pt-group) -->
		<xsl:if test="			
			(
			preceding-sibling::tx-option[generate-id(.)=$preceding-tx-option-id and translate(normalize-space(pt-group), $upper, $lower) = $current-pt-group]
				and (position() = last() 
					or following-sibling::tx-option[generate-id(.)=$following-tx-option-id and translate(normalize-space(pt-group), $upper, $lower) != $current-pt-group])
			)
			
			and not(
			(position() = 1 
			or preceding-sibling::tx-option[generate-id(.)=$preceding-tx-option-id and translate(normalize-space(pt-group), $upper, $lower) != $current-pt-group])
			and (following-sibling::tx-option[generate-id(.)=$following-tx-option-id and translate(normalize-space(pt-group), $upper, $lower) != $current-pt-group] 
			or position() = last())
			)
			 
			">
			
			<!-- process child tx-options -->
			<xsl:if test="tx-options/tx-option">
				<xsl:element name="pt-groups">
					<xsl:apply-templates select="tx-options/tx-option"/>
				</xsl:element>
			</xsl:if>
			<xsl:text disable-output-escaping="yes">&#13;&lt;/pt-group&gt;&#13;</xsl:text>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="process-tx-option-tier-group">
		
		<xsl:param name="new-pt-group"/>
		
		<xsl:variable name="current-pt-group" select="translate(normalize-space(pt-group), $upper, $lower)"/>
		<xsl:variable name="current-tx-line" select="@tx-line"/>
		<xsl:variable name="current-tx-line-group-name" select="concat(name(@tx-line), '-', @tx-line)"/>
		
		<xsl:variable name="preceding-tx-option-id" select="generate-id(preceding-sibling::tx-option[position()=1])"/>
		<xsl:variable name="following-tx-option-id" select="generate-id(following-sibling::tx-option[position()=1])"/>
		
		<!-- open pt-group with disable-output-escaping -->
		<xsl:choose>
			
			<xsl:when test="
				(position() = 1 
				or preceding-sibling::tx-option[generate-id(.)=$preceding-tx-option-id and @tx-line != $current-tx-line]
					or $new-pt-group = 'true')
						and (following-sibling::tx-option[generate-id(.)=$following-tx-option-id and @tx-line != $current-tx-line] 
					or position() = last()) 
				">
				<xsl:element name="tx-options">
					<xsl:attribute name="tx-line" select="@tx-line"/>
					<xsl:call-template name="process-tx-option-body"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="
				following-sibling::tx-option[generate-id(.)=$following-tx-option-id and @tx-line = $current-tx-line]
				and (position() = 1 
					or preceding-sibling::tx-option[generate-id(.)=$preceding-tx-option-id and @tx-line != $current-tx-line]
					or $new-pt-group = 'true') 
				">
				<xsl:text disable-output-escaping="yes">&#13;&lt;</xsl:text>
				<xsl:text>tx-options tx-line="</xsl:text>
				<xsl:value-of select="@tx-line"/>
				<xsl:text disable-output-escaping="yes">"&gt;&#13;</xsl:text>
				<xsl:call-template name="process-tx-option-body"/>
			</xsl:when>			
			<xsl:otherwise>
				<xsl:call-template name="process-tx-option-body"/>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test="
			(
				(
				preceding-sibling::tx-option[generate-id(.)=$preceding-tx-option-id and @tx-line = $current-tx-line]
					and (position() = last() 
						or following-sibling::tx-option[generate-id(.)=$following-tx-option-id and @tx-line != $current-tx-line])
				)
				or (
				preceding-sibling::tx-option[generate-id(.)=$preceding-tx-option-id and translate(normalize-space(pt-group), $upper, $lower) = $current-pt-group]
					and (position() = last() 
						or following-sibling::tx-option[generate-id(.)=$following-tx-option-id and translate(normalize-space(pt-group), $upper, $lower) != $current-pt-group])
				)
			)
			and not(
				(position() = 1 
					or preceding-sibling::tx-option[generate-id(.)=$preceding-tx-option-id and @tx-line != $current-tx-line]
					or $new-pt-group = 'true')
				and (following-sibling::tx-option[generate-id(.)=$following-tx-option-id and @tx-line != $current-tx-line] 
					or position() = last())
			)
			">
			<xsl:text disable-output-escaping="yes">&#13;&lt;/tx-options&gt;&#13;</xsl:text>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="process-tx-option-body">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@id"/>
			<xsl:if test="@version">
				<xsl:attribute name="version" select="@version"/>
			</xsl:if>
			<xsl:for-each select="pt-group | @timeframe | @tx-line | @tier">
				<xsl:comment>
					<xsl:value-of select="name()"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="."/>
				</xsl:comment>
			</xsl:for-each>
			<xsl:apply-templates select="node()[name()!='tx-options' and name()!='pt-group']"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="regimens">
		<xsl:for-each 
			select="
			regimen[@tier='1'][1] |
			regimen[@tier='2'][1] |
			regimen[@tier='3'][1] 
			">
			<xsl:variable name="group" select="@tier"/>
			<xsl:variable name="regimen-tier-group-name">
				<xsl:choose>
					<xsl:when test="@tier='1'">
						<xsl:text>primary</xsl:text>
					</xsl:when>
					<xsl:when test="@tier='2'">
						<xsl:text>secondary</xsl:text>
					</xsl:when>
					<xsl:when test="@tier='3'">
						<xsl:text>tertiary</xsl:text>
					</xsl:when>
				</xsl:choose>
				<xsl:text>-regimen-tier</xsl:text>
			</xsl:variable>
			<xsl:element name="regimens">
				<xsl:attribute name="tier" select="@tier"/>
				<xsl:apply-templates select="parent::*/*[name()='regimen' and @*=$group]"/>
			</xsl:element>				
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="regimen">
		<xsl:element name="{name()}">
			<xsl:comment>
				<xsl:text>tier: </xsl:text>
				<xsl:value-of select="@tier"/>
			</xsl:comment>
			<xsl:apply-templates select="node()[name()!='tx-options']"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="component">
		<xsl:element name="{name()}">
			<xsl:attribute name="modifier" select="@modifier"/>
			<xsl:attribute name="id" select="@id"/>			
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>

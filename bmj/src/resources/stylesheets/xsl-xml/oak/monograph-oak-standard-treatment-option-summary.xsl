<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xi="http://www.w3.org/2001/XInclude" 
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns="http://schema.bmj.com/delivery/oak"
	xmlns:bp="http://schema.bmj.com/delivery/oak-bp"
	xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
	version="2.0">
	
	
	
	<xsl:template name="process-level-2-section-with-heading-and-with-implied-grouping-summary">
		<xsl:variable name="name" select="name()" />
		<xsl:variable name="parent-name" select="name(parent::*)" />
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name" />
			
			
			
			<!-- TODO order these enumerations the same in schema as here -->
			<xsl:for-each 
				select="
				tx-option[@timeframe='presumptive'][1] | 
				tx-option[@timeframe='acute'][1] |
				tx-option[@timeframe='ongoing'][1] 
				">
				
				<xsl:variable name="section" select="name()" />
				<xsl:variable name="group" select="@strength | @key-factor | @order | @timeframe" />
				<xsl:variable name="name" select="concat($group, '-', $section, '-group')" />
				
				<xsl:element name="section">
					<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
					<xsl:attribute name="class" select="$name" />
					
					<xsl:element name="title">
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="$name"/>
						</xsl:call-template>
					</xsl:element>
					
					<xsl:call-template name="process-first-tx-option-in-timeframe-group-summary" />
					
				</xsl:element>
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-first-tx-option-in-timeframe-group-summary">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="group" select="@timeframe"/>
		<xsl:variable name="first-tx-option-in-group" select="generate-id()"/>
		
		<!--<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
		
		<xsl:element name="table">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
			<xsl:attribute name="border">0</xsl:attribute>
			
			<xsl:element name="thead">
				<xsl:element name="tr">
					<xsl:element name="td">
						<xsl:attribute name="width">30%</xsl:attribute>
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="string('pt-group')"/>
						</xsl:call-template>
					</xsl:element>
					<xsl:element name="td">
						<xsl:attribute name="width">10%</xsl:attribute>
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="string('tx-line')"/>
						</xsl:call-template>
					</xsl:element>
					<xsl:element name="td">
						<xsl:attribute name="width">60%</xsl:attribute>
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="string('treatment')"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="tbody">
				
				<xsl:element name="tr">
					<xsl:attribute name="class">tx-option-seperater</xsl:attribute>
					
					<xsl:element name="td">
						<xsl:attribute name="width">30%</xsl:attribute>
						
						<xsl:choose>
							
							<xsl:when test="parent::tx-options/parent::treatment">
								<xsl:attribute name="align">left</xsl:attribute>
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:attribute name="align">right</xsl:attribute>
							</xsl:otherwise>
							
						</xsl:choose>
						
						<xsl:element name="b">
							<xsl:apply-templates select="pt-group/node()" />	
						</xsl:element>
						
						<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
						
					</xsl:element>
					
					<xsl:element name="td">
						<xsl:attribute name="width">10%</xsl:attribute>
						<xsl:attribute name="align">center</xsl:attribute>
						
						<xsl:if test="@tx-line and @tx-line!='unset' and string-length(@tx-line)!=0">
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="concat('tx-line-', @tx-line)"/>
							</xsl:call-template>
						</xsl:if>
						
						<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
						
					</xsl:element>
					
					<xsl:element name="td">
						<xsl:attribute name="width">60%</xsl:attribute>
						
						<xsl:element name="b">
							<xsl:apply-templates select="tx-type/node()" />	
						</xsl:element>
						
						<!--<xsl:apply-templates select="comments" />-->
						
						<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
						
					</xsl:element>
				</xsl:element>
				
				<xsl:apply-templates select="regimens" mode="tx-summary" />
				
				<xsl:apply-templates select="//tx-option[@timeframe=$group and generate-id(.)!=$first-tx-option-in-group]" mode="tx-summary">
					<xsl:with-param name="first-tx-option-in-group" select="$first-tx-option-in-group" />
				</xsl:apply-templates>
				
			</xsl:element>
			
		</xsl:element>
		
		<!--</xsl:element>-->
		
	</xsl:template>
	
	<xsl:template match="tx-option" mode="tx-summary">
		<xsl:param name="first-tx-option-in-group" />
		<xsl:variable name="current-pt-group" select="normalize-space(pt-group)"/>
		
		<xsl:if test="generate-id()!=$first-tx-option-in-group">
			
			<xsl:element name="tr">
				<xsl:choose>
					<xsl:when test="
						parent::tx-options/parent::treatment
						and (position()=1
							or preceding-sibling::tx-option/pt-group != $current-pt-group)
						">
						<xsl:attribute name="class">pt-group-seperater</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="class">tx-option-seperater</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:element name="td">
					<xsl:attribute name="width">30%</xsl:attribute>
					<xsl:choose>
						<xsl:when test="parent::tx-options/parent::treatment">
							<xsl:attribute name="align">left</xsl:attribute>
							<xsl:apply-templates select="pt-group/node()" />
							<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
						</xsl:when>
						<xsl:when test="preceding-sibling::tx-option[pt-group=$current-pt-group]">
							<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
							<!--<xsl:text>|</xsl:text>-->
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="align">right</xsl:attribute>
							<!--<xsl:attribute name="align">left</xsl:attribute>-->
							<xsl:text>►</xsl:text>
							<!--<xsl:text>└→</xsl:text>-->
							<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
							<xsl:apply-templates select="pt-group/node()" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				
				<xsl:element name="td">
					<xsl:attribute name="width">10%</xsl:attribute>
					<xsl:attribute name="align">center</xsl:attribute>
					
					<xsl:if test="@tx-line and @tx-line!='unset' and string-length(@tx-line)!=0">
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="concat('tx-line-', @tx-line)"/>
						</xsl:call-template>	
					</xsl:if>
					
					<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
					
				</xsl:element>
				
				<xsl:element name="td">
					<xsl:attribute name="width">60%</xsl:attribute>
					
					<xsl:apply-templates select="tx-type/node()" />
					
					<!--<xsl:apply-templates select="comments" />-->
					
					<!--<xsl:apply-templates select="regimens" />-->
					
					<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
					
				</xsl:element>
				
			</xsl:element>
			
			<!--<xsl:apply-templates select="regimens" mode="tx-summary" />-->
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="regimens" mode="tx-summary">
		<xsl:for-each 
			select="
			regimen[@tier='1'][1] |
			regimen[@tier='2'][1] |
			regimen[@tier='3'][1] |
			regimen[@tier='4'][1] |
			regimen[@tier='5'][1] 
			">
			<xsl:variable name="group" select="@tier"/>
			<xsl:variable name="name" select="concat(@tier, '-regimen-group')"/>
			
			<xsl:element name="tr">
				<xsl:attribute name="class" select="concat('n', $name)" />
				<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
				
				<xsl:element name="td">
					<xsl:attribute name="width">30%</xsl:attribute>
					<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
				</xsl:element>
				<xsl:element name="td">
					<xsl:attribute name="width">10%</xsl:attribute>
					<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
				</xsl:element>
				<xsl:element name="td">
					<xsl:attribute name="width">60%</xsl:attribute>
					<xsl:element name="title">
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="$name"/>
						</xsl:call-template>
					</xsl:element>
					<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
				</xsl:element>
			</xsl:element>
			
			<xsl:if test="regimen-name[string-length(normalize-space(.))!=0]">
				
				<xsl:element name="tr" use-attribute-sets="">
					
					<xsl:element name="td" use-attribute-sets="">
						<xsl:attribute name="width">30%</xsl:attribute>
						<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
					</xsl:element>
					
					<xsl:element name="td" use-attribute-sets="">
						<xsl:attribute name="width">10%</xsl:attribute>
						<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
					</xsl:element>
					
					<xsl:element name="td" use-attribute-sets="">
						<xsl:attribute name="width">60%</xsl:attribute>
						
						<xsl:apply-templates select="regimen-name/node()" />
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:if>
			
			<xsl:apply-templates select="parent::*/*[name()='regimen' and @*=$group]" mode="tx-summary"/>
			
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="regimen | components" mode="tx-summary">
		<xsl:apply-templates mode="tx-summary" />
	</xsl:template>
	
	<xsl:template match="component" mode="tx-summary">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="tr">
			<!--<xsl:attribute name="class" select="$name" />-->
			<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
			
			<xsl:attribute name="id">hidden</xsl:attribute>
			
			<xsl:element name="td">
				<xsl:attribute name="width">30%</xsl:attribute>
				<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
			</xsl:element>
			
			<xsl:element name="td">
				<xsl:attribute name="width">10%</xsl:attribute>
				<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
			</xsl:element>
			
			<xsl:element name="td">
				<xsl:attribute name="class" select="$name" />
				<xsl:attribute name="width">60%</xsl:attribute>
				
				<xsl:apply-templates select="name/node()" />
				
				<xsl:if test="details[string-length(normalize-space(.))!=0]">
					<xsl:text>: </xsl:text>
					<xsl:apply-templates select="details/node()" />
				</xsl:if>
				
				<xsl:choose>
					
					<xsl:when test="@modifier='unset'">
						<!-- do nothing -->
					</xsl:when>
					
					<xsl:when 
						test="
						@modifier='or'  
						or @modifier='and'  
						or @modifier='and/or' 
						">
						
						<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
						
						<xsl:element name="inline">
							<xsl:attribute name="class">modifier</xsl:attribute>
							<xsl:value-of select="@modifier"/>
						</xsl:element>
						
					</xsl:when>
					
					<xsl:when test="@modifier='OR'">
						
						<xsl:element name="br"/>
						
						<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
						
						<xsl:element name="inline">
							<xsl:attribute name="class">modifier</xsl:attribute>
							<xsl:text>-- </xsl:text>
							<xsl:value-of select="@modifier" />
							<xsl:text> --</xsl:text>
						</xsl:element>
						
					</xsl:when>
					
					<xsl:when 
						test="
						@modifier='AND'  
						or @modifier='AND/OR' 
						">
						
						<xsl:element name="br"/>
						
						<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
						
						<xsl:element name="inline">
							<xsl:attribute name="class">modifier</xsl:attribute>
							<xsl:text>-- </xsl:text>
							<xsl:value-of select="@modifier" />
							<xsl:text> --</xsl:text>
						</xsl:element>
						
					</xsl:when>
					
					<!-- previosly do nothing -->
					<xsl:otherwise>
						
						<xsl:element name="br"/>
						
						<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
						
						<xsl:element name="inline">
							<xsl:attribute name="class">modifier</xsl:attribute>
							<xsl:text>OR</xsl:text>
						</xsl:element>
						
					</xsl:otherwise>
					
				</xsl:choose>
				
				<!--<xsl:apply-templates select="comments" mode="tx-summary" />-->
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<!--<xsl:template match="comments" mode="tx-summary">
		
		<xsl:element name="span">
			<xsl:attribute name="id">hidden</xsl:attribute>
			
			<xsl:apply-templates />
			
		</xsl:element>
		
	</xsl:template>-->
	
</xsl:stylesheet>

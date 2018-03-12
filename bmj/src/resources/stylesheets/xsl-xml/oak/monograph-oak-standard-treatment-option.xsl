<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://schema.bmj.com/delivery/oak"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:bp="http://schema.bmj.com/delivery/oak-bp"
	version="2.0">
	
	<xsl:template name="process-top-level-tx-summary">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:namespace name="bp">http://schema.bmj.com/delivery/oak-bp</xsl:namespace>
			<xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
			<xsl:attribute name="xsi:schemaLocation">http://schema.bmj.com/delivery/oak http://schema.bmj.com/delivery/oak/bmj-oak-strict.xsd</xsl:attribute>
			<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="id" select="concat('_', @dx-id)"/>
			<!--<xsl:attribute name="xml:lang" select="$lang"/>-->
			
			<xsl:element name="section">
				<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
				<xsl:attribute name="class" select="$name"/>
				
				<xsl:element name="title">
					<xsl:apply-templates select="monograph-info/title/node()" />
					<!--<xsl:text disable-output-escaping="yes"> </xsl:text>
						<xsl:text>[Treatment summary]</xsl:text>-->
				</xsl:element>
				
				<xsl:element name="p">
					
					<xsl:text>Summary of </xsl:text>
					
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('tx-options')"/>
					</xsl:call-template>
					
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					
					<xsl:element name="link">
						<xsl:attribute name="target">
							<xsl:text>JavaScript:doMenu('hidden');</xsl:text>
						</xsl:attribute>
						<xsl:text>[+]</xsl:text>
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
			<!--<xsl:for-each select="//treatment/tx-options/tx-option">
				<xsl:call-template name="process-first-tx-option-in-timeframe-group"/>
				</xsl:for-each>-->
			
			<xsl:apply-templates select="//treatment/tx-options"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<!--<xsl:template name="process-first-tx-option-in-timeframe-group">-->
	<xsl:template match="treatment/tx-options[1]/tx-option[1]">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="group" select="@timeframe"/>
		<xsl:variable name="first-tx-option-in-group" select="generate-id()"/>
		
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
						
						<xsl:element name="title">
							<xsl:apply-templates select="pt-group/node()" />	
						</xsl:element>
						
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
						
						<xsl:element name="section">
							
							<xsl:element name="title">
								<xsl:apply-templates select="tx-type/node()" />
							</xsl:element>
							
							<xsl:if test="not(contains($components, 'tx-summary'))">
								<xsl:apply-templates select="comments" />
								<xsl:apply-templates select="regimens" />
							</xsl:if>
							
						</xsl:element>
						
					</xsl:element>
					
				</xsl:element>
				
				<xsl:apply-templates select="//tx-option[@timeframe=$group and generate-id(.)!=$first-tx-option-in-group]" >
					<xsl:with-param name="first-tx-option-in-group" select="$first-tx-option-in-group" />
				</xsl:apply-templates>
				
			</xsl:element>
			
		</xsl:element>
			
	</xsl:template>
	
	<xsl:template match="tx-option">
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
							
							<xsl:element name="title">
								<xsl:apply-templates select="pt-group/node()" />	
							</xsl:element>
							
						</xsl:when>
						
						<xsl:when test="preceding-sibling::tx-option[1][normalize-space(pt-group)=$current-pt-group]">
							<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
						</xsl:when>
						
						<xsl:otherwise>
							
							<xsl:element name="p">
								<xsl:text disable-output-escaping="yes">&#160;└►&#160;</xsl:text>
								<xsl:apply-templates select="pt-group/node()" />
							</xsl:element>
							
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
					
					<xsl:element name="section">
							
						<xsl:element name="title">
							<xsl:apply-templates select="tx-type/node()" />
						</xsl:element>
						
						<xsl:if test="not(contains($components, 'tx-summary'))">
							<xsl:apply-templates select="comments" />
							<xsl:apply-templates select="regimens" />
						</xsl:if>
							
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="regimens">
		
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
			
			<xsl:element name="section">
				<xsl:attribute name="class" select="concat('n', $name)" />
				
				<xsl:element name="title">
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="$name"/>
					</xsl:call-template>
				</xsl:element>
				
				<xsl:if test="regimen-name[string-length(normalize-space(.))!=0]">
					<xsl:element name="p">
						<xsl:apply-templates select="regimen-name/node()" />
					</xsl:element>
				</xsl:if>
				
				<xsl:for-each select="parent::*/*[name()='regimen' and @*=$group]">
					<xsl:call-template name="process-regimen"/>	
				</xsl:for-each>
				
			</xsl:element>
			
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-regimen">
		
		<xsl:for-each select="components/component">
			<xsl:call-template name="process-component"/>
		</xsl:for-each>
			
		<xsl:if 
			test="
			position()!=last() 
			and 
			components[last()]/component[last()]
			[
			@modifier!='AND'
			and @modifier!='AND/OR'
			and @modifier!='and'
			and @modifier!='and/or'
			and @modifier!='or'
			]
			">
			
			<xsl:element name="p">
				<xsl:element name="inline">
					<xsl:attribute name="class">modifier-big</xsl:attribute>
					<xsl:text>OR</xsl:text>
				</xsl:element>
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="process-component">

		<xsl:if test="position()=1">
			<xsl:text disable-output-escaping="yes">&lt;section class="component-wrap"&gt;</xsl:text>
			<xsl:text disable-output-escaping="yes">&lt;section class="component-box"&gt;</xsl:text>
		</xsl:if>
		
		<xsl:element name="p">
			
			<xsl:apply-templates select="name/node()" />
			
			<xsl:if test="details[string-length(normalize-space(.))!=0]">
				<xsl:text>: </xsl:text>
				<xsl:apply-templates select="details/node()" />
			</xsl:if>
			
		</xsl:element>
		
		<xsl:apply-templates select="comments" />
		
		<xsl:choose>
			
			<xsl:when test="@modifier='and' or @modifier='or' or @modifier='and/or'" >
				
				<xsl:choose>

					<xsl:when test="position()!=last()">
						
						<xsl:element name="p">
							<xsl:element name="inline">
								<xsl:attribute name="class">modifier-small</xsl:attribute>
								<xsl:value-of select="@modifier"/>
							</xsl:element>
						</xsl:element>
						
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:text disable-output-escaping="yes">&lt;/section&gt;</xsl:text>
						<xsl:text disable-output-escaping="yes">&lt;/section&gt;</xsl:text>
						
						<xsl:element name="p">
							<xsl:element name="inline">
								<xsl:attribute name="class">modifier-small</xsl:attribute>
								<xsl:value-of select="@modifier"/>
							</xsl:element>
						</xsl:element>
						
					</xsl:otherwise>
					
				</xsl:choose>
				
			</xsl:when>
			
			<xsl:when test="@modifier='AND' or @modifier='AND/OR'">
				
				<xsl:if test="position()=last()">
					<xsl:text disable-output-escaping="yes">&lt;/section&gt;</xsl:text>    
				</xsl:if>
				
				<xsl:text disable-output-escaping="yes">&lt;/section&gt;</xsl:text>
				
				<xsl:element name="p">
					<xsl:element name="inline">
						<xsl:attribute name="class">modifier-big</xsl:attribute>
						<xsl:text> -- </xsl:text>
						<xsl:value-of select="@modifier"/>
						<xsl:text> -- </xsl:text>
					</xsl:element>
				</xsl:element>
				
				<xsl:if test="position()!=last()">
					<xsl:text disable-output-escaping="yes">&lt;section class="component-box"&gt;</xsl:text>
				</xsl:if>
				
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:text disable-output-escaping="yes">&lt;/section&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;/section&gt;</xsl:text>
			</xsl:otherwise>
			
		</xsl:choose>
				
	</xsl:template>
	
</xsl:stylesheet>
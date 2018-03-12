<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
	version="2.0">
	
	<xsl:template name="process-first-tx-option-in-timeframe-group">

		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="group" select="@timeframe"/>
		<xsl:variable name="first-tx-option-in-group" select="generate-id()"/>
		
		<xsl:element name="fo:table" use-attribute-sets="">
			<xsl:attribute name="border">0</xsl:attribute>
			<xsl:attribute name="table-omit-header-at-break">true</xsl:attribute>
			
			<xsl:element name="fo:table-header" use-attribute-sets="">
				
				<xsl:element name="fo:table-row" use-attribute-sets="">
					<xsl:attribute name="border-bottom">1pt</xsl:attribute>
					<xsl:attribute name="border-color">#000000</xsl:attribute>
					<xsl:attribute name="border-style">solid</xsl:attribute>
					<xsl:attribute name="border-top">0pt</xsl:attribute>
					
					<xsl:element name="fo:table-cell" use-attribute-sets="">
						<xsl:attribute name="width">35%</xsl:attribute>
						<xsl:attribute name="display-align">after</xsl:attribute>
						
						<xsl:element name="fo:block" use-attribute-sets="strong align-center">
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="string('pt-group')"/>
							</xsl:call-template>
						</xsl:element>
						
					</xsl:element>
					
					<xsl:element name="fo:table-cell" use-attribute-sets="">
						<xsl:attribute name="width">10%</xsl:attribute>
						<xsl:attribute name="display-align">after</xsl:attribute>
						
						<xsl:element name="fo:block" use-attribute-sets="strong align-center">
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="string('tx-line')"/>
							</xsl:call-template>
						</xsl:element>
						
					</xsl:element>
					
					<xsl:element name="fo:table-cell" use-attribute-sets="">
						<xsl:attribute name="width">55%</xsl:attribute>
						<xsl:attribute name="display-align">after</xsl:attribute>
						
						<xsl:element name="fo:block" use-attribute-sets="strong align-center">
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="string('treatment')"/>
							</xsl:call-template>
						</xsl:element>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:table-body" use-attribute-sets="">
				
				<xsl:element name="fo:table-row" use-attribute-sets="">

					<xsl:element name="fo:table-cell" use-attribute-sets="">
						<xsl:attribute name="width">30%</xsl:attribute>
						
						<xsl:element name="fo:block" use-attribute-sets="">
							
							<xsl:element name="fo:block" use-attribute-sets="strong">
								<xsl:apply-templates select="pt-group/node()" />	
							</xsl:element>
							
						</xsl:element>
						
					</xsl:element>
					
					<xsl:element name="fo:table-cell" use-attribute-sets="">
						<xsl:attribute name="width">10%</xsl:attribute>
						<xsl:attribute name="text-align" select="string('center')"/>
						
						<xsl:element name="fo:block">
							
							<xsl:if test="@tx-line and @tx-line!='unset' and string-length(@tx-line)!=0">
								<xsl:call-template name="process-string-variant">
									<xsl:with-param name="name" select="concat('tx-line-', @tx-line)"/>
								</xsl:call-template>
							</xsl:if>
							
							<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
							
						</xsl:element>
						
					</xsl:element>
					
					<xsl:element name="fo:table-cell" use-attribute-sets="">
						<xsl:attribute name="width">60%</xsl:attribute>
						
						<xsl:element name="fo:block" use-attribute-sets="">
							
							<xsl:element name="fo:block" use-attribute-sets="strong">
								<xsl:apply-templates select="tx-type/node()" />
							</xsl:element>
							
							<xsl:apply-templates select="comments" />
							<xsl:apply-templates select="regimens" />
							
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
			
			<xsl:element name="fo:table-row" use-attribute-sets="">
				
				<xsl:if test="
					parent::tx-options/parent::treatment
					and (position()=1
					or preceding-sibling::tx-option/pt-group != $current-pt-group)
					">
					<xsl:attribute name="border-top">1pt</xsl:attribute>
					<xsl:attribute name="border-color">#000000</xsl:attribute>
					<xsl:attribute name="border-style">solid</xsl:attribute>
					<xsl:attribute name="border-bottom">0pt</xsl:attribute>
				</xsl:if>
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					<xsl:attribute name="width">30%</xsl:attribute>
					
					<xsl:choose>
						
						<xsl:when test="parent::tx-options/parent::treatment">
							
							<xsl:element name="fo:block" use-attribute-sets="strong">
								<xsl:apply-templates select="pt-group/node()" />
								<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
							</xsl:element>
							
						</xsl:when>
						
						<xsl:when test="preceding-sibling::tx-option[pt-group=$current-pt-group]">
							
							<xsl:element name="fo:block" use-attribute-sets="">
								<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
							</xsl:element>
							
						</xsl:when>
						
						<xsl:otherwise>
							
							<xsl:element name="fo:block" use-attribute-sets="">
								<xsl:text disable-output-escaping="yes">&#160;=>&#160;</xsl:text>
								<xsl:apply-templates select="pt-group/node()" />
							</xsl:element>
							
						</xsl:otherwise>
						
					</xsl:choose>
					
				</xsl:element>
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					<xsl:attribute name="width">10%</xsl:attribute>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:attribute name="text-align" select="string('center')"/>
						
						<xsl:if test="@tx-line and @tx-line!='unset' and string-length(@tx-line)!=0">
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="concat('tx-line-', @tx-line)"/>
							</xsl:call-template>
						</xsl:if>
						
						<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
						
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					<xsl:attribute name="width">60%</xsl:attribute>
					
					<xsl:element name="fo:block">
						
						<xsl:element name="fo:block" use-attribute-sets="strong">
							<xsl:apply-templates select="tx-type/node()" />
						</xsl:element>
						
						<xsl:apply-templates select="comments" />
						<xsl:apply-templates select="regimens" />
						
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
			
			<xsl:element name="fo:block">
				
				<xsl:element name="fo:block" use-attribute-sets="strong">
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="$name"/>
					</xsl:call-template>
				</xsl:element>
				
				<xsl:if test="regimen-name[string-length(normalize-space(.))!=0]">
					<xsl:element name="fo:block">
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
			
			<xsl:element name="fo:block" use-attribute-sets="strong em">
				<xsl:text>OR</xsl:text>
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="process-component">
		
		<xsl:if test="position()=1">
			<xsl:text disable-output-escaping="yes">&lt;fo:block border-style="solid" border-width="1px" padding="5px" margin="5px" background-color="lightgrey" keep-together="always"&gt;</xsl:text>
			<xsl:text disable-output-escaping="yes">&lt;fo:block border-style="dotted" border-width="1px" padding="5px" margin="0px" background-color="white" keep-together="always"&gt;</xsl:text>
		</xsl:if>
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
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
						
						<xsl:element name="fo:block" use-attribute-sets="strong em">
							<xsl:value-of select="@modifier"/>
						</xsl:element>
						
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:text disable-output-escaping="yes">&lt;/fo:block&gt;</xsl:text>
						<xsl:text disable-output-escaping="yes">&lt;/fo:block&gt;</xsl:text>
						
						<xsl:element name="fo:block" use-attribute-sets="strong em">
							<xsl:value-of select="@modifier"/>
						</xsl:element>
						
					</xsl:otherwise>
					
				</xsl:choose>
				
			</xsl:when>
			
			<xsl:when test="@modifier='AND' or @modifier='AND/OR'">
				
				<xsl:if test="position()=last()">
					<xsl:text disable-output-escaping="yes">&lt;/fo:block&gt;</xsl:text>    
				</xsl:if>
				
				<xsl:text disable-output-escaping="yes">&lt;/fo:block&gt;</xsl:text>
				
				<xsl:element name="fo:block" use-attribute-sets="strong em">
					<xsl:text> -- </xsl:text>
					<xsl:value-of select="@modifier"/>
					<xsl:text> -- </xsl:text>
				</xsl:element>
				
				<xsl:if test="position()!=last()">
					<xsl:text disable-output-escaping="yes">&lt;fo:block&gt;</xsl:text> <!--class="component-box"-->
				</xsl:if>
				
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:text disable-output-escaping="yes">&lt;/fo:block&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;/fo:block&gt;</xsl:text>
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
	
</xsl:stylesheet>
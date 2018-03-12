<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xi xsi cals"
	version="2.0">
	
	<xsl:param name="image-logo"/>
	<xsl:param name="image-footer"/>
    <xsl:param name="info-standard-logo"/>
	<xsl:param name="data-folder"/>
	<xsl:param name="published-date"/>
	<xsl:param name="language"/>

    <!-- Variable to create a new line -->
    <xsl:variable name="newline" select="'&#10;&#160;&#160;&#160;'" />
   
	<xsl:variable name="audience">
		<xsl:choose>
			<xsl:when test="$language = 'en-gb'">
				<xsl:text>UK</xsl:text>
			</xsl:when>
			<xsl:when test="$language = 'en-us'">
				<xsl:text>US</xsl:text>
			</xsl:when>			
			<xsl:otherwise>
				<xsl:value-of select="$language"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>		

	<xsl:variable name="bhurl">
		<xsl:text>http://besthealth.bmj.com</xsl:text>				
	</xsl:variable>		
		
	<xsl:include href="../../xsl-entities/custom-map-renderx.xsl"/>
	<xsl:variable name="publicationYear" select="substring-after($published-date, ', ')"/>
	
	<xsl:template name="footer_copyright">
		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:text disable-output-escaping="yes">&#xA9;</xsl:text> 
			BMJ Publishing Group Limited <xsl:value-of select="$publicationYear"/>. All rights reserved.
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="footer_page_number">
		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="color">#CCCCCC</xsl:attribute>
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			page <fo:page-number/> of  <fo:page-number-citation ref-id="theEnd"/>
		</xsl:element>	
	</xsl:template>
	
	<xsl:template name="declaration_text">
		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="space-before">20pt</xsl:attribute>
			<xsl:element name="fo:external-graphic">
				<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
				<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
				<xsl:attribute name="height">0.075in</xsl:attribute>
				<xsl:attribute name="width">6.4in</xsl:attribute>
				<xsl:attribute name="scaling">non-uniform</xsl:attribute>
				<xsl:attribute name="src">
					<xsl:text>url('</xsl:text><xsl:value-of select="$image-footer"/><xsl:text>')</xsl:text>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="keep-together">always</xsl:attribute>
			<xsl:attribute name="space-before">5pt</xsl:attribute>
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			This information is aimed at a <xsl:value-of select="$audience"/> patient audience. This information however does not replace medical advice.
			<xsl:element name="fo:block" use-attribute-sets=""/>
			If you have a medical problem please see your doctor. Please see our full <xsl:element name="fo:basic-link">
				<xsl:attribute name="external-destination">
					<xsl:text>url('http://www.bmj.com/company/legal-information')</xsl:text>
				</xsl:attribute>
				<xsl:element name="fo:inline" use-attribute-sets="link">
					<xsl:text>Conditions of Use</xsl:text>
				</xsl:element>
			</xsl:element> for this content. These leaflets are reviewed annually.
		</xsl:element>
          <xsl:element name="fo:block" use-attribute-sets="">
           
                  <xsl:value-of select="$newline"></xsl:value-of>
            
            </xsl:element>
	    
      <xsl:element name="fo:block">     
            <xsl:element name="fo:list-block">
                   <xsl:element name="fo:list-item">
                         <xsl:element name="fo:list-item-label" >
                                <xsl:attribute name="end-indent">
                                    label-end()
                                </xsl:attribute>
                        	<xsl:element name="fo:block">
                                    <xsl:attribute name="text-align">
                                           left
                             	      </xsl:attribute>
                                     <xsl:element name="fo:external-graphic">
                                          <xsl:attribute name="keep-with-next">
                                                always
                                          </xsl:attribute>
                                          <xsl:attribute name="content-height">
                                                5%
                                          </xsl:attribute>
                                          <xsl:attribute name="content-width">
                                                5%
                                          </xsl:attribute>
                                          <xsl:attribute name="src">
                                                <xsl:text>url('</xsl:text>
                                                <xsl:value-of select="$info-standard-logo"/>
                                                <xsl:text>')</xsl:text>
                                          </xsl:attribute>
                                    </xsl:element>
                              </xsl:element>
                        </xsl:element>
                         <xsl:element name="fo:list-item-body" >
                               <xsl:element name="fo:block">
                                    <xsl:attribute name="text-align">
                                           right
                                    </xsl:attribute>
                                     <xsl:element name="fo:external-graphic">
                                          <xsl:attribute name="keep-with-next">
                                                always
                                          </xsl:attribute>
                                          <xsl:attribute name="content-height">
                                                20%
                                          </xsl:attribute>
                                          <xsl:attribute name="content-width">
                                                20%
                                          </xsl:attribute>
                                          <xsl:attribute name="src">
                                                <xsl:text>url('</xsl:text>
                                                <xsl:value-of select="$image-logo"/>
                                                <xsl:text>')</xsl:text>
                                          </xsl:attribute>
                                    </xsl:element>
                              </xsl:element>
                        </xsl:element>
                 </xsl:element>
           </xsl:element>
      </xsl:element>
      
	</xsl:template>
	

	<xsl:template match="article-glossaries">
		<xsl:if test="./gloss">
			<xsl:element name="fo:block" use-attribute-sets="space-before space-after pale-grey-background">
				<xsl:element name="fo:block" use-attribute-sets="space-after-small pale-blue-background">
					<xsl:element name="fo:inline" use-attribute-sets="reference-title">
						<xsl:text>Glossary:</xsl:text>
					</xsl:element>
				</xsl:element>
				<xsl:apply-templates/>			
			</xsl:element>	
		</xsl:if>
	</xsl:template>

	<xsl:template match="gloss">
		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			<xsl:element name="fo:inline" use-attribute-sets="font-8pt bold">
				<xsl:apply-templates select="term"/>	
			</xsl:element>
		</xsl:element>
		<xsl:element name="fo:block" use-attribute-sets="space-after-small">
			<xsl:element name="fo:inline" use-attribute-sets="font-8pt">
				<xsl:apply-templates select="definition" mode="gloss"/>	
			</xsl:element>								
		</xsl:element>
	</xsl:template>
			
	<xsl:template match="article-references">
		<xsl:if test="./reference">
			<xsl:element name="fo:block" use-attribute-sets="space-before space-after grey-background">
				<xsl:element name="fo:block" use-attribute-sets="space-after-small pale-blue-background">
					<xsl:element name="fo:inline" use-attribute-sets="reference-title">
						<xsl:text>Sources for the information on this leaflet:</xsl:text>
					</xsl:element>
				</xsl:element>
				<xsl:apply-templates/>			
			</xsl:element>	
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="reference">
		<xsl:element name="fo:block" use-attribute-sets="space-after-small">
			<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			<xsl:element name="fo:inline" use-attribute-sets="font-8pt">
	        <xsl:call-template name="findLinkPosition">
	            <xsl:with-param name="target"><xsl:value-of select="@id"/></xsl:with-param>
	            <xsl:with-param name="type">bibr</xsl:with-param>
	        </xsl:call-template>
	        <xsl:text>. </xsl:text>
	        <xsl:value-of select="primary-authors"/>
   	        <xsl:value-of select="primary-title"/>
   	        <xsl:value-of select="source"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="sec">
		<xsl:param name="sectionDepth"/>
		<xsl:element name="fo:block" use-attribute-sets="">	
			<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			<xsl:apply-templates>
				<xsl:with-param name="sectionDepth">
					<xsl:choose>
						<xsl:when test="string-length(normalize-space($sectionDepth))!=0">
							<xsl:value-of select="xs:string(xs:integer($sectionDepth) + 1)"/>
						</xsl:when>
						<xsl:otherwise>
							
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:with-param> 
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>

	<xsl:template match="sec" mode="info-box">
		<xsl:param name="sectionDepth"/>
		<xsl:element name="fo:block" use-attribute-sets="border padding-small pale-grey-background space-after">	
			<xsl:attribute name="id">further-information/<xsl:value-of select="@id"/></xsl:attribute>
			<xsl:apply-templates>
				<xsl:with-param name="sectionDepth" select="xs:string(xs:integer($sectionDepth) + 1)"/>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="title">
		<xsl:param name="sectionDepth"/>
		
		<!--<xsl:choose>
			<xsl:when test="$sectionDepth = '1'">
				<xsl:element name="fo:block"
					use-attribute-sets="heading1 space-before space-after keep-with-next">
					<xsl:apply-templates/>
				</xsl:element>		
			</xsl:when>
			<xsl:when test="$sectionDepth = '2'">
				<xsl:element name="fo:block"
					use-attribute-sets="heading2 space-before space-after keep-with-next">
					<xsl:apply-templates/>
				</xsl:element>						
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="fo:block"
				use-attribute-sets="heading3 space-before space-after keep-with-next">
				<xsl:apply-templates/>
				</xsl:element>	
			</xsl:otherwise>
		</xsl:choose>-->
		
		<xsl:comment select="concat('h', count(ancestor-or-self::*:sec))"/>
		
		<xsl:element name="fo:block" use-attribute-sets="space-before space-after keep-with-next">
			
			<xsl:choose>
				<xsl:when test="count(ancestor-or-self::*:sec)=1">
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					<xsl:attribute name="color">darkred</xsl:attribute>
					<xsl:attribute name="font-size">14pt</xsl:attribute>
				</xsl:when>
				<xsl:when test="count(ancestor-or-self::*:sec)=2">
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					<xsl:attribute name="color">darkblue</xsl:attribute>
					<xsl:attribute name="font-size">12pt</xsl:attribute>
				</xsl:when>
				<xsl:when test="count(ancestor-or-self::*:sec)=3">
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					<xsl:attribute name="font-size">12pt</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="font-weight">bold</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:apply-templates/>
			
		</xsl:element>
	
	</xsl:template>
	
	<xsl:template match="p">
		<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="p" mode="gloss">
		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
		
	<xsl:template match="bold">
		<xsl:element name="fo:inline" use-attribute-sets="bold">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

    <xsl:template match="ext-link">
		<xsl:element name="fo:basic-link">
			<xsl:attribute name="external-destination">
				<xsl:text>url('</xsl:text><xsl:value-of select="@href"/><xsl:text>')</xsl:text>
			</xsl:attribute>
			<xsl:element name="fo:inline" use-attribute-sets="link">
				<xsl:apply-templates/>
			</xsl:element>    
		</xsl:element>
    </xsl:template>
    	
	<xsl:template match="italic">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	
    <xsl:template match="list">
        <xsl:element name="fo:list-block"><xsl:apply-templates/></xsl:element>
    </xsl:template>
    
	<xsl:template match="list-item">
        <xsl:element name="fo:list-item" use-attribute-sets="space-before-small space-after-small">
            <fo:list-item-label end-indent="label-end()">
                <fo:block>&#x2022;</fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block><xsl:apply-templates/></fo:block>
            </fo:list-item-body>
        </xsl:element>
	</xsl:template>
	
	<xsl:template match="article-title">
		<xsl:element name="fo:block" use-attribute-sets="space-before space-after">Nav: <xsl:value-of
			select="."/></xsl:element>
	</xsl:template>

	<xsl:template match="xref[@ref-type='fig']">
		<xsl:variable name="figureid" select="@rid"/>
		<xsl:element name="fo:block" use-attribute-sets="space-after-small">
			<xsl:attribute name="padding-before">5pt</xsl:attribute>			
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:element name="fo:external-graphic">
				<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
				<xsl:attribute name="src">
					<xsl:text>url('</xsl:text><xsl:value-of select="$data-folder"/><xsl:text>/</xsl:text><xsl:value-of select="//article-figures/figure[@id=$figureid]/@image"/><xsl:text>')</xsl:text>
				</xsl:attribute>
			</xsl:element>		
			<xsl:element name="fo:inline" use-attribute-sets="font-8pt pale-grey-background">
				<xsl:attribute name="text-align">center</xsl:attribute>
				<xsl:apply-templates select="//article-figures/figure[@id=$figureid]/caption"/>
			</xsl:element>			
		</xsl:element>	
	</xsl:template>

	<xsl:template match="xref[@ref-type='gloss']">
		<xsl:variable name="glossid" select="@rid"/>
		<xsl:element name="fo:inline" use-attribute-sets="pale-blue-background">
			<xsl:element name="fo:basic-link">
				<xsl:attribute name="internal-destination">
					<xsl:value-of select="@rid"/>
				</xsl:attribute>
				<xsl:apply-templates />
			</xsl:element>	
		</xsl:element>	
	</xsl:template>
		
	<xsl:template match="xref[@ref-type='bibr']">
		<xsl:variable name="id"><xsl:value-of select="@rid"/></xsl:variable>
		<xsl:element name="fo:inline" use-attribute-sets="ref-link">
			<xsl:element name="fo:basic-link">
				<xsl:attribute name="internal-destination">
					<xsl:value-of select="@rid"/>
				</xsl:attribute>
				<xsl:text>[</xsl:text>
	   	        <xsl:call-template name="findLinkPosition">
		            <xsl:with-param name="target"><xsl:value-of select="@rid"/></xsl:with-param>
		            <xsl:with-param name="type">bibr</xsl:with-param>
		        </xsl:call-template>
	   			<xsl:text>]</xsl:text>
			</xsl:element>		
		</xsl:element>
	</xsl:template>

    <xsl:template match="xref[@ref-type='patient-treatment']">
		<xsl:choose>
			<xsl:when test="//article[@article-type = 'patient-topic']/@id = @topic-id">
				<xsl:element name="fo:basic-link">
					<xsl:attribute name="internal-destination">
						<xsl:value-of select="@rid"/>
						<xsl:text>/</xsl:text>
						<xsl:value-of select="@section"/>

					</xsl:attribute>
					<xsl:element name="fo:inline" use-attribute-sets="link">					
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:element>						
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="fo:basic-link">
					<xsl:attribute name="external-destination">
						<xsl:text>url('</xsl:text><xsl:value-of select="$bhurl"/><xsl:text>')</xsl:text>
					</xsl:attribute>
					<xsl:element name="fo:inline" use-attribute-sets="link">
						<xsl:apply-templates/>
					</xsl:element>    
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:template>

	<xsl:template match="xref[@ref-type='patient-topic']">
		<xsl:choose>
			<xsl:when test="//article[@article-type = 'patient-topic']/@id = @rid">
				<xsl:element name="fo:basic-link">
					<xsl:attribute name="internal-destination">
						<xsl:value-of select="@section"/>
					</xsl:attribute>
					<xsl:element name="fo:inline" use-attribute-sets="link">					
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:element>						
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="fo:basic-link">
					<xsl:attribute name="external-destination">
						<xsl:text>url('</xsl:text><xsl:value-of select="$bhurl"/><xsl:text>')</xsl:text>
					</xsl:attribute>
					<xsl:element name="fo:inline" use-attribute-sets="link">
						<xsl:apply-templates/>
					</xsl:element>    
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:template>
        
	<xsl:template match="further-information">
		<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
			<xsl:attribute name="id"><xsl:value-of select="name()"/></xsl:attribute>
			<xsl:apply-templates select="sec" mode="info-box">
				<xsl:with-param name="sectionDepth">0</xsl:with-param>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	    
	<xsl:template match="caption">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template name="findLinkPosition">
        <xsl:param name="target"/>
        <xsl:param name="type"/>        
        <xsl:for-each select="//xref[@ref-type=$type and not(@rid = preceding::xref/@rid)]">
            <xsl:if test="$target = @rid">
                <xsl:value-of select="position()"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    

    
    <!-- Attribute sets -->
	<xsl:attribute-set name="link">
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
		<xsl:attribute name="color">#0D519F</xsl:attribute>
		<!-- blue -->
	</xsl:attribute-set>

	<xsl:attribute-set name="ref-link">
		<xsl:attribute name="baseline-shift">super</xsl:attribute>
		<xsl:attribute name="font-size">8pt</xsl:attribute>
		<xsl:attribute name="color">#0D519F</xsl:attribute>
		<!-- blue -->
	</xsl:attribute-set>
	
	<xsl:attribute-set name="drug">
		<xsl:attribute name="color">#5E8F39</xsl:attribute>
		<!-- dark green -->
	</xsl:attribute-set>
	
	
	<xsl:attribute-set name="bold">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="heading1">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">#990000</xsl:attribute>
		<!-- red -->
		<xsl:attribute name="font-size">14pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="heading2">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="heading3">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">#990000</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="topic-title">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">24pt</xsl:attribute>
		<xsl:attribute name="color">#0000FF</xsl:attribute>
		<!-- bluer blue -->
	</xsl:attribute-set>
	
	<xsl:attribute-set name="headline-title">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">15pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="section-title">
		<xsl:attribute name="text-transform">uppercase</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="space-before">
		<xsl:attribute name="space-before.minimum">5pt</xsl:attribute>
		<xsl:attribute name="space-before.maximum">20pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">10pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="space-after">
		<xsl:attribute name="space-after.minimum">5pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">20pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">10pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="space-before-small">
		<xsl:attribute name="space-before.minimum">3pt</xsl:attribute>
		<xsl:attribute name="space-before.maximum">10pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">5pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="space-after-small">
		<xsl:attribute name="space-after.minimum">3pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">10pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">5pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="keep-with-next">
		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="image">
		<xsl:attribute name="space-after.minimum">5pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">20pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">10pt</xsl:attribute>
	</xsl:attribute-set>
	
	
	<xsl:attribute-set name="sub">
		<xsl:attribute name="baseline-shift">sub</xsl:attribute>
		<xsl:attribute name="font-size">8pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="sup">
		<xsl:attribute name="baseline-shift">super</xsl:attribute>
		<xsl:attribute name="font-size">8pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="blue-background">
		<xsl:attribute name="background-color">#C5C9E6</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="grey-background">
		<xsl:attribute name="background-color">#CCCCCC</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="pale-blue-background">
		<xsl:attribute name="background-color">#E6EEEE</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="pale-grey-background">
		<xsl:attribute name="background-color">#f4f4f4</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="reference-title">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">8pt</xsl:attribute>				
	</xsl:attribute-set>			

	<xsl:attribute-set name="font-8pt">
		<xsl:attribute name="font-size">8pt</xsl:attribute>
	</xsl:attribute-set>			
	
	<xsl:attribute-set name="leader">
		<xsl:attribute name="leader-length">5in</xsl:attribute>
		<xsl:attribute name="leader-pattern">rule</xsl:attribute>
		<xsl:attribute name="alignment-baseline">middle</xsl:attribute>
		<xsl:attribute name="rule-thickness">0.5pt</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="page-id">
		<xsl:attribute name="color">#CCCCCC</xsl:attribute>
		<xsl:attribute name="font-size">7pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="further-information-box">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="background-color">#f4f4f4</xsl:attribute>
		<xsl:attribute name="border-width">1mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name='border'>
		<xsl:attribute name='border-before-style'>solid</xsl:attribute>
		<xsl:attribute name='border-after-style'>solid</xsl:attribute>
		<xsl:attribute name='border-start-style'>solid</xsl:attribute>
		<xsl:attribute name='border-end-style'>solid</xsl:attribute>
		
		<xsl:attribute name='border-before-width'>.1mm</xsl:attribute>
		<xsl:attribute name='border-after-width'>.1mm</xsl:attribute>
		<xsl:attribute name='border-start-width'>.1mm</xsl:attribute>
		<xsl:attribute name='border-end-width'>.1mm</xsl:attribute>
	</xsl:attribute-set>		


		
	<xsl:attribute-set name="padding-small">
		<xsl:attribute name="padding-left">5pt</xsl:attribute>
		<xsl:attribute name="padding-right">5pt</xsl:attribute>
		<xsl:attribute name="padding-top">5pt</xsl:attribute>
		<xsl:attribute name="padding-bottom">5pt</xsl:attribute>				
	</xsl:attribute-set>	
	
</xsl:stylesheet>

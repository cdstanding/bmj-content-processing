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
	
	<xsl:output
		method="xml"
		version="1.0"
		encoding="UTF-8"
		indent="yes"
		use-character-maps="custom-map-renderx"
		doctype-public="-//BMJ//DTD FO:ROOT//EN"
		doctype-system="http://www.renderx.com/Tests/validator/fo2000.dtd"/>
	
	<xsl:preserve-space elements=""/>
	<xsl:strip-space elements="fo:basic-link fo:inline fo:page-number-citation"/>
		
	<xsl:include href="common-bh-rtf-fo.xsl"/>
	
	<xsl:include href="patient-table-fo.xsl"/>
	
	<xsl:template match="/">
		<xsl:element name="fo:root" use-attribute-sets="">
			
			<xsl:element name="fo:layout-master-set" use-attribute-sets="">
				<xsl:element name="fo:simple-page-master" use-attribute-sets="">
					<xsl:attribute name="master-name">my-page</xsl:attribute>
					<xsl:element name="fo:region-body" use-attribute-sets="">
						<xsl:attribute name="margin">0.8in</xsl:attribute>
					</xsl:element>
					<xsl:element name="fo:region-before" use-attribute-sets="">
						<xsl:attribute name="region-name">header</xsl:attribute>
						<xsl:attribute name="extent">0.5in</xsl:attribute>
					</xsl:element>
					<xsl:element name="fo:region-after" use-attribute-sets="">
						<xsl:attribute name="region-name">footer</xsl:attribute>
						<xsl:attribute name="extent">0.5in</xsl:attribute>
					</xsl:element>
					<xsl:element name="fo:region-start" use-attribute-sets="">
						<xsl:attribute name="extent">0.8in</xsl:attribute>
					</xsl:element>
					<xsl:element name="fo:region-end" use-attribute-sets="">
						<xsl:attribute name="extent">0.8in</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:page-sequence" use-attribute-sets="">
				<xsl:attribute name="master-reference">my-page</xsl:attribute>
			
				<xsl:element name="fo:static-content" use-attribute-sets="">
					<xsl:attribute name="flow-name">header</xsl:attribute>
					<xsl:element name="fo:retrieve-marker">
						<xsl:attribute name="retrieve-class-name">header_marker</xsl:attribute>
						<xsl:attribute name="retrieve-position">first-including-carryover</xsl:attribute>
					</xsl:element>
				</xsl:element>
				
				<xsl:element name="fo:static-content" use-attribute-sets="">
					<xsl:attribute name="flow-name">footer</xsl:attribute>
					<xsl:call-template name="footer_copyright"/>
					<xsl:element name="fo:retrieve-marker">
						<xsl:attribute name="retrieve-class-name">footer_published_date</xsl:attribute>
						<xsl:attribute name="retrieve-position">last-ending-within-page</xsl:attribute>
					</xsl:element>					
					<xsl:call-template name="footer_page_number"/>
				</xsl:element>
				
				<xsl:element name="fo:flow" use-attribute-sets="">
					<xsl:attribute name="flow-name">xsl-region-body</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:element name="fo:block" use-attribute-sets="">
							<xsl:attribute name="padding-before">10pt</xsl:attribute>			
							<xsl:attribute name="text-align">right</xsl:attribute>
							<xsl:element name="fo:external-graphic">
								<xsl:attribute name="content-height">12%</xsl:attribute>
								<xsl:attribute name="content-width">12%</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:text>url('</xsl:text><xsl:value-of select="$image-logo"/><xsl:text>')</xsl:text>
								</xsl:attribute>
							</xsl:element>		
						</xsl:element>
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:attribute name="font-weight">bold</xsl:attribute>
						<xsl:attribute name="font-size">14pt</xsl:attribute>
						<xsl:attribute name="space-after">5pt</xsl:attribute>
						Patient information from the BMJ Group
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:attribute name="space-after">5pt</xsl:attribute>
						<xsl:element name="fo:inline" use-attribute-sets="topic-title">
							<xsl:value-of select="/article/front/article-meta/title-group/article-title"/>
						</xsl:element>					
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:element name="fo:marker">
							<xsl:attribute name="marker-class-name">header_marker</xsl:attribute>
							<xsl:element name="fo:block" use-attribute-sets="">
								<xsl:attribute name="padding-before">20pt</xsl:attribute>
								<xsl:attribute name="text-align">center</xsl:attribute>
								<xsl:attribute name="font-weight">bold</xsl:attribute>
								<xsl:value-of select="/article/front/article-meta/title-group/article-title"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					
					<xsl:call-template name="topic-section_list"/>

					<xsl:apply-templates select="/article/body/introduction"/>				
					<xsl:apply-templates select="/article/body/description"/>				
					<xsl:apply-templates select="/article/body/symptoms"/>				
					<xsl:apply-templates select="/article/body/diagnosis"/>				
					<xsl:apply-templates select="/article/body/incidence"/>				
					<xsl:apply-templates select="/article/body/treatment-points"/>									
					<xsl:apply-templates select="/article/body/prognosis"/>				
					<xsl:apply-templates select="/article/body/questions-to-ask"/>				
																				
					<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
						<xsl:element name="fo:leader">
							<xsl:attribute name="leader-pattern">rule</xsl:attribute>
							<xsl:attribute name="leader-length">90%</xsl:attribute>
						</xsl:element>
					</xsl:element>
					
					<xsl:apply-templates select="/article/article-treatments"/>
					
					<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
						<xsl:element name="fo:block" use-attribute-sets="keep-with-next">
							<xsl:attribute name="font-weight">bold</xsl:attribute>
							<xsl:attribute name="font-size">14pt</xsl:attribute>
							<xsl:attribute name="space-after">5pt</xsl:attribute>
							Further information:			
						</xsl:element>
						<xsl:apply-templates select="//further-information"/>							
					</xsl:element>

					<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
						<xsl:element name="fo:leader">
							<!-- xsl:attribute name="leader-pattern">rule</xsl:attribute -->
							<xsl:attribute name="leader-length">90%</xsl:attribute>
						</xsl:element>
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
						<xsl:apply-templates select="/article/article-glossaries"/>				
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
						<xsl:element name="fo:leader">
							<!-- xsl:attribute name="leader-pattern">rule</xsl:attribute -->
							<xsl:attribute name="leader-length">90%</xsl:attribute>
						</xsl:element>
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="space-before">
						<xsl:apply-templates select="/article/article-references"/>				
					</xsl:element>
										
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:attribute name="id">theEnd</xsl:attribute>
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:call-template name="declaration_text"/>
					</xsl:element>

					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:element name="fo:marker">
							<xsl:attribute name="marker-class-name">footer_published_date</xsl:attribute>
							<xsl:element name="fo:block" use-attribute-sets="">
								<xsl:attribute name="font-size">8pt</xsl:attribute>
								Last published: <xsl:value-of select="$published-date"/>				
							</xsl:element>
						</xsl:element>
					</xsl:element>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="description | treatment-points | treatment-groups">
		<xsl:element name="fo:block" use-attribute-sets="">	
			<xsl:attribute name="id"><xsl:value-of select="name()"/></xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="introduction 
	| overview | key-points | explanation | risk-factors | classification | staging
	| symptoms | prognosis | diagnosis | incidence | questions-to-ask | survival-rates | self-management
	| treatment-approach | guidelines | drug-alerts | which-treatments-work-best
	| treatments">
		
		<xsl:choose>
			<!-- do nothing if element contains no content - stop strange spacing -->
			<xsl:when test=".[text()[string-length(normalize-space(.))=0] and count(element())=0]">
				<xsl:comment>empty content (1) removed: <xsl:value-of select="name()"/></xsl:comment>
			</xsl:when>
			<xsl:when test=".[not(node()[not(self::comment())])]">
				<xsl:comment>empty content (2) removed: <xsl:value-of select="name()"/></xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
					<xsl:choose>
						<xsl:when test="parent::body">
							<xsl:attribute name="id"><xsl:value-of select="name()"/></xsl:attribute>
						</xsl:when>
						<xsl:when test="parent::description">
							<xsl:attribute name="id">description/<xsl:value-of select="name()"/></xsl:attribute>
						</xsl:when>				
						<xsl:when test="parent::treatment-points">
							<xsl:attribute name="id">treatment-points/<xsl:value-of select="name()"/></xsl:attribute>
						</xsl:when>	
						<xsl:when test="parent::group">
							<xsl:attribute name="id">group/<xsl:value-of select="parent::group/@id"/>/<xsl:value-of select="name()"/></xsl:attribute>
						</xsl:when>													
					</xsl:choose>
					<xsl:apply-templates select="sec">
						<xsl:with-param name="sectionDepth">0</xsl:with-param>
					</xsl:apply-templates>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="introduction[ancestor::article-treatments] | does-it-work | what-is-it | benefits | how-does-it-work | harms | how-good-is-the-research">
		
		<!-- only process if its got content -->
		<xsl:choose>
			<!-- do nothing if element contains no content - stop strange spacing -->
			<xsl:when test=".[text()[string-length(normalize-space(.))=0] and count(element())=0]">
				<xsl:comment>empty content (x) removed: <xsl:value-of select="name()"/></xsl:comment>
			</xsl:when>
			<xsl:when test=".[not(node()[not(self::comment())])]">
				<xsl:comment>empty content (z) removed: <xsl:value-of select="name()"/></xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
					<xsl:attribute name="id"><xsl:value-of select="ancestor::article[@article-type='patient-treatment']/@id"/>/<xsl:value-of select="name()"/></xsl:attribute>
					<xsl:apply-templates select="sec">
						<xsl:with-param name="sectionDepth">0</xsl:with-param>
					</xsl:apply-templates>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="group">
		<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
			<xsl:element name="fo:leader">
				<!-- xsl:attribute name="leader-pattern">rule</xsl:attribute -->
				<xsl:attribute name="leader-length">90%</xsl:attribute>
			</xsl:element>
		</xsl:element>
		<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
			<xsl:element name="fo:block" use-attribute-sets="keep-with-next">
				<xsl:attribute name="id">group/<xsl:value-of select="@id"/></xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-size">14pt</xsl:attribute>
				Treatment Group 
				<xsl:call-template name="findGroupPosition">
		            			<xsl:with-param name="target"><xsl:value-of select="@id"/></xsl:with-param>
		        		</xsl:call-template>
			</xsl:element>
			<xsl:apply-templates/>				
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="article-treatments">

		<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
			<xsl:element name="fo:block" use-attribute-sets="keep-with-next">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-size">16pt</xsl:attribute>
				<xsl:attribute name="space-after">5pt</xsl:attribute>
				<xsl:attribute name="space-before">5pt</xsl:attribute>
				Treatments:			
			</xsl:element>
			<xsl:apply-templates/>			
		</xsl:element>	
	</xsl:template>
	
	<xsl:template match="article[@article-type='patient-treatment']">
		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:attribute name="id"><xsl:value-of select="@id"/>/</xsl:attribute>
			<xsl:attribute name="space-after">5pt</xsl:attribute>
			<xsl:element name="fo:inline" use-attribute-sets="">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-size">16pt</xsl:attribute>
				<xsl:attribute name="color">#0000FF</xsl:attribute>
				<xsl:value-of select="front/article-meta/title-group/article-title"/>
			</xsl:element>					
		</xsl:element>	
		<xsl:apply-templates select="front/treatment-rating"/>		
		<xsl:apply-templates select="body"/>
		<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
			<xsl:element name="fo:leader">
				<xsl:attribute name="leader-pattern">rule</xsl:attribute>
				<xsl:attribute name="leader-length">90%</xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="findGroupPosition">
	        <xsl:param name="target"/>
	        <xsl:for-each select="//group">
	            <xsl:if test="$target = @id">
	                <xsl:value-of select="position()"/>
	            </xsl:if>
	        </xsl:for-each>
	</xsl:template>

	<xsl:template name="treatment-section_list">
		<xsl:param name="id"/>
		<xsl:element name="fo:block" use-attribute-sets="space-after space-before">
			<xsl:element name="fo:block" use-attribute-sets="font-8pt">
				<xsl:text>In this section</xsl:text>
			</xsl:element>
			<xsl:for-each select=".//body/*">
				<!-- only add link if content -->
				<xsl:choose>
					<!-- do nothing if element contains no content -->
					<xsl:when test=".[text()[string-length(normalize-space(.))=0] and count(element())=0]">
						<xsl:comment>empty content (a) removed: <xsl:value-of select="name()"/></xsl:comment>
					</xsl:when>
					<xsl:when test=".[not(node()[not(self::comment())])]">
						<xsl:comment>empty content (b) removed: <xsl:value-of select="name()"/></xsl:comment>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="fo:block" use-attribute-sets="font-8pt link">
							<xsl:element name="fo:basic-link">
								<xsl:attribute name="internal-destination">
									<xsl:value-of select="$id"/>/<xsl:value-of select="name()"/>
								</xsl:attribute>
								<xsl:value-of select="sec[1]/title"/>						
							</xsl:element>	
						</xsl:element>			
					</xsl:otherwise>
				</xsl:choose>		
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template name="topic-section_list">
		<xsl:element name="fo:block" use-attribute-sets="space-after space-before">
			<xsl:element name="fo:block" use-attribute-sets="font-8pt">
				<xsl:text>In this section</xsl:text>
			</xsl:element>
			<xsl:if test=".//body/description">
				<xsl:call-template name="add-topic-section">
					<xsl:with-param name="sectionName">description</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test=".//body/symptoms">
				<xsl:call-template name="add-topic-section">
					<xsl:with-param name="sectionName">symptoms</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test=".//body/diagnosis">
				<xsl:call-template name="add-topic-section">
					<xsl:with-param name="sectionName">diagnosis</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test=".//body/incidence">
				<xsl:call-template name="add-topic-section">
					<xsl:with-param name="sectionName">incidence</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test=".//body/treatment-points">
				<xsl:call-template name="add-topic-section">
					<xsl:with-param name="sectionName">treatment-points</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test=".//body/prognosis">
				<xsl:call-template name="add-topic-section">
					<xsl:with-param name="sectionName">prognosis</xsl:with-param>
				</xsl:call-template>
			</xsl:if>		
			<xsl:if test=".//body/questions-to-ask">
				<xsl:call-template name="add-topic-section">
					<xsl:with-param name="sectionName">questions-to-ask</xsl:with-param>
				</xsl:call-template>
			</xsl:if>																	
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="add-topic-section">
		<xsl:param name="sectionName"/>
		<xsl:element name="fo:block" use-attribute-sets="font-8pt link">
			<xsl:element name="fo:basic-link">
				<xsl:attribute name="internal-destination">
					<xsl:value-of select="$sectionName"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$sectionName = 'description'">What is it?</xsl:when>
					<xsl:when test="$sectionName = 'symptoms'">What are the symptoms?</xsl:when>
					<xsl:when test="$sectionName = 'diagnosis'">How is it diagnosed?</xsl:when>
					<xsl:when test="$sectionName = 'incidence'">How common is it?</xsl:when>
					<xsl:when test="$sectionName = 'prognosis'">What will happen?</xsl:when>																												
					<xsl:when test="$sectionName = 'questions-to-ask'">Questions to ask</xsl:when>																																			
					<xsl:when test="$sectionName = 'treatment-points'">What treatments work?</xsl:when>																																										
				</xsl:choose>
			</xsl:element>	
		</xsl:element>			
	</xsl:template>	
	
	<xsl:template match="treatment-rating">
		<xsl:element name="fo:block" use-attribute-sets="border padding-small pale-blue-background space-after">
			<xsl:element name="fo:block" use-attribute-sets="space-after-small">
				<xsl:element name="fo:inline" use-attribute-sets="reference-title">
					<xsl:text>Treatment Rating </xsl:text> 
				</xsl:element>
				<xsl:element name="fo:inline" use-attribute-sets="font-8pt">
					<xsl:text> [</xsl:text><xsl:value-of select="preceding-sibling::article-meta//custom-meta[child::meta-name[text() = 'rating-score']]/meta-value"/><xsl:text>]</xsl:text>
				</xsl:element>
			</xsl:element>
        	
			<xsl:element name="fo:block" use-attribute-sets="font-8pt">
				<xsl:element name="fo:block" >
					<xsl:element name="fo:inline" use-attribute-sets="reference-title">
						<xsl:text>Treatment Licence</xsl:text> 
					</xsl:element>
				</xsl:element>
		       	<xsl:element name="fo:list-block" use-attribute-sets="space-after-small">
					<xsl:for-each select="preceding-sibling::article-meta//custom-meta[child::meta-name[text() = 'treatment-licence']]/meta-value">
				        <xsl:element name="fo:list-item" >
				            <fo:list-item-label end-indent="label-end()">
				                <fo:block>&#x2022;</fo:block>
				            </fo:list-item-label>
				            <fo:list-item-body start-indent="body-start()">
				                <fo:block><xsl:apply-templates/></fo:block>
				            </fo:list-item-body>
				        </xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
						
        	
			<xsl:element name="fo:block" use-attribute-sets="font-8pt">
				<xsl:element name="fo:block" >
					<xsl:element name="fo:inline" use-attribute-sets="reference-title">
						<xsl:text>Grade Score</xsl:text> 
					</xsl:element>
				</xsl:element>
		       	<xsl:element name="fo:list-block" use-attribute-sets="space-after-small">
					<xsl:for-each select="preceding-sibling::article-meta//custom-meta[child::meta-name[text() = 'grade-score']]/meta-value">
				        <xsl:element name="fo:list-item" >
				            <fo:list-item-label end-indent="label-end()">
				                <fo:block>&#x2022;</fo:block>
				            </fo:list-item-label>
				            <fo:list-item-body start-indent="body-start()">
				                <fo:block><xsl:apply-templates/></fo:block>
				            </fo:list-item-body>
				        </xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
									
			<xsl:element name="fo:block" use-attribute-sets="font-8pt">
				<xsl:element name="fo:block" >
					<xsl:element name="fo:inline" use-attribute-sets="reference-title">
						<xsl:text>Treatment Forms</xsl:text> 
					</xsl:element>
				</xsl:element>
	        			<xsl:element name="fo:list-block" use-attribute-sets="space-after-small">
					<xsl:for-each select="preceding-sibling::article-meta//custom-meta[child::meta-name[text() = 'treatment-form']]/meta-value">
				        <xsl:element name="fo:list-item">
				            <fo:list-item-label end-indent="label-end()">
				                <fo:block>&#x2022;</fo:block>
				            </fo:list-item-label>
				            <fo:list-item-body start-indent="body-start()">
				                <fo:block><xsl:apply-templates/></fo:block>
				            </fo:list-item-body>
				        </xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>			        	
			
			<xsl:element name="fo:block" use-attribute-sets="font-8pt">
				<xsl:element name="fo:block" >
					<xsl:element name="fo:inline" use-attribute-sets="reference-title">
						<xsl:text>Treatment Examples</xsl:text> 
					</xsl:element>
				</xsl:element>
	        	<xsl:element name="fo:list-block" use-attribute-sets="space-after-small">
					<xsl:for-each select="treatment-examples/treatment-example">
				        <xsl:element name="fo:list-item">
				            <fo:list-item-label end-indent="label-end()">
				                <fo:block>&#x2022;</fo:block>
				            </fo:list-item-label>
				            <fo:list-item-body start-indent="body-start()">
				                <fo:block><xsl:apply-templates/></fo:block>
				            </fo:list-item-body>
				        </xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>			        	

			<xsl:element name="fo:block" use-attribute-sets="font-8pt">
				<xsl:element name="fo:block" >
					<xsl:element name="fo:inline" use-attribute-sets="reference-title">
						<xsl:text>Description</xsl:text> 
					</xsl:element>
				</xsl:element>
				<xsl:apply-templates select="description/sec">
					<xsl:with-param name="sectionDepth">0</xsl:with-param>
				</xsl:apply-templates>
			</xsl:element>		

			<xsl:element name="fo:block" use-attribute-sets="font-8pt">
				<xsl:element name="fo:block" >
					<xsl:element name="fo:inline" use-attribute-sets="reference-title">
						<xsl:text>Effect</xsl:text> 
					</xsl:element>
				</xsl:element>
				<xsl:apply-templates select="effect">
					<xsl:with-param name="sectionDepth">0</xsl:with-param>
				</xsl:apply-templates>
			</xsl:element>	
			
			<xsl:element name="fo:block" use-attribute-sets="font-8pt">
				<xsl:element name="fo:block" >
					<xsl:element name="fo:inline" use-attribute-sets="reference-title">
						<xsl:text>Research</xsl:text> 
					</xsl:element>
				</xsl:element>
				<xsl:apply-templates select="research/sec">
					<xsl:with-param name="sectionDepth">0</xsl:with-param>
				</xsl:apply-templates>
			</xsl:element>							

			<xsl:element name="fo:block" use-attribute-sets="font-8pt">
				<xsl:element name="fo:block" >
					<xsl:element name="fo:inline" use-attribute-sets="reference-title">
						<xsl:text>Harms</xsl:text> 
					</xsl:element>
				</xsl:element>
	        	<xsl:element name="fo:list-block" use-attribute-sets="space-after-small">
					<xsl:for-each select="harms/harm">
				        <xsl:element name="fo:list-item">
				            <fo:list-item-label end-indent="label-end()">
				                <fo:block>&#x2022;</fo:block>
				            </fo:list-item-label>
				            <fo:list-item-body start-indent="body-start()">
				                <fo:block><xsl:apply-templates/></fo:block>
				            </fo:list-item-body>
				        </xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>	
						        	
		</xsl:element>
	</xsl:template>			


</xsl:stylesheet>

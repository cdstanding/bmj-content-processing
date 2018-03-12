<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	exclude-result-prefixes="xi xsi cals"
	version="2.0">

	<!--<xsl:output
		method="xml"
		version="1.0"
		encoding="UTF-8"
		indent="yes"
		use-character-maps="custom-map-renderx"
		doctype-public="-//BMJ//DTD FO:ROOT//EN"
		doctype-system="http://www.renderx.com/Tests/validator/fo2000.dtd"/>-->
	<xsl:output
		method="xml"
		version="1.0"
		encoding="UTF-8"
		indent="yes"
		use-character-maps="custom-map-renderx"
	/>
	
	<xsl:preserve-space elements=""/>
	<xsl:strip-space elements="fo:basic-link fo:inline fo:page-number-citation"/>

	<xsl:param name="lang"/>
	<xsl:param name="media"/>
	<xsl:param name="system"/>
	<xsl:param name="proof"/>
	<xsl:param name="components"/>
	<xsl:param name="links-xml-input"/>
	<xsl:param name="temp-xml-input"/>
	<xsl:param name="systematic-review-xml-input"/>
	<xsl:param name="images-input"/>
	<xsl:param name="date"/>
	<xsl:param name="strings-variant-fileset"/>
	<xsl:param name="comparisons-tabulated"/>
	<xsl:param name="pub-resource-name"/>
	
	<xsl:include href="../../generic-params.xsl"/>
	<xsl:include href="../../systematic-review-params.xsl"/>
	<xsl:include href="../../systematic-review-rss.xsl"/>
	<xsl:include href="../../xsl-entities/custom-map-renderx.xsl"/>
	<xsl:include href="../generic-fo-fonts.xsl"/>
	<xsl:include href="../generic-fo-page-sizes.xsl"/>
	<xsl:include href="../generic-fo-default-elements.xsl"/>
	<xsl:include href="systematic-review-fo-params.xsl"/>
	<xsl:include href="systematic-review-fo-layout.xsl"/>
	<xsl:include href="systematic-review-fo-summary-views.xsl"/>
	<xsl:include href="systematic-review-fo-reference-range.xsl"/>
	
	<xsl:include href="../../xsl-lib/strings/publication-labels-process-shared.xsl"/>
	
	<xsl:include href="systematic-review-comparisons-serial.xsl"/>
	<xsl:include href="systematic-review-comparisons-tabulated.xsl"/>
	<xsl:include href="systematic-review-comparisons-grade-table.xsl"/>
	
	<xsl:variable name="links" select="document($links-xml-input)/*"/>
	<xsl:variable name="temp" select="document($temp-xml-input)/*"/>	
	<xsl:variable name="cid" select="substring-after(/systematic-review/@id, '_')"/>
	<xsl:variable name="bmjk-review-plan" select="document(/systematic-review/info/bmjk-review-plan-link/@target)/*"/>
	<xsl:variable name="primary-section-title" select="document($bmjk-review-plan//info/section-list/section-link[1]/@target)//title"/>
	<xsl:variable name="systematic-review-title" select="/systematic-review/info/title/node()"/>

	<xsl:variable name="question-list">
		<xsl:element name="question-list">
			<xsl:for-each select="/systematic-review/question-list/question">
				<xsl:element name="question">
					<xsl:copy-of select="title" />
					<xsl:choose>
						<xsl:when test="option">
							<xsl:for-each select="option">
								<xsl:copy-of select="self::option" />
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="xi:include[contains(@href, 'option')]">
								<xsl:copy-of select="document(@href)/*" />	
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>	
	</xsl:variable>
	
	<xsl:variable name="evidence-appraisal-grade-table">
		<xsl:choose>
			<xsl:when test="$question-list//*:question/*:option/*:comparison-set/*:comparison/*:grade/*:evidence-appraisal">
				<xsl:text>true</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>false</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:template match="/">
		
		<xsl:element name="fo:root" use-attribute-sets="root">
			
			<!--<xsl:attribute namespace="http://www.w3.org/1999/XSL/Format" name="xmlns:fo"/>
			<xsl:attribute namespace="http://www.renderx.com/XSL/Extensions" name="xmlns:rx"/>-->
			
			<!--<xsl:namespace name="fo">http://www.w3.org/1999/XSL/Format</xsl:namespace>
			<xsl:namespace name="rx">http://www.renderx.com/XSL/Extensions</xsl:namespace>-->
			
			<xsl:call-template name="process-layout-meta-info"/>
			<xsl:call-template name="process-layout-master-set"/>

			<xsl:element name="fo:page-sequence" use-attribute-sets="">
				<!--<xsl:attribute name="master-name">my-sequence</xsl:attribute>-->
				<xsl:attribute name="master-reference">my-sequence</xsl:attribute>

				<xsl:call-template name="process-static-header"/>
				<xsl:call-template name="process-static-footer"/>

				<xsl:element name="fo:flow" use-attribute-sets="flow">
					<xsl:attribute name="flow-name">xsl-region-body</xsl:attribute>
					
					<!-- add: inc. peer-review, author, etc. ? -->

					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:attribute name="id">first-page</xsl:attribute>
					</xsl:element>

					<xsl:element name="fo:block" use-attribute-sets="space-before">
						
						<xsl:if test="contains($proof, 'draft')">
							<xsl:element name="fo:block" use-attribute-sets="preview large align-center space-after">
								<xsl:element name="fo:block" use-attribute-sets="default-margin">
									<xsl:text>draft</xsl:text>
								</xsl:element>
							</xsl:element>
						</xsl:if>

						<xsl:choose>
							
							<xsl:when test="/systematic-review/info/title[string-length(.) &lt; 50]">
								<xsl:element name="fo:block" use-attribute-sets="strong huge">
									<xsl:apply-templates select="/systematic-review/info/title"/>
								</xsl:element>
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:element name="fo:block" use-attribute-sets="strong large">
									<xsl:apply-templates select="/systematic-review/info/title"/>
								</xsl:element>
							</xsl:otherwise>
							
						</xsl:choose>

						
						<xsl:if test="contains($proof, 'draft')">
							
							<xsl:element name="fo:block" use-attribute-sets="preview">
								
								<xsl:element name="fo:block" use-attribute-sets="default-margin">
									
									<xsl:text>abridged-title: </xsl:text>
									
									<xsl:apply-templates select="/systematic-review/info/abridged-title"/>
									
									<xsl:text> [ id: </xsl:text>
									<xsl:value-of select="$cid"/>
									<xsl:text> ]</xsl:text>
									
									<xsl:text> [ date: </xsl:text>
									<xsl:value-of select="$date"/>
									<xsl:text> ]</xsl:text>
									
								</xsl:element>
								
							</xsl:element>
							
						</xsl:if>
						
						<!-- add later: or contains($proof, 'peer-review') -->
						<xsl:if 
							test="
							(contains($proof, 'draft') 
							or contains($proof, 'peer-review'))
							and /systematic-review/notes/p[string-length(.)!=0]
							">
							
							<xsl:element name="fo:block" use-attribute-sets="preview space-before">
								
								<xsl:element name="fo:block" use-attribute-sets="align-center default-margin">
									<xsl:text>notes</xsl:text>
								</xsl:element>
								
								<xsl:for-each select="/systematic-review/notes/p">
									<xsl:element name="fo:block" use-attribute-sets="default-margin color-black">
										<xsl:apply-templates/>
									</xsl:element>
								</xsl:for-each>
								
								<xsl:element name="fo:block" use-attribute-sets="default-margin"/>
								
							</xsl:element>
							
							<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
							
						</xsl:if>

					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="strong color-blue">
						<xsl:apply-templates select="/systematic-review/info/search-date"/>
					</xsl:element>

					<xsl:element name="fo:block" use-attribute-sets="em color-blue space-after">
						
						<xsl:choose>
							
							<xsl:when test="contains($components, 'contributors')">
								
								<xsl:element name="fo:basic-link" use-attribute-sets="">
									<xsl:attribute name="internal-destination" select="concat($cid, '_CONTRIB')"/>
									<xsl:apply-templates select="/systematic-review/info/collective-name"/>
								</xsl:element>
								
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:apply-templates select="/systematic-review/info/collective-name"/>
							</xsl:otherwise>
							
						</xsl:choose>
						
					</xsl:element>
					
					<xsl:if test="contains($components, 'abstract')">
						<xsl:call-template name="process-abstract"/>
					</xsl:if>					
					
					<xsl:if test="contains($components, 'summary-questions-list')">
						<xsl:call-template name="process-summary-questions-list"/>
					</xsl:if>
					
					<xsl:if test="contains($components, 'summary-interventions-list')">
						<xsl:call-template name="process-summary-interventions-list"/>
					</xsl:if>
					
					<xsl:if test="contains($components, 'key-points-list')">
						<xsl:call-template name="process-key-points-list"/>
					</xsl:if>
					
					<xsl:if test="contains($components, 'summary-view-summary-statement-list')">
						<xsl:call-template name="process-summary-view-summary-statement-list"/>
					</xsl:if>
					
					<xsl:if test="contains($components, 'summary-view-concise')">
						<xsl:call-template name="process-summary-view-concise"/>
					</xsl:if>
					
					<xsl:if test="contains($components, 'clinical-context')">
						<xsl:call-template name="process-clinical-context"/>
					</xsl:if>
										
					<xsl:if test="contains($components, 'background')">
						<xsl:call-template name="process-background"/>
					</xsl:if>
					
					<xsl:if test="contains($components, 'questions')">
						<xsl:call-template name="process-questions"/>
					</xsl:if>
					
					<xsl:if test="contains($components, 'glossaries')">
						<xsl:call-template name="process-glossary"/>
					</xsl:if>
					
					<xsl:if test="contains($components, 'substantive-changes')">
						<xsl:call-template name="process-substantive-changes"/>
					</xsl:if>
					
					<xsl:if test="contains($components, 'references')">
						<xsl:call-template name="process-references"/>
					</xsl:if>
					
					<xsl:if test="contains($components, 'references-excluded')">
						<xsl:call-template name="process-references-excluded"/>
					</xsl:if>
					
					<xsl:if test="contains($components, 'contributors')">
						<xsl:call-template name="process-contributors"/>
					</xsl:if>
					
					<xsl:if test="contains($components, 'figures')">
						<xsl:call-template name="process-figures"/>
					</xsl:if>
					
					<!--<xsl:if test="contains($components, 'guide')">
						<xsl:call-template name="process-guide"/>
						</xsl:if>-->
					
					<xsl:if test="contains($components, 'disclaimer')">
						<xsl:call-template name="process-disclaimer"/>
					</xsl:if>
						
					<xsl:if test="not(contains($components, 'tables'))">
						<xsl:element name="fo:block" use-attribute-sets="">
							<xsl:attribute name="id">last-page</xsl:attribute>
						</xsl:element>
					</xsl:if>
					
				</xsl:element>

			</xsl:element>
			
			<xsl:if test="contains($components, 'tables')"><!-- and tables exist -->
				
				<xsl:element name="fo:page-sequence" use-attribute-sets="">
					<!--<xsl:attribute name="master-name">my-sequence</xsl:attribute>-->
					<xsl:attribute name="master-reference">my-sequence-landscape</xsl:attribute>
					
					<xsl:call-template name="process-static-header"/>
					<xsl:call-template name="process-static-footer"/>
					
					<xsl:element name="fo:flow" use-attribute-sets="flow">
						<xsl:attribute name="flow-name">xsl-region-body</xsl:attribute>
						
						<xsl:call-template name="process-tables"/>
						<xsl:call-template name="process-comparisons-grade-table" />
						
						<xsl:element name="fo:block" use-attribute-sets="">
							<xsl:attribute name="id">last-page</xsl:attribute>
						</xsl:element>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:if>

		</xsl:element>

	</xsl:template>
	
	<xsl:template name="process-abstract">
		
		<xsl:choose>
			
			<xsl:when test="/systematic-review/abstract/element()[string-length(.)!=0]">
				
				<xsl:element name="fo:block" use-attribute-sets="strong color-blue keep-with-next">ABSTRACT</xsl:element>
				<xsl:element name="fo:block" use-attribute-sets="space-after align-justify small">
						
					<xsl:for-each select="/systematic-review/abstract/*">
						<xsl:variable name="name" select="name()" />
						
						<xsl:element name="fo:inline" use-attribute-sets="small">
							
							<xsl:choose>
								<xsl:when test="$name eq 'intro'">INTRODUCTION</xsl:when>
								<xsl:when test="$name eq 'methods'">METHODS AND OUTCOMES</xsl:when>
								<xsl:when test="$name eq 'results'">RESULTS</xsl:when>
								<xsl:when test="$name eq 'conclusions'">CONCLUSIONS</xsl:when>
							</xsl:choose>							
							
							<xsl:text>: </xsl:text>
							<xsl:apply-templates/>
							<xsl:text> </xsl:text>
						</xsl:element>
						
					</xsl:for-each>
						
				</xsl:element>
				
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:if test="contains($proof, 'draft')">
					<xsl:element name="fo:block" use-attribute-sets="preview space-after">
						<xsl:element name="fo:block" use-attribute-sets="default-margin">
							<xsl:text>abstract: [ not available ]</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>

	<xsl:template name="process-clinical-context">

		<xsl:comment>clinical-context</xsl:comment>

		<xsl:element name="fo:block" use-attribute-sets="">
		
		<xsl:if test="/systematic-review/clinical-context/element()[string-length(.)!=0]">
			<xsl:call-template name="process-key-heading">				
				<xsl:with-param name="label">Clinical context</xsl:with-param>				
			</xsl:call-template>
		</xsl:if>
			<xsl:for-each select="/systematic-review/clinical-context/*">
				<xsl:variable name="name" select="name()" />
				<xsl:element name="fo:block" use-attribute-sets="space-after">
					<xsl:element name="fo:block" use-attribute-sets="strong color-blue preserve-linefeed">						
						<xsl:choose>
							<xsl:when test="$name eq 'general-background'">
								GENERAL BACKGROUND
							</xsl:when>
							<xsl:when test="$name eq 'focus-of-the-review'">
								FOCUS OF THE REVIEW
							</xsl:when>
							<xsl:when test="$name eq 'comments-on-evidence'">
								COMMENTS ON EVIDENCE
							</xsl:when>
							<xsl:when test="$name eq 'search-and-appraisal-summary'">
								SEARCH AND APPRAISAL SUMMARY
							</xsl:when>
							<xsl:when test="$name eq 'additional-information'">
								ADDITIONAL INFORMATION
							</xsl:when>
						</xsl:choose>		
					</xsl:element>
					<xsl:element name="fo:block" use-attribute-sets="">			
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>	
		
	</xsl:template>
	
	<xsl:template name="process-key-points-list">

		<xsl:comment>key-points-list</xsl:comment>

		<xsl:element name="fo:block" use-attribute-sets="space-after">

			<!-- key-heading -->
			<xsl:call-template name="process-key-heading">
				<xsl:with-param name="label">Key points</xsl:with-param>
			</xsl:call-template>

			<xsl:for-each select="/systematic-review/key-point-list/*">
				
				<xsl:choose>
					
					<xsl:when test="name()='p'">
						<xsl:call-template name="process-list-first-level"/>
						
					</xsl:when>
					
					<xsl:when test="name()='ul'">
						<xsl:for-each select="li">
							<xsl:call-template name="process-list-second-level"/>
						</xsl:for-each>
					</xsl:when>
					
				</xsl:choose>
				
			</xsl:for-each>

		</xsl:element>
		
	</xsl:template>

	<xsl:template name="process-background">

		<xsl:comment>background</xsl:comment>

		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:for-each select="$background-order/element()">
				
				<xsl:variable name="name" select="name()"/>
				
				<xsl:for-each select="$temp//background/element()[name()=$name][string-length(p[1])!=0]">
					
					<xsl:call-template name="process-blue-ruled-block">
						
						<xsl:with-param name="label" select="$name"/>
						
						<xsl:with-param name="methods-performed-grade-evaluation-description">
							
							<xsl:if test="$evidence-appraisal-grade-table='true' and $name='methods'">
								
								<xsl:text disable-output-escaping="yes"> </xsl:text>We have performed a GRADE evaluation of the quality of evidence for interventions included in this review<xsl:text disable-output-escaping="yes"> (</xsl:text>
								
								<xsl:element name="fo:basic-link" use-attribute-sets="link">
									<xsl:attribute name="internal-destination" select="concat($cid, '_T', 'G')"/>see table<xsl:if test="contains($media, 'print')">
										
										<xsl:text>, p </xsl:text>
										
										<xsl:element name="fo:page-number-citation" use-attribute-sets="">
											<xsl:attribute name="ref-id" select="concat($cid, '_T', 'G')"/>
										</xsl:element>
										
									</xsl:if>
									
								</xsl:element>
								
								<xsl:text disable-output-escaping="yes">). </xsl:text>The categorisation of the quality of the evidence (high, moderate, low, or very low) reflects the quality of evidence available for our chosen outcomes in our defined populations of interest. These categorisations are not necessarily a reflection of the overall methodological quality of any individual study, because the Clinical Evidence population and outcome of choice may represent only a small subset of the total outcomes reported, and population included, in any individual trial. For further details of how we perform the GRADE evaluation and the scoring system we use, please see our website (www.clinicalevidence.com).</xsl:if>
							
						</xsl:with-param>
						
					</xsl:call-template>
					
				</xsl:for-each>
				
			</xsl:for-each>
			
		</xsl:element>

	</xsl:template>

	<xsl:template name="process-questions">
		
		<xsl:comment>questions</xsl:comment>

		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:apply-templates select="/systematic-review/question-list/question" />
			
		</xsl:element>

	</xsl:template>
	
	<xsl:template match="question">
		<xsl:variable name="qid" select="concat($cid, '_Q', position())"/>
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:call-template name="process-question-title">
				
				<xsl:with-param name="label">QUESTION</xsl:with-param>
				
				<xsl:with-param name="id" select="$qid"/>
				
				<xsl:with-param name="text">
					<xsl:value-of select="title"/>
				</xsl:with-param>
				
			</xsl:call-template>
			
			<xsl:if test="contains($proof, 'draft')">
				
				<xsl:element name="fo:block" use-attribute-sets="preview space-after">
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						<xsl:text>abridged-title: </xsl:text>
						<xsl:apply-templates select="abridged-title"/>
					</xsl:element>
				</xsl:element>
				
			</xsl:if>
			
			<xsl:apply-templates select="xi:include[contains(@href, 'option')]" />
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="xi:include[contains(@href, 'option')]">

		<!-- chpping '../options/_op1003_I1.xml' or 
			'../options/option-1179218159900_en-gb.xml' to get option id -->
		<xsl:variable 
			name="iid" 
			select="
			concat($cid, '_I', 
			replace(
			@href 
			, '^.*?[I\-](\d+).*?$'
			, '$1'))
			"/>
		
		<xsl:apply-templates select="document(@href)/*">
			<xsl:with-param name="iid" select="$iid" />
		</xsl:apply-templates>
		
	</xsl:template>
	
	<xsl:template match="option">
		<xsl:param name="iid" />
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:attribute name="id" select="$iid"/>				
			
			<xsl:call-template name="process-option-title">
				
				<xsl:with-param name="label">OPTION</xsl:with-param>
				
				<xsl:with-param name="id" select="$iid"/>
				
				<xsl:with-param name="text">
					<xsl:value-of select="translate(title, $lower, $upper)"/>
					
					<xsl:element name="fo:leader" use-attribute-sets="default-leader color-tinted-blue"/>
					
					<xsl:if test="substantive-change-set/substantive-change[@status='new-option']">
						
						<xsl:element name="fo:inline" use-attribute-sets="strong color-white keep-with-next ">New<xsl:text disable-output-escaping="yes"> </xsl:text>
						</xsl:element>
						
					</xsl:if>
					
					<!--<xsl:if test="count(intervention-set/intervention)=1">
						
						<xsl:element name="fo:inline" use-attribute-sets="">
						
							<xsl:element name="fo:external-graphic" use-attribute-sets="">
								<xsl:attribute name="scaling">uniform</xsl:attribute>
								<xsl:attribute name="overflow">visible</xsl:attribute>
								<xsl:attribute name="content-height" select="concat($body.font.master,'pt')"/>
								<xsl:attribute name="width" select="'30px'"/>
								<xsl:attribute name="height" select="'15px'"/>
								<xsl:attribute name="src">
									<xsl:text>url('</xsl:text>
									<xsl:value-of select="$images-input"/>
									<xsl:value-of select="intervention-set/intervention/@efficacy"/>
									<xsl:if test="contains($system, 'docato')">
										<xsl:text>_default</xsl:text>
									</xsl:if>
									<xsl:text>.gif</xsl:text>
									<xsl:text>')</xsl:text>
								</xsl:attribute>
							</xsl:element>
							
						</xsl:element>
						
					</xsl:if>-->
					
				</xsl:with-param>
				
			</xsl:call-template>
			
			<xsl:if test="option-contributor[string-length(.)!=0]">
				
				<xsl:element name="fo:block" use-attribute-sets="default-margin">
					<xsl:text>Contributed by </xsl:text>
					<xsl:apply-templates select="option-contributor"/>
				</xsl:element>
				
			</xsl:if>
			
			<xsl:if test="contains($proof, 'draft')">
				
				<xsl:element name="fo:block" use-attribute-sets="preview space-after">
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						
						<xsl:text>abridged-title: </xsl:text>
						
						<xsl:apply-templates select="abridged-title/node()"/>
						
						<xsl:text> [ id: </xsl:text>
						<xsl:value-of select="$iid"/>
						<xsl:text> ] </xsl:text>
						
					</xsl:element>
					
					<xsl:for-each select="intervention-set/intervention">
						
						<xsl:element name="fo:block" use-attribute-sets="">
							
							<xsl:element name="fo:block" use-attribute-sets="default-margin">
								
								<xsl:text>intervention-title: </xsl:text>
								
								<xsl:apply-templates select="title/node()"/>
								
								<xsl:text> [ efficacy: </xsl:text>
								<xsl:value-of select="@efficacy"/>
								<xsl:text> ]</xsl:text>
								
							</xsl:element>
							
							<!-- removed by IB : duplicate summary statement  -->
							<!-- 
							<xsl:if test="count(intervention-set/intervention) != 1 or summary-statement[string-length(.)=0]">
								
								<xsl:element name="fo:block" use-attribute-sets="default-margin">
									
									<xsl:text>summary-statement: </xsl:text>
									<xsl:apply-templates select="summary-statement/node()"/>
									
								</xsl:element>
								
							</xsl:if>
							-->
							
						</xsl:element>
						
					</xsl:for-each>
					
					<xsl:if test="drug-safety-alert/p[1][string-length(.)!=0]">
						
						<xsl:element name="fo:block" use-attribute-sets="default-margin">
							
							<xsl:text>drug-safety-alert: </xsl:text>
							<xsl:apply-templates select="drug-safety-alert/p[1]/node()"/>
							
						</xsl:element>
						
					</xsl:if>
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						
						<xsl:text>substantive-change: </xsl:text>
						
						<xsl:choose>
							
							<xsl:when test="substantive-change-set/substantive-change[1][string-length(.)!=0]">
								<xsl:apply-templates select="substantive-change-set/substantive-change/node()"/>
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:text>No description.</xsl:text>
							</xsl:otherwise>
							
						</xsl:choose>
						
						<xsl:text> [ status: </xsl:text>
						
						<xsl:choose>
							
							<xsl:when test="substantive-change-set/substantive-change/@status">
								<xsl:value-of select="substantive-change-set/substantive-change/@status"/>
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:text>no-new-evidence</xsl:text>
							</xsl:otherwise>
							
						</xsl:choose>
						
						<xsl:text> ]</xsl:text>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:if>
			
			<!-- summary-statement -->
			<xsl:element name="fo:block" use-attribute-sets="align-justify space-after">
				
				<xsl:choose>
					
					<xsl:when test="summary-statement[string-length(.)!=0]">
						<xsl:apply-templates select="summary-statement"/>
					</xsl:when>
					
					<xsl:when test="count(intervention-set/intervention) = 1">
						
						<xsl:choose>
							
							<xsl:when test="comparison-set">
								
								<xsl:element name="fo:list-block">
									
									<xsl:if test="$evidence-appraisal-grade-table = 'true'">
										
										<xsl:element name="fo:list-item" use-attribute-sets="">
											
											<xsl:element name="fo:list-item-label" use-attribute-sets="">
												<xsl:attribute name="end-indent">15pt</xsl:attribute>
												
												<xsl:element name="fo:block" use-attribute-sets="p">
													<xsl:text>&#x2022;</xsl:text>
												</xsl:element>
												
											</xsl:element>
											
											<xsl:element name="fo:list-item-body" use-attribute-sets="">
												<xsl:attribute name="start-indent">15pt</xsl:attribute>
												
												<xsl:element name="fo:block" use-attribute-sets="p">
													
													<xsl:text>For </xsl:text>GRADE<xsl:text disable-output-escaping="yes"> </xsl:text>evaluation of interventions<xsl:text> for </xsl:text>
													
													<xsl:apply-templates select="$systematic-review-title" />
													
													<xsl:text>, </xsl:text>
													
													<xsl:element name="fo:basic-link" use-attribute-sets="link">
														<xsl:attribute name="internal-destination" select="concat($cid, '_T', 'G')"/>see table<xsl:if test="contains($media, 'print')">
															
															<xsl:text>, p </xsl:text>
															
															<xsl:element name="fo:page-number-citation" use-attribute-sets="">
																<xsl:attribute name="ref-id" select="concat($cid, '_T', 'G')"/>
															</xsl:element>
															
														</xsl:if>
														
													</xsl:element>
														
													<xsl:text>. </xsl:text>
														
												</xsl:element>
												
											</xsl:element>
											
										</xsl:element>
										
									</xsl:if>
									
									<xsl:apply-templates select="intervention-set/intervention/summary-statement" mode="comparisions-serial"/>
									
								</xsl:element>
								
							</xsl:when>
							
							<xsl:otherwise>
								
								<xsl:apply-templates select="intervention-set/intervention/summary-statement"/>
								
							</xsl:otherwise>
							
						</xsl:choose>
						
					</xsl:when>
					
				</xsl:choose>
				
			</xsl:element>
			
			<xsl:choose>
				
				<xsl:when test="comparison-set and $comparisons-tabulated='false'">
					
					<xsl:apply-templates select="comparison-set" mode="comparisons-serial">
						<xsl:with-param name="iid" select="$iid" />
					</xsl:apply-templates>
					
					<xsl:if test="contains($proof, 'sign-off')">
						<xsl:apply-templates select="benefits">
							<xsl:with-param name="iid" select="$iid" />
						</xsl:apply-templates>
						
						<xsl:apply-templates select="harms">
							<xsl:with-param name="iid" select="$iid" />
						</xsl:apply-templates>						
					</xsl:if>
					
					<xsl:apply-templates select="comment">
						<xsl:with-param name="iid" select="$iid" />
					</xsl:apply-templates>
					
				</xsl:when>
				
				<xsl:when test="comparison-set">
					
					<xsl:apply-templates select="comparison-set" mode="comparisons-tabulated">
						<xsl:with-param name="iid" select="$iid" />
					</xsl:apply-templates>
					
					<xsl:if test="contains($proof, 'sign-off')">
						<xsl:apply-templates select="benefits">
							<xsl:with-param name="iid" select="$iid" />
						</xsl:apply-templates>
						
						<xsl:apply-templates select="harms">
							<xsl:with-param name="iid" select="$iid" />
						</xsl:apply-templates>
					</xsl:if>
					
					<xsl:apply-templates select="comment">
						<xsl:with-param name="iid" select="$iid" />
					</xsl:apply-templates>
					
				</xsl:when>
				
				<xsl:otherwise>
					
					<xsl:apply-templates select="benefits">
						<xsl:with-param name="iid" select="$iid" />
					</xsl:apply-templates>
					
					<xsl:apply-templates select="harms">
						<xsl:with-param name="iid" select="$iid" />
					</xsl:apply-templates>
					
					<xsl:apply-templates select="comment">
						<xsl:with-param name="iid" select="$iid" />
					</xsl:apply-templates>
					
				</xsl:otherwise>
				
			</xsl:choose>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="summary-statement" mode="comparisions-serial">
		
		<xsl:element name="fo:list-item" use-attribute-sets="">
			
			<xsl:element name="fo:list-item-label" use-attribute-sets="">
				<xsl:attribute name="end-indent">15pt</xsl:attribute>
				<xsl:element name="fo:block" use-attribute-sets="p">
					<xsl:text>&#x2022;</xsl:text>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:list-item-body" use-attribute-sets="">
				<xsl:attribute name="start-indent">15pt</xsl:attribute> 
				<xsl:element name="fo:block" use-attribute-sets="p">
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	 
	<xsl:template match="summary-statement/strong">
		<xsl:element name="fo:block" use-attribute-sets="strong space-before">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="summary-statement/em">
		<xsl:if test="preceding-sibling::element()[1][name()!='strong']">
			<xsl:element name="fo:block" use-attribute-sets="space-before"/>
		</xsl:if>
		<xsl:element name="fo:inline" use-attribute-sets="em">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="summary-statement[not(strong) or not(em)]">
		<xsl:element name="fo:block" use-attribute-sets="strong">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="benefits | harms | comment">
		<xsl:param name="iid" />
		<xsl:variable name="name" select="name()"/>
		
		<xsl:variable name="id" select="concat($iid, '_', translate($name, $lower, $upper))"/>
		
		<xsl:element name="fo:list-block" use-attribute-sets="">
			
			<xsl:element name="fo:list-item" use-attribute-sets="">
				
				<xsl:element name="fo:list-item-label" use-attribute-sets="">
					<xsl:attribute name="end-indent">70pt</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets="strong color-blue">				
						<xsl:value-of select="translate(substring($name, 1, 1), $lower, $upper)"/>
						<xsl:value-of select="substring($name, 2)"/>
						<xsl:text>:</xsl:text>
					</xsl:element>
				</xsl:element>
				
				<xsl:element name="fo:list-item-body" use-attribute-sets="">
					<xsl:attribute name="start-indent">70pt</xsl:attribute>
					
					<xsl:element name="fo:block" use-attribute-sets="space-after">
						<xsl:attribute name="id" select="$id"/>
						
						<xsl:choose>
							
							<xsl:when test="contains($media, 'print') or contains($media, 'web')">
								
								<xsl:for-each select="p">
									
									<xsl:choose>
										
										<xsl:when test="strong">
											<!-- fix: inline strong can also be split over mulitple lines -->
											<xsl:element name="fo:block" use-attribute-sets="keep-with-next">
												<xsl:apply-templates/>
											</xsl:element>
										</xsl:when>
										
										<xsl:otherwise>
											
											<xsl:choose>
												
												<xsl:when test="position()!=last() and not(following-sibling::drug-safety-alert/p[2])">
													<xsl:element name="fo:block" use-attribute-sets="space-after">
														<xsl:apply-templates/>
													</xsl:element>
												</xsl:when>
												
												<xsl:otherwise>
													<xsl:element name="fo:block" use-attribute-sets="">
														<xsl:apply-templates/>
													</xsl:element>
												</xsl:otherwise>
												
											</xsl:choose>
											
										</xsl:otherwise>
										
									</xsl:choose>
									
								</xsl:for-each>
								
								<xsl:if test="$name='harms' and following-sibling::drug-safety-alert/p[2][string-length(.)!=0]">
									
									<xsl:element name="fo:block" use-attribute-sets="strong keep-with-next">
										<xsl:text>Drug safety alert:</xsl:text>
									</xsl:element>
									
									<xsl:element name="fo:block" use-attribute-sets="">
										<xsl:element name="fo:inline" use-attribute-sets="">
											<xsl:apply-templates select="following-sibling::drug-safety-alert/p[2]"/>
										</xsl:element>
									</xsl:element>
									
								</xsl:if>
								
							</xsl:when>
							
							<xsl:otherwise>
								
								<xsl:for-each select="p">
									<xsl:apply-templates/>
									<xsl:text disable-output-escaping="yes"> </xsl:text>
								</xsl:for-each>
								
								<xsl:if test="$name='harms' and following-sibling::drug-safety-alert/p[2][string-length(.)!=0]">
									<xsl:element name="fo:inline" use-attribute-sets="strong">
										<xsl:text>Drug safety alert:</xsl:text>
										<xsl:text disable-output-escaping="yes"> </xsl:text>
									</xsl:element>
									<xsl:element name="fo:inline" use-attribute-sets="">
										<xsl:apply-templates select="following-sibling::drug-safety-alert/p[2]"/>
									</xsl:element>
								</xsl:if>
								
							</xsl:otherwise>
							
						</xsl:choose>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	
	<xsl:template name="process-glossary">
		
		<xsl:if test="$links//gloss-link">
			
			<xsl:comment>glossary</xsl:comment>
			
			<xsl:element name="fo:block" use-attribute-sets="space-after">
				<xsl:attribute name="id">glossary</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="large strong color-tinted-blue keep-with-next">GLOSSARY</xsl:element>
				
				<xsl:variable name="glossary">
					<xsl:for-each select="$links//gloss-link">
						<xsl:sort select="."/>
						<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@target, '../'))"/>
						<xsl:variable name="gloss" select="document($filename)/*"/>
						<xsl:element name="fo:block" use-attribute-sets="para">
							<xsl:attribute name="id" select="concat($cid, '_G', position())"/>
							<xsl:apply-templates select="$gloss"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:variable>
				
				<xsl:for-each select="$glossary/element()">
					<xsl:sort select="."/>
					<xsl:copy-of select="."/>
				</xsl:for-each>
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>

	<xsl:template name="process-substantive-changes">
		
		<xsl:if 
			test="
			document(//xi:include[contains(@href, 'option')]/@href)
			//substantive-change-set/substantive-change
				[@status='new-evidence-conclusions-confirmed' 
				or @status='new-evidence-conclusions-changed'
				or @status='no-new-evidence-substantial-error-corrected'
				or @status='no-new-evidence-existing-evidence-reevaluated'
				or @status='condition-restructured'
				or @status='new-option']">
			
			<xsl:element name="fo:block" use-attribute-sets="space-after">
				<xsl:attribute name="id">substantive-changes</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="large strong color-tinted-blue keep-with-next">SUBSTANTIVE CHANGES</xsl:element>
				
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='new-option']">
					<xsl:sort select="option/title"/>
					
					<xsl:element name="fo:block" use-attribute-sets="para">
						
						<xsl:choose>
							
							<xsl:when test=".[string-length()!=0]">
								<xsl:apply-templates select="node()"/>
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:element name="fo:inline" use-attribute-sets="strong">
									<xsl:text>New option added </xsl:text>
								</xsl:element>
								<xsl:apply-templates select="ancestor::option/title"/>
								<xsl:text>.</xsl:text>
							</xsl:otherwise>
							
						</xsl:choose>
						
					</xsl:element>
					
				</xsl:for-each>
				
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='new-evidence-conclusions-confirmed']">
					<xsl:sort select="."/>
					<xsl:element name="fo:block" use-attribute-sets="para">
						<xsl:apply-templates select="node()"/>
					</xsl:element>
				</xsl:for-each>
				
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='new-evidence-conclusions-changed']">
					<xsl:sort select="."/>
					<xsl:element name="fo:block" use-attribute-sets="para">
						<xsl:apply-templates select="node()"/>
					</xsl:element>
				</xsl:for-each>
				
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='no-new-evidence-substantial-error-corrected']">
					<xsl:sort select="."/>
					<xsl:element name="fo:block" use-attribute-sets="para">
						<xsl:apply-templates select="node()"/>
					</xsl:element>
				</xsl:for-each>
				
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='no-new-evidence-existing-evidence-reevaluated']">
					<xsl:sort select="."/>
					<xsl:element name="fo:block" use-attribute-sets="para">
						<xsl:apply-templates select="node()"/>
					</xsl:element>
				</xsl:for-each>
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='condition-restructured']">
					<xsl:sort select="."/>
					<xsl:element name="fo:block" use-attribute-sets="para">
						<xsl:apply-templates select="node()"/>
					</xsl:element>
				</xsl:for-each>
				
			</xsl:element>
			
		</xsl:if>
		
		<xsl:if test="contains($proof, 'draft')">
			
			<xsl:element name="fo:block" use-attribute-sets="preview space-after">
				<xsl:element name="fo:block" use-attribute-sets="default-margin">
					<xsl:text>rss description: </xsl:text>
					<xsl:call-template name="process-rss-description"/>
				</xsl:element>
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="process-references">
		
		<xsl:element name="fo:block" use-attribute-sets="strong color-blue large keep-with-next">REFERENCES</xsl:element>
		
		<xsl:element name="rx:flow-section" use-attribute-sets="two-column-gap">			
			
			<xsl:element name="fo:block" use-attribute-sets="">
				
				<xsl:for-each select="$links//reference-link">
					<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@target, '../'))"/>
					<xsl:variable name="reference" select="document($filename)/*"/>
					
					<xsl:element name="fo:list-block" use-attribute-sets="space-after-tiny">
						
						<fo:list-item>
							
							<fo:list-item-label end-indent="15pt">
								<xsl:element name="fo:block" use-attribute-sets="tiny">
									<xsl:attribute name="id" select="concat($cid, '_REF', position())"/>
									<xsl:value-of select="position()"/>
									<xsl:text>.</xsl:text>
								</xsl:element>
							</fo:list-item-label>
							
							<fo:list-item-body start-indent="15pt">
								
								<xsl:element name="fo:block" use-attribute-sets="tiny">
									
									<xsl:apply-templates select="$reference//clinical-citation"/>
									
									<xsl:if test="$reference//unique-id[@source='medline' and string-length(normalize-space(.))!=0]">
										
										<xsl:element name="fo:basic-link" use-attribute-sets="link">
											<xsl:attribute name="external-destination">
												<xsl:text>url('</xsl:text>
												<xsl:value-of select="$pubmed-url"/>
												<xsl:value-of select="$reference//unique-id"/>
												<xsl:text>')</xsl:text>
											</xsl:attribute>
											
											<xsl:text>[PubMed]</xsl:text>
											
										</xsl:element>
										
									</xsl:if>
									
								</xsl:element>
								
							</fo:list-item-body>
							
						</fo:list-item>
						
					</xsl:element>
					
				</xsl:for-each>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-references-excluded">
		<xsl:variable 
			name="references-excluded-list-filename"
			select="concat($systematic-review-xml-input, 'references/refs-', substring-after($pub-resource-name, 'sr-'), '.xml')"/>
		<xsl:variable 
			name="references-excluded-list" 
			select="document($references-excluded-list-filename)/*"/>
		
		<xsl:variable name="references-excluded-matched">
			
			<xsl:for-each select="$references-excluded-list//reference-link[@approved='false']">
				<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@target, '../'))"/>
				<xsl:variable name="reference" select="document($filename)/*"/>
				
				<xsl:if test="$reference//clinical-citation[string-length(.)!=0]">
					<xsl:copy-of select="$reference"/>
				</xsl:if>
				
			</xsl:for-each>
			
		</xsl:variable>
		
		<xsl:if test="count($references-excluded-matched/*) &gt; 0">
		
			<xsl:element name="fo:block" use-attribute-sets="strong color-blue large keep-with-next space-before">REFERENCES EXCLUDED</xsl:element>
		
			<!--<xsl:element name="fo:block" use-attribute-sets="para keep-with-next">
				<xsl:text>excluded references description</xsl:text>
			</xsl:element>-->
		
			<xsl:element name="rx:flow-section" use-attribute-sets="two-column-gap">			
				
				<xsl:element name="fo:block" use-attribute-sets="">
					
					<xsl:for-each select="$references-excluded-matched/*">
						
						<xsl:element name="fo:list-block" use-attribute-sets="space-after-tiny">
							
							<fo:list-item>
								
								<fo:list-item-label end-indent="15pt">
									<xsl:element name="fo:block" use-attribute-sets="tiny">
										<xsl:attribute name="id" select="concat($cid, '_REF_EXC', position())"/>
										<xsl:text>e</xsl:text>
										<xsl:value-of select="position()"/>
										<xsl:text>.</xsl:text>
									</xsl:element>
								</fo:list-item-label>
								
								<fo:list-item-body start-indent="15pt">
									
									<xsl:element name="fo:block" use-attribute-sets="tiny">
										
										<xsl:apply-templates select=".//clinical-citation"/>
										
										<xsl:if test=".//unique-id[@source='medline' and string-length(normalize-space(.))!=0]">
											
											<xsl:element name="fo:basic-link" use-attribute-sets="link">
												<xsl:attribute name="external-destination">
													<xsl:text>url('</xsl:text>
													<xsl:value-of select="$pubmed-url"/>
													<xsl:value-of select=".//unique-id"/>
													<xsl:text>')</xsl:text>
												</xsl:attribute>
												
												<xsl:text>[PubMed]</xsl:text>
												
											</xsl:element>
											
										</xsl:if>
										
									</xsl:element>
									
								</fo:list-item-body>
								
							</fo:list-item>
							
						</xsl:element>
						
					</xsl:for-each>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>

	<xsl:template name="process-contributors">
		<xsl:comment>contributors</xsl:comment>
		
		<xsl:element name="fo:block" use-attribute-sets="align-right space-before">
			<xsl:attribute name="id" select="concat($cid, '_CONTRIB')"/>
			
			<xsl:for-each select="$bmjk-review-plan//contributor-set/person-link">
				
				<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@target, '../'))"/>
				<xsl:variable name="person" select="document($filename)/*"/>
				
				<xsl:element name="fo:block" use-attribute-sets="keep-together space-after">
					
					<!--<xsl:choose>
						<xsl:when test="count($bmjk-review-plan//contributor-set/person-link) = 1">
						<xsl:attribute name="break-before">column</xsl:attribute>
						</xsl:when>
						<xsl:when test="
						count($bmjk-review-plan//contributor-set/person-link) = 2 and position() = 2">
						<xsl:attribute name="break-before">column</xsl:attribute>
						</xsl:when>
						<xsl:when test="
						count($bmjk-review-plan//contributor-set/person-link) &gt; 2 and
						(position() = 1 or position() = 2 or position() = 4 or position() = 6)">
						<xsl:attribute name="break-before">column</xsl:attribute>
						</xsl:when>
						</xsl:choose>-->
					
					<xsl:element name="fo:block" use-attribute-sets="strong">
						<xsl:attribute name="id" select="concat($cid, '_CONTRIB', position())"/>
						
						<xsl:apply-templates select="$person//first-name"/>
						
						<xsl:text disable-output-escaping="yes"> </xsl:text>
						
						<xsl:if test="$person//middle-name[string-length(.)!=0]">
							<xsl:apply-templates select="$person//middle-name"/>
							<xsl:text disable-output-escaping="yes"> </xsl:text>
						</xsl:if>
						
						<xsl:apply-templates select="$person//last-name"/>
						
					</xsl:element>
					
					<xsl:if test="$person//title[string-length(.)!=0]">
						
						<xsl:element name="fo:block" use-attribute-sets="">
							<xsl:apply-templates select="$person//title"/>
						</xsl:element>
						
					</xsl:if>
					
					<xsl:if test="$person//affiliation[string-length(.)!=0]">
						
						<xsl:choose>
							
							<xsl:when test="contains($person//affiliation, ',')">
								
								<xsl:element name="fo:block" use-attribute-sets="">
									<xsl:value-of select="substring-before($person//affiliation, ',')"/>
								</xsl:element>
								
								<xsl:for-each select="substring-after($person//affiliation, ',')">
									
									<xsl:element name="fo:block" use-attribute-sets="">
										<xsl:value-of select="."/>
									</xsl:element>
									
								</xsl:for-each>
								
							</xsl:when>
							
							<xsl:otherwise>
								
								<xsl:element name="fo:block" use-attribute-sets="">
									<xsl:apply-templates select="$person//affiliation"/>
								</xsl:element>
								
							</xsl:otherwise>
							
						</xsl:choose>
						
					</xsl:if>
					
					<xsl:if test="$person//city[string-length(.)!=0]">
						
						<xsl:element name="fo:block" use-attribute-sets="">
							<xsl:apply-templates select="$person//city"/>
						</xsl:element>
						
					</xsl:if>
					
					<xsl:if test="$person//country[string-length(.)!=0]">
						
						<xsl:element name="fo:block" use-attribute-sets="">
							<xsl:apply-templates select="$person//country"/>
						</xsl:element>
						
					</xsl:if>
					
				</xsl:element>
				
			</xsl:for-each>
			
		</xsl:element>

		<xsl:element name="fo:block"/>

		<xsl:element name="fo:block" use-attribute-sets="tiny align-right keep-together">
			
			<xsl:for-each select="/systematic-review/info/competing-interests/p">
				
				<xsl:choose>
					
					<xsl:when test="position()=1">
						
						<xsl:element name="fo:block" use-attribute-sets="">Competing interests<xsl:text>: </xsl:text>
							
							<xsl:apply-templates select="."/>
							
						</xsl:element>
						
					</xsl:when>
					
					<xsl:otherwise>
						
						<xsl:element name="fo:block" use-attribute-sets="">
							<xsl:apply-templates select="."/>
						</xsl:element>
						
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:for-each>
			
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="space-after"/>

	</xsl:template>
	
	<xsl:template name="process-figures">
		
		<xsl:for-each select="$links//figure-link">
			
			<xsl:comment>figure</xsl:comment>
			
			<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@target, '../'))"/>
			<xsl:variable name="figure" select="document($filename)/*"/>
			
			<xsl:element name="fo:block" use-attribute-sets="keep-together">
				<xsl:attribute name="id" select="concat($cid, '_F', position())"/>
				
				<xsl:element name="fo:block" use-attribute-sets="space-after align-center">
					
					<xsl:element name="fo:external-graphic">
						<xsl:attribute name="content-width">140mm</xsl:attribute>
						<xsl:attribute name="scaling">uniform</xsl:attribute>
						
						<xsl:attribute name="src">
							<xsl:text>url('</xsl:text>
							<xsl:value-of select="$images-input"/>
							<!--<image-link target="../images/0201_figure_1_default.jpg"/>-->
							<xsl:value-of 
								select="
								replace(
								$figure//image-link/@target
								, '^\.\./images/(.+?)(_default)?\.(.+?)$'
								, '$1$2.$3')
								"/>
							<xsl:text>')</xsl:text>
						</xsl:attribute>
						
					</xsl:element>
					
				</xsl:element>
				
				<xsl:call-template name="process-caption">
					
					<xsl:with-param name="label">Figure</xsl:with-param>
					
					<xsl:with-param name="id" select="position()"/>
					
					<xsl:with-param name="text">
						<xsl:apply-templates select="$figure//caption"/>
					</xsl:with-param>
					
				</xsl:call-template>
				
			</xsl:element>
			
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-tables">
		
		<xsl:for-each select="$links//table-link">
			
			<xsl:comment>table</xsl:comment>
			
			<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@target, '../'))"/>
			<xsl:variable name="table" select="document($filename)/*"/>
			
			<!-- add: force landscape page orient / flip pdf view -->
			<xsl:element name="fo:block" use-attribute-sets="keep-together">
				<xsl:attribute name="id" select="concat($cid, '_T', position())"/>
				
				<xsl:variable name="table-id">
					
					<xsl:choose>
						
						<xsl:when test="@grade='true'">
							<!-- add no label id -->
						</xsl:when>
						
						<xsl:otherwise>
							<xsl:value-of select="position()"/>
						</xsl:otherwise>
						
					</xsl:choose>
					
				</xsl:variable>
				
				<xsl:call-template name="process-caption">
					
					<xsl:with-param name="label">Table</xsl:with-param>
					
					<xsl:with-param name="id" select="$table-id"/>
					
					<xsl:with-param name="text">
						<xsl:apply-templates select="$table//caption"/>
					</xsl:with-param>
					
				</xsl:call-template>
				
				<xsl:element name="fo:table" use-attribute-sets="table small background-tinted-blue space-after">
					<xsl:apply-templates select="$table//thead"/>
					<xsl:apply-templates select="$table//tbody"/>
					<xsl:apply-templates select="$table//tfoot"/>
				</xsl:element>
				
			</xsl:element>
			
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template match="thead">
		<xsl:element name="fo:table-header" use-attribute-sets="strong thead space-after-small">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="display-align">after</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tbody">
		<xsl:element name="fo:table-body" use-attribute-sets="tbody">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tfoot">
		<xsl:element name="fo:table-footer" use-attribute-sets="tfoot space-before-small">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="tr">
		
		<xsl:element name="fo:table-row">
			
			<xsl:for-each select="th|td">
				
				<xsl:element name="fo:table-cell">
					
					<xsl:if test="contains($proof, 'draft')">
						<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
						<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
						<xsl:attribute name="border">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:attribute name="number-columns-spanned">
						
						<xsl:choose>
							
							<xsl:when test="@colspan">
								<xsl:value-of select="@colspan"/>
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:text>1</xsl:text>
							</xsl:otherwise>
							
						</xsl:choose>
						
					</xsl:attribute>
					
					<xsl:if test="@rowspan">
						<xsl:attribute name="number-rows-spanned" select="@rowspan"/>	
					</xsl:if>
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						
						<xsl:if test="@align[string-length(.)!=0]">
							<xsl:attribute name="text-align" select="translate(@align, $upper, $lower)"/>
						</xsl:if>
						
						<xsl:apply-templates/>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	
	<xsl:template name="process-disclaimer">
		
		<xsl:element name="fo:block" use-attribute-sets="keep-together space-before">
			
			<xsl:call-template name="process-key-heading">
				
				<xsl:with-param name="label">Disclaimer</xsl:with-param>
				
			</xsl:call-template>
		
			<xsl:element name="fo:block" use-attribute-sets="small align-justify preserve-linefeed">The information contained in this publication is intended for medical professionals. Categories presented in Clinical Evidence indicate a judgement about the strength of the evidence available to our contributors prior to publication and the relevant importance of benefit and harms. We rely on our contributors to confirm the accuracy of the information presented and to adhere to describe accepted practices. Readers should be aware that professionals in the field may have different opinions. Because of this and regular advances in medical research we strongly recommend that readers' independently verify specified treatments and drugs including manufacturers' guidance. Also, the categories do not indicate whether a particular treatment is generally appropriate or whether it is suitable for a particular individual. Ultimately it is the readers' responsibility to make their own professional judgements, so to appropriately advise and treat their patients. To the fullest extent permitted by law, BMJ Publishing Group Limited and its editors are not responsible for any losses, injury or damage caused to any person or property (including under contract, by negligence, products liability or otherwise) whether they be direct or indirect, special, incidental or consequential, resulting from the application of the information in this publication.</xsl:element>
			
		</xsl:element>
		
	</xsl:template>

	<xsl:template match="gloss-link">
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="text">
			<xsl:apply-templates/>
		</xsl:variable>
		
		<xsl:for-each select="$links//gloss-link">
			
			<xsl:if test="@target=$target">
				
				<xsl:choose>
					
					<xsl:when test="contains($components, 'glossaries')">
						
						<xsl:element name="fo:basic-link" use-attribute-sets="link">
							<xsl:attribute name="internal-destination" select="concat($cid, '_G', position())"/>
							
							<xsl:copy-of select="$text"/>
							
							<!--<xsl:if test="contains($media, 'print')">
								<xsl:text>, p </xsl:text>
								<xsl:element name="fo:page-number-citation" use-attribute-sets="">
								<xsl:attribute name="ref-id" select="concat($cid, '_G', position())"/>
								</xsl:element>
								</xsl:if>-->
							
						</xsl:element>
						
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:copy-of select="$text"/>
					</xsl:otherwise>
					
				</xsl:choose>
				
			</xsl:if>
			
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template match="figure-link">
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="text">
			<xsl:apply-templates/>
		</xsl:variable>
		
		<xsl:for-each select="$links//figure-link">
			
			<xsl:if test="@target=$target">
				
				<xsl:choose>
					
					<xsl:when test="contains($components, 'figures')">
						
						<xsl:element name="fo:basic-link" use-attribute-sets="link">
							<xsl:attribute name="internal-destination" select="concat($cid, '_F', position())"/>
							
							<xsl:copy-of select="$text"/>
							
							<xsl:if test="contains($media, 'print')">
								<xsl:text>, p </xsl:text>
								<xsl:element name="fo:page-number-citation" use-attribute-sets="">
									<xsl:attribute name="ref-id" select="concat($cid, '_F', position())"/>
								</xsl:element>
							</xsl:if>
							
						</xsl:element>
						
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:copy-of select="$text"/>
					</xsl:otherwise>
					
				</xsl:choose>
				
			</xsl:if>
			
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template match="table-link">
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="text">
			<xsl:apply-templates/>
		</xsl:variable>
		
		<xsl:for-each select="$links//table-link">
			
			<xsl:if test="@target=$target">
				
				<xsl:choose>
					
					<xsl:when test="contains($components, 'tables')">
						
						<xsl:element name="fo:basic-link" use-attribute-sets="link">
							<xsl:attribute name="internal-destination" select="concat($cid, '_T', position())"/>
							
							<xsl:copy-of select="$text"/>
							
							<xsl:if test="contains($media, 'print')">
								
								<xsl:text>, p </xsl:text>
								
								<xsl:element name="fo:page-number-citation" use-attribute-sets="">
									<xsl:attribute name="ref-id" select="concat($cid, '_T', position())"/>
								</xsl:element>
								
							</xsl:if>
							
						</xsl:element>
						
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:copy-of select="$text"/>
					</xsl:otherwise>
					
				</xsl:choose>
				
			</xsl:if>
			
		</xsl:for-each>
		
	</xsl:template>
	
	<!-- note: now managed by systematic-review-to-pdf-reference-range.xsl -->
	<!--xsl:template match="reference-link">
		<xsl:if test="$paper.type!='ce-handbook'">
			<xsl:variable name="target" select="@target"/>
			<xsl:element name="fo:basic-link" use-attribute-sets="">
				<xsl:for-each select="$links//reference-link">
					<xsl:if test="@target=$target">
						<xsl:attribute name="internal-destination" select="concat($cid, '_REF', position())"/>
						<xsl:element name="fo:inline" use-attribute-sets="link sup tiny">
							<xsl:text>[</xsl:text>
							<xsl:for-each select="$links//reference-link">
								<xsl:if test="@target=$target">
									<xsl:value-of select="position()"/>
								</xsl:if>
							</xsl:for-each>
							<xsl:text>]</xsl:text>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:element>
		</xsl:if>
		</xsl:template-->
	
	<xsl:template match="option-link">
		<!-- chpping '../options/_op1003_I1.xml' or 
			'../options/option-1179218159900_en-gb.xml' to get option id -->
		<xsl:variable 
			name="iid" 
			select="
			concat($cid, '_I', 
			replace(
			@target 
			, '^.*?[I\-](\d+).*?$'
			, '$1'))
			"/>
		
		<xsl:choose>
			
			<xsl:when test="contains($components, 'questions')">
				
				<xsl:element name="fo:basic-link" use-attribute-sets="link color-blue">
					<xsl:attribute name="internal-destination">
						
						<!--<xsl:choose>
							<xsl:when test="@xpointer='benefits'">
								<xsl:value-of select="concat($iid, '_BENEFITS')"/>
							</xsl:when>
							<xsl:when test="@xpointer='harms'">
								<xsl:value-of select="concat($iid, '_HARMS')"/>
							</xsl:when>
							<xsl:when test="@xpointer='comment'">
								<xsl:value-of select="concat($iid, '_COMMENT')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$iid"/>
							</xsl:otherwise>
							</xsl:choose>-->
						
						<xsl:value-of select="$iid"/>
						
					</xsl:attribute>
					
					<xsl:apply-templates/>
					
					<xsl:if test="contains($media, 'print') and not(ancestor::key-point-list)">
						
						<xsl:text>, p </xsl:text>
						
						<xsl:element name="fo:page-number-citation" use-attribute-sets="">
							<xsl:attribute name="ref-id">
								
								<!--<xsl:choose>
									<xsl:when test="@xpointer='benefits'">
										<xsl:value-of select="concat($iid, '_BENEFITS')"/>
									</xsl:when>
									<xsl:when test="@xpointer='harms'">
										<xsl:value-of select="concat($iid, '_HARMS')"/>
									</xsl:when>
									<xsl:when test="@xpointer='comment'">
										<xsl:value-of select="concat($iid, '_COMMENT')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$iid"/>
									</xsl:otherwise>
									</xsl:choose>-->
								
								<xsl:value-of select="$iid"/>
								
							</xsl:attribute>
							
						</xsl:element>
							
					</xsl:if>
					
				</xsl:element>
				
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
	<!-- FIX: how will these work as links? -->
	<xsl:template match="knowledge-topic-link">
		<xsl:variable name="target" select="substring-before(substring-after(@target, '_'), '.xml')"/>
		
		<xsl:element name="fo:basic-link" use-attribute-sets="link color-blue">
			<xsl:attribute name="internal-destination" select="$target"/>
			<xsl:apply-templates/>
		</xsl:element>
		
	</xsl:template>

	<xsl:template match="uri-link">
		<xsl:variable name="target" select="substring-before(substring-after(@target, '_'), '.xml')"/>
		
		<xsl:element name="fo:basic-link" use-attribute-sets="link color-blue">
			
			<xsl:attribute name="external-destination">
				<xsl:text>url('</xsl:text>
				<xsl:value-of select="  @target"/>
				<xsl:text>')</xsl:text>
			</xsl:attribute>

			<xsl:apply-templates/>
			<xsl:value-of select="$url-icon"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="processing-instruction('substantive-change-start')">
		
		<xsl:if test="
			ancestor::*[name()='benefits' 
			or name()='harms']//processing-instruction('substantive-change-end')
			or contains($media, 'web')">
			
			<!--<xsl:element name="fo:basic-link" use-attribute-sets="">
				<xsl:attribute name="internal-destination">substantive-changes</xsl:attribute>
				<xsl:element name="fo:inline" use-attribute-sets="link color-blue">
					<xsl:value-of select="$change-start-icon"/>
				</xsl:element>
				</xsl:element>-->
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="processing-instruction('substantive-change-end')">
		
		<xsl:if test="
			ancestor::*[name()='benefits' 
			or name()='harms']//processing-instruction('substantive-change-start')
			or contains($media, 'web')">
			
			<!--<xsl:element name="fo:basic-link" use-attribute-sets="">
				<xsl:attribute name="internal-destination">substantive-changes</xsl:attribute>
				<xsl:element name="fo:inline" use-attribute-sets="link color-blue">
					<xsl:value-of select="$change-end-icon"/>
				</xsl:element>
				</xsl:element>-->
			
		</xsl:if>
		
	</xsl:template>
	
</xsl:stylesheet>

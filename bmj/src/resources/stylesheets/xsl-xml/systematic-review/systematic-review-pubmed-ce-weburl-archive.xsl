<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xi="http://www.w3.org/2001/XInclude" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:oak="http://schema.bmj.com/delivery/oak"
	xmlns:ce="http://schema.bmj.com/delivery/oak-ce"
	version="2.0">
	
	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8"
		indent="yes"/>
	
	<xsl:param name="lang"/>
	<xsl:param name="media"/>
	<xsl:param name="systematic-review-xml-input"/>
	<xsl:param name="links-xml-input"/>
	<xsl:param name="date"/>
	<xsl:param name="pmid"/>
	<xsl:param name="proof"/>
	
	<xsl:param name="strings-variant-fileset" />
	<xsl:param name="xmlns" select="string('ce')"/>
	
	<xsl:include href="../../xsl-glue-text/bmj-publisher-glue-text.xsl"/>
	<xsl:include href="../../generic-params.xsl"/>
	<xsl:include href="../../systematic-review-params.xsl"/>
	
	<xsl:include href="../../xsl-lib/strings/publication-labels-process-shared.xsl" />
	
	<!--<xsl:include href="../oak/systematic-review-oak-comparisons-serial.xsl" />-->
	<xsl:include href="../oak/systematic-review-oak-comparisons-tabulated.xsl" />
	<xsl:include href="../oak/systematic-review-oak-comparisons-grade-table.xsl" />
	
	<xsl:variable name="links" select="document($links-xml-input)/*"/>
	<xsl:variable name="cid" select="substring-after(/systematic-review/@id, '_')"/>
	<xsl:variable name="bmjk-review-plan" select="document(/systematic-review/info/bmjk-review-plan-link/@target)/*"/>
	<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after($bmjk-review-plan//info/section-list/section-link[1]/@target, '../'))"/>
	<xsl:variable name="primary-section-info" select="document($filename)/*"/>
	
	<xsl:variable name="id-lead-text">BMJ_</xsl:variable>
	
	<xsl:variable name="inline-callout">true</xsl:variable>
	
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
	
	<xsl:variable name="comparisons-grade-table-oak">
		<xsl:call-template name="process-comparisons-grade-table"/>	
	</xsl:variable>
	
	<xsl:key 
		name="para" 
		match="p[not(strong)]"
		use="generate-id((preceding-sibling::p[strong])[last()])"/>
	
	<xsl:template match="/">
		
		<xsl:element name="article">
			<xsl:attribute name="article-type">review-article</xsl:attribute>
			<xsl:attribute name="xml:lang">EN</xsl:attribute>
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">http://dtd.nlm.nih.gov/archiving/2.3/xsd/archivearticle.xsd</xsl:attribute>
			<xsl:attribute name="dtd-version">2.3</xsl:attribute>
			
			<xsl:element name="front">
				
				<xsl:element name="journal-meta">
					
					<xsl:element name="journal-id">
						<xsl:attribute name="journal-id-type">publisher-id</xsl:attribute>
						<xsl:value-of select="$journal-title-abbr"/>
					</xsl:element>
					
					<xsl:element name="journal-title">
						<xsl:value-of select="$journal-title" />
					</xsl:element>
					
					<xsl:element name="issn">
						<xsl:attribute name="pub-type">epub</xsl:attribute>
						<xsl:value-of select="$issn"/>
					</xsl:element>
					
					<xsl:element name="publisher">
						<xsl:element name="publisher-name">
							<xsl:value-of select="$bmj-publisher-glue-text/publisher-name[contains(@lang, $lang)]"/>
						</xsl:element>
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="article-meta">
					
					<xsl:element name="article-id">
						<xsl:attribute name="pub-id-type">publisher-id</xsl:attribute>
						<xsl:value-of select="$cid"/>
					</xsl:element>
					
					<xsl:call-template name="process-section-info"/>
					
					<xsl:if test="string-length($pmid)">
						<xsl:element name="article-id">
							<xsl:attribute name="pub-id-type">pmid</xsl:attribute>
							<xsl:value-of select="$pmid"/>
						</xsl:element>
					</xsl:if>
					
					<xsl:element name="title-group">
						<xsl:element name="article-title">
							<xsl:apply-templates select="/systematic-review/info/title"/>
						</xsl:element>
						<xsl:element name="alt-title">
							<xsl:attribute name="alt-title-type" select="string('abridged')" />
							<xsl:apply-templates select="/systematic-review/info/abridged-title"/>
						</xsl:element>
					</xsl:element>
					
					<xsl:call-template name="process-contributors"/>
					
					<xsl:element name="pub-date">
						<xsl:attribute name="pub-type">epub</xsl:attribute>
						<xsl:element name="day">
							<xsl:value-of select="substring($date, 9, 2)"/>
						</xsl:element>
						<xsl:element name="month">
							<xsl:value-of select="substring($date, 6, 2)"/>
						</xsl:element>
						<xsl:element name="year">
							<xsl:value-of select="substring($date, 1, 4)"/>
						</xsl:element>
					</xsl:element>
					
					<xsl:element name="pub-date">
						<xsl:attribute name="pub-type">collection</xsl:attribute>
						<xsl:element name="year">
							<xsl:value-of select="substring($date, 1, 4)"/>
						</xsl:element>
					</xsl:element>
					
					<xsl:element name="volume">
						<xsl:value-of select="substring($date, 1, 4)"/>
					</xsl:element>					
					
					<xsl:element name="elocation-id">
						<xsl:value-of select="$cid"/>
					</xsl:element>
					
					<xsl:element name="permissions">
						<xsl:element name="copyright-statement">
							<xsl:value-of select="$copyright"/><xsl:text>, All Rights Reserved</xsl:text>
						</xsl:element>
						<xsl:element name="copyright-year">
							<xsl:value-of select="substring($date, 1, 4)"/>
						</xsl:element>
					</xsl:element>
					
					<xsl:variable name="self-uri-ceweb">
						<xsl:text>http://clinicalevidence.bmj.com/x/systematic-review/</xsl:text>
						<xsl:value-of select="$cid"/>
						<xsl:text>/overview.html</xsl:text>
					</xsl:variable>
					
					<xsl:variable name="self-uri-pmc">
						<xsl:text>http://clinicalevidence.bmj.com/x/systematic-review/</xsl:text>
						<xsl:value-of select="$cid"/>
						<xsl:text>/overview.html</xsl:text>
					</xsl:variable>
					
					<xsl:element name="self-uri">
						<xsl:attribute name="xlink:href" select="$self-uri-pmc"/>
						<xsl:text>This article is available from </xsl:text>
						<xsl:value-of select="$self-uri-pmc"/>
					</xsl:element>
										
					<xsl:call-template name="process-abstract"/>
					<xsl:call-template name="process-key-points"/>					
					
					<xsl:element name="counts">
						
						<xsl:if test="$links//figure-link">
							<xsl:element name="fig-count">
								<xsl:attribute name="count" select="count($links//figure-link)"/>
							</xsl:element>
						</xsl:if>
						
						<xsl:if test="$links//table-link or $evidence-appraisal-grade-table = 'true'">
							
							<xsl:element name="table-count">
								
								<xsl:variable name="evidence-appraisal-grade-table-binary">
									<xsl:if test="$evidence-appraisal-grade-table = 'true'">
										<xsl:text>1</xsl:text>
									</xsl:if>
								</xsl:variable>
								
								<xsl:attribute name="count" select="count($links//table-link) + number($evidence-appraisal-grade-table-binary)"/>
								
							</xsl:element>
							
						</xsl:if>
						
						<xsl:element name="ref-count">
							<xsl:attribute name="count" select="count($links//reference-link)"/>
						</xsl:element>
						
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="notes">
					<xsl:attribute name="notes-type" select="string('disclaimer')"/>
					<xsl:element name="sec">
						<xsl:element name="title">
							<!--<xsl:value-of select="$glue-text//element()[name()='disclaimer-title'][contains(@lang, $lang)]"/>-->
							<xsl:text>Disclaimer</xsl:text>
						</xsl:element>
						<xsl:element name="p">
							<xsl:value-of select="$glue-text//element()[name()='disclaimer'][contains(@lang, $lang)]"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>

			</xsl:element>
			
			<xsl:element name="body">
				<xsl:call-template name="process-clinical-context"/>
				<xsl:call-template name="process-background"/>
				
			</xsl:element>
			
			<xsl:element name="back">
				
				<xsl:call-template name="process-glossary"/>
				<xsl:call-template name="process-references"/>
				
				<xsl:choose>
					
					<xsl:when test="$inline-callout = 'false'">
						
						<xsl:if test="$links//figure-link or $links//table-link or $evidence-appraisal-grade-table = 'true'">
							
							<xsl:element name="ref-list">
								
								<xsl:call-template name="process-back-matter-figures"/>
								<xsl:call-template name="process-back-matter-tables"/>
								
							</xsl:element>
							
						</xsl:if>
						
					</xsl:when>
					
					<!--<xsl:otherwise>
						
						<xsl:if test="$evidence-appraisal-grade-table = 'true' or $links//table-link[@grade='true']">
							
							<xsl:element name="ref-list">
								
								<xsl:choose>
									
									<xsl:when test="$evidence-appraisal-grade-table = 'true'">
										
										<xsl:apply-templates select="$comparisons-grade-table-oak" mode="comparisons-grade-table-oak" />
										
									</xsl:when>
									
									<xsl:when test="$links//table-link[@grade='true']">
										
										<xsl:for-each select="$links//table-link">
											<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
											
											<xsl:if test="@grade='true'">
												<xsl:apply-templates select="document($filename)/*" mode="back-matter-table-nlm">
													<xsl:with-param name="position" select="position()" />
												</xsl:apply-templates>
											</xsl:if>
											
										</xsl:for-each>
										
									</xsl:when>
									
								</xsl:choose>
							
							</xsl:element>
							
						</xsl:if>
						
					</xsl:otherwise>-->
					
				</xsl:choose>
				
				<xsl:if test="/systematic-review/info/covered-elsewhere/p[1][string-length(.)!=0]">
					<xsl:element name="notes">
						<xsl:attribute name="notes-type">
							<xsl:text>related-resources</xsl:text>
						</xsl:attribute>
						<xsl:for-each select="/systematic-review/info/covered-elsewhere/p">
							<xsl:element name="p">
								<xsl:apply-templates/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:if>
				
			</xsl:element>
			
		    <xsl:call-template name="process-questions-intervention-sub-article"/>
			
		</xsl:element>

	</xsl:template>
	
	<xsl:template name="process-section-info">
		<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after($bmjk-review-plan//info/section-list/section-link[1]/@target, '../'))"/>
		<xsl:variable name="primary-section-info" select="document($filename)/*"/>
		
		<xsl:element name="article-categories">
			
			<xsl:element name="subj-group">
				<xsl:attribute name="subj-group-type">primary-section</xsl:attribute>
				<xsl:element name="subject">
					<xsl:apply-templates select="$primary-section-info//title"/>
				</xsl:element>
			</xsl:element>
			
			<xsl:if test="count($bmjk-review-plan//info/section-list/section-link) &gt; 1">
				<xsl:element name="subj-group">
					<xsl:attribute name="subj-group-type">secondary-section</xsl:attribute>
					<xsl:for-each select="$bmjk-review-plan//info/section-list/section-link[position()!=1]">
						<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@target, '../'))"/>
						<xsl:variable name="additional-section-info" select="document($filename)/*"/>
						<xsl:element name="subject">
							<xsl:apply-templates select="$additional-section-info//title"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-contributors">
		
		<xsl:element name="contrib-group">
			
			<xsl:for-each select="$bmjk-review-plan//contributor-set/person-link">
				<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@target, '../'))"/>
				<xsl:variable name="person" select="document($filename)/*"/>
		
				<xsl:element name="contrib">
					<xsl:attribute name="contrib-type">contributor</xsl:attribute>
					<xsl:attribute name="corresp">no</xsl:attribute>
					<xsl:attribute name="deceased">no</xsl:attribute>
					<xsl:if test="count($bmjk-review-plan//contributor-set/person-link) != 1">
						<xsl:attribute name="equal-contrib">yes</xsl:attribute>
					</xsl:if>
					
					<xsl:element name="name">
						<xsl:element name="surname">
							<xsl:apply-templates select="$person//last-name"/>
						</xsl:element>
						<xsl:element name="given-names">
							<xsl:apply-templates select="$person//first-name"/>
							<xsl:if test="$person//middle-name[string-length(normalize-space(.))!=0]">
								<xsl:text> </xsl:text>
								<xsl:apply-templates select="$person//middle-name"/>
							</xsl:if> 
						</xsl:element>
						<xsl:if test="$person//nomen[string-length(normalize-space(.))!=0]">
							<xsl:element name="prefix">
								<xsl:apply-templates select="$person//nomen"/>
							</xsl:element>
						</xsl:if>
					</xsl:element>
					
					<xsl:if test="$person//honorific[string-length(normalize-space(.))!=0]">
						<xsl:element name="degrees">
							<xsl:apply-templates select="$person//honorific"/>
						</xsl:element>
					</xsl:if>
					
					<xsl:if test="$person//title[string-length(normalize-space(.))!=0]">
						<xsl:element name="role">
							<xsl:apply-templates select="$person//title"/>
						</xsl:element>
					</xsl:if>
					
					<xsl:element name="aff">
						<xsl:element name="institution">
							<xsl:apply-templates select="$person//affiliation"/>
						</xsl:element>
						<xsl:element name="addr-line">
							<xsl:apply-templates select="$person//city"/>
						</xsl:element>
						<xsl:element name="country">
							<xsl:apply-templates select="$person//country"/>
						</xsl:element>
					</xsl:element>
					
				</xsl:element>
				
			</xsl:for-each>
		
		</xsl:element>
		
		<xsl:comment>competing-interests</xsl:comment>
		
		<xsl:choose>
			<xsl:when test="/systematic-review/info/competing-interests/p[1][string-length(.) = 0]">
				<xsl:comment>no author notes</xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="author-notes">
					<xsl:element name="fn">
						<xsl:for-each select="/systematic-review/info/competing-interests/p">
							<xsl:element name="p">
								<xsl:apply-templates/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
				
	</xsl:template>
	
	<xsl:template name="process-abstract">
		<xsl:choose>
			<xsl:when test="/systematic-review/abstract/element()[string-length(.)!=0]">
				<xsl:element name="abstract">
					<xsl:for-each select="/systematic-review/abstract/element()">
						<xsl:variable name="abstract-label" select="concat('abstract-', name())"/>
						<xsl:element name="sec">
							<xsl:element name="title">
								<xsl:value-of select="$glue-text//element()[name()=$abstract-label][contains(@lang, $lang)]"/>
							</xsl:element>
							<xsl:element name="p">
								<xsl:apply-templates/>
							</xsl:element>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<!-- do nothing -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="process-summary-view">
		
		<xsl:element name="abstract">
			<xsl:attribute name="abstract-type">summary</xsl:attribute>
			
			<xsl:element name="sec">
				<xsl:attribute name="sec-type">interventions</xsl:attribute>
				
				<xsl:element name="title">
					<xsl:value-of select="$glue-text/interventions[contains(@lang, $lang)]"/>
				</xsl:element>
				
				<xsl:element name="p">
					<xsl:value-of select="$glue-text/interventions-byline[contains(@lang, $lang)]"/>
				</xsl:element>
				
				<xsl:for-each select="/systematic-review/question-list/question">
					
					<xsl:element name="sec">
						<xsl:attribute name="sec-type">question</xsl:attribute>
						<xsl:element name="title">
							<xsl:apply-templates select="title"/>
						</xsl:element>
						
						<xsl:variable name="question">
							<xsl:for-each select=".//xi:include[contains(@href, 'option')]">
								<xsl:element name="{name()}">
									<xsl:attribute name="href" select="@href"/>
									<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@href, '../'))"/>
									<xsl:copy-of select="document($filename)/*"/>
								</xsl:element>
							</xsl:for-each>
						</xsl:variable>
						
						<xsl:call-template name="process-summary-interventions">
							<xsl:with-param name="summary-group" select="$question"/>
						</xsl:call-template>
						
					</xsl:element>
								
				</xsl:for-each>

				<xsl:if test="$bmjk-review-plan//info/future-issues/p[1][string-length(.)!=0]">
					<xsl:element name="sec">
						<xsl:attribute name="sec-type">future-updates</xsl:attribute>
						<xsl:element name="title">
							<xsl:value-of select="$glue-text/future-updates[contains(@lang, $lang)]"/>
						</xsl:element>
						<xsl:for-each select="$bmjk-review-plan//info/future-issues/p">
							<xsl:element name="p">
								<xsl:apply-templates/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:if>
				
				<xsl:if test="/systematic-review/info/footnote/p[1][string-length(.)!=0]">
					<xsl:element name="fn-group">
						<xsl:element name="fn">
							<xsl:attribute name="fn-type">other</xsl:attribute>
							<xsl:for-each select="/systematic-review/info/footnote/p">
								<xsl:element name="p">
									<xsl:apply-templates/>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				
			</xsl:element>
			
		</xsl:element>
				
	</xsl:template>
	
	<xsl:template name="process-summary-interventions">
		<xsl:param name="summary-group"/>
		<xsl:param name="summary-group-id"/>
		
		<xsl:for-each select="$efficacy-order/*">
			<xsl:variable name="efficacy-type" select="name()"/>
			
			<xsl:if test="$summary-group//intervention[@efficacy = $efficacy-type]">
				
				<xsl:element name="sec">
					<xsl:attribute name="sec-type" select="$efficacy-type"/>
					
					<xsl:element name="title">
						<xsl:value-of select="$glue-text/*[name()=$efficacy-type][contains(@lang, $lang)]"/>
					</xsl:element>
					
					<xsl:for-each select="$summary-group//intervention">
						<xsl:sort select="title"/>
						
						<xsl:if test="@efficacy = $efficacy-type">
							<xsl:variable name="iid">
								<xsl:choose>
									<xsl:when test="not($summary-group-id)">
										<!-- chpping '../options/_op1003_I1.xml' to get option id -->
										<!--<xsl:variable name="iid" select="substring-after(substring-after(substring-before(ancestor::xi:include/@href, '.xml'), '_'), '_')"/>-->
										<xsl:value-of
											select="
											concat($cid, '_I', 
											replace(
											ancestor::xi:include/@href 
											, '^.*?[I\-](\d+).*?$'
											, '$1'))
											"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$summary-group-id"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							<xsl:element name="sec">
								<xsl:attribute name="sec-type">intervention</xsl:attribute>
								
								<xsl:element name="title">
									<xsl:apply-templates select="title"/>
								</xsl:element>
								
								<!-- summary-statement -->
								<xsl:choose>
									<xsl:when test="string-length(summary-statement)">
										<xsl:element name="p">
											<xsl:apply-templates select="summary-statement"/>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:element name="p">
											<xsl:apply-templates select="ancestor::option/summary-statement"/>
										</xsl:element>
									</xsl:otherwise>
								</xsl:choose>
								
							</xsl:element>
							
						</xsl:if>
						
					</xsl:for-each>
					
				</xsl:element>
				
			</xsl:if>
			
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template name="process-key-points">
		
		<xsl:element name="abstract">
			<xsl:attribute name="abstract-type">key-points</xsl:attribute>
			
			<xsl:element name="title">
				<xsl:value-of select="$glue-text/key-points[contains(@lang, $lang)]"/>
			</xsl:element>
			
			<xsl:for-each select="/systematic-review/key-point-list/element()">
				
				<xsl:variable name="preceding-sibling-generate-id" select="generate-id(preceding-sibling::element()[1])"/>
				<xsl:variable name="following-sibling-generate-id" select="generate-id(following-sibling::element()[1])"/>
				
				<xsl:if test="name() = 'p' and following-sibling::element()[1][name() = 'p']">
					<xsl:element name="p">
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:if>
				
				<xsl:if test="name() = 'p' and following-sibling::element()[1][name() = 'ul']">
					<xsl:text disable-output-escaping="yes">&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&lt;p&gt;</xsl:text>
					<xsl:apply-templates/>
				</xsl:if>
				
				<xsl:if test="name() = 'ul'">
					
					<xsl:if test="//element()[generate-id(.)=$preceding-sibling-generate-id and name()!='ul']">
						<xsl:text disable-output-escaping="yes">&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;&lt;list list-type="bullet"&gt;</xsl:text>	
					</xsl:if>
					
					<xsl:for-each select="li[string-length(normalize-space(.))!=0]">
						<xsl:text disable-output-escaping="yes">&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
						<xsl:element name="list-item">
							<xsl:element name="p">
								<xsl:apply-templates/>
							</xsl:element>
						</xsl:element>
					</xsl:for-each>
					
					<xsl:if test="//element()[generate-id(.)=$following-sibling-generate-id and name()!='ul'] or position()=last()">
						<xsl:text disable-output-escaping="yes">&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&lt;/list&gt;</xsl:text>
						<xsl:text disable-output-escaping="yes">&#13;&#x9;&#x9;&#x9;&#x9;&lt;/p&gt;&#13;</xsl:text>	
					</xsl:if>
					
				</xsl:if>
				
				<xsl:if test="name() = 'p' and position() = last()">
					<xsl:element name="p">
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:if>
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	
	<xsl:template name="process-clinical-context">
	
		<xsl:variable name="clinical-context">
			<!-- first extract from topic -->
			<xsl:for-each select="/systematic-review/clinical-context/*">			
				<xsl:variable name="name" select="name()"/>				
				<xsl:element name="{$name}">					
					<xsl:element name="sec">				
						<xsl:attribute name="sec-type" select="$name"/>
						<xsl:attribute name="id" select="concat($id-lead-text, $cid, '_', translate($name, $lower, $upper))"/>						
						<xsl:element name="title">
							<xsl:value-of select="$glue-text/*[name()=$name][contains(@lang, $lang)]"/>
						</xsl:element>						
						<xsl:element name="p">						
							<xsl:apply-templates select="p/node()"/>												
						</xsl:element>				
					</xsl:element>					
				</xsl:element>							
			</xsl:for-each>
		</xsl:variable>
		
		<!-- then rebuild + order -->
		<xsl:element name="sec">
			<xsl:attribute name="sec-type">clinical-context</xsl:attribute>			
			<xsl:element name="title">Clinical context</xsl:element>		
			<xsl:for-each select="$clinical-context-order/*">
				<xsl:variable name="name" select="name()"/>
				<xsl:if test="$clinical-context/node()[name()=$name][string-length(.)!=0]">
					<xsl:copy-of select="$clinical-context/node()[name()=$name]/sec"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>

			
	</xsl:template>	
	
	
	
	<xsl:template name="process-background">
		
		<xsl:variable name="background">
			
			<!-- first extract from topic -->
			<xsl:for-each select="/systematic-review/background/*">
				
				<xsl:variable name="name" select="name()"/>
				
				<xsl:element name="{$name}">
					
					<xsl:element name="sec">
						<xsl:attribute name="sec-type" select="$name"/>
						<xsl:attribute name="id" select="concat($id-lead-text, $cid, '_', translate($name, $lower, $upper))"/>
						
						<xsl:element name="title">
							<xsl:value-of select="$glue-text/*[name()=$name][contains(@lang, $lang)]"/>
						</xsl:element>
						
						<xsl:element name="p">
						
							<xsl:apply-templates select="p/node()"/>
							
							<xsl:if test="$evidence-appraisal-grade-table='true' and $name='methods'">
								
								<xsl:text disable-output-escaping="yes"> </xsl:text>
								
								<xsl:call-template name="process-string-variant">
									<xsl:with-param name="name" select="string('methods-performed-grade-evaluation')"/>
								</xsl:call-template>
								
								<xsl:text disable-output-escaping="yes"> (</xsl:text>
								
								<xsl:element name="xref">
									<xsl:attribute name="ref-type">table</xsl:attribute>
									<xsl:attribute name="rid" select="concat($id-lead-text, $cid, '_TG')"/>
									
									<xsl:call-template name="process-string-variant">
										<xsl:with-param name="name" select="string('see-table')"/>
										<xsl:with-param name="case" select="string('lower')"/>
									</xsl:call-template>
									
								</xsl:element>
								
								<xsl:text disable-output-escaping="yes">). </xsl:text>
								<xsl:comment>added grade statement and table link automatically</xsl:comment>
								
								<xsl:call-template name="process-string-variant">
									<xsl:with-param name="name" select="string('methods-performed-grade-evaluation-description')"/>
								</xsl:call-template>
								
							</xsl:if>
							
						</xsl:element>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:for-each>
			
		</xsl:variable>
		
		<!-- then rebuild + order -->
		<xsl:element name="sec">
			<xsl:attribute name="sec-type">background</xsl:attribute>
			
			<xsl:element name="title">About this condition</xsl:element>
			
			<xsl:for-each select="$background-order/*">
				
				<xsl:variable name="name" select="name()"/>
				
				<xsl:if test="$background/node()[name()=$name][string-length(.)!=0]">
					<xsl:copy-of select="$background/node()[name()=$name]/sec"/>
				</xsl:if>
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>

	<!-- deprecated for process-questions-intervention-sub-article -->
	<xsl:template name="process-questions">
		
		<xsl:element name="sec">
			<xsl:attribute name="sec-type">questions</xsl:attribute>
			
			<xsl:element name="title">
				<xsl:value-of select="$glue-text/interventions[contains(@lang, $lang)]"/>
			</xsl:element>
			
			<!-- search-date -->
			<xsl:element name="p">
				<xsl:value-of select="/systematic-review/info/search-date"/>
			</xsl:element>
			
			<xsl:for-each select="/systematic-review/question-list/question">
		
				<xsl:element name="sec">
					<xsl:attribute name="sec-type">question</xsl:attribute>
					<xsl:attribute name="id" select="concat($id-lead-text, $cid, '_Q', position())"/>
					
					<xsl:element name="title">
						<xsl:apply-templates select="title"/>
					</xsl:element>
					
					<xsl:for-each select=".//xi:include[contains(@href, 'option')]">
						<!-- chpping '../options/_op1003_I1.xml' to get option id -->
						<xsl:variable 
							name="iid" 
							select="
							concat($cid, '_I', 
							replace(
							@href 
							, '^.*?[I\-](\d+).*?$'
							, '$1'))
							"/>
						
						<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@href, '../'))"/>
						<xsl:variable name="option" select="document($filename)/*"/>
						
						<xsl:element name="sec">
							<xsl:attribute name="sec-type">option</xsl:attribute>
							<xsl:attribute name="id" select="concat($id-lead-text, $iid)"/>
							
							<xsl:element name="title">
								<xsl:apply-templates select="$option/title"/>
							</xsl:element>
							
							<xsl:choose>
								<xsl:when test="string-length($option/summary-statement)">
									<xsl:element name="p">
										<xsl:apply-templates select="$option/summary-statement"/>
									</xsl:element>
								</xsl:when>
								<xsl:when test="count($option/intervention-set/intervention) = 1">
									<xsl:element name="p">
										<xsl:apply-templates select="$option/intervention-set/intervention/summary-statement"/>
									</xsl:element>
								</xsl:when>
							</xsl:choose>
							
							<xsl:for-each select="$option/intervention-set/intervention">
								<xsl:element name="sec">
									<xsl:attribute name="sec-type" select="@efficacy"/>
									<xsl:element name="title">
										<xsl:apply-templates select="title"/>
									</xsl:element>
									<xsl:element name="p">
										<xsl:apply-templates select="summary-statement"/>
									</xsl:element>
								</xsl:element>
							</xsl:for-each>
							
							<xsl:for-each select="$option/(benefits|harms|drug-safety-alert|comment)">
								<xsl:variable name="name" select="name()"/>
								<xsl:element name="sec">
									<xsl:attribute name="sec-type" select="name()"/>
									<xsl:choose>
										<xsl:when test="name()!='drug-safety-alert'">
											<xsl:attribute name="id" select="concat($id-lead-text, $iid, '_', translate(name(), $lower, $upper))"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="id" select="concat($id-lead-text, $iid, '_ALERT')"/>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:element name="title">
										<xsl:value-of select="$glue-text/*[name()=$name][contains(@lang, $lang)]"/>
									</xsl:element>

									<xsl:apply-templates select="p[not(strong) and not(preceding-sibling::p[strong])]" mode="para"/>
									<xsl:apply-templates select="key('para',generate-id())" mode="para"/>
									<xsl:apply-templates select="p[strong]" mode="para-title"/>
									
								</xsl:element>
							</xsl:for-each>
					
							<xsl:element name="sec">
								<xsl:variable name="status" select="$option//substantive-change-set/substantive-change/@status"/>
								<xsl:attribute name="sec-type">substantive-change</xsl:attribute>
								<xsl:element name="title">
									<xsl:value-of select="$glue-text/substantive-changes[contains(@lang, $lang)]"/>
								</xsl:element>
								<xsl:choose>
									<xsl:when test="$option//substantive-change-set/substantive-change/@status[string-length(.)!=0 and .!='no-new-evidence']">
										<xsl:element name="p">
											<xsl:apply-templates select="$option//substantive-change-set/substantive-change/node()"/>
										</xsl:element>
									</xsl:when>
									<xsl:otherwise>
										<xsl:element name="p">
											<xsl:value-of select="$glue-text/no-new-evidence[contains(@lang, $lang)]"/>
										</xsl:element>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
							
						</xsl:element>
					</xsl:for-each>			
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>
	
    <xsl:template name="process-questions-intervention-sub-article">
    	
    	<xsl:for-each select="/systematic-review/question-list/question">
    		
    		<xsl:variable name="section-title" select="$primary-section-info//title"/>
    		<xsl:variable name="question-title" select="abridged-title"/>
                    
	        <xsl:for-each select=".//xi:include[contains(@href, 'option')]">
	            <!-- chpping '../options/_op1003_I1.xml' to get option id -->
	            <xsl:variable 
	                name="iid" 
	                select="
	                concat(
	                $cid, 
	                '_I', 
	                replace(
	                @href 
	                , '^.*?[I\-](\d+).*?$'
	                , '$1'))
	                "/>
	            
	            <xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@href, '../'))"/>
	            <xsl:variable name="option" select="document($filename)/*"/>
	            
	            <xsl:element name="sub-article">
	                <!--<xsl:attribute name="article-type">intervention</xsl:attribute>-->
	            	<xsl:attribute name="article-type" select="string('option')" />
	                <xsl:attribute name="id" select="concat($id-lead-text, $iid)"/>
	            	
	            	<xsl:element name="front">
	            	
	            		<xsl:element name="article-meta">
	            			
	            			<xsl:element name="article-categories">
	            				
	            				<!-- section -->
	            				<xsl:element name="subj-group">
	            					<xsl:attribute name="subj-group-type" select="string('section')" />
            						<xsl:element name="subject">
            							<!--<xsl:attribute name="content-type" select="string('section')" />-->
            							<xsl:apply-templates select="$section-title"/>
            						</xsl:element>
	            				</xsl:element>
	            				
	            				<!-- question -->
	            				<xsl:element name="subj-group">
	            					<xsl:attribute name="subj-group-type" select="string('question')" />
	            					<xsl:element name="subject">
	            						<!--<xsl:attribute name="content-type" select="string('question')" />-->
	            						<xsl:apply-templates select="$question-title"/>
	            					</xsl:element>
	            				</xsl:element>
	            				
	            				<!-- efficacy -->
	            				<xsl:if test="count($option/intervention-set/intervention) = 1">
	            					<xsl:variable name="efficacy-type" select="$option/intervention-set/intervention/@efficacy"/>
		            				<xsl:element name="subj-group">
		            					<xsl:attribute name="subj-group-type" select="string('efficacy')" />
		            					<xsl:element name="subject">
		            						<!--<xsl:attribute name="content-type" select="string('intervention-efficacy')" />-->
		            						<xsl:value-of select="$glue-text/*[name()=$efficacy-type][contains(@lang, $lang)]"/>
		            					</xsl:element>
		            				</xsl:element>
	            				</xsl:if>
	            				
	            			</xsl:element>
	            			
	            			<xsl:element name="title-group">
	            				
	            				<xsl:element name="article-title">
	            					<xsl:apply-templates select="$option/title"/>
	            				</xsl:element>
	            				
	            				<xsl:element name="alt-title">
	            					<xsl:attribute name="alt-title-type" select="string('abridged')" />
	            					<xsl:apply-templates select="$option/abridged-title"/>
	            				</xsl:element>
	            				
	            				<xsl:if test="count($option/intervention-set/intervention) = 1">
	            					<xsl:element name="alt-title">
	            						<xsl:attribute name="alt-title-type" select="string('summary')" />
	            						<xsl:apply-templates select="$option/intervention-set/intervention/title"/>
	            					</xsl:element>
	            				</xsl:if>
	            				
	            			</xsl:element>
	            			
	            			<xsl:element name="abstract">
	            				
	            				<xsl:element name="title">
	            					<xsl:value-of select="$glue-text/summary[contains(@lang, $lang)]"/>
	            				</xsl:element>
	            				
	            				<!-- summary-statement -->
	            				<xsl:choose>
	            					
	            					<xsl:when test="string-length($option/summary-statement)">
	            						<xsl:apply-templates select="$option/summary-statement" mode="single-para" />
	            					</xsl:when>
	            					
	            					<xsl:when test="count($option/intervention-set/intervention) = 1">
	            						<xsl:apply-templates select="$option/intervention-set/intervention/summary-statement" mode="single-para" />
	            					</xsl:when>
	            					
	            				</xsl:choose>
	            				
	            			</xsl:element>
	            			
	            		</xsl:element>
	            	
	            	</xsl:element>
	            	
	            	<xsl:element name="body">
	            		
	            		<xsl:choose>
	            			
	            			<xsl:when test="$option/comparison-set">
	            				
	            				<xsl:comment>original hackberry xml format benefits and harms elements have been replaced 
	            					with new content model comparison-set as oak xml format</xsl:comment>
	            				
	            				<xsl:apply-templates select="$option/comparison-set" mode="comparisons-serial">
	            					<xsl:with-param name="iid" select="$iid" />
	            				</xsl:apply-templates>
	            				
	            				<xsl:apply-templates select="$option/drug-safety-alert">
	            					<xsl:with-param name="iid" select="$iid" />
	            				</xsl:apply-templates>
	            				
	            				<xsl:apply-templates select="$option/comment">
	            					<xsl:with-param name="iid" select="$iid" />
	            				</xsl:apply-templates>
	            				
	            			</xsl:when>
	            			
	            			<xsl:otherwise>
	            				
	            				<xsl:apply-templates select="$option/benefits">
	            					<xsl:with-param name="iid" select="$iid" />
	            				</xsl:apply-templates>
	            				
	            				<xsl:apply-templates select="$option/harms">
	            					<xsl:with-param name="iid" select="$iid" />
	            				</xsl:apply-templates>
	            				
	            				<xsl:apply-templates select="$option/drug-safety-alert">
	            					<xsl:with-param name="iid" select="$iid" />
	            				</xsl:apply-templates>
	            				
	            				<xsl:apply-templates select="$option/comment">
	            					<xsl:with-param name="iid" select="$iid" />
	            				</xsl:apply-templates>
	            				
	            			</xsl:otherwise>
	            			
	            		</xsl:choose>
	            		
	            		<xsl:element name="sec">
	            			
	            			<xsl:attribute name="sec-type">substantive-change</xsl:attribute>
	            			
	            			<xsl:variable name="status" select="$option//substantive-change-set/substantive-change/@status"/>
	            			
	            			<xsl:element name="title">
	            				<xsl:value-of select="$glue-text/substantive-changes[contains(@lang, $lang)]"/>
	            			</xsl:element>
	            			
	            			<xsl:choose>
	            				
	            				<xsl:when test="$option//substantive-change-set/substantive-change/@status[string-length(.)!=0 and .!='no-new-evidence']">
	            					<xsl:element name="p">
	            						<xsl:apply-templates select="$option//substantive-change-set/substantive-change/node()"/>
	            					</xsl:element>
	            				</xsl:when>
	            				
	            				<xsl:otherwise>
	            					<xsl:element name="p">
	            						<xsl:value-of select="$glue-text/no-new-evidence[contains(@lang, $lang)]"/>
	            					</xsl:element>
	            				</xsl:otherwise>
	            				
	            			</xsl:choose>
	            			
	            		</xsl:element>
	            		
	            	</xsl:element>
	            	
	            </xsl:element>
	        	
	        </xsl:for-each>
    		
    	</xsl:for-each>
        
    </xsl:template>
	
	<xsl:template match="benefits | harms | comment[parent::option]">
		<xsl:param name="iid" />
		
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="sec">
			<xsl:attribute name="sec-type" select="name()"/>
			<xsl:attribute name="id" select="concat($id-lead-text, $iid, '_', translate(name(), $lower, $upper))"/>
			
			<xsl:element name="title">
				<xsl:value-of select="$glue-text/*[name()=$name][contains(@lang, $lang)]"/>
			</xsl:element>
			
			<xsl:apply-templates select="p[not(strong) and not(preceding-sibling::p[strong])]" mode="para"/>
			<xsl:apply-templates select="key('para',generate-id())" mode="para"/>
			<xsl:apply-templates select="p[strong]" mode="para-title"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="drug-safety-alert">
		<xsl:param name="iid" />
		
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="sec">
			<xsl:attribute name="sec-type" select="name()"/>
			<xsl:attribute name="id" select="concat($id-lead-text, $iid, '_ALERT')"/>
			
			<xsl:element name="title">
				<xsl:value-of select="$glue-text/*[name()=$name][contains(@lang, $lang)]"/>
			</xsl:element>
			
			<xsl:apply-templates select="p[not(strong) and not(preceding-sibling::p[strong])]" mode="para"/>
			<xsl:apply-templates select="key('para',generate-id())" mode="para"/>
			<xsl:apply-templates select="p[strong]" mode="para-title"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="summary-statement" mode="split-summary-statement">
		
		<xsl:choose>
			
			<xsl:when test="not(strong)">
				<xsl:apply-templates />
			</xsl:when>
			
			<xsl:when test="strong">
				
				<xsl:for-each select="node()">
					
					<xsl:variable name="generate-id" select="generate-id(.)" />
					
					<xsl:comment select="position()"/>
					
					<xsl:choose>
						
						<xsl:when test="name()='strong'">
							
							<xsl:if test="preceding-sibling::strong">
								<xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
								<xsl:text disable-output-escaping="yes">&lt;/sec&gt;</xsl:text>
							</xsl:if>
							
							<xsl:text disable-output-escaping="yes">&lt;sec&gt;</xsl:text>
							
							<xsl:element name="title">
								<xsl:apply-templates />
							</xsl:element>
							
							<xsl:if test="following-sibling::node()[1][self::text() and string-length(normalize-space(.))!=0]">
								<xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
							</xsl:if>
							
						</xsl:when>
						
						<xsl:when test="name()='em'">
							
							<xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
							
							<xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
							
							<xsl:element name="italic">
								<xsl:apply-templates />
							</xsl:element>
							
						</xsl:when>
						
						<xsl:when test="name()='gloss-link'">
							<xsl:apply-templates />
						</xsl:when>
						
						<xsl:when test="name()='table-link'">
							<xsl:apply-templates />
						</xsl:when>
						
						<xsl:when test="self::text()">
							<xsl:value-of select="." />
						</xsl:when>
						
						<xsl:when test="position()=last()">
							<xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
							<xsl:text disable-output-escaping="yes">&lt;sec&gt;</xsl:text>
						</xsl:when>
						
					</xsl:choose>
					
				</xsl:for-each>
				
			</xsl:when>
			
			<xsl:when test="not(strong)">
				<xsl:element name="p">
					<xsl:apply-templates />	
				</xsl:element>
			</xsl:when>
			
		</xsl:choose>
		
	</xsl:template>
	
	<!--special formatting control for mixed content in summary-statement-->
	<xsl:template match="summary-statement" mode="single-para">
		
		<xsl:element name="p">
			
			<xsl:for-each select="node()">
				
				<xsl:choose>
					
					<xsl:when test="name()='strong' and (table-link or contains(translate(., $upper, $lower), 'table') or contains(translate(., $upper, $lower), 'grade'))">
						<xsl:comment select="'grade statement removed'"/>
					</xsl:when>
					
					<xsl:when test="name()='strong'">
						<xsl:value-of select="translate(normalize-space(.), $lower, $upper)"/>
						<xsl:text disable-output-escaping="yes"> </xsl:text>
					</xsl:when>
					
					<xsl:when test="name()='em'">
						<xsl:value-of select="normalize-space(.)"/>
						<xsl:text disable-output-escaping="yes">: </xsl:text>
					</xsl:when>
					
					<xsl:when test="string-length(normalize-space(.))!=0">
						<xsl:value-of select="normalize-space(.)"/>
						<xsl:text disable-output-escaping="yes"> </xsl:text>
					</xsl:when>
					
				</xsl:choose>
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
    
	<xsl:template name="process-glossary">
		
		<xsl:if test="$links//gloss-link">
			
			<xsl:element name="glossary">
				
				<xsl:element name="title">Glossary</xsl:element>
				
				<xsl:element name="gloss-group">
					
					<xsl:element name="def-list">
						
						<xsl:variable name="glossary">
							
							<xsl:for-each select="$links//gloss-link">
								
								<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@target, '../'))"/>
								<xsl:variable name="gloss" select="document($filename)/*"/>
								
								<xsl:element name="def-item">
									
									<xsl:if test="string-length(normalize-space($gloss))=0">
										<xsl:element name="error-glossary-element-empty" />
									</xsl:if>
									
									<xsl:element name="term">
										<xsl:attribute name="id" select="concat($id-lead-text, $cid, '_G', position())"/>
										
										<xsl:choose>
											
											<xsl:when test="$gloss/term[string-length(normalize-space(.))!=0]">
												<xsl:apply-templates select="$gloss/term"/>
											</xsl:when>
											
											<xsl:otherwise>
												<xsl:value-of select="substring($gloss/term/following-sibling::*, 1, 16)"/>
												<xsl:text>...</xsl:text>
											</xsl:otherwise>
											
										</xsl:choose>
										
									</xsl:element>
									
									<xsl:element name="def">
										
										<xsl:element name="p">
											<xsl:apply-templates select="$gloss/term/following-sibling::*"/>
										</xsl:element>
										
									</xsl:element>
									
								</xsl:element>
								
							</xsl:for-each>
							
						</xsl:variable>
						
						<xsl:for-each select="$glossary/element()">
							<xsl:sort select="term"/>
							
							<xsl:copy-of select="."/>
						</xsl:for-each>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="process-substantive-changes">
		<xsl:if test="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='new-evidence-conclusions-confirmed' or @status='new-evidence-conclusions-changed']">
			<xsl:element name="substantive-changes">
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='new-evidence-conclusions-confirmed']">
					<xsl:element name="substantive-change">
						<xsl:attribute name="status" select="@status"/>
						<xsl:apply-templates select="node()"/>
					</xsl:element>
				</xsl:for-each>
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='new-evidence-conclusions-changed']">
					<xsl:element name="substantive-change">
						<xsl:attribute name="status" select="node()/@status"/>
						<xsl:apply-templates select="node()"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="process-references">			
		
		<xsl:element name="ref-list">
			
			<xsl:if test="$evidence-appraisal-grade-table='true' and $inline-callout = 'true'">
				<xsl:apply-templates select="$comparisons-grade-table-oak" mode="comparisons-grade-table-oak" />	
			</xsl:if>
			
			<xsl:for-each select="$links//reference-link">
				<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@target, '../'))"/>
				<xsl:variable name="reference" select="document($filename)/*"/>
				<xsl:element name="ref">
					<xsl:attribute name="id" select="concat($id-lead-text, $cid, '_REF', position())"/>
					<xsl:element name="label">
						<xsl:value-of select="position()"/>
					</xsl:element>
					<xsl:choose>
						<!--also <nlm-citation citation-type="journal"/>-->
						<xsl:when test="$reference//unique-id[@source='medline' and string-length(normalize-space(.))!=0]">
							<xsl:element name="citation">
								<xsl:attribute name="citation-type">journal</xsl:attribute>
								<xsl:apply-templates select="$reference//clinical-citation"/>
								<xsl:element name="pub-id">
									<xsl:attribute name="pub-id-type">pmid</xsl:attribute>
									<xsl:value-of select="$reference//unique-id"/>
								</xsl:element>
							</xsl:element>
						</xsl:when>		
						<xsl:otherwise>
							<xsl:element name="citation">
								<xsl:attribute name="citation-type">journal</xsl:attribute>
								<xsl:apply-templates select="$reference//clinical-citation"/>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-back-matter-figures">
		
		<xsl:for-each select="$links//figure-link">
			<xsl:call-template name="process-figure">
				<xsl:with-param name="target" select="@target"/>
			</xsl:call-template>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-figure">
		
		<xsl:param name="target"/>
		
		<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after($target, '../'))"/>
		<xsl:variable name="figure" select="document($filename)/*"/>					
		<xsl:element name="fig">
			<xsl:attribute name="id" select="concat($id-lead-text, $cid, '_F', position())"/>
			<xsl:element name="label">
				<xsl:text>Figure </xsl:text>
				<xsl:value-of select="position()"/>
			</xsl:element>
			<xsl:element name="caption">
				<xsl:element name="p">
					<xsl:apply-templates select="$figure//caption"/>
				</xsl:element>
			</xsl:element>
			<xsl:element name="graphic">
				<xsl:attribute name="xlink:href">
					<xsl:text>clinevid-</xsl:text>
					<xsl:value-of select="substring($date, 1, 4)"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="$cid"/>
					<xsl:text>-g00</xsl:text>
					<xsl:value-of select="substring($figure//image-link/@target, 23, 1)"/>
					<xsl:text>.jpg</xsl:text>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-back-matter-tables">
		
		<xsl:for-each select="$links//table-link">
			
			<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
			<xsl:apply-templates select="document($filename)/*" mode="back-matter-table-nlm">
				<xsl:with-param name="position" select="position()" />
			</xsl:apply-templates>
			
		</xsl:for-each>
		
		<xsl:apply-templates select="$comparisons-grade-table-oak" mode="comparisons-grade-table-oak" />
		
	</xsl:template>
	
	<xsl:template match="*:table" mode="back-matter-table-nlm">
		<xsl:param name="position" />
		
		<xsl:element name="table-wrap">
			<xsl:attribute name="id" select="concat($id-lead-text, $cid, '_T', $position)"/>
			<xsl:attribute name="position">float</xsl:attribute>
			<xsl:attribute name="content-type">web,print</xsl:attribute>
			
			<xsl:element name="label">
				<xsl:text>Table</xsl:text>
				<xsl:choose>
					<xsl:when test="@grade='true'">
						<!-- do nothing -->
					</xsl:when>
					<xsl:otherwise>
						<xsl:text disable-output-escaping="yes"> </xsl:text>
						<xsl:value-of select="position()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			
			<xsl:element name="caption">
				<xsl:element name="p">
					<xsl:apply-templates select="caption/node()"/>
				</xsl:element>
			</xsl:element>

			<xsl:element name="table">
				<xsl:attribute name="frame">border</xsl:attribute>
				<xsl:attribute name="border">1</xsl:attribute>
				<xsl:attribute name="width">100%</xsl:attribute>
				<!--<xsl:attribute name="orient">LAND</xsl:attribute>-->
				
				<xsl:element name="colgroup">
					
					<xsl:variable name="maxcol-generate-id">
						<xsl:for-each select=".//tr">
							<xsl:sort select="count(*:td)" />
							<xsl:if test="position()=last()">
								<xsl:value-of select="generate-id(.)" />
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>
					
					<xsl:for-each select="*:tbody/*:tr[generate-id(.)=$maxcol-generate-id]/*:td">
						<xsl:element name="col">
							<xsl:attribute name="width">1*</xsl:attribute>
							<xsl:if test="string-length(@align)">
								<xsl:attribute name="align" select="translate(@align, $upper, $lower)"/>
							</xsl:if>
						</xsl:element>
					</xsl:for-each>
					
				</xsl:element>
			
				<xsl:apply-templates select="*:thead|*:tbody" />
				
			</xsl:element>
			
			<xsl:if 
				test="
				*:tbody/*:tr[count(*:td) != 1]
				and *:tbody/*:tr[position()=last() and count(*:td) = 1 and *:td[string-length(.)!=0]]
				or *:tfoot/*:tr/*:td[string-length(.)!=0]
				">
				
				<xsl:element name="table-wrap-foot">
					
					<xsl:element name="fn">
						
						<xsl:for-each select="*:tfoot/*:tr/*:td">
							<xsl:element name="p">
								<xsl:apply-templates/>
							</xsl:element>
						</xsl:for-each>
						
						<xsl:for-each select="*:tbody/*:tr[position()=last() and count(*:td)=1]/*:td[string-length(.)!=0]">
							<xsl:element name="p">
								<xsl:apply-templates/>
							</xsl:element>
						</xsl:for-each>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:if>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="*:table" mode="comparisons-grade-table-oak">
		
		<xsl:element name="table-wrap">
			<xsl:attribute name="id" select="concat($id-lead-text, $cid, '_TG')"/>
			<xsl:attribute name="position">float</xsl:attribute>
			<xsl:attribute name="content-type">web,print</xsl:attribute>
			
			<xsl:element name="label">
				<xsl:text>Table</xsl:text>
			</xsl:element>
			
			<xsl:element name="caption">
				<xsl:element name="p">
					<xsl:apply-templates select="*:caption/*:p" />
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="table">
				<xsl:attribute name="frame">border</xsl:attribute>
				<xsl:attribute name="border">1</xsl:attribute>
				<xsl:attribute name="width">100%</xsl:attribute>
				<!--<xsl:attribute name="orient">LAND</xsl:attribute>-->
				
				<colgroup>
					<col width="1*" />
					<col width="1*" />
					<col width="1*" />
					<col width="1*" />
					<col width="1*" />
					<col width="1*" />
					<col width="1*" />
					<col width="1*" />
					<col width="1*" />
					<col width="1*" />
				</colgroup>
				
				<xsl:apply-templates select="*:thead|*:tbody" />
				
			</xsl:element>
			
			<xsl:if 
				test="
				*:tbody/*:tr[count(*:td) != 1]
				and *:tbody/*:tr[position()=last() and count(*:td) = 1 and *:td[string-length(.)!=0]]
				or *:tfoot/*:tr/*:td[string-length(.)!=0]
				">
				
				<xsl:element name="table-wrap-foot">
					
					<xsl:element name="fn">
						
						<xsl:for-each select="*:tfoot/*:tr/*:td">
							<xsl:element name="p">
								<xsl:apply-templates/>
							</xsl:element>
						</xsl:for-each>
						
						<xsl:for-each select="*:tbody/*:tr[position()=last() and count(*:td)=1]/*:td[string-length(.)!=0]">
							<xsl:element name="p">
								<xsl:apply-templates/>
							</xsl:element>
						</xsl:for-each>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:if>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="*:thead|*:tbody|*:tfoot">
		
		<xsl:element name="{name()}">
			<xsl:apply-templates />
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="*:tr">
		
		<xsl:choose>
			
			<xsl:when test="(not(following-sibling::*:tr) and count(*:td) = 1) and parent::*:tbody[*:tr[count(*:td) != 1]]">
				<xsl:comment>foot</xsl:comment>
			</xsl:when>
			
			<!-- If row has no content don't include -->
			<xsl:when test="count(.//*:th | *:td) = 0">
				<xsl:comment>empty row removed</xsl:comment>
			</xsl:when>
			
			<xsl:otherwise>
				
				<xsl:element name="tr">
					
					<xsl:for-each select="*:th | *:td">
						
						<xsl:element name="td">
							<xsl:copy-of select="@colspan"/>
							
							<xsl:if test="@align[string-length(.)!=0]">
								<xsl:attribute name="align" select="translate(@align, $upper, $lower)"/>
							</xsl:if>
							
							<xsl:apply-templates/>
							
						</xsl:element>
						
					</xsl:for-each>
					
				</xsl:element>
				
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="p" mode="para-title">
		
		<xsl:element name="sec">
			
			<xsl:element name="title">
				<xsl:apply-templates select="strong[1]/node()"/>
			</xsl:element>
			
			<xsl:if test="strong[1]/following-sibling::node()[string-length(normalize-space(.))!=0]">
				<xsl:comment>forcing sibling nodes of strong withought own para to new para markup</xsl:comment>
				
				<xsl:element name="p">
					<xsl:apply-templates select="strong[1]/following-sibling::node()"/>
				</xsl:element>
				
			</xsl:if>
			
			<xsl:apply-templates select="key('para',generate-id())" mode="para"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="p" mode="para">
		<xsl:element name="p">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="p[strong]">
		<xsl:element name="title">
			<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="'strong'"/>
				<xsl:attribute name="class" select="'strong'"/>-->
			<xsl:apply-templates select="strong[1]/node()"/>
		</xsl:element>
		<xsl:if test="strong[1]/following-sibling::node()[string-length(normalize-space(.))!=0]">
			<xsl:comment>forcing sibling nodes of strong withought own para to new para markup</xsl:comment>
			<xsl:element name="p">
				<xsl:apply-templates select="strong[1]/following-sibling::node()"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="strong">
		<xsl:element name="bold">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="em">
		<xsl:element name="italic">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="sub|sup|p">
		<xsl:element name="{name()}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="ul">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="li">
		<xsl:element name="list-item">
			<xsl:element name="p">
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template 
		match="
		option-link[contains(@target, 'MISSING')] | 
		gloss-link[contains(@target, 'MISSING')] |
		figure-link[contains(@target, 'MISSING')] |
		table-link[contains(@target, 'MISSING')] |
		reference-link[contains(@target, 'MISSING')] |
		reference-link[ancestor::reference]
		">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="option-link">
		
		<!-- chpping '../options/_op1003_I1.xml' to get option id -->
		<!--<xsl:variable name="iid" select="substring-after(substring-after(substring-before(ancestor::xi:include/@href, '.xml'), '_'), '_')"/>-->
		<xsl:variable 
			name="iid" 
			select="
			concat($cid, '_I', 
			replace(
			@target 
			, '^.*?[Ii\-](\d+).*?$'
			, '$1'))
			"/>
		
		<!-- do we have links to deleted options that does not create a MISSING_LINK_TARGET href value ?? -->
		<xsl:variable name="available-iid-list">
			<xsl:for-each select="//xi:include[contains(@href, 'option')]">
				<xsl:element name="iid">
					<xsl:value-of 
						select="
						concat($cid, '_I', 
						replace(
						@href 
						, '^.*?[Ii\-](\d+).*?$'
						, '$1'))
						"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$available-iid-list//iid=$iid">
				<xsl:element name="xref">
					<xsl:attribute name="ref-type">sec</xsl:attribute>
					<xsl:choose>
						<xsl:when test="@xpointer='benefits'">
							<xsl:attribute name="rid" select="concat($id-lead-text, $iid, '_BENEFITS')"/>
						</xsl:when>
						<xsl:when test="@xpointer='harms'">
							<xsl:attribute name="rid" select="concat($id-lead-text, $iid, '_HARMS')"/>
						</xsl:when>
						<xsl:when test="@xpointer='comment'">
							<xsl:attribute name="rid" select="concat($id-lead-text, $iid, '_COMMENT')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="rid" select="concat($id-lead-text, $iid)"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>
					<xsl:text>untagged: missing link target </xsl:text>
					<xsl:value-of select="$iid"/>
				</xsl:comment>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="gloss-link">
		<xsl:variable name="target" select="@target"/>
		<xsl:element name="xref">
			<xsl:attribute name="ref-type">term</xsl:attribute>
			<xsl:for-each select="$links//gloss-link">
				<xsl:if test="@target=$target">
					<xsl:attribute name="rid" select="concat($id-lead-text, $cid, '_G', position())"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="figure-link">
		<xsl:variable name="target" select="@target"/>
		<xsl:element name="xref">
			<xsl:attribute name="ref-type">figure</xsl:attribute>
			<xsl:for-each select="$links//figure-link">
				<xsl:if test="@target=$target">
					<xsl:attribute name="rid" select="concat($id-lead-text, $cid, '_F', position())"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:element>
		
		<xsl:if test="$inline-callout = 'true'">
			<xsl:for-each select="$links//figure-link">
				<xsl:if test="@target=$target">
					<xsl:call-template name="process-figure">
						<xsl:with-param name="target" select="$target"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="table-link">
		
		<xsl:variable name="target" select="@target"/>
		
		<xsl:element name="xref">
			<xsl:attribute name="ref-type">table</xsl:attribute>
			
			<xsl:for-each select="$links//table-link">
				
				<xsl:if test="@target=$target">
					<xsl:attribute name="rid" select="concat($id-lead-text, $cid, '_T', position())"/>
				</xsl:if>
				
			</xsl:for-each>
			
			<xsl:apply-templates/>
			
		</xsl:element>
		
		<xsl:if test="$inline-callout = 'true'">
			
			<xsl:for-each select="$links//table-link">
				
				<xsl:if test="@target=$target">
					
					<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after($target, '../'))"/>
					
					<xsl:apply-templates select="document($filename)/*" mode="back-matter-table-nlm">
						<xsl:with-param name="position" select="position()" />
					</xsl:apply-templates>
						
				</xsl:if>
				
			</xsl:for-each>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="reference-link">
		
		<xsl:variable name="target" select="@target"/>
		<xsl:element name="xref">
			<xsl:attribute name="ref-type">bibr</xsl:attribute>
			<xsl:for-each select="$links//reference-link">
				<xsl:if test="@target=$target">
					<xsl:attribute name="rid" select="concat($id-lead-text, $cid, '_REF', position())"/>
					<!--<xsl:value-of select="position()"/>-->
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="systematic-review-link">
		<xsl:comment>ext-link</xsl:comment>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="processing-instruction('substantive-change-start')">
		<xsl:if test="ancestor::*[name()='benefits' or name()='harms']//processing-instruction('substantive-change-end')">
			<xsl:comment>change-start</xsl:comment>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="processing-instruction('substantive-change-end')">
		<xsl:if test="ancestor::*[name()='benefits' or name()='harms']//processing-instruction('substantive-change-start')">
			<xsl:comment>change-end</xsl:comment>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="pi-comment">
		<!-- do nothing -->
	</xsl:template>
	
	<xsl:template match="comment()">
		<xsl:comment select="."/>
	</xsl:template>
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xi="http://www.w3.org/2001/XInclude" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html">
	
	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"
		use-character-maps="custom-map-letterpart"/>
	
	<xsl:param name="lang"/>
	<xsl:param name="media"/>
	<xsl:param name="links-xml-input"/>
	<xsl:param name="systematic-review-xml-input"/>
	<xsl:param name="process-stream"/>
	
	<xsl:include href="../../generic-params.xsl"/>
	<xsl:include href="../../systematic-review-params.xsl"/>
	<xsl:include href="../../xsl-entities/custom-map-letterpart.xsl"/>
	
	<xsl:variable name="links" select="document($links-xml-input)/*"/>
	<xsl:variable name="cid" select="substring-after(/systematic-review/@id, '_')"/>
	<xsl:variable name="bmjk-review-plan" select="document(concat($systematic-review-xml-input, substring-after(/systematic-review/info/bmjk-review-plan-link/@target, '../')))/*"/>
	
	<xsl:template match="/">
		
		<condition>
			<xsl:attribute name="id" select="concat('CE_', $cid)"/>
			
			<xsl:choose>
				<xsl:when test="translate($process-stream, $upper, $lower) = 'new'">
					<xsl:attribute name="is-new">
						<xsl:text>true</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="translate($process-stream, $upper, $lower) = 'archive'">
					<xsl:attribute name="is-archived">
						<xsl:text>true</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="is-updated">
						<xsl:text>true</xsl:text>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">http://schema.bmj.com/delivery/hackberry/condition.xsd</xsl:attribute>
						
			<xsl:call-template name="process-section-info"/>
			
			<condition-info>			
				
				<condition-long-title>
					<xsl:value-of select="/systematic-review/info/title"/>
				</condition-long-title>
				<condition-abridged-title/>
				<search-date>
					<xsl:value-of select="/systematic-review/info/search-date"/>
				</search-date>
				<collective-name>
					<xsl:value-of select="/systematic-review/info/collective-name"/>
				</collective-name>
				
				<xsl:call-template name="process-contributors"/>

				<xsl:if test="/systematic-review/info/footnote/p[1][string-length(.)!=0]">
					<xsl:element name="footnote">
						<xsl:for-each select="/systematic-review/info/footnote/p">
							<p>
								<xsl:apply-templates/>
							</p>
						</xsl:for-each>
					</xsl:element>
				</xsl:if>
				
			</condition-info>

			<xsl:call-template name="process-key-points"/>
			<xsl:call-template name="process-clinical-context"/>
			<xsl:call-template name="process-summary-view"/>
			<xsl:call-template name="process-background"/>
			<xsl:call-template name="process-questions"/>
			
			
		</condition>

	</xsl:template>
	
	<xsl:template name="process-section-info">
		<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after($bmjk-review-plan//info/section-list/section-link[1]/@target, '../'))"/>
		<xsl:variable name="primary-section-info" select="document($filename)/*"/>
		<primary-section-info>
			<xsl:attribute name="id">
				<xsl:value-of select="$primary-section-info//@id"/>
			</xsl:attribute>
			<section-long-title>
				<xsl:value-of select="$primary-section-info//title"/>
			</section-long-title>
			<section-abridged-title/>
		</primary-section-info>
	</xsl:template>
	
	<xsl:template name="process-contributors">
		<xsl:comment>section left blank as part of hackberry letterpart xml</xsl:comment>
		<contributors>
			<contributor>
				<nomen/>
				<first-name/>
				<middle-name/>
				<last-name/>
				<pedigree/>
				<honorific/>
				<title/>
				<affiliation/>
				<city/>
				<country/>
			</contributor>
		</contributors>
		<competing-interests>
			<p/>
		</competing-interests>
	</xsl:template>
	
	<xsl:template name="process-summary-view">
		<summary-view>
			
			<xsl:for-each select="/systematic-review/question-list/question">
				
				<question-list>
					<xsl:attribute name="refid">
						<xsl:value-of select="concat($cid, '_Q', position())"/>
					</xsl:attribute>
					
					<title>
						<xsl:apply-templates select="title"/>
					</title>
					<abridged-title/>
					
					<xsl:variable name="question">
						<xsl:for-each select=".//xi:include[contains(@href, 'option')]">
							<xsl:element name="{name()}">
								<xsl:attribute name="href" select="@href"/>
								<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@href, '../'))"/>
								<xsl:copy-of select="document($filename)/*"/>
							</xsl:element>
						</xsl:for-each>
					</xsl:variable>
										
					<xsl:for-each select="$efficacy-order/*">
						<xsl:variable name="efficacy-type" select="name()"/>
						
						<xsl:if test="$question//intervention[@efficacy = $efficacy-type]">
							
							<efficacy-list>
								<xsl:attribute name="efficacy">
									<xsl:value-of select="$efficacy-type"/>
								</xsl:attribute>
								
								<title>
									<xsl:value-of select="$glue-text/*[name()=$efficacy-type][contains(@lang, $lang)]"/>
								</title>
								
								<xsl:for-each select="$question//intervention">
									<xsl:sort select="title"/>
									
									<xsl:if test="@efficacy = $efficacy-type">
										<!-- chpping '../options/_op1003_I1.xml' to get option id -->
										<xsl:variable 
											name="iid" 
											select="
											concat($cid, '_I', 
											replace(
											ancestor::xi:include[contains(@href, 'option')]/@href 
											, '^.*?[I\-](\d+).*?$'
											, '$1'))
											"/>
										<intervention>
											<xsl:attribute name="refid">
												<xsl:value-of select="$iid"/>
											</xsl:attribute>
											<xsl:if test="parent::option[substantive-change-set/substantive-change/@status = 'new-option']">
												<xsl:attribute name="is-new">true</xsl:attribute>
											</xsl:if>
											<title>
												<xsl:apply-templates select="title"/>
											</title>
											<key-message>
												<!--<xsl:choose>
													<xsl:when test="summary-statement">
														<xsl:apply-templates select="summary-statement"/>														
													</xsl:when>
													<xsl:otherwise>
														<xsl:apply-templates select="ancestor::option/summary-statement"/>
													</xsl:otherwise>
												</xsl:choose>-->
											</key-message>
										</intervention>
									</xsl:if>
									
								</xsl:for-each>
								
							</efficacy-list>
							
						</xsl:if>
						
					</xsl:for-each>
					
				</question-list>
			
			</xsl:for-each>
			
		</summary-view>

	</xsl:template>

	<xsl:template name="process-key-points">
		<keypoint-list>
			<xsl:attribute name="id" select="concat($cid, '_KEYPOINT')"/>
			<xsl:for-each select="/systematic-review/key-point-list/node()">
				<xsl:apply-templates select="."/>
			</xsl:for-each>			
		</keypoint-list>
	</xsl:template>
	
	<xsl:template name="process-clinical-context">
		<xsl:variable name="clinical-context">
			<!-- first extract from topic -->
			<xsl:for-each select="/systematic-review/clinical-context/*">
				<xsl:element name="{name()}">
					<xsl:apply-templates select="p/node()"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:variable>
		
		<!-- then rebuild + order -->
		<xsl:element name="clinical-context">
			<xsl:for-each select="$clinical-context-order/*">
				<xsl:variable name="name" select="name()"/>
				<xsl:if test="$clinical-context/node()[name()=$name][string-length(.)!=0]">
					<xsl:copy-of select="$clinical-context/node()[name()=$name]"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-background">
		
		<xsl:variable name="background">
			<!-- first extract from topic -->
			<xsl:for-each select="/systematic-review/background/*">
				<xsl:element name="{name()}">
					<xsl:apply-templates select="p/node()"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:variable>
		
		<!-- then rebuild + order -->
		<xsl:element name="background">
			<xsl:for-each select="$background-order/*">
				<xsl:variable name="name" select="name()"/>
				<xsl:if test="$background/node()[name()=$name][string-length(.)!=0]">
					<xsl:choose>
						<xsl:when test="
							name() = 'definition' or
							name() = 'incidence' or
							name() = 'aetiology' or
							name() = 'prognosis'">
							<xsl:copy-of select="$background/node()[name()=$name]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:comment>section left blank as part of hackberry letterpart xml</xsl:comment>
							<xsl:element name="{name()}"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>

	<xsl:template name="process-questions">
		<xsl:comment>section left blank as part of hackberry letterpart xml</xsl:comment>
		<questions>
			<question id="Q1">
				<question-long-title/>
				<question-abridged-title/>
			</question>
		</questions>
	</xsl:template>
	
	<xsl:template match="em|strong|sub|sup|p|ul|li">
		<xsl:element name="{name()}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="option-link|gloss-link|figure-link|table-link">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="reference-link">
		<!-- do nothing -->
	</xsl:template>
	
	<xsl:template match="systematic-review-link">
		
		<xsl:choose>
			<xsl:when test="matches(@target, '[0-9][0-9][0-9][0-9]')">
				<xsl:element name="link">
					<xsl:attribute name="type">condition</xsl:attribute>
					<xsl:attribute name="target">
						<xsl:text>CE_</xsl:text>
						<xsl:analyze-string select="@target"
							regex="([0-9][0-9][0-9][0-9])">
							<xsl:matching-substring>
								<xsl:value-of select="regex-group(1)"/>
							</xsl:matching-substring>
						</xsl:analyze-string>
					</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xi="http://www.w3.org/2001/XInclude" 
	
	xmlns="http://schema.bmj.com/delivery/oak"
	
	xmlns:oak="http://schema.bmj.com/delivery/oak"
	xmlns:ce="http://schema.bmj.com/delivery/oak-ce"

	version="2.0">
	
	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"/>
	
	<xsl:param name="proof"/>
	<xsl:param name="lang"/>
	<xsl:param name="media"/>
	<xsl:param name="systematic-review-xml-input"/>
	<xsl:param name="systematic-review-meta-input"/>
	<xsl:param name="links-xml-input"/>
	<xsl:param name="components"/>
	<xsl:param name="date"/>
	<xsl:param name="process-stream"/>
	<xsl:param name="xmlns"/>
	<xsl:param name="strings-variant-fileset" />
	
	<xsl:param name="pub-resource-name" />
	
		
	<xsl:include href="../../xsl-lib/strings/publication-labels-process-shared.xsl"/>
	<xsl:include href="../../xsl-glue-text/bmj-publisher-glue-text.xsl"/>
	
	<xsl:include href="../../generic-params.xsl"/>
	<xsl:include href="../../systematic-review-params.xsl"/>
	<xsl:include href="generic-oak-default-elements.xsl"/>
	<xsl:include href="generic-oak-redline-annotation.xsl"/>
	
	<xsl:include href="systematic-review-oak-comparisons-serial.xsl" />
	<xsl:include href="systematic-review-oak-comparisons-grade-table.xsl"/>
	
	<xsl:variable name="links" select="document(translate($links-xml-input, '\\', '/'))/*"/>
	<xsl:variable name="cid" select="substring-after(/systematic-review/@id, '_')"/>
	<xsl:variable name="id-lead-text" select="'sr-'"/>
	<xsl:variable name="bmjk-review-plan" select="document(/systematic-review/info/bmjk-review-plan-link/@target)/*"/>
	<xsl:variable name="primary-section-info" select="document(concat(translate($systematic-review-xml-input, '\\', '/'), substring-after($bmjk-review-plan//info/section-list/section-link[1]/@target, '../')))/*"/>
	<xsl:variable name="systematic-review-title" select="/systematic-review/info/title/node()"/>
	
	<xsl:key 
		name="para" 
		match="p[not(strong)]"
		use="generate-id((preceding-sibling::p[strong])[last()])"/>
	
	
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
	
	<xsl:variable 
		name="references-excluded-list-filename"
		select="concat(translate($systematic-review-xml-input, '\\', '/'), 'references/refs-', substring-after($pub-resource-name, 'sr-'), '.xml')"/>
	<xsl:variable 
		name="references-excluded-list" 
		select="document($references-excluded-list-filename)/*"/>
	
	<xsl:variable name="references-excluded-matched">
		
		<xsl:for-each select="$references-excluded-list//reference-link[@approved='false']">
			<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
			<xsl:variable name="reference" select="document($filename)/*"/>
			
			<xsl:if test="$reference//clinical-citation[string-length(.)!=0]">
				<xsl:copy-of select="$reference"/>
			</xsl:if>
			
		</xsl:for-each>
		
	</xsl:variable>
	
	<xsl:template match="/systematic-review">
		
		
		<xsl:element name="section">
			
			<xsl:namespace name="ce">http://schema.bmj.com/delivery/oak-ce</xsl:namespace>
			<xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
			<xsl:attribute name="xsi:schemaLocation">http://schema.bmj.com/delivery/oak http://schema.bmj.com/delivery/oak/bmj-oak-strict.xsd</xsl:attribute>
			
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="id" select="concat($id-lead-text, substring-after(@id, '_'))"/>
			<!--<xsl:attribute name="xml:lang" select="$lang"/>-->
			
			<xsl:if test="count($references-excluded-matched/*) &gt; 0">
				<xsl:processing-instruction name="references-excluded" select="string('true')"/>
				<!--
					<?references-excluded true?>
					//processing-instruction()[name()='references-excluded' and .='true']
				-->
			</xsl:if>


			<xsl:apply-templates select="info"/>

			<xsl:if test="contains($components, 'notes')">
				<xsl:apply-templates select="notes"/>
			</xsl:if>

			<xsl:if test="contains($components, 'abstract')">
				<xsl:if test="abstract/*[1][string-length(.)=0]">
					<xsl:processing-instruction name="abstract-available" select="string('false')" />
				</xsl:if>
				<!--<xsl:apply-templates select="abstract" mode="abstract"/>-->
				<xsl:apply-templates select="abstract" mode="plain-text"/>
			</xsl:if>
			
			<xsl:if test="contains($components, 'summary-questions-list')">
				<xsl:call-template name="process-summary-questions-list"/>
			</xsl:if>
			
			<xsl:if test="contains($components, 'summary-interventions-list')">
				<xsl:call-template name="process-summary-interventions-list"/>
			</xsl:if>
			
			<xsl:if test="contains($components, 'clinical-context')">
				<xsl:apply-templates select="clinical-context"/>
			</xsl:if>
			
			<xsl:if test="contains($components, 'key-points-list')">
				<xsl:apply-templates select="key-point-list" mode="section"/>
			</xsl:if>
			
						
			<xsl:if test="contains($components, 'background')">
				<xsl:apply-templates select="background"/>
			</xsl:if>
			
			<xsl:apply-templates select="question-list"/>
			
			<xsl:if test="contains($components, 'substantive-changes')">
				<xsl:call-template name="process-substantive-changes"/>
			</xsl:if>
			
			<xsl:if test="contains($components, 'glossaries')">
				<xsl:call-template name="process-glossary"/>
			</xsl:if>
			
			<xsl:if test="contains($components, 'references')">
				<xsl:call-template name="process-references"/>
			</xsl:if>
			
			<!--<xsl:if test="contains($components, 'references-excluded')">
				<xsl:call-template name="process-references-excluded"/>
			</xsl:if>-->
			
			<xsl:if test="contains($components, 'figures')">
				<xsl:call-template name="process-figures"/>
			</xsl:if>
			
			<xsl:if test="contains($components, 'tables')">
				<xsl:call-template name="process-tables"/>
				<xsl:call-template name="process-comparisons-grade-table"/>
			</xsl:if>
			
			<xsl:if test="contains($components, 'disclaimer')">
				<xsl:call-template name="process-disclaimer"/>
			</xsl:if>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="info">
			
		<xsl:apply-templates select="title" mode="title"/>
		
		<xsl:element name="metadata">
			
			<xsl:if test="string-length($systematic-review-meta-input)!=0">
				<xsl:element name="key">
					<xsl:attribute name="{concat($xmlns, ':name')}" select="string('version-from-cms')"/>
					<xsl:attribute name="value" select="document(translate($systematic-review-meta-input, '\\', '/'), /)/meta/version"/>
				</xsl:element>
			</xsl:if>
			
			<xsl:comment>note: abridged-title can contain escaped inline markup</xsl:comment>
			<xsl:element name="key">
				<xsl:attribute name="{concat($xmlns, ':name')}" select="string('abridged-title')"/>
				<!--<xsl:attribute name="value" select="normalize-space(abridged-title)"/>-->
				<xsl:attribute name="value">
					<xsl:call-template name="process-abridged-title-escaped-markup">
						<xsl:with-param name="abridged-title" select="abridged-title" />
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
			
			<xsl:if test="string-length(normalize-space($date))!=0">
				<xsl:element name="key">
					<xsl:attribute name="{concat($xmlns, ':name')}" select="'publication-date'"/>
					<xsl:attribute name="value" select="$date"/>
				</xsl:element>
			</xsl:if>
			
			<xsl:element name="key">
				<xsl:attribute name="{concat($xmlns, ':name')}" select="'search-date'"/>
				<xsl:attribute name="value">
					<xsl:choose>
						<xsl:when test="contains(translate(search-date, $upper, $lower), 'search date ')">
							<xsl:call-template name="date-convert">
								<xsl:with-param name="date-value" select="concat('1 ', substring-after(translate(normalize-space(search-date), $upper, $lower), 'search date '))"/>
							</xsl:call-template>							
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="date-convert">
								<xsl:with-param name="date-value" select="concat('1 ', translate(normalize-space(search-date), $upper, $lower))"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:element>
			
			<xsl:call-template name="process-section-info"/>
			
			<xsl:element name="key">
				<xsl:attribute name="{concat($xmlns, ':name')}" select="'publication-status'"/>
				<xsl:choose>
					<xsl:when test="translate($process-stream, $upper, $lower) = 'new'">
						<xsl:attribute name="value" select="'new'"/>
					</xsl:when>
					<xsl:when test="translate($process-stream, $upper, $lower) = 'archive'">
						<xsl:attribute name="value" select="'archive'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="value" select="'update'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			
		</xsl:element>
		
		<!--<xsl:apply-templates select="collective-name" mode="section"/>-->
		
		<xsl:if test="contains($components, 'contributors')">
			<xsl:call-template name="process-contributors"/>
		</xsl:if>
		<xsl:if test="/systematic-review/info/footnote[string-length(normalize-space(.))!=0]">
			<xsl:apply-templates select="/systematic-review/info/footnote" mode="section-list"/>
        </xsl:if>
	</xsl:template>
	
	<xsl:template match="notes">
		<xsl:element name="section">
			<xsl:attribute name="class" select="'notes'"/>
			<xsl:element name="title">
				<xsl:value-of>Notes</xsl:value-of>
			</xsl:element>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
		
	

	<xsl:template name="process-section-info">
		<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after($bmjk-review-plan//info/section-list/section-link[1]/@target, '../'))"/>
		<xsl:variable name="primary-section-info" select="document($filename)/*"/>
		
		<xsl:comment select="'see separate property file for subject-group title list'"/>
		
		<xsl:choose>
			<xsl:when test="$primary-section-info//title[string-length(.)!=0]">
				<xsl:element name="key">
					<xsl:attribute name="{concat($xmlns, ':name')}" select="'subject-group-primary'"/>
					<!--<xsl:attribute name="value" select="$primary-section-info//title"/>-->
					<xsl:attribute name="value" select="$primary-section-info//@id"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment select="'subject-group-primary missing from source'"/>	
			</xsl:otherwise>
		</xsl:choose>
			
		<xsl:if test="count($bmjk-review-plan//info/section-list/section-link) &gt; 1">
			<xsl:for-each select="$bmjk-review-plan//info/section-list/section-link[position()!=1]">
				<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
				<xsl:variable name="additional-section-info" select="document($filename)/*"/>
				<xsl:element name="key">
					<xsl:attribute name="{concat($xmlns, ':name')}" select="'subject-group-secondary'"/>
					<!--<xsl:attribute name="value" select="$additional-section-info//title"/>-->
					<xsl:attribute name="value" select="$additional-section-info//@id"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="process-contributors">
				
		<xsl:element name="person-group">
			
			<xsl:for-each select="$bmjk-review-plan//contributor-set/person-link">
				<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
				<xsl:variable name="person" select="document($filename)/*"/>
		
				<xsl:element name="person">
					<xsl:attribute name="class">contributor</xsl:attribute>
					<xsl:attribute name="id" select="concat($id-lead-text, $cid, '-person', position())"/>
					 
					<xsl:choose>
						<xsl:when test="$person//first-name[string-length(normalize-space(.))!=0 and not(starts-with(normalize-space(.), 'Please enter'))]">
							<xsl:element name="given-names">
								<xsl:apply-templates select="$person//first-name"/>
								<xsl:if test="$person//middle-name[string-length(normalize-space(.))!=0 and not(starts-with(normalize-space(.), 'Please enter'))]">
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="$person//middle-name"/>
								</xsl:if> 
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:comment select="'given-names missing from source'"/>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:choose>
						<xsl:when test="$person//last-name[string-length(normalize-space(.))!=0 and not(starts-with(normalize-space(.), 'Please enter'))]">
							<xsl:element name="family-names">
								<xsl:apply-templates select="$person//last-name"/>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:comment select="'family-names missing from source'"/>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:if test="$person//honorific[string-length(normalize-space(.))!=0 and not(starts-with(normalize-space(.), 'Please enter'))]">
						<xsl:element name="honorific">
							<xsl:apply-templates select="$person//honorific"/>
						</xsl:element>
					</xsl:if>
					
					<xsl:if test="$person//nomen[string-length(normalize-space(.))!=0 and not(starts-with(normalize-space(.), 'Please enter'))]">
						<xsl:element name="prefix">
							<xsl:apply-templates select="$person//nomen"/>
						</xsl:element>
					</xsl:if>
					
					<xsl:if test="$person//pedigree[string-length(normalize-space(.))!=0 and not(starts-with(normalize-space(.), 'Please enter'))]">
						<!--speciality--> 
						<!--<xsl:element name="need-new-name-from-xsd">
							<xsl:apply-templates select="$person//pedigree"/>
						</xsl:element>-->
					</xsl:if>
					
					<xsl:if test="$person//title[string-length(normalize-space(.))!=0 and not(starts-with(normalize-space(.), 'Please enter'))]">
						<xsl:element name="role">
							<xsl:apply-templates select="$person//title"/>
						</xsl:element>
					</xsl:if>
					
					<xsl:if 
						test="
						$person//affiliation[string-length(normalize-space(.))!=0 and not(starts-with(normalize-space(.), 'Please enter'))]
						or $person//city[string-length(normalize-space(.))!=0 and not(starts-with(normalize-space(.), 'Please enter'))]
						or $person//country[string-length(normalize-space(.))!=0 and not(starts-with(normalize-space(.), 'Please enter'))]
						">
						<xsl:element name="address">
							<xsl:for-each select="$person//affiliation | $person//city | $person//country">
								<xsl:if test="string-length(normalize-space(.))!=0 and not(starts-with(normalize-space(.), 'Please enter'))">
									<xsl:element name="p">
										<xsl:apply-templates/>
									</xsl:element>
								</xsl:if>
							</xsl:for-each>
						</xsl:element>
					</xsl:if>
					
				</xsl:element>
				
			</xsl:for-each>
			
			<xsl:apply-templates select="competing-interests"/>
		
		</xsl:element>
				
	</xsl:template>
	
	<xsl:template match="competing-interests">
		<xsl:element name="notes">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			<xsl:choose>
				<xsl:when test="p[string-length(normalize-space(.))!=0]">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="p">
						<xsl:text>None declared.</xsl:text>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="abstract" mode="plain-text">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="abstract">
			
			<xsl:element name="p">
				
				<xsl:for-each select="element()">
					<xsl:variable name="name" select="name()" />
					
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="concat('abstract-', $name)"/>
						<xsl:with-param name="case" select="string('upper')" />
					</xsl:call-template>
					
					<xsl:text disable-output-escaping="yes">: </xsl:text>
					
					<xsl:value-of select="." />
					
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					
				</xsl:for-each>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="abstract">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="abstract"/>
			<xsl:attribute name="class" select="$name"/>
			<!--<xsl:attribute name="id" select="concat($id-lead-text, $cid, '-', $name)"/>-->
			
			<xsl:element name="title">
				<xsl:value-of select="$glue-text//element()[name()=$name][contains(@lang, $lang)]"/>
			</xsl:element>
			
			<xsl:apply-templates/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="abstract/*">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="concat('abstract-', $name)"/>
			<xsl:attribute name="class" select="concat('abstract-', $name)"/>
			<!--<xsl:attribute name="id" select="concat($id-lead-text, $cid, '-', $name)"/>-->
			
			<xsl:element name="title">
				<xsl:value-of select="$glue-text//element()[name()=concat('abstract-', $name)][contains(@lang, $lang)]"/>
			</xsl:element>
			
			<xsl:element name="p">
				<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="concat('abstract-', $name)"/>
				<xsl:attribute name="class" select="concat('abstract-', $name)"/>-->
				<xsl:apply-templates/>
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-summary-questions-list">
			
		<xsl:element name="section">
			<xsl:attribute name="class" select="'questions-summary'"/>
			
			<xsl:element name="title">
				<xsl:value-of select="$glue-text/questions[contains(@lang, $lang)]"/>
			</xsl:element>
			
			<xsl:element name="list">
				
				<xsl:for-each select="/systematic-review/question-list/question">
					
					<xsl:element name="li">
						<xsl:element name="link">
							<xsl:attribute name="target" select="concat($id-lead-text, generate-id(.))" />
							<xsl:attribute name="class" select="string('question-link')"/>
							<xsl:apply-templates select="title/node()" />
						</xsl:element>
					</xsl:element>	
								
				</xsl:for-each>
			
			</xsl:element>
			
		</xsl:element>
				
	</xsl:template>
	
	<xsl:template name="process-summary-interventions-list">
		
		<xsl:element name="section">
			<xsl:attribute name="class" select="'interventions-summary'"/>
			
			<xsl:element name="title">
				<xsl:value-of select="$glue-text/interventions[contains(@lang, $lang)]"/>
			</xsl:element>
			
			<xsl:element name="p">
				<xsl:value-of select="$glue-text/interventions-byline[contains(@lang, $lang)]"/>
			</xsl:element>
			
			<xsl:for-each select="/systematic-review/question-list/question">
				
				<xsl:element name="section">
					<xsl:attribute name="class">question</xsl:attribute>
					
					<!--ADD: link to target? -->
					<xsl:apply-templates select="title" mode="title"/>
					
					<xsl:element name="metadata">
						<xsl:comment>note: abridged-title can contain escaped inline markup</xsl:comment>
						<xsl:element name="key">
							<xsl:attribute name="{concat($xmlns, ':name')}" select="string('abridged-title')"/>
							<!--<xsl:attribute name="value" select="normalize-space(abridged-title)"/>-->
							<xsl:attribute name="value">
								<xsl:call-template name="process-abridged-title-escaped-markup">
									<xsl:with-param name="abridged-title" select="abridged-title" />
								</xsl:call-template>
							</xsl:attribute>
						</xsl:element>
					</xsl:element>
					
					<xsl:variable name="question">
						<xsl:for-each select=".//xi:include[contains(@href, 'option')]">
							<xsl:element name="{name()}">
								<xsl:attribute name="href" select="@href"/>
								<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@href, '../'))"/>
								<xsl:copy-of select="document($filename)/*"/>
							</xsl:element>
						</xsl:for-each>
					</xsl:variable>
					
					<!-- xsl:element name="list" -->
						
						<xsl:call-template name="process-summary-interventions-list-group">
							<xsl:with-param name="summary-group" select="$question"/>
						</xsl:call-template>
						
					<!-- /xsl:element -->
					
				</xsl:element>
				
			</xsl:for-each>
			
			<xsl:if test="covered-elsewhere[string-length(normalize-space(.))!=0]">
				<xsl:apply-templates select="covered-elsewhere" mode="section-list"/>	
			</xsl:if>
			
			<xsl:if test="$bmjk-review-plan//info/future-issues[string-length(normalize-space(.))!=0]">
				<xsl:apply-templates select="$bmjk-review-plan//info/future-issues" mode="section-list"/>
			</xsl:if>
			
			<xsl:if test="/systematic-review/info/footnote[string-length(normalize-space(.))!=0]">
				<xsl:apply-templates select="/systematic-review/info/footnote" mode="section-list"/>
				
				<!--<xsl:element name="section">
					<xsl:attribute name="{concat($xmlns, ':oen')}" select="string('footnote')"/>
					<xsl:attribute name="class" select="string('footnote')"/>
					
					<xsl:element name="title">
						<xsl:value-of select="$glue-text//summary-footnote[contains(@lang, $lang)]"/>
					</xsl:element>
					
					<xsl:apply-templates select="/systematic-review/info/footnote/p"/>
					
				</xsl:element>-->
				
			</xsl:if>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-summary-interventions-list-group">
		<xsl:param name="summary-group"/>
		
		<xsl:for-each select="$efficacy-order/*">
			<xsl:variable name="efficacy-type" select="name()"/>
			
			<xsl:if test="$summary-group//intervention[@efficacy = $efficacy-type]">
				
				<xsl:element name="section">
					<xsl:attribute name="class" select="$efficacy-type"/>
					
					<xsl:element name="title">
						<xsl:value-of select="$glue-text/*[name()=$efficacy-type][contains(@lang, $lang)]"/>
					</xsl:element>
					
					<xsl:element name="metadata">
						<xsl:element name="key">
							<xsl:attribute name="{concat($xmlns, ':name')}" select="'intervention-efficacy'"/>
							<xsl:attribute name="value" select="$efficacy-type"/>
						</xsl:element>
					</xsl:element>
					
					<xsl:element name="list">
						<xsl:for-each select="$summary-group//intervention">
							<xsl:sort select="title"/>
							
							<xsl:if test="@efficacy = $efficacy-type">
								
								<!-- chpping '../options/_op1003_I1.xml' or 
									'../options/option-1179218159900_en-gb.xml' to get option id -->			
								
								<xsl:variable name="iid" 
									select="
									concat(
									$id-lead-text, 
									$cid, 
									'-i', 
									replace(
									ancestor::xi:include/@href 
									, '^.*?[I\-](\d+).*?$'
									, '$1'))
									"/>
								
								<xsl:element name="li">
									<xsl:element name="link">
										<xsl:attribute name="class" select="string('option-link')"/>
										<xsl:attribute name="target" select="$iid" />
										<xsl:apply-templates select="title/node()" />	
									</xsl:element>
								</xsl:element>
								
							</xsl:if>
							
						</xsl:for-each>
					</xsl:element>
					
				</xsl:element>
				
			</xsl:if>
			
		</xsl:for-each>
		
	</xsl:template>
	<xsl:template match="clinical-context">
		<xsl:variable name="clinical-context">
			<xsl:for-each select="child::*[string-length(normalize-space(.))!=0]">
				<xsl:variable name="name" select="name()"/>				
				<xsl:element name="{$name}">					
					<xsl:element name="section">
						<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
						<xsl:attribute name="class" select="$name"/>
						<xsl:attribute name="id" select="concat($id-lead-text, $cid, '-', $name)"/>						
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
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:element name="title">Clinical context</xsl:element>
			
			<xsl:for-each select="$clinical-context-order/*">
				<xsl:variable name="name" select="name()"/>
				<xsl:if test="$clinical-context/node()[name()=$name][string-length(.)!=0]">
					<xsl:copy-of select="$clinical-context/node()[name()=$name]/*"/>
				</xsl:if>
			</xsl:for-each>
			
		</xsl:element>
	
	</xsl:template>
	
	
	<xsl:template match="background">
		
		<xsl:variable name="background">
			<!-- first extract from topic -->
			<xsl:for-each select="child::*[string-length(normalize-space(.))!=0]">
				<xsl:variable name="name" select="name()"/>
				
				<xsl:element name="{$name}">
					
					<xsl:element name="section">
						<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
						<xsl:attribute name="class" select="$name"/>
						<xsl:attribute name="id" select="concat($id-lead-text, $cid, '-', $name)"/>
						
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
								
								<xsl:element name="link">
									<xsl:attribute name="target" select="concat($id-lead-text, $cid, '-t', 'g')"/>
									<xsl:attribute name="class" select="'table-link'"/>
									
									<xsl:call-template name="process-string-variant">
										<xsl:with-param name="name" select="string('see-table')"/>
										<xsl:with-param name="case" select="string('lower')"/>
									</xsl:call-template>
									
								</xsl:element>
								
								<xsl:text disable-output-escaping="yes">). </xsl:text>
								
								<xsl:call-template name="process-string-variant">
									<xsl:with-param name="name" select="string('methods-performed-grade-evaluation-description')"/>
								</xsl:call-template>
								
							</xsl:if>
						</xsl:element>
						
						<!--<xsl:apply-templates select="p[not(strong) and not(preceding-sibling::p[strong])]" mode="para"/>
						<xsl:apply-templates select="key('para',generate-id())" mode="para"/>
						<xsl:apply-templates select="p[strong]" mode="para-title"/>-->
						
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:variable>
		
		<!-- then rebuild + order -->
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:element name="title">About this condition</xsl:element>
			
			<xsl:for-each select="$background-order/*">
				<xsl:variable name="name" select="name()"/>
				<xsl:if test="$background/node()[name()=$name][string-length(.)!=0]">
					<xsl:copy-of select="$background/node()[name()=$name]/*"/>
				</xsl:if>
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="question-list">
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<!--<xsl:element name="title">
				<xsl:value-of select="$glue-text/questions[contains(@lang, $lang)]"/>
			</xsl:element>-->
			
			<xsl:apply-templates select="question" />
			
			<xsl:if test="covered-elsewhere[string-length(normalize-space(.))!=0]">
				<xsl:apply-templates select="covered-elsewhere" mode="section-list"/>	
			</xsl:if>
			
			<xsl:if test="$bmjk-review-plan//info/future-issues[string-length(normalize-space(.))!=0]">
				<xsl:apply-templates select="$bmjk-review-plan//info/future-issues" mode="section-list"/>
			</xsl:if>
			
			<xsl:if test="/systematic-review/info/footnote[string-length(normalize-space(.))!=0]">
				<!--<xsl:apply-templates select="/systematic-review/info/footnote" mode="section-list" />-->
				
				<!--<xsl:element name="section">
					<xsl:attribute name="{concat($xmlns, ':oen')}" select="string('footnote')"/>
					<xsl:attribute name="class" select="string('footnote')"/>
					
					<xsl:element name="title">
						<xsl:value-of select="$glue-text//summary-footnote[contains(@lang, $lang)]"/>
					</xsl:element>
					
					<xsl:apply-templates select="/systematic-review/info/footnote/p"/>
					
				</xsl:element>-->
				
			</xsl:if>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="question">
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			<xsl:attribute name="id" select="concat($id-lead-text, generate-id(.))"/>
			
			<xsl:apply-templates select="title" mode="title"/>
			
			<xsl:element name="metadata">
				
				<xsl:comment>note: abridged-title can contain escaped inline markup</xsl:comment>
				
				<xsl:element name="key">
					<xsl:attribute name="{concat($xmlns, ':name')}" select="string('abridged-title')"/>
					<xsl:attribute name="value">
						<xsl:call-template name="process-abridged-title-escaped-markup">
							<xsl:with-param name="abridged-title" select="abridged-title" />
						</xsl:call-template>
					</xsl:attribute>
				</xsl:element>
				
			</xsl:element>
			
			<xsl:apply-templates select="xi:include"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="xi:include[contains(@href, 'option')]">
		
		<xsl:variable 
			name="iid" 
			select="
			concat(
			$id-lead-text, 
			$cid, 
			'-i', 
			replace(
			@href 
			, '^.*?[I\-](\d+).*?$'
			, '$1'))
			"/>
		
		<xsl:apply-templates select="document(concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@href, '../')),/)/option">
			<xsl:with-param name="iid" select="$iid" />
			<xsl:with-param name="xinclude-href" select="@href" />
		</xsl:apply-templates>
		
	</xsl:template>
	
	<xsl:template match="option">
		<xsl:param name="iid" />
		<xsl:param name="xinclude-href" />
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="string('option')"/>
			<xsl:attribute name="class" select="string('option')"/>
			<xsl:attribute name="id" select="$iid"/>
			
			<xsl:apply-templates select="title" mode="title"/>
			
			<xsl:element name="metadata">
				
				<xsl:if test="string-length($systematic-review-meta-input)!=0">
					<xsl:element name="key">
						<xsl:attribute name="{concat($xmlns, ':name')}" select="string('version-from-cms')"/>
						<xsl:attribute name="value" select="document(concat(translate($systematic-review-xml-input, '\\', '/'), 'meta/', substring-after($xinclude-href, '../')))/meta/version"/>
					</xsl:element>
				</xsl:if>
				
				<xsl:comment>note: abridged-title can contain escaped inline markup</xsl:comment>
				
				<xsl:element name="key">
					
					<xsl:attribute name="{concat($xmlns, ':name')}" select="string('abridged-title')"/>
					
					<!--<xsl:attribute name="value" select="normalize-space(abridged-title)"/>-->
					
					<xsl:attribute name="value">
						<xsl:call-template name="process-abridged-title-escaped-markup">
							<xsl:with-param name="abridged-title" select="abridged-title" />
						</xsl:call-template>
					</xsl:attribute>
					
				</xsl:element>
				
				<xsl:choose>
					
					<!--ADD: dedupe efficay used is only one type-->
					<xsl:when test="count(intervention-set/intervention) = 1">
						
						<xsl:comment>note: summary-title can contain escaped inline markup</xsl:comment>
						
						<xsl:element name="key">
							
							<xsl:attribute name="{concat($xmlns, ':name')}" select="string('summary-title')"/>
							
							<!--<xsl:attribute name="value" select="normalize-space(intervention-set/intervention/title)"/>-->
							
							<xsl:attribute name="value">
								<xsl:call-template name="process-abridged-title-escaped-markup">
									<xsl:with-param name="abridged-title" select="intervention-set/intervention/title" />
								</xsl:call-template>
							</xsl:attribute>
							
						</xsl:element>
						
						<xsl:element name="key">
							<xsl:attribute name="{concat($xmlns, ':name')}" select="string('intervention-efficacy')"/>
							<xsl:attribute name="value" select="intervention-set/intervention/@efficacy"/>
						</xsl:element>
						
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:processing-instruction name="split-interventions">
							<xsl:text>true</xsl:text>
						</xsl:processing-instruction>
					</xsl:otherwise>
					
				</xsl:choose>
				
				<!-- TODO: there can be more than one here so maybe we should take the highest status type 
				if we are in luck that editorial style puts these in order of strngth whti might be the first in order anyway -->
				<xsl:choose>
					
					<xsl:when test="substantive-change-set/substantive-change/@status[string-length(.)!=0 and .!='no-new-evidence']">
					    
					    <xsl:for-each select="substantive-change-set/substantive-change">

					        <xsl:if test="position()=1">
					        
					            <xsl:element name="key">
					                <xsl:attribute name="{concat($xmlns, ':name')}" select="'substantive-change-status'"/>
					                <xsl:attribute name="value" select="@status"/>
					            </xsl:element>
					            
					        </xsl:if>
					        
					    </xsl:for-each>
					    
					</xsl:when>
					
					<xsl:otherwise>
					    <xsl:element name="key">
					        <xsl:attribute name="{concat($xmlns, ':name')}" select="'substantive-change-status'"/>
					        <xsl:attribute name="value" select="'no-new-evidence'"/>
					    </xsl:element>
					</xsl:otherwise>
					
				</xsl:choose>
				
				<!--<xsl:element name="key">
					<xsl:attribute name="{concat($xmlns, ':name')}" select="'subject-group-question'"/>
					<xsl:attribute name="value" select="normalize-space(parent::question/abridged-title)"/>
					</xsl:element>-->
				
			</xsl:element>
			
			<xsl:if test="option-contributor[string-length(normalize-space(.))!=0]">
				
				<xsl:element name="p">
					<xsl:attribute name="{concat($xmlns, ':oen')}" select="'option-contributor'"/>
					<xsl:attribute name="class" select="'option-contributor'"/>
					<xsl:apply-templates select="option-contributor"/>
				</xsl:element>
				
			</xsl:if>
			
			
			<xsl:choose>
				
				<xsl:when test="comparison-set">
					
					<xsl:apply-templates select="intervention-set" mode="comparison-serial" />
					
					<xsl:apply-templates select="comparison-set" mode="comparisons-serial">
						<xsl:with-param name="iid" select="$iid" />
					</xsl:apply-templates>
					
					<xsl:apply-templates select="drug-safety-alert">
						<xsl:with-param name="iid" select="$iid" />
					</xsl:apply-templates>
					
					<xsl:apply-templates select="comment">
						<xsl:with-param name="iid" select="$iid" />
					</xsl:apply-templates>
					
					<xsl:apply-templates select="substantive-change-set"/>
					
				</xsl:when>
				
				<xsl:otherwise>
					
					<!-- over-arching statement -->
					<xsl:choose>
						
						<xsl:when test="summary-statement[string-length(normalize-space(.))!=0]">
							<xsl:apply-templates select="summary-statement" mode="section"/>
							<!--<xsl:apply-templates select="summary-statement" mode="split-text"/>-->
						</xsl:when>
						
						<xsl:when test="count(intervention-set/intervention) = 1">
							<xsl:apply-templates select="intervention-set/intervention/summary-statement" mode="section"/>
							<!--<xsl:apply-templates select="intervention-set/intervention/summary-statement" mode="split-text"/>-->
						</xsl:when>
						
					</xsl:choose>
					
					<!-- individual intervention statements -->
					<xsl:for-each select="intervention-set[count(intervention) &gt; 1]/intervention">
						
						<xsl:element name="section">
							
							<xsl:apply-templates select="title" mode="title"/>
							
							<xsl:element name="metadata">
								<xsl:element name="key">
									<xsl:attribute name="{concat($xmlns, ':name')}" select="'intervention-efficacy'"/>
									<xsl:attribute name="value" select="@efficacy"/>
								</xsl:element>
							</xsl:element>
							
							<xsl:apply-templates select="summary-statement" mode="section"/>
							<!--<xsl:apply-templates select="summary-statement" mode="split-text"/>-->
							
						</xsl:element>
						
					</xsl:for-each>
					
					<xsl:apply-templates select="benefits">
						<xsl:with-param name="iid" select="$iid" />
					</xsl:apply-templates>
					
					<xsl:apply-templates select="harms">
						<xsl:with-param name="iid" select="$iid" />
					</xsl:apply-templates>
					
					<xsl:apply-templates select="drug-safety-alert">
						<xsl:with-param name="iid" select="$iid" />
					</xsl:apply-templates>
					
					<xsl:apply-templates select="comment">
						<xsl:with-param name="iid" select="$iid" />
					</xsl:apply-templates>
					
					<xsl:apply-templates select="substantive-change-set"/>
					
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="intervention-set" mode="comparison-serial">
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="string('summary-statement')"/>
			<xsl:attribute name="class" select="string('key-points')"/>
			
			<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="string('key-points')"/>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:element name="list">
				
				<xsl:if test="$evidence-appraisal-grade-table = 'true'">
					
					<xsl:element name="li">
						
						<xsl:text>For </xsl:text>
						
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="string('grade')"/>
						</xsl:call-template>
						
						<xsl:text disable-output-escaping="yes"> </xsl:text>
						
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="string('evaluation-of-interventions')"/>
							<xsl:with-param name="case" select="string('lower')"/>
						</xsl:call-template>
						
						<xsl:text> for </xsl:text>
						
						<xsl:apply-templates select="$systematic-review-title" />
						
						<xsl:text>, </xsl:text>
						
						<xsl:element name="link">
							<xsl:attribute name="target" select="concat($id-lead-text, $cid, '-t', 'g')"/>
							<xsl:attribute name="class" select="'table-link'"/>
							
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="string('see-table')"/>
								<xsl:with-param name="case" select="string('lower')"/>
							</xsl:call-template>
							
						</xsl:element>
						
						<xsl:text>. </xsl:text>
						
					</xsl:element>
					
				</xsl:if>
				
				<xsl:apply-templates select="intervention" mode="comparison-serial" />
			</xsl:element>
		
		</xsl:element>
		
	</xsl:template>
				
	<xsl:template match="intervention" mode="comparison-serial">
		
		<xsl:for-each select="summary-statement">
			<xsl:element name="li">
				<xsl:apply-templates />
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>

	<!--special formatting control for mixed content in summary-statement-->
	<xsl:template match="summary-statement" mode="plain-text">
		
		<xsl:for-each select="node()">
			
			<xsl:choose>
				
				<xsl:when test="comment()">
					<xsl:comment select="."/>
				</xsl:when>
				
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
		
	</xsl:template>
	
	<xsl:template match="benefits | harms | comment">
		<xsl:param name="iid" />
		<xsl:variable name="name" select="name()" />
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="id" select="concat($iid, '-', name())"/>
			
			<xsl:element name="title">
				<xsl:value-of select="$glue-text/*[name()=$name][contains(@lang, $lang)]"/>
			</xsl:element>
			
			<!--<xsl:apply-templates select="p" />-->
			
			<xsl:apply-templates select="p[not(strong) and not(preceding-sibling::p[strong])]" mode="para" />
			<!--<xsl:key name="para" match="p[not(strong)]" use="generate-id((preceding-sibling::p[strong])[last()])" />-->
			<xsl:apply-templates select="key('para',generate-id())" mode="para" />
			<xsl:apply-templates select="p[strong]" mode="para-title" />
			
			<!-- put our sibling drug-safety-alert data inside our comment section -->
			<xsl:if test="name()='comment' and preceding-sibling::drug-safety-alert/p[2][string-length(normalize-space(.))!=0]">
				
				<xsl:element name="section">
					<xsl:attribute name="{concat($xmlns, ':oen')}" select="'drug-safety-alert'"/>
					<xsl:attribute name="class" select="'drug-safety-alert'"/>
					
					<xsl:element name="title">
						<xsl:value-of select="$glue-text/drug-safety-alert[contains(@lang, $lang)]"/>
					</xsl:element>
					
					<xsl:element name="p">
						<xsl:apply-templates select="preceding-sibling::drug-safety-alert/p[2]/node()"/>
					</xsl:element>
					
				</xsl:element>
				
			</xsl:if>
			
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="drug-safety-alert">
		<xsl:param name="iid" />
		<!-- do nothing as appended to comment section in previous template -->
	</xsl:template>
	
	<xsl:template match="substantive-change-set">
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:element name="title">
				<xsl:value-of select="$glue-text/substantive-changes[contains(@lang, $lang)]"/>
			</xsl:element>
			
			<!--<xsl:element name="metadata">
				<xsl:element name="key">
				<xsl:attribute name="{concat($xmlns, ':name')}" select="'status'"/>
				<xsl:choose>
				<xsl:when test="substantive-change/@status[string-length(.)!=0 and .!='no-new-evidence']">
				<xsl:attribute name="value" select="substantive-change[1]/@status"/>
				</xsl:when>
				<xsl:otherwise>
				<xsl:attribute name="value" select="'no-new-evidence'"/>
				</xsl:otherwise>
				</xsl:choose>
				</xsl:element>
				</xsl:element>-->
			
			<!--<xsl:comment select="'stats metatadata moved to option head level'"/>-->
			
			<xsl:choose>
			    
				<xsl:when test="substantive-change/@status[string-length(.)!=0 and .!='no-new-evidence']">
				    
				    <xsl:element name="p">
				        
				        <xsl:for-each select="substantive-change">
				            <xsl:apply-templates select="node()"/>
				            <xsl:text> </xsl:text>
				        </xsl:for-each>
				        
				    </xsl:element>				    
				    
				</xsl:when>
			    
				<xsl:otherwise>
				    
					<xsl:element name="p">
						<xsl:value-of select="$glue-text/no-new-evidence[contains(@lang, $lang)]"/>
						<xsl:text>.</xsl:text>
					</xsl:element>
				    
				</xsl:otherwise>
			    
			</xsl:choose>
		    
		</xsl:element>
		
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
			or @status='new-option']">
			
			<xsl:element name="section">
				<!-- <xsl:attribute name="{concat($xmlns, ':oen')}" select="string('substantive-change-list')"/> -->
				<xsl:attribute name="class" select="string('substantive-change-list')"/>
				
				<xsl:element name="title">
					<xsl:value-of select="$glue-text/substantive-changes[contains(@lang, $lang)]"/>
				</xsl:element>
				
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='new-option']">
					<xsl:sort select="option/title"/>
					
					<xsl:element name="p">
						
						<xsl:choose>
							
							<xsl:when test=".[string-length()!=0]">
								<xsl:apply-templates select="node()"/>
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:element name="strong">
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
					
					<xsl:element name="p">
						<xsl:apply-templates select="node()"/>
					</xsl:element>
					
				</xsl:for-each>
				
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='new-evidence-conclusions-changed']">
					<xsl:sort select="."/>
					
					<xsl:element name="p">
						<xsl:apply-templates select="node()"/>
					</xsl:element>
					
				</xsl:for-each>
				
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='no-new-evidence-substantial-error-corrected']">
					<xsl:sort select="."/>
					
					<xsl:element name="p">
						<xsl:apply-templates select="node()"/>
					</xsl:element>
					
				</xsl:for-each>
				
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='no-new-evidence-existing-evidence-reevaluated']">
					<xsl:sort select="."/>
					
					<xsl:element name="p">
						<xsl:apply-templates select="node()"/>
					</xsl:element>
					
				</xsl:for-each>
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
    
	<xsl:template name="process-glossary">
		
		<xsl:if test="$links//gloss-link">
			<!--<xsl:element name="section">
				<xsl:attribute name="{concat($xmlns, ':oen')}" select="'glossary'"/>
				<xsl:attribute name="class" select="'glossary'"/>
				
				<xsl:element name="title">
					<xsl:value-of select="$glue-text/glossary[contains(@lang, $lang)]"/>
				</xsl:element>-->
				
				<xsl:for-each select="$links//gloss-link">
					<xsl:sort select="document(concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../')))//term"/>
					
					<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
					<xsl:variable name="gloss" select="document($filename)/*"/>
					<xsl:variable name="generate-id" select="generate-id(.)"/>
					
					<xsl:element name="gloss">

						<xsl:for-each select="$links//gloss-link">
						    
							<xsl:if test="generate-id(.)=$generate-id">
								<xsl:attribute name="id" select="concat($id-lead-text, $cid, '-g', position())"/>
							</xsl:if>
						    
						</xsl:for-each>
						
						<xsl:choose>
						    
							<xsl:when test="$gloss//term[string-length(.)!=0]">
							    
								<xsl:element name="p">
									<xsl:attribute name="class" select="'term'"/>
								    
									<xsl:apply-templates select="$gloss//term"/>
								    
								</xsl:element>
							    
							</xsl:when>
						    
							<xsl:otherwise>
								<xsl:comment select="'term missing from source'"/>
							</xsl:otherwise>
						    
						</xsl:choose>
					    
						<!-- fix white space '<p class="definition"> The test...' -->
						<xsl:element name="p">
							<xsl:attribute name="class" select="'definition'"/>
						    
							<xsl:apply-templates select="$gloss//term/following-sibling::*"/>
						    
						</xsl:element>
					    
					</xsl:element>

				</xsl:for-each>
			
			<!--</xsl:element>-->
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="process-references">
		
		<xsl:if test="document(concat(translate($systematic-review-xml-input, '\\', '/'), substring-after($links//reference-link[1]/@target, '../')))/clinical-citation/node()[string-length(.)=0]">
			<xsl:processing-instruction name="references-available" select="string('false')"/>
		</xsl:if>
		
		<xsl:element name="references">
			
			<xsl:for-each select="$links//reference-link">
				<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
				<xsl:variable name="reference" select="document($filename)/*"/>
				
				<xsl:element name="reference">
					<xsl:attribute name="id" select="concat($id-lead-text, $cid, '-ref', position())"/>
					
					<xsl:element name="p">
						
						<xsl:apply-templates select="$reference//clinical-citation/node()"/>
						
						<xsl:if test="$reference//unique-id[@source='medline' and string-length(normalize-space(.))!=0]">
							
							<xsl:text disable-output-escaping="yes"> </xsl:text>
							
							<xsl:element name="link">
								<xsl:attribute name="class" select="'pubmed-link'"/>
								<xsl:attribute name="target" select="concat($pubmed-url, $reference//unique-id)"/>
								
								<xsl:text>[PubMed]</xsl:text>
								
							</xsl:element>
							
						</xsl:if>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:for-each>
			
			<xsl:if test="contains($components, 'references-excluded')">
				<xsl:call-template name="process-references-excluded"/>
			</xsl:if>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-references-excluded">
		
		<xsl:if test="count($references-excluded-matched/*) &gt; 0">
			
			<xsl:comment>
				<xsl:text>references-excluded not to be normally published add-on show references part of search but excluded for published review</xsl:text>
			</xsl:comment>
			
			<!--<xsl:element name="references">
				<xsl:attribute name="class" select="string('excluded')"/>-->
				
				<xsl:for-each select="$references-excluded-matched/*">
						
					<xsl:element name="reference">
						<xsl:attribute name="id" select="concat($id-lead-text, $cid, '-ref-exc', position())"/>
						<xsl:attribute name="class" select="string('excluded')"/>
						
						<xsl:element name="p">
							
							<xsl:apply-templates select=".//clinical-citation/node()"/>
							
							<xsl:if test=".//unique-id[@source='medline' and string-length(normalize-space(.))!=0]">
								
								<xsl:text disable-output-escaping="yes"> </xsl:text>
								
								<xsl:element name="link">
									<xsl:attribute name="class" select="'pubmed-link'"/>
									<xsl:attribute name="target" select="concat($pubmed-url, .//unique-id)"/>
									
									<xsl:text>[PubMed]</xsl:text>
									
								</xsl:element>
								
							</xsl:if>
							
						</xsl:element>
						
					</xsl:element>
						
				</xsl:for-each>
				
			<!--</xsl:element>-->
			
		</xsl:if>
			
	</xsl:template>

	<!--http://www.osix.net/modules/article/?id=586-->
	<xsl:template match="
		text()
		[(ancestor::clinical-citation
			or ancestor::drug-safety-alert)
		and not(parent::uri-link)
		and (contains(., 'http')
			or contains(., 'www'))]
		">
		<xsl:analyze-string select="."
			regex="((www|http)(\W+[^\p{{Zs}}]+)([^).,:;?\] \r\n$\p{{Pd}}]+))">
			<xsl:matching-substring>
				<xsl:element name="link">
					<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="'uri-link'"/>-->
					<xsl:attribute name="class" select="string('uri-link')"/>
					<xsl:attribute name="target">
						<xsl:value-of select="regex-group(1)"/>
					</xsl:attribute>
					<xsl:value-of select="regex-group(1)"/>
				</xsl:element>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>
	
	<xsl:template match="
		uri-link[string-length(normalize-space(@target))!=0]
		[(ancestor::clinical-citation
		or ancestor::drug-safety-alert)
		and (contains(., 'http')
		or contains(., 'www'))]
		">
		<xsl:analyze-string select="."
			regex="((www|http)(\W+[^\p{{Zs}}]+)([^).,:;?\] \r\n$\p{{Pd}}]+))">
			<xsl:matching-substring>
				<xsl:element name="link">
					<xsl:attribute name="{concat($xmlns, ':oen')}" select="'uri-link'"/>
					<xsl:attribute name="class" select="string('uri-link')"/>
					<xsl:attribute name="target">
						<xsl:value-of select="regex-group(1)"/>
					</xsl:attribute>
					<xsl:value-of select="regex-group(1)"/>
				</xsl:element>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>
	
	<xsl:template name="process-figures">
		
		<xsl:for-each select="$links//figure-link">
			<xsl:call-template name="process-figure">
				<xsl:with-param name="target" select="@target"/>
			</xsl:call-template>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-figure">
		<xsl:param name="target"/>
		<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after($target, '../'))"/>
		<xsl:variable name="figure" select="document($filename)/*"/>
		
		<xsl:element name="figure">
			<xsl:attribute name="id" select="concat($id-lead-text, $cid, '-f', position())"/>
			<!-- ../images/2004_figure_1_default.jpg -->
			<!-- note: let's try and keep image variant names -->
			<xsl:attribute name="image">
				<!--<xsl:value-of select="
					replace(
					$figure//image-link/@target 
					, '^(.+?)_default\.(.+?)$'
					, '$1.$2'
					)"/>-->
				<xsl:choose>
					<xsl:when test="$figure//image-link/@target[string-length(normalize-space(.))!=0]">
						<xsl:value-of select="$figure//image-link/@target"/>		
					</xsl:when>
					<xsl:otherwise>MISSING_LINK</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:element name="caption">
				<xsl:element name="p">
					<xsl:element name="inline">
						<xsl:attribute name="class">label</xsl:attribute>
						<xsl:text>Figure</xsl:text>
						<xsl:text disable-output-escaping="yes"> </xsl:text>
						<xsl:value-of select="position()"/>
						<xsl:text disable-output-escaping="yes"> </xsl:text>
					</xsl:element>
					<xsl:apply-templates select="$figure//caption"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
	</xsl:template>
	<xsl:template name="process-tables">
		
		<xsl:for-each select="$links//table-link">
			<xsl:call-template name="process-table">
				<xsl:with-param name="target" select="@target"/>
			</xsl:call-template>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-disclaimer">
		
		<xsl:element name="section">
			<xsl:attribute name="class" select="string('disclaimer')"/>
			
			<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="string('disclaimer')"/>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:element name="p">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="string('disclaimer-text')"/>
				</xsl:call-template>
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
</xsl:stylesheet>

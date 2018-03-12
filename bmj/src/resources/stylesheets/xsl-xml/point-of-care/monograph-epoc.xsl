<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
	version="2.0">

	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"
		use-character-maps="poc-custom-character-map isolat1-hexadecimal-character-entity-map"/>

	<xsl:strip-space elements="reference-link figure-link organism name drug related-topics"/>
	
	<xsl:param name="path"/>
	<xsl:param name="server"/>
	<xsl:param name="date"/>
	
	<xsl:param name="pubmed-url">http://www.ncbi.nlm.nih.gov/pubmed/</xsl:param>
	
	<xsl:include href="monograph-shared-reference-lists.xsl"/>
	<xsl:include href="../../xsl-entities/custom-map-point-of-care.xsl"/>
	<xsl:include href="../../xsl-lib/xinclude.xsl"/>
	
	<xsl:variable name="monograph-plan" select="document(//monograph-info/monograph-plan-link/@target)"/>

	<xsl:template match="/*[starts-with(name(), 'monograph')]">
		<xsl:variable name="name" select="translate(name(), '-', '_')"/>
		<xsl:element name="monographs">
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">http://schemas.epocrates.com/schemas/newdx_v1_6.xsd</xsl:attribute>
			<xsl:element name="{$name}">
				<xsl:attribute name="dx_id" select="@dx-id"/>
				<xsl:apply-templates select="*[name()!='evidence-scores'][name()!='figures']"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="monograph-info">
		
		<xsl:apply-templates select="title"/>
		<xsl:apply-templates select="$monograph-plan//monograph-info/authors"/>
		<xsl:apply-templates select="$monograph-plan//monograph-info/peer-reviewers"/>
		<xsl:apply-templates select="$monograph-plan//monograph-info/editors"/>
		<xsl:call-template name="process-version-history"/>
		<xsl:apply-templates select="topic-synonyms"/>
		<xsl:apply-templates select="related-topics[monograph-link]"/>
		
		<xsl:element name="references">
			
			<xsl:variable name="article-references">
				<xsl:element name="references">
					<xsl:element name="article-references">
						<xsl:call-template name="process-article-reference-links">
							<xsl:with-param name="item-count" select="1"/>
							<xsl:with-param name="link-index" select="1"/>
							<xsl:with-param name="link-count" select="count(//reference-link[@type='article']) + 1"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:variable>
			<xsl:if test="//reference-link[@type='article']">
				<xsl:apply-templates select="$article-references//article-references"/>
			</xsl:if>
			
			<xsl:variable name="online-references">
				<xsl:element name="references">
					<xsl:element name="online-references">
						<xsl:call-template name="process-online-reference-links">
							<xsl:with-param name="item-count" select="1"/>
							<xsl:with-param name="link-index" select="1"/>
							<xsl:with-param name="link-count" select="count(//reference-link[@type='online']) + 1"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:variable>
			<xsl:if test="//reference-link[@type='online']">
				<xsl:apply-templates select="$online-references//online-references"/>
			</xsl:if>
			
			<xsl:if test="//evidence-score-link">
				<xsl:apply-templates select="//evidence-scores"/>
			</xsl:if>
			
			<xsl:apply-templates select="//figures"/>
			
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="process-version-history">
		<xsl:element name="version_history">
			<xsl:element name="history">
				<xsl:element name="date">
					<xsl:value-of select="$date"/>
				</xsl:element>
				<xsl:element name="revised_by">
					<xsl:value-of select="'BMJ CMS'"/>
				</xsl:element>
				<xsl:element name="comments">
					<xsl:value-of select="'Last update'"/>
				</xsl:element>
				<xsl:element name="version">
					<xsl:value-of select="'99'"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	
	<!-- ###################################################### -->
	
	<xsl:template match="pt-group">
		<xsl:element name="pt_group">
			<xsl:apply-templates/>
		</xsl:element>
		<xsl:if test="parent::tx-option/parent::tx-options/parent::tx-option">
			<xsl:element name="parent_pt_group">
				<xsl:value-of select="parent::tx-option/parent::tx-options/parent::tx-option/pt-group"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="tx-option">
		<xsl:variable name="name" select="translate(name(), '-', '_')"/>
		<xsl:element name="{$name}">
			
			<!-- block attributes --> 
			<xsl:apply-templates select="monograph-link"/>
			<xsl:apply-templates select="@order"/>
			<xsl:apply-templates select="@common"/>
			<xsl:apply-templates select="@red-flag"/>
			<xsl:apply-templates select="@first"/>
			<!-- block elements -->
			<xsl:apply-templates select="factor-name"/>
			<xsl:apply-templates select="name"/>
			<xsl:apply-templates select="sign-symptoms"/>
			<xsl:apply-templates select="ddx-name"/>
			<xsl:apply-templates select="category"/>
			<xsl:apply-templates select="history"/>
			<xsl:apply-templates select="exam"/>
			<xsl:apply-templates select="tests"/>
			<xsl:apply-templates select="test"/>
			<xsl:apply-templates select="@likelihood" mode="force-to-element"/>
			<xsl:apply-templates select="@timeframe" mode="force-to-element"/>
			<xsl:apply-templates select="@type" mode="force-to-element"/>
			<xsl:apply-templates select="@strength" mode="force-to-element"/>
			<xsl:apply-templates select="pt-group"/>
			<xsl:apply-templates select="@tx-line" mode="force-to-element"/>
			<xsl:apply-templates select="tx-type"/>
			<xsl:apply-templates select="result"/>
			<xsl:apply-templates select="detail"/>
			<xsl:apply-templates select="comments"/>
			<xsl:apply-templates select="@frequency" mode="force-to-element"/>
			<xsl:apply-templates select="@key-factor" mode="force-to-element"/>
			<xsl:apply-templates select="regimens"/>
			
		</xsl:element>
		
		<!-- does the tx-option have children? -->
		<xsl:for-each select="tx-options/tx-option">
			<xsl:variable name="tx-id" select="@id"/>
			
			<!-- decide if child is a duplicate if not apply-templates -->
			<xsl:choose>
				<xsl:when test="(count(//tx-option[@id=$tx-id]) gt 1) and (following::tx-option[@id=$tx-id])">
					<!-- do nothing -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="."/>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:for-each>
		
	</xsl:template>
	
	<!-- ###################################################### -->
	
	<xsl:template match="reference-link[@type='article']">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="article-references">
			<xsl:element name="article-references">
				<xsl:element name="reference">
					<xsl:call-template name="process-article-reference-links">
						<xsl:with-param name="item-count" select="1"/>
						<xsl:with-param name="link-index" select="1"/>
						<xsl:with-param name="link-count" select="count(//reference-link[@type='article']) + 1"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:variable>
		<xsl:element name="foot">
			<xsl:for-each select="$article-references//reference">
				<xsl:if test="processing-instruction()[name()='target'] = $target">
					<xsl:attribute name="id_ref" select="processing-instruction()[name()='position']"/>
					<xsl:attribute name="type">reference</xsl:attribute>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="reference-link[@type='online']">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="online-references">
			<xsl:element name="online-references">
				<xsl:element name="reference">
					<xsl:call-template name="process-online-reference-links">
						<xsl:with-param name="item-count" select="1"/>
						<xsl:with-param name="link-index" select="1"/>
						<xsl:with-param name="link-count" select="count(//reference-link[@type='online']) + 1"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:variable>
		<xsl:element name="foot">
			<xsl:for-each select="$online-references//reference">
				<xsl:if test="processing-instruction()[name()='target'] = $target">
					<xsl:attribute name="id_ref" select="processing-instruction()[name()='position']"/>
					<xsl:attribute name="type">resource</xsl:attribute>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="evidence-score-link">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="target" select="@target"/>

		<xsl:for-each select="//evidence-score">
			<xsl:variable name="id" select="substring-after(preceding-sibling::comment()[1], 'including ')"/>
			<xsl:if test="$id = $target">
				<xsl:variable name="position-id" select="generate-id()"/>
				<xsl:for-each select="parent::*/*">
					<xsl:if test="generate-id()=$position-id">
						<xsl:element name="foot">
							<!--<xsl:attribute name="id_ref" select="processing-instruction()[name()='position']"/>-->
							<xsl:attribute name="id_ref" select="position()"/>
							<xsl:attribute name="type">evidence</xsl:attribute>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="figure-link">
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="inline" select="@inline"/>
		
		<xsl:if test="not(preceding-sibling::node()[not(self::text()[normalize-space(.)=''])][1][self::figure-link])">
			<xsl:text disable-output-escaping="yes">&lt;images&gt;</xsl:text>	
		</xsl:if>
		
		<xsl:for-each select="//figures/figure">
			<xsl:variable name="id" select="substring-after(preceding-sibling::comment()[1], 'including ')"/>
			
			<xsl:if test="$id = $target">
				<xsl:variable name="position-id" select="generate-id()"/>
				
				<xsl:for-each select="parent::*/*">
					
					<xsl:if test="generate-id() = $position-id">
						
						<!-- export thumb nail image if found in respositiory -->
						<!-- xsl:variable name="image-name" select="substring-after(image-link/@target, 'images/')"/>
						<xsl:variable name="image-path" select="concat(substring-before($path, 'monograph-plan'), 'monograph-images')"/>
						<xsl:if test="$server!='offline'">
							<xsl:processing-instruction name="thumb">
								<xsl:value-of select="legacytag:copyOverThumbImages($image-path ,$image-name)"/>
							</xsl:processing-instruction>
						</xsl:if -->
						
						<xsl:element name="image">
							<xsl:attribute name="id_ref" select="position()"/>
							<xsl:attribute name="inline" select="$inline"/>
						</xsl:element>
						
					</xsl:if>
					
				</xsl:for-each>
				
			</xsl:if>
		</xsl:for-each>
		
		<xsl:if test="not(following-sibling::node()[not(self::text()[normalize-space(.)=''])][1][self::figure-link])">
			<xsl:text disable-output-escaping="yes">&lt;/images&gt;</xsl:text>	
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="person-link">
		<xsl:apply-templates select="document(@target)/monograph-person/*"/>
	</xsl:template>
	
	<xsl:template match="article-references">
		<xsl:element name="article_refs">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="reference[parent::article-references]">
		<xsl:element name="article_ref">
			<xsl:attribute name="id">
				<xsl:value-of select="processing-instruction()[name()='position']"/>
			</xsl:attribute>
			<xsl:apply-templates select="poc-citation/@key-article"/>
			<xsl:apply-templates select="poc-citation/citation"/>	
			<xsl:if test="unique-id[@source='medline' and string-length(normalize-space(.))!=0]">
				<xsl:element name="abstract_url">
					<xsl:value-of select="concat($pubmed-url, unique-id)"/>
				</xsl:element>
			</xsl:if>
			<xsl:apply-templates select="poc-citation/fulltext-url"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="online-references">
		<xsl:element name="online_refs">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="reference[parent::online-references]">
		<xsl:element name="online_ref">
			<xsl:attribute name="id">
				<xsl:value-of select="processing-instruction()[name()='position']"/>
			</xsl:attribute>
			<xsl:apply-templates select="title"/>
			<xsl:apply-templates select="poc-citation/url"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="figures">
		<xsl:element name="image_refs">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="figure">
		<xsl:element name="image_ref">
			<xsl:variable name="position-id" select="generate-id()"/>
			<xsl:for-each select="parent::*/*">
				<xsl:if test="generate-id()=$position-id">
					<xsl:attribute name="id" select="position()"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="image-link">
				<xsl:variable name="target" select="@target"/>
				
				<!-- export thumb nail image if found in respositiory -->
				<!-- xsl:variable name="image-name" select="substring-after($target, 'images/')"/>
				<xsl:variable name="image-path" select="concat(substring-before($path, 'monograph-plan'), 'monograph-images')"/>
				<xsl:if test="$server!='offline'">
					<xsl:processing-instruction name="thumb">
						<xsl:value-of select="legacytag:copyOverThumbImages($image-path ,$image-name)"/>
					</xsl:processing-instruction>
				</xsl:if -->
				
				<xsl:element name="filename">
					
					<xsl:choose>
						<xsl:when test="contains(@target, '_default')">
							<xsl:value-of select="
								replace(
								substring-after(@target, 'images/'),
								'^(.*)_default(.*)$$', 
								'$1$2')
								"/>	
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-after(@target, 'images/')"/>
						</xsl:otherwise>
					</xsl:choose>
					
					<!-- note adding .jpg is just to help get images working with offline builds
						also note all images will not be jpeg type -->
					<xsl:choose>
						<xsl:when test="not(contains(@target, '.gif')) and contains(@target, 'iline')">
							<xsl:text>.gif</xsl:text>
						</xsl:when>
						<xsl:when test="not(contains(@target, '.jpg')) and not(contains(@target, 'iline'))">
							<xsl:text>.jpg</xsl:text>
						</xsl:when>
					</xsl:choose>
					
				</xsl:element>
			</xsl:for-each>
			
			<xsl:apply-templates select="caption"/>
			<xsl:apply-templates select="source"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="caption[parent::figure]">
		<xsl:element name="caption">
			<xsl:for-each select="node()">
				<xsl:choose>
					<xsl:when test="position()!=last()">
						<xsl:apply-templates select="self::node()"/>
					</xsl:when>
					<xsl:when test="position()=last() and self::text() and matches(self::node(), '^.*\. *$$')">
						<xsl:value-of select="replace(self::node(), '^(.*)\. *$$', '$1')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="self::node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="image-link[parent::author]">
		<xsl:element name="photo">
			<xsl:choose>
				<xsl:when test="contains(@target, '_default')">
					<xsl:value-of select="
						replace(
						substring-after(@target, 'images/'),
						'^(.*)_default(.*)$$', 
						'$1$2')
						"/>	
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-after(@target, 'images/')"/>
				</xsl:otherwise>
			</xsl:choose>
			<!-- note adding .jpg is just to help get images working with offline builds
				also note all images will not be jpeg type -->
			<xsl:choose>
				<xsl:when test="not(contains(@target, '.gif')) and contains(@target, 'iline')">
					<xsl:text>.gif</xsl:text>
				</xsl:when>
				<xsl:when test="not(contains(@target, '.jpg')) and not(contains(@target, 'iline'))">
					<xsl:text>.jpg</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="evidence-scores">
		<xsl:element name="clinical_refs">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="evidence-score">
		
		<xsl:variable name="position-id" select="generate-id()"/>
		<xsl:for-each select="parent::*/*">
			<xsl:if test="generate-id()=$position-id">
				<xsl:element name="clinical_ref">
					<xsl:attribute name="id" select="position()" />
					
					<xsl:apply-templates select="@score" mode="force-to-element"/>
					<xsl:apply-templates select="comments"/>
					
					<xsl:if test="option-link/@target[string-length(.)!=0]">
						<xsl:variable name="target" select="option-link/@target"/>
						
						<!-- get topic id -->
						<xsl:variable name="topicid" select="legacytag:getSystematicReviewId($target)"/>
						
						<!-- get option id -->
						<xsl:variable name="optionid">
							<xsl:choose>
								<!-- old option file name '../options/_op0203_I5.xml' -->
								<xsl:when test="contains($target,'_op')">
									<xsl:text>I</xsl:text>
									<xsl:value-of select="substring-before((substring-after($target, 'I')),'.xml')"/>
								</xsl:when>
								<!-- new option file name '../options/option-1194864898395.xml' -->
								<xsl:otherwise>
									<xsl:text>I</xsl:text>
									<xsl:value-of select="substring-before((substring-after($target, '-')),'.xml')"/>
								</xsl:otherwise>
							</xsl:choose>	
						</xsl:variable>
						
						<xsl:element name="bmj_url">
							<xsl:text>http://clinicalevidence.bmj.com/ceweb/conditions/abc/</xsl:text>
							<xsl:value-of select="$topicid"/>
							<xsl:text>/</xsl:text>
							<xsl:value-of select="concat($topicid, '_', $optionid)"/>
							<xsl:text>.jsp</xsl:text>
						</xsl:element>
						
					</xsl:if>
					
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template 
		match="
		factor | 
		test[parent::tests] | 
		risk-factor | 
		differential | 
		complication | 
		subtype |
		tests[parent::differential and ancestor::monograph-eval]
		">
		<xsl:variable name="name" select="translate(name(), '-', '_')"/>
		<xsl:element name="{$name}">

			<!-- block attributes --> 
			<xsl:apply-templates select="monograph-link"/>
			<xsl:apply-templates select="@order"/>
			<xsl:apply-templates select="@common"/>
			<xsl:apply-templates select="@red-flag"/>
			<xsl:apply-templates select="@first"/>
			<!-- block elements -->
			<xsl:apply-templates select="factor-name"/>
			<xsl:apply-templates select="name"/>
			<xsl:apply-templates select="sign-symptoms"/>
			<xsl:apply-templates select="ddx-name"/>
			<xsl:apply-templates select="category"/>
			<xsl:apply-templates select="history"/>
			<xsl:apply-templates select="exam"/>
			<xsl:apply-templates select="tests"/>
			<xsl:apply-templates select="test"/>
			<xsl:apply-templates select="@likelihood" mode="force-to-element"/>
			<xsl:apply-templates select="@timeframe" mode="force-to-element"/>
			<xsl:apply-templates select="@type" mode="force-to-element"/>
			<xsl:apply-templates select="@strength" mode="force-to-element"/>
			<xsl:apply-templates select="pt-group"/>
			<xsl:apply-templates select="@tx-line" mode="force-to-element"/>
			<xsl:apply-templates select="tx-type"/>
			<xsl:apply-templates select="result"/>
			<xsl:apply-templates select="detail"/>
			<xsl:apply-templates select="comments"/>
			<xsl:apply-templates select="@frequency" mode="force-to-element"/>
			<xsl:apply-templates select="@key-factor" mode="force-to-element"/>
			<xsl:apply-templates select="regimens"/>
			
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="monograph-link[parent::related-topics]">
		<xsl:choose>
			<xsl:when test="contains(@target, '../')">
				<xsl:variable name="mono-doc" select="document(concat($path, '/', @target))"/>
				<xsl:element name="related_topic">
					<xsl:attribute name="dx_id" select="$mono-doc/node()/@dx-id"/>
					<xsl:value-of select="$mono-doc/node()/monograph-info/title"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="file-type" select="/node()/name()"/>
				<xsl:choose>
					<xsl:when test="$file-type = 'monograph-eval'">
						<xsl:variable name="mono-doc" select="document(concat($path, '/', '../monograph-evaluation/',@target))"/>
						<xsl:element name="related_topic">
							<xsl:attribute name="dx_id" select="$mono-doc/node()/@dx-id"/>
							<xsl:value-of select="$mono-doc/node()/monograph-info/title"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$file-type = 'monograph-generic'">
						<xsl:variable name="mono-doc" select="document(concat($path, '/', '../monograph-generic/',@target))"/>
						<xsl:element name="related_topic">
							<xsl:attribute name="dx_id" select="$mono-doc/node()/@dx-id"/>
							<xsl:value-of select="$mono-doc/node()/monograph-info/title"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$file-type = 'monograph-overview'">
						<xsl:variable name="mono-doc" select="document(concat($path, '/', '../monograph-overview/',@target))"/>
						<xsl:element name="related_topic">
							<xsl:attribute name="dx_id" select="$mono-doc/node()/@dx-id"/>
							<xsl:value-of select="$mono-doc/node()/monograph-info/title"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$file-type = 'monograph-full'">
						<xsl:variable name="mono-doc" select="document(concat($path, '/', '../monograph-standard/',@target))"/>
						<xsl:element name="related_topic">
							<xsl:attribute name="dx_id" select="$mono-doc/node()/@dx-id"/>
							<xsl:value-of select="$mono-doc/node()/monograph-info/title"/>
						</xsl:element>
					</xsl:when>
				</xsl:choose>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="monograph-link[not(parent::related-topics)]">
		<xsl:choose>
			<xsl:when test="contains(@target, '../')">
				<xsl:variable name="mono-doc" select="document(concat($path, '/', @target))"/>
				<xsl:attribute name="dx_id" select="$mono-doc/node()/@dx-id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="file-type" select="/node()/name()"/>
				<xsl:choose>
					<xsl:when test="$file-type = 'monograph-eval'">
						<xsl:variable name="mono-doc" select="document(concat($path, '/', '../monograph-evaluation/',@target))"/>
						<xsl:attribute name="dx_id" select="$mono-doc/node()/@dx-id"/>
					</xsl:when>
					<xsl:when test="$file-type = 'monograph-generic'">
						<xsl:variable name="mono-doc" select="document(concat($path, '/', '../monograph-generic/',@target))"/>
						<xsl:attribute name="dx_id" select="$mono-doc/node()/@dx-id"/>
					</xsl:when>
					<xsl:when test="$file-type = 'monograph-overview'">
						<xsl:variable name="mono-doc" select="document(concat($path, '/', '../monograph-overview/',@target))"/>
						<xsl:attribute name="dx_id" select="$mono-doc/node()/@dx-id"/>
					</xsl:when>
					<xsl:when test="$file-type = 'monograph-full'">
						<xsl:variable name="mono-doc" select="document(concat($path, '/', '../monograph-standard/',@target))"/>
						<xsl:attribute name="dx_id" select="$mono-doc/node()/@dx-id"/>
					</xsl:when>
				</xsl:choose>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="processing-instruction()[name()='broken-link'][parent::related-topics]">
		<!-- TODO: find title with javaclass -->
		<!--<xsl:element name="related_topic">
			<xsl:attribute name="dx_id" select="."/>
			<xsl:comment select="string('broken-link recovered')" />
		</xsl:element>-->
	</xsl:template>
	
	<xsl:template match="processing-instruction()[name()='broken-link'][not(parent::related-topics)]">
		<!--<xsl:attribute name="dx_id" select="." />-->
	</xsl:template>
	
	<xsl:template match="recommendations">
		<xsl:element name="recomendations">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="drug">
		<xsl:value-of select="."/>
		<xsl:if test="following-sibling::node()[not(self::text()[normalize-space(.)=''])][1][self::drug]">
			<!--<xsl:comment>white space forced here</xsl:comment>-->
			<xsl:text disable-output-escaping="yes"> </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tx-type">
		<xsl:element name="tx_type"><xsl:value-of select="normalize-space(.)"/></xsl:element>
	</xsl:template>
	
	<xsl:template 
		match="
		notes | 
		@xsi:noNamespaceSchemaLocation | 
		@displayable[parent::synonym] | 
		@region[parent::guideline] | 
		@*[.='unset'] | 
		@xml:base | 
		synonym[string-length(.)=0] |
		related-patient-summaries | 
		patient-summary-link
		">
		<!-- do nothing -->
	</xsl:template>

	<xsl:template match="*">
		<xsl:variable name="name" select="translate(name(), '-', '_')"/>
		<xsl:element name="{$name}">
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<!-- remove unneeded ids -->
	<!-- xsl:template match="@id"/ -->
	
	
	<xsl:template match="@*" mode="force-to-element">
		<xsl:variable name="name" select="translate(name(), '-', '_')"/>
		<xsl:choose>
			<xsl:when test=".!='unset'">
				<xsl:element name="{$name}">
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<!-- do nothing -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="@*">
		<xsl:variable name="name" select="translate(name(), '-', '_')"/>
		<xsl:attribute name="{$name}" select="."/>
	</xsl:template>

	<xsl:template match="guidelines[ancestor::monograph-eval or ancestor::monograph-generic]"/>
</xsl:stylesheet>

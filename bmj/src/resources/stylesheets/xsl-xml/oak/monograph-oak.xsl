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

	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"
		/>
	
	<!--<xsl:strip-space elements=""/>-->
	
	<xsl:param name="lang"/>
	<xsl:param name="xmlns"/>
	<xsl:param name="path"/>
	<xsl:param name="server"/>
	<xsl:param name="date-amended"/>
	<xsl:param name="date-updated"/>
	<xsl:param name="components"/>
	<xsl:param name="strings-variant-fileset"/>
	
	<xsl:param name="prompt-separator">
		<xsl:element name="inline">
			<xsl:attribute name="class">prompt</xsl:attribute>
			<!--<xsl:text disable-output-escaping="yes">&#x9;</xsl:text>-->
			<xsl:text disable-output-escaping="yes"> - </xsl:text>
		</xsl:element>
	</xsl:param>
	<xsl:param name="exclamation">
		<xsl:element name="inline">
			<xsl:attribute name="class">exclamation</xsl:attribute>
			<xsl:text disable-output-escaping="yes">!</xsl:text>
		</xsl:element>
	</xsl:param>
	
	<xsl:param name="pubmed-url">http://www.ncbi.nlm.nih.gov/pubmed/</xsl:param>
	<xsl:param name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝ'"/>
	<xsl:param name="lower" select="'abcdefghijklmnopqrstuvwxyzáâãäåæçèéêëìíîïðñòóôõöøùúûüý'"/>

	<xsl:include href="../../xsl-lib/xinclude.xsl"/>
	<xsl:include href="../../xsl-lib/strings/publication-labels-process-shared.xsl"/>
	
	<xsl:include href="monograph-shared-reference-lists.xsl"/>
	<xsl:include href="monograph-shared-outline-match.xsl"/>
	<xsl:include href="monograph-oak-outline-output.xsl"/>
	<xsl:include href="monograph-oak-standard-treatment-option.xsl"/>
	<!--<xsl:include href="monograph-oak-standard-treatment-option-summary.xsl"/>-->
	<xsl:include href="monograph-oak-evaluation-differential.xsl"/>
	<xsl:include href="monograph-oak-inline-elements.xsl"/>
	
	<!--<xsl:template match="/*" priority="1">
		<xsl:apply-templates mode="annotate"/>
	</xsl:template>-->

	<xsl:template match="authors | peer-reviewers | editors">
		<xsl:variable name="name" select="name()"/>
		<xsl:element name="person-group">
			<xsl:attribute name="class" select="$name"/>
			<xsl:for-each select="person-link">
				<xsl:variable name="filename" select="concat($path, '/', @target)"/>
				<xsl:apply-templates select="document($filename)/monograph-person/node()"/>	
			</xsl:for-each>
			<xsl:element name="notes">
				<xsl:for-each select="person-link">
					<xsl:variable name="filename" select="concat($path, '/', @target)"/>
					<xsl:if test="document($filename)//disclosures[string-length(normalize-space(.))!=0]">
						<xsl:element name="p">
							<xsl:apply-templates select="document($filename)//disclosures[string-length(normalize-space(.))!=0]/node()"/>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>				
			</xsl:element>
		</xsl:element>
		
		<!-- include author photo's -->
		<xsl:if test="person-link[parent::authors and document(concat($path, '/', @target))]//author//image-link[string-length(normalize-space(.))!=0]">
			<xsl:element name="section">
				<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
				<xsl:attribute name="class">author-photos</xsl:attribute>
				<xsl:for-each select="person-link[parent::authors]">
					
					<xsl:variable name="filename" select="concat($path, '/', @target)"/>
					<xsl:variable name="author" select="document($filename)//author"/>
					<xsl:element name="figure">
						<xsl:apply-templates select="$author//image-link"/>
						<xsl:element name="caption">
							<xsl:apply-templates select="$author//name/node()"/>
							<xsl:text disable-output-escaping="yes"> </xsl:text>
							<xsl:apply-templates select="$author//degree/node()"/>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="author | peer-reviewer | editor">
		<xsl:variable name="person-id" select="concat(name(), '-', position())"/>
		<xsl:element name="person">
			<xsl:element name="given-names">
				<xsl:apply-templates select="name/node()"/>
			</xsl:element>
			<xsl:element name="family-names"/>
			<!--<xsl:element name="honorific"/>-->
			<!--<xsl:element name="prefix"/>-->
			<!--<xsl:element name="suffix"/>-->
			<!--<xsl:element name="role"/>-->
			<xsl:element name="address">
				<xsl:for-each select="title-affil/para">
					<xsl:element name="p">
						<xsl:apply-templates />
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<!-- documentinfo property -->
	<xsl:template match="deadline-date">
		<xsl:variable name="name" select="name()"/>
		<xsl:element name="property">
			<xsl:attribute name="name" select="$name"/>
			<xsl:attribute name="value" select="."/>
			<xsl:attribute name="type">date</xsl:attribute>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="section">
		<xsl:variable name="name" select="name()"/>
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="section-header">
		<xsl:element name="title">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="section-text">
		<xsl:apply-templates />
	</xsl:template>
	
	<!-- our stylesheet might get confused which namespace to match 
		for variable content passed back with apply-templates --> 
	<xsl:template match="*:figures">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="figure">
		<xsl:element name="figure">
			<xsl:attribute name="id">
				<xsl:text>fig</xsl:text>
				<xsl:value-of select="processing-instruction()[name()='position']"/>
			</xsl:attribute>
			<xsl:apply-templates select="image-link"/>
			<xsl:apply-templates select="caption"/>
			<!--<xsl:apply-templates select="source"/>-->
		</xsl:element>					
	</xsl:template>
	
	<xsl:template match="figure" mode="inline">
		<xsl:element name="figure">
			<xsl:apply-templates select="image-link"/>
			<xsl:apply-templates select="caption"/>
			<!--<xsl:apply-templates select="source"/>-->
		</xsl:element>					
	</xsl:template>
	
	<xsl:template match="image-link">
		
		<xsl:attribute name="image">
			<xsl:text>../images/</xsl:text>
			<xsl:value-of select="substring-after(@target, 'images/')"/>
			<!--<xsl:if test="parent::figure/parent::figures">
				<xsl:text>-tn</xsl:text>
			</xsl:if>-->
			<!-- note adding .jpg is just to help get images working with offline builds
			also note all images will not be jpeg type -->
			<!-- xsl:choose>
				<xsl:when test="not(contains(@target, '.gif')) and contains(@target, 'iline')">
					<xsl:text>.gif</xsl:text>
				</xsl:when>
				<xsl:when test="not(contains(@target, '.jpg')) and not(contains(@target, 'iline'))">
					<xsl:text>.jpg</xsl:text>
				</xsl:when>
			</xsl:choose -->
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="caption">
		<xsl:element name="caption">
			<xsl:element name="p">
				<xsl:apply-templates/>
			</xsl:element>
			<xsl:if test="following-sibling::source">
				<xsl:element name="p">
					<xsl:element name="inline">
						<xsl:attribute name="class" select="string('prompt')" />
						<xsl:text>Source:</xsl:text>
					</xsl:element>
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:apply-templates select="following-sibling::source/node()" />
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	
	<!--<xsl:template match="evidence-score">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="position-id" select="generate-id()"/>
		<xsl:for-each select="parent::*/*">
			<xsl:if test="generate-id()=$position-id">
				<xsl:element name="{name()}">
					<xsl:attribute name="id" select="position()" />
					<xsl:attribute name="score" select="@score"/>
					<xsl:apply-templates/>	
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>-->
	
	<xsl:template match="*:evidence-score">
		<xsl:variable name="position-id" select="generate-id()"/>
		<xsl:element name="li">
			<!--<xsl:value-of select="processing-instruction()[name()='position']"/>-->
			<xsl:for-each select="parent::*/*">
				<xsl:if test="generate-id()=$position-id">
					<xsl:attribute name="id">
						<xsl:text>evid</xsl:text>
						<xsl:value-of select="position()" />
					</xsl:attribute>
				</xsl:if>
			</xsl:for-each>
				<xsl:for-each select="parent::*/*">
					<xsl:if test="generate-id()=$position-id">
						<xsl:element name="inline">
							<!--<xsl:attribute name="class">prompt</xsl:attribute>-->
							<xsl:text>[</xsl:text>
							<xsl:text>e</xsl:text>
							<xsl:value-of select="position()" />
							<xsl:text>]</xsl:text>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="comments/node()"/>
			<xsl:value-of select="$prompt-separator"/>
			<!--TODO bmj-url or option-link??-->
			<xsl:if test="option-link">
				<xsl:element name="inline">
					<xsl:attribute name="class">prompt</xsl:attribute>
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('option-link')"/>
					</xsl:call-template>
					<xsl:text>: </xsl:text>
				</xsl:element>
				<xsl:element name="link">
					<xsl:attribute name="target" select="@target"/>
					<xsl:text>[</xsl:text>
					<xsl:text>link</xsl:text>
					<xsl:text>]</xsl:text>
				</xsl:element>
				<xsl:value-of select="$prompt-separator"/>
			</xsl:if>
			<xsl:apply-templates select="@score"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="reference[parent::*:key-article-references]">
		<xsl:element name="li">
			<xsl:apply-templates select="poc-citation/citation/node()"/>
			<xsl:if test="unique-id[@source='medline' and string-length(normalize-space(.))!=0]">
				<xsl:element name="link">
					<xsl:attribute name="target" select="concat($pubmed-url, unique-id)"/>
					<xsl:text>[</xsl:text>
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('abstract-url')"/>
					</xsl:call-template>
					<xsl:text>]</xsl:text>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="reference[parent::*:online-references]">
		<xsl:element name="li">
			<xsl:attribute name="id">
				<xsl:text>web</xsl:text>
				<xsl:value-of select="processing-instruction()[name()='position']"/>
			</xsl:attribute>
			<xsl:element name="inline">
				<!--<xsl:attribute name="class">prompt</xsl:attribute>-->
				<xsl:text>[</xsl:text>
				<xsl:text>w</xsl:text>
				<xsl:value-of select="processing-instruction()[name()='position']"/>
				<xsl:text>]</xsl:text>
			</xsl:element>
			<xsl:text disable-output-escaping="yes"> </xsl:text>
			<xsl:element name="link">
				<xsl:attribute name="target" select="poc-citation/url"/>
				<xsl:apply-templates select="title/node()"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="*:combined-references | *:article-references">
		<xsl:element name="references">
			<xsl:attribute name="class" select="name()"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="reference[parent::*:article-references]">
		<xsl:element name="reference">
			<xsl:attribute name="id">
				<xsl:text>ref</xsl:text>
				<xsl:value-of select="processing-instruction()[name()='position']"/>
			</xsl:attribute>
			<xsl:if test="unique-id[@source='medline' and string-length(normalize-space(.))!=0]">
				<xsl:attribute name="pubmed-id" select="normalize-space(unique-id)" />
			</xsl:if>
			<xsl:element name="p">
				<xsl:apply-templates select="poc-citation/citation/node()"/>
				<xsl:if test="unique-id[@source='medline' and string-length(normalize-space(.))!=0]">
					<xsl:element name="link">
						<xsl:attribute name="target" select="concat($pubmed-url, unique-id)"/>
						<xsl:text>[</xsl:text>
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="string('abstract-url')"/>
						</xsl:call-template>
						<xsl:text>]</xsl:text>
					</xsl:element>
				</xsl:if>
				<xsl:if test="poc-citation/fulltext-url[string-length(normalize-space(.))!=0]">
					<xsl:element name="link">
						<xsl:attribute name="target" select="normalize-space(poc-citation/fulltext-url)"/>
						<xsl:text>[</xsl:text>
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="string('fulltext-url')"/>
						</xsl:call-template>
						<xsl:text>]</xsl:text>
					</xsl:element>
				</xsl:if>
			</xsl:element>
		</xsl:element>					
	</xsl:template>
	
	<!-- para prompt _not_ enumerated -->
	<xsl:template match="
		source[parent::guideline] | 
		last-published | 
		tx-type | 
		parent-pt-group | 
		pt-group | 
		category | 
		result
		"><!--source[parent::figure] |-->
		<xsl:variable name="name" select="name()" />
		<xsl:element name="section">
			<xsl:attribute name="class" select="$name"/>
			<xsl:element name="p">
				<xsl:element name="inline">
					<xsl:attribute name="class">prompt</xsl:attribute>
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="$name"/>
					</xsl:call-template>
					<xsl:text>: </xsl:text>
				</xsl:element>
				<xsl:apply-templates />
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="url[parent::guideline]">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="p">
			<xsl:element name="link">
				<xsl:attribute name="target">
					<xsl:value-of select="."/>
				</xsl:attribute>
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="string('guideline-url')"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<!-- inline prompt -->
	<!-- ??NOTE removed @strength |@order | @key-factor are now being managed to group section -->
	<xsl:template match="
		@id | 
		@dx-id | 
		@tier | 
		@score | 
		@likelihood | 
		@modifier | 
		@tx-line | 
		@frequency |  
		@timeframe[parent::complication] | 
		@timeframe[parent::tx-option] | 
		@type[parent::poc-citation] | 
		@key-article | 
		@common | 
		@red-flag | 
		@first | 
		@strength |
		@order | 
		@key-factor 
		"> 
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline">
			<xsl:attribute name="class">prompt</xsl:attribute>
			<xsl:call-template name="process-string-variant">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline">
			<xsl:attribute name="class" select="$name"/>
			<xsl:value-of select="."/>
			<xsl:text disable-output-escaping="yes"> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="
		@type[parent::test] | 
		@type[parent::factor]  
		"> 
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline">
			<xsl:attribute name="class">hint-prompt</xsl:attribute>
			<xsl:call-template name="process-string-variant">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline">
			<xsl:attribute name="class">hint</xsl:attribute>
			<xsl:value-of select="."/>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- dev output test -->
	<xsl:template match="element()|@*">
		<xsl:comment select="concat('unmatched-', name())"/>
	</xsl:template>
	
</xsl:stylesheet>

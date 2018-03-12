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

	<xsl:output
		method="xml"
		version="1.0"
		encoding="UTF-8"
		indent="yes"
		use-character-maps="custom-map-renderx"
	/>
	<!--doctype-public="-//BMJ//DTD FO:ROOT//EN"
	doctype-system="http://www.renderx.com/Tests/validator/fo2000.dtd"-->
	
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
	<xsl:param name="inc-exc-xml-input"/>
	<xsl:param name="images-input"/>
	<xsl:param name="date"/>
	<xsl:param name="strings-variant-fileset"/>
	
	<xsl:include href="../../generic-params.xsl"/>
	<xsl:include href="../../systematic-review-params.xsl"/>
	<xsl:include href="../../xsl-entities/custom-map-renderx.xsl"/>
	<xsl:include href="../generic-fo-fonts.xsl"/>
	<xsl:include href="../generic-fo-page-sizes.xsl"/>
	
	<xsl:include href="../../xsl-lib/strings/publication-labels-process-shared.xsl"/>
	
	<xsl:include href="systematic-review-fo-params.xsl"/>
	<xsl:include href="systematic-review-fo-reference-range.xsl"/>
	<xsl:include href="systematic-review-fo-layout.xsl"/>
	
	<xsl:variable name="links" select="document($links-xml-input)/*"/>
	<xsl:variable name="cid" select="substring-after(/systematic-review/@id, '_')"/>
	<xsl:variable name="bmjk-review-plan" select="document(/systematic-review/info/bmjk-review-plan-link/@target)/*"/>
	<xsl:variable name="primary-section-title" select="document($bmjk-review-plan//info/section-list/section-link[1]/@target)//title"/>
	
	<xsl:template match="/">
		
		<xsl:element name="fo:root" use-attribute-sets="root">
			
			<xsl:call-template name="process-layout-master-set"/>
			
			<xsl:element name="fo:page-sequence" use-attribute-sets="">
				<xsl:attribute name="master-reference">my-sequence</xsl:attribute>

				<xsl:element name="fo:flow" use-attribute-sets="flow">
					<xsl:attribute name="flow-name">xsl-region-body</xsl:attribute>
					
					<!-- add: inc. peer-review, author, etc. ? -->

					<!--xsl:element name="fo:block" use-attribute-sets="">
						<xsl:attribute name="id">first-page</xsl:attribute>
					</xsl:element-->

					<xsl:element name="fo:block" use-attribute-sets="space-after">
						
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
					</xsl:element>
					
					<xsl:if test="contains($components, 'references')">
						<xsl:call-template name="process-references"/>
					</xsl:if>
					
				</xsl:element>
		</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="process-references">
		<xsl:comment>references</xsl:comment>
		<xsl:choose>
			<xsl:when test="$links//reference-link != ''">
				<xsl:element name="fo:block" use-attribute-sets="strong color-blue large keep-with-next">
					EXCLUDED <xsl:value-of select="translate($glue-text/references[contains(@lang, $lang)], $lower, $upper)"/>
				</xsl:element>
				<xsl:element name="fo:block" use-attribute-sets="">
					<xsl:for-each select="$links//reference-link">
						<xsl:element name="fo:list-block" use-attribute-sets="space-after-tiny">
							<fo:list-item>
								<fo:list-item-label end-indent="15pt">
									<xsl:element name="fo:block" use-attribute-sets="small">
										<xsl:attribute name="id" select="concat($cid, '_REF', position())"/>
										<xsl:value-of select="position()"/>
										<xsl:text>.</xsl:text>
									</xsl:element>
								</fo:list-item-label>
								<fo:list-item-body start-indent="15pt">
									<xsl:element name="fo:block" use-attribute-sets="small">
										<xsl:apply-templates select="clinical-citation"/>
										<xsl:if test="unique-id[@source='medline']">
											<xsl:element name="fo:basic-link">
												<xsl:attribute name="external-destination">
													<xsl:text>url('</xsl:text>
													<xsl:value-of select="$pubmed-url"/>
													<xsl:value-of select="unique-id"/>
													<xsl:text>')</xsl:text>
												</xsl:attribute>
												<xsl:element name="fo:inline" use-attribute-sets="link">
													<xsl:text>[PubMed]</xsl:text>
												</xsl:element>
											</xsl:element>
										</xsl:if>
									</xsl:element>
								</fo:list-item-body>
							</fo:list-item>
						</xsl:element>						
					</xsl:for-each>
				</xsl:element>				
			</xsl:when>
		
			<xsl:otherwise>
				<xsl:element name="fo:block" use-attribute-sets="strong color-blue large keep-with-next">
					No excluded reference
				</xsl:element>
				</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>

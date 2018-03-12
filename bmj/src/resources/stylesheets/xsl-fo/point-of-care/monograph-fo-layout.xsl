<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	exclude-result-prefixes="rx xi xsi cals"
	version="2.0">
	
	<xsl:template name="do-layout-master-set">
	
		<xsl:comment>layout-master-set</xsl:comment>
		
		<xsl:element name="fo:layout-master-set" use-attribute-sets="">
		
			<xsl:element name="fo:simple-page-master" use-attribute-sets="page-margin">
				<xsl:attribute name="master-name">first-page</xsl:attribute>
				<xsl:element name="fo:region-body" use-attribute-sets="body-margin">
					<xsl:attribute name="region-name">xsl-region-body</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-before" use-attribute-sets="">
					<xsl:attribute name="region-name">first-header</xsl:attribute>
					<xsl:attribute name="extent">0pt</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-after" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">first-footer</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-start" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-left</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-end" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-right</xsl:attribute>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:simple-page-master" use-attribute-sets="page-margin">
				<xsl:attribute name="master-name">all-pages</xsl:attribute>
				<xsl:element name="fo:region-body" use-attribute-sets="body-margin">
					<xsl:attribute name="region-name">xsl-region-body</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-before" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-header</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-after" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-footer</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-start" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-left</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-end" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-right</xsl:attribute>
				</xsl:element>
			</xsl:element>

			<xsl:element name="fo:page-sequence-master" use-attribute-sets="">
				<xsl:attribute name="master-name">my-sequence</xsl:attribute>
				<xsl:element name="fo:single-page-master-reference" use-attribute-sets="">
					<xsl:attribute name="master-reference">first-page</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:repeatable-page-master-reference" use-attribute-sets="">
					<xsl:attribute name="master-reference">all-pages</xsl:attribute>
				</xsl:element>
			</xsl:element>

		</xsl:element>

	</xsl:template>

	<xsl:template name="do-static-header">

		<xsl:comment>static-header</xsl:comment>
		
		<xsl:element name="fo:static-content" use-attribute-sets="">
			<xsl:attribute name="flow-name">first-right</xsl:attribute>
			<xsl:element name="fo:block-container" use-attribute-sets="running-head">			
				<xsl:element name="fo:block" use-attribute-sets="strong huge color-tinted-blue">
					<!--<xsl:value-of select="$primary-section-title"/>-->
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
		<xsl:element name="fo:static-content" use-attribute-sets="">
			<xsl:attribute name="flow-name">all-right</xsl:attribute>
			<xsl:element name="fo:block-container" use-attribute-sets="running-head">			
				<xsl:element name="fo:block" use-attribute-sets="strong huge color-tinted-blue">
					<!--<xsl:value-of select="$primary-section-title"/>-->
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
		<xsl:element name="fo:static-content" use-attribute-sets="">
			<xsl:attribute name="flow-name">all-header</xsl:attribute>
			<xsl:element name="fo:block" use-attribute-sets="strong huge align-right color-tinted-blue">
				<xsl:apply-templates select="/monographs/(monograph_full|monograph_eval)/title"/>
			</xsl:element>
		</xsl:element>

	</xsl:template>

	<xsl:template name="do-static-footer">
		
		<xsl:comment>static-footer</xsl:comment>
			
		<xsl:element name="fo:static-content" use-attribute-sets="">
			<xsl:attribute name="flow-name">first-footer</xsl:attribute>
			<xsl:element name="fo:block" use-attribute-sets="last-justify">
				<xsl:element name="fo:inline" use-attribute-sets="tiny">
					<xsl:value-of select="$copyright"/>
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:value-of select="$year"/>
				</xsl:element>
				<xsl:element name="fo:leader" use-attribute-sets="default-leader color-white"/>
				<xsl:element name="fo:inline" use-attribute-sets="">
					<fo:page-number/>
				</xsl:element>
				<xsl:element name="fo:leader" use-attribute-sets="default-leader color-white"/>
				<xsl:element name="fo:inline" use-attribute-sets="tiny">
					<xsl:value-of select="$journal-title"/>
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:value-of select="$year"/>
					<xsl:text disable-output-escaping="yes">;</xsl:text>
					<xsl:value-of select="$volume"/>
					<xsl:text disable-output-escaping="yes">:</xsl:text>
					<fo:page-number-citation>
						<xsl:attribute name="ref-id">first-page</xsl:attribute>
					</fo:page-number-citation>
					<xsl:text disable-output-escaping="yes">-</xsl:text>
					<fo:page-number-citation>
						<xsl:attribute name="ref-id">last-page</xsl:attribute>
					</fo:page-number-citation>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
		<xsl:element name="fo:static-content" use-attribute-sets="">
			<xsl:attribute name="flow-name">all-footer</xsl:attribute>
				<xsl:element name="fo:block" use-attribute-sets="last-justify">
					<xsl:element name="fo:inline" use-attribute-sets="tiny">
						<xsl:value-of select="$copyright"/>
						<xsl:text disable-output-escaping="yes"> </xsl:text>
						<xsl:value-of select="$year"/>
					</xsl:element>
					<xsl:element name="fo:leader" use-attribute-sets="default-leader color-white"/>
					<xsl:element name="fo:inline" use-attribute-sets="">
						<fo:page-number/>
					</xsl:element>
				</xsl:element>
		</xsl:element>
		
	</xsl:template>

</xsl:stylesheet>

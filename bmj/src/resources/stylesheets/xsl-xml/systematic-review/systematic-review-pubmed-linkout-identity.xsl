<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	
	<xsl:output 
		method="xml" 
		version="1.0" 
		indent="yes"
		omit-xml-declaration="yes"
		doctype-public="-//NLM//DTD LinkOut 1.0//EN" 
		doctype-system="http://www.ncbi.nlm.nih.gov/entrez/linkout/doc/LinkOut.dtd"/>
	
	<!-- more info @ http://www.ncbi.nlm.nih.gov/books/bv.fcgi?rid=helplinkout.section.files.Identity_File -->
	
	<xsl:param name="lang"/>

	<xsl:include href="../../generic-params.xsl"/>
	<xsl:include href="../../systematic-review-params.xsl"/>
	<xsl:include href="../../xsl-glue-text/bmj-publisher-glue-text.xsl"/>
	
	<xsl:template match="/">
			
		<xsl:element name="Provider">
			
			<!-- ProviderId is assigned by NCBI -->
			<xsl:element name="ProviderId">
				<!--<xsl:value-of select="$issn" />-->
				<xsl:value-of select="$ncbi-provider-id" />
			</xsl:element>
			<xsl:element name="Name">
				<xsl:value-of select="$bmj-publisher-glue-text/publisher-name[contains(@lang, $lang)]"/>
			</xsl:element>
			<xsl:element name="NameAbbr">
				<xsl:value-of select="$bmj-publisher-glue-text/ncbi-publisher-name-abbr[contains(@lang, $lang)]"/>
			</xsl:element>
			
			<xsl:element name="SubjectType">
				<xsl:text>publishers/providers</xsl:text>
			</xsl:element>
			<xsl:element name="Attribute">
				<xsl:text>publisher of information in URL</xsl:text>
			</xsl:element>
			<xsl:element name="Attribute">
				<xsl:text>subscription/membership/fee required</xsl:text>
			</xsl:element>
			<!-- Url is used in My NCBI and the LinkOut Journals and Providers lists -->
			<xsl:element name="Url">
				<xsl:text>http://www.clinicalevidence.bmj.com</xsl:text>
			</xsl:element>
			<!-- Brief is used in My NCBI -->
			<xsl:element name="Brief">
				<xsl:text>An international publisher of medical journals covering major specialties and a growing number of online products for doctors and patients.</xsl:text>
			</xsl:element>
		
		</xsl:element>
			
	</xsl:template>
	
</xsl:stylesheet>

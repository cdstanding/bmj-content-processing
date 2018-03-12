<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output  
		method="xml" 
		version="1.0" 
		encoding="us-ascii" 
		indent="yes"
		omit-xml-declaration="yes"
		doctype-public="-//NLM//DTD PubMed 2.0//EN" 
		doctype-system="http://www.ncbi.nlm.nih.gov:80/entrez/query/static/PubMed.dtd"
		use-character-maps="iso8879" 
	/>
	
	<xsl:include href="../../xsl-entities/iso8879/iso8879map.xsl"/>
	
	<xsl:param name="pubmed-citation-xml-input"/><!--current citation-->
	
	<xsl:template match="ArticleSet">
		<xsl:variable name="document" select="document($pubmed-citation-xml-input)/*"/>
		<xsl:element name="ArticleSet">
			<xsl:apply-templates select="Article"/>
			<xsl:apply-templates select="$document//Article"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@LZero|@EmptyYN">
		<!-- do nothing -->
	</xsl:template>
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format">
	
	<xsl:output method="text" encoding="UTF-8"/>
	
	<xsl:template match="ArticleSet">
	
	    <xsl:text>Clinical Evidence new and updated epublish citations since issue 15</xsl:text>
	    <xsl:text>&#10;&#10;</xsl:text>
		
		<xsl:text>ArticleId | </xsl:text>
		
		<xsl:text>ArticleTitle | </xsl:text>
		
		<xsl:text>PubDate&#10;</xsl:text>
		
		<xsl:apply-templates/>
		
	</xsl:template>
	
	<xsl:template match="Article">

		<xsl:value-of select="ArticleIdList/ArticleId"/><xsl:text> | </xsl:text>
		
		<xsl:value-of select="normalize-space(ArticleTitle)"/><xsl:text> | </xsl:text>
		
		<xsl:value-of select="concat(Journal/PubDate/Year, '-', Journal/PubDate/Month, '-', Journal/PubDate/Day)"/><xsl:text>&#10;</xsl:text>
		
	</xsl:template>
	
</xsl:stylesheet>

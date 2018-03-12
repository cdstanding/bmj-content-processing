<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	version="2.0">

	<xsl:output 
		method="text" 
		encoding="UTF-8" 
		indent="yes" 
	/>

	<xsl:template match="/CONDITIONS">
		<xsl:text>"</xsl:text>
		<xsl:text>id</xsl:text>
		<xsl:text>"</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>"</xsl:text>
		<xsl:text>name</xsl:text>
		<xsl:text>"</xsl:text>
		<xsl:text>&#13;</xsl:text>		
		<xsl:apply-templates select="//SECTION[@DOCTYPE='section']"/>
	</xsl:template>

	<xsl:template match="SECTION[@DOCTYPE='section']" >
		<xsl:text>"</xsl:text>
		<xsl:value-of select="@ID"/>
		<xsl:text>"</xsl:text>
		<xsl:text>,</xsl:text>
		<xsl:text>"</xsl:text>
		<xsl:value-of select="@TITLE"/>
		<xsl:text>"</xsl:text>
		<xsl:text>&#13;</xsl:text>					
	</xsl:template>
	
</xsl:stylesheet>

<?xml version="1.0"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="2.0">

	<xsl:output 
		method="text" 
		encoding="UTF-8" 
		indent="no"/>
	
	<xsl:strip-space elements="*"/>
	
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="/*/*[position() = 1]">
		
		<xsl:for-each select="*">
			<xsl:text>"</xsl:text>
			<xsl:value-of select="name()"/>
			<xsl:text>"</xsl:text>
			<xsl:choose>
				<xsl:when test="position()!=last()">
					<xsl:text>,</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>&#13;</xsl:text>					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
		<xsl:for-each select="*">
			<xsl:text>"</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>"</xsl:text>
			<xsl:choose>
				<xsl:when test="position()!=last()">
					<xsl:text>,</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>&#13;</xsl:text>					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template match="/*/*[position() != 1]">
		
		<xsl:for-each select="*">
			<xsl:text>"</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>"</xsl:text>
			<xsl:choose>
				<xsl:when test="position()!=last()">
					<xsl:text>,</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>&#13;</xsl:text>					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
	</xsl:template>
	
</xsl:stylesheet>
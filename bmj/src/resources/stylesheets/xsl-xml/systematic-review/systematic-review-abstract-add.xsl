<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 

	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"/>
	
	<xsl:param name="abstract-xml-input"/>
	<xsl:variable name="abstract-doc" select="document($abstract-xml-input)/abstract"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>
	
	<xsl:template match="abstract">
		<!-- do nothing -->
	</xsl:template>
	
	<xsl:template match="info">
		<xsl:element name="info">
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:element>
		
		<!-- add abstract from document if available and not in source xml -->
		<xsl:if test="$abstract-doc/element()[string-length(.)!=0]">
			<xsl:element name="abstract">
				<xsl:for-each select="$abstract-doc/element()">
					<xsl:apply-templates select="."/>	
				</xsl:for-each>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>

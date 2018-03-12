<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	
	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"/>
	
	<xsl:param name="empty-node">type-text-for-empty-node</xsl:param>
	
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="section[not(section-header)]">
		<xsl:element name="section">
			<xsl:element name="section-header">
				<xsl:value-of select="$empty-node"/>
			</xsl:element>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<!-- copy all source xml to target xml -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>

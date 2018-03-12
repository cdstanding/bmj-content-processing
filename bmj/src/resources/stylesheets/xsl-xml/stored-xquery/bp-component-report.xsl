<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	version="2.0">
	
	<xsl:output method="xml" indent="yes" encoding="UTF-8"  name="xml"/>
	
	<xsl:strip-space elements="*"/>
	
	<xsl:template match="/">
		<xsl:element name="components">
			<xsl:apply-templates  select="//component" />
		</xsl:element>
	</xsl:template>

	<xsl:template match="component">
		<xsl:element name="drug">
			<xsl:attribute name="id"><xsl:value-of select="@comp-id"/></xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="@drug-name"/></xsl:attribute>
		</xsl:element>
	</xsl:template>    
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"   exclude-result-prefixes="legacytag">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:element name="systematic-review">
            <xsl:variable name="reviewlink" select="/patient-summary/topic-info/systematic-review-link/@target" />
            <xsl:attribute name="link"><xsl:value-of select="$reviewlink"/></xsl:attribute>
            <xsl:value-of select="legacytag:getSummariesForSR($reviewlink, 'en-gb')" disable-output-escaping="yes"/>
            
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>

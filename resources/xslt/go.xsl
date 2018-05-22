<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="xml" indent="yes" xml:space="preserve"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>
&lt;!DOCTYPE HWExpress PUBLIC "-//HIGHWIRE//DTD HighWire Express Marker DTD v1.1.2HW//EN" "marker.dtd"&gt;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>
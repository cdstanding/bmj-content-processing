<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:param name="site"/>
    <xsl:param name="volume"/>
    <xsl:param name="issue"/>
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&#x000D;&lt;!DOCTYPE HWExpress PUBLIC "-//HIGHWIRE//DTD HighWire Express Marker DTD v1.1.2HW//EN" "marker.dtd"&gt;&#x000D;</xsl:text>
        <HWExpress type="vissue">
            <site>
                <xsl:value-of select="$site"/>
            </site>
            <volume>
                <xsl:value-of select="$volume"/>
            </volume>
            <issue>
                <xsl:value-of select="$issue"/>
            </issue>
        </HWExpress>
    </xsl:template>
    
        
</xsl:stylesheet>
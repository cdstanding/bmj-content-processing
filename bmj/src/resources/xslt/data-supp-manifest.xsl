<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="xlink">
    
    <xsl:param name="doi"/>
    <xsl:param name="data-supp-file"/>
    
    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>
&lt;!DOCTYPE datasupp 
PUBLIC "-//HIGHWIRE//DTD HighWire Data Supplement Manifest//EN" "http://schema.highwire.org/public/hwx/ds/datasupplement_manifest.dtd"&gt;</xsl:text>
        <datasupp sitecode="bmj">
            <resource type="doi"><xsl:value-of select="$doi"/></resource>
            <linktext><xsl:value-of select="//notes/label/text()"/></linktext>
            <title><xsl:value-of select="//notes/label/text()"/></title>
            <file></file>
        </datasupp>
    </xsl:template>
    
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:oak="http://schema.bmj.com/delivery/oak"
    xmlns:ce="http://schema.bmj.com/delivery/oak-ce"    
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"   
    exclude-result-prefixes="legacytag xsi"
    version="2.0">
    <xsl:output 
        method="xml" 
        encoding="UTF-8"
        indent="yes"
    />
    
    <xsl:strip-space elements="*"/>
 
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="category[text()[string-length(normalize-space(.))=0] and count(element())=0]">
        <xsl:comment>empty category(1) removed: <xsl:value-of select="./@class"/></xsl:comment> 
    </xsl:template>

    <xsl:template match="category[not(node()[not(self::comment())])]">
        <xsl:comment>empty category(2) removed: <xsl:value-of select="./@class"/></xsl:comment> 
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                    <xsl:attribute name="{name()}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>    

</xsl:stylesheet>

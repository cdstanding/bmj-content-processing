<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink" >
    
    <xsl:param name="journal-id"/>
    <xsl:param name="elocator"/>
    <xsl:param name="valid-date-string"/>
        
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Remove data supplement notes -->
    <xsl:template match="notes[@notes-type='data-supplement']"/>
    
    <!-- Add self-uri for PDF -->
    <xsl:template match="permissions">
        <xsl:copy-of select="."/>
        <xsl:element name="self-uri">
            <xsl:attribute name="xlink:href">
                <xsl:text>bmj.</xsl:text>
                <xsl:value-of select="$elocator"/>
                <xsl:text>.pdf</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xlink:title">
                <xsl:text>pdf</xsl:text>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
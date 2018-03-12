<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <xsl:param name="systematic-review-references-input"/>
    <xsl:param name="systematic-review-xml-input"/>
    <xsl:param name="configuration-name"/>
    
    <xsl:variable name="fileName" select="concat('refs-', substring-after($configuration-name, 'sr-'), '.xml')"/>
    <xsl:variable name="refsFileName" select="concat($systematic-review-references-input, $fileName)"/>
    <xsl:variable name="references" select="document($refsFileName)/*"/>

    <xsl:template match="/">
        <xsl:element name="root">
            <xsl:element name="reference-links">
                <xsl:call-template name="process-references"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="process-references">
        <xsl:for-each select="$references//reference-link[@approved='false']">
            <xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@target, '../'))"/>
            <xsl:variable name="reference" select="document($filename)/*"/>
            
            <xsl:if test="$reference//clinical-citation[string-length(.)!=0]">
                <xsl:element name="reference-link">
                    <xsl:attribute name="reason" select="$reference//reason"/>
                    <xsl:attribute name="target" select="@target"/>
                    <xsl:attribute name="type" select="$reference//@type"/>
                    <xsl:element name="clinical-citation">
                        <xsl:value-of select="$reference//clinical-citation"/>
                    </xsl:element>
                    <xsl:if test="$reference//unique-id[string-length(normalize-space(.))!=0]">
                        <xsl:element name="unique-id">
                            <xsl:attribute name="source" select="$reference//unique-id/@source"/>                                
                            <xsl:value-of select="$reference//unique-id"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:if>            
            
        </xsl:for-each>
    </xsl:template>
    
    
</xsl:stylesheet>

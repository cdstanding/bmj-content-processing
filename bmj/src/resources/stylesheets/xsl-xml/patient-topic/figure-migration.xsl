<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    
    <xsl:output method="xml" indent="yes" name="xml"/>
    
    <xsl:template match="/">
        <xsl:for-each select="//image-link">
            
            <xsl:if test=".[not(@target = preceding::image-link/@target)]">
                <xsl:variable name="targetfile1"><xsl:value-of select="replace(@target, '^\.\./images/(.+?)(_default)?\.(.+?)$' , '$1')"/></xsl:variable>
                <xsl:variable name="targetfile"><xsl:text>fig-</xsl:text><xsl:value-of select="replace($targetfile1, '^(.+?)(_default)$', '$1')"/></xsl:variable>
                
                <xsl:call-template name="create-figure">
                    <xsl:with-param name="filename"><xsl:value-of select="concat($targetfile,'.xml')"/></xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="create-figure">
        <xsl:param name="filename"/>
        <xsl:result-document href="{$filename}" format="xml">
            <xsl:element name="figure">
                <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
                <xsl:attribute name="xsi:noNamespaceSchemaLocation">
                    <xsl:text>../../schemas/bmjk-patient-figures.xsd</xsl:text>
                </xsl:attribute>
                <xsl:element name="image-link">
                    <xsl:attribute name="target">
                        <xsl:value-of select="replace(@target, '^\.\./images/(.+?)(_default)?\.(.+?)$' , '../images/$1.$3')"/> </xsl:attribute>
                </xsl:element>
                <xsl:element name="caption"><xsl:value-of select="@caption"/></xsl:element>
                <xsl:element name="source"/>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
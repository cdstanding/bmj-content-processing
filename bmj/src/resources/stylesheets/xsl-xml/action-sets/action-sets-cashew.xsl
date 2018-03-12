<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">
    
    <xsl:output 
        method="xml" 
        encoding="UTF-8" 
        indent="yes"/>
    
    <xsl:param name="lang"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="action-set">

        <xsl:element name="action-set">
            
            <xsl:for-each select="@*">
                <xsl:choose>
                    <xsl:when test="name() = 'xsi:noNamespaceSchemaLocation'">
                        <xsl:attribute name="xsi:noNamespaceSchemaLocation">
                            <xsl:text>http://schema.bmj.com/delivery/cashew/bmj-action-sets.xsd</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="{name()}">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <xsl:apply-templates/>
           
        </xsl:element>

    </xsl:template>      

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
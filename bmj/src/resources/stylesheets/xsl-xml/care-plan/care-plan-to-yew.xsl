<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xi="http://www.w3.org/2001/XInclude">
    
    <xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- add schema -->
    <xsl:template match="care-plan">
        <xsl:element name="care-plan">
            
            <xsl:for-each select="@*">
                <xsl:choose>
                    <xsl:when test="name() = 'xsi:noNamespaceSchemaLocation'">
                        <xsl:attribute name="xsi:noNamespaceSchemaLocation">
                            <xsl:text>http://schema.bmj.com/delivery/yew/bmjk-care-plan.xsd</xsl:text>
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
    
    <xsl:template match="notes|title|display|display-line|value|description">
        <xsl:element name="{name()}">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="care-plan-info|
        evidence-url|
        action-set-list|
        action-set|
        category-list|
        category|
        sub-category-list|
        sub-category|
        component-list|
        component|
        sentence-list|
        sentence|
        details-list|
        details">

        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:choose>
                    <xsl:when test="name() = 'cki' or name() = 'target'"/>
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
    
</xsl:stylesheet>

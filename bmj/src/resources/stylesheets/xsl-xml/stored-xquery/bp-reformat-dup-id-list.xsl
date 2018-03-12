<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:output 
        method="xml" 
        encoding="UTF-8"
        indent="yes"
        name="xml"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*[name()!='xmlns:xi' ] ">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:element name="result">
            <xsl:apply-templates select="//monograph"/>    
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="monograph">
        <xsl:element name="monograph">
            <xsl:apply-templates select="lang"/>
            <xsl:apply-templates select="docato-id"/>
            <xsl:apply-templates select="name"/>
    
            <xsl:for-each-group select=".//component-id" group-by="@join-id">
                <xsl:element name="component-id">
                    <xsl:attribute name="tx-id"><xsl:value-of select="@tx-id"/></xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:for-each-group>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>

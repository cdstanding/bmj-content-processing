<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes" name="xml"/>
    
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
            <xsl:for-each-group select="//option" group-by="@id">
                <xsl:for-each select="./component">
                    
                    <xsl:apply-templates select="."/>  
                </xsl:for-each>
            </xsl:for-each-group>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="component">
        <xsl:variable name="id" select="@id"/>
        <xsl:element name="component">
            <xsl:attribute name="id">
                <xsl:choose>
                    <xsl:when test="normalize-space(@id)">
                        <xsl:value-of select="@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Unset</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:element name="language">
                <xsl:value-of select="ancestor::monograph/@language"/>
            </xsl:element>
            <xsl:apply-templates select="name"/>
            <xsl:element name="details">
                <xsl:value-of select="normalize-space(details)"/>
            </xsl:element>
            <xsl:element name="modifier">
                <xsl:value-of select="modifier"/>
            </xsl:element>
            <xsl:element name="regimen-tier">
                <xsl:value-of select="regimen-tier"/>
            </xsl:element>
            <xsl:element name="treatment-line">
                <xsl:value-of select="parent::option/tx-line"/>
            </xsl:element>
            <xsl:element name="treatment-type">
                <xsl:value-of select="parent::option/tx-type"/>
            </xsl:element>
            <xsl:element name="treatment-option-id">
                <xsl:value-of select="parent::option/@tx-id"/>
            </xsl:element>
            <xsl:element name="timeframe">
                <xsl:value-of select="parent::option/timeframe"/>
            </xsl:element>
            <xsl:element name="monograph-id">
                <xsl:value-of select="ancestor::monograph/@id"/>
            </xsl:element>
            <xsl:element name="monograph-title">
                <xsl:value-of select="normalize-space(ancestor::monograph/@title)"/>
            </xsl:element>
            <xsl:element name="parent-patient-group-name">
                <xsl:value-of select="parent::option/preceding-sibling::pt-group"/>
            </xsl:element>
            <xsl:element name="patient-group-name">
                <xsl:value-of select="preceding-sibling::pt-group"/>
            </xsl:element>
        </xsl:element>    
        
    </xsl:template>
    
</xsl:stylesheet>
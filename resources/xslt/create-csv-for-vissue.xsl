<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:output indent="no" method="text"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        
        <xsl:variable name="volume">
            <xsl:value-of select="MetaIssue/@volume"/>
        </xsl:variable>
        
        <xsl:variable name="issue">
            <xsl:value-of select="MetaIssue/@issue"/>
        </xsl:variable>
        
        <xsl:variable name="provider">
            <xsl:value-of select="MetaIssue/Provider/text()"/>
        </xsl:variable>
        
        <xsl:for-each select="//DOI">
            <xsl:value-of select="."/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$provider"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="$volume"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="$issue"/>
            <xsl:text>-</xsl:text>
            <xsl:choose>
                <xsl:when test=".[ancestor::TocSection[Heading/text()[contains(.,' ')]]]">
                    <xsl:value-of select="./ancestor::TocSection/Heading/text()/replace(lower-case(.),' ','-')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="./ancestor::TocSection/Heading/text()/lower-case(.)"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>.pdf</xsl:text>
            <xsl:text>&#x000A;</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
    
</xsl:stylesheet>

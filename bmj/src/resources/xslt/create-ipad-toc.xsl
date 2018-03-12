<?xml version="1.0" encoding="UTF-8"?>
 <xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&#x000D;&lt;!DOCTYPE MetaIssue &#x000D;SYSTEM "http://schema.highwire.org/public/toc/MetaIssue.dtd"&gt;&#x000D;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="IssueDate">
        <xsl:element name="{name()}">
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="@yr"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="TOC">
        <xsl:element name="{name()}">
            <xsl:for-each select="TocSection">
                <xsl:element name="{name()}">
                    <xsl:copy-of select="Heading"/>
                    <xsl:for-each select="Resource">
                        <xsl:variable name="article-name">
                            <xsl:value-of select="replace(Location,'(.+)(\\)(.+)','$3')"/>
                        </xsl:variable>
                        <xsl:element name="DOI">
                            <xsl:value-of select="doc(concat('file:///',.,'/nlmxml/',$article-name,'.xml'))//article-meta/article-id[@pub-id-type='doi']/text()"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
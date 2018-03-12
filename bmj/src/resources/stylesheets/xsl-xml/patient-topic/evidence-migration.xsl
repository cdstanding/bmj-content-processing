<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  version="2.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:import href="common-heading1.xsl"/>
    
    <xsl:output 
        method="xml" 
        encoding="UTF-8"
        indent="yes"/>
    
    <xsl:strip-space elements="*"/>
    
    <!-- stylesheets to format evidence, placing all heading1 inside sec-->
    
    <xsl:template match="/">
        <xsl:element name="evidence">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="body-text">
        
        <xsl:element name="sec">
            <xsl:apply-templates select="preceding-sibling::title" mode="head1"/>     
            <xsl:apply-templates select="preceding-sibling::introduction"/>
            <xsl:choose>
                <xsl:when test="not(child::heading1 or child::p[child::heading1])">
                    <xsl:apply-templates select="key('WholeSection',generate-id())" mode="para"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="key('ParaBefore1stHeading1',generate-id())" mode="para"/>
                    <xsl:apply-templates select="key('Before1stHeading1',generate-id())" mode="para"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="heading1">
        <xsl:element name="sec">
            <!--process the title-->
            <xsl:apply-templates select="." mode="head1"/>
            
            <xsl:if test="key('OddPara',generate-id())">
                <xsl:element name="p">
                    <xsl:apply-templates select="key('OddPara',generate-id())" mode="para"/>                         
                </xsl:element>
            </xsl:if>
            
            <xsl:apply-templates select="key('NormalPara',generate-id())" mode="para"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="option-link">
        <xsl:element name="related-article">
            <xsl:attribute name="related-article-type">option</xsl:attribute>
            <xsl:attribute name="href">
                <xsl:variable name="optionTarget1" select="replace(@target, '_i', '_I')"/>
                <xsl:variable name="optionTarget" select="replace($optionTarget1, '../options/op', '../options/_op')"/>
                <xsl:choose>
                    <xsl:when test="string-length(substring-after($optionTarget, '_I')) > 6">
                        <!-- including .xml -->
                        <xsl:value-of select="concat('../options/option-', substring-after($optionTarget, '_I'))"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$optionTarget"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="section"><xsl:value-of select="@xpointer"/></xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>

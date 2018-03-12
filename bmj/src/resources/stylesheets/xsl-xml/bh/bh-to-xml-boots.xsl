<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"   
    exclude-result-prefixes="legacytag"    
    version="2.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:output method="xml" indent="yes" name="xmlOutput" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- related-article related-article-type="option" href="0604.xml" section="I10"/ -->
    <!-- remove link -->
    <xsl:template match="related-article[@related-article-type='option']">
        <!-- do nothing -->
    </xsl:template>

    <!--  
    <xref ref-type="static-content" rid="BmiCalculator">work out your own BMI</xref>.
    -->
    <!-- change bmi calc link -->
    <xsl:template match="ext-link[@href='bmicalc']">
        <xsl:element name="xref">
            <xsl:attribute name="ref-type">static-content</xsl:attribute>
            <xsl:attribute name="rid">BmiCalculator</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>    
    
    
</xsl:stylesheet>

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

    <!-- remove elements -->
    <xsl:template match="title-group|front|article-meta|custom-meta-group">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- remove section -->
    <xsl:template match="treatment-rating">
        <!-- do nothing -->
    </xsl:template>
    
    <xsl:template match="custom-meta">
        <xsl:choose>
            <xsl:when test="./meta-name = 'rating-score'
                or ./meta-name =  'rating-score-id'
                or ./meta-name = 'treatment-licence' 
                or ./meta-name = 'treatment-form' 
                or ./meta-name = 'grade-score'">
                <!-- do nothing duplicate data -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{./meta-name}"><xsl:value-of select="./meta-value"/></xsl:element>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- change schema -->
    <xsl:template match="article[not(parent::article-treatments)]">
        <xsl:element name="article">
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:attribute name="xsi:noNamespaceSchemaLocation">
                <xsl:text>http://schema.bmj.com/delivery/hazel/bmj-best-health-article-cu.xsd</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="article-type"><xsl:value-of select="@article-type"/></xsl:attribute>
            <xsl:attribute name="condition-id"><xsl:value-of select="@id"/></xsl:attribute>
            <xsl:attribute name="version"><xsl:value-of select="@version"/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <!-- rename nested sec elements -->
    <xsl:template match="sec">
        
        <xsl:choose>
            <xsl:when test="count(ancestor::sec) = 0">
                <xsl:element name="sec">
                    <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="count(ancestor::sec) = 1">
                <xsl:element name="sub-sec">
                    <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="count(ancestor::sec) = 2">
                <xsl:element name="sub-sub-sec">
                    <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="count(ancestor::sec) = 3">
                <xsl:element name="sub-sub-sub-sec">
                    <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="count(ancestor::sec) = 4">
                <xsl:element name="sub-sub-sub-sub-sec">
                    <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="count(ancestor::sec) = 5">
                <xsl:element name="sub-sub-sub-sub-sub-sec">
                    <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    
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

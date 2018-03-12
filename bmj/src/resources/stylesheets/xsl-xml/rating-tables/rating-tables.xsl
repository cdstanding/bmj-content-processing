<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
    version="2.0"
    exclude-result-prefixes="legacytag">
    
    <xsl:output 
        method="xml" 
        encoding="UTF-8"
        indent="yes" 
    />
    
    <xsl:strip-space elements="*"/>

    <xsl:param name="filename"/>

    <!-- add schema -->
    <xsl:template match="treatment-ratings">
        <xsl:element name="treatment-ratings">
            
            <xsl:for-each select="@*">
                <xsl:choose>
                    <xsl:when test="name() = 'xsi:noNamespaceSchemaLocation'">
                        <xsl:attribute name="xsi:noNamespaceSchemaLocation">
                            <xsl:text>http://schema.bmj.com/delivery/mahogany/bmjk-patient-treatment-table.xsd</xsl:text>
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

    <!-- move heading back into attribute -->
    <xsl:template match="treatment-ratings-set">

        <xsl:element name="treatment-ratings-set">
            
            <xsl:for-each select="@*">
                        <xsl:attribute name="{name()}">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
            </xsl:for-each>

            <xsl:attribute name="heading">
                <xsl:value-of select="./heading"/>
            </xsl:attribute>

            <xsl:apply-templates/>
            
        </xsl:element>
    </xsl:template>


    <!-- remove empty elements -->
    <xsl:template match="treatment-example">
        <xsl:choose>
            <xsl:when test="./text()">
                <xsl:element name="treatment-example">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- do nothing no content -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
        
    <xsl:template match="treatment-form">
        <xsl:choose>
            <xsl:when test="./text()">
                <xsl:element name="treatment-form">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- do nothing no content -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- move treatment name back into attribute -->
    <xsl:template match="treatment-rating">
        
        <xsl:element name="treatment-rating">
            
            <!-- treatment-rating id="1840395790" rating-score="treatments-that-work" reference-article-id="1000250651" -->
            
            <xsl:attribute name="id">
                <xsl:value-of select="./@id"/>
            </xsl:attribute>
            
            <xsl:attribute name="treatment-name">
                <xsl:value-of select="./treatment-name"/>
            </xsl:attribute>
            
            <xsl:attribute name="rating-score">
                
                <xsl:choose>
                    <xsl:when test="./@rating-score = 'treatments-that-work'">
                        <xsl:value-of>1</xsl:value-of>
                    </xsl:when>
                    <xsl:when test="./@rating-score = 'treatments-that-are-likely-to-work'">
                        <xsl:value-of>2</xsl:value-of>
                    </xsl:when>
                    <xsl:when test="./@rating-score = 'treatments-that-work-but-whose-harms-may-outweigh-benefits'">
                        <xsl:value-of>3</xsl:value-of>
                    </xsl:when>
                    <xsl:when test="./@rating-score = 'treatments-that-need-further-study'">
                        <xsl:value-of>4</xsl:value-of>
                    </xsl:when>
                    <xsl:when test="./@rating-score = 'treatments-that-are-unlikely-to-work'">
                        <xsl:value-of>5</xsl:value-of>
                    </xsl:when>
                    <xsl:when test="./@rating-score = 'treatments-that-are-likely-to-be-ineffective-or-harmful'">
                        <xsl:value-of>6</xsl:value-of>
                    </xsl:when>
                    <xsl:when test="./@rating-score = 'other-treatments'">
                        <xsl:value-of>7</xsl:value-of>
                    </xsl:when>
                    <xsl:when test="./@rating-score = 'usual-treatments'">
                        <xsl:value-of>8</xsl:value-of>
                    </xsl:when>
                </xsl:choose>
                
            </xsl:attribute>

            <xsl:attribute name="reference-article-id">
                <xsl:value-of select="./@reference-article-id"/>
            </xsl:attribute>
            
            <xsl:attribute name="treatment-rating-type">
                
                <xsl:choose>
                    <xsl:when test="./@rating-score = 'usual-treatments'">
                        <xsl:value-of>usual</xsl:value-of>
                    </xsl:when>
                    <xsl:when test="./@rating-score = 'other-treatments'">
                        <xsl:value-of>other</xsl:value-of>
                    </xsl:when>
                    <xsl:when test="./@rating-score = 'treatments-that-need-further-study'">
                        <xsl:value-of>needs further study</xsl:value-of>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of>rated</xsl:value-of>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:attribute>
            
            
            
            <xsl:apply-templates/>
            
        </xsl:element>
    </xsl:template>
    
    <!-- use matching the title element as a placeholder to add the dates -->
    <xsl:template match="title">

        <xsl:variable name="creation-date" select="legacytag:getMetaDataForResourceURL('docato-created',concat('/bmjk/patient-treatment-tables/',substring-before($filename,'.xml')),'en-us','true')"/>

        <xsl:if test="$creation-date!=''">
            <xsl:element name="creation-date">
                <xsl:value-of select="$creation-date"/>
            </xsl:element>
        </xsl:if>

        <xsl:variable name="update-date" select="legacytag:getMetaDataForResourceURL('amended-date',concat('/bmjk/patient-treatment-tables/',substring-before($filename,'.xml')),'en-us','true')"/>
        <xsl:if test="$update-date!=''">
            <xsl:element name="update-date">
                <xsl:value-of select="$update-date"/>
            </xsl:element>
        </xsl:if>
        
        <xsl:element name="export-date">
                    <xsl:value-of select="legacytag:getTodaysDate()"/>
        </xsl:element>

    </xsl:template>
    
    <!-- don't need this data in CR feed -->
    <xsl:template match="notes|systematic-review-link|heading|treatment-name"/>
    
    <xsl:template match="*|@*|text()">
        <xsl:copy>
            <xsl:apply-templates select="*|@*|text()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
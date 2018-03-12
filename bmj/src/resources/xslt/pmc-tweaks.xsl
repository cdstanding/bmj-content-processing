<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="graphic-files-in-folder"/>
    <xsl:param name="volume-number"/>
    <xsl:param name="elocator-bmj"/>
    <xsl:param name="embargo-set"/>
    <xsl:param name="embargo-date-string"/>
    <xsl:param name="embargo-time-string"/>
    <xsl:param name="ppr"/>
    <xsl:param name="supp-files-in-folder"/>
    <xsl:param name="valid-date-string"/>
    
    <!-- Entered dates for PPR -->
    <xsl:param name="ppr-day" select="replace($valid-date-string,'(\d+)([/])(\d+)([/])(\d+)','$1')"/>
    <xsl:param name="ppr-month" select="replace($valid-date-string,'(\d+)([/])(\d+)([/])(\d+)','$3')"/>
    <xsl:param name="ppr-year" select="replace($valid-date-string,'(\d+)([/])(\d+)([/])(\d+)','$5')"/>
    
    <!-- Entered dates for HW Embargo process -->
    <xsl:param name="embargo-day" select="replace($embargo-date-string,'(\d+)([/])(\d+)([/])(\d+)','$1')"/>
    <xsl:param name="embargo-month" select="replace($embargo-date-string,'(\d+)([/])(\d+)([/])(\d+)','$3')"/>
    <xsl:param name="embargo-year" select="replace($embargo-date-string,'(\d+)([/])(\d+)([/])(\d+)','$5')"/>
    
    <!-- Current dates for Green to Go (No embargo) -->
    <xsl:param name="current-date-day" select="day-from-date(current-date())"/>
    <xsl:param name="current-date-month" select="month-from-date(current-date())"/>
    <xsl:param name="current-date-year" select="year-from-date(current-date())"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="article">
        <xsl:text disable-output-escaping="yes" xml:space="default"><![CDATA[<!DOCTYPE article PUBLIC "-//NLM//DTD JATS (Z39.96) Journal Publishing DTD v1.1 20151215//EN"
"JATS-journalpublishing1.dtd">]]>
        </xsl:text>
        <xsl:element name="article">
            <xsl:namespace name="mml">http://www.w3.org/1998/Math/MathML</xsl:namespace>
            <xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:copy-of select="@article-type"/>
            <xsl:copy-of select="@xml:lang"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="//article-meta/volume">
        <volume>
            <xsl:value-of select="$volume-number"/>
        </volume>
    </xsl:template>
    
    <!-- Add file extension to graphic reference in the XML -->
    <xsl:template match="graphic/@xlink:href">
        <xsl:variable name="graphic-xml" select="."/>
        <xsl:analyze-string select="$graphic-files-in-folder" regex="({$graphic-xml}.*?)($|,)">
            <xsl:matching-substring>
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:attribute>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <!-- Add file extension to data supplement reference in the XML -->
    <xsl:template match="supplementary-material/media/@xlink:href">
        <xsl:variable name="supp-xml" select="."/>
        <xsl:analyze-string select="$supp-files-in-folder" regex="({$supp-xml}.*?)($|,)">
            <xsl:matching-substring>
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:attribute>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <!-- Add self-uri for PDF -->
    <xsl:template match="permissions">
        <xsl:copy-of select="."/>
        <xsl:element name="self-uri">
            <xsl:attribute name="xlink:href">
                <xsl:value-of select="$elocator-bmj"/>
                <xsl:text>.pdf</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xlink:title">
                <xsl:text>pdf</xsl:text>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    
    <!-- WORKING ON DATE STRINGS! -->
    <xsl:template match="pub-date[@pub-type='epub'][not(preceding-sibling::pub-date[@pub-type='collection'])]">
        <xsl:element name="pub-date">
            <xsl:attribute name="pub-type">
                <xsl:text>collection</xsl:text>
            </xsl:attribute>
            <xsl:if test="$embargo-set = 'y'">
                <xsl:element name="year">
                    <xsl:value-of select="$embargo-year"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="$embargo-set = 'n'">
                <xsl:choose>
                    <xsl:when test="$ppr = 'true'">
                        <xsl:element name="year">
                            <xsl:value-of select="$ppr-year"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="year">
                            <xsl:value-of select="$current-date-year"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:element>
        
        <xsl:if test="$embargo-set = 'y'">
            <xsl:element name="pub-date">
                <xsl:copy-of select="@*"/>
                <xsl:element name="day">
                    <xsl:value-of select="$embargo-day"/>
                </xsl:element>
                <xsl:element name="month">
                    <xsl:value-of select="$embargo-month"/>
                </xsl:element>
                <xsl:element name="year">
                    <xsl:value-of select="$embargo-year"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        
        <xsl:if test="$embargo-set = 'n'">
            <xsl:choose>
                <xsl:when test="$ppr = 'true'">
                    <xsl:element name="pub-date">
                        <xsl:copy-of select="@*"/>
                        <xsl:element name="day">
                            <xsl:value-of select="$ppr-day"/>
                        </xsl:element>
                        <xsl:element name="month">
                            <xsl:value-of select="$ppr-month"/>
                        </xsl:element>
                        <xsl:element name="year">
                            <xsl:value-of select="$ppr-year"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="pub-date">
                        <xsl:copy-of select="@*"/>
                        <xsl:element name="day">
                            <xsl:value-of select="$current-date-day"/>
                        </xsl:element>
                        <xsl:element name="month">
                            <xsl:value-of select="$current-date-month"/>
                        </xsl:element>
                        <xsl:element name="year">
                            <xsl:value-of select="$current-date-year"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        
    </xsl:template>
    
</xsl:stylesheet>
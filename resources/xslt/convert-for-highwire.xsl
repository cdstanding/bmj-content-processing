﻿<?xml version="1.0" encoding="UTF-8"?>

<!-- Stylesheet to convert NLM XML to be ready for ingestion at Highwire -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:output indent="no" method="xml"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="elocator"/>
    <xsl:param name="embargo.set"/>
    <xsl:param name="launched-by"/>
    <xsl:param name="ppr-volume"/>
    <xsl:param name="date"/>
    <xsl:param name="year"/>
    <xsl:param name="month"/>
    <xsl:param name="day"/>
    <xsl:param name="volume-number"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Remove topic codes -->
    <xsl:template match="subj-group[@subj-group-type = 'univadis-top-article']"/>
    <xsl:template match="subj-group[@subj-group-type = 'univadis-customer-type']"/>
    <xsl:template match="subj-group[@subj-group-type = 'univadis-specialties']"/>
    <xsl:template match="subj-group[@subj-group-type = 'univadis-conditions']"/>
    <xsl:template match="subj-group[@subj-group-type = 'univadis-type-categorization']"/>
    
    <xsl:template match="article-meta">
        <article-meta>
            <xsl:apply-templates/>
            <!-- Add self-uri link if article has associated PDF -->
            <xsl:if test="not(self-uri[@xlink:title='pdf'])">
                <self-uri>
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="$elocator"/>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:title">
                        <xsl:text>pdf</xsl:text>
                    </xsl:attribute>
                </self-uri>
            </xsl:if>
            <!-- Add custom meta value for cccme if processing instruction is present -->
            <xsl:if test="//processing-instruction('cccme')">
                <custom-meta-group>
                    <custom-meta>
                        <meta-name>special-property</meta-name>
                        <meta-value>cccme</meta-value>
                    </custom-meta>
                </custom-meta-group>
            </xsl:if>
            <!-- Add custom meta value for fast-track if processing instruction is present -->
            <xsl:if test="//processing-instruction('fast-track')">
                <custom-meta-group>
                    <custom-meta>
                        <meta-name>special-property</meta-name>
                        <meta-value>fast-track</meta-value>
                    </custom-meta>
                </custom-meta-group>
            </xsl:if>
        </article-meta>
    </xsl:template>
    
    <!-- Add pub date and year values from autobatch file -->
    <xsl:template match="pub-date">
        <pub-date>
            <xsl:attribute name="pub-type">
                <xsl:text>collection</xsl:text>
            </xsl:attribute>
            <year>
                <xsl:value-of select="$year"/>
            </year>
        </pub-date>
        
        <xsl:choose>
            <xsl:when test="$launched-by = 'ppr'">
                <xsl:choose>
                    <xsl:when test="$date = ''">
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="pub-date">
                            <xsl:attribute name="pub-type">
                                <xsl:text>epub</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="day">
                                <xsl:value-of
                                    select="$day"/>
                            </xsl:element>
                            <xsl:element name="month">
                                <xsl:value-of
                                    select="$month"/>
                            </xsl:element>
                            <xsl:element name="year">
                                <xsl:value-of
                                    select="$year"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <pub-date>
                    <xsl:attribute name="pub-type">
                        <xsl:value-of select="@pub-type"/>
                    </xsl:attribute>
                    <day>
                        <xsl:value-of select="$day"/>
                    </day>
                    <month>
                        <xsl:value-of select="$month"/>
                    </month>
                    <year>
                        <xsl:value-of select="$year"/>
                    </year>
                </pub-date>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- Remove data supplement notes -->
    <xsl:template match="notes[@notes-type='data-supplement']"/>
    
    <xsl:template match="article-meta/volume">
        <volume>
            <xsl:choose>
                <xsl:when test="$launched-by = 'ppr'">
                    <xsl:value-of select="$ppr-volume"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$volume-number"/>
                </xsl:otherwise>
            </xsl:choose>
        </volume>
    </xsl:template>
    
    <!-- Suppress any processing instructions -->
    <xsl:template match="comment() | processing-instruction()"/>
    
</xsl:stylesheet>

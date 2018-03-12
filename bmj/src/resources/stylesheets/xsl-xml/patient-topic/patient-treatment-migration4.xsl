<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:import href="patient-topic-migration4.xsl"/>
    
    <xsl:output 
        method="xml" 
        encoding="UTF-8"
        indent="yes"/>
    
    <xsl:param name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝ'"/>
    <xsl:param name="lower" select="'abcdefghijklmnopqrstuvwxyzáâãäåæçèéêëìíîïðñòóôõöøùúûüý'"/>
    
    <xsl:param name="maintopic"/>
    <xsl:param name="filename"/>
    
    <xsl:strip-space elements="*"/>

    <xsl:template match="body">
        <xsl:element name="body">
            <xsl:element name="introduction">
                <xsl:apply-templates select="introduction/*"/>
                <xsl:if test="not(introduction/further-information)">
                    <xsl:element name="further-information"/>
                </xsl:if>
            </xsl:element>
            
            <xsl:element name="does-it-work">
                <xsl:apply-templates select="does-it-work/*"/>
                <xsl:if test="not(does-it-work/further-information)">
                    <xsl:element name="further-information"/>
                </xsl:if>
            </xsl:element>
            
            <xsl:element name="what-is-it">
                <xsl:apply-templates select="what-is-it/*"/>
                <xsl:if test="not(what-is-it/further-information)">
                    <xsl:element name="further-information"/>
                </xsl:if>
            </xsl:element>
            
            <xsl:element name="benefits">
                <xsl:apply-templates select="benefits/*"/>
                <xsl:if test="not(benefits/further-information)">
                    <xsl:element name="further-information"/>
                </xsl:if>
            </xsl:element>
            
            <xsl:element name="how-does-it-work">
                <xsl:apply-templates select="how-does-it-work/*"/>
                <xsl:if test="not(how-does-it-work/further-information)">
                    <xsl:element name="further-information"/>
                </xsl:if>
            </xsl:element>
            
            <xsl:element name="harms">
                <xsl:apply-templates select="harms/*"/>
                <xsl:if test="not(harms/further-information)">
                    <xsl:element name="further-information"/>
                </xsl:if>
            </xsl:element>
            
            <xsl:element name="how-good-is-the-research">
                <xsl:apply-templates select="how-good-is-the-research/*"/>
                <xsl:if test="not(how-good-is-the-research/further-information)">
                    <xsl:element name="further-information"/>
                </xsl:if>
            </xsl:element>            
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="sidebar-link">
        <xsl:element name="xref">
            <xsl:attribute name="ref-type">patient-topic</xsl:attribute>
            <xsl:attribute name="rid">
                <xsl:value-of select="concat('../patient-topic/',replace(@topic, '^(.+?)?\.(.+?)$', '$1'), '.xml')"/>
            </xsl:attribute>
            <xsl:attribute name="section">
                <xsl:text>further-information/</xsl:text>
                <xsl:choose>
                    <xsl:when test="contains(@target, '/sidebars/')">
                        <xsl:value-of select="replace(@target, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2')"/>                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-before(@target, '.xml')"/>        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="custom-meta[child::meta-name[text() = 'rating-score']]">
        <xsl:copy>
            <xsl:element name="meta-name"><xsl:text>rating-score</xsl:text></xsl:element>
            <xsl:element name="meta-value">
                <xsl:variable name="maintopicDoc" select="document($maintopic)"/>
                <xsl:variable name="ratings"  select="$maintopicDoc//group//sec[./list/list-item/p/xref[@ref-type='patient-treatment' and contains(@rid, $filename) and not(ancestor::further-information)] and last()]/title"/>
                <xsl:value-of select="replace(replace(translate($ratings[last()], $upper, $lower), ' ', '-'), ',', '')"/>
            </xsl:element>
        </xsl:copy>    
    </xsl:template>
    
   
</xsl:stylesheet>

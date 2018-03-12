<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:import href="patient-topic-migration3.xsl"/>
    
    <xsl:output 
        method="xml" 
        encoding="UTF-8"
        indent="yes"/>
    
    <xsl:strip-space elements="*"/>
    <!--xsl:param name="maintopic"/-->
    
    <xsl:template match="introduction|does-it-work|what-is-it|benefits|how-does-it-work|harms|how-good-is-the-research">
        
        <xsl:copy>
            <!-- 
            <xsl:call-template name="add-related-article-section"/>
            <xsl:call-template name="add-related-article-sidebar-section">
                <xsl:with-param name="sectionname" select="name()"/>
            </xsl:call-template>
            -->
            <xsl:apply-templates/>
            <!--xsl:call-template name="add-further-information-section"/-->
        </xsl:copy>
        
    </xsl:template>

    <!-- PROCESS SIDEBARS HERE -->
    <!-- to fix sidebar directory/path! do not add sidebar in further information if it is already in the main topic-->
    <!--
    <xsl:template name="add-further-information-section">
        <xsl:element name="further-information">
            <xsl:for-each select=".//sidebar-link">
                <xsl:variable name="targetvalue"><xsl:value-of select="@target"/></xsl:variable>
                <xsl:variable name="maintopicDoc" select="document($maintopic)"></xsl:variable>
                
                <xsl:if test="not($targetvalue = $maintopicDoc//sidebar-link/@target)">
                    <xsl:if test=".[not($targetvalue= preceding::sidebar-link/@target)]">
                        <xsl:variable name="sidebar" select="document(concat($path, '/', substring-after(@target,'../sidebars/')))"></xsl:variable>
                        
                        <xsl:comment>sidebar-link target='<xsl:value-of select="@target"/> topic='<xsl:value-of select="@topic"/></xsl:comment>
                        <xsl:apply-templates select="$sidebar/sidebar/*"></xsl:apply-templates>
                    </xsl:if>                    
                </xsl:if>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    -->
</xsl:stylesheet>

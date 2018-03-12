<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
     
    version="2.0">
    
    <!--
    xmlns:xptr="http://www.w3.org/2001/05/XPointer"
    xmlns:xptrf="http://www.isogen.com/functions/xpointer"
    xmlns:func="http://exslt.org/functions"
    xmlns:fcommon="http://exslt.org/common"
    
    extension-element-prefixes="func xptr"
    -->

    <!--<xsl:import href="xpointer-functions.xsl" />-->

    <xsl:param name="doctype-system" />
    <xsl:param name="doctype-public" />

    <xsl:template name="xinclude-copy-attributes">
        
        <!-- Implement this template in the main template to specialize to a particular document type.-->
        <xsl:for-each select="./@*[name()!='xsi:noNamespaceSchemaLocation']">
            <xsl:copy-of select="." />
        </xsl:for-each>
        
    </xsl:template>

    <!--<xsl:output 
        method="xml" 
        indent="yes"
        doctype-system="foo"
        omit-xml-declaration="no" 
        encoding="UTF-8"/>-->

    <!-- ==============================================================
        XInclude implementation
        
        Implements XInclude by processing the entire doc
        to produce a single result tree with all the includes resolved
        and then applies the normal template processing to that document.
        ==============================================================-->
    
    <xsl:template match="/">
        
        <xsl:choose>
            
            <xsl:when test="//xi:include">
                <xsl:variable name="resolved-doc">
                    <xsl:apply-templates mode="xinclude" />
                </xsl:variable>
                
                <xsl:apply-templates select="$resolved-doc" mode="normal" />
                
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    
    <!-- addded sutome template to allow processing non-root xml tree ie variable document -->
    <xsl:template match="/" mode="xinclude-implementation">
        
        <xsl:choose>
            
            <xsl:when test="//xi:include">
                <xsl:variable name="resolved-doc">
                    <xsl:apply-templates mode="xinclude" />
                </xsl:variable>
                
                <xsl:copy-of select="$resolved-doc"/>
                
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="/" mode="normal">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="node()" mode="xinclude">
        <xsl:copy>
            <xsl:call-template name="xinclude-copy-attributes" />
            <xsl:apply-templates select="node()" mode="xinclude" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xi:include" mode="xinclude">
        <xsl:param name="xpath" select="@href" />
        
        <xsl:choose>
            
            <xsl:when test="$xpath != ''">
                
                <!-- NOTE: comment now comprosing 'inluding ' may affect 
                    some stylesheets that share and test contents from this comment -->
                <xsl:message>including <xsl:value-of select="$xpath" /></xsl:message>
                <xsl:comment>including <xsl:value-of select="$xpath" /></xsl:comment>
                <xsl:apply-templates select="document($xpath)" mode="xinclude" />
                
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:message>Xinclude: Failed to get a value for the href= attribute of xi:include element.</xsl:message>
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>

</xsl:stylesheet>

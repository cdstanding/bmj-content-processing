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
    
    <xsl:key name="EvidenceLink" match="evidence-link" use="generate-id(ancestor::body-text)"/>
    
    <xsl:template match="/">
        <xsl:element name="article">
            <xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:attribute name="xsi:noNamespaceSchemaLocation">
                <xsl:text>../../schemas/nlm-hybrid-article-patient.xsd</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="article-type">patient-treatment</xsl:attribute>
            
            <xsl:element name="front">
                <xsl:element name="article-meta">
                    <xsl:element name="title-group">
                        <xsl:element name="article-title">
                            <xsl:value-of select="./treatment/headline"/>    
                        </xsl:element>
                        <xsl:element name="alt-title">
                            <xsl:attribute name="alt-title-type">abridged</xsl:attribute>
                            <xsl:value-of select="/treatment/title"/>    
                        </xsl:element>  
                    </xsl:element>
                    <xsl:element name="custom-meta-group">
                        <xsl:call-template name="add-custom-meta">
                            <xsl:with-param name="name">rating-score</xsl:with-param>
                            <xsl:with-param name="value"></xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="add-custom-meta">
                            <xsl:with-param name="name">treatment-licence</xsl:with-param>
                            <xsl:with-param name="value">unset</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="add-custom-meta">
                            <xsl:with-param name="name">treatment-form</xsl:with-param>
                            <xsl:with-param name="value">unset</xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="add-custom-meta">
                            <xsl:with-param name="name">grade-score</xsl:with-param>
                            <xsl:with-param name="value">unset</xsl:with-param>
                        </xsl:call-template>                        
                    </xsl:element>
                </xsl:element>
                <xsl:element name="notes">
                    <xsl:element name="sec">
                        <xsl:element name="title"/>
                        <xsl:element name="p"/>
                    </xsl:element>
                </xsl:element>
                
            </xsl:element>
            <xsl:element name="body">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>    
    
    <xsl:template name="add-custom-meta">
        <xsl:param name="name"/>
        <xsl:param name="value"/>
        <xsl:element name="custom-meta">
            <xsl:element name="meta-name"><xsl:value-of select="$name"/></xsl:element>
            <xsl:element name="meta-value"><xsl:value-of select="$value"/></xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="body-text">
        
        
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
        
        <xsl:apply-templates select="key('EvidenceLink',generate-id())" mode="newsection"/>
        
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
    
    <xsl:template match="evidence-link" mode="para"/>
    
    <xsl:template match="evidence-link" mode="newsection">
        <xsl:element name="evidence-link">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>


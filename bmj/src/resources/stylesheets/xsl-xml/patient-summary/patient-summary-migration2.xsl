<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes" />
    
    <xsl:strip-space elements="*"/>
    
    <!-- 
        stylesheet to format transformed2 xml
        - format heading 2, placing realated text and element into separate <p>
        - add related-article in each category
        - add futher-information in each category, inserting related sidebars in category that it is first used
        
        TODO:
        change path for  transformed sidebars
    -->
    
    <xsl:key name="OddParaHeading2" match="text()[parent::p[child::heading2] and preceding-sibling::heading2]         |*[parent::p[child::heading2] and preceding-sibling::heading2 and not(name()='heading2')]" use="generate-id((preceding::heading2)[last()])"/>
    
    <xsl:key name="OddParaHeading3" match="text()[parent::p[child::heading3] and preceding-sibling::heading3]         |*[parent::p[child::heading3] and preceding-sibling::heading3 and not(name()='heading3')]" use="generate-id((preceding::heading3)[last()])"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*[name()!='xmlns:xi' ] ">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="introduction|content">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="p[child::heading2]">
        
        <xsl:for-each select="./*[not(preceding-sibling::heading2 or name() = 'heading2')]">
            <xsl:element name="p">
                <xsl:apply-templates select="."/>    
            </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="heading2">
            <xsl:apply-templates select="."/>
            <xsl:if test="key('OddParaHeading2', generate-id())">
                <xsl:element name="p">
                    <xsl:apply-templates select="key('OddParaHeading2', generate-id())"/>    
                </xsl:element>                
            </xsl:if>
            
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="heading2">
        <xsl:choose>
            <xsl:when test="count(child::*) = 1 and child::heading3 and normalize-space()">
                <xsl:apply-templates/>        
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="p[child::heading3]">
        <xsl:for-each select="./*[not(preceding-sibling::heading3 or name() = 'heading3')]">
            <xsl:element name="p">
                <xsl:apply-templates select="."/>    
            </xsl:element>
        </xsl:for-each>        
        <xsl:for-each select="heading3">
            <xsl:apply-templates select="."/>
            <xsl:if test="key('OddParaHeading3', generate-id())">
                <xsl:element name="p">
                    <xsl:apply-templates select="key('OddParaHeading3', generate-id())"/>    
                </xsl:element>                
            </xsl:if>
            
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="bold[parent::th]">
        <xsl:apply-templates mode="para"/>
    </xsl:template>    

</xsl:stylesheet>
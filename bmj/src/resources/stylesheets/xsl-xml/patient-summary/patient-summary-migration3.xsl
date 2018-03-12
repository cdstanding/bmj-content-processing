<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:strip-space elements="*"/>
    <xsl:output 
        method="xml" 
        encoding="UTF-8"
        indent="yes"/>
    
    <xsl:param name="outputdir"/>
    
    <!-- 
        stylesheet to format transformed3 xml
        - format heading 2, placing related <p> in sec
        - add related-article in each further-information
        - fix section attribute in related article for further-information
        - comment out sidebar, treatment and internal links
    -->

 
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
    
    <xsl:template match="body">
        <xsl:element name="body">
            <xsl:element name="introduction">
                <xsl:apply-templates select="introduction/*"/>
                <xsl:element name="further-information"/>
            </xsl:element>
            
            <xsl:element name="content">
                <xsl:apply-templates select="content/*"/>
                <xsl:element name="further-information"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="introduction|content"/>
    
    <xsl:key name="OddParaList" 
        match="text()[parent::p[child::list] and preceding-sibling::list]
        |*[parent::p[child::list] and preceding-sibling::list and not(name()='list')]"
        use="generate-id((preceding::list)[last()])"/>
    
    <xsl:key name="OddParaTable" 
        match="text()[parent::p[child::table-wrap] and preceding-sibling::table-wrap]
        |*[parent::p[child::table-wrap] and preceding-sibling::table-wrap]"
        use="generate-id((preceding::table-wrap)[last()])"/>
    
    <xsl:template match="p[child::list]">
        <xsl:if test="child::text()[not(preceding-sibling::list)] | child::node()[not(preceding-sibling::list or name()='list')]">
            <xsl:element name="p">
                <xsl:for-each select="child::text()[not(preceding-sibling::list)] | child::node()[not(preceding-sibling::list or name()='list')]">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
            </xsl:element>                        
        </xsl:if>
        <xsl:for-each select="list">
            <xsl:apply-templates select="."/>
                <xsl:if test="key('OddParaList', generate-id())">
                    <xsl:element name="p">
                        <xsl:apply-templates select="key('OddParaList', generate-id())"/>
                    </xsl:element>                          
                </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="p[child::table-wrap]">
        <xsl:if test="child::text()[not(preceding-sibling::table-wrap)] | child::node()[not(preceding-sibling::table-wrap or name()='table-wrap')]">
            <xsl:for-each select="child::text()[not(preceding-sibling::table-wrap)] | child::node()[not(preceding-sibling::table-wrap or name()='table-wrap')]">
                <xsl:element name="p">
                    <xsl:apply-templates select="."/>
                </xsl:element>
            </xsl:for-each>            
        </xsl:if>

        <xsl:for-each select="table-wrap">
            <xsl:apply-templates select="."/>
            <xsl:if test="key('OddParaTable', generate-id())">
                <xsl:element name="p">
                    <xsl:apply-templates select="key('OddParaTable', generate-id())"/>    
                </xsl:element>                
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
     
    <xsl:template match="list-item">
        <xsl:copy>
            <xsl:element name="p">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:key name="BeforeHeading2" 
        match="title[parent::sec and not(preceding-sibling::heading2)]
        |*[parent::sec and not(preceding-sibling::heading2) and not(name()='heading2')]" use="generate-id(parent::sec[last()])"/>

    <xsl:key name="Heading2" 
    match="heading2" use="generate-id(parent::sec[last()])"/>
    

    <xsl:key name="AfterHeading2" 
    match="*[parent::sec and not(preceding-sibling::heading3) and not(name()='heading2')]|heading3 " use="generate-id(preceding-sibling::heading2[position() = 1])"/>
    
    <xsl:key name="AfterHeading3" 
        match="*" use="generate-id(preceding-sibling::heading3[position() = 1])"/>


    <xsl:template match="sec">
        <xsl:choose>
            <xsl:when test="parent::further-information">
                <xsl:if test="not(@id = preceding::sec/@id)">
                    <xsl:choose>
                        <xsl:when test="child::heading2">
                            <xsl:call-template name="add-section-with-heading2"/>        
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="add-section-no--heading2"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="child::heading2">
                        <xsl:call-template name="add-section-with-heading2"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="add-section-no--heading2"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xsl:template name="add-section-with-heading2">
        <xsl:element name="sec">
            <xsl:if test="@id">
                <xsl:attribute name="id" select="@id"/>    
            </xsl:if>
            <xsl:apply-templates select="key('BeforeHeading2', generate-id())"/>
            <xsl:apply-templates select="key('Heading2', generate-id())"/>
        </xsl:element>        
    </xsl:template>
    
    <xsl:template name="add-section-no--heading2">
        <xsl:element name="sec">
            <xsl:if test="@id">
                <xsl:attribute name="id" select="@id"/>    
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>        
    </xsl:template>

    
    <xsl:template match="heading2">
        <xsl:element name="sec">
            <xsl:element name="title"><xsl:value-of select="."/></xsl:element>
            <xsl:apply-templates select="key('AfterHeading2', generate-id())"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="heading3">
        <xsl:element name="sec">
            <xsl:element name="title"><xsl:value-of select="."/></xsl:element>
            <xsl:apply-templates select="key('AfterHeading3', generate-id())"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="text()[parent::sec]">
            <xsl:element name="p">
                <xsl:value-of select="."/>
            </xsl:element>
    </xsl:template>
    

    <xsl:template match="p[not(normalize-space(.))]"/>
    
    <xsl:template match="xref[parent::sec]">
        <xsl:element name="p">
            <xsl:copy>
                <xsl:for-each select="@*">
                    <xsl:attribute name="{name()}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:for-each>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:element>    
    </xsl:template>
    
</xsl:stylesheet>

    
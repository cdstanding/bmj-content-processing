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
                <xsl:if test="not(introduction/further-information)">
                    <xsl:element name="further-information"/>
                </xsl:if>
            </xsl:element>
            
            <xsl:element name="description">
                <xsl:element name="overview">
                    <xsl:apply-templates select="description/overview/*"/>
                    <xsl:if test="not(description/overview/further-information)">
                        <xsl:element name="further-information"/>
                    </xsl:if>
                </xsl:element>
                
                <xsl:element name="key-points">
                    <xsl:apply-templates select="description/key-points/*"/>
                    <xsl:if test="not(description/key-points/further-information)">
                        <xsl:element name="further-information"/>
                    </xsl:if>
                </xsl:element>
                
                <xsl:element name="explanation">
                    <xsl:apply-templates select="description/explanation/*"/>
                    <xsl:if test="not(description/explanation/further-information)">
                        <xsl:element name="further-information"/>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="risk-factors">
                    <xsl:apply-templates select="description/risk-factors/*"/>
                    <xsl:if test="not(description/risk-factors/further-information)">
                        <xsl:element name="further-information"/>
                    </xsl:if>
                </xsl:element>
                
                <xsl:element name="staging">
                    <xsl:apply-templates select="description/staging/*"/>
                    <xsl:if test="not(description/staging/further-information)">
                        <xsl:element name="further-information"/>
                    </xsl:if>
                </xsl:element>
                
                <xsl:element name="classification">
                    <xsl:apply-templates select="description/classification/*"/>
                    <xsl:if test="not(description/classification/further-information)">
                        <xsl:element name="further-information"/>
                    </xsl:if>
                </xsl:element>
            </xsl:element>
            
            <xsl:element name="symptoms">
                <xsl:apply-templates select="symptoms/*"/>
                <xsl:if test="not(symptoms/further-information)">
                    <xsl:element name="further-information"/>
                </xsl:if>
            </xsl:element>
            <xsl:element name="incidence">
                <xsl:apply-templates select="incidence/*"/>
                <xsl:if test="not(incidence/further-information)">
                    <xsl:element name="further-information"/>
                </xsl:if>
            </xsl:element>
            <xsl:element name="prognosis">
                <xsl:apply-templates select="prognosis/*"/>
                <xsl:if test="not(prognosis/further-information)">
                    <xsl:element name="further-information"/>
                </xsl:if>
            </xsl:element>
            <xsl:element name="diagnosis">
                <xsl:apply-templates select="diagnosis/*"/>
                <xsl:if test="not(diagnosis/further-information)">
                    <xsl:element name="further-information"/>
                </xsl:if>
            </xsl:element>
            <xsl:element name="questions-to-ask">
                <xsl:apply-templates select="questions-to-ask/*"/>
                <xsl:if test="not(questions-to-ask/further-information)">
                    <xsl:element name="further-information"/>
                </xsl:if>
            </xsl:element>
            <xsl:element name="survival-rates"><xsl:element name="further-information"/></xsl:element>
            <xsl:element name="self-management"><xsl:element name="further-information"/></xsl:element>
            <xsl:element name="tests"><xsl:element name="further-information"/></xsl:element>
            <xsl:element name="treatment-points">
                <xsl:element name="introduction">
                    <xsl:apply-templates select="treatment-points/introduction/*"/>
                    <xsl:if test="not(treatment-points/introduction/further-information)">
                        <xsl:element name="further-information"/>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="key-points">
                    <xsl:apply-templates select="treatment-points/key-points/*"/>
                    <xsl:if test="not(treatment-points/key-points/further-information)">
                        <xsl:element name="further-information"/>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="treatment-approach"><xsl:element name="further-information"/></xsl:element>
                <xsl:element name="guidelines"><xsl:element name="further-information"/></xsl:element>
                <xsl:element name="drug-alerts"><xsl:element name="further-information"/></xsl:element>                                
                <xsl:element name="which-treatments-work-best">
                    <xsl:apply-templates select="treatment-points/which-treatments-work-best/*"/>
                    <xsl:if test="not(treatment-points/which-treatments-work-best/further-information)">
                        <xsl:element name="further-information"/>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="treatment-groups">
                    <xsl:for-each select="treatment-points/treatment-groups/group">
                        <xsl:element name="group">
                            <!-- 
                            <xsl:apply-templates/>    
                            <xsl:if test="not(further-information)">
                                <xsl:element name="further-information"/>
                            </xsl:if>
                            -->
                            
                            <xsl:element name="introduction">
                                <xsl:apply-templates select="introduction/*"/>
                                <xsl:if test="not(introduction/further-information)">
                                    <xsl:element name="further-information"/>
                                </xsl:if>
                            </xsl:element>
                            <xsl:element name="key-points">
                                <xsl:apply-templates select="key-points/*"/>
                                <xsl:if test="not(key-points/further-information)">
                                    <xsl:element name="further-information"/>
                                </xsl:if>
                            </xsl:element>
                            <xsl:element name="treatment-approach"><xsl:element name="further-information"/></xsl:element>
                            <xsl:element name="guidelines"><xsl:element name="further-information"/></xsl:element>
                            <xsl:element name="drug-alerts"><xsl:element name="further-information"/></xsl:element>                                
                            <xsl:element name="which-treatments-work-best">
                                <xsl:apply-templates select="which-treatments-work-best/*"/>
                                <xsl:if test="not(which-treatments-work-best/further-information)">
                                    <xsl:element name="further-information"/>
                                </xsl:if>
                            </xsl:element>
                            <xsl:element name="treatments">
                                <xsl:apply-templates select="treatments/*"/>
                                <xsl:if test="not(treatments/further-information)">
                                    <xsl:element name="further-information"/>
                                </xsl:if>
                            </xsl:element>                            
                        </xsl:element>                        
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>       
        </xsl:element>
    </xsl:template>

    <xsl:template match="introduction|overview|key-points
        |explanation|risk-factors|staging|classification|symptoms|prognosis|incidence|diagnosis|treatment-approach|treatment-points|group"/>
    
    <xsl:template match="related-article">
        <xsl:choose>
            <xsl:when test="@related-article-type = 'further-information'">
                <xsl:variable name="targetvalue"><xsl:value-of select="@target"/></xsl:variable>
                <xsl:if test=".[$targetvalue= preceding::related-article/@target]">
                    <xsl:comment>sidebar-link target='<xsl:value-of select="@target"/> topic='<xsl:value-of select="@href"/></xsl:comment>    
                    <xsl:element name="related-article">
                        <xsl:attribute name="related-article-type">further-information</xsl:attribute>
                        <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
                        <xsl:attribute name="section"><xsl:value-of select="preceding::related-article[@target = $targetvalue and last()]/@section"/></xsl:attribute>
                        <xsl:value-of select="."></xsl:value-of>
                    </xsl:element>                    
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:for-each select="@*">
                        <xsl:attribute name="{name()}">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </xsl:copy>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="add-related-article-sidebar-section">
        <xsl:param name="sectionname"/>
        <xsl:for-each select=".//sidebar-link">

            <xsl:comment>sidebar-link target='<xsl:value-of select="@target"/> topic='<xsl:value-of select="@topic"/></xsl:comment>
            <xsl:element name="related-article">
                <xsl:attribute name="related-article-type">further-information</xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:choose>
                        <xsl:when test="contains(@topic, '.xml')">
                            <xsl:value-of select="@topic"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat(@topic, '.xml')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="section">
                    <xsl:variable name="target"><xsl:value-of select="concat('../sidebars/', @target)"/></xsl:variable>
                    <xsl:value-of select="(//related-article[@target = $target]/@section)[position() = 1]"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>                    
        </xsl:for-each>            
    </xsl:template>
    
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
    
    <xsl:template match="treatment-link">
        <xsl:element name="xref">
            <xsl:attribute name="ref-type">patient-treatment</xsl:attribute>
            <xsl:attribute name="rid">
                <xsl:choose>
                    <xsl:when test="contains(@target, '/treatments/')">
                        <xsl:value-of select="concat('../patient-treatment/', replace(@target, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.$3'))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@target"/>        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="internal-link">
        <xsl:choose>
            <xsl:when test="contains(@target, '../about/') or contains(@target, '../howtouse/')">
                <xsl:element name="ext-link">
                    <xsl:attribute name="ext-link-type">static</xsl:attribute>
                    <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="xref">
                    <xsl:attribute name="ref-type">patient-topic</xsl:attribute>
                    <xsl:attribute name="rid">
                        <xsl:choose>
                            <xsl:when test="contains(@target, '/patient-topics/')">
                                <xsl:value-of select="concat('../patient-topic/', replace(@target, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.$3'))"/>
                                <!--xsl:value-of select="substring-after(@target, '../patient-topics/')"></xsl:value-of-->                        
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@target"/>        
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="section">
                        <xsl:choose>
                            <xsl:when test="@target-element = 'topic-info'">
                                <xsl:text>introduction</xsl:text>
                            </xsl:when>
                            <xsl:when test="@target-element = 'treatments'">
                                <xsl:text>treatment-points</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@target-element"/>        
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>    
    
    <xsl:template match="sidebar-link">
        <xsl:element name="xref">
            <xsl:attribute name="ref-type">patient-topic</xsl:attribute>
            <xsl:attribute name="rid">
                <xsl:value-of select="concat(replace(@topic, '^(.+?)?\.(.+?)$', '$1'), '.xml')"/>
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
    
    <xsl:template match="text()[parent::sec]">
            <xsl:element name="p">
                <xsl:value-of select="."/>
            </xsl:element>
    </xsl:template>
    

    <xsl:template match="xi:include">
        <xsl:if test="not(@href = preceding-sibling::xi:include/@href)">
            <xsl:copy>
                <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
            </xsl:copy>
        </xsl:if>    
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
    
    <xsl:template match="floats-group">
        <xsl:element name="floats-group">
            <xsl:for-each select="//xref[@ref-type = 'fig']">
                <xsl:if test="not(@rid = preceding::xref[@ref-type = 'fig']/@rid)">
                    <xsl:element name="xi:include">
                        <xsl:attribute name="href" select="@rid"/>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
            
            <xsl:for-each select="xi:include">
                <xsl:if test="not(@href = preceding::xi:include/@href)">
                    <xsl:variable name="targetfile"><xsl:value-of select="substring-after(@href, '..')"/></xsl:variable>
                    <xsl:variable name="treatmentdoc" select="document(concat($outputdir, $targetfile))"></xsl:variable>
                    <xsl:for-each select="$treatmentdoc/article//xref[@ref-type = 'fig']">
                        <xsl:if test="not(@rid = preceding::xref[@ref-type = 'fig']/@rid)">
                            <xsl:element name="xi:include">
                                <xsl:attribute name="href" select="@rid"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>    
            </xsl:for-each>
            
            
        </xsl:element>
        
    </xsl:template>
    
</xsl:stylesheet>

    
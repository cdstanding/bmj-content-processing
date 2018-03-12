<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes" name="xml"/>
    
    <xsl:strip-space elements="*"/>
    <xsl:param name="maintopicname"/>
    <xsl:param name="path"/>
    <xsl:param name="temppath"/>
    <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    
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
    
    <xsl:template match="introduction|overview|key-points|explanation|risk-factors|staging|classification|symptoms|prognosis|incidence|diagnosis         |which-treatments-work-best">
        <xsl:copy>
            <xsl:apply-templates/>
            <xsl:call-template name="add-further-information-section">
                <xsl:with-param name="sectionName"><xsl:value-of select="name()"/></xsl:with-param>
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="treatments">
        <xsl:copy>
            <xsl:apply-templates/>
            <xsl:call-template name="add-further-information-section">
                <xsl:with-param name="sectionName"><xsl:value-of select="name()"/></xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="add-xi-include"/>
        </xsl:copy>        
    </xsl:template>
    
    <xsl:template name="add-xi-include">
        <xsl:for-each select=".//treatment-link">
            <xsl:variable name="topicLowerCase" select="translate(@topic, $ucletters,$lcletters)"/>
            <xsl:variable name="articleTitleLowerCase" select="replace(replace(translate(//article-title, $ucletters,$lcletters), ' ', '-' ), ',', '')"/>
            <xsl:if test="not(contains(text()[1], 'More...')) and ($maintopicname = $topicLowerCase or $articleTitleLowerCase = $topicLowerCase)">
                <xsl:element name="xi:include">
                    <xsl:attribute name="href">
                        <xsl:choose>
                            <xsl:when test="contains(@target, '/treatments/')">
                                <xsl:value-of select="concat('../patient-treatment/', replace(@target, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.$3'))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@target"/>        
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:element>
                <!-- 
                    <xsl:call-template name="copyFile">
                    <xsl:with-param name="target" select="@target"/>
                    </xsl:call-template>
                -->
          
            </xsl:if>
        </xsl:for-each>       
    </xsl:template>
    
    <!-- PROCESS LINKS HERE!!!  -->
    <!--    <xsl:template name="add-related-article-section">
        <xsl:for-each select=".//internal-link">
        <xsl:element name="related-article">
        <xsl:attribute name="related-article-type">internal-link</xsl:attribute>
        <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
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
        <xsl:value-of select="."></xsl:value-of>
        </xsl:element>                    
        </xsl:for-each>
        
        <xsl:for-each select=".//treatment-link">
        <xsl:if test="not(preceding::treatment-link/@target = @target and contains(., 'More..') )">
        <xsl:element name="related-article">
        <xsl:attribute name="related-article-type">treatment-link</xsl:attribute>
        <xsl:attribute name="href">
        <xsl:choose>
        <xsl:when test="contains(@target, '../treatments/')">
        <xsl:value-of select="concat('../patient-treatment', '/', substring-after(@target, '../treatments/'))"/>       
        </xsl:when>
        <xsl:otherwise>
        <xsl:value-of select="@target"/>
        </xsl:otherwise>
        </xsl:choose>
        </xsl:attribute> 
        <xsl:attribute name="section"></xsl:attribute>
        <xsl:value-of select="."></xsl:value-of>
        </xsl:element>   
        </xsl:if>
        </xsl:for-each>
        </xsl:template>
        
        <xsl:template name="add-related-article-sidebar-section">
        <xsl:param name="sectionname"/>
        <xsl:for-each select=".//sidebar-link">
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
        <xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
        <xsl:attribute name="section"><xsl:value-of select="$sectionname"/></xsl:attribute>
        <xsl:value-of select="."></xsl:value-of>
        </xsl:element>                    
        </xsl:for-each>            
        </xsl:template>-->
    
    
    <!-- PROCESS SIDEBARS HERE -->
    <!-- to fix sidebar directory/path! -->
    <xsl:template name="add-further-information-section">
        <xsl:param name="sectionName"/>
        <xsl:element name="further-information">
            <xsl:call-template name="process-first-sidebars"/>
            <xsl:if test="$sectionName = 'treatments'">
                <xsl:call-template name="process-sidebars-in-treatment-group"/>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="process-sidebars-in-treatment-group">
        <xsl:for-each select=".//treatment-link">
            <xsl:if test="not(@target = preceding::treatment-link[ancestor::treatments]/@target)">
                <xsl:variable name="treatment" select="document(concat($temppath, '', substring-after(@target,'..')))"/>
                <!--xsl:comment>treatment-link target='<xsl:value-of select="@target"/> topic='<xsl:value-of select="@topic"/></xsl:comment-->            
                <xsl:apply-templates select="$treatment/treatment"/>                
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 
        Add levels to avoid infinite loop!!!
        This will dig/look for sidebars unto the 3rd level, 
        meaning sidebars in topic/treatment, sidebars inside a sidebar, sidebars inside a sidebar in a sidebar of topic/treatment
    -->
    <xsl:template name="process-first-sidebars">
        <xsl:for-each select=".//sidebar-link">
            <xsl:variable name="targetvalue"><xsl:value-of select="@target"/></xsl:variable>
            <xsl:variable name="topicvalue"><xsl:value-of select="replace(@topic, '.xml', '')"/></xsl:variable>
            <xsl:if test=".[not($targetvalue= preceding::sidebar-link/@target and $topicvalue = preceding::sidebar-link/@topic) ] and $maintopicname = $topicvalue">
                <xsl:variable name="sidebar" select="document(concat($path, '', substring-after(@target, '..')))"/>
                <!--xsl:comment>sidebar-link target='<xsl:value-of select="@target"/> topic='<xsl:value-of select="@topic"/></xsl:comment-->
                <xsl:apply-templates select="$sidebar/sidebar" mode="first"/>            
            </xsl:if>
        </xsl:for-each>        
    </xsl:template>
    
    <xsl:template name="process-second-sidebars">
        <xsl:for-each select=".//sidebar-link">
            <xsl:variable name="targetvalue"><xsl:value-of select="@target"/></xsl:variable>
            <xsl:variable name="topicvalue"><xsl:value-of select="replace(@topic, '.xml', '')"/></xsl:variable>
            <xsl:if test=".[not($targetvalue= preceding::sidebar-link/@target and $topicvalue = preceding::sidebar-link/@topic) ] and $maintopicname = $topicvalue">
                
                <xsl:variable name="sidebar" select="document(concat($path, '/sidebars/', @target))"/>
                <!--xsl:comment>sidebar-link target='<xsl:value-of select="@target"/> topic='<xsl:value-of select="@topic"/></xsl:comment-->
                <xsl:apply-templates select="$sidebar/sidebar" mode="second"/>            
            </xsl:if>
        </xsl:for-each>        
    </xsl:template>
    
    <xsl:template name="process-third-sidebars">
        <xsl:for-each select=".//sidebar-link">
            <xsl:variable name="targetvalue"><xsl:value-of select="@target"/></xsl:variable>
            <xsl:variable name="topicvalue"><xsl:value-of select="replace(@topic, '.xml', '')"/></xsl:variable>
            <xsl:if test=".[not($targetvalue= preceding::sidebar-link/@target and $topicvalue = preceding::sidebar-link/@topic) ] and $maintopicname = $topicvalue">
                
                <xsl:variable name="sidebar" select="document(concat($path, '/sidebars/', @target))"/>
                <!--xsl:comment>sidebar-link target='<xsl:value-of select="@target"/> topic='<xsl:value-of select="@topic"/></xsl:comment-->
                <xsl:apply-templates select="$sidebar/sidebar" mode="third"/>            
            </xsl:if>
        </xsl:for-each>        
    </xsl:template>
    
    <xsl:template match="sidebar" mode="first">
        <xsl:apply-templates select="sec" mode="#default"/>
        <xsl:call-template name="process-second-sidebars"/>
    </xsl:template>
    
    <xsl:template match="sidebar" mode="second">
        <xsl:apply-templates select="sec" mode="#default"/>
        <xsl:call-template name="process-third-sidebars"/>
    </xsl:template>
    
    <xsl:template match="sidebar" mode="third">
        <xsl:apply-templates select="sec" mode="#default"/>
    </xsl:template>    
    
    <xsl:template match="treatment">
        <xsl:call-template name="process-first-sidebars"/>
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
    
    <!-- 
        <xsl:template name="copyFile">
        <xsl:param name="target"/>                        
        
        <xsl:variable name="treatmentdoc" select="document(concat($temppath, substring-after($target, '..')))"></xsl:variable>
        <xsl:variable name="filename">file:///<xsl:value-of select="translate($path,'\','/')"/>/patient-treatment-temp/<xsl:value-of select="substring-after($target, '../treatments/')"/></xsl:variable>
        
        <xsl:result-document href="{$filename}" format="xml">
        <xsl:apply-templates select="$treatmentdoc/*"/>
        </xsl:result-document>
        
        </xsl:template>
    -->
</xsl:stylesheet>
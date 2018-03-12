<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://schema.bmj.com/delivery/oak"
    xmlns:bh="http://schema.bmj.com/delivery/oak-bh"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"   
    exclude-result-prefixes="legacytag"    
    version="2.0">

    <xsl:param name="path"/>
    <xsl:param name="outputpath"/>
    <xsl:param name="inputpath"/>
    <xsl:param name="maintopicname"/>
    <xsl:param name="published-date"/>
    <xsl:param name="amended-date"/>
    <xsl:param name="last-update"/>
    <xsl:param name="last-reviewed"/>
    <xsl:param name="date-amended-iso"/>
    <xsl:param name="date-updated-iso"/>
    <xsl:param name="last-reviewed-iso"/>
    <xsl:param name="todays-date-iso"/>
    <xsl:param name="embargo-date"/>
    <xsl:param name="embargo-date-iso"/>
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:output method="xml" indent="yes" name="xmlOutput" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*[name()!='xmlns:xi' ] ">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <xsl:apply-templates select="article">
            <xsl:with-param name="id" select="$maintopicname"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="article">
        <xsl:param name="id"/>
        <xsl:element name="section">
            <xsl:namespace name="bh">http://schema.bmj.com/delivery/oak-bh</xsl:namespace>
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:attribute name="xsi:schemaLocation">
                <xsl:text>http://schema.bmj.com/delivery/oak http://schema.bmj.com/delivery/oak/bmj-oak-strict.xsd</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="id" select="$id"/>
            <xsl:attribute name="class" select="@article-type"/>
            <xsl:apply-templates/>
            
            <xsl:call-template name="add-glossaries"/>
            <xsl:call-template name="add-references"/>
            <xsl:call-template name="add-figures"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="front|font">
        
        <xsl:element name="metadata">

            <xsl:for-each select="./article-meta/custom-meta-group/custom-meta">
                <xsl:element name="key">
                    <xsl:attribute name="name" select="./meta-name"/>
                    <xsl:attribute name="value" select="./meta-value"/>
                </xsl:element>
            </xsl:for-each>

            <xsl:if test="$published-date!=''">
                <xsl:element name="key">
                    <xsl:attribute name="name">exported</xsl:attribute>
                    <xsl:attribute name="value"><xsl:value-of select="$published-date"/></xsl:attribute>						
                </xsl:element>
            </xsl:if>

            <xsl:if test="$amended-date!=''">
                <xsl:element name="key">
                    <xsl:attribute name="name">amended</xsl:attribute>
                    <xsl:attribute name="value"><xsl:value-of select="$amended-date"/></xsl:attribute>						
                </xsl:element>
            </xsl:if>
            
            <xsl:if test="$last-update!=''">
                <xsl:element name="key">
                    <xsl:attribute name="name">updated</xsl:attribute>
                    <xsl:attribute name="value"><xsl:value-of select="$last-update"/></xsl:attribute>						
                </xsl:element>
            </xsl:if>
            
            <xsl:if test="$embargo-date!=''">
                <xsl:element name="key">
                    <xsl:attribute name="name">embargo-date</xsl:attribute>
                    <xsl:attribute name="value"><xsl:value-of select="$embargo-date"/></xsl:attribute>						
                </xsl:element>
            </xsl:if>
            
        </xsl:element>

        <xsl:element name="title">
            <xsl:value-of select="./article-meta/title-group/article-title"/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="body">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template
        match="introduction
        |overview
        |key-points
        |explanation
        |risk-factors
        |staging
        |classification
        |symptoms
        |incidence
        |prognosis
        |diagnosis
        |questions-to-ask
        |survival-rates
        |self-management
        |tests
        |treatment-points
        |treatment-approach
        |guidelines
        |drug-alerts
        |treatment-groups
        |description
        |does-it-work
        |what-is-it
        |benefits
        |how-does-it-work
        |harms
        |which-treatments-work-best
        |treatments
        |what-is-it-for
        |who-is-it-suitable-for
        |what-happens
        |treatment-choices
        |whats-the-outcome
        |what-if-it-doesnt-work
        |what-are-the-risks
        |what-if-i-dont-have-it
        |what-are-the-alternatives
        |what-can-i-expect-afterwards
        |content
        ">
        <xsl:if test="normalize-space(.)">
            <xsl:element name="section">
                <xsl:attribute name="class" select="name()"/>  
                <xsl:attribute name="bh:oen" select="name()"/>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="how-good-is-the-research">
        <xsl:if test="normalize-space(.)">
            <xsl:element name="section">
                <xsl:attribute name="class" select="name()"/>  
                <xsl:attribute name="bh:oen" select="name()"/>
                <xsl:call-template name="add-section-for-related-articles"/>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="group">
        <xsl:if test="normalize-space(.)">
            <xsl:element name="section">
                <xsl:attribute name="class" select="name()"/>  
                <xsl:attribute name="bh:oen" select="name()"/>
                <xsl:attribute name="id" select="@id"/>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="further-information">
        <xsl:for-each select="sec">
            <xsl:element name="section">
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:attribute name="class">further-information</xsl:attribute>  
                        <xsl:attribute name="bh:oen">further-information</xsl:attribute>
                        <xsl:attribute name="id" select="@id"/>
                        <xsl:element name="section">
                            <xsl:attribute name="class">content</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="class">content</xsl:attribute>  
                        <xsl:apply-templates select="title"/>
                        <xsl:element name="p">
                            <xsl:element name="b">*Further information with no id</xsl:element>
                        </xsl:element>
                        <xsl:apply-templates select="./*[not(name() = 'title')]"/>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:element>
        </xsl:for-each>    
    </xsl:template>
    
    <xsl:template name="add-section-for-related-articles">
        <xsl:if test="related-article">
            <xsl:element name="section">
                <xsl:attribute name="class"><xsl:text>related-article</xsl:text></xsl:attribute>  
                <xsl:attribute name="bh:oen"><xsl:text>related-article</xsl:text></xsl:attribute>
                <xsl:element name="title"><xsl:text>Related Article</xsl:text></xsl:element>
                <xsl:element name="list">
                    <xsl:for-each select="related-article">
                        <xsl:variable name="ceweb"><xsl:value-of>http://clinicalevidence.bmj.com/ceweb/conditions/abc/</xsl:value-of></xsl:variable>
                        
                        <xsl:element name="li">
                            <xsl:choose>
                                <xsl:when test="contains(@href, 'MISSING_LINK_TARGET')">
                                    <xsl:element name="b"><xsl:text>[Broken link] option:</xsl:text> <xsl:value-of select="@href"/></xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="link">
                                        <xsl:attribute name="class" select="@related-article-type"/>
                                        <xsl:choose>
                                            <!-- old option file name -->
                                            <xsl:when test="contains(@href,'_op')">
                                                <xsl:attribute name="target">
                                                    <xsl:variable name="topicid"><xsl:value-of select="substring-before((substring-after(@href, '_op')),'_I')"/></xsl:variable>
                                                    <xsl:variable name="interid"><xsl:value-of select="substring-before((substring-after(@href, '_I')),'.xml')"/></xsl:variable>
                                                    <xsl:variable name="intervention"><xsl:value-of select="concat($topicid, '_I', $interid)"/></xsl:variable>
                                                    <xsl:value-of select="concat($ceweb,$topicid,'/',$intervention,'.jsp')"/>
                                                </xsl:attribute>
                                                <xsl:variable name="optiondoc" select="document(concat($path, '/options/', replace(@href, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.$3')))"></xsl:variable>
                                                <xsl:if test="$optiondoc">
                                                    <xsl:value-of select="$optiondoc/option/title"></xsl:value-of>    
                                                </xsl:if>
                                            </xsl:when>
                                            <!-- new option file name -->
                                            <xsl:when test="contains(@href,'-')">
                                                <xsl:attribute name="target">
                                                    <xsl:variable name="topicid"><xsl:value-of select="legacytag:getSystematicReviewId(@href)"/></xsl:variable>
                                                    <xsl:variable name="interid"><xsl:value-of select="substring-before((substring-after(@href, '-')),'.xml')"/></xsl:variable>
                                                    <xsl:variable name="intervention"><xsl:value-of select="concat($topicid, '_I', $interid)"/></xsl:variable>
                                                    <xsl:value-of select="concat($ceweb,$topicid,'/',$intervention,'.jsp')"/>
                                                </xsl:attribute>
                                                <xsl:variable name="optiondoc" select="document(concat($path, '/options/', replace(@href, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.$3')))"></xsl:variable>
                                                <xsl:if test="$optiondoc">
                                                    <xsl:value-of select="$optiondoc/option/title"></xsl:value-of>    
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:attribute name="target"/>
                                                <xsl:text>[Broken link] option:</xsl:text> <xsl:value-of select="@href"/> 
                                            </xsl:otherwise>
                                        </xsl:choose> 
                                    </xsl:element>                                        
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:for-each>  
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="sec">
        <xsl:element name="section" inherit-namespaces="yes">
            <xsl:attribute name="class">content</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="title|p[not(parent::list-item)]|list|thead|tbody">
        <xsl:element name="{name()}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tr|td|th">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>    

    <xsl:template match="list-item">
        <xsl:element name="li">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="p[parent::list-item]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="bold">
        <xsl:element name="b" >
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="italic">
        <xsl:element name="i">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="drug">
        <xsl:element name="inline">
            <xsl:attribute name="class">drug</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="table-wrap">
        <xsl:apply-templates select="table"/>
    </xsl:template> 
        
    <xsl:template match="table">
        <xsl:element name="table">
            <xsl:element name="caption">
                <xsl:element name="p"/>
                <xsl:value-of select="../caption"/>
            </xsl:element>
                <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xref[@ref-type='bibr']">
        <xsl:element name="link">
            <xsl:attribute name="bh:oen" select="name()"/>
            <xsl:attribute name="class" select="@ref-type"/>
            <xsl:attribute name="target">
                <xsl:call-template name="findLinkPosition">
                    <xsl:with-param name="target"><xsl:value-of select="@rid"/></xsl:with-param>
                    <xsl:with-param name="type">bibr</xsl:with-param>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xref[@ref-type='gloss']">
        <xsl:element name="link">
            <xsl:attribute name="bh:oen" select="name()"/>
            <xsl:attribute name="class" select="@ref-type"/>
            <xsl:attribute name="target">
                <xsl:call-template name="findLinkPosition">
                    <xsl:with-param name="target"><xsl:value-of select="@rid"/></xsl:with-param>
                    <xsl:with-param name="type">gloss</xsl:with-param>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xref[@ref-type='static-content']">
        <xsl:element name="link">
            <xsl:attribute name="bh:oen" select="name()"/>
            <xsl:attribute name="class" select="@ref-type"/>
            <xsl:attribute name="target">
                <xsl:call-template name="findLinkPosition">
                    <xsl:with-param name="target"><xsl:value-of select="@rid"/></xsl:with-param>
                    <xsl:with-param name="type">static-content</xsl:with-param>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="xref[@ref-type='fig']">
        <xsl:element name="link">
            <xsl:attribute name="bh:oen" select="name()"/>
            <xsl:attribute name="class" select="@ref-type"/>
            <xsl:attribute name="target">
                <xsl:call-template name="findLinkPosition">
                    <xsl:with-param name="target"><xsl:value-of select="@rid"/></xsl:with-param>
                    <xsl:with-param name="type">fig</xsl:with-param>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xref[@ref-type='patient-topic']">
        <xsl:element name="link">
            <xsl:attribute name="bh:oen" select="name()"/>
            <xsl:attribute name="class" select="@ref-type"/>
            <xsl:attribute name="target">
                <xsl:value-of select="concat(replace(replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2'), '.xml', ''), '/', @section)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xref[@ref-type='elective-surgery']">
        <xsl:element name="link">
            <xsl:attribute name="bh:oen" select="name()"/>
            <xsl:attribute name="class" select="@ref-type"/>
            <xsl:attribute name="target">
                <xsl:value-of select="concat(replace(replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2'), '.xml', ''), '/', @section)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xref[@ref-type='patient-treatment']">
        <xsl:element name="link">
            <xsl:attribute name="bh:oen" select="name()"/>
            <xsl:attribute name="class" select="@ref-type"/>
            <xsl:attribute name="target">
                <xsl:choose>
                    <xsl:when test="@section">
                        <xsl:value-of select="concat(replace(replace(replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2'), '.xml', ''), '_', ''), '/', @section)"/>        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace(replace(replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2'), '.xml', ''), '_', '')"/>        
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>   
    
    <xsl:template name="add-references">
    	<xsl:if test="//xref[@ref-type='bibr']">
        <xsl:element name="references">
            <xsl:for-each select="//xref[@ref-type='bibr' and not(@rid = preceding::xref/@rid)]">
                    <xsl:variable name="referencedoc" select="document(concat($path, '/reference/', replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.$3')))"></xsl:variable>
                    <xsl:element name="reference">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat('bibr_',position())"/>
                        </xsl:attribute>
                        <xsl:element name="p">
                            <xsl:value-of select="$referencedoc/reference/patient-citation/primary-authors"/><xsl:text> </xsl:text>
                            <xsl:value-of select="$referencedoc/reference/patient-citation/primary-title"/><xsl:text> </xsl:text>
                            <xsl:value-of select="$referencedoc/reference/patient-citation/source"/>
                        </xsl:element>
                    </xsl:element>
            </xsl:for-each>
        </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="add-glossaries">
       	<xsl:if test="//xref[@ref-type='gloss']">
        <xsl:element name="section">
            <xsl:attribute name="class"><xsl:text>glossary</xsl:text></xsl:attribute>
            <xsl:element name="title">Glossary</xsl:element>
            <xsl:for-each select="//xref[@ref-type='gloss' and not(@rid = preceding::xref/@rid)]">
                   <xsl:variable name="glossesdoc" select="document(concat($path, '/glosses/', replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.$3')))"></xsl:variable>
                    <xsl:element name="gloss">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat('gloss_',position())"/>
                        </xsl:attribute>
                        <xsl:element name="p">
                            <xsl:attribute name="class"><xsl:text>term</xsl:text></xsl:attribute>
                            <xsl:value-of select="$glossesdoc/gloss/term"></xsl:value-of>
                        </xsl:element>
                        <xsl:element name="p">
                            <xsl:attribute name="class"><xsl:text>definition</xsl:text></xsl:attribute>
                            <xsl:value-of select="$glossesdoc/gloss/definition"></xsl:value-of>
                        </xsl:element>
                    </xsl:element>
            </xsl:for-each>
        </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="add-figures">
        <xsl:for-each select="//xref[@ref-type='fig' and not(@rid = preceding::xref/@rid)]">
                <xsl:variable name="figuredoc" select="document(concat($path, '/patient-figure/', replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')))"></xsl:variable>
                <xsl:element name="figure">
                    <xsl:attribute name="id">
                        <xsl:value-of select="concat('fig_',position())"/>
                    </xsl:attribute>
                    <xsl:attribute name="image"><xsl:value-of select="replace($figuredoc/figure/image-link/@target, '^\.\./(.+?)/(.+?)?\.(.+?)$', 'images/$2.$3')"/></xsl:attribute>
                    <xsl:element name="caption">
                        <xsl:element name="p">
                            <xsl:value-of select="$figuredoc/figure/caption"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
        </xsl:for-each>
    </xsl:template>

        
    <xsl:template match="ext-link">
        <xsl:element name="link">
            <xsl:attribute name="class" select="@ext-link-type"/>
            <xsl:attribute name="target" select="@href"/>
            <xsl:value-of select="."/>
        </xsl:element>    
    </xsl:template>
    
    <xsl:template match="comment()"/>
    
    <xsl:template match="xi:include">
        <xsl:if test="not(@href = preceding::xi:include/@href)">
            <xsl:variable name="name"><xsl:value-of select="replace(@href, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.$3')"/></xsl:variable>
            <xsl:variable name="includepath">file://localhost/<xsl:value-of select="translate($inputpath,'\','/')"/>/<xsl:value-of select="$name"/></xsl:variable>
            <xsl:variable name="treatmentfile" select="document($includepath)"/>
            <xsl:variable name="filename">file:///<xsl:value-of select="translate($outputpath,'\','/')"/>/<xsl:value-of select="replace($name, '_', '')"/></xsl:variable>
            <xsl:result-document href="{$filename}" format="xmlOutput">
                <xsl:apply-templates select="$treatmentfile/article">
                    <xsl:with-param name="id" select="replace(replace(@href, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2'), '_', '')"/>
                </xsl:apply-templates>
            </xsl:result-document>            
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="alt-link-wrapper">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="related-article"/>
    <xsl:template match="floats-group"/>
    
    <xsl:template name="findLinkPosition">
        <xsl:param name="target"/>
        <xsl:param name="type"/>        
        <xsl:for-each select="//xref[@ref-type=$type and not(@rid = preceding::xref/@rid)]">
            <xsl:if test="$target = @rid">
                <xsl:value-of select="concat($type,'_',position())"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>

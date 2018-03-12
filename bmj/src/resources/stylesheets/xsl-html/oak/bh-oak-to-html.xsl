<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:oak="http://schema.bmj.com/delivery/oak"
    xmlns:bh="http://schema.bmj.com/delivery/oak-bh"    
    version="2.0"
    exclude-result-prefixes="oak">

    <xsl:output 
        method="html" 
        encoding="UTF-8" 
        indent="yes"/>
    
    <xsl:param name="resource-name"/>
    
    <xsl:template match="/*">
        <xsl:element name="html">
            
            <!--<xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>-->

            <xsl:element name="head">
                <xsl:element name="title">
                    <xsl:value-of select="self::oak:section/(self::oak:section | oak:section[1])/oak:title[1]"/>
                </xsl:element>
                <!--FIX: use param for location and/or pull in css into html-->
                <xsl:element name="link">
                    <xsl:attribute name="rel">stylesheet</xsl:attribute>
                    <xsl:attribute name="type">text/css</xsl:attribute>
                    <!--<xsl:attribute name="media">print</xsl:attribute>-->
                    <xsl:attribute name="href">../../css/oak.css</xsl:attribute>
                </xsl:element>
                
            </xsl:element>
            
            <xsl:element name="body">
                <xsl:element name="div">
                    <xsl:attribute name="class" select="'wrapper'"/>
                   
                    <xsl:apply-templates/>
                    
                </xsl:element>
            </xsl:element>
            
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="oak:section">
        <xsl:element name="div">
            <xsl:attribute name="class" select="@class"/>
            <xsl:choose>
                <xsl:when test="@bh:oen = 'further-information'">
                    <xsl:attribute name="id" select="@id"/>    
                </xsl:when>
                <xsl:when test="parent::oak:section[@bh:oen = 'description']">
                    <xsl:attribute name="id" select="concat('description-', @bh:oen)"/>    
                </xsl:when>
                <xsl:when test="parent::oak:section[@bh:oen = 'treatment-points']">
                    <xsl:attribute name="id" select="concat('treatment-points-', @bh:oen)"/>    
                </xsl:when>
                <xsl:when test="parent::oak:section[@bh:oen = 'group']">
                    <xsl:attribute name="id" select="concat(parent::oak:section/@id, '-', @bh:oen)"/>    
                </xsl:when>                                       
                <xsl:otherwise>
                    <xsl:attribute name="id" select="@bh:oen"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="@bh:oen">
                <xsl:element name="h2"><xsl:value-of select="@bh:oen"/></xsl:element>    
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oak:section[@bh:oen='treatment-groups']">
        <xsl:element name="div">
            <xsl:attribute name="class" select="@class"/>
            <xsl:element name="h2"><xsl:value-of select="@bh:oen"/></xsl:element>
            <xsl:for-each select="oak:section[@class='group']">
                <xsl:element name="div">
                    <xsl:attribute name="class" select="@class"/>
                    <xsl:attribute name="id" select="@id"/>
                    <xsl:element name="h2"><xsl:value-of select="@bh:oen"/> <xsl:text> </xsl:text><xsl:value-of select="position()"/></xsl:element>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>


    <xsl:template match="oak:section[@class='related-article']">
        <xsl:element name="div">
            <xsl:attribute name="class" select="@class"/>
            <xsl:element name="ul">
                <xsl:apply-templates/>
            </xsl:element>
       </xsl:element>
    </xsl:template>
    
    <xsl:template match="oak:link[@class='option']">
        <xsl:element name="li">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:value-of select="@target"/>
            </xsl:attribute>
            <xsl:attribute name="class">web-link</xsl:attribute>  		
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="oak:title">
        <xsl:choose>
            <xsl:when test="ancestor::oak:section[@bh:oen='description']">
                <xsl:element name="{concat('h', (count(ancestor::node()) -2))}">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="ancestor::oak:section[@bh:oen='group']">
                <xsl:element name="{concat('h', (count(ancestor::node()) -4))}">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>            
            <xsl:when test="ancestor::oak:section[@bh:oen='treatment-points']">
                <xsl:element name="{concat('h', (count(ancestor::node()) -2))}">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>               
            
            <xsl:otherwise>
                <xsl:element name="{concat('h', (count(ancestor::node()) -1))}">
                    <xsl:apply-templates/>
                </xsl:element>                
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="oak:metadata">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="oak:key">
        <xsl:element name="meta">
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="content" select="@value"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="oak:p">
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oak:link[@class='bibr']">
        <xsl:element name="a">
            <xsl:attribute name="href" select="concat('#ref', @target)"/>
            <xsl:text>[</xsl:text>
            <xsl:value-of select="@target"/>
            <xsl:text>]</xsl:text>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oak:link[@class='fig']">
        <xsl:variable name="target" select="@target"/>
        
        <xsl:for-each select="//oak:figure">
            <xsl:if test="@id = $target">
                <xsl:element name="img">
                    <xsl:attribute name="src" select="concat('../../',@image)"/>
                    <xsl:attribute name="border" select="'0'"/>
                </xsl:element>
                <xsl:if test="oak:caption[string-length(normalize-space(.))!=0]">
                    <xsl:value-of select="oak:caption"/>
                </xsl:if>
                <xsl:element name="br"/>
                <xsl:element name="br"/>
            </xsl:if>
        </xsl:for-each>
        
    </xsl:template>
    
    
    <xsl:template match="oak:link[@class='gloss']">
        <xsl:element name="a">
            <xsl:attribute name="class">gloss</xsl:attribute>
            <xsl:attribute name="href" select="concat('#gloss', @target)"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- need some more test to check that further-info links  to correct topic -->
    <xsl:template match="oak:link[@class='patient-topic' or @class = 'patient-treatment']">
        <xsl:element name="a">
            <xsl:choose>
                <xsl:when test="contains(@target, 'further-information')">
                    <xsl:variable name="topic" select="concat(substring-before(@target, '/further-information'), '.html')"></xsl:variable>
                    <xsl:variable name="id" select="concat('#', substring-after(@target, 'further-information/'))"></xsl:variable>
                    <xsl:choose>
                        <xsl:when test="starts-with(@target, $resource-name)">
                            <xsl:attribute name="href" select="$id"/>                
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="href" select="concat('../',substring-after(@class, 'patient-'),'s/', $topic, $id)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="contains(@target, 'group')">
                    <xsl:variable name="topic" select="concat(substring-before(@target, '/group'), '.html')"></xsl:variable>
                    <xsl:variable name="id" select="concat('#', replace(substring-after(@target, 'group/'), '/', '-'))"></xsl:variable>
                    <xsl:choose>
                        <xsl:when test="starts-with(@target, $resource-name)">
                            <xsl:attribute name="href" select="$id"/>                
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="href" select="concat('../',substring-after(@class, 'patient-'),'s/', $topic, $id)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>                
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains(@target, '/')">
                            <xsl:variable name="topic" select="concat(substring-before(@target, '/'), '.html')"></xsl:variable>
                            <xsl:variable name="section" select="concat('#', substring-after(@target, '/'))"></xsl:variable>
                            <xsl:choose>
                                <xsl:when test="contains($section, '/')">
                                    <xsl:attribute name="href" select="concat('../', substring-after(@class, 'patient-'),'s/', $topic, replace($section, '/', '-'))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="href" select="concat('../',substring-after(@class, 'patient-'),'s/', $topic, $section)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="href" select="concat('../',substring-after(@class, 'patient-'),'s/', @target, '.html')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:if test="not(contains(@target, $resource-name))">
                    <xsl:attribute name="target">_blank</xsl:attribute>
             </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>                    

    </xsl:template>
    
    <xsl:template match="oak:b">
        <xsl:element name="strong">
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>

    <xsl:template match="oak:i">
        <xsl:element name="em">
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="oak:br">
        <xsl:element name="br" />
    </xsl:template>

    <xsl:template match="oak:span[@class]">
        <xsl:element name="span">
            <xsl:attribute name="class" select="@class" />
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>

    <xsl:template match="oak:inline">
        <xsl:element name="span">
            <xsl:attribute name="class" select="@class" />
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>

    <xsl:template match="oak:list">
        <!-- none bullet 1 a A i I --> 
        <xsl:choose>
            <xsl:when test="@class='none' or not(@class)">
                <xsl:element name="ul">
                    <xsl:attribute name="class" select="@class" />
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
            <xsl:when test="@class='bullet'">
                <xsl:element name="ul">
                    <xsl:attribute name="class" select="@class" />
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
            <xsl:when test="@class='1' or @class='a' or @class='A' or @class='i' or @class='I'">
                <xsl:element name="ol">
                    <xsl:attribute name="class" select="@class" />
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="oak:li">
        <xsl:element name="li">
            <xsl:attribute name="id" select="@id" />
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>

    
    <xsl:template match="oak:notes">
        <xsl:element name="div">
            <xsl:attribute name="class" select="name()"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="oak:gloss">
        
        <xsl:if test="not(preceding-sibling::oak:gloss) and count(ancestor-or-self::*)=2">
            <xsl:text disable-output-escaping="yes">&#13;&lt;div class="gloss"&gt;&#13;</xsl:text>
            <xsl:text disable-output-escaping="yes">&#13;&lt;h</xsl:text>
            <xsl:value-of select="count(ancestor::node())"/>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text>Glossary</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/h</xsl:text>
            <xsl:value-of select="count(ancestor::node())"/>
            <xsl:text disable-output-escaping="yes">&gt;&#13;</xsl:text>
        </xsl:if>
                
        <xsl:element name="p">
            <xsl:attribute name="id" select="concat('gloss',@id)"/>
            <xsl:element name="strong">
                <xsl:apply-templates select="oak:p[@class='term']/node()"/>
            </xsl:element>
            <xsl:text disable-output-escaping="yes"> </xsl:text>
            <xsl:apply-templates select="oak:p[@class='definition']/node()"/>
        </xsl:element>
        
        <xsl:if test="not(following-sibling::oak:gloss) and count(ancestor-or-self::*)=2">
            <xsl:text disable-output-escaping="yes">&#13;&lt;/div&gt;&#13;</xsl:text>
        </xsl:if>
        
    </xsl:template>

    <xsl:template match="oak:references">
        <xsl:element name="div">
            <xsl:attribute name="class" select="name()"/>
            <xsl:element name="{concat('h', (count(ancestor::node())))}">
                <xsl:text>References</xsl:text>
            </xsl:element>
            <xsl:element name="ol">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="oak:reference">
        <xsl:element name="li">
            <!--<xsl:attribute name="value" select="position()"/>-->
            <xsl:attribute name="id" select="concat('ref',@id)"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- we can keep an inline image to para as inline -->
    <xsl:template match="oak:figure"/>
    
    <xsl:template match="oak:table">
        
        <xsl:if test="not(preceding-sibling::oak:table) and count(ancestor-or-self::*)=2">
            <xsl:text disable-output-escaping="yes">&#13;&lt;div class="tables"&gt;&#13;</xsl:text>
            <xsl:text disable-output-escaping="yes">&#13;&lt;h</xsl:text>
            <xsl:value-of select="count(ancestor::node())"/>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text>Tables</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/h</xsl:text>
            <xsl:value-of select="count(ancestor::node())"/>
            <xsl:text disable-output-escaping="yes">&gt;&#13;</xsl:text>
        </xsl:if>
        
        <xsl:element name="table">
            <xsl:attribute name="id" select="@id"/>
            <xsl:choose>
                <xsl:when test="@border">
                            <xsl:attribute name="border" select="@border"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="border">1</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:attribute name="width">100%</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
        
        <xsl:if test="not(following-sibling::oak:table) and count(ancestor-or-self::*)=2">
            <xsl:text disable-output-escaping="yes">&#13;&lt;/div&gt;&#13;</xsl:text>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="oak:thead | oak:tbody | oak:tfoot | oak:tr | oak:td">
        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="name()='td' and ancestor::oak:thead">
                    <xsl:text>th</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="name()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$name}">
            <xsl:copy-of select ="@width | @align | @rowspan | @colspan | @span | @class"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="oak:caption">
        <xsl:element name="caption">
            <xsl:for-each select="oak:p">
                <xsl:apply-templates select="node()"/>
                <xsl:text disable-output-escaping="yes"> </xsl:text>
            </xsl:for-each> 
        </xsl:element>
        <xsl:if test="not(preceding-sibling::oak:table)">
            <xsl:text disable-output-escaping="yes">&#13;&lt;/div&gt;&#13;</xsl:text>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>

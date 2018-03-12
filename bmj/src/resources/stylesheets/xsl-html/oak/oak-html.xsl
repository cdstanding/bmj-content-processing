<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:oak="http://schema.bmj.com/delivery/oak"
    xmlns:bt="http://schema.bmj.com/delivery/oak-bt"
    xmlns:bp="http://schema.bmj.com/delivery/oak-bp"
    xmlns:ce="http://schema.bmj.com/delivery/oak-ce"
    version="2.0"
    exclude-result-prefixes="oak">

    <xsl:output 
        method="xml" 
        version="1.0" 
        encoding="UTF-8" 
        indent="yes"/>
    
    <xsl:param name="proof" />
    <xsl:param name="xmlns" />
    <xsl:param name="toc">false</xsl:param>
    <xsl:param name="toc-depth">2</xsl:param>
    
    <xsl:template match="/*">
        <xsl:element name="html">
            
            <!--<xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>-->

            <xsl:element name="head">
                
                <xsl:element name="meta">
                    <xsl:attribute name="http-equiv">Content-Type</xsl:attribute>
                    <xsl:attribute name="content">text/html; charset=UTF-8</xsl:attribute>
                </xsl:element>

                <xsl:element name="title">
                    <xsl:choose>
                        <xsl:when test="self::oak:section/(self::oak:section | oak:section[1])[1]/oak:title[1]">
                            <xsl:value-of select="self::oak:section/(self::oak:section | oak:section[1])[1]/oak:title[1]"/>                            
                        </xsl:when>
                        <xsl:when test="self::oak:section[1]/oak:section[1]/oak:title[1]">
                            <xsl:value-of select="self::oak:section[1]/oak:section[1]/oak:title[1]"/>                            
                        </xsl:when>
                        <xsl:otherwise>
                            Title
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                
                <!--FIX: use param for location and/or pull in css into html-->
                <xsl:element name="link">
                    <xsl:attribute name="rel">stylesheet</xsl:attribute>
                    <xsl:attribute name="type">text/css</xsl:attribute>
                    <!--<xsl:attribute name="media">print</xsl:attribute>-->
                    <xsl:attribute name="href">../css/oak.css</xsl:attribute>
                </xsl:element>
                
                <xsl:for-each select="tokenize($xmlns,' ')">
                    
                    <xsl:element name="link">
                        <xsl:attribute name="rel">stylesheet</xsl:attribute>
                        <xsl:attribute name="type">text/css</xsl:attribute>
                        <!--<xsl:attribute name="media">print</xsl:attribute>-->
                        <xsl:attribute name="href" select="concat('../css/oak-', normalize-space(.), '.css')" />
                    </xsl:element>
                    
                </xsl:for-each>
                
                <!--<xsl:element name="style">
                    <xsl:attribute name="type" select="'text/css'"/>
                    <xsl:text>div {padding-left: 5px}</xsl:text>
                    </xsl:element>-->
                
                <xsl:element name="script">
                    <!--<xsl:attribute name="langauge">JavaScript</xsl:attribute>-->
                    <xsl:attribute name="type">text/javascript</xsl:attribute>
                    
                    <xsl:text>
                        function doMenu(item) {
                        obj=document.getElementById(item);
                        col=document.getElementById("x" + item);
                        if (obj.style.display=="none") {
                        obj.style.display="block";
                        col.innerHTML="[-]";
                        }
                        else {
                        obj.style.display="none";
                        col.innerHTML="[+]";
                        }
                        }
                    </xsl:text>
                    
                </xsl:element>
                
            </xsl:element>
            
            <xsl:element name="body">
                
                <xsl:element name="div">
                    <xsl:attribute name="class" select="'wrapper'"/>
                    
                    <!-- or use components param here??-->
                    <xsl:if test="$toc = 'true'">
                        <xsl:call-template name="process-toc">
                            <xsl:with-param name="toc-depth" select="$toc-depth"/>
                        </xsl:call-template>
                    </xsl:if>
                    
                    <xsl:apply-templates select="*[name()!='person-group']"/>
                    <xsl:apply-templates select="oak:person-group"/>
                    
                </xsl:element>
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template name="process-toc">
        <xsl:param name="toc-depth"/>
        
        <xsl:element name="div">
            <xsl:attribute name="class">toc</xsl:attribute>
            
            <!--<xsl:element name="h1">
                <xsl:text>Table of Contents</xsl:text>
            </xsl:element>-->
            
            <xsl:if test="$toc-depth &gt;= 1 and /oak:section/oak:section/oak:title">
                
                <xsl:element name="ul">
                    
                    <xsl:for-each select="/oak:section/oak:section">
                        
                        <xsl:element name="li">
                            
                            <xsl:element name="a">
                                <!--<xsl:attribute name="xlink:href">
                                    <xsl:text>//div[@class='</xsl:text>
                                    <xsl:value-of select="@class"/>
                                    <xsl:text>'][1]</xsl:text>
                                </xsl:attribute>-->
                                <xsl:attribute name="href" select="concat('#', @class)"/>
                                <xsl:value-of select="oak:title"/>
                            </xsl:element>
                            
                        </xsl:element>
                        
                        <xsl:if test="$toc-depth &gt;= 2 and oak:section">
                            
                            <xsl:element name="ul">
                                
                                <xsl:for-each select="oak:section">
                                    
                                    <xsl:element name="li">
                                        
                                        <xsl:element name="a">
                                            <xsl:attribute name="href" select="concat('#', @class)"/>
                                            <xsl:value-of select="oak:title"/>
                                        </xsl:element>
                                        
                                    </xsl:element>
                                    
                                </xsl:for-each>
                                
                                <xsl:if test="$toc-depth &gt;= 3 and oak:section">
                                    
                                    <xsl:element name="ul">
                                        
                                        <xsl:for-each select="oak:section">
                                            
                                            <xsl:element name="li">
                                                
                                                <xsl:element name="a">
                                                    <xsl:attribute name="href" select="concat('#', @class)"/>
                                                    <xsl:value-of select="oak:title"/>
                                                </xsl:element>
                                                
                                            </xsl:element>
                                            
                                        </xsl:for-each>
                                        
                                    </xsl:element>
                                    
                                </xsl:if>
                                
                            </xsl:element>
                            
                        </xsl:if>
                        
                    </xsl:for-each>
                
                    <!-- check + add references figures etc. -->
                    
                </xsl:element>
                
            </xsl:if>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="oak:section">
        
        <xsl:if test="string-length(normalize-space(.))!=0">
            
            <xsl:element name="div">
                <xsl:attribute name="class" select="@class"/>
                
                <xsl:if test="@id">
                    <xsl:attribute name="id" select="@id"/>
                </xsl:if>
                
                <xsl:apply-templates/>
                
            </xsl:element>
            
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="oak:abstract">
        
        <xsl:element name="div">
            <xsl:attribute name="class" select="'abstract'"/>
            
            <xsl:element name="{concat('h', (count(ancestor::oak:section[oak:title]) -0))}">
                <xsl:text>Abstract</xsl:text>
            </xsl:element>
            
            <xsl:apply-templates/>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="oak:title">
        
        <xsl:choose>
            
            <!-- first article section title -->
            <!-- TODO: should also test if first title in first section -->
            <xsl:when test="count(ancestor::oak:section) = 1">
                <xsl:element name="h1">
                    <xsl:attribute name="class" select="string('primary-heading')" />
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            
            <!-- header greater than h6 level -->
            <xsl:when test="count(ancestor::oak:section[oak:title]) &gt; 7">
                <xsl:element name="h6">
                    <xsl:attribute name="class" select="parent::oak:section/@class" />
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            
            <xsl:when test="$xmlns='ce'">
                <xsl:element name="{concat('h', (count(ancestor::oak:section[oak:title]) -1))}">
                    <xsl:attribute name="class" select="parent::oak:section/@class" />
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            
            <!-- all other headers -->
            <xsl:otherwise>
                <xsl:element name="{concat('h', count(ancestor::oak:section[oak:title]))}">
                    <xsl:attribute name="class" select="parent::oak:section/@class" />
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="oak:metadata">
        
        <xsl:if test="$proof='draft'">
            
            <xsl:element name="div">
                <xsl:attribute name="class" select="name()"/>
                
                <xsl:element name="h6">
                    <xsl:attribute name="class" select="name()" />
                    <xsl:text>metadata</xsl:text>
                </xsl:element>
                
                <xsl:element name="ul">
                    <xsl:apply-templates/>
                </xsl:element>
                
            </xsl:element>
            
        </xsl:if>
        
    </xsl:template>

    <xsl:template match="oak:key">
        
        <xsl:if test="$proof='draft'">
        
            <xsl:element name="li">
                <xsl:attribute name="class" select="concat(@*:name, '-', @value)" /> 
                <xsl:value-of select="@*:name"/>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="@value"/>
            </xsl:element>
            
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="oak:p">
    
        <xsl:if test="string-length(normalize-space(.))!=0 or element()">
            
            <xsl:element name="p">
                
                <xsl:if test="@id">
                    <xsl:attribute name="id" select="@id"/>
                </xsl:if>
                
                <xsl:if test="@class">
                    <xsl:attribute name="class" select="@class" />
                </xsl:if>
                
                <xsl:apply-templates/>
                
            </xsl:element>
            
        </xsl:if>
        
    </xsl:template>

    <xsl:template match="oak:link">
        
        <xsl:variable name="target" select="@target"/>
        <xsl:variable name="target-id" select="substring-before(substring-after($target, ''''), '''')"/>
        
        <xsl:choose>
            
            <xsl:when test="//oak:reference[@id=$target-id]">
                
                <xsl:for-each select="//oak:reference">
                    
                    <xsl:if test="@id=$target-id">
                        
                        <xsl:element name="a">
                            <xsl:attribute name="href" select="concat('#', $target-id)"/>
                            <xsl:attribute name="class" select="@class"/>
                            
                            <xsl:text>[</xsl:text>
                            <xsl:value-of select="position()"/>
                            <xsl:text>]</xsl:text>
                            
                        </xsl:element>
                        
                    </xsl:if>
                    
                </xsl:for-each>
                
            </xsl:when>
            
            <xsl:otherwise>
                
                <xsl:element name="a">
                    
                    <xsl:attribute name="href">
                        
                        <xsl:choose>
                            
                            <!--assume external uri link-->
                            <xsl:when test="contains($target, 'http') or contains($target, 'www')">
                                <xsl:if test="starts-with($target, 'www')">
                                    <xsl:text>http://</xsl:text>
                                </xsl:if>
                                <xsl:value-of select="$target"/>
                            </xsl:when>
                            
                            <!--assume external document link-->
                            <xsl:when test="contains($target, '#xpointer(id(') and not(starts-with($target, '#xpointer(id('))">
                                <xsl:variable name="filename" select="translate(substring-before($target, '#'), 'xml','html')"/>
                                <xsl:if test="substring-before(substring-after($target, '('), '(') = 'id'">
                                    <xsl:value-of select="concat($filename, '#', $target-id)"/>
                                </xsl:if>
                            </xsl:when>
                            
                            <!--assume internal document link -->
                            <xsl:when test="starts-with($target, '#xpointer(id(')">
                                <xsl:variable name="id" select="substring-before(substring-after($target, ''''), '''')"/>
                                <xsl:value-of select="concat('#', $target-id)"/>
                            </xsl:when>

                            <!--javascript link -->
                            <xsl:when test="starts-with($target, 'JavaScript')">
                                <xsl:value-of select="$target"/>
                            </xsl:when>
                            
                            <!--a default output-->
                            <xsl:otherwise>
                                <xsl:value-of select="concat('#', $target)"/>
                            </xsl:otherwise>
                            
                        </xsl:choose>
                        
                    </xsl:attribute>
                    
                    <xsl:attribute name="class" select="@class"/>
                    
                    <!--ADD: needs reference to javascript-->
                    <xsl:if test="contains($target, 'http') or contains($target, 'www')">
                        <xsl:attribute name="rel" select="'external'"/>
                    </xsl:if>
                    
                    <xsl:choose>
                        
                        <xsl:when test="string-length(normalize-space(.))!=0">
                            <xsl:apply-templates/>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:text>[link]</xsl:text>
                        </xsl:otherwise>
                        
                    </xsl:choose>
                    
                </xsl:element>
                
            </xsl:otherwise>
            
        </xsl:choose>
        
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

    <xsl:template match="oak:span">
        
        <xsl:element name="span">
            <xsl:attribute name="id" select="@id" />
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
            
            <xsl:otherwise>
                <xsl:element name="ol">
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>

    <xsl:template match="oak:li">
        
        <xsl:element name="li">
            
            <xsl:if test="@id">
                <xsl:attribute name="id" select="@id"/>
            </xsl:if>
            
            <xsl:if test="@class">
                <xsl:attribute name="class" select="@class" />
            </xsl:if>
            
            <xsl:apply-templates />
            
        </xsl:element>
        
    </xsl:template>

    <xsl:template match="oak:person-group">
        
        <xsl:element name="div">
            <xsl:attribute name="class" select="name()" />
            
            
            <xsl:choose>
                
                <xsl:when test="$xmlns='ce'">
                    <xsl:element name="{concat('h', (count(ancestor::oak:section[oak:title]) -0))}">
                        <xsl:text>Authors</xsl:text>
                    </xsl:element>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:element name="{concat('h', (count(ancestor::oak:section[oak:title]) +1))}">
                        <xsl:text>Authors</xsl:text>
                    </xsl:element>
                </xsl:otherwise>
                
            </xsl:choose>
            
            <xsl:apply-templates select="oak:person" />
            <xsl:apply-templates select="oak:notes" />
            
        </xsl:element>
        
    </xsl:template>

    <xsl:template match="oak:person">
        
        <xsl:element name="div">
            <xsl:attribute name="class" select="@class"/>
            
            <xsl:element name="p">
                <xsl:apply-templates select="oak:prefix"/>
                <xsl:apply-templates select="oak:given-names"/>
                <xsl:apply-templates select="oak:family-names"/>
                <xsl:apply-templates select="oak:honorific"/>
            </xsl:element>
            
            <!--<xsl:apply-templates select="oak:role"/>-->
            <xsl:apply-templates select="oak:address"/>
            
        </xsl:element>
        
    </xsl:template>

    <xsl:template match="oak:prefix | oak:given-names | oak:family-names">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="oak:honorific">
        
        <xsl:element name="span">
            <xsl:attribute name="class" select="name()"/>
            
            <xsl:apply-templates/>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="oak:address">
        
        <xsl:element name="div">
            <xsl:attribute name="class" select="name()"/>
            
            <xsl:apply-templates select="parent::oak:person/oak:role"/>
            <xsl:apply-templates/>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="oak:role">
        
        <xsl:element name="p">
            <xsl:attribute name="class" select="name()"/>
            
            <xsl:apply-templates/>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="oak:notes">
        
        <xsl:element name="div">
            <xsl:attribute name="class" select="name()"/>
            
            <xsl:apply-templates/>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="oak:date">
        
        <xsl:element name="span">
            <xsl:attribute name="class" select="name()"/>
            
            <xsl:apply-templates/>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="oak:datetime">
        
        <xsl:element name="span">
            <xsl:attribute name="class" select="name()"/>
            
            <xsl:apply-templates/>
            
        </xsl:element>
        
    </xsl:template>

    <xsl:template match="oak:gloss">
        
        <xsl:if test="not(preceding-sibling::oak:gloss) and count(ancestor-or-self::*)=2">
            
            <xsl:text disable-output-escaping="yes">&#13;&lt;div class="gloss"&gt;&#13;</xsl:text>
            
            
            <xsl:choose>
                
                <xsl:when test="$xmlns='ce'">
                    
                    <xsl:text disable-output-escaping="yes">&#13;&lt;h</xsl:text>
                    <xsl:value-of select="count(ancestor::oak:section[oak:title]) -0"/>
                    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                    
                    <xsl:text>Glossary</xsl:text>
                    
                    <xsl:text disable-output-escaping="yes">&lt;/h</xsl:text>
                    <xsl:value-of select="count(ancestor::oak:section[oak:title]) -0"/>
                    <xsl:text disable-output-escaping="yes">&gt;&#13;</xsl:text>
                    
                </xsl:when>
                
                <xsl:otherwise>
                    
                    <xsl:text disable-output-escaping="yes">&#13;&lt;h</xsl:text>
                    <xsl:value-of select="count(ancestor::oak:section[oak:title]) +1"/>
                    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                    
                    <xsl:text>Glossary</xsl:text>
                    
                    <xsl:text disable-output-escaping="yes">&lt;/h</xsl:text>
                    <xsl:value-of select="count(ancestor::oak:section[oak:title]) +1"/>
                    <xsl:text disable-output-escaping="yes">&gt;&#13;</xsl:text>
                    
                </xsl:otherwise>
                
            </xsl:choose>
            
        </xsl:if>
                
        <xsl:element name="p">
            <xsl:attribute name="id" select="@id"/>
            
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
            
            <xsl:choose>
                
                <xsl:when test="$xmlns='ce'">
                    <xsl:element name="{concat('h', (count(ancestor::oak:section[oak:title]) -0))}">
                        <xsl:text>References</xsl:text>
                    </xsl:element>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:element name="{concat('h', (count(ancestor::oak:section[oak:title]) +1))}">
                        <xsl:text>References</xsl:text>
                    </xsl:element>
                </xsl:otherwise>
                
            </xsl:choose>
            
            <xsl:element name="ol">
                <xsl:apply-templates/>
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="oak:reference">
        
        <xsl:element name="li">
            
            <xsl:if test="@id">
                <xsl:attribute name="id" select="@id"/>
            </xsl:if>
            
            <xsl:apply-templates/>
            
        </xsl:element>
        
    </xsl:template>
    
    <!-- we can keep an inline image to para as inline -->
    <xsl:template match="oak:figure[parent::oak:p]">
        
        <xsl:element name="img">
            <xsl:attribute name="src" select="@image"/>
            <xsl:attribute name="border" select="'0'"/>
        </xsl:element>
        
        <xsl:if test="oak:caption[string-length(normalize-space(.))!=0]">
            
            <xsl:element name="div">
                <xsl:attribute name="class" select="'caption'"/>
                <xsl:apply-templates select="oak:caption/node()"/>
            </xsl:element>
            
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="oak:figure[not(parent::oak:p)]">
        
        <xsl:if test="not(preceding-sibling::oak:figure) and count(ancestor-or-self::*)=2">
            
            <xsl:text disable-output-escaping="yes">&#13;&lt;div class="figures"&gt;&#13;</xsl:text>
            
            <xsl:choose>
                
                <xsl:when test="$xmlns='ce'">
                    
                    <xsl:text disable-output-escaping="yes">&#13;&lt;h</xsl:text>
                    <xsl:value-of select="count(ancestor::oak:section[oak:title]) -0"/>
                    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                    
                    <xsl:text>Figures</xsl:text>
                    
                    <xsl:text disable-output-escaping="yes">&lt;/h</xsl:text>
                    <xsl:value-of select="count(ancestor::oak:section[oak:title]) -0"/>
                    <xsl:text disable-output-escaping="yes">&gt;&#13;</xsl:text>
                    
                </xsl:when>
                
                <xsl:otherwise>
                    
                    <xsl:text disable-output-escaping="yes">&#13;&lt;h</xsl:text>
                    <xsl:value-of select="count(ancestor::oak:section[oak:title]) +1"/>
                    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                    
                    <xsl:text>Figures</xsl:text>
                    
                    <xsl:text disable-output-escaping="yes">&lt;/h</xsl:text>
                    <xsl:value-of select="count(ancestor::oak:section[oak:title]) +1"/>
                    <xsl:text disable-output-escaping="yes">&gt;&#13;</xsl:text>
                    
                </xsl:otherwise>
                
            </xsl:choose>
            
        </xsl:if>
        
        <xsl:element name="div">
            <xsl:attribute name="class" select="'figure'"/>
            <xsl:attribute name="id" select="@id"/>
            
            <xsl:element name="img">
                <xsl:attribute name="src" select="@image"/>
                <xsl:attribute name="border" select="'0'"/>
            </xsl:element>
            
            <xsl:if test="oak:caption[string-length(normalize-space(.))!=0]">
                
                <xsl:element name="div">
                    <xsl:attribute name="class" select="'caption'"/>
                    <xsl:apply-templates select="oak:caption/node()"/>
                </xsl:element>
                
            </xsl:if>
            
        </xsl:element>
        
        <xsl:if test="not(following-sibling::oak:figure) and count(ancestor-or-self::*)=2">
            <xsl:text disable-output-escaping="yes">&#13;&lt;/div&gt;&#13;</xsl:text>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="oak:table">
        
        <xsl:if test="not(preceding-sibling::oak:table) and count(ancestor-or-self::*)=2">
            
            <xsl:text disable-output-escaping="yes">&#13;&lt;div class="tables"&gt;&#13;</xsl:text>
            
            <xsl:choose>
                
                <xsl:when test="$xmlns='ce'">
                    
                    <xsl:text disable-output-escaping="yes">&#13;&lt;h</xsl:text>
                    <xsl:value-of select="count(ancestor::oak:section[oak:title]) -0"/>
                    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                    
                    <xsl:text>Tables</xsl:text>
                    
                    <xsl:text disable-output-escaping="yes">&lt;/h</xsl:text>
                    <xsl:value-of select="count(ancestor::oak:section[oak:title]) -0"/>
                    <xsl:text disable-output-escaping="yes">&gt;&#13;</xsl:text>
                    
                </xsl:when>
                
                <xsl:otherwise>
                    
                    <xsl:text disable-output-escaping="yes">&#13;&lt;h</xsl:text>
                    <xsl:value-of select="count(ancestor::oak:section[oak:title]) +1"/>
                    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                    
                    <xsl:text>Tables</xsl:text>
                    
                    <xsl:text disable-output-escaping="yes">&lt;/h</xsl:text>
                    <xsl:value-of select="count(ancestor::oak:section[oak:title]) +1"/>
                    <xsl:text disable-output-escaping="yes">&gt;&#13;</xsl:text>
                    
                </xsl:otherwise>
                
            </xsl:choose>

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
            
            <xsl:apply-templates select="oak:caption" />
            <xsl:apply-templates select="oak:thead" />
            <xsl:apply-templates select="oak:tfoot" />
            <xsl:apply-templates select="oak:tbody" />
            
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
            
            <xsl:copy-of select ="@width | @align | @rowspan | @colspan | @span | @class | @id"/>
            
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
        
        <!--<xsl:if test="not(preceding-sibling::oak:table)">
            <xsl:text disable-output-escaping="yes">&#13;&lt;/div&gt;&#13;</xsl:text>
        </xsl:if>-->
        
    </xsl:template>

    <!-- match any other element, writing it out and calling apply-templates for any children -->
    <!--<xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:comment select="name()"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>-->

</xsl:stylesheet>

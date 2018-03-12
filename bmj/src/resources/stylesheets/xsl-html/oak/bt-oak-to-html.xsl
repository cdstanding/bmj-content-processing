<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:oak="http://www.bmjgroup.com/2007/07/BMJ-OAK"
    xmlns:bt="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"
    xmlns:ce="http://www.bmjgroup.com/2007/07/BMJ-OAK-CE"
    version="2.0">

    <xsl:output method="xml"/>

    <xsl:template match="oak:section">
        <!-- Handle a top-level section (with no parent) as follows -->
        <html>
            <head>
                <!-- use the highest level section title as the page title-->
                <xsl:if test="oak:title">
                    <xsl:element name="title">
                        <xsl:value-of select="oak:title"/>
                    </xsl:element>
                </xsl:if>
                <link rel="stylesheet" type="text/css" href="../css/oak.css"/>
            </head>
            <body>
                <!-- the highest level div container that contains all sections derived from the xml -->
                <div class="container" id="topic-info">
                    <!-- if a section has a class, select it and display it within a comment for now -->
                    <xsl:if test="@class">
                        <xsl:comment>
                            <xsl:text>section-class: </xsl:text>
                            <xsl:value-of select="@class"/>
                        </xsl:comment>
                    </xsl:if>

                    <!--   default top-level section div class which can be overwritten by section class if required -->
                    <div class="main">
                        <xsl:apply-templates/>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- Handle a nested section (that has a parent) as follows -->
    <xsl:template match="oak:section[parent::*]">

        <!-- builds div container for nested section-content only (i.e. not used for abstract, glossary etc)-->
        <xsl:element name="div">
            <xsl:choose>
                <xsl:when test="not(@class)">
                    <!-- select and assign any attributes it does have to a div (other than bt:oen or ce:oen) -->
                    <xsl:for-each select="@*[not(name() = 'bt:oen' or name() = 'ce:oen')] ">
                        <xsl:attribute name="{name()}">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:for-each>
                    <xsl:attribute name="class">
                        <xsl:text>content</xsl:text><!-- presume this is a default value we want to use ?? -->
                    </xsl:attribute>
                </xsl:when>
                <!-- OTHERWISE ASSIGN ALL SECTION ATTRIBUTES TO A DIV (other than bt:oen or ce:oen) -->
                <xsl:otherwise>
                    <xsl:for-each select="@*[not(name() = 'bt:oen' or name() = 'ce:oen')] ">
                        <xsl:attribute name="{name()}">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>

    </xsl:template>

    <!-- match a section title and build an appropriate header tag dependent on level of nesting -->
    <xsl:template match="oak:title">
        <xsl:variable name="headerIndex" select="(count(ancestor::node()) -1)"/>

        <xsl:text disable-output-escaping="yes">&lt;h</xsl:text>
        <xsl:value-of select="$headerIndex"/>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        <xsl:apply-templates/>

        <xsl:text disable-output-escaping="yes">&lt;/h</xsl:text>
        <xsl:value-of select="$headerIndex"/>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="oak:gloss">

        <!-- secondary level div container specifically for glossary -->
        <xsl:element name=" div">
            <xsl:attribute name="class">
                <xsl:value-of select="'glossary'"/>
            </xsl:attribute>
            <xsl:for-each select="@*[not(name() = 'bt:oen' or name() = 'ce:oen')] ">
                <xsl:choose>
                    <!-- add any attribute except "id" to the div calling it by its current name -->
                    <xsl:when test="not(name() = 'id')">
                        <xsl:attribute name="{name()}">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:when>
                    <!-- in the case of the "id" attribute, rename it as "name" before adding it to the div within an anchor tag -->
                    <xsl:otherwise>
                        <xsl:element name="a">
                            <xsl:attribute name="name">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:text disable-output-escaping="yes">&lt;h2&gt;&#13;</xsl:text>
            <xsl:text>Glossary</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/h2&gt;&#13;</xsl:text>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oak:metadata">
        <xsl:element name="div">
            <xsl:element name="h2">
                <xsl:text>metadata</xsl:text>
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oak:key">
        <xsl:element name="p">
            <xsl:text>name: </xsl:text>
            <xsl:choose>
                <xsl:when test="@bt:name">
                    <xsl:value-of select="@bt:name"/>                    
                </xsl:when>
                <xsl:when test="@ce:name">
                    <xsl:value-of select="@ce:name"/>
                </xsl:when>
            </xsl:choose>
            <xsl:text> value:</xsl:text>
            <xsl:value-of select="@value"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oak:summary">
        <!-- secondary level div container specifically for abstract -->
        <div class="abstract">
            <h2>
                <xsl:text>Abstract</xsl:text>
            </h2>
            <xsl:apply-templates select="oak:p"/>
        </div>
    </xsl:template>

    <!-- match p element  with no attributes-->
    <xsl:template match="oak:p">
        <xsl:choose>
            <!-- in these cases, surrounding p tags are not wanted for display reasons -->
            <xsl:when
                test="name(parent::*[1]) = 'reference' or name(parent::*[1]) = 'family-names' or name(child::*[1]) = 'span' ">
                <xsl:apply-templates/>
            </xsl:when>
            <!-- in this case, wrap it in a surrounding p tag of class 'address' -->
            <xsl:when test="name(parent::*[1]) = 'address' ">
                <p id="address">
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <!-- wrap everything else in a surrounding p tag -->
            <xsl:otherwise>
                <xsl:element name="p">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- match p element along with class attribute; currently used with gloss '@term' and '@definition' -->
    <xsl:template match="oak:p[@class]">
        <xsl:variable name="paragraph-class" select="@class"/>
        <!-- if a node is either empty or contains an empty String, do not display it, because it messes up the formatting -->
        <xsl:if test="node()">
            <xsl:if test="not(node()='')">
                <xsl:element name="p">
                    <xsl:attribute name="class">
                        <xsl:value-of select="$paragraph-class"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- eg (internal link) link target="#xpointer(id('bt_t_d1e151'))"  -->
    <!-- eg (external link) link target="1000673117.xml#xpointer(id('topic-info')"-->
    <xsl:template match="oak:link">
        <!-- xsl:if test="node()" -->
            <!-- extract the link id -->
            <xsl:variable name="return-result">
                <xsl:call-template name="process-link">
                    <xsl:with-param name="link" select="@target"/>
                </xsl:call-template>
            </xsl:variable>


            <xsl:choose>

                
                <!-- if any of the link ids (from the main body of the page) match reference link ids (at the bottom of the page) -->
                <xsl:when test="/oak:section/oak:references/oak:reference[@id=$return-result]">
                    <xsl:for-each select="/oak:section/oak:references/oak:reference">
                        
                        <xsl:choose>
                            <xsl:when test="@id=$return-result">
                                <sup>
                                    <xsl:element name="a">
                                        <xsl:attribute name="href">
                                            <!-- target reference anchors directly, building the link in the form #ref followed by reference index number -->
                                            <xsl:value-of select="concat('#ref', position())"/>
                                        </xsl:attribute>
                                        <!-- show reference index as superscript -->
                                        <xsl:value-of select="position()"/>
                                    </xsl:element>
                                </sup>
                            </xsl:when>
                            <xsl:otherwise> </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:comment>not a ref link</xsl:comment>
                    <xsl:element name="a">
                        <xsl:attribute name="href">

                            <xsl:choose>
                                <xsl:when test="contains($return-result, '.')">
                                    <!--it is an external link that has been returned from the process-link template; display 'as is' -->
                                    <xsl:value-of select="$return-result"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- the link is within the same page, so prefix with a #  -->
                                    <xsl:value-of select="concat('#', $return-result)"/>
                                </xsl:otherwise>
                            </xsl:choose>

                        </xsl:attribute>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        <!-- /xsl:if -->
    </xsl:template>

    <!-- This template returns  to caller: a 'complete' external link, but only the 'extracted id' of an internal link-->
    <xsl:template name="process-link">
        <xsl:param name="link"/>
        <!-- choose between an external or internal link -->
        <xsl:choose>
            <!-- external link-->
            <xsl:when test="substring-before($link,'#')">
                <xsl:variable name="filename" select="substring-before($link,'#')"/>
                <!-- swap the file extension .html for .xml -->

                
                <!-- xsl:variable name="html-filename" select="translate($filename, 'xml', 'html')"/ -->
                
                <xsl:variable name="html-filename" select="concat(substring-before($filename, '.xml'),'.html')"/>
                
                
                
                <xsl:if test="substring-before(substring-after($link, '('), '(') = 'id'">
                    <xsl:variable name="id"
                        select="substring-before(substring-after($link, ''''), '''')"/>
                    
                    <!--<xsl:value-of select="concat($filename,'#', $id)"/>-->
                    <xsl:value-of select="concat($html-filename,'#', $id)"/>
                </xsl:if>
            </xsl:when>
            <!-- internal link -->
            <xsl:otherwise>
                <xsl:if test="substring-before(substring-after($link, '('), '(') = 'id'">
                    <xsl:variable name="id"
                        select="substring-before(substring-after($link, ''''), '''')"/>
                    <xsl:value-of select="$id"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="oak:b">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>

    <xsl:template match="oak:i">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <xsl:template match="oak:span[@class]">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="@class"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- match figure element and display within a table -->
    <xsl:template match="oak:figure">
                <xsl:element name="a">
                    <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
                </xsl:element>
        
        
        <xsl:element name="table">
        
            <xsl:element name="tr">
                <xsl:element name="td">
                    <!-- call named template to return img tag -->
                    <xsl:call-template name="buildImgTag">
                        <xsl:with-param name="figure">
                            <xsl:value-of select="."/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:element>
            </xsl:element>
            <xsl:element name="tr">
                <xsl:element name="td">
                    
                    <xsl:apply-templates select="./oak:caption/node()"/>
                     
                    
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- match figure element (and display without a table) -->
    <xsl:template match="oak:figure[@templateEffectivelyCommentedOutForTheTimeBeing]">
        <xsl:choose>
            <!-- if the figure occurs within a p tag -->
            <xsl:when test="name(parent::*[1]) = 'p'">
                <!-- close p tag -->
                <xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
                <xsl:call-template name="buildImgTag">
                    <xsl:with-param name="figure">
                        <xsl:value-of select="."/>
                    </xsl:with-param>
                </xsl:call-template>
                <!-- reopen p tag -->
                <xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="buildImgTag">
                    <xsl:with-param name="figure">
                        <xsl:value-of select="."/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- build the img tag -->
    <xsl:template name="buildImgTag">
        <xsl:param name="figure"/>
        <xsl:element name="img">
            <xsl:attribute name="src">../<xsl:value-of select="@image"/></xsl:attribute>
            <xsl:attribute name="border">
                <xsl:value-of select="'0'"/>
            </xsl:attribute>
<!--
            <div class="caption">
                <xsl:value-of select="child::*[1]/descendant-or-self::*[position() = last()]"/>
            </div>
-->
    </xsl:element>
    </xsl:template>

    <!-- match table element, outputting successive nested elements, tbody, tr, td by calling apply templates on each -->
    <xsl:template match="oak:table">
        <xsl:element name="table">
            <xsl:attribute name="id" select="@id"/>
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
    </xsl:template>

    <xsl:template match="oak:tbody">
        <xsl:element name="tbody">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oak:thead">
        <xsl:element name="thead">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oak:tr">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="oak:td">
        <xsl:element name="td">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- match inline element if it is a list -->
    <xsl:template match="oak:inline[name(child::*[1]) = 'list']">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- replace the list tag with a ul tag and call apply-templates for li -->
    <xsl:template match="oak:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="oak:li">
        <xsl:element name="li">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- match person-group element -->
    <xsl:template match="oak:person-group">
        <!-- secondary level div container specifically for abstract -->
        <div class="personnel">
            <h2>
                <xsl:text>Authors</xsl:text>
            </h2>
            <xsl:apply-templates select="oak:person"/>
        </div>
    </xsl:template>

    <!-- match person element -->
    <xsl:template match="oak:person">
        <div class="person">
            <p>
                <xsl:apply-templates select="oak:prefix"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="oak:given-names"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="oak:family-names"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="oak:honorific"/>
            </p>
            <xsl:apply-templates select="oak:address"/>
        </div>
    </xsl:template>

    <xsl:template match="oak:prefix">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="oak:given-names">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="oak:family-names">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="oak:honorific">
        <span class="honorific">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="oak:references">
        <xsl:element name="div">
            <xsl:attribute name="class" select="name()"/>
            <xsl:element name="h3">
                <xsl:text>References</xsl:text>
            </xsl:element>
            <xsl:element name="ol">
                <xsl:for-each select="oak:reference">
                    <xsl:element name="li">
                        <!--<xsl:attribute name="value" select="position()"/>-->
                        <xsl:attribute name="id" select="concat('ref', position())"/>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- format date contained within callling p tag -->
    <xsl:template match="oak:date">
        <span class="date">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    

    <!-- match any other element, writing it out and calling apply-templates for any children -->
    <xsl:template match="*" mode="#all">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>

            <xsl:comment>[<xsl:value-of select="name()"/>]</xsl:comment>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>

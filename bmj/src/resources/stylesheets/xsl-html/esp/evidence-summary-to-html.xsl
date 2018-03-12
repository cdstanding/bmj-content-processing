<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"   
    exclude-result-prefixes="legacytag"
    version="2.0">
    
    <xsl:output method="html"
        indent="yes"
        encoding="UTF-8"
        doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
    />
    
    <!-- 
        
        Publication business rules
        
        X monograph content                en-au and en-gb get UK version of content, en-us get US version
        X ce content                                 all publications have this content
        X bt summs                                 all publications have this content
        X related links                              display accorrding to lang selection, if lang = none then display. 
        X performance measure           display accorrding to lang selection, if lang = none then display
        X external link                              display accorrding to lang selection, if lang = none then display
        
    -->
    
    <xsl:param name="pub-stream"/>
    <xsl:param name="ukdir"/>
    <xsl:param name="usdir"/>
    <xsl:param name="published-date"/>
    <xsl:param name="amended-date"/>
    <xsl:param name="last-update"/>
    
    <xsl:param name="upper" select="'AABCDEFGHIJKLMNOPQRSTUVWXYZÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝ'"/>
    <xsl:param name="lower" select="'abcdefghijklmnopqrstuvwxyzáâãäåæçèéêëìíîïðñòóôõöøùúûüý'"/>
 
    <xsl:variable name="ceweb"><xsl:value-of>http://clinicalevidence.bmj.com/ceweb/conditions/abc/</xsl:value-of></xsl:variable>
    <xsl:variable name="ukmonoweb"><xsl:value-of>http://bestpractice.bmj.com/best-practice/monograph/</xsl:value-of></xsl:variable>
    <xsl:variable name="usmonoweb"><xsl:value-of>http://bestpracticedx.bmj.com/best-practice-dx/monograph/</xsl:value-of></xsl:variable>
 
    <xsl:strip-space elements="*"/>
 
    <xsl:template match="/*">
        <xsl:element name="html">
            
            <xsl:comment>pub stream: <xsl:value-of select="$pub-stream"/></xsl:comment>
            
            <xsl:element name="head">
                <xsl:element name="title">
                    <xsl:value-of select="/evidence-summary/summary-info/title"/>
                </xsl:element>

                <xsl:element name="link">
                    <xsl:attribute name="rel">stylesheet</xsl:attribute>
                    <xsl:attribute name="type">text/css</xsl:attribute>
                    <xsl:attribute name="href">http://resources.bmj.com/repository/css/global.css</xsl:attribute>
                </xsl:element>

                <xsl:element name="link">
                    <xsl:attribute name="rel">stylesheet</xsl:attribute>
                    <xsl:attribute name="type">text/css</xsl:attribute>
                    <xsl:attribute name="href">../css/import.css</xsl:attribute>
                </xsl:element>
                
                <xsl:element name="link">
                    <xsl:attribute name="rel">stylesheet</xsl:attribute>
                    <xsl:attribute name="type">text/css</xsl:attribute>
                    <xsl:attribute name="media">print</xsl:attribute>
                    <xsl:attribute name="href">../css/print.css</xsl:attribute>
                </xsl:element>

                <xsl:element name="script">
                    <xsl:attribute name="language">JavaScript</xsl:attribute>
                    <xsl:attribute name="type">text/javascript</xsl:attribute>
                    <xsl:attribute name="src">http://resources.bmj.com/repository/js/jquery-1.2.2.pack.js</xsl:attribute>
                </xsl:element>

                <xsl:element name="script">
                    <xsl:attribute name="language">JavaScript</xsl:attribute>
                    <xsl:attribute name="type">text/javascript</xsl:attribute>
                    <xsl:attribute name="src">../js/main.js</xsl:attribute>
                </xsl:element>

                <xsl:element name="script">
                    <xsl:attribute name="language">JavaScript</xsl:attribute>
                    <xsl:attribute name="type">text/javascript</xsl:attribute>
                    <xsl:attribute name="src">../js/jquery.url.js</xsl:attribute>
                </xsl:element>
                
            </xsl:element>

            <xsl:element name="body">
             
                 <!-- header start -->
                <xsl:element name="div">
                    <xsl:attribute name="id">header</xsl:attribute>

                    <xsl:element name="div">
                        <xsl:attribute name="id">logo</xsl:attribute>
                        <xsl:element name="a">
                            <xsl:attribute name="href">#</xsl:attribute>
                            <xsl:element name="img">
                                <xsl:attribute name="title">BMJ Evidence Centre</xsl:attribute>
                                <xsl:attribute name="alt">BMJ Evidence Centre</xsl:attribute>
                                <xsl:attribute name="src">../images/evidence-centre-logo.gif</xsl:attribute>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    
                    <xsl:element name="h1">
                        <xsl:attribute name="class">clearfix</xsl:attribute>Evidence summary for<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;<xsl:value-of select="/evidence-summary/summary-info/title"/>
                    </xsl:element>
                    
                    <xsl:element name="div">
                        <xsl:attribute name="id">page-tools</xsl:attribute>
                        <xsl:element name="div">
                            <xsl:attribute name="class">button</xsl:attribute>
                            <xsl:element name="a">
                                <xsl:attribute name="href">javascript:this.print();</xsl:attribute>
                                <xsl:attribute name="class">print</xsl:attribute>
                                <xsl:attribute name="title">Print full summary</xsl:attribute>
                                <xsl:attribute name="alt">Print full summary</xsl:attribute>
                                <xsl:text>Print full summary</xsl:text>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    
                </xsl:element>
                <xsl:comment>header div end</xsl:comment>
                <!-- header end -->
                
                <xsl:element name="div">
                        <xsl:attribute name="id">wrapper</xsl:attribute>

                        <xsl:element name="div">
                            <xsl:attribute name="id">content</xsl:attribute>
                            <xsl:attribute name="class"></xsl:attribute>

                                <xsl:element name="div">
                                    <xsl:attribute name="class">body-copy</xsl:attribute>
                                    
                                     <!-- main content -->
                                    <xsl:apply-templates/>

                                    <xsl:element name="p">
                                        <xsl:attribute name="class">methodology</xsl:attribute>
                                        <xsl:text>BMJ Order Entry Sets are created and updated using a rigorous and consistent methodology. Full details are available </xsl:text>
                                        <xsl:element name="a">
                                            <xsl:attribute name="class">external-link</xsl:attribute>
                                            <xsl:attribute name="href">../marketing/our-methodology.html</xsl:attribute>
                                            <xsl:text>here</xsl:text>
                                        </xsl:element>
                                        <xsl:text>.</xsl:text>
                                    </xsl:element> 

                                    <xsl:element name="p">
                                        <xsl:text>Use of this content is subject to our </xsl:text> 
                                        <xsl:element name="a">
                                            <xsl:attribute name="class">external-link</xsl:attribute>
                                            <xsl:attribute name="href">../marketing/disclaimer.html</xsl:attribute>
                                            <xsl:text>disclaimers</xsl:text>
                                        </xsl:element>
                                        <xsl:text>.</xsl:text>
                                    </xsl:element> 
                                    
                                </xsl:element> 
                                <xsl:comment>body-copy div end</xsl:comment>
                                
                        </xsl:element>    
                        <xsl:comment>content div end</xsl:comment>
    
                        <xsl:element name="div">
                            <xsl:attribute name="class">clear</xsl:attribute>
                        </xsl:element>
    
                    </xsl:element>
                    <xsl:comment>wrapper div end</xsl:comment>
            </xsl:element>        

            <!-- footer start -->
            <xsl:element name="div">
                <xsl:attribute name="id">footer</xsl:attribute>

                <xsl:element name="div">
                    <xsl:attribute name="class">issn</xsl:attribute>
                    <xsl:element name="p"><xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;</xsl:element>
                </xsl:element>
    
                <xsl:element name="div">
                    <xsl:attribute name="class">legal</xsl:attribute>
                    <xsl:element name="ul">

                        <xsl:element name="li">
                            <xsl:element name="a">
                                <xsl:attribute name="href">../marketing/disclaimer.html</xsl:attribute>
                                <xsl:value-of>Disclaimer</xsl:value-of>
                            </xsl:element>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
                        </xsl:element>

                        <xsl:element name="li">
                            <xsl:element name="a">
                                <xsl:attribute name="href">http://group.bmj.com/group/about/revenue-sources</xsl:attribute>
                                <xsl:value-of>Revenue sources</xsl:value-of>
                            </xsl:element>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
                        </xsl:element>

                        <xsl:element name="li">
                            <xsl:element name="a">
                                <xsl:attribute name="href">http://group.bmj.com/group/about/legal/terms/</xsl:attribute>
                                <xsl:value-of>Website terms &amp; conditions</xsl:value-of>
                            </xsl:element>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
                        </xsl:element>
                        
                        <xsl:element name="li">
                            <xsl:element name="a">
                                <xsl:attribute name="href">http://group.bmj.com/group/about/legal/privacy/</xsl:attribute>
                                <xsl:value-of>Privacy policy</xsl:value-of>
                            </xsl:element>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
                        </xsl:element>
                        
                        <xsl:element name="li">
                            <xsl:element name="a">
                                <xsl:attribute name="href">http://group.bmj.com/products/evidence-centre/</xsl:attribute>
                                <xsl:value-of>About us</xsl:value-of>
                            </xsl:element>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
                        </xsl:element>
                        
                        <xsl:element name="li">
                            <xsl:element name="a">
                                <xsl:attribute name="href">http://group.bmj.com/group/contact-address/</xsl:attribute>
                                <xsl:value-of>Contact us</xsl:value-of>
                            </xsl:element>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;|<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
                        </xsl:element>
                        
                        <xsl:element name="li">
                            <xsl:element name="a">
                                <xsl:attribute name="href">javascript:scrollTo(0,0);</xsl:attribute>
                                <xsl:value-of>Top</xsl:value-of>
                            </xsl:element>
                        </xsl:element>
                        
                    </xsl:element>
                </xsl:element>
                
                <xsl:element name="div">
                    <xsl:attribute name="class">legal-copyright</xsl:attribute>
                    <xsl:element name="p">
                        <xsl:if test="$published-date != ''">
                            Published <xsl:value-of select="$published-date"/>.
                            <xsl:text></xsl:text>
                        </xsl:if>
                        <xsl:if test="$last-update != ''">
                            Last updated<xsl:value-of select="$last-update"/>.
                            <xsl:text></xsl:text>
                        </xsl:if>           
                        <xsl:if test="$amended-date != ''">
                            Last amended <xsl:value-of select="$amended-date"/>.
                            <xsl:text></xsl:text>
                        </xsl:if>  
                        <xsl:value-of>© BMJ Publishing Group Limited 2010. All rights reserved.</xsl:value-of>
                    </xsl:element>
                </xsl:element>
                
                <xsl:element name="div">
                    <xsl:attribute name="class">sub-brand</xsl:attribute>
                </xsl:element>
            </xsl:element>
            <xsl:comment>footer div end</xsl:comment>
            <!-- footer end -->
            
        </xsl:element>
    </xsl:template>

    <xsl:template match="summary-info">
        
        <xsl:apply-templates select="scope"/>

        <!-- nav links for the diff sections -->
        <xsl:element name="p">
            <xsl:attribute name="class">featured</xsl:attribute>
            <xsl:text>In this summary: </xsl:text> 
            <xsl:element name="a">
                <xsl:attribute name="href"></xsl:attribute>
                <xsl:text>Show all</xsl:text>
            </xsl:element>
        </xsl:element>
        
        <xsl:element name="ul">
            <xsl:attribute name="class">tabNavigation</xsl:attribute>

            <xsl:if test="definition[internal-evidence-link]">
                <xsl:element name="li" ><xsl:element name="a"><xsl:attribute name="href">#definition</xsl:attribute>Definition</xsl:element></xsl:element>
            </xsl:if>

            <xsl:if test="classification[string-length(normalize-space(.))!=0] or classification//internal-evidence-link">
                <xsl:element name="li"><xsl:element name="a"><xsl:attribute name="href">#classification</xsl:attribute>Classification</xsl:element></xsl:element>
            </xsl:if>

            <xsl:element name="li"><xsl:element name="a"><xsl:attribute name="href">#resources</xsl:attribute>Resources</xsl:element></xsl:element>
            
            <!-- loop the categories -->
            <xsl:for-each select="//category">

                <xsl:element name="li">
                    <xsl:element name="a">
                        <xsl:attribute name="href">#<xsl:value-of select="replace(@class,' ','-')"/></xsl:attribute>
                        <xsl:value-of select="replace(concat(translate(substring(@class,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),substring(@class,2,string-length(@class))),'-',' ')"/>
                    </xsl:element>
                </xsl:element>
                
            </xsl:for-each>

        </xsl:element>
        
        <xsl:if test="definition[internal-evidence-link]">
            <xsl:element name="div">
                <xsl:attribute name="id">definition</xsl:attribute>
                <xsl:element name="div">
                    <xsl:attribute name="class">content-block</xsl:attribute>
                    <xsl:element name="h1">Definition</xsl:element>
                    <xsl:element name="a">
                        <xsl:attribute name="name">definition</xsl:attribute>
                    </xsl:element>
                    <xsl:apply-templates select="definition"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        
        <xsl:if test="classification[string-length(normalize-space(.))!=0] or classification//internal-evidence-link">
            <xsl:element name="div">
                <xsl:attribute name="id">classification</xsl:attribute>
                <xsl:element name="div">
                    <xsl:attribute name="class">content-block</xsl:attribute>
                    <xsl:element name="h1">Classification</xsl:element>
                    <xsl:element name="a">
                        <xsl:attribute name="name">classification</xsl:attribute>
                    </xsl:element>
                    <xsl:apply-templates select="classification"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        
        <xsl:element name="div">
            <xsl:attribute name="id">resources</xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">content-block</xsl:attribute>
                <xsl:element name="h1">Resources</xsl:element>
                <xsl:element name="a">
                    <xsl:attribute name="name">resources</xsl:attribute>
                </xsl:element>
            
                <!-- related resources section -->
                <xsl:element name="p">
                    <xsl:element name="strong">
                        <xsl:text>The order entry set and evidence summary page have been created with reference to the following sources:</xsl:text>
                    </xsl:element>
                </xsl:element>
            
                <xsl:element name="div">
                    <xsl:attribute name="class">source</xsl:attribute>
                    
                    <xsl:element name="h4">Information from:</xsl:element>
                    
                    <!-- print out related ce topics -->
                    <xsl:apply-templates select="/evidence-summary/summary-info/ce-links"/>
                    
                    <!-- print out related monograph topics -->
                    <xsl:apply-templates select="/evidence-summary/summary-info/mono-links"/>
                    
                    <!-- loop related links -->
                    
                    <!-- only do this if there are actually links to display -->
                    
                    <xsl:if test="(/evidence-summary/summary-info/related-resources/external-evidence-link[@lang='none'] or /evidence-summary/summary-info/related-resources/external-evidence-link[@lang=$pub-stream])">
                        
                        <xsl:for-each select="/evidence-summary/summary-info/related-resources/external-evidence-link">
                            
                            <!-- display accorrding to lang selection, if lang = none then display -->
                            <xsl:variable name="lang"><xsl:value-of select="@lang"/></xsl:variable>
                            <xsl:comment>related link pub-stream:<xsl:value-of select="$pub-stream"/> lang:<xsl:value-of select="$lang"/></xsl:comment>
                            
                            <xsl:choose>
                                <xsl:when test="$lang=$pub-stream or $lang='none'">
                                    <xsl:element name="p" xml:space="default">
                                        <xsl:if test="uri-link/@lang!='none' and uri-link/@lang!=''">
                                            <xsl:element name="img">
                                                <xsl:attribute name="class">image-inline</xsl:attribute>
                                                <xsl:attribute name="alt">flag</xsl:attribute>
                                                <xsl:attribute name="src" select="concat('../images/flag-', uri-link/@lang, '.gif')"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="a">
                                            <xsl:attribute name="class">external-link</xsl:attribute>
                                            <xsl:attribute name="target">_blank</xsl:attribute>
                                            <xsl:attribute name="href" select="uri-link/@href"/>
                                            <xsl:value-of select="uri-link"/>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>                        
                        </xsl:for-each>
                        
                    </xsl:if>
                    
                </xsl:element>
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>

    <xsl:template match="classification[string-length(normalize-space(.))!=0]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="ce-links">
        <xsl:comment>Related CE links</xsl:comment>
        
            <xsl:for-each-group select="celink" group-by="@href">
            <xsl:element name="p">
                <xsl:attribute name="class">clinical-evidence</xsl:attribute>
                <xsl:element name="a">
                    <xsl:attribute name="class">external-link</xsl:attribute>
                    <xsl:attribute name="target">_blank</xsl:attribute>
                    <xsl:attribute name="href" select="current-grouping-key()"/>
                    <xsl:element name="em">
                        <xsl:text>Clinical Evidence</xsl:text>
                    </xsl:element>
                    <xsl:text>: </xsl:text>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:element>
        </xsl:for-each-group>

    </xsl:template>

    <xsl:template match="mono-links">
        <xsl:comment>Related monograph links</xsl:comment>

            <xsl:for-each-group select="monolink" group-by="@href">
                <xsl:element name="p">
                    <xsl:attribute name="class">best-practice</xsl:attribute>
                    
                    <!-- make them non-clickable if for US site -->    
                    <xsl:choose>
                        <xsl:when test="$pub-stream='en-us'">
                            <xsl:element name="em">
                                <xsl:text>BMJ Point of Care</xsl:text>
                            </xsl:element>
                            <xsl:text>: </xsl:text>
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="a">
                                <xsl:attribute name="class">external-link</xsl:attribute>
                                <xsl:attribute name="target">_blank</xsl:attribute>
                                <xsl:attribute name="href" select="current-grouping-key()"/>
                                <xsl:element name="em">
                                    <xsl:text>Best Practice</xsl:text>
                                </xsl:element>
                                <xsl:text>: </xsl:text>
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                </xsl:element>
            </xsl:for-each-group>

    </xsl:template>

    <xsl:template match="categories">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="category">
        
        <xsl:element name="div">
            <xsl:attribute name="id"><xsl:value-of select="replace(@class,' ','-')"/></xsl:attribute>
            <xsl:element name="div">
                <xsl:attribute name="class">content-block</xsl:attribute>
                <xsl:element name="h1">
                    <xsl:value-of select="replace(concat(translate(substring(@class,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),substring(@class,2,string-length(@class))),'-',' ')"/>
                </xsl:element>
                <xsl:element name="a">
                    <xsl:attribute name="name"><xsl:value-of select="replace(@class,' ','-')"/></xsl:attribute>
                </xsl:element>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    
    </xsl:template>

    <xsl:template match="external-evidence-link">
        <!--  display accorrding to lang selection, if lang = none then display -->
        <xsl:variable name="lang"><xsl:value-of select="@lang"/></xsl:variable>
        <xsl:variable name="class"><xsl:value-of select="@class"/></xsl:variable>
        
        <xsl:comment>external-evidence-link pub-stream:<xsl:value-of select="$pub-stream"/> lang:<xsl:value-of select="$lang"/> class:<xsl:value-of select="$class"/></xsl:comment>
        
        <xsl:choose>
            <xsl:when test="$lang=$pub-stream or $lang='none'">
                <xsl:apply-templates select="heading|sub-heading|p|ol|ul|table"/>
                
                <xsl:element name="div">
                    <xsl:attribute name="class">source</xsl:attribute>
                    <xsl:element name="h4">Information from:</xsl:element>
                    <xsl:apply-templates select="uri-link"/>
                </xsl:element>
                
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        
    </xsl:template>

    <xsl:template match="performance-measure">
        
        <!--  display accorrding to lang selection, if lang = none then display -->
        <xsl:variable name="lang"><xsl:value-of select="@lang"/></xsl:variable>

        <xsl:comment>performance measure pub-stream:<xsl:value-of select="$pub-stream"/> lang:<xsl:value-of select="$lang"/></xsl:comment>

        <xsl:choose>
            <xsl:when test="$lang=$pub-stream or $lang='none'">
                
                <xsl:apply-templates select="heading"/>
                
                <xsl:element name="table">
                    <xsl:attribute name="rules">all</xsl:attribute>
                    <xsl:attribute name="frame">box</xsl:attribute>
                    <xsl:attribute name="class">default</xsl:attribute>
                    
                    <xsl:element name="tbody">
                        <xsl:element name="tr">
                            <xsl:element name="td">
                                <xsl:element name="strong">
                                    <xsl:value-of>DESCRIPTION</xsl:value-of>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="td">
                                <xsl:apply-templates select="description"/>
                            </xsl:element>
                        </xsl:element>

                        <xsl:element name="tr">
                            <xsl:element name="td">
                                <xsl:element name="strong">
                                    <xsl:value-of>RATIONALE</xsl:value-of>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="td">
                                <xsl:apply-templates select="rationale"/>
                            </xsl:element>
                        </xsl:element>

                        <xsl:if test="clinical-recommendations/node()">
                            <xsl:element name="tr">
                                <xsl:element name="td">
                                    <xsl:element name="strong">
                                        <xsl:value-of>CLINICAL RECOMMENDATION STATEMENTS</xsl:value-of>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="td">
                                    <xsl:apply-templates select="clinical-recommendations"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>

                    </xsl:element>
                </xsl:element>

                <xsl:element name="div">
                    <xsl:attribute name="class">source</xsl:attribute>
                    <xsl:element name="h4">Information from:</xsl:element>
                    <xsl:apply-templates select="uri-link"/>
                </xsl:element>
                
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        
    </xsl:template>

    <xsl:template name="doc-location">
        <xsl:param name="target"/>
        <xsl:variable name="targetChop"><xsl:value-of select="replace($target, '\.\./', '')"/></xsl:variable>
        <xsl:choose>
            <xsl:when test="$pub-stream='en-us'">
                <xsl:value-of select="concat($usdir,$targetChop)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($ukdir,$targetChop)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="internal-evidence-link">
        
        <!-- display according to lang pub business rules -->
        <xsl:variable name="lang" select="@lang"/>
        <xsl:variable name="class" select="@class"/>
        
        <xsl:variable name="generate-id" select="generate-id()"/>
        
        <xsl:apply-templates select="heading|sub-heading|p|ol|ul|table"/>

        <xsl:for-each select="es-internal-link">

            <xsl:variable name="target" select="@target"/>
            <xsl:variable name="xpath" select="@xpointer"/>

            <!-- 
                if pub stream is US then select US version of the monograph else use UK version
            -->
           
            <xsl:variable name="doclocation">
                <xsl:call-template name="doc-location">
                    <xsl:with-param name="target" select="@target"/>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="doc" select="document($doclocation)"/>
            
            <!-- 
                cant seem to pass the xpath as a variable - use a nasty if else statement 
            -->
            <xsl:choose>
                <xsl:when test="$xpath = 'basics/definition'">
                    <xsl:apply-templates select="$doc//basics/definition" />
                </xsl:when>
                <xsl:when test="$xpath = 'basics/risk-factors'">
                    <xsl:apply-templates select="$doc//basics/risk-factors" />
                </xsl:when>
                <xsl:when test="$xpath = 'basics/prevention'">
                    <xsl:apply-templates select="$doc//basics/prevention" />
                </xsl:when>
                <xsl:when test="$xpath = 'basics/classifications'">
                    <xsl:apply-templates select="$doc//basics/classifications" />
                </xsl:when>
                <xsl:when test="$xpath = 'diagnosis/diagnostic-factors'">
                    <xsl:apply-templates select="$doc//diagnosis/diagnostic-factors" />
                </xsl:when>
                <xsl:when test="$xpath = 'diagnosis/approach'">
                    <xsl:apply-templates select="$doc//diagnosis/approach" />
                </xsl:when>
                <xsl:when test="$xpath = 'diagnosis/screening'">
                    <xsl:apply-templates select="$doc//diagnosis/screening" />
                </xsl:when>
                <xsl:when test="$xpath = 'diagnosis/tests'">
                    <xsl:apply-templates select="$doc//diagnosis/tests" />
                </xsl:when>
                <xsl:when test="$xpath = 'diagnosis/differentials'">
                    <xsl:apply-templates select="$doc//diagnosis/differentials" />
                </xsl:when>
                <xsl:when test="$xpath = 'diagnosis/diagnostic-criteria'">
                    <xsl:element name="h2">Diagnostic criteria</xsl:element>
                    <xsl:element name="a">
                        <xsl:attribute name="name">diagnostic-criteria</xsl:attribute>
                    </xsl:element>
                    <xsl:apply-templates select="$doc//diagnosis/diagnostic-criteria" />
                </xsl:when>
                <xsl:when test="$xpath = 'diagnosis/guidelines'">
                    <xsl:apply-templates select="$doc//diagnosis/guidelines" />
                </xsl:when>
                <xsl:when test="$xpath = 'treatment/approach'">
                    <xsl:element name="h2">Treatment approach</xsl:element>
                    <xsl:element name="a">
                        <xsl:attribute name="name">treatment-approach</xsl:attribute>
                    </xsl:element>
                    <xsl:apply-templates select="$doc//treatment/approach" />
                </xsl:when>
                <xsl:when test="$xpath = 'treatment/emerging-txs'">
                    <xsl:apply-templates select="$doc//treatment/emerging-txs" />
                </xsl:when>
                <xsl:when test="$xpath = 'followup/recommendations'">
                    <xsl:element name="h2">Follow up recommendations</xsl:element>
                    <xsl:element name="a">
                        <xsl:attribute name="name">follow-up-recommendations</xsl:attribute>
                    </xsl:element>
                    <xsl:apply-templates select="$doc//followup/recommendations" />
                </xsl:when>
                <xsl:when test="$xpath = 'followup/complications'">
                    <xsl:apply-templates select="$doc//followup/complications" />
                </xsl:when>
                <xsl:when test="$xpath = 'followup/outlook'">
                    <xsl:apply-templates select="$doc//followup/outlook" />
                </xsl:when>

                <!-- TODO eval elements -->
                 <xsl:when test="$xpath = 'monograph-eval/overview'">
                     <xsl:apply-templates select="$doc//monograph-eval/overview" />
                </xsl:when>
                 <xsl:when test="$xpath = 'monograph-eval/ddx-etiology'">
                        <xsl:apply-templates select="$doc//monograph-eval/ddx-etiology" />
                </xsl:when>
                 <xsl:when test="$xpath = 'monograph-eval/urgent-considerations'">
                        <xsl:apply-templates select="$doc//monograph-eval/urgent-considerations" />
                </xsl:when>
                 <xsl:when test="$xpath = 'monograph-eval/diagnostic-approach'">
                        <xsl:apply-templates select="$doc//monograph-eval/diagnostic-approach" />
                </xsl:when>
                <xsl:when test="$xpath = 'differential'">
                    
                    <xsl:element name="h3">
                        
                        <xsl:apply-templates select="$doc//differential/ddx-name"/>
                    
                        <xsl:if test="$doc//differential[@common='true']">
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
                            <xsl:element name="span">
                                <xsl:attribute name="class">frequency</xsl:attribute>
                                Common
                            </xsl:element>
                        </xsl:if>
                        
                        <xsl:if test="$doc//differential[@common='false']">
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
                            <xsl:element name="span">
                                <xsl:attribute name="class">frequency</xsl:attribute>
                                Uncommon
                              </xsl:element>    
                        </xsl:if>
                    
                    </xsl:element>
                    
                    <xsl:element name="table">
                        <xsl:attribute name="rules">all</xsl:attribute>
                        <xsl:attribute name="frame">box</xsl:attribute>
                        <xsl:attribute name="class">default</xsl:attribute>
                        
                        
                        <xsl:element name="tbody">
                            <xsl:element name="tr">
                                <xsl:element name="td">
                                    <xsl:element name="strong">
                                        <xsl:value-of>History</xsl:value-of>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="td">
                                    <xsl:element name="strong">
                                        <xsl:value-of>Exam</xsl:value-of>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="td">
                                    <xsl:element name="strong">
                                        <xsl:value-of>1st test</xsl:value-of>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="td">
                                    <xsl:element name="strong">
                                        <xsl:value-of>Other tests</xsl:value-of>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                            
                            <xsl:element name="tr">
                                <xsl:element name="td">
                                    <xsl:apply-templates select="$doc//differential/history/text()"/>
                                </xsl:element>
                                <xsl:element name="td">
                                    <xsl:apply-templates select="$doc//differential/exam/text()"/>
                                </xsl:element>
                                <xsl:element name="td">
                                    <xsl:for-each select="$doc//differential/tests/test[@first='true']">
                                        <xsl:element name="strong">
                                            <xsl:value-of select="name"/>:
                                        </xsl:element>
                                        <xsl:value-of select="result"/>
                                    </xsl:for-each>
                                </xsl:element>
                                <xsl:element name="td">
                                    <xsl:for-each select="$doc//differential/tests/test[@first='false']">
                                        <xsl:element name="strong">
                                            <xsl:value-of select="name"/>:
                                        </xsl:element>
                                        <xsl:value-of select="result"/>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    
                
                </xsl:when>
                
                <xsl:when test="$xpath = 'option/intervention-set'">
                    <xsl:element name="a">
                        <xsl:attribute name="name"><xsl:value-of select="replace($doc//option/title,' ','-')"/></xsl:attribute>
                    </xsl:element>
                    <xsl:for-each select="$doc//option/intervention-set/intervention">
                        <xsl:element name="a">
                            <xsl:attribute name="name"><xsl:value-of select="replace(title,' ','-')"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="h3">
                            <xsl:value-of select="$doc//option/title"/>
                        </xsl:element>
                        <xsl:apply-templates select="summary-statement"/>
                    </xsl:for-each>
                    <!-- 
                        need to create a link to the ce web page 
                        <es-internal-link target="../options/_op0208_I3.xml" xpointer="option/intervention-set"/>
                        http://clinicalevidence.bmj.com/ceweb/conditions/abc/0208/0208_I3.jsp
                        
                        <es-internal-link target="../options/option-1188290036797.xml" xpointer="option/intervention-set"/>
                        http://clinicalevidence.bmj.com/ceweb/conditions/abc/0206/0206_I1188290036797.jsp
                    -->
                    
                    <!-- find topic id -->
                    <xsl:variable name="topicid"><xsl:value-of select="/evidence-summary/summary-info/ce-links/celink[@target=$target]/@topic-id"/></xsl:variable>
                    <xsl:variable name="topictitle"><xsl:value-of select="/evidence-summary/summary-info/ce-links/celink[@target=$target]"/></xsl:variable>

                    <xsl:element name="div">
                        <xsl:attribute name="class">source</xsl:attribute>
                        <xsl:element name="h4">Evidence from:</xsl:element>
                            
                        <!-- get option id -->
                        <xsl:choose>
                            <!-- old option file name -->
                            <xsl:when test="contains(@target,'_op')">
                                <xsl:variable name="interid">
                                    <xsl:value-of select="substring-before((substring-after(@target, 'I')),'.xml')"/>
                                </xsl:variable>
                                <xsl:element name="p">
                                    <xsl:attribute name="class">clinical-evidence</xsl:attribute>
                                    <xsl:element name="a">
                                        <xsl:attribute name="class">
                                            <xsl:text>external-link</xsl:text>
                                        </xsl:attribute>
                                        <xsl:attribute name="target">_blank</xsl:attribute>
                                        <xsl:attribute name="href" select="concat($ceweb,$topicid,'/',$topicid,'_I',$interid,'.jsp')"/>
                                        <xsl:element name="em">
                                            <xsl:text>Clinical Evidence</xsl:text>
                                        </xsl:element>
                                        <xsl:text>: </xsl:text>
                                        <xsl:value-of select="$topictitle"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <!-- new option file name -->
                            <xsl:otherwise>
                                <xsl:variable name="interid"><xsl:value-of select="substring-before((substring-after(@target, '-')),'.xml')"/></xsl:variable>
                                <xsl:element name="p">
                                    <xsl:attribute name="class">clinical-evidence</xsl:attribute>
                                    <xsl:element name="a">
                                        <xsl:attribute name="class">external-link</xsl:attribute>
                                        <xsl:attribute name="target">_blank</xsl:attribute>
                                        <xsl:attribute name="href" select="concat($ceweb,$topicid,'/',$topicid,'_I',$interid,'.jsp')"/>
                                        <xsl:element name="em">
                                            <xsl:text>Clinical Evidence</xsl:text>
                                        </xsl:element>
                                        <xsl:text>: </xsl:text>
                                        <xsl:value-of select="$topictitle"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    
                    </xsl:element>

                </xsl:when>

                <!-- create a link to the summary pdf on CE website -->
                <!-- http://clinicalevidence.bmj.com/ceweb/conditions/abc/1011/patient-summary-1183654350398-ce_patient_leaflet.pdf -->
                <xsl:when test="$xpath = 'patient-summary/topic-info'">
                    <xsl:variable name="newTarget" select="replace(replace($target, '../patient-summaries/', ''),'.xml','-ce_patient_leaflet.pdf')"/>
                    <xsl:variable name="reviewtarget" select="$doc//patient-summary/topic-info/systematic-review-link/@target"/>
                    <xsl:variable name="cedocTarget" select="(concat($ukdir,(replace($reviewtarget,'\.\./',''))))"/>
                    <xsl:variable name="ceid" select="document($cedocTarget)//systematic-review/@id"/>
                    
                    <xsl:for-each select="//category[internal-evidence-link[generate-id()=$generate-id]]/internal-evidence-link">
                        <!--es-internal-link-->
                        
                        <xsl:if 
                            test="
                            (position()=1 
                            or preceding-sibling::internal-evidence-link[@class!='bt-summary'])
                            and self::internal-evidence-link[generate-id()=$generate-id]
                            ">
                            <xsl:element name="p">
                                <xsl:element name="strong">
                                    <xsl:text>The following 'Patient Information Leaflets' from </xsl:text>
                                    <xsl:element name="em">
                                        <xsl:text>BMJ Best Health</xsl:text>
                                    </xsl:element>
                                    <xsl:text>are applicable to this order set:</xsl:text>
                                </xsl:element>
                            </xsl:element>
                            <xsl:text disable-output-escaping="yes">&lt;div class="source"&gt;</xsl:text>
                            <xsl:element name="h4">Information from:</xsl:element>
                        </xsl:if>
                        
                        <xsl:if test="self::internal-evidence-link[generate-id()=$generate-id]">
                            <xsl:element name="p">
                                <xsl:attribute name="class">best-health</xsl:attribute>
                                <xsl:element name="a">
                                    <xsl:attribute name="class">external-link</xsl:attribute>
                                    <xsl:attribute name="href" select="concat($ceweb,replace($ceid,'_',''),'/',$newTarget)"/>
                                    <xsl:value-of select="$doc//patient-summary/topic-info/title"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                        
                        <xsl:if 
                            test="
                            (position()=last() 
                            or following-sibling::internal-evidence-link[@class!='bt-summary'])
                            and self::internal-evidence-link[generate-id()=$generate-id]
                            ">
                            <xsl:comment>closing div class="source"</xsl:comment>
                            <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
                        </xsl:if>
                        
                    </xsl:for-each>
                    
                </xsl:when>
                
            </xsl:choose>
            
            <!-- add link to monograph -->
            <xsl:if 
                test="
                @xpointer!='option/intervention-set' 
                and @xpointer!='patient-summary/topic-info' 
                and @xpointer!='basics/definition'
                ">
                
                <xsl:element name="div">
                    <xsl:attribute name="class">source</xsl:attribute>
                    <xsl:element name="h4">Information from:</xsl:element>
                    
                    <xsl:element name="p">
                        <xsl:attribute name="class">best-practice</xsl:attribute>

                        <xsl:choose>
                            <xsl:when test="$pub-stream='en-us'">

                                <xsl:variable name="target"><xsl:value-of select="@target"/></xsl:variable>
                                <xsl:variable name="monoid"><xsl:value-of select="/evidence-summary/summary-info/mono-links/monolink[@target=$target]/@monoid"/></xsl:variable>
                                <xsl:variable name="monotitle"><xsl:value-of select="/evidence-summary/summary-info/mono-links/monolink[@target=$target]"/></xsl:variable>

                                <xsl:element name="a">
                                    <xsl:attribute name="class">external-link</xsl:attribute>
                                    <xsl:attribute name="target">_blank</xsl:attribute>
                                    <xsl:attribute name="href" select="concat($usmonoweb,$monoid,'.html')"/>
                                    <xsl:element name="em">
                                        <xsl:text>Best Practice Dx</xsl:text>
                                    </xsl:element>
                                    <xsl:text>: </xsl:text>
                                    <xsl:value-of select="$monotitle"/>
                                </xsl:element>
                                
                            </xsl:when>
                            <xsl:otherwise>

                                <xsl:variable name="target"><xsl:value-of select="@target"/></xsl:variable>
                                <xsl:variable name="monoid"><xsl:value-of select="/evidence-summary/summary-info/mono-links/monolink[@target=$target]/@monoid"/></xsl:variable>
                                <xsl:variable name="monotitle"><xsl:value-of select="/evidence-summary/summary-info/mono-links/monolink[@target=$target]"/></xsl:variable>
                                
                                <xsl:element name="a">
                                    <xsl:attribute name="class">external-link</xsl:attribute>
                                    <xsl:attribute name="target">_blank</xsl:attribute>
                                    <xsl:attribute name="href" select="concat($ukmonoweb,$monoid,'.html')"/>
                                    <xsl:element name="em">
                                        <xsl:text>Best Practice</xsl:text>
                                    </xsl:element>
                                    <xsl:text>: </xsl:text>
                                    <xsl:value-of select="$monotitle"/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:element>
                    
                </xsl:element>
            </xsl:if>

         </xsl:for-each>   
        
    </xsl:template>

    <!-- monograph mark up start-->
    
    <xsl:template 
        match="
        para | 
        name | 
        result | 
        factor-name
        ">
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- remove link to grade table from statement -->
    <xsl:template match="summary-statement">
        <xsl:element name="p">
            
            <xsl:for-each select="node()">
                
                <xsl:choose>
                    
                    <xsl:when test="name()='strong' and table-link">
                        <xsl:comment select="'grade statement node removed'"/>
                    </xsl:when>
                    
                    <xsl:when test="preceding-sibling::node()[name()='strong' and table-link]">
                        <xsl:comment select="'further grade statement nodes removed'"/>
                    </xsl:when>
                    
                    <xsl:when test="name()='strong' and (contains(., 'GRADE') or contains(., 'grade') )">
                        <xsl:comment select="'fragmented grade markup strong node removed'"/>
                    </xsl:when>
                    
                    <xsl:when test="name()='table-link'">
                        <xsl:comment select="'un-nested grade table-link removed'"/>
                    </xsl:when>
                    
                    <xsl:when test="preceding-sibling::table-link">
                        <xsl:comment select="'any nodes folloing table-link removed'"/>
                    </xsl:when>
                    
                    <xsl:when test="name()='strong'">
                        <xsl:element name="br" />
                        <xsl:element name="strong">
                            <xsl:value-of select="."/>
                        </xsl:element>
                        <xsl:element name="br" />
                    </xsl:when>
                    
                    <xsl:when test="name()='em'">
                        <xsl:element name="em">
                            <xsl:value-of select="."/>
                        </xsl:element>
                        <xsl:text disable-output-escaping="yes"> </xsl:text>
                    </xsl:when>
                    
                    <xsl:when test="string-length(normalize-space(.))!=0">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:text disable-output-escaping="yes"> </xsl:text>
                    </xsl:when>
                    
                </xsl:choose>
                
            </xsl:for-each>
        
        </xsl:element>
    </xsl:template>

    <xsl:template match="scope">
        <xsl:element name="h2">
            <xsl:attribute name="class">scope</xsl:attribute>
            <xsl:text>Scope</xsl:text>
        </xsl:element>
        <xsl:element name="a">
            <xsl:attribute name="name">scope</xsl:attribute>
        </xsl:element>
        <xsl:for-each select="p">
            <xsl:element name="p">
                <xsl:attribute name="class">introduction</xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template 
        match="
        reference-link | 
        figure-link | 
        table-link | 
        gloss-link | 
        evidence-score-link | 
        definition | 
        sign-symptoms | 
        approach | 
        section | 
        section-text | 
        detail | 
        outlook | 
        prevention | 
        screening | 
        diagnostic-criteria | 
        criteria | 
        overview | 
        ddx-etiology | 
        urgent-considerations | 
        diagnostic-approach | 
        ddx-name
        ">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="section-header">
        <xsl:element name="a">
            <xsl:attribute name="name" select="replace(.,' ','-')"/>
        </xsl:element>
        <xsl:element name="h2">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="list[@style='bullet']">
        <xsl:element name="ul">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="list[@style!='bullet']">
        <xsl:element name="ol">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="item">
        <xsl:element name="li">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="recommendations">
        <xsl:apply-templates select="monitoring"/>
        <xsl:apply-templates select="patient-instructions"/>
        <xsl:apply-templates select="preventive-actions"/>
    </xsl:template>
    
    <xsl:template match="monitoring">
        <xsl:element name="h2">Monitoring</xsl:element>
        <xsl:element name="a">
            <xsl:attribute name="name">monitoring</xsl:attribute>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="patient-instructions">
        <xsl:element name="h2">Patient Instructions</xsl:element>
        <xsl:element name="a">
            <xsl:attribute name="name">patient-instructions</xsl:attribute>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="preventive-actions">
        <xsl:element name="h2">Preventive Actions</xsl:element>
        <xsl:element name="a">
            <xsl:attribute name="name">preventive-actions</xsl:attribute>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="complications">
        <xsl:element name="table">
            <xsl:attribute name="rules">all</xsl:attribute>
            <xsl:attribute name="frame">box</xsl:attribute>
            <xsl:attribute name="class">default</xsl:attribute>
            
            
            <xsl:element name="tbody">
                <xsl:element name="tr">
                    <xsl:element name="td">
                        <xsl:element name="strong">
                            <xsl:value-of>Complication</xsl:value-of>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="td">
                        <xsl:element name="strong">
                            <xsl:value-of>Details</xsl:value-of>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="td">
                        <xsl:element name="strong">
                            <xsl:value-of>Timeframe</xsl:value-of>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="td">
                        <xsl:element name="strong">
                            <xsl:value-of>Likelihood</xsl:value-of>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:for-each select="complication">
                    <xsl:element name="tr">
                        <xsl:element name="td">
                            <xsl:apply-templates select="name"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:apply-templates select="detail"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:apply-templates select="@timeframe"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:apply-templates select="@likelihood"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>


    <xsl:template match="tests">
        
        <xsl:element name="h2">Diagnostic tests</xsl:element>
        <xsl:element name="a">
            <xsl:attribute name="name">diagnostic-tests</xsl:attribute>
        </xsl:element>
        
        
        <!-- 
            initial
            subsequent
            emerging
        -->
        
        <xsl:if test="test[@order='initial']">
            
            <xsl:element name="h4">Initial</xsl:element>
            
            <xsl:element name="table">
                <xsl:attribute name="rules">all</xsl:attribute>
                <xsl:attribute name="frame">box</xsl:attribute>
                <xsl:attribute name="class">default</xsl:attribute>
                
                
                <xsl:element name="tbody">
                    <xsl:element name="tr">
                        <xsl:element name="td">
                            <xsl:element name="strong">
                                <xsl:value-of>Test</xsl:value-of>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:element name="strong">
                                <xsl:value-of>Details</xsl:value-of>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:element name="strong">
                                <xsl:value-of>Result</xsl:value-of>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:for-each select="test[@order='initial']">
                        <xsl:element name="tr">
                            <xsl:element name="td">
                                <xsl:apply-templates select="name"/>
                            </xsl:element>
                            <xsl:element name="td">
                                <xsl:apply-templates select="detail"/>
                            </xsl:element>
                            <xsl:element name="td">
                                <xsl:apply-templates select="result"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
            
        </xsl:if>
        
        <xsl:if test="test[@order='subsequent']">
            
            <xsl:element name="h4">Subsequent</xsl:element>
            
            <xsl:element name="table">
                <xsl:attribute name="rules">all</xsl:attribute>
                <xsl:attribute name="frame">box</xsl:attribute>
                <xsl:attribute name="class">default</xsl:attribute>
                
                
                <xsl:element name="tbody">
                    <xsl:element name="tr">
                        <xsl:element name="td">
                            <xsl:element name="strong">
                                <xsl:value-of>Test</xsl:value-of>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:element name="strong">
                                <xsl:value-of>Details</xsl:value-of>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:element name="strong">
                                <xsl:value-of>Result</xsl:value-of>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:for-each select="test[@order='subsequent']">
                        <xsl:element name="tr">
                            <xsl:element name="td">
                                <xsl:apply-templates select="name"/>
                            </xsl:element>
                            <xsl:element name="td">
                                <xsl:apply-templates select="detail"/>
                            </xsl:element>
                            <xsl:element name="td">
                                <xsl:apply-templates select="result"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
            
        </xsl:if>
        
        <xsl:if test="test[@order='emerging']">
            
            <xsl:element name="h4">Emerging</xsl:element>
            
            <xsl:element name="table">
                <xsl:attribute name="rules">all</xsl:attribute>
                <xsl:attribute name="frame">box</xsl:attribute>
                <xsl:attribute name="class">default</xsl:attribute>
                
                
                <xsl:element name="tbody">
                    <xsl:element name="tr">
                        <xsl:element name="td">
                            <xsl:element name="strong">
                                <xsl:value-of>Test</xsl:value-of>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:element name="strong">
                                <xsl:value-of>Details</xsl:value-of>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:element name="strong">
                                <xsl:value-of>Result</xsl:value-of>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:for-each select="test[@order='emerging']">
                        <xsl:element name="tr">
                            <xsl:element name="td">
                                <xsl:apply-templates select="name"/>
                            </xsl:element>
                            <xsl:element name="td">
                                <xsl:apply-templates select="detail"/>
                            </xsl:element>
                            <xsl:element name="td">
                                <xsl:apply-templates select="result"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
            
        </xsl:if>
        

    </xsl:template>


    <xsl:template match="classifications">
        <xsl:for-each select="classification">
            <xsl:element name="h3"><xsl:value-of select="title"/></xsl:element>
            <xsl:element name="a">
                <xsl:attribute name="name"><xsl:value-of select="replace(title,' ','-')"/></xsl:attribute>
            </xsl:element>
            <xsl:apply-templates select="detail"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="emerging-txs">
        <xsl:for-each select="emerging-tx">
            <xsl:element name="h3"><xsl:value-of select="name"/></xsl:element>
            <xsl:element name="a">
                <xsl:attribute name="name"><xsl:value-of select="replace(name,' ','-')"/></xsl:attribute>
            </xsl:element>
            <xsl:element name="p"><xsl:apply-templates select="detail"/></xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="guidelines">

        
            <xsl:for-each select="guideline">
                <xsl:apply-templates select="title"/>
                <xsl:apply-templates select="summary/node()"/>
                
                <xsl:element name="div">
                    <xsl:attribute name="class">source</xsl:attribute>
                    <xsl:element name="h4">Information from:</xsl:element>
                    
                        <xsl:element name="p">
                            <xsl:value-of select="source"/><xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
                            last published:<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;<xsl:value-of select="last-published"/>
                            <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
                            <xsl:element name="a">
                                <xsl:attribute name="class">external-link</xsl:attribute>
                                <xsl:attribute name="target">_blank</xsl:attribute>
                                <xsl:attribute name="href"><xsl:value-of select="url"/></xsl:attribute>
                                <xsl:value-of select="title"/>
                            </xsl:element>
                        </xsl:element>
                    
                </xsl:element>
            </xsl:for-each>
        
        
        
    </xsl:template>

    <xsl:template match="diagnostic-factors">

    
            <xsl:element name="h2">Key Diagnostic Factors</xsl:element>
        
            <xsl:element name="a">
                <xsl:attribute name="name">key-diagnostic-factors</xsl:attribute>
            </xsl:element>
        
            
            <xsl:element name="ul">
                
                <xsl:for-each select="factor">
                    
                    <xsl:element name="li">
                        <xsl:apply-templates select="factor-name/text()"/><xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;(<xsl:apply-templates select="@frequency"/>)
                        <xsl:for-each select="detail">
                            <xsl:element name="ul">
                                <xsl:for-each select="para">
                                    <xsl:element name="li">
                                        <xsl:apply-templates/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                    
                </xsl:for-each>
                
            </xsl:element>

    </xsl:template>

    <xsl:template match="risk-factors">
        
        <xsl:element name="h2">Risk factors</xsl:element>
        
        <xsl:element name="a">
            <xsl:attribute name="name">risk-factors</xsl:attribute>
        </xsl:element>
        
        
        <xsl:if test="risk-factor[@strength='strong']">

            <xsl:element name="ul">
        
                <xsl:for-each select="risk-factor[@strength='strong']">
                    
                    <xsl:element name="li">
                        <xsl:apply-templates select="name/text()"/>
                        <xsl:for-each select="detail">
                                <xsl:element name="ul">
                                    <xsl:for-each select="para">
                                        <xsl:element name="li">
                                            <xsl:apply-templates/>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                    
                </xsl:for-each>
            
            </xsl:element>
            
        </xsl:if>
        
        <xsl:if test="risk-factor[@strength='weak']">
            
            <xsl:element name="ul">
                
                <xsl:for-each select="risk-factor[@strength='weak']">
                    
                    <xsl:element name="li">
                        <xsl:apply-templates select="name/text()"/>
                        <xsl:for-each select="detail">
                            <xsl:element name="ul">
                                <xsl:for-each select="para">
                                    <xsl:element name="li">
                                        <xsl:apply-templates/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                    
                </xsl:for-each>
                
            </xsl:element>
           
        </xsl:if>
        
    </xsl:template>

    <xsl:template match="differentials">
        <xsl:element name="table">
            <xsl:attribute name="rules">all</xsl:attribute>
            <xsl:attribute name="frame">box</xsl:attribute>
            <xsl:attribute name="class">default</xsl:attribute>
            
            
            <xsl:element name="tbody">
                <xsl:element name="tr">
                    <xsl:element name="td">
                        <xsl:element name="strong">
                            <xsl:value-of>Disease/Condition</xsl:value-of>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="td">
                        <xsl:element name="strong">
                            <xsl:value-of>Differentiating Signs/Symptoms</xsl:value-of>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="td">
                        <xsl:element name="strong">
                            <xsl:value-of>Differentiating Tests</xsl:value-of>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:for-each select="differential">
                    <xsl:element name="tr">
                        <xsl:element name="td">
                            <xsl:apply-templates select="name"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:apply-templates select="sign-symptoms"/>
                        </xsl:element>
                        <xsl:element name="td">
                            <xsl:apply-templates select="tests/node()"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    

    <!-- monograph mark up end -->

    <xsl:template match="uri-link">
        <xsl:element name="p">
        <xsl:element name="a">
            <xsl:attribute name="class">external-link</xsl:attribute>
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:attribute name="href" select="@href"/>
            <xsl:apply-templates/>
        </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="heading">
        <xsl:element name="a">
            <xsl:attribute name="name" select="replace(.,' ','-')"/>
        </xsl:element>
        <xsl:element name="h2">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="sub-heading | title">
        <xsl:element name="a">
            <xsl:attribute name="name" select="replace(.,' ','-')"/>
        </xsl:element>
        <xsl:element name="h3">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template 
        match="
        description | 
        rationale | 
        clinical-recommendations
        ">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="notes"><!-- do nothing --></xsl:template>

    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>    


</xsl:stylesheet>

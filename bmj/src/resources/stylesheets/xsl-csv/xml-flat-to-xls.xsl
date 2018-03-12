<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/TR/REC-html40"
    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:v="urn:schemas-microsoft-com:vml"
    xmlns:o="urn:schemas-microsoft-com:office:office"
    xmlns:x="urn:schemas-microsoft-com:office:excel"
    
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
    xmlns:change="http://change.bmj.com"
    
    version="2.0">
    
    <xsl:output 
        method="xml" 
        encoding="UTF-8" 
        indent="yes"
        omit-xml-declaration="yes" 
    />
    
    <xsl:param name="report-level"/>
    
    <xsl:param name="break">
        <xsl:element name="br"/>
        <!--<xsl:element name="span">
            <xsl:attribute name="class" select="string('space')"/>
            <xsl:text>x</xsl:text>
        </xsl:element>-->
        <!--<xsl:text disable-output-escaping="yes">&#13;&#10;&#09;</xsl:text>-->
        <!--<xsl:text disable-output-escaping="yes">&#09;</xsl:text>-->
    </xsl:param>
    
    <xsl:template match="/">
        
        <xsl:element name="html">
            
            <xsl:element name="head">
                
                <xsl:element name="title">
                    <xsl:text>Change report: </xsl:text>
                    <xsl:value-of select="/root/row[1]/name" />
                    <xsl:text> [</xsl:text>
                    <xsl:value-of select="/root/row[1]/id" />
                    <xsl:text>]</xsl:text>
                </xsl:element>
                
                <xsl:element name="meta">
                    <xsl:attribute name="http-equiv" select="string('Content-Type')" />
                    <xsl:attribute name="content" select="string('text/html; charset=UTF-8')" />
                </xsl:element>
                
                <xsl:element name="meta">
                    <xsl:attribute name="name" select="string('ProgId')" />
                    <xsl:attribute name="content" select="string('Excel.Sheet')" />
                </xsl:element>
                
                <xsl:element name="style">
                    
                    <xsl:comment>
                        
                        @page {
                        margin:.75in .25in .75in .25in;
                        mso-header-margin:.3in;
                        mso-footer-margin:.3in;
                        mso-page-orientation:landscape;
                        mso-horizontal-page-align:center;
                        mso-vertical-page-align:top;}
                        
                        br {
                        mso-data-placement:same-cell;
                        }
                        
                    </xsl:comment>
                    
                </xsl:element>
                
                <xsl:element name="style">
                    <xsl:attribute name="type">text/css</xsl:attribute>
                    
                    <xsl:text>
                        
                        table {
                        table-layout:fixed;
                        border-collapse:collapse;
                        mso-displayed-decimal-separator:"\.";
                        mso-displayed-thousand-separator:"\,";
                        width:190mm;                        
                        }
                        
                        tr {
                        mso-height-source:auto;
                        }
                        th, td {
                        border-left:.5pt solid;
                        border-top:.5pt solid;
                        border-right:.5pt solid;
                        border-bottom:.5pt solid;
                        vertical-align:top;
                        font-size:8pt;                         
                        line-height:200%;
                        display:table-cell;
                        }
                        th {
                        font-weight:bold;
                        text-align:centre;
                        }
                        
                        th.name, td.name, th.section-path, td.section-path {
                        width:.75in;
                        }
                        th.details-of-change-old, td.details-of-change-old, th.details-of-change-new, td.details-of-change-new {
                        width:3.25in;
                        }
                        th.lang, td.lang, th.id, td.id, th.date, td.date, th.ver-old, td.ver-old, th.ver-new, td.ver-new {
                        mso-width-source:auto;
                        }
                        
                        div.redline-moved, span.redline-moved {
                        color:blue;
                        keep-together:auto;
                        }
                        div.redline-insert, span.redline-insert {
                        color:green;
                        keep-together:auto;
                        text-decoration:underline;
                        }
                        div.redline-delete, span.redline-delete {
                        color:red;
                        keep-together:auto;
                        text-decoration:line-through;
                        }
                        div.redline-comment, span.redline-comment {
                        color:brown;
                        keep-together:auto;
                        }
                        
                    </xsl:text>    
                
                </xsl:element>
                
            </xsl:element>
            
            <xsl:element name="body">
                <xsl:apply-templates mode="worksheet" />
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="element()" mode="worksheet">
        
        <xsl:element name="table">
            
            <xsl:element name="thead">
                <xsl:element name="tr">
                    
                    <xsl:for-each select="/root/row[1]/element()">
                        <xsl:element name="th">
                            <xsl:attribute name="class" select="name()"/>
                            <xsl:value-of select="name()"/>
                        </xsl:element>
                    </xsl:for-each>
                    
                </xsl:element>
            </xsl:element>
            
            <xsl:element name="tbody">
                <xsl:apply-templates mode="row" />
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="element()" mode="row">
  
        <xsl:if 
            test="
            (details-of-change-old | details-of-change-new)//(change:div | change:span | */@change:*)
            and not(details-of-change-new[string-length(normalize-space(.))=0] 
            and details-of-change-old/change:div[@class='redline-moved'])
            ">

            <xsl:element name="tr">
                <xsl:apply-templates mode="cell" />
            </xsl:element>
            
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="element()" mode="cell">
        <xsl:variable name="generate-id-parent" select="generate-id(ancestor::row)"/>
        <xsl:variable name="section-path-current" select="ancestor::row/section-path"/>
        <xsl:variable name="generate-id-matched-moved-section" select="generate-id(//row[section-path=$section-path-current and generate-id(.)!=$generate-id-parent][1])"/>
        
        <xsl:element name="td">
            <xsl:attribute name="class" select="name()"/>
            
            <xsl:choose>
                
                <xsl:when 
                    test="
                    name()='details-of-change-new' 
                    and change:div[@class='redline-moved']
                    ">
                    
                    <xsl:element name="span">
                        <xsl:attribute name="class" select="string('redline-moved')"/>
                        
                        <xsl:text disable-output-escaping="no">&lt;!-- </xsl:text> 
                        <xsl:text>section moved: new section-path preceding to </xsl:text>
                        <xsl:value-of select="//row[generate-id()=$generate-id-parent]/following-sibling::row[1]/section-path"/>
                        <xsl:text disable-output-escaping="no"> --&gt;</xsl:text>
                        
                    </xsl:element>
                    
                    <xsl:copy-of select="$break"/>
                    
                    <xsl:apply-templates/>
                    
                </xsl:when>
                
                <xsl:when 
                    test="
                    name()='details-of-change-old' 
                    and following-sibling::details-of-change-new/change:div[@class='redline-moved']
                    ">
                    
                    <xsl:element name="span">
                        <xsl:attribute name="class" select="string('redline-moved')"/>
                        
                        <xsl:text disable-output-escaping="no">&lt;!-- </xsl:text> 
                        <xsl:text>section moved: old section-path preceding to </xsl:text>
                        <xsl:value-of select="//row[generate-id()=$generate-id-matched-moved-section]/following-sibling::row[1]/section-path"/>
                        <xsl:text disable-output-escaping="no"> --&gt;</xsl:text>
                        
                    </xsl:element>
                    
                    <xsl:copy-of select="$break"/>
                    
                    <xsl:choose>
                        
                        <xsl:when test="string-length(normalize-space(.))=0">
                            
                            <xsl:apply-templates select="following-sibling::details-of-change-new/change:div[@class='redline-moved']"/>
                            
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                        
                    </xsl:choose>
                    
                </xsl:when>
                
                <xsl:when test="name()='details-of-change-old' or name()='details-of-change-new'">
                    <xsl:apply-templates/>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="."/>                    
                </xsl:otherwise>
                
           </xsl:choose>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="pi-comment | notes[parent::details-of-change-old or parent::details-of-change-new]" />
    
    <xsl:template match="change:div | change:span">
        <xsl:variable name="generate-id-parent" select="generate-id(ancestor::row)"/>
        <xsl:variable name="section-path-current" select="ancestor::row/section-path"/>
        <xsl:variable name="generate-id-matched-moved-section" select="generate-id(//row[section-path=$section-path-current and generate-id(.)!=$generate-id-parent])"/>
        
        <xsl:choose>
            
            <xsl:when test="ancestor::change:span">
                <xsl:apply-templates/>
            </xsl:when>
            
            <xsl:when test="@class='redline-moved' and parent::details-of-change-old or parent::details-of-change-new">
                <xsl:apply-templates/>
            </xsl:when>
            
            <xsl:when 
                test="
                name()='change:span' 
                and not(element()) 
                and $report-level='node'">
                
                <xsl:element name="{substring-after(name(), ':')}">
                    <xsl:attribute name="class" select="@class"/>
                    
                    <xsl:apply-templates/>
                    
                </xsl:element>
                
            </xsl:when>
            
            <xsl:otherwise>
                
                <xsl:element name="{substring-after(name(), ':')}">
                    <xsl:attribute name="class" select="@class"/>
                    
                    <xsl:apply-templates/>
                    
                </xsl:element>
                
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="element()">
        <xsl:param name="name" select="name()" />
        
        <xsl:choose>
            
            <xsl:when 
                test="
                (
                ancestor-or-self::node()/@change:*
                or ancestor::change:div 
                or ancestor::change:span
                or change:div 
                or change:span 
                and $report-level='node' 
                )
                or $report-level!='node'
                ">
                <!--
                TODO: following condition forcing parent no change element display in spreadhseet?? 
                or ancestor::change:div 
                or ancestor::change:span
                -->
                <xsl:choose>
                    
                    <!-- closed empty element -->
                    <xsl:when test="count(child::node())=0 or (count(child::node())=1 and child::node()[self::text() and string-length(normalize-space(.))=0])">
<!--
                        <xsl:text disable-output-escaping="no">&lt;</xsl:text>
                        <xsl:value-of select="$name"/>
                        
                        <xsl:call-template name="process-attributes"/>
                        
                        <xsl:text disable-output-escaping="no"> /&gt;</xsl:text>
-->
                        <xsl:call-template name="process-attributes"/>
                        
                        <!-- TODO: parent element does not contain text?? -->
                        <xsl:if test="parent::node()/text()[string-length(normalize-space(.))=0]">
                            <xsl:comment>br1</xsl:comment>
                            <xsl:copy-of select="$break"/>
                        </xsl:if>
                        
                    </xsl:when>
                    
                    <xsl:otherwise>
<!--
                        <xsl:text disable-output-escaping="no">&lt;</xsl:text>
                        <xsl:value-of select="$name"/>
                        
                        <xsl:call-template name="process-attributes"/>
                        
                        <xsl:text disable-output-escaping="no">&gt;</xsl:text>
-->

                        <xsl:call-template name="process-attributes"/>
                        
                        <!-- current element has no text or elements behind and current element is not text only -->
                        <xsl:if 
                            test="
                            (
                            preceding-sibling::node()[1]
                            [
                            (
                            self::text() 
                            and string-length(normalize-space(.))=0
                            )
                            or self::element()
                            ]
                            or count(preceding-sibling::element())=0
                            )
                            
                            and 
                            not
                            (
                            count(element()[name()!='change:span'])=0 
                            and 
                            (
                            text()[string-length(normalize-space(.))!=0]
                            or change:span/text()[string-length(normalize-space(.))!=0]
                            )
                            )
                            ">
                            <xsl:copy-of select="$break"/>
                        </xsl:if>
                        
                        <xsl:apply-templates select="node()[name()!='tx-options']"/>
                        
                        <xsl:if 
                            test="
                            (
                            following-sibling::node()[1]
                            [
                            (
                            self::text() 
                            and string-length(normalize-space(.))=0
                            ) 
                            or self::element()
                            ]
                            or count(following-sibling::element())=0
                            )
                            
                            and 
                            not
                            (
                            count(element()[name()!='change:span'])=0 
                            and 
                            (
                            text()[string-length(normalize-space(.))!=0]
                            or change:span/text()[string-length(normalize-space(.))!=0]
                            )
                            )
                            ">
                            <xsl:copy-of select="$break"/>
                        </xsl:if>
<!--
                        <xsl:text disable-output-escaping="no">&lt;/</xsl:text>
                        <xsl:value-of select="$name"/>
                        <xsl:text disable-output-escaping="no">&gt;</xsl:text>
-->
                    </xsl:otherwise>
                    
                </xsl:choose>
                
                <xsl:if test="following-sibling::*[1][(self::text() and string-length(normalize-space(.))=0) or self::element()]">
                    <xsl:comment>br4</xsl:comment>
                    <xsl:copy-of select="$break"/>
                </xsl:if>
                
            </xsl:when>
            
            <xsl:when test="$report-level='node'">
                <xsl:apply-templates/>            
            </xsl:when>
            
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="text()">
        
        <xsl:choose>
            
            <xsl:when test="$report-level!='node'">
                <xsl:value-of select="."/>
            </xsl:when>
            
            <xsl:when  
                test="
                ancestor::node()/@change:*
                or ancestor::change:div
                or ancestor::change:span
                or preceding-sibling::change:span
                or following-sibling::change:span
                and $report-level='node'">
                <xsl:value-of select="."/>
            </xsl:when>
            
            <xsl:otherwise/>
            
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="process-attributes">
        
        <xsl:param name="attribute-change">
            <xsl:element name="attribute-change">
                <xsl:copy-of select="self::element()/attribute()[starts-with(name(), 'change:')]" />
            </xsl:element>
        </xsl:param>
        
        <xsl:for-each select="self::element()/attribute()[not(starts-with(name(), 'change:'))]">
            <xsl:variable name="name" select="name()" />
            
            <xsl:choose>
                
                <xsl:when test="$attribute-change/*:attribute-change/attribute()[substring-after(name(), 'change:') = $name]">
                    
                    <xsl:text disable-output-escaping="yes"> </xsl:text>
                    
                    <xsl:element name="span">
                        
                        <xsl:choose>
                            
                            <xsl:when test="ancestor::details-of-change-old">
                                <xsl:attribute name="class" select="string('redline-delete')"/>        
                            </xsl:when>
                            
                            <xsl:when test="ancestor::details-of-change-new">
                                <xsl:attribute name="class" select="string('redline-insert')"/>
                            </xsl:when>
                            
                        </xsl:choose>
                        
                        <xsl:text disable-output-escaping="yes">[@</xsl:text>
                        <xsl:value-of select="$name"/>
                        <xsl:text disable-output-escaping="yes">="</xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text disable-output-escaping="yes">"</xsl:text>
                        <xsl:text disable-output-escaping="yes">]</xsl:text>
                        
                    </xsl:element>
                    
                </xsl:when>
                
                <xsl:otherwise>
                    
                    <xsl:text disable-output-escaping="yes"> [@</xsl:text>
                    <xsl:value-of select="$name"/>
                    <xsl:text disable-output-escaping="yes">="</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text disable-output-escaping="yes">"</xsl:text>
                    <xsl:text disable-output-escaping="yes">]</xsl:text>
                    
                </xsl:otherwise>
                
            </xsl:choose>
            
        </xsl:for-each>
        
    </xsl:template>
    
</xsl:stylesheet>


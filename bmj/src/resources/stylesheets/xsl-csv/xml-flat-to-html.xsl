<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
    xmlns:change="http://change.bmj.com"
    
    version="2.0">
    
    <xsl:output 
        method="xhtml" 
        encoding="UTF-8"
        indent="yes"
        use-character-maps="nbsp"/>
    <!--encoding="iso-8859-1"-->
    
    <xsl:character-map name="nbsp">
        <xsl:output-character character=" " string="&amp;nbsp;"/>
        <xsl:output-character character="&#160;" string="&amp;nbsp;"/>
        <xsl:output-character character="–" string="-"/>
    </xsl:character-map>
    
    <xsl:param name="markup-format" />
    <xsl:param name="index" />
    <xsl:param name="lang" />
    <xsl:param name="server" />
    <xsl:param name="strings-variant-fileset" />
    <xsl:param name="pub-resource-name" />
    <xsl:param name="pub-resource-type" />
    <xsl:param name="pub-resource-folder" />
    
    <!--<xsl:param name="break">
        <xsl:text disable-output-escaping="yes">&#13;&#10;&#09;</xsl:text>
        <xsl:element name="br"/>
        </xsl:param>-->
    
    <xsl:include href="../xsl-lib/xinclude.xsl"/>
    <xsl:include href="../generic-params.xsl"/>
    <xsl:include href="../xsl-lib/strings/publication-labels-process-shared.xsl"/>
    
    <xsl:template match="/*">
        
        <xsl:element name="html">
             
            <xsl:element name="head">
                <xsl:element name="meta">
                	  <xsl:attribute name="charset" select="string('UTF-8')"/>
                </xsl:element>
                <!-- latest jquery library -->
                <xsl:element name="script">
                    <xsl:attribute name="type" select="string('text/javascript')"/>
                    <xsl:attribute name="src" select="string('../js/jquery-1.5.1.js')"/>
                </xsl:element>

                <!-- expand-and-collaps plugin source -->
                <xsl:element name="script">
                    <xsl:attribute name="type" select="string('text/javascript')"/>
                    <xsl:attribute name="src" select="string('../js/jquery.bmj.utils.expand_and_collaps_1.0.js')"/>
                </xsl:element>
                
                <xsl:element name="script">
                    <xsl:attribute name="type" select="string('text/javascript')"/>
                    <xsl:text>$(document).ready(function() {$.fn.enableExpandables();});</xsl:text>
                </xsl:element>
                
                <xsl:element name="script">
                    <xsl:attribute name="type" select="string('text/javascript')"/>
                    <xsl:text>function show_alert(){alert("link to external resource");}</xsl:text>
                </xsl:element>
                <!--
                <xsl:element name="script">
                    <xsl:attribute name="type" select="string('text/javascript')"/>
                    <xsl:attribute name="src" select="string('../js/jquery.clipboard.min.js')"/>
                </xsl:element>
                
                <xsl:element name="script">
                    <xsl:attribute name="type" select="string('text/javascript')"/>
                    <xsl:text>
                        
                        $(document).ready(function(){
                        $(".warning").text("Clipboard is not loaded. Flash not installed or version not supported.");
                        $.clipboardReady(function(){
                        $(".warning").remove();
                        $("#demo").show();
                        $("#demo_span").html("");
                        $('button.clipboard').click(function(){
                        var clipcoardText = $(this).attr('title');
                        $.clipboard( clipcoardText );
                        }).appendTo("#demo_span");
                        }, { debug: true } );
                        });
                        
                    </xsl:text>
                </xsl:element>
                -->    
                <xsl:element name="style">
                    <xsl:attribute name="type">text/css</xsl:attribute>
                    <xsl:text>
                        
                        body {
                        background-color:white; 
                        width:960px; 
                        align:center; 
                        margin:20pt auto; 
                        border:1pt; 
                        border-color:black; 
                        border-style:solid; 
                        padding:20pt;
                        font-family:arial;
                        font-size:12pt;
                        }
                        table {
                        width:100%;
                        table-layout:fixed;
                        }
                        div.metadata {
                        margin:20pt auto; 
                        border:1pt; 
                        border-color:black; 
                        border-style:dashed; 
                        padding:20pt;
                        }
                        h1 {
                        text-align:center;
                        }
                        h2 {
                        font-size:150%;
                        }
                        div.heading, div.heading-implied {
                        font-weight:bold;
                        font-size:125%;
                        padding-bottom:10pt;
                        }
                        div.metadata td {
                        display:block;
                        width:50%;
                        }
                        div.row {
                        padding-bottom:75pt;
                        border-top:2pt; 
                        border-top-color:black; 
                        border-top-style:solid;
                        }
                        div.section-path {
                        padding-bottom:10pt;
                        }
                        div.indent {
                        margin-left:20pt;
                        padding-top:5pt;
                        padding-bottom:5pt;
                        }
                        div.section {
                        margin-left:20pt;
                        margin-top:10pt;
                        padding-top:5pt;
                        padding-bottom:5pt;
                        padding-left:5pt;
                        border-left:2pt; 
                        border-left-color:lightgray; 
                        border-left-style:solid;
                        }
                        div.para, div.p {
                        padding-bottom:10pt;
                        }
                        h2.heading-implied, div.heading-implied, span.prompt, div.section-path {
                        color:darkgray;
                        }
                        h2.heading-implied span.attribute, div.heading-implied span.attribute, span.prompt span.attribute {
                        color:black;
                        }
                        div.prompt {
                        padding-bottom:10pt;
                        }
                        span.prompt, span.strong, strong, span.bold, bold, span.b, b {
                        font-weight:bold;
                        }
                        span.inline, span.em, em, span.italic, italic, span.i, i {
                        font-style:italic;
                        }
                        span.sup, sup, {
                        font-size:xx-small; 
                        vertical-align:top;
                        } 
                        span.sub, sub, {
                        font-size:xx-small; 
                        vertical-align:bottom;
                        }
                        span.drug {
                        background-color:#E0B0FF;
                        padding-top:0pt;
                        padding-bottom:2pt;
                        padding-left:2pt;
                        padding-right:2pt;
                        }
                        span.float-label {
                        font-weight:normal;
                        vertical-align: text-top;
                        font-size:8pt;
                        padding-top:0pt;
                        padding-bottom:2pt;
                        padding-left:2pt;
                        padding-right:2pt;
                        }
                        a, span.link {
                        text-decoration:underline;
                        }
                        div.redline-insert, span.redline-insert {
                        background-color:khaki;
                        color:darkgreen;
                        text-decoration:underline;
                        padding-top:0pt;
                        padding-bottom:2pt;
                        padding-left:2pt;
                        padding-right:2pt;
                        }
                        div.redline-delete, span.redline-delete {
                        background-color:khaki;
                        color:darkred;
                        text-decoration:line-through;
                        padding-top:0pt;
                        padding-bottom:2pt;
                        padding-left:2pt;
                        padding-right:2pt;
                        }
                        span.redline-comment {
                        background-color:khaki;
                        padding-top:0pt;
                        padding-bottom:2pt;
                        padding-left:2pt;
                        padding-right:2pt;
                        }
                        
                        span.monospace {
                        font-family:monospace;
                        }
                        div.details-of-change-new {
                        }
                        div.details-of-change-old {
                        color:gray;
                        border:1pt; 
                        border-color:gray; 
                        border-style:dashed;
                        padding-bottom:20pt;
                        padding:5pt;
                        }
                        div.section-changed {
                        padding-bottom:20pt;
                        border:1pt; 
                        border-color:darkblue; 
                        border-style:dashed;
                        padding:5pt;
                        }
                        div.section-changed h2 {
                        color:darkblue;
                        }
                        span.section-changed {
                        color:darkblue;
                        background-color:khaki;
                        padding-top:0pt;
                        padding-bottom:2pt;
                        padding-left:2pt;
                        padding-right:2pt;
                        }
                        dl dd, dl dd {
                        margin:0;
                        padding:0;
                        display:none;
                        }
                        button {
                        width:180px;
                        clear:right;
                        float:right;
                        cursor:pointer;
                        }
                        a.button {
                        text-decoration:none;
                        }
                        div.container {
                        display:none;
                        }
                        
                        span.redline-insert, div.redline-insert *{
                        color:darkgreen;
                        }
                        span.redline-delete, div.redline-delete *{
                        color:darkred;
                        }
                        
                        div.index li {
                        padding-bottom:10pt;
                        }
                        
                        div.spacer {
                        padding:30pt; 
                        display:block;
                        }
                        
                        span.pi-comment-q-to-pr {
                        background-color:#FFE19B;
                        padding-top:0pt;
                        padding-bottom:2pt;
                        padding-left:2pt;
                        padding-right:2pt;
                        }
                        span.pi-comment-q-to-a {
                        background-color:#FFE19B;
                        padding-top:0pt;
                        padding-bottom:2pt;
                        padding-left:2pt;
                        padding-right:2pt;
                        }
                        span.pi-comment-q-to-ed {
                        background-color:#F5CCCA;
                        padding-top:0pt;
                        padding-bottom:2pt;
                        padding-left:2pt;
                        padding-right:2pt;
                        }
                        span.pi-comment-q-to-teched {
                        background-color:#9FD4B8;
                        padding-top:0pt;
                        padding-bottom:2pt;
                        padding-left:2pt;
                        padding-right:2pt;
                        }
                        span.pi-comment-q-to-prod {
                        background-color:#6C97CC;
                        padding-top:0pt;
                        padding-bottom:2pt;
                        padding-left:2pt;
                        padding-right:2pt;
                        }
                        
                        th {
                        vertical-align:text-bottom;
                        
                        }
                        td {
                        vertical-align:text-top;
                        }
                        
                    </xsl:text>
                    
                </xsl:element>
                
                <xsl:element name="title">
                    <xsl:text>Change report: </xsl:text>
                    <xsl:value-of select="*[1]/name" />
                    <xsl:text> [</xsl:text>
                    <xsl:value-of select="*[1]/id" />
                    <xsl:text>]</xsl:text>
                </xsl:element>
                
            </xsl:element>
            
            <xsl:element name="body">
                
                <xsl:element name="div">
                    <!--<xsl:attribute name="id" select="string('top')"/>-->
                    
                    <xsl:apply-templates select="/*" mode="worksheet" />
                    
                </xsl:element>
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="*" mode="worksheet">
        
        <xsl:element name="h1">
            <xsl:value-of select="*[1]/name" />
        </xsl:element>
        
        <!-- metadata -->
        <xsl:element name="div">
            <xsl:attribute name="class" select="string('metadata')"/>
            
            <xsl:element name="table">
                
                <xsl:element name="tr">
                    
                    <xsl:for-each select="*[1]/(lang|date)">
                        
                        <xsl:element name="td">
                            
                            <xsl:element name="div">
                                <xsl:attribute name="class" select="string('key')"/>
                                
                                <xsl:element name="span">
                                    <xsl:attribute name="class" select="string('prompt')"/>
                                    
                                    <xsl:value-of select="name()"/>
                                    <xsl:text>:</xsl:text>
                                    
                                </xsl:element>
                                
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                
                                <xsl:element name="span">
                                    <xsl:attribute name="class" select="string('value')"/>
                                    
                                    <xsl:apply-templates/>
                                    
                                </xsl:element>
                                
                            </xsl:element>
                            
                        </xsl:element>
                            
                    </xsl:for-each>
                    
                </xsl:element>
                    
                <xsl:element name="tr">
                    
                    <xsl:for-each select="*[1]/(id|ver-old)">
                    
                        <xsl:element name="td">
                            
                            <xsl:element name="div">
                                <xsl:attribute name="class" select="string('key')"/>
                                
                                <xsl:element name="span">
                                    <xsl:attribute name="class" select="string('prompt')"/>
                                    
                                    <xsl:value-of select="name()"/>
                                    <xsl:text>:</xsl:text>
                                    
                                </xsl:element>
                                
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                
                                <xsl:element name="span">
                                    <xsl:attribute name="class" select="string('value')"/>
                                    
                                    <xsl:apply-templates/>
                                    
                                </xsl:element>
                                
                            </xsl:element>
                            
                        </xsl:element>
                        
                    </xsl:for-each>
                    
                </xsl:element>
                
                <xsl:element name="tr">
                    
                    <xsl:for-each select="*[1]/(section-path)">
                        
                        <xsl:element name="td">
                            
                            <xsl:element name="div">
                                <xsl:attribute name="class" select="string('key')"/>
                                
                                <xsl:element name="span">
                                    <xsl:attribute name="class" select="string('prompt')"/>
                                    
                                    <!--<xsl:value-of select="name()"/>-->
                                    <xsl:text>type</xsl:text>
                                    <xsl:text>:</xsl:text>
                                    
                                </xsl:element>
                                
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                
                                <xsl:element name="span">
                                    <xsl:attribute name="class" select="string('value')"/>
                                    
                                    <xsl:value-of select="$pub-resource-type" />
                                    
                                </xsl:element>
                                
                            </xsl:element>
                            
                        </xsl:element>
                        
                    </xsl:for-each>
                    
                    <xsl:for-each select="*[1]/(ver-new)">
                        
                        <xsl:element name="td">
                            
                            <xsl:element name="div">
                                <xsl:attribute name="class" select="string('key')"/>
                                
                                <xsl:element name="span">
                                    <xsl:attribute name="class" select="string('prompt')"/>
                                    
                                    <xsl:value-of select="name()"/>
                                    <xsl:text>:</xsl:text>
                                    
                                </xsl:element>
                                
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                
                                <xsl:element name="span">
                                    <xsl:attribute name="class" select="string('value')"/>
                                    
                                    <xsl:apply-templates/>
                                    
                                </xsl:element>
                                
                            </xsl:element>
                            
                        </xsl:element>
                        
                    </xsl:for-each>
                    
                </xsl:element>
                
            </xsl:element>
            
        </xsl:element>
        
        <xsl:if test="$index != 'false'">
            <xsl:call-template name="process-index"/>
        </xsl:if>

        <!-- show-all -->
        <xsl:element name="div">
            <xsl:attribute name="class" select="string('allopenable')"/>
            
            <xsl:element name="button">
                <xsl:attribute name="type" select="string('button')"/>
                <xsl:attribute name="class" select="string('showall')"/>
                <xsl:text>expand all deleted changes</xsl:text>    
            </xsl:element>
            
            <xsl:element name="div">
                <xsl:attribute name="class" select="string('spacer')"/>
                
                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                
            </xsl:element>
            
            
            <xsl:choose>
                
                <xsl:when test="$markup-format='pretty-changed'">
                    <xsl:apply-templates 
                        select="
                        *
                        [
                        details-of-change-new//(change:span|change:div|@change:*)
                        or details-of-change-old//(change:span|change:div|@change:*)
                        ]
                        " 
                        mode="row"/>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="*" mode="row"/>                            
                </xsl:otherwise>
                
            </xsl:choose>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="*" mode="row">
        <xsl:param name="section-path" select="section-path"/>
        <xsl:param name="generate-id" select="generate-id()"/>
        <xsl:param name="generate-id-matched-moved-section" 
            select="generate-id(//row[section-path=$section-path and generate-id(.)!=$generate-id][1])"/>
            
        <xsl:element name="div">
            <xsl:attribute name="class" select="string('row')"/>
            <xsl:attribute name="id" select="generate-id(section-path)"/>
            
            <xsl:apply-templates select="section-path" mode="cell"/>
            
            <xsl:choose>
                
                <xsl:when 
                    test="
                    not(details-of-change-new//(change:span|change:div|@change:*))
                    and details-of-change-old//(change:span|change:div|@change:*)
                    ">
                    <xsl:comment>details-of-change-old but not details-of-change-new hense supressed</xsl:comment>
                </xsl:when>
                
                <xsl:when 
                    test="
                    not(details-of-change-new//(change:span|change:div|@change:*))
                    and not(details-of-change-old//(change:span|change:div|@change:*))
                    ">
                    
                    <xsl:element name="div">
                        <xsl:attribute name="class" select="string('allopenable2')"/>
                        
                        <xsl:apply-templates select="details-of-change-new" mode="cell">
                            <xsl:with-param name="section-path" select="section-path"/>
                        </xsl:apply-templates>
                        
                    </xsl:element>
                    
                </xsl:when>
                
                <xsl:otherwise>
                    
                    <xsl:apply-templates select="details-of-change-new" mode="cell">
                        <xsl:with-param name="section-path" select="section-path"/>
                    </xsl:apply-templates>
                    
                </xsl:otherwise>
                
            </xsl:choose>
            
            <xsl:choose>

                <!-- TODO: only do once not each old/new end? -->
                
                <xsl:when test="
                    details-of-change-new[change:div[@class='redline-moved']] and 
                    //row[generate-id()=$generate-id-matched-moved-section]/details-of-change-old[change:div[@class='redline-moved']//(change:span|change:div|@change:*)]
                    ">
                    
                    <xsl:apply-templates select="//row[generate-id()=$generate-id-matched-moved-section]/details-of-change-old[change:div[@class='redline-moved']//(change:span|change:div|@change:*)]" mode="cell">
                        <xsl:with-param name="section-path" select="section-path"/>
                        <xsl:with-param name="matched-moved-section" select="string('true')"/>
                    </xsl:apply-templates>
                    
                </xsl:when>
                
                <xsl:when test="details-of-change-old[.//(change:span|change:div|@change:*)]">
                    
                    <xsl:apply-templates select="details-of-change-old[.//(change:span|change:div|@change:*)]" mode="cell">
                        <xsl:with-param name="section-path" select="section-path"/>
                    </xsl:apply-templates>
                    
                </xsl:when>
                
            </xsl:choose>
            
            <xsl:element name="button">
                <xsl:attribute name="type" select="string('button')"/>
                <xsl:attribute name="onclick" select="string('javascript:scrollTo(0,0);')"/>
                <xsl:text>jump to top</xsl:text>
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="section-path" mode="cell">
        
        <xsl:element name="div">
            <xsl:attribute name="class" select="name()"/>
            
            <xsl:element name="span">
                <xsl:attribute name="class" select="string('prompt')"/>
                
                <xsl:value-of select="name()"/>
                <xsl:text>:</xsl:text>
                
            </xsl:element>
            
            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
            
            <xsl:element name="span">
                <xsl:value-of select="."/>
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="details-of-change-new" mode="cell">
        <xsl:param name="section-path" />
        
        <xsl:element name="div">
            <xsl:attribute name="class" select="name()"/>
            
            <!--<xsl:element name="button">
                <xsl:attribute name="type" select="string('button')"/>
                <xsl:attribute name="class" select="string('clipboard')"/>
                <xsl:attribute name="title" select="$section-path"/>
                <xsl:text>section link to clipboard</xsl:text>
            </xsl:element>-->
            
            <xsl:apply-templates>
                <xsl:with-param name="section-path" select="$section-path" />
            </xsl:apply-templates>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="details-of-change-old" mode="cell">
        <xsl:param name="section-path" />
        <xsl:param name="matched-moved-section" />
        <xsl:param name="name" select="name()"/>
        
        <xsl:choose>
            
            <xsl:when test="change:div[@class='redline-moved'] and $matched-moved-section='true'">
                
                <xsl:element name="dl">
                    <xsl:attribute name="class" select="string('expandable')"/>
                    
                    <xsl:element name="dt">
                        <xsl:attribute name="class" select="string('collapsed')"/>
                        
                        <xsl:element name="div">
                            <xsl:attribute name="class" select="string('collapsed handle')"/>
                            
                            <xsl:element name="button">
                                <xsl:attribute name="type" select="string('button')"/>
                                <xsl:text>expand deleted changes</xsl:text>
                            </xsl:element>
                            
                        </xsl:element>
                        
                    </xsl:element>
                    
                    <xsl:element name="dd">
                        
                        <xsl:element name="div">
                            <xsl:attribute name="class" select="$name"/>
                            
                            <xsl:apply-templates select="change:div[@class='redline-moved']/node()">
                                <xsl:with-param name="section-path" select="$section-path" />
                            </xsl:apply-templates>
                            
                        </xsl:element>
                        
                    </xsl:element>
                    
                </xsl:element>
                
            </xsl:when>
            
            <xsl:when test="change:div[@class='redline-delete' or @class='redline-moved']">
                
                <xsl:apply-templates>
                    <xsl:with-param name="section-path" select="$section-path" />
                </xsl:apply-templates>
                
            </xsl:when>
            
            <xsl:otherwise>
                    
                <xsl:element name="dl">
                    <xsl:attribute name="class" select="string('expandable')"/>
                    
                    <xsl:element name="dt">
                        <xsl:attribute name="class" select="string('collapsed')"/>
                        
                        <xsl:element name="div">
                            <xsl:attribute name="class" select="string('collapsed handle')"/>
                            
                            <xsl:element name="button">
                                <xsl:attribute name="type" select="string('button')"/>
                                <xsl:text>expand deleted changes</xsl:text>
                            </xsl:element>
                            
                        </xsl:element>
                        
                    </xsl:element>
                    
                    <xsl:element name="dd">
                        
                        <xsl:element name="div">
                            <xsl:attribute name="class" select="$name"/>
                            
                            <xsl:apply-templates>
                                <xsl:with-param name="section-path" select="$section-path" />
                            </xsl:apply-templates>
                            
                        </xsl:element>
                        
                    </xsl:element>
                    
                </xsl:element>
                    
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="change:span">
        <xsl:param name="section-path" />
        <xsl:param name="name" select="element()[1]/name()"/><!-- todo bit messy fix later due to nested span/div from flat-xml -->
        
        <xsl:comment select="$name"/>
        
        <xsl:choose>
            
            <xsl:when test="$name = 'pi-comment'">
                <xsl:apply-templates>
                    <xsl:with-param name="section-path" select="$section-path" />
                </xsl:apply-templates>
            </xsl:when>
            
            <xsl:when test="$strings//abstract[@name=$name and @format='inline']">
                
                <xsl:element name="span">
                    <xsl:attribute name="class" select="@class"/>

                    <xsl:element name="span">
                        <xsl:attribute name="class" select="string('inline')"/>
                        
                        <xsl:apply-templates>
                            <xsl:with-param name="section-path" select="$section-path" />
                        </xsl:apply-templates>
                        
                    </xsl:element>
                    
                </xsl:element>
                
            </xsl:when>
            
            <xsl:when 
                test="
                $strings//abstract[@name=$name and @format='link']
                and 
                not(
                ancestor::para 
                or ancestor::p 
                or ancestor::td 
                or ancestor::substantive-change 
                or ancestor::absolute-results 
                or ancestor::reference-original 
                or ancestor::reference-related
                or ancestor::summary-statement
                )
                ">
                
                <xsl:element name="div">
                    <xsl:attribute name="class" select="@class"/>
                
                    <xsl:element name="div">
                        <xsl:attribute name="class" select="string('link')"/>
                        
                        <xsl:apply-templates>
                            <xsl:with-param name="section-path" select="$section-path" />
                        </xsl:apply-templates>
                        
                    </xsl:element>
                    
                </xsl:element>
                
            </xsl:when>
            
            <xsl:when test="$strings//abstract[@name=$name and @format='link']">
                
                <xsl:element name="span">
                    <xsl:attribute name="class" select="@class"/>
                    
                    <xsl:element name="span">
                        <xsl:attribute name="class" select="string('link')"/>
                        
                        <xsl:apply-templates>
                            <xsl:with-param name="section-path" select="$section-path" />
                        </xsl:apply-templates>
                        
                    </xsl:element>
                    
                </xsl:element>
                
            </xsl:when>
            
            <xsl:when test="$strings//abstract[@name=$name]">
                
                <xsl:element name="div">
                    <xsl:attribute name="class" select="@class"/>
                    
                    <xsl:apply-templates>
                        <xsl:with-param name="section-path" select="$section-path" />
                    </xsl:apply-templates>
                    
                </xsl:element>
                
            </xsl:when>
            
            <!-- effectively text() ? -->
            <xsl:otherwise>
                
                <xsl:element name="span">
                    <xsl:attribute name="class" select="@class"/>
                    
                    <xsl:choose>
                        
                        <xsl:when test="string-length(normalize-space(.))=0">
                            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates>
                                <xsl:with-param name="section-path" select="$section-path" />
                            </xsl:apply-templates>
                        </xsl:otherwise>
                        
                    </xsl:choose>
                    
                </xsl:element>
                
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    
    <!-- usually top level ?! -->
    <xsl:template match="change:div">
        <xsl:param name="section-path" />
        <xsl:param name="name" select="element()[1]/name()"/><!-- todo bit messy fix later due to nested span/div from flat-xml -->
        
        <xsl:variable name="generate-id-parent" select="ancestor::row[1]/generate-id()"/>
        <xsl:variable name="generate-id-matched-moved-section" select="generate-id(//row[section-path=$section-path and generate-id(.)!=$generate-id-parent][1])"/>
        
        <xsl:choose>
            
            <xsl:when test="@class='redline-moved' and parent::details-of-change-old">
                
                <xsl:element name="div">
                    <xsl:attribute name="class" select="string('section-changed')"/>
                    
                    <xsl:element name="h2">
                        <xsl:attribute name="class" select="string('heading-implied')"/>
                        
                        <xsl:text>Section moved to </xsl:text>
                        
                        <xsl:element name="a">
                            <xsl:attribute name="href" select="concat('#', generate-id(//row[generate-id()=$generate-id-matched-moved-section]/section-path))"/>
                            
                            <xsl:text>here</xsl:text>
                            
                        </xsl:element>
                        
                    </xsl:element>                    
                    
                    <!--<xsl:apply-templates>
                        <xsl:with-param name="section-path" select="$section-path" />
                    </xsl:apply-templates>-->
                    
                </xsl:element>
                
            </xsl:when>
            
            <xsl:when test="@class='redline-moved' and parent::details-of-change-new">
                
                <xsl:element name="div">
                    <xsl:attribute name="class" select="string('section-changed')"/>
                    
                    <xsl:element name="h2">
                        <xsl:attribute name="class" select="string('heading-implied')"/>
                        
                        <xsl:text>Section moved from </xsl:text>
                        
                        <xsl:element name="a">
                            <xsl:attribute name="href" select="concat('#', generate-id(//row[generate-id()=$generate-id-matched-moved-section]/section-path))"/>
                            
                            <xsl:text>here</xsl:text>
                            
                        </xsl:element>
                        
                    </xsl:element>                    
                    
                    <xsl:apply-templates>
                        <xsl:with-param name="section-path" select="$section-path" />
                    </xsl:apply-templates>
                    
                </xsl:element>
                
            </xsl:when>
            
            <xsl:when test="@class='redline-merged' and parent::details-of-change-new">
                
                <xsl:element name="div">
                    <xsl:attribute name="class" select="string('section-changed')"/>
                    
                    <xsl:element name="h2">
                        <xsl:attribute name="class" select="string('heading-implied')"/>
                        
                        <xsl:text>Section merged</xsl:text>
                        
                    </xsl:element>                    
                    
                    <xsl:apply-templates>
                        <xsl:with-param name="section-path" select="$section-path" />
                    </xsl:apply-templates>
                    
                </xsl:element>
                
            </xsl:when>
            
            <xsl:when test="@class='redline-merged' and parent::details-of-change-old">
                
                <xsl:apply-templates select="change:div/node()">
                    <xsl:with-param name="section-path" select="$section-path" />
                </xsl:apply-templates>
                
            </xsl:when>
            
            <xsl:otherwise>
                
                <xsl:element name="div">
                    <xsl:attribute name="class" select="string('section-changed')"/>
                    
                    <xsl:element name="h2">
                        <xsl:attribute name="class" select="string('heading-implied')"/>
                        
                        <xsl:choose>
                            
                            <xsl:when test="@class='redline-insert'">
                                <xsl:text>New section</xsl:text>        
                            </xsl:when>
                            
                            <xsl:when test="@class='redline-delete'">
                                <xsl:text>Section deleted</xsl:text>
                            </xsl:when>
                            
                        </xsl:choose>
                        
                    </xsl:element>
                
                    <xsl:element name="div">
                        <xsl:attribute name="class" select="@class"/>
                        
                        <xsl:apply-templates>
                            <xsl:with-param name="section-path" select="$section-path" />
                        </xsl:apply-templates>
                        
                    </xsl:element>
                    
                </xsl:element>
                    
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="reference[ancestor::references]">
        <xsl:param name="section-path" />
        <xsl:param name="name" select="name()"/>
        <xsl:param name="target" select="processing-instruction()[name()='target']"/>
        <xsl:param name="id">
            
            <xsl:choose>
                
                <xsl:when test="$server!='offline'">
                    
                    <xsl:choose>
                        
                        <xsl:when test="not(contains(($target), '/'))">
                            
                            <xsl:value-of 
                                select="
                                legacytag:getAbstractId(
                                concat('/bmjk/', $pub-resource-folder, '/', replace(($target), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1'))
                                )"/>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of 
                                select="
                                legacytag:getAbstractId(
                                concat('/bmjk/', replace(($target), '^.*?([^/^\\]+[/\\][^/^\\]+)\.[^/^\\]+$', '$1')) 
                                )"/>
                        </xsl:otherwise>
                        
                    </xsl:choose>
                    
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="replace(($target), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1')"/>
                </xsl:otherwise>
                
            </xsl:choose>
            
        </xsl:param>
        
        <xsl:element name="ul">
            <xsl:attribute name="class" select="$name"/>
            <xsl:attribute name="id" select="$id"/>
            
            <xsl:element name="li">
                
                <xsl:element name="div">
                    <xsl:attribute name="class" select="string('prompt')"/>
                    
                    <xsl:element name="span">
                        <xsl:attribute name="class" select="string('prompt')"/>
                        
                        <xsl:call-template name="process-string-variant">
                            <xsl:with-param name="name" select="$name"/>
                        </xsl:call-template>
                        
                        <xsl:text>: </xsl:text>
                        
                    </xsl:element>
                    
                    <xsl:element name="span">
                        <xsl:attribute name="class" select="string('float-label')"/>
                        
                        <xsl:text>[</xsl:text>
                        <xsl:value-of select="$id"/>
                        <xsl:text>]</xsl:text>
                        
                    </xsl:element>
                    
                    <xsl:if test="contains($markup-format, 'pretty')">
                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                    </xsl:if>
                    
                    <xsl:if test="poc-citation[@type='online']">
                        
                        <!-- todo: pass this to process-attribute template with param to imply process -->
                        
                        <xsl:element name="span">
                            <xsl:attribute name="class" select="string('float-label')" />
                            
                            <xsl:if test="contains($markup-format, 'pretty')">
                                <xsl:text disable-output-escaping="yes">[@</xsl:text>
                            </xsl:if>
                            
                            <xsl:if test="$markup-format='escaped'">
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                            </xsl:if>
                            
                            <xsl:text disable-output-escaping="yes">type="</xsl:text>
                            <xsl:value-of select="poc-citation/@type"/>
                            <xsl:text disable-output-escaping="yes">"</xsl:text>
                            
                            <xsl:if test="contains($markup-format, 'pretty')">
                                <xsl:text disable-output-escaping="yes">]</xsl:text>
                            </xsl:if>
                            
                        </xsl:element>
                        
                        <xsl:if test="contains($markup-format, 'pretty')">
                            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                        </xsl:if>
                        
                    </xsl:if>
                    
                    <xsl:if test="string-length(unique-id[@source='medline'])!=0 and contains($markup-format, 'pretty')">
                        
                        <!-- todo: pass this to process-attribute template with param to imply process -->
                        
                        <xsl:element name="span">
                            <xsl:attribute name="class" select="string('float-label')" />
                            
                            <xsl:text>[</xsl:text>
                            
                            <xsl:element name="a">
                                <xsl:attribute name="href" select="concat($pubmed-url, unique-id)"/>
                                <xsl:attribute name="target" select="string('_blank')"/>
                            
                                <xsl:text>pmc-</xsl:text>
                                <xsl:value-of select="unique-id"/>    
                                    
                            </xsl:element>
                            
                            <xsl:text>]</xsl:text>
                            
                        </xsl:element>
                        
                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                        
                    </xsl:if>
                    
                </xsl:element>
                
                <xsl:choose>
                    
                    <xsl:when test="contains($pub-resource-type, 'monograph')">
                        
                        <xsl:apply-templates select="poc-citation">
                            <xsl:with-param name="section-path" select="$section-path"/>
                        </xsl:apply-templates>
                        
                    </xsl:when>
                    
                    <xsl:when test="contains($pub-resource-type, 'patient')">
                        
                        <xsl:apply-templates select="patient-citation">
                            <xsl:with-param name="section-path" select="$section-path"/>
                        </xsl:apply-templates>
                        
                    </xsl:when>
                    
                    <xsl:when test="contains($pub-resource-type, 'systematic-review')">
                        
                        <xsl:apply-templates select="clinical-citation">
                            <xsl:with-param name="section-path" select="$section-path"/>
                        </xsl:apply-templates>
                        
                        <xsl:if test="not(clinical-citation)">
                            <xsl:apply-templates select="patient-citation">
                                <xsl:with-param name="section-path" select="$section-path"/>
                            </xsl:apply-templates>
                        </xsl:if>
                        
                    </xsl:when>
                    
                    <!--
                    title
                    authors
                    bmjk-citation
                    reference-type
                    order-status
                    -->
                    
                    <xsl:otherwise/>
                    
                </xsl:choose>
                
            </xsl:element>
            
        </xsl:element>
            
    </xsl:template>
    
    <xsl:template match="gloss[ancestor::glosses]">
        <xsl:param name="section-path" />
        <xsl:param name="name" select="name()"/>
        <xsl:param name="target" select="processing-instruction()[name()='target']"/>
        <xsl:param name="id">
            
            <xsl:choose>
                
                <xsl:when test="$server!='offline'">
                    
                    <xsl:choose>
                        
                        <xsl:when test="not(contains(($target), '/'))">
                            
                            <xsl:value-of 
                                select="
                                legacytag:getAbstractId(
                                concat('/bmjk/', $pub-resource-folder, '/', replace(($target), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1'))
                                )"/>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:value-of 
                                select="
                                legacytag:getAbstractId(
                                concat('/bmjk/', replace(($target), '^.*?([^/^\\]+[/\\][^/^\\]+)\.[^/^\\]+$', '$1')) 
                                )"/>
                        </xsl:otherwise>
                        
                    </xsl:choose>
                    
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="replace(($target), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1')"/>
                </xsl:otherwise>
                
            </xsl:choose>
            
        </xsl:param>
        
        <xsl:element name="ul">
            <xsl:attribute name="class" select="$name"/>
            <xsl:attribute name="id" select="$id"/>
            
            <xsl:element name="li">
                
                <xsl:element name="div">
                    <xsl:attribute name="class" select="string('prompt')"/>
                    
                    <xsl:element name="span">
                        <xsl:attribute name="class" select="string('prompt')"/>
                        
                        <xsl:call-template name="process-string-variant">
                            <xsl:with-param name="name" select="$name"/>
                        </xsl:call-template>
                        
                        <xsl:text>: </xsl:text>
                        
                    </xsl:element>
                    
                    <xsl:element name="span">
                        <xsl:attribute name="class" select="string('float-label')"/>
                        
                        <xsl:text>[</xsl:text>
                        <xsl:value-of select="$id"/>
                        <xsl:text>]</xsl:text>
                        
                    </xsl:element>
                    
                    <xsl:if test="contains($markup-format, 'pretty')">
                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                    </xsl:if>
                    
                </xsl:element>
                
                <xsl:choose>
                    
                    <xsl:when test="$pub-resource-type='systematic-review'">
                        
                        <xsl:for-each select="term|definition">
                            
                            <xsl:element name="div">
                                <xsl:attribute name="class" select="string('prompt')"/>
                                
                                <xsl:element name="span">
                                    <xsl:attribute name="class" select="string('prompt')"/>
                                    
                                    <xsl:call-template name="process-string-variant">
                                        <xsl:with-param name="name" select="name()"/>
                                    </xsl:call-template>
                                    
                                    <xsl:text>: </xsl:text>
                                    
                                </xsl:element>
                                
                                <xsl:apply-templates>
                                    <xsl:with-param name="section-path" select="$section-path"/>
                                </xsl:apply-templates>
                                
                            </xsl:element>
                            
                        </xsl:for-each>
                        
                    </xsl:when>
                    
                    <xsl:otherwise>
                        
                        <xsl:apply-templates>
                            <xsl:with-param name="section-path" select="$section-path"/>
                        </xsl:apply-templates>
                        
                    </xsl:otherwise>
                    
                </xsl:choose>
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="thead|tbody|tr|th|td">
        <xsl:param name="section-path"/>
        
        <xsl:element name="{name()}">
            <!--<xsl:call-template name="process-attributes"/>-->
            <xsl:copy-of select="@*[name()!='width']"/>
            
            <xsl:apply-templates>
                <xsl:with-param name="section-path" select="$section-path" />
            </xsl:apply-templates>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="br">
        <xsl:element name="br"/>
    </xsl:template>
    
    <xsl:template match="element()">
        <xsl:param name="section-path" />
        
        <xsl:variable name="name">
            <xsl:value-of select="name()"/>
            <xsl:if test="name()='xref'">
                <xsl:text>-</xsl:text>
                <xsl:value-of select="@ref-type"/>    
            </xsl:if>
        </xsl:variable>
        
        <xsl:variable name="section-path-test">
            <xsl:for-each select="tokenize(substring-after($section-path, '/'), '/')">
                <!--<xsl:sort order="ascending" />-->
                <xsl:if test="not(contains($name, 'change:'))">
                    <xsl:element name="test">
                        <!--<xsl:value-of select="substring-before(., '[')"/>-->
                        <xsl:value-of select="."/>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="name-parent" select="substring-before($section-path-test//test[position()=last()]/preceding-sibling::test[1], '[')" />
        <xsl:variable name="name-grandparent" select="substring-before($section-path-test//test[position()=last()]/preceding-sibling::test[2], '[')" />
        
        <xsl:choose>
            
            <xsl:when test="$markup-format='escaped'">
                
                <xsl:element name="div">
                    
                    <xsl:choose>
                        
                        <xsl:when test="parent::*[not(contains(name(), 'details-of-change'))]">
                            <xsl:attribute name="class" select="string('indent')"/>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:attribute name="class" select="$name"/>
                        </xsl:otherwise>
                        
                    </xsl:choose>
                    
                    <xsl:text disable-output-escaping="no">&lt;</xsl:text>
                    <xsl:value-of select="$name"/>
                    
                    <xsl:call-template name="process-attributes"/>
                    
                    <xsl:choose>
                        
                        <xsl:when test="count(child::node())=0 or (count(child::node())=1 and child::node()[self::text() and string-length(normalize-space(.))=0])">
                            
                            <xsl:text disable-output-escaping="no"> /&gt;</xsl:text>
                            
                            <!--<xsl:if test="child::node()[not(self::text() and string-length(normalize-space(.))!=0)]">
                                <xsl:copy-of select="$break"/>
                                </xsl:if>-->
                            
                        </xsl:when>
                        
                        <xsl:otherwise>
                            
                            <xsl:text disable-output-escaping="no">&gt;</xsl:text>
                            
                            <!--<xsl:if 
                                test="
                                (
                                preceding-sibling::node()[1]
                                [
                                (
                                self::text() 
                                and string-length(normalize-space(.))=0
                                ) 
                                or 
                                self::element()
                                ]
                                or  
                                count(preceding-sibling::element())=0
                                )
                                and  
                                not(child::text()[string-length(normalize-space(.))!=0])
                                ">
                                <xsl:copy-of select="$break"/>        
                            </xsl:if>-->
                            
                            <xsl:apply-templates select="node()[name()!='tx-options' and name()!='article']">
                                <xsl:with-param name="section-path" select="$section-path"/>
                            </xsl:apply-templates>
                            
                            <!--<xsl:if 
                                test="
                                (
                                following-sibling::node()[1]
                                [
                                (
                                self::text() 
                                and string-length(normalize-space(.))=0
                                ) 
                                or 
                                self::element()
                                ]
                                or  
                                count(following-sibling::element())=0
                                )
                                and  
                                not(child::text()[string-length(normalize-space(.))!=0])
                                ">
                                <xsl:copy-of select="$break"/>
                            </xsl:if>-->
                            
                            <xsl:text disable-output-escaping="no">&lt;/</xsl:text>
                            <xsl:value-of select="$name"/>
                            <xsl:text disable-output-escaping="no">&gt;</xsl:text>
                            
                        </xsl:otherwise>
                        
                    </xsl:choose>
                    
                    <!--<xsl:if test="following-sibling::*[1][(self::text() and string-length(normalize-space(.))=0) or self::element()]">
                        <xsl:copy-of select="$break"/>
                    </xsl:if>-->
                    
                </xsl:element>
                
            </xsl:when>
            
            <xsl:when test="$markup-format='pretty'">
                
                <xsl:choose>
                    
                    <!-- ignore some sections -->
                    <!-- TODO: some of these getting missed?! -->
                    <xsl:when 
                        test="
                        self::monograph-plan-link[parent::monograph-info]
                        or self::related-article[parent::article-meta and @related-article-type='references-list']
                        or self::related-article[parent::article-meta and @related-article-type='systematic-review']
                        or self::bmjk-review-plan-link
                        " />
                    <!--
                        or self::title[parent::monograph-info]
                        or (self::article-title and not(ancestor::front))
                        or (self::title and $section-path = '/systematic-review/info')
                    -->
                    
                    <!-- ignore empty sections -->
                    <xsl:when test="$strings//abstract[@name=$name and @format='heading-implied'] and string-length(normalize-space(.))=0" />
                    
                    <xsl:when test="$strings//abstract[@name=$name and @format='ignored']">
                        
                        <xsl:element name="div">
                            <xsl:call-template name="process-attributes"/>
                        </xsl:element>
                        
                        <xsl:apply-templates select="node()[name()!='tx-options' and name()!='article']">
                            <xsl:with-param name="section-path" select="$section-path"/>
                        </xsl:apply-templates>
                        
                    </xsl:when>
                    
                    <xsl:when test="$strings//abstract[@name=$name and @format='heading-implied']">
                            
                        <xsl:variable name="target">
                            
                            <xsl:if 
                                test="
                                (
                                $name='figure'
                                or $name='table'
                                or (contains($pub-resource-type, 'monograph') and $name='evidence-score') 
                                or (contains($pub-resource-type, 'patient') and $name='article-meta')
                                or ($pub-resource-type='systematic-review' and $name='option')
                                )
                                and 
                                processing-instruction()[name()='target']
                                ">
                                
                                <xsl:value-of select="processing-instruction()[name()='target']"/>
                                
                            </xsl:if>
                            
                        </xsl:variable> 
                            
                        <xsl:variable name="id">
                            
                            <xsl:choose>
                                
                                <xsl:when test="string-length(normalize-space($target))=0"/>
                                
                                <xsl:when test="$server='offline'">
                                    
                                    <xsl:value-of select="replace($target, '^.*?([^/^\\]+)\.[^/^\\]+$', '$1')"/>
                                    
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    
                                    <xsl:choose>
                                        
                                        <xsl:when test="not(contains($target, '/'))">
                                            <xsl:value-of 
                                                select="
                                                legacytag:getAbstractId(
                                                concat('/bmjk/', $pub-resource-folder, '/', replace($target, '^.*?([^/^\\]+)\.[^/^\\]+$', '$1'))
                                                )"/>
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of 
                                                select="
                                                legacytag:getAbstractId(
                                                concat('/bmjk/', replace($target, '^.*?([^/^\\]+[/\\][^/^\\]+)\.[^/^\\]+$', '$1')) 
                                                )"/>
                                        </xsl:otherwise>
                                        
                                    </xsl:choose>
                                    
                                </xsl:otherwise>
                                
                            </xsl:choose>
                            
                        </xsl:variable>
                            
                        <xsl:element name="div">
                            
                            <xsl:if test="string-length(normalize-space($id))!=0">
                                <xsl:attribute name="id" select="$id"/>        
                            </xsl:if>
                        
                            <xsl:choose>
                                
                                <xsl:when test="parent::*[contains(name(), 'details-of-change')]">
                                    
                                    <xsl:element name="h2">
                                        <xsl:attribute name="class" select="string('heading-implied')"/>
                                        
                                        <xsl:choose>
                                            
                                            <!-- concat parent heading if level-3 section heading and matches conditions for split sections -->
                                            <xsl:when 
                                                test="
                                                count($section-path-test//test)=4
                                                and contains($pub-resource-type, 'monograph')
                                                ">
                                                <!--and ($name='risk-factor' and $name-parent='risk-factors')-->
                                            
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="$name-grandparent" />
                                                </xsl:call-template>
                                                
                                                <xsl:text>: </xsl:text>
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="$name-parent"/>
                                                </xsl:call-template>
                                                
                                               <!-- <xsl:text disable-output-escaping="yes"> &gt; </xsl:text>
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="$name"/>
                                                </xsl:call-template>-->
                                                
                                            </xsl:when>
                                            
                                            <!-- concat parent heading if level-2 section heading -->
                                            <xsl:when 
                                                test="
                                                count($section-path-test//test)=3
                                                and contains($pub-resource-type, 'monograph')
                                                ">
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="$name-parent"/>
                                                </xsl:call-template>
                                                
                                                <xsl:text>: </xsl:text>
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="$name"/>
                                                </xsl:call-template>
                                                    
                                            </xsl:when>
                                            
                                            <!-- /monograph-full/treatment[1]/tx-options[1]/tx-option[1]/tx-options[1]/tx-option[@id='560454'] -->
                                            <xsl:when 
                                                test="
                                                matches(
                                                $section-path,
                                                'tx-options[\[0-9\]]*/tx-option[\[0-9\]]*/tx-options[\[0-9\]]*/tx-option')
                                                and contains($pub-resource-type, 'monograph')
                                                ">
                                                <!-- todo: do the same for bh: sub article ?? -->
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="string('treatment')"/>
                                                </xsl:call-template>
                                                
                                                <xsl:text>: </xsl:text>
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="concat($name, '-child')"/>
                                                </xsl:call-template>
                                                
                                            </xsl:when>
                                            
                                            <xsl:when 
                                                test="
                                                $name='tx-option'
                                                and contains($pub-resource-type, 'monograph')
                                                ">
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="string('treatment')"/>
                                                </xsl:call-template>
                                                
                                                <xsl:text>: </xsl:text>
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="$name"/>
                                                </xsl:call-template>
                                                
                                            </xsl:when>
                                            
                                            <xsl:when 
                                                test="
                                                ($name-parent='description'
                                                or $name-parent='treatment-points')
                                                and $name-grandparent='body'
                                                and contains($pub-resource-type, 'patient')
                                                ">
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="$name-parent"/>
                                                </xsl:call-template>
                                                
                                                <xsl:text>: </xsl:text>
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="$name"/>
                                                </xsl:call-template>
                                                
                                            </xsl:when>
                                            
                                            <xsl:when 
                                                test="
                                                $name-grandparent='treatment-groups'
                                                and contains($pub-resource-type, 'patient')
                                                ">
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="string('treatment-group')"/>
                                                </xsl:call-template>
                                                
                                                <xsl:text> #</xsl:text>
                                                <xsl:value-of select="replace($section-path, '^.*?/group\[(\d+)\].+?$', '$1')"/>
                                                <xsl:text>: </xsl:text>
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="$name"/>
                                                </xsl:call-template>
                                                
                                            </xsl:when>
                                            
                                            <xsl:when 
                                                test="
                                                $name-grandparent='article'
                                                and substring-before($section-path-test//test[position()=last()]/preceding-sibling::test[3], '[') = 'treatments' 
                                                and contains($pub-resource-type, 'patient')
                                                ">
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="string('treatment-group')"/>
                                                </xsl:call-template>
                                                
                                                <xsl:text> #</xsl:text>
                                                <xsl:value-of select="replace($section-path, '^.*?/group\[(\d+)\].+?$', '$1')"/>
                                                
                                                <xsl:text disable-output-escaping="yes"> </xsl:text>
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="string('sub-article')"/>
                                                </xsl:call-template>
                                                
                                                <xsl:text> #</xsl:text>
                                                <xsl:value-of select="replace($section-path, '^.*?/treatments\[\d+\]/article\[(\d+)\].+?$', '$1')"/>
                                                <xsl:text>: </xsl:text>
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="$name"/>
                                                </xsl:call-template>
                                                
                                                <xsl:if test="$name='article-meta'">
                                                    
                                                    <xsl:element name="span">
                                                        <xsl:attribute name="class" select="string('float-label')"/>
                                                        
                                                        <xsl:text>[@id="</xsl:text>
                                                        <xsl:value-of select="$id"/>
                                                        <xsl:text>"]</xsl:text>
                                                        
                                                    </xsl:element>
                                                    
                                                </xsl:if>
                                                
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="$name"/>
                                                </xsl:call-template>
                                                
                                            </xsl:otherwise>
                                            
                                        </xsl:choose>
                                        
                                        <xsl:call-template name="process-attributes"/>
                                        
                                    </xsl:element>
                                        
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    
                                    <xsl:element name="div">
                                        <xsl:attribute name="class" select="string('heading-implied')"/>
                                    
                                        <xsl:call-template name="process-string-variant">
                                            <xsl:with-param name="name" select="$name"/>
                                        </xsl:call-template>
                                            
                                        <xsl:call-template name="process-attributes"/>
                                        
                                    </xsl:element>
                                    
                                </xsl:otherwise>
                                
                            </xsl:choose>
                        
                            <xsl:apply-templates select="node()[name()!='tx-options' and name()!='article']">
                                <xsl:with-param name="section-path" select="$section-path"/>
                            </xsl:apply-templates>
                            
                        </xsl:element>
                        
                    </xsl:when>
                    
                    <xsl:when test="$strings//abstract[@name=$name and @format='heading-self']">
                        
                        <xsl:element name="div">
                            <xsl:attribute name="class" select="string('heading')" />

                            <xsl:apply-templates select="node()">
                                <xsl:with-param name="section-path" select="$section-path"/>
                            </xsl:apply-templates>
                            
                            <xsl:call-template name="process-attributes"/>
                            
                        </xsl:element>
                        
                    </xsl:when>
                    
                    <xsl:when test="$strings//abstract[@name=$name and @format='section']">
                        
                        <xsl:element name="div">
                            <xsl:attribute name="class" select="string('section')"/>
                            
                            <xsl:element name="div">
                                <xsl:attribute name="class" select="string('heading-implied')" />
                                
                                <xsl:call-template name="process-string-variant">
                                    <xsl:with-param name="name" select="string('section')"/>
                                </xsl:call-template>
                                
                                <xsl:call-template name="process-attributes"/>
                                
                            </xsl:element>
                            
                            <xsl:apply-templates select="node()[name()!='tx-options' and name()!='article']">
                                <xsl:with-param name="section-path" select="$section-path"/>
                            </xsl:apply-templates>
                            
                        </xsl:element>
                        
                    </xsl:when>
                    
                    <xsl:when test="$strings//abstract[@name=$name and @format='section-heading']">
                        
                        <xsl:element name="div">
                            <xsl:attribute name="class" select="string('section')"/>
                            
                            <xsl:element name="div">
                                <xsl:attribute name="class" select="string('heading-implied')" />
                                
                                <xsl:call-template name="process-string-variant">
                                    <xsl:with-param name="name" select="$name"/>
                                </xsl:call-template>
                                
                                <xsl:call-template name="process-attributes"/>
                                
                            </xsl:element>
                            
                            <xsl:apply-templates select="node()[name()!='tx-options' and name()!='article']">
                                <xsl:with-param name="section-path" select="$section-path"/>
                            </xsl:apply-templates>
                            
                        </xsl:element>
                        
                    </xsl:when>
                    
                    <xsl:when test="$strings//abstract[@name=$name and @format='section-implied']">
                        
                        <xsl:element name="div">
                            <xsl:attribute name="class" select="string('section')"/>
                            
                            <xsl:element name="div">
                                <xsl:attribute name="class" select="string('heading-implied')" />
                                
                                <xsl:call-template name="process-string-variant">
                                    <xsl:with-param name="name" select="string('section')"/>
                                </xsl:call-template>
                                
                                <xsl:call-template name="process-attributes"/>
                                
                            </xsl:element>
                            
                            <xsl:apply-templates select="node()[name()!='tx-options' and name()!='article']">
                                <xsl:with-param name="section-path" select="$section-path"/>
                            </xsl:apply-templates>
                            
                        </xsl:element>
                        
                    </xsl:when>
                    
                    <xsl:when test="$strings//abstract[@name=$name and @format='section-self']">
                        
                        <xsl:element name="div">
                            <xsl:attribute name="class" select="string('section')"/>
                            
                            <xsl:element name="div">
                                <xsl:call-template name="process-attributes"/>
                            </xsl:element>
                            
                            <xsl:apply-templates select="node()[name()!='tx-options' and name()!='article']">
                                <xsl:with-param name="section-path" select="$section-path"/>
                            </xsl:apply-templates>
                            
                        </xsl:element>
                        
                    </xsl:when>
                    
                    <!-- TODO: change to section-prompt? -->
                    <xsl:when 
                        test="
                        $strings//abstract[@name=$name and @format='para-prompt']
                        and (string-length(normalize-space(.))!=0 or @*)
                        ">
                        
                        <xsl:element name="div">
                            <xsl:attribute name="class" select="string('prompt')" />
                        
                            <xsl:element name="span">
                                <xsl:attribute name="class" select="string('prompt')" />
                                
                                <xsl:call-template name="process-string-variant">
                                    <xsl:with-param name="name" select="$name"/>
                                </xsl:call-template>
                                
                                <xsl:text>: </xsl:text>
                            
                            </xsl:element>
                            
                            <xsl:call-template name="process-attributes"/>
                            
                            <xsl:if test="$name = 'alt-link-wrapper'">
                                
                                <xsl:element name="span">
                                    <xsl:attribute name="class" select="string('float-label')"/>
                                    
                                    <xsl:text>[</xsl:text>
                                    
                                    <xsl:call-template name="process-link-label">
                                        <xsl:with-param name="link" select="." />
                                    </xsl:call-template>
                                    
                                    <xsl:text disable-output-escaping="yes">: </xsl:text>
                                    
                                    <xsl:choose>
                                        
                                        <xsl:when test="string-length(normalize-space(@alt-text))=0">
                                            <xsl:text>blank</xsl:text>
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:value-of select="@alt-text"/>
                                        </xsl:otherwise>
                                        
                                    </xsl:choose>
                                    
                                    <xsl:text>]</xsl:text>
                                    
                                </xsl:element>
                                
                            </xsl:if>
                            
                            <xsl:choose>
                                
                                <xsl:when 
                                    test="
                                    $name = 'url'
                                    or $name = 'abstract-url'
                                    or $name = 'fulltext-url'
                                    or $name = 'guideline-url'
                                    
                                    and 
                                    (
                                    contains(normalize-space(.), 'http')
                                    or contains(normalize-space(.), 'www')
                                    )
                                    ">
                                    
                                    <xsl:element name="a">
                                        <xsl:attribute name="href" select="normalize-space(.)"/>
                                        <xsl:attribute name="target" select="string('_blank')"/>
                                    
                                        <xsl:apply-templates select="node()">
                                            <xsl:with-param name="section-path" select="$section-path"/>
                                        </xsl:apply-templates>
                                        
                                    </xsl:element>
                                    
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    
                                    <xsl:apply-templates select="node()">
                                        <xsl:with-param name="section-path" select="$section-path"/>
                                    </xsl:apply-templates>                                    
                                    
                                </xsl:otherwise>
                                
                            </xsl:choose>
                            
                        </xsl:element>
                        
                    </xsl:when>
                    
                    <xsl:when test="$strings//abstract[@name=$name and @format='para-prompt']"/>
                    
                    <xsl:when test="$strings//abstract[@name=$name and @format='para']">
                        
                        <xsl:element name="div">
                            <xsl:attribute name="class" select="string('para')"/>
                            
                            <xsl:attribute name="class" select="$name"/>

                            <xsl:call-template name="process-attributes"/>
                        
                            <xsl:apply-templates select="node()">
                                <xsl:with-param name="section-path" select="$section-path"/>
                            </xsl:apply-templates>
                        
                        </xsl:element>
                        
                    </xsl:when>
                    
                    <xsl:when test="$strings//abstract[@name=$name and @format='list']">
                        
                        <xsl:element name="ul">
                            
                            <xsl:element name="li">
                                
                                <xsl:call-template name="process-attributes"/>
                                
                                <xsl:apply-templates>
                                    <xsl:with-param name="section-path" select="$section-path" />
                                </xsl:apply-templates>
                                
                            </xsl:element>
                            
                        </xsl:element>
                        
                    </xsl:when>
                    
                    <xsl:when test="$strings//abstract[@name=$name and (@format='strong' or @format='em' or @format='inline' or @format='sup' or @format='sub')]">
                        
                        <xsl:element name="span">
                            <xsl:attribute name="class" select="$name"/>
                            
                            <xsl:apply-templates>
                                <xsl:with-param name="section-path" select="$section-path" />
                            </xsl:apply-templates>
                            
                            <xsl:call-template name="process-attributes"/>
                            
                        </xsl:element>
                        
                    </xsl:when>

                    <xsl:when 
                        test="
                        $strings//abstract[@name=$name and @format='link'] 
                        and 
                        not(
                        ancestor::para 
                        or ancestor::p 
                        or ancestor::td 
                        or ancestor::substantive-change 
                        or ancestor::absolute-results 
                        or ancestor::reference-original 
                        or ancestor::reference-related
                        or ancestor::summary-statement
                        )
                        ">
                        <!-- TODO: if add more rules here also add to change:span match templte -->
                        
                        <xsl:variable name="target-link" select="@target | @rid | @href" />
                        
                        <xsl:element name="ul">
                            
                            <xsl:element name="li">
                                
                                <xsl:element name="span">
                                    <xsl:attribute name="class" select="string('prompt')" />
                                    
                                    <xsl:call-template name="process-string-variant">
                                        <xsl:with-param name="name" select="$name"/>
                                    </xsl:call-template>
                                    
                                    <xsl:text>: </xsl:text>
                                    
                                </xsl:element>
                                
                                <xsl:if test="string-length(normalize-space(.))!=0">
                                    
                                    <xsl:element name="span">
                                        <xsl:attribute name="class" select="string('link')"/>
                                        
                                        <xsl:apply-templates>
                                            <xsl:with-param name="section-path" select="$section-path" />
                                        </xsl:apply-templates>
                                        
                                    </xsl:element>
                                    
                                </xsl:if>
                                
                                <xsl:call-template name="process-attributes"/>
                                
                                <xsl:element name="span">
                                    <xsl:attribute name="class" select="string('float-label')"/>
                                    
                                    <xsl:text>[</xsl:text>
                                    
                                    <xsl:element name="a">
                                        
                                        <!--<xsl:attribute name="href">
                                            
                                            <xsl:choose>
                                                
                                                <xsl:when test="$name='ext-link'">
                                                    <xsl:value-of select="@href"/>
                                                </xsl:when>
                                                
                                                <xsl:when test="$server='offline'">
                                                    <xsl:text>#</xsl:text>
                                                    <xsl:value-of select="replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1')"/>
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    
                                                    <xsl:choose>
                                                        
                                                        <xsl:when test="not(contains((@target | @rid | @href), '/'))">
                                                            <xsl:text>#</xsl:text>
                                                            <xsl:value-of 
                                                                select="
                                                                legacytag:getAbstractId(
                                                                concat('/bmjk/', $pub-resource-folder, '/', replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1'))
                                                                )"/>
                                                        </xsl:when>
                                                        
                                                        <xsl:otherwise>
                                                            <xsl:text>#</xsl:text>
                                                            <xsl:value-of 
                                                                select="
                                                                legacytag:getAbstractId(
                                                                concat('/bmjk/', replace((@target | @rid | @href), '^.*?([^/^\\]+[/\\][^/^\\]+)\.[^/^\\]+$', '$1')) 
                                                                )"/>
                                                        </xsl:otherwise>
                                                        
                                                    </xsl:choose>
                                                    
                                                </xsl:otherwise>
                                                
                                            </xsl:choose>
                                            
                                            </xsl:attribute>-->
                                        
                                        <xsl:attribute name="href">
                                            
                                            <xsl:choose>
                                                
                                                <xsl:when test="$name='ext-link'">
                                                    <xsl:value-of select="@href"/>
                                                </xsl:when>
                                                
                                                <xsl:when test="$server!='offline'">
                                                    
                                                    <xsl:text>#</xsl:text>
                                                    
                                                    <xsl:choose>
                                                        
                                                        <xsl:when test="not(contains((@target | @rid | @href), '/')) and $name='xref-patient-treatment'">
                                                            <xsl:value-of 
                                                                select="
                                                                legacytag:getAbstractId(
                                                                concat('/bmjk/patient-treatment/', replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1'))
                                                                )"/>
                                                        </xsl:when>
                                                        
                                                        <xsl:when test="not(contains((@target | @rid | @href), '/'))">
                                                            <xsl:value-of 
                                                                select="
                                                                legacytag:getAbstractId(
                                                                concat('/bmjk/', $pub-resource-folder, '/', replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1'))
                                                                )"/>
                                                        </xsl:when>
                                                        
                                                        <xsl:otherwise>
                                                            <xsl:value-of 
                                                                select="
                                                                legacytag:getAbstractId(
                                                                concat('/bmjk/', replace((@target | @rid | @href), '^.*?([^/^\\]+[/\\][^/^\\]+)\.[^/^\\]+$', '$1')) 
                                                                )"/>
                                                        </xsl:otherwise>
                                                        
                                                    </xsl:choose>
                                                    
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    <xsl:text>#</xsl:text>
                                                    <xsl:value-of select="replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1')"/>
                                                </xsl:otherwise>
                                                
                                            </xsl:choose>
                                            
                                        </xsl:attribute>
                                        
                                        <xsl:if 
                                            test="
                                            $name='xref-patient-topic'
                                            or $name='xref-elective-surgery'
                                            or $name='xref-static-content'
                                            or $name='xref-option-link'
                                            or $name='xref-systematic-review-link'
                                            or $name='related-article'
                                            or 
                                            (
                                            $name='xref-patient-treatment'
                                            and not(//processing-instruction()[name()='target' and contains(self::node(), $target-link)])
                                            )
                                            ">
                                            
                                            <xsl:attribute name="onclick" select="string('show_alert()')"/>
                                            
                                        </xsl:if>
                                        
                                        <xsl:if test="$name='ext-link'">
                                            <xsl:attribute name="target" select="string('_blank')"/>
                                        </xsl:if>
                                        
                                        <xsl:call-template name="process-link-label">
                                            <xsl:with-param name="link" select="." />
                                        </xsl:call-template>
                                        
                                        <xsl:text disable-output-escaping="yes">-</xsl:text>
                                        
                                        <xsl:choose>
                                            
                                            <xsl:when test="$name='ext-link'">
                                                <xsl:value-of select="@href"/>
                                            </xsl:when>
                                            
                                            <xsl:when test="$server='offline'">
                                                <xsl:value-of select="replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1')"/>
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                
                                                <xsl:choose>
                                                    
                                                    <xsl:when test="not(contains((@target | @rid | @href), '/')) and $name='xref-patient-treatment'">
                                                        <xsl:value-of 
                                                            select="
                                                            legacytag:getAbstractId(
                                                            concat('/bmjk/patient-treatment/', replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1'))
                                                            )"/>
                                                    </xsl:when>
                                                    
                                                    <xsl:when test="not(contains((@target | @rid | @href), '/'))">
                                                        <xsl:value-of 
                                                            select="
                                                            legacytag:getAbstractId(
                                                            concat('/bmjk/', $pub-resource-folder, '/', replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1'))
                                                            )"/>
                                                    </xsl:when>
                                                    
                                                    <xsl:otherwise>
                                                        <xsl:value-of 
                                                            select="
                                                            legacytag:getAbstractId(
                                                            concat('/bmjk/', replace((@target | @rid | @href), '^.*?([^/^\\]+[/\\][^/^\\]+)\.[^/^\\]+$', '$1')) 
                                                            )"/>
                                                    </xsl:otherwise>
                                                    
                                                </xsl:choose>
                                                
                                            </xsl:otherwise>
                                            
                                        </xsl:choose>
                                        
                                    </xsl:element>
                                    
                                    <xsl:text>]</xsl:text>
                                    
                                </xsl:element>
                                    
                            </xsl:element>
                            
                        </xsl:element>
                        
                    </xsl:when>
                    
                    <xsl:when test="$strings//abstract[@name=$name and @format='link']">
                        
                        <xsl:variable name="target-link" select="@target | @rid | @href"/>

                        <xsl:element name="span">
                            <xsl:attribute name="class" select="string('link')"/>
                            
                            <xsl:apply-templates>
                                <xsl:with-param name="section-path" select="$section-path" />
                            </xsl:apply-templates>
                            
                        </xsl:element>
                        
                        <xsl:element name="span">
                            <xsl:attribute name="class" select="string('float-label')"/>
                            
                            <xsl:text>[</xsl:text>
                            
                            <xsl:element name="a">
                                <xsl:attribute name="class" select="$name"/>
                                
                                <xsl:attribute name="href">
                                    
                                    <xsl:choose>
                                        
                                        <xsl:when test="$name='ext-link'">
                                            <xsl:value-of select="@href"/>
                                        </xsl:when>
                                        
                                        <xsl:when test="$server!='offline'">
                                            
                                            <xsl:text>#</xsl:text>
                                            
                                            <xsl:choose>
                                                
                                                <xsl:when test="not(contains((@target | @rid | @href), '/')) and $name='xref-patient-treatment'">
                                                    <xsl:value-of 
                                                        select="
                                                        legacytag:getAbstractId(
                                                        concat('/bmjk/patient-treatment/', replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1'))
                                                        )"/>
                                                </xsl:when>
                                                
                                                
                                                
                                                <!-- TODO:
                                                    
                                                    <option-link target="option-1266338961375.xml" xpointer="benefits">See benefits of
                                                    immunoglobulin</option-link>
                                                    
                                                    vs
                                                    
                                                    <option-link target="../options/_op0319_I1.xml" xpointer="benefits"
                                                    >Phototherapy</option-link>
                                                    
                                                -->
                                                
                                                
                                                <xsl:when test="not(contains((@target | @rid | @href), '/'))">
                                                    
                                                    <xsl:choose>
                                                        
                                                        <xsl:when test="$name='xref-patient-treatment'">
                                                            <xsl:value-of 
                                                                select="
                                                                legacytag:getAbstractId(
                                                                concat('/bmjk/options/', replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1'))
                                                                )"/>
                                                        </xsl:when>
                                                        
                                                        <xsl:otherwise>
                                                            <xsl:value-of 
                                                                select="
                                                                legacytag:getAbstractId(
                                                                concat('/bmjk/', $pub-resource-folder, '/', replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1'))
                                                                )"/>
                                                        </xsl:otherwise>
                                                        
                                                    </xsl:choose>
                                                    
                                                </xsl:when>
                                                
                                                <xsl:otherwise>
                                                    <xsl:value-of 
                                                        select="
                                                        legacytag:getAbstractId(
                                                        concat('/bmjk/', replace((@target | @rid | @href), '^.*?([^/^\\]+[/\\][^/^\\]+)\.[^/^\\]+$', '$1')) 
                                                        )"/>
                                                </xsl:otherwise>
                                                
                                            </xsl:choose>
                                            
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            <xsl:text>#</xsl:text>
                                            <xsl:value-of select="replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1')"/>
                                        </xsl:otherwise>
                                        
                                    </xsl:choose>
                                    
                                </xsl:attribute>
                                
                                <xsl:if 
                                    test="
                                    $name='xref-patient-topic'
                                    or $name='xref-elective-surgery'
                                    or $name='xref-static-content'
                                    or $name='xref-option-link'
                                    or $name='xref-systematic-review-link'
                                    or $name='related-article'
                                    or $name='drug'
                                    or 
                                    (
                                    $name='xref-patient-treatment'
                                    and not(//processing-instruction()[name()='target' and contains(self::node(), $target-link)])
                                    )
                                    ">
                                    
                                    <xsl:attribute name="onclick" select="string('show_alert()')"/>
                                    
                                </xsl:if>
                                
                                <xsl:if test="$name='ext-link'">
                                    <xsl:attribute name="target" select="string('_blank')"/>
                                </xsl:if>
                                
                                <xsl:call-template name="process-link-label">
                                    <xsl:with-param name="link" select="." />
                                </xsl:call-template>
                                
                                <xsl:if test="$name!='drug'">
                                    <xsl:text disable-output-escaping="yes">-</xsl:text>
                                </xsl:if>
                                
                                <xsl:choose>
                                    
                                    <xsl:when test="$name='ext-link'">
                                        <xsl:value-of select="@href"/>
                                    </xsl:when>
                                    
                                    <xsl:when test="$server!='offline'">
                                        
                                        <xsl:choose>
                                            
                                            <xsl:when test="not(contains((@target | @rid | @href), '/')) and $name='xref-patient-treatment'">
                                                <xsl:value-of 
                                                    select="
                                                    legacytag:getAbstractId(
                                                    concat('/bmjk/patient-treatment/', replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1'))
                                                    )"/>
                                            </xsl:when>
                                            
                                            
                                            <xsl:when test="not(contains((@target | @rid | @href), '/'))">
                                                <xsl:value-of 
                                                    select="
                                                    legacytag:getAbstractId(
                                                    concat('/bmjk/', $pub-resource-folder, '/', replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1'))
                                                    )"/>
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:value-of 
                                                    select="
                                                    legacytag:getAbstractId(
                                                    concat('/bmjk/', replace((@target | @rid | @href), '^.*?([^/^\\]+[/\\][^/^\\]+)\.[^/^\\]+$', '$1')) 
                                                    )"/>
                                            </xsl:otherwise>
                                            
                                        </xsl:choose>
                                        
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1')"/>
                                    </xsl:otherwise>
                                    
                                </xsl:choose>
                                
                            </xsl:element>
                            
                            <xsl:text>]</xsl:text>
                            
                        </xsl:element>
                        
                    </xsl:when>
                    
                    <xsl:when test="$strings//abstract[@name=$name and @format='image']">
                        
                        <xsl:element name="div">
                            <xsl:attribute name="class" select="string('image')"/>
                            
                            <xsl:comment select="(@target | @rid | @href)"/>
                            <!--../monograph-images/39-1-hlight_default.jpg-->
                            
                            <xsl:element name="img">
                                <xsl:attribute name="src" select="replace((@target | @rid | @href), '^.*?([^/^\\]+\.[^/^\\]+)$', '../images/$1')" />
                            </xsl:element>
                            
                            <xsl:element name="div">
                                <xsl:attribute name="class" select="string('prompt')"/>
                                
                                <xsl:element name="span">
                                    <xsl:attribute name="class" select="string('prompt')"/>
                                    
                                    <xsl:text>Filename: </xsl:text>
                                    
                                </xsl:element>
                                
                                <xsl:value-of select="replace((@target | @rid | @href), '^.*?([^/^\\]+\.[^/^\\]+)$', '$1')" />
                                
                            </xsl:element>
                            
                        </xsl:element>
                        
                    </xsl:when>
                    
                    <xsl:when test="$strings//abstract[@name=$name and @format='table']">
                        
                        <xsl:element name="div">
                            <xsl:attribute name="class" select="string('table')"/>
                            
                            <xsl:attribute name="id">
                                
                                <xsl:variable name="target" select="processing-instruction()[name()='target']"/><!-- ce only? -->
                                
                                <xsl:choose>
                                    
                                    <xsl:when test="$server!='offline'">
                                        
                                        <xsl:choose>
                                            
                                            <xsl:when test="not(contains(($target), '/'))">
                                                <xsl:value-of 
                                                    select="
                                                    legacytag:getAbstractId(
                                                    concat('/bmjk/', $pub-resource-folder, '/', replace((@target | @rid | @href), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1'))
                                                    )"/>
                                            </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:value-of 
                                                    select="
                                                    legacytag:getAbstractId(
                                                    concat('/bmjk/', replace(($target), '^.*?([^/^\\]+[/\\][^/^\\]+)\.[^/^\\]+$', '$1')) 
                                                    )"/>
                                            </xsl:otherwise>
                                            
                                        </xsl:choose>
                                        
                                    </xsl:when>
                                    
                                    <xsl:otherwise>
                                        <xsl:value-of select="replace(($target), '^.*?([^/^\\]+)\.[^/^\\]+$', '$1')"/>
                                    </xsl:otherwise>
                                    
                                </xsl:choose>
                                
                            </xsl:attribute>
                            
                            
                            <xsl:element name="div">
                                <xsl:attribute name="class" select="string('heading-implied')" />
                                
                                <xsl:call-template name="process-string-variant">
                                    <xsl:with-param name="name" select="$name"/>
                                </xsl:call-template>
                                
                            </xsl:element>
                            
                            <xsl:element name="table">
                                <xsl:copy-of select="@*"/>
                                
                                <xsl:apply-templates>
                                    <xsl:with-param name="section-path" select="$section-path" />
                                </xsl:apply-templates>
                                
                            </xsl:element>

                        </xsl:element>
                        
                    </xsl:when>
                    
                    <xsl:when test="$strings//abstract[contains(@name, 'pi-comment') and @format='pi-comment']">
                        
                        <xsl:element name="span">
                            <xsl:attribute name="class" select="concat($name, '-', @type)"/>
                            
                            <!--<xsl:text>[</xsl:text>-->
                            
                            <xsl:element name="span">
                                <xsl:attribute name="class" select="string('prompt')"/>
                                
                                <xsl:call-template name="process-string-variant">
                                    <xsl:with-param name="name" select="concat($name, '-', @type)"/>
                                </xsl:call-template>
                                
                                <xsl:text>: </xsl:text>
                                
                            </xsl:element>
                            
                            <xsl:apply-templates>
                                <xsl:with-param name="section-path" select="$section-path" />
                            </xsl:apply-templates>
                            
                            <!--<xsl:text>]</xsl:text>-->
                            
                        </xsl:element>
                        
                    </xsl:when>
                    
                    <xsl:otherwise>
                        
                        <xsl:element name="div">
                            
                            <xsl:call-template name="process-string-variant">
                                <xsl:with-param name="name" select="$name" />
                            </xsl:call-template>
                        
                            <xsl:call-template name="process-attributes"/>
                            
                            <xsl:apply-templates select="node()[name()!='tx-options' and name()!='article']">
                                <xsl:with-param name="section-path" select="$section-path"/>
                            </xsl:apply-templates>
                            
                        </xsl:element>
                        
                    </xsl:otherwise>
                    
                </xsl:choose>
                    
            </xsl:when>
            
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="process-index">
        
        <xsl:element name="div">
            <xsl:attribute name="class" select="string('index')"/>
            
            <xsl:element name="dl">
                <xsl:attribute name="class" select="string('expandable')"/>
                
                <xsl:element name="dt">
                    <xsl:attribute name="class" select="string('collapsed')"/>
                    
                    <xsl:element name="div">
                        <xsl:attribute name="class" select="string('collapsed handle')"/>
                        
                        <xsl:element name="button">
                            <xsl:attribute name="type" select="string('button')"/>
                            
                            <xsl:text>full index of sections</xsl:text>
                            
                        </xsl:element>
                        
                    </xsl:element>
                    
                </xsl:element>
                
                <xsl:element name="dd">
                    
                    <xsl:element name="h2">
                        <xsl:attribute name="class" select="string('heading-implied')" />
                        <xsl:text>Full index of sections</xsl:text>
                    </xsl:element>
                    
                    <xsl:element name="ul">
                        
                        <xsl:for-each select="row">
                            
                            <xsl:element name="li">
                                
                                <xsl:element name="a">
                                    <xsl:attribute name="href" select="concat('#', generate-id(section-path))"/>
                                    
                                    <xsl:value-of select="normalize-space(section-path)"/>
                                    
                                </xsl:element>
                                
                                <xsl:choose>
                                    
                                    <xsl:when 
                                        test="
                                        details-of-change-new/change:div[@class='redline-moved']
                                        ">
                                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                        <xsl:element name="span">
                                            <xsl:attribute name="class" select="string('redline-insert')"/>
                                            <xsl:text>section moved</xsl:text>
                                        </xsl:element>
                                        
                                    </xsl:when>
                                    
                                    <xsl:when 
                                        test="
                                        details-of-change-old/change:div[@class='redline-moved']
                                        ">
                                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                        <xsl:element name="span">
                                            <xsl:attribute name="class" select="string('redline-delete')"/>
                                            <xsl:text>section moved</xsl:text>
                                        </xsl:element>
                                        
                                    </xsl:when>
                                    
                                    <xsl:when 
                                        test="
                                        details-of-change-new/change:div[@class='redline-merged']
                                        ">
                                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                        <xsl:element name="span">
                                            <xsl:attribute name="class" select="string('section-changed')"/>
                                            <xsl:text>section merged</xsl:text>
                                        </xsl:element>
                                        
                                    </xsl:when>
                                    
                                    <xsl:when 
                                        test="
                                        details-of-change-old/change:div[@class='redline-merged']
                                        ">
                                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                        <xsl:element name="span">
                                            <xsl:attribute name="class" select="string('section-changed')"/>
                                            <xsl:text>section merged</xsl:text>
                                        </xsl:element>
                                        
                                    </xsl:when>
                                    
                                    <xsl:when 
                                        test="
                                        details-of-change-new/change:div
                                        ">
                                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                        <xsl:element name="span">
                                            <xsl:attribute name="class" select="string('redline-insert')"/>
                                            <xsl:text>new section</xsl:text>
                                        </xsl:element>
                                        
                                    </xsl:when>
                                    
                                    <xsl:when 
                                        test="
                                        details-of-change-old/change:div
                                        ">
                                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                        <xsl:element name="span">
                                            <xsl:attribute name="class" select="string('redline-delete')"/>
                                            <xsl:text>section deleted</xsl:text>
                                        </xsl:element>
                                        
                                    </xsl:when>
                                    
                                    <xsl:when 
                                        test="
                                        details-of-change-new//(change:span|change:div|@change:*)
                                        or details-of-change-old//(change:span|change:div|@change:*)
                                        ">
                                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                                        <xsl:element name="span">
                                            <xsl:attribute name="class" select="string('section-changed')"/>
                                            <xsl:text>changes</xsl:text>
                                        </xsl:element>
                                        
                                    </xsl:when>
                                    
                                </xsl:choose>
                                
                            </xsl:element>
                            
                        </xsl:for-each>
                        
                    </xsl:element>
                    
                    <xsl:element name="button">
                        <xsl:attribute name="type" select="string('button')"/>
                        <xsl:attribute name="onclick" select="string('javascript:scrollTo(0,0);')"/>
                        <xsl:text>jump to top</xsl:text>
                    </xsl:element>
                    
                </xsl:element>
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
    
    <!--<xsl:template match="node()|@*" mode="reference-section"/>-->
    
    <xsl:template name="process-link-label">
        <xsl:param name="link" />
        
        <xsl:choose>
            
            <xsl:when test="$link/name() = 'reference-link' or $link/@ref-type='bibr'">
                <xsl:text>ref</xsl:text>
            </xsl:when>
            
            <xsl:when test="$link/name() = 'reference-link' and $link/@type='online'">
                <xsl:text>online-ref</xsl:text>
            </xsl:when>
            
            <xsl:when test="$link/name() = 'gloss-link' or $link/@ref-type='gloss'">
                <xsl:text>gls</xsl:text>
            </xsl:when>
            
            <xsl:when test="$link/name() = 'table-link' or $link/@ref-type='table'">
                <xsl:text>tbl</xsl:text>
            </xsl:when>
            
            <xsl:when test="$link/name() = 'figure-link' or $link/@ref-type='fig'">
                <xsl:text>fig</xsl:text>
            </xsl:when>
            
            <xsl:when test="$link/name() = 'image-link'">
                <xsl:text>img</xsl:text>
            </xsl:when>
            
            <xsl:when test="$link/name() = 'evidence-score-link'">
                <xsl:text>evd</xsl:text>
            </xsl:when>
            
            <xsl:when test="$link/name() = 'monograph-link'">
                <xsl:text>mono</xsl:text>
            </xsl:when>
            
            <xsl:when test="$link/name() = 'option-link'">
                <xsl:text>opt</xsl:text>
            </xsl:when>
            
            <xsl:when test="$link/name() = 'systematic-review-link'">
                <xsl:text>srv</xsl:text>
            </xsl:when>
            
            <xsl:when test="$link/@ref-type='patient-topic'">                
                <xsl:text>ptp</xsl:text>
            </xsl:when>
            <xsl:when test="$link/@ref-type='patient-treatment'">
                <xsl:text>ptx</xsl:text>
            </xsl:when>
            <xsl:when test="$link/@ref-type='patient-leaflet'">                
                <xsl:text>sum</xsl:text>
            </xsl:when>
            <xsl:when test="$link/@ref-type='elective-surgery'">
                <xsl:text>ele</xsl:text>
            </xsl:when>
            <xsl:when test="$link/@ref-type='static-content'">
                <xsl:text>sta</xsl:text>
            </xsl:when>
            <xsl:when test="$link/@ref-type='ext-link'">
                <xsl:text>url</xsl:text>
            </xsl:when>
            <xsl:when test="$link/name()='related-article'">
                <xsl:text>ext</xsl:text>
            </xsl:when>
            
            <xsl:when test="$link/name()='drug'">
                <xsl:text>drg</xsl:text>
            </xsl:when>
            
            <xsl:when test="$link/@ref-type">
                <xsl:value-of select="substring($link/@ref-type, 1, 3)"/>
            </xsl:when>
            
                <xsl:when test="$link/name()='alt-link-wrapper'">
                <xsl:value-of select="substring($link/name(), 1, 3)"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="substring($link/name(), 1, 3)"/>
            </xsl:otherwise>
            
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
                    
                    <xsl:element name="span">
                        <xsl:attribute name="class" select="string('float-label')" />
                    
                        <xsl:element name="span">
                            
                            <xsl:choose>
                                
                                <xsl:when test="ancestor::details-of-change-old">
                                    <xsl:attribute name="class" select="string('redline-delete')"/>        
                                </xsl:when>
                                
                                <xsl:when test="ancestor::details-of-change-new">
                                    <xsl:attribute name="class" select="string('redline-insert')"/>
                                </xsl:when>
                                
                            </xsl:choose>
                            
                            <xsl:if test="contains($markup-format, 'pretty')">
                                <xsl:text disable-output-escaping="yes">[@</xsl:text>
                            </xsl:if>
                            
                            <xsl:if test="$markup-format='escaped'">
                                <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                            </xsl:if>
                            
                            
                            <xsl:value-of select="$name"/>
                            <xsl:text disable-output-escaping="yes">="</xsl:text>
                            <xsl:value-of select="."/>
                            <xsl:text disable-output-escaping="yes">"</xsl:text>
                            
                            <xsl:if test="contains($markup-format, 'pretty')">
                                <xsl:text disable-output-escaping="yes">]</xsl:text>
                            </xsl:if>
                            
                        </xsl:element>
                        
                    </xsl:element>
                    
                    <xsl:if test="contains($markup-format, 'pretty')">
                        <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                    </xsl:if>
                    
                </xsl:when>
                
                <xsl:otherwise>
                    
                    <xsl:choose>
                        
                        <xsl:when test="$markup-format='escaped'">
                            
                            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                            <xsl:value-of select="$name"/>
                            <xsl:text disable-output-escaping="yes">="</xsl:text>
                            <xsl:value-of select="."/>
                            <xsl:text disable-output-escaping="yes">"</xsl:text>
                            
                        </xsl:when>
                        
                        <xsl:when 
                            test="
                            (parent::element()[name()='tx-option'] and ($name='timeframe' or $name='tx-line'))
                            or (parent::element()[name()='regimen'] and ($name='tier'))
                            or (parent::element()[name()='component'] and ($name='modifier'))
                            
                            
                            or (parent::element()[name()='intervention'] and ($name='efficacy'))
                            
                            or (parent::element()[name()='evidence-appraisal'] 
                            and (
                            $name='best-evidence' 
                            or $name='consistency' 
                            or $name='directness'
                            or $name='effect-size'
                            or $name='evidence-quality'
                            or $name='methodlogical-quality'
                            )
                            )
                            
                            or (parent::element()[name()='reference-studies'] 
                            and (
                            $name='participants' 
                            or $name='study-count' 
                            )
                            )
                            
                            or (parent::element()[name()='reference-original'] 
                            and (
                            $name='design' 
                            or $name='number-of-arms' 
                            )
                            )
                            
                            or (parent::element()[name()='reference-related'] and ($name='type'))
                            
                            or (parent::element()[name()='population'] 
                            and (
                            $name='analysis' 
                            or $name='trials-identified' 
                            )
                            )
                            
                            or (parent::element()[name()='absolute-results'] and ($name='reporting'))
                            
                            or (parent::element()[name()='favour'] and ($name='evaluated-effect'))
                            ">
                            
                            <xsl:element name="span">
                                <xsl:attribute name="class" select="string('float-label')"/>
                                
                                <xsl:text disable-output-escaping="yes">[@</xsl:text>
                                
                                <xsl:value-of select="$name"/>
                                <xsl:text disable-output-escaping="yes">="</xsl:text>
                                <xsl:value-of select="."/>
                                <xsl:text disable-output-escaping="yes">"</xsl:text>
                                
                                <xsl:text disable-output-escaping="yes">]</xsl:text>
                                
                            </xsl:element>
                            
                        </xsl:when>
                        
                    </xsl:choose>
                    
                </xsl:otherwise>
                
            </xsl:choose>
            
        </xsl:for-each>
        
    </xsl:template>
    
</xsl:stylesheet>

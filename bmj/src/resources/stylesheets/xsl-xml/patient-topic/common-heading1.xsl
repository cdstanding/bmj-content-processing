<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:output method="xml" indent="yes" name="xml" encoding="UTF-8"/>
    <xsl:param name="resourcename"/>
    <xsl:param name="maintopicname"/>
    <xsl:param name="outputdir"/>
    
    <xsl:key name="HeadingType" match="heading1" use="generate-id(ancestor::topic-element/@type)"/>
    
    <!--     set up keys to select components-->
    <!--     paras and lists after heading1s indexed by preceding heading1-->     
    <xsl:key name="NormalPara" match="p[not(child::heading1)]
        |*[parent::p[child::heading1] and not(parent::p[child::heading1] and preceding-sibling::heading1) and not(name()='heading1')]
        |text()[parent::p[child::heading1] and not(parent::p[child::heading1] and preceding-sibling::heading1) ]" 
        use="generate-id((preceding::heading1)[last()])"/>

    <xsl:key name="NormalParaTopicElement" match="p[not(child::heading1)]
        |*[parent::p[child::heading1] and not(parent::p[child::heading1] and preceding-sibling::heading1) and not(name()='heading1')]
        |text()[parent::p[child::heading1] and not(parent::p[child::heading1] and preceding-sibling::heading1) ]"
        use="concat(generate-id(ancestor::topic-element), generate-id((preceding::heading1)[last()]))"/>
    

    <!--     'odd' text items that are following heading1s and yet whose parents are paras that contain heading1-->
    <!--     indexed by preceding heading1 -->     
    
    <xsl:key name="OddPara" 
        match="text()[parent::p[child::heading1] and preceding-sibling::heading1]
        |*[parent::p[child::heading1] and preceding-sibling::heading1 and not(name()='heading1')]"
        use="generate-id((preceding::heading1)[last()])"/>
    
    
    <xsl:key name="ParaBefore1stHeading1" 
        match="p[parent::body-text and not(preceding-sibling::p[child::heading1] or child::heading1)]" 
        use="generate-id((parent::body-text)[last()])"/>
    
    <xsl:key name="Before1stHeading1" 
        match="*[parent::p[parent::body-text and child::heading1 and not(preceding-sibling::p[child::heading1])] and not(preceding-sibling::heading1 or name()='heading1') ]" 
        use="generate-id((ancestor::body-text)[last()])"/>
    
    <xsl:key name="WholeSection" 
        match="p[parent::body-text]" 
        use="generate-id((parent::body-text)[last()])"/>

    <!--template to match item note mode = keep is so the text() match is kept-->
    <xsl:template match="item" mode="para">
        <xsl:element name="list-item">
                <xsl:apply-templates mode="para"/>    
        </xsl:element>
    </xsl:template>
    
    <!--template to process list-->
    <xsl:template match="list" mode="para">
        <xsl:element name="list">
            <xsl:apply-templates select="item" mode="#current"/>
        </xsl:element>
    </xsl:template>
    <!--template to keep text()     -->
    <xsl:template match="text()" mode="keep">
        <xsl:copy-of select="."/>
    </xsl:template>
    <!--chnage text() template to suppress text()-->
    <xsl:template match="text()"/>
    
    <xsl:template match="tbody|thead|drug|headline|heading2|heading3" mode="para">
        <xsl:element name="{name()}">
            <xsl:apply-templates mode="para"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="th|tr|td" mode="para">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates mode="para"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="p" mode="para">
        <xsl:element name="{name()}">
            <xsl:apply-templates mode="para"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*[name()!='xmlns:xi' ] ">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- PROCESS TABLE -->
    <xsl:template match="table" mode="para">
        <xsl:element name="table-wrap">
            <xsl:element name="table">
                <xsl:for-each select="@*">
                    <xsl:attribute name="{name()}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:for-each>
                <xsl:apply-templates mode="para"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- PROCESS LINKS HERE!!!  -->
    <xsl:template match="uri-link" mode="para">
        <xsl:element name="ext-link">
            <xsl:attribute name="ext-link-type">uri</xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="reference-link" mode="para">
        <xsl:element name="xref">
            <xsl:attribute name="ref-type">bibr</xsl:attribute>
            <xsl:attribute name="rid"><xsl:value-of select="@target"/></xsl:attribute>
            <xsl:value-of select="."></xsl:value-of>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="gloss-link" mode="para">
        <xsl:element name="xref">
            <xsl:attribute name="ref-type">gloss</xsl:attribute>
            <xsl:attribute name="rid"><xsl:value-of select="@target"/></xsl:attribute>
            <xsl:value-of select="."></xsl:value-of>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="image-link" mode="para">
                
        <xsl:variable name="targetfile1"><xsl:value-of select="replace(@target, '^\.\./images/(.+?)(_default)?\.(.+?)$' , '$1')"/></xsl:variable>
        <xsl:variable name="targetfile">
            <xsl:text>../patient-figure/fig-</xsl:text>
            <xsl:if test="not($maintopicname = $resourcename)">
                <xsl:value-of select="$resourcename"/>
                <xsl:text>-</xsl:text>                
            </xsl:if>
            <xsl:value-of select="replace($targetfile1, '^(.+?)(_default)$', '$1')"/>
            <xsl:text>.xml</xsl:text>
        </xsl:variable>

        <xsl:element name="xref">
            <xsl:attribute name="ref-type">fig</xsl:attribute>
            <xsl:attribute name="rid">
                <xsl:value-of select="$targetfile"/>
                <!-- 
                <xsl:choose>
                    <xsl:when test="ancestor::patient-topic">
                        <xsl:value-of select="replace($targetfile1, '^(.+?)(_default)?\.(.+?)$', '../patient-figure/fig-topic-$1.$3')"/>
                    </xsl:when>
                    <xsl:when test="ancestor::treatment">
                        <xsl:value-of select="replace($targetfile1, '^(.+?)(_default)?\.(.+?)$', '../patient-figure/fig-tx-$1.$3')"/>
                    </xsl:when>            
                    <xsl:when test="ancestor::sidebar">
                        <xsl:value-of select="replace($targetfile1, '^(.+?)(_default)?\.(.+?)$', '../patient-figure/fig-$1.$3')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace($targetfile1, '^(.+?)(_default)?\.(.+?)$', '../patient-figure/fig-$1.$3')"/>
                    </xsl:otherwise>
                </xsl:choose>
                -->
            </xsl:attribute>
            <xsl:value-of select="."></xsl:value-of>
        </xsl:element>
     
        <xsl:choose>
            <xsl:when test="ancestor::patient-topic">
                <xsl:call-template name="create-figure">
                    <xsl:with-param name="articleType">topic-</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="ancestor::treatment">
                <xsl:call-template name="create-figure">
                    <xsl:with-param name="articleType">tx-</xsl:with-param>
                </xsl:call-template>
            </xsl:when>            
            <xsl:when test="ancestor::sidebar">
                <xsl:call-template name="create-figure">
                    <xsl:with-param name="articleType"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="create-figure">
                    <xsl:with-param name="articleType"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    
        
   </xsl:template>
   
     <xsl:template match="sidebar-link|treatment-link|internal-link" mode="remove">
        <xsl:comment><xsl:value-of select="name()"/> target="<xsl:value-of select="@target"/>"</xsl:comment>
        <xsl:value-of select="."></xsl:value-of>
        <xsl:comment><xsl:value-of select="name()"/></xsl:comment>
    </xsl:template>
    
    <xsl:template match="sidebar-link|treatment-link|internal-link" mode="para">
        
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates mode="para"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="strong" mode="para">
        <xsl:choose>
            <xsl:when test="parent::th">
                <xsl:apply-templates mode="para"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="bold">
                    <xsl:apply-templates mode="para"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="em" mode="para">
        <xsl:element name="italic">
            <xsl:apply-templates mode="para"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="introduction">
        <xsl:element name="p">
            <xsl:apply-templates mode="para"/>
        </xsl:element>
    </xsl:template>
    
    <!--template to add title-->
    <xsl:template match="title|heading1" mode="head1">
        <xsl:element name="title">
            <xsl:choose>
                <xsl:when test="following-sibling::headline">
                    <xsl:value-of select="following-sibling::headline"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="keep"/>                         
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

<!-- 
    <xsl:template name="process-images">
        <xsl:param name="articleType"/>
        <xsl:for-each select="//image-link"> 
            <xsl:variable name="targetfile1"><xsl:value-of select="replace(@target, '^\.\./images/(.+?)(_default)?\.(.+?)$' , '$1')"/></xsl:variable>
            <xsl:variable name="targetfile"><xsl:text>fig</xsl:text>-<xsl:value-of select="$articleType"/>-<xsl:value-of select="replace($targetfile1, '^(.+?)(_default)$', '$1')"/></xsl:variable>
        </xsl:for-each>
    </xsl:template>
-->  
    <xsl:template name="create-figure">
         
        <xsl:param name="articleType"/>
        
        
        <xsl:if test="not(@target = preceding::image-link/@target)">
            <xsl:variable name="targetfile1"><xsl:value-of select="replace(@target, '^\.\./images/(.+?)(_default)?\.(.+?)$' , '$1')"/></xsl:variable>
            <xsl:variable name="targetfile">
                <xsl:text>fig-</xsl:text>
                <xsl:if test="not($maintopicname = $resourcename)">
                    <xsl:value-of select="$resourcename"/>
                    <xsl:text>-</xsl:text>                
                </xsl:if>
                <xsl:value-of select="replace($targetfile1, '^(.+?)(_default)$', '$1')"/>
            </xsl:variable>
            <!-- 
            <xsl:variable name="targetfile"><xsl:text>fig-</xsl:text><xsl:value-of select="$articleType"/><xsl:value-of select="replace($targetfile1, '^(.+?)(_default)$', '$1')"/></xsl:variable>
            -->
            <xsl:variable name="current-file-name"><xsl:value-of select="concat($targetfile,'.xml')"/></xsl:variable>
            <xsl:variable name="filename">file:///<xsl:value-of select="translate($outputdir,'\','/')"/>/patient-figure/<xsl:value-of select="$current-file-name"/></xsl:variable>
            
            <xsl:result-document href="{$filename}" format="xml">
                <xsl:element name="figure">
                    <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
                    <xsl:attribute name="xsi:noNamespaceSchemaLocation">
                        <xsl:text>../../schemas/bmjk-patient-figures.xsd</xsl:text>
                    </xsl:attribute>
                    <xsl:element name="image-link">
                        <xsl:attribute name="target">
                            <xsl:value-of select="replace(@target, '^\.\./images/(.+?)(_default)?\.(.+?)$' , '../images/$1.$3')"/> </xsl:attribute>
                    </xsl:element>
                    <xsl:element name="caption"><xsl:value-of select="@caption"/></xsl:element>
                    <xsl:element name="source"/>
                </xsl:element>
            </xsl:result-document>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>

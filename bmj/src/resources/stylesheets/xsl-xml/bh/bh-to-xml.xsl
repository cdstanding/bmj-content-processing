<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"   
    exclude-result-prefixes="legacytag"    
    version="2.0">
    
    
    <xsl:param name="topresourcename"/>
    <xsl:param name="metapath"/>
    <xsl:param name="rootdocdir"/>
    <xsl:param name="path"/>
    <xsl:param name="outputpath"/>
    <xsl:param name="inputpath"/>
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:output method="xml" indent="yes" name="xmlOutput" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="metadoc" select="document(translate(concat($metapath, $rootdocdir , $topresourcename),'\','/'))"></xsl:variable>

    <xsl:variable name="articleid">
       <xsl:value-of select="$metadoc//abstract-id"/>
    </xsl:variable>    

    <xsl:variable name="articleversion">
        <xsl:value-of select="$metadoc//version"/>
    </xsl:variable>    
	    
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
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="article">
        <xsl:element name="article">
            <xsl:attribute name="article-type"><xsl:value-of select="@article-type"/></xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="$articleid"/></xsl:attribute>            
            <xsl:attribute name="version"><xsl:value-of select="$articleversion"/></xsl:attribute>
            <xsl:apply-templates/>
            <xsl:if test="//xi:include">
                <xsl:call-template name="add-treatments"/>
            </xsl:if>
        </xsl:element>
    </xsl:template>


    <xsl:template match="article-meta">
        <xsl:element name="article-meta">
            <xsl:apply-templates select="article-categories" />
            <xsl:apply-templates select="title-group" />
            <xsl:apply-templates select="related-article" />
            <xsl:apply-templates select="kwd-group" />
            <xsl:choose>
                <xsl:when test="custom-meta-group">
                    <xsl:apply-templates select="custom-meta-group" />
                </xsl:when>
                <xsl:otherwise>
                    <!-- add metadata element if missing -->
                    <xsl:element name="custom-meta-group"></xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    

    <xsl:template match="article" mode="included-article">
        <xsl:param name="id"/>
        <xsl:param name="version"/>
        <xsl:element name="article">
            <xsl:attribute name="article-type"><xsl:value-of select="@article-type"/></xsl:attribute>
            <xsl:attribute name="id" select="$id"/>
            <xsl:attribute name="version" select="$version"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="add-treatments">
        <xsl:element name="article-treatments">
            <xsl:for-each select="//xi:include[not(@href = preceding::xi:include/@href)]">
                <xsl:if test="starts-with(@href, '../patient-treatment/')">
                    <xsl:variable name="name"><xsl:value-of select="replace(@href, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.$3')"/></xsl:variable>
                    <xsl:variable name="includepath">file://localhost/<xsl:value-of select="translate($inputpath,'\','/')"/>/<xsl:value-of select="$name"/></xsl:variable>
                    <xsl:variable name="treatmentfile" select="document($includepath)"/>
                    <!-- read meta file and get version number -->
                    <xsl:variable name="metadoc" select="document(translate(concat($metapath, replace(@href,'\.\./','/')),'\','/'))"></xsl:variable>
                    <xsl:variable name="version" select="$metadoc//version"/>
                    <xsl:variable name="treatmentAbstractId"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/patient-treatment/', replace($name, '.xml', '')))"/></xsl:variable>
                    <xsl:apply-templates select="$treatmentfile/*" mode="included-article">
                        <xsl:with-param name="id" select="$treatmentAbstractId"/>
                        <xsl:with-param name="version" select="$version"/>
                    </xsl:apply-templates>                    
                </xsl:if>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xref[@ref-type='patient-topic']">
        <xsl:element name="xref">
            <xsl:attribute name="ref-type"><xsl:value-of select="@ref-type"/></xsl:attribute>
            <xsl:variable name="topicname"><xsl:value-of select="replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>
            <xsl:choose>
                <xsl:when test="$topresourcename = $topicname">
                    <xsl:attribute name="rid"><xsl:value-of select="$articleid"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="rid"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/patient-topic/', replace($topicname, '.xml', '')))"/></xsl:attribute>				
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
            	<xsl:when test="starts-with(@section, 'further-information/sidebar-')">
       	            <xsl:attribute name="section"><xsl:value-of select="replace(@section, 'sidebar-', '')"/></xsl:attribute>
            	</xsl:when>
            	<xsl:otherwise>
       	            <xsl:attribute name="section"><xsl:value-of select="replace(@section, '_', '')"/></xsl:attribute>
            	</xsl:otherwise>
            </xsl:choose>

            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xref[@ref-type='static-content']">
        <xsl:variable name="staticcontentname"><xsl:value-of select="replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>
        <xsl:element name="xref">
            <xsl:attribute name="ref-type"><xsl:value-of select="@ref-type"/></xsl:attribute>
           	<xsl:attribute name="rid"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/patient-static-content/', replace($staticcontentname, '.xml', '')))"/></xsl:attribute>				
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xref[@ref-type='elective-surgery']">
        <xsl:variable name="surgeryname"><xsl:value-of select="replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>
        <xsl:element name="xref">
            <xsl:attribute name="ref-type"><xsl:value-of select="@ref-type"/></xsl:attribute>
           	<xsl:attribute name="rid"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/patient-elective-surgery/', replace($surgeryname, '.xml', '')))"/></xsl:attribute>				
            <xsl:attribute name="section"><xsl:value-of select="@section"/></xsl:attribute>           	
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xref[@ref-type='patient-summary']">
        <xsl:variable name="summaryname"><xsl:value-of select="replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>
        <xsl:element name="xref">
            <xsl:attribute name="ref-type"><xsl:value-of select="@ref-type"/></xsl:attribute>
           	<xsl:attribute name="rid"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/patient-summary/', replace($summaryname, '.xml', '')))"/></xsl:attribute>				
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xref[@ref-type='patient-news']">
        <xsl:variable name="newsname"><xsl:value-of select="replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>
        <xsl:element name="xref">
            <xsl:attribute name="ref-type"><xsl:value-of select="@ref-type"/></xsl:attribute>
           	<xsl:attribute name="rid"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/bh-patient-news/', replace($newsname, '.xml', '')))"/></xsl:attribute>				
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
                
    <xsl:template match="custom-meta-group">

        <xsl:element name="custom-meta-group">
            
            <!-- add rating score id for CR -->
            <xsl:if test=".//custom-meta/meta-name[. = 'rating-score']">

                <!-- get value of the rating score -->
                <xsl:variable name="rate-score-value"><xsl:value-of select=".//custom-meta/meta-name[. = 'rating-score']/following-sibling::meta-value"/></xsl:variable>

                <xsl:choose>
                    <xsl:when test="$rate-score-value = 'treatments-that-work'">
                        <xsl:element name="custom-meta">
                            <xsl:element name="meta-name">rating-score-id</xsl:element>
                            <xsl:element name="meta-value">1</xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$rate-score-value = 'treatments-that-are-likely-to-work'">
                        <xsl:element name="custom-meta">
                            <xsl:element name="meta-name">rating-score-id</xsl:element>
                            <xsl:element name="meta-value">2</xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$rate-score-value = 'treatments-that-work-but-whose-harms-may-outweigh-benefits'">
                        <xsl:element name="custom-meta">
                            <xsl:element name="meta-name">rating-score-id</xsl:element>
                            <xsl:element name="meta-value">3</xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$rate-score-value = 'treatments-that-need-further-study'">
                        <xsl:element name="custom-meta">
                            <xsl:element name="meta-name">rating-score-id</xsl:element>
                            <xsl:element name="meta-value">4</xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$rate-score-value = 'treatments-that-are-unlikely-to-work'">
                        <xsl:element name="custom-meta">
                            <xsl:element name="meta-name">rating-score-id</xsl:element>
                            <xsl:element name="meta-value">5</xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$rate-score-value = 'treatments-that-are-likely-to-be-ineffective-or-harmful'">
                        <xsl:element name="custom-meta">
                            <xsl:element name="meta-name">rating-score-id</xsl:element>
                            <xsl:element name="meta-value">6</xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$rate-score-value = 'other-treatments'">
                        <xsl:element name="custom-meta">
                            <xsl:element name="meta-name">rating-score-id</xsl:element>
                            <xsl:element name="meta-value">7</xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$rate-score-value = 'usual-treatments'">
                        <xsl:element name="custom-meta">
                            <xsl:element name="meta-name">rating-score-id</xsl:element>
                            <xsl:element name="meta-value">8</xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$rate-score-value = ''">
                        <xsl:element name="custom-meta">
                            <xsl:element name="meta-name">rating-score-id</xsl:element>
                            <xsl:element name="meta-value"></xsl:element>
                        </xsl:element>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
            
            <xsl:apply-templates/>
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="sec[parent::further-information] | group">
    	<xsl:element name="{name()}">
    		<xsl:if test="@sec-type">
	    		<xsl:attribute name="sec-type"><xsl:value-of select="@sec-type"/></xsl:attribute>
    		</xsl:if>
    		<xsl:if test="@id">
	            <xsl:choose>
	            	<xsl:when test="starts-with(@id, 'sidebar-')">
			    		<xsl:attribute name="id"><xsl:value-of select="replace(@id, 'sidebar-', '')"/></xsl:attribute>
	            	</xsl:when>
	            	<xsl:otherwise>
			    		<xsl:attribute name="id"><xsl:value-of select="replace(@id, '_', '')"/></xsl:attribute>
	            	</xsl:otherwise>
	            </xsl:choose>    		
    		</xsl:if>
    		<xsl:apply-templates/>
    	</xsl:element>
    </xsl:template>

    <!-- removed empty elements -->
    <xsl:template match="p[not(element()) and not(text()) and not(@*)]">
        <!-- do nothing -->
    </xsl:template>
    
    <xsl:template match="sec[not(element()) and not(text()) and not(@*)]">
        <!-- do nothing -->
    </xsl:template>
    
    <xsl:template match="further-information[not(element()) and not(text()) and not(@*)]">
        <!-- do nothing -->
    </xsl:template>
    
    
    
    <xsl:template 
        match="
        node()
        [preceding-sibling::processing-instruction()[1]
        [name() = 'serna-redline-start' 
        and (. = '400 ' or . = '0 ' or . = '1000 ')]]
        [following-sibling::processing-instruction()[1]
        [name() = 'serna-redline-end']]
        ">
        
        <xsl:choose>
            
            <xsl:when test="preceding-sibling::processing-instruction()[1][. = '1000 ']">
                <xsl:element name="redline-insert">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            
            <xsl:when test="preceding-sibling::processing-instruction()[1][. = '400 ']">
                <xsl:element name="redline-delete">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            
            <xsl:when test="preceding-sibling::processing-instruction()[1][. = '0 ' ]">
                <xsl:element name="redline-comment">
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:when>
            
        </xsl:choose>
        
    </xsl:template>
    
    
    <xsl:template match="pi-comment">
        
        <xsl:choose>
            
            <xsl:when test="@type='q-to-pr'">
                <xsl:element name="comment-q-to-pr">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            
            <xsl:when test="@type='q-to-a'">
                <xsl:element name="comment-q-to-a">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            
            <xsl:when test="@type='q-to-ed'">
                <xsl:element name="comment-q-to-ed">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            
            <xsl:when test="@type='q-to-teched'">
                <xsl:element name="comment-q-to-teched">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            
            <xsl:when test="@type='q-to-prod'">
                <xsl:element name="comment-q-to-prod">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            
            <xsl:otherwise/>
            
        </xsl:choose>
        
    </xsl:template>
    
    
    
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

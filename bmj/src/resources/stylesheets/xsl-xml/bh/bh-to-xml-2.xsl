<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
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
    
    <xsl:param name="lang"/>
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:output method="xml" indent="yes" name="xmlOutput" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>

      <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- add dates -->
    <xsl:template match="custom-meta-group[not(ancestor::article-treatments)]">
        <xsl:element name="custom-meta-group">
            <xsl:element name="custom-meta">
                <xsl:element name="meta-name">amended-date</xsl:element>
                <xsl:element name="meta-value"><xsl:value-of select="$amended-date"/></xsl:element>
            </xsl:element>
            <xsl:element name="custom-meta">
                <xsl:element name="meta-name">amended-date-iso</xsl:element>
                <xsl:element name="meta-value"><xsl:value-of select="$date-amended-iso"/></xsl:element>
            </xsl:element>
            <xsl:element name="custom-meta">
                <xsl:element name="meta-name">last-updated</xsl:element>
                <xsl:element name="meta-value"><xsl:value-of select="$last-update"/></xsl:element>
            </xsl:element>
            <xsl:element name="custom-meta">
                <xsl:element name="meta-name">last-updated-iso</xsl:element>
                <xsl:element name="meta-value"><xsl:value-of select="$date-updated-iso"/></xsl:element>
            </xsl:element>
            <xsl:element name="custom-meta">
                <xsl:element name="meta-name">export-date</xsl:element>
                <xsl:element name="meta-value"><xsl:value-of select="$published-date"/></xsl:element>
            </xsl:element>
            <xsl:element name="custom-meta">
                <xsl:element name="meta-name">export-date-iso</xsl:element>
                <xsl:element name="meta-value"><xsl:value-of select="$todays-date-iso"/></xsl:element>
            </xsl:element>
            <xsl:element name="custom-meta">
                <xsl:element name="meta-name">last-reviewed</xsl:element>
                <xsl:element name="meta-value"><xsl:value-of select="$last-reviewed"/></xsl:element>
            </xsl:element>
            <xsl:element name="custom-meta">
                <xsl:element name="meta-name">last-reviewed-iso</xsl:element>
                <xsl:element name="meta-value"><xsl:value-of select="$last-reviewed-iso"/></xsl:element>
            </xsl:element>
            <xsl:element name="custom-meta">
                <xsl:element name="meta-name">embargo-date</xsl:element>
                <xsl:element name="meta-value"><xsl:value-of select="$embargo-date"/></xsl:element>
            </xsl:element>
            <xsl:element name="custom-meta">
                <xsl:element name="meta-name">embargo-date-iso</xsl:element>
                <xsl:element name="meta-value"><xsl:value-of select="$embargo-date-iso"/></xsl:element>
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="article[not(parent::article-treatments)]">
        <xsl:element name="article">
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:attribute name="xsi:noNamespaceSchemaLocation">
                <xsl:text>http://schema.bmj.com/delivery/sycamore/bmj-best-health-article.xsd</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="article-type"><xsl:value-of select="@article-type"/></xsl:attribute>
            <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
            <xsl:attribute name="version"><xsl:value-of select="@version"/></xsl:attribute>

            <xsl:apply-templates/>
        
            <xsl:element name="article-figures">
                <xsl:call-template name="add-figures"/>
            </xsl:element>
            
            <xsl:element name="article-glossaries">
                <xsl:call-template name="add-glossaries"/>
            </xsl:element>
                
            <xsl:element name="article-references">
                <xsl:call-template name="add-references"/>
            </xsl:element>

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
    
    
    
    <xsl:template name="add-figures">
        <xsl:for-each select="//xref[@ref-type='fig' and not(@rid = preceding::xref/@rid)]">
            <xsl:variable name="figuredoc" select="document(concat($path, '/patient-figure/', replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')))"></xsl:variable>
            <xsl:variable name="figurename"><xsl:value-of select="replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>
            <xsl:element name="figure">
                <xsl:attribute name="id"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/patient-figure/', replace($figurename, '.xml', '')))"/></xsl:attribute>
                <xsl:attribute name="image"><xsl:value-of select="replace($figuredoc/figure/image-link/@target, '^\.\./(.+?)/(.+?)?\.(.+?)$', 'images/$2.$3')"/></xsl:attribute>
                <xsl:element name="caption">
                    <xsl:element name="p">
                        <xsl:value-of select="$figuredoc/figure/caption"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="xref[@ref-type='fig']">
        <xsl:variable name="figurename"><xsl:value-of select="replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>
        <xsl:element name="xref">
            <xsl:attribute name="ref-type"><xsl:value-of select="@ref-type"/></xsl:attribute>
            <xsl:attribute name="rid"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/patient-figure/', replace($figurename, '.xml', '')))"/></xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template name="add-glossaries">
            <xsl:for-each select="//xref[@ref-type='gloss' and not(@rid = preceding::xref/@rid)]">
                <xsl:variable name="glossesdoc" select="document(concat($path, '/glosses/', replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.$3')))"></xsl:variable>
                <xsl:variable name="glossname"><xsl:value-of select="replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>
                <xsl:element name="gloss">
                    <xsl:attribute name="id"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/glosses/', replace($glossname, '.xml', '')))"/></xsl:attribute>
                    <xsl:element name="term"><xsl:value-of select="$glossesdoc/gloss/term"/></xsl:element>
                    <xsl:element name="definition">
                        <xsl:element name="p">
                            <xsl:value-of select="$glossesdoc/gloss/definition"></xsl:value-of>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
    </xsl:template>

    <xsl:template match="xref[@ref-type='gloss']">
        <xsl:variable name="glossname"><xsl:value-of select="replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>
        <xsl:element name="xref">
            <xsl:attribute name="ref-type"><xsl:value-of select="@ref-type"/></xsl:attribute>
            <xsl:attribute name="rid"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/glosses/', replace($glossname, '.xml', '')))"/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    

    <xsl:template name="add-references">
            <xsl:for-each select="//xref[@ref-type='bibr' and not(@rid = preceding::xref/@rid)]">
                <xsl:variable name="referencedoc" select="document(concat($path, '/reference/', replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.$3')))"></xsl:variable>
                <xsl:variable name="referencename"><xsl:value-of select="replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>                
                <xsl:element name="reference">
                    <xsl:attribute name="id"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/reference/', replace($referencename, '.xml', '')))"/></xsl:attribute>
                    <xsl:if test="$referencedoc//unique-id[@source='medline']!=''">
                        <xsl:attribute name="pubmed-id">
                            <xsl:value-of select="$referencedoc//unique-id[@source='medline']/node()"></xsl:value-of>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:element name="primary-authors"><xsl:value-of select="$referencedoc/reference/patient-citation/primary-authors"/></xsl:element>
                    <xsl:element name="primary-title"><xsl:value-of select="$referencedoc/reference/patient-citation/primary-title"/></xsl:element>
                    <xsl:element name="source"><xsl:value-of select="$referencedoc/reference/patient-citation/source"/></xsl:element>
                </xsl:element>
            </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="xref[@ref-type='bibr']">
        <xsl:variable name="referencename"><xsl:value-of select="replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>                    
        <xsl:element name="xref">
            <xsl:attribute name="ref-type"><xsl:value-of select="@ref-type"/></xsl:attribute>
            <xsl:attribute name="rid"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/reference/', replace($referencename, '.xml', '')))"/></xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xref[@ref-type='patient-treatment']">
        <xsl:variable name="treatmentname"><xsl:value-of select="replace(@rid, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>
        <xsl:variable name="treatmentid"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/patient-treatment/', replace($treatmentname, '.xml', '')))"/></xsl:variable>
        <xsl:element name="xref">
            <xsl:attribute name="ref-type"><xsl:value-of select="@ref-type"/></xsl:attribute>
            <xsl:attribute name="rid"><xsl:value-of select="$treatmentid"/></xsl:attribute>
            <xsl:choose>
                <xsl:when test="//article[@article-type='patient-treatment']/@id = $treatmentid">
                    <xsl:attribute name="topic-id"><xsl:value-of select="//article[@article-type='patient-topic']/@id"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="topic-id"><xsl:value-of select="legacytag:getTopicForTreatment($treatmentid, 'en-gb')"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:attribute name="section"><xsl:value-of select="replace(@section, '_', '')"/></xsl:attribute>			
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!-- turn systematic review link into a list of releated patient topics, needed for news, surgeries and summaries -->
    <xsl:template match="article-meta">
        <xsl:element name="article-meta">
            <xsl:if test="/article[@article-type!='patient-topic']">
                    <xsl:for-each select="/article/front/article-meta/related-article">
						<xsl:choose>
							<xsl:when test="@related-article-type='systematic-review'">
								<!-- look up file name and title of related pt -->
								<xsl:value-of select="legacytag:getAbstractTopicsForSR(./@href, $lang)" disable-output-escaping="yes"/>
							</xsl:when>
							<xsl:when test="@related-article-type='patient-topic'">
								<!-- look up file name and title of related pt -->
								<xsl:value-of select="legacytag:getPatientTopicRelatedArticle(./@href, $lang)" disable-output-escaping="yes"/>						 
							</xsl:when>							
						</xsl:choose>
                    </xsl:for-each>
            </xsl:if>
            
            <!-- 2011-09-20-KM: added to include sr link for new ce bh summary link -->
            <xsl:for-each select="related-article[@related-article-type='systematic-review']">
                <xsl:variable name="target" select="@href"/>
                <xsl:processing-instruction name="related-systematic-review" select="replace($target, '^.*?[^/^\\]+(\d\d\d\d)\.[^/^\\]+$', '$1.xml')"/>
            </xsl:for-each>
            
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="notes|xi:include|floats-group|related-article">
        <!-- elements to remove -->        
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
    
    <xsl:template match="related-article[@related-article-type = 'option']">
		<xsl:variable name="target" select="@href"/>
		
		<!-- get sr id -->
		<xsl:variable name="srid" select="legacytag:getSystematicReviewId($target)"/>

		<!-- get option id -->
		<xsl:variable name="optionid">
			<xsl:choose>
				<!-- old option file name '../options/_op0203_I5.xml' -->
				<xsl:when test="contains($target,'_op')">
					<xsl:text>I</xsl:text>
					<xsl:value-of select="substring-before((substring-after($target, 'I')),'.xml')"/>
				</xsl:when>
				<!-- new option file name '../options/option-1194864898395.xml' -->
				<xsl:otherwise>
					<xsl:text>I</xsl:text>
					<xsl:value-of select="substring-before((substring-after($target, '-')),'.xml')"/>
				</xsl:otherwise>
			</xsl:choose>	
		</xsl:variable>
		
		<xsl:element name="related-article">
			<xsl:attribute name="related-article-type" select="'option'"/>
			<xsl:attribute name="href" select="concat($srid, '.xml')"/>
			<xsl:attribute name="section" select="$optionid"/>						
		</xsl:element>
						
    </xsl:template>
    
</xsl:stylesheet>

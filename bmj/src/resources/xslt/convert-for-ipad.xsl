<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:nlm="http://schema.highwire.org/NLM/Journal"
    exclude-result-prefixes="nlm">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:param name="bmj-doi"/>
    <xsl:param name="full-doi"/>
    <xsl:param name="temp-article-path"/>
    <xsl:param name="toc-path"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!--Suppress-->
    <xsl:template match="//fig[@fig-type='lead']"/>
    <xsl:template match="notes[@notes-type='data-supplement']"/>
    <xsl:template match="subj-group[@subj-group-type='hwp-journal-coll']"/>
    <xsl:template match="comment()"/>
    
    <!-- Output normal graphics where they appear in document -->
    <xsl:template match="graphic[parent::fig[not(@fig-type='lead')]]">
        <graphic>
            <xsl:attribute name="alt-version">
                <xsl:text>no</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="position">
                <xsl:text>float</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="xlink:href">
                <xsl:text>assets/</xsl:text>
                <xsl:value-of select="@xlink:href"/>
                <xsl:text>.jpg</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </graphic>
    </xsl:template>
    
    <!-- Figure template for 'lead' figures if present in the document-->
    <xsl:template name="output-fig">
        <xsl:for-each select="//fig[@fig-type='lead']">
            <fig>
                <xsl:copy-of select="@*"/>
                <graphic>
                    <xsl:attribute name="alt-version">
                        <xsl:text>no</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="position">
                        <xsl:text>float</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:href">
                        <xsl:text>assets/</xsl:text>
                        <xsl:value-of select="graphic/@xlink:href"/>
                        <xsl:text>.jpg</xsl:text>
                    </xsl:attribute>
                </graphic>
                <attrib>
                    <xsl:value-of select="attrib"/>
                </attrib>
            </fig>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="add-response-link">
        <notes notes-type="response-link">
            <p>
                <ext-link ext-link-type="uri">
                    <xsl:attribute name="xlink:href">
                        <xsl:text>http://www.bmj.com/content/</xsl:text>
                        <xsl:value-of select="//article-meta/volume"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="$bmj-doi"/>
                        <xsl:text>?tab=response-form</xsl:text>
                    </xsl:attribute>
                    <xsl:text>Submit response</xsl:text>
                </ext-link>
            </p>
        </notes>
    </xsl:template>
    
    <!-- Add custom-meta if Letters or Endgames article-->
    <xsl:template name="add-custom-meta-data">
          <xsl:variable name="headingSubject" select="/article/front/article-meta/article-categories/subj-group[@subj-group-type='heading']/subject[1]"></xsl:variable>
          <xsl:if test="matches($headingSubject,'Letters','i')">
               <xsl:element name="custom-meta-wrap">
                    <xsl:element name="custom-meta">
                         <xsl:element name="meta-name">
                              <xsl:text>template-style</xsl:text>
                         </xsl:element>
                         <xsl:element name="meta-value">
                              <xsl:text>letters</xsl:text>
                         </xsl:element>
                    </xsl:element>
               </xsl:element>
          </xsl:if>
          <xsl:if test="matches($headingSubject,'Endgames','i')">
               <xsl:element name="custom-meta-wrap">
                    <xsl:element name="custom-meta">
                         <xsl:element name="meta-name">
                              <xsl:text>template-style</xsl:text>
                         </xsl:element>
                         <xsl:element name="meta-value">
                              <xsl:text>endgames</xsl:text>
                         </xsl:element>
                    </xsl:element>
               </xsl:element>
          </xsl:if>
     </xsl:template>
    
    <!-- Template to add back section where one doesn't exist and populate with any expected elements -->
    <xsl:template match="article">
        <article>
            <xsl:copy-of select="@*"/>
            <!-- Apply templets for whole article -->
            <xsl:apply-templates/>
            <!-- Test for existing back section and populate if one doesn't exist -->
            <xsl:if test=".[not(back)]">
                <back>
                    <xsl:call-template name="add-response-link"/>
                </back>
            </xsl:if>
            <!-- Test for any figures of the type 'lead' and create floats section at end of document if so -->
            <xsl:if test="//fig[@fig-type='lead']">
                <floats-wrap>
                    <xsl:call-template name="output-fig"/>
                </floats-wrap>
            </xsl:if>
        </article>
    </xsl:template>
    
    <!-- Call custom meta template if available-->
    <xsl:template match="article-meta">
        <article-meta>
            <xsl:apply-templates/>
            <xsl:call-template name="add-custom-meta-data"/>
        </article-meta>
    </xsl:template>
    
    <xsl:template match="related-article">
        <xsl:variable name="related-article-doi" select="@xlink:href"/>
        <xsl:choose>
            <xsl:when test="doc(concat('file:///',$toc-path))//DOI[contains(.,$related-article-doi)]">
                <related-article>
                    <xsl:attribute name="xlink:href">
                        <xsl:value-of select="@xlink:href"/>
                    </xsl:attribute>
                    <xsl:attribute name="ext-link-type">
                        <xsl:text>doi</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="related-article-type">
                        <xsl:text>in-this-issue</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:type">
                        <xsl:text>simple</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </related-article>
            </xsl:when>
            <xsl:otherwise>
                <ext-link>
                    <xsl:attribute name="xlink:href">
                        <xsl:text>http://doi.org/</xsl:text>
                        <xsl:value-of select="@xlink:href"/>
                    </xsl:attribute>
                    <xsl:attribute name="ext-link-type">
                        <xsl:text>uri</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:type">
                        <xsl:text>simple</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </ext-link>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text()[ancestor::related-article[parent::article-meta]]" mode="#all">
<!--template to swap full doi links in top-level related article links to show just the elocation id-->
        <xsl:value-of select="replace(.,',|doi:\s*10\.1136/bmj\.','$1')"/>
    </xsl:template>
    
    <xsl:template match="text()[ancestor::related-article[ancestor::notes[@notes-type='editorial-note']]]" mode="#all">
        <!--          template to swap full doi links in top-level related article links to show just the elocation id-->
        <xsl:value-of select="replace(.,',|doi:\s*10\.1136/bmj\.','$1')"/>
    </xsl:template>
    
    <xsl:template match="back">
        <back>
            <xsl:apply-templates/>
            <xsl:call-template name="add-response-link"/>
        </back>
        <xsl:if test="//fig[@fig-type='lead']">
            <floats-wrap>
                <xsl:call-template name="output-fig"/>
            </floats-wrap>
        </xsl:if>
    </xsl:template>
    
    <xsl:variable name="article-name">
        <xsl:value-of select="replace(Location,'(.+)(\\)(.+)','$3')"/>
    </xsl:variable>
    
    <!--Checks for series title. If present do nothing, if not present get 
        value of subject heading for article from external toc.xml and move
        subject from current xml into series-title element-->
    <xsl:template match="subj-group[@subj-group-type='heading']">
        <subj-group subj-group-type="heading">
            <subject>
                <xsl:value-of select="doc(concat('file:///',$toc-path))//DOI[contains(.,$full-doi)]/preceding-sibling::Heading/text()"/>
            </subject>
        </subj-group>
        <xsl:if test="not(following::series-title)">
            <series-title>
                <xsl:value-of select="."/>
            </series-title>
        </xsl:if>
    </xsl:template>
    
    <!-- Get pub date from downloaded Highwire metadata passed in from build -->
    <xsl:template match="pub-date[@pub-type='epub']">
        <pub-date pub-type="collection">
            <year>
                <xsl:value-of select="doc(concat('file:///',$temp-article-path,'/',$bmj-doi,'-hw-pub-info.xml'))//nlm:pub-date[@pub-type='epub']/nlm:year/text()"/>
            </year>
        </pub-date>
        <pub-date pub-type="epub">
            <day>
                <xsl:value-of select="doc(concat('file:///',$temp-article-path,'/',$bmj-doi,'-hw-pub-info.xml'))//nlm:pub-date[@pub-type='epub']/nlm:day/text()"/>
            </day>
            <month>
                <xsl:value-of select="doc(concat('file:///',$temp-article-path,'/',$bmj-doi,'-hw-pub-info.xml'))//nlm:pub-date[@pub-type='epub']/nlm:month/text()"/>
            </month>
            <year>
                <xsl:value-of select="doc(concat('file:///',$temp-article-path,'/',$bmj-doi,'-hw-pub-info.xml'))//nlm:pub-date[@pub-type='epub']/nlm:year"/>
            </year>
        </pub-date>
    </xsl:template>
    
</xsl:stylesheet>
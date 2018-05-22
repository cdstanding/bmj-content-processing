<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
     xmlns:xlink="http://www.w3.org/1999/xlink">
     <xsl:variable name="current-month">
          <xsl:value-of select="month-from-date(current-date())"/>
     </xsl:variable>
     <xsl:variable name="ref-placeholder-text">
          <xsl:text>References are in the version on bmj.com.</xsl:text>
     </xsl:variable>
     
     <xsl:param name="journal"/>
     <xsl:param name="art-section"/>
     <xsl:param name="art-type"/>
     <xsl:param name="output-location"/>
     <xsl:variable name="thisfilepath">
          <xsl:value-of select="replace(document-uri(/),&quot;(.*?)[^/]+$&quot;,&quot;$1&quot;)"/>
     </xsl:variable>
     <xsl:variable name="thisfilepathparent">
          <xsl:value-of select="replace($thisfilepath,&quot;(.*?)/nlmxml/$&quot;,&quot;$1&quot;)"/>
     </xsl:variable>
     <xsl:variable name="thisfilename">
          <xsl:value-of select="replace(document-uri(/),&quot;.*?([^/]+$)&quot;,&quot;$1&quot;)"/>
     </xsl:variable>
     <xsl:variable name="thisfilebasename">
          <xsl:value-of select="replace(document-uri(/),&quot;.*?([^/]+).xml$&quot;,&quot;$1&quot;)"
          />
     </xsl:variable>
     <!--NEW section head abbreviations to add to body styles
          Exclusions: references, tables, and boxes
          
          AC= Analysis
          DB = Data Breifing
          EC= Editor's choice
          NW= News
          NIB= News Bites
          LT= Letters
          ED= Editorials
          RE= Research
          FE= Features
          H2H= Head to Head
          RN= Research News
          RMR= Research Methods & Reporting
          PR= Practice
          CR= Clinical Review
          OBT= Obits
          OBS= Observations (LW= Lobby Watch, MM= Medicine in Media)
          END= Endgames
          PV= Already split 
          MV= Minerva 
          DOT= Dot.com page?
          SC = short cuts
          VR = views and reviews generic
          
     
     
     -->
     
     
     
     
     
     <xsl:variable name="series-title-label">
          <xsl:if test="$journal='bmj'">
               <xsl:choose>
                    <xsl:when test="matches(.//series-title,'lobby watch','i')">
                         <xsl:text>LW</xsl:text>
                    </xsl:when>
                    <xsl:when test="matches(.//series-title,'medicine and the media','i')">
                         <xsl:text>MM</xsl:text>
                    </xsl:when>
                    <xsl:when test="matches(.//series-title,'medical classics?|round table','i')">
                         <xsl:text>MC</xsl:text>
                    </xsl:when>
                    <xsl:when test="matches(.//series-title,'from the frontline','i')">
                         <xsl:text>FTF</xsl:text>
                    </xsl:when>
                    <xsl:when test="matches(.//series-title,'between the lines','i')">
                         <xsl:text>BTL</xsl:text>
                    </xsl:when>
                    <xsl:when test="matches(.//series-title,'review of the week','i')">
                         <xsl:text>ROTW</xsl:text>
                    </xsl:when>
                    <xsl:when test="matches(.//series-title,'personal views?','i')">
                         <xsl:text>PV</xsl:text>
                    </xsl:when>
                    <xsl:when
                         test="$art-type='obituary' and //front/article-meta/abstract[@abstract-type='teaser']/p ">
                         <xsl:text>OBIT-L</xsl:text>
                    </xsl:when>
                    <xsl:when
                         test="$art-type='obituary'">
                         <xsl:text>OBIT</xsl:text>
                    </xsl:when>
                    <xsl:when test="$art-section='news' and matches(.//article-title,'In brief','i')">
                         <xsl:text>NIB</xsl:text>
                    </xsl:when>
                    <xsl:when test="$art-section='minerva' and //fig">
                         <xsl:text>MP</xsl:text>
                    </xsl:when>
                    <xsl:when test="$art-section='minerva'">
                         <xsl:text>MV</xsl:text>
                    </xsl:when>
                    <xsl:when test="$art-section='feature' and matches(.//series-title,'data briefing','i')">
                         <xsl:text>DB</xsl:text>
                    </xsl:when>
                    <xsl:when test="$art-section='rpage' and matches(.//series-title,'weblinks','i')">
                         <xsl:text>LK</xsl:text>
                    </xsl:when>
                    
                    <!--  CAREERS MATCHES /  -->
                    <xsl:when
                         test="$art-section='careers' and matches(.//article-title[1],'News in brief','i')">
                         <xsl:text>CIB</xsl:text>
                    </xsl:when>
                    <xsl:when
                         test="$art-section='careers' and matches(.//article-title[1],'News','i')">
                         <xsl:text>NH</xsl:text>
                    </xsl:when>
                    <xsl:when test="$art-section='careers' and $art-type='letter'">
                         <xsl:text>LET</xsl:text>
                    </xsl:when>
                    <!--  / CAREERS MATCHES   -->
                    
                    
                    <!--SECTION MATCHES   -->
                    <xsl:when
                         test="matches($art-section,'research-news','i')">
                         <!--                    QUERY: WHAT WILL RESEARCH NEWS BE TAGGED AS?-->
                         <!--<xsl:text>RN</xsl:text>-->
                         <xsl:text>NW</xsl:text>
                    </xsl:when>
                    <xsl:when test="$art-section='choice'">
                         <xsl:text>EC</xsl:text>
                    </xsl:when>
                    <xsl:when test="$art-section='rpage'">
                         <xsl:text>RI</xsl:text>
                    </xsl:when>
                    <xsl:when test="$art-section='filler'">
                         <xsl:text>FL</xsl:text>
                    </xsl:when>
                    <xsl:when test="$art-section='feature'">
                         <xsl:text>FE</xsl:text>
                    </xsl:when>
                    <xsl:when test="$art-section='spotlight'">
                         <xsl:text>FE</xsl:text>
                    </xsl:when>
                    <xsl:when
                         test="matches($art-section,'analysis*','i')">
                         <xsl:text>AC</xsl:text>
                    </xsl:when>
                    <xsl:when
                         test="matches($art-section,'editorial*','i')">
                         <xsl:text>ED</xsl:text>
                    </xsl:when>
                    <xsl:when
                         test="matches($art-section,'news*','i')">
                         <xsl:text>NW</xsl:text>
                    </xsl:when>
                    <xsl:when
                         test="matches($art-section,'letter*','i')">
                         <xsl:text>LT</xsl:text>
                    </xsl:when>
                    <xsl:when
                         test="matches($art-section,'research-methods*','i')">
                         <xsl:text>RMR</xsl:text>
                    </xsl:when>
                    <xsl:when
                         test="matches($art-section,'research','i')">
                         <xsl:text>RE</xsl:text>
                    </xsl:when>
                    <xsl:when
                         test="matches($art-section,'practice*','i')">
                         <xsl:text>PR</xsl:text>
                    </xsl:when>
                    <xsl:when
                         test="matches($art-section,'clinical*','i')">
                         <xsl:text>CR</xsl:text>
                    </xsl:when>
                    <xsl:when
                         test="matches($art-section,'observation*','i')">
                         <xsl:text>OBS</xsl:text>
                    </xsl:when>
                    <xsl:when
                         test="matches($art-section,'endgame*','i')">
                         <xsl:text>END</xsl:text>
                    </xsl:when>
                    <xsl:when
                         test="matches($art-section,'dot*','i')">
                         <!--                    QUERY: WHAT WILL dot come page be tagged as?-->
                         <xsl:text>DOT</xsl:text>
                    </xsl:when>
                    
                    <xsl:when
                         test="matches($art-section,'head-to-head','i')">
                         <xsl:text>H2H</xsl:text>
                    </xsl:when>
                    <xsl:when test="matches($art-section,'short-cuts','i')">
                         <xsl:text>SC</xsl:text>
                    </xsl:when>
                    <xsl:when test="matches($art-section,'views','i')">
                         <xsl:text>VR</xsl:text>
                    </xsl:when>
                    
                    
                    <!--                   / SECTION MATCHES   -->
                    <xsl:otherwise/>
                    
               </xsl:choose>
          </xsl:if>
     </xsl:variable>
     
     <xsl:include href="lib-authors.xsl"/>
     <xsl:include href="lib-tables.xsl"/>

     <xsl:template match="/">
          <xsl:message select="$current-month"/>
          
          

          <xsl:message>SERIES/section TITLE LABEL IS <xsl:value-of select="$series-title-label"/></xsl:message>
          <xsl:choose>
               <xsl:when test="$journal='bmj'">
                    <xsl:call-template name="bmj-processing"/>
               </xsl:when>
               <xsl:when test="$journal='sbmj'">
                    <xsl:call-template name="sbmj-processing"/>
               </xsl:when>
          </xsl:choose>



     </xsl:template>
     
     <xsl:template match="//article-meta/comment()[not(contains(.,'=')) and not(contains(.,'Table-node')) and not(contains(.,'DEBUG'))]" mode="#all">
          <xsl:copy-of select="."/>
     </xsl:template>
     <xsl:template match="comment()[not(contains(.,'=')) and not(contains(.,'Table-node')) and not(contains(.,'DEBUG'))]" mode="#all">
          <xsl:element name="typesetter-note">
               <xsl:value-of select="."/>
               </xsl:element>
          <xsl:copy-of select="."/>
     </xsl:template>
     
     <xsl:template name="bmj-processing">
          <xsl:choose>
               <xsl:when test="$art-type='editorial'">
                    <xsl:message>PROCESSING EDITORIAL</xsl:message>
                    <xsl:call-template name="process-editorial"/>
               </xsl:when>
               <xsl:when test="$art-type='product-review' and $series-title-label='MC'">
                    <xsl:message>PROCESSING MED CLASSIC</xsl:message>
                    <xsl:call-template name="process-med-classic"/>
               </xsl:when>
               <xsl:when test="$art-type='other' and $series-title-label='PV'">
                    <xsl:message>PROCESSING PERSONAL VIEW</xsl:message>
                    <xsl:call-template name="process-personal-view"/>
               </xsl:when>
               <xsl:when test="$art-type='product-review' and $series-title-label='ROTW'">
                    <xsl:message>PROCESSING REVIEW OF THE WEEK</xsl:message>
                    <xsl:call-template name="process-product-review"/>
               </xsl:when>
               <xsl:when test="$art-type='product-review'">
                    <xsl:message>PROCESSING REVIEW </xsl:message>
                    <xsl:call-template name="process-product-review"/>
               </xsl:when>
               <xsl:when test="$art-type='other' and $series-title-label='BTL'">
                    <xsl:message>PROCESSING BETWEN THE LINES</xsl:message>
                    <xsl:call-template name="process-column"/>
               </xsl:when>
               <xsl:when test="$art-section='views'">
                    <xsl:message>PROCESSING VIEWS COLUMN</xsl:message>
                    <xsl:call-template name="process-column"/>
               </xsl:when>
               <xsl:when test="$art-section='letters'">
                    <xsl:message>PROCESSING LETTERS</xsl:message>
                    <xsl:call-template name="process-letter"/>
               </xsl:when>
               <xsl:when test="$series-title-label='OBIT-L'">
                    <xsl:message>PROCESSING LEAD OBITUARY</xsl:message>
                    <xsl:call-template name="process-lead-obit"/>
               </xsl:when>
               <xsl:when test="$art-type='obituary'">
                    <xsl:message>PROCESSING OBITUARY</xsl:message>
                    <xsl:call-template name="process-obit"/>
               </xsl:when>
               <xsl:when test="$art-section='analysis'">
                    <xsl:message>PROCESSING ANALYSIS</xsl:message>
                    <xsl:call-template name="process-analysis"/>
               </xsl:when>
               <xsl:when test="$art-section='news' and matches(.//article-title,'In brief','i')">
                    <xsl:message>PROCESSING NEWS BRIEF</xsl:message>
                    <xsl:call-template name="process-news-brief"/>
               </xsl:when>
               <xsl:when test="$art-section='news'">
                    <xsl:message>PROCESSING NEWS</xsl:message>
                    <xsl:call-template name="process-news"/>
               </xsl:when>
               <xsl:when test="$art-section='filler'">
                    <xsl:message>PROCESSING FILLER</xsl:message>
                    <xsl:call-template name="process-filler"/>
               </xsl:when>
               <xsl:when test="$art-section='short-cuts'">
                    <xsl:message>PROCESSING SHORT CUTS</xsl:message>
                    <xsl:call-template name="process-short-cuts"/>
               </xsl:when>
               <!--2013-09-12 Deprecate Research News now just a news story
                    <xsl:when test="$art-section='research-news'">
                    <xsl:message>PROCESSING RESEARCH NEWS</xsl:message>
                    <xsl:call-template name="process-research-news"/>
               </xsl:when>-->
               <xsl:when test="$art-section='research-news'">
                    <xsl:message>PROCESSING RESEARCH NEWS INTO NEWS</xsl:message>
                    <xsl:call-template name="process-news"/>
               </xsl:when>
               <xsl:when test="$art-section='minerva'">
                    <xsl:message>PROCESSING MINERVA</xsl:message>
                    <xsl:call-template name="process-minerva"/>
               </xsl:when>
               <xsl:when test="$art-section='research-methods-and-reporting'">
                    <xsl:message>PROCESSING RESEARCH METHODS AND REPORTING</xsl:message>
                    <xsl:call-template name="process-rmr"/>
               </xsl:when>
               <xsl:when test="$art-section='research' and $art-type='research-article'">
                    <xsl:message>PROCESSING RESEARCH ARTICLE</xsl:message>
                    <xsl:call-template name="process-research-article"/>
               </xsl:when>
               <xsl:when test="$art-type='commentary'">
                    <xsl:message>PROCESSING COMMENTARY ARTICLE</xsl:message>
                    <xsl:call-template name="process-research-article"/>
               </xsl:when>
               <xsl:when test="$art-section='practice' or $art-section='clinical-review'">
                    <xsl:message>PROCESSING PRACTICE OR CR ARTICLE</xsl:message>
                    <xsl:call-template name="process-research-article"/>
               </xsl:when>
               <xsl:when
                    test="$art-section='careers' and $art-type='news' and matches($series-title-label,'NH','i')">
                    <xsl:message>PROCESSING CAREERS NEWSHOUND ARTICLE</xsl:message>
                    <xsl:call-template name="process-careers-news"/>
               </xsl:when>
               <xsl:when
                    test="$art-section='careers' and $art-type='news' and matches($series-title-label,'CIB','i')">
                    <xsl:message>PROCESSING CAREERS NEWSBRIEF</xsl:message>
                    <xsl:call-template name="process-careers-news-in-brief"/>
               </xsl:when>
               <xsl:when
                    test="$art-section='careers' and
                    (matches(.//series-title,'Diplomatosis','i')
                    or matches(.//series-title,'The Way I see it','i')
                    )">
                    <xsl:message>PROCESSING CAREERS ARTICLE STRUCTURE 2"</xsl:message>
                    <xsl:call-template name="process-careers-structure2"/>
               </xsl:when>
               <xsl:when test="$art-section='careers' and $art-type='letter'">
                    <xsl:message>PROCESSING CAREERS LETTER</xsl:message>
                    <xsl:call-template name="process-careers-letter"/>
               </xsl:when>
               <xsl:when test="$art-section='careers'">
                    <xsl:message>PROCESSING CAREERS STANDARD ARTICLE</xsl:message>
                    <xsl:call-template name="process-careers-standard-article"/>
               </xsl:when>
               <xsl:when test="$art-section='observations'">
                    <xsl:message>PROCESSING OBSERVATIONS ARTICLE</xsl:message>
                    <xsl:call-template name="process-bmj-observations-article"/>
               </xsl:when>
               <xsl:when test="$art-section='feature'">
                    <xsl:message>PROCESSING FEATURES ARTICLE</xsl:message>
                    <xsl:call-template name="process-bmj-feature-article"/>
               </xsl:when>
               <xsl:when test="$art-section='head-to-head'">
                    <xsl:message>PROCESSING HEAD-TO-HEAD ARTICLE</xsl:message>
                    <xsl:call-template name="process-bmj-head-to-head-article"/>
<!--                    <xsl:call-template name="process-editorial"/>-->
               </xsl:when>
               <xsl:when test="$art-section='rpage'">
                    <xsl:message>PROCESSING Research Page</xsl:message>
                    <xsl:call-template name="process-rpage"/>
               </xsl:when>
               <xsl:when test="$art-section='endgames'">
                    <xsl:message>PROCESSING Endgames</xsl:message>
<!--                    <xsl:call-template name="process-lead-obit"/>-->
<!--                    <xsl:call-template name="process-endgames1"/>-->
                    <xsl:call-template name="process-endgames2"/>
               </xsl:when>
               <xsl:when test="$art-section='choice'">
                    <xsl:message>PROCESSING EDITOR'S CHOICE</xsl:message>
                    <xsl:call-template name="process-choice"/>
               </xsl:when>
<!-- spotlight make to look like feature (Mar 2012 )-->
     <xsl:when test="$art-section='spotlight'">
                    <xsl:message>PROCESSING SPOTLIGHT with feature layout rules</xsl:message>
          <xsl:call-template name="process-bmj-feature-article"/>
               </xsl:when>
 <xsl:otherwise/>
          </xsl:choose>
     </xsl:template>
     
     <xsl:template name="sbmj-processing">
          <xsl:message>PROCESSING SBMJ ARTICLE</xsl:message>
          <xsl:call-template name="process-sbmj"/>
     </xsl:template>


     <xsl:template name="process-editorial">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:apply-templates
                         select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                         mode="flow"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
<!-- OLD
               <xsl:element name="author-info">
                    <xsl:apply-templates select="//article-meta/related-article"/>
                    <xsl:call-template name="lib-authors-model-a">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates select="//back/notes/fn-group/fn[@fn-type='conflict']/p"
                         mode="flow"/>
                    <xsl:apply-templates
                         select="//back/notes/fn-group/fn/p[matches(text()[1],'Provenance and peer review')]"
                         mode="flow"/>
                    <xsl:text>&#x2028;&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
                    <xsl:apply-templates
                         select="//article/front/article-meta/article-id[@pub-id-type='doi']"/>
               </xsl:element>
-->               
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:call-template name="lib-authors-model-a">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:apply-templates select="//back/notes/fn-group/fn[@fn-type='conflict']/p"
                         mode="flow"/>
                    <xsl:apply-templates
                         select="//back/notes/fn-group/fn/p[matches(text()[1],'Provenance and peer review')]"
                         mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
                    <xsl:apply-templates
                         select="//article/front/article-meta/article-id[@pub-id-type='doi']">
                         <xsl:with-param name="run-on" select="'0'"/>
                    </xsl:apply-templates>
          </xsl:element>
               <xsl:call-template name="process-floats"/>
          </xsl:element>
     </xsl:template>

   
     
     <xsl:template name="process-column">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
<!--               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/contrib-group/contrib/name"
                         mode="column"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                         <xsl:text>&#x0A;</xsl:text>
                    </xsl:if>
               </xsl:element>
-->               
               <xsl:element name="flow">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/contrib-group/contrib/name"
                         mode="column"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                         <xsl:text>&#x0A;</xsl:text>
                    </xsl:if>
               <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    
                    <!--<xsl:apply-templates select="//back/ref-list"/>-->
                    <xsl:call-template name="lib-authors-model-views">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="art-section" select="$art-section"/>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:if test="//back/ref-list">
                         <xsl:call-template name="add-ref-placeholder-text"/>
                    </xsl:if>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <xsl:call-template name="process-floats"/>
               
          </xsl:element>
     </xsl:template>
     

     <xsl:template name="process-personal-view">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
<!--               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/contrib-group/contrib/name"
                         mode="column"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                         <xsl:text>&#x0A;</xsl:text>
                    </xsl:if>
               </xsl:element>
--> 
               <xsl:element name="flow">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/contrib-group/contrib/name"
                         mode="column"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                         <xsl:text>&#x0A;</xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:call-template name="lib-authors-model-views">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="art-section" select="$art-section"/>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p"
                    mode="flow"/>
                    <xsl:if test="//back/ref-list">
                         <xsl:call-template name="add-ref-placeholder-text"/>
                    </xsl:if>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <xsl:call-template name="process-floats"/>

          </xsl:element>
     </xsl:template>

     <xsl:template name="process-product-review">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
<!--               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                         <xsl:text>&#x0A;</xsl:text>
                    </xsl:if>
               </xsl:element>

               <xsl:if test="//front/notes/fn-group/fn">
                    <xsl:element name="product-info">
                         <xsl:apply-templates select="//front/notes/fn-group/fn/p" mode="flow"/>
                    </xsl:element>
               </xsl:if>
-->               <xsl:element name="flow">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                         <xsl:text>&#x0A;</xsl:text>
                    </xsl:if>
                    <xsl:if test="//front/notes/fn-group/fn">
<!--                         <xsl:element name="product-info">-->
                              <xsl:apply-templates select="//front/notes/fn-group/fn/p" mode="flow"/>
<!--                         </xsl:element>-->
                    </xsl:if>
                    
                    
                    
                    
                    
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:call-template name="lib-authors-model-views">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="art-section" select="$art-section"/>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:if test="//back/ref-list">
                         <xsl:call-template name="add-ref-placeholder-text"/>
                    </xsl:if>                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <xsl:call-template name="process-floats"/>

          </xsl:element>
     </xsl:template>

     <xsl:template name="process-med-classic">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="flow">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                         <xsl:text>&#x0A;</xsl:text>
                    </xsl:if>
                    <xsl:if test="//front/notes/fn-group/fn">
                         <xsl:element name="product-info">
                              <xsl:apply-templates select="//front/notes/fn-group/fn/p" mode="flow"
                              />
                         </xsl:element>
                    </xsl:if>
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:call-template name="lib-authors-model-views">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="art-section" select="$art-section"/>
                         
                         <xsl:with-param name="series-title-label">
                              <xsl:copy-of select="$series-title-label"/>
                         </xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:if test="//back/ref-list">
                         <xsl:call-template name="add-ref-placeholder-text"/>
                    </xsl:if>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <xsl:call-template name="process-floats"/>


          </xsl:element>
     </xsl:template>

     <xsl:template name="process-letter">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="flow">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                         <xsl:text>&#x0A;</xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:call-template name="lib-authors-model-views">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="art-section" select="$art-section"/>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="//back/notes/fn-group/fn[@fn-type='conflict']/p"
                         mode="flow"/>
                    <xsl:apply-templates select="//notes/fn-group/fn[not(@fn-type='conflict')]/p"
                         mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <xsl:call-template name="process-floats"/>
               <xsl:text>&#x0A;</xsl:text>
          </xsl:element>
     </xsl:template>

     <xsl:template name="process-lead-obit">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                    </xsl:if>
               </xsl:element>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//front/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:call-template name="lib-authors-model-a">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:if test="//back/ref-list">
                         <xsl:call-template name="add-ref-placeholder-text"/>
                    </xsl:if>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <xsl:call-template name="process-floats"/>
          </xsl:element>
     </xsl:template>
     
     <xsl:template name="process-endgames1">
<!--          This assumes the questions and answers have been split. I would prefer to use process-endgames2-->
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                    </xsl:if>
               </xsl:element>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <!--                    <xsl:apply-templates select="//body/node()[matches(ancestor-or-self::sec/title,'Questions','i')]" mode="flow"/>-->
                    <!--                    <xsl:apply-templates select="//node()[ancestor::body]" mode="flow"/>-->
                    <xsl:apply-templates select="//body/*[not(sec[matches(title, 'Answer','i')]) and not(ancestor-or-self::sec[matches(title, 'Patient outcome')])]" mode="flow"/>
                    <xsl:if test="//front//article-meta/contrib-group">
                              <xsl:call-template name="lib-authors-model-endgames">
                                   <xsl:with-param name="contrib-group">
                                        <xsl:copy-of select="//article-meta/contrib-group"/>
                                   </xsl:with-param>
                                   <xsl:with-param name="author-notes">
                                        <xsl:copy-of select="//article-meta/author-notes"/>
                                   </xsl:with-param>
                                   <xsl:with-param name="series-title-label" select="$series-title-label"/>
                              </xsl:call-template>
                         
                    </xsl:if>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
                              <xsl:call-template name="process-floats"/>
          </xsl:element>
     </xsl:template>
     
     
     <xsl:template name="process-endgames2">
<!--          this splits out the questions and answers into two files for print. Preferred solution if we can make it work-->
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                    </xsl:if>
                    <xsl:apply-templates select="//body/*[not(ancestor-or-self::sec[matches(title, 'Answer','i')]) and not(ancestor-or-self::sec[matches(title, 'Patient outcome')])]" mode="flow"/>
                    <xsl:if test="//front//article-meta/contrib-group">
                              <xsl:call-template name="lib-authors-model-endgames">
                                   <xsl:with-param name="contrib-group">
                                        <xsl:copy-of select="//article-meta/contrib-group"/>
                                   </xsl:with-param>
                                   <xsl:with-param name="author-notes">
                                        <xsl:copy-of select="//article-meta/author-notes"/>
                                   </xsl:with-param>
                                   <xsl:with-param name="series-title-label" select="$series-title-label"/>
                              </xsl:call-template>
                         
                    </xsl:if>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:choose>
                         <xsl:when test="matches(//front/article-meta/article-categories/series-title,'On\s*Examination','i')"/>
                         <xsl:otherwise>
                              <xsl:call-template name="add-citation-info"/>
                         </xsl:otherwise>
                    </xsl:choose>
                    
               </xsl:element>
               <xsl:call-template name="process-floats-in-context">
                    <xsl:with-param name="context">
                         <xsl:copy-of select="//body/*[not(ancestor-or-self::sec[matches(title, 'Answer','i')]) and not(ancestor-or-self::sec[matches(title, 'Patient outcome')])]"/>
                    </xsl:with-param>
               </xsl:call-template>
          </xsl:element>
          <xsl:variable name="output-file" select="concat($thisfilepathparent,'/id-xml/',$id,'-answer.xml')"/>
          <xsl:message>I get output location param as file for endgames answer as location as <xsl:value-of select="$output-location"></xsl:value-of></xsl:message>
          <xsl:message>I get parent output file for this file as <xsl:value-of select="$thisfilepathparent"></xsl:value-of></xsl:message>
          <xsl:message>I get output file for endgames answer as location as <xsl:value-of select="$output-file"></xsl:value-of></xsl:message>
          <xsl:if test="//body/sec[matches(title, 'answer','i')]">
               <xsl:result-document href="{$output-file}">
                    <xsl:element name="article">
                         <xsl:attribute name="id" select="$id"/>
                         <xsl:element name="titles">
                              <xsl:apply-templates
                                   select="//front/article-meta/article-categories/series-title"/>
                              <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                              <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                                   <xsl:element name="standfirst">
                                        <xsl:apply-templates
                                             select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                             mode="flow"/>
                                   </xsl:element>
                              </xsl:if>
                         </xsl:element>
                         <xsl:element name="flow">
                              <xsl:choose>
                                   <xsl:when test="//body//title[matches(.,'Short answer$')]">
                                        <xsl:for-each select="//body//sec[title[matches(.,'Short answer$')]]">
                                                  <xsl:apply-templates select="./*[not(matches(local-name(),'title'))]" mode="flow"/>
                                        </xsl:for-each>
                                   </xsl:when>
                                   <xsl:otherwise>
                                        <xsl:for-each select="//body//sec[matches(title, 'answer','i')]">
                                             <xsl:apply-templates select="./*[not(matches(local-name(),'title'))  and not(ancestor-or-self::sec[title[matches(.,'Discussion')]]) ]" mode="flow"/>
                                        </xsl:for-each>
                                   </xsl:otherwise>
                              </xsl:choose>
                         </xsl:element>
                         <xsl:call-template name="process-floats-in-context">
                              <xsl:with-param name="context">
                                   <xsl:choose>
                                        <xsl:when test="//body//title[matches(.,'Short answer$')]">
                                             <xsl:for-each select="//body//sec[title[matches(.,'Short answer$')]]">
                                                  <xsl:copy-of select="./*[not(matches(local-name(),'title'))]"/>
                                             </xsl:for-each>
                                        </xsl:when>
                                        <xsl:otherwise>
                                             <xsl:copy-of select="//body//sec[matches(title, 'Answer','i')]/*[not(matches(local-name(),'title'))  and not(ancestor-or-self::sec[title[matches(.,'Discussion')]]) ]"/>
                                        </xsl:otherwise>
                                   </xsl:choose>
                              </xsl:with-param>
                         </xsl:call-template>
                    </xsl:element>
               </xsl:result-document>
          </xsl:if>
     </xsl:template>
     
     
     
     
     
     
     
     
     
     
     

     <xsl:template name="process-obit">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="flow">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:apply-templates select="//front/notes/fn-group/fn/p|//back/bio/p" mode="flow"/>
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:call-template name="lib-authors-model-views">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="art-section" select="$art-section"/>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
                    <xsl:text>&#x0A;</xsl:text>
               </xsl:element>
               <xsl:call-template name="process-floats"/>
          </xsl:element>
     </xsl:template>

     <xsl:template name="process-analysis">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               
               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:apply-templates
                         select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                         mode="flow"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:call-template name="lib-authors-model-analysis">
                         <xsl:with-param name="journal" select="$journal"/>
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="//front/article-meta/history" mode="flow"/>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:call-template name="process-floats"/>
               <xsl:text>&#x0A;</xsl:text>
          </xsl:element>
     </xsl:template>
     
     
     
     
     
     <xsl:template name="process-sbmj">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               
               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:apply-templates
                         select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                         mode="flow"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//front/notes" mode="flow"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:call-template name="lib-authors-model-analysis">
                         <xsl:with-param name="journal" select="$journal"/>
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates select="//front/article-meta/history" mode="flow"/>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:call-template name="process-floats"/>
               <xsl:text>&#x0A;</xsl:text>
          </xsl:element>
     </xsl:template>
     

     <xsl:template name="process-news">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="titles">
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
               </xsl:element>

               <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                    <xsl:element name="standfirst">
                         <xsl:apply-templates
                              select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                              mode="flow"/>
                    </xsl:element>
                    <xsl:text>&#x0A;</xsl:text>
               </xsl:if>

               <xsl:element name="flow">
                    <xsl:call-template name="lib-authors-model-news">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="art-section" select="$art-section"/>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <xsl:call-template name="process-floats"/>
          </xsl:element>
     </xsl:template>
     <xsl:template name="process-news-brief">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <!--<xsl:element name="titles">
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/contrib-group/contrib/name"
                         mode="pv"/>
               </xsl:element>-->

               <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                    <xsl:element name="standfirst">
                         <xsl:apply-templates
                              select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                              mode="flow"/>
                    </xsl:element>
                    <xsl:text>&#x0A;</xsl:text>
               </xsl:if>


               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>

          </xsl:element>
     </xsl:template>
     <xsl:template name="process-filler">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="id">
                    <xsl:value-of select="$id"/>
               </xsl:element>
               <xsl:if test="//front/article-meta/title-group/article-title">
                    <xsl:element name="titles">
                         <xsl:apply-templates
                              select="//front/article-meta/article-categories/series-title"/>
                         <xsl:apply-templates
                              select="//front/article-meta/title-group/article-title"/>
                    </xsl:element>
               </xsl:if>
               <xsl:element name="flow">
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                         <xsl:text>&#x0A;</xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:if test="/article/front/article-meta/contrib-group">
                         <!--<xsl:call-template name="lib-authors-model-views">
                              <xsl:with-param name="contrib-group">
                                   <xsl:copy-of select="//article-meta/contrib-group"/>
                              </xsl:with-param>
                              <xsl:with-param name="author-notes">
                                   <xsl:copy-of select="//article-meta/author-notes"/>
                              </xsl:with-param>
                              <xsl:with-param name="art-section" select="$art-section"/>
                              <xsl:with-param name="series-title-label" select="$series-title-label"
                              />
                              </xsl:call-template>-->
                         <xsl:call-template name="lib-authors-model-a">
                              <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                              </xsl:with-param>
                              <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                              </xsl:with-param>
                              <xsl:with-param name="series-title-label" select="$series-title-label"
                              />
                              </xsl:call-template>
                    </xsl:if>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <xsl:call-template name="process-floats"/>
          </xsl:element>
     </xsl:template>
     <xsl:template name="process-minerva">
          <xsl:choose>
               <xsl:when test="//contrib or //fig">
                    <xsl:call-template name="process-minerva-pic"/>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:call-template name="process-minerva-para"/>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>

     <xsl:template name="process-minerva-pic">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="flow">
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                         <xsl:text>&#x0A;</xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//article-meta/title-group/article-title"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:call-template name="lib-authors-model-minerva">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="art-section" select="$art-section"/>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <!--               <xsl:call-template name="process-floats"/>-->
          </xsl:element>
     </xsl:template>
     <xsl:template name="process-minerva-para">
          <xsl:message>PROCESSING MINERVA PARA</xsl:message>
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
          </xsl:element>
     </xsl:template>
     
     <xsl:template name="process-research-news">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:element name="scut"><xsl:text>&#x0A;</xsl:text>
                         <xsl:element name="RN-body-sec-title-1">
                              <xsl:apply-templates select="//article-meta/title-group/article-title" mode="flow"/>
                         </xsl:element>
                         <xsl:apply-templates select="//body/p[not(child::citation)]|//body/li|//body/fig"
                              mode="flow"/>
                         <xsl:apply-templates select="//body/p[child::citation]/citation" mode="scuts"
                         />
                    </xsl:element>
                    
<!--                    <xsl:for-each select="//body/sec">
                         <xsl:element name="scut">
                              <xsl:apply-templates select="title" mode="flow"/>
                              <xsl:apply-templates select="p[not(child::citation)]|li|fig"
                                   mode="flow"/>
                              <xsl:apply-templates select="p[child::citation]/citation" mode="scuts"
                              />
                         </xsl:element>
                    </xsl:for-each>
-->                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
                    <!--<xsl:call-template name="process-floats"/>-->
               </xsl:element>
          </xsl:element>
     </xsl:template>
     
     
     

     <xsl:template name="process-short-cuts">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:for-each select="//body/sec">
                         <xsl:element name="scut">
                              <xsl:apply-templates select="title" mode="flow"/>
                              <xsl:apply-templates select="p[not(child::citation)]|li|fig"
                                   mode="flow"/>
                              <xsl:apply-templates select="p[child::citation]/citation" mode="scuts"
                              />
                         </xsl:element>
                    </xsl:for-each>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
                    <!--<xsl:call-template name="process-floats"/>-->
               </xsl:element>
          </xsl:element>
     </xsl:template>

     <xsl:template name="process-rmr">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:call-template name="lib-authors-model-research">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>

               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="author-info">
                    <xsl:apply-templates select="//article-meta/related-article" mode="flow"/>
                    <xsl:call-template name="lib-author-info-model-research">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="//article-meta/history" mode="flow"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
                    <xsl:apply-templates
                         select="//article/front/article-meta/article-id[@pub-id-type='doi']"/>
                    <xsl:apply-templates select="//article/front/notes/fn-group/fn/p" mode="flow"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                    </xsl:if>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:call-template name="process-floats"/>
          </xsl:element>
     </xsl:template>



     <xsl:template name="process-research-article">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:call-template name="lib-authors-model-research">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>

               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="author-info">
                    <xsl:apply-templates select="//article-meta/related-article" mode="flow"/>
                    <xsl:call-template name="lib-author-info-model-research">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
                    <xsl:apply-templates
                         select="//article/front/article-meta/article-id[@pub-id-type='doi']"/>
                    <xsl:apply-templates select="//article/front/notes/fn-group/fn/p" mode="flow"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="flow">
                    
                    <xsl:if test="//front/article-meta/abstract/p">
                         <!--                         insert abstract title-->
                         <xsl:element name="front-article-meta-abstract-title">
                              <xsl:text>Abstract</xsl:text>
                         </xsl:element>
                         <xsl:apply-templates select="//front/article-meta/abstract/p" mode="flow"/>
                    </xsl:if>
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
                    <xsl:apply-templates select="//article-meta/history" mode="flow"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:call-template name="process-floats"/>
               <xsl:text>&#x0A;</xsl:text>
          </xsl:element>
     </xsl:template>

     <xsl:template name="process-careers-news">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="flow">
                    <!--<xsl:apply-templates select="//front/article-meta/title-group/article-title"/>-->
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
               </xsl:element>
               <xsl:call-template name="process-floats"/>
               <xsl:text>&#x0A;</xsl:text>
          </xsl:element>
     </xsl:template>

     <xsl:template name="process-careers-news-in-brief">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
               </xsl:element>
          </xsl:element>
     </xsl:template>

     <xsl:template name="process-careers-letter">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="flow">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
                    <xsl:call-template name="lib-authors-model-careers">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
               </xsl:element>
          </xsl:element>
     </xsl:template>

     <xsl:template name="process-careers-standard-article">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:apply-templates
                         select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                         mode="flow"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
                    <xsl:call-template name="lib-authors-model-careers">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                    </xsl:call-template>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:call-template name="process-floats"/>
               <xsl:text>&#x0A;</xsl:text>
          </xsl:element>
     </xsl:template>

     <xsl:template name="process-careers-structure2">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:apply-templates
                         select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                         mode="flow"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="author-info">
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
                    <xsl:call-template name="lib-authors-model-careers">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                    </xsl:call-template>
               </xsl:element>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
               </xsl:element>
               <xsl:call-template name="process-floats"/>
          </xsl:element>
     </xsl:template>


     <xsl:template name="process-bmj-observations-article">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
<!--               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/contrib-group/contrib/name"
                         mode="column"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                         <xsl:text>&#x0A;</xsl:text>
                    </xsl:if>
               </xsl:element>
-->               
               <xsl:element name="flow">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/contrib-group/contrib/name"
                         mode="column"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                         <xsl:text>&#x0A;</xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:call-template name="lib-authors-model-views">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="art-section" select="$art-section"/>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:if test="//back/ref-list">
                         <xsl:call-template name="add-ref-placeholder-text"/>
                    </xsl:if>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:call-template name="process-floats"/>

          </xsl:element>
     </xsl:template>


     <xsl:template name="process-bmj-feature-article">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:if test="//front/article-meta/article-categories/series-title">
                    <xsl:element name="page-banner">
                         <xsl:apply-templates
                              select="//front/article-meta/article-categories/series-title"/>
                    </xsl:element>
               </xsl:if>
               <xsl:element name="titles">
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                    </xsl:if>
               </xsl:element>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:call-template name="lib-authors-model-views">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="art-section" select="$art-section"/>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:call-template name="process-floats"/>

          </xsl:element>
     </xsl:template>

     <xsl:template name="process-bmj-head-to-head-article">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/series-title"/>
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                         <xsl:text>&#x0A;</xsl:text>
                    </xsl:if>
               </xsl:element>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <!--<xsl:call-template name="lib-authors-model-a">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>-->
                    <xsl:call-template name="lib-authors-model-views">
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                         <xsl:with-param name="art-section" select="$art-section"/>
                         <xsl:with-param name="series-title-label" select="$series-title-label"/>
                    </xsl:call-template>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:call-template name="process-floats"/>

          </xsl:element>
     </xsl:template>
     
     <xsl:template name="process-rpage">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               <xsl:if test="//front/article-meta/article-categories/series-title">
                    <xsl:element name="page-banner">
                         <xsl:apply-templates
                              select="//front/article-meta/article-categories/series-title"/>
                    </xsl:element>
               </xsl:if>
               <xsl:element name="titles">
                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:if test="//front/article-meta/abstract[@abstract-type='teaser']/p">
                         <xsl:element name="standfirst">
                              <xsl:apply-templates
                                   select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                                   mode="flow"/>
                         </xsl:element>
                    </xsl:if>
               </xsl:element>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:for-each select="//body/sec">
                         <xsl:element name="sec"><xsl:apply-templates mode="flow"/></xsl:element>
                         <xsl:text>&#x0A;</xsl:text>
                    </xsl:for-each>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:call-template name="process-floats"/>
          </xsl:element>
     </xsl:template>
     
     <xsl:template name="process-choice">
          <xsl:variable name="id">
               <xsl:value-of
                    select="/article/front/article-meta/article-id[@pub-id-type='publisher-id']"/>
          </xsl:variable>
          <xsl:element name="article">
               <xsl:attribute name="id" select="$id"/>
               
               <xsl:element name="titles">
                    <xsl:apply-templates
                         select="//front/article-meta/article-categories/subj-group[@subj-group-type='heading']/subject"/>
<!--                    <xsl:text>&#x0A;</xsl:text>
-->                    <xsl:apply-templates select="//front/article-meta/title-group/article-title"/>
                    <xsl:apply-templates
                         select="//front/article-meta/abstract[@abstract-type='teaser']/p"
                         mode="flow"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="flow">
                    <xsl:apply-templates select="//article-meta/comment()"/>
                    <xsl:apply-templates select="//body" mode="flow"/>
                    <xsl:call-template name="lib-authors-model-analysis">
                         <xsl:with-param name="journal" select="$journal"/>
                         <xsl:with-param name="contrib-group">
                              <xsl:copy-of select="//article-meta/contrib-group"/>
                         </xsl:with-param>
                         <xsl:with-param name="author-notes">
                              <xsl:copy-of select="//article-meta/author-notes"/>
                         </xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates select="//front/article-meta/history" mode="flow"/>
                    <xsl:apply-templates select="//back/notes/fn-group/fn/p" mode="flow"/>
                    <xsl:apply-templates select="//back/ref-list"/>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:call-template name="add-citation-info"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:call-template name="process-floats"/>
               <xsl:text>&#x0A;</xsl:text>
          </xsl:element>
     </xsl:template>
     


     <xsl:template match="title-group//*" mode="#default">
          <xsl:variable name="myname">
               <xsl:choose>
                    <xsl:when test="$series-title-label!=''">
                         <xsl:value-of select="concat($series-title-label,'-',name(.))"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:value-of select="name(.)"/>
                    </xsl:otherwise>
               </xsl:choose>
          </xsl:variable>
          <xsl:choose>
               <xsl:when test="$art-section='careers' and $art-type='news'"/>
               <xsl:otherwise>
                    <xsl:text>&#x0A;</xsl:text>
               </xsl:otherwise>
          </xsl:choose>
          <xsl:element name="{$myname}">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>



     <xsl:template match="subj-group[@subj-group-type='heading']/*" mode="#default">
          <xsl:variable name="myname">
               <xsl:value-of select="concat(name(.),'-','heading')"/>
          </xsl:variable>
          <xsl:element name="{$myname}">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="series-title">
          <xsl:variable name="myname">
               <xsl:choose>
                    <xsl:when test="$series-title-label!=''">
                         <xsl:value-of select="concat($series-title-label,'-',name(.))"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:value-of select="name(.)"/>
                    </xsl:otherwise>
               </xsl:choose>
          </xsl:variable>
          <xsl:choose>
               <xsl:when
                    test="$art-section='careers' and ($series-title-label='NIB' or $series-title-label='LET')"/>
<!--               <xsl:when test="$art-section='observations'"/>-->
               <xsl:when test="$art-section='letters'"/>
               <xsl:otherwise>
                    <xsl:text>&#x0A;</xsl:text>
               </xsl:otherwise>
          </xsl:choose>

          <xsl:element name="{$myname}">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>

     <xsl:template match="date[@date-type='accepted']" mode="#all">
          <xsl:variable name="myname">
               <xsl:text>accepted</xsl:text>
          </xsl:variable>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="{$myname}">
               <xsl:text>Accepted: </xsl:text>
               <xsl:value-of select="day"/>
               <xsl:text> </xsl:text>
               <xsl:value-of select="month"/>
               <xsl:text> </xsl:text>
               <xsl:value-of select="year"/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="name" mode="column">
          <xsl:variable name="myname">
               <xsl:value-of select="$series-title-label"/>
               <xsl:text>-column-author</xsl:text>
          </xsl:variable>
          <xsl:choose>
               <xsl:when test="preceding::name">
                    <xsl:element name="{$myname}">
                         <xsl:text>, </xsl:text>
                    </xsl:element>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:element name="{$myname}">
                         <xsl:text> </xsl:text>
                    </xsl:element>
               </xsl:otherwise>
          </xsl:choose>
          <xsl:element name="{$myname}">
               <xsl:value-of select="given-names"/>
               <xsl:text> </xsl:text>
               <xsl:value-of select="surname"/>
               <xsl:if test="suffix">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="suffix"/>
               </xsl:if>
          </xsl:element>
     </xsl:template>

     <xsl:template match="name" mode="pv">
<!--          obsolete 2011?-->
          <xsl:variable name="myname">
               <xsl:text>PV-column-author</xsl:text>
          </xsl:variable>
          <xsl:choose>
               <xsl:when test="preceding::name">
                    <xsl:element name="{$myname}">
                         <xsl:text>, </xsl:text>
                    </xsl:element>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:element name="{$myname}">
                         <xsl:text> </xsl:text>
                    </xsl:element>
               </xsl:otherwise>
          </xsl:choose>

          <xsl:element name="{$myname}">
               <xsl:value-of select="given-names"/>
               <xsl:text> </xsl:text>
               <xsl:value-of select="surname"/>
               <xsl:if test="suffix">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="suffix"/>
               </xsl:if>
          </xsl:element>
     </xsl:template>
     <xsl:template match="name" mode="obs">
          <!--          obsolete 2011?-->
          <xsl:variable name="myname">
               <xsl:text>column-author</xsl:text>
          </xsl:variable>
          <xsl:choose>
               <xsl:when test="preceding::name">
                    <xsl:element name="{$myname}">
                         <xsl:text>, </xsl:text>
                    </xsl:element>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:element name="{$myname}">
                         <xsl:text> </xsl:text>
                    </xsl:element>
               </xsl:otherwise>
          </xsl:choose>

          <xsl:element name="{$myname}">
               <xsl:value-of select="given-names"/>
               <xsl:text> </xsl:text>
               <xsl:value-of select="surname"/>
               <xsl:if test="suffix">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="suffix"/>
               </xsl:if>
          </xsl:element>
     </xsl:template>


     <xsl:template match="article-meta/related-article" mode="#all">
          <xsl:variable name="myname">
               <xsl:text>article-meta-</xsl:text>
               <xsl:value-of select="name(.)"/>
          </xsl:variable>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="{$myname}">
               <xsl:apply-templates/>
          </xsl:element>
          <xsl:text>&#x2028;</xsl:text>
     </xsl:template>

     <xsl:template match="article-meta/article-id[@pub-id-type='doi']" mode="#all">
          <xsl:param name="run-on"/>
          <xsl:variable name="myname">
               <xsl:text>article-meta-doi</xsl:text>
          </xsl:variable>
          <xsl:choose>
               <xsl:when test="$run-on eq '1'">
                    <xsl:text> </xsl:text>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:text>&#x0A;</xsl:text>
               </xsl:otherwise>
          </xsl:choose>
          
          <xsl:element name="{$myname}">
               <xsl:text>doi: </xsl:text>
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     <xsl:template
          match="bold[matches(ancestor::article//article-title,'In brief','i') and (ancestor::article/@article-type='news')]"
          mode="#all">
          <xsl:variable name="myname">
               <xsl:text>IB-bold</xsl:text>
          </xsl:variable>
          <xsl:element name="{$myname}">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="bold[ancestor::notes[@notes-type='citation-text']]" mode="#all">
          <xsl:apply-templates/>
     </xsl:template>
     <xsl:template match="bold[ancestor::abstract[@abstract-type='teaser']]" mode="#all">
          <xsl:variable name="myname">
               <xsl:text>abstract-bold</xsl:text>
          </xsl:variable>
          <xsl:element name="{$myname}">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="bold[ancestor::abstract[not(@abstract-type ='teaser')]]" mode="#all">
          <xsl:variable name="myname">
               <xsl:value-of select="$series-title-label"/>
               <xsl:text>-abstract-bold</xsl:text>
          </xsl:variable>
          <xsl:element name="{$myname}">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="bold" mode="#all">
          <xsl:variable name="myname">
               <xsl:value-of select="name(.)"/>
          </xsl:variable>
          <xsl:element name="{$myname}">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="italic[parent::title[parent::sec]]" mode="#all">
          <xsl:variable name="myname">
               <xsl:choose>
                    <xsl:when test="$art-section='short-cuts'">
                         <xsl:text>italic-10</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:text>italic</xsl:text>
                    </xsl:otherwise>
               </xsl:choose>

          </xsl:variable>
          <xsl:element name="{$myname}">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="italic[ancestor::fn[ancestor::back]]" mode="#all">
          <xsl:variable name="myname">
               <xsl:choose>
                    <xsl:when test="$art-section='filler'">
                         <xsl:text>italic-10</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:text>italic</xsl:text>
                    </xsl:otherwise>
               </xsl:choose>

          </xsl:variable>
          <xsl:element name="{$myname}">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     <!--<xsl:template match="italic[ancestor::notes[@notes-type='citation-text']]" mode="#all">
          <xsl:variable name="myname">
                         <xsl:text>italic-10</xsl:text>
          </xsl:variable>
          <xsl:element name="{$myname}">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>-->
     <xsl:template match="sup|sub|italic|ext-link|year|source|volume|fpage" mode="#all">
          <xsl:variable name="myname">
               <xsl:value-of select="name(.)"/>
          </xsl:variable>
          <xsl:element name="{$myname}">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="xref[@ref-type='bibr']" mode="#all">
          <xsl:variable name="myname">
               <xsl:value-of select="name(.)"/>
          </xsl:variable>
          <xsl:variable name="myrid">
               <xsl:value-of select="@rid"/>
          </xsl:variable>
          <xsl:choose>
               <xsl:when test="$art-section='endgames'"/>
<!--               2011-11-07 Comment out this facility to embed refs as typesetter note + comment as redesign in progress
                                          I suspect that they will realise they don't want thyis facility suppressed for all of the views content-->
               <!--<xsl:when test="$art-section='views'">
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:element name="typesetter-note">
                         <xsl:text>[R</xsl:text>
                         <xsl:value-of select="substring-after(@rid,'ref')"/>
                         <xsl:text>]</xsl:text>
                         <xsl:comment>REF: <xsl:value-of select="//ref[@id=$myrid]/citation//text()"
                              /></xsl:comment>
                    </xsl:element>
               </xsl:when>-->
               <xsl:when
                    test="preceding-sibling::node()[2][@ref-type='bibr'] and preceding-sibling::node()[1][@ref-type='bibr'] and following-sibling::node()[1][@ref-type='bibr']"/>
               <xsl:when
                    test="preceding-sibling::node()[1][@ref-type='bibr'] and following-sibling::node()[1][@ref-type='bibr']">
                    <xsl:element name="{$myname}">
                         <xsl:text>&#x2011;</xsl:text>
                    </xsl:element>
               </xsl:when>
               <xsl:when
                    test="preceding-sibling::node()[2][@ref-type='bibr'] and (normalize-space(translate(preceding-sibling::text()[1],' ',''))='')">
                    <xsl:element name="{$myname}">
                         <xsl:text>&#xA0;</xsl:text>
                         <xsl:apply-templates/>
                    </xsl:element>
               </xsl:when>
               <xsl:when
                    test="preceding-sibling::node()[2][@ref-type='bibr'] and not(following-sibling::node()[1][@ref-type='bibr'])">
                    <xsl:element name="{$myname}">
                         <xsl:apply-templates/>
                    </xsl:element>
               </xsl:when>
               <xsl:when test="preceding-sibling::node()[1][@ref-type='bibr']">
                    <xsl:element name="{$myname}">
                         <xsl:text>&#xA0;</xsl:text>
                         <xsl:apply-templates/>
                    </xsl:element>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:element name="{$myname}">
                         <xsl:apply-templates/>
                    </xsl:element>
               </xsl:otherwise>
          </xsl:choose>

     </xsl:template>

     <!--<xsl:template match="table-wrap/label" mode="float">
          <xsl:variable name="myname">
               <xsl:if test="ancestor::*[1]">
                    <xsl:value-of select="name(ancestor::*[1])"/>
                    <xsl:text>-</xsl:text>
               </xsl:if>
               <xsl:value-of select="name(.)"/>
               <xsl:if test="not(preceding-sibling::*)">
                    <xsl:text>-1</xsl:text>
               </xsl:if>

          </xsl:variable>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="{$myname}">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>-->

     <xsl:template match="citation">
          <xsl:variable name="myname">
               <xsl:if test="ancestor::*[1]">
                    <xsl:value-of select="name(ancestor::*[1])"/>
                    <xsl:text>-</xsl:text>
               </xsl:if>
               <xsl:value-of select="name(.)"/>
               <xsl:if test="not(preceding::ref)">
                    <xsl:text>-1</xsl:text>
               </xsl:if>

          </xsl:variable>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="{$myname}">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>

     <xsl:template match="body//p|body//title[not(ancestor::boxed-text)]|back//p|front//p|corresp" mode="flow">
          <xsl:variable name="myname">
               <xsl:if test="$series-title-label!=''">
                    <xsl:value-of select="$series-title-label"/>
                    <xsl:text>-</xsl:text>
               </xsl:if>
               <xsl:choose>
                    <xsl:when test="parent::list-item">
                         <xsl:variable name="depth" select="count(ancestor::list)"/>
                         <xsl:variable name="list-type" select="ancestor::list[1]/@list-type"/>

                         <xsl:for-each select="ancestor::*[not(ancestor-or-self::list) and (name(.) !='article') and (name(.) !='sec')]">
                              <xsl:value-of select="name(.)"/>
                              <xsl:text>-</xsl:text>
                              <xsl:for-each select="@*">
                                   <xsl:choose>
                                        <xsl:when test="name(.)='list-type' and .='order'">
                                             <xsl:text>ordered-</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="name(.)='list-type' or name(.)='content-type'">
                                             <xsl:value-of select="."/>
                                             <xsl:text>-</xsl:text>
                                        </xsl:when>
                                   </xsl:choose>
                              </xsl:for-each>
                              
                         </xsl:for-each>
                         <xsl:value-of select="concat($list-type,'-list',$depth,'-')"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:for-each select="ancestor::*[(name(.) !='article')]">
                              <xsl:value-of select="name(.)"/>
                              <xsl:text>-</xsl:text>
                              <xsl:for-each select="@*">
                                   <xsl:choose>
                                        <xsl:when test="name(.)='list-type' and .='order'">
                                             <xsl:text>ordered-</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="name(.)='list-type' or name(.)='content-type'">
                                             <xsl:value-of select="."/>
                                             <xsl:text>-</xsl:text>
                                        </xsl:when>
                                   </xsl:choose>
                              </xsl:for-each>
                         </xsl:for-each>
                    </xsl:otherwise>
               </xsl:choose>

               <xsl:value-of select="name(.)"/>
               <xsl:if
                    test="not(preceding-sibling::*) or name(preceding-sibling::*[1])='title'
                    or (name(preceding-sibling::*[1])='fig' and $art-section='short-cuts')
                    or (name(preceding-sibling::*[1])='fig' and $art-section='research-news')
                    or (name(preceding-sibling::*[1])='fig' and $art-section='views')
                    or (name(preceding-sibling::*[1])='fig' and $art-section='obituaries')or (preceding-sibling::p[1]/citation and $art-section='short-cuts') or (preceding-sibling::p[1]/citation and $art-section='research-news')">
                    <xsl:text>-1</xsl:text>
               </xsl:if>
          </xsl:variable>
          <!--<xsl:comment>DEBUG-template 1 - flow with prefix</xsl:comment>-->
          <xsl:choose>
               <xsl:when test="$art-section='endgames' and local-name()='title' and parent::sec[parent::body] and matches(./text(),'Questions')">
                    <!--<xsl:comment>DEBUG: 2011-11-07: suppress questions heading for endgames</xsl:comment>-->
               </xsl:when>
               <xsl:otherwise>
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:element name="{$myname}">
                         <xsl:apply-templates mode="#current"/>
                    </xsl:element>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>


     <!--<xsl:template match="boxed-text//p" mode="float">
          <xsl:variable name="myname">
               <xsl:if test="$series-title-label!=''">
                    <xsl:value-of select="$series-title-label"/>
                    <xsl:text>-</xsl:text>
               </xsl:if>
               <xsl:for-each select="ancestor::*[ancestor::boxed-text]">
                    <xsl:value-of select="name(.)"/>
                    <xsl:text>-</xsl:text>
                    <xsl:for-each select="@*">
                         <xsl:if test="name(.)='list-type' or name(.)='content-type'">
                              <xsl:value-of select="."/>
                              <xsl:text>-</xsl:text>
                         </xsl:if>
                    </xsl:for-each>
               </xsl:for-each>
               
               <xsl:value-of select="name(.)"/>
               <xsl:if test="not(preceding-sibling::*) or name(preceding-sibling::*[1])='title'">
                    <xsl:text>-1</xsl:text>
               </xsl:if>
          </xsl:variable>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="{$myname}">
               <xsl:apply-templates mode="#current"/>
          </xsl:element>
     </xsl:template>-->

     <xsl:template
          match="body//title[not(ancestor::boxed-text)]|
                       back//p|
                       front//p"
          mode="float">
<!--          paras that require section prefixes-->
          <xsl:variable name="myancestors"
               select="count(ancestor::*[ancestor::boxed-text or ancestor::fig or ancestor::disp-quote or ancestor::table-wrap])+1"/>
          <xsl:variable name="myname">
               <xsl:if test="$series-title-label!=''">
                    <xsl:value-of select="$series-title-label"/>
                    <xsl:text>-</xsl:text>
               </xsl:if>
               <xsl:value-of select="name(ancestor::*[$myancestors])"/>
               <xsl:text>-</xsl:text>
               <xsl:for-each select="ancestor::*[$myancestors]/@*">
                    <xsl:choose>
                         <xsl:when test="name(.)='list-type' and .='order'">
                              <xsl:text>ordered-</xsl:text>
                         </xsl:when>
                         <xsl:when test="name(.)='list-type' or name(.)='content-type'">
                              <xsl:value-of select="."/>
                              <xsl:text>-</xsl:text>
                         </xsl:when>
                    </xsl:choose>
<!--                    <xsl:if test="name(.)='list-type' or name(.)='content-type'">
                         <xsl:value-of select="."/>
                         <xsl:text>-</xsl:text>
                    </xsl:if>
-->               </xsl:for-each>
               <xsl:for-each
                    select="ancestor::*[ancestor::boxed-text or ancestor::fig or ancestor::disp-quote or ancestor::table-wrap and (name(.) !='article')]">
                    <xsl:value-of select="name(.)"/>
                    <xsl:text>-</xsl:text>
                    <xsl:for-each select="@*">
                         <xsl:choose>
                              <xsl:when test="name(.)='list-type' and .='order'">
                                   <xsl:text>ordered-</xsl:text>
                              </xsl:when>
                              <xsl:when test="name(.)='list-type' or name(.)='content-type'">
                                   <xsl:value-of select="."/>
                                   <xsl:text>-</xsl:text>
                              </xsl:when>
                         </xsl:choose>
                         <!--<xsl:if test="name(.)='list-type' or name(.)='content-type'">
                              <xsl:value-of select="."/>
                              <xsl:text>-</xsl:text>
                         </xsl:if>-->
                    </xsl:for-each>
               </xsl:for-each>

               <xsl:value-of select="name(.)"/>
               <xsl:if test="not(preceding-sibling::*) or name(preceding-sibling::*[1])='title'">
                    <xsl:text>-1</xsl:text>
               </xsl:if>
          </xsl:variable>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="{$myname}">
               <!--<xsl:comment>DEBUG-template 2 [req prefix]</xsl:comment>-->
    
               
<!--               <xsl:call-template name="add-label-to-caption"/>-->
               <xsl:apply-templates mode="#current"/>
          </xsl:element>
     </xsl:template>
     
     <xsl:template
          match="body//fig//p|
                    body//fig//attrib|
                    body//table-wrap//p|
                    body//boxed-text//p|
                    body//boxed-text//title|
                    body//disp-quote[@content-type='style3']//p"
          mode="float">
          <!--          paragraphs that do not require section prefixes-->
          
          <xsl:variable name="myancestors"
               select="count(ancestor::*[ancestor::boxed-text or ancestor::fig or ancestor::disp-quote or ancestor::table-wrap])+1"/>
          <xsl:variable name="mylistancestors"
               select="count(ancestor-or-self::list)"/>
          <xsl:variable name="myname">
               <xsl:value-of select="name(ancestor::*[$myancestors])"/>
               <xsl:text>-</xsl:text>
               <xsl:choose>
                    <xsl:when test="parent::list-item">
                         <xsl:variable name="depth" select="count(ancestor::list)"/>
                         <xsl:variable name="list-type" select="ancestor::list[1]/@list-type"/>
                         
<!--                         <xsl:for-each select="ancestor::*[not(ancestor-or-self::list) and (name(.) !='article') and (name(.) !='sec')]">-->
                         <xsl:for-each select="ancestor::*[ancestor::boxed-text or ancestor::fig or ancestor::disp-quote or ancestor::table-wrap and name(.) !='article']">
                               <xsl:choose>
                                    <xsl:when test="matches(name(.),'list|list-item|sec')"/>
                                    <xsl:otherwise>
                                         <xsl:value-of select="name(.)"/>
                                         <xsl:text>-</xsl:text>
                                         <xsl:for-each select="@*">
                                              <xsl:choose>
                                                   <xsl:when test="name(.)='list-type' and .='order'">
                                                        <xsl:text>ordered-</xsl:text>
                                                   </xsl:when>
                                                   <xsl:when test="name(.)='list-type' or name(.)='content-type'">
                                                        <xsl:value-of select="."/>
                                                        <xsl:text>-</xsl:text>
                                                   </xsl:when>
                                              </xsl:choose>
                                         </xsl:for-each>
                                    </xsl:otherwise>
                               </xsl:choose>
                              
                              
                         </xsl:for-each>
                         <xsl:value-of select="concat($list-type,'-list',$depth,'-')"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:for-each select="ancestor::*[$myancestors]/@*">
                              <xsl:choose>
                                   <xsl:when test="name(.)='list-type' and .='order'">
                                        <xsl:text>ordered-</xsl:text>
                                   </xsl:when>
                                   <xsl:when test="name(.)='list-type' or name(.)='content-type'">
                                        <xsl:value-of select="."/>
                                        <xsl:text>-</xsl:text>
                                   </xsl:when>
                              </xsl:choose>
               </xsl:for-each>
                         <xsl:for-each
                              select="ancestor::*[ancestor::boxed-text or ancestor::fig or ancestor::disp-quote or ancestor::table-wrap and (name(.) !='article')]">
                              <xsl:value-of select="name(.)"/>
                              <xsl:text>-</xsl:text>
                              <xsl:for-each select="@*">
                                   <xsl:choose>
                                        <xsl:when test="name(.)='list-type' and .='order'">
                                             <xsl:text>ordered-</xsl:text>
                                        </xsl:when>
                                        <xsl:when test="name(.)='list-type' or name(.)='content-type'">
                                             <xsl:value-of select="."/>
                                             <xsl:text>-</xsl:text>
                                        </xsl:when>
                                   </xsl:choose>
                                   <!--<xsl:if test="name(.)='list-type' or name(.)='content-type'">
                                        <xsl:value-of select="."/>
                                        <xsl:text>-</xsl:text>
                                        </xsl:if>-->
                              </xsl:for-each>
                         </xsl:for-each>
                    </xsl:otherwise>
               </xsl:choose>
               
               
               
               
               
               <xsl:value-of select="name(.)"/>
               <xsl:if test="not(preceding-sibling::*) or name(preceding-sibling::*[1])='title'">
                    <xsl:text>-1</xsl:text>
               </xsl:if>
          </xsl:variable>
          
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="{$myname}">
               <xsl:choose>
                    <xsl:when test="position()=1 and parent::caption[parent::*[child::label]] and $journal='bmj'">
                         <xsl:apply-templates select="../../label" mode="#current"/>
                         <xsl:text>&#x2009;|&#x2009;</xsl:text>
                         <xsl:value-of select="replace(./text()[1],'^\p{Zs}','')"></xsl:value-of>
                         <xsl:apply-templates select="node()[position() !=1]" mode="#current"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:apply-templates mode="#current"/>
                    </xsl:otherwise>
               </xsl:choose>
          </xsl:element>
     </xsl:template>
     
     
     
     
     




     <xsl:template
          match="sec|bio|body|front|back|caption|boxed-text|list|list-item|fn-group|fn|ref-list|ref|table-wrap-foot|notes">
          <xsl:apply-templates/>
     </xsl:template>

     <xsl:template match="boxed-text|disp-quote[@content-type='style3']" mode="float">
          <xsl:variable name="myname" select="name(.)"/>
          <xsl:variable name="count" select="count(preceding::*[name(.)=$myname]) + 1"/>
          <!--<xsl:call-template name="add-paragraph-return"/>-->
          <xsl:element name="{$myname}">
               <xsl:attribute name="id">
                    <xsl:choose>
                         <xsl:when test="@id">
                              <xsl:value-of select="@id"/>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:value-of select="concat($myname,'-',$count)"/>
                         </xsl:otherwise>
                    </xsl:choose>
               </xsl:attribute>
               <xsl:apply-templates mode="#current"/>
          </xsl:element>
     </xsl:template>
     
     <xsl:template match="attrib" mode="#all">
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="quote-ref">
               <xsl:apply-templates mode="#current"/>
          </xsl:element>
     </xsl:template>

     <xsl:template match="fig" mode="float">
          <xsl:variable name="myname" select="name(.)"/>
          <xsl:variable name="count" select="count(preceding::*[name(.)=$myname]) + 1"/>
          <xsl:element name="{$myname}">
               <xsl:attribute name="id">
                    <xsl:choose>
                         <xsl:when test="@id">
                              <xsl:value-of select="@id"/>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:value-of select="concat($myname,'-',$count)"/>
                         </xsl:otherwise>
                    </xsl:choose>
               </xsl:attribute>
               <xsl:apply-templates select="graphic" mode="#current"/>
               <xsl:apply-templates select="label|caption|attrib" mode="#current"/>
          </xsl:element>
     </xsl:template>

     <xsl:template match="graphic" mode="float">
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="typesetter-note">
               <xsl:text>USE GRAPHIC </xsl:text>
               <xsl:value-of select="@xlink:href"/>
          </xsl:element>
     </xsl:template>

     <xsl:template match="citation" mode="scuts">
          <xsl:variable name="myname" select="concat($series-title-label,'-ref-citation')"/>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="{$myname}">
               <xsl:apply-templates mode="flow"/>
          </xsl:element>
     </xsl:template>

     <xsl:template match="disp-quote[@content-type='style3']" mode="flow"/>

     <xsl:template match="boxed-text" mode="flow">
          <xsl:variable name="myname" select="name(.)"/>
          <xsl:variable name="count" select="count(preceding::*[name(.)=$myname]) + 1"/>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="typesetter-note">
               <xsl:text>PLACE </xsl:text>
               <xsl:value-of select="concat($myname,'-',$count)"/>
               <xsl:text> NEAR HERE</xsl:text>
          </xsl:element>
     </xsl:template>

     <xsl:template match="table-wrap" mode="flow">
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="typesetter-note">
               <xsl:text>PLACE TABLE </xsl:text>
               <xsl:choose>
                    <xsl:when test="label">
                         <xsl:value-of select="label"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:value-of select="@id"/>
                    </xsl:otherwise>
               </xsl:choose>
               <xsl:text> NEAR HERE</xsl:text>
          </xsl:element>
     </xsl:template>
     <xsl:template match="table-wrap" mode="float">
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="table-wrap">
               <xsl:attribute name="id" select="@id"/>
               <xsl:apply-templates select="caption|table|table-wrap-foot" mode="#current"/>
          </xsl:element>
     </xsl:template>

     <xsl:template match="fig" mode="flow">
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="typesetter-note">
               <xsl:choose>
                    <xsl:when test="$art-section='minerva'">
                         <xsl:text>PLACE </xsl:text>
                         <xsl:for-each select=".//graphic">
                              <xsl:value-of select="@xlink:href"/>
                              <xsl:text> </xsl:text>
                         </xsl:for-each>
                         <xsl:text>HERE</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:text>PLACE </xsl:text>
                         <xsl:for-each select=".//graphic">
                              <xsl:value-of select="@xlink:href"/>
                              <xsl:text> </xsl:text>
                         </xsl:for-each>
                         <xsl:text>NEAR HERE</xsl:text>
                    </xsl:otherwise>
               </xsl:choose>
          </xsl:element>
     </xsl:template>
     <xsl:template match="citation//year" mode="#all">
          <xsl:if test="name(preceding-sibling::node()[1])='source'">
               <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:copy-of select="." copy-namespaces="no"/>
     </xsl:template>

     <xsl:template match="ref/label"/>
     <xsl:template match="table-wrap/label"/>

     <!--Pick up box label in BMJ articles to insert dividing character-->
     <xsl:template match="text()[parent::title[parent::sec[parent::boxed-text]]]" mode="float">
          <xsl:choose>
               <xsl:when test="matches(.,'^Box\s\d+') and $journal='bmj'">
                    <xsl:value-of select="replace(.,'(^Box\s\d+)\p{Zs}?(.*)','$1&#x2009;|&#x2009;$2')"/>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:value-of select="."/>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>
     
     <xsl:template match="text()[ancestor::sec/title/text()[matches(.,'research questions', 'i')]]" mode="#all">
                 <xsl:value-of select="replace(.,'(^XXX|^\d+)\s+(.*)','$1&#09;$2')"/>
     </xsl:template>


     <xsl:template match="fig/caption/p[1]/bold[1][not(preceding-sibling::node())]" mode="float">
          <xsl:choose>
               <xsl:when test="matches(./text()[1],'^Fig(\w+)?\s\d+')  and $journal='bmj'">
                    <xsl:value-of select="replace(./text()[1],'(^Fig(\w+)?\s\d+)\p{Zs}?(.*)','$1&#x2009;|&#x2009;$2')"/>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:element name="bold">
                         <xsl:apply-templates mode="#current"/>
                    </xsl:element>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>

<xsl:template match="notes[@notes-type='editorial-note']" mode="float">
     <xsl:element name="links">
          <xsl:apply-templates mode="#current"/>
     </xsl:element>
</xsl:template>
     <!--suppress real space between xrefs, see xref matches for inserrtion of non-breaking space-->
     <xsl:template
          match="text()[(normalize-space(translate(.,' ',''))='')
          and preceding-sibling::node()[1][@ref-type='bibr']
          and following-sibling::node()[1][@ref-type='bibr']]"
          mode="#all"> </xsl:template>
     
     



     <xsl:template match="*">
          <xsl:variable name="myname">
               <xsl:if test="$series-title-label!=''">
                    <xsl:value-of select="$series-title-label"/>
                    <xsl:text>-</xsl:text>
               </xsl:if>
               <!--<xsl:text>no-match</xsl:text>-->

               <xsl:for-each select="ancestor::element()">
                    <xsl:value-of select="name(.)"/>
                    <xsl:text>-</xsl:text>
                    <xsl:for-each select="@*">
                         <xsl:choose>
                              <xsl:when test="name(.)='list-type' and .='order'">
                                   <xsl:text>ordered-</xsl:text>
                              </xsl:when>
                              <xsl:when test="name(.)='list-type' or name(.)='content-type'">
                                   <xsl:value-of select="."/>
                                   <xsl:text>-</xsl:text>
                              </xsl:when>
                         </xsl:choose>
                         <!--<xsl:if test="name(.)='list-type'">
                              <xsl:value-of select="."/>
                         </xsl:if>-->
                    </xsl:for-each>
               </xsl:for-each>
               <xsl:value-of select="name(.)"/>
          </xsl:variable>
          <xsl:element name="{$myname}">
               <xsl:apply-templates mode="#current"/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="article-meta/related-article/text()">
          <xsl:choose>
               <xsl:when test="matches(.,'doi:\s*\S+')">
                    <xsl:comment>
                         <xsl:value-of select="."/>
                    </xsl:comment>
                    <xsl:value-of select="replace(.,'doi:\s*\S+','p 0000')"/>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:value-of select="."/>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>
     <xsl:template match="p/related-article" mode="#all">
          <xsl:choose>
               <xsl:when test="matches(preceding::node()[1],'\(doi:')">
                    <xsl:element name="inline-typesetter-note">
                         <xsl:apply-templates/>
                    </xsl:element>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:apply-templates/>
               </xsl:otherwise>
          </xsl:choose>
          
     </xsl:template>


     <xsl:template match="p/related-article/text()">
          <xsl:choose>
               <xsl:when test="$art-section='choice' and matches(.,'10.1136\S+') and matches(preceding::node()[1],'\(doi:')">
                    <xsl:comment>
                         <xsl:value-of select="."/>
                    </xsl:comment>
                    <xsl:value-of select="replace(.,'\S+','p 0000')"/>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:value-of select="."/>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>
     <xsl:template match="p/text()" mode="#all">
          <xsl:choose>
               <xsl:when test="$art-section='choice' and matches(.,'\(doi:')">
                    <xsl:value-of select="replace(.,'(.*?)(\()doi:(\s*)','$1$2$3')"/>
               </xsl:when>
               <xsl:when test="$art-section='endgames' 
                    and ancestor::sec[@id='answer']
                    and parent::p[parent::sec[matches(title,'Answer$','i')][1]] 
                    and count(preceding-sibling::text()) = 0">
                    <xsl:variable name="q-number" select="replace(ancestor::sec[2]/title,'(^\d+).*$','$1','i')"/>
                    <xsl:value-of select="concat($q-number, ' ')"/>
                    <xsl:value-of select="."/>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:value-of select="."/>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>
<!--MATCHES FOR LINKS TEXT-->
     
     <xsl:template match="title[parent::notes[@notes-type='editorial-note']]" mode="float">
          <xsl:comment select="concat('Links: ',.)"/>
     </xsl:template>
     <xsl:template match="sec[ancestor::notes[@notes-type='editorial-note']]/title" mode="float">
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="links-head">
               <xsl:apply-templates mode="#current"/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="list[ancestor::notes[@notes-type='editorial-note']]/list-item[count(preceding-sibling::list-item)=0]/p[1]" mode="float">
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="links-list-1">
               <xsl:apply-templates mode="#current"/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="list[ancestor::notes[@notes-type='editorial-note']]/list-item[count(preceding-sibling::list-item) &gt; 0]/p" mode="float">
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="links-list">
               <xsl:apply-templates mode="#current"/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="p[parent::sec[ancestor::notes[@notes-type='editorial-note']]]" mode="float">
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="links-para">
               <xsl:apply-templates mode="#current"/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="ext-link[ancestor::notes[@notes-type='editorial-note']]" mode="float">
               <xsl:apply-templates mode="#current"/>
     </xsl:template>
     


     <!--<xsl:apply-templates
          select="//back/notes/fn-group/fn[matches(.//p/text(),'Provenance and peer review')]/p"/>-->

     <xsl:template
          match="text()[ancestor::article/@article-type='product-review' and ancestor::fn/@fn-type='other' and matches(.,'Rating:')]"
          mode="flow">
          <xsl:variable name="slength"
               select="string-length(normalize-space(substring-after(., 'Rating:')))"/>
          <xsl:variable name="neededstars" select="4-$slength"/>
          <xsl:message>I got a <xsl:value-of select="$slength"/> stars </xsl:message>
          <xsl:message>I need <xsl:value-of select="$neededstars"/> white stars </xsl:message>

          <xsl:value-of select="replace(.,'\*','&lt;redstar&gt;*&lt;/redstar&gt;')"
               disable-output-escaping="yes"/>
          <xsl:message>I got these <xsl:value-of select="count(matches(.,'\*'))"/></xsl:message>
          <xsl:call-template name="addstar">
               <xsl:with-param name="starcount" select="$neededstars"/>
          </xsl:call-template>
     </xsl:template>

     <xsl:template name="addstar">
          <xsl:param name="starcount"/>
          <xsl:message>starcount is <xsl:value-of select="$starcount"/></xsl:message>
          <xsl:choose>
               <xsl:when test="$starcount > 0">
                    <xsl:element name="whitestar">
                         <xsl:text>*</xsl:text>
                    </xsl:element>
                    <xsl:call-template name="addstar">
                         <xsl:with-param name="starcount" select="$starcount - 1"/>
                    </xsl:call-template>
               </xsl:when>
          </xsl:choose>
     </xsl:template>
     <xsl:template name="add-citation-info">
          <xsl:element name="citation-info">
               <xsl:choose>
                    <xsl:when test="//back/notes[@notes-type='citation-text']/p">
                         <xsl:copy-of
                              select="normalize-space(//back/notes[@notes-type='citation-text']/p/text()[1])"/>
                         <xsl:text> </xsl:text>
                         <xsl:apply-templates
                              select="//back/notes[@notes-type='citation-text']/p/italic"/>
                         <xsl:value-of
                              select="//back/notes[@notes-type='citation-text']/p/text()[last()]"/>
                         <!--                         <xsl:apply-templates select="//back/notes[@notes-type='citation-text']/p" mode="#current"/>
-->
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:text>Cite this as: </xsl:text>
                         <xsl:element name="italic">
                              <xsl:value-of
                                   select="/article/front/journal-meta/journal-id[@journal-id-type='nlm-ta']"
                              />
                         </xsl:element>
                         <xsl:text> </xsl:text>
                         <xsl:value-of select="/article/front/article-meta/pub-date/year"/>
                         <xsl:text>;</xsl:text>
                         <xsl:choose>
                              <xsl:when test="string-length(normalize-space(/article/front/article-meta/volume)) !=0">
                                   <xsl:value-of select="/article/front/article-meta/volume"/>
                              </xsl:when>
                              <xsl:otherwise>
                                   <xsl:text>[VOLNO]</xsl:text>
                              </xsl:otherwise>
                         </xsl:choose>
                         <xsl:text>:</xsl:text>
                         <xsl:choose>
                              <xsl:when test="/article/front/article-meta/elocation-id">
                                   <xsl:value-of select="/article/front/article-meta/elocation-id"/>
                              </xsl:when>
                              <xsl:otherwise>
                                   <xsl:text>ERROR NEED ELOCATION ID</xsl:text>
                              </xsl:otherwise>
                         </xsl:choose>


                    </xsl:otherwise>
               </xsl:choose>


          </xsl:element>
     </xsl:template>

     <xsl:template name="add-paragraph-return">
          <xsl:if test="preceding-sibling::*">
               <xsl:text>&#x0A;</xsl:text>
          </xsl:if>
     </xsl:template>

     <xsl:template name="add-line-break">
          <xsl:text>&#x2028;</xsl:text>
     </xsl:template>

     <xsl:template name="process-floats">
          <xsl:if test="//disp-quote[@content-type='style3']|//fig|//table-wrap|//boxed-text|//notes[@notes-type='editorial-note']">
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="floats">
                    <xsl:apply-templates select="//disp-quote[@content-type='style3']" mode="float"/>
                    <xsl:apply-templates select="//boxed-text" mode="float"/>
                    <xsl:apply-templates select="//fig" mode="float"/>
                    <xsl:apply-templates select="//table-wrap" mode="float"/>
                    <xsl:if test="//notes[@notes-type='editorial-note']">
                         <xsl:element name="links">
                              <xsl:apply-templates select="//notes[@notes-type='editorial-note']/*" mode="float"/>
                         </xsl:element>
                    </xsl:if>
               </xsl:element>
          </xsl:if>
     </xsl:template>
     <xsl:template name="process-floats-in-context">
          <xsl:param name="context"/>
          <xsl:if test="$context//disp-quote[@content-type='style3']|$context//fig|$context//table-wrap|$context//boxed-text">
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="floats">
                    <xsl:apply-templates select="$context//disp-quote[@content-type='style3']" mode="float"/>
                    <xsl:apply-templates select="$context//boxed-text" mode="float"/>
                    <xsl:apply-templates select="$context//fig" mode="float"/>
                    <xsl:apply-templates select="$context//table-wrap" mode="float"/>
               </xsl:element>
          </xsl:if>
     </xsl:template>

     <xsl:template name="add-label-to-caption">
          <!--     Test from inside paragraph of caption-->
          <xsl:choose>
               <xsl:when test="position()=1 and parent::caption[parent::*[child::label]] and $journal='bmj'">
                    <xsl:apply-templates select="../../label" mode="#current"/>
                    <xsl:text>&#x2009;|&#x2009;</xsl:text>
                    <xsl:value-of select="replace(./text()[1],'^\p{Zs}','')"></xsl:value-of>
               </xsl:when>
               <xsl:otherwise/>
          </xsl:choose>


     </xsl:template>
     
     <xsl:template name="add-ref-placeholder-text">
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="refs-on-web">
               <xsl:copy-of select="$ref-placeholder-text"/>
          </xsl:element>
     </xsl:template>

</xsl:stylesheet>

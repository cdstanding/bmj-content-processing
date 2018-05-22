<?xml version="1.0" encoding="utf-8"?>
<!-- ============================================================= -->
<!--  MODULE:    set-opener-body-back-1-0.xsl                      -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      September 2004                                    -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:     Archiving and Interchange DTD Suite               -->
<!--             Journal Article Formatting                        -->
<!--                                                               -->
<!-- PURPOSE:    A module of article-fo.xsl that structures        -->
<!--             the main flow of the article content: article     -->
<!--             opening, body, and back; and handleds the         -->
<!--             article-opener.                                   -->
<!--                                                               -->
<!-- CONTAINS:   1) Named template: set-article-opener             -->
<!--             2) Named template: set-article-body               -->
<!--             3) Named template: set-article-back               -->
<!--             The remaining templates in this module are all in -->
<!--             support of the article opener:                    -->
<!--             4) article title                                  -->
<!--             5) contributors                                   -->
<!--             6) Named template: set-copyright-note             -->
<!--             7) Mode: copyright-note                           -->
<!--             8) Named template: set-correspondence-note        -->
<!--             9) Mode: correspondence-note                      -->
<!--            10) Named template: set-affiliation-note           -->
<!--            11) Mode: affiliation-number                       -->
<!--            12) affiliation                                    -->
<!--            13) Suppress source affiliation numbering          -->
<!--            14) abstract                                       -->
<!--            15) Elements processed in no-mode                  -->
<!--            16) Elements suppressed in no-mode                 -->
<!--                                                               -->
<!-- CREATED FOR:                                                  -->
<!--             Digital Archive of Journal Articles               -->
<!--             National Center for Biotechnology Information     -->
<!--                (NCBI)                                         -->
<!--             National Library of Medicine (NLM)                -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             September 2004                                    -->
<!--                                                               -->
<!-- CREATED BY: Kate Hamilton (Mulberry Technologies, Inc.)       -->
<!--             Deborah Lapeyre (Mulberry Technologies, Inc.)     -->
<!--                                                               -->
<!--             Suggestions for refinements and enhancements to   -->
<!--             this stylesheet suite should be sent in email to: -->
<!--                 publishing-dtd@ncbi.nlm.nih.gov               -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                    VERSION/CHANGE HISTORY                     -->
<!-- ============================================================= -->
<!--
     =============================================================

No.  Reason/Occasion                       (who) vx.x (yyyymmdd)

     =============================================================
 1.  Original version                            v1.0  20040823    
                                                                   -->
                                                                     
<!-- ============================================================= -->
<!--                    XSL STYLESHEET INVOCATION                  -->
<!-- ============================================================= -->

<xsl:stylesheet version="2.0" xmlns:fo="http://www.w3.org/1999/XSL/Format"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
     xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:m="http://dtd.nlm.nih.gov/xsl/util"
     extension-element-prefixes="m">


     <!-- ============================================================= -->
     <!-- NAMED TEMPLATE: SET-ARTICLE-OPENER (NO MODE)                  -->
     <!-- ============================================================= -->


     <!-- Publication order of article-meta notes:
        - copyright note, unnumbered
        - corresponding author (0 or more, in 1 block, unnumbered)
        - affiliations (0 or more), the note unnumbered but with 
          internal alpha numbering linking aff to contrib.
        - author-notes/fn (0 or more), marked with daggers.
  -->

     <xsl:template name="set-article-opener">
          <fo:block span="all">
               <!-- change context node -->
               <!-- a rule before the title article body -->
               <fo:block space-after="2pt" border-bottom-style="solid"
                    border-bottom-width="0.25pt"
                    margin-left="{$mainindent}pc" margin-right="{$mainindent}pc"/>

               <xsl:for-each select="/article/front/article-meta">
                    <!--               <xsl:call-template name="set-copyright-note"/>
               <xsl:call-template name="set-correspondence-note"/>
-->
                    <xsl:if test="article-categories/series-title">
                         <xsl:apply-templates select="article-categories/series-title"/>
                    </xsl:if>
                    <xsl:apply-templates select="title-group/article-title"/>
                    <xsl:if test="//front/article-meta/permissions/license[matches(@license-type,'open-access','i')]">
                         <xsl:call-template name="add-open-access-logo"/>
                    </xsl:if>
                    <xsl:apply-templates select="abstract[@abstract-type='teaser']"/>
                    <xsl:apply-templates select="contrib-group"/>
                    <xsl:call-template name="set-affiliations-note"/>
                    <!--<xsl:apply-templates select="abstract[@abstract-type !='teaser']|abstract[not(@abstract-type)]"/>-->
                    <xsl:call-template name="set-correspondence-note"/>
               </xsl:for-each>
               <xsl:if test="not(/article/front/article-meta/contrib-group)">
                    <fo:block space-before="20pt" span="all"/>
               </xsl:if>

               <!--<fo:block span="all" space-before="12pt"/>-->
          </fo:block>
          <!--     set any front footnotes as notes at the start of the article-->
          <xsl:if test="front/notes or back/notes[matches(@notes-type,'data-supplement')]">
               <!--          Need to do something different with data-supplement front notes and highlight videos on front page-->
               <fo:block>
                    <fo:footnote>
                         <fo:inline/>
                         <fo:footnote-body>
                              <xsl:apply-templates
                                   select="front/notes[not(matches(@notes-type,'data-supplement'))]"
                              />
                              <xsl:choose>
                    <xsl:when
                         test="//notes[matches(@notes-type,'data-supplement')]">
                         <xsl:variable name="web-root-url" select="'http://www.bmj.com'"/>
                         <xsl:variable name="data-supp-url"
                              select="concat($web-root-url,'/content/',front/article-meta/volume,'/bmj.',front/article-meta/elocation-id,'?tab=related#datasupp')"/>
                              <xsl:if test="//notes[matches(@notes-type,'data-supplement')]">
                                        <fo:block font-size="{$fnsize}pt"
                                             line-height="{$fnleading}pt" background-color="#E6F7FD"
                                             padding="3pt">
                                             <fo:block margin-bottom="3pt">
                                                  <fo:inline color="#1A4354">
                                                       <xsl:choose>
                                                       <xsl:when test="string-length(//notes[matches(@notes-type,'data-supplement')][1]/title[last()]/text()[last()]) !=0">
                                                                 <xsl:apply-templates
                                                                 select="//notes[matches(@notes-type,'data-supplement')][1]/title/text()"
                                                            />
                                                       </xsl:when>
                                                       <xsl:otherwise>
                                                            <xsl:text>Data supplements on bmj.com</xsl:text>
                                                       </xsl:otherwise>
                                                       </xsl:choose>
                                                       <xsl:text> (see </xsl:text>
                                                       <fo:basic-link
                                                            external-destination="url({$data-supp-url})">
                                                            <xsl:value-of select="$data-supp-url"/>
                                                       </fo:basic-link>
                                                       <xsl:text>)</xsl:text>
                                                  </fo:inline>
                                             </fo:block>
                                                  <fo:block>
                                                       
                                                                           <xsl:for-each select="//supplementary-material[parent::notes[matches(@notes-type,'data-supplement')]]">
                                                                                          <xsl:if
                                                                                               test="string-length(caption[1]/p[1]) !=0">
                                                                                               <xsl:comment>test2</xsl:comment>
                                                                                               <xsl:apply-templates
                                                                                                    select="caption/p"
                                                                                               />
                                                                                          </xsl:if>
                                                                           </xsl:for-each>
                                                       
                                                  </fo:block>     
                                        </fo:block>
          </xsl:if>

                    </xsl:when>
                    <xsl:otherwise/>
               </xsl:choose>

</fo:footnote-body>
</fo:footnote>
               </fo:block>
               
          </xsl:if>



     </xsl:template>


     <!-- ============================================================= -->
     <!-- NAMED TEMPLATE: SET-ARTICLE-BODY (NO MODE)                    -->
     <!-- ============================================================= -->


     <xsl:template name="set-article-body">

          <fo:block space-before="0pt" space-after="0pt" start-indent="{$mainindent}pc">

               <!-- This fo:wrapper establishes the default text setting
         for the entire article/body. -->
               <fo:wrapper font-family="{$textfont}" font-size="{$textsize}pt"
                    line-height="{$textleading}pt" font-style="normal" font-weight="normal"
                    text-align="start">
                    <xsl:apply-templates
                         select="/article/front/article-meta/abstract[@abstract-type !='teaser']
                                     | /article/front/article-meta/abstract[not(@abstract-type)]"/>
                    <xsl:apply-templates select="/article/body"/>
               </fo:wrapper>

          </fo:block>
     </xsl:template>


     <!-- ============================================================= -->
     <!-- NAMED TEMPLATE: SET-ARTICLE-BACK (NO MODE)                    -->
     <!-- ============================================================= -->


     <xsl:template name="set-article-back">

          <!-- This fo:block and fo:wrapper establishes the default 
         text setting for the entire backmatter. -->

          <fo:block space-before="0pt" space-after="0pt" start-indent="0pc">

               <fo:wrapper font-family="{$textfont}" font-size="{$textsize}pt"
                    line-height="{$textleading}pt" font-style="normal" font-weight="normal"
                    text-align="start">

                    <xsl:apply-templates select="/article/back"/>

               </fo:wrapper>

          </fo:block>
     </xsl:template>

     <xsl:template name="set-article-back-tables-figs">

          <!-- This fo:block and fo:wrapper establishes the default 
               text setting for the entire backmatter. -->

          <fo:block space-before="0pt" space-after="0pt" start-indent="0pc">

               <fo:wrapper font-family="{$textfont}" font-size="{$textsize}pt"
                    line-height="{$textleading}pt" font-style="normal" font-weight="normal"
                    text-align="start">

                    <!--<xsl:if test="//supplementary-material[media[@mimetype='video']]">
                         <xsl:variable name="fig-count" select="count(//fig)"/>
                         <xsl:variable name="vid-string">
                              <xsl:text>Video</xsl:text>
                         </xsl:variable>
                         <fo:block break-before="column">
                              <fo:block space-after="{$space-below-tables-figures}"
                                   font-family="{$titlefont}"
                                   font-size="{$textsize}*1.5pt"
                                   font-weight="bold"
                                   line-height="17pt">
                                   <xsl:copy-of select="$vid-string"/>
                              </fo:block>
                              <xsl:for-each select="/article//supplementary-material[media[@mimetype='video']]">
                                   <xsl:apply-templates select="." mode="put-at-end"/>
                              </xsl:for-each>
                         </fo:block>
                    </xsl:if>-->
                    <xsl:if test="//table-wrap">
                         <xsl:variable name="table-count" select="count(//table-wrap)"/>
                         <xsl:variable name="table-string">
                              <xsl:choose>
                                   <xsl:when test="$table-count &gt; 1">
                                        <xsl:text>Tables</xsl:text>
                                   </xsl:when>
                                   <xsl:otherwise>
                                        <xsl:text>Table</xsl:text>
                                   </xsl:otherwise>
                              </xsl:choose>
                         </xsl:variable>

                         <fo:block break-before="page">
                              <fo:block space-after="{$space-below-tables-figures}"
                                   font-family="{$titlefont}" font-size="{$textsize}*1.5pt"
                                   font-weight="bold" line-height="17pt">
                                   <xsl:copy-of select="$table-string"/>
                              </fo:block>
                              <xsl:for-each select="/article//table-wrap">
                                   <xsl:apply-templates select="." mode="put-at-end"/>
                              </xsl:for-each>
                         </fo:block>
                    </xsl:if>

                    <xsl:if test="//fig[not(matches(@fig-type,'lead|theme|equation|fixed','i')) and 
                         not(matches(/article/front/article-meta/article-categories/subj-group[@subj-group-type='heading']/subject,'Editorial|Endgames|Observation|Obituar|Short Cuts|Research News|Minerva|Views &amp; Reviews','i'))]">
                         <xsl:variable name="fig-count" select="count(//fig[not(matches(@fig-type,'lead|theme|equation|fixed','i'))])"/>
                         <xsl:variable name="fig-string">
                              <xsl:choose>
                                   <xsl:when test="$fig-count &gt; 1">
                                        <xsl:text>Figures</xsl:text>
                                   </xsl:when>
                                   <xsl:otherwise>
                                        <xsl:text>Figure</xsl:text>
                                   </xsl:otherwise>
                              </xsl:choose>
                         </xsl:variable>
                         <fo:block break-before="page">
                              <fo:block space-after="{$space-below-tables-figures}"
                                   font-family="{$titlefont}" font-size="{$textsize}*1.5pt"
                                   font-weight="bold" line-height="17pt">
                                   <xsl:copy-of select="$fig-string"/>
                              </fo:block>
                              <xsl:for-each select="/article//fig[not(matches(@fig-type,'lead|theme|equation|fixed','i'))]">
                                   <xsl:apply-templates select="." mode="put-at-end"/>
                              </xsl:for-each>
                         </fo:block>
                    </xsl:if>



               </fo:wrapper>

          </fo:block>
     </xsl:template>


     <!-- ============================================================= -->
     <!-- THE REST IS ALL SUPPORT FOR SET-ARTICLE-OPENER                -->
     <!-- ============================================================= -->



     <!-- ============================================================= -->
     <!-- ARTICLE TITLE on ARTICLE FIRST PAGE                           -->
     <!-- ============================================================= -->


     <xsl:template match="/article/front/article-meta/title-group/article-title">
          <fo:block space-before="0pt" line-stacking-strategy="font-height"
               font-family="{$titlefont}" font-size="19pt" line-height="21pt" font-weight="bold"
               font-stretch="normal">
               <xsl:apply-templates/>
          </fo:block>
     </xsl:template>


     <!-- ============================================================= -->
     <!-- ARTICLE CONTRIBUTOR  GROUP                                         -->
     <!-- ============================================================= -->
     <xsl:template match="/article/front/article-meta/contrib-group">

          <fo:block line-height="{$textleading}pt" text-align="left"
               start-indent="{$mainindent}pc" space-before="18pt" space-after="10pt"
               font-stretch="normal" font-family="{$titlefont}">
               <xsl:apply-templates select="contrib"/>
               <xsl:if test="on-behalf-of">
                    <xsl:apply-templates select="on-behalf-of"/>
               </xsl:if>
               
          </fo:block>

     </xsl:template>
     <!-- ============================================================= -->
     <!-- ARTICLE CONTRIBUTOR                                           -->
     <!-- ============================================================= -->


     <xsl:template match="/article/front/article-meta/contrib-group/contrib">

          <fo:inline>
               <fo:wrapper font-style="normal" font-size="{$textsize*1.2}pt"
                    font-family="{$titlefont}">

                    <xsl:if test="preceding-sibling::contrib">
                         <xsl:text>, </xsl:text>
                    </xsl:if>
                    <!-- probably it's a name, but perhaps it's a collab.
           Assumes that a contrib contains EITHER one name
           OR one collab. -->

                    <!-- change context for convenience -->
                    <!-- set the name -->
                    <xsl:for-each select="name | collab">


                         <xsl:if test="given-names">
                              <xsl:apply-templates select="given-names" mode="pass-through"/>
                              <xsl:text> </xsl:text>
                         </xsl:if>

                         <xsl:apply-templates select="surname" mode="pass-through"/>

                         <xsl:if test="suffix">
                              <xsl:text> </xsl:text>
                              <xsl:apply-templates select="suffix" mode="pass-through"/>
                         </xsl:if>

                         <xsl:if test="matches(local-name(.),'collab','i')">
                              <xsl:apply-templates  mode="pass-through"/>
                         </xsl:if>
                         
                    </xsl:for-each>

                    <!-- Now the role. -->
                    <!-- There are three pieces of role information: role,
           @contrib-type, and on-behalf-of. The xsl:choose expresses
           the preferences for which information to use. -->

                    <xsl:choose>


                         <!-- if we have an on-behalf-of with a role -->
                         <xsl:when test="role and on-behalf-of">
                              <xsl:text> [</xsl:text>
                              <xsl:apply-templates select="role" mode="pass-through"/>
                              <xsl:text> on behalf of </xsl:text>
                              <xsl:apply-templates select="on-behalf-of" mode="pass-through"/>
                              <xsl:text>]</xsl:text>
                              <xsl:choose>
                                   <xsl:when
                                        test="$affiliations-have-xrefs and xref[@ref-type='aff']">
                                        <xsl:apply-templates select="xref[@ref-type='aff']"
                                             mode="affiliation-number"/>
                                   </xsl:when>
                                   <xsl:when test="aff">
                                        <xsl:apply-templates select="aff" mode="affiliation-number"
                                        />
                                   </xsl:when>
                                   <xsl:otherwise/>
                              </xsl:choose>
                         </xsl:when>

                         <!-- if an on-behalf-of with an @contrib-type that's not an author -->
                         <xsl:when test="on-behalf-of and not(@contrib-type='author')">
                              <xsl:text> [</xsl:text>
                              <xsl:value-of select="@contrib-type"/>
                              <xsl:text> on behalf of </xsl:text>
                              <xsl:apply-templates select="on-behalf-of" mode="pass-through"/>
                              <xsl:text>]</xsl:text>
                              <xsl:choose>
                                   <xsl:when
                                        test="$affiliations-have-xrefs and xref[@ref-type='aff']">
                                        <xsl:apply-templates select="xref[@ref-type='aff']"
                                             mode="affiliation-number"/>
                                   </xsl:when>
                                   <xsl:when test="aff">
                                        <xsl:apply-templates select="aff" mode="affiliation-number"
                                        />
                                   </xsl:when>
                                   <xsl:otherwise/>
                              </xsl:choose>
                         </xsl:when>

                         <!-- if there's one role -->
                         <xsl:when test="count(role) = 1">
                              <xsl:text> </xsl:text>
                                   <fo:wrapper font-style="italic">
                                        <xsl:apply-templates select="role" mode="pass-through"/>
                                   </fo:wrapper>
                                   <xsl:choose>
                                        <xsl:when
                                             test="$affiliations-have-xrefs and xref[@ref-type='aff']">
                                             <xsl:apply-templates select="xref[@ref-type='aff']"
                                                  mode="affiliation-number"/>
                                        </xsl:when>
                                        <xsl:when test="aff">
                                             <xsl:apply-templates select="aff" mode="affiliation-number"
                                             />
                                        </xsl:when>
                                        <xsl:otherwise/>
                                   </xsl:choose>
                              
                         </xsl:when>
                         <!-- if there's multiple roles -->
                         <xsl:when test="count(role) &gt;1">
                              <xsl:for-each select="role">
                                   <xsl:text> </xsl:text>
                                   <fo:wrapper font-style="italic">
                                        <xsl:apply-templates mode="pass-through"/>
                                   </fo:wrapper>
                                   <xsl:choose>
                                        <xsl:when
                                             test="$affiliations-have-xrefs and following-sibling::xref[@ref-type='aff'][1]">
                                             <xsl:apply-templates select="following-sibling::xref[@ref-type='aff'][1]"
                                                  mode="affiliation-number"/>
                                        </xsl:when>
                                        <xsl:otherwise/>
                                   </xsl:choose>
                              </xsl:for-each>
                         </xsl:when>

                         <!-- if there's an @contrib-type -->
                         <xsl:when test="@contrib-type[not('author')]">
                              <xsl:text> [</xsl:text>
                              <xsl:value-of select="@contrib-type"/>
                              <xsl:text>]</xsl:text>
                         </xsl:when>

                         <!-- if there's an on-behalf of (but no @contrib-type or role) -->
                         <xsl:when test="on-behalf-of">
                              <xsl:text> [on behalf of </xsl:text>
                              <xsl:apply-templates select="on-behalf-of" mode="pass-through"/>
                              <xsl:text>]</xsl:text>
                              <xsl:choose>
                                   <xsl:when
                                        test="$affiliations-have-xrefs and xref[@ref-type='aff']">
                                        <xsl:apply-templates select="xref[@ref-type='aff']"
                                             mode="affiliation-number"/>
                                   </xsl:when>
                                   <xsl:when test="aff">
                                        <xsl:apply-templates select="aff" mode="affiliation-number"
                                        />
                                   </xsl:when>
                                   <xsl:otherwise/>
                              </xsl:choose>
                         </xsl:when>
                         <xsl:when test="$affiliations-have-xrefs and xref[@ref-type='aff']">
                              <xsl:apply-templates select="xref[@ref-type='aff']"
                                   mode="affiliation-number"/>
                         </xsl:when>
                         <xsl:when test="aff">
                              <xsl:apply-templates select="aff" mode="affiliation-number"/>
                         </xsl:when>

                    </xsl:choose>



               </fo:wrapper>

               <!-- Finally set an affiliation reference, if any,
           using xref or aff as appropriate -->



          </fo:inline>

     </xsl:template>


     <!-- ============================================================= -->
     <!-- CONTRIBUTOR GROUP LEVEL ON_BEHALF OF                                           -->
     <!-- ============================================================= -->
     <xsl:template match="/article/front/article-meta/contrib-group/on-behalf-of">
          <xsl:comment>processing on-behalf-of no mode</xsl:comment>
          <fo:inline>
               <fo:wrapper font-style="normal" font-size="{$textsize*1.2}pt"
                    font-family="{$titlefont}">
                    <xsl:text>, </xsl:text>
                    <xsl:apply-templates/>
               </fo:wrapper>
               </fo:inline>
     </xsl:template>
     
     <!-- ============================================================= -->
     <!-- NAMED TEMPLATE: SET-COPYRIGHT-NOTE (MODE copyright-note)      -->
     <!-- ============================================================= -->


     <xsl:template name="set-copyright-note">

          <!-- This note is set as a first-page footnote, 
       and has no number or other device. -->

          <!-- An fo:footnote-body which has no number or other device
       needs a block immediately surrounding it, to
       anchor it to the currently-setting page; otherwise, 
       it slides through to the last page. -->

          <!-- context node is /article/front/article-meta -->

          <xsl:if test="copyright-statement | copyright-year">

               <fo:block space-before="0pt" space-after="0pt">

                    <!-- put out the note -->
                    <fo:footnote>
                         <fo:inline>&#x200B;</fo:inline>
                         <fo:footnote-body>
                              <fo:block line-height="{$fnleading}pt" space-before="0pt"
                                   space-after="{$leading-below-fn}">
                                   <fo:wrapper font-size="{$fnsize}pt">
                                        <xsl:for-each select="copyright-statement">
                                             <xsl:apply-templates mode="copyright-note"/>
                                        </xsl:for-each>

                                        <xsl:if test="not(copyright-statement)">
                                             <xsl:apply-templates select="copyright-year"
                                                  mode="copyright-note"/>
                                        </xsl:if>
                                   </fo:wrapper>
                              </fo:block>
                         </fo:footnote-body>
                    </fo:footnote>

               </fo:block>
          </xsl:if>

     </xsl:template>


     <!-- ============================================================= -->
     <!-- MODE: COPYRIGHT-NOTE                                          -->
     <!-- ============================================================= -->


     <xsl:template mode="copyright-note" match="copyright-statement | copyright-year">
          <xsl:apply-templates/>
     </xsl:template>


     <!-- ============================================================= -->
     <!-- NAMED TEMPLATE: SET-CORRESPONDENCE-NOTE                       -->
     <!-- ============================================================= -->


     <!-- This is set as a first-page footnote, unnumbered.
       Usually there is only 1 corresponding author; if there is 
       more than one, they're all set in this one note. -->

     <!-- context node is article-meta -->
     <xsl:template name="set-correspondence-note">

          <xsl:if test="contrib-group/contrib[@corresp='yes']|//author-notes/corresp">
               <fo:block space-before="0pt" space-after="0pt">
                    <fo:footnote>
                         <fo:inline>&#x200B;</fo:inline>

                         <fo:footnote-body>

                              <fo:block line-height="{$fnleading}pt" space-before="0pt"
                                   space-after="{$leading-below-fn}">
                                   <fo:wrapper font-size="{$fnsize}pt">

                                        <xsl:apply-templates select="//author-notes/corresp"/>

                                        <!--<xsl:for-each select="contrib-group/contrib[@corresp='yes']">

                    <xsl:if test="not(preceding-sibling::contrib[@corresp='yes'])">
                      <xsl:text>Correspondence to: </xsl:text>
                    </xsl:if>

                    <xsl:apply-templates select="name | collab" mode="correspondence-note"/>
                    
                    <xsl:choose>
                      <xsl:when test="email">
                        <xsl:text>, </xsl:text>
                        <fo:wrapper font-family="monospace">
                          <xsl:apply-templates select="email" mode="correspondence-note"/>
                        </fo:wrapper>
                      </xsl:when>
                         <xsl:when test="//author-notes/corresp/email">
                              <xsl:text>, </xsl:text>
                              <fo:wrapper font-family="monospace">
                                   <xsl:apply-templates select="email" mode="correspondence-note"/>
                              </fo:wrapper>
                         </xsl:when>
                      <xsl:when test="address">
                        <xsl:text>, </xsl:text>
                        <xsl:apply-templates select="address" mode="correspondence-note"/>
                      </xsl:when>
                    </xsl:choose>

                    <xsl:choose>
                      <xsl:when test="not(following-sibling::contrib[@corresp='yes'])">
                        <xsl:text>.</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>; </xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>

                  </xsl:for-each>-->

                                   </fo:wrapper>

                              </fo:block>
                         </fo:footnote-body>
                    </fo:footnote>
               </fo:block>
          </xsl:if>

     </xsl:template>


     <!-- ============================================================= -->
     <!-- MODE: CORRESPONDENCE-NOTE                                     -->
     <!-- ============================================================= -->


     <xsl:template mode="correspondence-note"
          match="collab | email | address | given-names | surname | suffix">
          <xsl:apply-templates/>
     </xsl:template>


     <xsl:template mode="correspondence-note" match="name">

          <xsl:if test="given-names">
               <xsl:apply-templates select="given-names" mode="correspondence-note"/>
               <xsl:text> </xsl:text>
          </xsl:if>

          <xsl:apply-templates select="surname" mode="correspondence-note"/>

          <xsl:if test="suffix">
               <xsl:text>, </xsl:text>
               <xsl:apply-templates select="suffix" mode="correspondence-note"/>
          </xsl:if>

     </xsl:template>



     <!-- ============================================================= -->
     <!-- NAMED TEMPLATE: SET-AFFILIATIONS-NOTE                         -->
     <!-- ============================================================= -->


     <!-- This is set as a first-page footnote. "Active" affiliations
     (either xref'd or inside contrib, whichever is the style) 
     are set here in a single note, each uniquely distinguished 
     within the note (and on the contrib) by an alpha superscript. -->


     <xsl:variable name="affiliations-have-xrefs"
          select="boolean(/article/front/article-meta//xref[ancestor::article-meta][@ref-type='aff'])"/>

     <xsl:key name="aff-refs" match="xref[ancestor::article-meta][@ref-type='aff']" use="@rid"/>


     <xsl:template name="set-affiliations-note">

          <xsl:param name="the-key" select="concat('aff', '-refs')"/>
          <xsl:message>xref-affils is set to <xsl:value-of select="$affiliations-have-xrefs"/> with
               key as <xsl:value-of select="$the-key"/>
          </xsl:message>

          <xsl:if test="$affiliations-have-xrefs or /article/front/article-meta//aff">

               <fo:block space-after="10pt">

                    <fo:block line-height="{$fnleading}pt" space-before="3pt" space-after="2pt"
                         padding-top="3pt" font-stretch="normal" font-family="{$titlefont}">

                         <!--border-top-width="0.25pt"
                  border-top-style="solid"
             -->

                         <fo:block font-size="{$fnsize}pt">


                              <!-- set the affiliations encountered in document order -->
                              <xsl:for-each select="/article/front/article-meta//aff">
                                   <xsl:apply-templates select="." mode="affiliation-number"/>
                                   <xsl:apply-templates/>
                              </xsl:for-each>
                         </fo:block>
                    </fo:block>
               </fo:block>

          </xsl:if>

     </xsl:template>


     <!-- ============================================================= -->
     <!-- MODE: AFFILIATION-NUMBER                                      -->
     <!-- ============================================================= -->

     <xsl:template mode="affiliation-number" match="xref[@ref-type='aff']" priority="1">

          <xsl:if test="(count(//article/front/article-meta//aff) > 1)">
               <fo:inline baseline-shift="55%" font-size="55%">
                    <!--               narrow non-break space-->
                    <xsl:text>&#x202F;</xsl:text>
                    <xsl:value-of select="."/>
               </fo:inline>
          </xsl:if>

     </xsl:template>


     <xsl:template mode="affiliation-number" match="aff">

          <xsl:if
               test="(count(//article/front/article-meta//aff) > 1) or ($affiliations-have-xrefs and (count(//article/front/article-meta//aff) > 1))">
               <xsl:if test="preceding-sibling::aff">
                    <xsl:text>; </xsl:text>
               </xsl:if>
               <fo:inline baseline-shift="35%" font-size="{$fnsize - 3}pt">
                    <!--<xsl:number count="article-meta//aff" 
                 level="any" 
                 from="/" 
                 format="a"/>-->
                    <xsl:value-of select="label"/>
               </fo:inline>
          </xsl:if>


     </xsl:template>


     <!-- ============================================================= -->
     <!-- AFFILIATION AND ITS CONTENT IN NO-MODE                        -->
     <!-- ============================================================= -->

     <xsl:template match="aff">
          <xsl:apply-templates/>
     </xsl:template>

     <xsl:template match="aff/institution | aff/addr-line | aff/country">

          <xsl:apply-templates/>
          <xsl:choose>
               <xsl:when test="not(following-sibling::*)">
                    <xsl:text>.</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:text>, </xsl:text>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>


     <!-- ============================================================= -->
     <!-- SUPPRESS SOURCE DOCUMENT'S AFFILIATION NUMBERING              -->
     <!-- ============================================================= -->


     <!-- can't rely on the original numbers being accurate
     for this design's numbering scheme, so suppress them
     insofar as we can identify them. -->

     <xsl:template match="aff/child::node()[1][self::bold] |aff/label"/>


     <!-- ============================================================= -->
     <!-- ARTICLE ABSTRACT                                              -->
     <!-- ============================================================= -->


     <xsl:template match="article-meta/abstract[not(@abstract-type='toc')]">
          <fo:block font-family="{$titlefont}" space-after="{$leading-below-titles-big}">
               <fo:block space-after="{$leading-below-titles-small}"
                    line-height="{$textleading*0.8}pt">
                    <fo:wrapper font-family="{$titlefont}" font-size="{$textsize}pt" font-weight="bold">
                         <xsl:text>Abstract</xsl:text>
                    </fo:wrapper>
               </fo:block>
               <fo:block font-size="{$textsize*0.8}pt">
                    <xsl:apply-templates/>
               </fo:block>
          </fo:block>
          
     </xsl:template>


     <!-- ============================================================= -->
     <!-- ARTICLE ABSTRACT TEASER                                              -->
     <!-- ============================================================= -->


     <xsl:template match="article-meta/abstract[@abstract-type='teaser']">

          <fo:block space-before="4pt" font-size="{$textsize*1.2}pt"
               space-after="{$leading-below-titles-small}" line-height="{$textsize*1.2 + 1.5}pt">
               <fo:block margin-left="0pc" margin-right="0pc">
                    <xsl:apply-templates/>
               </fo:block>
          </fo:block>


     </xsl:template>




     <!-- ============================================================= -->
     <!-- ELEMENTS PROCESSED SIMPLY IN NO-MODE                          -->
     <!-- ============================================================= -->

     <!-- These elements are listed here only to help a developer 
     be sure of what's happening. -->

     <!-- journal meta -->
     <xsl:template
          match="journal-meta/abbrev-journal-title
                   | journal-meta/journal-title
                   | journal-meta/issn
                   | journal-meta/publisher/publisher-name
                   | journal-meta/publisher/publisher-loc
                   | article-meta/copyright-statement
                   | article-meta/copyright-year">
          <xsl:apply-templates/>
     </xsl:template>

     <!-- article-meta -->
     <xsl:template
          match="article-meta/volume
                   | article-meta/issue
                   | article-meta/fpage
                   | article-meta/lpage
                   | article-meta/self-uri
                   | article-meta/article-id
                   | article/body
                   | article-meta/subj-group/subject">
          <xsl:apply-templates/>
     </xsl:template>


     <!-- ============================================================= -->
     <!-- ELEMENTS SUPPRESSED IN NO-MODE                                -->
     <!-- ============================================================= -->

     <!-- The content of these elements is suppressed when walking the
     document tree (though some elements -are- used by a mode in a 
     select, e.g., email for a corresponding contributor).         -->

     <xsl:template match="title-group/trans-title 
                   | title-group/alt-title"/>

     <xsl:template
          match="article-meta/ext-link
                   | article-meta/elocation-id
                   | article-meta/product
                   | article-meta/supplementary-material
                   | article-meta/trans-abstract
                   | article-meta/contract-num
                   | article-meta/contract-sponsor
                   | article-meta/counts
                   | article-meta/author-notes/label
                   | article-meta/author-notes/title"/>

     <!-- loose information in article-meta/contrib-group -->
     <xsl:template
          match="article-meta/contrib-group/address 
                   | article-meta/contrib-group/author-comment 
                   | article-meta/contrib-group/bio 
                   | article-meta/contrib-group/email 
                   | article-meta/contrib-group/ext-link 
                   | article-meta/contrib-group/role 
                   | article-meta/contrib-group/xref"/>

     <!-- unused information in (any) contrib -->
     <xsl:template
          match="contrib/address
                   | contrib/author-comment
                   | contrib/bio
                   | contrib/degrees
                   | contrib/email
                   | contrib/ext-link"/>

     <xsl:template match="alt-text | ext-link | long-desc"/>
<xsl:template name="add-open-access-logo">
     <fo:block space-before="6pt" font-family="{$titlefont}"
          font-size="{$textsize}pt">
          <fo:inline>
               <fo:basic-link  external-destination="url({//front/article-meta/permissions/license//ext-link[1]/@xlink:href})">
               <fo:external-graphic src="url({$cc-logo})"
                    width="auto" 
                    content-width="auto"
                    content-height="{$textleading}pt"/>
               <xsl:text> OPEN ACCESS</xsl:text>
               </fo:basic-link>
          </fo:inline>
          
     </fo:block>
</xsl:template>

</xsl:stylesheet>

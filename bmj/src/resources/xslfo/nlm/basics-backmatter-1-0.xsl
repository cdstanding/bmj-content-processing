<?xml version="1.0" encoding="utf-8"?>
<!-- ============================================================= -->
<!--  MODULE:    backmatter-1-0.xsl                                -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      September 2004                                    -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:     Archiving and Interchange DTD Suite               -->
<!--             Journal Article Formatting                        -->
<!--                                                               -->
<!-- PURPOSE:    A module of article-fo.xsl that handles the       -->
<!--             grouping components such as appendix and bio      -->
<!--             *in backmatter*. (Some of these elements, such    -->
<!--             as reflist, may also be used in the article body, -->
<!--             where their formatting may be different than in   -->
<!--             backmatter.)                                      -->
<!--                                                               -->
<!-- CONTAINS:   Templates for:                                    -->
<!--             1) Acknowledgements (ack)                         -->
<!--             2) Appendix Group and Appendix (app-group, app)   -->
<!--             3) Biography (bio)                                -->
<!--             4) Footnote Group (fn-group)                      -->
<!--             5) Glossary (glossary)                            -->
<!--             6) Notes (notes)                                  -->
<!--             7) Reference list (ref-list)                      -->
<!--             8) Section (of backmatter)                        -->
<!--             9) Article response and sub-article               -->
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


<xsl:stylesheet version="2.0"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:mml="http://www.w3.org/1998/Math/MathML">


<!-- ============================================================= -->
<!-- WHAT BACK CAN CONTAIN                                         -->
<!-- ============================================================= -->

<!-- back contains an optional title, not handled by this
     formatting, followed by any combination of:
     
     Acknowledgments <ack> 
     Appendix Matter <app-group> 
     Biography <bio> 
     Footnote Group <fn-group> 
     Glossary Elements List <glossary> 
     Notes <notes> 
     Reference List (Bibliographic Reference List) <ref-list> 
     Section <sec> 
     
     Each of these is treated as a top-level section within back,
     and formatted in the order encountered. -->


<!-- ============================================================= -->
<!-- BACK                                                          -->
<!-- ============================================================= -->


<xsl:template match="article/back">
  
     <xsl:apply-templates select="title|ack|app-group|bio|fn-group|glossary|notes[not(matches(@notes-type,'citation-text|editorial-note','i'))]|ref-list"/>
     <xsl:call-template name="add-pub-history"/>
     <xsl:apply-templates select="notes[@notes-type='citation-text']"/>
     <xsl:apply-templates select="notes[@notes-type='editorial-note']"/>
     <xsl:call-template name="add-copyright-statement-in-flow"/>

</xsl:template>


<!-- ============================================================= -->
<!-- BACK/ACK                                                      -->
<!-- ============================================================= -->


<!-- ack behaves like body section -->
<xsl:template match="back/ack">

  <xsl:param name="space-before" select="$leading-around-display-blocks"/>
  <xsl:param name="space-after"  select="'0pt'"/>

  <xsl:param name="title-string">
    <xsl:choose>
      <xsl:when test="title">
        <xsl:apply-templates select="title" mode="pass-through"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Acknowledgements</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <fo:block id="{@id}"
            space-before="{$space-before}" space-before.precedence="2"
            space-after="{$space-after}"    space-after.precedence="2">
    <xsl:call-template name="block-title-style-1">
      <xsl:with-param name="title-string" select="$title-string"/>
    </xsl:call-template>
    
    <xsl:apply-templates select="*[not(title)]"/>

  </fo:block>
  
</xsl:template>



<!-- ============================================================= -->
<!-- APP-GROUP AND APPENDIX                                        -->
<!-- ============================================================= -->


<!-- app-group titles not handled; assumes the relevant content
     is the contained apps. -->

<xsl:template match="back/app-group">

  <xsl:param name="space-before" select="$leading-around-display-blocks"/>
  <xsl:param name="space-after"  select="'0pt'"/>

  <fo:block id="{@id}">
    <xsl:apply-templates select="app"/>
  </fo:block>
  
</xsl:template>


<!-- app behaves like body section -->
<xsl:template match="app-group/app">

  <xsl:param name="space-before" select="$leading-around-display-blocks"/>
  <xsl:param name="space-after"  select="'0pt'"/>

  <xsl:param name="title-string">
    <xsl:choose>
      <xsl:when test="title">
        <xsl:apply-templates select="title" mode="pass-through"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Appendix</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <fo:block id="{@id}"
            space-before="{$space-before}" space-before.precedence="2"
            space-after="{$space-after}"    space-after.precedence="2">

    <xsl:call-template name="block-title-style-1">
      <xsl:with-param name="title-string" select="$title-string"/>
    </xsl:call-template>
    
    <xsl:apply-templates select="*[not(title)]"/>

  </fo:block>
  
</xsl:template>


<!-- ============================================================= -->
<!-- BACK/BIO                                                      -->
<!-- ============================================================= -->


<!-- bio behaves like a body section -->
<xsl:template match="back/bio">

  <xsl:param name="space-before" select="$leading-around-display-blocks"/>
  <xsl:param name="space-after"  select="'0pt'"/>

  <xsl:param name="title-string">
    <xsl:choose>
      <xsl:when test="title">
        <xsl:apply-templates select="title" mode="pass-through"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Biography</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <fo:block id="{@id}"
            space-before="{$space-before}" space-before.precedence="2"
            space-after="{$space-after}"    space-after.precedence="2">

    <xsl:call-template name="block-title-style-1">
      <xsl:with-param name="title-string" select="$title-string"/>
    </xsl:call-template>
    
    <xsl:apply-templates select="*[not(title)]"/>
    
  </fo:block>
</xsl:template>


<!-- ============================================================= -->
<!-- BACK/FN-GROUP                                                 -->
<!-- ============================================================= -->


<!-- Footnotes are displayed on the page where they are
     referenced, or if xrefs are not used in the document
     then they are displayed on the body page where they 
     appear. They are not put out in the back-matter. -->
     
<xsl:template match="back/fn-group"/>


<!-- ============================================================= -->
<!-- BACK/GLOSSARY                                                 -->
<!-- ============================================================= -->


<!-- back/glossary behaves like a body section -->
<xsl:template match="back/glossary">

  <xsl:param name="space-before" select="$leading-around-display-blocks"/>
  <xsl:param name="space-after"  select="'0pt'"/>

  <xsl:param name="title-string">
    <xsl:choose>
      <xsl:when test="title">
        <xsl:apply-templates select="title" mode="pass-through"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Glossary</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <fo:block id="{@id}"
            space-before="{$space-before}" space-before.precedence="2"
            space-after="{$space-after}"    space-after.precedence="2">

    <xsl:call-template name="block-title-style-1">
      <xsl:with-param name="title-string" select="$title-string"/>
    </xsl:call-template>
    
    <xsl:apply-templates select="*[not(title)]"/>

  </fo:block>
  
</xsl:template>



<!-- ============================================================= -->
<!-- BACK/NOTES                                                    -->
<!-- ============================================================= -->


<!-- back/notes behaves like a body section -->
<xsl:template match="back/notes">

  <xsl:param name="space-before" select="$leading-around-display-blocks"/>
  <xsl:param name="space-after"  select="'0pt'"/>

  <xsl:param name="title-string">
    <xsl:choose>
      <xsl:when test="title">
        <xsl:apply-templates select="title" mode="pass-through"/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:param>

  <fo:block id="{@id}"
            space-before="{$space-before}" space-before.precedence="2"
            space-after="{$space-after}"    space-after.precedence="2">

    <xsl:if test="title">
         <xsl:comment>FOUND NOTES THAT ARE NOT CITATION TEXT</xsl:comment>
         <xsl:call-template name="block-title-style-1">
              <xsl:with-param name="title-string" select="$title-string"/>
         </xsl:call-template>
    </xsl:if>
       <xsl:comment>SHOULD BE PROCESSING *NOT(TITLE)</xsl:comment>
       
    
       <xsl:apply-templates select="*[not(ancestor-or-self::title)]"/>

  </fo:block>
  
</xsl:template>
<!--  suppress expression of data supps in back matter, these are processed on front page-->
  <xsl:template match="notes[ancestor::back][@notes-type='data-supplement']"/>
    

     <xsl:template match="back/notes[@notes-type='citation-text']">
          
          <xsl:param name="space-before" select="$leading-around-display-blocks"/>
          <xsl:param name="space-after"  select="'0pt'"/>
          
          <xsl:param name="title-string">
               <xsl:choose>
                    <xsl:when test="title">
                         <xsl:apply-templates select="title" mode="pass-through"/>
                    </xsl:when>
                    <xsl:otherwise/>
               </xsl:choose>
          </xsl:param>
          
          <fo:block id="{@id}"
               space-before="{$space-before}" space-before.precedence="2"
               space-after="{$space-after}"    space-after.precedence="2"
               font-family="{$titlefont}"
               font-size="{$fnsize}pt"
               color="#5586E9">
               <xsl:comment>FOUND CITATION TEXT</xsl:comment>
               
               <xsl:if test="title">
                    <xsl:call-template name="block-title-style-1">
                         <xsl:with-param name="title-string" select="$title-string"/>
                    </xsl:call-template>
               </xsl:if>
               
               
               <xsl:apply-templates select="*[not(title)]"/>
               
          </fo:block>
          
     </xsl:template>
     


<!-- ============================================================= -->
<!-- BACK/REF-LIST                                                 -->
<!-- ============================================================= -->

<!-- A ref-list in back behaves the same as anywhere else.
     See the module for ref-list.                                  -->


<!-- ============================================================= -->
<!-- BACK/SEC                                                      -->
<!-- ============================================================= -->


<!-- back/sec behaves like a body section.
     Title is required by DTD. -->
<xsl:template match="back/sec | back/notes/sec">

  <xsl:param name="space-before" select="$leading-around-display-blocks"/>
  <xsl:param name="space-after"  select="'0pt'"/>

  <fo:block id="{@id}"
            space-before="{$space-before}" space-before.precedence="2"
            space-after="{$space-after}"    space-after.precedence="2">
<xsl:comment>PROCESSING BACK NOTES SEC OR BACK SEC</xsl:comment>
    <xsl:apply-templates/>
  </fo:block>
  
</xsl:template>


<!-- ============================================================= -->
<!-- RESPONSE AND SUB-ARTICLE                                      -->
<!-- ============================================================= -->

<!-- The present formatting does not handle article responses
     and sub-articles (both of which follow article/back). -->

<xsl:template match="article/response | article/subarticle"/>


<!-- ============================================================= -->
<!-- SUPPRESS TITLES OF BACKMATTER COMPONENTS                      -->
<!-- ============================================================= -->

<!-- These titles if present are all passed to 
     the named template block-title-styles-1 
     in mode="pass-through"                                        -->

<xsl:template match="back/ack/title
                   | back/app/title
                   | back/bio/title
                   | back/glossary/title
                   | back/notes/title"
              priority="1"/>

<xsl:template name="add-pub-history">
     <xsl:if test="//article-meta/history/date[@date-type='accepted']">
          <fo:block 
               space-before="3pt" space-before.precedence="2"
               space-after="0pt"    space-after.precedence="2"
               font-family="{$titlefont}"
               font-size="{$fnsize}pt" 
               font-style="normal" font-weight="normal">
               <fo:inline font-weight="bold">
                    <xsl:text>Accepted: </xsl:text>
               </fo:inline>
               <xsl:value-of select="//article-meta/history/date[@date-type='accepted'][1]/day"/>
               <xsl:text> </xsl:text>
               <xsl:value-of select="//article-meta/history/date[@date-type='accepted'][1]/month"/>
               <xsl:text> </xsl:text>
               <xsl:value-of select="//article-meta/history/date[@date-type='accepted'][1]/year"/>
          </fo:block>
          
     </xsl:if>
</xsl:template>
     <xsl:template name="add-copyright-statement-in-flow">
          <fo:block 
               space-before="3pt" space-before.precedence="2"
               space-after="0pt"    space-after.precedence="2"
               font-family="{$titlefont}"
               font-size="{$fnsize}*0.8pt" 
               font-style="normal"
               line-height="{$fnleading}pt"
               font-weight="normal">
               <xsl:choose>
                    <xsl:when test="//front/article-meta/permissions/license[@license-type='open-access']">
                      <xsl:apply-templates select="//front/article-meta/permissions/copyright-statement"/>
                      <xsl:apply-templates select="//front/article-meta/permissions/license[@license-type='open-access']"/>
                    </xsl:when>
                    <xsl:otherwise>
                              <xsl:apply-templates select="//front/article-meta/permissions/copyright-statement"/>
                    </xsl:otherwise>
               </xsl:choose>
          </fo:block>
          
          
     </xsl:template>
</xsl:stylesheet>
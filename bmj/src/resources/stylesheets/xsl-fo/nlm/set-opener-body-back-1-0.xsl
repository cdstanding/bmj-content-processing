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

<xsl:transform version="1.0"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:m="http://dtd.nlm.nih.gov/xsl/util"
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

  <!-- change context node -->
  <xsl:for-each select="/article/front/article-meta"> 
 
    <xsl:call-template name="set-copyright-note"/>
    <xsl:call-template name="set-correspondence-note"/>
    <xsl:call-template name="set-affiliations-note"/>

    <xsl:apply-templates select="title-group/article-title"/>
    <xsl:apply-templates select="contrib-group/contrib"/>
    <xsl:apply-templates select="abstract[not(@abstract-type='toc')]"/>
    
    <!-- then a rule before the article body -->
    <fo:block space-before="8pt"
              border-bottom-style="solid"
              border-bottom-width="0.5pt"
              margin-left="{$mainindent}pc"
              margin-right="{$mainindent}pc"/>

  </xsl:for-each>
  

</xsl:template>


<!-- ============================================================= -->
<!-- NAMED TEMPLATE: SET-ARTICLE-BODY (NO MODE)                    -->
<!-- ============================================================= -->


<xsl:template name="set-article-body">

  <fo:block space-before="0pt"
            space-after="0pt"
            start-indent="{$mainindent}pc">
            
    <!-- This fo:wrapper establishes the default text setting
         for the entire article/body. -->
    <fo:wrapper
            font-family="{$textfont}"
            font-size="{$textsize}pt"
            line-height="{$textleading}pt"
            font-style="normal"
            font-weight="normal"
            text-align="start">
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

  <fo:block space-before="0pt"
            space-after="0pt"
            start-indent="0pc">
            
    <fo:wrapper
            font-family="{$textfont}"
            font-size="{$textsize}pt"
            line-height="{$textleading}pt"
            font-style="normal"
            font-weight="normal"
            text-align="start">
            
       <xsl:apply-templates select="/article/back"/>
       
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


  <fo:block space-before="12pt"
            space-after="12pt"
            line-height="19pt">
    <fo:wrapper font-family="{$titlefont}"
                font-size="14pt"
                font-weight="bold">
      <xsl:apply-templates/>
    </fo:wrapper>
  </fo:block>
  
</xsl:template>


<!-- ============================================================= -->
<!-- ARTICLE CONTRIBUTOR                                           -->
<!-- ============================================================= -->


<xsl:template match="/article/front/article-meta/contrib-group/contrib">

  <fo:block line-height="{$textleading}pt"
            text-align="right"
            start-indent="{$mainindent}pc"
            space-after="2pt" >
    <fo:wrapper font-style="italic"
                font-size="{$textsize}pt"
                font-family="{$textfont}">

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
      
        <xsl:apply-templates select="collab" mode="pass-through"/>
        
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
        </xsl:when>
        
        <!-- if an on-behalf-of with an @contrib-type that's not an author -->
        <xsl:when test="on-behalf-of and not(@contrib-type='author')">
          <xsl:text> [</xsl:text>
          <xsl:value-of select="@contrib-type"/>
          <xsl:text> on behalf of </xsl:text>
          <xsl:apply-templates select="on-behalf-of" mode="pass-through"/>
          <xsl:text>]</xsl:text>
        </xsl:when>
        
        <!-- if there's a role -->
        <xsl:when test="role">
          <xsl:text> [</xsl:text>
          <xsl:apply-templates select="role" mode="pass-through"/>
          <xsl:text>]</xsl:text>
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
        </xsl:when>
        
      </xsl:choose>
      
    </fo:wrapper>
    
      <!-- Finally set an affiliation reference, if any,
           using xref or aff as appropriate -->
      <xsl:choose>
        <xsl:when test="$affiliations-have-xrefs and xref[@ref-type='aff']">
          <xsl:apply-templates select="xref[@ref-type='aff']"
                                 mode="affiliation-number"/>
        </xsl:when>
        <xsl:when test="aff">
          <xsl:apply-templates select="aff"
                                 mode="affiliation-number"/>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    
              
  </fo:block>

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

      <fo:block space-before="0pt"
               space-after="0pt">

        <!-- put out the note -->
        <fo:footnote>
          <fo:inline>&#x200B;</fo:inline>
          <fo:footnote-body>
            <fo:block line-height="{$fnleading}pt"
                      space-before="0pt"
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


<xsl:template mode="copyright-note"
              match="copyright-statement | copyright-year" >
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
  
      <xsl:if test="contrib-group/contrib[@corresp='yes']">
        <fo:block space-before="0pt"
                  space-after="0pt">
          <fo:footnote>
            <fo:inline>&#x200B;</fo:inline>

            <fo:footnote-body>
            
              <fo:block line-height="{$fnleading}pt"
                        space-before="0pt"
                        space-after="{$leading-below-fn}">
                <fo:wrapper font-size="{$fnsize}pt">
  
                    <xsl:for-each select="contrib-group/contrib[@corresp='yes']">

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
                      <xsl:when test="address">
                        <xsl:text>, </xsl:text>
                        <xsl:apply-templates select="address" mode="correspondence-note"/>
                      </xsl:when>
                    </xsl:choose>

                    <!-- now post-contrib punctuation -->
                    <xsl:choose>
                      <xsl:when test="not(following-sibling::contrib[@corresp='yes'])">
                        <xsl:text>.</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>; </xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>

                  </xsl:for-each>
                
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


<xsl:template mode="correspondence-note"
              match="name">

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
            
<xsl:key name="aff-refs" match="xref[ancestor::article-meta][@ref-type='aff']"
                         use="@rid"/>
                         

<xsl:template name="set-affiliations-note">

  <xsl:param name="the-key" select="concat('aff', '-refs')"/>

  <xsl:if test="$affiliations-have-xrefs or /article/front/article-meta//aff">
  
    <fo:footnote>
      <fo:inline>&#x200B;</fo:inline>

      <fo:footnote-body>

        <fo:block line-height="{$fnleading}pt"
                  space-before="0pt"
                  space-after="{$leading-below-fn}">
          <fo:wrapper font-size="{$fnsize}pt">
            <xsl:text>Contributor affiliations: </xsl:text>

            <xsl:choose>
              <xsl:when test="$affiliations-have-xrefs">
                <xsl:for-each select="/article/front/article-meta//xref[@ref-type='aff']">

                  <!-- if it's the first reference to this aff,
                       set its number and set the aff -->
                  <xsl:if test="count(key($the-key, @rid)[1] | . ) = 1">
                    <xsl:apply-templates select="." mode="affiliation-number"/>
                    <xsl:apply-templates select="key('element-by-id', @rid)/self::aff"/>
                  </xsl:if>
                </xsl:for-each>
              </xsl:when>

              <xsl:otherwise>
                <!-- set the affiliations encountered in document order -->
                <xsl:for-each select="/article/front/article-meta//aff">
                  <xsl:apply-templates select="." mode="affiliation-number"/>
                  <xsl:apply-templates/>
                </xsl:for-each>
              </xsl:otherwise>         

            </xsl:choose>

          </fo:wrapper>
        </fo:block>
      </fo:footnote-body>
    </fo:footnote>
  
  </xsl:if>

</xsl:template>


<!-- ============================================================= -->
<!-- MODE: AFFILIATION-NUMBER                                      -->
<!-- ============================================================= -->

<xsl:template  mode="affiliation-number"
              match="xref[@ref-type='aff']"
              priority="1">

  <fo:inline baseline-shift="super" 
             font-size="{$fnsize -1}pt">
    <xsl:for-each select="key('aff-refs', @rid)[1]">
      <xsl:number level="any"
                  from="/"
                  format="a"
                  count="xref[@ref-type='aff'][ancestor::article-meta]
                         [count(key('aff-refs', @rid)[1] | . ) = 1]"/>
    </xsl:for-each>
  </fo:inline>
  
</xsl:template>


<xsl:template  mode="affiliation-number"
              match="aff" >

  <fo:inline baseline-shift="super" 
             font-size="{$fnsize -1}pt">
    <xsl:number count="article-meta//aff" 
                level="any" 
                from="/" 
                format="a"/>
  </fo:inline>
  
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
     
<xsl:template match="aff/child::node()[1][self::bold]"/>


<!-- ============================================================= -->
<!-- ARTICLE ABSTRACT                                              -->
<!-- ============================================================= -->


<xsl:template match="article-meta/abstract[not(@abstract-type='toc')]">

  <fo:block space-before="12pt"
            space-after="{$leading-below-titles-small}"
            line-height="{$textleading}pt">
    <fo:wrapper font-family="{$titlefont}"
                font-size="12pt"
                font-weight="bold">
      <xsl:text>Abstract</xsl:text>
    </fo:wrapper>
  </fo:block>
  
  <fo:block margin-left="1.5pc"
            margin-right="1.5pc">
    <xsl:apply-templates/>
  </fo:block>

</xsl:template>


<!-- ============================================================= -->
<!-- ELEMENTS PROCESSED SIMPLY IN NO-MODE                          -->
<!-- ============================================================= -->

<!-- These elements are listed here only to help a developer 
     be sure of what's happening. -->

<!-- journal meta -->
<xsl:template match="journal-meta/abbrev-journal-title
                   | journal-meta/journal-title
                   | journal-meta/issn
                   | journal-meta/publisher/publisher-name
                   | journal-meta/publisher/publisher-loc
                   | article-meta/copyright-statement
                   | article-meta/copyright-year">
  <xsl:apply-templates/>
</xsl:template>

<!-- article-meta -->
<xsl:template match="article-meta/volume
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

<xsl:template match="article-meta/ext-link
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
<xsl:template match="article-meta/contrib-group/address 
                   | article-meta/contrib-group/author-comment 
                   | article-meta/contrib-group/bio 
                   | article-meta/contrib-group/email 
                   | article-meta/contrib-group/ext-link 
                   | article-meta/contrib-group/on-behalf-of 
                   | article-meta/contrib-group/role 
                   | article-meta/contrib-group/xref"/>

<!-- unused information in (any) contrib -->
<xsl:template match="contrib/address
                   | contrib/author-comment
                   | contrib/bio
                   | contrib/degrees
                   | contrib/email
                   | contrib/ext-link"/>

<xsl:template match="alt-text | ext-link | long-desc"/>


</xsl:transform>

<?xml version="1.0" encoding="utf-8"?>
<!-- ============================================================= -->
<!--  MODULE:    basics-paragraphs-1-0.xsl                         -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      September 2004                                    -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:     Archiving and Interchange DTD Suite               -->
<!--             Journal Article Formatting                        -->
<!--                                                               -->
<!-- PURPOSE:    A module of article-fo.xsl that handles           -->
<!--             paragraphs in all their contexts.                 -->
<!--                                                               -->
<!-- CONTAINS:   Templates for paragraphs in:                      -->
<!--             1) body, body sections, and ref-list              -->
<!--             2) boxed-text                                     -->
<!--             3) abstract                                       -->
<!--             4) speech                                         -->
<!--             5) statement                                      -->
<!--             6) footnote                                       -->
<!--             7) table-wrap/caption and fig-wrap/caption        -->
<!--             8) a default paragraph template                   -->
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
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >


<!-- ============================================================= -->
<!-- PARAGRAPH under most conditions                               -->
<!-- ============================================================= -->

<!-- Note: The templates for paragraphs differ primarily in the
     handling and contexts for run-in titles and numbering.
     This template handles "ordinary" paragraphs, in body,
     body sections, and ref-list.

     In particular: speech, statement, boxed-text, abstract, and
     fn have different rules for run-in data and are handled in
     separate templates, below. -->

<xsl:template match="ref-list/p 
                   | body//p[not(ancestor::boxed-text)
                         and not(ancestor::speech)
                         and not(ancestor::statement)
                         and not(ancestor::caption)
                         and not(ancestor::fn)]
                   | back//p[not(ancestor::boxed-text)
                         and not(ancestor::speech)
                         and not(ancestor::statement)
                         and not(ancestor::caption)
                         and not(ancestor::fn)]" >
                         
  <xsl:param name="space-after">
  
     <xsl:choose>
                  
       <!-- if the next thing is another para
            and we're in a low-level wrapper -->
       <xsl:when test="following-sibling::*[1][self::p]
                   and (parent::disp-quote | parent::list-item 
                      | parent::def | parent::abstract)">
         <xsl:value-of select="$leading-between-wrapped-paras"/>
       </xsl:when>
       
       <!-- otherwise, use "normal" paragraph spacing: 
            either this is appropriate, OR the next element 
            encountered will override it using .precedence
            1, 2, or force. -->
       <xsl:otherwise> 
         <xsl:value-of select="$leading-between-body-paras"/>
       </xsl:otherwise>

      </xsl:choose>

  </xsl:param>


  <!-- now set the paragraph. -->
  
  <fo:block space-after="{$space-after}">

    <!-- get runin title if any -->
    
    <!-- boxed-sec contains sections, which might mess up the
         ancestor count - except that we've excluded boxed-text
         from this template. It has its own. -->
       
    <xsl:if test="parent::sec
              and preceding-sibling::*[1][self::title]
              and count(ancestor::sec) &gt;8">

      <xsl:choose>
        <!-- level 3: titlefont run-in -->
        <xsl:when test="count(ancestor::sec) = 8">
          <xsl:call-template name="runin-title-style-1"/>
        </xsl:when>

        <!-- everything deeper than that: text-font run-in -->
        <xsl:otherwise>
           <xsl:call-template name="runin-title-style-2"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <!-- now, at last, the paragraph's content -->
    <xsl:apply-templates/>

  </fo:block>
</xsl:template>


<!-- ============================================================= -->
<!-- PARAGRAPH IN BOXED TEXT (which may contain sec w/runin title) -->
<!-- ============================================================= -->


<xsl:template match="boxed-text/p">

  <!-- if there's something other than a para next,
       it can only be a section, and its spacing 
       will take precedence over the value set here,
       which is what we want to have happen. -->
  <xsl:param name="space-after" select="$leading-between-wrapped-paras"/>

  <fo:block space-after="{$space-after}">
    
    <!-- now the paragraph's content -->
    <xsl:apply-templates/>

  </fo:block>
</xsl:template>


<xsl:template match="boxed-text//sec/p">

  <xsl:param name="space-after" select="$leading-between-wrapped-paras"/>

  <fo:block space-after="{$space-after}">
    
    <!-- get run-in title if any -->
    <xsl:if test="preceding-sibling::*[1][self::title]">
    
      <xsl:choose>
        <!-- if a first-level sec within boxed-text,
             the title's already been produced as a block title -->
        <xsl:when test="parent::sec/parent::boxed-text"/>
        
        <!-- anything below that -->
        <xsl:otherwise>
<!--          <xsl:call-template name="runin-title-style-2"/>
-->        </xsl:otherwise>      
      </xsl:choose> 
      
    </xsl:if>
    
    <!-- now the paragraph's content -->
    <xsl:apply-templates/>

  </fo:block>

</xsl:template>
    
    <xsl:template match="boxed-text//sec/p">

        <xsl:param name="space-after" select="$leading-between-wrapped-paras"/>
      
        <fo:block space-after="{$space-after}">
          
          <!-- get run-in title if any -->
          <xsl:if test="preceding-sibling::*[1][self::title]">
          
            <xsl:choose>
              <!-- if a first-level sec within boxed-text,
                   the title's already been produced as a block title -->
              <xsl:when test="parent::sec/parent::boxed-text"/>
              
              <!-- anything below that -->
              <xsl:otherwise>
      <!--          <xsl:call-template name="runin-title-style-2"/>
      -->        </xsl:otherwise>      
            </xsl:choose> 
            
          </xsl:if>
          
          <!-- now the paragraph's content -->
          <xsl:apply-templates/>
      
        </fo:block>
      
      </xsl:template>


<!-- ============================================================= -->
<!-- PARAGRAPH IN ABSTRACT (which may contain sec w/runin title)   -->
<!-- ============================================================= -->


<xsl:template match="abstract/p">

  <!-- if there's something other than a para next,
       it can only be a section, and its spacing 
       will take precedence over the value set here,
       which is what we want to have happen. -->
  <xsl:param name="space-after" select="$leading-between-wrapped-paras"/>

  <fo:block space-after="{$space-after}">
    
    <!-- now the paragraph's content -->
    <xsl:apply-templates/>

  </fo:block>
</xsl:template>


<xsl:template match="abstract//sec/p">

  <xsl:param name="space-after" select="$leading-between-wrapped-paras"/>

  <fo:block space-after="{$space-after}">
    
    <!-- get run-in title if any -->
    <xsl:if test="preceding-sibling::*[1][self::title]">
    
      <xsl:choose>
        <!-- if a first-level sec within abstract -->
        <xsl:when test="parent::sec/parent::abstract">
          <xsl:call-template name="runin-title-style-1"/>
        </xsl:when>
        
        <!-- anything below that -->
        <xsl:otherwise>
          <xsl:call-template name="runin-title-style-2"/>
        </xsl:otherwise>      
      </xsl:choose> 
      
    </xsl:if>
    
    <!-- now the paragraph's content -->
    <xsl:apply-templates/>

  </fo:block>

</xsl:template>


<!-- ============================================================= -->
<!-- PARAGRAPH IN SPEECH (where speaker may run in)                -->
<!-- ============================================================= -->


<!-- Speech can't contain sections, but it must contain a speaker
     and the speaker runs in to the first paragraph. -->
     
     
<xsl:template match="speech/p">

  <xsl:param name="space-after" select="$leading-between-body-paras"/>
    
  <fo:block space-after="{$space-after}">
  
    <!-- get speaker if appropriate -->
    <!-- A speech can contain (besides speaker) only paragraphs,
         no other elements, so this test is sufficient to identify
         the first paragraph. -->
    <xsl:if test="not(preceding-sibling::p)">  
      <fo:inline font-weight="bold">
        <xsl:apply-templates select="preceding-sibling::speaker" mode="run-in"/>
        <xsl:text>: </xsl:text>
      </fo:inline>
    </xsl:if>
      
    <xsl:apply-templates/>
  
  </fo:block>
  
</xsl:template>

<xsl:template match="speech/speaker" mode="run-in">
  <xsl:apply-templates/>
</xsl:template>

<!-- suppress in no-mode -->
<xsl:template match="speech/speaker"/>


<!-- ============================================================= -->
<!-- PARAGRAPH IN STATEMENT (where label and/or title may run in)  -->
<!-- ============================================================= -->


<!-- Statement can't contain sections. But it may contain a label
     and/or title which run in to the first paragraph.             -->
     

<xsl:template match="statement/p">

  <xsl:param name="space-after" select="$leading-between-body-paras"/>
    
  <fo:block space-after="{$space-after}">
  
  <!-- get run-in label and title, if any -->
  <!-- A statement can contain (besides label and title) only paragraphs,
       no other elements, so this test is sufficient to identify
       the first paragraph. -->
    <xsl:if test="not(preceding-sibling::p)">
      
      <xsl:if test="preceding-sibling::label">
        <fo:inline font-weight="bold">
          <xsl:apply-templates select="preceding-sibling::label" mode="run-in"/>
          <xsl:text>: </xsl:text>
        </fo:inline>
      </xsl:if>
      
      <xsl:if test="preceding-sibling::title">
        <xsl:call-template name="runin-title-style-2"/>
      </xsl:if>
        
    </xsl:if>
    
    <xsl:apply-templates/>
    
  </fo:block>
  
</xsl:template>


<xsl:template match="statement/label | statement/title" mode="run-in">
  <xsl:apply-templates/>
</xsl:template>

<!-- suppress in no-mode -->
<xsl:template match="statement/label | statement/title"/>



<!-- ============================================================= -->
<!-- FOOTNOTE PARAGRAPHS                                           -->
<!-- ============================================================= -->

<!-- numbering assumes the footnote's first significant content
     is a paragraph. -->
<!-- used by fn template whether with or without xrefs -->
<!-- XX need to handle non-para contents of fn. -->
     
<xsl:template match="fn/p">

  <!-- receives value from fn template (whether with or without xrefs) -->
  <xsl:param name="my-number"/>
  
  <fo:block
            space-before="0pt">
    <xsl:if test="not(preceding-sibling::p) and string-length(normalize-space($my-number)) != 0">
      <fo:inline baseline-shift="super">
        <fo:wrapper font-size="6.5pt">
          <xsl:value-of select="$my-number"/>
        </fo:wrapper>
      </fo:inline>
    </xsl:if>
    
    <fo:wrapper font-size="6.5pt" font-family="{$titlefont}">
      <xsl:apply-templates/>
    </fo:wrapper>
  </fo:block>
  
</xsl:template>


<!-- ============================================================= -->
<!-- TABLE-WRAP/CAPTION PARAGRAPHS                                 -->
<!-- ============================================================= -->


<xsl:template match="table-wrap/caption/p">
  <fo:inline>
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<!-- ============================================================= -->
<!-- FIG/CAPTION AND SUPPLEMENTARY-MATERIAL/CAPTION PARAGRAPHS     -->
<!-- ============================================================= -->
    
    <!--<xsl:template match="fig[label]">
        <fo:list-block>
            <fo:list-item>
                <fo:list-item-label font-weight="800">
                    <xsl:apply-templates select="label"/>
                </fo:list-item-label>
                <fo:list-item-body>
                    <xsl:apply-templates select="caption/p"/>
                </fo:list-item-body>
            </fo:list-item>
        </fo:list-block>
    </xsl:template>-->
    
    <!--<xsl:template match="fig/label">
        <fo:inline font-weight="800" padding-top="5pt">
            <xsl:value-of select="text()"/>
        </fo:inline>
    </xsl:template>-->


<!--<xsl:template match="fig/caption/p | supplementary-material/caption/p">
  <fo:block float="right" padding-top="5pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>-->


<!-- ============================================================= -->
<!-- DEFAULT PARAGRAPH                                             -->
<!-- ============================================================= -->


<xsl:template match="p">

  <xsl:param name="space-after" select="$leading-between-wrapped-paras"/>

  <fo:block space-after="{$space-after}">
    <xsl:apply-templates/>
  </fo:block>
  
</xsl:template>
     
     <xsl:template match="p[citation]">
          
          <xsl:param name="space-after" select="$leading-between-wrapped-paras"/>
          
          <fo:block space-after="{$space-after}" keep-with-next.within-page="always">
               <xsl:apply-templates/>
          </fo:block>
          
     </xsl:template>
     
     <xsl:template match="fn[ancestor::table-wrap-foot]" mode="pseudo-footnote">
          <fo:block font-size="{$fnsize*0.9}pt" font-family="{$titlefont}">
               <xsl:apply-templates/>
          </fo:block>

     </xsl:template>
     <xsl:template match="p" mode="display">
               <xsl:apply-templates/>
     </xsl:template>
<!--     paras containing supplementary material tags need to be suppressed in main flow-->
     <xsl:template match="p[ancestor::body][supplementary-material]"/>
     <xsl:template match="break">
          <fo:block space-before="2pt"/>
     </xsl:template>
</xsl:stylesheet>
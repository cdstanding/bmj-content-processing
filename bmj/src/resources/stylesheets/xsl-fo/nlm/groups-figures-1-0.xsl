<?xml version="1.0" encoding="utf-8"?>
<!-- ============================================================= -->
<!--  MODULE:    groups-figures-1-0.xsl                            -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      September 2004                                    -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:     Archiving and Interchange DTD Suite               -->
<!--             Journal Article Formatting                        -->
<!--                                                               -->
<!-- PURPOSE:    A module of article-fo.xsl that handles           -->
<!--             figures; fig is a grouping element that           -->
<!--             characteristically contains a display object,     -->
<!--             such as a graphic, with its caption.              -->
<!--                                                               -->
<!-- CONTAINS:   Keys for handling figures:                        -->
<!--             1) legit-figs-no-fig-type                         -->
<!--             2) legit-figs-by-fig-type                         -->
<!--             Templates for:                                    -->
<!--             1) fig                                            -->
<!--             2) Named template: decide-fig-type                -->
<!--             3) Named template: decide-make-label-for-fig-type -->
<!--             4) Named template: determine-fig-label            -->
<!--             5) fig-group                                      -->
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
                xmlns:mml="http://www.w3.org/1998/Math/MathML">


<!-- ============================================================= -->
<!-- KEYS AND VARIABLES FOR FIGURES                                -->
<!-- ============================================================= -->


<xsl:key name="legit-figs-no-fig-type" 
         match="body/fig[not(@fig-type)]
              | sec/fig[not(@fig-type)]
              | app/fig[not(@fig-type)]
              | fig-group/fig[not(@fig-type)]"
         use="local-name()"/>
                                       
<xsl:key name="legit-figs-by-fig-type" 
         match="body/fig[@fig-type]
              | sec/fig[@fig-type]
              | app/fig[@fig-type] 
              | fig-group/fig[@fig-type]"
         use="@fig-type"/>
   


<!-- ============================================================= -->
<!-- FIG                                                           -->
<!-- ============================================================= -->


<xsl:template match="fig">

  <xsl:param name="object-gid" select="generate-id()"/>
  
  <xsl:param name="object-fig-type">
    <!-- this logic is externalized because it is
         also used by xref -->
    <xsl:call-template name="decide-fig-type">
      <xsl:with-param name="object-gid" select="$object-gid"/>
    </xsl:call-template>
  </xsl:param>
  
  <xsl:param name="make-fig-labels-for-type">
    <!-- this logic is externalized because it is
         also used by xref -->
    <xsl:call-template name="decide-make-fig-labels-for-type">
      <xsl:with-param name="object-gid" select="$object-gid"/>
      <xsl:with-param name="object-fig-type" select="$object-fig-type"/>
    </xsl:call-template>
  </xsl:param>
      

  <xsl:param name="space-before" select="$leading-around-display-blocks"/>
  <xsl:param name="space-after"  select="$leading-around-display-blocks"/>
  
  <xsl:param name="float">
    <xsl:choose>
      <xsl:when test="@position='float'">before</xsl:when>
      <xsl:otherwise>none</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <fo:float float="{$float}"
            space-before="0pt"
            space-after="0pt">
  
    <fo:block space-before="{$space-before}"
              space-after="{$space-after}"
              line-stacking-strategy="max-height"
              id="{@id}">

      <!-- the graphic or other fig content-->
      <xsl:apply-templates select="*[not(self::label) 
                                 and not(self::caption) 
                                 and not(self::copyright-statement)]"/>
    </fo:block>

    <!-- the apparatus, beneath the graphic -->
    <fo:block line-height="10pt"
              space-before="{$leading-at-apparatus}" 
              space-before.precedence="force">
      <!-- was buggy: space-before.conditionality="force" -->

      <fo:wrapper font-family="{$textfont}"
                  font-size="9pt"
                  font-weight="bold">  
                  
        <!-- fig are labeled only in certain contexts
         (though they may, of course, have a caption/title) -->
        <xsl:if test="(key('legit-figs-no-fig-type', 'fig')[generate-id()=$object-gid]
                      or key('legit-figs-by-fig-type', $object-fig-type)[generate-id()=$object-gid])
                  and ($make-fig-labels-for-type='yes' or child::label)">
          <xsl:call-template name="determine-fig-label">
            <xsl:with-param name="object-gid" select="$object-gid"/>
            <xsl:with-param name="object-fig-type" select="$object-fig-type"/>
          </xsl:call-template>
          <xsl:text>. </xsl:text>
        </xsl:if>
        
        <!-- the fig/caption/title, if any, on the same line -->
        <xsl:apply-templates select="caption/title" mode="display"/>
        
      </fo:wrapper>
      
    </fo:block>
       

    <!-- fig/caption/p's, if any -->
    <!-- a caption can contain ONLY title and p's, and we've
         already dealt with the title -->
    <xsl:apply-templates select="caption/p"/>
      
    <!-- the fig/copyright if any -->
    <xsl:apply-templates select="copyright-statement" mode="display"/>
      
     
  </fo:float>
  
</xsl:template>


<!-- ============================================================= -->
<!-- NAMED TEMPLATE: DECIDE-FIG-TYPE                               -->
<!-- ============================================================= -->


<xsl:template name="decide-fig-type">

  <xsl:param name="object-gid"/>
  
  <xsl:for-each select="key('element-by-gid', $object-gid)">
    <xsl:choose>
      <xsl:when test="@fig-type">
        <xsl:value-of select="@fig-type"/>
      </xsl:when>
      <xsl:otherwise>generic</xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>

</xsl:template>


<!-- ============================================================= -->
<!-- NAMED TEMPLATE: DECIDE-MAKE-FIG-LABELS-FOR-TYPE               -->
<!-- ============================================================= -->


<xsl:template name="decide-make-fig-labels-for-type">

  <xsl:param name="object-gid"/>
  <xsl:param name="object-fig-type"/>

  <xsl:choose>
  
    <!-- DON'T make labels if 
         ANY legit fig OF THIS TYPE has a label -->
    <xsl:when test="key('element-by-gid', $object-gid)/@fig-type 
                and count(key('legit-figs-by-fig-type', $object-fig-type)[parent::fig/label]) != 0">
      <xsl:value-of select="'no'"/>
    </xsl:when>

    <!-- Same for generic figs (=has no @fig-type value) -->
    <xsl:when test="$object-fig-type='generic'
                and count(key('legit-figs-no-fig-type', 'fig')[child::label]) != 0">
      <xsl:value-of select="'no'"/>
    </xsl:when>

    <!-- otherwise, in this document NO fig of this type has a label, 
         so we'll set the value to yes,
         and when the time comes we'll use that to put out a string and number -->
    <xsl:otherwise>
      <xsl:value-of select="'yes'"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


<!-- ============================================================= -->
<!-- NAMED TEMPLATE: DETERMINE-FIG-LABEL                           -->
<!-- ============================================================= -->


<!-- This template is used by both fig and xref templates.
     The logic is externalized here to ensure that both
     fig and xref use exactly the same decisions. -->

<!-- Called IFF the figure is in an appropriate context
     AND we're setting labels for this figure type. -->
     
<!-- By now we know:

      - a value for the fig-type, even if none was provided
      - whether figs of this type are to be labeled in this document
      - whether -this- fig is in a legitimate context to have a label
      
      Here we decide:
      - do we use the document's fig/label or create one?
      - if we create one, what number do we give it?
      and
      - whether to put out a figure-type string as well as the number.
      -->
     
<!-- About the figure-type string.
     A fig may have an @fig-type, such as 'plate', 'map', etc.
     If the transform's doing the numbering, then each @fig-type
     gets a separate numbering sequence. 

     The transform at present has strings for 
       * fig with no @fig-type = 'generic'      ("Figure")
       * fig with    @fig-type = 'plate'        ("Plate")

     To add more types, add items to the m:map "fig-type-strings"
     AND add an xsl:when to named template calculate-fig-number.
     (It shouldn't be necessary to do the second thing! a generic
     solution in calculate-fig-number should be possible, but my 
     solution has a bug in it so far.) -->
     
<xsl:template name="determine-fig-label">

  <!-- from fig or xref template -->
  <xsl:param name="object-gid"/>
  <xsl:param name="object-fig-type"/>

    <xsl:choose>
      
      <!-- if there's a label with a space in it, assume the
           label contains both string and number -->
      <xsl:when test="contains(label, ' ')">
        <xsl:apply-templates select="label" mode="pass-through"/>
      </xsl:when>
      
      <!-- if there's a label (with no space in it), 
           generate a string and use the label -->
      <xsl:when test="child::label">
        <xsl:value-of select="$fig-type-strings[@source-fig-type=$object-fig-type]/@display-string"/>
        <xsl:apply-templates select="label" mode="display"/>   
      </xsl:when>
      
      <!-- Otherwise, choose the string AND calculate the number -->
      <xsl:otherwise>
        <xsl:value-of select="$fig-type-strings[@source-fig-type=$object-fig-type]/@display-string"/>
        <xsl:call-template name="calculate-fig-number">
          <xsl:with-param name="object-gid" select="$object-gid"/>
          <xsl:with-param name="object-fig-type" select="$object-fig-type"/>
        </xsl:call-template>
      </xsl:otherwise>

    </xsl:choose>

</xsl:template>


<!-- ============================================================= -->
<!-- FIG-GROUP                                                     -->
<!-- ============================================================= -->

<!-- Not handled: only its child figs are processed.               -->

<xsl:template match="fig-group">
  <xsl:apply-templates select="fig"/>
</xsl:template>


<!-- ============================================================= -->
<!-- MODE: DISPLAY                                                 -->
<!-- ============================================================= -->


<xsl:template match="fig/caption/title" mode="display">
  <fo:wrapper font-family="{$textfont}"
              font-size="9pt"
              font-weight="bold">
    <xsl:apply-templates/>
  </fo:wrapper>
</xsl:template>


<xsl:template match="fig/copyright-statement" mode="display">
  <fo:block>
    <fo:wrapper font-family="{$textfont}"
                font-size="9pt"
                font-weight="normal">
      <xsl:apply-templates select="copyright" mode="display"/>
    </fo:wrapper>
  </fo:block>
</xsl:template>


<!-- ============================================================= -->
<!-- SUPPRESSED IN NO-MODE                                         -->
<!-- ============================================================= -->

<!-- suppress in no-mode because have been
     picked up in "display" mode by fig -->
<xsl:template match="fig/label | fig/caption | fig/copyright-statement"/>




</xsl:transform>
<?xml version="1.0" encoding="utf-8"?>
<!-- ============================================================= -->
<!--  MODULE:    basics-inlines-1-0.xsl                            -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      September 2004                                    -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:     Archiving and Interchange DTD Suite               -->
<!--             Journal Article Formatting                        -->
<!--                                                               -->
<!-- PURPOSE:    A module of article-fo.xsl that handles           -->
<!--             inline elements such as italic and overline.      -->
<!--                                                               -->
<!-- CONTAINS:   Templates for:                                    -->
<!--             1) bold, italic, smallcap, monospace              -->
<!--             2) overline, underline, strikethrough             -->
<!--             3) superscript, subscript                         -->
<!--             4) private-char, glyph-data, glyph-ref            -->
<!--             5) inline-graphic, inline-formula                 -->
<!--             6) abbreviation, named-content                    -->
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


<!-- This fragment treats both the "regular" inline elements and 
     those which might equally be considered display objects, 
     such as inline graphic. 
     
     The referencing elements - primarily xref - are treated in a
     separate fragment                                             -->
     
     
<!-- ============================================================= -->
<!-- BOLD, ITALIC, SMALLCAP, AND MONOSPACE                         -->
<!-- ============================================================= -->


<xsl:template match="bold">
  <fo:wrapper font-weight="bold">
    <xsl:apply-templates/>
  </fo:wrapper>
</xsl:template>


<xsl:template match="italic">
  <fo:wrapper font-style="italic">
    <xsl:apply-templates/>
  </fo:wrapper>
</xsl:template>


<xsl:template match="monospace">
  <fo:wrapper font-family="monospace"
              font-size="{$textsize -1}pt">
    <xsl:apply-templates/>
  </fo:wrapper>
</xsl:template>


<xsl:template match="sc">
  <fo:wrapper text-transform="uppercase"
              font-size="{$textsize -2}pt">
    <xsl:apply-templates/>
  </fo:wrapper>
</xsl:template>


<!-- ============================================================= -->
<!-- OVERLINE, UNDERLINE, STRIKE-THROUGH                           -->
<!-- ============================================================= -->


<xsl:template match="overline">
  <fo:wrapper text-decoration="overline">
    <xsl:apply-templates/>
  </fo:wrapper>
</xsl:template>


<xsl:template match="underline">
  <fo:wrapper text-decoration="underline">
    <xsl:apply-templates/>
  </fo:wrapper>
</xsl:template>


<xsl:template match="strike">
  <fo:wrapper text-decoration="line-through">
    <xsl:apply-templates/>
  </fo:wrapper>
</xsl:template>


<!-- ============================================================= -->
<!-- SUPERSCRIPT AND SUBSCRIPT                                     -->
<!-- ============================================================= -->


<!-- Use fo:inline for sup and sub, not fo:wrapper, because
     fo:wrapper isn't meant to handle a change to baseline.        -->
     
     
<xsl:template match="sup">
  <fo:inline baseline-shift="super"
              font-size="{$textsize -2}pt">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<xsl:template match="sub">
  <fo:inline baseline-shift="sub"
              font-size="{$textsize -2}pt">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<!-- ============================================================= -->
<!-- PRIVATE-CHAR, GLYPH-DATA, GLYPH-REF                           -->
<!-- ============================================================= -->


<!-- By design: If there are graphics, display'em.
     Otherwise, just show @name. -->
     
<xsl:template match="private-char">
  <xsl:choose>
    <xsl:when test="inline-graphic">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <fo:wrapper>
        <xsl:text>[</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>]</xsl:text>
      </fo:wrapper>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="glyph-data | glyph-ref"/>


<!-- ============================================================= -->
<!-- INLINE-GRAPHIC AND INLINE-FORMULA                             -->
<!-- ============================================================= -->


<xsl:template match="inline-graphic">
  <fo:external-graphic src="url({@xlink:href})"/>
</xsl:template>

<!-- suppress alt-text if present -->
<xsl:template match="inline-graphic/alt-text"/>


<!-- inline formula -->

<xsl:template match="inline-formula">

  <fo:wrapper font-size="9pt"
              font-family="Courier"
              white-space-treatment="preserve"
              white-space-collapse="false"><xsl:apply-templates/></fo:wrapper>
  
</xsl:template>


<!-- math inside inline-formula -->

<xsl:template match="inline-formula/mml:math">
  <fo:instream-foreign-object content-type="application/mathml+xml">
    <xsl:copy-of select="."/>
  </fo:instream-foreign-object>
</xsl:template>


<!-- ============================================================= -->
<!-- ABBREVIATION AND NAMED-CONTENT                                -->
<!-- ============================================================= -->

<!-- Inline elements that have no formatting consequences -->

<xsl:template match="abbreviation | named-content">
  <xsl:apply-templates/>
</xsl:template>



</xsl:transform>
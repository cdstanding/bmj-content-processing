<?xml version="1.0" encoding="utf-8"?>
<!-- ============================================================= -->
<!--  MODULE:    basics-sections-1-0.xsl                           -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      September 2004                                    -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:     Archiving and Interchange DTD Suite               -->
<!--             Journal Article Formatting                        -->
<!--                                                               -->
<!-- PURPOSE:    A module of article-fo.xsl that handles           -->
<!--             sections, in various contexts.                    -->
<!--                                                               -->
<!-- CONTAINS:   Templates for:                                    -->
<!--             1) body sections                                  -->
<!--             2) boxed-text sections                            -->
<!--             3) abstract sections                              -->
<!--             4) default section                                -->
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
<!-- BODY SECTIONS                                                 -->
<!-- ============================================================= -->

<!-- back/sec is handled in basics-backmatter.xsl. -->

<!-- Sections within boxed-text are handled by the boxed-text
     templates. Sections within abstract are handled by the
     abstract templates. -->
    

<!-- This template handles 5 levels of sections explicitly. 
     At level 4 and beyond, the title formatting remains the same.
     At level 5 and beyond, the section will be caught by the
     default section template and the space-above will be
     a tad smaller than this template produces.  -->
     
<xsl:template match="body/sec | back/sec
                   | body/sec/sec | back/sec/sec
                   | body/sec/sec/sec | back/sec/sec/sec
                   | body/sec/sec/sec/sec | back/sec/sec/sec/sec
                   | body/sec/sec/sec/sec/sec | back/sec/sec/sec/sec/sec
                   | back/notes/sec">
     <xsl:param name="id">
          <xsl:choose>
               <xsl:when test="@id">
                    <xsl:value-of select="@id"/>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:value-of select="generate-id()"/>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:param>
                   
  <fo:block id="{$id}"
       space-before="{$leading-around-display-blocks}"
       space-before.precedence="2"
            space-after="0pt">
       <xsl:comment>PROCESSING SEC HERE</xsl:comment>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>
     
     <xsl:template match="body/sec[1]">
          <xsl:param name="id">
               <xsl:choose>
                    <xsl:when test="@id">
                         <xsl:value-of select="@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:value-of select="generate-id()"/>
                    </xsl:otherwise>
               </xsl:choose>
          </xsl:param>
          <fo:block id="{$id}"
               space-after="0pt">
               <xsl:apply-templates/>
          </fo:block>
     </xsl:template>


<!-- Titles in first- and second-level body sections are
     to be block titles. (In sections nested more deeply
     than that, titles are to be run-in, and they're called
     in by the paragraph template.) -->

<xsl:template match="body/sec/title | back/sec/title">
  <xsl:call-template name="block-title-style-1"/>
</xsl:template>
     <xsl:template match="body/sec/sec/title | back/sec/sec/title | back/notes/sec/title">
  <xsl:call-template name="block-title-style-2"/>
</xsl:template>
     <xsl:template match="body/sec/sec/sec/title | back/sec/sec/sec/title">
          <xsl:call-template name="block-title-style-3"/>
     </xsl:template>

<!-- suppress all other sec titles in no-mode,
     because they are handled by the "run-in" mode -->

<xsl:template match="sec/title" priority="0.4"/>


<!-- ============================================================= -->
<!-- BOXED-TEXT SECTIONS                                           -->
<!-- ============================================================= -->


<xsl:template match="boxed-text//sec">

  <xsl:param name="space-before" select="$leading-around-narrative-blocks"/>
  <xsl:param name="space-after"  select="'0pt'"/>

  <fo:block id="{@id}"
            space-before="{$space-before}" space-before.precedence="2"
            space-after="{$space-after}"    space-after.precedence="2">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="boxed-text/sec/title">
  <fo:block space-after="{$leading-below-titles-big}"
            space-after.precedence="force"
            keep-with-next.within-page="always">
    <fo:wrapper
            font-family="{$titlefont}"
            font-size="{$textsize*0.8}pt"
            font-weight="bold">
      <xsl:apply-templates/>
    </fo:wrapper>
  </fo:block>
</xsl:template>
     
     <xsl:template match="boxed-text/sec/sec/title">
          <fo:block space-after="{$leading-below-titles-small}"
               space-after.precedence="force"
               keep-with-next.within-page="always">
               <fo:wrapper
                    font-family="{$titlefont}"
                    font-size="{$textsize*0.8}pt"
                    font-weight="normal"
                    font-style="italic">
                    <xsl:apply-templates/>
               </fo:wrapper>
          </fo:block>
     </xsl:template>

     <xsl:template match="boxed-text/sec/sec/sec/title">
          <fo:block space-after="{$leading-below-titles-small}"
               space-after.precedence="force"
               keep-with-next.within-page="always">
               <fo:wrapper
                    font-family="{$titlefont}"
                    font-size="{$textsize*0.8}pt"
                    font-weight="normal"
                    font-style="italic">
                    <xsl:apply-templates/>
               </fo:wrapper>
          </fo:block>
     </xsl:template>
     
<!-- ============================================================= -->
<!-- ABSTRACT SECTIONS                                             -->
<!-- ============================================================= -->


<xsl:template match="abstract//sec">

  <xsl:param name="space-before" select="$leading-between-wrapped-paras"/>
  <xsl:param name="space-after"  select="'0pt'"/>

  <fo:block id="{@id}"
            space-before="{$space-before}" space-before.precedence="2"
            space-after="{$space-after}"    space-after.precedence="2">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!-- suppress in no-mode -->
<xsl:template match="abstract//sec/title"/>



<!-- ============================================================= -->
<!-- DEFAULT SECTION                                               -->
<!-- ============================================================= -->


<xsl:template match="sec">
  <fo:block id="{@id}">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>




</xsl:stylesheet>
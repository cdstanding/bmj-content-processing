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


<xsl:stylesheet version="2.0"
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
     <xsl:element name="fo:inline">
          <xsl:attribute name="font-style">
               <xsl:text>italic</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates/>
     </xsl:element>
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
     
     
<xsl:template match="sup" mode="#all">
     <fo:inline baseline-shift="35%" font-size="55%" >
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>
     <!--<xsl:template match="sup[ancestor::table|ancestor::ref]">
          <fo:inline baseline-shift="35%" font-size="55%" >
               <xsl:apply-templates/>
          </fo:inline>
     </xsl:template>-->

<xsl:template match="sub">
  <fo:inline baseline-shift="sub"
              font-size="55%">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>
     <xsl:template match="sub[ancestor::table|ancestor::ref]">
          <fo:inline baseline-shift="sub"
               font-size="{$fnsize*0.8-2}pt">
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
<!--     <xsl:comment>inline-graphic choice 3</xsl:comment>
-->     
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
<!-- ABBREVIATION AND NAMED-CONTENT-->
<!-- ============================================================= -->

<!-- Inline elements that have no formatting consequences -->

<xsl:template match="abbreviation | named-content">
  <xsl:apply-templates/>
</xsl:template>


     <!-- ============================================================= -->
     <!-- EXTERNAL LINKS-->
     <!-- ============================================================= -->
     
     <!-- need to do something about long urls -->
     
     <xsl:template match="ext-link|related-article">
          <xsl:choose>
               <xsl:when test="matches(@xlink:href,'http://')">
                    <xsl:element name="fo:basic-link">
                         <xsl:attribute name="external-destination" select="concat('url(',normalize-space(@xlink:href),')')"/>
                         <xsl:apply-templates/>
                    </xsl:element>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:apply-templates/>
               </xsl:otherwise>
          </xsl:choose>
          
     </xsl:template>
     <xsl:template match="ext-link//text()|related-article//text()">
          <!--<xsl:value-of select="replace(substring-after(.,'http://'),'(\.|-|&amp;|[^/]/|\?)','$1&#x200B;','i')"/>-->
          <xsl:value-of select="replace(.,'([^\w]|[^/]/)','$1&#x200B;','i')"/>
     </xsl:template>
     <xsl:template match="text()[parent::td][1]">
          <xsl:choose>
               <xsl:when test="matches(.,'^&#x2002;&#x2002;','i')">
                    <xsl:value-of select="replace(.,'^&#x2002;&#x2002;','&#x00A0;&#x00A0;','i')"/>
               </xsl:when>
               <xsl:when test="matches(.,'^&#x2002;','i')">
                    <xsl:value-of select="replace(.,'^&#x2002;','&#x00A0;','i')"/>
               </xsl:when>
               <xsl:when test="matches(.,'^&#x2003;&#x2003;','i')">
                    <xsl:value-of select="replace(.,'^&#x2003;&#x2003;','&#x00A0;&#x00A0;','i')"/>
               </xsl:when>
               <xsl:when test="matches(.,'^&#x2003;','i')">
                    <xsl:value-of select="replace(.,'^&#x2003;','&#x00A0;&#x00A0;','i')"/>
               </xsl:when>
               <xsl:when test="matches(.,'^&#x0020;&#x0020;','i')">
                    <xsl:value-of select="replace(.,'^&#x0020;&#x0020;','&#x00A0;&#x00A0;','i')"/>
               </xsl:when>
               <xsl:when test="matches(.,'^&#x0020;','i')">
                    <xsl:value-of select="replace(.,'^&#x0020;','&#x00A0;','i')"/>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:value-of select="."/>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>

</xsl:stylesheet>
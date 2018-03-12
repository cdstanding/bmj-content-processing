<?xml version="1.0" encoding="utf-8"?>
<!-- ============================================================= -->
<!--  MODULE:    basics-display-objects-1-0.xsl                    -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      September 2004                                    -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:     Archiving and Interchange DTD Suite               -->
<!--             Journal Article Formatting                        -->
<!--                                                               -->
<!-- PURPOSE:    A module of article-fo.xsl that handles           -->
<!--             display objects such as graphic and chem-struct,  -->
<!--             which are usually grouped with titling data       -->
<!--             inside an element such as fig or boxed-text.      -->
<!--                                                               -->
<!-- CONTAINS:   Templates for:                                    -->
<!--             1) graphic and media                              -->
<!--             2) disp-formula                                   -->
<!--             3) chem-struct                                    -->
<!--             4) array                                          -->
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
<!-- DISPLAY OBJECTS                                               -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!-- TEX-MATH                                                  -->
<!-- ============================================================= -->


<xsl:template match="tex-math">

  <fo:inline id="{@id}">
    <xsl:text>[TeX equation: not rendered by this stylesheet.] </xsl:text>
    <xsl:value-of select="."/>
  </fo:inline>
  
</xsl:template>


<!-- ============================================================= -->
<!-- GRAPHIC and MEDIA                                             -->
<!-- ============================================================= -->


<!-- Assumes graphic fits in the page width and height;
     doesn't specify size or scale. -->
     
<!-- A graphic may float if it is NOT inside a container that
     might float. The contexts in which graphic may NOT float
     are listed. -->

<!--     20140606 suppress media element in PDF-->
     <xsl:template match="media"/>
<xsl:template match="graphic ">

  <xsl:param name="float">
    <xsl:choose>
      <xsl:when test="self::graphic and @position='float' 
                 and not(ancestor::boxed-text
                         | ancestor::chem-struct-wrapper
                         | ancestor::disp-formula
                         | ancestor::fig
                         | ancestor::supplementary-material
                         | table-wrap)"><!-- This originally had "supplementary-material" as "aupllementary-material". Now corrected and will see if this makes a change anywhere.  -->
        <xsl:text>before</xsl:text>
      </xsl:when>
         <xsl:when test="self::graphic and ancestor::fig[@fig-type='theme']">
              <xsl:text>left</xsl:text>
         </xsl:when>
      <xsl:otherwise>
        <xsl:text>none</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
     <xsl:variable name="my-content-height">
          <xsl:choose>
               <xsl:when test="ancestor::fig[@fig-type='theme']">
                    <xsl:value-of select="'45mm'"/>
               </xsl:when>
               <xsl:when test="ancestor::fig[@fig-type='lead']">
                    <xsl:value-of select="'75%'"/>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:value-of select="'scale-to-fit'"/>
               </xsl:otherwise>
          </xsl:choose>
          
     </xsl:variable>
     <xsl:variable name="my-width">
          <xsl:choose>
               <xsl:when test="ancestor::supplementary-material[media[@mimetype='video']]">
                    <xsl:variable name="vid-factor" select="100 div count(//media[@mimetype='video'])"/>
                    <xsl:value-of select="concat($vid-factor,'%')"/>
               </xsl:when>
               <xsl:when test="ancestor::fig[@fig-type='theme']">
                    <xsl:value-of select="'100%'"/>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:value-of select="'100%'"/>
               </xsl:otherwise>
          </xsl:choose>
          
     </xsl:variable>
     
          
     
     <xsl:variable name="my-align">
          <xsl:choose>
               <xsl:when test="ancestor::fig[@fig-type='theme']">
                    <xsl:value-of select="'after'"/>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:value-of select="'auto'"/>
               </xsl:otherwise>
          </xsl:choose>
          
     </xsl:variable>
     <!--<xsl:message select="concat('graphics drive=',$graphics-location-drive,' graphics path=', $graphics-location-path)"/>-->
    <!--<xsl:variable name="thisfile" select="replace(@xlink:href,'.*?([^/]+)$',';$1')"/>-->
    <!--<xsl:variable name="thisfile" select="replace(@xlink:href,'.*?(.+)(\.)(.+)','$1')"/>-->
    <xsl:variable name="the-external-file">
      <xsl:text>../pdfgraphics/</xsl:text><xsl:value-of select="@xlink:href"/><xsl:text>.jpg</xsl:text>
    <!--<xsl:text>url(file:///</xsl:text>
<!-\-    <xsl:value-of select="$graphics-location-drive"/>
-\->    <xsl:value-of select="$graphics-location-path"/>
       <xsl:text>/</xsl:text>
       <xsl:value-of select="replace($thisfile,'(.*?)[^.]+$','$1jpg')"/> <!-\- required replace(.,&quot;.*?([^/]+)$&quot;,&quot;$1&quot;)-\->
    <xsl:text>)</xsl:text>-->
    </xsl:variable>
  
  <!-- if it's inside something that's already floating,
       don't let this float inside that float! -->
  <xsl:choose>
    <xsl:when test="ancestor::*[@position='float'] or ancestor::supplementary-material">
         <xsl:comment>float choice 1 content-width=scale-to-fit, content-height=<xsl:value-of select="$my-content-height"/> width=<xsl:value-of select="$my-width"/>align=<xsl:value-of select="$my-align"/></xsl:comment>
         <xsl:element name="fo:external-graphic">
              <xsl:attribute name="src" select="$the-external-file"/>
              <xsl:attribute name="content-width" select="'scale-to-fit'"/>
              <xsl:attribute name="content-height" select="$my-content-height"/>
<!--              <xsl:attribute name="content-height" select="'100%'"/>
<xsl:attribute name="width" select="'100%'"/>-->
              <xsl:attribute name="display-align" select="$my-align"/>
<!--              <xsl:attribute name="width" select="$my-width"/>-->
              <xsl:attribute name="width" select="$my-width"/>
              <xsl:attribute name="scaling" select="'uniform'"/>
         </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <fo:float float="{$float}">
           <xsl:comment>float choice 2 content-width=scale-to-fit, content-height=<xsl:value-of select="$my-content-height"/> width=<xsl:value-of select="$my-width"/>align=<xsl:value-of select="$my-align"/></xsl:comment>
           <xsl:element name="fo:block">
                <xsl:element name="fo:external-graphic">
                     <xsl:attribute name="src" select="$the-external-file"/>
                     <xsl:attribute name="content-width" select="'scale-to-fit'"/>
                     <xsl:attribute name="content-height" select="$my-content-height"/>
<!--                     <xsl:attribute name="content-height" select="'100%'"/>
-->              <xsl:attribute name="width" select="$my-width"/>
                     <xsl:attribute name="display-align" select="$my-align"/>
                     <!--<xsl:attribute name="width" select="'100%'"/>-->
                     <xsl:attribute name="scaling" select="'uniform'"/>
                </xsl:element>
           </xsl:element>
      </fo:float>
    </xsl:otherwise>
  </xsl:choose>
  
</xsl:template>


<!-- ============================================================= -->
<!-- DISP-FORMULA                                                  -->
<!-- ============================================================= -->


<!-- The contents of a disp-formula are not unique to disp-formula:
     they're things like text with emphases, math, graphic, etc.,
     all of which are handled by their respective templates. -->

<!-- disp-formula is numbered only if referenced. -->

<xsl:template match="disp-formula">

  <xsl:param name="object-id" select="@id"/>

  <fo:block id="{@id}"
            line-stacking-strategy="max-height">
  
    <xsl:if test="key('element-by-rid', $object-id)[self::xref]">
      <xsl:call-template name="calculate-disp-formula-number">
        <xsl:with-param name="object-id" select="$object-id"/>
      </xsl:call-template>
    </xsl:if>
    
    <xsl:apply-templates/>
  
  </fo:block>
  
</xsl:template>

  
<!-- ============================================================= -->
<!-- CHEM-STRUCT                                                   -->
<!-- ============================================================= -->


<!-- chem-struct is contained within chem-struct-wrapper and many
     other contexts. -->

<!-- The contents of a chem-struct are not unique to chem-struct:
     they're things like text with emphases, math, graphic, etc.,
     all of which are handled by their respective templates. -->
     
<!-- Note: although chem-struct has an @id, the legitimate
     target for cross-referencing is the chem-struct-wrapper. -->


<xsl:template match="chem-struct">

  <fo:block id="{@id}">
    <xsl:apply-templates/>
  </fo:block>
  
</xsl:template>


<!-- ============================================================= -->
<!-- ARRAY                                                         -->
<!-- ============================================================= -->


<!-- Arrays do not have @id, label, title, or caption.
     They do not float.
     They are set in the regular content area, 
     NOT out at the textboxLMarg.
     
     An array can contain media, graphic, or tbody,
     and optionally a copyright-statement.
     The behavior for each of these parts is specified
     in its proper place, so all we have to do here is
     manage the array's space-above and space-below. -->
     
    
<xsl:template match="array">

  <xsl:param name="space-before" select="$leading-around-narrative-blocks"/>
  <xsl:param name="space-after"  select="$leading-around-narrative-blocks"/>
  
  <fo:block space-before="{$space-before}"
            space-before.precedence="1"
            space-after="{$space-after}"
            space-after.precedence="1">
    <xsl:apply-templates/>
  </fo:block>
  
</xsl:template>


</xsl:stylesheet>
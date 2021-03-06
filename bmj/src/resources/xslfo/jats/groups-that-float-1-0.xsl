﻿<?xml version="1.0" encoding="utf-8"?>
<!-- ============================================================= -->
<!--  MODULE:    groups-that-float-1-0.xsl                         -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      September 2004                                    -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:     Archiving and Interchange DTD Suite               -->
<!--             Journal Article Formatting                        -->
<!--                                                               -->
<!-- PURPOSE:    A module of article-fo.xsl that handles           -->
<!--             grouping elements that may float.                 -->
<!--                                                               -->
<!-- CONTAINS:   Templates for:                                    -->
<!--             1) preformat                                      -->
<!--             2) boxed-text                                     -->
<!--             3) chem-struct-wrapper                            -->
<!--             4) supplementary-material                         -->
<!--             Note: table-wraps and figures, which also may     -->
<!--             are are handled in separate, eponymous modules.   -->
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
<!-- FIGURE AND TABLE-WRAP                                         -->
<!-- ============================================================= -->


<!-- Figures and table-wraps float, but they're complicated enough 
     groups that for ease of reading they're stored in separate 
     stylesheets:
       - groups-figures.xsl
       - groups-table-wraps.xsl
-->
     
     
<!-- ============================================================= -->
<!-- PREFORMAT                                                     -->
<!-- ============================================================= -->

<!-- DO NOT "fix" the linespacing in the following code for fo:block! 
     Any linespace inside the fo:block *will* be preserved in output, 
     adding to any linespaces in the source document, which 
     won't be what's wanted at all. -->
     
<xsl:template match="preformat">

  <xsl:param name="space-before" select="$leading-around-display-blocks"/>
  <xsl:param name="space-after"  select="$leading-around-display-blocks"/>
    
  <xsl:param name="float">
    <xsl:choose>
      <xsl:when test="@position='float'">
        <xsl:text>before</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>none</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  
  <fo:float float="{$float}">
    <fo:block id="{@id}"
              space-before="{$space-before}" space-before.precedence="1"
              space-after="{$space-after}"    space-after.precedence="1"
              linefeed-treatment="preserve"
              white-space-treatment="preserve"
              white-space-collapse="false"><fo:wrapper font-family="Courier"
                    font-size="9pt"
                    line-height="10pt"><xsl:apply-templates/></fo:wrapper></fo:block>  
  </fo:float>
</xsl:template>


<!-- ============================================================= -->
<!-- BOXED-TEXT                                                    -->
<!-- ============================================================= -->


<xsl:template match="boxed-text">

  <xsl:param name="space-before" select="$leading-around-narrative-blocks"/>
  <xsl:param name="space-after"  select="$leading-around-narrative-blocks"/>
     <xsl:param name="myid">
          <xsl:value-of select="generate-id()"/>
     </xsl:param>
  <xsl:param name="float">
    <xsl:choose>
      <xsl:when test="@position='float'">
        <xsl:text>before</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>none</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
     
     <xsl:param name="margin-width">
          <xsl:choose>
               <xsl:when test="sum(count(.//text()))  &gt; 60">
                    <xsl:text>0pc</xsl:text>
               </xsl:when>
               <xsl:when test="sum(count(.//text()))  &gt; 50">
                    <xsl:text>1pc</xsl:text>
               </xsl:when>
               <xsl:when test="sum(count(.//text()))  &gt; 40">
                    <xsl:text>2pc</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:text>0pc</xsl:text>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:param>
     
     <xsl:param name="keep-box-together">
          <xsl:choose>
               <xsl:when test="sum(count(.//text()))  &gt; 60">
                    <xsl:text>auto</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:text>0</xsl:text>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:param>
  
  <fo:float float="{$float}">
       <xsl:comment>text  count for this box is <xsl:value-of select="sum(count(.//text())) "></xsl:value-of></xsl:comment>
    <fo:block id="{@id}"
              keep-together.within-page="{$keep-box-together}"
              space-before="{$space-before}" space-before.precedence="1"
              space-after="{$space-after}"    space-after.precedence="1"
              border-width="0.5pt"
              border-style="none"
              margin-left="{$margin-width}"
              margin-right="{$margin-width}"
              padding-top="6pt"
              padding-bottom="6pt"
              padding-left="6pt"
              padding-right="6pt"
              background-color="#E3DFD5"
              font-family="{$titlefont}"
              font-size="{$textsize*0.7}pt"
              line-height="{$textleading*0.7}pt">
              
      <xsl:apply-templates/>
    </fo:block>
  </fo:float>
</xsl:template>


<xsl:template match="boxed-text/caption/title">
  <fo:block text-align="left"
            space-after="{$leading-below-titles-big}"
            space-after.precedence="force"
            keep-with-next.within-page="always">
    <fo:wrapper font-family="{$titlefont}"
                font-size="7.44pt"
                font-weight="bold">
        <xsl:if test=".[parent::caption[preceding-sibling::label]]">
            <xsl:value-of select="./parent::caption/preceding-sibling::label"/>
            <xsl:text>:&#x0020;</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </fo:wrapper>
  </fo:block>
</xsl:template>
    
    <!-- Suppress label for boxed text as this is dealt with in the above template -->
    <xsl:template match="boxed-text/label"/>


<!-- ============================================================= -->
<!-- CHEM-STRUCT-WRAPPER                                           -->
<!-- ============================================================= -->


<!-- chem-struct-wrapper is numbered only if referenced. 
     (Note that chem-struct themselves are display objects and
     NOT considered legitimate targets of cross-referencing
     for the purpose of this formatting. -->

<xsl:template match="chem-struct-wrapper">

  <xsl:param name="object-id" select="@id"/>

  <xsl:param name="space-before" select="$leading-around-display-blocks"/>
  <xsl:param name="space-after"  select="$leading-around-display-blocks"/>
    
  <xsl:param name="float">
    <xsl:choose>
      <xsl:when test="@position='float'">
        <xsl:text>before</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>none</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  
  <fo:float float="{$float}">
    <fo:block id="{@id}">

      <xsl:if test="key('element-by-rid', $object-id)[self::xref]">
        <xsl:call-template name="calculate-chem-struct-number">
          <xsl:with-param name="object-id" select="$object-id"/>
        </xsl:call-template>
      </xsl:if>

      <xsl:apply-templates/>

    </fo:block>
  </fo:float>
  
</xsl:template>


<!-- ============================================================= -->
<!-- SUPPLEMENTARY-MATERIAL                                        -->
<!-- ============================================================= -->


<!-- content model is very like a fig. -->

<!--<xsl:template match="supplementary-material">

  <xsl:param name="space-before" select="$leading-around-display-blocks"/>
  <xsl:param name="space-after"  select="$leading-around-display-blocks"/>
    
  <xsl:param name="float">
    <xsl:choose>
         <xsl:when test="@position='float'">
        <xsl:text>before</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>none</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  
  <fo:float float="{$float}">
    <fo:block id="{@id}"
              space-before="{$space-before}"
              space-after="{$space-after}"
              line-stacking-strategy="max-height">
         
         <xsl:choose>
              <xsl:when test="./media[@mimetype='video']">
                   <xsl:call-template name="set-supmat-video"/>
              </xsl:when>
              <xsl:otherwise>
                   <xsl:call-template name="set-supmat-apparatus"/>
                   
                   <xsl:apply-templates select="caption/p"/>
                   
                   <xsl:apply-templates select="copyright-statement" mode="display"/>
              </xsl:otherwise>
         </xsl:choose>
         
         
      

    </fo:block>
  </fo:float>
  
  </xsl:template>-->
<!--     Suppress supplementary material as it is being processed in named template-->
     <xsl:template match="supplementary-material"/>
 
 <xsl:template match="supplementary-material" mode="supp-mat-as-footnote">
                     <xsl:call-template name="set-supmat-video"/>

 </xsl:template>
<xsl:template match="supplementary-material" mode="put-at-end">
          
          <xsl:param name="space-before" select="$leading-around-display-blocks"/>
          <xsl:param name="space-after"  select="$leading-around-display-blocks"/>
          
          <xsl:param name="float">
               <xsl:choose>
                    <xsl:when test="@position='float'">
                         <xsl:text>before</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:text>none</xsl:text>
                    </xsl:otherwise>
               </xsl:choose>
          </xsl:param>
          
          <fo:float float="{$float}">
               <fo:block id="{@id}"
                    space-before="{$space-before}"
                    space-after="{$space-after}"
                    line-stacking-strategy="max-height">
                    
                    <xsl:choose>
                         <xsl:when test="./media[@mimetype='video']">
                              <!--                   process for Video -->
                              <xsl:call-template name="set-supmat-video"/>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:call-template name="set-supmat-apparatus"/>
                              
                              <!-- caption/p's, if any -->
                              <!-- a caption can contain ONLY title and p's, and we've
                                   already dealt with the title -->
                              <xsl:apply-templates select="caption/p"/>
                              
                              <!-- the fig/copyright if any -->
                              <xsl:apply-templates select="copyright-statement" mode="display"/>
                         </xsl:otherwise>
                    </xsl:choose>
               </fo:block>
          </fo:float>
          
     </xsl:template>
     
     
     
     
     

<xsl:template name="set-supmat-video">
     <xsl:apply-templates select="./graphic"/>
     <xsl:apply-templates select="./caption/*[1]"/>
</xsl:template>
<xsl:template name="set-supmat-apparatus">

    <xsl:choose>
      
      <!-- if there's a label with a space in it, assume the
           label contains both string and number -->
      <xsl:when test="contains(label, ' ')">
        <xsl:apply-templates select="label" mode="pass-through"/>
      </xsl:when>
      
      <!-- if there's a label but it has no space, 
           generate a string and use the label -->
      <xsl:when test="label">
        <xsl:text>Supplementary Material </xsl:text>
        <xsl:apply-templates select="label" mode="pass-through"/>
      </xsl:when>
      
      <!-- Otherwise, choose the string AND calculate the number -->
      <xsl:otherwise>
        <xsl:text>Supplementary Material</xsl:text>
        <xsl:number count="supplementary-material"
                    from="/"
                    level="any"
                    format="1"/>
      </xsl:otherwise>

    </xsl:choose>
    
    <xsl:text>. </xsl:text>
    
    <xsl:apply-templates select="caption/title" mode="display"/>
    
    <!-- name of external link if any -->
    <xsl:apply-templates select="@xlink:href"/>
    
    
</xsl:template>


<xsl:template match="supplementary-material/caption/title" mode="display">

  <fo:wrapper font-family="{$textfont}"
              font-size="9pt"
              font-weight="bold">
    <xsl:apply-templates/>
    <xsl:text>. </xsl:text>
  </fo:wrapper>
  
</xsl:template>


<xsl:template match="supplementary-material/copyright-statement" mode="display">

  <fo:block>
    <fo:wrapper font-family="{$textfont}"
                font-size="9pt"
                font-weight="normal">
      <xsl:apply-templates select="copyright" mode="display"/>
    </fo:wrapper>
  </fo:block>
  
</xsl:template>


<xsl:template match="supplementary-material/@xlink:href">

  <fo:wrapper>
    <xsl:text>See </xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>. </xsl:text>
  </fo:wrapper>

</xsl:template>


 <!-- suppress label and caption/title in no-mode -->
 <xsl:template match="supplementary-material/label
                    | supplementary-material/caption/title"/>
                    
 
</xsl:stylesheet>


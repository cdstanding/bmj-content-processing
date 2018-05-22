<?xml version="1.0" encoding="utf-8"?>
<!-- ============================================================= -->
<!--  MODULE:    Journal Article Formatting (article-fo.xsl)       -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      September 2004                                    -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:     Archiving and Interchange DTD Suite               -->
<!--             Journal Article Formatting                        -->
<!--                                                               -->
<!-- PURPOSE:    A starter FO stylesheet for journal articles      -->
<!--             that are tagged according to the NCBI             -->
<!--             Journal Publishing DTD (with additional           -->
<!--             constraints that are described in                 -->
<!--             article-fo-constraints.txt)                       -->
<!--                                                               -->
<!-- CONTAINS:   1. Module includes                                -->
<!--             2. Templates for root and article                 -->
<!--             3. Mode: pass-through                             -->
<!--                                                               -->
<!-- INPUT:      1) An XML document valid to Version 1.1 of the    -->
<!--                NCBI Publishing DTD                            -->
<!--                                                               -->
<!-- OUTPUT:     1) A XSL-FO file of the journal article.          -->
<!--                Testing used AntennaHouse XSL Formatter        -->
<!--                2.5.2004.107                                   -->
<!--                The formatted article consists of:             -->
<!--                - cover page showing key article metadata      -->
<!--                - the formatted article (as many pages as      -->
<!--                   needed)                                     -->
<!--                - a final page or pages of user warnings       -->
<!--                  and notes relating to the transformation     --> 
<!--                  (see article-fo-constraints.txt for          -->
<!--                  explanations of these warnings and notes)    -->
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
     xmlns:rx="http://www.renderx.com/XSL/Extensions"
     extension-element-prefixes="m">

     <xsl:output method="xml" indent="no"/>
     <xsl:strip-space
          elements="abstract ack address annotation app app-group 
                           array article article-categories article-meta 
                           author-comment author-notes back bio body boxed-text 
                           break caption chem-struct chem-struct-wrapper 
                           citation col colgroup conference contrib contrib-group 
                           copyright-statement date def def-item def-list 
                           disp-quote etal fig fig-group fn fn-group front 
                           gloss-group glossary glyph-ref graphic history hr 
                           inline-graphic journal-meta kwd-group list list-item 
                           media mml:math name nlm-citation note notes page-count 
                           person-group private-char pub-date publisher ref 
                           ref-list response sec speech statement sub-article 
                           subj-group supplementary-material table table-wrap 
                           table-wrap-foot table-wrap-group tbody tfoot thead 
                           title-group tr trans-abstract verse-group
                           "/>
     <xsl:preserve-space elements="preformat"/>


     <!-- ============================================================= -->
     <!-- TO GET STARTED                                                -->
     <!-- ============================================================= -->

     <!-- Put this file and all the xsl:include files listed below
     in a single directory.
     
     Edit util-variables-and-keys-.1-0.xsl to:

       - set the graphics location
       - toggle the display of diagnostic pages after the last
         page of the article.
       
     Make sure the XML document's DOCTYPE declaration points to the
     correct DTD location - otherwise special characters will fail.
     
     Document assumptions and constraints are detailed in
     the file article-fo-constraints.txt.

-->

     <!-- ============================================================= -->
     <!-- INCLUDED FRAGMENTS                                            -->
     <!-- ============================================================= -->
    
    <xsl:param name="pdfPreview"/>
    
     <xsl:include href="util-variables-and-keys-1-0.xsl"/>
     <xsl:include href="setup-page-layout-1-0.xsl"/>
     <xsl:include href="set-cover-page-1-0.xsl"/>
     <xsl:include href="set-opener-body-back-1-0.xsl"/>

     <xsl:include href="basics-paragraphs-1-0.xsl"/>
     <xsl:include href="basics-inlines-1-0.xsl"/>
     <xsl:include href="basics-sections-1-0.xsl"/>
     <xsl:include href="basics-referencing-elements-1-0.xsl"/>
     <xsl:include href="basics-display-objects-1-0.xsl"/>
     <xsl:include href="basics-backmatter-1-0.xsl"/>

     <xsl:include href="groups-lists-1-0.xsl"/>
     <xsl:include href="groups-by-content-type-1-0.xsl"/>
     <xsl:include href="groups-footnotes-1-0.xsl"/>
     <xsl:include href="groups-ref-list-1-0.xsl"/>

     <xsl:include href="groups-figures-1-0.xsl"/>
     <xsl:include href="groups-table-wraps-1-0.xsl"/>
     <xsl:include href="groups-that-float-1-0.xsl"/>

     <xsl:include href="util-calculate-numbers-1-0.xsl"/>
     <xsl:include href="util-named-title-styles-1-0.xsl"/>

     <xsl:include href="util-diagnostics-1-0.xsl"/>


     <!-- ============================================================= -->
     <!-- ON ROOT, SET UP PAGE LAYOUTS and PROCESS DOCUMENT             -->
     <!-- ============================================================= -->


     <xsl:template match="/">

          <fo:root>
<!--               <xsl:processing-instruction name="xep-pdf-userpassword" select="'bmj'"/>
               <xsl:processing-instruction name="xep-pdf-userprivileges" select="'annotate'"/>
-->               <fo:layout-master-set>
                    <xsl:call-template name="define-simple-page-masters"/>
                    <xsl:call-template name="define-page-sequences"/>
               </fo:layout-master-set>

               <xsl:apply-templates/>

          </fo:root>
     </xsl:template>


     <!-- ============================================================= -->
     <!-- ON DOCUMENT ELEMENT, SET UP AND POPULATE THE PAGE FLOWS       -->
     <!-- ============================================================= -->


     <!-- This template controls the order of the main parts:
     cover page, article-opener and body, and backmatter. 
     Each is handled by a named template. -->

     <!-- Call the document content into the pages.                     -->

     <xsl:template match="/article">

          <!-- Populate the cover-page sequence -->
          <!--<fo:page-sequence master-reference="seq-cover">
  
    <xsl:call-template name="define-headers"/>
    <xsl:call-template name="define-before-float-separator"/>
    
    <fo:flow flow-name="body">
      <fo:block space-before="0pt"
                space-after="0pt"
                margin-top="0pt"
                margin-bottom="0pt"
                line-stacking-strategy="font-height"
                line-height-shift-adjustment="disregard-shifts">
        <xsl:call-template name="set-article-cover-page"/>
      </fo:block>
    </fo:flow>
    
  </fo:page-sequence>-->

          <!-- Populate the content sequence -->
          <fo:page-sequence master-reference="seq-content" initial-page-number="1"
               >

               <xsl:call-template name="define-headers"/>
               <xsl:call-template name="define-before-float-separator"/>
               <xsl:call-template name="define-footnote-separator"/>

               <fo:flow flow-name="body">


                    <!-- set the article opener, body, and backmatter -->
                    <xsl:call-template name="set-article-opener"/>
                    <fo:block space-before="0pt" space-after="0pt" start-indent="{$mainindent}pc"
                         line-stacking-strategy="font-height" line-height-shift-adjustment="disregard-shifts">
                         <!--<xsl:if test="$section-column-count = 1">
                              <xsl:attribute name="margin-left" select="'6pc'"/>
                              <xsl:attribute name="margin-right" select="'6pc'"/>
                              <xsl:attribute name="start-indent" select="'6pc'"/>
                         </xsl:if>-->
                         <xsl:call-template name="set-article-body"/>
                         <xsl:call-template name="set-article-back"/>
                    </fo:block>
                    <fo:block span="all"><fo:leader leader-length="0pt" 
                         leader-pattern="space"/></fo:block>
<!--                    <xsl:if test="(//table-wrap or //fig) 
                         and (not(matches(/article/front/article-meta/article-categories/subj-group[@subj-group-type='heading']/subject,'Editorial|Observation|Obituar|Short Cuts|Minerva|Views &amp; Reviews','i'))
                         or (count(//fig) - count(//fig[matches(@fig-type,'theme|lead')]) !=0))">
-->                         
<!--                    <xsl:if test="(//table-wrap
                               or (count(//fig) - count(//fig[matches(@fig-type,'theme|lead')]) !=0)) 
                               and not(matches(/article/front/article-meta/article-categories/subj-group[@subj-group-type='heading']/subject,'Editorial|Observation|Obituar|Short Cuts|Minerva|Views &amp; Reviews','i'))">-->
                         <xsl:if test="(//table-wrap
                              or (count(//fig) - count(//fig[matches(@fig-type,'theme|lead')]) !=0))">
                              <fo:block space-before="0pt" space-after="0pt" start-indent="{$mainindent}pc"
                              line-stacking-strategy="font-height" line-height-shift-adjustment="disregard-shifts"
                              span="all">
                              <xsl:call-template name="set-article-back-tables-figs"/>
                         </fo:block>
                    </xsl:if>
                    

                    <!-- an id of 0 height on last article page, 
           for use in page headers -->
                    
                    <fo:block id="last-article-page" space-before="0pt" space-after="0pt"
                         margin-top="0pt" margin-bottom="0pt" line-height="0pt"><fo:leader leader-length="0pt" 
                              leader-pattern="space"/></fo:block>
               </fo:flow>

          </fo:page-sequence>


          <!-- If requested, produce document diagnostics 
       (after the end of the article). -->

          <xsl:if test="$produce-diagnostics">
               <!-- has a page sequence in it and all else needed -->
               <xsl:call-template name="run-diagnostics"/>
          </xsl:if>



     </xsl:template>


     <!-- ============================================================= -->
     <!-- MODE = PASS-THROUGH                                           -->
     <!-- ============================================================= -->


     <!-- For use when the element must be handled in a mode
     (to avoid duplicate production) and the intention
     is simply to process the element's content, i.e.,
     without adding spaces, punctuation, fonts, etc. -->

     <!-- used on cover page -->

     <xsl:template mode="pass-through"
          match="article-title | alt-title
       | abbrev-journal-title | journal-title | journal-id
       | volume | issue | supplement | fpage | lpage">
          <xsl:apply-templates/>
     </xsl:template>

     <!-- used in article-opener -->

     <xsl:template mode="pass-through"
          match="name | given-names | surname | suffix | collab
                   | role | on-behalf-of">
          <xsl:apply-templates mode="pass-through"/>
     </xsl:template>



</xsl:stylesheet>

<?xml version="1.0" encoding="utf-8"?>
<!-- ============================================================= -->
<!--  MODULE:    setup-page-layout-1-0.xsl                         -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      September 2004                                    -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:     Archiving and Interchange DTD Suite               -->
<!--             Journal Article Formatting                        -->
<!--                                                               -->
<!-- PURPOSE:    A module of article-fo.xsl that establishes the   -->
<!--             page layout.                                      -->
<!--                                                               -->
<!-- CONTAINS:   Templates for:                                    -->
<!--             1) Simple page masters                            -->
<!--             2) Page sequences                                 -->
<!--             3) Named-template: define-headers                 -->
<!--             4) Named-template: define-diagnostics-headers     -->
<!--             5) Named template: assemble-page-header-contents  -->
<!--             6) Named template: define-before-float-separator  -->
<!--             7) Named template: define-footnote-separator      -->
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
                xmlns:xlink="http://www.w3.org/1999/xlink">


<!-- ============================================================= -->
<!-- SIMPLE PAGE MASTERS                                           -->
<!-- ============================================================= -->

     <xsl:variable name="logo-file" select="concat($logo-location-path,'/','bmjlogonew.jpg')"/>
     <xsl:variable name="cc-logo">
          <xsl:choose>
               <xsl:when test="matches(/article/front/article-meta/permissions/license/@xlink:href,'/by/')">
                    <xsl:value-of select="concat('file:///',$logo-location-path,'/','bycc_default.jpg')"/>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:value-of select="concat('file:///',$logo-location-path,'/','by-nc.eu_default.jpg')"/>
               </xsl:otherwise>
          </xsl:choose>
          
     </xsl:variable>
     <xsl:variable name="pub-date-string">
         <xsl:choose>
             <xsl:when test="$pdfPreview = 'pdfPreview'"/>
             <xsl:otherwise>
                 <xsl:choose>
                     <xsl:when test="//front/article-meta/pub-date[@pub-type='epub']/day
                         and //front/article-meta/pub-date[@pub-type='epub']/month
                         and //front/article-meta/pub-date[@pub-type='epub']/month">
                         <xsl:text>(Published </xsl:text>
                         <xsl:apply-templates select="//front/article-meta/pub-date[@pub-type='epub']/month" mode="pub-date"></xsl:apply-templates>
                         <xsl:text> </xsl:text>
                         <xsl:value-of select="//front/article-meta/pub-date[@pub-type='epub']/year"/>
                         <xsl:text>)</xsl:text>
                     </xsl:when>
                     <xsl:when test="$batchPubDate !=''">
                         <xsl:variable name="dateasno">
                             <xsl:element name='day'>
                                 <xsl:value-of select="replace($batchPubDate,'(\d+)/(\d+)/(\d+)','$1')"/>
                             </xsl:element>
                             <xsl:element name='month'>
                                 <xsl:value-of select="replace($batchPubDate,'(\d+)/(\d+)/(\d+)','$2')"/>
                             </xsl:element>
                             <xsl:element name='year'>
                                 <xsl:value-of select="replace($batchPubDate,'(\d+)/(\d+)/(\d+)','$3')"/>
                             </xsl:element>
                         </xsl:variable>
                         <xsl:text>(Published </xsl:text>
                         <xsl:apply-templates select="$dateasno/month" mode="pub-date"/>
                         <xsl:text> </xsl:text>
                         <xsl:value-of select="$dateasno/year"/>
                         <xsl:text>)</xsl:text>
                     </xsl:when>
                     <xsl:otherwise/>
                 </xsl:choose>
             </xsl:otherwise>
         </xsl:choose>
          
     </xsl:variable>
     <xsl:template name="define-simple-page-masters">

      <!-- blank and cover are similar -->
      
      <!-- cover page uses recto margins -->
      <fo:simple-page-master master-name="lo-cover"
                             page-height="11in"
                             page-width="8.5in"
                             margin-top="0.5in"
                             margin-bottom="1.0in"
                             margin-left="1.25in"
                             margin-right="1.25in">

        <fo:region-body      region-name="body"
                             margin-top="24pt"
                             margin-bottom="0in"
                             margin-left="0in"
                             margin-right="0in"/>

        <fo:region-before    region-name="no-header"
          display-align="before"
          extent="12pt"/>
        
        <fo:region-after     region-name="no-footer"
                             extent="0in"/>
      </fo:simple-page-master>

      <!-- blank page -->
      <fo:simple-page-master master-name="lo-blank"
                             page-height="11in"
                             page-width="8.5in"
                             margin-top="0.5in"
                             margin-bottom="1.0in"
                             margin-left="1.25in"
                             margin-right="1.25in">

        <fo:region-body      region-name="body"
                             margin-top="24pt"
                             margin-bottom="0in"
                             margin-left="0in"
                             margin-right="0in"/>
        
        <fo:region-before    region-name="no-header"
          display-align="before"
          extent="12pt"/>
        
        <fo:region-after     region-name="no-footer"
                             extent="0in"/>
      </fo:simple-page-master>

      
      <!-- first has recto margins -->
      <fo:simple-page-master master-name="lo-first"
      
                             page-height="297mm"
                             page-width="210mm"
                             margin-top="5mm"
                             margin-bottom="5mm"
                             margin-left="20mm"
                             margin-right="20mm">

        <fo:region-body      region-name="body"
                             margin-top="65mm"
                             margin-bottom="5mm"
                             margin-left="0in"
                             margin-right="0in"
                             column-count="{$section-column-count}"
                             column-gap="1.5pc"/>

        <fo:region-before    region-name="first-header"
          display-align="before"
          extent="65mm"/>
        
        <fo:region-after     region-name="first-footer"
                             extent="3.5mm"
                             display-align="after"/>
      </fo:simple-page-master>

      <!-- verso page -->
      <fo:simple-page-master master-name="lo-verso"
      
                               page-height="297mm"
                               page-width="210mm"
                               margin-top="5mm"
                               margin-bottom="5mm"
                               margin-left="20mm"
                               margin-right="20mm">
           
        <fo:region-body      region-name="body"
                             margin-top="25mm"
                             margin-bottom="5mm"
                             margin-left="0in"
                             margin-right="0in"
                             column-count="{$section-column-count}"
                             column-gap="1.5pc"/>
           

        <fo:region-before    region-name="verso-header"
          display-align="before"
          extent="10mm"/>
        
        <fo:region-after     region-name="first-footer"
                             display-align="after"
                             extent="3.5mm"/>
      </fo:simple-page-master>

      <!-- recto page -->
      <fo:simple-page-master master-name="lo-recto"
      
                             page-height="297mm"
                             page-width="210mm"
                             margin-top="5mm"
                             margin-bottom="5mm"
                             margin-left="20mm"
                             margin-right="20mm">

        <fo:region-body      region-name="body"
                             margin-top="25mm"
                             margin-bottom="5mm"
                             margin-left="0in"
                             margin-right="0in"
                             column-count="{$section-column-count}"
                             column-gap="1.5pc"/>

        <fo:region-before    region-name="recto-header"
          display-align="before"
          extent="10mm"/>
        
           <fo:region-after     region-name="first-footer"
                display-align="after"
                extent="3.5mm"/>
      </fo:simple-page-master>
     
     
     
     

</xsl:template>


<!-- ============================================================= -->
<!-- PAGE SEQUENCES                                                -->
<!-- ============================================================= -->


<!-- There are three page sequences, for the cover,
     article, and diagnostics. -->
     

<xsl:template name="define-page-sequences">


    <!-- seq-cover page sequence master is: 
         cover+, blank -->

    <fo:page-sequence-master master-name="seq-cover">
    
      <fo:repeatable-page-master-reference master-reference="lo-cover"/>
      <fo:single-page-master-reference     master-reference="lo-blank"/>
      
    </fo:page-sequence-master>
    

    <!-- seq-content page sequence master is:  
         first, (verso, recto)+ -->

    <fo:page-sequence-master master-name="seq-content">
    
      <fo:single-page-master-reference master-reference="lo-first"/>
      
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference odd-or-even="even"
                                              master-reference="lo-verso"/>
        <fo:conditional-page-master-reference odd-or-even="odd"
                                              master-reference="lo-recto"/>
      </fo:repeatable-page-master-alternatives>
         
    </fo:page-sequence-master>
    
    
    <!-- seq-diagnostics page sequence master is: 
         (recto, verso)+ -->

    <fo:page-sequence-master master-name="seq-diagnostics">
    
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference odd-or-even="odd"
                                              master-reference="lo-recto"/>
        <fo:conditional-page-master-reference odd-or-even="even"
                                              master-reference="lo-verso"/>
      </fo:repeatable-page-master-alternatives>
      
    </fo:page-sequence-master>
    

</xsl:template>


<!-- ============================================================= -->
<!-- DEFINE STATIC CONTENT FOs FOR PAGE HEADERS                    -->
<!-- ============================================================= -->
 
 <!-- The actual assembly of content is complicated because
      it must decide what content is available. So, to keep
      the static-content flows easy to read, that work is 
      done in separate named templates. -->
      
 <!-- The article body pages and the diagnostics pages are
      handled by the same templates: the pagination is
      differentiated by the test is-diagnostics-page.
      The diagnostics page sequence master uses only verso
      and recto pages. -->
      
  <xsl:template name="define-headers">
  
     <xsl:param name="is-diagnostics-page"/>
     
 
     <fo:static-content flow-name="first-header">
       <fo:block text-align="start" 
                 line-height="12pt">
         <fo:wrapper font-family="{$titlefont}"
                     font-size="8pt">
           <xsl:call-template name="assemble-first-page-header"/>
         </fo:wrapper>
       </fo:block>
   </fo:static-content>
   
   
   <fo:static-content flow-name="recto-header">
     <fo:block line-height="12pt">
       <fo:wrapper font-family="{$titlefont}"
                   font-size="8pt">
         <xsl:call-template name="assemble-recto-header">
           <xsl:with-param name="is-diagnostics-page" select="$is-diagnostics-page"/>
         </xsl:call-template>
       </fo:wrapper>
     </fo:block>
   </fo:static-content>
   
 
   <fo:static-content flow-name="verso-header">
     <fo:block line-height="12pt">
       <fo:wrapper font-family="{$titlefont}"
                   font-size="8pt">
         <xsl:call-template name="assemble-verso-header">
           <xsl:with-param name="is-diagnostics-page" select="$is-diagnostics-page"/>
         </xsl:call-template>
       </fo:wrapper>
     </fo:block>
   </fo:static-content>
   
 
   <fo:static-content flow-name="no-header">
     <fo:block space-before="0pt"
               line-height="0pt"
               space-after="0pt"/>
   </fo:static-content> 
   
   
   <fo:static-content flow-name="no-footer">
     <fo:block space-before="0pt"
               line-height="0pt"
               space-after="0pt"/>
   </fo:static-content>
       
       <fo:static-content flow-name="first-footer">
            <fo:block line-height="{$fnleading}*0.8pt"
                 space-after="0pt">
                 <xsl:call-template name="assemble-first-footer"/>
            </fo:block>
       </fo:static-content>    

 </xsl:template>
 
 
<!-- ============================================================= -->
<!-- NAMED TEMPLATES: ASSEMBLE PAGE-HEADER CONTENTS                -->
<!-- ============================================================= -->


<xsl:template name="assemble-first-page-header">
     <xsl:param name="is-diagnostics-page"/>
     <fo:block text-align-last="justify">
          <fo:inline>
               <fo:external-graphic src="url({$logo-file})"
                    width="auto" height="50pt"
                    content-width="auto"
                    content-height="35pt"/>
          </fo:inline>
          <!--<xsl:if test="//front/article-meta/permissions/license[@license-type='open-access']">
               <fo:leader leader-alignment="reference-area" leader-pattern="space"/>
               <fo:inline>
                    <fo:external-graphic src="url({$cc-logo})"
                         width="auto" height="50pt"
                         content-width="auto"
                         content-height="35pt"/>
               </fo:inline>
          </xsl:if>-->
          </fo:block>
          <fo:block text-align-last="justify"
                    font-family="FreeSans"
                    font-size="{$fnsize}pt"
                    >
                    <fo:inline>
                         
                    <!-- change context node, choose journal title -->
          <xsl:for-each select="/article/front/journal-meta">
               <xsl:choose>
                    <xsl:when test="journal-id[@journal-id-type='nlm-ta']">
                         <fo:wrapper font-style="italic">
                              <xsl:apply-templates select="journal-id[@journal-id-type='nlm-ta']" mode="pass-through"/>
                         </fo:wrapper>
                    </xsl:when>
                    <xsl:when test="abbrev-journal-title">
                         <xsl:apply-templates select="abbrev-journal-title[1]" mode="pass-through"/>
                    </xsl:when>
                    <xsl:when test="journal-title">
                         <xsl:apply-templates select="journal-title[1]" mode="pass-through"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:apply-templates select="journal-id[1]" mode="pass-through"/>
                    </xsl:otherwise>
               </xsl:choose>
          </xsl:for-each>
          
          <xsl:if test="/article/front/article-meta/pub-date[@pub-type='epub']/year">
               <xsl:text> </xsl:text>
               <xsl:apply-templates select="/article/front/article-meta/pub-date[@pub-type='epub']/year" mode="pass-through"/>
          </xsl:if>
          
          
          <!-- change context node, get article info -->
          <xsl:for-each select="/article/front/article-meta">
               <xsl:if test="volume">
                    <xsl:text>;</xsl:text>
                    <xsl:apply-templates select="volume" mode="pass-through"/>
                    <xsl:text>:</xsl:text>
               </xsl:if>
               
               <xsl:if test="issue">
                    <xsl:text>, No. </xsl:text>
                    <xsl:apply-templates select="issue" mode="pass-through"/>
               </xsl:if>
               
               <xsl:if test="supplement">
                    <xsl:text>, Supp. </xsl:text>
                    <xsl:apply-templates select="supplement" mode="pass-through"/>
               </xsl:if>
               
               <xsl:if test="elocation-id">
                    <xsl:apply-templates select="elocation-id" mode="pass-through"/>
               </xsl:if>
               
               <xsl:if test="fpage">
                    <xsl:text> (</xsl:text>
                    <xsl:apply-templates select="fpage" mode="pass-through"/>
                    
                    <xsl:if test="lpage">
                         <xsl:text>&#x02013;</xsl:text>
                         <xsl:apply-templates select="lpage" mode="pass-through"/>
                    </xsl:if>
                    
                    <xsl:text>)</xsl:text>
               </xsl:if>
               <xsl:if test="article-id[@pub-id-type='doi']">
                    <xsl:text> doi:&#x0200A;</xsl:text>
                    <xsl:apply-templates select="article-id[@pub-id-type='doi']" mode="pass-through"/>
               </xsl:if>
          </xsl:for-each>
                         <xsl:if test="$pub-date-string !=''">
                              <xsl:text> </xsl:text>
                              <xsl:value-of select="$pub-date-string"/>
                         </xsl:if>
          <fo:leader leader-alignment="reference-area" leader-pattern="space"/>
          <xsl:if test="boolean($is-diagnostics-page)">
               <xsl:text>Diagnostics-</xsl:text>
          </xsl:if>
          
          <xsl:text>Page </xsl:text>
          
          <fo:page-number/>
          <xsl:text> of </xsl:text>
          
          <xsl:choose>
               <xsl:when test="boolean($is-diagnostics-page)">
                    <fo:page-number-citation ref-id="last-diagnostics-page"/>
               </xsl:when>
               <xsl:otherwise>
                    <fo:page-number-citation ref-id="last-article-page"/>
               </xsl:otherwise>
          </xsl:choose>
          </fo:inline>
          
     </fo:block>
     <fo:block background-color="{$section-colour}" font-family="{$titlefont}" font-size="15pt"
          space-before="5pt" space-after="5pt">
          <fo:inline color="{$section-colour}" font-size="2pt">
               <xsl:value-of select="//front/article-meta/article-categories/subj-group[@subj-group-type='heading']/subject/text()"/>
          </fo:inline>
     </fo:block>
     <fo:block  text-transform="uppercase" text-align="right" font-family="{$titlefont}" font-weight="bold" font-size="24pt" space-before="30pt"
          space-after="0pt">
          <fo:inline color="{$section-colour}">
               <xsl:value-of select="//front/article-meta/article-categories/subj-group[@subj-group-type='heading']/subject/text()"/>
          </fo:inline>
     </fo:block>

</xsl:template>
  

<xsl:template name="assemble-recto-header">

  <xsl:param name="is-diagnostics-page"/>

  <fo:block margin-left="0in"
            start-indent="0pc"
            space-after="0pt"
            text-align-last="justify"
            font-family="FreeSans"
            font-size="{$fnsize}pt">
    
       <!-- change context node, choose journal title -->
       <xsl:for-each select="/article/front/journal-meta">
            <xsl:choose>
                 <xsl:when test="journal-id[@journal-id-type='nlm-ta']">
                      <fo:wrapper font-style="italic">
                           <xsl:apply-templates select="journal-id[@journal-id-type='nlm-ta']" mode="pass-through"/>
                      </fo:wrapper>
                 </xsl:when>
                 <xsl:when test="abbrev-journal-title">
                      <xsl:apply-templates select="abbrev-journal-title[1]" mode="pass-through"/>
                 </xsl:when>
                 <xsl:when test="journal-title">
                      <xsl:apply-templates select="journal-title[1]" mode="pass-through"/>
                 </xsl:when>
                 <xsl:otherwise>
                      <xsl:apply-templates select="journal-id[1]" mode="pass-through"/>
                 </xsl:otherwise>
            </xsl:choose>
       </xsl:for-each>
       
       <xsl:if test="/article/front/article-meta/pub-date[@pub-type='epub']/year">
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="/article/front/article-meta/pub-date[@pub-type='epub']/year" mode="pass-through"/>
       </xsl:if>
       
       
       <!-- change context node, get article info -->
       <xsl:for-each select="/article/front/article-meta">
            <xsl:if test="volume">
                 <xsl:text>;</xsl:text>
                 <xsl:apply-templates select="volume" mode="pass-through"/>
                 <xsl:text>:</xsl:text>
            </xsl:if>
            
            <xsl:if test="issue">
                 <xsl:text>, No. </xsl:text>
                 <xsl:apply-templates select="issue" mode="pass-through"/>
            </xsl:if>
            
            <xsl:if test="supplement">
                 <xsl:text>, Supp. </xsl:text>
                 <xsl:apply-templates select="supplement" mode="pass-through"/>
            </xsl:if>
            
            <xsl:if test="elocation-id">
                 <xsl:apply-templates select="elocation-id" mode="pass-through"/>
            </xsl:if>
            
            <xsl:if test="fpage">
                 <xsl:text> (</xsl:text>
                 <xsl:apply-templates select="fpage" mode="pass-through"/>
                 
                 <xsl:if test="lpage">
                      <xsl:text>&#x02013;</xsl:text>
                      <xsl:apply-templates select="lpage" mode="pass-through"/>
                 </xsl:if>
                 
                 <xsl:text>)</xsl:text>
            </xsl:if>
            <xsl:if test="article-id[@pub-id-type='doi']">
                 <xsl:text> doi:&#x0200A;</xsl:text>
                 <xsl:apply-templates select="article-id[@pub-id-type='doi']" mode="pass-through"/>
            </xsl:if>
       </xsl:for-each>
       
       <xsl:if test="$pub-date-string !=''">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$pub-date-string"/>
       </xsl:if>
       <fo:leader leader-alignment="reference-area" leader-pattern="space"/>
       <xsl:if test="boolean($is-diagnostics-page)">
            <xsl:text>Diagnostics-</xsl:text>
       </xsl:if>
       <fo:leader/>
       <xsl:text>Page </xsl:text>
       <fo:page-number/>
       <xsl:text> of </xsl:text>
       
       <xsl:choose>
            <xsl:when test="boolean($is-diagnostics-page)">
                 <fo:page-number-citation ref-id="last-diagnostics-page"/>
            </xsl:when>
            <xsl:otherwise>
                 <fo:page-number-citation ref-id="last-article-page"/>
            </xsl:otherwise>
       </xsl:choose>
  </fo:block>
     <fo:block background-color="{$section-colour}" font-family="{$titlefont}" font-size="15pt"
          space-before="5pt" space-after="5pt" text-align="right">
          <fo:inline color="#FFFFFF" font-size="9pt" text-transform="uppercase" padding-right="2pt" baseline-shift="1pt">
               <xsl:value-of select="//front/article-meta/article-categories/subj-group[@subj-group-type='heading']/subject/text()"/>
          </fo:inline>
     </fo:block>
</xsl:template>


<xsl:template name="assemble-verso-header">
 
  <xsl:param name="is-diagnostics-page"/>

  <fo:block margin-left="0in"
       start-indent="0pc"
       space-after="0pt"
       text-align-last="justify"
       font-family="FreeSans"
       font-size="{$fnsize}pt">
       
       <!-- change context node, choose journal title -->
       <xsl:for-each select="/article/front/journal-meta">
            <xsl:choose>
                 <xsl:when test="journal-id[@journal-id-type='nlm-ta']">
                      <fo:wrapper font-style="italic">
                           <xsl:apply-templates select="journal-id[@journal-id-type='nlm-ta']" mode="pass-through"/>
                      </fo:wrapper>
                 </xsl:when>
                 <xsl:when test="abbrev-journal-title">
                      <xsl:apply-templates select="abbrev-journal-title[1]" mode="pass-through"/>
                 </xsl:when>
                 <xsl:when test="journal-title">
                      <xsl:apply-templates select="journal-title[1]" mode="pass-through"/>
                 </xsl:when>
                 <xsl:otherwise>
                      <xsl:apply-templates select="journal-id[1]" mode="pass-through"/>
                 </xsl:otherwise>
            </xsl:choose>
       </xsl:for-each>
       
       <xsl:if test="/article/front/article-meta/pub-date[@pub-type='epub']/year">
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="/article/front/article-meta/pub-date[@pub-type='epub']/year" mode="pass-through"/>
       </xsl:if>
       
       
       <!-- change context node, get article info -->
       <xsl:for-each select="/article/front/article-meta">
            <xsl:if test="volume">
                 <xsl:text>;</xsl:text>
                 <xsl:apply-templates select="volume" mode="pass-through"/>
                 <xsl:text>:</xsl:text>
            </xsl:if>
            
            <xsl:if test="issue">
                 <xsl:text>, No. </xsl:text>
                 <xsl:apply-templates select="issue" mode="pass-through"/>
            </xsl:if>
            
            <xsl:if test="supplement">
                 <xsl:text>, Supp. </xsl:text>
                 <xsl:apply-templates select="supplement" mode="pass-through"/>
            </xsl:if>
            
            <xsl:if test="elocation-id">
                 <xsl:apply-templates select="elocation-id" mode="pass-through"/>
            </xsl:if>
            
            <xsl:if test="fpage">
                 <xsl:text> (</xsl:text>
                 <xsl:apply-templates select="fpage" mode="pass-through"/>
                 
                 <xsl:if test="lpage">
                      <xsl:text>&#x02013;</xsl:text>
                      <xsl:apply-templates select="lpage" mode="pass-through"/>
                 </xsl:if>
                 
                 <xsl:text>)</xsl:text>
            </xsl:if>
            <xsl:if test="article-id[@pub-id-type='doi']">
                 <xsl:text> doi:&#x0200A;</xsl:text>
                 <xsl:apply-templates select="article-id[@pub-id-type='doi']" mode="pass-through"/>
            </xsl:if>
       </xsl:for-each>
       
       <xsl:if test="$pub-date-string !=''">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$pub-date-string"/>
       </xsl:if>
       <fo:leader leader-alignment="reference-area" leader-pattern="space"/>
       <xsl:if test="boolean($is-diagnostics-page)">
            <xsl:text>Diagnostics-</xsl:text>
       </xsl:if>
       <fo:leader/>
       <xsl:text>Page </xsl:text>
       
       <fo:page-number/>
       <xsl:text> of </xsl:text>
       <xsl:choose>
            <xsl:when test="boolean($is-diagnostics-page)">
                 <fo:page-number-citation ref-id="last-diagnostics-page"/>
            </xsl:when>
            <xsl:otherwise>
                 <fo:page-number-citation ref-id="last-article-page"/>
            </xsl:otherwise>
       </xsl:choose>
  </fo:block>
     <fo:block background-color="{$section-colour}" font-family="{$titlefont}" font-size="15pt"
          space-before="5pt" space-after="5pt" text-align="right">
          <fo:inline color="#FFFFFF" font-size="9pt" text-transform="uppercase" padding-right="2pt" baseline-shift="1pt">
               <xsl:value-of select="//front/article-meta/article-categories/subj-group[@subj-group-type='heading']/subject/text()"/>
          </fo:inline>
     </fo:block>
</xsl:template>


<!-- ============================================================= -->
<!-- NAMED TEMPLATE: DEFINE SEPARATOR FOR BEFORE-FLOAT             -->
<!-- ============================================================= -->


<xsl:template name="define-before-float-separator">

	 <!-- don't really want "a leader" here, but have to have
				something to make a break occur in the static content -->

	 <fo:static-content flow-name="xsl-before-float-separator">
		 <fo:block line-height="2pt"
							 space-before="0pt"
							 space-after="0pt">
			 <fo:leader leader-pattern="space"
									leader-length="100%"/>
		 </fo:block>
	 </fo:static-content>
</xsl:template>
 
 
 <!-- ============================================================= -->
 <!-- NAMED TEMPLATE: DEFINE SEPARATOR FOR FOOTNOTES                -->
 <!-- ============================================================= -->

<xsl:template name="define-footnote-separator">

  <fo:static-content flow-name="xsl-footnote-separator">
    <fo:block start-indent="0pc"
              end-indent="4in"
              margin-top="12pt"
              space-after="8pt"
              border-width="0.5pt"
              border-bottom-style="solid"/>
  </fo:static-content>
  
</xsl:template>

     <!-- ============================================================= -->
     <!-- NAMED TEMPLATES: ASSEMBLE FOOTER CONTENTS                -->
     <!-- ============================================================= -->
     
     <xsl:template name="assemble-first-footer">
          <xsl:param name="is-diagnostics-page"/>
          <!--OPTION ONE INCLUDES REPRINT FORM LINK-->
          <!--<fo:block>
               <fo:block  font-size="{$fnsize}*0.8pt" 
                    text-align="center"
                    border-width="0.25pt"
                    border-style="solid"
                    padding="1pt"
                    margin-bottom="1pt">
                    <fo:inline> 
                         <xsl:choose>
                              <xsl:when test="//front/article-meta/permissions/license[@license-type='open-access']">
                                   <xsl:text>No commercial reuse: See rights and reprints </xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                   <xsl:text>For personal use only: See rights and reprints </xsl:text>
                              </xsl:otherwise>
                         </xsl:choose>
                         <fo:basic-link  color="#5586E9" external-destination="url(http://resources.bmj.com/bmj/readers/permissions)">http://resources.bmj.com/bmj/readers/permissions</fo:basic-link>
                    </fo:inline>
               </fo:block>
               <fo:block font-size="{$fnsize}*0.8pt"  text-align-last="justify" color="#5586E9">
                    <fo:inline>Reprints:
                         <fo:basic-link
                              external-destination="url(http://journals.bmj.com/cgi/reprintform)"
                              >http://journals.bmj.com/cgi/reprintform</fo:basic-link>
                    </fo:inline>
                    <fo:leader/>
                    <fo:inline>Subscribe:
                         <fo:basic-link external-destination="url(http://resources.bmj.com/bmj/subscribers/how-to-subscribe)">http://resources.bmj.com/bmj/subscribers/how-to-subscribe</fo:basic-link>
                    </fo:inline>
               </fo:block>
          </fo:block>-->
               
<!--          OPTION TWO disclaimer and subscribe link in the box-->
          <fo:block  font-size="{$fnsize}*0.8pt" 
               text-align-last="justify"
               border-width="0.25pt"
               border-style="solid"
               padding="2pt">
               <fo:inline> 
                    <xsl:choose>
                         <xsl:when test="//front/article-meta/permissions/license[@license-type='open-access']
                              and matches(//front/article-meta/permissions/license/@xlink:href,'/by/')">
                              <xsl:text>Open Access: Reuse allowed</xsl:text>
                         </xsl:when>
                         <xsl:when test="//front/article-meta/permissions/license[@license-type='open-access']">
                              <xsl:text>No commercial reuse: See rights and reprints </xsl:text>
                              <fo:basic-link  color="#5586E9" external-destination="url(http://www.bmj.com/permissions)">http://www.bmj.com/permissions</fo:basic-link>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:text>For personal use only: See rights and reprints </xsl:text>
                              <fo:basic-link  color="#5586E9" external-destination="url(http://www.bmj.com/permissions)">http://www.bmj.com/permissions</fo:basic-link>
                         </xsl:otherwise>
                    </xsl:choose>
               </fo:inline>
               <fo:leader/>
               <fo:inline>Subscribe:
                    <fo:basic-link  color="#5586E9" external-destination="url(http://www.bmj.com/subscribe)">http://www.bmj.com/subscribe</fo:basic-link>
               </fo:inline>
          </fo:block>
     </xsl:template>
     
     


</xsl:stylesheet>
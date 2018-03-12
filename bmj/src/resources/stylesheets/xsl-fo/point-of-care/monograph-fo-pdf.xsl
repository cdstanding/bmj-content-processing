<?xml version="1.0" encoding="UTF-8"?>

 <xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 

<!-- <xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
    version="2.0">-->

  <!-- Page layout information -->
  <xsl:param name="BP_PDF_BP_logo_blue_on_white"/>
  <xsl:param name="BP_PDF_arrow-down"/>
  <xsl:param name="BP_PDF_arrow-right"/>
  <xsl:param name="BP_PDF_BP_logo_White_on_blue_cropped"/>
  <xsl:param name="BP_PDF_BP_logo_White_Trans_cropped"/>
  <xsl:param name="BP_PDF_Standard_cover"/>
  <xsl:param name="BP_PDF_tab_bottom"/>
  <xsl:param name="BP_PDF_treatment-detail-sub"/>
  <xsl:param name="BP_PDF_treatment-detail-vertical"/>
  <xsl:param name="BP_PDF_treatment-detail-vertical-double"/>
  <xsl:param name="BP_PDF_treatment-detail-vertical-double-empty"/>
  
  <xsl:template match="/">

    <xsl:variable name="messages" select="document('messages.xml')"/>
    <xsl:variable name="lang" select="monograph-full/@lang"/>
    
    
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="InterFace" font-size="10pt">

      <fo:layout-master-set>

        <fo:simple-page-master master-name="first-page" margin-bottom="14.173pt" margin-left="0.5cm" margin-right="14.173pt"
          margin-top="14.173pt" page-height="29.7cm" page-width="21cm">
          <fo:region-body region-name="body" margin-bottom="0cm" margin-top="0cm" background-color="#2A6EBB"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="toc-page" margin-bottom="0cm" margin-left="0cm" margin-right="0cm" margin-top="0cm"
          page-height="29.7cm" page-width="21cm">
          <fo:region-body region-name="body" margin-left="0.75cm" margin-right="0.75cm" margin-bottom="0.7cm" margin-top="0.7cm"/>
          <fo:region-before region-name="toc-page-page-header" extent="0.75cm" background-color="#cbdde7"/>
          <fo:region-after region-name="toc-page-odd-footer" extent="0.75cm" background-color="#cbdde7"/>
          <fo:region-start region-name="toc-page-page-start" extent="0.75cm" background-color="#cbdde7"/>
          <fo:region-end region-name="toc-page-odd-page-end" extent="0.75cm" background-color="#cbdde7"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="summary-page" margin-bottom="14.173pt" margin-left="1.5cm" margin-right="1.5cm"
          margin-top="2.5cm" page-height="29.7cm" page-width="21cm">
          <fo:region-body region-name="body" margin-bottom="0cm" margin-top="0cm"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="even-page" margin-bottom="1cm" margin-left="0cm" margin-right="2cm" margin-top="14.173pt"
          page-height="29.7cm" page-width="21cm">
          <fo:region-body region-name="body" margin-bottom="2cm" margin-top="1cm" margin-left="2cm"/>
          <fo:region-before region-name="even-page-header" extent="1.5cm"/>
          <fo:region-after region-name="even-footer" extent="1.5cm"/>
          <fo:region-start region-name="even-page-start" extent="2cm"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="odd-page" margin-bottom="1cm" margin-left="2cm" margin-right="0cm" margin-top="14.173pt"
          page-height="29.7cm" page-width="21cm">
          <fo:region-body region-name="body" margin-bottom="2cm" margin-top="1cm" margin-right="2cm"/>
          <fo:region-before region-name="odd-page-header" extent="1.5cm"/>
          <fo:region-after region-name="odd-footer" extent="1.5cm"/>
          <fo:region-end region-name="odd-page-end" extent="2cm"/>
        </fo:simple-page-master>

        <fo:page-sequence-master master-name="content-basics">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <fo:page-sequence-master master-name="content-prevention">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <fo:page-sequence-master master-name="content-diagnosis">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <fo:page-sequence-master master-name="content-treatment">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <fo:page-sequence-master master-name="content-followup">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <fo:page-sequence-master master-name="content-guidelines">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <fo:page-sequence-master master-name="content-online_resources">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <fo:page-sequence-master master-name="content-evidence_scores">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <fo:page-sequence-master master-name="content-references">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <fo:page-sequence-master master-name="content-images">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <fo:page-sequence-master master-name="content-disclaimer">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <fo:simple-page-master master-name="last-page" margin-bottom="14.173pt" margin-left="14.173pt" margin-right="14.173pt"
          margin-top="14.173pt" page-height="29.7cm" page-width="21cm">
          <fo:region-body region-name="body" margin-bottom="0cm" margin-top="0cm" background-color="#FFFFFF"/>
        </fo:simple-page-master>

      </fo:layout-master-set>
      
      

      <fo:page-sequence master-reference="first-page">
        <fo:flow flow-name="body">
          <fo:block space-before="0.7cm" space-before.conditionality="retain" text-align="center" space-after="36pt" color="#FFFFFF">
            <fo:external-graphic content-width="17cm" src="url('{$BP_PDF_BP_logo_White_on_blue_cropped}')"/>
          </fo:block>
          <fo:block font-family="nevis" font-size="48pt" font-weight="bold" text-align="center" space-after="36pt" color="#FFFFFF">
            <xsl:apply-templates select="monograph-full/monograph-info/title"/>
          </fo:block>
          <fo:block-container absolute-position="absolute" top="10.7cm">
            <fo:block font-size="15pt" letter-spacing="1.5pt" text-align="center" color="#FFFFFF">
             <xsl:value-of select="$messages/messages/locale[@value=$lang]/first-page/subtitle"/><!--  The right clinical information, right where it's needed -->
            </fo:block>
          </fo:block-container>
          <fo:block-container absolute-position="absolute" top="12.1cm">
            <fo:block font-size="0pt" top="14cm" padding="0mm" margin="0mm" line-height="0mm">
              <fo:external-graphic padding="0mm" margin="0mm" content-width="20cm" height="15cm" content-height="scale-to-fit"
                scaling="non-uniform" background-color="white" src="url('{$BP_PDF_Standard_cover}')"/>
               
            </fo:block>            
          </fo:block-container>
          <fo:block-container absolute-position="absolute" top="27.1cm" text-align="right">
            <fo:block>
              <fo:table table-layout="fixed" width="100%">
                <fo:table-column column-width="100%"/>
                <fo:table-body>
                  <fo:table-row>
                    <fo:table-cell background-color="#FFFFFF">
                      <fo:block font-size="10pt" font-weight="bold" padding="6mm" margin="0mm" color="#AFA6A6">
                        Last updated:
                        <xsl:apply-templates select="monograph-full/monograph-info/last-updated"/> 
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-body>
              </fo:table>
            </fo:block>
          </fo:block-container>
        </fo:flow>
      </fo:page-sequence>
      
      <fo:page-sequence master-reference="toc-page">
        <fo:flow flow-name="body">
          <fo:block font-weight="bold" text-align="center" background-color="#FFFFFF" padding-top="14pt">

            <fo:block font-family="nevis">
              <fo:inline border-after-width="3.0pt" border-after-style="solid" border-color="#cbdde7" color="#2b2b2b" font-size="18pt"
                margin="14pt">
                <xsl:text>Table of Contents</xsl:text>
              </fo:inline>
            </fo:block>

            <!-- Summary link -->
            <xsl:call-template name="summary-toc"/>

            <!--Basics -->
            <xsl:call-template name="toc-main-section">
              <xsl:with-param name="section-name" select="'Basics'"/>
              <xsl:with-param name="hardcoded-id" select="'basics-id'"/>
            </xsl:call-template>
            <xsl:apply-templates select="monograph-full/basics/definition" mode="toc"/>
            <xsl:apply-templates select="monograph-full/basics/epidemiology" mode="toc"/>
            <xsl:apply-templates select="monograph-full/basics/etiology" mode="toc"/>
            <xsl:apply-templates select="monograph-full/basics/pathophysiology" mode="toc"/>
            <xsl:apply-templates select="monograph-full/basics/classifications" mode="toc"/>

            <!--Prevention -->
            <xsl:call-template name="toc-main-section">
              <xsl:with-param name="section-name" select="'Prevention'"/>
              <xsl:with-param name="hardcoded-id" select="'prevention-id'"/>
            </xsl:call-template>
            <xsl:apply-templates select="monograph-full/basics/prevention" mode="toc"/> <!-- Primary Prevention -->
            <xsl:apply-templates select="monograph-full/diagnosis/screening" mode="toc"/> <!-- Screening -->
            <xsl:apply-templates select="monograph-full/followup/recommendations/preventive-actions" mode="toc"/> <!--Secondary Prevention -->

            <!--Diagnosis -->
            <xsl:call-template name="toc-main-section">
              <xsl:with-param name="section-name" select="'Diagnosis'"/>
              <xsl:with-param name="hardcoded-id" select="'diagnosis-id'"/>
            </xsl:call-template>
            <xsl:apply-templates select="monograph-full/basics/vignettes" mode="toc"/> <!-- Case history -->
            <xsl:apply-templates select="monograph-full/diagnosis/approach" mode="toc"/> <!-- Step-by-step diagnostic approach -->
            <xsl:apply-templates select="monograph-full/basics/risk-factors" mode="toc"/><!-- Risk factors -->
            <xsl:apply-templates select="monograph-full/diagnosis/diagnostic-factors" mode="toc"/> <!-- History-and-examination -->
            <xsl:apply-templates select="monograph-full/diagnosis/tests" mode="toc"/> <!-- Diagnostic tests -->
            <xsl:apply-templates select="monograph-full/diagnosis/differentials" mode="toc"/> <!-- Differential diagnosis -->
            <xsl:apply-templates select="monograph-full/diagnosis/diagnostic-criteria" mode="toc"/> <!-- Diagnostic criteria -->

            <!--Treatment -->
            <xsl:call-template name="toc-main-section">
              <xsl:with-param name="section-name" select="'Treatment'"/>
              <xsl:with-param name="hardcoded-id" select="'treatment-id'"/>
            </xsl:call-template>
            <xsl:apply-templates select="monograph-full/treatment/approach" mode="toc"/> <!-- Step-by-step treatment approach -->
            <xsl:call-template name="treatment-details-overview-toc"></xsl:call-template> <!-- Treatment details/overview options -->
            <xsl:apply-templates select="monograph-full/treatment/timeframes" mode="toc"/> <!-- Treatment details/overview options -->
            <xsl:apply-templates select="monograph-full/treatment/emerging-txs" mode="toc"/> <!-- Emerging -->

            <!--Follow Up -->
            <xsl:call-template name="toc-main-section">
              <xsl:with-param name="section-name" select="'Follow up'"/>
              <xsl:with-param name="hardcoded-id" select="'followup-id'"/>
            </xsl:call-template>
            <xsl:apply-templates select="monograph-full/followup/recommendations" mode="toc"/> <!-- Recommendations -->
            <xsl:apply-templates select="monograph-full/followup/complications" mode="toc"/> <!-- Complications -->
            <xsl:apply-templates select="monograph-full/followup/outlook" mode="toc"/> <!-- Prognosis -->

            <!-- Guidelines -->
            <xsl:call-template name="toc-main-section">
              <xsl:with-param name="section-name" select="'Guidelines'"/>
              <xsl:with-param name="hardcoded-id" select="'guidelines-id'"/>
            </xsl:call-template>
            <xsl:apply-templates select="monograph-full/diagnosis/guidelines" mode="toc"/> <!-- Diagnostic guidelines -->
            <xsl:apply-templates select="monograph-full/treatment/guidelines" mode="toc"/> <!-- Treatment guidelines -->

            <!-- Online resources -->
            <xsl:if test="monograph-full/online-references">
              <xsl:call-template name="toc-main-section">
                <xsl:with-param name="section-name" select="'Online resources'"/>
                <xsl:with-param name="hardcoded-id" select="'online-resources-id'"/>
              </xsl:call-template>
            </xsl:if>

            <!-- Evidence scores -->
            <xsl:if test="monograph-full/evidence-scores">
              <xsl:call-template name="toc-main-section">
                <xsl:with-param name="section-name" select="'Evidence scores'"/>
                <xsl:with-param name="hardcoded-id" select="'evidence-scores-id'"/>
              </xsl:call-template>
            </xsl:if>

            <!-- References -->
            <xsl:if test="monograph-full/article-references">
              <xsl:call-template name="toc-main-section">
                <xsl:with-param name="section-name" select="'References'"/>
                <xsl:with-param name="hardcoded-id" select="'references-id'"/>
              </xsl:call-template>
            </xsl:if>

            <!-- Images -->
            <xsl:if test="monograph-full/figures">
              <xsl:call-template name="toc-main-section">
                <xsl:with-param name="section-name" select="'Images'"/>
                <xsl:with-param name="hardcoded-id" select="'images-id'"/>
              </xsl:call-template>
            </xsl:if>

            <!-- Disclaimer -->
            <xsl:call-template name="toc-main-section">
              <xsl:with-param name="section-name" select="'Disclaimer'"/>
              <xsl:with-param name="hardcoded-id" select="'disclaimer-id'"/>
            </xsl:call-template>

          </fo:block>
        </fo:flow>
      </fo:page-sequence>
          <fo:page-sequence master-reference="summary-page">
        <fo:flow flow-name="body">
          <fo:block font-size="13pt" text-align-last="left" border-after-width="1pt" border-after-style="solid" border-color="#b7cfde" border-top-color="#b7cfde"
            border-top-style="solid" border-top-width="3.7pt" border-bottom-color="#b7cfde" border-bottom-style="solid" border-bottom-width="3.7pt"
            border-left-color="#b7cfde" border-left-style="solid" border-left-width="3.7pt" border-right-color="#b7cfde" border-right-style="solid"
            border-right-width="3.7pt">

             <fo:block  margin-top="30pt">   
              <fo:basic-link internal-destination="{generate-id()}">
                <xsl:apply-templates select="monograph-full/highlights"/>
              </fo:basic-link>
             </fo:block>
            
          </fo:block>

          <!-- place the Summary block heading over the top margin -->
          <fo:block-container position="absolute" top="-0.75cm" left="6.0cm" width="148pt">
            <fo:block font-family="nevis" font-size="18pt" text-align-last="center" space-before="7pt" background-color="#FFFFFF" border-top-color="#b7cfde" border-top-style="solid"
              border-top-width="3.7pt" border-bottom-color="#b7cfde" border-bottom-style="solid" border-bottom-width="3.7pt" border-left-color="#b7cfde"
              border-left-style="solid" border-left-width="3.7pt" border-right-color="#b7cfde" border-right-style="solid" border-right-width="3.7pt" padding-top="4pt" padding-bottom="4pt"
              id="{generate-id()}">

              <fo:inline>
                <xsl:text>Summary</xsl:text>
              </fo:inline>

            </fo:block>
          </fo:block-container>
        </fo:flow>
      </fo:page-sequence>

      <fo:page-sequence master-reference="content-basics">

        <fo:static-content flow-name="even-page-header">
          <xsl:call-template name="even-header-contents-basics"/>
        </fo:static-content>

        <fo:static-content flow-name="even-page-start">
          <fo:block-container reference-orientation="90" position="absolute" top="2mm" right="9mm">
            <fo:block text-align="right">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="2.85cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              BASICS
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-end">
          <fo:block-container reference-orientation="270" position="absolute" top="2mm" right="0mm">
            <fo:block text-align="left">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="270" position="absolute" top="2.85cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              BASICS
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-header">
          <xsl:call-template name="odd-header-contents-basics"/>
        </fo:static-content>

        <fo:static-content flow-name="even-footer">
          <xsl:call-template name="even-footer-contents"/>
        </fo:static-content>

        <fo:static-content flow-name="odd-footer">
          <xsl:call-template name="odd-footer-contents"/>
        </fo:static-content>

        <fo:flow flow-name="body">
          <fo:block id="basics-id"/>
          <xsl:apply-templates select="monograph-full/basics/definition"/>
          <xsl:apply-templates select="monograph-full/basics/epidemiology"/>
          <xsl:apply-templates select="monograph-full/basics/etiology"/>
          <xsl:apply-templates select="monograph-full/basics/pathophysiology"/>
          <xsl:apply-templates select="monograph-full/basics/classifications"/>
        </fo:flow>

      </fo:page-sequence>
      
      <fo:page-sequence master-reference="content-prevention">

        <fo:static-content flow-name="even-page-header">
          <xsl:call-template name="even-header-contents-prevention"/>
        </fo:static-content>

        <fo:static-content flow-name="even-page-start">
          <fo:block-container reference-orientation="90" position="absolute" top="7cm" right="9mm">
            <fo:block text-align="right">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="9.05cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              PREVENTION
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-end">
          <fo:block-container reference-orientation="270" position="absolute" top="7cm" right="0mm">
            <fo:block text-align="left">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="270" position="absolute" top="9.05cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              PREVENTION
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-header">
          <xsl:call-template name="odd-header-contents-prevention"/>
        </fo:static-content>

        <fo:static-content flow-name="even-footer">
          <xsl:call-template name="even-footer-contents"/>
        </fo:static-content>

        <fo:static-content flow-name="odd-footer">
          <xsl:call-template name="odd-footer-contents"/>
        </fo:static-content>

        <fo:flow flow-name="body">
          <fo:block id="prevention-id"/>
          <xsl:apply-templates select="monograph-full/basics/prevention"/>
          <xsl:apply-templates select="monograph-full/diagnosis/screening"/>
          <xsl:apply-templates select="monograph-full/followup/recommendations/preventive-actions"/>
        </fo:flow>

      </fo:page-sequence>

      <fo:page-sequence master-reference="content-diagnosis">

        <fo:static-content flow-name="even-page-header">
          <xsl:call-template name="even-header-contents-diagnosis"/>
        </fo:static-content>

        <fo:static-content flow-name="even-page-start">
          <fo:block-container reference-orientation="90" position="absolute" top="14cm" right="9mm">
            <fo:block text-align="right">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="16.3cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              DIAGNOSIS
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-end">
          <fo:block-container reference-orientation="270" position="absolute" top="14cm" right="0mm">
            <fo:block text-align="left">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="270" position="absolute" top="16.3cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              DIAGNOSIS
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-header">
          <xsl:call-template name="odd-header-contents-diagnosis"/>
        </fo:static-content>

        <fo:static-content flow-name="even-footer">
          <xsl:call-template name="even-footer-contents"/>
        </fo:static-content>

        <fo:static-content flow-name="odd-footer">
          <xsl:call-template name="odd-footer-contents"/>
        </fo:static-content>

        <fo:flow flow-name="body">
          <fo:block id="diagnosis-id"/>
          <xsl:apply-templates select="monograph-full/basics/vignettes"/>
          <xsl:apply-templates select="monograph-full/diagnosis/approach"/>
          <xsl:apply-templates select="monograph-full/basics/risk-factors"/>
          <xsl:apply-templates select="monograph-full/diagnosis/diagnostic-factors"/>
          <xsl:apply-templates select="monograph-full/diagnosis/tests"/>
          <xsl:apply-templates select="monograph-full/diagnosis/differentials"/>
          <xsl:apply-templates select="monograph-full/diagnosis/diagnostic-criteria"/>
        </fo:flow>

      </fo:page-sequence>

      <fo:page-sequence master-reference="content-treatment">

        <fo:static-content flow-name="even-page-header">
          <xsl:call-template name="even-header-contents-treatment"/>
        </fo:static-content>

        <fo:static-content flow-name="even-page-start">
          <fo:block-container reference-orientation="90" position="absolute" top="21cm" right="9mm">
            <fo:block text-align="right">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="23.2cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              TREATMENT
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-end">
          <fo:block-container reference-orientation="270" position="absolute" top="21cm" right="0mm">
            <fo:block text-align="left">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="270" position="absolute" top="23.2cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              TREATMENT
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-header">
          <xsl:call-template name="odd-header-contents-treatment"/>
        </fo:static-content>

        <fo:static-content flow-name="even-footer">
          <xsl:call-template name="even-footer-contents"/>
        </fo:static-content>

        <fo:static-content flow-name="odd-footer">
          <xsl:call-template name="odd-footer-contents"/>
        </fo:static-content>

        <fo:flow flow-name="body">
          <fo:block id="treatment-id"/>
          <xsl:apply-templates select="monograph-full/treatment/approach"/>
          <xsl:apply-templates select="monograph-full/treatment/timeframes"/>
          <xsl:apply-templates select="monograph-full/treatment/timeframes">
            <xsl:with-param name="full" select="'true'"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="monograph-full/treatment/emerging-txs"/>
        </fo:flow>

      </fo:page-sequence>

      <fo:page-sequence master-reference="content-followup">

        <fo:static-content flow-name="even-page-header">
          <xsl:call-template name="even-header-contents-followup"/>
        </fo:static-content>

        <fo:static-content flow-name="even-page-start">
          <fo:block-container reference-orientation="90" position="absolute" top="2mm" right="9mm">
            <fo:block text-align="right">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="2.45cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              FOLLOW UP
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-end">
          <fo:block-container reference-orientation="270" position="absolute" top="2mm" right="0mm">
            <fo:block text-align="left">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="270" position="absolute" top="2.45cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              FOLLOW UP
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-header">
          <xsl:call-template name="odd-header-contents-followup"/>
        </fo:static-content>

        <fo:static-content flow-name="even-footer">
          <xsl:call-template name="even-footer-contents"/>
        </fo:static-content>

        <fo:static-content flow-name="odd-footer">
          <xsl:call-template name="odd-footer-contents"/>
        </fo:static-content>

        <fo:flow flow-name="body">
          <fo:block id="followup-id"/>
          <xsl:apply-templates select="monograph-full/followup/recommendations"/>
          <xsl:apply-templates select="monograph-full/followup/complications"/>
          <xsl:apply-templates select="monograph-full/followup/outlook"/>
        </fo:flow>

      </fo:page-sequence>

      <fo:page-sequence master-reference="content-guidelines">

        <fo:static-content flow-name="even-page-header">
          <xsl:call-template name="even-header-contents-guidelines"/>
        </fo:static-content>

        <fo:static-content flow-name="even-page-start">
          <fo:block-container reference-orientation="90" position="absolute" top="7cm" right="9mm">
            <fo:block text-align="right">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="9.17cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              GUIDELINES
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-end">
          <fo:block-container reference-orientation="270" position="absolute" top="7cm" right="0mm">
            <fo:block text-align="left">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="270" position="absolute" top="9.17cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              GUIDELINES
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-header">
          <xsl:call-template name="odd-header-contents-guidelines"/>
        </fo:static-content>

        <fo:static-content flow-name="even-footer">
          <xsl:call-template name="even-footer-contents"/>
        </fo:static-content>

        <fo:static-content flow-name="odd-footer">
          <xsl:call-template name="odd-footer-contents"/>
        </fo:static-content>

        <fo:flow flow-name="body">
          <fo:block id="guidelines-id"/>
          <xsl:apply-templates select="monograph-full/diagnosis/guidelines"/>
          <xsl:apply-templates select="monograph-full/treatment/guidelines"/>
        </fo:flow>

      </fo:page-sequence>
      <!-- Check that there is some content at least to avoid empty pages -->
      <xsl:if test="monograph-full/online-references">
        <fo:page-sequence master-reference="content-online_resources">

          <fo:static-content flow-name="even-page-header">
            <xsl:call-template name="even-header-contents-online_resources"/>
          </fo:static-content>

          <fo:static-content flow-name="even-page-start">
            <fo:block-container reference-orientation="90" position="absolute" top="14cm" right="9mm">
              <fo:block text-align="right">
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="90" position="absolute" top="15.45cm" left="0.4cm">
              <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
                ONLINE RESOURCES
              </fo:block>
            </fo:block-container>
          </fo:static-content>

          <fo:static-content flow-name="odd-page-end">
            <fo:block-container reference-orientation="270" position="absolute" top="14cm" right="0mm">
              <fo:block text-align="left">
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="270" position="absolute" top="15.45cm" right="4mm">
              <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
                ONLINE RESOURCES
              </fo:block>
            </fo:block-container>
          </fo:static-content>

          <fo:static-content flow-name="odd-page-header">
            <xsl:call-template name="odd-header-contents-online_resources"/>
          </fo:static-content>

          <fo:static-content flow-name="even-footer">
            <xsl:call-template name="even-footer-contents"/>
          </fo:static-content>

          <fo:static-content flow-name="odd-footer">
            <xsl:call-template name="odd-footer-contents"/>
          </fo:static-content>

          <fo:flow flow-name="body">
            <fo:block id="online-resources-id"/>
            <xsl:apply-templates select="monograph-full/online-references"/>
          </fo:flow>

        </fo:page-sequence>
      </xsl:if>
     
      <xsl:if test="monograph-full/evidence-scores">
        <fo:page-sequence master-reference="content-evidence_scores">

          <fo:static-content flow-name="even-page-header">
            <xsl:call-template name="even-header-contents-evidence_scores"/>
          </fo:static-content>

          <fo:static-content flow-name="even-page-start">
            <fo:block-container reference-orientation="90" position="absolute" top="21cm" right="9mm">
              <fo:block text-align="right">
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="90" position="absolute" top="22.6cm" left="0.4cm">
              <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
                EVIDENCE SCORES
              </fo:block>
            </fo:block-container>
          </fo:static-content>

          <fo:static-content flow-name="odd-page-end">
            <fo:block-container reference-orientation="270" position="absolute" top="21cm" right="0mm">
              <fo:block text-align="left">
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="270" position="absolute" top="22.6cm" right="4mm">
              <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
                EVIDENCE SCORES
              </fo:block>
            </fo:block-container>
          </fo:static-content>

          <fo:static-content flow-name="odd-page-header">
            <xsl:call-template name="odd-header-contents-evidence_scores"/>
          </fo:static-content>

          <fo:static-content flow-name="even-footer">
            <xsl:call-template name="even-footer-contents"/>
          </fo:static-content>

          <fo:static-content flow-name="odd-footer">
            <xsl:call-template name="odd-footer-contents"/>
          </fo:static-content>

          <fo:flow flow-name="body">
            <fo:block id="evidence-scores-id"/>
            <xsl:apply-templates select="monograph-full/evidence-scores"/>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>
  
      <xsl:if test="monograph-full/article-references">
        <fo:page-sequence master-reference="content-references">

          <fo:static-content flow-name="even-page-header">
            <xsl:call-template name="even-header-contents-references"/>
          </fo:static-content>

          <fo:static-content flow-name="even-page-start">
            <fo:block-container reference-orientation="90" position="absolute" top="2mm" right="9mm">
              <fo:block text-align="right">
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="90" position="absolute" top="2.35cm" left="0.4cm">
              <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
                REFERENCES
              </fo:block>
            </fo:block-container>
          </fo:static-content>

          <fo:static-content flow-name="odd-page-end">
            <fo:block-container reference-orientation="270" position="absolute" top="2mm" right="0mm">
              <fo:block text-align="left">
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="270" position="absolute" top="2.35cm" right="4mm">
              <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
                REFERENCES
              </fo:block>
            </fo:block-container>
          </fo:static-content>

          <fo:static-content flow-name="odd-page-header">
            <xsl:call-template name="odd-header-contents-references"/>
          </fo:static-content>

          <fo:static-content flow-name="even-footer">
            <xsl:call-template name="even-footer-contents"/>
          </fo:static-content>

          <fo:static-content flow-name="odd-footer">
            <xsl:call-template name="odd-footer-contents"/>
          </fo:static-content>

          <fo:flow flow-name="body">
            <fo:block id="references-id"/>
            <xsl:apply-templates select="monograph-full/article-references"/>
          </fo:flow>

        </fo:page-sequence>
      </xsl:if>
 
      <xsl:if test="monograph-full/figures">
        <fo:page-sequence master-reference="content-images">

          <fo:static-content flow-name="even-page-header">
            <xsl:call-template name="even-header-contents-images"/>
          </fo:static-content>

          <fo:static-content flow-name="even-page-start">
            <fo:block-container reference-orientation="90" position="absolute" top="7cm" right="9mm">
              <fo:block text-align="right">
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="90" position="absolute" top="9.6cm" left="0.4cm">
              <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
                IMAGES
              </fo:block>
            </fo:block-container>
          </fo:static-content>

          <fo:static-content flow-name="odd-page-end">
            <fo:block-container reference-orientation="270" position="absolute" top="7cm" right="0mm">
              <fo:block text-align="left">
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="270" position="absolute" top="9.6cm" right="4mm">
              <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
                IMAGES
              </fo:block>
            </fo:block-container>
          </fo:static-content>

          <fo:static-content flow-name="odd-page-header">
            <xsl:call-template name="odd-header-contents-images"/>
          </fo:static-content>

          <fo:static-content flow-name="even-footer">
            <xsl:call-template name="even-footer-contents"/>
          </fo:static-content>

          <fo:static-content flow-name="odd-footer">
            <xsl:call-template name="odd-footer-contents"/>
          </fo:static-content>

          <fo:flow flow-name="body">
            <fo:block id="images-id"/>
            <xsl:apply-templates select="monograph-full/figures"/>
          </fo:flow>

        </fo:page-sequence>
      </xsl:if>

      <fo:page-sequence master-reference="content-disclaimer">

        <fo:static-content flow-name="even-page-header">
          <xsl:call-template name="even-header-contents-disclaimer"/>
        </fo:static-content>

        <fo:static-content flow-name="even-page-start">
          <fo:block-container reference-orientation="90" position="absolute" top="14cm" right="9mm">
            <fo:block text-align="right">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="16.2cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              DISCLAIMER
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-end">
          <fo:block-container reference-orientation="270" position="absolute" top="14cm" right="0mm">
            <fo:block text-align="left">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white" src="url('{$BP_PDF_tab_bottom}')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="270" position="absolute" top="16.2cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              DISCLAIMER
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-header">
          <xsl:call-template name="odd-header-contents-disclaimer"/>
        </fo:static-content>

        <fo:static-content flow-name="even-footer">
          <xsl:call-template name="even-footer-contents"/>
        </fo:static-content>

        <fo:static-content flow-name="odd-footer">
          <xsl:call-template name="odd-footer-contents"/>
        </fo:static-content>

        <fo:flow flow-name="body">
          <fo:block id="disclaimer-id"/>
          <xsl:call-template name="disclaimer-content"/>
        </fo:flow>

      </fo:page-sequence>

      <fo:page-sequence master-reference="last-page">
        <fo:flow flow-name="body">
          <fo:block space-before="0.7cm" space-before.conditionality="retain" text-align="center" space-after="36pt" color="#FFFFFF"> 
            <fo:external-graphic content-width="17cm" src="url('{$BP_PDF_BP_logo_blue_on_white}')"/>
          </fo:block>
          <fo:block margin-left="20pt" margin-right="20pt">
            <fo:table table-layout="fixed" border="none" border-width="1pt" border-color="#A9D0F5">
              <fo:table-column column-width="100%"/>
              <fo:table-header background-color="#FFFFFF" font-size="14pt" font-weight="bold" color="#2A6EBB">
                <fo:table-row space-after="10px">
                  <fo:table-cell>
                    <fo:block font-size="20pt" font-weight="bold" margin-top="14pt" margin-left="3pt" margin-bottom="4pt" border-after-style="solid"
                      border-after-width="1pt" border-after-color="#A9D0F5">
                      Contributors:
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-header>
              <fo:table-body>
                <fo:table-row space-after="10px">
                  <fo:table-cell>
                    <fo:block font-weight="bold" margin-top="14pt" margin="5pt" font-size="15pt" color="#2A6EBB">
                      // Authors:
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <xsl:apply-templates select="monograph-full/monograph-info/authors/author"/>
                <fo:table-row space-after="10px">
                  <fo:table-cell>
                    <fo:block font-weight="bold" margin-top="14pt" margin="5pt" font-size="15pt" margin-bottom="14pt" color="#2A6EBB">
                      // Acknowledgements:
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              
               <xsl:call-template name="monograph-full-monograph-info-authors-author-acknowledgements">
                  <xsl:with-param name="authors" select="monograph-full/monograph-info/authors/author"/>
                </xsl:call-template>
                 
                <fo:table-row space-after="10px">
                  <fo:table-cell>
                    <fo:block font-weight="bold" margin-top="14pt" margin="5pt" font-size="15pt" color="#2A6EBB">
                      // Peer Reviewers:
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <xsl:apply-templates select="monograph-full/monograph-info/peer-reviewers/peer-reviewer"/>
                <fo:table-row>
                  <fo:table-cell>
                    <fo:block font-weight="bold" margin-left="10pt" font-size="10pt" margin-bottom="14pt">
                      <xsl:value-of select="''"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-body>
            </fo:table>
          </fo:block>
          
        </fo:flow>
      </fo:page-sequence>
      
    </fo:root>

  </xsl:template>

  <!-- HEADERS -->

  <xsl:template name="common-header">
    <xsl:param name="section"/>
    <fo:block font-family="nevis" >
      <fo:table table-layout="fixed" width="100%" border-bottom-width="1pt" border-bottom-style="solid" border-color="#cadce7">
        <fo:table-column column-width="70%"/>
        <fo:table-column column-width="30%"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell text-align="left" display-align="after" background-color="#FFFFFF">
              <fo:block font-size="10pt" font-weight="bold" color="#cadce7">
                <xsl:apply-templates select="monograph-full/monograph-info/title"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right" display-align="after" background-color="#FFFFFF">
              <fo:block font-size="14pt" font-weight="bold" color="#cadce7">
                <xsl:value-of select="$section"/>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <xsl:template name="even-header-contents-basics">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Basics'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-basics">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Basics'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-prevention">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Prevention'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-prevention">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Prevention'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-diagnosis">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Diagnosis'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-diagnosis">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Diagnosis'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-treatment">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Treatment'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-treatment">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Treatment'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-followup">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Follow up'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-followup">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Follow up'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-guidelines">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Guidelines'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-guidelines">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Guidelines'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-online_resources">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Online resources'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-online_resources">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Online resources'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-evidence_scores">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Evidence scores'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-evidence_scores">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Evidence scores'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-references">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'References'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-references">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'References'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-images">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Images'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-images">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Images'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-disclaimer">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Disclaimer'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-disclaimer">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="'Disclaimer'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- END HEADERS -->

  <!-- FOOTERS -->

  <xsl:template name="even-footer-contents">
    <fo:block>
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="5%"/>
        <fo:table-column column-width="90%"/>
        <fo:table-column column-width="5%"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block font-size="14pt" font-weight="bold" text-align="left" color="#cadce7">
                <fo:page-number/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <xsl:call-template name="disclaimer"/>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <xsl:template name="odd-footer-contents">
    <fo:block>
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="5%"/>
        <fo:table-column column-width="90%"/>
        <fo:table-column column-width="5%"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block/>
            </fo:table-cell>
            <fo:table-cell>
              <xsl:call-template name="disclaimer"/>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-size="14pt" font-weight="bold" text-align="right" color="#cadce7">
                <fo:page-number/>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <xsl:template name="disclaimer">
    <fo:block font-size="8pt" text-align="center" color="#AFA6A6">
      This PDF of the BMJ Best Practice topic is based on the web version that was last updated:
      <xsl:apply-templates select="monograph-full/monograph-info/last-updated"/>
      .
    </fo:block>
    <fo:block font-size="8pt" text-align="center" color="#AFA6A6">
      BMJ Best Practice topics are regularly updated and the most recent version of the
      topics can be found on
      <fo:basic-link external-destination="url('http://bestpractice.bmj.com')" text-decoration="underline">bestpractice.bmj.com </fo:basic-link>
      . Use of this
      content is subject to our
      <fo:basic-link internal-destination="disclaimer-id" text-decoration="underline">disclaimer</fo:basic-link>
      . © BMJ Publishing Group Ltd 2015. All rights
      reserved.
    </fo:block>
  </xsl:template>

  <!-- END FOOTERS -->

  <xsl:template match="monograph-full/monograph-info/last-updated">
    <fo:inline>
      <xsl:value-of select="."/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="monograph-full/monograph-info/title">
    <fo:block>
      <xsl:value-of select="."/>
    </fo:block>
  </xsl:template>

  <!-- TOC -->

  <xsl:template name="toc-main-section">
    <xsl:param name="section-name"/>
    <xsl:param name="hardcoded-id" select="false()"/>
    <fo:block space-before="7pt">
      <fo:table width="17cm" table-layout="fixed">
        <fo:table-column column-width="1cm"/>
        <fo:table-column column-width="16cm"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block>
                <!-- Blank to indent the text -->
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block text-align-last="justify" space-before="7pt" border-after-width="0.25pt" border-after-style="solid" border-color="#F2F2F2">
                <xsl:choose>
                  <xsl:when test="$hardcoded-id">
                    <fo:basic-link internal-destination="{$hardcoded-id}">
                      <fo:inline color="#333333" font-size="13pt" font-weight="bold">
                        <xsl:value-of select="$section-name"/>
                      </fo:inline>
                      <fo:leader leader-pattern="space"/>
                      <fo:page-number-citation ref-id="{$hardcoded-id}"/>
                    </fo:basic-link>
                  </xsl:when>
                  <xsl:otherwise>
                    <fo:basic-link internal-destination="{generate-id()}">
                      <fo:inline color="#333333" font-size="13pt" font-weight="bold">
                        <xsl:value-of select="$section-name"/>
                      </fo:inline>
                      <fo:leader leader-pattern="space"/>
                      <fo:page-number-citation ref-id="{generate-id()}"/>
                    </fo:basic-link>
                  </xsl:otherwise>
                </xsl:choose>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <xsl:template name="toc-main-subsection">
    <xsl:param name="section-name"/>
    <xsl:param name="hardcoded-id" select="false()"/>
    <fo:block space-before="7pt">
      <fo:table width="17cm" table-layout="fixed">
        <fo:table-column column-width="2cm"/>
        <fo:table-column column-width="15cm"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block>
                <!-- Blank to indent the text -->
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block text-align-last="justify" space-before="7pt" border-after-width="0.25pt" border-after-style="solid" border-color="#F2F2F2">
                <xsl:choose>
                  <xsl:when test="$hardcoded-id">
                    <fo:basic-link internal-destination="{$hardcoded-id}">
                      <fo:inline color="#666666" font-size="10pt" font-weight="bold">
                        <xsl:value-of select="$section-name"/>
                      </fo:inline>
                      <fo:leader leader-pattern="space"/>
                      <fo:page-number-citation ref-id="{$hardcoded-id}"/>
                    </fo:basic-link>
                  </xsl:when>
                  <xsl:otherwise>
                    <fo:basic-link internal-destination="{generate-id()}">
                      <fo:inline color="#666666" font-size="10pt" font-weight="bold">
                        <xsl:value-of select="$section-name"/>
                      </fo:inline>
                      <fo:leader leader-pattern="space"/>
                      <fo:page-number-citation ref-id="{generate-id()}"/>
                    </fo:basic-link>
                  </xsl:otherwise>
                </xsl:choose>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>
  </xsl:template>

  <xsl:template name="summary-toc">
    <xsl:call-template name="toc-main-section">
      <xsl:with-param name="section-name" select="'Summary'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Basics -->

  <xsl:template match="//basics/definition" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Definition'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//basics/epidemiology" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Epidemiology'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//basics/etiology" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Aetiology'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//basics/pathophysiology" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Pathophysiology'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//basics/classifications" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Classification'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- END Basics -->

  <!-- Prevention -->

  <xsl:template match="//basics/prevention" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Primary prevention'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//followup/recommendations/preventive-actions" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Secondary prevention'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//diagnosis/screening" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Screening'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- END Prevention -->

  <!-- Diagnosis -->

  <xsl:template match="//basics/vignettes" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Case history'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//diagnosis/approach" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Step-by-step diagnostic approach'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//basics/risk-factors" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Risk factors'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//diagnosis/diagnostic-factors" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'History &amp; examination factors'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//diagnosis/tests" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Diagnostic tests'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//diagnosis/differentials" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Differential diagnosis'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//diagnosis/diagnostic-criteria" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Diagnostic criteria'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- END Diagnosis -->

  <!-- Treatment -->

  <xsl:template match="//treatment/approach" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Step-by-step treatment approach'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//treatment/emerging-txs" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Emerging'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="treatment-details-overview-toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Treatment details overview'"/>
      <xsl:with-param name="hardcoded-id" select="'treatment-details-overview-id'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//treatment/timeframes" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Treatment options'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- END Treatment -->

  <!-- Follow up -->

  <xsl:template match="//followup/complications" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Complications'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//followup/outlook" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Prognosis'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//followup/recommendations" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Recommendations'"/>
    </xsl:call-template>
  </xsl:template>

  <!--END Follow up -->

  <!-- Guidelines -->

  <xsl:template match="//diagnosis/guidelines" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Diagnostic guidelines'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//treatment/guidelines" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="'Treatment guidelines'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- END Guidelines -->

  <!-- END TOC -->

  <!-- SUMMARY -->

  <xsl:template match="monograph-full/highlights">
    <xsl:for-each select="highlight">
      <fo:block space-before="20pt">
        <fo:table width="17cm" table-layout="fixed">
          <fo:table-column column-width="0.75cm"/>
          <fo:table-column column-width="14.173pt"/>
          <fo:table-column column-width="15.75cm"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell>
                <fo:block text-align="center">
                  <!-- Blank to indent the text -->
                </fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block font-family="InterFace" text-align="center" color="#b7cfde">
                  <xsl:text>&#x25ca;</xsl:text>
                </fo:block>
              </fo:table-cell>

              <fo:table-cell>
                <fo:block text-align="left" space-before="7pt" border-after-width="0.5pt" border-after-style="solid" border-color="#f0f0f0" padding-bottom="4pt">
                  <fo:inline>
                    <!-- <xsl:apply-templates select="./child::node()"/> -->
                    <xsl:value-of select="."/>
                  </fo:inline>
                </fo:block>
                <xsl:if test="position()=last()"> <!-- put a spacer block at the bottom -->
                  <fo:block-container height="30mm">
                    <fo:block text-align="center">
                      <xsl:text></xsl:text>
                    </fo:block>
                  </fo:block-container>
                </xsl:if>

              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </xsl:for-each>
  </xsl:template>

  <!-- END SUMMARY -->

  <!-- BASICS -->

  <xsl:template match="monograph-full/basics/definition">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt"  border-color="#b7cfde">
        Definition
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/basics/epidemiology">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt"  border-color="#b7cfde">
        Epidemiology
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/basics/etiology">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt"  border-color="#b7cfde">
        Aetiology
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/basics/pathophysiology">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt"  border-color="#b7cfde">
        Pathophysiology
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/basics/classifications">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt"  border-color="#b7cfde">
        Classification
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <!-- END BASICS -->

  <!-- PREVENTION -->

  <xsl:template match="monograph-full/basics/prevention">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Primary prevention
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/followup/recommendations/preventive-actions">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Secondary prevention
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/diagnosis/screening">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Screening
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <!-- END PREVENTION -->

  <!-- DIAGNOSIS -->

  <xsl:template match="monograph-full/basics/vignettes">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-after-width="3pt" border-after-style="solid" border-color="#b7cfde" >
        Case history
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block  line-height="15pt">
      <xsl:apply-templates select="../other-presentations"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/basics/other-presentations">
    <fo:block font-size="16pt" font-weight="bold" text-align="left" space-before="6pt" space-after="12pt" margin-left="14.173pt"
      keep-with-next.within-page="always">
      <fo:inline border-bottom-color="#333333" border-bottom-style="solid" border-bottom-width="0.5pt" padding-bottom="2pt">
        Other presentations
      </fo:inline>
    </fo:block>
    <fo:block margin-left="14.173pt" line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="approach/section[section-header!='']/section-text">
    <fo:block margin-left="14.173pt" line-height="15pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="monograph-full/diagnosis/diagnostic-factors">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-before="6pt" space-after="12pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        History &amp; examination factors
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:if test="./factor[@key-factor='true']">
        <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" margin-left="14.173pt" margin-bottom="6pt"
          keep-with-next.within-page="always">
          <fo:inline border-bottom-color="#333333" border-bottom-style="solid" border-bottom-width="0.5pt" padding-bottom="2pt">
            Key diagnostic factors
          </fo:inline>
        </fo:block>
      </xsl:if>
      <xsl:apply-templates select="./factor[@key-factor='true' and @frequency='common']"/>
      <xsl:apply-templates select="./factor[@key-factor='true' and @frequency='uncommon']"/>
      <xsl:if test="./factor[@key-factor='false']">
        <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" margin-left="14.173pt"
          keep-with-next.within-page="always">
          <fo:inline border-bottom-color="#333333" border-bottom-style="solid" border-bottom-width="0.5pt" padding-bottom="2pt">
            Other diagnostic factors
          </fo:inline>
        </fo:block>
      </xsl:if>
      <xsl:apply-templates select="./factor[@key-factor='false' and @frequency='common']"/>
      <xsl:apply-templates select="./factor[@key-factor='false' and @frequency='uncommon']"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/diagnosis/diagnostic-factors/factor[@key-factor='true' and @frequency='common']">
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="monograph-full/diagnosis/diagnostic-factors/factor[@key-factor='true' and @frequency='uncommon']">
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="monograph-full/diagnosis/diagnostic-factors/factor[@key-factor='false' and @frequency='common']">
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="monograph-full/diagnosis/diagnostic-factors/factor[@key-factor='false' and @frequency='uncommon']">
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="factor/factor-name">
    <fo:block font-weight="bold" font-size="12pt" space-after="7pt" margin-left="14.173pt">
      <xsl:value-of select="."/>
      <xsl:value-of select="concat(' (',../@frequency,')')"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="factor/detail">
    <fo:list-block space-after="7pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="factor/detail/para">
    <fo:list-item provisional-distance-between-starts="1cm">
      <fo:list-item-label end-indent="label-end()">
        <fo:block text-align="right">&#x02022;</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="monograph-full/basics/risk-factors">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Risk factors
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:if test="./risk-factor[@strength='strong']">
        <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline" start-indent="0cm"
          margin-left="14.173pt">
          Strong
        </fo:block>
      </xsl:if>
      <xsl:apply-templates select="./risk-factor[@strength='strong']"/>
      <xsl:if test="./risk-factor[@strength='weak']">
        <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline" start-indent="0cm"
          margin-left="14.173pt">
          Weak
        </fo:block>
      </xsl:if>
      <xsl:apply-templates select="./risk-factor[@strength='weak']"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="risk-factor/name">
    <fo:block font-weight="bold" font-size="12pt" space-after="7pt" start-indent="0cm" margin-left="14.173pt" keep-with-next.within-page="always">
      <xsl:value-of select="."/>
    </fo:block>
  </xsl:template>

  <xsl:template match="risk-factor/detail">
    <fo:list-block space-after="7pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="risk-factor/detail/para">
    <fo:list-item provisional-distance-between-starts="1cm">
      <fo:list-item-label end-indent="label-end()">
        <fo:block text-align="right">&#x02022;</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="monograph-full/diagnosis/tests">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Diagnostic tests
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:if test="./test[@order='initial']">
        <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline" margin-left="14.173pt"
          keep-with-next.within-page="always">
          1st test to order
        </fo:block>
        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="70%"/>
          <fo:table-column column-width="30%"/>
          <fo:table-header background-color="#2A6EBB" font-size="14pt" font-weight="bold" color="#FFFFFF">
            <fo:table-row space-after="10px">
              <fo:table-cell>
                <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">Test</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">Result</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <xsl:apply-templates select="./test[@order='initial']"/>
          </fo:table-body>
        </fo:table>
      </xsl:if>
      <xsl:if test="./test[@order='subsequent']">
        <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline" margin-left="14.173pt"
          keep-with-next.within-page="always">
          Other tests to consider
        </fo:block>
        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="70%"/>
          <fo:table-column column-width="30%"/>
          <fo:table-header background-color="#2A6EBB" font-size="14pt" font-weight="bold" color="#FFFFFF">
            <fo:table-row space-after="10px">
              <fo:table-cell>
                <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">Test</fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">Result</fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <xsl:apply-templates select="./test[@order='subsequent']"/>
          </fo:table-body>
        </fo:table>
      </xsl:if>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="diagnosis/tests/test">
    <fo:table-row page-break-inside="avoid">
      <fo:table-cell border="solid" border-width="1pt" border-color="#b7cfde">
        <fo:block font-weight="bold" margin="5pt">
          <xsl:value-of select="./name"/>
        </fo:block>
        <fo:list-block>
          <xsl:apply-templates select="./detail"/>
        </fo:list-block>
      </fo:table-cell>
      <fo:table-cell border="solid" border-width="1pt" border-color="#b7cfde">
        <fo:block font-weight="bold" margin="5pt">
          <xsl:value-of select="./result"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <xsl:template match="tests/test/detail/para">
    <fo:list-item provisional-distance-between-starts="1cm">
      <fo:list-item-label end-indent="label-end()">
        <fo:block text-align="right">&#x02022;</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="monograph-full/diagnosis/differentials">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Differential diagnosis
      </fo:inline>
    </fo:block>
    <fo:block>
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="30%"/>
        <fo:table-column column-width="35%"/>
        <fo:table-column column-width="35%"/>
        <fo:table-header background-color="#2A6EBB" font-size="14pt" font-weight="bold" color="#FFFFFF">
          <fo:table-row space-after="10px">
            <fo:table-cell>
              <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">Condition</fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">Differentiating signs / symptoms</fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">Differentiating tests</fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:apply-templates select="./differential"/>
        </fo:table-body>
      </fo:table>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="diagnosis/differentials/differential">
    <fo:table-row page-break-inside="avoid">
      <fo:table-cell border="solid" border-width="1pt" border-color="#b7cfde">
        <fo:block font-weight="bold" margin="5pt">
          <xsl:value-of select="./name"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell border="solid" border-width="1pt" border-color="#b7cfde">
        <fo:list-block margin="5pt">
          <xsl:apply-templates select="./sign-symptoms"/>
        </fo:list-block>
      </fo:table-cell>
      <fo:table-cell border="solid" border-width="1pt" border-color="#b7cfde">
        <fo:list-block margin="5pt">
          <xsl:apply-templates select="./tests"/>
        </fo:list-block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <xsl:template match="diagnosis/differentials/differential/sign-symptoms/para">
    <fo:list-item provisional-distance-between-starts="1cm">
      <fo:list-item-label end-indent="label-end()">
        <fo:block text-align="right">&#x02022;</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="diagnosis/differentials/differential/tests/para">
    <fo:list-item provisional-distance-between-starts="1cm">
      <fo:list-item-label end-indent="label-end()">
        <fo:block>&#x02022;</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="monograph-full/diagnosis/diagnostic-criteria">
    <fo:block font-family="nevis" margin-bottom="6pt" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Diagnostic criteria
      </fo:inline>
    </fo:block>
    <fo:block margin-left="0.5cm">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/diagnosis/diagnostic-criteria/criteria">
    <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" start-indent="0cm" margin-left="14.173pt">
      <fo:inline border-bottom-color="#333333" border-bottom-style="solid" border-bottom-width="0.5pt" padding-bottom="2pt">
        <xsl:apply-templates select="./title"/>
      </fo:inline>
    </fo:block>
    <fo:block start-indent="0cm" margin-left="14.173pt">
      <xsl:apply-templates select="./detail"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/diagnosis/diagnostic-criteria/criteria/title">
    <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="monograph-full/diagnosis/approach">
    <fo:block font-family="nevis" margin-bottom="6pt" font-size="18pt" font-weight="bold" text-align="left" space-after="12pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Step by step diagnostic approach
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <!-- END DIAGNOSIS -->

  <!-- TREATMENT -->

  <xsl:template match="monograph-full/treatment/approach">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Step-by-step treatment approach
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <!-- So that the name is not rendered generating an invalid fo -->
  <xsl:template match="pt-group/name">
  </xsl:template>

  <xsl:template match="monograph-full/treatment/timeframes">
    <xsl:param name="full"/>
    <xsl:choose>
      <xsl:when test="$full">
        <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" page-break-before="always"
          keep-with-next.within-page="always" id="{generate-id()}">
          <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
            Treatment options
          </fo:inline>
        </fo:block>
        <fo:block>
          <xsl:apply-templates select="./child::node()">
            <xsl:with-param name="full" select="$full"/>
          </xsl:apply-templates>
        </fo:block>
        <fo:block space-after="14pt"/>
      </xsl:when>
      <xsl:otherwise>
        <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" keep-with-next.within-page="always"
          id="treatment-details-overview-id">
          <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
            Treatment details overview
          </fo:inline>
        </fo:block>
        <fo:block space-after="7pt">
          Consult your local pharmaceutical database for comprehensive drug information including contraindications,
          drug
          interactions, and
          alternative
          dosing. (see
          <fo:basic-link internal-destination="disclaimer-id">Disclaimer</fo:basic-link>
          )
        </fo:block>
        <fo:block>
          <xsl:apply-templates select="./child::node()"/>
        </fo:block>
        <fo:block space-after="14pt"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="timeframes/timeframe">
    <xsl:param name="full"/>
    <xsl:choose>
      <xsl:when test="$full">
        <fo:table table-layout="fixed" width="100%" space-after="14pt">
          <fo:table-column column-width="40%"/>
          <fo:table-column column-width="15%"/>
          <fo:table-column column-width="45%"/>
          <fo:table-header background-color="#2A6EBB" font-size="14pt" font-weight="bold" color="#FFFFFF">
            <fo:table-row space-after="10px">
              <fo:table-cell text-align="left">
                <xsl:call-template name="timeframe-types-table-header"/>
              </fo:table-cell>
              <xsl:call-template name="empty-cell"/>
              <xsl:call-template name="empty-cell"/>
            </fo:table-row>
            <xsl:call-template name="timeframe-table-second-header"/>
          </fo:table-header>
          <fo:table-body>
            <xsl:apply-templates select="./child::node()">
              <xsl:with-param name="full" select="$full"/>
            </xsl:apply-templates>
          </fo:table-body>
        </fo:table>
      </xsl:when>
      <xsl:otherwise>
        <fo:table table-layout="fixed" width="100%" border="solid" border-width="1pt" border-color="#b7cfde" space-after="14pt">
          <fo:table-column column-width="40%"/>
          <fo:table-column column-width="15%"/>
          <fo:table-column column-width="45%"/>
          <fo:table-header background-color="#2A6EBB" font-size="14pt" font-weight="bold" color="#FFFFFF">
            <fo:table-row space-after="10px">
              <fo:table-cell text-align="left">
                <xsl:call-template name="timeframe-types-table-header"/>
              </fo:table-cell>
              <xsl:call-template name="empty-cell"/>
              <fo:table-cell text-align="right">
                <fo:block font-weight="bold" margin-top="5pt" margin-right="3pt" margin-bottom="4pt">
                  (summary)
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <xsl:call-template name="timeframe-table-second-header"/>
          </fo:table-header>
          <fo:table-body>
            <xsl:apply-templates select="./child::node()"/>
          </fo:table-body>
        </fo:table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="timeframe/pt-groups/pt-group/tx-options/tx-option">
    <xsl:param name="full"/>
    <fo:table-row>
      <xsl:variable name="tr_position" select="count(../preceding-sibling::tx-options/tx-option) + count(preceding-sibling::tx-option) + 1"/>
      <xsl:variable name="n_subgroups" select="count(../../pt-groups)"/>
      <xsl:choose>
        <xsl:when test="$tr_position = 1">
          <xsl:choose>
            <xsl:when test="$full">
              <xsl:choose>
                <xsl:when test="$n_subgroups != 0">
                  <xsl:call-template name="pt-group-cell-first-full"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="pt-group-cell-first"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="pt-group-cell-first"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$n_subgroups != 0">
          <xsl:call-template name="empty-cell-with-vertical-line"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="empty-cell"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="tx-line-cell"/>
      <xsl:choose>
        <xsl:when test="$full">
          <xsl:call-template name="tx-type-cell-down-arrow-full"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="tx-type-cell-right-arrow"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:table-row>

  </xsl:template>

  <xsl:template match="pt-group/pt-groups/pt-group/tx-options/tx-option">
    <xsl:param name="full"/>
    <xsl:choose>
      <xsl:when test="$full">
        <fo:table-row>
          <xsl:variable name="tr_position" select="count(../preceding-sibling::tx-options/tx-option) + count(preceding-sibling::tx-option) + 1"/>
          <xsl:variable name="pt_position" select="count(../../preceding-sibling::pt-group) + 1"/>
          <xsl:variable name="n_subgroups_tr" select="count(../../../pt-group)"/>
          <xsl:choose>
            <xsl:when test="($tr_position = 1) and ($pt_position != $n_subgroups_tr)">
              <xsl:call-template name="pt-subgroup-cell-first"/>
            </xsl:when>
            <xsl:when test="($tr_position = 1) and ($pt_position = $n_subgroups_tr)">
              <xsl:call-template name="pt-subgroup-cell-last"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="empty-cell-with-vertical-line"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:call-template name="tx-line-cell"/>
          <xsl:call-template name="tx-type-cell-down-arrow-full"/>
        </fo:table-row>
      </xsl:when>
      <xsl:otherwise>
        <fo:table-row>
          <xsl:variable name="tr_position" select="count(../preceding-sibling::tx-options/tx-option) + count(preceding-sibling::tx-option) + 1"/>
          <xsl:variable name="pt_position" select="count(../../preceding-sibling::pt-group) + 1"/>
          <xsl:variable name="n_subgroups_tr" select="count(../../../pt-group)"/>
          <xsl:choose>
            <xsl:when test="($tr_position = 1) and ($pt_position != $n_subgroups_tr)">
              <xsl:call-template name="pt-subgroup-cell-first"/>
            </xsl:when>
            <xsl:when test="($tr_position = 1) and ($pt_position = $n_subgroups_tr)">
              <xsl:call-template name="pt-subgroup-cell-last"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="empty-cell-with-vertical-line"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:call-template name="tx-line-cell"/>
          <xsl:call-template name="tx-type-cell-right-arrow"/>
        </fo:table-row>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="timeframe-types-table-header">
    <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
      <xsl:choose>
        <xsl:when test="@type='acute'">
          Acute
        </xsl:when>
        <xsl:when test="@type='ongoing'">
          Ongoing
        </xsl:when>
      </xsl:choose>
    </fo:block>
  </xsl:template>

  <xsl:template name="timeframe-table-second-header">
    <fo:table-row space-after="10px" background-color="#FFFFFF">
      <fo:table-cell text-align="left" background-color="#FFFFFF">
        <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt" color="#2A6EBB">
          Patient group
        </fo:block>
      </fo:table-cell>
      <fo:table-cell background-color="#FFFFFF">
        <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt" color="#2A6EBB">
          Tx line
        </fo:block>
      </fo:table-cell>
      <fo:table-cell background-color="#FFFFFF">
        <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt" color="#2A6EBB">
          Treatment
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <xsl:template name="pt-group-cell-first">
    <fo:table-cell>
      <fo:block font-weight="bold" margin-top="5pt" margin-left="14pt" margin-bottom="4pt">
        <xsl:value-of select="../../name"/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template name="pt-group-cell-first-full">
    <fo:table-cell margin="0pt" background-color="white" background-image="url('{$BP_PDF_treatment-detail-vertical}')" background-repeat="repeat-y"
      background-position-horizontal="7pt">
      <fo:block-container position="absolute" left="7pt">
        <fo:block>
          <fo:external-graphic src="url('{$BP_PDF_treatment-detail-vertical-double-empty}')"/>
        </fo:block>
      </fo:block-container>
      <fo:block font-weight="bold" margin-top="5pt" margin-left="14pt" margin-bottom="4pt">
        <xsl:value-of select="../../name"/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template name="pt-subgroup-cell-first">
    <fo:table-cell margin="0pt" background-color="white" background-image="url('{$BP_PDF_treatment-detail-vertical}')" background-repeat="repeat-y"
      background-position-horizontal="7pt">
      <fo:block font-weight="bold" margin-top="5pt" margin-left="5pt" margin-bottom="4pt">
        <fo:table>
          <fo:table-column column-width="20%"/>
          <fo:table-column column-width="80%"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell text-align="left">
                <fo:block>
                  <fo:external-graphic src="url('{$BP_PDF_treatment-detail-sub}')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left">
                <fo:block>
                  <xsl:value-of select="../../name"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template name="pt-subgroup-cell-last">
    <fo:table-cell margin="0pt" background-color="white" background-image="url('{$BP_PDF_treatment-detail-vertical-double}')"
      background-repeat="no-repeat" background-position-horizontal="7pt">
      <fo:block font-weight="bold" margin-top="5pt" margin-left="5pt" margin-bottom="4pt">
        <fo:table>
          <fo:table-column column-width="20%"/>
          <fo:table-column column-width="80%"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell text-align="left">
                <fo:block>
                  <fo:external-graphic src="url('{$BP_PDF_treatment-detail-sub}')"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left">
                <fo:block>
                  <xsl:value-of select="../../name"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-body>
        </fo:table>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template name="empty-cell-with-vertical-line">
    <fo:table-cell margin="0pt" background-color="white" background-image="url('{$BP_PDF_treatment-detail-vertical}')" background-repeat="repeat-y"
      background-position-horizontal="7pt">
      <fo:block>
        <fo:leader/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template name="empty-cell">
    <fo:table-cell>
      <fo:block>
        <fo:leader/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template name="tx-line-cell">
    <fo:table-cell>
      <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt" text-align="center">
        <xsl:choose>
          <xsl:when test="../@tx-line='1'">
            <xsl:value-of select="'1st'"/>
          </xsl:when>
          <xsl:when test="../@tx-line='P'">
            <xsl:value-of select="'plus'"/>
          </xsl:when>
          <xsl:when test="../@tx-line='A'">
            <xsl:value-of select="'adjunt'"/>
          </xsl:when>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template name="tx-type-cell-right-arrow">
    <fo:table-cell>
      <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
        <!-- &#x25b7; -->
        <fo:external-graphic src="url('{$BP_PDF_arrow-right}')" content-width="14px" vertical-align="middle"/>
        <xsl:value-of select="./tx-type"/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template name="tx-type-cell-down-arrow-full">
    <fo:table-cell>
      <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
        <!-- &#x25bd; -->
        <fo:external-graphic src="url('{$BP_PDF_arrow-down}')" content-width="14px" vertical-align="middle"/>
        <xsl:value-of select="./tx-type"/>
      </fo:block>
      <fo:block>
        <xsl:apply-templates select="./comments"/>
      </fo:block>
      <fo:block>
        <xsl:apply-templates select="./regimens"/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template match="tx-option/comments">
    <fo:block space-before="7pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="tx-option/comments/para">
    <fo:block space-after="10pt">
      <fo:inline color="#2A6EBB">&#187; </fo:inline>
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="tx-option/regimens">
    <fo:block page-break-inside="avoid">
      <fo:block font-weight="bold" margin-top="7pt" margin-left="3pt" margin-bottom="4pt" color="#2A6EBB" space-after="7pt">
        <xsl:choose>
          <xsl:when test="./@tier = 1">
            Primary options
          </xsl:when>
          <xsl:when test="./@tier = 2">
            Secondary options
          </xsl:when>
          <xsl:when test="./@tier = 3">
            Tertiary options
          </xsl:when>
        </xsl:choose>
      </fo:block>
      <xsl:apply-templates select="./regimen"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="tx-option/regimens/regimen">
    <fo:block font-weight="bold" space-before="3pt" space-after="7pt" margin-left="3pt">
      <xsl:value-of select="./regimen-name"></xsl:value-of>
    </fo:block>
    <fo:table table-layout="fixed" width="100%" border="1pt solid #b7cfde" space-after="10pt">
      <fo:table-body>
        <xsl:apply-templates select="./components"/>
      </fo:table-body>
    </fo:table>
    <xsl:if test="count(following-sibling::regimen) != 0">
      <fo:block font-weight="bold" space-after="0pt" margin-left="3pt">
        <xsl:value-of select="'OR'"/>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tx-option/regimens/regimen/components/component">
    <fo:table-row>
      <fo:table-cell>
        <fo:block margin="7pt">
          <fo:inline color="#2A6EBB">
            &#187;
            <xsl:value-of select="./name"/>
          </fo:inline>
          <xsl:value-of select="': '"/>
          <xsl:value-of select="./details"/>
          <xsl:choose>
            <xsl:when test="./@modifier = 'and' or ./@modifier = 'or'">
              <fo:inline font-weight="bold" font-style="italic" keep-together.within-line="always">
                <xsl:value-of select="concat(' -',./@modifier,'-')"/>
              </fo:inline>
            </xsl:when>
          </xsl:choose>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <xsl:if test="./@modifier = 'AND'">
      <fo:table-row page-break-inside="avoid">
        <fo:table-cell border="1pt solid #b7cfde">
          <fo:block font-weight="bold" margin="7pt">--AND--</fo:block>
        </fo:table-cell>
      </fo:table-row>
    </xsl:if>
  </xsl:template>

  <xsl:template match="monograph-full/treatment/emerging-txs">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" page-break-before="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Emerging
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="emerging-tx/name">
    <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- END TREATMENT -->

  <!-- FOLLOW UP -->

  <xsl:template match="monograph-full/followup/recommendations">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Recommendations
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:call-template name="followup-recommendations-monitoring"/>
      <xsl:call-template name="followup-recommendations-patientinstructions"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template name="followup-recommendations-monitoring">
    <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" margin-left="14.173pt" keep-with-next.within-page="always">
      <fo:inline border-bottom-color="#333333" border-bottom-style="solid" border-bottom-width="0.5pt" padding-bottom="2pt">
        Monitoring
      </fo:inline>
    </fo:block>
    <fo:block margin-left="14.173pt">
      <xsl:apply-templates select="./monitoring/child::node()"/>
    </fo:block>
  </xsl:template>

  <xsl:template name="followup-recommendations-patientinstructions">
    <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" margin-left="14.173pt"
      keep-with-next.within-page="always">
      <fo:inline border-bottom-color="#333333" border-bottom-style="solid" border-bottom-width="0.5pt" padding-bottom="2pt">
        Patient instructions
      </fo:inline>
    </fo:block>
    <fo:block margin-left="14.173pt">
      <xsl:apply-templates select="./patient-instructions/child::node()"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="monograph-full/followup/outlook">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="30pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Prognosis
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/followup/complications">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Complications
      </fo:inline>
    </fo:block>
    <fo:block>
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="60%"/>
        <fo:table-column column-width="20%"/>
        <fo:table-column column-width="20%"/>
        <fo:table-header background-color="#2A6EBB" font-size="14pt" font-weight="bold" color="#FFFFFF">
          <fo:table-row space-after="10px">
            <fo:table-cell>
              <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">Complications</fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">Timeframe</fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">Likelihood</fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-header>
        <fo:table-body>
          <xsl:for-each select="./complication">
            <xsl:sort data-type="number" order="ascending"
              select="((./@timeframe='short term') * 1) + ((./@timeframe='long term') * 2) + ((./@timeframe='variable') * 3)"/>
            <xsl:sort data-type="number" order="ascending" select="((./@likelihood='high') * 1) + ((./@likelihood='medium') * 2) + ((./@likelihood='low') * 3)"/>
            <fo:table-row page-break-inside="avoid" font-size="10pt">
              <fo:table-cell border="solid" border-width="1pt" border-color="#b7cfde" background-color="#F9F9F9">
                <fo:block font-weight="bold" margin="5pt">
                  <xsl:value-of select="./name"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="solid" border-width="1pt" border-color="#b7cfde" background-color="#F9F9F9">
                <fo:block font-weight="bold" margin="5pt" text-align="center">
                  <xsl:value-of select="./@timeframe"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="solid" border-width="1pt" border-color="#b7cfde" background-color="#F9F9F9">
                <fo:block font-weight="bold" margin="5pt" text-align="center">
                  <xsl:value-of select="./@likelihood"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
            <fo:table-row page-break-inside="avoid" font-size="14pt">
              <fo:table-cell border="solid" border-width="1pt" border-color="#b7cfde" number-columns-spanned="3">
                <fo:block font-size="10pt" font-weight="normal" margin="5pt">
                  <xsl:apply-templates select="./detail"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </xsl:for-each>
        </fo:table-body>
      </fo:table>
    </fo:block>
    <fo:block space-after="30pt"/>
  </xsl:template>

  <!-- END FOLLOW UP -->

  <!-- GUIDELINES -->

  <xsl:template match="monograph-full/diagnosis/guidelines">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Diagnostic guidelines
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:if test="./guideline[@region='Europe']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Europe'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='International']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'International'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='North America']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'North America'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Latin America']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Latin America'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Asia']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Asia'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Africa']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Africa'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Oceania']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Oceania'"/>
        </xsl:call-template>
      </xsl:if>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template name="guidelines-per-region">
    <xsl:param name="current_region"/>
    <fo:table table-layout="fixed" width="100%">
      <fo:table-column column-width="100%"/>
      <fo:table-header background-color="#2A6EBB" font-size="14pt" font-weight="bold" color="#FFFFFF">
        <fo:table-row space-after="10px">
          <fo:table-cell>
            <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
              <xsl:value-of select="$current_region"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>
      <fo:table-body>
        <xsl:apply-templates select="./guideline[@region=$current_region]"/>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <xsl:template match="guideline">
    <fo:table-row page-break-inside="avoid">
      <fo:table-cell border="solid" border-bottom="2pt" border-left="0pt" border-top="0pt" border-right="0pt" border-color="#2A6EBB">
        <fo:block font-size="12pt" font-weight="bold" margin="5pt" color="#2A6EBB" margin-top="10pt" margin-bottom="14pt">
          <xsl:value-of select="./title"/>
        </fo:block>
        <fo:block margin="3pt" space-after="7pt" margin-bottom="14pt">
          <fo:table table-layout="fixed" width="100%">
            <fo:table-column column-width="70%"/>
            <fo:table-column column-width="30%"/>
            <fo:table-body>
              <fo:table-row space-after="10px">
                <fo:table-cell>
                  <fo:block>
                    <fo:inline font-weight="bold">Published by: </fo:inline>
                    <xsl:value-of select="./source"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block>
                    <fo:inline font-weight="bold">Last published: </fo:inline>
                    <xsl:value-of select="./last-published"/>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-body>
          </fo:table>
        </fo:block>
        <xsl:if test="./summary/para[text() != '']">
          <fo:block margin="5pt" margin-bottom="14pt">
            <fo:inline font-weight="bold">Summary: </fo:inline>
            <xsl:value-of select="./summary"/>
          </fo:block>
        </xsl:if>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <xsl:template match="monograph-full/treatment/guidelines">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Treatment guidelines
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:if test="./guideline[@region='Europe']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Europe'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='International']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'International'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='North America']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'North America'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Latin America']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Latin America'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Asia']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Asia'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Africa']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Africa'"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Oceania']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Oceania'"/>
        </xsl:call-template>
      </xsl:if>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <!-- END GUIDELINES -->

  <!-- ONLINE RESOURCES -->

  <xsl:template match="monograph-full/online-references">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Online resources
      </fo:inline>
    </fo:block>
    <fo:list-block padding="4pt" line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="monograph-full/online-references/reference">
    <fo:list-item provisional-distance-between-starts="1cm" space-after="14pt">
      <fo:list-item-label end-indent="label-end()">
        <fo:block>
          <xsl:number
            value="count(
                preceding-sibling::reference
                |
                ../../preceding-sibling::online-references/reference)
                + 1"
            format="1.&#x20;"/>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block border-width="0.25pt" border-after-style="solid" border-color="#f0f0f0" >
          <xsl:variable name="title">
            <xsl:value-of select="title"/>
          </xsl:variable>
          <xsl:if test="poc-citation[@type='online']">
            <xsl:value-of select="'  '"/>
            <xsl:variable name="poc-citation-url" select="./poc-citation/url"/>
            <fo:basic-link external-destination="url({$poc-citation-url})" color="#2a6ebb">
              <xsl:value-of select="$title"/>
              <fo:inline color="black" font-style="italic">
                <xsl:value-of select="' (external link)'"/>
              </fo:inline>
            </fo:basic-link>
          </xsl:if>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- END ONLINE RESOURCES -->

  <!-- EVIDENCE SCORES -->

  <xsl:template match="monograph-full/evidence-scores">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Evidence scores
      </fo:inline>
    </fo:block>
    <fo:list-block padding="4pt" line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:list-block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/evidence-scores/evidence-score">
    <fo:list-item provisional-distance-between-starts="1cm" space-after="14pt">
      <fo:list-item-label end-indent="label-end()">
        <fo:block>
          <xsl:number
            value="count(
                preceding-sibling::evidence-score
                |
                ../../preceding-sibling::evidence-scores/evidence-score)
                + 1"
            format="1.&#x20;"/>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block border-width="0.25pt" border-after-style="solid" border-color="#f0f0f0" padding-bottom="6pt" margin-bottom="6pt" id="E{@id}">
          <xsl:value-of select="./comments"/>
          <xsl:choose>
            <xsl:when test="./@score = 'A'">
              <fo:block>
                <fo:inline font-weight="bold" color="#2A6EBB">Evidence level A</fo:inline>:
                Systematic reviews (SRs) or randomized controlled trials (RCTs) of &gt;200 participants.
              </fo:block>
            </xsl:when>
            <xsl:when test="./@score = 'B'">
              <fo:block>
                <fo:inline font-weight="bold" color="#2A6EBB">Evidence level B</fo:inline>
              </fo:block>
            </xsl:when>
            <xsl:when test="./@score = 'C'">
              <fo:block>
                <fo:inline font-weight="bold" color="#2A6EBB">Evidence level C</fo:inline>:
                Poor quality observational (cohort) studies or methodologically flawed randomized controlled trials (RCTs)
                of &lt;200 participants.
              </fo:block>
            </xsl:when>
          </xsl:choose>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- END EVIDENCE SCORES -->

  <!-- REFERENCES -->

  <xsl:template match="monograph-full/article-references">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Key articles
      </fo:inline>
    </fo:block>
    <fo:list-block padding="4pt" line-height="15pt">
      <xsl:for-each select="./reference[poc-citation/@key-article = 'true']">
        <xsl:call-template name="key-articles"/>
      </xsl:for-each>
    </fo:list-block>
    <fo:block space-after="14pt"/>
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        References
      </fo:inline>
    </fo:block>
    <fo:list-block padding="4pt" line-height="15pt">
      <xsl:apply-templates select="./reference"/>
    </fo:list-block>
  </xsl:template>

  <xsl:template name="key-articles">
    <fo:list-item provisional-distance-between-starts="1cm">
      <fo:list-item-label end-indent="label-end()">
        <fo:block>&#x02022;</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block border-width="0.25pt" border-after-style="solid" border-color="#f0f0f0" padding-bottom="6pt" margin-bottom="6pt">
          <xsl:value-of select="./poc-citation/citation"/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="monograph-full/article-references/reference">
    <fo:list-item provisional-distance-between-starts="1cm">
      <fo:list-item-label end-indent="label-end()">
        <fo:block>
          <xsl:number
            value="count(
                preceding-sibling::reference
                |
                ../../preceding-sibling::article-references/reference)
                + 1"
            format="1.&#x20;"/>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block id="{./@id}" border-width="0.25pt" border-after-style="solid" border-color="#f0f0f0" padding-bottom="6pt" margin-bottom="6pt" >
          <xsl:value-of select="./poc-citation/citation"/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- END REFERENCES -->

  <!-- IMAGES -->

  <xsl:template match="monograph-full/figures">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Images
      </fo:inline>
    </fo:block>
    <fo:block padding="4pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="figures/figure">
    <fo:block border-after-width="2pt" border-after-style="solid" border-color="#b7cfde" space-after="14pt" id="f{@id}">
        <xsl:variable name="image" select="./image-link/@target"/>
      <fo:block text-align="center" space-after="14pt" border-style="solid" border-width="0.5pt" border-color="#f0f0f0" padding="6pt">
        <fo:external-graphic src="url('{$image}')"/>
      </fo:block>
      <fo:block font-size="12pt" font-style="italic" space-after="14pt" border-after-style="solid" border-after-width="0.5pt" border-after-color="#f0f0f0">
        <xsl:value-of select="concat('Figure ',./@id,': ', ./caption)"/>
      </fo:block>
      <fo:block font-size="12pt" font-style="italic" space-after="28pt">
        <xsl:value-of select="./source"/>
      </fo:block>
    </fo:block>
  </xsl:template>

  <!-- END IMAGES -->

  <!-- DISCLAIMER -->

  <xsl:template name="disclaimer-content">
    <fo:block font-family="nevis" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" keep-with-next.within-page="always">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        Disclaimer
      </fo:inline>
    </fo:block>

    <fo:block font-size="12pt" line-height="18pt" font-weight="bold" text-align="left" space-after="10pt">
      This content is meant for medical professionals situated
      outside of the United States and Canada.
      The BMJ Publishing Group Ltd ("BMJ Group") tries to ensure that the information
      provided is accurate and
      up-to-date, but we do not warrant that it is nor do our licensors
      who supply certain content linked to or otherwise accessible from our content.
      The BMJ
      Group does not advocate or endorse the use of any drug or therapy contained within
      nor does it diagnose patients. Medical professionals
      should use their own professional
      judgement in using this information and caring for their patients and the information
      herein should not be
      considered a substitute for that.
    </fo:block>

    <fo:block font-size="12pt" line-height="18pt" font-weight="bold" text-align="left" space-after="10pt">
      This information is not intended to cover all possible
      diagnosis methods, treatments,
      follow up, drugs and any contraindications or side effects. In addition such standards
      and practices in medicine
      change as new data become available, and you should consult
      a variety of sources. We strongly recommend that users independently verify specified
      diagnosis, treatments and follow up and ensure it is appropriate for your patient within
      your region. In addition, with respect to prescription
      medication, you are advised to check
      the product information sheet accompanying each drug to verify conditions of use and
      identify any changes in
      dosage schedule or contraindications, particularly if the agent to
      be administered is new, infrequently used, or has a narrow therapeutic range.
      You must
      always check that drugs referenced are licensed for the specified use and at the specified
      doses in your region. This information is
      provided on an "as is" basis and to the fullest
      extent permitted by law the BMJ Group and its licensors assume no responsibility for any
      aspect of
      healthcare administered with the aid of this information or any other use of this
      information.
    </fo:block>
  </xsl:template>

  <!-- END DISCLAIMER -->

  <!-- LAST PAGE -->

  <xsl:template name="monograph-full-monograph-info-authors-author-acknowledgements">
    <xsl:param name="authors"/>
    <xsl:for-each select="$authors">
      <xsl:if test="./name = 'Acknowledgements'">
        <fo:table-row>
          <fo:table-cell>
            <fo:block margin-left="10pt" font-style="normal" font-size="12pt">
              <xsl:for-each select="./title-affil/para/child::node()">
                <xsl:choose>
                  <xsl:when test="position() = last()">
                    <xsl:value-of select="."/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="."/>
                    <xsl:value-of select="',  '"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
        <fo:table-row>
          <fo:table-cell>
            <fo:block margin-left="10pt" font-weight="normal" font-size="10pt">
              <xsl:value-of select="'DISCLOSURES: '"/>
              <xsl:apply-templates select="./disclosures/child::node()"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="monograph-full/monograph-info/authors/author">
    <xsl:if test="./name != 'Acknowledgements'">
      <fo:table-row>
        <fo:table-cell>
          <fo:block font-size="12pt" font-weight="bold" margin-top="14pt" margin-left="10pt" margin-bottom="4pt" border-after-style="solid"
            border-after-width="0.5pt" border-after-color="#f0f0f0">
            <xsl:apply-templates select="./name"/>
            <xsl:value-of select="', '"/>
            <xsl:apply-templates select="./degree"/>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
      <fo:table-row>
        <fo:table-cell>
          <fo:block font-style="normal" font-size="10pt" margin-left="10pt">
            <xsl:for-each select="./title-affil/para/child::node()">
              <!--<xsl:apply-templates select="."/> -->
              <xsl:choose>
                <xsl:when test="position() = 1">
                  <fo:block font-style="normal" font-weight="normal">
                    <xsl:value-of select="."/>
                  </fo:block>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="position() = last()">
                      <xsl:value-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="."/>
                      <xsl:value-of select="',  '"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
      <fo:table-row>
        <fo:table-cell>
          <fo:block margin-left="10pt" font-weight="normal" font-size="10pt">
            <xsl:value-of select="'DISCLOSURES: '"/>
            <xsl:apply-templates select="./disclosures/child::node()"/>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
    </xsl:if>
  </xsl:template>

  <xsl:template match="monograph-full/monograph-info/peer-reviewers/peer-reviewer">
    <fo:table-row space-after="10px">
      <fo:table-cell>
        <fo:block font-size="12pt" font-weight="bold" margin-top="14pt" margin-left="10pt" margin-bottom="4pt" border-after-style="solid" border-after-width="0.5pt"
          border-after-color="#f0f0f0">
          <xsl:apply-templates select="./name"/>
          <xsl:value-of select="', '"/>
          <xsl:apply-templates select="./degree"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block margin-left="10pt" font-style="normal" font-size="10pt">
          <xsl:for-each select="./title-affil/para/child::node()">
            <!--<xsl:apply-templates select="."/> -->
            <xsl:choose>
              <xsl:when test="position() = 1">
                <fo:block font-style="normal" font-weight="normal">
                  <xsl:value-of select="."/>
                </fo:block>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="position() = last()">
                    <xsl:value-of select="."/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="."/>
                    <xsl:value-of select="',  '"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <fo:table-row>
      <fo:table-cell>
        <fo:block font-weight="normal" margin-left="10pt" font-size="10pt">
          <xsl:value-of select="'DISCLOSURES: '"/>
          <xsl:apply-templates select="./disclosures/child::node()"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <!-- END LAST PAGE -->

  <xsl:template match="reference-link">
    <fo:basic-link internal-destination="{@target}" color="#2a6ebb" font-weight="bold">
      <xsl:value-of select="concat('[',./@target,']')"/>
    </fo:basic-link>
  </xsl:template>

  <xsl:template match='evidence-score-link'>
    <fo:basic-link internal-destination="E{@target}" color="#2a6ebb" font-weight="bold">
      <xsl:value-of select="concat(./@target, '[',./@score,']', 'Evidence')"/>
    </fo:basic-link>
  </xsl:template>

  <xsl:template match="figure-link">
    <xsl:choose>
      <xsl:when test="./@inline='false'">
        <fo:basic-link internal-destination="f{@target}" color="#2a6ebb" font-weight="bold">
          <xsl:value-of select="concat('[F',./@target,']')"/>
        </fo:basic-link>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="para">
    <xsl:choose>
      <xsl:when test="count(./child::node()) = 1">
        <fo:block space-after="10pt" line-height="15pt">
          <xsl:apply-templates select="./child::node()"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="item" select="(./child::node())[last()]"/>
        <xsl:choose>
          <xsl:when test="name($item) = 'figure'">
            <fo:block space-after="10pt">
              <xsl:for-each select="(./child::node())[position() != last()]">
                <xsl:apply-templates select="."/>
              </xsl:for-each>
            </fo:block>
            <xsl:for-each select="(./child::node())[last()]">
              <xsl:apply-templates select="."/>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <fo:block space-after="10pt">
              <xsl:for-each select="./child::node()">
                <xsl:apply-templates select="."/>
              </xsl:for-each>
            </fo:block>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="list">
    <fo:list-block padding="4pt">
      <xsl:apply-templates/>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="item">
    <xsl:variable name="style" select="../@style"/>
    <xsl:choose>
      <xsl:when test="$style ='1'">
        <fo:list-item provisional-distance-between-starts="1cm">
          <fo:list-item-label end-indent="label-end()">
            <fo:block text-align="right">
              <xsl:number
                value="count(
                preceding-sibling::item
                |
                ../../preceding-sibling::list/item)
                + 1"
                format="1.&#x20;"/>
            </fo:block>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <fo:block>
              <xsl:apply-templates/>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </xsl:when>
      <xsl:otherwise>
        <fo:list-item provisional-distance-between-starts="1cm">
          <fo:list-item-label end-indent="label-end()">
            <fo:block text-align="right">&#x02022;</fo:block>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <fo:block>
              <xsl:apply-templates/>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="classification/title">
    <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline"
      keep-with-next.within-page="always">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <xsl:template match="section-header">
    <fo:block font-family="nevis" font-size="14pt" font-weight="bold" space-before="12pt" space-after="6pt" 
      margin-left="14.173pt" keep-with-next.within-page="always">
        <fo:inline border-bottom-color="#333333" border-bottom-style="solid" border-bottom-width="0.5pt" padding-bottom="2pt">
          <xsl:apply-templates/>
        </fo:inline>
    </fo:block>
  </xsl:template>

  <xsl:template match="reference">
    <xsl:variable name="title">
      <xsl:value-of select="title"/>
    </xsl:variable>
    <xsl:if test="poc-citation[@type='online']">
      <xsl:value-of select="'  '"/>
      <xsl:variable name="poc-citation-url" select="./poc-citation/url"/>
      <fo:basic-link external-destination="url({$poc-citation-url})" color="#2a6ebb">
        <xsl:value-of select="' ['"/>
        <xsl:value-of select="$title"/>
        <xsl:value-of select="'] '"/>
      </fo:basic-link>
    </xsl:if>
  </xsl:template>

  <xsl:template match="figure">
    <fo:block text-align="center" space-after="14pt">
      <xsl:variable name=" image " select="./image-link/@target"/>
      <fo:block space-after="14pt" border="1pt solid #b7cfde">
        <fo:external-graphic margin="14pt" content-width="12cm" background-color="white" src="url('{$image}')"/>
      </fo:block>
      <fo:block font-weight="bold">
        <xsl:value-of select="./caption"/>
      </fo:block>
      <fo:block font-weight="bold" space-after="14pt">
        <xsl:value-of select="./source"/>
      </fo:block>
    </fo:block>
  </xsl:template> 
 <!-- 
  <xsl:template match="image-link">
        
        <xsl:element name="fo:external-graphic" use-attribute-sets="align-center">
            <xsl:attribute name="scaling">uniform</xsl:attribute>
            <xsl:attribute name="content-width">140mm</xsl:attribute>
        
            <xsl:attribute name="src">
                <xsl:text>url('</xsl:text>
                <xsl:value-of select="$INLINE_IMAGE_PATH"/>
                <xsl:value-of 
                    select="replace(@target , '^\./images/(.+?)(_default)?\.(.+?)$' , '$1$2.$3')"/>
                <xsl:text>')</xsl:text>
            </xsl:attribute>
            
        </xsl:element>

    </xsl:template>
  -->
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="../../xsl-lib/strings/bp-pdf-static-text.xsl"/>

  <xsl:param name="copyrightYear"/>
  <xsl:param name="default-lang"/>
  
  <xsl:variable name="lang">
      <xsl:choose>
          <xsl:when test="/monograph-full/@lang">
              <xsl:value-of select="/monograph-full/@lang"/>
          </xsl:when>
          <xsl:otherwise>
              <xsl:value-of select="$default-lang"/>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:variable>

  <xsl:variable name="title-font">
    <xsl:choose>
      <xsl:when test="$lang = 'zh-cn'">
        <xsl:value-of select="'NotoSansCJKsc'"/>
      </xsl:when>
  	  <xsl:when test="$lang = 'az-az'">
        <xsl:value-of select="'CharisSIL'"/>
      </xsl:when>
  	  <xsl:when test="$lang = 'ka-ge'">
        <xsl:value-of select="'Gorda'"/>
      </xsl:when>
		<xsl:when test="$lang = 'uk-uk'">
			<xsl:value-of select="'CharisSIL'" />
		</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'rm'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="font">
    <xsl:choose>
      <xsl:when test="$lang = 'zh-cn'">
        <xsl:value-of select="'NotoSansCJKsc'"/>
      </xsl:when>
      <xsl:when test="$lang = 'az-az'">
        <xsl:value-of select="'CharisSIL'"/>
      </xsl:when>
      <xsl:when test="$lang = 'ka-ge'">
        <xsl:value-of select="'Gorda'"/>
      </xsl:when>
		<xsl:when test="$lang = 'uk-uk'">
			<xsl:value-of select="'CharisSIL'" />
		</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'InterFace'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Page layout information -->

  <xsl:template match="/">

    <xsl:element name="fo:root">

      <xsl:attribute name="font-family"><xsl:value-of select="$font"/></xsl:attribute>
      <xsl:attribute name="font-size">10pt</xsl:attribute>

      <!-- <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="InterFace" font-size="10pt"> -->

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
            <fo:external-graphic content-width="17cm" src="url('../images/BP_PDF_BP_logo_White_on_blue_cropped_default.png')"/>
          </fo:block>
          <xsl:variable name="title-length" select="string-length(monograph-full/monograph-info/title)"/>
          <xsl:element name="fo:block">
            <xsl:attribute name="font-family"><xsl:value-of select="$title-font"/></xsl:attribute>
            <xsl:choose>
              <xsl:when test="$title-length > 45">
                <xsl:attribute name="font-size">38pt</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="font-size">45pt</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:attribute name="font-weight">bold</xsl:attribute>
            <xsl:attribute name="text-align">center</xsl:attribute>
            <xsl:attribute name="space-after">36pt</xsl:attribute>
            <xsl:attribute name="color">#FFFFFF</xsl:attribute>
            <xsl:attribute name="margin-left">10px</xsl:attribute>
            <xsl:attribute name="margin-right">10px</xsl:attribute>
            <xsl:apply-templates select="monograph-full/monograph-info/title"/>
          </xsl:element>
          <fo:block-container absolute-position="absolute" top="10.7cm">
            <fo:block font-size="15pt" letter-spacing="1.5pt" text-align="center" color="#FFFFFF" margin-left="10px" margin-right="10px">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/first-page/subtitle"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container absolute-position="absolute" top="12.1cm">
            <fo:block font-size="0pt" top="14cm" padding="0mm" margin="0mm" line-height="0mm">
              <fo:external-graphic padding="0mm" margin="0mm" content-width="20cm" height="15cm" content-height="scale-to-fit"
                scaling="non-uniform" background-color="white" src="url('../images/BP_PDF_Standard_cover_default.jpg')"/>
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
                        <xsl:value-of select="$strings//str[@xml:lang=$lang]/first-page/last-updated"/>
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

            <fo:block font-family="{$title-font}">
              <fo:inline border-after-width="3.0pt" border-after-style="solid" border-color="#cbdde7" color="#2b2b2b" font-size="18pt"
                margin="14pt">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/toc/title"/>
              </fo:inline>
            </fo:block>

            <!-- Summary link -->
            <xsl:call-template name="summary-toc"/>

            <!--Basics -->
            <xsl:call-template name="toc-main-section">
              <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/basics/title"/>
              <xsl:with-param name="hardcoded-id" select="'basics-id'"/>
            </xsl:call-template>
            <xsl:apply-templates select="monograph-full/basics/definition" mode="toc"/>
            <xsl:apply-templates select="monograph-full/basics/epidemiology" mode="toc"/>
            <xsl:apply-templates select="monograph-full/basics/etiology" mode="toc"/>
            <xsl:apply-templates select="monograph-full/basics/pathophysiology" mode="toc"/>
            <xsl:apply-templates select="monograph-full/basics/classifications" mode="toc"/>

            <!--Prevention -->
            <xsl:call-template name="toc-main-section">
              <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/prevention/title"/>
              <xsl:with-param name="hardcoded-id" select="'prevention-id'"/>
            </xsl:call-template>
            <xsl:apply-templates select="monograph-full/basics/prevention" mode="toc"/> <!-- Primary Prevention -->
            <xsl:apply-templates select="monograph-full/diagnosis/screening" mode="toc"/> <!-- Screening -->
            <xsl:apply-templates select="monograph-full/followup/recommendations/preventive-actions" mode="toc"/> <!--Secondary Prevention -->

            <!--Diagnosis -->
            <xsl:call-template name="toc-main-section">
              <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/diagnosis/title"/>
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
              <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/treatment/title"/>
              <xsl:with-param name="hardcoded-id" select="'treatment-id'"/>
            </xsl:call-template>
            <xsl:apply-templates select="monograph-full/treatment/approach" mode="toc"/> <!-- Step-by-step treatment approach -->
            <xsl:call-template name="treatment-details-overview-toc"></xsl:call-template> <!-- Treatment details/overview options -->
            <xsl:apply-templates select="monograph-full/treatment/timeframes" mode="toc"/> <!-- Treatment details/overview options -->
            <xsl:apply-templates select="monograph-full/treatment/emerging-txs" mode="toc"/> <!-- Emerging -->

            <!--Follow Up -->
            <xsl:call-template name="toc-main-section">
              <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/follow-up/title"/>
              <xsl:with-param name="hardcoded-id" select="'followup-id'"/>
            </xsl:call-template>
            <xsl:apply-templates select="monograph-full/followup/recommendations" mode="toc"/> <!-- Recommendations -->
            <xsl:apply-templates select="monograph-full/followup/complications" mode="toc"/> <!-- Complications -->
            <xsl:apply-templates select="monograph-full/followup/outlook" mode="toc"/> <!-- Prognosis -->

            <!-- Guidelines -->
            <xsl:if test="(monograph-full/diagnosis/guidelines) or (monograph-full/treatment/guidelines)">
              <xsl:call-template name="toc-main-section">
                <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/guidelines/title"/>
                <xsl:with-param name="hardcoded-id" select="'guidelines-id'"/>
              </xsl:call-template>
              <xsl:apply-templates select="monograph-full/diagnosis/guidelines" mode="toc"/> <!-- Diagnostic guidelines -->
              <xsl:apply-templates select="monograph-full/treatment/guidelines" mode="toc"/> <!-- Treatment guidelines -->
            </xsl:if>

            <!-- Online resources -->
            <xsl:if test="monograph-full/online-references">
              <xsl:call-template name="toc-main-section">
                <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/online-resources/title"/>
                <xsl:with-param name="hardcoded-id" select="'online-resources-id'"/>
              </xsl:call-template>
            </xsl:if>

            <!-- Evidence scores -->
            <xsl:if test="monograph-full/evidence-scores">
              <xsl:call-template name="toc-main-section">
                <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/evidence-scores/title"/>
                <xsl:with-param name="hardcoded-id" select="'evidence-scores-id'"/>
              </xsl:call-template>
            </xsl:if>

            <!-- References -->
            <xsl:if test="monograph-full/article-references">
              <xsl:call-template name="toc-main-section">
                <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/references/title"/>
                <xsl:with-param name="hardcoded-id" select="'references-id'"/>
              </xsl:call-template>
            </xsl:if>

            <!-- Images -->
            <xsl:if test="monograph-full/figures">
              <xsl:call-template name="toc-main-section">
                <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/images/title"/>
                <xsl:with-param name="hardcoded-id" select="'images-id'"/>
              </xsl:call-template>
            </xsl:if>

            <!-- Disclaimer -->
            <xsl:call-template name="toc-main-section">
              <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/disclaimer/title"/>
              <xsl:with-param name="hardcoded-id" select="'disclaimer-id'"/>
            </xsl:call-template>

          </fo:block>
        </fo:flow>
      </fo:page-sequence>

      <fo:page-sequence master-reference="summary-page">
        <fo:flow flow-name="body">
          <!-- place the Summary block heading over the top margin -->
          <fo:block-container position="absolute" top="-0.75cm" left="6.0cm" width="148pt">
            <fo:block font-family="{$title-font}" font-size="18pt" text-align-last="center" space-before="7pt" background-color="#FFFFFF"
              border-top-color="#b7cfde" border-top-style="solid" border-top-width="3.7pt" border-bottom-color="#b7cfde" border-bottom-style="solid"
              border-bottom-width="3.7pt" border-left-color="#b7cfde" border-left-style="solid" border-left-width="3.7pt" border-right-color="#b7cfde"
              border-right-style="solid" border-right-width="3.7pt" padding-top="4pt" padding-bottom="4pt" id="{generate-id()}">
              <fo:inline>
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/summary/title"/>
              </fo:inline>
            </fo:block>
          </fo:block-container>
          <fo:block font-size="10pt" text-align-last="left" border-after-width="1pt" border-after-style="solid" border-color="#b7cfde"
            border-top-color="#b7cfde" border-top-style="solid" border-top-width="3.7pt" border-bottom-color="#b7cfde" border-bottom-style="solid"
            border-bottom-width="3.7pt" border-left-color="#b7cfde" border-left-style="solid" border-left-width="3.7pt" border-right-color="#b7cfde"
            border-right-style="solid" border-right-width="3.7pt">
            <fo:block margin-top="30pt">
              <fo:basic-link internal-destination="{generate-id()}">
                <xsl:apply-templates select="monograph-full/highlights"/>
              </fo:basic-link>
            </fo:block>
          </fo:block>
        </fo:flow>
      </fo:page-sequence>

      <fo:page-sequence master-reference="content-basics">

        <fo:static-content flow-name="even-page-header">
          <xsl:call-template name="even-header-contents-basics"/>
        </fo:static-content>

        <fo:static-content flow-name="even-page-start">
          <fo:block-container reference-orientation="90" position="absolute" top="2mm" right="9mm">
            <fo:block text-align="right">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="2.85cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/basics/tab"/>
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-end">
          <fo:block-container reference-orientation="270" position="absolute" top="2mm" right="0mm">
            <fo:block text-align="left">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="270" position="absolute" top="2.85cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/basics/tab"/>
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
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="9.05cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/prevention/tab"/>
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-end">
          <fo:block-container reference-orientation="270" position="absolute" top="7cm" right="0mm">
            <fo:block text-align="left">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="270" position="absolute" top="9.05cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/prevention/tab"/>
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
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="16.3cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/tab"/>
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-end">
          <fo:block-container reference-orientation="270" position="absolute" top="14cm" right="0mm">
            <fo:block text-align="left">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="270" position="absolute" top="16.3cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/tab"/>
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
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="23.2cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/tab"/>
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-end">
          <fo:block-container reference-orientation="270" position="absolute" top="21cm" right="0mm">
            <fo:block text-align="left">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="270" position="absolute" top="23.2cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/tab"/>
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
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="2.45cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/tab"/>
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-end">
          <fo:block-container reference-orientation="270" position="absolute" top="2mm" right="0mm">
            <fo:block text-align="left">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="270" position="absolute" top="2.45cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/tab"/>
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
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="9.17cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/guidelines/tab"/>
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-end">
          <fo:block-container reference-orientation="270" position="absolute" top="7cm" right="0mm">
            <fo:block text-align="left">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="270" position="absolute" top="9.17cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/guidelines/tab"/>
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
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                  src="url('../images/BP_PDF_tab_bottom_default.png')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="90" position="absolute" top="15.45cm" left="0.4cm">
              <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/online-resources/tab"/>
              </fo:block>
            </fo:block-container>
          </fo:static-content>

          <fo:static-content flow-name="odd-page-end">
            <fo:block-container reference-orientation="270" position="absolute" top="14cm" right="0mm">
              <fo:block text-align="left">
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                  src="url('../images/BP_PDF_tab_bottom_default.png')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="270" position="absolute" top="15.45cm" right="4mm">
              <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/online-resources/tab"/>
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
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                  src="url('../images/BP_PDF_tab_bottom_default.png')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="90" position="absolute" top="22.6cm" left="0.4cm">
              <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/evidence-scores/tab"/>
              </fo:block>
            </fo:block-container>
          </fo:static-content>

          <fo:static-content flow-name="odd-page-end">
            <fo:block-container reference-orientation="270" position="absolute" top="21cm" right="0mm">
              <fo:block text-align="left">
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                  src="url('../images/BP_PDF_tab_bottom_default.png')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="270" position="absolute" top="22.6cm" right="4mm">
              <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/evidence-scores/tab"/>
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
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                  src="url('../images/BP_PDF_tab_bottom_default.png')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="90" position="absolute" top="2.35cm" left="0.4cm">
              <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/references/tab"/>
              </fo:block>
            </fo:block-container>
          </fo:static-content>

          <fo:static-content flow-name="odd-page-end">
            <fo:block-container reference-orientation="270" position="absolute" top="2mm" right="0mm">
              <fo:block text-align="left">
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                  src="url('../images/BP_PDF_tab_bottom_default.png')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="270" position="absolute" top="2.35cm" right="4mm">
              <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/references/tab"/>
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
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                  src="url('../images/BP_PDF_tab_bottom_default.png')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="90" position="absolute" top="9.6cm" left="0.4cm">
              <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/images/tab"/>
              </fo:block>
            </fo:block-container>
          </fo:static-content>

          <fo:static-content flow-name="odd-page-end">
            <fo:block-container reference-orientation="270" position="absolute" top="7cm" right="0mm">
              <fo:block text-align="left">
                <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                  src="url('../images/BP_PDF_tab_bottom_default.png')"/>
              </fo:block>
            </fo:block-container>
            <fo:block-container reference-orientation="270" position="absolute" top="9.6cm" right="4mm">
              <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/images/tab"/>
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
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="16.2cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/tab"/>
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-end">
          <fo:block-container reference-orientation="270" position="absolute" top="14cm" right="0mm">
            <fo:block text-align="left">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="270" position="absolute" top="16.2cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/tab"/>
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
            <fo:external-graphic content-width="17cm" src="url('../images/BP_PDF_BMJ-Best Practice_logo_default.jpg')"/>
          </fo:block>
          <fo:block margin-left="20pt" margin-right="20pt">
            <fo:table table-layout="fixed" border="none" border-width="1pt" border-color="#b7cfde">
              <fo:table-column column-width="100%"/>
              <fo:table-header background-color="#FFFFFF" font-size="14pt" font-weight="bold" color="#2A6EBB">
                <fo:table-row space-after="10px">
                  <fo:table-cell>
                    <fo:block font-family="{$title-font}" font-size="20pt" font-weight="bold" margin-top="14pt" margin-left="3pt"
                      margin-bottom="4pt" border-after-style="solid" border-after-width="1pt" border-after-color="#b7cfde">
                      <xsl:value-of select="$strings//str[@xml:lang=$lang]/last-page/title"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
              </fo:table-header>
              <fo:table-body>
                <fo:table-row space-after="10px">
                  <fo:table-cell>
                    <fo:block font-weight="bold" margin-top="18pt" margin-bottom="10pt" margin="0pt" font-size="15pt" color="#2A6EBB">
                      <xsl:value-of select="$strings//str[@xml:lang=$lang]/last-page/authors"/>
                    </fo:block>
                  </fo:table-cell>
                </fo:table-row>
                <xsl:apply-templates select="monograph-full/monograph-info/authors/author"/>
                <xsl:if test="monograph-full/monograph-info/authors/author/name = 'Acknowledgements'">
                  <fo:table-row space-after="10px">
                    <fo:table-cell>
                      <fo:block font-weight="bold" margin-top="18pt" margin-bottom="10pt" margin="0pt" font-size="15pt" color="#2A6EBB">
                        <xsl:value-of select="$strings//str[@xml:lang=$lang]/last-page/acknowledgements"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <xsl:call-template name="monograph-full-monograph-info-authors-author-acknowledgements">
                    <xsl:with-param name="authors" select="monograph-full/monograph-info/authors/author"/>
                  </xsl:call-template>
                </xsl:if>
                <xsl:if test="monograph-full/monograph-info/peer-reviewers">
                  <fo:table-row space-after="10px">
                    <fo:table-cell>
                      <fo:block font-weight="bold" margin-top="18pt" margin-bottom="10pt" margin="0pt" font-size="15pt" color="#2A6EBB">
                        <xsl:value-of select="$strings//str[@xml:lang=$lang]/last-page/peer-reviewers"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <xsl:apply-templates select="monograph-full/monograph-info/peer-reviewers/peer-reviewer"/>
                </xsl:if>
              </fo:table-body>
            </fo:table>
          </fo:block>
        </fo:flow>
      </fo:page-sequence>

    </xsl:element>
    <!-- </fo:root> -->

  </xsl:template>

  <!-- HEADERS -->

  <xsl:template name="common-header">
    <xsl:param name="section"/>
    <fo:block font-family="{$title-font}">
      <fo:table table-layout="fixed" width="100%" border-bottom-width="1pt" border-bottom-style="solid" border-color="#cadce7">
        <fo:table-column column-width="60%"/>
        <fo:table-column column-width="40%"/>
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
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/basics/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-basics">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/basics/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-prevention">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/prevention/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-prevention">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/prevention/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-diagnosis">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/diagnosis/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-diagnosis">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/diagnosis/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-treatment">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/treatment/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-treatment">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/treatment/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-followup">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/follow-up/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-followup">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/follow-up/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-guidelines">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/guidelines/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-guidelines">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/guidelines/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-online_resources">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/online-resources/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-online_resources">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/online-resources/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-evidence_scores">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/evidence-scores/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-evidence_scores">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/evidence-scores/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-references">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/references/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-references">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/references/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-images">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/images/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-images">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/images/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-disclaimer">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/disclaimer/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-disclaimer">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/disclaimer/title"/>
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
      <xsl:value-of select="$strings//str[@xml:lang=$lang]/footer/disclaimer-1"/>
      <xsl:apply-templates select="monograph-full/monograph-info/last-updated"/>
      <xsl:value-of select="$strings//str[@xml:lang=$lang]/dot"/>
    </fo:block>
    <fo:block font-size="8pt" text-align="center" color="#AFA6A6">
      <xsl:value-of select="$strings//str[@xml:lang=$lang]/footer/disclaimer-2"/>
      <fo:basic-link external-destination="url('{$strings//str[@xml:lang=$lang]/footer/link}')" text-decoration="underline">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/footer/link-text"/>
      </fo:basic-link>
      <xsl:value-of select="$strings//str[@xml:lang=$lang]/footer/disclaimer-3"/>
      <fo:basic-link internal-destination="disclaimer-id" text-decoration="underline">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/footer/disclaimer"/>
      </fo:basic-link>
      <xsl:value-of select="$strings//str[@xml:lang=$lang]/footer/disclaimer-4"/>
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
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/summary/title"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Basics -->

  <xsl:template match="//basics/definition" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/basics/subsections/definition/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//basics/epidemiology" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/basics/subsections/epidemiology/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//basics/etiology" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/basics/subsections/aetiology/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//basics/pathophysiology" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/basics/subsections/pathophysiology/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//basics/classifications" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/basics/subsections/classification/title"/>
    </xsl:call-template>
  </xsl:template>

  <!-- END Basics -->

  <!-- Prevention -->

  <xsl:template match="//basics/prevention" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/prevention/subsections/primary/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//followup/recommendations/preventive-actions" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/prevention/subsections/secondary/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//diagnosis/screening" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/prevention/subsections/screening/title"/>
    </xsl:call-template>
  </xsl:template>

  <!-- END Prevention -->

  <!-- Diagnosis -->

  <xsl:template match="//basics/vignettes" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/case-history/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//diagnosis/approach" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/step-by-step/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//basics/risk-factors" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/risk-factors/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//diagnosis/diagnostic-factors" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/history/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//diagnosis/tests" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-tests/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//diagnosis/differentials" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/differential-diagnosis/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//diagnosis/diagnostic-criteria" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-criteria/title"/>
    </xsl:call-template>
  </xsl:template>

  <!-- END Diagnosis -->

  <!-- Treatment -->

  <xsl:template match="//treatment/approach" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/step-by-step/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//treatment/emerging-txs" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/emerging/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="treatment-details-overview-toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/title"/>
      <xsl:with-param name="hardcoded-id" select="'treatment-details-overview-id'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//treatment/timeframes" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-options/title"/>
    </xsl:call-template>
  </xsl:template>

  <!-- END Treatment -->

  <!-- Follow up -->

  <xsl:template match="//followup/complications" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/complications/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//followup/outlook" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/prognosis/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//followup/recommendations" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/recommendations/title"/>
    </xsl:call-template>
  </xsl:template>

  <!--END Follow up -->

  <!-- Guidelines -->

  <xsl:template match="//diagnosis/guidelines" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-guidelines/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="//treatment/guidelines" mode="toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-guidelines/title"/>
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
                <fo:block text-align="left" space-before="7pt" border-after-width="0.5pt" border-after-style="solid" border-color="#f0f0f0"
                  padding-bottom="4pt">
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
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt"
      id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/basics/subsections/definition/title"/>
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/basics/epidemiology">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/basics/subsections/epidemiology/title"/>
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/basics/etiology">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/basics/subsections/aetiology/title"/>
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/basics/pathophysiology">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/basics/subsections/pathophysiology/title"/>
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/basics/classifications">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt"
      id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/basics/subsections/classification/title"/>
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
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/prevention/subsections/primary/title"/>
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/followup/recommendations/preventive-actions">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/prevention/subsections/secondary/title"/>
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/diagnosis/screening">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/prevention/subsections/screening/title"/>
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
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" margin-bottom="6pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-after-width="3pt" border-after-style="solid" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/case-history/title"/>
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="../other-presentations"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/basics/vignettes/vignette">
    <xsl:variable name="v_position" select="count(preceding-sibling::vignette) + 1"/>
    <fo:block font-size="16pt" font-weight="bold" text-align="left" space-before="14pt" space-after="12pt" margin-left="14.173pt"
      keep-with-next.within-page="always">
      <fo:inline border-bottom-color="#333333" border-bottom-style="solid" border-bottom-width="0.5pt" padding-bottom="2pt">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/case-history/title"/>
        <xsl:value-of select="concat(' #', $v_position)"/>
      </fo:inline>
    </fo:block>
    <fo:block margin-left="14.173pt" line-height="15pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:apply-templates select="../other-presentations"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/basics/other-presentations">
    <fo:block font-size="16pt" font-weight="bold" text-align="left" space-before="14pt" space-after="12pt" margin-left="14.173pt"
      keep-with-next.within-page="always">
      <fo:inline border-bottom-color="#333333" border-bottom-style="solid" border-bottom-width="0.5pt" padding-bottom="2pt">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/case-history/other-presentations"/>
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
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-before="14pt" space-after="12pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/history/title"/>
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:if test="./factor[@key-factor='true']">
        <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" margin-left="14.173pt" margin-bottom="6pt"
          keep-with-next.within-page="always">
          <fo:inline border-bottom-color="#333333" border-bottom-style="solid" border-bottom-width="0.5pt" padding-bottom="2pt">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/history/key-factors"/>
          </fo:inline>
        </fo:block>
      </xsl:if>
      <xsl:apply-templates select="./factor[@key-factor='true' and @frequency='common']"/>
      <xsl:apply-templates select="./factor[@key-factor='true' and @frequency='uncommon']"/>
      <xsl:if test="./factor[@key-factor='false']">
        <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" margin-left="14.173pt"
          keep-with-next.within-page="always">
          <fo:inline border-bottom-color="#333333" border-bottom-style="solid" border-bottom-width="0.5pt" padding-bottom="2pt">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/history/other-factors"/>
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
      <xsl:choose>
        <xsl:when test="../@frequency = 'uncommon'">
          <xsl:variable name="freq" select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/history/uncommon"/>
          <xsl:value-of select="concat(' (',$freq,')')"/>
        </xsl:when>
        <xsl:when test="../@frequency = 'common'">
          <xsl:variable name="freq" select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/history/common"/>
          <xsl:value-of select="concat(' (',$freq,')')"/>
        </xsl:when>
      </xsl:choose>
    </fo:block>
    <xsl:if test="not(../detail)">
      <fo:list-block space-after="7pt">
        <fo:list-item provisional-distance-between-starts="1cm">
          <fo:list-item-label end-indent="label-end()">
            <fo:block text-align="right">&#x02022;</fo:block>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <fo:block>
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/history/is"/>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </xsl:if>
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
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/risk-factors/title"/>
      </fo:inline>
    </fo:block>
    <fo:block line-height="15pt">
      <xsl:if test="./risk-factor[@strength='strong']">
        <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline" start-indent="0cm"
          margin-left="14.173pt">
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/risk-factors/strong"/>
        </fo:block>
      </xsl:if>
      <xsl:apply-templates select="./risk-factor[@strength='strong']"/>
      <xsl:if test="./risk-factor[@strength='weak']">
        <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline" start-indent="0cm"
          margin-left="14.173pt">
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/risk-factors/weak"/>
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
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-tests/title"/>
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:if test="./test[@order='initial']">
        <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline" margin-left="14.173pt"
          keep-with-next.within-page="always">
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-tests/first"/>
        </fo:block>
        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="70%"/>
          <fo:table-column column-width="30%"/>
          <fo:table-header background-color="#2A6EBB" font-size="14pt" font-weight="bold" color="#FFFFFF">
            <fo:table-row space-after="10px">
              <fo:table-cell>
                <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
                  <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-tests/test"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
                  <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-tests/result"/>
                </fo:block>
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
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-tests/other"/>
        </fo:block>
        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="70%"/>
          <fo:table-column column-width="30%"/>
          <fo:table-header background-color="#2A6EBB" font-size="14pt" font-weight="bold" color="#FFFFFF">
            <fo:table-row space-after="10px">
              <fo:table-cell>
                <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
                  <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-tests/test"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
                  <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-tests/result"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <xsl:apply-templates select="./test[@order='subsequent']"/>
          </fo:table-body>
        </fo:table>
      </xsl:if>
      <xsl:if test="./test[@order='emerging']">
        <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline" margin-left="14.173pt"
          keep-with-next.within-page="always">
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-tests/emerging"/>
        </fo:block>
        <fo:table table-layout="fixed" width="100%">
          <fo:table-column column-width="70%"/>
          <fo:table-column column-width="30%"/>
          <fo:table-header background-color="#2A6EBB" font-size="14pt" font-weight="bold" color="#FFFFFF">
            <fo:table-row space-after="10px">
              <fo:table-cell>
                <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
                  <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-tests/test"/>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell>
                <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
                  <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-tests/result"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <xsl:apply-templates select="./test[@order='emerging']"/>
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
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/differential-diagnosis/title"/>
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
              <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/differential-diagnosis/condition"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/differential-diagnosis/signs"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/differential-diagnosis/tests"/>
              </fo:block>
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
    <fo:block font-family="{$title-font}" margin-bottom="6pt" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-criteria/title"/>
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
    <fo:block font-family="{$title-font}" margin-bottom="6pt" font-size="18pt" font-weight="bold" text-align="left" space-after="12pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/step-by-step/title"/>
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
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/step-by-step/title"/>
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
        <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" page-break-before="always"
          id="{generate-id()}">
          <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-options/title"/>
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
        <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
          keep-with-next.within-page="always" id="treatment-details-overview-id">
          <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/title"/>
          </fo:inline>
        </fo:block>
        <fo:block space-after="7pt">
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/drug-text"/>
          (
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/see"/>
          <fo:basic-link internal-destination="disclaimer-id" color="#2a6ebb">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/title"/>
          </fo:basic-link>
          )
        </fo:block>
        <fo:block>
          <xsl:apply-templates select="./timeframe"/>
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
                  (
                  <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/summary"/>
                  )
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <xsl:call-template name="timeframe-table-second-header"/>
            <xsl:apply-templates select="./child::node()"/>
          </fo:table-body>
        </fo:table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="timeframe/pt-groups/pt-group">
    <xsl:param name="full"/>
    <xsl:variable name="n_pgroup" select="count(../pt-group)"/>
    <xsl:variable name="pg_position" select="count(preceding-sibling::pt-group) + 1"/>
    <xsl:if test="name(./*[2]) = 'pt-groups'">
      <fo:table-row>
        <fo:table-cell>
          <fo:block font-weight="bold" margin-top="5pt" margin-left="14pt" margin-bottom="4pt">
            <xsl:value-of select="name"/>
          </fo:block>
        </fo:table-cell>
        <xsl:call-template name="empty-cell"/>
        <xsl:call-template name="empty-cell"/>
      </fo:table-row>
    </xsl:if>
    <xsl:apply-templates>
      <xsl:with-param name="full" select="$full"/>
    </xsl:apply-templates>
    <xsl:if test="$n_pgroup != 1 and $pg_position != $n_pgroup">
      <fo:table-row>
        <fo:table-cell number-columns-spanned="3">
          <fo:block border-bottom="2pt solid #2A6EBB" margin-top="10px" margin-bottom="10px">
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
    </xsl:if>
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

  <xsl:template match="timeframe/pt-groups/pt-group/pt-groups/pt-group/tx-options/tx-option">
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
            <xsl:when test="($tr_position != 1) and ($pt_position = $n_subgroups_tr)">
              <xsl:call-template name="empty-cell"/>
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
            <xsl:when test="($tr_position != 1) and ($pt_position = $n_subgroups_tr)">
              <xsl:call-template name="empty-cell"/>
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
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/acute"/>
        </xsl:when>
        <xsl:when test="@type='ongoing'">
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/ongoing"/>
        </xsl:when>
        <xsl:when test="@type='presumptive'">
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/presumptive"/>
        </xsl:when>
      </xsl:choose>
    </fo:block>
  </xsl:template>

  <xsl:template name="timeframe-table-second-header">
    <fo:table-row space-after="10px" background-color="#FFFFFF">
      <fo:table-cell text-align="left" background-color="#FFFFFF">
        <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt" color="#2A6EBB">
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/patient-group"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell background-color="#FFFFFF">
        <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt" color="#2A6EBB">
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/tx-line"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell background-color="#FFFFFF">
        <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt" color="#2A6EBB">
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/treatment"/>
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
    <fo:table-cell margin="0pt" background-color="white" background-image="url('../images/BP_PDF_treatment-detail-vertical_default.gif')"
      background-repeat="repeat-y" background-position-horizontal="20px">
      <fo:block-container>
        <fo:block font-weight="bold" margin-top="0pt" margin-left="0pt" margin-bottom="4pt">
          <fo:external-graphic src="url('../images/BP_PDF_treatment-detail-vertical-double-empty_default.gif')" border="2pt solid white"
            content-width="14pt" scaling="non-uniform"/>
          <xsl:value-of select="../../name"/>
        </fo:block>
      </fo:block-container>
    </fo:table-cell>
  </xsl:template>

  <xsl:template name="pt-subgroup-cell-first">
    <fo:table-cell margin="0pt" background-color="white" background-image="url('../images/BP_PDF_treatment-detail-vertical_default.gif')"
      background-repeat="repeat-y" background-position-horizontal="20px">
      <fo:block font-weight="bold" margin-top="5pt" margin-left="21px" margin-bottom="4pt">
        <fo:table>
          <fo:table-column column-width="20%"/>
          <fo:table-column column-width="80%"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell text-align="left">
                <fo:block>
                  <fo:external-graphic src="url('../images/BP_PDF_treatment-detail-sub_default.gif')"/>
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
    <fo:table-cell margin="0pt" background-color="white">
      <fo:block font-weight="bold" margin-top="0pt" margin-left="20px" margin-bottom="4pt">
        <fo:table>
          <fo:table-column column-width="20%"/>
          <fo:table-column column-width="80%"/>
          <fo:table-body>
            <fo:table-row>
              <fo:table-cell text-align="left">
                <fo:block>
                  <fo:block-container top="0pt" left="0pt">
                    <fo:block>
                      <fo:external-graphic src="url('../images/BP_PDF_treatment-detail-vertical-double_default.gif')"/>
                      <fo:external-graphic src="url('../images/BP_PDF_treatment-detail-sub_default.gif')"/>
                    </fo:block>
                  </fo:block-container>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell text-align="left">
                <fo:block margin-top="5pt">
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
    <fo:table-cell margin="0pt" background-color="white" background-image="url('../images/BP_PDF_treatment-detail-vertical_default.gif')"
      background-repeat="repeat-y" background-position-horizontal="20px">
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
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/first"/>
          </xsl:when>
          <xsl:when test="../@tx-line='2'">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/second"/>
          </xsl:when>
          <xsl:when test="../@tx-line='3'">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/third"/>
          </xsl:when>
          <xsl:when test="../@tx-line='4'">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/fourth"/>
          </xsl:when>
          <xsl:when test="../@tx-line='5'">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/fifth"/>
          </xsl:when>
          <xsl:when test="../@tx-line='6'">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/sixth"/>
          </xsl:when>
          <xsl:when test="../@tx-line='7'">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/seventh"/>
          </xsl:when>
          <xsl:when test="../@tx-line='8'">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/eigth"/>
          </xsl:when>
          <xsl:when test="../@tx-line='9'">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/ninth"/>
          </xsl:when>
          <xsl:when test="../@tx-line='10'">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/tenth"/>
          </xsl:when>
          <xsl:when test="../@tx-line='P'">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/plus"/>
          </xsl:when>
          <xsl:when test="../@tx-line='A'">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-details-overview/adjunct"/>
          </xsl:when>
        </xsl:choose>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template name="tx-type-cell-right-arrow">
    <fo:table-cell>
      <fo:block font-weight="bold" margin-top="5pt" margin-left="0pt" margin-bottom="4pt">
        <xsl:value-of select="./tx-type"/>
      </fo:block>
    </fo:table-cell>
  </xsl:template>

  <xsl:template name="tx-type-cell-down-arrow-full">
    <fo:table-cell>
      <fo:block font-weight="bold" margin-top="5pt" margin-left="0pt" margin-bottom="4pt">
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
    <fo:block>
      <fo:block font-weight="bold" margin-top="7pt" margin-left="3pt" margin-bottom="4pt" color="#2A6EBB" space-after="7pt">
        <xsl:choose>
          <xsl:when test="./@tier = 1">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-options/primary"/>
          </xsl:when>
          <xsl:when test="./@tier = 2">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-options/secondary"/>
          </xsl:when>
          <xsl:when test="./@tier = 3">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-options/tertiary"/>
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
    <fo:table table-layout="fixed" width="100%" padding="0pt" space-after="10pt" background-color="#E6E6E6">
      <fo:table-body>
        <xsl:apply-templates select="./components"/>
      </fo:table-body>
    </fo:table>
    <xsl:if test="count(following-sibling::regimen) != 0">
      <fo:block font-weight="bold" space-after="0pt" margin-left="3pt">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-options/cap-or"/>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tx-option/regimens/regimen/components/component">
    <fo:table-row padding="0pt">
      <fo:table-cell>
        <fo:block margin-left="7pt" margin-right="7pt">
          <fo:inline color="#2A6EBB">
            &#187;
            <xsl:value-of select="./name"/>
          </fo:inline>
          <xsl:if test="./details">
            <xsl:value-of select="': '"/>
          </xsl:if>
          <xsl:value-of select="./details"/>
          <fo:block>
            <xsl:value-of select="./comments"/>
          </fo:block>
          <xsl:variable name="and-sign" select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-options/and"/>
          <xsl:variable name="or-sign" select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-options/or"/>
          <xsl:variable name="andor-sign" select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-options/andor"/>
          <xsl:choose>
            <xsl:when test="./@modifier = 'and'">
              <fo:inline font-weight="bold" keep-together.within-line="always">
                <xsl:value-of select="concat(' -',$and-sign,'-')"/>
              </fo:inline>
            </xsl:when>
            <xsl:when test="./@modifier = 'or'">
              <fo:inline font-weight="bold" keep-together.within-line="always">
                <xsl:value-of select="concat(' -',$or-sign,'-')"/>
              </fo:inline>
            </xsl:when>
            <xsl:when test="./@modifier = 'and/or'">
              <fo:inline font-weight="bold" keep-together.within-line="always">
                <xsl:value-of select="concat(' -',$andor-sign,'-')"/>
              </fo:inline>
            </xsl:when>
          </xsl:choose>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
    <xsl:choose>
      <xsl:when test="./@modifier = 'AND'">
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-weight="bold" margin-top="3pt" margin-bottom="3pt" background-color="#A1A1A1">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-options/cap-and"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </xsl:when>
      <xsl:when test="./@modifier = 'AND/OR'">
        <fo:table-row>
          <fo:table-cell>
            <fo:block font-weight="bold" margin-top="3pt" margin-bottom="3pt" background-color="#A1A1A1">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-options/cap-andor"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="monograph-full/treatment/emerging-txs">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt" page-break-before="always"
      id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/emerging/title"/>
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
  
  <!-- Added to deal with <detail> element. Not in original. -->
  <xsl:template match="emerging-tx/detail">
    <fo:block font-size="11pt">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- END TREATMENT -->

  <!-- FOLLOW UP -->

  <xsl:template match="monograph-full/followup/recommendations">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/recommendations/title"/>
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
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/recommendations/monitoring"/>
      </fo:inline>
    </fo:block>
    <fo:block margin-left="14.173pt">
      <xsl:apply-templates select="./monitoring/child::node()"/>
    </fo:block>
  </xsl:template>

  <xsl:template name="followup-recommendations-patientinstructions">
    <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" margin-left="14.173pt" keep-with-next.within-page="always">
      <fo:inline border-bottom-color="#333333" border-bottom-style="solid" border-bottom-width="0.5pt" padding-bottom="2pt">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/recommendations/patient-instructions"/>
      </fo:inline>
    </fo:block>
    <fo:block margin-left="14.173pt">
      <xsl:apply-templates select="./patient-instructions/child::node()"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="monograph-full/followup/outlook">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="30pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/prognosis/title"/>
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-full/followup/complications">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/complications/title"/>
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
              <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/complications/title"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/complications/timeframe"/>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/complications/likelihood"/>
              </fo:block>
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
                  <xsl:choose>
                    <xsl:when test="./@timeframe = 'short term'">
                      <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/complications/short-term"/>
                    </xsl:when>
                    <xsl:when test="./@timeframe = 'long term'">
                      <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/complications/long-term"/>
                    </xsl:when>
                    <xsl:when test="./@timeframe = 'variable'">
                      <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/complications/variable"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="./@timeframe"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </fo:block>
              </fo:table-cell>
              <fo:table-cell border="solid" border-width="1pt" border-color="#b7cfde" background-color="#F9F9F9">
                <fo:block font-weight="bold" margin="5pt" text-align="center">
                  <xsl:choose>
                    <xsl:when test="./@likelihood = 'high'">
                      <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/complications/high"/>
                    </xsl:when>
                    <xsl:when test="./@likelihood = 'medium'">
                      <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/complications/medium"/>
                    </xsl:when>
                    <xsl:when test="./@likelihood = 'low'">
                      <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/follow-up/subsections/complications/low"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="./@likelihood"/>
                    </xsl:otherwise>
                  </xsl:choose>
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
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/diagnosis/subsections/diagnostic-guidelines/title"/>
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:if test="./guideline[@region='Europe']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Europe'"/>
          <xsl:with-param name="current_region_text" select="$strings//str[@xml:lang=$lang]/sections/guidelines/europe"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="(./guideline[@region='International']) or (./guideline[not(@region)])">
        <fo:table table-layout="fixed" width="100%" space-after="14pt">
          <fo:table-column column-width="100%"/>
          <fo:table-header background-color="#2A6EBB" font-size="14pt" font-weight="bold" color="#FFFFFF">
            <fo:table-row space-after="10px">
              <fo:table-cell>
                <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
                  <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/guidelines/international"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <xsl:apply-templates select="./guideline[@region='International']"/>
            <xsl:apply-templates select="./guideline[not(@region)]"/>
          </fo:table-body>
        </fo:table>
      </xsl:if>
      <xsl:if test="./guideline[@region='North America']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'North America'"/>
          <xsl:with-param name="current_region_text" select="$strings//str[@xml:lang=$lang]/sections/guidelines/north-america"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Latin America']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Latin America'"/>
          <xsl:with-param name="current_region_text" select="$strings//str[@xml:lang=$lang]/sections/guidelines/latin-america"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Asia']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Asia'"/>
          <xsl:with-param name="current_region_text" select="$strings//str[@xml:lang=$lang]/sections/guidelines/asia"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Africa']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Africa'"/>
          <xsl:with-param name="current_region_text" select="$strings//str[@xml:lang=$lang]/sections/guidelines/africa"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Oceania']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Oceania'"/>
          <xsl:with-param name="current_region_text" select="$strings//str[@xml:lang=$lang]/sections/guidelines/oceania"/>
        </xsl:call-template>
      </xsl:if>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template name="guidelines-per-region">
    <xsl:param name="current_region"/>
    <xsl:param name="current_region_text"/>
    <fo:table table-layout="fixed" width="100%" space-after="14pt">
      <fo:table-column column-width="100%"/>
      <fo:table-header background-color="#2A6EBB" font-size="14pt" font-weight="bold" color="#FFFFFF">
        <fo:table-row space-after="10px">
          <fo:table-cell>
            <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
              <xsl:value-of select="$current_region_text"/>
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
        <fo:block font-size="12pt" font-weight="bold" margin="5pt" color="#2A6EBB" margin-top="10pt" margin-bottom="7pt">
          <xsl:variable name="guideline-url" select="./url"/>
          <fo:basic-link external-destination="url({$guideline-url})" color="#2a6ebb">
            <xsl:value-of select="./title"/>
          </fo:basic-link>
        </fo:block>
        <fo:block margin="3pt" space-after="3pt" margin-bottom="0pt">
          <fo:table table-layout="fixed" width="100%">
            <fo:table-column column-width="70%"/>
            <fo:table-column column-width="30%"/>
            <fo:table-body>
              <fo:table-row space-after="0px">
                <fo:table-cell>
                  <fo:block>
                    <fo:inline font-weight="bold">
                      <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/guidelines/published-by"/>
                    </fo:inline>
                    <xsl:value-of select="./source"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell>
                  <fo:block>
                    <fo:inline font-weight="bold">
                      <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/guidelines/last-published"/>
                    </fo:inline>
                    <xsl:value-of select="./last-published"/>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-body>
          </fo:table>
        </fo:block>
        <xsl:if test="./summary/para[text() != '']">
          <fo:block margin="5pt" margin-bottom="7pt">
            <fo:inline font-weight="bold">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/guidelines/summary"/>
            </fo:inline>
            <xsl:value-of select="./summary"/>
          </fo:block>
        </xsl:if>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

  <xsl:template match="monograph-full/treatment/guidelines">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/treatment/subsections/treatment-guidelines/title"/>
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:if test="./guideline[@region='Europe']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Europe'"/>
          <xsl:with-param name="current_region_text" select="$strings//str[@xml:lang=$lang]/sections/guidelines/europe"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="(./guideline[@region='International']) or (./guideline[not(@region)])">
        <fo:table table-layout="fixed" width="100%" space-after="14pt">
          <fo:table-column column-width="100%"/>
          <fo:table-header background-color="#2A6EBB" font-size="14pt" font-weight="bold" color="#FFFFFF">
            <fo:table-row space-after="10px">
              <fo:table-cell>
                <fo:block font-weight="bold" margin-top="5pt" margin-left="3pt" margin-bottom="4pt">
                  <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/guidelines/international"/>
                </fo:block>
              </fo:table-cell>
            </fo:table-row>
          </fo:table-header>
          <fo:table-body>
            <xsl:apply-templates select="./guideline[@region='International']"/>
            <xsl:apply-templates select="./guideline[not(@region)]"/>
          </fo:table-body>
        </fo:table>
      </xsl:if>
      <xsl:if test="./guideline[@region='North America']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'North America'"/>
          <xsl:with-param name="current_region_text" select="$strings//str[@xml:lang=$lang]/sections/guidelines/north-america"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Latin America']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Latin America'"/>
          <xsl:with-param name="current_region_text" select="$strings//str[@xml:lang=$lang]/sections/guidelines/latin-america"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Asia']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Asia'"/>
          <xsl:with-param name="current_region_text" select="$strings//str[@xml:lang=$lang]/sections/guidelines/asia"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Africa']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Africa'"/>
          <xsl:with-param name="current_region_text" select="$strings//str[@xml:lang=$lang]/sections/guidelines/africa"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="./guideline[@region='Oceania']">
        <xsl:call-template name="guidelines-per-region">
          <xsl:with-param name="current_region" select="'Oceania'"/>
          <xsl:with-param name="current_region_text" select="$strings//str[@xml:lang=$lang]/sections/guidelines/oceania"/>
        </xsl:call-template>
      </xsl:if>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <!-- END GUIDELINES -->

  <!-- ONLINE RESOURCES -->

  <xsl:template match="monograph-full/online-references">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/online-resources/title"/>
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
        <fo:block border-width="0.25pt" border-after-style="solid" border-color="#f0f0f0">
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
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/evidence-scores/title"/>
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
          <xsl:apply-templates select="./comments"/>
          <xsl:choose>
            <xsl:when test="./@score = 'A'">
              <fo:block>
                <fo:inline font-weight="bold">
                  <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/evidence-scores/evidence-a"/>
                </fo:inline>
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/evidence-scores/evidence-a-text"/>
              </fo:block>
            </xsl:when>
            <xsl:when test="./@score = 'B'">
              <fo:block>
                <fo:inline font-weight="bold">
                  <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/evidence-scores/evidence-b"/>
                </fo:inline>
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/evidence-scores/evidence-b-text"/>
              </fo:block>
            </xsl:when>
            <xsl:when test="./@score = 'C'">
              <fo:block>
                <fo:inline font-weight="bold">
                  <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/evidence-scores/evidence-c"/>
                </fo:inline>
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/evidence-scores/evidence-c-text"/>
              </fo:block>
            </xsl:when>
          </xsl:choose>
          <xsl:if test="./option-link">
            <fo:block color="#2a6ebb" space-before="10px">
              <xsl:variable name="token-1" select="substring-before(./option-link/@target, '/')"/>
              <xsl:variable name="token-2"
                select="translate(substring-after(./option-link/@target, '/'), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
              <xsl:variable name="option-link-url"
                select="concat($strings//str[@xml:lang=$lang]/footer/link,'/best-practice/monograph/', /monograph-full/@dx-id, '/treatment/evidence/intervention/', $token-1, '/0/sr-', $token-1, '-', $token-2, '.html')"/>
              <fo:basic-link external-destination="url({$option-link-url})">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/evidence-scores/more-info"/>
              </fo:basic-link>
            </fo:block>
          </xsl:if>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- END EVIDENCE SCORES -->

  <!-- REFERENCES -->

  <xsl:template match="monograph-full/article-references">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/references/key-articles"/>
      </fo:inline>
    </fo:block>
    <fo:list-block padding="4pt" line-height="15pt">
      <xsl:for-each select="./reference[poc-citation/@key-article = 'true']">
        <xsl:call-template name="key-articles"/>
      </xsl:for-each>
    </fo:list-block>
    <fo:block space-after="14pt"/>
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/references/title"/>
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
          <xsl:if test="./poc-citation/fulltext-url">
            <xsl:value-of select="' '"/>
            <xsl:variable name="full-text-url" select="./poc-citation/fulltext-url"/>
            <fo:basic-link external-destination="url({$full-text-url})" color="#2a6ebb">
              <xsl:value-of select="concat(' ', $strings//str[@xml:lang=$lang]/sections/references/full-text, ' ')"/>
            </fo:basic-link>
          </xsl:if>
          <xsl:if test="./unique-id and ./unique-id/@source='medline'">
            <xsl:variable name="abstract-url" select="concat('http://www.ncbi.nlm.nih.gov/pubmed/', ./unique-id, '?tool=bestpractice.bmj.com')"/>
            <fo:basic-link external-destination="url({$abstract-url})" color="#2a6ebb">
              <xsl:value-of select="concat(' ', $strings//str[@xml:lang=$lang]/sections/references/abstract)"/>
            </fo:basic-link>
          </xsl:if>
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
        <fo:block id="{./@id}" border-width="0.25pt" border-after-style="solid" border-color="#f0f0f0" padding-bottom="6pt" margin-bottom="6pt">
          <xsl:value-of select="./poc-citation/citation"/>
          <xsl:if test="./poc-citation/fulltext-url">
            <xsl:value-of select="' '"/>
            <xsl:variable name="full-text-url" select="./poc-citation/fulltext-url"/>
            <fo:basic-link external-destination="url({$full-text-url})" color="#2a6ebb">
              <xsl:value-of select="concat(' ', $strings//str[@xml:lang=$lang]/sections/references/full-text, ' ')"/>
            </fo:basic-link>
          </xsl:if>
          <xsl:if test="./unique-id and ./unique-id/@source='medline'">
            <xsl:variable name="abstract-url" select="concat('http://www.ncbi.nlm.nih.gov/pubmed/', ./unique-id, '?tool=bestpractice.bmj.com')"/>
            <fo:basic-link external-destination="url({$abstract-url})" color="#2a6ebb">
              <xsl:value-of select="concat(' ', $strings//str[@xml:lang=$lang]/sections/references/abstract)"/>
            </fo:basic-link>
          </xsl:if>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <!-- END REFERENCES -->

  <!-- IMAGES -->

  <xsl:template match="monograph-full/figures">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/images/title"/>
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

      <fo:block font-style="italic" space-after="7pt" border-after-style="solid" border-after-width="0.5pt" border-after-color="#f0f0f0">
        <fo:inline>
          <xsl:value-of select="concat($strings//str[@xml:lang=$lang]/sections/images/figure, ./@id,': ')"/>
        </fo:inline>
        <xsl:value-of select="./caption"/>
      </fo:block>
      <fo:block font-style="italic" space-after="28pt" color="#A3A3A3">
        <xsl:value-of select="./source"/>
      </fo:block>
    </fo:block>
  </xsl:template>

  <!-- END IMAGES -->

  <!-- DISCLAIMER -->

  <xsl:template name="disclaimer-content">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always">
      <fo:inline border-bottom-style="solid" border-bottom-width="3pt" padding-bottom="4pt" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/title"/>
      </fo:inline>
    </fo:block>

    <fo:block font-size="10pt" text-align="left" space-after="10pt">
      <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/text-1"/>
    </fo:block>

    <fo:block font-size="10pt" text-align="left" space-after="10pt">
      <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/text-2"/>
    </fo:block>

    <fo:block font-size="10pt" text-align="left" space-after="10pt">
      <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/text-3"/>
    </fo:block>

    <xsl:if test="$strings//str[@xml:lang=$lang]/sections/disclaimer/table/link = 'true'">
      <fo:block font-size="10pt" text-align="left" space-after="10pt">
        <fo:basic-link external-destination="url('http://www1.bipm.org/jsp/en/ViewCGPMResolution.jsp?CGPM=22&amp;RES=10')" color="#2a6ebb">
          <xsl:value-of select="'http://www1.bipm.org/jsp/en/ViewCGPMResolution.jsp'"/>
        </fo:basic-link>
      </fo:block>
    </xsl:if>

    <xsl:if test="$strings//str[@xml:lang=$lang]/sections/disclaimer/table/link = 'true'">
      <fo:block space-after="10pt" page-break-inside="avoid">
        <fo:block margin-left="5.5cm">
          <fo:table border="1pt solid" space-after="7pt">
            <fo:table-header>
              <fo:table-row>
                <fo:table-cell border="1pt solid" padding="7pt" text-align="center" number-columns-spanned="2">
                  <fo:block>
                    <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/table/header"/>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-header>
            <fo:table-body>
              <fo:table-row>
                <fo:table-cell border="1pt solid" padding="7pt">
                  <fo:block>
                    <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/table/row1/col1"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="1pt solid" padding="7pt">
                  <fo:block>
                    <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/table/row1/col2"/>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
              <fo:table-row>
                <fo:table-cell border="1pt solid" padding="7pt">
                  <fo:block>
                    <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/table/row2/col1"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="1pt solid" padding="7pt">
                  <fo:block>
                    <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/table/row2/col2"/>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
              <fo:table-row>
                <fo:table-cell border="1pt solid" padding="7pt">
                  <fo:block>
                    <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/table/row3/col1"/>
                  </fo:block>
                </fo:table-cell>
                <fo:table-cell border="1pt solid" padding="7pt">
                  <fo:block>
                    <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/table/row3/col2"/>
                  </fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-body>
          </fo:table>
        </fo:block>
        <fo:block text-align="center" font-weight="bold">
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/table/description"/>
        </fo:block>
      </fo:block>
    </xsl:if>

    <fo:block font-size="10pt" text-align="left" space-after="10pt">
      <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/text-4"/>
    </fo:block>

    <fo:block font-size="10pt" text-align="left" space-after="10pt">
      <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/full-link-1"/>
      <fo:basic-link external-destination="url('http://www.bmj.com/company/legal-information/')" color="#2a6ebb">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/disclaimer/full-link-2"/>
      </fo:basic-link>
    </fo:block>
  </xsl:template>

  <!-- END DISCLAIMER -->

  <!-- LAST PAGE -->

  <xsl:template name="monograph-full-monograph-info-authors-author-acknowledgements">
    <xsl:param name="authors"/>
    <xsl:for-each select="$authors">
      <xsl:if test="./name = 'Acknowledgements'">
        <fo:table-row margin-left="10pt">
          <fo:table-cell margin-bottom="4pt">
            <fo:block margin-top="10pt" margin-left="10pt" font-style="normal">
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
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/last-page/disclosures"/>
              <xsl:apply-templates select="./disclosures/child::node()"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="monograph-full/monograph-info/authors/author">
    <xsl:if test="./name != 'Acknowledgements'">
      <fo:table-row space-after="10px">
        <fo:table-cell>
          <fo:block font-weight="bold" margin-top="10pt" margin-left="10pt" margin-bottom="4pt" border-after-style="solid"
            border-after-width="0.5pt" border-after-color="#b7cfde">
            <xsl:apply-templates select="./name"/>
            <xsl:value-of select="', '"/>
            <xsl:apply-templates select="./degree"/>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
      <fo:table-row>
        <fo:table-cell>
          <fo:block margin-left="10pt" font-style="normal">
            <xsl:for-each select="./title-affil/para/child::node()">
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
          <fo:block font-weight="normal" margin-left="10pt">
            <xsl:value-of select="$strings//str[@xml:lang=$lang]/last-page/disclosures"/>
            <xsl:apply-templates select="./disclosures/child::node()"/>
          </fo:block>
        </fo:table-cell>
      </fo:table-row>
    </xsl:if>
  </xsl:template>

  <xsl:template match="monograph-full/monograph-info/peer-reviewers/peer-reviewer">
    <fo:table-row space-after="10px">
      <fo:table-cell>
        <fo:block font-weight="bold" margin-top="10pt" margin-left="10pt" margin-bottom="4pt" border-after-style="solid" border-after-width="0.5pt"
          border-after-color="#b7cfde">
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
          <xsl:value-of select="$strings//str[@xml:lang=$lang]/last-page/disclosures"/>
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
          <xsl:value-of select="concat('[Fig-',./@target,']')"/>
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
    <fo:block font-family="{$title-font}" font-size="14pt" font-weight="bold" space-before="12pt" space-after="6pt" margin-left="14.173pt"
      keep-with-next.within-page="always">
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
      <fo:block space-after="7pt" border="1pt solid #b7cfde">
        <fo:external-graphic margin="0pt" content-width="760px" background-color="white" src="url('{$image}')"/>
      </fo:block>
      <fo:block font-style="italic" font-size="9pt" margin-left="10pt" margin-right="10pt">
        <xsl:value-of select="./caption"/>
      </fo:block>
      <fo:block font-style="italic" font-size="9pt" margin-left="10pt" margin-right="10pt" color="#A3A3A3" space-after="14pt">
        <xsl:value-of select="./source"/>
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template match="organism">
    <fo:inline font-style="italic">
      <xsl:value-of select="."/>
    </fo:inline>
  </xsl:template>

</xsl:stylesheet>

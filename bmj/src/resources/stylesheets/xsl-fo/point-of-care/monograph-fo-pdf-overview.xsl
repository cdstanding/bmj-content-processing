<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="../../xsl-lib/strings/bp-pdf-static-text.xsl"/>
  
  <xsl:param name="copyrightYear"/>
    <xsl:param name="default-lang"/>

    <xsl:variable name="lang">
        <xsl:choose>
            <xsl:when test="/monograph-overview/@lang">
                <xsl:value-of select="/monograph-overview/@lang"/>
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
        <xsl:value-of select="nevis"/>
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

      <fo:layout-master-set>

        <fo:simple-page-master master-name="first-page" margin-bottom="0.5cm" margin-left="0.5cm" margin-right="0.5cm"
          margin-top="0.5cm" page-height="29.7cm" page-width="21cm">
          <fo:region-body region-name="body" margin-bottom="0cm" margin-top="0cm" background-color="#2A6EBB"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="toc-page" margin-bottom="0cm" margin-left="0cm" margin-right="0cm" margin-top="0cm"
          page-height="29.7cm" page-width="21cm">
          <fo:region-body region-name="body" margin-left="0.76cm" margin-right="0.76cm" margin-bottom="0.7cm" margin-top="0.7cm"/>
          <fo:region-before region-name="toc-page-page-header" extent="0.75cm" background-color="#cbdde7"/>
          <fo:region-after region-name="toc-page-odd-footer" extent="0.75cm" background-color="#cbdde7"/>
          <fo:region-start region-name="toc-page-page-start" extent="0.75cm" background-color="#cbdde7"/>
          <fo:region-end region-name="toc-page-odd-page-end" extent="0.75cm" background-color="#cbdde7"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="even-page" margin-bottom="1cm" margin-left="0cm" margin-right="2cm" margin-top="0.5cm"
          page-height="29.7cm" page-width="21cm">
          <fo:region-body region-name="body" margin-bottom="2cm" margin-top="1cm" margin-left="2cm"/>
          <fo:region-before region-name="even-page-header" extent="1.5cm"/>
          <fo:region-after region-name="even-footer" extent="1.5cm"/>
          <fo:region-start region-name="even-page-start" extent="2cm"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="odd-page" margin-bottom="1cm" margin-left="2cm" margin-right="0cm" margin-top="0.5cm"
          page-height="29.7cm" page-width="21cm">
          <fo:region-body region-name="body" margin-bottom="2cm" margin-top="1cm" margin-right="2cm"/>
          <fo:region-before region-name="odd-page-header" extent="1.5cm"/>
          <fo:region-after region-name="odd-footer" extent="1.5cm"/>
          <fo:region-end region-name="odd-page-end" extent="2cm"/>
        </fo:simple-page-master>

        <fo:page-sequence-master master-name="content-introduction">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <fo:page-sequence-master master-name="content-conditions">
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

        <fo:page-sequence-master master-name="content-disclaimer">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="even-page"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="odd-page"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>

        <fo:simple-page-master master-name="last-page" margin-bottom="0.5cm" margin-left="0.5cm" margin-right="0.5cm"
          margin-top="0.5cm" page-height="29.7cm" page-width="21cm">
          <fo:region-body region-name="body" margin-bottom="0cm" margin-top="0cm" background-color="#FFFFFF"/>
        </fo:simple-page-master>

      </fo:layout-master-set>

      <fo:page-sequence master-reference="first-page">
        <fo:flow flow-name="body">
          <fo:block space-before="0.7cm" space-before.conditionality="retain" text-align="center" space-after="36pt" color="#FFFFFF">
            <fo:external-graphic content-width="17cm" src="url('../images/BP_PDF_BP_logo_White_on_blue_cropped_default.png')"/>
          </fo:block>
          <xsl:variable name="title-length" select="string-length(monograph-overview/monograph-info/title)"/>
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
            <xsl:apply-templates select="monograph-overview/monograph-info/title"/>
          </xsl:element>
          <fo:block-container absolute-position="absolute" top="10.7cm">
            <fo:block font-size="15pt" text-align="center" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/first-page/subtitle"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container absolute-position="absolute" top="12.1cm">
            <fo:block font-size="0pt" top="14cm" padding="0mm" margin="0mm" line-height="0mm">
              <fo:external-graphic padding="0mm" margin="0mm" content-width="20cm" height="15cm" content-height="scale-to-fit"
                scaling="non-uniform" background-color="white" src="url('../images/BP_PDF_Overview_cover_default.jpg')"/>
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
                        <xsl:apply-templates select="monograph-overview/monograph-info/last-updated"/>
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
              <fo:inline border-after-width="3.0pt" border-after-style="solid" border-color="#cbdde7" color="#333333" font-size="18pt"
                margin="14pt">
                <xsl:value-of select="$strings//str[@xml:lang=$lang]/toc/title"/>
              </fo:inline>
            </fo:block>

            <!--Introduction -->
            <xsl:call-template name="toc-main-section">
              <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/introduction/title"/>
              <xsl:with-param name="hardcoded-id" select="'introduction-id'"/>
            </xsl:call-template>
            <xsl:if test="monograph-overview/summary//section-header[text()='Background']">
              <xsl:call-template name="introduction-background-toc"/><!-- Background -->
            </xsl:if>
            <xsl:if test="monograph-overview/summary//section-header[text()='Pathophysiology']">
              <xsl:call-template name="introduction-pathophysiology-toc"/> <!-- Pathophysiology -->
            </xsl:if>
            <xsl:if test="monograph-overview/summary//section-header[text()='History']">
              <xsl:call-template name="introduction-history-toc"/><!-- History -->
            </xsl:if>
            <xsl:if test="monograph-overview/summary//section-header[text()='Evaluation']">
              <xsl:call-template name="introduction-evaluation-toc"/> <!-- Evaluation -->
            </xsl:if>

            <!--Conditions -->
            <xsl:if test="monograph-overview/disease-subtypes">
              <xsl:call-template name="toc-main-section">
                <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/conditions/title"/>
                <xsl:with-param name="hardcoded-id" select="'conditions-id'"/>
              </xsl:call-template>
            </xsl:if>
            
            <!-- Evidence scores -->
            <xsl:if test="monograph-overview/evidence-scores">
              <xsl:call-template name="toc-main-section">
                <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/evidence-scores/title"/>
                <xsl:with-param name="hardcoded-id" select="'evidence-scores-id'"/>
              </xsl:call-template>
            </xsl:if>

            <!-- References -->
            <xsl:if test="monograph-overview/article-references">
              <xsl:call-template name="toc-main-section">
                <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/references/title"/>
                <xsl:with-param name="hardcoded-id" select="'references-id'"/>
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

      <fo:page-sequence master-reference="content-introduction">

        <fo:static-content flow-name="even-page-header">
          <xsl:call-template name="even-header-contents-introduction"/>
        </fo:static-content>

        <fo:static-content flow-name="even-page-start">
          <fo:block-container reference-orientation="90" position="absolute" top="2mm" right="9mm">
            <fo:block text-align="right">
              <fo:external-graphic padding="-1mm" margin="0mm" content-width="7cm" background-color="white"
                src="url('../images/BP_PDF_tab_bottom_default.png')"/>
            </fo:block>
          </fo:block-container>
          <fo:block-container reference-orientation="90" position="absolute" top="2.2cm" left="0.4cm">
            <fo:block font-size="12pt" font-weight="bold" text-align="right" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/introduction/tab"/>
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
          <fo:block-container reference-orientation="270" position="absolute" top="2.2cm" right="4mm">
            <fo:block font-size="12pt" font-weight="bold" text-align="left" color="#FFFFFF">
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/introduction/tab"/>
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-header">
          <xsl:call-template name="odd-header-contents-introduction"/>
        </fo:static-content>

        <fo:static-content flow-name="even-footer">
          <xsl:call-template name="even-footer-contents"/>
        </fo:static-content>

        <fo:static-content flow-name="odd-footer">
          <xsl:call-template name="odd-footer-contents"/>
        </fo:static-content>

        <fo:flow flow-name="body">
          <fo:block id="introduction-id"/>
          <xsl:apply-templates select="monograph-overview/summary"/>
        </fo:flow>

      </fo:page-sequence>

      <fo:page-sequence master-reference="content-conditions">

        <fo:static-content flow-name="even-page-header">
          <xsl:call-template name="even-header-contents-conditions"/>
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
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/conditions/tab"/>
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
              <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/conditions/tab"/>
            </fo:block>
          </fo:block-container>
        </fo:static-content>

        <fo:static-content flow-name="odd-page-header">
          <xsl:call-template name="odd-header-contents-conditions"/>
        </fo:static-content>

        <fo:static-content flow-name="even-footer">
          <xsl:call-template name="even-footer-contents"/>
        </fo:static-content>

        <fo:static-content flow-name="odd-footer">
          <xsl:call-template name="odd-footer-contents"/>
        </fo:static-content>

        <fo:flow flow-name="body">
          <fo:block id="conditions-id"/>
          <xsl:apply-templates select="monograph-overview/disease-subtypes"/>
        </fo:flow>

      </fo:page-sequence>

      <xsl:if test="monograph-overview/evidence-scores">
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
            <xsl:apply-templates select="monograph-overview/evidence-scores"/>
          </fo:flow>
        </fo:page-sequence>
      </xsl:if>
      
      <xsl:if test="monograph-overview/article-references">
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
            <xsl:apply-templates select="monograph-overview/article-references"/>
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
                <xsl:apply-templates select="monograph-overview/monograph-info/authors/author"/>
                <xsl:if test="monograph-overview/monograph-info/authors/author/name = 'Acknowledgements'">
                  <fo:table-row space-after="10px">
                    <fo:table-cell>
                      <fo:block font-weight="bold" margin-top="18pt" margin-bottom="10pt" margin="0pt" font-size="15pt" color="#2A6EBB">
                        <xsl:value-of select="$strings//str[@xml:lang=$lang]/last-page/acknowledgements"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <xsl:call-template name="monograph-overview-monograph-info-authors-author-acknowledgements">
                    <xsl:with-param name="authors" select="monograph-overview/monograph-info/authors/author"/>
                  </xsl:call-template>
                </xsl:if>
                <xsl:if test="monograph-overview/monograph-info/peer-reviewers">
                  <fo:table-row space-after="10px">
                    <fo:table-cell>
                      <fo:block font-weight="bold" margin-top="18pt" margin-bottom="10pt" margin="0pt" font-size="15pt" color="#2A6EBB">
                        <xsl:value-of select="$strings//str[@xml:lang=$lang]/last-page/peer-reviewers"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                  <xsl:apply-templates select="monograph-overview/monograph-info/peer-reviewers/peer-reviewer"/>
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
    <fo:block>
      <fo:table table-layout="fixed" width="100%" border-bottom-width="1pt" border-bottom-style="solid" border-color="#cadce7">
        <fo:table-column column-width="60%"/>
        <fo:table-column column-width="40%"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell text-align="left" display-align="after" background-color="#FFFFFF">
              <fo:block font-size="10pt" font-weight="bold" color="#cadce7">
                <xsl:apply-templates select="monograph-overview/monograph-info/title"/>
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

  <xsl:template name="even-header-contents-introduction">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/introduction/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-introduction">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/introduction/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="even-header-contents-conditions">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/conditions/title"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="odd-header-contents-conditions">
    <xsl:call-template name="common-header">
      <xsl:with-param name="section" select="$strings//str[@xml:lang=$lang]/sections/conditions/title"/>
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
      <xsl:apply-templates select="monograph-overview/monograph-info/last-updated"/>
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

  <xsl:template match="monograph-overview/monograph-info/last-updated">
    <fo:inline>
      <xsl:value-of select="."/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="monograph-overview/monograph-info/title">
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

  <!-- Introduction -->

  <xsl:template name="introduction-background-toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/introduction/subsections/background/title"/>
      <xsl:with-param name="hardcoded-id" select="'background-id'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="introduction-pathophysiology-toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/introduction/subsections/pathophysiology/title"/>
      <xsl:with-param name="hardcoded-id" select="'pathophysiology-id'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="introduction-history-toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/introduction/subsections/history/title"/>
      <xsl:with-param name="hardcoded-id" select="'history-id'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="introduction-evaluation-toc">
    <xsl:call-template name="toc-main-subsection">
      <xsl:with-param name="section-name" select="$strings//str[@xml:lang=$lang]/sections/introduction/subsections/evaluation/title"/>
      <xsl:with-param name="hardcoded-id" select="'evaluation-id'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- END Introduction -->

  <!-- END TOC -->

  <!-- INTRODUCTION -->

  <xsl:template match="monograph-overview/summary">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-after-width="3pt" border-after-style="solid" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/introduction/title"/>
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <!-- Override the section headers to add the ids -->
  <xsl:template match="monograph-overview/summary//section-header[text()='Background']">
    <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline" start-indent="0cm"
      margin-left="0.5cm" keep-with-next.within-page="always" id="background-id">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="monograph-overview/summary//section-header[text()='Pathophysiology']">
    <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline" start-indent="0cm"
      margin-left="0.5cm" keep-with-next.within-page="always" id="pathophysiology-id">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="monograph-overview/summary//section-header[text()='History']">
    <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline" start-indent="0cm"
      margin-left="0.5cm" keep-with-next.within-page="always" id="history-id">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  <xsl:template match="monograph-overview/summary//section-header[text()='Evaluation']">
    <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline" start-indent="0cm"
      margin-left="0.5cm" keep-with-next.within-page="always" id="evaluation-id">
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>

  <!-- END INTRODUCTION -->

  <!-- CONDITIONS -->

  <xsl:template match="monograph-overview/disease-subtypes">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always">
      <fo:inline border-after-width="3pt" border-after-style="solid" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/conditions/title"/>
      </fo:inline>
    </fo:block>
    <fo:block>
      <xsl:apply-templates select="./subtype"/>
    </fo:block>
    <fo:block space-after="14pt"/>
  </xsl:template>

  <xsl:template match="monograph-overview/disease-subtypes/subtype">
    <fo:table table-layout="fixed" width="100%" border="0.5pt solid #b7cfde">
      <fo:table-column column-width="60%"/>
      <fo:table-header background-color="#F6F6F6" font-size="14pt" font-weight="bold">
        <fo:table-row space-after="10px" border="0.5pt solid #b7cfde">
          <fo:table-cell>
            <fo:block font-weight="bold" margin="5pt">
              <xsl:text>&#x25ca; </xsl:text>
              <xsl:value-of select="./name"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-header>
      <fo:table-body>
        <fo:table-row page-break-inside="avoid" font-size="10pt">
          <fo:table-cell>
            <fo:block margin="5pt">
              <xsl:variable name="monograph-url"
                select="concat($strings//str[@xml:lang=$lang]/footer/link,'/best-practice/monograph/',substring-before(./monograph-link/@target,'.'),'.html')"/>
              <fo:basic-link external-destination="url({$monograph-url})" color="#2a6ebb">
                <fo:inline color="#2A6EBB">
                  <xsl:text>&#187; </xsl:text>
                  <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/conditions/see-our"/>
                  <xsl:value-of select="./monograph-link"/>
                </fo:inline>
              </fo:basic-link>
            </fo:block>
            <fo:block margin="5pt">
              <xsl:apply-templates select="./detail"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </xsl:template>

  <!-- END CONDITIONS -->

  <!-- EVIDENCE SCORES -->

  <xsl:template match="monograph-overview/evidence-scores">
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

  <xsl:template match="monograph-overview/evidence-scores/evidence-score">
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
                select="concat($strings//str[@xml:lang=$lang]/footer/link,'/best-practice/monograph/', /monograph-overview/@dx-id, '/treatment/evidence/intervention/', $token-1, '/0/sr-', $token-1, '-', $token-2, '.html')"/>
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

  <xsl:template match="monograph-overview/article-references">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-after-width="3pt" border-after-style="solid" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/references/key-articles"/>
      </fo:inline>
    </fo:block>
    <fo:list-block padding="4pt">
      <xsl:for-each select="./reference[poc-citation/@key-article = 'true']">
        <xsl:call-template name="key-articles"/>
      </xsl:for-each>
    </fo:list-block>
    <fo:block space-after="14pt"/>
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt">
      <fo:inline border-after-width="3pt" border-after-style="solid" border-color="#b7cfde">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/references/title"/>
      </fo:inline>
    </fo:block>
    <fo:list-block padding="4pt">
      <xsl:apply-templates select="./reference"/>
    </fo:list-block>
  </xsl:template>

  <xsl:template name="key-articles">
    <fo:list-item provisional-distance-between-starts="1cm">
      <fo:list-item-label end-indent="label-end()">
        <fo:block>&#x02022;</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block border-bottom-width="0.25pt" border-bottom-style="solid" border-color="#AFA6A6" margin-bottom="7pt">
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

  <xsl:template match="monograph-overview/article-references/reference">
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
        <fo:block id="{./@id}" border-bottom-width="0.25pt" border-bottom-style="solid" border-color="#AFA6A6" margin-bottom="14pt">
          <xsl:value-of select="./poc-citation/citation"/>
          <xsl:if test="./poc-citation/fulltext-url">
            <xsl:value-of select="' '"/>
            <xsl:variable name="full-text-url" select="./poc-citation/fulltext-url"/>
            <fo:basic-link external-destination="url({$full-text-url})" color="#2a6ebb">
              <xsl:value-of select="concat(' ', $strings//str[@xml:lang=$lang]/sections/references/full-text)"/>
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

  <xsl:template match="monograph-overview/figures">
    <fo:block font-family="{$title-font}" font-size="18pt" font-weight="bold" text-align="left" space-after="14pt"
      keep-with-next.within-page="always" id="{generate-id()}">
      <fo:inline border-bottom-width="3pt" border-bottom-style="solid" border-color="#b7cfde" padding-bottom="4pt">
        <xsl:value-of select="$strings//str[@xml:lang=$lang]/sections/images/title"/>
      </fo:inline>
    </fo:block>
    <fo:block padding="4pt">
      <xsl:apply-templates select="./child::node()"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="figures/figure">
    <fo:block border-after-width="2pt" border-after-style="solid" border-color="b7cfde" space-after="14pt" id="f{@id}">
      <xsl:variable name="image" select="./image-link/@target"/>
      <fo:block text-align="center" space-after="14pt" border-style="solid" border-width="0.5pt" border-color="#f0f0f0" padding="6pt">
        <fo:external-graphic content-width="760px" background-color="white" src="url('{$image}')"/>
      </fo:block>
      <fo:block font-style="italic" space-after="7pt">
        <xsl:value-of select="concat($strings//str[@xml:lang=$lang]/sections/images/figure, ./@id,': ')"/>
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
      <fo:inline border-after-width="3pt" border-after-style="solid" border-color="#b7cfde">
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

  <xsl:template name="monograph-overview-monograph-info-authors-author-acknowledgements">
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

  <xsl:template match="monograph-overview/monograph-info/authors/author">
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

  <xsl:template match="monograph-overview/monograph-info/peer-reviewers/peer-reviewer">
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
    <fo:basic-link internal-destination="{@target}" color="#2a6ebb">
      <xsl:value-of select="concat('[',./@target,']')"/>
    </fo:basic-link>
  </xsl:template>

  <xsl:template match='evidence-score-link'>
    <fo:basic-link internal-destination="E{@target}" color="#2a6ebb">
      <xsl:value-of select="concat(./@target, '[',./@score,']', 'Evidence')"/>
    </fo:basic-link>
  </xsl:template>

  <xsl:template match="figure-link">
    <xsl:choose>
      <xsl:when test="./@inline='false'">
        <fo:basic-link internal-destination="f{@target}" color="#2a6ebb">
          <xsl:value-of select="concat('[Fig-',./@target,']')"/>
        </fo:basic-link>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="para">
    <xsl:choose>
      <xsl:when test="count(./child::node()) = 1">
        <fo:block space-after="10pt">
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
    <fo:block font-size="14pt" font-weight="bold" space-before="14pt" space-after="7pt" text-decoration="underline" start-indent="0cm"
      margin-left="0.5cm" keep-with-next.within-page="always">
      <xsl:apply-templates/>
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

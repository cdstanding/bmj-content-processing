<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:common="http://exslt.org/common">
  
  <xsl:import href="../libs/general-lib.xsl" />

  <!-- 
    PLEASE NOTE: This setions depends heavily on the page label definitions in the
    layout files. If anything changes there, (e.g. as we have for BP Dx) then this
    here also needs to change.. 
  -->
  <xsl:variable name="image-backlinks">
    <!-- Standard (full) monographs -->
    <uri prefix="monograph-full/basics/classifications" page-label="basics/classification">Classification</uri>
    <uri prefix="monograph-full/basics/definition" page-label="basics/definition">Definition</uri>
    <uri prefix="monograph-full/basics/epidemiology" page-label="basics/epidemiology">Epidemiology</uri>
    <uri prefix="monograph-full/basics/etiology" page-label="basics/aetiology">Aetiology</uri>
    <uri prefix="monograph-full/basics/other-presentations" page-label="diagnosis/case-history">Case history</uri>
    <uri prefix="monograph-full/basics/pathophysiology" page-label="basics/pathophysiology">Pathophysiology</uri>
    <uri prefix="monograph-full/basics/prevention" page-label="prevention/primary">Primary prevention</uri>
    <uri prefix="monograph-full/basics/risk-factors" page-label="diagnosis/history-and-examination">Risk factors</uri>
    <uri prefix="monograph-full/basics/vignettes" page-label="diagnosis/case-history">Case history</uri>
    <uri prefix="monograph-full/diagnosis/approach" page-label="diagnosis/step-by-step">Diagnosis step-by-step</uri>
    <uri prefix="monograph-full/diagnosis/diagnostic-criteria" page-label="diagnosis/criteria">Diagnostic criteria</uri>
    <uri prefix="monograph-full/diagnosis/diagnostic-factors" page-label="diagnosis/history-and-examination">Diagnostic factors</uri>
    <uri prefix="monograph-full/diagnosis/differentials" page-label="diagnosis/differential">Differential diagnosis</uri>
    <uri prefix="monograph-full/diagnosis/screening" page-label="prevention/screening">Screening</uri>
    <uri prefix="monograph-full/diagnosis/tests" page-label="diagnosis/tests">Tests</uri>
    <uri prefix="monograph-full/followup/complications" page-label="follow-up/complications">Complications</uri>
    <uri prefix="monograph-full/followup/outlook" page-label="follow-up/prognosis">Prognosis</uri>
    <uri prefix="monograph-full/followup/recommendations/monitoring" page-label="follow-up/recommendations">Recommendations</uri>
    <uri prefix="monograph-full/followup/reccomendations/patient-instructions" page-label="follow-up/recommendations">Recommendations</uri>
    <uri prefix="monograph-full/followup/recommendations/preventive-actions" page-label="prevention/secondary">Secondary prevention</uri>
    <uri prefix="monograph-full/treatment/approach" page-label="treatment/step-by-step">Treatment step-by-step</uri>
    <uri prefix="monograph-full/treatment/emerging-txs" page-label="treatment/emerging">Emerging treatments</uri>
    <uri prefix="monograph-full/treatment/timeframes" page-label="treatment/details">Treatment details</uri>
   
    <!-- Assessment (eval) monographs: -->
    <uri prefix="monograph-eval/ddx-etiology" page-label="overview/aetiology">Aetiology</uri>
    <uri prefix="monograph-eval/diagnostic-approach" page-label="diagnosis/step-by-step">Diagnosis step-by-step</uri>
    <uri prefix="monograph-eval/differentials" page-label="diagnosis/differential-diagnosis">Differential diagnosis</uri>
    <uri prefix="monograph-eval/overview" page-label="overview/summary">Summary</uri>
    <uri prefix="monograph-eval/urgent-considerations" page-label="emergencies/urgent-considerations">Urgent considerations</uri>

    <!-- Generic monographs -->
    <uri prefix="monograph-generic/sections" page-label="summary/overview">Overview</uri>
    
    <!-- Overview monographs -->
    <uri prefix="monograph-overview/disease-subtypes" page-label="overview/conditions">Conditions</uri>
    
  </xsl:variable>
  
  <!-- This template just gets you the page label from the backlink URI -->
  <xsl:template name="back-link-page-label-template">
    <xsl:param name="backlink-uri"/>
    <xsl:copy-of select="(common:node-set($image-backlinks)//uri[contains($backlink-uri, @prefix)])[1]"/>
  </xsl:template>
  
  <!-- This template gives you a marked up <a href> to the appropriate page 
       NOTE: the parameter is the page label, so you need to fetch this first -->
  <xsl:template name="back-link-href-template">
    <xsl:param name="backlink"/>
        
    <xsl:choose>
      
      <xsl:when test="not($backlink)">
        <xsl:element name="span">
          <xsl:attribute name="class">unavailable-back-link</xsl:attribute>
        </xsl:element>
        <xsl:apply-templates select="$backlink"/>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:call-template name="basic-path"/>
            <xsl:value-of select="concat('/', $backlink/@page-label, '.html')"/> 
          </xsl:attribute>
          
          <xsl:apply-templates select="$backlink"/>
          
        </xsl:element>
      </xsl:otherwise>
      
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

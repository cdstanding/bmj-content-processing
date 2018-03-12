<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:oak="http://schema.bmj.com/delivery/oak"
  xmlns:common="http://exslt.org/common">
  
  <xsl:import href="../libs/general-lib.xsl" />
    
  <!--  GENERIC STYLING FOR HANDLING EVIDENCE SCORE DISPLAY -->
    
  <xsl:output method="html" omit-xml-declaration="yes" />
  
  <!--
      Constants for the upper-case and lower-case alphabets. 
      These are used when converting from upper-case to lower-case.
  -->
  <xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
  
  <!-- request context path -->
  <xsl:param name="ctxPath" />
  
  <!-- Monograph paramters -->
  <xsl:param name="monographTitle" />
  <xsl:param name="monographId" />
  
  <xsl:variable name="EvidenceScoreDescriptions">
    <evidence-score-levels>
      <description score="A">
        <xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.evidence-score-lib.evidence-score-descriptions-a</xsl:with-param>
		</xsl:call-template>     
      </description>
      <description score="B">
        <xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.evidence-score-lib.evidence-score-descriptions-b</xsl:with-param>
		</xsl:call-template>           
      </description>
      <description score="C">
        <xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.evidence-score-lib.evidence-score-descriptions-c</xsl:with-param>
		</xsl:call-template>           
      </description>
    </evidence-score-levels>
  </xsl:variable>
  
  <xsl:template name="evidence-score-description">
    <xsl:param name="score"/>
    <xsl:apply-templates select="common:node-set($EvidenceScoreDescriptions)//description[@score=$score]"/>
  </xsl:template>
  
  <xsl:template name="evidence-score-level">
    <xsl:choose>
      <xsl:when test="@score='A'">
        <p><strong>
	        <xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence-score-lib.evidence-level-a</xsl:with-param>
			</xsl:call-template></strong><br/>
	        <xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence-score-lib.evidence-score-descriptions-a</xsl:with-param>
			</xsl:call-template>
		</p>
      </xsl:when>
      <xsl:when test="@score='B'">
        <p><strong>
	        <xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence-score-lib.evidence-level-b</xsl:with-param>
			</xsl:call-template></strong><br/>
	        <xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence-score-lib.evidence-score-descriptions-b</xsl:with-param>
			</xsl:call-template>
		</p>
      </xsl:when>
      <xsl:when test="@score='C'">
        <p><strong>
	        <xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence-score-lib.evidence-level-c</xsl:with-param>
			</xsl:call-template></strong><br/>
	        <xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence-score-lib.evidence-score-descriptions-c</xsl:with-param>
			</xsl:call-template>
		</p>
      </xsl:when>
      <xsl:otherwise />
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="comments">
    <p class="content">
      <xsl:apply-templates />
    </p>
  </xsl:template>
  
  <xsl:template match="option-link">
    <xsl:variable name="srId" select="substring-before(@target, '/')"/>
    <xsl:variable name="intId" select="translate(substring-after(@target, '/'), $upper, $lower)"/>
    <a tabindex="45">
      <xsl:attribute name="href">
        <xsl:call-template name="basic-path" />
        <xsl:value-of select="'/treatment/evidence/intervention/'" />
        <xsl:value-of select="$srId" />
        <xsl:value-of select="'/0/sr-'" />
        <xsl:value-of select="$srId" />
        <xsl:value-of select="'-'" />
        <xsl:value-of select="$intId" />
        <xsl:value-of select="'.html'" />        
      </xsl:attribute>
      <xsl:call-template name="translate">
		<xsl:with-param name="messagekey">body.evidence-score-lib.more-info</xsl:with-param>
 	  </xsl:call-template>      
    </a>
  </xsl:template>
    
</xsl:stylesheet>
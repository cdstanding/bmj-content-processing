<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:common="http://exslt.org/common">
  
  <xsl:import href="../libs/general-lib.xsl" />

  <xsl:variable name="CEEfficacyList">
    <efficacies>
      <efficacy id="beneficial" icon="icon-beneficial.gif">
  		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.evidence.efficacy-list.beneficial</xsl:with-param>
		</xsl:call-template>            
      </efficacy>
      <efficacy id="likely-to-be-beneficial" icon="icon-likelybeneficial.gif">
  		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.evidence.efficacy-list.likely-to-be-beneficial</xsl:with-param>
		</xsl:call-template>                  
      </efficacy>
      <efficacy id="trade-off-between-benefits-and-harms" icon="icon-tradeoff.gif">
  		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.evidence.efficacy-list.trade-off-between-benefits-and-harms</xsl:with-param>
		</xsl:call-template>                  
      </efficacy>
      <efficacy id="unknown-effectiveness" icon="icon-unknowneffectiveness.gif">
  		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.evidence.efficacy-list.unknown-effectiveness</xsl:with-param>
		</xsl:call-template>                  
      </efficacy>
      <efficacy id="unlikely-to-be-beneficial" icon="icon-unlikelybeneficial.gif">
  		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.evidence.efficacy-list.unlikely-to-be-beneficial</xsl:with-param>
		</xsl:call-template>                  
      </efficacy>
      <efficacy id="likely-to-be-ineffective-or-harmful" icon="icon-ineffharmful.gif">
  		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.evidence.efficacy-list.likely-to-be-ineffective-or-harmful</xsl:with-param>
		</xsl:call-template>                        
      </efficacy>
    </efficacies>
  </xsl:variable>
  
  <xsl:template name="efficacy-name">
    <xsl:param name="id"/>
    <xsl:apply-templates select="common:node-set($CEEfficacyList)//efficacy[@id=$id]"/>
  </xsl:template>
  
  <xsl:template name="efficacy-icon">
    <xsl:param name="id"/>
    <xsl:value-of select="common:node-set($CEEfficacyList)//efficacy[@id=$id]/@icon"/>
  </xsl:template>
    
</xsl:stylesheet>

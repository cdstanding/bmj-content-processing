<?xml version="1.0"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xi="http://www.w3.org/2001/XInclude" 
  version="2.0">

  <xsl:output 
    method="xml" 
    version="1.0" 
    encoding="UTF-8" 
    indent="yes"
  />
  
  <xsl:include href="xinclude.xsl"/>
  
  <xsl:template match="/*">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@* | node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="notes[parent::monograph-full]">
    <!-- do nothing -->
  </xsl:template>
  
  <xsl:template match="notes[parent::monograph-overview]">
    <!-- do nothing -->
  </xsl:template>
  
  <xsl:template match="notes[parent::monograph-generic]">
    <!-- do nothing -->
  </xsl:template>
  
  <xsl:template match="notes[parent::monograph-eval]">
    <!-- do nothing -->
  </xsl:template>
  
  <xsl:template match="processing-instruction()[contains(name(), 'serna-redline')] | pi-comment">
    <xsl:element name="fail-on-annotation">
      <xsl:attribute name="value" select="string('true')"/>
    </xsl:element>
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@* | node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
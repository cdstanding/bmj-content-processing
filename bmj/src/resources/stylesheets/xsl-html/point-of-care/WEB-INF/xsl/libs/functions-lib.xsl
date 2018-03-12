<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:oak="http://schema.bmj.com/delivery/oak">

  <xsl:output method="html" omit-xml-declaration="yes" />

  <!-- Truncation rules follow instructions from Jon, agreed over a very long process
      with Jeremy, Esther et al... do not change them arbitrarily! -->
  <xsl:template name="truncate">
    <xsl:param name="stringToTruncate"/>
    <xsl:param name="maxLength" select="65"/> <!--  defaults to 65 -->
    <xsl:param name="lengthToTruncateTo" select="45"/> <!--  defaults to 45 -->
    <xsl:choose>
      <xsl:when test="string-length($stringToTruncate) > $maxLength">
        <xsl:value-of select="substring($stringToTruncate, 1, $lengthToTruncateTo)"/>...
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$stringToTruncate"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
 
  <xsl:template name="to-upper">
    <xsl:param name="toconvert"/>
    <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>   
    <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:value-of select="translate($toconvert,$lcletters,$ucletters)"/>
  </xsl:template> 
  
  <xsl:template name="to-lower">
    <xsl:param name="toconvert"/>
    <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>   
    <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:value-of select="translate($toconvert,$ucletters,$lcletters)"/>
  </xsl:template> 
</xsl:stylesheet>

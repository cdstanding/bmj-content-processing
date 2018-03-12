<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:bmj="http://www.bmjgroup.com/XML/Schema"
  version="2.0">
  
  <xsl:output
    method="text"
    encoding="utf-8" />
  
  <!--
    Attempts to match a name element for the given locale code,
    and return it as l:name where l is a single letter locale.
  -->
  <xsl:function name="bmj:locale-match" as="xs:string*">
    <xsl:param name="context" as="element()" />
    <xsl:param name="locale-code" as="xs:string" />
    <xsl:param name="output-code" as="xs:string" />
    
    <xsl:for-each select="$context/official_name[starts-with(@scheme, $locale-code)][string-length(normalize-space(text())) gt 0]">
      <xsl:value-of select="concat($output-code, ':', normalize-space(text()))" />
    </xsl:for-each>
  </xsl:function>
  
  <!-- Selects names for schemes starting with a given id -->
  <xsl:key name="name-by-scheme" match="official_name" use="replace(@scheme, 'M$', '')" />
  
  
  <xsl:template match="/chapters">
    <xsl:message>
      Starting, <xsl:value-of select="count(monograph)" /> drugs in list
    </xsl:message>
    
    <xsl:apply-templates select="monograph" />

    <xsl:message>
      Finished processing!
    </xsl:message>
  </xsl:template>
  
  <!-- Match all drugs with British names and convert into a much simpler output. -->
  <xsl:template match="monograph">
    <xsl:message>mart-id: <xsl:value-of select="normalize-space(@id)" /></xsl:message>

    <!-- Build list of items to return for each drug -->
    <xsl:variable name="oi" as="xs:string*">
      <xsl:value-of select="@id" />
      
      <xsl:for-each select="heading">
        <xsl:sequence select="concat('h:', normalize-space(text()))" />
      </xsl:for-each>
      
      <xsl:sequence select="bmj:locale-match(., 'BAN', 'b')" />
      <xsl:sequence select="bmj:locale-match(., 'USAN', 'u')" />
      <xsl:sequence select="bmj:locale-match(., 'rINN', 'r')" />
      <xsl:sequence select="bmj:locale-match(., 'USP', 'p')" />
    </xsl:variable>
    
    <!-- Join list with | and print line -->
    <xsl:value-of select="string-join(for $x in $oi return normalize-space($x), '|')" />
    <xsl:text>&#10;</xsl:text>
  </xsl:template>
  
  <!-- Override default behaviour of outputting text nodes -->
  <xsl:template match="text()" />
  
</xsl:stylesheet>

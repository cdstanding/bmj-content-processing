<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0">

    <!--
        custom systematic-review to pmc nlm xml format character map 
        to resolve known old character entity issues
    -->
    <xsl:character-map name="pmc-custom-character-map">
        <xsl:output-character character="&#134;" string="†"/>
        <xsl:output-character character="&#147;" string="&quot;"/>
        <xsl:output-character character="&#148;" string="&quot;"/> 
        <xsl:output-character character="&#150;" string="–"/>
        <xsl:output-character character="" string="–"/>
    </xsl:character-map>
    
</xsl:stylesheet>
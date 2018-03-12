<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0">
    
    <!-- see for more info http://www.render.net/lists/xep-support/4259.html -->
    <xsl:character-map name="custom-map-renderx">
        <xsl:output-character character="≥" string="greater-than or equal to"/>
        <xsl:output-character character="≤" string="less-than or equal to"/>
    </xsl:character-map>
    
</xsl:stylesheet>
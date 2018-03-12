<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0">
    
    <!-- see for more info http://www.render.net/lists/xep-support/4259.html -->
    
    <xsl:character-map name="custom-map-letterpart">
        
        <!-- 
            map NO-BREAK SPACE character (&#160; / &#xA0;) 
            to THIN SPACE decimal character entity (&#8201; / &#x2009;) 
        -->
        <xsl:output-character character=" " string="&amp;#8201;"/>
        
    </xsl:character-map>
    
</xsl:stylesheet>
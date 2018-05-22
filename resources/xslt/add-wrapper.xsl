<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:template match="*">
            <graphics>
                <xsl:for-each select="graphic">
                <graphic><xsl:value-of select="text()"/></graphic>
                </xsl:for-each>
            </graphics>
    </xsl:template>
    
    
</xsl:stylesheet>
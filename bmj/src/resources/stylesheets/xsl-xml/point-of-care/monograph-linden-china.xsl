<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	version="2.0">
	

	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"/>
		
	<xsl:param name="language"/>

	<xsl:template match="node()|@*">
        <xsl:copy>
          <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>        
 	</xsl:template>	
 	
    <xsl:template match="monograph-info/title">          
    	<xsl:variable name="the-title" select="./text()"/>
        <xsl:element name="title">
        	<xsl:if test="$language = 'zh-cn'">
        		<xsl:attribute name="alternate" select="'value'" />
        	</xsl:if>	
            <xsl:value-of select="$the-title" />
        </xsl:element>      
    </xsl:template>	
    
    <xsl:template match="monograph-info/topic-synonyms/synonym">          
    	<xsl:variable name="the-synonym" select="./text()"/>
        <xsl:element name="synonym">
        	<xsl:if test="$language = 'zh-cn'">
        		<xsl:attribute name="alternate" select="'value'" />
        	</xsl:if>	
        	<xsl:attribute name="displayable" select="@displayable" />
            <xsl:value-of select="$the-synonym" />
        </xsl:element>      
    </xsl:template>	
    
</xsl:stylesheet>

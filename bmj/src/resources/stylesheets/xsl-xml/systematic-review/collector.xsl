<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:oak="http://schema.bmj.com/delivery/oak" 
	xmlns:ce="http://schema.bmj.com/delivery/oak-ce" 
	version="2.0">
	
	<xsl:output method="text" indent="no" encoding="UTF-8" omit-xml-declaration="yes" standalone="no"/>

	<xsl:param name="ce-id"/>
	<xsl:param name="doc-status"/>
	<xsl:param name="xmlstore-url"/>
	<xsl:strip-space elements="*"/>
	
	<xsl:template match="/">
		<xsl:text>guid:bmj:clinical-evidence:systematic-review:</xsl:text><xsl:value-of select="$ce-id"/><xsl:text>:en-gb</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>url:http://clinicalevidence.bmj.com/x/systematic-review/</xsl:text><xsl:value-of select="$ce-id"/><xsl:text>/overview.html</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>publication-date:</xsl:text><xsl:value-of select="./*:section/*:metadata/*:key[@ce:name='publication-date']/@value"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>publication:CE</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>content-type:text/plain</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>status:</xsl:text>
		<xsl:choose>
			<xsl:when test="$doc-status = ''">
				<xsl:text>LIVE</xsl:text>		
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$doc-status"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>article_type:systematic-review</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>rawdata-url:</xsl:text><xsl:value-of select="$xmlstore-url"/><xsl:text>/getDocument.html?id=</xsl:text><xsl:value-of select="$ce-id"/><xsl:text>%26db=BMJK%26library=CE/OAK/en-gb/systematic-review</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>title:</xsl:text><xsl:value-of select="./*:section/*:title"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="*">
		<xsl:apply-templates/>
		<!-- it the node has content make a new line -->
		<xsl:if test="text()[normalize-space()!='']"><xsl:text>&#10;</xsl:text></xsl:if>
	</xsl:template>    


	<!-- do nothing -->
	<xsl:template match="*:p[starts-with(., 'None.')]">
		
	</xsl:template>    
	
	<!-- do nothing -->
	<xsl:template match="*:li[starts-with(., 'For GRADE evaluation of')]">
		
	</xsl:template>    

	<!-- do nothing -->
	<xsl:template match="*:b[starts-with(., 'For GRADE evaluation of')]">
		
	</xsl:template>    
	
	<!-- do nothing -->
	<xsl:template match="*:title|*:metadata|*:person-group|*:gloss|*:references|*:table|*:section[@class='disclaimer']|*:section[@class='comparison-set']|*:section[@class='reference-notes']|*:section[@class='substantive-change-set']|*:section[@class='methods']">
		
	</xsl:template>    
	
</xsl:stylesheet>

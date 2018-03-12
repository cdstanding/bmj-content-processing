<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	version="2.0">
	
	<xsl:output method="text" indent="no" encoding="UTF-8" omit-xml-declaration="yes" standalone="no"/>
	
	<xsl:param name="lang"/>
	<xsl:param name="id"/>

	<xsl:param name="date-updated-iso"/>
	<xsl:param name="todays-date-iso"/>
	<xsl:param name="xmlstore-url"/>
	<xsl:param name="doc-status"/>
	
	<xsl:strip-space elements="*"/>
	
	<!-- 
		urn:bmj:patient-summary:article:1234:en-gb
		urn:bmj:patient-topic:article:1234:en-gb
		urn:bmj:elective-surgery:article:1234:en-gb
		urn:bmj:patient-news:article:1234:en-gb
		
		
		http://bestpractice.bmj.com/best-practice/pdf/patient-summaries/en-gb/531448.pdf
		http://besthealth.bmj.com/x/topic/392845/essentials.html
		http://besthealth.bmj.com/x/operations/514463/essentials.html
		http://besthealth.bmj.com/x/news/669937/news-item.html
	-->
	
	<xsl:template match="/">
		<xsl:variable name="article-type" select="/article/@article-type"/>
		<xsl:text>guid:bmj:</xsl:text><xsl:value-of select="$article-type"/><xsl:text>:article:</xsl:text><xsl:value-of select="$id"/><xsl:text>:</xsl:text><xsl:value-of select="$lang"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:choose>
			<xsl:when test="$article-type = 'patient-summary'">
				<xsl:text>url:http://bestpractice.bmj.com/best-practice/pdf/patient-summaries/</xsl:text><xsl:value-of select="$lang"/><xsl:text>/</xsl:text><xsl:value-of select="$id"/><xsl:text>.pdf</xsl:text>				
				<xsl:text>&#10;</xsl:text>
				<xsl:text>rawdata-url:</xsl:text><xsl:value-of select="$xmlstore-url"/><xsl:text>/getDocument.html?id=</xsl:text><xsl:value-of select="$id"/><xsl:text>%26db=BMJK%26library=BESTHEALTH/SYCAMORE/en-gb/summary</xsl:text>
			</xsl:when>
			<xsl:when test="$article-type = 'patient-topic'">
				<xsl:text>url:http://besthealth.bmj.com/x/topic/</xsl:text><xsl:value-of select="$id"/><xsl:text>/essentials.html</xsl:text>
				<xsl:text>&#10;</xsl:text>
				<xsl:text>rawdata-url:</xsl:text><xsl:value-of select="$xmlstore-url"/><xsl:text>/getDocument.html?id=</xsl:text><xsl:value-of select="$id"/><xsl:text>%26db=BMJK%26library=BESTHEALTH/SYCAMORE/en-gb/topic</xsl:text>
			</xsl:when>
			<xsl:when test="$article-type = 'elective-surgery'">
				<xsl:text>url:http://besthealth.bmj.com/x/operations/</xsl:text><xsl:value-of select="$id"/><xsl:text>/essentials.html</xsl:text>
				<xsl:text>&#10;</xsl:text>
				<xsl:text>rawdata-url:</xsl:text><xsl:value-of select="$xmlstore-url"/><xsl:text>/getDocument.html?id=</xsl:text><xsl:value-of select="$id"/><xsl:text>%26db=BMJK%26library=BESTHEALTH/SYCAMORE/en-gb/operations</xsl:text>
			</xsl:when>
			<xsl:when test="$article-type = 'patient-news'">
				<xsl:text>url:http://besthealth.bmj.com/x/news/</xsl:text><xsl:value-of select="$id"/><xsl:text>/news-item.html</xsl:text>
				<xsl:text>&#10;</xsl:text>
				<xsl:text>rawdata-url:</xsl:text><xsl:value-of select="$xmlstore-url"/><xsl:text>/getDocument.html?id=</xsl:text><xsl:value-of select="$id"/><xsl:text>%26db=BMJK%26library=BESTHEALTH/SYCAMORE/en-gb/news</xsl:text>
			</xsl:when>
		</xsl:choose>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>publication-date:</xsl:text>
		<xsl:choose>
			<xsl:when test="$date-updated-iso != ''">
				<xsl:value-of select="$date-updated-iso"/>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$todays-date-iso"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>publication:BH</xsl:text>
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
		<xsl:text>article_type:</xsl:text><xsl:value-of select="$article-type"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>title:</xsl:text><xsl:value-of select="./article/front/article-meta/title-group/article-title"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:apply-templates/>
		<!-- it the node has content make a new line -->
		<xsl:if test="text()[normalize-space()!='']"><xsl:text>&#10;</xsl:text></xsl:if>
	</xsl:template>    
	
	<xsl:template match="front|article-references|article-glossaries|article-figures">
		<!-- do nothing -->
	</xsl:template>    
	
</xsl:stylesheet>

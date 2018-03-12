<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	version="2.0">
	
	<xsl:output method="text" indent="no" encoding="UTF-8" omit-xml-declaration="yes" standalone="no"/>

	<xsl:strip-space elements="*"/>
	
	<xsl:param name="metadata-demographic"/>
	<xsl:param name="doc-status"/>
	<xsl:param name="xmlstore-url"/>
	
	<xsl:param name="metadata-demographic-doc">
		<xsl:choose>
			<xsl:when test="string-length(normalize-space($metadata-demographic))!=0">
				<xsl:copy-of select="document(translate($metadata-demographic,'\','/'))"/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:param>
	
	<xsl:param name="article-id" select="/*/@dx-id"/>
	
	<!-- 
		urn:bmj:best-practice:monograph-full:1:en-gb
		urn:bmj:best-practice:monograph-eval:XXX:en-gb
		urn:bmj:best-practice:monograph-overview:ZZZ:en-gb
		urn:bmj:best-practice:monograph-generic:YYY:en-gb
	-->
	
	<xsl:template match="/">
		<xsl:variable name="file-type" select="/node()/name()"/>
		<xsl:text>guid:bmj:best-practice:</xsl:text><xsl:value-of select="$file-type"/><xsl:text>:</xsl:text><xsl:value-of select="./node()/@dx-id"/><xsl:text>:en-gb</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>url:http://bestpractice.bmj.com/best-practice/monograph/</xsl:text><xsl:value-of select="./node()/@dx-id"/><xsl:text>.html</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>publication-date:</xsl:text>
		<xsl:choose>
			<xsl:when test="./node()/monograph-info/last-updated/@iso">
				<xsl:value-of select="./node()/monograph-info/last-updated/@iso"/>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="./node()/monograph-info/export-date/@iso"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>publication:BP</xsl:text>
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
		<xsl:text>article_type:</xsl:text><xsl:value-of select="$file-type"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>rawdata-url:</xsl:text><xsl:value-of select="$xmlstore-url"/><xsl:text>/rest/document/rowan/</xsl:text><xsl:value-of select="./node()/@dx-id"/><xsl:text>?locale=en-gb</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>title:</xsl:text><xsl:value-of select="./node()/monograph-info/title"/>
		<xsl:text>&#10;</xsl:text>
		
		<xsl:choose>
			<xsl:when test="$metadata-demographic-doc//mapping[@id=$article-id and count(element()) &gt; 0]">
					
					<xsl:for-each select="$metadata-demographic-doc//mapping[@id=$article-id and count(element()) &gt; 0]">
							
							<xsl:for-each select="element()/@*">

								<xsl:text>demographic-</xsl:text><xsl:value-of select="name()"/><xsl:text>:</xsl:text><xsl:value-of select="."/>
								<xsl:text>&#10;</xsl:text>
								
							</xsl:for-each>
						
					</xsl:for-each>
				
			</xsl:when>
		</xsl:choose>
		
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="*">
		<xsl:apply-templates/>
		<!-- it the node has content make a new line -->
		<xsl:if test="text()[normalize-space()!='']"><xsl:text>&#10;</xsl:text></xsl:if>
	</xsl:template>    

	<xsl:template match="monograph-info|article-references|online-references|guidelines|figures|combined-references">
		<!-- do nothing -->
	</xsl:template>    
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:html="http://www.w3.org/HTML/1998/html4"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal"
	exclude-result-prefixes="html uci">

	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8"
		omit-xml-declaration="no" 
		indent="no"/>

	<!-- 
		remove space
		remove unwanted styles
	-->

	<!-- ignore uci:style information from top of iloop raw xml -->
	<xsl:template match="uci:style">
		<!-- do nothing -->
	</xsl:template>
	
	<xsl:template match="uci:inline[@uci:lang and count(@*)=1]">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- not working: ignore colour diffStyle (if it's the only local diffStyle ) --> 
	<xsl:template match="uci:inline[@uci:diffStyle[starts-with(., 'color: ') and count(tokenize(., ';'))=1] and count(@*)=1]">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="uci:endtarget">
		<!-- do nothing -->
	</xsl:template>

	<xsl:template match="uci:gentext">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>

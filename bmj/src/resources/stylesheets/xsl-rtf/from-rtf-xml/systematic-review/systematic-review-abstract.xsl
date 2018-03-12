<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	exclude-result-prefixes="uci xsi">

	<xsl:output
		method="xml"
		version="1.0"
		encoding="UTF-8"
		indent="yes"
		omit-xml-declaration="yes"/>

	<xsl:include href="../../../generic-params.xsl"/>
	
	<xsl:template match="/">
		
		<!--<xsl:comment select="//uci:par[contains(translate(., $upper, $lower), 'word count:')]"/>-->
		
		<xsl:element name="abstract">
<!--			<xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">abstract.xsd</xsl:attribute>
-->			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="uci:par[contains(translate(., $upper, $lower), 'introduction:')]">
		<xsl:element name="intro">
			<!--<xsl:value-of select="substring-after(., ': ')"/>-->
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<!--<xsl:template match="uci:par[contains(translate(., $upper, $lower), 'methods:')]">
		<xsl:element name="methods">
		<xsl:value-of select="substring-after(., ': ')"/>
		</xsl:element>
		</xsl:template>-->
	
	<xsl:template match="uci:par[contains(translate(., $upper, $lower), ' objectives:') or contains(translate(., $upper, $lower), ' outcomes:')]">
		<xsl:element name="methods">
			<!--<xsl:value-of select="substring-after(., ': ')"/>-->
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<!--<xsl:template match="uci:par[contains(translate(., $upper, $lower), 'searched:')]">
		<xsl:element name="search">
			<xsl:value-of select="substring-after(., ': ')"/>
		</xsl:element>
	</xsl:template>-->
	
	<xsl:template match="uci:par[contains(translate(., $upper, $lower), 'results:')]">
		<xsl:element name="results">
			<!--<xsl:value-of select="substring-after(., ': ')"/>-->
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="uci:par[contains(translate(., $upper, $lower), 'conclusions:')]">
		<xsl:element name="conclusions">
			<!--<xsl:value-of select="substring-after(., ': ')"/>-->
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="uci:par">
		<!--  do nothing -->
	</xsl:template>
	
	<xsl:template match="uci:inline">
		<xsl:apply-templates select="." mode="super"/>
	</xsl:template>
	
	<xsl:template match="uci:inline" mode="super">
		<xsl:choose>
			<xsl:when test="contains(@uci:diffStyle, 'super')">
				<xsl:element name="sup">
					<xsl:apply-templates select="." mode="sub"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="sub"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="uci:inline" mode="sub">
		<xsl:choose>
			<xsl:when test="contains(@uci:diffStyle, 'sub')">
				<xsl:element name="sub">
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="process-text">
		<xsl:param name="str"/>
		<xsl:choose>
			<xsl:when test="contains(translate($str, $upper, $lower),'introduction:')">
				<xsl:value-of select="substring-after($str,'INTRODUCTION: ')"/>
				<!--<xsl:call-template name="process-text">
					<xsl:with-param name="str" select="substring-after(translate($str, $upper, $lower),'introduction: ')"/>
				</xsl:call-template>-->
			</xsl:when>
			<xsl:when test="contains(translate($str, $upper, $lower),'objectives:')">
				<xsl:value-of select="substring-after($str,'OBJECTIVES: ')"/>
				<!--<xsl:call-template name="process-text">
					<xsl:with-param name="str" select="substring-after(translate($str, $upper, $lower),'objectives: ')"/>
				</xsl:call-template>-->
			</xsl:when>
			<xsl:when test="contains(translate($str, $upper, $lower),'results:')">
				<xsl:value-of select="substring-after($str,'RESULTS: ')"/>
				<!--<xsl:call-template name="process-text">
					<xsl:with-param name="str" select="substring-after(translate($str, $upper, $lower),'results: ')"/>
				</xsl:call-template>-->
			</xsl:when>
			<xsl:when test="contains(translate($str, $upper, $lower),'conclusions:')">
				<xsl:value-of select="substring-after($str,'CONCLUSIONS: ')"/>
				<!--<xsl:call-template name="process-text">
					<xsl:with-param name="str" select="substring-after(translate($str, $upper, $lower),'conclusions: ')"/>
				</xsl:call-template>-->
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="text()">
		<xsl:call-template name="process-text">
			<xsl:with-param select="." name="str"/>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>

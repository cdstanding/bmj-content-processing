<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/HTML/1998/html4"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal">

	<xsl:template match="html:table">
		<xsl:element name="table" use-attribute-sets="">
			<xsl:attribute name="width">100%</xsl:attribute>
			<xsl:attribute name="border">1</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="html:thead">
		<xsl:element name="thead" use-attribute-sets="">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="html:tbody">
		<xsl:element name="tbody" use-attribute-sets="">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="html:tr">
		<xsl:element name="tr" use-attribute-sets="">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="html:th">
		<xsl:element name="th" use-attribute-sets="">
			<xsl:attribute name="colspan" select="@uci:colspan"/>
			<xsl:attribute name="align">left</xsl:attribute>
			<xsl:attribute name="width">1*</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="html:td">
		<xsl:choose>
			<xsl:when test="ancestor::html:tr/ancestor::html:tbody">
				<xsl:element name="td">
					<xsl:attribute name="colspan" select="@uci:colspan"/>
					<xsl:attribute name="align">left</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="th">
					<xsl:attribute name="colspan" select="@uci:colspan"/>
					<xsl:attribute name="align">left</xsl:attribute>
					<xsl:attribute name="width">1*</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	
	xmlns:oak="http://schema.bmj.com/delivery/oak"
	xmlns:ce="http://schema.bmj.com/delivery/oak-ce"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	
	version="2.0">
	
	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"  />
	
	<!--
		# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
		2nd-pass transformation to simply remove oak xmlns references from 1st hackberry transformation
		# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
	-->  
	
	<xsl:template match="/">
		<xsl:apply-templates select="node()"/>
	</xsl:template>
	
	<!-- oak specif tags we know about to remove xmlns -->
	<xsl:template match="*:section | *:title | *:metadata | *:key | *:p">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@* | node()" exclude-result-prefixes="oak" />
		</xsl:element>
	</xsl:template>
	
	<!-- <link target="1703-tg" type="table"> -->
	<xsl:template match="link[@type='table' and contains(@target, '-t')]">
		<xsl:element name="{name()}">
			<xsl:attribute name="type" select="string('table')" />
			<xsl:attribute name="target" select="translate(@target, '-t', '_T')" />
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<!-- <table-data id="1703-tg" media="web print" grade="true"> -->
	<xsl:template match="table-data[contains(@id, '-t')]">
		<xsl:element name="{name()}">
			<xsl:attribute name="id" select="translate(@id, '-t', '_T')" />
			<xsl:attribute name="media" select="@media" />
			<xsl:attribute name="grade" select="@grade" />
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<!-- remove unused @ce:oen attributes for oak xml nested inside hackberry xml -->
	<xsl:template match="@ce:oen" />

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" />
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>

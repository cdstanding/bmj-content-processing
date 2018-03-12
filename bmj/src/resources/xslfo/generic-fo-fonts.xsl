<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	xmlns:xse="http://www.syntext.com/Extensions/XSLT-1.0" 
	exclude-result-prefixes="xi xsi cals"
	version="2.0">
	
	<xsl:param name="body.font.family">Helvetica</xsl:param>
	<xsl:param name="title.font.family">Helvetica</xsl:param>
	<xsl:param name="dingbat.font.family">Times</xsl:param>
	<xsl:param name="sans.font.family">Arial</xsl:param>
	<xsl:param name="serif.font.family">Times</xsl:param>
	<xsl:param name="monospace.font.family">Courier</xsl:param>
	
	<!-- font-size setup -->
	<xsl:param name="body.font.master" xse:type="numeric">9</xsl:param> 
	<xsl:param name="body.font.size" select="concat($body.font.master,'pt')"/>
	<xsl:param name="tiny.font.size" select="concat(0.66 * $body.font.master,'pt')"/>
	<xsl:param name="small.font.size" select="concat(0.83 * $body.font.master,'pt')"/>
	<xsl:param name="large.font.size" select="concat(1.33 * $body.font.master,'pt')"/>
	<xsl:param name="huge.font.size" select="concat(2 * $body.font.master,'pt')"/>
	
</xsl:stylesheet>

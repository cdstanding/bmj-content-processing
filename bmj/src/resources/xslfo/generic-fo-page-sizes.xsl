<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	exclude-result-prefixes="xi xsi cals"
	version="2.0">

	<xsl:param name="page.height">
		<xsl:choose>
			<xsl:when test="$page.orientation = 'portrait'">
				<xsl:value-of select="$page.height.portrait"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$page.width.portrait"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

	<xsl:param name="page.height.portrait">
		<xsl:choose>
			<xsl:when test="$paper.type = 'ce-handbook'">225mm</xsl:when>
			<xsl:when test="$paper.type = 'A4landscape'">210mm</xsl:when>
			<xsl:when test="$paper.type = 'USletter'">11in</xsl:when>
			<xsl:when test="$paper.type = 'USlandscape'">8.5in</xsl:when>
			<xsl:when test="$paper.type = '4A0'">2378mm</xsl:when>
			<xsl:when test="$paper.type = '2A0'">1682mm</xsl:when>
			<xsl:when test="$paper.type = 'A0'">1189mm</xsl:when>
			<xsl:when test="$paper.type = 'A1'">841mm</xsl:when>
			<xsl:when test="$paper.type = 'A2'">594mm</xsl:when>
			<xsl:when test="$paper.type = 'A3'">420mm</xsl:when>
			<xsl:when test="$paper.type = 'A4'">297mm</xsl:when>
			<xsl:when test="$paper.type = 'A5'">210mm</xsl:when>
			<xsl:when test="$paper.type = 'A6'">148mm</xsl:when>
			<xsl:when test="$paper.type = 'A7'">105mm</xsl:when>
			<xsl:when test="$paper.type = 'A8'">74mm</xsl:when>
			<xsl:when test="$paper.type = 'A9'">52mm</xsl:when>
			<xsl:when test="$paper.type = 'A10'">37mm</xsl:when>
			<xsl:when test="$paper.type = 'B0'">1414mm</xsl:when>
			<xsl:when test="$paper.type = 'B1'">1000mm</xsl:when>
			<xsl:when test="$paper.type = 'B2'">707mm</xsl:when>
			<xsl:when test="$paper.type = 'B3'">500mm</xsl:when>
			<xsl:when test="$paper.type = 'B4'">353mm</xsl:when>
			<xsl:when test="$paper.type = 'B5'">250mm</xsl:when>
			<xsl:when test="$paper.type = 'B6'">176mm</xsl:when>
			<xsl:when test="$paper.type = 'B7'">125mm</xsl:when>
			<xsl:when test="$paper.type = 'B8'">88mm</xsl:when>
			<xsl:when test="$paper.type = 'B9'">62mm</xsl:when>
			<xsl:when test="$paper.type = 'B10'">44mm</xsl:when>
			<xsl:when test="$paper.type = 'C0'">1297mm</xsl:when>
			<xsl:when test="$paper.type = 'C1'">917mm</xsl:when>
			<xsl:when test="$paper.type = 'C2'">648mm</xsl:when>
			<xsl:when test="$paper.type = 'C3'">458mm</xsl:when>
			<xsl:when test="$paper.type = 'C4'">324mm</xsl:when>
			<xsl:when test="$paper.type = 'C5'">229mm</xsl:when>
			<xsl:when test="$paper.type = 'C6'">162mm</xsl:when>
			<xsl:when test="$paper.type = 'C7'">114mm</xsl:when>
			<xsl:when test="$paper.type = 'C8'">81mm</xsl:when>
			<xsl:when test="$paper.type = 'C9'">57mm</xsl:when>
			<xsl:when test="$paper.type = 'C10'">40mm</xsl:when>
			<xsl:otherwise>11in</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

	<xsl:param name="page.width">
		<xsl:choose>
			<xsl:when test="$page.orientation = 'portrait'">
				<xsl:value-of select="$page.width.portrait"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$page.height.portrait"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

	<xsl:param name="page.width.portrait">
		<xsl:choose>
			<xsl:when test="$paper.type = 'ce-handbook'">140mm</xsl:when>
			<xsl:when test="$paper.type = 'USletter'">8.5in</xsl:when>
			<xsl:when test="$paper.type = '4A0'">1682mm</xsl:when>
			<xsl:when test="$paper.type = '2A0'">1189mm</xsl:when>
			<xsl:when test="$paper.type = 'A0'">841mm</xsl:when>
			<xsl:when test="$paper.type = 'A1'">594mm</xsl:when>
			<xsl:when test="$paper.type = 'A2'">420mm</xsl:when>
			<xsl:when test="$paper.type = 'A3'">297mm</xsl:when>
			<xsl:when test="$paper.type = 'A4'">210mm</xsl:when>
			<xsl:when test="$paper.type = 'A5'">148mm</xsl:when>
			<xsl:when test="$paper.type = 'A6'">105mm</xsl:when>
			<xsl:when test="$paper.type = 'A7'">74mm</xsl:when>
			<xsl:when test="$paper.type = 'A8'">52mm</xsl:when>
			<xsl:when test="$paper.type = 'A9'">37mm</xsl:when>
			<xsl:when test="$paper.type = 'A10'">26mm</xsl:when>
			<xsl:when test="$paper.type = 'B0'">1000mm</xsl:when>
			<xsl:when test="$paper.type = 'B1'">707mm</xsl:when>
			<xsl:when test="$paper.type = 'B2'">500mm</xsl:when>
			<xsl:when test="$paper.type = 'B3'">353mm</xsl:when>
			<xsl:when test="$paper.type = 'B4'">250mm</xsl:when>
			<xsl:when test="$paper.type = 'B5'">176mm</xsl:when>
			<xsl:when test="$paper.type = 'B6'">125mm</xsl:when>
			<xsl:when test="$paper.type = 'B7'">88mm</xsl:when>
			<xsl:when test="$paper.type = 'B8'">62mm</xsl:when>
			<xsl:when test="$paper.type = 'B9'">44mm</xsl:when>
			<xsl:when test="$paper.type = 'B10'">31mm</xsl:when>
			<xsl:when test="$paper.type = 'C0'">917mm</xsl:when>
			<xsl:when test="$paper.type = 'C1'">648mm</xsl:when>
			<xsl:when test="$paper.type = 'C2'">458mm</xsl:when>
			<xsl:when test="$paper.type = 'C3'">324mm</xsl:when>
			<xsl:when test="$paper.type = 'C4'">229mm</xsl:when>
			<xsl:when test="$paper.type = 'C5'">162mm</xsl:when>
			<xsl:when test="$paper.type = 'C6'">114mm</xsl:when>
			<xsl:when test="$paper.type = 'C7'">81mm</xsl:when>
			<xsl:when test="$paper.type = 'C8'">57mm</xsl:when>
			<xsl:when test="$paper.type = 'C9'">40mm</xsl:when>
			<xsl:when test="$paper.type = 'C10'">28mm</xsl:when>
			<xsl:otherwise>8.5in</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

</xsl:stylesheet>
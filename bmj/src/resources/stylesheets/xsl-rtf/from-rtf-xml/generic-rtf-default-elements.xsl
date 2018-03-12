<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal">
	
	<!--<xsl:template match="uci:par[parent::node()[name()='html:td']]">
		<xsl:apply-templates/>
		<xsl:if test="following-sibling::element()[name()='uci:par']">
			<xsl:text> </xsl:text>
			<xsl:element name="br"/>
		</xsl:if>
		</xsl:template>-->
	
	<xsl:template match="uci:par">
		<xsl:apply-templates/>
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
					<xsl:apply-templates select="." mode="bold"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="bold"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="uci:inline" mode="bold">
		<xsl:choose>
			<xsl:when test="contains(@uci:diffStyle, 'bold')">
				<xsl:element name="strong">
					<xsl:apply-templates select="." mode="italics"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="italics"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="uci:inline" mode="italics">
		<xsl:choose>
			<xsl:when test="contains(@uci:diffStyle, 'italic')">
				<xsl:element name="em">
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>

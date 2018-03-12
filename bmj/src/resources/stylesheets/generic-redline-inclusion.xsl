<?xml version="1.0"?>

<xsl:stylesheet 
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output 
		method="xml" 
		encoding="UTF-8"
		name="xml-format"/>
	
	<xsl:param name="systematic-review-xml-input"/>
		
	<xsl:template match="bmjk-review-plan-link">
		<!-- <bmjk-review-plan-link target="../bmjk-review-plans/brp-bronchiolitis-0308.xml"/> -->
		<xsl:variable name="linked-doc-path">
			<xsl:choose>
				<xsl:when test="contains(@target, '.xml')">
					<xsl:value-of select="$systematic-review-xml-input"/>
					<xsl:value-of select="substring-after(@target, '../')"/>
				</xsl:when>
				<xsl:when test="contains(@href, '.xml')">
					<xsl:value-of select="$systematic-review-xml-input"/>
					<xsl:value-of select="substring-after(@href, '../')"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- do nothing -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="linked-doc">
			<xsl:apply-templates select="document($linked-doc-path)"/>
		</xsl:variable>
		<xsl:result-document href="translate($linked-doc-path, '.xml', '.tmp')" format="xml-format">
			<xsl:value-of select="$linked-doc"/>
		</xsl:result-document>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
		
	<xsl:template match="processing-instruction()[contains(name(), 'serna-redline')]">
		<xsl:choose>
			<!-- redline-start-insert -->
			<xsl:when test="name()='serna-redline-start' and contains(., '1000')">
				<xsl:text disable-output-escaping="yes">&lt;pi-redline type="insert"&gt;</xsl:text>
			</xsl:when>
			<!-- redline-start-delete -->
			<xsl:when test="name()='serna-redline-start' and contains(., '400')">
				<xsl:text disable-output-escaping="yes">&lt;pi-redline type="delete"&gt;</xsl:text>
			</xsl:when>
			<!-- redline-end -->
			<xsl:when test="name()='serna-redline-end'">
				<xsl:text disable-output-escaping="yes">&lt;/pi-redline&gt;</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>	

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>

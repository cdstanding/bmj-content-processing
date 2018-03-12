<?xml version="1.0"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xi="http://www.w3.org/2001/XInclude">

	<xsl:output 
		method="xml" 
		encoding="UTF-8" 
		indent="yes" 
		omit-xml-declaration="no"/>

	<xsl:param name="lang"/>
	<xsl:param name="media"/>
	<xsl:param name="date"/>
	<xsl:param name="process-stream"/>
	
	<xsl:include href="../../generic-params.xsl"/>
	<xsl:include href="../../systematic-review-params.xsl"/>

	<xsl:variable name="bmjk-review-plan" select="document(/systematic-review/info/bmjk-review-plan-link/@target)/*"/>
	
	<xsl:template match="/">
		
		<xsl:element name="sr-makefile-segment">
			
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">
				<xsl:text>../../../../schemas/bmjk-systematic-review-makefile-segment.xsd</xsl:text>
			</xsl:attribute>
			
			<xsl:attribute name="id" select="substring-after(/systematic-review/@id, '_')"/>
			
			<xsl:attribute name="pubdate">
				<xsl:choose>
					<xsl:when 
						test="
						translate($process-stream, $upper, $lower) = 'new'
						or translate($process-stream, $upper, $lower) = 'standard update'
						or translate($process-stream, $upper, $lower) = 'new question / option'
						or translate($process-stream, $upper, $lower) = 'nne'
						">
						<xsl:value-of select="$date"/>
					</xsl:when>
					<xsl:when test="translate($process-stream, $upper, $lower) = 'error correction'">
						<xsl:value-of select="$date"/>
						<!--<xsl:value-of select="/systematic-review/@pubdate"/> or from previous makefile-segment -->
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$date"/>
						<!--<xsl:value-of select="/systematic-review/@pubdate"/> or from previous makefile-segment -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:attribute name="pubstatus">
				<xsl:choose>
					<xsl:when test="translate($process-stream, $upper, $lower) = 'new'">
						<xsl:text>new</xsl:text>
					</xsl:when>
					<xsl:when test="translate($process-stream, $upper, $lower) = 'archive'">
						<xsl:text>pulled</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>update</xsl:text>
						<!--<xsl:value-of select="/systematic-review/@pubstatus"/> or from previous makefile-segment -->
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:attribute name="band">
				<xsl:variable name="option-count" select="count(/systematic-review//xi:include[contains(@href, 'option')])"/>
				<xsl:choose>
					<xsl:when test="$option-count &lt; 10">
						<xsl:text>A</xsl:text>
					</xsl:when>
					<xsl:when test="$option-count &lt; 20">
						<xsl:text>B</xsl:text>
					</xsl:when>
					<xsl:when test="$option-count &gt;= 20">
						<xsl:text>C</xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:attribute>

			<xsl:element name="title">
				<xsl:value-of select="/systematic-review/info/title"/>
			</xsl:element>
			<xsl:element name="abridged-title">
				<xsl:value-of select="/systematic-review/info/abridged-title"/>
			</xsl:element>
			
			<xsl:element name="section-list">
				<xsl:variable name="primary-section-title" select="document($bmjk-review-plan//info/section-list/section-link[1]/@target)//title"/>
				<xsl:for-each select="$bmjk-review-plan//info/section-list/section-link">
					<xsl:element name="section-link">
						<xsl:attribute name="target" select="@target"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		
		</xsl:element>
		
	</xsl:template>

</xsl:stylesheet>

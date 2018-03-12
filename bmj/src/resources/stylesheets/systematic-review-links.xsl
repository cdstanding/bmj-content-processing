<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	exclude-result-prefixes="xi xsi cals"
	version="2.0">
	
	<xsl:output
		method="xml"
		version="1.0"
		encoding="UTF-8"
		indent="yes"/>

	<xsl:key name="reference-link-keys" match="reference-link" use="@target"/>
	<xsl:key name="gloss-link-keys" match="gloss-link" use="@target"/>
	<xsl:key name="figure-link-keys" match="figure-link" use="@target"/>
	<xsl:key name="table-link-keys" match="table-link" use="@target"/>
	
	<xsl:param name="systematic-review-xml-input"/>
		
	<xsl:template match="/">
		<xsl:element name="root">
			<xsl:element name="reference-links">
				<xsl:call-template name="process-reference-links">
					<xsl:with-param name="item-count" select="1"/>
					<xsl:with-param name="link-index" select="1"/>
					<xsl:with-param name="link-count" select="count(//reference-link) + 1"/>
				</xsl:call-template>
			</xsl:element>
			<xsl:element name="gloss-links">
				<xsl:call-template name="process-gloss-links">
					<xsl:with-param name="item-count" select="1"/>
					<xsl:with-param name="link-index" select="1"/>
					<xsl:with-param name="link-count" select="count(//gloss-link) + 1"/>
				</xsl:call-template>
			</xsl:element>
			<xsl:element name="figure-links">
				<xsl:call-template name="process-figure-links">
					<xsl:with-param name="item-count" select="1"/>
					<xsl:with-param name="link-index" select="1"/>
					<xsl:with-param name="link-count" select="count(//figure-link) + 1"/>
				</xsl:call-template>
			</xsl:element>
			<xsl:element name="table-links">
				<xsl:call-template name="process-table-links">
					<xsl:with-param name="item-count" select="1"/>
					<xsl:with-param name="link-index" select="1"/>
					<xsl:with-param name="link-count" select="count(//table-link) + 1"/>
				</xsl:call-template>
				<!-- if grade table then add to end of list -->
				<xsl:if  
					test="
					//table-link
					[contains(
					document(concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../')))//caption
					, 'GRADE')]
					">
					<xsl:element name="table-link">
						<xsl:for-each 
							select="
							//table-link
							[contains(
							document(concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../')))//caption
							, 'GRADE')]
							[1]">
							<xsl:attribute name="target" select="@target"/>
						</xsl:for-each>
						<xsl:attribute name="grade">true</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</xsl:element>
		</xsl:element>	
	</xsl:template>

	<xsl:template name="process-reference-links">
		<xsl:param name="link-index"/>
		<xsl:param name="item-count"/>
		<xsl:param name="link-count"/>
		<xsl:variable name="link-target" select="(//reference-link)[$link-index]/@target"/>
		<!-- if the current link is the same element as the first 
			element in the list, indexed on link target, then print the reference -->
		<xsl:if test="$link-index &lt; $link-count">
			<xsl:variable name="link-id" select="generate-id((//reference-link)[$link-index])"/>
			<xsl:variable name="key-id" select="generate-id(key('reference-link-keys', $link-target)[1])"/>
			<xsl:choose>
				<xsl:when test="$link-id = $key-id and //reference-link[@target=$link-target]">
					<xsl:element name="reference-link">
						<xsl:attribute name="target" select="$link-target"/>
					</xsl:element>
					<!-- Call WITH an incremented item-count -->
					<xsl:call-template name="process-reference-links">
						<xsl:with-param name="item-count" select="$item-count + 1"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- Call WITHOUT an incremented item-count -->
					<xsl:call-template name="process-reference-links">
						<xsl:with-param name="item-count" select="$item-count"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="process-gloss-links">
		<xsl:param name="link-index"/>
		<xsl:param name="item-count"/>
		<xsl:param name="link-count"/>
		<xsl:variable name="link-target" select="(//gloss-link)[$link-index]/@target"/>
		<!-- if the current link is the same element as the first 
			element in the list, indexed on link target, then print the reference -->
		<xsl:if test="$link-index &lt; $link-count">
			<xsl:variable name="link-id" select="generate-id((//gloss-link)[$link-index])"/>
			<xsl:variable name="key-id" select="generate-id(key('gloss-link-keys', $link-target)[1])"/>
			<xsl:choose>
				<xsl:when test="$link-id = $key-id and //gloss-link[@target=$link-target]">
					<xsl:element name="gloss-link">
						<xsl:attribute name="target" select="$link-target"/>
					</xsl:element>
					<!-- Call WITH an incremented item-count -->
					<xsl:call-template name="process-gloss-links">
						<xsl:with-param name="item-count" select="$item-count + 1"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- Call WITHOUT an incremented item-count -->
					<xsl:call-template name="process-gloss-links">
						<xsl:with-param name="item-count" select="$item-count"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="process-figure-links">
		<xsl:param name="link-index"/>
		<xsl:param name="item-count"/>
		<xsl:param name="link-count"/>
		<xsl:variable name="link-target" select="(//figure-link)[$link-index]/@target"/>		
		<!-- if the current link is the same element as the first 
			element in the list, indexed on link target, then print the reference -->
		<xsl:if test="$link-index &lt; $link-count">
			<xsl:variable name="link-id" select="generate-id((//figure-link)[$link-index])"/>
			<xsl:variable name="key-id" select="generate-id(key('figure-link-keys', $link-target)[1])"/>
			<xsl:choose>
				<xsl:when test="$link-id = $key-id and //figure-link[@target=$link-target]">
					<xsl:element name="figure-link">
						<xsl:attribute name="target" select="$link-target"/>
					</xsl:element>
					<!-- Call WITH an incremented item-count -->
					<xsl:call-template name="process-figure-links">
						<xsl:with-param name="item-count" select="$item-count + 1"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- Call WITHOUT an incremented item-count -->
					<xsl:call-template name="process-figure-links">
						<xsl:with-param name="item-count" select="$item-count"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="process-table-links">
		<xsl:param name="link-index"/>
		<xsl:param name="item-count"/>
		<xsl:param name="link-count"/>
		<xsl:variable name="link-target" select="(//table-link)[$link-index]/@target"/>

		<xsl:variable name="table-link-grade-type">
			<xsl:choose>
				<xsl:when test="contains(document(concat(translate($systematic-review-xml-input, '\\', '/'), substring-after($link-target, '../')))//caption, 'GRADE')">
					<xsl:text>true</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>false</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable> 
		
		<!-- if the current link is the same element as the first 
			element in the list, indexed on link target, then print the reference -->
		<xsl:if test="$link-index &lt; $link-count">
			<xsl:variable name="link-id" select="generate-id((//table-link)[$link-index])"/>
			<xsl:variable name="key-id" select="generate-id(key('table-link-keys', $link-target)[1])"/>
			<xsl:choose>
				<xsl:when test="$link-id = $key-id and //table-link[@target=$link-target]">
					<!-- if target is a grade table type then we want to ignore listing it in our normal table numbered ordering -->
					<xsl:if test="$table-link-grade-type = 'false'">
						<xsl:element name="table-link">
							<xsl:attribute name="target" select="$link-target"/>
							<xsl:attribute name="grade">false</xsl:attribute>
						</xsl:element>
					</xsl:if>
					<!-- Call WITH an incremented item-count -->
					<xsl:call-template name="process-table-links">
						<xsl:with-param name="item-count" select="$item-count + 1"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- Call WITHOUT an incremented item-count -->
					<xsl:call-template name="process-table-links">
						<xsl:with-param name="item-count" select="$item-count"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>

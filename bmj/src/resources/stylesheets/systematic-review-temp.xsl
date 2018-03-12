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
	
	<xsl:param name="lang"/>
	<xsl:param name="media"/>
	<xsl:param name="systematic-review-xml-input"/>
	
	<xsl:include href="generic-params.xsl"/>
	<xsl:include href="systematic-review-params.xsl"/>
	
	<xsl:variable name="background">
		<xsl:for-each select="/systematic-review/background/element()">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="clinical-context">
		<xsl:for-each select="/systematic-review/clinical-context/element()">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template match="/">
		
		<xsl:element name="root">
			
			<xsl:copy-of select="//key-point-list"/>

			<clinical-context>
				<xsl:for-each select="$clinical-context/element()">
					<xsl:variable name="name" select="name()"/>
					<xsl:if test="$clinical-context/node()[name()=$name][string-length(.)!=0]">
						<xsl:copy-of select="$clinical-context/node()[name()=$name]"/>
					</xsl:if>
				</xsl:for-each>
			</clinical-context>
						
			<background>
				<xsl:for-each select="$background/element()">
					<xsl:variable name="name" select="name()"/>
					<xsl:if test="$background/node()[name()=$name][string-length(.)!=0]">
						<xsl:copy-of select="$background/node()[name()=$name]"/>
					</xsl:if>
				</xsl:for-each>
			</background>
			
			<options>
				<xsl:attribute name="count" select="count(//xi:include[contains(@href, 'option')])"/>
				<xsl:for-each select="//xi:include[contains(@href, 'option')]">
					<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@href, '../'))"/>
					<xsl:element name="option">
						<xsl:attribute name="id" select="@href"/>
						<xsl:copy-of select="document($filename)//option/node()"/>
					</xsl:element>
				</xsl:for-each>
			</options>
			
			<glosses>
				<xsl:attribute name="count" select="count(document(//xi:include[contains(@href, 'option')]/@href)//gloss-link ) + count($background//gloss-link)"/>
				
				<xsl:for-each select="//key-point-list/element()">
					<xsl:for-each select=".//gloss-link">
						<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
						<xsl:element name="gloss">
							<xsl:attribute name="id" select="@target"/>
							<xsl:copy-of select="document($filename)/gloss/node()"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:for-each>
				
				<xsl:for-each select="$background/element()">
					<xsl:for-each select=".//gloss-link">
						<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
						<xsl:element name="gloss">
							<xsl:attribute name="id" select="@target"/>
							<xsl:copy-of select="document($filename)/gloss/node()"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:for-each>
				
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)/*">
					<xsl:for-each select=".//gloss-link">
						<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
						<xsl:element name="gloss">
							<xsl:attribute name="id" select="@target"/>
							<xsl:copy-of select="document($filename)/gloss/node()"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:for-each>
			</glosses>
			
			<figures>
				<xsl:attribute name="count" select="count(document(//xi:include[contains(@href, 'option')]/@href)//figure-link ) + count($background//figure-link)"/>
				
				<xsl:for-each select="$background/element()">
					<xsl:for-each select=".//figure-link">
						<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
						<xsl:element name="figure">
							<xsl:attribute name="id" select="@target"/>
							<xsl:copy-of select="document($filename)/figure/node()"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:for-each>
				
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)/*">
					<xsl:for-each select=".//figure-link">
						<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
						<xsl:element name="figure">
							<xsl:attribute name="id" select="@target"/>
							<xsl:copy-of select="document($filename)/figure/node()"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:for-each>
			</figures>
			
			<tables>
				<xsl:attribute name="count" select="count(document(//xi:include[contains(@href, 'option')]/@href)//table-link ) + count($background//table-link)"/>
				
				<xsl:for-each select="$background/element()">
					<xsl:for-each select=".//table-link">
						<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
						<xsl:element name="table">
							<xsl:attribute name="id" select="@target"/>
							<xsl:copy-of select="document($filename)/table/node()"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:for-each>
				
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)/*">
					<xsl:for-each select=".//table-link">
						<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
						<xsl:element name="table">
							<xsl:attribute name="id" select="@target"/>
							<xsl:copy-of select="document($filename)/table/node()"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:for-each>
			</tables>
			
		</xsl:element>
		
	</xsl:template>

</xsl:stylesheet>

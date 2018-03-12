<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

	<xsl:output 
		method="xml" 
		encoding="UTF-8" 
		indent="yes" 
		omit-xml-declaration="no"
		name="xml-format"
	/>

	<xsl:param name="xml-input"/>
	<xsl:param name="xml-output"/>
	
	<xsl:template match="/CONDITIONS">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="CONDITION[@DOCTYPE='condition']">

		<xsl:variable name="sr-id" select="@ID"/>
		<xsl:variable name="sr-doc" select="document(concat($xml-input, $sr-id, '.xml'))"/>
		
		<xsl:message>
			<xsl:text>processing: </xsl:text>
			<xsl:value-of select="$sr-id"/>
		</xsl:message>

		<xsl:result-document format="xml-format"
			href="{concat($xml-output, 'sr-makefile-segment-', $sr-id, '.xml')}">

			<xsl:element name="sr-makefile-segment">
				
				<xsl:attribute name="xsi:noNamespaceSchemaLocation">../../../../schemas/bmjk-systematic-review-makefile-segment.xsd</xsl:attribute>
				
				<xsl:attribute name="id" select="$sr-id"/>
				<xsl:attribute name="pubdate" select="@PUBDATE"/>
				<xsl:attribute name="pubstatus" select="@PUBSTATUS"/>
				<xsl:attribute name="band">
					<xsl:variable name="option-count" select="count($sr-doc//option)"/>
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
					<xsl:value-of select="$sr-doc//condition-long-title"/>
				</xsl:element>
				<xsl:element name="abridged-title">
					<xsl:value-of select="$sr-doc//condition-abridged-title"/>
				</xsl:element>
				
				<!-- fix: get filenames from src-filenames -->
				<!--<xsl:element name="systematic-review-link">
					<xsl:attribute name="target" select="concat('../systematic-reviews/', 'sr-', $sr-id, '.xml')"/>
				</xsl:element>-->
				
				<!-- gaining primary and secondary section id's from makefile -->
				<xsl:element name="section-list">
					<xsl:element name="section-link">
						<xsl:attribute name="target"
							select="concat('../sections/', parent::SECTION/@ID, '.xml')"/>
					</xsl:element>
					<xsl:for-each
						select="//SECTION[CONDITION[@ID=$sr-id and @DOCTYPE='cross_ref']]">
						<xsl:element name="section-link">
							<xsl:attribute name="target"
								select="concat('../sections/', @ID, '.xml')"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>

			</xsl:element>

		</xsl:result-document>
		
	</xsl:template>

</xsl:stylesheet>

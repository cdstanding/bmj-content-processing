<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"
		use-character-maps="poc-custom-character-map isolat1-hexadecimal-character-entity-map"/>
	
	<xsl:include href="../../../xsl-entities/custom-map-point-of-care.xsl"/>

	<xsl:template match="/monographs">
		
		<xsl:element name="monographs">
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">
				<xsl:text>http://schemas.epocrates.com/schemas/newdx_v1_6.xsd</xsl:text>
			</xsl:attribute>
			
			<xsl:apply-templates/>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="regimens[not(regimen)]">
		<!--do nothing for empty regimens node-->
	</xsl:template>
	
	<xsl:template match="complications[not(complication)]">
		<!--do nothing for empty regimens node-->
	</xsl:template>
	
	<!--<xsl:template match="component[@modifier='OR']">
		<xsl:element name="component">
			<xsl:attribute name="modifier">
				<xsl:text>or</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
		</xsl:template>-->
	
	<!-- remove editors field and place into comment -->
	<xsl:template match="editors">
		<xsl:comment>
			<xsl:apply-templates/>
		</xsl:comment>
	</xsl:template>
	
	<!-- change component/details string order -->
	<!--<xsl:template match="details[parent::component]">
		<xsl:choose>
			<xsl:when test="not(contains(., ', '))">
				<xsl:comment select="'string order unchanged as no comma found'"/>
				<xsl:element name="details">
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="contains(., ',') and count(tokenize(., ',')) != 2">
				<xsl:comment select="'string order unchanged as more than one comma found'"/>
				<xsl:element name="details">
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="contains(., ',') and count(tokenize(., ',')) = 2">
				<xsl:comment select="concat('string order unchanged from ', .)"/>
				<xsl:element name="details">
					<xsl:value-of select="substring-after(., ', ')"/>
					<xsl:text>, </xsl:text>
					<xsl:value-of select="substring-before(., ', ')"/>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
	</xsl:template>-->
	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>

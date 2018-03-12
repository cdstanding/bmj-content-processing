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
	<xsl:include href="../../../generic-params.xsl"/>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- remove empty/optional parent_pt_group child empty-self-closing-element (parent_pt_group|tx_line|tx_type|comments) -->
	<xsl:template 
		match="
		element()[name()='parent_pt_group' or name()='tx_line' or name()='tx_type' or name()='comments'] 
		[not(element()) and not(text()) and not(@*)]
		[parent::tx_option]
		" 
		priority="3">
		<xsl:variable name="current-pt-group" select="translate(normalize-space(../pt_group), $upper, $lower)"/>
		<xsl:choose>
			<!-- am i parent patient group type? if so then remove these empty elements -->
			<xsl:when test="//parent_pt_group[translate(normalize-space(), $upper, $lower) = $current-pt-group]">
				<!--<xsl:comment>
					<xsl:text>removed optional empty-self-closing-element </xsl:text>
					<xsl:value-of select="name()"/>
				</xsl:comment>-->
			</xsl:when>
			<!-- otherwise warn me about why these elements are empty if they are expected for normal patient group tables -->
			<xsl:otherwise>
				<xsl:element name="{name()}">
					<xsl:element name="{$warning}"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- allow expected empty-self-closing-element -->
	
	<!-- //history/version -->
	<xsl:template match="version[not(element()) and not(text()) and not(@*)][parent::history]" priority="3">
		<xsl:element name="{name()}">
			<xsl:text>na</xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- //history/revised_by -->
	<xsl:template match="revised_by[not(element()) and not(text()) and not(@*)][parent::history]" priority="3">
		<xsl:element name="{name()}">
			<xsl:text>na</xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- //history/comments -->
	<xsl:template match="comments[not(element()) and not(text()) and not(@*)][parent::history]" priority="3">
		<xsl:element name="{name()}">
			<xsl:text>na</xsl:text>
		</xsl:element>
	</xsl:template>
	
	
	<!-- remove optional empty-self-closing-element -->
	
	<!-- //last_accessed/guideline -->
	<xsl:template match="last_accessed[not(element()) and not(text()) and not(@*)][parent::guideline]" priority="3">
		<xsl:comment>
			<xsl:text>removed optional empty-self-closing-element </xsl:text>
			<xsl:value-of select="name()"/>
		</xsl:comment>
	</xsl:template>
	
	<!-- //guideline/url -->
	<xsl:template match="url[not(element()) and not(text()) and not(@*)][parent::guideline]" priority="3">
		<xsl:comment>
			<xsl:text>removed optional empty-self-closing-element </xsl:text>
			<xsl:value-of select="name()"/>
		</xsl:comment>
	</xsl:template>
	
	<!-- //(test|risk_factor)/detail -->
	<xsl:template match="detail[not(element()) and not(text()) and not(@*)][parent::test or parent::risk_factor]" priority="3">
		<xsl:comment>
			<xsl:text>removed optional empty-self-closing-element </xsl:text>
			<xsl:value-of select="name()"/>
		</xsl:comment>
	</xsl:template>
	
	<!-- //test/comments -->
	<xsl:template match="comments[not(element()) and not(text()) and not(@*)][parent::test]" priority="3">
		<xsl:comment>
			<xsl:text>removed optional empty-self-closing-element </xsl:text>
			<xsl:value-of select="name()"/>
		</xsl:comment>
	</xsl:template>
	
	<!-- //component/details -->
	<xsl:template match="details[not(element()) and not(text()) and not(@*)][parent::component]" priority="3">
		<xsl:comment>
			<xsl:text>removed optional empty-self-closing-element </xsl:text>
			<xsl:value-of select="name()"/>
		</xsl:comment>
	</xsl:template>
	
	<!-- //peer_reviewers -->
	<xsl:template match="peer_reviewers[not(element()) and not(text()) and not(@*)]" priority="3">
		<xsl:comment>
			<xsl:text>removed optional empty-self-closing-element </xsl:text>
			<xsl:value-of select="name()"/>
		</xsl:comment>
	</xsl:template>
	
	<!-- //(author|peer_reviewer)/degree -->
	<xsl:template match="degree[not(element()) and not(text()) and not(@*)][parent::author or parent::peer_reviewer]" priority="3">
		<xsl:comment>
			<xsl:text>removed optional empty-self-closing-element </xsl:text>
			<xsl:value-of select="name()"/>
		</xsl:comment>
	</xsl:template>
	
	<!-- //criteria/title -->
	<xsl:template match="title[not(element()) and not(text()) and not(@*)][parent::criteria]" priority="3">
		<xsl:comment>
			<xsl:text>removed optional empty-self-closing-element </xsl:text>
			<xsl:value-of select="name()"/>
		</xsl:comment>
	</xsl:template>

	<!-- //diagnosis/differentials -->
	<xsl:template match="differentials[not(element()) and not(text()) and not(@*)][parent::diagnosis]" priority="3">
		<xsl:comment>
			<xsl:text>removed optional empty-self-closing-element </xsl:text>
			<xsl:value-of select="name()"/>
		</xsl:comment>
	</xsl:template>
	
	<!-- //image_ref/source -->
	<xsl:template match="source[not(element()) and not(text()) and not(@*)][parent::image_ref]" priority="3">
		<xsl:comment>
			<xsl:text>removed optional empty-self-closing-element </xsl:text>
			<xsl:value-of select="name()"/>
		</xsl:comment>
	</xsl:template>

	
	<!-- warning -->
	<xsl:template match="element()[name()=$warning]" priority="3">
		<xsl:element name="{name()}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>


	<!-- prompt empty-self-closing-element -->
	<xsl:template match="element()[not(element()) and not(text()) and not(@*)]" priority="2">
		<xsl:element name="{name()}">
			<xsl:element name="{$warning}"/>
		</xsl:element>
	</xsl:template>
	
	
	<!-- copy all source xml to target xml -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>

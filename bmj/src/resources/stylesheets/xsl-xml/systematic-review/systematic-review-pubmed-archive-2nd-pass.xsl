<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xi="http://www.w3.org/2001/XInclude" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	
	xmlns:oak="http://schema.bmj.com/delivery/oak"
	xmlns:ce="http://schema.bmj.com/delivery/oak-ce"
	
	version="2.0">
	
	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"/>
	
	<xsl:include href="../../generic-params.xsl"/>
	<xsl:include href="../../systematic-review-params.xsl"/>
	
	<xsl:template match="/*">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@* | node()"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="table-wrap">
		<xsl:variable name="wrap-id" select="@id"/>
		<xsl:variable name="wrap-position" select="generate-id(.)"/>
		<xsl:variable name="wrap-first" select="generate-id((//table-wrap[@id = $wrap-id])[1])"/>
		
		<xsl:if test="$wrap-position = $wrap-first and not(contains(translate(caption, $upper, $lower), 'grade'))">
			
			<xsl:element name="table-wrap">
				<xsl:apply-templates select="@*"/>
				<xsl:apply-templates/>
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="*:table[parent::*:section[@class='grade' or @class='adverse-effects']]">
		
		<xsl:element name="table-wrap">
			<xsl:attribute name="position" select="string('anchor')" />
			
			<xsl:element name="table">
				<xsl:apply-templates />
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
<xsl:template match="fig">
		<xsl:variable name="wrap-id" select="@id"/>
		<xsl:variable name="wrap-position" select="generate-id(.)"/>
		<xsl:variable name="wrap-first" select="generate-id((//fig[@id = $wrap-id])[1])"/>
		
		<xsl:if test="$wrap-position = $wrap-first">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::*:td">
					<xsl:element name="graphic">
						<xsl:apply-templates select="@*"/>
						<xsl:apply-templates select="graphic/@*"/>
						<xsl:apply-templates select="*[local-name() !='graphic']"/>
					</xsl:element>
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="fig">
						<xsl:apply-templates select="@*"/>
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="ref-list">
		
		<xsl:element name="ref-list">
			
			<xsl:for-each select="//table-wrap[contains(translate(caption, $upper, $lower), 'grade')]">
				
				<xsl:if test="position()=last()">
					
					<xsl:comment>moving GRADE table-wrap here to avoid invalid nesting in bold markup when referenced in //sec[@sec-type='intervention']/p/bold</xsl:comment>
					
					<xsl:element name="table-wrap">
						<xsl:apply-templates select="@*"/>
						<xsl:apply-templates/>
					</xsl:element>
					
				</xsl:if>
				
			</xsl:for-each>
			
			<xsl:apply-templates/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="section[@class='effect-size' and metadata/key[@ce:name='effect-size' and @value='unset']]" />
	
	<!-- various templates to convert shared oak comparison xsl output format back to nlm format -->
	<xsl:template match="*:section">
		
		<xsl:element name="sec">
			
			<xsl:if test="@class and @class!='sec'">
				<xsl:attribute name="sec-type" select="@class" />
			</xsl:if>
			
			<xsl:if test="@id">
				<xsl:attribute name="id" select="@id" />
			</xsl:if>
			
			<xsl:apply-templates />
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="*:section/*:metadata[*:key/@name='effect-size']">
		
		<xsl:element name="sec-meta">
			
			<xsl:element name="kwd-group">
				<xsl:attribute name="kwd-group-type" select="string('effect-size')" />
				
				<xsl:element name="kwd">
					<xsl:value-of select="*:key[@name='effect-size']/@value" />
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="*:title | *:p | *:thead | *:tbody | *:tfoot | *:tr | *:td | *:bold | *:italic | *:xref">
		
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@* | node()" />
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="*:br">
		<xsl:element name="break" />
	</xsl:template>
	
	<xsl:template match="@class">
		<xsl:attribute name="content-type" select="." />
	</xsl:template>
	
	<xsl:template match="@*[name()!='xmlns:ce' and name()!='ce:oen' and name()!='class'] | node()">
		
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
		
	</xsl:template>
	
	<xsl:template match="comment()">
		<xsl:comment select="."/>
	</xsl:template>
	
</xsl:stylesheet>

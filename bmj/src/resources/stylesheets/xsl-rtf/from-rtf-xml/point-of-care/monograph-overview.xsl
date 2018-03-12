<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/HTML/1998/html4"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal">

	<xsl:template name="process-monograph-overview">
		
		<xsl:element name="monograph_overview">
			
			<xsl:call-template name="process-info"/>
			
			<xsl:call-template name="process-overview-summary"/>
			<xsl:call-template name="process-overview-disease-subtypes"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-overview-summary">
		
		<xsl:for-each
			select="
			//html:table
			//html:tr
			[html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'summary')]]
			">
			<xsl:element name="summary">
				<xsl:for-each select="following-sibling::html:tr[position() &gt; 1]">
					<xsl:element name="section">
						<xsl:call-template name="process-section"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-overview-disease-subtypes">
		
		<xsl:element name="disease_subtypes">
			<xsl:for-each
				select="
				//html:table
				//html:tr
					[html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(., $upper, $lower), 'disease sub-types')]]
				/following-sibling::html:tr[position() &gt; 1]
					[html:td/uci:par[1][string-length()!=0]]
				">
				<xsl:element name="subtype">
					<xsl:attribute name="dx_id" select="normalize-space(html:td[1])"/>
					<xsl:element name="name">
						<xsl:apply-templates select="html:td[2]"/>
					</xsl:element>
					<xsl:element name="detail">
						<xsl:for-each select="html:td[3]/uci:par">
							<xsl:call-template name="process-para"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
		
</xsl:stylesheet>

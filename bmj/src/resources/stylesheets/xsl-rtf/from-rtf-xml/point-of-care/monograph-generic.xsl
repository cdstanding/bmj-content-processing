<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/HTML/1998/html4"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal">

	<xsl:template name="process-monograph-generic">
		
		<xsl:element name="monograph_generic">
			
			<xsl:call-template name="process-info"/>
			
			<xsl:element name="sections">
				<xsl:call-template name="process-sections"/>
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-sections">
		
		<xsl:for-each
			select="
			//html:table
			//html:tr
			[.//html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'sections') or contains(translate(., $upper, $lower), 'overview')]]
			">
			<xsl:for-each select="following-sibling::html:tr[position() &gt; 1 and string-length(normalize-space(.))!=0]">
				<xsl:element name="section">
					<xsl:call-template name="process-section"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:for-each>

	</xsl:template>
		
</xsl:stylesheet>

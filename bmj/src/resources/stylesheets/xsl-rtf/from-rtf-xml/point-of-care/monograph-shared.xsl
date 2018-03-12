<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/HTML/1998/html4"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal">

	

	<xsl:template name="process-approach-shared">
		<xsl:param name="approach-type"/>
		
		<xsl:element name="approach">
			<xsl:for-each
				select="
				//html:table
				//html:tr
				[html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(., $upper, $lower), concat(': ', $approach-type, ' approach'))]]
				">
				<xsl:for-each select="following-sibling::html:tr[position() &gt; 1]">
					<xsl:if test="html:td[2][string-length(normalize-space(.))!=0]">
						<xsl:element name="section">
							<xsl:call-template name="process-section"/>
						</xsl:element>		
					</xsl:if>
				</xsl:for-each>
				
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-guidelines-shared">
		<xsl:param name="guideline-type"/>
		
		<xsl:if test="$debug='true'">
			<xsl:comment>DEBUG Guidelines</xsl:comment>
		</xsl:if>
		
		
		<xsl:for-each
			select="
			//html:table
			//html:tr
			[.//html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), concat(': ', $guideline-type, ' guidelines'))]]
			">
			<!-- optional -->
			<xsl:if test="following-sibling::html:tr[2][string-length()!=0]">
				<xsl:element name="guidelines">
					<xsl:for-each 
						select="
						following-sibling::html:tr[position() &gt; 1]
						[string-length()!=0]
						">
						<xsl:element name="guideline">
							<xsl:element name="title">
								<xsl:apply-templates select="html:td[1]"/>
							</xsl:element>
							<xsl:element name="source">
								<xsl:apply-templates select="html:td[2]"/>
							</xsl:element>
							<xsl:element name="last_published">
								<xsl:apply-templates select="html:td[3]"/>
							</xsl:element>
							<xsl:element name="last_accessed">
								<xsl:apply-templates select="html:td[4]"/>
							</xsl:element>
							<xsl:element name="url">
								<xsl:apply-templates select="html:td[5]"/>
							</xsl:element>
							<xsl:element name="summary">
								<xsl:for-each select="html:td[6]/uci:par">
									<xsl:call-template name="process-para"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>						
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/HTML/1998/html4"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal">

	<xsl:template name="process-monograph-evaluation">
		
		<xsl:element name="monograph_eval">
			
			<xsl:call-template name="process-info"/>
			
			<xsl:call-template name="process-eval-overview"/>
			<xsl:call-template name="process-eval-ddx-etiology"/>
			<xsl:call-template name="process-eval-urgent-considerations"/>
			<!-- if schema change then use process-approach-shared template -->
			<xsl:call-template name="process-eval-diagnostic-approach"/>
			<xsl:call-template name="process-eval-differentials"/>
			<!-- if schema change then use process-approach-shared template -->
			<!--<xsl:call-template name="process-eval-differential-approach"/>-->
			<!--<xsl:call-template name="process-eval-diagnostic-factors"/>-->
			<!--<xsl:call-template name="process-eval-tests"/>-->
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-eval-overview">
		
		<xsl:for-each
			select="
			//html:table
			//html:tr[1]
			[html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'overview')]]
			">
			<xsl:element name="overview">
				<xsl:for-each select="following-sibling::html:tr[position() &gt; 1]">
					<xsl:element name="section">
						<xsl:call-template name="process-section"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-eval-ddx-etiology">

		<xsl:for-each
			select="
			//html:table
			//html:tr[1]
			[html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'etiology')]]
			">
			<xsl:element name="ddx_etiology">
				<xsl:for-each select="following-sibling::html:tr[position() &gt; 1]">
					<xsl:element name="section">
						<xsl:call-template name="process-section"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-eval-urgent-considerations">
		
		<xsl:for-each
			select="
			//html:table
			//html:tr
			[html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'urgent considerations')]]
			">
			<xsl:element name="urgent_considerations">
				<xsl:for-each select="following-sibling::html:tr[position() &gt; 1]">
					<xsl:element name="section">
						<xsl:call-template name="process-section"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-eval-diagnostic-approach">
		
		<xsl:for-each
			select="
			//html:table
			//html:tr
			[html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'diagnostic approach')]]
			">
			<xsl:element name="diagnostic_approach">
				<xsl:for-each select="following-sibling::html:tr[position() &gt; 1]">
					<xsl:element name="section">
						<xsl:call-template name="process-section"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-eval-differentials">
		
		<xsl:element name="differentials">
			<xsl:for-each
				select="
				//html:table
					[.//html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(uci:par[1], $upper, $lower), 'differential')]
					/parent::html:tr/following-sibling::html:tr[1]/html:td[1]
						[contains(translate(uci:par[1], $upper, $lower), 'dx id')]]
				">
				<xsl:call-template name="process-eval-differential"/>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-eval-differential">
		
		<xsl:element name="differential">
			
			<xsl:for-each 
				select="
				.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(uci:par[1], $upper, $lower), 'dx id')]
				/following-sibling::html:td[1][string-length(normalize-space(.))!=0]
				">
				<xsl:attribute name="dx_id" select="replace(., '^.*?(\d+).*?$', '$1')"/>
			</xsl:for-each>
			<xsl:for-each 
				select="
				.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(uci:par[1], $upper, $lower), 'common')]
				/following-sibling::html:td[1]
				">
				<xsl:attribute name="common">
					<xsl:choose>
						<xsl:when 
							test="
							contains(translate(., $upper, $lower), 'yes')
							or contains(translate(., $upper, $lower), 'true')
							">
							<xsl:text>true</xsl:text>
						</xsl:when>
						<xsl:when 
							test="
							contains(translate(., $upper, $lower), 'no')
							or contains(translate(., $upper, $lower), 'false')
							">
							<xsl:text>false</xsl:text>
						</xsl:when>
						<xsl:when test="string-length(normalize-space(.))!=0">
							<xsl:value-of select="$warning"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>false</xsl:text>								
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:for-each>
			<xsl:for-each 
				select="
				.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(uci:par[1], $upper, $lower), 'red flag')]
				/following-sibling::html:td[1]
				">
				<xsl:attribute name="red_flag">
					<xsl:choose>
						<xsl:when 
							test="
							contains(translate(., $upper, $lower), 'yes')
							or contains(translate(., $upper, $lower), 'true')
							">
							<xsl:text>true</xsl:text>
						</xsl:when>
						<xsl:when 
							test="
							contains(translate(., $upper, $lower), 'no')
							or contains(translate(., $upper, $lower), 'false')
							">
							<xsl:text>false</xsl:text>
						</xsl:when>
						<xsl:when test="string-length(normalize-space(.))!=0">
							<xsl:value-of select="$warning"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>false</xsl:text>								
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:for-each>
			
			<xsl:element name="ddx_name">
				<xsl:for-each 
					select="
					.//html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(uci:par[1], $upper, $lower), 'differential name')]
					/following-sibling::html:td[1]
					">
					<xsl:apply-templates/>
				</xsl:for-each>
			</xsl:element>
			<xsl:element name="category">
				<xsl:for-each 
					select="
					.//html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(uci:par[1], $upper, $lower), 'differential category')]
					/following-sibling::html:td[1]
					">
					<xsl:apply-templates/>
				</xsl:for-each>
			</xsl:element>
			<xsl:element name="history">
				<xsl:for-each 
					select="
					.//html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(uci:par[1], $upper, $lower), 'history')]
					/following-sibling::html:td[1]
					">
					<xsl:apply-templates/>
				</xsl:for-each>
			</xsl:element>
			<xsl:element name="exam">
				<xsl:for-each 
					select="
					.//html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(uci:par[1], $upper, $lower), 'exam')]
						/following-sibling::html:td[1]/uci:par
					">
					<xsl:apply-templates/>
				</xsl:for-each>
			</xsl:element>
			
			<xsl:call-template name="process-eval-differential-tests"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-eval-differential-tests">
		
		<xsl:for-each 
			select="
			.//html:tr
			[html:td
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'specific tests to order')]]
			[following-sibling::html:tr[position() = 2 and string-length(normalize-space(.))!=0]]
			">
			<xsl:element name="tests">
				<xsl:for-each select="following-sibling::html:tr[position() &gt; 1 and string-length(normalize-space(.))!=0]">
					<xsl:element name="test">
						<xsl:attribute name="first">
							<xsl:choose>
								<xsl:when 
									test="
									html:td[4]
									[contains(translate(., $upper, $lower), 'yes')
									or contains(translate(., $upper, $lower), 'true')]
									">
									<xsl:text>true</xsl:text>
								</xsl:when>
								<xsl:when 
									test="
									html:td[4]
									[contains(translate(., $upper, $lower), 'no')
									or contains(translate(., $upper, $lower), 'false')]
									">
									<xsl:text>false</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[4][string-length(normalize-space(.))!=0]">
									<xsl:value-of select="$warning"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>false</xsl:text>								
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:element name="name">
							<xsl:apply-templates select="html:td[1]"/>
						</xsl:element>
						<xsl:element name="result">
							<xsl:apply-templates select="html:td[2]"/>
						</xsl:element>
						<xsl:element name="comments">
							<xsl:for-each select="html:td[3]/uci:par">
								<xsl:call-template name="process-para"/>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-eval-differential-approach">
		
		<xsl:for-each
			select="
			//html:table
			//html:tr
			[html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'differential: approach')]]
			">
			<xsl:element name="differential_approach">
				<xsl:for-each select="following-sibling::html:tr[position() &gt; 1]">
					<xsl:element name="section">
						<xsl:call-template name="process-section"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>
		
	<xsl:template name="process-eval-diagnostic-factors">
		
		<xsl:element name="diagnostic_factors">
			<xsl:for-each
				select="
				//html:table
				//html:tr
					[.//html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(., $upper, $lower), 'diagnostic factors')]]
					/following-sibling::html:tr[position() = 2]
						[html:td/uci:par[1][string-length(normalize-space(.))!=0]]
				">
				<xsl:element name="diagnostic_factor">
					<xsl:element name="factor">
						<xsl:apply-templates select="html:td[1]"/>
					</xsl:element>
					<xsl:element name="detail">
						<xsl:for-each select="html:td[2]/uci:par">
							<xsl:call-template name="process-para"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
			
			<xsl:for-each
				select="
				//html:table
				//html:tr
					[.//html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(., $upper, $lower), 'diagnostic factors')]]
					/following-sibling::html:tr[position() &gt; 2]
						[html:td/uci:par[1][string-length(normalize-space(.))!=0]]
				">
				<xsl:comment xml:space="preserve">
					<xsl:element name="diagnostic_factor">
						<xsl:element name="factor">
							<xsl:apply-templates select="html:td[1]"/>
						</xsl:element>
						<xsl:element name="detail">
							<xsl:for-each select="html:td[2]/uci:par">
								<xsl:call-template name="process-para"/>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:comment>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-eval-tests">
		
		<xsl:for-each
			select="
			//html:table
			//html:tr
			[.//html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'diagnostic factors')]]
			[following-sibling::html:tr[position() = 2 and string-length(normalize-space(.))!=0]]
			">
			<xsl:element name="tests">
				<xsl:for-each
					select="following-sibling::html:tr[position() &gt; 1 and string-length(normalize-space(.))!=0]">	
					<xsl:element name="test">
						<xsl:element name="differential">
							<xsl:apply-templates select="html:td[1]"/>
						</xsl:element>
						<xsl:element name="name">
							<xsl:apply-templates select="html:td[2]"/>
						</xsl:element>
						<xsl:element name="result">
							<xsl:apply-templates select="html:td[3]"/>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:html="http://www.w3.org/HTML/1998/html4"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal">
	
	<xsl:include href="monograph-standard-treatment-options.xsl"/>
	
	<!--
	*poc: other tests*
	- normalise-space without effecting any organism mark-up for: <pt_group/>, <parent_pt_group/>, <tx_type/>
	- warn if image system filename not matched
	- warn if image filename not using correct naming convention
	- warn if reference numbering being out of sequence
	- warn if sequence numbering of reference links out of order
	- warn if listed reference not cited in monograph
	- warn if any outstanding organism mark-up not matched
	- warn if any outstanding unmatched bracketed text
	- warn if certain special characters not being used as descibed in style guide (or force to correct style on conversion)
	- warn if xml not valid on point of ftp transfer
	- better test for processing non standard monograph types
	-->
	
	<xsl:variable name="debug">false</xsl:variable>
		
	<xsl:template name="process-monograph-standard">
		
		<xsl:element name="monograph_full">
			
			<xsl:call-template name="process-info"/>
			
			<xsl:call-template name="process-highlights"/>
						
			<xsl:element name="basics">
				<xsl:call-template name="process-basics-definition"/>
				<xsl:call-template name="process-basics-classifications"/>
				<xsl:call-template name="process-basics-vignette"/>
				<xsl:call-template name="process-basics-other-presentations"/>
				<xsl:call-template name="process-basics-epidemiology"/>
				<xsl:call-template name="process-basics-etiology"/>
				<xsl:call-template name="process-basics-pathophysiology"/>
				<xsl:call-template name="process-basics-risk-factors"/>
				<xsl:call-template name="process-basics-prevention"/>
			</xsl:element>
			
			<xsl:element name="diagnosis">
				<xsl:call-template name="process-approach-shared">
					<xsl:with-param name="approach-type">diagnostic</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="process-diagnosis-factors"/>
				<xsl:call-template name="process-diagnosis-tests"/>
				<xsl:call-template name="process-diagnosis-differentials"/>
				<xsl:call-template name="process-diagnosis-criteria"/>
				<xsl:call-template name="process-diagnosis-screening"/>
				<xsl:call-template name="process-guidelines-shared">
					<xsl:with-param name="guideline-type">diagnostic</xsl:with-param>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:element name="treatment">
				<xsl:call-template name="process-approach-shared">
					<xsl:with-param name="approach-type">treatment</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="process-treatment-tx-options"/>
				<xsl:call-template name="process-treatment-emerging-txs"/>
				<xsl:call-template name="process-guidelines-shared">
					<xsl:with-param name="guideline-type">treatment</xsl:with-param>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:element name="followup">
				<xsl:call-template name="process-followup-outlook"/>
				<xsl:call-template name="process-followup-complications"/>
				<xsl:call-template name="process-followup-recomendations"/>
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-highlights">
		
		<xsl:element name="highlights">
			<xsl:for-each
				select="
				//html:table
				//html:tr
				[html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(., $upper, $lower), 'key highlights')]]
				/following-sibling::html:tr
				/html:td/uci:par[string-length(normalize-space(.))!=0]
				">
				<xsl:element name="highlight">
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-basics-definition">
		
		<xsl:element name="definition">
			<xsl:for-each
				select="
				//html:table
				//html:tr
				[html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(., $upper, $lower), 'basics: definition')]]
				/following-sibling::html:tr
				/html:td/uci:par
				">
				<xsl:call-template name="process-para"/>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>

	<xsl:template name="process-basics-classifications">

		<xsl:for-each
			select="
			//html:table
			//html:tr
			[html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'basics: classification')]]
			">
			<xsl:if 
				test="
				following-sibling::html:tr[2]
				[string-length(normalize-space(.))!=0]
				">
				<xsl:element name="classifications">
					<xsl:for-each 
						select="
						following-sibling::html:tr[position() &gt; 1]
						[string-length(normalize-space(.))!=0]
						">
						<xsl:element name="classification">
							<xsl:element name="title">
								<xsl:if test="normalize-space(html:td[1])=''">
									<xsl:element name="{$warning}"/>
								</xsl:if>
								<xsl:apply-templates select="html:td[1]"/>
							</xsl:element>

							
							<xsl:element name="detail">
								<xsl:for-each select="html:td[2]/(uci:par|uci:list)">
									<xsl:call-template name="process-para"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template name="process-basics-vignette">
		
		<xsl:element name="vignettes">
			
			<xsl:for-each
				select="
				//html:table
				//html:tr
				[html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(., $upper, $lower), 'basics: common vignette #1')]]
				">
				<xsl:element name="vignette">
					<xsl:for-each
						select="
						following-sibling::html:tr
						/html:td/uci:par
						">
						<xsl:call-template name="process-para"/>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each>
		
			<xsl:for-each
				select="
				//html:table
				//html:tr
				[html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(., $upper, $lower), 'basics: common vignette #2')]]
				[following-sibling::html:tr/html:td/uci:par[string-length(normalize-space(.))!=0]]
				">
				<xsl:element name="vignette">
					<xsl:for-each
						select="
						following-sibling::html:tr
						/html:td/uci:par
						">
						<xsl:call-template name="process-para"/>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>

	<xsl:template name="process-basics-other-presentations">
		
		<xsl:for-each
			select="
			//html:table
			//html:tr
			[html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'basics: other presentations')]]
			">
			<xsl:if test="following-sibling::html:tr[1][string-length(normalize-space(.))!=0]">
				<xsl:element name="other_presentations">
					<xsl:for-each select="following-sibling::html:tr/html:td/uci:par">
						<xsl:call-template name="process-para"/>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-basics-epidemiology">
		
		<xsl:element name="epidemiology">
			<xsl:for-each
				select="
				//html:table
				//html:tr
				[html:td
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(., $upper, $lower), 'basics: epidemiology')]]
				/following-sibling::html:tr
				/html:td/(uci:par|uci:list)
				">
				<xsl:call-template name="process-para"/>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-basics-etiology">
		
		<xsl:element name="etiology">
			<xsl:for-each
				select="
				//html:table
				//html:tr[1]
				[html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(., $upper, $lower), 'basics: etiology &amp; pathophysiology')]]
				/following-sibling::html:tr
				">
				<xsl:for-each 
					select="
					.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'etiology')]
					/following-sibling::html:td[1]/(uci:par|uci:list)
					">
					<xsl:call-template name="process-para"/>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-basics-pathophysiology">
		
		<xsl:element name="pathophysiology">
			<xsl:for-each
				select="
				//html:table
				//html:tr[1]
				[html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(., $upper, $lower), 'basics: etiology &amp; pathophysiology')]]
				/following-sibling::html:tr
				">
				<xsl:for-each 
					select="
					.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'pathophysiology')]
					/following-sibling::html:td[1]/(uci:par|uci:list)
					">
					<xsl:call-template name="process-para"/>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>

	<xsl:template name="process-basics-risk-factors">
		
		<xsl:for-each select="
			//html:table
			//html:tr
			[.//html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'basics: risk factors')
			or contains(translate(., $upper, $lower), 'basics:  risk factors')]]
			[following-sibling::html:tr[position() = 2 and string-length(normalize-space(.))!=0]]
			">
			<xsl:element name="risk_factors">
				<xsl:for-each select="following-sibling::html:tr[position() &gt; 1 and string-length(normalize-space(.))!=0]">				
					<xsl:element name="risk_factor">
						<xsl:element name="name">
							<xsl:apply-templates select="html:td[1]"/>
						</xsl:element>
						<xsl:element name="strength">
							<xsl:choose>
								<xsl:when test="html:td[2][contains(translate(., $upper, $lower), 'strong')]">
									<xsl:text>strong</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[2][contains(translate(., $upper, $lower), 'weak')]">
									<xsl:text>weak</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="{$warning}"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						<xsl:element name="detail">
							<xsl:for-each select="html:td[3]/uci:par">
								<xsl:call-template name="process-para"/>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="process-basics-prevention">
		
		
		<xsl:for-each
			select="
			//html:table
			//html:tr
			[html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'basics: primary prevention')]]
			">
			<!-- optional -->
			<xsl:if 
				test="
				following-sibling::html:tr[1]
				/html:td[1][string-length(normalize-space(.))!=0]
				">
				<xsl:element name="prevention">
					<xsl:for-each 
						select="
						following-sibling::html:tr
						/html:td/(uci:par|uci:list)
						">
						<xsl:call-template name="process-para"/>		
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-diagnosis-factors">
		
		<xsl:element name="diagnostic_factors">
			<xsl:for-each
				select="
				//html:table
				//html:tr
				[.//html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(., $upper, $lower), 'diagnosis: history &amp; exam, diagnostic factors')]]
				/following-sibling::html:tr[position() &gt; 1]
				[html:td/uci:par[1][string-length(normalize-space(.))!=0]]
				">
				<xsl:element name="factor">
					<xsl:element name="factor_name">
						<xsl:apply-templates select="html:td[1]"/>
					</xsl:element>
					<xsl:element name="type">
						<xsl:choose>
							<xsl:when test="html:td[2][contains(translate(., $upper, $lower), 'historical')]">
								<xsl:text>historical</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[2][contains(translate(., $upper, $lower), 'symptom')]">
								<xsl:text>symptom</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[2][contains(translate(., $upper, $lower), 'sign')]">
								<xsl:text>sign</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:element name="{$warning}"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					<xsl:if test="html:td[3]/uci:par[1][string-length(normalize-space(.))!=0]">
						<xsl:element name="detail">
							<xsl:for-each select="html:td[3]/uci:par">
								<xsl:call-template name="process-para"/>
							</xsl:for-each>
						</xsl:element>
					</xsl:if>
					<xsl:element name="frequency">
						<xsl:variable name="common-val"><xsl:value-of select="normalize-space(translate(html:td[4], $upper, $lower))"/></xsl:variable>

						<xsl:if test="$debug='true'">
							<xsl:comment>DEBUG <xsl:value-of select="$common-val"/></xsl:comment>
						</xsl:if>
						
						<xsl:choose>
							<xsl:when test="contains($common-val, 'common')">
								<xsl:value-of select="$common-val"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:element name="{$warning}"/>
							</xsl:otherwise>
						</xsl:choose>
						<!--
						<xsl:choose>
							<xsl:when test="html:td[4][contains(translate(., $upper, $lower), 'common')]">
								<xsl:text>common</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[4][contains(translate(., $upper, $lower), 'uncommon')]">
								<xsl:text>uncommon</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:element name="{$warning}"/>
							</xsl:otherwise>
						</xsl:choose>
						-->
					
					</xsl:element>
					<xsl:element name="key_factor">
						<xsl:choose>
							<xsl:when 
								test="
								html:td[5]
								[contains(translate(., $upper, $lower), 'yes')
								or contains(translate(., $upper, $lower), 'true')]
								">
								<xsl:text>true</xsl:text>
							</xsl:when>
							<xsl:when 
								test="
								html:td[5]
								[contains(translate(., $upper, $lower), 'no')
								or contains(translate(., $upper, $lower), 'false')]
								">
								<xsl:text>false</xsl:text>
							</xsl:when>
							<xsl:when 
								test="
								html:td[5]/uci:par[1]
								[string-length(normalize-space(.))!=0]
								">
								<xsl:value-of select="$warning"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>false</xsl:text>								
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>

	<xsl:template name="process-diagnosis-tests">
		
		<xsl:for-each
			select="
			//html:table
			//html:tr
			[.//html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'diagnosis: tests')]]
			[following-sibling::html:tr[2]
			[string-length(normalize-space(.))!=0]]
			">
			<xsl:element name="tests">	
				<xsl:for-each
					select="
					following-sibling::html:tr[position() &gt; 1]
					[string-length(normalize-space(.))!=0]
					">
					<xsl:element name="test">
						<xsl:attribute name="order">
							<xsl:choose>
								<xsl:when test="html:td[5][contains(translate(., $upper, $lower), 'initial')]">
									<xsl:text>initial</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[5][contains(translate(., $upper, $lower), 'subsequent')]">
									<xsl:text>subsequent</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[5][contains(translate(., $upper, $lower), 'emerging')]">
									<xsl:text>emerging</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="{$warning}"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:element name="name">
							<xsl:apply-templates select="html:td[1]"/>
						</xsl:element>
						<xsl:element name="type">
							<xsl:choose>
								<xsl:when test="html:td[2][contains(translate(., $upper, $lower), 'laboratory')]">
									<xsl:text>laboratory</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[2][contains(translate(., $upper, $lower), 'physiologic')]">
									<xsl:text>physiologic</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[2][contains(translate(., $upper, $lower), 'theraputic')]">
									<xsl:text>theraputic</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[2][contains(translate(., $upper, $lower), 'trial')]">
									<xsl:text>theraputic trial</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[2][contains(translate(., $upper, $lower), 'endoscopy')]">
									<xsl:text>endoscopy</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[2][contains(translate(., $upper, $lower), 'pathology')]">
									<xsl:text>pathology</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[2][contains(translate(., $upper, $lower), 'other')]">
									<xsl:text>other</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[2][contains(translate(., $upper, $lower), 'imaging')]">
									<xsl:text>imaging</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="{$warning}"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						<xsl:element name="result">
							<xsl:apply-templates select="html:td[3]"/>
						</xsl:element>
						<xsl:element name="detail">
							<xsl:for-each select="html:td[4]/uci:par">
								<xsl:call-template name="process-para"/>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template name="process-diagnosis-differentials">
		<!-- HAVE REMOVED EMPTY TEST AS NOT WORKING [following-sibling::html:tr[position() = 1 and string-length(normalize-space(.))!=0]] -->
		<xsl:for-each
			select="
			//html:table
			//html:tr
			[.//html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'diagnosis: differential')]
			]
			">
			<xsl:element name="differentials">
				<xsl:for-each select="following-sibling::html:tr[position() &gt; 1 and string-length(normalize-space(.))!=0]">
					<xsl:element name="differential">
						<xsl:if test="html:td[1][string-length(normalize-space(.))!=0]">
							<xsl:attribute name="dx_id" select="replace(html:td[1], '^.*?(\d+).*?$', '$1')"/>
						</xsl:if>
						<xsl:element name="name">
							<xsl:apply-templates select="html:td[2]"/>
						</xsl:element>
						<xsl:element name="sign_symptoms">
							<xsl:for-each select="html:td[3]/uci:par">
								<xsl:call-template name="process-para"/>
							</xsl:for-each>
						</xsl:element>
						<xsl:element name="tests">
							<xsl:for-each select="html:td[4]/uci:par">
								<xsl:call-template name="process-para"/>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template name="process-diagnosis-criteria">
		
		<xsl:for-each
			select="
			//html:table
			//html:tr
			[.//html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'diagnosis: criteria')]]
			">
			<!-- optional -->
			<xsl:if 
				test="
				following-sibling::html:tr[2]
				[string-length(normalize-space(.))!=0]
				">
				<xsl:element name="diagnostic_criteria">
					<xsl:for-each 
						select="
						following-sibling::html:tr[position() &gt; 1]
						[html:td[2][string-length(normalize-space(.))!=0]]
						">
						<xsl:element name="criteria">
							<xsl:element name="title">
								<xsl:apply-templates select="html:td[1]"/>
							</xsl:element>
							<xsl:element name="detail">
								<xsl:for-each select="html:td[2]/(uci:par|uci:list)">
									<xsl:call-template name="process-para"/>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template name="process-diagnosis-screening">
		<!-- optional -->
		<xsl:for-each
			select="
			//html:table
			//html:tr[1]
			[.//html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'diagnosis: screening')]]
			">
			<!-- optional -->
			<xsl:if 
				test="
				following-sibling::html:tr[2]
				[string-length(normalize-space(.))!=0]
				">
				<xsl:element name="screening">
					<xsl:for-each select="following-sibling::html:tr[position() &gt; 1 and string-length(normalize-space(.))!=0]">
						<xsl:element name="section">
							<xsl:call-template name="process-section"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template name="process-treatment-emerging-txs">

		<xsl:for-each
			select="
			//html:table
			//html:tr
			[.//html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'treatment: emerging tx')]]
			">
			<!-- optional -->
			<xsl:if test="following-sibling::html:tr[2][string-length(normalize-space(.))!=0]">
				<xsl:element name="emerging_txs">
					<xsl:for-each 
						select="
						following-sibling::html:tr[position() &gt; 1]
						[string-length(normalize-space(.))!=0]
						">
						<xsl:element name="emerging_tx">
							<xsl:element name="name">
								<xsl:apply-templates select="html:td[1]"/>
							</xsl:element>
							<xsl:element name="detail">
								<xsl:for-each select="html:td[2]/uci:par[string-length(normalize-space(.))!=0]">
									<xsl:apply-templates/>
									<xsl:text> </xsl:text>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>							
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-followup-outlook">
		
		<xsl:element name="outlook">
			<xsl:for-each
				select="
				//html:table
				//html:tr
				[.//html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(., $upper, $lower), 'follow-up: patient outlook')]]
				/following-sibling::html:tr[position() &gt; 1][string-length(normalize-space(.))!=0]
				">
				<xsl:element name="section">
					<xsl:call-template name="process-section"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>

	<xsl:template name="process-followup-complications">
		
		<xsl:for-each
			select="
			//html:table
			//html:tr
			[.//html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'follow-up: complications')]]
			[following-sibling::html:tr[position() = 2 and string-length(normalize-space(.))!=0]]
			">
			<xsl:element name="complications">
				<xsl:for-each select="following-sibling::html:tr[position() &gt; 1 and string-length(normalize-space(.))!=0]">
					<xsl:element name="complication">
						<xsl:if test="html:td[1][string-length(normalize-space(.))!=0]">
							<xsl:attribute name="dx_id" select="replace(html:td[1], '^.*?(\d+).*?$', '$1')"/>
						</xsl:if>
						<xsl:element name="name">
							<xsl:apply-templates select="html:td[2]"/>
						</xsl:element>
						<xsl:element name="likelihood">
							<xsl:choose>
								<xsl:when test="html:td[3][contains(translate(., $upper, $lower), 'high')]">
									<xsl:text>high</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[3][contains(translate(., $upper, $lower), 'medium')]">
									<xsl:text>medium</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[3][contains(translate(., $upper, $lower), 'low')]">
									<xsl:text>low</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="{$warning}"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						<xsl:element name="timeframe">
							<xsl:choose>
								<xsl:when 
									test="html:td[4][contains(translate(., $upper, $lower), 'short')]">
									<xsl:text>short term</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[4][contains(translate(., $upper, $lower), 'long')]">
									<xsl:text>long term</xsl:text>
								</xsl:when>
								<xsl:when test="html:td[4][contains(translate(., $upper, $lower), 'variable')]">
									<xsl:text>variable</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="{$warning}"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						<xsl:element name="detail">
							<xsl:for-each select="html:td[5]/uci:par">
								<xsl:call-template name="process-para"/>
							</xsl:for-each>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-followup-recomendations">
		
		<xsl:for-each
			select="
			//html:table
			[.//html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'follow-up: recommendations')]]
			[
			.//html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'monitoring')
			or contains(translate(., $upper, $lower), 'patient instructions')
			or contains(translate(., $upper, $lower), 'preventive actions')]
			/following-sibling::html:td[1][string-length(normalize-space(.))!=0]
			]
			">
			
			<xsl:element name="recomendations">
				
				<xsl:for-each
					select="
					.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'monitoring')]
					/following-sibling::html:td[1][string-length(normalize-space(.))!=0]
					">
					<xsl:element name="monitoring">
						<xsl:for-each select="uci:par|uci:list">
							<xsl:call-template name="process-para"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:for-each>
			
				<xsl:for-each
					select="
					.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'patient instructions')]
					/following-sibling::html:td[1][string-length(normalize-space(.))!=0]
					">
					<xsl:element name="patient_instructions">
						<xsl:for-each select="uci:par|uci:list">
							<xsl:call-template name="process-para"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:for-each>
			
				<xsl:for-each
					select="
					.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'preventive actions')]
					/following-sibling::html:td[1][string-length(normalize-space(.))!=0]
					">
					<xsl:element name="preventive_actions">
						<xsl:for-each select="uci:par|uci:list">
							<xsl:call-template name="process-para"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:for-each>
			
			</xsl:element>
			
		</xsl:for-each>
		
	</xsl:template>
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:html="http://www.w3.org/HTML/1998/html4"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal">
	

	<xsl:template name="process-treatment-tx-options">

		<xsl:element name="tx_options">
			<xsl:for-each
				select="
				//html:table
				[.//html:td
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(., $upper, $lower), 'treatment: tx options')]]
				">
				<xsl:call-template name="process-tx-option"/>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-tx-option">
		
		<xsl:variable name="current-tx-option-id" select="generate-id(.)"/>
	
		<xsl:variable name="timeframe" 
			select="
			translate(normalize-space(
				.//html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(uci:par[1], $upper, $lower), 'timeframe')]
				/following-sibling::html:td[1]
			), $upper, $lower)
			"/>
		
		<xsl:variable name="patient-group-name" 
			select="
			translate(normalize-space(
				.//html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(uci:par[1], $upper, $lower), 'patient group')]
				/following-sibling::html:td[1]
				), $upper, $lower)
			"/>
		
		<!-- set to true if current tx_option is parent / heading group with tx_option children -->
		<xsl:variable name="parent-pt-group-current-is-true">
			<xsl:choose>
				<xsl:when 
					test="
					//html:table
					[.//html:td
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'treatment: tx options')]]
					[generate-id(.)!=$current-tx-option-id]
					
					[.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(uci:par[1], $upper, $lower), 'parent pt group')]
					/following-sibling::html:td[1]
					[translate(normalize-space(.), $upper, $lower) = $patient-group-name]
					
					and .//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(uci:par[1], $upper, $lower), 'timeframe')]
					/following-sibling::html:td[1]
					[translate(normalize-space(.), $upper, $lower) = $timeframe]]
					">
					<xsl:text>true</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>false</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$parent-pt-group-current-is-true = 'true'">
				<xsl:comment>
					<xsl:text>parent-pt-group </xsl:text>
					<xsl:value-of select="$current-tx-option-id"/>
				</xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>
					<xsl:text>patient-group </xsl:text>
					<xsl:value-of select="$current-tx-option-id"/>
				</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:element name="tx_option">
			
			<xsl:element name="timeframe">
				<xsl:for-each 
					select="
					.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(uci:par[1], $upper, $lower), 'timeframe')]
					/following-sibling::html:td[1]
					">
					<xsl:choose>
						<xsl:when test="contains(translate(., $upper, $lower), 'acute')">
							<xsl:text>acute</xsl:text>
						</xsl:when>
						<xsl:when test="contains(translate(., $upper, $lower), 'ongoing')">
							<xsl:text>ongoing</xsl:text>
						</xsl:when>
						<xsl:when test="contains(translate(., $upper, $lower), 'presumptive')">
							<xsl:text>presumptive</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="{$warning}"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
			
			<xsl:element name="pt_group">
				<xsl:for-each select=".//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(uci:par[1], $upper, $lower), 'patient group')]
					/following-sibling::html:td[1]
					/uci:par[string-length(normalize-space(.))!=0]">
					<xsl:apply-templates/>
					<xsl:if test="position()!=last()">
						<xsl:text disable-output-escaping="yes"> </xsl:text>	
					</xsl:if>
				</xsl:for-each>
			</xsl:element>
			
			<!-- parent_pt_group -->
			<xsl:for-each 
				select="
				.//html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(uci:par[1], $upper, $lower), 'parent pt group')]
				/following-sibling::html:td[1]
				">
				<xsl:choose>
					<xsl:when test="string-length(normalize-space(.))!=0 and $parent-pt-group-current-is-true = 'false'">
						
						<xsl:variable name="parent-pt-group-target" select="normalize-space(.)"/>
						
						<xsl:for-each 
							select="
							//html:table
							[.//html:td
							[contains(@uci:diffStyle, 'background-color')]
							[contains(translate(., $upper, $lower), 'treatment: tx options')]]
							[generate-id(.)!=$current-tx-option-id]
							
							[.//html:td[1]
							[contains(@uci:diffStyle, 'background-color')]
							[contains(translate(uci:par[1], $upper, $lower), 'patient group')]
							/following-sibling::html:td[1]
							[normalize-space(.)=$parent-pt-group-target]
							
							and .//html:td[1]
							[contains(@uci:diffStyle, 'background-color')]
							[contains(translate(uci:par[1], $upper, $lower), 'timeframe')]
							/following-sibling::html:td[1]
							[translate(normalize-space(.), $upper, $lower) = translate(normalize-space($timeframe), $upper, $lower)]]
							">
							<xsl:comment>
								<xsl:text>target </xsl:text>
								<xsl:value-of select="generate-id(.)"/>
							</xsl:comment>
						</xsl:for-each>
						
						<!--<xsl:variable name="parent-tx-option-id" 
							select="
							
							//html:table
							[.//html:td
							[contains(@uci:diffStyle, 'background-color')]
							[contains(translate(., $upper, $lower), 'treatment: tx options')]]
							[generate-id(.)!=$current-tx-option-id]
							
							[.//html:td[1]
							[contains(@uci:diffStyle, 'background-color')]
							[contains(translate(uci:par[1], $upper, $lower), 'patient group')]
							/following-sibling::html:td[1]
							[normalize-space(.)=$parent-pt-group-target]
							
							and .//html:td[1]
							[contains(@uci:diffStyle, 'background-color')]
							[contains(translate(uci:par[1], $upper, $lower), 'timeframe')]
							/following-sibling::html:td[1]
							[translate(normalize-space(.), $upper, $lower) = translate(normalize-space($timeframe), $upper, $lower)]]
							)
							"/>
							<xsl:comment select="$parent-tx-option-id"/>-->
						
						<xsl:choose>
							<!-- current tx-option parent_pt_group _does_ match against patient_group in another tx-option -->
							<xsl:when 
								test="
								//html:table
								[.//html:td
								[contains(@uci:diffStyle, 'background-color')]
								[contains(translate(., $upper, $lower), 'treatment: tx options')]]
								[generate-id(.)!=$current-tx-option-id]
								//html:td[1]
								[contains(@uci:diffStyle, 'background-color')]
								[contains(translate(uci:par[1], $upper, $lower), 'patient group')]
								/following-sibling::html:td[1]
								[normalize-space(.)=$parent-pt-group-target]
								">
								
								<xsl:choose>
									
									<!-- current tx-option _does_ match parent_pt_group against patient_group in another tx-option 
										and current tx-option _does_ match timeframe against timeframe in another tx-option -->
									<xsl:when 
										test="
										//html:table
										[.//html:td
										[contains(@uci:diffStyle, 'background-color')]
										[contains(translate(., $upper, $lower), 'treatment: tx options')]]
										[generate-id(.)!=$current-tx-option-id]
										//html:td[1]
										[contains(@uci:diffStyle, 'background-color')]
										[contains(translate(uci:par[1], $upper, $lower), 'timeframe')]
										/following-sibling::html:td[1]
										[translate(normalize-space(.), $upper, $lower) = translate(normalize-space($timeframe), $upper, $lower)]
										">
										<xsl:element name="parent_pt_group">
											<xsl:apply-templates/>
										</xsl:element>
									</xsl:when>
									
									<!-- current tx-option parent_pt_group _does not_ match against patient_group in another tx-option 
										and current tx-option _does not_ match timeframe against timeframe in another tx-option -->
									<xsl:otherwise>
										<xsl:element name="{$warning}">
											<xsl:text>timeframe for treatment option parent patient group '</xsl:text>
											<xsl:value-of select="normalize-space(.)"/>
											<xsl:text>' has not been matched</xsl:text>
										</xsl:element>
										<xsl:element name="parent_pt_group">
											<xsl:apply-templates/>
										</xsl:element>
									</xsl:otherwise>
									
								</xsl:choose>
							</xsl:when>
							
							<!-- current tx-option parent_pt_group _does not_ match against patient_group in another tx-option -->
							<xsl:otherwise>
								
								<xsl:element name="{$warning}">
									<xsl:text>treatment option parent patient group '</xsl:text>
									<xsl:value-of select="normalize-space(.)"/>
									<xsl:text>' has not been matched</xsl:text>
								</xsl:element>
								<xsl:element name="parent_pt_group">
									<xsl:apply-templates/>
								</xsl:element>
								
							</xsl:otherwise>
							
						</xsl:choose>
					</xsl:when>
					
					<!-- current tx-option is selected as parent-patient-group -->
					<!--<xsl:when test="string-length(normalize-space(.))!=0 and $parent-pt-group-current-is-true = 'true'">
						<xsl:element name="{$warning}">
							<xsl:text>element should be empty if current tx_option is selected as parent_pt_group</xsl:text>
						</xsl:element>
						<xsl:element name="parent_pt_group">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>-->
					
				</xsl:choose>
				
			</xsl:for-each>
			
			<xsl:for-each 
				select="
				.//html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(uci:par[1], $upper, $lower), '(line)')
				or contains(translate(uci:par[1], $upper, $lower), 'tx type tier')]
				/following-sibling::html:td[1]
				">
				<xsl:choose>
					<!--<xsl:when test="string-length(normalize-space(.))!=0 and $parent-pt-group-current-is-true = 'true'">
						<xsl:element name="{$warning}">
							<xsl:text>element should be empty if current tx_option is selected as parent_pt_group</xsl:text>
						</xsl:element>
						<xsl:element name="tx_line">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:element>
					</xsl:when>-->
					<xsl:when test="contains(., '1')">
						<xsl:element name="tx_line">
							<xsl:text>1</xsl:text>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains(., '2')">
						<xsl:element name="tx_line">
							<xsl:text>2</xsl:text>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains(., '3')">
						<xsl:element name="tx_line">
							<xsl:text>3</xsl:text>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains(., '4')">
						<xsl:element name="tx_line">
							<xsl:text>4</xsl:text>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains(., '5')">
						<xsl:element name="tx_line">
							<xsl:text>5</xsl:text>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains(., '6')">
						<xsl:element name="tx_line">
							<xsl:text>6</xsl:text>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains(., '7')">
						<xsl:element name="tx_line">
							<xsl:text>7</xsl:text>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains(., '8')">
						<xsl:element name="tx_line">
							<xsl:text>8</xsl:text>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains(., '9')">
						<xsl:element name="tx_line">
							<xsl:text>9</xsl:text>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains(translate(., $upper, $lower), 'a')">
						<xsl:element name="tx_line">
							<xsl:text>A</xsl:text>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains(translate(., $upper, $lower), 'p')">
						<xsl:element name="tx_line">
							<xsl:text>P</xsl:text>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="tx_line">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			
			<!-- tx_type -->
			<xsl:for-each 
				select="
				.//html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(uci:par[1], $upper, $lower), 'treatment type')]
				/following-sibling::html:td[1]
				">
				<xsl:choose>
					<!--<xsl:when test="string-length(normalize-space(.))!=0 and $parent-pt-group-current-is-true = 'true'">
						<xsl:element name="{$warning}">
							<xsl:text>element should be empty if current tx_option is selected as parent_pt_group</xsl:text>
						</xsl:element>
						<xsl:element name="tx_type">
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:element>
					</xsl:when>-->
					<xsl:when test="string-length(normalize-space(.))=0 and $parent-pt-group-current-is-true = 'true'">
						<!-- do nothing -->
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="tx_type">
							<xsl:apply-templates/>
							<!--
								<xsl:choose>
								<xsl:when test="string-length(normalize-space(.))!=0">
								<xsl:apply-templates/>
								</xsl:when>
								<xsl:otherwise>
								<xsl:element name="{$warning}"/>
								</xsl:otherwise>
								</xsl:choose>	
							-->
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			
			<!-- comments -->
			<xsl:for-each 
				select="
				.//html:tr
				[html:td
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(., $upper, $lower), 'comments')]][1]
				">
				<xsl:if 
					test="
					following-sibling::html:tr[1]
					/html:td[position()=last()][string-length(normalize-space(.))!=0]
					">
					<!--<xsl:choose>
						<xsl:when test="$parent-pt-group-current-is-true = 'true'">
							<xsl:element name="comments">
								<xsl:element name="{$warning}">
									<xsl:text>element should be empty if current tx_option is selected as parent_pt_group</xsl:text>
								</xsl:element>
								<xsl:for-each select="following-sibling::html:tr[1]/html:td[position()=last()]/uci:par">
									<xsl:call-template name="process-para"/>							
								</xsl:for-each>
							</xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="comments">
								<xsl:for-each select="following-sibling::html:tr[1]/html:td[position()=last()]/uci:par">
									<xsl:call-template name="process-para"/>							
								</xsl:for-each>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>-->
					<xsl:element name="comments">
						<xsl:for-each select="following-sibling::html:tr[1]/html:td[position()=last()]/uci:par">
							<xsl:call-template name="process-para"/>							
						</xsl:for-each>
					</xsl:element>
				</xsl:if>
			</xsl:for-each>
			
			<xsl:call-template name="process-regimens"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-regimens">
		
		<!-- optional -->
		<xsl:if 
			test="
			.//html:tr
			[html:td
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'treatments regimens')]]
			/following-sibling::html:tr[2][string-length(normalize-space(.))!=0]
			">
			
			<xsl:element name="regimens">
				
				<!-- fix: need a better test for starting row to avoid error -->
				<xsl:for-each 
					select="
					.//html:tr
					[html:td
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'treatments regimens')]]
					/following-sibling::html:tr[position() &gt; 1]
					">
					
					<!-- annoyingly some rtf/xml is creating a first blank column 
						so we create column-expand variable to manage the unexpected first blank column -->
					<xsl:variable name="column-expand" select="count(html:td) - 7"/>
					
					<!-- FIX: do we need to test all row not just one column to avoid missing data ?? --> 
					<xsl:if test="string-length(normalize-space(html:td[$column-expand+1]))!=0">
						
						<!-- *open regimen* with disable-output-escaping -->
						<xsl:choose>
							
							<!-- if first regimen row   
								or tier value in a preceding row _does not_ match current row -->
							<xsl:when 
								test="
								position() = 1
								or normalize-space(html:td[$column-expand+1]) != normalize-space(preceding-sibling::html:tr[1]/html:td[$column-expand+1])
								">
								<xsl:text disable-output-escaping="yes">&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;&lt;regimen tier="</xsl:text>
								<xsl:choose>
									<xsl:when test="string-length(normalize-space(html:td[$column-expand+1]))!=0">
										<xsl:value-of select="normalize-space(html:td[$column-expand+1])"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>1</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
								<xsl:if test="html:td[$column-expand+3][string-length(normalize-space(.))!=0]">
									<xsl:element name="regimen_name">
										<xsl:value-of select="html:td[$column-expand+3]"/>
									</xsl:element>
								</xsl:if>
							</xsl:when>
							
							<!-- if _not_ first regimen row 
								and (tier value in preceding row _does_ match current row  
								and modifier value in preceding row _does not_ match current row) -->
							<xsl:when 
								test="
								position() != 1
								and (normalize-space(html:td[$column-expand+1]) = normalize-space(preceding-sibling::html:tr[1]/html:td[$column-expand+1])
								and normalize-space(html:td[$column-expand+2]) != normalize-space(preceding-sibling::html:tr[1]/html:td[$column-expand+2]))
								">
								<xsl:text disable-output-escaping="yes">&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;&lt;regimen tier="</xsl:text>
								<xsl:choose>
									<xsl:when test="string-length(normalize-space(html:td[$column-expand+1]))!=0">
										<xsl:value-of select="normalize-space(html:td[$column-expand+1])"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>1</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
								<xsl:if test="html:td[$column-expand+3][string-length(normalize-space(.))!=0]">
									<xsl:element name="regimen_name">
										<xsl:value-of select="html:td[$column-expand+3]"/>
									</xsl:element>
								</xsl:if>
							</xsl:when>
							
						</xsl:choose>
						
						<!-- *open components* with disable-output-escaping -->
						<xsl:choose>
							
							<!-- if first regimen row 
								or (tier value in preceding row _does not_ match current row -->   
							<xsl:when
								test="
								position() = 1
								or normalize-space(html:td[$column-expand+1]) != normalize-space(preceding-sibling::html:tr[1]/html:td[$column-expand+1])
								">
								<xsl:text disable-output-escaping="yes">&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;&lt;components&gt;&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
							</xsl:when>
							
							<!-- if _not_ first regimen row 
								and (tier value in preceding row _does_ match current row 
								and modifier entry in preceding row _does not_ match current row -->
							<xsl:when
								test="
								position() != 1
								and (normalize-space(html:td[$column-expand+1]) = normalize-space(preceding-sibling::html:tr[1]/html:td[$column-expand+1])
								and normalize-space(html:td[$column-expand+2]) != normalize-space(preceding-sibling::html:tr[1]/html:td[$column-expand+2]))
								">
								<xsl:text disable-output-escaping="yes">&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;&lt;components&gt;&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
							</xsl:when>
							
							<!-- *open componets* group 
								if _not_ first regimen row 
								and modifier value in preceding row _does_ match 'AND' or 'OR' -->
							<!--<xsl:when 
								test="
								position() != 1
								and preceding-sibling::html:tr[1]/html:td[$column-expand+7]
								[contains(., 'AND') or contains(., 'OR')]
								">
								<xsl:text disable-output-escaping="yes">&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;&lt;components&gt;&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
								</xsl:when>-->
							
						</xsl:choose>
						
						<!-- *component* for each row -->
						<xsl:element name="component">
							<xsl:choose>
								<xsl:when test="html:td[$column-expand+7][contains(normalize-space(.), 'and/or')]">
									<xsl:attribute name="modifier">
										<xsl:text>and/or</xsl:text>
									</xsl:attribute>
								</xsl:when>
								<xsl:when test="html:td[$column-expand+7][contains(normalize-space(.), 'AND/OR')]">
									<xsl:attribute name="modifier">
										<xsl:text>AND/OR</xsl:text>
									</xsl:attribute>
								</xsl:when>
								<xsl:when test="html:td[$column-expand+7][contains(normalize-space(.), 'AND')]">
									<xsl:attribute name="modifier">
										<xsl:text>AND</xsl:text>
									</xsl:attribute>
								</xsl:when>
								<xsl:when test="html:td[$column-expand+7][contains(normalize-space(.), 'and')]">
									<xsl:attribute name="modifier">
										<xsl:text>and</xsl:text>
									</xsl:attribute>
								</xsl:when>
								<xsl:when test="html:td[$column-expand+7][contains(translate(normalize-space(.), $upper, $lower), 'or')]">
									<xsl:attribute name="modifier">
										<xsl:text>or</xsl:text>
									</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<!--<xsl:attribute name="modifier">
										<xsl:text>or</xsl:text>
									</xsl:attribute>-->
								</xsl:otherwise>
							</xsl:choose>
							
							<xsl:element name="name">
								<xsl:value-of select="html:td[$column-expand+4]"/>
							</xsl:element>
							<xsl:if test="html:td[$column-expand+5][string-length(normalize-space(.))!=0]">
								<xsl:element name="details">
									<xsl:value-of select="html:td[$column-expand+5]"/>
								</xsl:element>
							</xsl:if>
							<xsl:if test="html:td[$column-expand+6][string-length(normalize-space(.))!=0]">
								<xsl:if test="$debug='true'">
									<xsl:comment>DEBUG comments tag</xsl:comment>
								</xsl:if>
								<xsl:element name="comments">
									<xsl:for-each select="html:td[$column-expand+6]/uci:par">
										<xsl:call-template name="process-para"/>
									</xsl:for-each>
								</xsl:element>
							</xsl:if>
							
						</xsl:element>
						
						<!-- *close components* with disable-output-escaping -->
						<xsl:choose>
							
							<!-- if last regimen row 
								or tier value in following row _does not_ match current row -->
							<xsl:when
								test="
								position() = last()
								or normalize-space(html:td[$column-expand+1]) != normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+1])
								">
								<xsl:text disable-output-escaping="yes">&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;&lt;/components&gt;</xsl:text>
							</xsl:when>
							
							<!-- if _not_ last regimen row 
								and (tier value in following row _does_ match current row  
								and regimen-group value in following row _does not_ match current row) -->
							<xsl:when
								test="
								position() != last()
								and (normalize-space(html:td[$column-expand+1]) = normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+1])
								and normalize-space(html:td[$column-expand+2]) != normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+2]))
								">
								<xsl:text disable-output-escaping="yes">&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;&lt;/components&gt;</xsl:text>
							</xsl:when>
							
						</xsl:choose>
						
						<!-- *close componets* nested group 
							if combined test true for
							modifier value in any preceding row _does_ match 'AND' or 'OR'
							and any preceding row _does not_ match 'modifier' (is not header row)
							
							and (tier value in any preceding row _does_ match current row 
							and regimen-group entry in any preceding row _does_ match current row)
							
							and ((tier value in following row _does not_ match current row
							or position is last row)
							
							or (tier value in following row _does_ match current row
							and regimen-group value in following row _does not_ match current row)
							or position is last row)))
						-->
						<!--<xsl:if 
							test="
							preceding-sibling::html:tr/html:td[$column-expand+7]
							[contains(., 'AND') or contains(., 'OR')]
							[not(contains(translate(., $upper, $lower), 'modifier'))]
							
							and (html:td[$column-expand+1] = preceding-sibling::html:tr/html:td[$column-expand+1]
							and html:td[$column-expand+2] = preceding-sibling::html:tr/html:td[$column-expand+2])
							
							and ((html:td[$column-expand+1] != following-sibling::html:tr[1]/html:td[$column-expand+1]
							or position() = last())
							
							or (html:td[$column-expand+1] = following-sibling::html:tr[1]/html:td[$column-expand+1]
							and html:td[$column-expand+2] != following-sibling::html:tr[1]/html:td[$column-expand+2]
							or position() = last()))
							">
							<xsl:text disable-output-escaping="yes">&#13;&#x9;&lt;/components&gt;&#13;&#x9;</xsl:text>
							</xsl:if>-->
						
						<!-- *close regimen* with disable-output-escaping -->
						<xsl:choose>
							
							<!-- if last regimen row 
								or tier value in following row _does not_ match current row -->   
							<xsl:when
								test="
								position() = last()
								or normalize-space(html:td[$column-expand+1]) != normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+1])
								">
								<xsl:text disable-output-escaping="yes">&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;&lt;/regimen&gt;&#13;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
							</xsl:when>
							
							<!-- if _not_ last regimen row 
								and (tier value in following row _does_ match current row
								and regimen-group value in following row _does not_ match current row) -->
							<xsl:when
								test="
								position() != last()
								and (normalize-space(html:td[$column-expand+1]) = normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+1])
								and normalize-space(html:td[$column-expand+2]) != normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+2]))
								">
								<xsl:text disable-output-escaping="yes">&#13;&#x9;&#x9;&#x9;&#x9;&#x9;&#x9;&lt;/regimen&gt;&#13;&#x9;&#x9;&#x9;&#x9;&#x9;</xsl:text>
							</xsl:when>
							
						</xsl:choose>
						
					</xsl:if>
					
				</xsl:for-each>
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<!-- template archived as schema reverted back to managing row information to flat xml grouping -->
	<xsl:template name="process-regimens-grouped">
		
		<xsl:element name="regimens">
			
			<!-- fix: need a better test for starting row to avoid error -->
			<xsl:for-each 
				select="
				.//html:tr
					[html:td
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(., $upper, $lower), 'treatments regimens')]]
				/following-sibling::html:tr[position() &gt; 1]
				">
				
				<xsl:if test="matches(html:td[1], '^[0-9a-z]+$') = false()">
					<xsl:element name="{$warning}">
						<xsl:text>avoid white space in tier and regimen-group columns</xsl:text>
					</xsl:element>
				</xsl:if>
				
				<!-- annoyingly some rtf/xml is creating a first blank column 
					so we create column-expand variable to manage the unexpected first blank column -->
				<xsl:variable name="column-expand" select="count(html:td) - 7"/>
				
				<!-- *open regimen* with disable-output-escaping -->
				<xsl:choose>
					
					<!-- if first regimen row   
						or tier value in a preceding row _does not_ match current row -->
					<xsl:when 
						test="
						position() = 1
						or html:td[$column-expand+1] != preceding-sibling::html:tr[1]/html:td[$column-expand+1]
						">
						<xsl:text disable-output-escaping="yes">
							&lt;regimen tier="</xsl:text>
						<xsl:value-of select="html:td[$column-expand+1]"/>
						<xsl:text disable-output-escaping="yes">"&gt;
						</xsl:text>
						<xsl:if test="html:td[$column-expand+3][string-length(normalize-space(.))!=0]">
							<xsl:element name="regimen_name">
								<xsl:value-of select="html:td[$column-expand+3]"/>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					
					<!-- if _not_ first regimen row 
						and (tier value in preceding row _does_ match current row  
						and modifier value in preceding row _does not_ match current row) -->
					<xsl:when 
						test="
						position() != 1
						and (normalize-space(html:td[$column-expand+1]) = normalize-space(preceding-sibling::html:tr[1]/html:td[$column-expand+1])
						and normalize-space(html:td[$column-expand+2]) != normalize-space(preceding-sibling::html:tr[1]/html:td[$column-expand+2]))
						">
						<xsl:text disable-output-escaping="yes">
							&lt;regimen tier="</xsl:text>
						<xsl:value-of select="html:td[$column-expand+1]"/>
						<xsl:text disable-output-escaping="yes">"&gt;
						</xsl:text>
						<xsl:if test="html:td[$column-expand+3][string-length(normalize-space(.))!=0]">
							<xsl:element name="regimen_name">
								<xsl:value-of select="html:td[$column-expand+3]"/>
							</xsl:element>
						</xsl:if>
					</xsl:when>
					
				</xsl:choose>
				
				<!-- *open components* with disable-output-escaping -->
				<xsl:choose>
					
					<!-- if first regimen row 
						or (tier value in preceding row _does not_ match current row -->   
					<xsl:when
						test="
						position() = 1
						or normalize-space(html:td[$column-expand+1]) != normalize-space(preceding-sibling::html:tr[1]/html:td[$column-expand+1])
						">
						<xsl:text disable-output-escaping="yes">
							&lt;components modifier="</xsl:text>
						<xsl:choose>
							<xsl:when test="html:td[$column-expand+7][contains(., 'and/or')]">
								<xsl:text>and/or</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[$column-expand+7][contains(., 'AND')]">
								<xsl:text>AND</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[$column-expand+7][contains(., 'OR')]">
								<xsl:text>OR</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[$column-expand+7][contains(., 'and')]">
								<xsl:text>and</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[$column-expand+7][contains(., 'or')]">
								<xsl:text>or</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>or</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text disable-output-escaping="yes">"&gt;
						</xsl:text>
					</xsl:when>
					
					<!-- if _not_ first regimen row 
						and (tier value in preceding row _does_ match current row 
						and modifier entry in preceding row _does not_ match current row -->
					<xsl:when
						test="
						position() != 1
						and (normalize-space(html:td[$column-expand+1]) = normalize-space(preceding-sibling::html:tr[1]/html:td[$column-expand+1])
						and normalize-space(html:td[$column-expand+2]) != normalize-space(preceding-sibling::html:tr[1]/html:td[$column-expand+2]))
						">
						<xsl:text disable-output-escaping="yes">
							&lt;components modifier="</xsl:text>
						<xsl:choose>
							<xsl:when test="html:td[$column-expand+7][contains(., 'and/or')]">
								<xsl:text>and/or</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[$column-expand+7][contains(., 'AND')]">
								<xsl:text>AND</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[$column-expand+7][contains(., 'OR')]">
								<xsl:text>OR</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[$column-expand+7][contains(., 'and')]">
								<xsl:text>and</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[$column-expand+7][contains(., 'or')]">
								<xsl:text>or</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>or</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text disable-output-escaping="yes">"&gt;
						</xsl:text>
					</xsl:when>
					
					<!-- *open componets* group 
						if _not_ first regimen row 
						and modifier value in preceding row _does_ match 'AND' or 'OR' -->
					<xsl:when 
						test="
						position() != 1
						and preceding-sibling::html:tr[1]/html:td[$column-expand+7]
						[contains(., 'AND') or contains(., 'OR')]
						">
						<xsl:text disable-output-escaping="yes">
							&lt;components modifier="</xsl:text>
						<xsl:choose>
							<xsl:when test="html:td[$column-expand+7][contains(., 'and/or')]">
								<xsl:text>and/or</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[$column-expand+7][contains(., 'AND')]">
								<xsl:text>AND</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[$column-expand+7][contains(., 'OR')]">
								<xsl:text>OR</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[$column-expand+7][contains(., 'and')]">
								<xsl:text>and</xsl:text>
							</xsl:when>
							<xsl:when test="html:td[$column-expand+7][contains(., 'or')]">
								<xsl:text>or</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>or</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text disable-output-escaping="yes">"&gt;
						</xsl:text>
					</xsl:when>
					
				</xsl:choose>
				
				<!-- *component* for each row -->
				<xsl:element name="component">
					<xsl:element name="name">
						<xsl:value-of select="html:td[$column-expand+4]"/>
					</xsl:element>
					<xsl:element name="details">
						<xsl:value-of select="html:td[$column-expand+5]"/>
					</xsl:element>
					<xsl:element name="comments">
						<xsl:for-each select="html:td[$column-expand+6]/uci:par">
							<xsl:call-template name="process-para"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
				
				<!-- *close components* with disable-output-escaping -->
				<xsl:choose>
					
					<!-- if last regimen row 
						or tier value in following row _does not_ match current row -->
					<xsl:when
						test="
						position() = last()
						or normalize-space(html:td[$column-expand+1]) != normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+1])
						">
						<xsl:text disable-output-escaping="yes">
							&lt;/components&gt;
						</xsl:text>
					</xsl:when>
					
					<!-- if _not_ last regimen row 
						and (tier value in following row _does_ match current row  
						and regimen-group value in following row _does not_ match current row) -->
					<xsl:when
						test="
						position() != last()
						and (normalize-space(html:td[$column-expand+1]) = normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+1])
						and normalize-space(html:td[$column-expand+2]) != normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+2]))
						">
						<xsl:text disable-output-escaping="yes">
							&lt;/components&gt;
						</xsl:text>
					</xsl:when>
					
				</xsl:choose>
				
				<!-- *close componets* nested group 
					if combined test true for
					modifier value in any preceding row _does_ match 'AND' or 'OR'
					and any preceding row _does not_ match 'modifier' (is not header row)
					
					and (tier value in any preceding row _does_ match current row 
					and regimen-group entry in any preceding row _does_ match current row)
					
					and ((tier value in following row _does not_ match current row
					or position is last row)
					
					or (tier value in following row _does_ match current row
					and regimen-group value in following row _does not_ match current row)
					or position is last row)))
				-->
				<xsl:if 
					test="
					preceding-sibling::html:tr/html:td[$column-expand+7]
					[contains(., 'AND') or contains(., 'OR')]
					[not(contains(translate(., $upper, $lower), 'modifier'))]
					
					and (normalize-space(html:td[$column-expand+1]) = normalize-space(preceding-sibling::html:tr/html:td[$column-expand+1])
					and normalize-space(html:td[$column-expand+2]) = normalize-space(preceding-sibling::html:tr/html:td[$column-expand+2]))
					
					and ((normalize-space(html:td[$column-expand+1]) != normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+1])
					or position() = last())
					
					or (normalize-space(html:td[$column-expand+1]) = normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+1])
					and normalize-space(html:td[$column-expand+2]) != normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+2])
					or position() = last()))
					">
					<xsl:text disable-output-escaping="yes">
						&lt;/components&gt;
					</xsl:text>
				</xsl:if>
				
				<!-- *close regimen* with disable-output-escaping -->
				<xsl:choose>
					
					<!-- if last regimen row 
						or tier value in following row _does not_ match current row -->   
					<xsl:when
						test="
						position() = last()
						or normalize-space(html:td[$column-expand+1]) != normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+1])
						">
						<xsl:text disable-output-escaping="yes">
							&lt;/regimen&gt;
						</xsl:text>
					</xsl:when>
					
					<!-- if _not_ last regimen row 
						and (tier value in following row _does_ match current row
						and regimen-group value in following row _does not_ match current row) -->
					<xsl:when
						test="
						position() != last()
						and (normalize-space(html:td[$column-expand+1]) = normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+1])
						and normalize-space(html:td[$column-expand+2]) != normalize-space(following-sibling::html:tr[1]/html:td[$column-expand+2]))
						">
						<xsl:text disable-output-escaping="yes">
							&lt;/regimen&gt;
						</xsl:text>
					</xsl:when>
					
				</xsl:choose>
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:html="http://www.w3.org/HTML/1998/html4"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal"
	exclude-result-prefixes="html uci">

	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"
		use-character-maps="poc-custom-character-map isolat1-hexadecimal-character-entity-map"/>
	
	<xsl:include href="../../../xsl-entities/custom-map-point-of-care.xsl"/>
	<xsl:include href="../../../generic-params.xsl"/>
	<xsl:include href="../generic-rtf-params.xsl"/>
	<xsl:include href="monograph-default-elements.xsl"/>
	<xsl:include href="monograph-shared.xsl"/>
	<xsl:include href="monograph-overview.xsl"/>
	<xsl:include href="monograph-evaluation.xsl"/>
	<xsl:include href="monograph-standard.xsl"/>
	<xsl:include href="monograph-generic.xsl"/>
	
	<xsl:param name="filename"/>

	<xsl:template match="/">
		
		<xsl:element name="monographs">
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">
				<xsl:text>http://schemas.epocrates.com/schemas/newdx_v1_6.xsd</xsl:text>
			</xsl:attribute>
			
			<xsl:choose>
				<xsl:when 
					test="
					//html:table
					//html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(., $upper, $lower), 'monograph title')]
					/following-sibling::html:td[1]
						[contains(translate(., $upper, $lower), 'overview')]
					">
					<xsl:call-template name="process-monograph-overview"/>
				</xsl:when>
				<xsl:when 
					test="
					//html:table
					//html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(., $upper, $lower), 'monograph title')]
					/following-sibling::html:td[1]
						[contains(translate(., $upper, $lower), 'evaluation')]
					">
					<xsl:call-template name="process-monograph-evaluation"/>
				</xsl:when>
				<xsl:when 
					test="
					//html:table
					//html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(., $upper, $lower), 'monograph title')]
					/following-sibling::html:td[1]
						[contains(translate(., $upper, $lower), 'generic')]
					">
					<xsl:call-template name="process-monograph-generic"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="process-monograph-standard"/>
				</xsl:otherwise>
				
			</xsl:choose>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-info">
		
		<xsl:call-template name="process-mogograph-info"/>
		<xsl:call-template name="process-topic-synonyms"/>
		<xsl:call-template name="process-related-topics"/>
		<!--<xsl:call-template name="process-statistics"/>-->
		<xsl:element name="references">
			<xsl:call-template name="process-article-refs"/>
			<xsl:call-template name="process-online-refs"/>
			<xsl:call-template name="process-clinical-refs"/>
			<xsl:call-template name="process-image-refs"/>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-mogograph-info">
		
		<xsl:for-each
			select="
			//html:table
				[.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'monograph title')]]
			">
			
			<!-- fix: test if id is integer -->
			<xsl:if 
				test="
				replace(
					.//html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(., $upper, $lower), 'dx id')]
					/following-sibling::html:td[1]
					, '^.*?(\d+).*?$', '$1')
				">
				<xsl:attribute name="dx_id"
					select="
					replace(
						.//html:td[1]
							[contains(@uci:diffStyle, 'background-color')]
							[contains(translate(., $upper, $lower), 'dx id')]
						/following-sibling::html:td[1]
						, '^.*?(\d+).*?$', '$1')
					"/>				
			</xsl:if>
			
			<!-- fix: test if id matches filename id -->
			<xsl:if 
				test="
				replace(
				.//html:td[1]
				[contains(@uci:diffStyle, 'background-color')]
				[contains(translate(., $upper, $lower), 'dx id')]
				/following-sibling::html:td[1]
				, '^.*?(\d+).*?$', '$1')
				!= 
				replace(
				$filename
				, '^(\d+)_.*?$', '$1')
				">
				<xsl:element name="{$warning}">
					<xsl:text>monograph id </xsl:text>
					<xsl:value-of 
						select="
						replace(
						.//html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(., $upper, $lower), 'dx id')]
						/following-sibling::html:td[1]
						, '^.*?(\d+).*?$', '$1')
						"/>
					<xsl:text> does not match filename id </xsl:text>
					<xsl:value-of 
						select="
						replace(
						$filename
						, '^(\d+)_.*?$', '$1')
						"/>
				</xsl:element>
			</xsl:if>
			
			<xsl:element name="title">
				<xsl:apply-templates 
					select="
					.//html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(., $upper, $lower), 'monograph title')]
					/following-sibling::html:td[1]
					"/>
			</xsl:element>
			
			<xsl:element name="authors">
				<xsl:for-each
					select="
					.//html:td
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'author')]
					[following-sibling::html:td[position() = 1 and string-length(normalize-space(.))!=0]]
					">
					<!--x-->
						<xsl:for-each select="ancestor::html:tr[1]">
							<xsl:element name="author">
								<xsl:call-template name="process-person">
									<xsl:with-param name="disclosures">true</xsl:with-param>
									<xsl:with-param name="photo">true</xsl:with-param>
								</xsl:call-template>
							</xsl:element>
						</xsl:for-each>
				</xsl:for-each>
			</xsl:element>
		
			<xsl:element name="peer_reviewers">
				<xsl:for-each
					select="
					.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'peer reviewer') or contains(translate(., $upper, $lower), 'expert')]
					[following-sibling::html:td[position() = 1 and string-length(normalize-space(.))!=0]]
					">
					<!--x-->
						<xsl:for-each select="ancestor::html:tr[1]">
							<xsl:element name="peer_reviewer">
								<xsl:call-template name="process-person">
									<xsl:with-param name="disclosures">true</xsl:with-param>
									<xsl:with-param name="photo">false</xsl:with-param>
								</xsl:call-template>
							</xsl:element>
						</xsl:for-each>
				</xsl:for-each>
			</xsl:element>
			
			<xsl:comment>
				<xsl:element name="editors">
					<xsl:for-each
						select="
						.//html:td[1]
						[contains(@uci:diffStyle, 'background-color')]
						[contains(translate(., $upper, $lower), 'editor')]
						[following-sibling::html:td[position() = 1 and string-length(normalize-space(.))!=0]]
						">
						<xsl:for-each select="ancestor::html:tr[1]">
							<xsl:element name="editor">
								<xsl:call-template name="process-person">
									<xsl:with-param name="disclosures">false</xsl:with-param>
									<xsl:with-param name="photo">false</xsl:with-param>
								</xsl:call-template>
							</xsl:element>
						</xsl:for-each>
					</xsl:for-each>
				</xsl:element>
			</xsl:comment>

			<xsl:element name="version_history">
				<xsl:for-each 
					select="
					.//html:tr
						[contains(html:td[1]/@uci:diffStyle, 'background-color')]
						[contains(translate(html:td[1], $upper, $lower), 'version history')]
					/following-sibling::html:tr[position() &gt; 1]
						[html:td/uci:par[1][string-length(normalize-space(.))!=0]]
					">
					<xsl:element name="history">
						<xsl:element name="date">
							<xsl:choose>
								<xsl:when 
									test="
									html:td[1][string-length(normalize-space(.))!=0]
									or .[last()][string-length(.)=0]
									">
									<xsl:call-template name="date-convert">
										<xsl:with-param name="date-value" select="html:td[1]"/>
									</xsl:call-template>
								</xsl:when>
								<!-- if date unavailable and position not last then add default value -->
								<xsl:when test="position()!=last()">
									<xsl:text>0000-00-00</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="{$warning}"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:element>
						
						<xsl:element name="revised_by">
							<xsl:apply-templates select="html:td[2]"/>
						</xsl:element>
						<xsl:element name="comments">
							<xsl:apply-templates select="html:td[3]"/>
						</xsl:element>
						<xsl:element name="version">
							<xsl:value-of 
								select="
								replace(
								html:td[4]
								, '^.*?(\d+).*?$'
								, '$1')
								"/>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-person">
		
		<xsl:param name="disclosures"/>
		<xsl:param name="photo"/>
		
		<xsl:element name="name">
			<xsl:apply-templates select="html:td[2]"/>
		</xsl:element>
		<xsl:element name="degree">
			<xsl:apply-templates select="html:td[3]"/>
		</xsl:element>
		<xsl:element name="title_affil">
			<xsl:for-each select="tokenize(html:td[4], ', ')">
				<xsl:element name="para">
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
		<xsl:if test="$disclosures = 'true'">
			<xsl:element name="disclosures">
				<xsl:apply-templates select="html:td[5]"/>
			</xsl:element>
		</xsl:if>
		<xsl:if test="$photo = 'true' and html:td[6][string-length(normalize-space(.))!=0]">
			<xsl:element name="photo">
				<xsl:apply-templates select="html:td[6]"/>
			</xsl:element>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="process-topic-synonyms">
		
		<xsl:for-each
			select="
			//html:table
			//html:tr
				[html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'topic synonyms')]]
				[following-sibling::html:tr[1][string-length(normalize-space(.))!=0]]
			">
			<xsl:element name="topic_synonyms">
				<xsl:for-each
					select="
					following-sibling::html:tr[string-length(normalize-space(.))!=0]
					">
					<xsl:element name="synonym">
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-related-topics">
		
		<xsl:for-each
			select="
			//html:table
			//html:tr
			[html:td[1]
			[contains(@uci:diffStyle, 'background-color')]
			[contains(translate(., $upper, $lower), 'related topics')]]
			[following-sibling::html:tr[position() = 2 and string-length(normalize-space(.))!=0]]
			">
			<xsl:element name="related_topics">
				<xsl:for-each select="following-sibling::html:tr[position() &gt; 1 and string-length(normalize-space(.))!=0]">				
					<xsl:element name="related_topic">
						<xsl:if test="html:td[1][string-length(normalize-space(.))!=0]">
							<xsl:attribute name="dx_id" select="replace(html:td[1], '^.*?(\d+).*?$', '$1')"/>
						</xsl:if>
						<xsl:apply-templates select="html:td[2]"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>		
	</xsl:template>

	<xsl:template name="process-statistics">
		
		<xsl:element name="statistics">
			<xsl:element name="us_prevalence"/>
			<xsl:element name="global_prevalence"/>
			<xsl:element name="morbidity"/>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-article-refs">
		
		<xsl:for-each 
			select="
			//html:table
				[.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'references: referenced articles')]]
			">
			<xsl:if test=".//html:tr[3][string-length(normalize-space(.))!=0]">
				<xsl:element name="article_refs">
					<xsl:for-each 
						select="
						.//html:tr[position() &gt; 2]
						[string-length(normalize-space(.))!=0]
						">
						<xsl:element name="article_ref">
							<xsl:attribute name="id" select="replace(html:td[1], '^.*?(\d+).*?$', '$1')"/>
							<xsl:attribute name="key_article">
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
							</xsl:attribute>
							<xsl:element name="citation">
								<xsl:apply-templates select="html:td[2]"/>
							</xsl:element>
							<xsl:if test="html:td[3]/uci:par[string-length(normalize-space(.))!=0]">
								<xsl:element name="abstract_url">
									<xsl:choose>
										<xsl:when test="starts-with(normalize-space(html:td[3]), 'www')">
											<xsl:text>http://</xsl:text>
											<xsl:value-of select="normalize-space(html:td[3])"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="normalize-space(html:td[3])"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:if>
							<xsl:if test="html:td[4]/uci:par[string-length(normalize-space(.))!=0]">
								<xsl:element name="fulltext_url">
									<xsl:choose>
										<xsl:when test="starts-with(normalize-space(html:td[4]), 'www')">
											<xsl:text>http://</xsl:text>
											<xsl:value-of select="normalize-space(html:td[4])"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="normalize-space(html:td[4])"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:if>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-online-refs">
		
		<xsl:for-each 
			select="
			//html:table
				[.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'references: external online resources')]]
			">
			<xsl:if test=".//html:tr[3][string-length(normalize-space(.))!=0]">
				<xsl:element name="online_refs">
					<xsl:for-each 
						select="
						.//html:tr[position() &gt; 2]
						[string-length(normalize-space(.))!=0]
						">
						<xsl:element name="online_ref">
							<xsl:attribute name="id" select="replace(html:td[1], '^.*?(\d+).*?$', '$1')"/>
							<xsl:element name="title">
								<xsl:apply-templates select="html:td[2]"/>
							</xsl:element>
							<xsl:element name="url">
								<xsl:choose>
									<xsl:when test="starts-with(normalize-space(html:td[3]), 'www')">
										<xsl:text>http://</xsl:text>
										<xsl:value-of select="normalize-space(html:td[3])"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="normalize-space(html:td[3])"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:element>			
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-clinical-refs">
		
		<xsl:for-each 
			select="
			//html:table
				[.//html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'references: clinical evidence')]]
			">
			<xsl:if test=".//html:tr[3][string-length(normalize-space(.))!=0]">
				<xsl:element name="clinical_refs">
					<xsl:for-each 
						select="
						.//html:tr[position() &gt; 2]
						[string-length(normalize-space(.))!=0]
						">
						<xsl:element name="clinical_ref">
							<xsl:attribute name="id" select="replace(html:td[1], '^.*?(\d+).*?$', '$1')"/>
							<xsl:element name="score">
								<xsl:value-of select="normalize-space(html:td[2])"/>
							</xsl:element>
							<xsl:element name="comments">
								<xsl:apply-templates select="html:td[3]"/>
							</xsl:element>
							<xsl:if test="html:td[4]/uci:par[string-length(normalize-space(.))!=0]">
								<xsl:element name="bmj_url">
									<xsl:choose>
										<xsl:when test="starts-with(normalize-space(html:td[4]), 'www')">
											<xsl:text>http://</xsl:text>
											<xsl:value-of select="normalize-space(html:td[4])"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="normalize-space(html:td[4])"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:element>
							</xsl:if>
						</xsl:element>						
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template name="process-image-refs">
		
		<xsl:for-each
			select="
			//html:table
			//html:tr[1]
				[html:td[1]
					[contains(@uci:diffStyle, 'background-color')]
					[contains(translate(., $upper, $lower), 'images')]]
			">
			<xsl:if 
				test="
				following-sibling::html:tr[2]
				[string-length(normalize-space(.))!=0]
				">
				<xsl:element name="image_refs">
					<xsl:for-each 
						select="
						following-sibling::html:tr[position() &gt; 1]
						[html:td[2]/uci:par[string-length(normalize-space(.))!=0]]
						">
						<xsl:choose>
							<xsl:when test="count(html:td)=4">
								<xsl:element name="image_ref">
									<xsl:attribute name="id" select="replace(html:td[1], '^.*?(\d+).*?$', '$1')"/>
									<xsl:variable name="filename" select="translate(normalize-space(html:td[2]), $upper, $lower)"/>
									<xsl:element name="filename">
										<!-- check that image name ends with jpg, png, or gif -->
										<xsl:if 
											test="
											substring-after($filename, '.') != 'jpg'
											and substring-after($filename, '.') != 'png'
											and substring-after($filename, '.') != 'gif'
											">
											<xsl:element name="{$warning}">
												<xsl:text>image name has no file ext</xsl:text>
											</xsl:element>
										</xsl:if>
										<xsl:value-of select="$filename"/>
									</xsl:element>
									<xsl:element name="caption">
										<!--<xsl:apply-templates select="html:td[3]"/>-->
										<xsl:for-each select="html:td[3]/uci:par/node()">
											<xsl:choose>
												<xsl:when test="position()!=last()">
													<xsl:apply-templates select="self::node()"/>
												</xsl:when>
												<xsl:when test="position()=last() and self::text() and matches(self::node(), '^.*\. *$$')">
													<xsl:value-of select="replace(self::node(), '^(.*)\. *$$', '$1')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:apply-templates select="self::node()"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</xsl:element>
									<xsl:if test="html:td[4][string-length(normalize-space(.))!=0]">
										<xsl:element name="source">
											<xsl:value-of select="normalize-space(html:td[4])"/>
										</xsl:element>
									</xsl:if>
								</xsl:element>		
							</xsl:when>
							<!-- in some cases rtf/xml first id column is missing from rtf/xml -->
							<xsl:otherwise>
								<xsl:element name="image_ref">
									<!--<xsl:attribute name="id" select="$warning"/>-->
									<xsl:variable name="filename" select="translate(normalize-space(html:td[1]), $upper, $lower)"/>
									<xsl:element name="filename">
										<!-- check that image name ends with jpg, png, or gif -->
										<xsl:if 
											test="
											substring-after($filename, '.') != 'jpg'
											and substring-after($filename, '.') != 'png'
											and substring-after($filename, '.') != 'gif'
											">
											<xsl:element name="{$warning}">
												<xsl:text>image name has no file ext</xsl:text>
											</xsl:element>
										</xsl:if>
										<xsl:value-of select="$filename"/>
									</xsl:element>
									<xsl:element name="caption">
										<!--<xsl:apply-templates select="html:td[2]"/>-->
										<xsl:for-each select="html:td[2]/uci:par/node()">
											<xsl:choose>
												<xsl:when test="position()!=last()">
													<xsl:apply-templates select="self::node()"/>
												</xsl:when>
												<xsl:when test="position()=last() and self::text() and matches(self::node(), '^.*\. *$$')">
													<xsl:value-of select="replace(self::node(), '^(.*)\. *$$', '$1')"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:apply-templates select="self::node()"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</xsl:element>
									<xsl:if test="html:td[3]/uci:par[string-length(normalize-space(.))!=0]">
										<xsl:element name="source">
											<xsl:value-of select="normalize-space(html:td[3])"/>
										</xsl:element>
									</xsl:if>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>			
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>				
		
	</xsl:template>

</xsl:stylesheet>

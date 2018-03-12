<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	exclude-result-prefixes="xi xsi cals"
	version="2.0">
	
	<xsl:template name="process-summary-questions-list">
		
		<xsl:comment>summary-questions-list</xsl:comment>
		
		<xsl:element name="fo:block" use-attribute-sets="background-grey space-after">
			
			<xsl:element name="fo:block" use-attribute-sets="strong background-black color-white align-center">
				<xsl:element name="fo:block" use-attribute-sets="default-margin">QUESTIONS</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:block" use-attribute-sets="background-grey">
				<xsl:for-each select="/systematic-review/question-list/question">
					<xsl:element name="fo:block" use-attribute-sets="color-black align-left default-margin last-justify">
						<xsl:choose>
							<xsl:when test="contains($components, 'questions')">
								<xsl:element name="fo:basic-link" use-attribute-sets="keep-with-next">
									<xsl:attribute name="internal-destination" select="concat($cid, '_Q', position())"/>
									<xsl:apply-templates select="title"/>
									<xsl:if test="contains($media, 'print')">
										<xsl:element name="fo:leader" use-attribute-sets="default-leader keep-with-next">
										</xsl:element>
										<xsl:element name="fo:page-number-citation" use-attribute-sets="">
											<xsl:attribute name="ref-id" select="concat($cid, '_Q', position())"/>
										</xsl:element>
									</xsl:if>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="title"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>

		</xsl:element>

	</xsl:template>

	<xsl:template name="process-summary-interventions-list">
		
		<xsl:comment>summary-questions-list</xsl:comment>
		

		<xsl:element name="fo:block" use-attribute-sets="strong align-center color-white background-blue">
			<xsl:element name="fo:block" use-attribute-sets="default-margin">INTERVENTIONS</xsl:element>
		</xsl:element>

		<xsl:element name="rx:flow-section" use-attribute-sets="two-column background-tinted-blue">
			
			<xsl:element name="fo:block" use-attribute-sets="background-tinted-blue">
				
				<xsl:for-each select="/systematic-review/question-list/question">
					
					<xsl:element name="fo:block" use-attribute-sets="strong keep-with-next default-margin">
						<xsl:choose>
							<xsl:when test="contains($components, 'questions')">
								<xsl:element name="fo:basic-link" use-attribute-sets="">
									<xsl:attribute name="internal-destination" select="concat($cid, '_Q', position())"/>
									<xsl:value-of select="translate(abridged-title, $lower, $upper)"/>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="translate(abridged-title, $lower, $upper)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
					
					<xsl:variable name="question">
						<xsl:for-each select=".//xi:include[contains(@href, 'option')]">
						
							<xsl:element name="{name()}" use-attribute-sets="">
								<xsl:attribute name="href" select="@href"/>
								<xsl:copy-of select="document(@href)/*"/>
							</xsl:element>
						</xsl:for-each>
					</xsl:variable>
					
					<xsl:for-each select="$efficacy-order/*">
						<xsl:variable name="efficacy-type" select="name()"/>
						
						<xsl:if test="$question//intervention[@efficacy = $efficacy-type]">
							
							<xsl:element name="fo:block" use-attribute-sets="space-after-large">
								
								<xsl:element name="fo:block" use-attribute-sets="strong keep-with-next default-margin">
									<!-- media=web disabled for now until publication tested -->
									<xsl:if test="contains($media, 'web')">
										<xsl:element name="fo:external-graphic" use-attribute-sets="">
											<xsl:attribute name="scaling">uniform</xsl:attribute>
											<xsl:attribute name="overflow">visible</xsl:attribute>
											<xsl:attribute name="content-height" select="concat($body.font.master,'pt')"/>
											<xsl:attribute name="width" select="'30px'"/>
											<xsl:attribute name="height" select="'15px'"/>
											<xsl:attribute name="src">
												<xsl:text>url('</xsl:text>
												<xsl:value-of select="$images-input"/>
												<xsl:value-of select="$efficacy-type"/>
												<xsl:if test="contains($system, 'docato')">
													<xsl:text>_default</xsl:text>
												</xsl:if>
												<!--<xsl:text>.svg</xsl:text>-->
												<xsl:text>.gif</xsl:text>
												<xsl:text>')</xsl:text>
											</xsl:attribute>
										</xsl:element>
										<xsl:text disable-output-escaping="yes"> </xsl:text>
									</xsl:if>
									<xsl:choose>
										<xsl:when test="$efficacy-type eq 'beneficial' "><xsl:text>Beneficial</xsl:text></xsl:when>
										<xsl:when test="$efficacy-type eq 'likely-to-be-beneficial' "><xsl:text>Likely to be beneficial</xsl:text></xsl:when>
										<xsl:when test="$efficacy-type eq 'trade-off-between-benefits-and-harms' "><xsl:text>Trade off between benefits and harms</xsl:text></xsl:when>
										<xsl:when test="$efficacy-type eq 'unknown-effectiveness' "><xsl:text>Unknown effectiveness</xsl:text></xsl:when>
										<xsl:when test="$efficacy-type eq 'unlikely-to-be-beneficial' "><xsl:text>Unlikely to be beneficial</xsl:text></xsl:when>
										<xsl:when test="$efficacy-type eq 'likely-to-be-ineffective-or-harmful' "><xsl:text>Likely to be ineffective or harmful</xsl:text></xsl:when>
										<xsl:when test="$efficacy-type eq 'not-given' "><xsl:text>Categorisation?</xsl:text></xsl:when>
									</xsl:choose>
								</xsl:element>
								
								<xsl:for-each select="$question//intervention">
								<!--  Commneted the below line for Mantis ID:12554 -->
								<!-- 	<xsl:sort select="title"/> -->
									
									<xsl:if test="@efficacy = $efficacy-type">
										<!--<xsl:variable name="iid" select="concat($cid, '_', substring-after(substring-after(substring-before(@target, '.xml'), '_op'), '_'))"/>-->
										<!-- chpping '../options/_op1003_I1.xml' or 
											'../options/option-1179218159900_en-gb.xml' to get option id -->
										<xsl:variable 
											name="iid" 
											select="
											concat($cid, '_I', 
											replace(
											ancestor::xi:include[contains(@href, 'option')]/@href 
											, '^.*?[I\-](\d+).*?$'
											, '$1'))
											"/>
										
										<xsl:element name="fo:block" use-attribute-sets="align-left default-margin last-justify">
											
											<xsl:choose>
												<xsl:when test="contains($components, 'questions')">
													<xsl:element name="fo:basic-link" use-attribute-sets="keep-with-next hanging-indent">
														<xsl:attribute name="internal-destination" select="$iid"/>
														<xsl:apply-templates select="title"/>
													</xsl:element>		
												</xsl:when>
												<xsl:otherwise>
													<xsl:apply-templates select="title"/>
												</xsl:otherwise>
											</xsl:choose>
											
											<xsl:if test="../../substantive-change-set/substantive-change[@status='new-option']">
												<xsl:element name="fo:inline" use-attribute-sets="strong color-white keep-with-next">
													<xsl:text disable-output-escaping="yes"> </xsl:text>New</xsl:element>
											</xsl:if>
											
											<xsl:choose>
												<xsl:when test="contains($media, 'print')">
													<xsl:element name="fo:leader" use-attribute-sets="default-leader keep-with-next">
														<xsl:attribute name="keep-with-previous">always</xsl:attribute>
													</xsl:element>
													<xsl:element name="fo:page-number-citation" use-attribute-sets="">
														<xsl:attribute name="ref-id">
															<xsl:value-of select="$iid"/>
														</xsl:attribute>
													</xsl:element>
												</xsl:when>
												<xsl:otherwise>
													<xsl:element name="fo:leader" use-attribute-sets="color-white"/>
												</xsl:otherwise>
											</xsl:choose>
											
										</xsl:element>
										
									</xsl:if>
								</xsl:for-each>
							</xsl:element>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
				
				<xsl:if test="/systematic-review/info/covered-elsewhere/p[string-length(.)!=0]">
					<xsl:element name="fo:block" use-attribute-sets="space-after-large">
						<xsl:element name="fo:block" use-attribute-sets="strong keep-with-next default-margin">Covered elsewhere in Clinical Evidence</xsl:element>
						<xsl:for-each select="/systematic-review/info/covered-elsewhere/p">
							<xsl:element name="fo:block" use-attribute-sets="default-margin">
								<xsl:apply-templates/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:if>
				
				<xsl:if test="$bmjk-review-plan//info/future-issues/p[1][string-length(.)!=0]">
					<xsl:element name="fo:block" use-attribute-sets="space-after-large">
						<xsl:element name="fo:block" use-attribute-sets="strong keep-with-next default-margin">To be covered in future updates</xsl:element>
						<xsl:for-each select="$bmjk-review-plan//info/future-issues/p">
							<xsl:element name="fo:block" use-attribute-sets="default-margin">
								<xsl:apply-templates select="."/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:if>
				
				<xsl:if test="/systematic-review/info/footnote/p[1][string-length(.)!=0]">
					<xsl:element name="fo:block" use-attribute-sets="space-after-large">
						<xsl:element name="fo:block" use-attribute-sets="strong keep-with-next default-margin">Footnote</xsl:element>
						<xsl:for-each select="/systematic-review/info/footnote/p">
							<xsl:element name="fo:block" use-attribute-sets="default-margin">
								<xsl:apply-templates select="."/>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
				</xsl:if>
				
				<xsl:element name="fo:block" use-attribute-sets="flow-section-space-filler background-tinted-blue">
					<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>				
		
		<xsl:element name="fo:block" use-attribute-sets="space-after"/>
		
	</xsl:template>


	<xsl:template name="process-summary-view-summary-statement-list">
	
		<xsl:comment>summary-statement-list</xsl:comment>

		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:attribute name="break-before">page</xsl:attribute>

			<xsl:call-template name="process-key-heading">
				<xsl:with-param name="label">To be covered in future updates</xsl:with-param>
			</xsl:call-template>

			<xsl:for-each select="/systematic-review/question-list/question">

				<xsl:element name="fo:block" use-attribute-sets="strong space-after">
					<xsl:element name="fo:basic-link" use-attribute-sets="">
						<xsl:attribute name="internal-destination" select="concat($cid, '_Q', position())"/>
						<xsl:apply-templates select="abridged-title"/>
					</xsl:element>
				</xsl:element>

				<xsl:variable name="question">
					<xsl:for-each select=".//xi:include[contains(@href, 'option')]">
						<xsl:element name="{name()}">
							<xsl:attribute name="href" select="@href"/>
							<xsl:copy-of select="document(@href)/*"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:variable>

				<xsl:for-each select="$efficacy-order/*">
					<xsl:variable name="efficacy-type" select="name()"/>
					<xsl:variable name="efficacy-title" select="name()"/>

					<xsl:if test="$question//intervention[@efficacy = $efficacy-type]">

						<xsl:for-each select="$question//intervention">
							<xsl:sort select="title"/>

							<xsl:if test="@efficacy = $efficacy-type">
								<!--<xsl:variable name="iid" select="concat($cid, '_', substring-after(substring-after(substring-before(@target, '.xml'), '_op'), '_'))"/>-->
								<!-- chpping '../options/_op1003_I1.xml' or 
									'../options/option-1179218159900_en-gb.xml' to get option id -->
								<xsl:variable 
									name="iid" 
									select="
									concat($cid, '_I', 
									replace(
									ancestor::xi:include[contains(@href, 'option')]/@href
									, '^.*?[I\-](\d+).*?$'
									, '$1'))
									"/>
								
								<xsl:variable name="processed-intervention-summary-block">
									<xsl:element name="fo:basic-link" use-attribute-sets="">
										<xsl:attribute name="internal-destination" select="$iid"/>
										<xsl:element name="fo:inline" use-attribute-sets="">
											<xsl:attribute name="font-weight">bold</xsl:attribute>
											<xsl:apply-templates select="title"/>
										</xsl:element>
									</xsl:element>
									<!--<xsl:if test="../../substantive-change-set/substantive-change[@status='new-option']">
										<xsl:element name="fo:inline" use-attribute-sets="strong color-blue">
											<xsl:text disable-output-escaping="yes"> </xsl:text>
											<xsl:value-of select="translate($glue-text//new[contains(@lang, $lang)], $lower, $uppper)"/>
										</xsl:element>
									</xsl:if>-->
									<xsl:text disable-output-escaping="yes"> </xsl:text>
									<xsl:apply-templates select="summary-statement"/>
								</xsl:variable>
								
								<xsl:for-each select="$processed-intervention-summary-block">
									<xsl:call-template name="process-list-first-level"/>									
								</xsl:for-each>

							</xsl:if>

						</xsl:for-each>

					</xsl:if>

				</xsl:for-each>

			</xsl:for-each>

		</xsl:element>

	</xsl:template>

	<xsl:template name="process-summary-view-concise">
		<xsl:comment>concise-layout</xsl:comment>

		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:attribute name="break-before">page</xsl:attribute>

			<xsl:for-each select="/systematic-review/question-list/question">
				<xsl:call-template name="process-ruled-heading">
					<xsl:with-param name="text">
						<xsl:apply-templates select="title"/>
					</xsl:with-param>
				</xsl:call-template>

				<xsl:variable name="question">
					<xsl:for-each select=".//xi:include[contains(@href, 'option')]">
						<xsl:element name="{name()}">
							<xsl:attribute name="href" select="@href"/>
							<xsl:copy-of select="document(@href)/*"/>
						</xsl:element>
					</xsl:for-each>
				</xsl:variable>

				<xsl:for-each select="$efficacy-order/*">
					<xsl:variable name="efficacy-type" select="name()"/>
					<xsl:variable name="efficacy-title" select="name()"/>

					<xsl:if test="$question//intervention[@efficacy = $efficacy-type]">

						<xsl:element name="fo:block" use-attribute-sets="color-white background-blue space-after">
							<xsl:element name="fo:block" use-attribute-sets="default-margin">
								<xsl:choose>
									<xsl:when test="$efficacy-type eq 'beneficial' "><xsl:text>BENEFICIAL</xsl:text></xsl:when>
									<xsl:when test="$efficacy-type eq 'likely-to-be-beneficial' "><xsl:text>>LIKELY TO BE BENEFICIAL</xsl:text></xsl:when>
									<xsl:when test="$efficacy-type eq 'trade-off-between-benefits-and-harms' "><xsl:text>TRADE OFF BETWEEN BENEFITS AND HARMS</xsl:text></xsl:when>
									<xsl:when test="$efficacy-type eq 'unknown-effectiveness' "><xsl:text>UNKNOWN EFFECTIVENESS</xsl:text></xsl:when>
									<xsl:when test="$efficacy-type eq 'unlikely-to-be-beneficial' "><xsl:text>LIKELY TO BE BENEFICIAL</xsl:text></xsl:when>
									<xsl:when test="$efficacy-type eq 'likely-to-be-ineffective-or-harmful' "><xsl:text>LIKELY TO BE INEFFECTIVE OR HARMFUL</xsl:text></xsl:when>
									<xsl:when test="$efficacy-type eq 'not-given' "><xsl:text>CATEGORISATION?</xsl:text></xsl:when>
								</xsl:choose>
							</xsl:element>
						</xsl:element>

						<xsl:for-each select="$question//intervention">
							<xsl:sort select="title"/>

							<xsl:if test="@efficacy = $efficacy-type">
								<!--<xsl:variable name="iid" select="concat($cid, '_', substring-after(substring-after(substring-before(@target, '.xml'), '_op'), '_'))"/>-->
								<!-- chpping '../options/_op1003_I1.xml' or 
									'../options/option-1179218159900_en-gb.xml' to get option id -->
								<xsl:variable 
									name="iid" 
									select="
									concat($cid, '_I', 
									replace(
									ancestor::xi:include[contains(@href, 'option')]/@href 
									, '^.*?[I\-](\d+).*?$'
									, '$1'))
									"/>

								<xsl:element name="fo:block" use-attribute-sets="strong color-blue">
									<xsl:attribute name="font-weight">bold</xsl:attribute>
									<xsl:attribute name="space-after">10pt</xsl:attribute>
									<xsl:apply-templates select="title"/>
									<xsl:if test="../../substantive-change-set/substantive-change[@status='new-option']">
										<xsl:element name="fo:inline" use-attribute-sets="strong color-blue">
											<xsl:text disable-output-escaping="yes"> </xsl:text>NEW</xsl:element>
									</xsl:if>
								</xsl:element>
								<xsl:element name="fo:block" use-attribute-sets="strong color-blue">
									<xsl:attribute name="start-indent">15pt</xsl:attribute>
									<xsl:attribute name="space-after">10pt</xsl:attribute>
									<xsl:apply-templates select="summary-statement"/>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>

					</xsl:if>

				</xsl:for-each>

			</xsl:for-each>

		</xsl:element>

	</xsl:template>

	

</xsl:stylesheet>

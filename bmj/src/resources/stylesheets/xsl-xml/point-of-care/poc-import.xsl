<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:xi="http://www.w3.org/2001/XInclude" 
		xmlns:drugs="Lookup table for Generic drug names">

	<!-- Un-comment the following xsl:include to get drug names -->
	<!-- xsl:include href="poc_add_drug_tagging.xsl"/ -->

	<!-- Set General parameters -->
	<xsl:output media-type="xml" method="xml" indent="yes"/>
	<xsl:variable name="figure-folder">../monograph-figures/</xsl:variable>
	<xsl:variable name="image-folder">../monograph-images/</xsl:variable>

	<xsl:key name="image-index" match="image_ref" use="@id"/>
	
	<xsl:param name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝ'"/>
	<xsl:param name="lower" select="'abcdefghijklmnopqrstuvwxyzáâãäåæçèéêëìíîïðñòóôõöøùúûüý'"/>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>


	<!-- Special processing on some elements -->
	<xsl:template match="*">
		<xsl:choose>

			<!-- Change the Schema reference -->
			<xsl:when test="self::monographs">
				<xsl:element name="monographs">
					<xsl:for-each select="@*">
						<xsl:choose>
							<xsl:when test="name() = 'xsi:noNamespaceSchemaLocation'">
								<xsl:attribute name="{name()}">../../schemas/bmjk-point-of-care.xsd</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="{name()}">
									<xsl:value-of select="."/>
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>

			<!--	Re-order the main blocks in the full Monograph -->
			<!--	Output main element -->
			<xsl:when test="self::monograph_full">
				<xsl:element name="monograph-full">
					<xsl:call-template name="add-current-attributes"/>

					<xsl:element name="notes">
						<xsl:element name="para"/>
					</xsl:element>
					
					<xsl:element name="monograph-info">

						<xsl:element name="monograph-plan-link">
							<xsl:attribute name="target">
								<xsl:value-of select="concat('../monograph-plan/monograph-plan-', @dx_id, '.xml')"/>
							</xsl:attribute>
						</xsl:element>
						
						<xsl:element name="title"><xsl:value-of select="./title"/></xsl:element>
						
						<xsl:for-each select="*">
							<xsl:choose>
								<xsl:when test="self::version_history"/>
								<xsl:when test="self::topic_synonyms">
									<xsl:apply-templates select="//topic_synonyms"/>
									<!-- xsl:call-template name="output-current-element"/ -->
								</xsl:when>
								<xsl:when test="self::related_topics">
									<xsl:call-template name="output-current-element"/>
									<!-- add empty cat tag -->
									<xsl:element name="categories"/>
								</xsl:when>
								<xsl:when test="self::statistics">
									<xsl:call-template name="output-current-element"/>
								</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
						</xsl:for-each>
		
					</xsl:element>
					
					<!-- this is to become the monograph plan -->
					<xsl:element name="bmjk-monograph-plan">
						
						<xsl:element name="notes">
							<xsl:element name="para"/>
						</xsl:element>
						
						<xsl:element name="monograph-info">
							
							<xsl:element name="title"><xsl:value-of select="./title"/></xsl:element>
							
							<xsl:element name="deadline-date">2000-01-01</xsl:element>
							
							<!-- group the people together we need to prccess these in the import -->
							<xsl:for-each select="*">
								<xsl:choose>
									<xsl:when test="self::authors">
										<xsl:call-template name="output-current-element"/>
									</xsl:when>
									<xsl:when test="self::peer_reviewers">
										<xsl:call-template name="output-current-element"/>
									</xsl:when>
									<xsl:when test="self::editors">
										<xsl:call-template name="output-current-element"/>
									</xsl:when>
									<xsl:otherwise/>
								</xsl:choose>
							</xsl:for-each>
						
						</xsl:element>
						
						<!-- add tx options -->

						<xsl:element name="tx-options">
							
							<!-- need to process the child options first, then the parents else will have an import prob -->
							
							<xsl:for-each select="//tx_option">
								
								<xsl:element name="tx-option">	
									<xsl:attribute name="id"><xsl:value-of select="position()" /></xsl:attribute>
									<xsl:attribute name="timeframe"><xsl:value-of select="./timeframe" /></xsl:attribute>
									
									<xsl:choose>
										<xsl:when test="./tx_line">
											<xsl:attribute name="tx-line">
												<xsl:value-of select="./tx_line"/>
											</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="tx-line">unset</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
									
									<xsl:for-each select="*">
										<xsl:choose>
											<xsl:when test="self::parent_pt_group"/>
											<xsl:when test="self::timeframe"/>
											<xsl:when test="self::tx_line"/>
											<xsl:otherwise>
												<xsl:call-template name="output-current-element"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
									
								</xsl:element>
								
							</xsl:for-each>
							
						</xsl:element>
						
					</xsl:element>

					<xsl:for-each select="*">
						<xsl:choose>
							<xsl:when test="self::highlights">
								<xsl:call-template name="output-current-element"/>
							</xsl:when>
							<xsl:otherwise/>	
						</xsl:choose>
					</xsl:for-each>
					
					
					<!--	Main content contains: basics, diagnosis, treatment, followup, references (only article_refs & online_refs) -->
					<xsl:for-each select="*">
						<xsl:choose>
							<xsl:when test="self::title"/>
							<xsl:when test="self::authors"/>
							<xsl:when test="self::peer_reviewers"/>
							<xsl:when test="self::editors"/>
							<xsl:when test="self::version_history"/>
							<xsl:when test="self::topic_synonyms"/>
							<xsl:when test="self::related_topics"/>
							<xsl:when test="self::references"/>
							<xsl:when test="self::highlights"/>
							<xsl:when test="self::treatment">
								<xsl:apply-templates select="."/>
							</xsl:when>
							<xsl:when test="self::differentials">
								<xsl:apply-templates select="."/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="output-current-element"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>

					
					<!-- process images -->
					<xsl:apply-templates select="references/image_refs"/>
					
					<!-- evidence scores -->
					<xsl:apply-templates select="references/clinical_refs"/>

					<!-- Finally the remaining references -->
					<xsl:apply-templates select="references"/>
					

				</xsl:element>
			</xsl:when>

			<xsl:when test="self::monograph_eval">
				<xsl:element name="monograph-eval">
					<xsl:call-template name="add-current-attributes"/>

					<xsl:element name="notes">
						<xsl:element name="para"/>
					</xsl:element>
					
					<xsl:element name="monograph-info">
						
						<xsl:element name="monograph-plan-link">
							<xsl:attribute name="target">
								<xsl:value-of select="concat('../monograph-plan/monograph-plan-', @dx_id, '.xml')"/>
							</xsl:attribute>
						</xsl:element>
						
						
						<xsl:element name="title"><xsl:value-of select="./title"/></xsl:element>
						
						<xsl:for-each select="*">
							<xsl:choose>
								<xsl:when test="self::version_history"/>
								<xsl:when test="self::topic_synonyms">
									<xsl:apply-templates select="//topic_synonyms"/>
									<!-- xesl:call-template name="output-current-element"/ -->
								</xsl:when>
								<xsl:when test="self::related_topics">
									<xsl:call-template name="output-current-element"/>
									<!-- add empty cat tag -->
									<xsl:element name="categories"/>
								</xsl:when>
								<xsl:when test="self::statistics">
									<xsl:call-template name="output-current-element"/>
								</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
						</xsl:for-each>
						
					</xsl:element>
					
					<!-- this is to become the monograph plan -->
					<xsl:element name="bmjk-monograph-plan">
						
						<xsl:element name="notes">
							<xsl:element name="para"/>
						</xsl:element>
						
						<xsl:element name="monograph-info">
							
							<xsl:element name="title"><xsl:value-of select="./title"/></xsl:element>
							
							<xsl:element name="deadline-date">2000-01-01</xsl:element>
							
							<!-- group the people together we need to prccess these in the import -->
							<xsl:for-each select="*">
								<xsl:choose>
									<xsl:when test="self::authors">
										<xsl:call-template name="output-current-element"/>
									</xsl:when>
									<xsl:when test="self::peer_reviewers">
										<xsl:call-template name="output-current-element"/>
									</xsl:when>
									<xsl:when test="self::editors">
										<xsl:call-template name="output-current-element"/>
									</xsl:when>
									<xsl:otherwise/>
								</xsl:choose>
							</xsl:for-each>
							
						</xsl:element>
						
						<!-- add differentiials -->
						
						<xsl:element name="differentials">
							<xsl:for-each select="differentials/differential">
								<xsl:element name="differential">
									<xsl:attribute name="id"><xsl:value-of select="position()" /></xsl:attribute>
									<xsl:attribute name="red-flag"><xsl:value-of select="./@red_flag" /></xsl:attribute>
									<xsl:attribute name="common"><xsl:value-of select="./@common" /></xsl:attribute>
									<xsl:if test="./@dx_id">
										<xsl:element name="monograph-link">
											<xsl:attribute name="target">
												<xsl:value-of select="./@dx_id"/>
											</xsl:attribute>
										</xsl:element>
									</xsl:if>
									<xsl:for-each select="*">
										<xsl:choose>
											<xsl:when test="self::ddx_name">
												<xsl:call-template name="output-current-element"/>
											</xsl:when>
											<xsl:when test="self::category">
												<xsl:call-template name="output-current-element"/>
											</xsl:when>
											<xsl:when test="self::history">
												<xsl:call-template name="output-current-element"/>
											</xsl:when>
											<xsl:when test="self::exam">
												<xsl:call-template name="output-current-element"/>
											</xsl:when>
											<xsl:when test="self::tests">
												<xsl:call-template name="output-current-element"/>
											</xsl:when>
											<xsl:otherwise/>
										</xsl:choose>
									</xsl:for-each>
								</xsl:element>
							</xsl:for-each>
						</xsl:element>
						
						
					</xsl:element>
					
					<!--	Main content contains: basics, diagnosis, treatment, followup, references (only article_refs & online_refs) -->
					<xsl:for-each select="*">
						<xsl:choose>
							<xsl:when test="self::title"/>
							<xsl:when test="self::authors"/>
							<xsl:when test="self::peer_reviewers"/>
							<xsl:when test="self::editors"/>
							<xsl:when test="self::version_history"/>
							<xsl:when test="self::topic_synonyms"/>
							<xsl:when test="self::related_topics"/>
							<xsl:when test="self::references"/>
							<xsl:when test="self::differentials"/>
							<xsl:otherwise>
								<xsl:call-template name="output-current-element"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>

					<xsl:element name="differentials">
						<xsl:for-each select="differentials/differential">
							<xsl:element name="differential">
								<xsl:attribute name="id"><xsl:value-of select="position()" /></xsl:attribute>
								<xsl:attribute name="red-flag"><xsl:value-of select="./@red_flag" /></xsl:attribute>
								<xsl:attribute name="common"><xsl:value-of select="./@common" /></xsl:attribute>
								<xsl:if test="./@dx_id">
									<xsl:element name="monograph-link">
										<xsl:attribute name="target">
											<xsl:value-of select="./@dx_id"/>
										</xsl:attribute>
									</xsl:element>
								</xsl:if>
								<xsl:for-each select="*">
									<xsl:choose>
										<xsl:when test="self::ddx_name">
											<xsl:call-template name="output-current-element"/>
										</xsl:when>
										<xsl:when test="self::category">
											<xsl:call-template name="output-current-element"/>
										</xsl:when>
										<xsl:when test="self::history">
											<xsl:call-template name="output-current-element"/>
										</xsl:when>
										<xsl:when test="self::exam">
											<xsl:call-template name="output-current-element"/>
										</xsl:when>
										<xsl:when test="self::tests">
											<xsl:call-template name="output-current-element"/>
										</xsl:when>
										<xsl:otherwise/>
									</xsl:choose>
								</xsl:for-each>
							</xsl:element>
						</xsl:for-each>
					</xsl:element>
					
					<!-- process images -->
					<xsl:apply-templates select="references/image_refs"/>
					
					<!-- evidence scores -->
					<xsl:apply-templates select="references/clinical_refs"/>
					
					<!-- Finally the remaining references -->
					<xsl:apply-templates select="references"/>
					
				</xsl:element>
			</xsl:when>


			<xsl:when test="self::monograph_overview">
				<xsl:element name="monograph-overview">
					<xsl:call-template name="add-current-attributes"/>
					
					<xsl:element name="notes">
						<xsl:element name="para"/>
					</xsl:element>
					
					<xsl:element name="monograph-info">
						
						<xsl:element name="monograph-plan-link">
							<xsl:attribute name="target">
								<xsl:value-of select="concat('../monograph-plan/monograph-plan-', @dx_id, '.xml')"/>
							</xsl:attribute>
						</xsl:element>
						
						
						<xsl:element name="title"><xsl:value-of select="./title"/></xsl:element>
						
						<xsl:for-each select="*">
							<xsl:choose>
								<xsl:when test="self::version_history"/>
								<xsl:when test="self::topic_synonyms">
									<xsl:apply-templates select="//topic_synonyms"/>
									<!-- xesl:call-template name="output-current-element"/ -->
								</xsl:when>
								<xsl:when test="self::related_topics">
									<xsl:call-template name="output-current-element"/>
									<!-- add empty cat tag -->
									<xsl:element name="categories"/>
								</xsl:when>
								<xsl:when test="self::statistics">
									<xsl:call-template name="output-current-element"/>
								</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
						</xsl:for-each>
						
					</xsl:element>
					
					<!-- this is to become the monograph plan -->
					<xsl:element name="bmjk-monograph-plan">
						
						<xsl:element name="notes">
							<xsl:element name="para"/>
						</xsl:element>
						
						<xsl:element name="monograph-info">
							
							<xsl:element name="title"><xsl:value-of select="./title"/></xsl:element>
							
							<xsl:element name="deadline-date">2000-01-01</xsl:element>
							
							<!-- group the people together we need to prccess these in the import -->
							<xsl:for-each select="*">
								<xsl:choose>
									<xsl:when test="self::authors">
										<xsl:call-template name="output-current-element"/>
									</xsl:when>
									<xsl:when test="self::peer_reviewers">
										<xsl:call-template name="output-current-element"/>
									</xsl:when>
									<xsl:when test="self::editors">
										<xsl:call-template name="output-current-element"/>
									</xsl:when>
									<xsl:otherwise/>
								</xsl:choose>
							</xsl:for-each>
							
						</xsl:element>
						
					</xsl:element>
					
					<!--	Main content contains: basics, diagnosis, treatment, followup, references (only article_refs & online_refs) -->
					<xsl:for-each select="*">
						<xsl:choose>
							<xsl:when test="self::title"/>
							<xsl:when test="self::authors"/>
							<xsl:when test="self::peer_reviewers"/>
							<xsl:when test="self::editors"/>
							<xsl:when test="self::version_history"/>
							<xsl:when test="self::topic_synonyms"/>
							<xsl:when test="self::related_topics"/>
							<xsl:when test="self::references"/>
							<xsl:otherwise>
								<xsl:call-template name="output-current-element"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					
					
					<!-- process images -->
					<xsl:apply-templates select="references/image_refs"/>
					
					<!-- evidence scores -->
					<xsl:apply-templates select="references/clinical_refs"/>
					
					<!-- Finally the remaining references -->
					<xsl:apply-templates select="references"/>
					
				</xsl:element>
			</xsl:when>


			<xsl:when test="self::monograph_generic">
				<xsl:element name="monograph-generic">
					<xsl:call-template name="add-current-attributes"/>
					
					<xsl:element name="notes">
						<xsl:element name="para"/>
					</xsl:element>
					
					<xsl:element name="monograph-info">
						
						<xsl:element name="monograph-plan-link">
							<xsl:attribute name="target">
								<xsl:value-of select="concat('../monograph-plan/monograph-plan-', @dx_id, '.xml')"/>
							</xsl:attribute>
						</xsl:element>
						
						
						<xsl:element name="title"><xsl:value-of select="./title"/></xsl:element>
						
						<xsl:for-each select="*">
							<xsl:choose>
								<xsl:when test="self::version_history"/>
								<xsl:when test="self::topic_synonyms">
									<xsl:apply-templates select="//topic_synonyms"/>
									<!-- xesl:call-template name="output-current-element"/ -->
								</xsl:when>
								<xsl:when test="self::related_topics">
									<xsl:call-template name="output-current-element"/>
									<!-- add empty cat tag -->
									<xsl:element name="categories"/>
								</xsl:when>
								<xsl:when test="self::statistics">
									<xsl:call-template name="output-current-element"/>
								</xsl:when>
								<xsl:otherwise/>
							</xsl:choose>
						</xsl:for-each>
						
					</xsl:element>
					
					<!-- this is to become the monograph plan -->
					<xsl:element name="bmjk-monograph-plan">
						
						<xsl:element name="notes">
							<xsl:element name="para"/>
						</xsl:element>
						
						<xsl:element name="monograph-info">
							
							<xsl:element name="title"><xsl:value-of select="./title"/></xsl:element>
							
							<xsl:element name="deadline-date">2000-01-01</xsl:element>
							
							<!-- group the people together we need to prccess these in the import -->
							<xsl:for-each select="*">
								<xsl:choose>
									<xsl:when test="self::authors">
										<xsl:call-template name="output-current-element"/>
									</xsl:when>
									<xsl:when test="self::peer_reviewers">
										<xsl:call-template name="output-current-element"/>
									</xsl:when>
									<xsl:when test="self::editors">
										<xsl:call-template name="output-current-element"/>
									</xsl:when>
									<xsl:otherwise/>
								</xsl:choose>
							</xsl:for-each>
							
						</xsl:element>
						
					</xsl:element>
					
					<!--	Main content contains: basics, diagnosis, treatment, followup, references (only article_refs & online_refs) -->
					<xsl:for-each select="*">
						<xsl:choose>
							<xsl:when test="self::title"/>
							<xsl:when test="self::authors"/>
							<xsl:when test="self::peer_reviewers"/>
							<xsl:when test="self::editors"/>
							<xsl:when test="self::version_history"/>
							<xsl:when test="self::topic_synonyms"/>
							<xsl:when test="self::related_topics"/>
							<xsl:when test="self::references"/>
							<xsl:otherwise>
								<xsl:call-template name="output-current-element"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					
					
					<!-- process images -->
					<xsl:apply-templates select="references/image_refs"/>
					
					<!-- evidence scores -->
					<xsl:apply-templates select="references/clinical_refs"/>
					
					<!-- Finally the remaining references -->
					<xsl:apply-templates select="references"/>
					
				</xsl:element>
			</xsl:when>


			<!-- Only select references need to appear at the end of the monograph -->
			<xsl:when test="self::references">
				<xsl:element name="poc-references">
					<xsl:call-template name="add-current-attributes"/>
					<xsl:for-each select="*">
						<xsl:choose>
							<xsl:when test="self::article_refs or self::online_refs">
								<xsl:apply-templates/>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>

			<!-- Map article_ref elements to reference elements -->
			<xsl:when test="self::article_ref">
				<xsl:element name="reference">
					<xsl:attribute name="ref-link">article-ref-<xsl:value-of select="./@id"/></xsl:attribute>
					<xsl:call-template name="get-pubmed-link"/>
					<xsl:element name="poc-citation">
						<xsl:attribute name="key-article">
							<xsl:value-of select="attribute::key_article"/>
						</xsl:attribute>
						<xsl:attribute name="type">article</xsl:attribute>
						<xsl:for-each select="*">
							<xsl:choose>
								<xsl:when test="self::abstract_url"/>
								<xsl:otherwise>
									<xsl:apply-templates select="self::*"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:element>
				</xsl:element>
			</xsl:when>

			<!-- Map online_ref elements to reference elements -->
			<xsl:when test="self::online_ref">
				<xsl:element name="reference">
					<xsl:attribute name="ref-link">olinine-ref-<xsl:value-of select="./@id"/></xsl:attribute>
					<xsl:for-each select="*">
						<xsl:choose>
							<xsl:when test="self::url">
								<xsl:element name="poc-citation">
									<xsl:attribute name="key-article">false</xsl:attribute>
									<xsl:attribute name="type">online</xsl:attribute>
									<xsl:apply-templates select="self::*"/>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="self::*"/>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:for-each>
				</xsl:element>
			</xsl:when>

			<!-- Map image_ref elements to image chunks elements -->
			<!-- These can be dropped from the list of references -->
			<xsl:when test="self::image_ref">
				
				<xsl:element name="figure">
					<xsl:element name="image-link">
						<xsl:attribute name="target">
							<xsl:value-of select="$image-folder"/>
							<xsl:choose>
								<xsl:when test="contains(key('image-index', attribute::id)[1]/filename, '.jpg')">
									<xsl:value-of select="substring-before(key('image-index', attribute::id)[1]/filename, '.jpg')"/>
								</xsl:when>
								<xsl:when test="contains(key('image-index', attribute::id)[1]/filename, '.gif')">
									<xsl:value-of select="substring-before(key('image-index', attribute::id)[1]/filename, '.gif')"/>
								</xsl:when>
							</xsl:choose>
						</xsl:attribute>
					</xsl:element>
					<xsl:element name="caption">
						<xsl:value-of select="./caption"/>
					</xsl:element>
					<xsl:element name="source">
						<xsl:value-of select="./source"/>
					</xsl:element>
				</xsl:element>
				
			</xsl:when>

			<!-- Map Clinical references to evidence scores -->
			<xsl:when test="self::clinical_ref">
				<xsl:element name="evidence-score">
					<xsl:attribute name="score"><xsl:value-of select="./score"/></xsl:attribute>
					<xsl:call-template name="add-current-attributes"/>
					<xsl:element name="comments">
						<xsl:apply-templates select="./comments/node()"/>
					</xsl:element>
					<xsl:if test="./bmj_url">
						<xsl:element name="option-link">
							<xsl:variable name="stubb">
								<xsl:call-template name="substring-after-last">
									<xsl:with-param name="string" select="./bmj_url"/>
									<xsl:with-param name="delimiter">/</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="optionId">
								<xsl:value-of select="substring-before($stubb,'_')"/>
							</xsl:variable>
							<xsl:variable name="interId">
								<xsl:value-of select="substring-after(substring-before($stubb,'.'),'_')"/>
							</xsl:variable>
							<xsl:attribute name="target">../options/_op<xsl:value-of select="$optionId"/>_<xsl:value-of select="$interId"/>.xml</xsl:attribute>
						</xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:when>

			<xsl:when test="self::clinical_refs">
				<xsl:element name="evidence-scores">
					<xsl:apply-templates/>	
				</xsl:element>
			</xsl:when>

			<!-- Modify foot references -->
			<xsl:when test="self::foot">
				<xsl:choose>
					<!-- 
						article ref
						<foot id_ref="21" type="reference"/> [article_ref]
						<reference-link target="../reference/ref-art-90-21.xml"/>
					-->
					<xsl:when test="./@type = 'reference'">
						<xsl:element name="reference-link">
							<!-- target needs to be updated in the java as we dont know the file name yet -->
							<xsl:attribute name="target">article-ref-<xsl:value-of select="./@id_ref"/></xsl:attribute>
							<xsl:attribute name="type">article</xsl:attribute>
						</xsl:element>
					</xsl:when>

					<!--					
						online ref
						<foot id_ref="3" type="resource"/> [online_ref]
						<reference-link target="../reference/ref-ol-90-3.xml"/>
					-->
					<xsl:when test="./@type = 'resource'">
						<xsl:element name="reference-link">
							<!-- target needs to be updated in the java as we dont know the file name yet -->
							<xsl:attribute name="target">olinine-ref-<xsl:value-of select="./@id_ref"/></xsl:attribute>
							<xsl:attribute name="type">online</xsl:attribute>
						</xsl:element>
					</xsl:when>
					
					<!--
						evidence score
						<foot id_ref="2" type="evidence"/> [clinical_ref]
						<evidence-score-link target="../mongraph-standard-evidence-score/evidence-score-6-2.xml"/>
					-->
					<xsl:when test="./@type = 'evidence'">
						<xsl:variable name="scoreid">
							<xsl:value-of select="./@id_ref" />
						</xsl:variable>
						
						
						<xsl:element name="evidence-score-link">
							<xsl:attribute name="target">../monograph-standard-evidence-score/evidence-score-<xsl:value-of select="/*/*/@dx_id"/>-<xsl:value-of select="./@id_ref"/>.xml</xsl:attribute>
							<!-- xsl:attribute name="score"><xsl:value-of select="//clinical_ref[@id=$scoreid]/score"/></xsl:attribute -->
						</xsl:element>
					</xsl:when>
					
				</xsl:choose>
			</xsl:when>


			<!-- Replace related_topic elements which have a dx_id attribute with links -->
			<xsl:when test="self::related_topic">
				<xsl:if test="./@dx_id">
					<xsl:element name="monograph-link">
						<xsl:attribute name="target">
							<xsl:value-of select="attribute::dx_id"/>
						</xsl:attribute>
						<xsl:for-each select="node()">
							<xsl:choose>
								<xsl:when test="name()!='drug'">
									<xsl:value-of select="."/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="node()"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:element>
				</xsl:if>
			</xsl:when>

			<!-- Convert images -->
			<xsl:when test="self::images">
				<xsl:apply-templates/>
			</xsl:when>

			<xsl:when test="self::image_refs">
				<xsl:element name="figures">
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			

			<xsl:when test="self::image">
				<xsl:element name="figure-link">
					<xsl:attribute name="target">
						<xsl:value-of select="$figure-folder"/>
						<xsl:choose>
							<xsl:when test="contains(key('image-index', attribute::id_ref)[1]/filename, '.jpg')">
								<xsl:value-of select="concat(substring-before(key('image-index', attribute::id_ref)[1]/filename, '.jpg'),'.xml')"/>
							</xsl:when>
							<xsl:when test="contains(key('image-index', attribute::id_ref)[1]/filename, '.gif')">
								<xsl:value-of select="concat(substring-before(key('image-index', attribute::id_ref)[1]/filename, '.gif'),'.xml')"/>
							</xsl:when>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="inline"><xsl:value-of select="./@inline"/></xsl:attribute>
				</xsl:element>
			</xsl:when>

			<xsl:otherwise>
				<xsl:call-template name="output-current-element"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- remove drug tags from citations -->
	<!-- xsl:template match="citation">
		<xsl:element name="citation">
			<xsl:for-each select="node()">
				<xsl:choose>
					<xsl:when test="name()!='drug'">
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template -->


	<!-- remove drug tags from disclosures -->
	<!-- xsl:template match="disclosures">
		<xsl:element name="disclosures">
			<xsl:for-each select="node()">
				<xsl:choose>
					<xsl:when test="name()!='drug'">
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template -->


	<!-- remove drug tags from title -->
	<!-- xsl:template match="title">
		<xsl:element name="title">
			<xsl:for-each select="node()">
				<xsl:choose>
					<xsl:when test="name()!='drug'">
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template -->
		
	<!-- remove drug tags from source -->
	<!-- xsl:template match="source">
		<xsl:element name="source">
			<xsl:for-each select="node()">
				<xsl:choose>
					<xsl:when test="name()!='drug'">
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template -->
	

	<!-- remove drug tags from url -->
	<xsl:template match="url">
		<xsl:element name="url">
			<xsl:for-each select="node()">
				<xsl:choose>
					<xsl:when test="name()!='drug'">
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	

	<!-- remove drug tags from fulltext-url -->
	<xsl:template match="fulltext_url">
		<xsl:element name="fulltext-url">
			<xsl:for-each select="node()">
				<xsl:choose>
					<xsl:when test="name()!='drug'">
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	

	<xsl:template match="synonym">
		<xsl:element name="synonym">
			<xsl:attribute name="displayable">true</xsl:attribute>
			<xsl:for-each select="node()">
				<xsl:choose>
					<xsl:when test="name()!='drug'">
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	


	<xsl:template match="risk_factor">
		<xsl:element name="risk-factor">

			<xsl:choose>
				<xsl:when test="./strength/text()">
					<xsl:attribute name="strength">
						<xsl:value-of select="./strength"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="strength">unset</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="self::name">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:when test="self::detail">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template match="factor">
		<xsl:element name="factor">

			<xsl:choose>
				<xsl:when test="./type/text()">
					<xsl:attribute name="type">
						<xsl:value-of select="./type"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="type">unset</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:choose>
				<xsl:when test="./frequency/text()">
					<xsl:attribute name="frequency">
						<xsl:value-of select="./frequency"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="frequency">unset</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:attribute name="key-factor">
				<xsl:value-of select="./key_factor"/>
			</xsl:attribute>

			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="self::factor_name">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:when test="self::detail">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="test">
		<xsl:element name="test">

			<xsl:if test="./@first">
				<xsl:attribute name="first">
					<xsl:value-of select="./@first"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="./@order">
				<xsl:attribute name="order">
					<xsl:value-of select="./@order"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="./type">
				<xsl:attribute name="type">
					<xsl:value-of select="./type"/>
				</xsl:attribute>
			</xsl:if>
			
			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="self::name">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:when test="self::result">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:when test="self::comments">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:when test="self::detail">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:for-each>
			
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="topic_synonyms">
		<xsl:element name="topic-synonyms">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="recomendations">
		<xsl:element name="recommendations">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	





	<xsl:template match="complications">
		<xsl:element name="complications">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	

	<xsl:template match="complication">
		
		<xsl:element name="complication">
			
			<xsl:attribute name="likelihood">
				<xsl:value-of select="./likelihood"/>
			</xsl:attribute>
			
			<xsl:attribute name="timeframe">
				<xsl:value-of select="./timeframe"/>
			</xsl:attribute>
			
			<xsl:if test="./@dx_id">
				<xsl:element name="monograph-link">
					<xsl:attribute name="target">
						<xsl:value-of select="./@dx_id"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="self::name">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:when test="self::detail">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	
	</xsl:template>
	

	<xsl:template match="subtype">
		<xsl:element name="subtype">
			<xsl:if test="./@dx_id">
				<xsl:element name="monograph-link">
					<xsl:attribute name="target">
						<xsl:value-of select="./@dx_id"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="self::name">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:when test="self::detail">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	


	
	<xsl:template match="differential">
		<xsl:element name="differential">
			<xsl:if test="./@dx_id">
				<xsl:element name="monograph-link">
					<xsl:attribute name="target">
						<xsl:value-of select="./@dx_id"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:if>
			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="self::name">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:when test="self::sign_symptoms">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:when test="self::history">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:when test="self::tests">
						<xsl:call-template name="output-current-element"/>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<!-- process treatment options and insert id's and parent id's -->
	<xsl:template match="treatment">
		<xsl:element name="treatment">
			
			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="self::tx_options">
						<xsl:apply-templates select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="output-current-element"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			
			
		</xsl:element>
	</xsl:template>
	
	<!-- xi:include href="../monograph-standard-treatment-option/tx_option-90-1.xml"/ -->
	<xsl:template match="tx_options">
		<xsl:element name="tx-options">
			
			<!-- need to process the child options first, then the parents else will have an import prob -->
			

			<xsl:for-each select="./tx_option">
				
				<xsl:choose>
					<xsl:when test="./parent_pt_group/text()!=''">
						<xsl:variable name="currentId"><xsl:value-of select="position()" /></xsl:variable>	
						<xsl:variable name="monoId"><xsl:value-of select="//monograph_full/@dx_id" /></xsl:variable>
						
						<xsl:choose>
							<xsl:when test="./parent_pt_group/text()!=''"/>
							<xsl:otherwise>
								<!-- this is a parent treatment so add xinclude -->
								<xsl:element name="xi:include">
									<xsl:attribute name="href"><xsl:value-of select="concat('../monograph-standard-treatment-option/tx-option-',$monoId,'-',$currentId,'.xml')"/></xsl:attribute>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>			
						
						<xsl:element name="tx-option">	
							<xsl:attribute name="id"><xsl:value-of select="position()" /></xsl:attribute>
							<xsl:attribute name="timeframe"><xsl:value-of select="./timeframe" /></xsl:attribute>
							
							<xsl:choose>
								<xsl:when test="./tx_line">
									<xsl:attribute name="tx-line">
										<xsl:value-of select="./tx_line"/>
									</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="tx-line">unset</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							
							
							<xsl:variable name="timeframe"><xsl:value-of select="translate(normalize-space(./timeframe), $upper, $lower)"/></xsl:variable>
							<xsl:variable name="pt_group"><xsl:value-of select="translate(normalize-space(./pt_group), $upper, $lower)"/></xsl:variable>
							
							<xsl:for-each select="*">
								<xsl:choose>
									<xsl:when test="self::parent_pt_group"/>
									<xsl:when test="self::timeframe"/>
									<xsl:when test="self::tx_line"/>
									<xsl:otherwise>
										<xsl:call-template name="output-current-element"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
							
							<xsl:element name="tx-options">
								<xsl:for-each select="//tx_option">
									<xsl:variable name="timeframe2"><xsl:value-of select="translate(normalize-space(./timeframe), $upper, $lower)"/></xsl:variable>
									<xsl:variable name="parent_pt_group2"><xsl:value-of select="translate(normalize-space(./parent_pt_group), $upper, $lower)"/></xsl:variable>
									<xsl:if test="($timeframe=$timeframe2) and ($pt_group=$parent_pt_group2)">
										<xsl:variable name="childnum"><xsl:value-of select="position()" /></xsl:variable>
										<xsl:element name="xi:include">
											<xsl:attribute name="href"><xsl:value-of select="concat('../monograph-standard-treatment-option/tx-option-',$monoId,'-',$childnum,'.xml')"/></xsl:attribute>
										</xsl:element>
									</xsl:if>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>			
				
				
			</xsl:for-each>
			
			<xsl:for-each select="./tx_option">
				
				<xsl:choose>
					<xsl:when test="./parent_pt_group/text()!=''"/>
					<xsl:otherwise>
						<xsl:variable name="currentId"><xsl:value-of select="position()" /></xsl:variable>	
						<xsl:variable name="monoId"><xsl:value-of select="//monograph_full/@dx_id" /></xsl:variable>
						
						<xsl:choose>
							<xsl:when test="./parent_pt_group/text()!=''"/>
							<xsl:otherwise>
								<!-- this is a parent treatment so add xinclude -->
								<xsl:element name="xi:include">
									<xsl:attribute name="href"><xsl:value-of select="concat('../monograph-standard-treatment-option/tx-option-',$monoId,'-',$currentId,'.xml')"/></xsl:attribute>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>			
						
						<xsl:element name="tx-option">
							<xsl:attribute name="id"><xsl:value-of select="position()" /></xsl:attribute>
							<xsl:attribute name="timeframe"><xsl:value-of select="./timeframe" /></xsl:attribute>

							<xsl:choose>
								<xsl:when test="./tx_line">
									<xsl:attribute name="tx-line">
										<xsl:value-of select="./tx_line"/>
									</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="tx-line">unset</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							

							<xsl:variable name="timeframe"><xsl:value-of select="translate(normalize-space(./timeframe), $upper, $lower)"/></xsl:variable>
							<xsl:variable name="pt_group"><xsl:value-of select="translate(normalize-space(./pt_group), $upper, $lower)"/></xsl:variable>
							
							<xsl:for-each select="*">
								<xsl:choose>
									<xsl:when test="self::parent_pt_group"/>
									<xsl:when test="self::timeframe"/>
									<xsl:when test="self::tx_line"/>
									
									<xsl:otherwise>
										<xsl:call-template name="output-current-element"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
							
							<xsl:element name="tx-options">
								<xsl:for-each select="//tx_option">
									<xsl:variable name="timeframe2"><xsl:value-of select="translate(normalize-space(./timeframe), $upper, $lower)"/></xsl:variable>
									<xsl:variable name="parent_pt_group2"><xsl:value-of select="translate(normalize-space(./parent_pt_group), $upper, $lower)"/></xsl:variable>
									<xsl:if test="($timeframe=$timeframe2) and ($pt_group=$parent_pt_group2)">
										<xsl:variable name="childnum"><xsl:value-of select="position()" /></xsl:variable>
										<xsl:element name="xi:include">
											<xsl:attribute name="href"><xsl:value-of select="concat('../monograph-standard-treatment-option/tx-option-',$monoId,'-',$childnum,'.xml')"/></xsl:attribute>
										</xsl:element>
									</xsl:if>
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
						
						
						
					</xsl:otherwise>
				</xsl:choose>			
				
				
			</xsl:for-each>
			

		</xsl:element>
	</xsl:template>
	
	<xsl:template match="differentials">
		<xsl:element name="differentials">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="photo">
		<xsl:element name="image-link">
			<xsl:attribute name="target">../monograph-images/<xsl:value-of select="substring-before(., '.')"/></xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="component">
		<xsl:element name="component">
			
			<xsl:choose>
				<xsl:when test="./@modifier">
					<xsl:attribute name="modifier">
						<xsl:value-of select="./@modifier"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="modifier">unset</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			
			
			<xsl:for-each select="*">
				<xsl:call-template name="output-current-element"/>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	

	
	<!--
		***********************************************************************************************
		Commonly used named templates
		*********************************************************************************************** 
	-->

	<!-- Output the current element and its attributes -->
	<xsl:template name="output-current-element">
		<xsl:variable name="name" select="translate(name(), '_', '-')"/>
		<xsl:element name="{$name}">
			<xsl:call-template name="add-current-attributes"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<!-- Add current attributes for this element -->
	<xsl:template name="add-current-attributes">
		<xsl:for-each select="@*">
			<xsl:variable name="name" select="translate(name(), '_', '-')"/>
			<xsl:attribute name="{$name}">
				<xsl:value-of select="."/>
			</xsl:attribute>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="get-pubmed-link">
		<xsl:variable name="pubmed">
			
			<!-- 
				rules for extracting pubmed id
				
				1) url must contain "www.ncbi.nlm.nih.gov" else not a pubmed url
				
				2) if contains url "www.ncbi.nlm.nih.gov/pubmed/" then pub med id always exisists  at the end of the url e.g.
				
				http://www.ncbi.nlm.nih.gov/pubmed/5090209?ordinalpos=2&amp;itool=EntrezSystem2.PEntrez.
				or
				http://www.ncbi.nlm.nih.gov/pubmed/15533067
			
				3) Other pub med urls have the id after the param list_uids e.g. 
				
				http://www.ncbi.nlm.nih.gov/sites/entrez?cmd=Retrieve&amp;db=PubMed&amp;list_uids=4195865&amp;dopt=Abstract
				or
				http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=Retrieve&amp;db=PubMed&amp;dopt=Citation&amp;list_uids=16033736
			
			-->
			
			<xsl:variable name="url">
				<xsl:value-of select="descendant::abstract_url"/>
			</xsl:variable>
			
			<xsl:choose>
				<!-- rule 1 -->
				<xsl:when test="contains($url,'www.ncbi.nlm.nih.gov')">
					<xsl:choose>
						<!-- rule 2 -->
						<xsl:when test="contains($url,'www.ncbi.nlm.nih.gov/pubmed/')">
							<!-- get string after pubmed -->
							<xsl:variable name="urlchop">
								<xsl:value-of select="substring-after($url, '/pubmed/')"/>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="contains($urlchop,'?')">
									<xsl:value-of select="substring-before($urlchop, '?')"/>
								</xsl:when>
								<xsl:when test="contains($urlchop,'&amp;')">
									<xsl:value-of select="substring-before($urlchop, '&amp;')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$urlchop"/>
								</xsl:otherwise>
							</xsl:choose>		
						</xsl:when>
						
						<!-- rule 3 -->
						<xsl:otherwise>
							<xsl:variable name="urlchop">
								<xsl:value-of select="substring-after($url, 'list_uids=')"/>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="contains($urlchop,'&amp;')">
									<xsl:value-of select="substring-before($urlchop, '&amp;')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$urlchop"/>
								</xsl:otherwise>
							</xsl:choose>		
						</xsl:otherwise>
					</xsl:choose>					
				</xsl:when>
				<xsl:otherwise>
					<!-- the url is empty or not a pubmed url -->
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="string-length($pubmed) > 0">
				<xsl:element name="unique-id">
					<xsl:attribute name="source">medline</xsl:attribute>
					<xsl:value-of select="$pubmed"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="substring-after-last">
		<xsl:param name="string"/>
		<xsl:param name="delimiter"/>
		<xsl:choose>
			<xsl:when test="contains($string, $delimiter)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
</xsl:stylesheet>

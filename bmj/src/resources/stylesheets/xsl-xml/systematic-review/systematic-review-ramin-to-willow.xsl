<?xml version="1.0" encoding="us-ascii"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output 
		method="xml" 
		encoding="us-ascii" 
		indent="yes" 
		doctype-public="-//BMJ//DTD CONTRIBUTION//EN" 
		doctype-system="http://schema.bmj.com/archive/willow/condition.dtd"/>

	<xsl:param name="ramin-xml-input"/>
	<xsl:variable name="pagenum-text">, p 000</xsl:variable>

	<xsl:template match="/">

		<xsl:for-each select="condition">
			
			<CONTRIBUTION>
				
				<SECTIONINFO>
					<!-- copy section details xml system document fragment here -->
					<xsl:copy-of select="document(concat($ramin-xml-input, 'section/', /condition/section/@id, '.xml'))/SECTION-DETAILS/*"/>
					<TOPIC>
						<TOPICID>
							<xsl:value-of select="/condition/@id"/>
						</TOPICID>
						<TOPICTITLE>
							<xsl:apply-templates select="condition-long-title"/>
							<!--<xsl:if test="(@status='new')">&#160;<xsl:processing-instruction name="xpp">new</xsl:processing-instruction></xsl:if>-->
						</TOPICTITLE>
						<SHORTTOPIC>
							<xsl:apply-templates select="condition-abridged-title"/>
						</SHORTTOPIC>
						<TOPICSTATUS>
							<xsl:apply-templates select="search-date"/>
						</TOPICSTATUS>
					</TOPIC>
					<COLLECTIVENAME>
						<xsl:apply-templates select="collective-name"/>
						<xsl:for-each select="link">
							<xsl:apply-templates/>
						</xsl:for-each>
					</COLLECTIVENAME>
				</SECTIONINFO>
				
				<SUMMARY>
				
					<QUESTIONS>
						<xsl:for-each select="question-section">
							<xsl:for-each select="question">
								<xsl:for-each select="question-long-title">
									<xsl:element name="P">
										<xsl:apply-templates select="."/>
										<xsl:element name="XREF">
											<xsl:attribute name="REFID"><xsl:value-of select="../@id"/></xsl:attribute>
										</xsl:element>
									</xsl:element>
								</xsl:for-each>
							</xsl:for-each>
						</xsl:for-each>
					</QUESTIONS>
					
					<INTERVENTIONS>
						<xsl:for-each select="question-section">
							<xsl:for-each select="question">
								<INTERVTITLE>
									<xsl:element name="P">
										<xsl:apply-templates select="question-abridged-title"/>
									</xsl:element>
								</INTERVTITLE>
								<!-- Build 'beneficial' list -->
								<xsl:if test="(option/summary/intervention-title[@type='beneficial'])">
									<BENEFICIAL>
										<xsl:for-each select="(option/summary/intervention-title[@type='beneficial'])">
											<xsl:sort select="."/>
											<xsl:element name="P">
												<!-- <xsl:attribute name="STATUS">new</xsl:attribute> -->
												<xsl:apply-templates/>
												<xsl:if test="(../../substantive-change/p/@status='new-option')">&#160;<xsl:processing-instruction name="xpp">new</xsl:processing-instruction>
												</xsl:if>
												<xsl:element name="XREF">
													<xsl:attribute name="REFID"><xsl:value-of select="../../@id"/></xsl:attribute>
												</xsl:element>
											</xsl:element>
										</xsl:for-each>
									</BENEFICIAL>
								</xsl:if>
								<!-- Build 'likely-to-be-beneficial' list -->
								<xsl:if test="(option/summary/intervention-title[@type='likely-to-be-beneficial'])">
									<LIKELYBENEFICIAL>
										<xsl:for-each select="(option/summary/intervention-title[@type='likely-to-be-beneficial'])">
											<xsl:sort select="."/>
											<xsl:element name="P">
												<xsl:apply-templates/>
												<xsl:if test="(../../substantive-change/p/@status='new-option')">&#160;<xsl:processing-instruction name="xpp">new</xsl:processing-instruction>
												</xsl:if>
												<xsl:element name="XREF">
													<xsl:attribute name="REFID"><xsl:value-of select="../../@id"/></xsl:attribute>
												</xsl:element>
											</xsl:element>
										</xsl:for-each>
									</LIKELYBENEFICIAL>
								</xsl:if>
								<!-- Build 'trade-off-between-benefits-and-harms' list -->
								<xsl:if test="(option/summary/intervention-title[@type='trade-off-between-benefits-and-harms'])">
									<TRADEOFF>
										<xsl:for-each select="(option/summary/intervention-title[@type='trade-off-between-benefits-and-harms'])">
											<xsl:sort select="."/>
											<xsl:element name="P">
												<xsl:apply-templates/>
												<xsl:if test="(../../substantive-change/p/@status='new-option')">&#160;<xsl:processing-instruction name="xpp">new</xsl:processing-instruction>
												</xsl:if>
												<xsl:element name="XREF">
													<xsl:attribute name="REFID"><xsl:value-of select="../../@id"/></xsl:attribute>
												</xsl:element>
											</xsl:element>
										</xsl:for-each>
									</TRADEOFF>
								</xsl:if>
								<!-- Build 'unknown-effectiveness' list -->
								<xsl:if test="(option/summary/intervention-title[@type='unknown-effectiveness'])">
									<UNKNOWNEFFECTIVENESS>
										<xsl:for-each select="(option/summary/intervention-title[@type='unknown-effectiveness'])">
											<xsl:sort select="."/>
											<xsl:element name="P">
												<xsl:apply-templates/>
												<xsl:if test="(../../substantive-change/p/@status='new-option')">&#160;<xsl:processing-instruction name="xpp">new</xsl:processing-instruction>
												</xsl:if>
												<xsl:element name="XREF">
													<xsl:attribute name="REFID"><xsl:value-of select="../../@id"/></xsl:attribute>
												</xsl:element>
											</xsl:element>
										</xsl:for-each>
									</UNKNOWNEFFECTIVENESS>
								</xsl:if>
								<!-- Build 'unlikely-to-be-beneficial' list -->
								<xsl:if test="(option/summary/intervention-title[@type='unlikely-to-be-beneficial'])">
									<UNLIKELYBENEFICIAL>
										<xsl:for-each select="(option/summary/intervention-title[@type='unlikely-to-be-beneficial'])">
											<xsl:sort select="."/>
											<xsl:element name="P">
												<xsl:apply-templates/>
												<xsl:if test="(../../substantive-change/p/@status='new-option')">&#160;<xsl:processing-instruction name="xpp">new</xsl:processing-instruction>
												</xsl:if>
												<xsl:element name="XREF">
													<xsl:attribute name="REFID"><xsl:value-of select="../../@id"/></xsl:attribute>
												</xsl:element>
											</xsl:element>
										</xsl:for-each>
									</UNLIKELYBENEFICIAL>
								</xsl:if>
								<!-- Build 'likely-to-be-ineffective-or-harmful' list -->
								<xsl:if test="(option/summary/intervention-title[@type='likely-to-be-ineffective-or-harmful'])">
									<INEFFHARMFUL>
										<xsl:for-each select="(option/summary/intervention-title[@type='likely-to-be-ineffective-or-harmful'])">
											<xsl:sort select="."/>
											<xsl:element name="P">
												<xsl:apply-templates/>
												<xsl:if test="(../../substantive-change/p/@status='new-option')">&#160;<xsl:processing-instruction name="xpp">new</xsl:processing-instruction>
												</xsl:if>
												<xsl:element name="XREF">
													<xsl:attribute name="REFID"><xsl:value-of select="../../@id"/></xsl:attribute>
												</xsl:element>
											</xsl:element>
										</xsl:for-each>
									</INEFFHARMFUL>
								</xsl:if>
								<!-- Build 'categorisation' *not applied* list -->
								<xsl:if test="(option/summary/intervention-title[@type='categorisation'])">
									<INTERVTITLE>
										<xsl:for-each select="(option/summary/intervention-title[@type='categorisation'])">
											<xsl:sort select="."/>
											<xsl:element name="P">
												<xsl:apply-templates/>[NOT-CATEGORISED]
											</xsl:element>
										</xsl:for-each>
									</INTERVTITLE>
								</xsl:if>
							</xsl:for-each>
						</xsl:for-each>
						
						<!-- subsequent-update -->
						<xsl:if test="subsequent-update/p[1][string-length(.)!=0]">
							<SUBSISSUE>
								<xsl:for-each select="subsequent-update">
									<xsl:apply-templates/>
								</xsl:for-each>
							</SUBSISSUE>
						</xsl:if>
						
						<!-- covered-elsewhere -->
						<xsl:if test="covered-elsewhere/p[1][string-length(.)!=0]">
							<COVEREDELSEWHERE>
								<xsl:for-each select="covered-elsewhere">
									<xsl:apply-templates/>
								</xsl:for-each>
							</COVEREDELSEWHERE>
						</xsl:if>
						
						<!-- summary-footnote -->
						<xsl:if test="summary-footnote/p[1][string-length(.)!=0] or /condition/glossary/p[@id][1]">
							<FOOTNOTE>
								<xsl:for-each select="summary-footnote">
									<xsl:apply-templates/>
								</xsl:for-each>								
								<xsl:if test="/condition/glossary/p[@id][1]">
									<!-- Note: if white space here is created by print 
									pretty then conversion to xpp isn't going to work -->
									<xsl:element name="P"><xsl:element name="XREF"><xsl:attribute name="REFID"><xsl:value-of select="/condition/glossary/p[@id][1]/@id"/></xsl:attribute>See glossary</xsl:element></xsl:element>
								</xsl:if>
							</FOOTNOTE>
						</xsl:if>
						
					</INTERVENTIONS>

					<KEYMESSAGES ID="KEYMESSAGES">

						<!-- if there is an over-arching key-message for the condition 
						we would like to put it here at the top of the key-message section -->
						<xsl:choose>
				
							<!-- new key-points -->
							<xsl:when test="/condition/key-point/title[1][string-length(.)!=0] or /condition/key-point/p[1][string-length(.)!=0]">
							
								<xsl:attribute name="TYPE">
									<xsl:text>KEYPOINT</xsl:text>
								</xsl:attribute>
							
								<xsl:for-each select="/condition/key-point/element()">
								
									<xsl:if test="name()='title'">
									
										<xsl:element name="KMTITLE">
											<xsl:apply-templates/>
										</xsl:element>
										
									</xsl:if>
									
									<xsl:if test="name()='p'">
									
										<xsl:if test="not( name(preceding-sibling::element()[1]) = 'p' )">
											<xsl:text disable-output-escaping="yes">&lt;KMLIST&gt;</xsl:text>
										</xsl:if>

										<xsl:element name="P">
											<xsl:apply-templates/>
										</xsl:element>
										
										<xsl:if test="not( name(following-sibling::element()[1]) = 'p' )">
											<xsl:text disable-output-escaping="yes">&lt;/KMLIST&gt;</xsl:text>
										</xsl:if>
										
									</xsl:if>
									
								</xsl:for-each>
								
							</xsl:when>
							
							<!-- old key-messages -->
							<xsl:otherwise>
							
								<xsl:attribute name="TYPE">
									<xsl:text>KEYMESSAGE</xsl:text>
								</xsl:attribute>
							
								<xsl:if test="/condition/key-message[1][string-length(.)!=0]">
								
									<xsl:element name="KMLIST">
										<xsl:for-each select="/condition/key-message">
											<xsl:element name="P"><xsl:apply-templates select="node()"/></xsl:element>
										</xsl:for-each>
									</xsl:element>							
								
								</xsl:if>
								
								<xsl:for-each select="//question">
								
									<KMTITLE>
										<xsl:apply-templates select="question-abridged-title"/>
									</KMTITLE>
									
									<KMLIST>
										
										<!-- kmojar 20051116 removed alphabetical order for efficacy ordering
										<xsl:if test="(option/summary/intervention-title)">
											<xsl:for-each select="(option/summary/intervention-title)">
												<xsl:sort select="."/>
												<xsl:element name="P">
													<xsl:element name="B">
														<xsl:apply-templates/>
													</xsl:element>
													<xsl:text disable-output-escaping="yes"> </xsl:text>
													<xsl:apply-templates select="../key-message"/>
												</xsl:element>
											</xsl:for-each>
										</xsl:if>
										-->
		
										<xsl:if test="(option/summary/intervention-title[@type='beneficial'])">
											<xsl:for-each select="(option/summary/intervention-title[@type='beneficial'])">
												<xsl:sort select="."/>
												<xsl:element name="P">
													<xsl:element name="B">
														<xsl:apply-templates/>
													</xsl:element>
													<xsl:text disable-output-escaping="yes"> </xsl:text>
													<xsl:apply-templates select="../key-message"/>
												</xsl:element>
											</xsl:for-each>
										</xsl:if>
										
										<xsl:if test="(option/summary/intervention-title[@type='likely-to-be-beneficial'])">
											<xsl:for-each select="(option/summary/intervention-title[@type='likely-to-be-beneficial'])">
												<xsl:sort select="."/>
												<xsl:element name="P">
													<xsl:element name="B">
														<xsl:apply-templates/>
													</xsl:element>
													<xsl:text disable-output-escaping="yes"> </xsl:text>
													<xsl:apply-templates select="../key-message"/>
												</xsl:element>
											</xsl:for-each>
										</xsl:if>
										
										<xsl:if test="(option/summary/intervention-title[@type='trade-off-between-benefits-and-harms'])">
											<xsl:for-each select="(option/summary/intervention-title[@type='trade-off-between-benefits-and-harms'])">
												<xsl:sort select="."/>
												<xsl:element name="P">
													<xsl:element name="B">
														<xsl:apply-templates/>
													</xsl:element>
													<xsl:text disable-output-escaping="yes"> </xsl:text>
													<xsl:apply-templates select="../key-message"/>
												</xsl:element>
											</xsl:for-each>
										</xsl:if>
										
										<xsl:if test="(option/summary/intervention-title[@type='unknown-effectiveness'])">
											<xsl:for-each select="(option/summary/intervention-title[@type='unknown-effectiveness'])">
												<xsl:sort select="."/>
												<xsl:element name="P">
													<xsl:element name="B">
														<xsl:apply-templates/>
													</xsl:element>
													<xsl:text disable-output-escaping="yes"> </xsl:text>
													<xsl:apply-templates select="../key-message"/>
												</xsl:element>
											</xsl:for-each>
										</xsl:if>
										
										<xsl:if test="(option/summary/intervention-title[@type='unlikely-to-be-beneficial'])">
											<xsl:for-each select="(option/summary/intervention-title[@type='unlikely-to-be-beneficial'])">
												<xsl:sort select="."/>
												<xsl:element name="P">
													<xsl:element name="B">
														<xsl:apply-templates/>
													</xsl:element>
													<xsl:text disable-output-escaping="yes"> </xsl:text>
													<xsl:apply-templates select="../key-message"/>
												</xsl:element>
											</xsl:for-each>
										</xsl:if>
										
										<xsl:if test="(option/summary/intervention-title[@type='likely-to-be-ineffective-or-harmful'])">
											<xsl:for-each select="(option/summary/intervention-title[@type='likely-to-be-ineffective-or-harmful'])">
												<xsl:sort select="."/>
												<xsl:element name="P">
													<xsl:element name="B">
														<xsl:apply-templates/>
													</xsl:element>
													<xsl:text disable-output-escaping="yes"> </xsl:text>
													<xsl:apply-templates select="../key-message"/>
												</xsl:element>
											</xsl:for-each>
										</xsl:if>
									
									</KMLIST>
								
								</xsl:for-each>
								
							</xsl:otherwise>
							
						</xsl:choose>
						
						<!-- evidence-in-practice -->
						<xsl:if test="/condition/evidence-in-practice/p[1][string-length(.)!=0]">

							<KMTITLE>Evidence into practice</KMTITLE>
							<KMLIST>
								<xsl:for-each select="/condition/evidence-in-practice/p">
									<xsl:element name="P"><xsl:apply-templates/></xsl:element>
								</xsl:for-each>
							</KMLIST>

						</xsl:if>
						
						<!-- summary-footnote -->
						<xsl:if test="summary-footnote/p[1][string-length(.)!=0] and (not(/condition/key-point/title[1][string-length(.)!=0]) or not(/condition/key-point/p[1][string-length(.)!=0]))">
							<KMLIST>
								<xsl:processing-instruction name="xpp">summary-footnote</xsl:processing-instruction>
								<xsl:for-each select="summary-footnote/p">
									<xsl:apply-templates select="."/>
								</xsl:for-each>
							</KMLIST>
						</xsl:if>

					</KEYMESSAGES>
					
					<xsl:for-each select="background">					
						<xsl:for-each select="definition">
							<DEFINITION ID="DEFINITION">
								<xsl:element name="P">
									<xsl:apply-templates/>
								</xsl:element>
							</DEFINITION>
						</xsl:for-each>
						<xsl:for-each select="incidence">
							<INCIDENCE ID="INCIDENCE">
								<xsl:element name="P">
									<xsl:apply-templates/>
								</xsl:element>
							</INCIDENCE>
						</xsl:for-each>
						<xsl:for-each select="aetiology">
							<AETIOLOGY ID="AETIOLOGY">
								<xsl:element name="P">
									<xsl:apply-templates/>
								</xsl:element>
							</AETIOLOGY>
						</xsl:for-each>

						<xsl:for-each select="diagnosis">
							<xsl:if test="string-length(.)!=0">
								<DIAGNOSIS ID="DIAGNOSIS">
									<xsl:element name="P">
										<xsl:apply-templates/>
									</xsl:element>
								</DIAGNOSIS>
							</xsl:if>
						</xsl:for-each>
						
						<xsl:for-each select="prognosis">
							<PROGNOSIS ID="PROGNOSIS">
								<xsl:element name="P">
									<xsl:apply-templates/>
								</xsl:element>
							</PROGNOSIS>
						</xsl:for-each>
						<xsl:for-each select="aims">
							<AIMS ID="AIMS">
								<xsl:element name="P">
									<xsl:apply-templates/>
								</xsl:element>
							</AIMS>
						</xsl:for-each>
						<xsl:for-each select="outcomes">
							<OUTCOMES ID="OUTCOMES">
								<xsl:element name="P">
									<xsl:apply-templates/>
								</xsl:element>
							</OUTCOMES>
						</xsl:for-each>
						<xsl:for-each select="methods">
							<METHODS ID="METHODS">
								<xsl:element name="P">
									<xsl:apply-templates/>
								</xsl:element>	
							</METHODS>
						</xsl:for-each>

						<!--
						<xsl:for-each select="search-strategy">
							<xsl:if test="p[1][string-length(.)!=0]">
								<SEARCH-STRATEGY ID="STRATEGY">
									<xsl:apply-templates/>
								</SEARCH-STRATEGY>
							</xsl:if>
						</xsl:for-each>
						-->

					</xsl:for-each>
				</SUMMARY>
				
				<INTERVSECTION>
				
					<QUESTIONSECTION>
					
						<xsl:for-each select="question-section">
						
							<xsl:for-each select="question">
							
								<QUESTION>
									<QUESTIONTITLE>
										<xsl:attribute name="ID"><xsl:value-of select="@id"/></xsl:attribute>
										<xsl:apply-templates select="question-long-title"/>
									</QUESTIONTITLE>
									<SHORTQUESTION>
										<xsl:apply-templates select="question-abridged-title"/>
									</SHORTQUESTION>
									<xsl:for-each select="contributor">
										<QUESTIONAUTHOR>
											<xsl:apply-templates select="."/>
										</QUESTIONAUTHOR>
									</xsl:for-each>
									
									<xsl:for-each select="option">
									
										<OPTION>
											<OPTIONTITLE>
												<xsl:attribute name="ID"><xsl:value-of select="@id"/></xsl:attribute>
												<!-- <xsl:if test="(substantive-change/p/@status='new-option')"><xsl:attribute name="STATUS">new</xsl:attribute></xsl:if> -->
												<xsl:apply-templates select="option-long-title"/>
												<xsl:if test="(substantive-change/p/@status='new-option')">&#160;<xsl:processing-instruction name="xpp">new2</xsl:processing-instruction></xsl:if>
											</OPTIONTITLE>
											<SHORTOPTION>
												<xsl:apply-templates select="option-abridged-title"/>
											</SHORTOPTION>
											<xsl:for-each select="contributor">
												<OPTIONAUTHOR>
													<xsl:apply-templates select="."/>
												</OPTIONAUTHOR>
											</xsl:for-each>
											<SUMSTATEMENT>
												<xsl:attribute name="ID"><xsl:value-of select="@id"/>-SUMSTATEMENT</xsl:attribute>
												<xsl:choose>
													<xsl:when test="key-message[string-length(.)!=0]">
														<xsl:apply-templates select="key-message"/>
													</xsl:when>
													<xsl:when test="count(summary) &gt; 1">[OPTION LEVEL KEY-MESSAGE NOT APPLIED AS MORE THAN ONE INTERVENTION-TITLE/KEY-MESSAGE]</xsl:when>
													<xsl:when test="count(summary) = 1">
														<xsl:apply-templates select="summary/key-message"/>
													</xsl:when>
												</xsl:choose>
												<xsl:if test="drug-safety-alert/p[2][string-length(.)!=0]">
													<xsl:text disable-output-escaping="yes"> </xsl:text>
													<xsl:value-of select="drug-safety-alert/p[2]"/>
												</xsl:if>
											</SUMSTATEMENT>

											<BENEFITS>
												<xsl:attribute name="ID"><xsl:value-of select="@id"/>-BENEFITS</xsl:attribute>
												<xsl:choose>
													<xsl:when test="benefits/p">
														<xsl:for-each select="benefits/p">
															<xsl:apply-templates/>
															<xsl:text disable-output-escaping="yes"> </xsl:text>
														</xsl:for-each>
													</xsl:when>
													<xsl:otherwise>
														<xsl:apply-templates select="benefits"/>
													</xsl:otherwise>
												</xsl:choose>											
											</BENEFITS>
											
											<HARMS>
												<xsl:attribute name="ID"><xsl:value-of select="@id"/>-HARMS</xsl:attribute>
												<xsl:choose>
													<xsl:when test="harms/p">
														<xsl:for-each select="harms/p">
															<xsl:apply-templates/>
															<xsl:text disable-output-escaping="yes"> </xsl:text>
														</xsl:for-each>
													</xsl:when>
													<xsl:otherwise>
														<xsl:apply-templates select="harms"/>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:if test="drug-safety-alert/p[2][string-length(.)!=0]">
													<xsl:text disable-output-escaping="yes"> </xsl:text>
													<B>Drug safety alert:</B>
													<xsl:text disable-output-escaping="yes"> </xsl:text>
													<xsl:value-of select="drug-safety-alert/p[2]"/>
												</xsl:if>
											</HARMS>

											<COMMENT>
												<xsl:attribute name="ID"><xsl:value-of select="@id"/>-COMMENT</xsl:attribute>
												<xsl:choose>
													<xsl:when test="evidence-in-practice/p[1][string-length(.)!=0]">
														<xsl:for-each select="evidence-in-practice/p">
															<xsl:apply-templates/>
															<xsl:text disable-output-escaping="yes"> </xsl:text>
															<!-- 
																<xsl:processing-instruction name="xpp">qa</xsl:processing-instruction>
															-->
														</xsl:for-each>
													</xsl:when>
													<xsl:when test="comment/p">
														<xsl:for-each select="comment/p">
															<xsl:apply-templates/>
															<xsl:text disable-output-escaping="yes"> </xsl:text>
														</xsl:for-each>
													</xsl:when>
													<xsl:otherwise>
														<xsl:apply-templates select="comment"/>
													</xsl:otherwise>
												</xsl:choose>
											</COMMENT>

											<xsl:for-each select="substantive-change">
												<xsl:if test="p/@status">
													<SUBSCHANGE>
														<xsl:for-each select="p">
															<xsl:element name="P">
																<xsl:if test="@status">
																	<xsl:attribute name="STATUS"><xsl:value-of select="@status"/></xsl:attribute>
																</xsl:if>
																<xsl:apply-templates/>
															</xsl:element>
														</xsl:for-each>
													</SUBSCHANGE>
												</xsl:if>
											</xsl:for-each>

										</OPTION>
									</xsl:for-each>
								</QUESTION>
							</xsl:for-each>
						</xsl:for-each>
					</QUESTIONSECTION>
					<xsl:for-each select="glossary">
						<xsl:if test="p[1][string-length(.)!=0]">
							<GLOSSARY>
								<xsl:apply-templates/>
							</GLOSSARY>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="//substantive-change/p[1][string-length()&gt;0]">
						<SUBSCHANGE>
							<xsl:for-each select="//substantive-change">
								<xsl:apply-templates/>
							</xsl:for-each>
						</SUBSCHANGE>
					</xsl:if>
					<xsl:for-each select="reference-section">
						<REFERENCESECTION>
							<xsl:for-each select="reference">
								<REFERENCE>
									<xsl:if test="number(@pubmed-id)">
										<xsl:attribute name="TYPE">pubmed</xsl:attribute>
										<xsl:attribute name="URL" select="@pubmed-id"/>
									</xsl:if>
									<REFERENCENUMBER>
										<xsl:value-of select="substring(@id,4)"/>
									</REFERENCENUMBER>
									<REFERENCEDETAILS>
										<xsl:attribute name="ID"><xsl:value-of select="@id"/></xsl:attribute>
										<xsl:apply-templates/>
									</REFERENCEDETAILS>
								</REFERENCE>
							</xsl:for-each>
						</REFERENCESECTION>
					</xsl:for-each>
					<!-- copy ####_contribdetails.xml xml system document fragment here -->
					<xsl:copy-of select="document(concat($ramin-xml-input, 'author/', /condition/@id, '_authors.xml'))/CONTRIBDETAILS-COMPINTERESTS/*"/>
				</INTERVSECTION>
				<!-- FIXME: don't want absolute path -->
				<xsl:if test="(/condition/additional-note/sys-link[@type='system-table' or @type='system-figure'])">
					<TABSFIGS>
						<xsl:apply-templates select="additional-note"/>
					</TABSFIGS>
				</xsl:if>
			</CONTRIBUTION>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="additional-note">
		<!-- does nothing here if web-table and web-figure -->
		<xsl:for-each select="sys-link[@type='system-table']">
			<xsl:copy-of select="document(concat($ramin-xml-input, 'table/', /condition/@id, '_table_', substring(@refid,2), '.xml'))/*"/>
		</xsl:for-each>
		<xsl:for-each select="sys-link[@type='system-figure']">
			<!-- LX: NB: Missing comma after 2nd substring() call caused script to break. But XMLSpy allowed it -->
			<xsl:copy-of select="document(concat($ramin-xml-input, 'figure/', /condition/@id, '_figure_', substring(@refid,2), '.xml'))/*"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="strong">
		<xsl:element name="B">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="em">
		<xsl:element name="I">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="u">
		<xsl:element name="U">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="sup">
		<xsl:element name="SUP">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="sub">
		<xsl:element name="SUB">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="BR">
		<xsl:element name="BR"/>
	</xsl:template>
	<xsl:template match="processing-instruction()">
		<xsl:copy/>
	</xsl:template>
	<xsl:template match="comment()">
		<xsl:copy/>
	</xsl:template>
	<xsl:template match="link">
		<xsl:choose>
			<xsl:when test="@type='internal-target'">
				<xsl:element name="XREF">
					<xsl:attribute name="REFID"><xsl:value-of select="translate(@refid,'abcdefghijklmnopqrstuvwxyz_','ABCDEFGHIJKLMNOPQRSTUVWXYZ-')"/></xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@type='internal-glossary'">
				<xsl:element name="XREF">
					<xsl:attribute name="REFID"><xsl:value-of select="translate(@refid,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@type='internal-table'">
				<xsl:element name="XREF">
					<xsl:attribute name="REFID"><xsl:apply-templates select="@refid"/></xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@type='internal-figure'">
				<xsl:element name="XREF">
					<xsl:attribute name="REFID"><xsl:apply-templates select="@refid"/></xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@type='web-table'">
				<xsl:element name="EXTREF">
					<xsl:attribute name="TYPE">WEBEXTRA</xsl:attribute>
					<xsl:attribute name="FILENAME"><xsl:apply-templates select="@refid"/></xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@type='web-figure'">
				<xsl:element name="EXTREF">
					<xsl:attribute name="TYPE">WEBEXTRA</xsl:attribute>
					<xsl:attribute name="FILENAME"><xsl:apply-templates select="@refid"/></xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<!--
				<link type="change-start" refid="C1"/> 
				<REV POSITION="START" REFID="C1"/>
			-->
			<xsl:when test="@type='change-start'">
				<xsl:element name="REV">
					<xsl:attribute name="POSITION">START</xsl:attribute>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@type='change-end'">
				<xsl:element name="REV">
					<xsl:attribute name="POSITION">END</xsl:attribute>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ext-link">
		<xsl:choose>
			<xsl:when test="@type='external-condition'">
				<xsl:element name="EXTREF">
					<xsl:attribute name="TYPE">CONDITION</xsl:attribute>
					<xsl:attribute name="FILENAME"><xsl:value-of select="@refid"/></xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="@type='external-url'">
				<xsl:element name="EXTREF">
					<xsl:attribute name="TYPE">URL</xsl:attribute>
					<xsl:attribute name="FILENAME"><xsl:value-of select="@refid"/></xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="process-text">
		<xsl:param name="str"/>
		<xsl:choose>
			<xsl:when test="contains($str,'[')">
				<xsl:variable name="target">
					<xsl:value-of select="substring-before(substring-after($str, '['), ']')"/>
				</xsl:variable>
				<!-- if the stuff in square brackets is an integer, add a reference link -->
				<xsl:choose>
					<xsl:when test="matches($target, '^\d+$')">
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-before($str,'[')"/>
						</xsl:call-template>
						<xsl:element name="XREF">
							<xsl:attribute name="REFID">
								<xsl:text>REF</xsl:text>
								<xsl:value-of select="$target"/>
							</xsl:attribute>
							<!--xsl:attribute name="remainder" select="substring-after(substring-after($str, '['), ']')"/-->
						</xsl:element>
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-after(substring-after($str, '['), ']')"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<!-- there might be more square brackets later... -->
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-before($str,'[')"/>
						</xsl:call-template>
						<xsl:text>[</xsl:text>
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-after($str,'[')"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<xsl:when test="contains($str, $pagenum-text)">
				<xsl:call-template name="process-text">
					<xsl:with-param name="str" select="substring-before($str, $pagenum-text)"/>
				</xsl:call-template>
				<xsl:processing-instruction name="xpp">pagenumber</xsl:processing-instruction>
				<xsl:call-template name="process-text">
					<xsl:with-param name="str" select="substring-after($str, $pagenum-text)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="text()">
		<!--xsl:variable name="references-expanded"></xsl:variable-->
		<xsl:call-template name="process-text">
			<xsl:with-param name="str" select="."/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="collective-name/link">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<xsl:template match="p">
		<xsl:if test="string-length(.)">
			<xsl:element name="P">
				<xsl:if test="@id">
					<xsl:attribute name="ID" select="@id"/>
				</xsl:if>
				<!--
				<xsl:if test="@status">
					<xsl:attribute name="STATUS" select="@status"/>
				</xsl:if>
				-->
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
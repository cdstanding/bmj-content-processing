<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="1.1"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html">

	<xsl:output 
		method="xml" 
		indent="yes" 
		encoding="iso-8859-1"/>

	<xsl:param name="ramin-xml-input"/>
	<xsl:param name="makefile-input"/>

	<xsl:variable name="pagenum-text">, p 000</xsl:variable>
    <xsl:variable name="topicId" select="/CONTRIBUTION/SECTIONINFO/TOPIC/TOPICID"/>
	<xsl:variable name="cid" select="//TOPICID"/>
	<xsl:variable name="ramin-question-section">
		<xsl:copy-of select="document(concat($ramin-xml-input, $cid, '.xml'))//question-section"/>
	</xsl:variable>
	
	<!-- array'ish for building keymessages --> 
	<xsl:variable name="list">
		<list>
			<efficacy type="beneficial"/>
			<efficacy type="likely-to-be-beneficial"/>
			<efficacy type="trade-off-between-benefits-and-harms"/>
			<efficacy type="unknown-effectiveness"/>
			<efficacy type="unlikely-to-be-beneficial"/>
			<efficacy type="likely-to-be-ineffective-or-harmful"/>
		</list>
	</xsl:variable>
	
	<!-- TODO do we need these? -->
	<xsl:namespace-alias stylesheet-prefix="cals" result-prefix="cals"/>
	<xsl:namespace-alias stylesheet-prefix="xsi" result-prefix="xsi"/>

	<!-- template that matches the root element -->
	<xsl:template match="CONTRIBUTION">
		<condition>
			<!-- internal ID of the condition -->
			<xsl:variable name="topicId"><xsl:value-of select="SECTIONINFO/TOPIC/TOPICID"/></xsl:variable>
			<xsl:attribute name="id"><xsl:value-of select="$topicId"/></xsl:attribute>
			
			<!--
			<xsl:attribute name="version">0.1</xsl:attribute>
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">condition.xsd</xsl:attribute>
			<xsl:attribute name="schemaVersion">0.2.03</xsl:attribute>
			-->
	
			<!-- status of the condition -->
			<xsl:variable 
				name="pubstatus" 
				select="document($makefile-input)/CONDITIONS/SECTION/CONDITION[@ID=$topicId and @DOCTYPE='condition']/@PUBSTATUS"/>
			
			<!--<xsl:attribute name="pubstatus" select="$pubstatus"/>-->
			<!-- is the topic new -->
			<xsl:if test="$pubstatus='new'">
				<xsl:attribute name="is-new">true</xsl:attribute>
			</xsl:if>
			
			<!-- is the topic updated -->
			<xsl:if test="starts-with($pubstatus, 'update')"><xsl:attribute name="is-updated">true</xsl:attribute></xsl:if>
			
			<!-- is the topic archived -->
			<xsl:if test="starts-with($pubstatus, 'archive')"><xsl:attribute name="is-archived">true</xsl:attribute></xsl:if>
			<xsl:if test="starts-with($pubstatus, 'pull')"><xsl:attribute name="is-archived">true</xsl:attribute></xsl:if>
	
			<!-- loop through each question in turn -->
			<xsl:variable name="questionDocument">
				<questions>
					<xsl:for-each select="INTERVSECTION/QUESTIONSECTION/QUESTION">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</questions>
			</xsl:variable>

			<!--
				convert the whole SECTIONINFO element
			-->
			<xsl:apply-templates select="SECTIONINFO" mode="lc_generic">
				<xsl:with-param name="questionDocument">
					<xsl:copy-of select="$questionDocument"/>
				</xsl:with-param>
			</xsl:apply-templates>
			<!--
				convert the whole SUMMARY element
			-->
			<xsl:apply-templates select="SUMMARY" mode="lc_generic"/>

			<!-- output the question document -->
			<xsl:copy-of select="$questionDocument"/>

			<!-- -output references -->
			<xsl:apply-templates select="INTERVSECTION/REFERENCESECTION"/>
			<!-- output the glossary -->
			<xsl:apply-templates select="INTERVSECTION/GLOSSARY"/>
			
			<!-- sustantive changes 
			<xsl:if test="INTERVSECTION/SUBSCHANGE">
				<substantive-changes>
					<xsl:for-each select="INTERVSECTION/SUBSCHANGE/P">
						<substantive-change>
							<xsl:if test="@ID">
								<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
							</xsl:if>
							<xsl:apply-templates select="node()" mode="lc_generic"/>
						</substantive-change>
					</xsl:for-each>
				</substantive-changes>
			</xsl:if>
		-->
			
			<!-- output the tables and figures -->
			<xsl:apply-templates select="TABSFIGS"/>
		</condition>
	</xsl:template>
	<!--
	===================================================
		section info
	===================================================
	-->
	<!-- 
		Specific template to lowercase the sectioninfo elements.
		Outputs a lower weight version.
	-->
	<xsl:template match="SECTIONINFO" mode="lc_generic">
		<xsl:param name="questionDocument"/>
		
		<section-info>
			<xsl:variable name="topicId" select="TOPIC/TOPICID"/>
			
			<!-- section id (eg cvd) of the condition -->
			<section-code>
				<xsl:value-of select="document($makefile-input)/CONDITIONS/SECTION/CONDITION[@ID=$topicId and @DOCTYPE='condition']/../@ID"/>
			</section-code>
			
			<xsl:apply-templates select="SECTIONTITLE" mode="lc_generic"/>
			<xsl:apply-templates select="SHORTSECTION" mode="lc_generic"/>
			<xsl:apply-templates select="SECTIONADVISOR" mode="lc_generic"/>
		</section-info>
		<condition-info>
			<condition-title>
				<xsl:apply-templates select="TOPIC/TOPICTITLE" mode="lc_generic">
					<xsl:with-param name="childrenOnly">true</xsl:with-param>
				</xsl:apply-templates>
			</condition-title>
			<short-condition-title>
				<xsl:apply-templates select="TOPIC/SHORTTOPIC" mode="lc_generic">
					<xsl:with-param name="childrenOnly">true</xsl:with-param>
				</xsl:apply-templates>
			</short-condition-title>
			<condition-status>
				<xsl:apply-templates select="TOPIC/TOPICSTATUS" mode="lc_generic">
					<xsl:with-param name="childrenOnly">true</xsl:with-param>
				</xsl:apply-templates>
			</condition-status>
			<collective-name>
				<xsl:apply-templates select="COLLECTIVENAME" mode="lc_generic">
					<xsl:with-param name="childrenOnly">true</xsl:with-param>
				</xsl:apply-templates>
			</collective-name>
			
			<!-- authors-->
			<xsl:apply-templates select="/CONTRIBUTION/INTERVSECTION/CONTRIBDETAILS" mode="lc_generic"/>

			<!-- competing interests -->
			<competing-interests>
				<xsl:apply-templates select="/CONTRIBUTION/INTERVSECTION/COMPINTERESTS" mode="lc_generic">
					<xsl:with-param name="childrenOnly">true</xsl:with-param>					
				</xsl:apply-templates>
			</competing-interests>
			
			<!-- intervention table -->
			<intervention-table>
				<xsl:if test="name(/CONTRIBUTION/SUMMARY/INTERVENTIONS/*[1])!='INTERVTITLE'">
					<xsl:text disable-output-escaping="yes">&lt;intervention-group&gt;</xsl:text>	
				</xsl:if>
				
				<xsl:for-each select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/*">
					<xsl:if test="name(.)='INTERVTITLE'">
						<!-- if it has an intervtitle before us then we need to close that one -->
						<xsl:if test="position()!=1"><xsl:text disable-output-escaping="yes">&lt;/intervention-group&gt;</xsl:text></xsl:if>
						<xsl:text disable-output-escaping="yes">&lt;intervention-group&gt;</xsl:text>
						<intervention-question-title>
							<xsl:apply-templates select="P" mode="lc_generic">
								<xsl:with-param name="childrenOnly">true</xsl:with-param>
								<xsl:with-param name="noLinks">true</xsl:with-param>
							</xsl:apply-templates>
						</intervention-question-title>
					</xsl:if>
					
					<xsl:if test="name(.)='BENEFICIAL'">
						<xsl:for-each select="P">
							<intervention-title>

								<xsl:attribute name="efficacy">beneficial</xsl:attribute>
								<xsl:if test="XREF/@REFID">
									<xsl:attribute name="refid"><xsl:value-of select="substring-before(concat(XREF/@REFID, '-'), '-')"/></xsl:attribute>
								</xsl:if>

								<xsl:apply-templates select="." mode="lc_generic">
									<xsl:with-param name="childrenOnly">true</xsl:with-param>
									<xsl:with-param name="noInternalLinks">true</xsl:with-param>
								</xsl:apply-templates>
							</intervention-title>
						</xsl:for-each>
					</xsl:if>	

					<xsl:if test="name(.)='LIKELYBENEFICIAL'">
						<xsl:for-each select="P">
							<intervention-title>
								<xsl:attribute name="efficacy">likely-beneficial</xsl:attribute>
								<xsl:if test="XREF/@REFID">
									<xsl:attribute name="refid"><xsl:value-of select="substring-before(concat(XREF/@REFID, '-'), '-')"/></xsl:attribute>
								</xsl:if>

								<xsl:apply-templates select="." mode="lc_generic">
									<xsl:with-param name="childrenOnly">true</xsl:with-param>
									<xsl:with-param name="noInternalLinks">true</xsl:with-param>
								</xsl:apply-templates>
							</intervention-title>
						</xsl:for-each>
					</xsl:if>	

					<xsl:if test="name(.)='UNKNOWNEFFECTIVENESS'">
						<xsl:for-each select="P">
							<intervention-title>
								<xsl:attribute name="efficacy">unknown</xsl:attribute>
								<xsl:if test="XREF/@REFID">
									<xsl:attribute name="refid"><xsl:value-of select="substring-before(concat(XREF/@REFID, '-'), '-')"/></xsl:attribute>
								</xsl:if>

								<xsl:apply-templates select="." mode="lc_generic">
									<xsl:with-param name="childrenOnly">true</xsl:with-param>
									<xsl:with-param name="noInternalLinks">true</xsl:with-param>
								</xsl:apply-templates>
							</intervention-title>
						</xsl:for-each>
					</xsl:if>	

					<xsl:if test="name(.)='INEFFHARMFUL'">
						<xsl:for-each select="P">
							<intervention-title>
								<xsl:attribute name="efficacy">ineff-harmful</xsl:attribute>
								<xsl:if test="XREF/@REFID">
									<xsl:attribute name="refid"><xsl:value-of select="substring-before(concat(XREF/@REFID, '-'), '-')"/></xsl:attribute>
								</xsl:if>

								<xsl:apply-templates select="." mode="lc_generic">
									<xsl:with-param name="childrenOnly">true</xsl:with-param>
									<xsl:with-param name="noInternalLinks">true</xsl:with-param>
								</xsl:apply-templates>
							</intervention-title>
						</xsl:for-each>
					</xsl:if>	

					<xsl:if test="name(.)='UNLIKELYBENEFICIAL'">
						<xsl:for-each select="P">
							<intervention-title>
								<xsl:attribute name="efficacy">unlikely-beneficial</xsl:attribute>
								<xsl:if test="XREF/@REFID">
									<xsl:attribute name="refid"><xsl:value-of select="substring-before(concat(XREF/@REFID, '-'), '-')"/></xsl:attribute>
								</xsl:if>

								<xsl:apply-templates select="." mode="lc_generic">
									<xsl:with-param name="childrenOnly">true</xsl:with-param>
									<xsl:with-param name="noInternalLinks">true</xsl:with-param>
								</xsl:apply-templates>
							</intervention-title>
						</xsl:for-each>
					</xsl:if>	

					<xsl:if test="name(.)='TRADEOFF'">
						<xsl:for-each select="P">
							<intervention-title>
								<xsl:attribute name="efficacy">trade-off</xsl:attribute>
								<xsl:if test="XREF/@REFID">
									<xsl:attribute name="refid"><xsl:value-of select="substring-before(concat(XREF/@REFID, '-'), '-')"/></xsl:attribute>
								</xsl:if>

								<xsl:apply-templates select="." mode="lc_generic">
									<xsl:with-param name="childrenOnly">true</xsl:with-param>
									<xsl:with-param name="noInternalLinks">true</xsl:with-param>
								</xsl:apply-templates>
							</intervention-title>
						</xsl:for-each>
					</xsl:if>	
				</xsl:for-each>
					
				<!--xsl:if test="name(/CONTRIBUTION/SUMMARY/INTERVENTIONS/*[1])!='INTERVTITLE'"-->
				<xsl:text disable-output-escaping="yes">&lt;/intervention-group&gt;</xsl:text>	
				<!--/xsl:if-->
			</intervention-table>
			
			<!-- web-like intervention table 
			TODO
			-->
			<web-intervention-table>
				
				<xsl:variable name="conditionId" select="/CONTRIBUTION/SECTIONINFO/TOPIC/TOPICID"/>
				
				<!-- loop through each question -->
				<xsl:for-each select="$questionDocument/questions/question">
					<question-ref>
					
						<xsl:attribute name="refid" select="@id"/>
						
						<xsl:if test="@is-new">
							<xsl:attribute name="is-new">true</xsl:attribute>
						</xsl:if>

						<xsl:copy-of select="question-title"/>
						<xsl:copy-of select="short-question-title"/>						
						
						<!-- loop through each beneficial option -->
						<xsl:for-each select="options/option/interventions/intervention[@efficacy='beneficial']">
							<intervention-title>
								<xsl:attribute name="efficacy">beneficial</xsl:attribute>
								<xsl:attribute name="refid"><xsl:value-of select="../../@id"/></xsl:attribute>
								<xsl:if test="intervention-title/processing-instruction('newitem')">
									<xsl:attribute name="is-new">true</xsl:attribute>
								</xsl:if>
								
								<xsl:apply-templates select="intervention-title" mode="lc_generic">
									<xsl:with-param name="childrenOnly">true</xsl:with-param>
								</xsl:apply-templates>
							</intervention-title>
						</xsl:for-each>
						
						<!-- loop through each likely-beneficial option -->
						<xsl:for-each select="options/option/interventions/intervention[@efficacy='likely-beneficial']">
							<intervention-title>
								<xsl:attribute name="efficacy">likely-beneficial</xsl:attribute>
								<xsl:attribute name="refid"><xsl:value-of select="../../@id"/></xsl:attribute>
								<xsl:if test="intervention-title/processing-instruction('newitem')">
									<xsl:attribute name="is-new">true</xsl:attribute>
								</xsl:if>

								<xsl:apply-templates select="intervention-title" mode="lc_generic">
									<xsl:with-param name="childrenOnly">true</xsl:with-param>
								</xsl:apply-templates>
							</intervention-title>
						</xsl:for-each>
						
						<!-- loop through each trade-off option -->
						<xsl:for-each select="options/option/interventions/intervention[@efficacy='trade-off']">
							<intervention-title>
								<xsl:attribute name="efficacy">trade-off</xsl:attribute>
								<xsl:attribute name="refid"><xsl:value-of select="../../@id"/></xsl:attribute>
								<xsl:if test="intervention-title/processing-instruction('newitem')">
									<xsl:attribute name="is-new">true</xsl:attribute>
								</xsl:if>

								<xsl:apply-templates select="intervention-title/." mode="lc_generic">
									<xsl:with-param name="childrenOnly">true</xsl:with-param>
								</xsl:apply-templates>
							</intervention-title>
						</xsl:for-each>
						
						<!-- loop through each unknown option -->
						<xsl:for-each select="options/option/interventions/intervention[@efficacy='unknown']">
							<intervention-title>
								<xsl:attribute name="efficacy">unknown</xsl:attribute>
								<xsl:attribute name="refid"><xsl:value-of select="../../@id"/></xsl:attribute>
								<xsl:if test="intervention-title/processing-instruction('newitem')">
									<xsl:attribute name="is-new">true</xsl:attribute>
								</xsl:if>

								<xsl:apply-templates select="intervention-title" mode="lc_generic">
									<xsl:with-param name="childrenOnly">true</xsl:with-param>
								</xsl:apply-templates>
							</intervention-title>
						</xsl:for-each>
						
						<!-- loop through each unknown option -->
						<xsl:for-each select="options/option/interventions/intervention[@efficacy='unlikely-beneficial']">
							<intervention-title>
								<xsl:attribute name="efficacy">unlikely-beneficial</xsl:attribute>
								<xsl:attribute name="refid"><xsl:value-of select="../../@id"/></xsl:attribute>
								<xsl:if test="intervention-title/processing-instruction('newitem')">
									<xsl:attribute name="is-new">true</xsl:attribute>
								</xsl:if>

								<xsl:apply-templates select="intervention-title" mode="lc_generic">
									<xsl:with-param name="childrenOnly">true</xsl:with-param>
								</xsl:apply-templates>
							</intervention-title>
						</xsl:for-each>
						
						<!-- loop through each ineff-harmful option -->
						<xsl:for-each select="options/option/interventions/intervention[@efficacy='ineff-harmful']">
							<intervention-title>
								<xsl:attribute name="efficacy">ineff-harmful</xsl:attribute>
								<xsl:attribute name="refid"><xsl:value-of select="../../@id"/></xsl:attribute>
								<xsl:if test="intervention-title/processing-instruction('newitem')">
									<xsl:attribute name="is-new">true</xsl:attribute>
								</xsl:if>

								<xsl:apply-templates select="intervention-title" mode="lc_generic">
									<xsl:with-param name="childrenOnly">true</xsl:with-param>
								</xsl:apply-templates>
							</intervention-title>
						</xsl:for-each>
					</question-ref>
				</xsl:for-each>
			</web-intervention-table>
			
			<!-- footnotes -->
			<xsl:if test="normalize-space(/CONTRIBUTION/SUMMARY/INTERVENTIONS/FOOTNOTE)!=''">
				<xsl:apply-templates select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/FOOTNOTE" mode="lc_generic"/>
			</xsl:if>
			
			<!-- to be covered in future updates -->
			<xsl:if test="normalize-space(/CONTRIBUTION/SUMMARY/INTERVENTIONS/SUBSISSUE)!=''">
				<future-updates>
					<xsl:for-each select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/SUBSISSUE/P">
						<future-update>
							<xsl:apply-templates select="." mode="lc_generic">
								<xsl:with-param name="childrenOnly">true</xsl:with-param>
							</xsl:apply-templates>
						</future-update>
					</xsl:for-each>
				</future-updates>
			</xsl:if>
			
			<!-- covered elsewhere in Clinical Evidence -->
			<xsl:if test="normalize-space(/CONTRIBUTION/SUMMARY/INTERVENTIONS/COVEREDELSEWHERE)!=''">
				<covered-elsewhere>
					<xsl:apply-templates select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/COVEREDELSEWHERE/P" mode="lc_generic"/>
				</covered-elsewhere>
			</xsl:if>
			
		</condition-info>
	</xsl:template>
	<!-- specific template to replace SECTIONTITLE with section-title -->
	<xsl:template match="SECTIONTITLE" mode="lc_generic">
		<section-title>
			<xsl:apply-templates select="node()" mode="lc_generic"/>
		</section-title>
	</xsl:template>
	<!-- specific template to replace SHORTSECTION with short-section-title -->
	<xsl:template match="SHORTSECTION" mode="lc_generic">
		<short-section-title>
			<xsl:apply-templates select="node()" mode="lc_generic"/>
		</short-section-title>
	</xsl:template>
	<!-- specific template for SECTIONADVISOR -->
	<xsl:template match="SECTIONADVISOR" mode="lc_generic">
		<section-advisors>
			<xsl:for-each select="CONTRIBDETAILS/CONTRIBUTOR">
				<advisor>
					<nomen>
						<xsl:apply-templates select="NOMEN" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</nomen>
					<first-name>
						<xsl:apply-templates select="FIRSTNAME" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</first-name>
					<middle-name>
						<xsl:apply-templates select="MIDDLENAME" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</middle-name>
					<last-name>
						<xsl:apply-templates select="LASTNAME" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</last-name>
					<pedigree>
						<xsl:apply-templates select="PEDIGREE" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</pedigree>
					<honorific>
						<xsl:apply-templates select="HONORIFIC" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</honorific>
					<title>
						<xsl:apply-templates select="AUTHORTITLE" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</title>
					<affiliation>
						<xsl:apply-templates select="following-sibling::*[name() = 'AFFILIATION' and normalize-space(.)!=''][1]" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</affiliation>
					<city>
						<xsl:apply-templates select="following-sibling::*[name() = 'CITY' and normalize-space(.)!=''][1]" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</city>
					<country>
						<xsl:apply-templates select="following-sibling::*[name() = 'COUNTRY' and normalize-space(.)!=''][1]" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</country>
				</advisor>
			</xsl:for-each>
		</section-advisors>
	</xsl:template>
	<!-- specific template for CONTRIBDETAILS -->
	<xsl:template match="CONTRIBDETAILS" mode="lc_generic">
		<authors>
			<xsl:for-each select="CONTRIBUTOR">
				<author>
					<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
					<nomen>
						<xsl:apply-templates select="NOMEN" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</nomen>
					<first-name>
						<xsl:apply-templates select="FIRSTNAME" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</first-name>
					<middle-name>
						<xsl:apply-templates select="MIDDLENAME" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</middle-name>
					<last-name>
						<xsl:apply-templates select="LASTNAME" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</last-name>
					<pedigree>
						<xsl:apply-templates select="PEDIGREE" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</pedigree>
					<honorific>
						<xsl:apply-templates select="HONORIFIC" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</honorific>
					<title>
						<xsl:apply-templates select="AUTHORTITLE" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</title>
					<affiliation>
						<xsl:apply-templates select="following-sibling::*[name() = 'AFFILIATION' and normalize-space(.)!=''][1]"  mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</affiliation>
					<city>
						<xsl:apply-templates select="following-sibling::*[name() = 'CITY' and normalize-space(.)!=''][1]"  mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</city>
					<country>
						<xsl:apply-templates select="following-sibling::*[name() = 'COUNTRY' and normalize-space(.)!=''][1]" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</country>
				</author>
			</xsl:for-each>
		</authors>
	</xsl:template>
	
	<!-- output summary -->
	<xsl:template match="SUMMARY" mode="lc_generic">
		<summary>
			<xsl:if test="DEFINITION/P">
				<xsl:apply-templates select="DEFINITION" mode="lc_generic">
					<xsl:with-param name="noParentAttribs">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="INCIDENCE/P">
				<xsl:apply-templates select="INCIDENCE" mode="lc_generic">
					<xsl:with-param name="noParentAttribs">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="AETIOLOGY/P">
				<xsl:apply-templates select="AETIOLOGY" mode="lc_generic">
					<xsl:with-param name="noParentAttribs">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="PROGNOSIS/P">
				<xsl:apply-templates select="PROGNOSIS" mode="lc_generic">
					<xsl:with-param name="noParentAttribs">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="AIMS/P">
				<xsl:apply-templates select="AIMS" mode="lc_generic">
					<xsl:with-param name="noParentAttribs">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="OUTCOMES/P">
				<xsl:apply-templates select="OUTCOMES" mode="lc_generic">
					<xsl:with-param name="noParentAttribs">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="METHODS/P">
				<xsl:apply-templates select="METHODS" mode="lc_generic">
					<xsl:with-param name="noParentAttribs">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
			
			<!--xsl:for-each select="INTERVENTIONS/SUBISSUE/P">
				<future-update><xsl:value-of select="."/></future-update>
			</xsl:for-each-->
		</summary>

		<!-- keymessages -->
		<xsl:choose>
			<!-- build keymessages from template/ramin xml -->
			<xsl:when test="$ramin-question-section//question">
				<xsl:call-template name="keymessages"/>
			</xsl:when>
			<!-- build keymessages from legacy xml -->
			<xsl:otherwise>
				<xsl:apply-templates select="KEYMESSAGES" mode="lc_generic"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<!--
	===================================================
		key messages (taken from legacy xml)
	===================================================
	-->
	<xsl:template match="KEYMESSAGES" mode="lc_generic">
		<xsl:choose>
			<xsl:when test="$ramin-question-section//question">
				<!-- do nothing  we've prepared keymessages already using template/ramin xml -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="*">
					<xsl:if test="name()='KMTITLE'">
						<xsl:text disable-output-escaping="yes">&lt;key-message&gt;</xsl:text>
						<key-message-title>
							<xsl:apply-templates select="node()" mode="lc_generic"/>
						</key-message-title>
						<xsl:if test="following-sibling::node()[1][name() = 'KMTITLE'] or not(following-sibling::node()[1])">
							<xsl:text disable-output-escaping="yes">&lt;/key-message&gt;</xsl:text>
						</xsl:if>
					</xsl:if>
					<xsl:if test="name()='KMLIST'">
						<!--xsl:value-of select="name(preceding-sibling::*[1])"/-->					
						<xsl:if test="name(preceding-sibling::*[1])!='KMTITLE'">
							<xsl:text disable-output-escaping="yes">&lt;key-message&gt;</xsl:text>
						</xsl:if>					
						<key-message-detail>
							<xsl:apply-templates select="node()" mode="lc_generic"/>
						</key-message-detail>
						<xsl:text disable-output-escaping="yes">&lt;/key-message&gt;</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- removes any superflouous <KMLIST> elements whilst lowercasing any child tags -->
	<xsl:template match="KMLIST" mode="lc_generic">
		<xsl:choose>
			<xsl:when test="$ramin-question-section//question">
				<!-- do nothing  we've prepared keymessages already using template/ramin xml -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="node()">
					<!-- lowercase children -->
					<xsl:apply-templates select="." mode="lc_generic"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--
	===================================================
		key messages (taken from template/ramin xml)
	===================================================
	-->
	<xsl:template name="keymessages">
		<key-messages>
			<xsl:for-each select="$ramin-question-section//question">
				<xsl:variable name="question">
					<xsl:copy-of select="."/>
				</xsl:variable>
				<key-message>
					<key-message-title>
						<xsl:apply-templates select="question-abridged-title/node()"/>
					</key-message-title>
					<key-message-detail>
						<xsl:for-each select="$list//efficacy">
							<xsl:variable name="efficacy-type" select="@type"/>
							<xsl:variable name="efficacy-title" select="."/>
							<xsl:for-each select="$question//summary[intervention-title/@type = $efficacy-type]">
								<xsl:sort select="intervention-title"/>
								<p><strong><xsl:value-of select="intervention-title"/></strong>
									<xsl:text> </xsl:text>
									<xsl:value-of select="key-message"/>
								</p>
							</xsl:for-each>
						</xsl:for-each>
					</key-message-detail>
				</key-message>
			</xsl:for-each>
		</key-messages>
	</xsl:template>
	
	<!--
	===================================================
		questions
	===================================================
	-->
	<!-- output a question -->
	<xsl:template match="QUESTION">
		<question>
			<xsl:attribute name="id"><xsl:value-of select="QUESTIONTITLE/@ID"/></xsl:attribute>
			<xsl:if test="QUESTIONTITLE/processing-instruction('newitem')">
				<xsl:attribute name="is-new">true</xsl:attribute>
			</xsl:if>

			<question-title>
				<xsl:apply-templates select="QUESTIONTITLE" mode="lc_generic">
					<xsl:with-param name="childrenOnly">true</xsl:with-param>
				</xsl:apply-templates>
			</question-title>
			<short-question-title>
				<xsl:apply-templates select="SHORTQUESTION" mode="lc_generic">
					<xsl:with-param name="childrenOnly">true</xsl:with-param>
				</xsl:apply-templates>
			</short-question-title>
			<xsl:if test="QUESTIONAUTHOR">
				<question-author>
					<xsl:apply-templates select="QUESTIONAUTHOR" mode="lc_generic">
					<xsl:with-param name="childrenOnly">true</xsl:with-param>
				</xsl:apply-templates>
				</question-author>
			</xsl:if>
			<options>
				<xsl:for-each select="OPTION">
					<xsl:apply-templates select="." mode="lc_generic"/>
				</xsl:for-each>
			</options>
		</question>
	</xsl:template>
	<!--
	===================================================
		options
	===================================================
	-->
	<!-- specific template to lowercase OPTION elements -->
	<xsl:template match="OPTION" mode="lc_generic">
		<option>
			<xsl:variable name="optionId">
				<xsl:value-of select="substring-before(concat(OPTIONTITLE/@ID, '-'), '-')"/>
			</xsl:variable>
			
			<xsl:if test="OPTIONTITLE/processing-instruction('newitem')">
				<xsl:attribute name="is-new">true</xsl:attribute>
			</xsl:if>

			<xsl:attribute name="id"><xsl:value-of select="$optionId"/></xsl:attribute>
			
			
			<xsl:choose>
				<xsl:when test="count(/CONTRIBUTION/SUMMARY/INTERVENTIONS/*/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId])=1">
					<!-- if an option has just one intervention, add an attribute for its efficacy -->
					<xsl:choose>
						<xsl:when test="/CONTRIBUTION/SUMMARY/INTERVENTIONS/BENEFICIAL/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]">
							<xsl:attribute name="efficacy">beneficial</xsl:attribute>
							<xsl:element name="interventions">
								<xsl:element name="intervention">
									<xsl:attribute name="efficacy">beneficial</xsl:attribute>
									<xsl:element name="intervention-question-title">
										<xsl:apply-templates select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/*/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]/parent::P//parent::*//preceding-sibling::INTERVTITLE[1]"></xsl:apply-templates>
									</xsl:element>
									<xsl:element name="intervention-title">
										<xsl:apply-templates select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/*/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]/.."  mode="lc_generic">
											<xsl:with-param name="childrenOnly">true</xsl:with-param>
											<xsl:with-param name="noLinks">true</xsl:with-param>
										</xsl:apply-templates>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:when>
						<xsl:when test="/CONTRIBUTION/SUMMARY/INTERVENTIONS/LIKELYBENEFICIAL/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]">
							<xsl:attribute name="efficacy">likely-beneficial</xsl:attribute>
							<xsl:element name="interventions">
								<xsl:element name="intervention">
									<xsl:attribute name="efficacy">likely-beneficial</xsl:attribute>
									<xsl:element name="intervention-question-title">
										<xsl:apply-templates select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/*/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]//parent::P//parent::*//preceding-sibling::INTERVTITLE[1]"></xsl:apply-templates>
									</xsl:element>
									<xsl:element name="intervention-title">
										<xsl:apply-templates select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/*/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]/.." mode="lc_generic">
											<xsl:with-param name="childrenOnly">true</xsl:with-param>
											<xsl:with-param name="noLinks">true</xsl:with-param>
										</xsl:apply-templates>
									</xsl:element>
								</xsl:element>
							</xsl:element>	
						</xsl:when>
						<xsl:when test="/CONTRIBUTION/SUMMARY/INTERVENTIONS/UNKNOWNEFFECTIVENESS/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]">
							<xsl:attribute name="efficacy">unknown</xsl:attribute>
							<xsl:element name="interventions">
								<xsl:element name="intervention">
									<xsl:attribute name="efficacy">unknown</xsl:attribute>
									<xsl:element name="intervention-question-title">
										<xsl:apply-templates select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/*/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]//parent::P//parent::*//preceding-sibling::INTERVTITLE[1]"></xsl:apply-templates>
									</xsl:element>
									<xsl:element name="intervention-title">
										<xsl:apply-templates select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/*/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]/.." mode="lc_generic">
											<xsl:with-param name="childrenOnly">true</xsl:with-param>
											<xsl:with-param name="noLinks">true</xsl:with-param>
										</xsl:apply-templates>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:when>
						<xsl:when test="/CONTRIBUTION/SUMMARY/INTERVENTIONS/INEFFHARMFUL/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]">
							<xsl:attribute name="efficacy">ineff-harmful</xsl:attribute>
							<xsl:element name="interventions">
								<xsl:element name="intervention">
									<xsl:attribute name="efficacy">ineff-harmful</xsl:attribute>
									<xsl:element name="intervention-question-title">
										<xsl:apply-templates select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/*/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]//parent::P//parent::*//preceding-sibling::INTERVTITLE[1]"></xsl:apply-templates>
									</xsl:element>
									<xsl:element name="intervention-title">
										<xsl:apply-templates select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/*/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]/.." mode="lc_generic">
											<xsl:with-param name="childrenOnly">true</xsl:with-param>
											<xsl:with-param name="noLinks">true</xsl:with-param>
										</xsl:apply-templates>
									</xsl:element>
								</xsl:element>
							</xsl:element>	
						</xsl:when>
						<xsl:when test="/CONTRIBUTION/SUMMARY/INTERVENTIONS/UNLIKELYBENEFICIAL/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]">
							<xsl:attribute name="efficacy">unlikely-beneficial</xsl:attribute>
							<xsl:element name="interventions">
								<xsl:element name="intervention">
									<xsl:attribute name="efficacy">unlikely-beneficial</xsl:attribute>
									<xsl:element name="intervention-question-title">
										<xsl:apply-templates select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/*/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]//parent::P//parent::*//preceding-sibling::INTERVTITLE[1]"></xsl:apply-templates>
									</xsl:element>
									<xsl:element name="intervention-title">
										<xsl:apply-templates select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/*/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]/.." mode="lc_generic">
											<xsl:with-param name="childrenOnly">true</xsl:with-param>
											<xsl:with-param name="noLinks">true</xsl:with-param>
										</xsl:apply-templates>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:when>
						<xsl:when test="/CONTRIBUTION/SUMMARY/INTERVENTIONS/TRADEOFF/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]">
							<xsl:attribute name="efficacy">trade-off</xsl:attribute>
							<xsl:element name="interventions">
								<xsl:element name="intervention">
									<xsl:attribute name="efficacy">trade-off</xsl:attribute>
									<xsl:element name="intervention-question-title">
										<xsl:apply-templates select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/*/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]//parent::P//parent::*//preceding-sibling::INTERVTITLE[1]"></xsl:apply-templates>
									</xsl:element>
									<xsl:element name="intervention-title">
										<xsl:apply-templates select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/*/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]/.." mode="lc_generic">
											<xsl:with-param name="childrenOnly">true</xsl:with-param>
											<xsl:with-param name="noLinks">true</xsl:with-param>
										</xsl:apply-templates>
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:when>
					</xsl:choose>
				</xsl:when>	
				<xsl:when test="count(/CONTRIBUTION/SUMMARY/INTERVENTIONS/*/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId])=0">
					<!-- When an option exists in the condition but isn't in the introductory table, we can't determine its efficacy -->
					<xsl:attribute name="efficacy">not-given</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="efficacy">multiple</xsl:attribute>
					<xsl:element name="interventions">
						<!-- go through each intervention listing its title and efficacy -->
						<xsl:for-each select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/BENEFICIAL/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]">
							<xsl:element name="intervention">
								<xsl:attribute name="efficacy">beneficial</xsl:attribute>
								<xsl:element name="intervention-question-title">
									<xsl:apply-templates select="parent::P//parent::*//preceding-sibling::INTERVTITLE[1]"></xsl:apply-templates>
								</xsl:element>
								<xsl:element name="intervention-title">
									<xsl:apply-templates select="../." mode="lc_generic">
											<xsl:with-param name="childrenOnly">true</xsl:with-param>
											<xsl:with-param name="noLinks">true</xsl:with-param>
										</xsl:apply-templates>
								</xsl:element>
							</xsl:element>
						</xsl:for-each>
						<xsl:for-each select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/LIKELYBENEFICIAL/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]">
							<xsl:element name="intervention">
								<xsl:attribute name="efficacy">likely-beneficial</xsl:attribute>
								<xsl:element name="intervention-question-title">
									<xsl:apply-templates select="parent::P//parent::*//preceding-sibling::INTERVTITLE[1]"></xsl:apply-templates>
								</xsl:element>
								<xsl:element name="intervention-title">
									<xsl:apply-templates select="../." mode="lc_generic">
											<xsl:with-param name="childrenOnly">true</xsl:with-param>
											<xsl:with-param name="noLinks">true</xsl:with-param>
										</xsl:apply-templates>
								</xsl:element>
							</xsl:element>
						</xsl:for-each>
						<xsl:for-each select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/UNKNOWNEFFECTIVENESS/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]">
							<xsl:element name="intervention">
								<xsl:attribute name="efficacy">unknown</xsl:attribute>
								<xsl:element name="intervention-question-title">
									<xsl:apply-templates select="parent::P//parent::*//preceding-sibling::INTERVTITLE[1]"></xsl:apply-templates>
								</xsl:element>
								<xsl:element name="intervention-title">
									<xsl:apply-templates select="../." mode="lc_generic">
											<xsl:with-param name="childrenOnly">true</xsl:with-param>
											<xsl:with-param name="noLinks">true</xsl:with-param>
										</xsl:apply-templates>
								</xsl:element>
							</xsl:element>		
						</xsl:for-each>
						<xsl:for-each select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/INEFFHARMFUL/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]">
							<xsl:element name="intervention">
								<xsl:attribute name="efficacy">ineff-harmful</xsl:attribute>
								<xsl:element name="intervention-question-title">
									<xsl:apply-templates select="parent::P//parent::*//preceding-sibling::INTERVTITLE[1]"></xsl:apply-templates>
								</xsl:element>
								<xsl:element name="intervention-title">
									<xsl:apply-templates select="../." mode="lc_generic">
											<xsl:with-param name="childrenOnly">true</xsl:with-param>
											<xsl:with-param name="noLinks">true</xsl:with-param>
										</xsl:apply-templates>
								</xsl:element>
							</xsl:element>
						</xsl:for-each>
						<xsl:for-each select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/UNLIKELYBENEFICIAL/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]">
							<xsl:element name="intervention">
								<xsl:attribute name="efficacy">unlikely-beneficial</xsl:attribute>
								<xsl:element name="intervention-question-title">
									<xsl:apply-templates select="parent::P//parent::*//preceding-sibling::INTERVTITLE[1]"></xsl:apply-templates>
								</xsl:element>
								<xsl:element name="intervention-title">
									<xsl:apply-templates select="../." mode="lc_generic">
											<xsl:with-param name="childrenOnly">true</xsl:with-param>
											<xsl:with-param name="noLinks">true</xsl:with-param>
										</xsl:apply-templates>
								</xsl:element>
							</xsl:element>
						</xsl:for-each>
						<xsl:for-each select="/CONTRIBUTION/SUMMARY/INTERVENTIONS/TRADEOFF/P/XREF[substring-before(concat(@REFID, '-'), '-')=$optionId]">
							<xsl:element name="intervention">
								<xsl:attribute name="efficacy">trade-off</xsl:attribute>
								<xsl:element name="intervention-question-title">
									<xsl:apply-templates select="parent::P//parent::*//preceding-sibling::INTERVTITLE[1]"></xsl:apply-templates>
								</xsl:element>
								<xsl:element name="intervention-title">
									<xsl:apply-templates select="../." mode="lc_generic">
											<xsl:with-param name="childrenOnly">true</xsl:with-param>
											<xsl:with-param name="noLinks">true</xsl:with-param>
										</xsl:apply-templates>
								</xsl:element>
							</xsl:element>	
						</xsl:for-each>
					</xsl:element>	
				</xsl:otherwise>	
			</xsl:choose>	
			
			<option-title>
				<xsl:apply-templates select="OPTIONTITLE" mode="lc_generic">
					<xsl:with-param name="childrenOnly">true</xsl:with-param>
				</xsl:apply-templates>
			</option-title>
			<!-- some conditions don't have shortoption titles -->
			<xsl:choose>
				<xsl:when test="SHORTOPTION">
					<short-option-title>
						<xsl:apply-templates select="SHORTOPTION" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</short-option-title>
				</xsl:when>
				<xsl:otherwise>
					<short-option-title>
						<xsl:apply-templates select="OPTIONTITLE" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</short-option-title>
				</xsl:otherwise>
			</xsl:choose>
			
			<!-- some option authors are empty tags so we check against a blank string -->
			<xsl:if test="OPTIONAUTHOR!=''">
				<option-author>
					<xsl:value-of select="OPTIONAUTHOR"/>
				</option-author>
			</xsl:if>
			
			<summary-statement>
				<xsl:choose>
					<xsl:when test="SUMSTATEMENT/@ID">
						<xsl:attribute name="id"><xsl:value-of select="SUMSTATEMENT/@ID"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<!-- some summary statements don't have IDs so we fake it -->
						<xsl:attribute name="id"><xsl:value-of select="$optionId"/>-SUMSTATEMENT</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="SUMSTATEMENT" mode="lc_generic">
					<xsl:with-param name="childrenOnly">true</xsl:with-param>
				</xsl:apply-templates>
			</summary-statement>
			<xsl:apply-templates select="BENEFITS" mode="lc_generic"/>
			<xsl:apply-templates select="HARMS" mode="lc_generic"/>
			<xsl:apply-templates select="COMMENT" mode="lc_generic"/>
		</option>
	</xsl:template>
	<!--
	===================================================
		references
	===================================================
	-->
	<!-- output all references -->
	<xsl:template match="REFERENCESECTION">
		<references>
			<xsl:for-each select="REFERENCE">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</references>
	</xsl:template>
	<!-- output a single reference -->
	<xsl:template match="REFERENCE">
		<reference>
			<!-- get ID from REFERENCEDETAILS child -->
			<xsl:attribute name="id"><xsl:value-of select="REFERENCEDETAILS/@ID"/></xsl:attribute>
			<xsl:attribute name="ordernum"><xsl:value-of select="substring(REFERENCEDETAILS/@ID, 4)"/></xsl:attribute>
			<xsl:apply-templates select="REFERENCEDETAILS"/>
			<xsl:if test="@TYPE='pubmed'">
				<link type="pubmed">
					<xsl:attribute name="url"><xsl:value-of select="@URL"/></xsl:attribute>
				</link>
			</xsl:if>
		</reference>
	</xsl:template>
	<!-- output reference details text -->
	<xsl:template match="REFERENCEDETAILS">
		<xsl:apply-templates select="node()" mode="lc_generic"/>
	</xsl:template>
	<!--
	===================================================
		revisions

		TODO currently broken because of poor input XML

		we have problems like
		* <strong><revision type="start"/>blah</strong>blah<revision type="end"/>
		* end tags with no start tags and vice-versa

		this affects 19 conditions:
		0302 0403 0407 0805 0808 0811 1001 1003 1004
		1005 1107 1108 1208 1209 1401 1402 1706 1801 2001
	===================================================
	-->
	<!-- output a starting tag for revisions -->
	<xsl:template match="REV[@POSITION='START']" mode="lc_generic">
		<!--xsl:text disable-output-escaping="yes">&lt;revision id='</xsl:text><xsl:value-of select="@REFID"/><xsl:text disable-output-escaping="yes">'&gt;</xsl:text-->	
	</xsl:template>
	<!-- output an ending tag for revisions -->
	<xsl:template match="REV[@POSITION='END']" mode="lc_generic">
		<!--xsl:text disable-output-escaping="yes">&lt;/revision&gt;</xsl:text-->	
	</xsl:template>
	<!--
	===================================================
		glossary
	===================================================
	-->
	<!-- template to output the glossary -->
	<xsl:template match="GLOSSARY">
		<xsl:if test="P">
			<glossary>
				<xsl:for-each select="P">
					<!--
	
						TODO: sort out stupid glossary stuff
	
					<glossaryentry>
						<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
						
						<term><xsl:value-of select="B"/></term>
						
						<definition><xsl:apply-templates select="."	mode="lc_generic"/></definition>
					</glossaryentry>
	
					-->
					<glossary-entry>
						<xsl:if test="@ID">
							<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
						</xsl:if>
						<xsl:apply-templates select="node()" mode="lc_generic"/>
					</glossary-entry>
				</xsl:for-each>
			</glossary>
		</xsl:if>
	</xsl:template>
	<!--
	===================================================
		tables and figures
	===================================================
	-->
	<xsl:template match="TABSFIGS">
		<!-- output each FIGURE -->
		<xsl:if test="FIGURE">
			<figures>
				<xsl:for-each select="FIGURE">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
			</figures>
		</xsl:if>
		<!-- output each TABLEDATA -->
		<xsl:if test="TABLEDATA">
			<tables>
				<xsl:for-each select="TABLEDATA">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
			</tables>
		</xsl:if>
	</xsl:template>
	<!-- output a single figure -->
	<xsl:template match="FIGURE">
		<figure>
			<!-- get the id attrib from the FIGUREREF child -->
			<xsl:attribute name="id"><xsl:value-of select="FIGUREREF/@ID"/></xsl:attribute>
			<!-- output the graphic -->
			<graphic>
				<xsl:attribute name="url" select="concat('http://www.clinicalevidence.com/images/', substring(GRAPHIC/@FILENAME, 1, 4), '_figure_',  substring(GRAPHIC/@FILENAME, 7, 10), '.jpg')"/>
				<xsl:variable name="fn" select="GRAPHIC/@FILENAME"/>
			</graphic>
			<!-- output the caption -->
			<caption>
				<xsl:apply-templates select="FIGURECAPTION" mode="lc_generic">
					<xsl:with-param name="childrenOnly">true</xsl:with-param>
				</xsl:apply-templates>
			</caption>
		</figure>
	</xsl:template>
	<!-- output a single table -->
	<xsl:template match="TABLEDATA">
		<table-data>
			<!-- get ID from the TABLEREF child -->
			<xsl:attribute name="id" select="TABLEREF/@ID"/>
			<!-- output caption -->
			<caption>
				<xsl:apply-templates select="TABLECAPTION" mode="lc_generic">
					<xsl:with-param name="childrenOnly">true</xsl:with-param>
				</xsl:apply-templates>
			</caption>
			<!-- output the CALS table -->
			<xsl:apply-templates select="TABLE" mode="lc_generic">
				<xsl:with-param name="calsNamespace">true</xsl:with-param>
			</xsl:apply-templates>
		</table-data>
	</xsl:template>
	<!--
	===================================================
		body elements
	===================================================
	-->
	<!-- takes an extref and turns it into a link tag -->
	<xsl:template match="EXTREF" mode="lc_generic">
		<xsl:param name="noPIs" select="false"/>
		<xsl:param name="childrenOnly" select="false"/>
		<xsl:param name="noParentAttribs" select="false"/>
		<xsl:param name="noLinks" select="false"/>
		<xsl:param name="noInternalLinks" select="false"/>

		<xsl:choose>
			<xsl:when test="$noLinks='true'"></xsl:when>
			<xsl:otherwise>
				<link>
					<xsl:choose>
                        <xsl:when test="@TYPE='WEBEXTRA' or @TYPE='webextra'">
                            <xsl:choose>
                                <!-- new-template web table special case -->
                                <xsl:when test="contains(@FILENAME, 'table_')">
                                    <xsl:attribute name="url">/lpBinCE/lpext.dll/BMJSPLITCE/CHILD_HEALTH.html/<xsl:value-of select="$topicId"/>/webextra/<xsl:value-of select="$topicId"/>t<xsl:value-of select="substring-after(@FILENAME, 'table_')"/>.html</xsl:attribute>
                                    <xsl:attribute name="type">url</xsl:attribute>
                                </xsl:when>

                                <!-- new-template web table special case -->
                                <xsl:when test="contains(@FILENAME, 'figure_')">
                                    <xsl:attribute name="url">/lpBinCE/lpext.dll/BMJSPLITCE/CHILD_HEALTH.html/<xsl:value-of select="$topicId"/>/webextra/<xsl:value-of select="$topicId"/>f<xsl:value-of select="substring-after(@FILENAME, 'figure_')"/>.html</xsl:attribute>
                                    <!--xsl:attribute name="filename"><xsl:value-of select="@FILENAME"/></xsl:attribute>
                                    <xsl:attribute name="type">internal</xsl:attribute-->
                                    <xsl:attribute name="type">url</xsl:attribute>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>

						<xsl:when test="@TYPE='URL' or starts-with(@FILENAME, 'http')">
							<!-- URL special case -->
							<xsl:attribute name="url"><xsl:value-of select="@FILENAME"/></xsl:attribute>
							<xsl:attribute name="type">url</xsl:attribute>
						</xsl:when>
						<xsl:when test="string(number(substring(@FILENAME, 1, 4)))!='NaN'">
							<!-- link to another condition -->
							<xsl:attribute name="type">condition</xsl:attribute>
							<xsl:attribute name="refid"><xsl:value-of select="substring(@FILENAME, 1, 4)"/></xsl:attribute>
		
						</xsl:when>
						<xsl:otherwise>
							<!-- general case -->
							<xsl:attribute name="filename"><xsl:value-of select="@FILENAME"/></xsl:attribute>
							<xsl:attribute name="type">internal</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<!-- lowercase children -->
					<xsl:apply-templates select="node()" mode="lc_generic">
						<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
						<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
						<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
					</xsl:apply-templates>
				</link>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- takes an xref and turns it into a link tag -->
	<xsl:template match="XREF" mode="lc_generic">
		<xsl:param name="noPIs" select="false"/>
		<xsl:param name="childrenOnly" select="false"/>
		<xsl:param name="noParentAttribs" select="false"/>
		<xsl:param name="noLinks" select="false"/>
		<xsl:param name="noInternalLinks" select="false"/>
		
		<xsl:choose>
			<xsl:when test="$noLinks='true'"></xsl:when>
			<xsl:when test="$noInternalLinks='true'"></xsl:when>
			<xsl:otherwise>
				<link>
					<xsl:choose>
						<xsl:when test="starts-with(@REFID, 'REF')">
							<xsl:attribute name="type">reference</xsl:attribute>
						</xsl:when>
						<xsl:when test="starts-with(@REFID, 'T')">
							<xsl:attribute name="type">table</xsl:attribute>
						</xsl:when>
						<xsl:when test="starts-with(@REFID, 'F')">
							<xsl:attribute name="type">figure</xsl:attribute>
						</xsl:when>
						<xsl:when test="starts-with(@REFID, 'G')">
							<xsl:attribute name="type">glossary</xsl:attribute>
						</xsl:when>
						<!-- link to a question -->
						<xsl:when test="starts-with(@REFID, 'Q')">
							<!-- TODO how do we handle this? -->
							<xsl:attribute name="type">question</xsl:attribute>
						</xsl:when>
						<!-- todo: should these point to individual sections rather than just the summary? -->
						<xsl:when test="@REFID='DEFINITION'">
							<xsl:attribute name="type">summary</xsl:attribute>
						</xsl:when>
						<xsl:when test="@REFID='AETIOLOGY'">
							<xsl:attribute name="type">summary</xsl:attribute>
						</xsl:when>
						<xsl:when test="@REFID='PROGNOSIS'">
							<xsl:attribute name="type">summary</xsl:attribute>
						</xsl:when>
						<xsl:when test="@REFID='METHODS'">
							<xsl:attribute name="type">summary</xsl:attribute>
						</xsl:when>
						<xsl:when test="@REFID='OUTCOMES'">
							<xsl:attribute name="type">summary</xsl:attribute>
						</xsl:when>
						<xsl:when test="@REFID='INCIDENCE'">
							<xsl:attribute name="type">summary</xsl:attribute>
						</xsl:when>
						<xsl:when test="starts-with(@REFID, 'I')">
							<!-- Intervention links (starting with I) can be benefits, harms or comments -->
							<!-- constants for benefits, harms and comment -->
							<xsl:variable name="benefits">BENEFITS</xsl:variable>
							<xsl:variable name="harms">HARMS</xsl:variable>
							<xsl:variable name="comment">COMMENT</xsl:variable>
							<xsl:variable name="sumstatement">SUMSTATEMENT</xsl:variable>
							<!-- XSL has a starts-with but not an ends-with function. stupid. -->
							<xsl:choose>
								<xsl:when test="substring(@REFID, 1 - string-length($benefits) + string-length(@REFID))=$benefits">
									<xsl:attribute name="type">benefits</xsl:attribute>
								</xsl:when>
								<xsl:when test="substring(@REFID, 1 - string-length($harms) + string-length(@REFID))=$harms">
									<xsl:attribute name="type">harms</xsl:attribute>
								</xsl:when>
								<xsl:when test="substring(@REFID, 1 - string-length($comment) + string-length(@REFID))=$comment">
									<xsl:attribute name="type">comment</xsl:attribute>
								</xsl:when>
								<xsl:when test="substring(@REFID, 1 - string-length($sumstatement) + string-length(@REFID))=$sumstatement">
									<xsl:attribute name="type">summary-statement</xsl:attribute>
								</xsl:when>
								<!-- if the string consists of I followed by a number then it's a link to an intervention -->
								<xsl:when test="string(number(substring(@REFID, 2)))!='NaN'">
									<xsl:attribute name="type">option</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="type">unknown-intervention-xref-type</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="type">unknown-xref-type</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="refid"><xsl:value-of select="@REFID"/></xsl:attribute>
					
					<!-- don't show any children if it's a reference link -->
					<xsl:if test="not(starts-with(@REFID, 'REF'))">
						<!-- convert children to lowercase -->
						<xsl:apply-templates select="node()" mode="lc_generic">
							<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
							<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
							<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
						</xsl:apply-templates>
					</xsl:if>
				</link>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- specific template to replace i with em -->
	<xsl:template match="I" mode="lc_generic">
		<xsl:param name="noPIs" select="false"/>
		<xsl:param name="noLinks" select="false"/>
		<xsl:param name="noInternalLinks" select="false"/>
		<xsl:param name="calsNamespace" select="false"/>

		<xsl:choose>
			<xsl:when test="$calsNamespace='true'">
				<cals:i>
					<!-- lowercase children -->
					<xsl:for-each select="node()">
						<xsl:apply-templates select="." mode="lc_generic">
							<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
							<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
							<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
							<xsl:with-param name="calsNamespace">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:for-each>
				</cals:i>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<!-- convert children to lowercase -->
					<xsl:apply-templates select="node()" mode="lc_generic">
						<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
						<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
						<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
					</xsl:apply-templates>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
 
	<!-- specific template to replace b with strong -->
	<xsl:template match="B" mode="lc_generic">
		<xsl:param name="noPIs" select="false"/>
		<xsl:param name="noLinks" select="false"/>
		<xsl:param name="noInternalLinks" select="false"/>
		<xsl:param name="calsNamespace" select="false"/>
		
		<xsl:choose>
			<xsl:when test="$calsNamespace='true'">
				<cals:b>
					<!-- lowercase children -->
					<xsl:for-each select="node()">
						<xsl:apply-templates select="." mode="lc_generic">
							<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
							<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
							<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
							<xsl:with-param name="calsNamespace">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:for-each>
				</cals:b>
			</xsl:when>
			<xsl:otherwise>
				<strong>
					<!-- convert children to lowercase -->
					<xsl:apply-templates select="node()" mode="lc_generic">
						<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
						<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
						<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
					</xsl:apply-templates>
				</strong>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	===================================================
		general templates to lower case elements
	===================================================
	-->
	<!--
		constants for the upper- and lowercase alphabets. These are used when
		converting from upper to lowercase
	-->
	<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
	
	<!-- generalised template to lower case the element and all children -->
	<xsl:template match="*" mode="lc_generic">
		<xsl:param name="noPIs" select="false"/>
		<xsl:param name="childrenOnly" select="false"/>
		<xsl:param name="noParentAttribs" select="false"/>
		<xsl:param name="noLinks" select="false"/>
		<xsl:param name="noInternalLinks" select="false"/>
		<xsl:param name="calsNamespace" select="false"/>
		
		<!--
		<debug>
			<xsl:attribute name="noPIs"><xsl:value-of select="$noPIs"/></xsl:attribute>
			<xsl:attribute name="childrenOnly"><xsl:value-of select="$childrenOnly"/></xsl:attribute>
			<xsl:attribute name="noParentAttribs"><xsl:value-of select="$noParentAttribs"/></xsl:attribute>
			<xsl:attribute name="noLinks"><xsl:value-of select="$noLinks"/></xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="name()"/></xsl:attribute>
			<xsl:attribute name="atcount"><xsl:value-of select="count(@*)"/></xsl:attribute>
		</debug>
		-->
		
		<xsl:choose>
			<xsl:when test="$noLinks='true' and name()='XREF'">
				<supress></supress>
				<!-- supress elements -->
			</xsl:when>
			<xsl:when test="$noLinks='true' and name()='EXTREF'">
				<supress></supress>
				<!-- supress elements -->
			</xsl:when>
			<xsl:when test="$childrenOnly='true'">
				<!-- lowercase children -->
				<xsl:for-each select="node()">
					<xsl:apply-templates select="." mode="lc_generic">
						<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
						<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
						<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
					</xsl:apply-templates>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$calsNamespace='true'">
				<!-- lowercase the element name -->
				<xsl:element name="cals:{translate(name(), $upper, $lower)}">
					<!-- lowercase each attribute -->
					<xsl:for-each select="@*">
						<xsl:attribute name="{translate(name(), $upper, $lower)}"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
					<!-- lowercase children -->
					<xsl:for-each select="node()">
						<xsl:apply-templates select="." mode="lc_generic">
							<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
							<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
							<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
							<xsl:with-param name="calsNamespace">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
			
				<!-- lowercase the element name -->
				<xsl:element name="{translate(name(), $upper, $lower)}">
					<xsl:choose>
						<xsl:when test="$noParentAttribs='true' or name()='P'">
							<!-- craziness going on when I try to do != 'true' -->
							<!-- also don't output attributes for P tags -->
						</xsl:when>
						<xsl:otherwise>
							<!-- lowercase each attribute -->
							<xsl:for-each select="@*">
								<xsl:attribute name="{translate(name(), $upper, $lower)}"><xsl:value-of select="."/></xsl:attribute>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					
					<!-- lowercase children -->
					<xsl:for-each select="node()">
						<xsl:apply-templates select="." mode="lc_generic">
						<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
						<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
						<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
						</xsl:apply-templates>
					</xsl:for-each>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--xsl:template match="processing-instruction('html_br')|processing-instruction('linebreak')" mode="lc_generic"-->
	<xsl:template match="processing-instruction('html_br')" mode="lc_generic">
		<xsl:param name="noPIs" select="false"/>
		
		<xsl:choose>
			<xsl:when test="$noPIs='true'">
				<!-- do nothing -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:processing-instruction name="html_br" xml:space="default">
					<!--xsl:value-of select="normalize-space(.)"/-->
				</xsl:processing-instruction>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- specific template to suppress elements -->
	<xsl:template match="OPTIONREAD|TOPICREAD|QUESTIONREAD|OPTIONSTATUS|OPTIONUMLS|QUESTIONSTATUS|QUESTIONUMLS" mode="lc_generic">
	</xsl:template>



	<xsl:template name="process-text">
		<xsl:param name="str"/>

        <xsl:choose>
			<xsl:when test="contains($str, $pagenum-text)">
				<xsl:call-template name="process-text">
					<xsl:with-param name="str">
						<xsl:value-of select="substring-before($str, $pagenum-text)"/>
					</xsl:with-param>
				</xsl:call-template><xsl:processing-instruction name="pagenum"/>
				<xsl:call-template name="process-text">
					<xsl:with-param name="str">
						<xsl:value-of select="substring-after($str, $pagenum-text)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
        </xsl:choose>
	</xsl:template>

	<xsl:template match="text()" mode="lc_generic">
		<!--xsl:variable name="references-expanded"></xsl:variable-->
		<xsl:call-template name="process-text">
			<xsl:with-param name="str"><xsl:value-of select="."/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:refman="http://www.bmj.com/bmjk/behive/refman/2006-10">

	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:template match="/">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<fo:layout-master-set>
				<fo:simple-page-master master-name="my-page">
					<fo:region-body margin="1in"/>
				</fo:simple-page-master>
			</fo:layout-master-set>

			<xsl:variable name="topic-title"
				select="document(/references/bmjk-review-plan-link/@target)//info/title"/>

			<fo:page-sequence master-reference="my-page">
				<fo:flow flow-name="xsl-region-body">
					<fo:block font-weight="bold">
						<xsl:text>INCLUSION/EXCLUSION FORM FOR </xsl:text>
						<xsl:value-of select="translate($topic-title,$lower,$upper)"/>
					</fo:block>
					<fo:block space-before="10pt">Please note that for transparency reasons, we will be unable
						to proceed with your topic without receiving completed inclusion/exclusion forms. It is
						therefore essential that you return your forms back to us before or at the same time as
						your submission. </fo:block>
					<fo:block space-before="10pt" font-style="italic">If you have any questions about filling
						in this form, require more details about how the literature was searched and appraised,
						or have any feedback to give, please contact the information specialist above. </fo:block>
					<fo:block space-before="10pt">Instructions for completing the form: Please look at the
						search results below and assess which studies you want to use to summarise the evidence.
						You should select all those studies that match the criteria agreed in the Topic
						Plan-Critical Appraisal Sheet that are relevant to the clinical question asked, about
						the defined population, and which assess the outcomes of interest stated in the Topic
						Plan-Critical Appraisal Sheet.</fo:block>
					<fo:block space-before="10pt">Please obtain the full text of your selected studies as soon
						as possible. Clinical Evidence is unable to provide all our authors with full text
						copies of the studies, hence we now check at commissioning stage whether authors have
						good access to the literature and can obtain them for themselves.</fo:block>
					<fo:block space-before="10pt">Having seen the full text of a previously selected study,
						you may decide that it does not meet the Topic Plan-Critical Appraisal criteria after
						all. In such cases, please ensure you amend the section "DO YOU WANT TO INCLUDE THIS
						ARTICLE? YES/NO; IF NO, INDICATE REASON FOR EXCLUSION" for that reference on the
						inclusion/exclusion form. </fo:block>
					<fo:block space-before="10pt">Translations: If you experience serious problems trying to
						obtain a particular paper, or want to discuss having a vital language reference
						translated - please contact the information specialist (contact details are shown at the
						top of this message). </fo:block>
					<fo:block space-before="10pt">Please note: Clinical Evidence avoids including unpublished
						studies. Clinical Evidence does not include studies published only as abstracts, unless
						that abstract has been included in the meta-analysis of an included systematic review. </fo:block>
					<fo:block space-before="10pt">For every reference below, please complete the section "DO
						YOU WANT TO INCLUDE THIS ARTICLE? YES/NO; IF NO, INDICATE REASON FOR EXCLUSION BELOW".
						As an evidence based product, Clinical Evidence must have a record of why studies were
						excluded. </fo:block>
					<fo:block space-before="10pt">Please state below any additional exclusion criteria to
						those in the topic plan-critical appraisal sheet: If you want to use additional
						exclusion criteria, please state them below. These will be stated in the methods section
						of the topic. For example, the topic plan may state the population of interest is _men
						over 75 years old_ so you may choose to exclude studies that also look at men aged below
						75, if fewer than 50% of the study participants are over 75 years old.
						___________________________________________________________________________________________________________________
						___________________________________________________________________________________________________________________
						___________________________________________________________________________________________________________________
						___________________________________________________________________________________________________________________
						___________________________________________________________________________________________________________________
						___________________________________________________________________________________________________________________ </fo:block>
					<fo:block>

						<xsl:for-each select="/references/reference-set/reference-link[not(@approved)]">
							<xsl:apply-templates select="document(@target)/reference">
								<xsl:with-param name="number"><xsl:number format="1. "/></xsl:with-param>
								<xsl:with-param name="type">systematic-review</xsl:with-param>
							</xsl:apply-templates>
						</xsl:for-each>

						<xsl:for-each select="/references/reference-set/reference-link[not(@approved)]">
							<xsl:apply-templates select="document(@target)/reference">
								<xsl:with-param name="number"><xsl:number format="1. "/></xsl:with-param>
								<xsl:with-param name="type">randomised-controlled-trial</xsl:with-param>
							</xsl:apply-templates>
						</xsl:for-each>

						<xsl:for-each select="/references/reference-set/reference-link[not(@approved)]">
							<xsl:apply-templates select="document(@target)/reference">
								<xsl:with-param name="number"><xsl:number format="1. "/></xsl:with-param>
								<xsl:with-param name="type">harms-study</xsl:with-param>
							</xsl:apply-templates>
						</xsl:for-each>

						<xsl:for-each select="/references/reference-set/reference-link[not(@approved)]">
							<xsl:apply-templates select="document(@target)/reference">
								<xsl:with-param name="number"><xsl:number format="1. "/></xsl:with-param>
								<xsl:with-param name="type">observational-study</xsl:with-param>
							</xsl:apply-templates>
						</xsl:for-each>

					</fo:block>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>

	<xsl:template match="refman:contributors">
		<fo:block font-weight="bold">
			<xsl:value-of select="."/>
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="refman:author">
		<fo:block margin-left="5pt" font-style="italic">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="refman:style">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="refman:full-title">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="refman:year | refman:volume | refman:abbr-1">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="refman:pages">
		<xsl:value-of select="@start"/>
		<xsl:text> - </xsl:text>
		<xsl:value-of select="@start"/>
	</xsl:template>

	<xsl:template match="refman:titles | refman:title | refman:dates | refman:periodical | title">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="refman:abstract | refman:contributors">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="refman:keywords">
		<xsl:text>Keywords: </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="refman:keyword | refman:author">
		<xsl:value-of select="."/>
		<xsl:text>, </xsl:text>
	</xsl:template>

	<xsl:template match="refman:authors">
		<xsl:text>Authors: </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="reference" priority="2">
		<xsl:param name="type"/>
		<xsl:param name="number"/>		

		<xsl:if test="reference-type=$type">
			<fo:block space-before="10pt">
				<xsl:value-of select="$number"/>
				
				<fo:inline font-style="italic" font-weight="bold">
					<xsl:text>Reference type: </xsl:text>
					<xsl:value-of select="reference-type"/>
					<xsl:text>, Ref ID: </xsl:text>
					<xsl:value-of select="refman:rec-number"/>
				</fo:inline>

				<fo:block font-weight="bold" space-before="10pt" margin-left="5pt">
					<xsl:apply-templates select="refman:titles"/>
				</fo:block>

				<fo:block space-before="10pt" margin-left="5pt">
					<xsl:apply-templates select="refman:contributors"/>
				</fo:block>

				<fo:block space-before="10pt" margin-left="5pt">
					<xsl:apply-templates select="refman:periodical"/>
					<xsl:text>: </xsl:text>
					<xsl:apply-templates select="refman:dates"/>
					<xsl:text>: </xsl:text>
					<xsl:apply-templates select="refman:volume"/>
					<xsl:text>: </xsl:text>
					<xsl:apply-templates select="refman:pages"/>
				</fo:block>

				<fo:block margin-left="5pt" space-before="10pt">
					<xsl:apply-templates select="refman:abstract"/>
				</fo:block>

				<fo:block space-before="10pt" font-weight="bold">
					<xsl:text>Do you want to include this article? Yes / No</xsl:text>
				</fo:block>

				<fo:block font-style="italic" font-weight="bold">
					<xsl:text>If no, indicate reason for exclusion below:</xsl:text>
				</fo:block>

				<xsl:if test="reference-type='systematic-review'">
					<fo:list-block>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Irrelevant/wrong question</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Not systematic search</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Wrong population</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Wrong comparison</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Abstract only</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Exclusions unacceptable</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Wrong intervention</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Wrong outcomes</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Other (please
								specify)___________________________________________
									</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>
				</xsl:if>

				<xsl:if test="reference-type='randomised-controlled-trial'">
					<fo:list-block>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Irrelevant/wrong question</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Not Blinded</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Too small (20 patients)</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Wrong patient group</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Less than 80% follow up</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Not RCT</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Wrong Comparison</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Wrong Intervention</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Surrogate Outcome</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Abstract only</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Other (please
									specify)___________________________________________</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>
				</xsl:if>

				<xsl:if test="reference-type='harms-study'">
					<fo:list-block>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Irrelevant/wrong question</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Wrong intervention</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Not harm of interest</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Wrong patient group</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Wrong study type</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>Other (please
								specify)___________________________________________</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>
				</xsl:if>

				<xsl:if test="reference-type='observational-study'">
					<fo:list-block>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Irrelevant/wrong question</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Wrong comparison</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Wrong Intervention</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Less than 80% follow up</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Wrong study type</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Too small</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Wrong patient group</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Outcome measurements not valid</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
						<fo:list-item>
							<fo:list-item-label end-indent="label-end()">
								<fo:block>
									<xsl:text>*</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="body-start()">
								<fo:block>
									<xsl:text>Other (please specify)___________________________________________</xsl:text>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>
				</xsl:if>

			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*">
		<!-- do nothing -->
	</xsl:template>

</xsl:stylesheet>

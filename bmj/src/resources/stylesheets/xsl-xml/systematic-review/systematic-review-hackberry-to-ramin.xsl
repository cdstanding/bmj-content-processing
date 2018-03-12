<?xml version="1.0" encoding="US-ASCII"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:kms="kms"
	exclude-result-prefixes="cals kms xsl xsi">

	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="us-ascii" 
		indent="yes" 
		name="xml-output"/>
	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="us-ascii" 
		indent="yes"
		doctype-public="-//BMJ//DTD condition//EN"
		doctype-system="http://schema.bmj.com/archive/ramin/condition.dtd"/>

	<xsl:param name="ramin-xml-output"/>

	<!--xsl:strip-space elements="*"/>
	<xsl:preserve-space elements="background question option references condition-info section-info"/-->

	<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'"/>
	<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz-'"/>

	<xsl:template match="condition">

		<xsl:comment>Converted from Hackberry (CMS)</xsl:comment>

		<condition>
			<xsl:attribute name="search-date">0000-00</xsl:attribute>
			<xsl:attribute name="issue">17</xsl:attribute>

			<xsl:attribute name="id" select="@id"/>

			<section>
				<xsl:attribute name="id" select="primary-section-info/@id"/>
				<xsl:apply-templates select="primary-section-info/section-long-title/node()"/>
			</section>

			<!-- section doc -->
			<xsl:variable name="sectionDocFilename">
				<xsl:if test="starts-with( translate($ramin-xml-output, $upper, $lower), 'c')">
					<xsl:text>/</xsl:text>
				</xsl:if>
				<xsl:value-of select="$ramin-xml-output"/>
				<xsl:text>section/</xsl:text>
				<xsl:value-of select="primary-section-info/@id"/>
				<xsl:text>.xml</xsl:text>
			</xsl:variable>

			<xsl:result-document href="{$sectionDocFilename}" format="xml-output">
				<SECTION-DETAILS>
					<SECTIONTITLE>
						<xsl:apply-templates select="primary-section-info/section-long-title/node()"
						/>
					</SECTIONTITLE>
					<SHORTSECTION>
						<xsl:apply-templates
							select="primary-section-info/section-abridged-title/node()"/>
					</SHORTSECTION>
					<SECTIONADVISOR>
						<CONTRIBDETAILS>
							<xsl:for-each
								select="/condition/primary-section-info/section-advisors/advisor">
								<CONTRIBUTOR>
									<NOMEN>
										<xsl:value-of select="nomen"/>
									</NOMEN>
									<FIRSTNAME>
										<xsl:value-of select="first-name"/>
									</FIRSTNAME>
									<MIDDLENAME>
										<xsl:value-of select="middle-name"/>
									</MIDDLENAME>
									<LASTNAME>
										<xsl:value-of select="last-name"/>
									</LASTNAME>
									<PEDIGREE>
										<xsl:value-of select="pedigree"/>
									</PEDIGREE>
									<HONORIFIC>
										<xsl:value-of select="honorific"/>
									</HONORIFIC>
									<AUTHORTITLE>
										<xsl:value-of select="title"/>
									</AUTHORTITLE>
								</CONTRIBUTOR>
								<AFFILIATION>
									<xsl:value-of select="affiliation"/>
								</AFFILIATION>
								<CITY>
									<xsl:value-of select="city"/>
								</CITY>
								<COUNTRY>
									<xsl:value-of select="country"/>
								</COUNTRY>
							</xsl:for-each>
						</CONTRIBDETAILS>
					</SECTIONADVISOR>
				</SECTION-DETAILS>
			</xsl:result-document>

			<xsl:apply-templates select="condition-info/condition-long-title"/>
			<xsl:apply-templates select="condition-info/condition-abridged-title"/>
			<xsl:apply-templates select="condition-info/search-date"/>
			<xsl:apply-templates select="condition-info/collective-name"/>
			<xsl:apply-templates select="background"/>
			<xsl:apply-templates select="key-message"/>

			<question-section>
				<xsl:apply-templates select="questions/node()"/>
			</question-section>

			<subsequent-update>
				<xsl:apply-templates select="condition-info/future-updates/node()"/>
			</subsequent-update>
			<covered-elsewhere>
				<xsl:apply-templates select="condition-info/covered-elsewhere/node()"/>
			</covered-elsewhere>
			<summary-footnote>
				<xsl:apply-templates select="condition-info/footnote/node()"/>
			</summary-footnote>

			<glossary id="Glossary">
				<xsl:for-each select="glossary/gloss">
					<p>
						<xsl:attribute name="id" select="substring-after(@id, '_')"/>
						<xsl:apply-templates select="node()"/>
					</p>
				</xsl:for-each>
			</glossary>
			<reference-section>
				<xsl:for-each select="references/reference">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
			</reference-section>

			<!-- todo this is currently empty -->
			<additional-note>
				<xsl:text>Figures: </xsl:text>
				<xsl:choose>
					<xsl:when test="/condition/figures/figure">
						<xsl:for-each select="/condition/figures/figure">
							<sys-link type="system-figure">
								<xsl:attribute name="refid">F<xsl:value-of
										select="translate(substring-after(@id, '_F'), $lower, $upper)"
									/></xsl:attribute>
							</sys-link>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>none. </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>Tables: </xsl:text>
				<xsl:choose>
					<xsl:when test="/condition/tables/table-data">
						<xsl:for-each select="/condition/tables/table-data">
							<sys-link type="system-table">
								<xsl:attribute name="refid">T<xsl:value-of
										select="translate(substring-after(@id, '_T'), $lower, $upper)"
									/></xsl:attribute>
							</sys-link>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>none.</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</additional-note>

			<!-- authors docs -->
			<xsl:variable name="authorsDocFilename">
				<xsl:if test="starts-with( translate($ramin-xml-output, $upper, $lower), 'c')">
					<xsl:text>/</xsl:text>
				</xsl:if>
				<xsl:value-of select="$ramin-xml-output"/>
				<xsl:text>author/</xsl:text>
				<xsl:value-of select="@id"/>
				<xsl:text>_authors.xml</xsl:text>
			</xsl:variable>

			<xsl:result-document href="{$authorsDocFilename}" format="xml-output">
				<CONTRIBDETAILS-COMPINTERESTS>
					<CONTRIBDETAILS>
						<xsl:for-each select="/condition/condition-info/contributors/contributor">
							<CONTRIBUTOR>
								<xsl:attribute name="ID">
									<xsl:value-of select="substring-after(@id, '_')"/>
								</xsl:attribute>
								<NOMEN>
									<xsl:value-of select="nomen"/>
								</NOMEN>
								<FIRSTNAME>
									<xsl:value-of select="first-name"/>
								</FIRSTNAME>
								<MIDDLENAME>
									<xsl:value-of select="middle-name"/>
								</MIDDLENAME>
								<LASTNAME>
									<xsl:value-of select="last-name"/>
								</LASTNAME>
								<PEDIGREE>
									<xsl:value-of select="pedigree"/>
								</PEDIGREE>
								<HONORIFIC>
									<xsl:value-of select="honorific"/>
								</HONORIFIC>
								<AUTHORTITLE>
									<xsl:value-of select="title"/>
								</AUTHORTITLE>
							</CONTRIBUTOR>
							<AFFILIATION>
								<xsl:value-of select="affiliation"/>
							</AFFILIATION>
							<CITY>
								<xsl:value-of select="city"/>
							</CITY>
							<COUNTRY>
								<xsl:value-of select="country"/>
							</COUNTRY>
						</xsl:for-each>
					</CONTRIBDETAILS>
					<COMPINTERESTS>
						<xsl:for-each select="/condition/condition-info/competing-interests/p">
							<P>
								<xsl:apply-templates mode="uc"/>
							</P>
						</xsl:for-each>
					</COMPINTERESTS>
				</CONTRIBDETAILS-COMPINTERESTS>
			</xsl:result-document>
		</condition>

		<!-- tables docs -->
		<xsl:for-each select="/condition/tables/table-data">
			<xsl:variable name="tablesDocFilename">
				<xsl:if test="starts-with( translate($ramin-xml-output, $upper, $lower), 'c')">
					<xsl:text>/</xsl:text>
				</xsl:if>
				<xsl:value-of select="$ramin-xml-output"/>
				<xsl:text>table/</xsl:text>
				<xsl:value-of select="substring-before(@id, '_')"/>
				<xsl:text>_table_</xsl:text>
				<xsl:value-of select="substring-after(@id, '_T')"/>
				<xsl:text>.xml</xsl:text>
			</xsl:variable>
			<xsl:result-document href="{$tablesDocFilename}" format="xml-output">
				<TABLEDATA>
					<TABLEREF>
						<xsl:attribute name="ID" select="substring-after(@id, '_')"/>
						<xsl:value-of select="substring-after(@id, '_T')"/>
					</TABLEREF>
					<TABLECAPTION>
						<xsl:apply-templates select="caption/node()" mode="uc"/>
					</TABLECAPTION>
					<xsl:for-each select="cals:table">
						<TABLE>
							<xsl:for-each select="@*">
								<xsl:attribute name="{translate(name(), $lower, $upper)}" select="."/>
							</xsl:for-each>
							<TGROUP>
								<xsl:for-each select="cals:tgroup/@*">
									<xsl:attribute name="{translate(name(), $lower, $upper)}" select="."/>
								</xsl:for-each>
								<xsl:for-each select="cals:tgroup/cals:colspec">
									<xsl:apply-templates select="." mode="uc"/>
								</xsl:for-each>
								<xsl:for-each select="cals:thead">
									<xsl:apply-templates select="." mode="uc"/>
								</xsl:for-each>
								<xsl:for-each select="cals:tbody">
									<xsl:apply-templates select="." mode="uc"/>
								</xsl:for-each>
								<xsl:for-each select="cals:tfoot">
									<xsl:apply-templates select="." mode="uc"/>
								</xsl:for-each>
							</TGROUP>
						</TABLE>
					</xsl:for-each>
					<!-- <xsl:apply-templates select="cals:table" mode="uc"/> -->
				</TABLEDATA>
			</xsl:result-document>
		</xsl:for-each>

		<!-- figures docs -->
		<xsl:for-each select="/condition/figures/figure">
			<xsl:variable name="figureDocFilename">
				<xsl:if test="starts-with( translate($ramin-xml-output, $upper, $lower), 'c')">
					<xsl:text>/</xsl:text>
				</xsl:if>
				<xsl:value-of select="$ramin-xml-output"/>
				<xsl:text>figure/</xsl:text>
				<xsl:value-of select="substring-before(@id, '_')"/>
				<xsl:text>_figure_</xsl:text>
				<xsl:value-of select="substring-after(@id, '_F')"/>
				<xsl:text>.xml</xsl:text>
			</xsl:variable>
			<xsl:result-document href="{$figureDocFilename}" format="xml-output">
				<FIGURE>
					<GRAPHIC>
						<xsl:attribute name="FILENAME"><xsl:value-of
								select="substring-before(@id, '_')"/>.f<xsl:value-of
								select="substring-after(@id, '_F')"/></xsl:attribute>
					</GRAPHIC>
					<FIGUREREF>
						<xsl:attribute name="ID" select="substring-after(@id, '_')"/>
						<xsl:value-of select="substring-after(@id, '_F')"/>
					</FIGUREREF>
					<FIGURECAPTION>
						<xsl:apply-templates select="caption/node()" mode="uc"/>
					</FIGURECAPTION>
				</FIGURE>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>

	<xsl:template
		match="link[@type='option-benefits' or @type='option-harms' or @type='option-comment']">
		<link>
			<xsl:attribute name="type">internal-target</xsl:attribute>
			<xsl:variable name="afterConditionId" select="substring-after(@target, '_')"/>
			<xsl:variable name="targetOptionId" select="substring-before($afterConditionId, '_')"/>
			<xsl:variable name="targetPartId" select="substring-after($afterConditionId, '_')"/>
			<xsl:attribute name="refid"><xsl:value-of select="$targetOptionId"/>_<xsl:value-of
					select="translate($targetPartId, $upper, $lower)"/></xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</link>
	</xsl:template>

	<xsl:template match="link[@type='option']">
		<link>
			<xsl:attribute name="type">internal-target</xsl:attribute>
			<xsl:attribute name="refid" select="translate(substring-after(@target, '_'), $lower, $upper)"/>
			<xsl:copy-of select="node()"/>
		</link>
	</xsl:template>
	<xsl:template match="link[@type='internal-table' or @type='table']">
		<link>
			<xsl:attribute name="type">internal-table</xsl:attribute>
			<xsl:attribute name="refid" select="translate(substring-after(@target, '_'), $lower, $upper)"/>
			<xsl:copy-of select="node()"/>
		</link>
	</xsl:template>
	<xsl:template match="link[@type='internal-figure' or @type='figure']">
		<link>
			<xsl:attribute name="type">internal-figure</xsl:attribute>
			<xsl:attribute name="refid" select="translate(substring-after(@target, '_'), $lower, $upper)"/>
			<xsl:copy-of select="node()"/>
		</link>
	</xsl:template>
	<xsl:template match="link[@type='question']">
		<link>
			<xsl:attribute name="type">internal-target</xsl:attribute>
			<xsl:attribute name="refid" select="translate(substring-after(@target, '_'), $lower, $upper)"/>
			<xsl:copy-of select="node()"/>
		</link>
	</xsl:template>
	<xsl:template match="link[@type='condition']">
		<ext-link>
			<xsl:attribute name="type">external-condition</xsl:attribute>
			<xsl:attribute name="refid" select="@target"/>
			<xsl:copy-of select="node()"/>
		</ext-link>
	</xsl:template>
	<xsl:template match="link[@type='internal-glossary' or @type='glossary']">
		<link>
			<xsl:attribute name="type">internal-glossary</xsl:attribute>
			<xsl:attribute name="refid" select="translate(substring-after(@target, '_'), $lower, $upper)"/>
			<xsl:copy-of select="node()"/>
		</link>
	</xsl:template>

	<xsl:template match="link[@type='reference']">
		<xsl:text>[</xsl:text>
		<xsl:value-of select="substring-after(@target, 'REF')"/>
		<xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template match="link[@type='reference']" mode="uc">
		<xsl:text>[</xsl:text>
		<xsl:value-of select="substring-after(@target, 'REF')"/>
		<xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template match="link[@type='url']">
		<ext-link>
			<xsl:attribute name="type">external-url</xsl:attribute>
			<xsl:attribute name="refid" select="@target"/>
			<xsl:copy-of select="node()"/>
		</ext-link>
	</xsl:template>

	<xsl:template match="link[@type='change-start' or @type='change-end']">
		<link>
			<xsl:attribute name="type" select="@type"/>
			<xsl:copy-of select="node()"/>
		</link>
	</xsl:template>

	<xsl:template match="link[@type='background']">
		<link>
			<xsl:attribute name="type">internal-target</xsl:attribute>
			<xsl:variable name="target" select="translate(substring-after(@target, '_'), $lower, $upper)"/>
			<xsl:variable name="firstTarget" select="substring($target, 1, 1)"/>
			<xsl:variable name="restTarget" select="substring($target, 2)"/>
			<xsl:attribute name="refid">
				<xsl:value-of select="$firstTarget"/>
				<xsl:value-of select="translate($restTarget, $upper, $lower)"/>
			</xsl:attribute>
			<xsl:copy-of select="node()"/>
		</link>
	</xsl:template>

	<xsl:template match="link">
		<link>
			<xsl:attribute name="type">todo</xsl:attribute>
			<xsl:attribute name="refid" select="substring-after(@target, '_')"/>
			<xsl:copy-of select="node()"/>
		</link>
	</xsl:template>

	<xsl:template match="intervention-summary">
		<summary>
			<xsl:apply-templates select="node()"/>
		</summary>
	</xsl:template>

	<xsl:template match="key-message">
		<key-message>
			<xsl:apply-templates select="node()"/>
		</key-message>
	</xsl:template>


	<xsl:template match="option-contributor | question-contributor">
		<contributor>
			<xsl:apply-templates select="node()"/>
		</contributor>
	</xsl:template>

	<xsl:template match="intervention-title">
		<intervention-title>
			<xsl:attribute name="type" select="@efficacy"/>
			<xsl:apply-templates select="node()"/>
		</intervention-title>
	</xsl:template>

	<xsl:template match="substantive-changes">
		<xsl:if test="substantive-change">
			<substantive-change>
				<xsl:for-each select="substantive-change">
					<p>
						<xsl:if test="@status">
							<xsl:attribute name="status" select="@status"/>
						</xsl:if>
						<xsl:apply-templates/>
					</p>
				</xsl:for-each>
			</substantive-change>
		</xsl:if>
	</xsl:template>

	<xsl:template match="substantive-change"> </xsl:template>

	<xsl:template match="reference">
		<reference>
			<xsl:attribute name="id" select="translate(substring-after(@id, '_'), $lower, $upper)"/>
			<xsl:apply-templates select="node()"/>
		</reference>
	</xsl:template>

	<xsl:template
		match="definition | incidence | aetiology | prognosis | aims | outcomes | methods | diagnosis | glossary">
		<xsl:element name="{name()}">
			<xsl:for-each select="@*">
				<xsl:choose>
					<xsl:when test="name()='id'">
						<!-- don't pass through id -->
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="{name()}" select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

			<xsl:variable name="first" select="substring(name(), 1, 1)"/>
			<xsl:variable name="rest" select="substring(name(), 2)"/>
			<xsl:attribute name="id">
				<xsl:value-of select="translate($first, $lower, $upper)"/>
				<xsl:value-of select="translate($rest, $upper, $lower)"/>
			</xsl:attribute>

			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="benefits | harms | comment">
		<xsl:variable name="name" select="name()"/>
		<xsl:element name="{$name}">
			<xsl:for-each select="@*">
				<xsl:choose>
					<xsl:when test="name()='id'">
						<xsl:variable name="afterConditionId" select="substring-after(., '_')"/>
						<xsl:variable name="optionId" select="substring-before($afterConditionId, '_')"/>
						<xsl:variable name="partId" select="substring-after($afterConditionId, '_')"/>
						<xsl:attribute name="{name()}"><xsl:value-of select="$optionId"
								/>_<xsl:value-of select="translate($partId, $upper, $lower)"
						/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="{name()}" select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<p>
				<xsl:apply-templates select="node()"/>
			</p>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="drug-safety-alert">
		<xsl:element name="{name()}">
			<xsl:for-each select="p">
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template match="text()">
		<xsl:choose>
			<xsl:when test="normalize-space(.)=''">
				<xsl:choose>
					<xsl:when test="name(following-sibling::node()[1])='link'">
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- generic template to copy an element changing all element and attrib names to be UC-->
	<xsl:template match="*" mode="uc">
		<xsl:variable name="elementName">
			<xsl:choose>
				<xsl:when test="starts-with(name(), 'cals')">
					<xsl:value-of select="translate(substring-after(name(), ':'), $lower, $upper)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="translate(name(), $lower, $upper)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$elementName}">
			<xsl:for-each select="@*">
				<xsl:if
					test="name() != 'colwidth' and name() != 'valign' and name() != 'morerows' and name() != 'align'">
					<xsl:attribute name="{translate(name(), $lower, $upper)}" select="."/>
				</xsl:if>
				<xsl:if test="name() = 'valign'">
					<!-- do nothing -->
				</xsl:if>
				<xsl:if test="name() = 'morerows'">
					<!-- do nothing -->
				</xsl:if>
				<xsl:if test="name() = 'colwidth'">
					<xsl:attribute name="COLWIDTH"><xsl:value-of select="substring-before(., '%')"
						/>*</xsl:attribute>
				</xsl:if>
				<xsl:if test="name() = 'align' and not(string(.))">
					<xsl:attribute name="ALIGN">LEFT</xsl:attribute>
				</xsl:if>
				<xsl:if test="name() = 'align' and string(.)">
					<xsl:attribute name="ALIGN" select="translate(., $lower, $upper)"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:apply-templates select="node()" mode="uc"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="link" mode="uc">
		<XREF>
			<xsl:attribute name="REFID">
				<xsl:value-of select="translate(substring-after(@target, '_'), '_', '-')"/>
			</xsl:attribute>
			<xsl:apply-templates mode="uc"/>
		</XREF>
	</xsl:template>
	
	<xsl:template match="strong" mode="uc">
		<B>
			<xsl:apply-templates mode="uc"/>
		</B>
	</xsl:template>
	
	<xsl:template match="em" mode="uc">
		<I>
			<xsl:apply-templates mode="uc"/>
		</I>
	</xsl:template>
	
	<xsl:template match="sup" mode="uc">
		<SUP>
			<xsl:apply-templates mode="uc"/>
		</SUP>
	</xsl:template>
	
	<xsl:template match="sub" mode="uc">
		<SUB>
			<xsl:apply-templates mode="uc"/>
		</SUB>
	</xsl:template>
	
	<!-- generic template to copy an element -->
	<xsl:template match="*">
		<xsl:element name="{name()}">
			<xsl:for-each select="@*">
				<xsl:choose>
					<xsl:when test="name()='id'">
						<xsl:attribute name="{name()}" select="translate(substring-after(., '_'), $lower, $upper)"/>
					</xsl:when>
					<xsl:when test="name()='is-new' and .='true'">
						<xsl:attribute name="status">new</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="{name()}" select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="term">
		<strong>
			<xsl:apply-templates select="node()"/>
		</strong>
	</xsl:template>	
	
</xsl:stylesheet>

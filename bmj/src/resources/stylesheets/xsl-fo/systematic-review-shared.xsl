<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE xsl:stylesheet [
	<!ENTITY ceblue "#0d519f">
	<!ENTITY celightblue "#c5c9e6">
	<!ENTITY cegrey "#cccccc">
]>

<?altova_samplexml C:\dev\docato-install\BMJ\systematic-review-publish.xml?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:rx="http://www.renderx.com/XSL/Extensions"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html">

	<!-- add: line-height-shift-adjustment="disregard-shifts" page or block -->

	<xsl:variable name="media">web</xsl:variable>

	<!-- icons for display -->
	<!-- fix: add to properties file -->
	<xsl:variable name="icon-bullet">&#x2022;</xsl:variable>
	<!-- • ● □ ■ -->
	<xsl:variable name="icon-glossary">[G]</xsl:variable>
	<xsl:variable name="icon-table">[T]</xsl:variable>
	<xsl:variable name="icon-figure">[F]</xsl:variable>
	<xsl:variable name="icon-arrow-right">&gt;&gt;</xsl:variable>
	<xsl:variable name="icon-arrow-left">&lt;&lt;</xsl:variable>

	<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz-áâãäåæçèéêëìíîïðñòóôõöøùúûüý'"/>
	<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ_ÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝ'"/>

	<xsl:template name="do-page-masters">
		<fo:layout-master-set>

			<fo:simple-page-master master-name="first-page" margin-right="1.5cm" margin-left="1.5cm"
				margin-bottom="1cm" margin-top="1cm">

				<!-- add page dimensions to suit product stream -->
				<xsl:choose>
					<xsl:when test="contains($media, 'web')">
						<xsl:attribute name="page-width">210mm</xsl:attribute>
						<xsl:attribute name="page-height">297mm</xsl:attribute>
					</xsl:when>
					<xsl:when test="contains($media, 'print')">
						<xsl:attribute name="page-width">130mm</xsl:attribute>
						<xsl:attribute name="page-height">215mm</xsl:attribute>
					</xsl:when>
				</xsl:choose>

				<fo:region-body margin="1cm"/>

				<fo:region-before extent="0cm" region-name="first-header"/>
				<fo:region-after extent="1cm" region-name="first-footer"/>

				<fo:region-end extent="1cm" region-name="first-right"/>
			</fo:simple-page-master>

			<fo:simple-page-master master-name="all-pages" margin-right="1.5cm" margin-left="1.5cm"
				margin-bottom="1cm" margin-top="1cm">

				<!-- add page dimensions to suit product stream -->
				<xsl:choose>
					<xsl:when test="contains($media, 'web')">
						<xsl:attribute name="page-width">210mm</xsl:attribute>
						<xsl:attribute name="page-height">297mm</xsl:attribute>
					</xsl:when>
					<xsl:when test="contains($media, 'print')">
						<xsl:attribute name="page-width">130mm</xsl:attribute>
						<xsl:attribute name="page-height">215mm</xsl:attribute>
					</xsl:when>
				</xsl:choose>

				<fo:region-body margin="1cm"/>

				<fo:region-before extent="1cm" region-name="all-header"/>
				<fo:region-after extent="1cm" region-name="all-footer"/>
				<fo:region-end extent="1cm" region-name="all-right"/>
			</fo:simple-page-master>

			<fo:page-sequence-master master-name="my-sequence">
				<fo:single-page-master-reference master-reference="first-page"/>
				<fo:repeatable-page-master-reference master-reference="all-pages"/>
			</fo:page-sequence-master>
		</fo:layout-master-set>
	</xsl:template>

	<xsl:template name="do-static-content">
		<fo:static-content flow-name="first-right">
			<fo:block-container reference-orientation="-90">
				<fo:block line-height="14pt" font-size="14pt" font-weight="bold" text-align="start"
					color="&celightblue;">
					<xsl:value-of select="//sections/section-link[@type='primary']/section/title"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>

		<fo:static-content flow-name="all-right">
			<fo:block-container reference-orientation="-90">
				<fo:block line-height="14pt" font-size="14pt" font-weight="bold" text-align="start"
					color="&celightblue;">
					<xsl:value-of select="//sections/section-link[@type='primary']/section/title"/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>

		<fo:static-content flow-name="all-header">
			<fo:block line-height="14pt" font-size="14pt" font-weight="bold" text-align="right"
				color="&celightblue;">
				<xsl:value-of select="//bmjk-review-plan/info/title"/>
			</fo:block>
		</fo:static-content>

		<fo:static-content flow-name="first-footer">
			<fo:block space-before="5pt" font-size="8pt" text-align="right">

				<xsl:text>© BMJ Publishing Group Ltd</xsl:text>
				<xsl:text disable-output-escaping="yes"> </xsl:text>

			</fo:block>
		</fo:static-content>

		<fo:static-content flow-name="all-footer">
			<fo:block space-before="5pt" font-size="8pt" text-align="right">

				<xsl:text>© BMJ Publishing Group Ltd</xsl:text>
				<xsl:text disable-output-escaping="yes"> </xsl:text>

			</fo:block>
		</fo:static-content>
	</xsl:template>

	<xsl:template name="do-headers">
		<fo:block font-size="16pt" font-weight="bold" text-align="right" space-after="5px">
			<xsl:value-of select="//bmjk-review-plan/info/title"/>
		</fo:block>
		<fo:block font-size="12pt" font-weight="bold" text-align="right" color="&ceblue;"
			space-after="5px">
			<xsl:value-of select="//info/search-date"/>
		</fo:block>

		<fo:block font-size="10pt" font-weight="normal" font-style="italic" text-align="right"
			space-after="20pt" color="&ceblue;">
			<xsl:value-of select="//bmjk-review-plan/info/collective-name"/>
		</fo:block>
	</xsl:template>

	<xsl:template name="do-intervention-table-single-efficacy">
		<xsl:param name="heading"/>
		<xsl:param name="efficacy"/>
		<xsl:param name="node-set"/>

		<xsl:if test="$node-set/xi:include/option/intervention-set/intervention[@efficacy=$efficacy]">
			<fo:block space-after="10px">
				<fo:block font-weight="bold"><xsl:value-of select="$heading"/></fo:block>
				<xsl:for-each
					select="xi:include/option/intervention-set/intervention[@efficacy=$efficacy]">
					<xsl:sort select="title"/>
					
					<fo:block text-align-last="justify">
						<xsl:apply-templates select="title"/>
						
						<fo:leader leader-pattern="dots"/>
					</fo:block>
				</xsl:for-each>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template name="do-intervention-table">
		<!-- interventions -->
		<fo:block background-color="&ceblue;" color="white" text-align="center" font-weight="bold">INTERVENTIONS</fo:block>

		<rx:flow-section column-count="2" column-gap="30px">

			<fo:block background-color="&celightblue;" space-after="10px">

				<xsl:for-each select="/systematic-review/question-list/question">

					<fo:block font-weight="bold">
						<xsl:value-of
							select="translate(title,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
					</fo:block>

					<!-- beneficial -->
					<xsl:call-template name="do-intervention-table-single-efficacy">
						<xsl:with-param name="node-set" select="."/>
						<xsl:with-param name="heading">Beneficial</xsl:with-param>
						<xsl:with-param name="efficacy">beneficial</xsl:with-param>
					</xsl:call-template>

					<!-- likely-to-be-beneficial -->
					<xsl:call-template name="do-intervention-table-single-efficacy">
						<xsl:with-param name="node-set" select="."/>
						<xsl:with-param name="heading">Likely to be beneficial</xsl:with-param>
						<xsl:with-param name="efficacy">likely-to-be-beneficial</xsl:with-param>
					</xsl:call-template>
					
					<!-- trade-off-between-benefits-and-harms -->
					<xsl:call-template name="do-intervention-table-single-efficacy">
						<xsl:with-param name="node-set" select="."/>
						<xsl:with-param name="heading">Trade off between benefits and harms</xsl:with-param>
						<xsl:with-param name="efficacy">trade-off-between-benefits-and-harms</xsl:with-param>
					</xsl:call-template>

					<!-- unknown-effectiveness -->
					<xsl:call-template name="do-intervention-table-single-efficacy">
						<xsl:with-param name="node-set" select="."/>
						<xsl:with-param name="heading">Unknown effectiveness</xsl:with-param>
						<xsl:with-param name="efficacy">unknown-effectiveness</xsl:with-param>
					</xsl:call-template>

					<!-- unlikely-to-be-beneficial -->
					<xsl:call-template name="do-intervention-table-single-efficacy">
						<xsl:with-param name="node-set" select="."/>
						<xsl:with-param name="heading">Unlikely to be beneficial</xsl:with-param>
						<xsl:with-param name="efficacy">unlikely-to-be-beneficial</xsl:with-param>
					</xsl:call-template>

					<!-- likely-to-be-ineffective-or-harmful -->
					<xsl:call-template name="do-intervention-table-single-efficacy">
						<xsl:with-param name="node-set" select="."/>
						<xsl:with-param name="heading">Likely to be ineffective or harmful</xsl:with-param>
						<xsl:with-param name="efficacy">likely-to-be-ineffective-or-harmful</xsl:with-param>
					</xsl:call-template>

				</xsl:for-each>

				<!-- subsequent-update -->
				<xsl:if test="string-length(subsequent-update/p[1])">
					<fo:block space-after="10px">
						<fo:block font-weight="bold"><xsl:text>To be covered in future updates</xsl:text></fo:block>
						<xsl:for-each select="subsequent-update/p">
							<fo:block>
								<xsl:apply-templates/>
							</fo:block>
						</xsl:for-each>
					</fo:block>
				</xsl:if>

				<!-- covered-elsewhere -->
				<xsl:if test="string-length(covered-elsewhere/p[1])">
					<fo:block space-after="10px">
						<fo:block font-weight="bold"><xsl:text>Covered elsewhere in Clinical Evidence</xsl:text></fo:block>
						<xsl:for-each select="covered-elsewhere/p">
							<fo:block>
								<xsl:apply-templates/>
							</fo:block>
						</xsl:for-each>
					</fo:block>
				</xsl:if>

				<!-- intervention-summary-footnote -->
				<xsl:if
					test="string-length(intervention-summary-footnote/p[1]) or /condition/glossary/p/@id">
					<fo:block space-after="10px">
						<xsl:for-each select="intervention-summary-footnote/p">
							<fo:block>
								<xsl:apply-templates/>
							</fo:block>
						</xsl:for-each>
					</fo:block>
				</xsl:if>

			</fo:block>

		</rx:flow-section>

	</xsl:template>
	
	
		<xsl:template name="do-clinical-context">
		<!-- background -->
		<fo:block space-after="10px">

			<xsl:call-template name="do-background-single">
				<xsl:with-param name="node-tree" select="//general-background"/>
				<xsl:with-param name="heading">GENERAL BACKGROUND</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="do-background-single">
				<xsl:with-param name="node-tree" select="//focus-of-the-review"/>
				<xsl:with-param name="heading">FOCUS OF THE REVIEW</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="do-background-single">
				<xsl:with-param name="node-tree" select="//comments-on-evidence"/>
				<xsl:with-param name="heading">COMMENTS ON EVIDENCE</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="do-background-single">
				<xsl:with-param name="node-tree" select="//search-and-appraisal-summary"/>
				<xsl:with-param name="heading">SEARXH AND APPRAISAL SUMMARY</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="do-background-single">
				<xsl:with-param name="node-tree" select="//additional-information"/>
				<xsl:with-param name="heading">ADDITIONAL INFORMATION</xsl:with-param>
			</xsl:call-template>
		</fo:block>

	</xsl:template>


	<xsl:template name="do-background">
		<!-- background -->
		<fo:block space-after="10px">

			<xsl:call-template name="do-background-single">
				<xsl:with-param name="node-tree" select="//definition"/>
				<xsl:with-param name="heading">DEFINITION</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="do-background-single">
				<xsl:with-param name="node-tree" select="//incidence"/>
				<xsl:with-param name="heading">INCIDENCE</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="do-background-single">
				<xsl:with-param name="node-tree" select="//aetiology"/>
				<xsl:with-param name="heading">AETIOLOGY</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="do-background-single">
				<xsl:with-param name="node-tree" select="//diagnosis"/>
				<xsl:with-param name="heading">DIAGNOSIS</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="do-background-single">
				<xsl:with-param name="node-tree" select="//prognosis"/>
				<xsl:with-param name="heading">PROGNOSIS</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="do-background-single">
				<xsl:with-param name="node-tree" select="//aims"/>
				<xsl:with-param name="heading">AIMS</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="do-background-single">
				<xsl:with-param name="node-tree" select="//outcomes"/>
				<xsl:with-param name="heading">OUTCOMES</xsl:with-param>
			</xsl:call-template>
		</fo:block>

	</xsl:template>

	<xsl:template name="do-background-single">
		<xsl:param name="heading"/>
		<xsl:param name="node-tree"/>

		<!-- horizontal rule -->
		<fo:block>
			<fo:leader leader-pattern="rule" leader-length="100%" rule-style="solid" rule-thickness="1px"
				color="&ceblue;" space-after="5px"/>
		</fo:block>

		<fo:list-block space-after="5px">
			<fo:list-item>
				<fo:list-item-label end-indent="115px">
					<fo:block color="&ceblue;" font-weight="bold" linefeed-treatment="preserve">
						<xsl:value-of select="$heading"/>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="115px">
					<fo:block color="&ceblue;" font-size="90%">
						<xsl:for-each select="$node-tree/p">
							<xsl:apply-templates select="node()"/>
						</xsl:for-each>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>
	
	<xsl:template name="do-option-part-single">
		<xsl:param name="heading"/>
		<xsl:param name="node-tree"/>
		
		
		<!-- benefits -->
		<fo:list-block space-after="10px">
			<fo:list-item>
				<fo:list-item-label end-indent="115px">
					<fo:block font-weight="bold" color="&ceblue;">
						<xsl:value-of select="$heading"/>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="115px">
					<fo:block line-height-shift-adjustment="disregard-shifts">
						<xsl:apply-templates select="$node-tree"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>		
	</xsl:template>

	<xsl:template match="option">
		<!-- for each option -->
		<fo:block>
			
			<fo:block background-color="&ceblue;" color="white" font-weight="bold">
				<xsl:text>OPTION</xsl:text></fo:block>
			
			<!-- title -->
			<fo:list-block space-after="10px" background-color="&celightblue;">
				<fo:list-item>
					<fo:list-item-label end-indent="90px">
						<fo:block background-color="&ceblue;" color="white"><xsl:text>Title</xsl:text></fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="90px">
						<fo:block background-color="&celightblue;" color="&ceblue;" font-weight="bold">
							<xsl:apply-templates select="title/node()"/>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>

				<fo:list-item>
					<fo:list-item-label end-indent="90px">
						<fo:block background-color="&ceblue;" color="white"><xsl:text>Abridged title</xsl:text></fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="90px">
						<fo:block background-color="&celightblue;" color="&ceblue;" font-weight="bold">
							<xsl:apply-templates select="abridged-title/node()"/>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
			
			<!-- key-message -->
			<fo:block font-weight="bold" space-after="10px"
				line-height-shift-adjustment="disregard-shifts" text-align="left">
				<xsl:choose>
					<xsl:when test="string-length(key-message)">
						<!-- has overarching km -->
						<xsl:apply-templates select="key-message"/>
					</xsl:when>
					<xsl:when test="count(intervention-set/intervention) = 1">
						<!-- has single intervention -->
						<xsl:apply-templates select="intervention-set/intervention/key-message"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- do nothing or test -->
						<fo:block>key-message-predicate-warning</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</fo:block>
			
			<xsl:call-template name="do-option-part-single">
				<xsl:with-param name="heading">Benefits:</xsl:with-param>
				<xsl:with-param name="node-tree" select="benefits"></xsl:with-param>
			</xsl:call-template>
			
			<xsl:call-template name="do-option-part-single">
				<xsl:with-param name="heading">Harms:</xsl:with-param>
				<xsl:with-param name="node-tree" select="harms"></xsl:with-param>
			</xsl:call-template>
			
			<xsl:call-template name="do-option-part-single">
				<xsl:with-param name="heading">Comment:</xsl:with-param>
				<xsl:with-param name="node-tree" select="comment"></xsl:with-param>
			</xsl:call-template>
		</fo:block>
	</xsl:template>

	<xsl:template name="do-questions">
		<!-- questions -->
		<fo:block>

			<xsl:for-each select="/systematic-review/question-list/question">

				<!-- for each question -->
				<fo:block>

					<fo:block background-color="black" color="white" font-weight="bold"><xsl:text>QUESTION</xsl:text></fo:block>
					
					<!-- title -->
					<fo:list-block space-after="10px" background-color="&cegrey;">
						<fo:list-item>
							<fo:list-item-label end-indent="90px">
								<fo:block background-color="black" color="white" font-weight="bold">
									<xsl:text>Title</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="90px">
								<fo:block background-color="&cegrey;" font-weight="bold">
									<xsl:value-of select="title"/>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>

					<fo:list-block space-after="10px" background-color="&cegrey;">
						<fo:list-item>
							<fo:list-item-label end-indent="90px">
								<fo:block background-color="black" color="white" font-weight="bold">
									<xsl:text>Abridged title</xsl:text>
								</fo:block>
							</fo:list-item-label>
							<fo:list-item-body start-indent="90px">
								<fo:block background-color="&cegrey;" font-weight="bold">
									<xsl:value-of select="abridged-title"/>
								</fo:block>
							</fo:list-item-body>
						</fo:list-item>
					</fo:list-block>
					
					<xsl:apply-templates select="xi:include/option"/>
				</fo:block>

			</xsl:for-each>

		</fo:block>
	</xsl:template>

	<xsl:template name="do-references">
		<fo:block font-weight="bold" color="&ceblue;"> REFERENCES </fo:block>

		<rx:flow-section column-count="2" column-gap="10px">
			<xsl:for-each select="//reference-link">
				<fo:block font-size="70%">
					<xsl:apply-templates select="reference/clinical-citation/node()"/>
				</fo:block>
			</xsl:for-each>
		</rx:flow-section>
	</xsl:template>

	<xsl:template match="em">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="strong">
		<fo:inline font-weight="bold">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="term">
		<fo:inline font-weight="bold">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="sub">
		<fo:inline vertical-align="sub" font-size="75%">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="sup">
		<fo:inline vertical-align="super" font-size="75%">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="br">
		<xsl:element name="br"/>
	</xsl:template>

	<xsl:template match="record-link">
		<fo:inline color="red" background-color="#BBBBBB">
			<xsl:text> [</xsl:text>
			<xsl:value-of select="@bmjk-citation"/>
			<xsl:text>] </xsl:text>
		</fo:inline>
	</xsl:template>

	<xsl:template match="link">
		<xsl:choose>
			<!-- reference -->
			<xsl:when test="@type='reference'">
				<fo:inline vertical-align="super" font-size="75%"
					line-height-shift-adjustment="disregard-shifts" color="red">[ref]</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="title|abridged-title">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="benefits|harms|comment">
		<xsl:for-each select="p">
			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
		</xsl:for-each>		
	</xsl:template>
	
	<xsl:template name="do-contributors">
		<xsl:for-each select="//contributor/person">
			<fo:block space-before="12pt" text-align="right" font-weight="bold">
				<xsl:choose>
					<xsl:when test="middle-name != ''">
						<xsl:value-of select="first-name"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="middle-name"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="last-name"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="first-name"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="last-name"/>
					</xsl:otherwise>
				</xsl:choose>
			</fo:block>
			
			<xsl:if test="pedigree!='' ">
				<fo:block text-align="right">
					<xsl:value-of select="pedigree"/>
				</fo:block>
			</xsl:if>
			<xsl:if test="honorific!='' ">
				<fo:block text-align="right">
					<xsl:value-of select="honorific"/>
				</fo:block>
			</xsl:if>
			<xsl:if test="title!='' ">
				<fo:block text-align="right">
					<xsl:value-of select="title"/>
				</fo:block>
			</xsl:if>
			<xsl:if test="affiliation!='' ">
				<fo:block text-align="right">
					<xsl:value-of select="affiliation"/>
				</fo:block>
			</xsl:if>
			<xsl:if test="city!='' ">
				<fo:block text-align="right">
					<xsl:value-of select="city"/>
				</fo:block>
			</xsl:if>
			<xsl:if test="country!='' ">
				<fo:block text-align="right">
					<xsl:value-of select="country"/>
				</fo:block>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*"> </xsl:template>

</xsl:stylesheet>

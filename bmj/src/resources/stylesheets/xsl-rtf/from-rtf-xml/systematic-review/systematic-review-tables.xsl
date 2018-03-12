<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:html="http://www.w3.org/HTML/1998/html4"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	exclude-result-prefixes="html uci">

	<xsl:output
		method="xml"
		version="1.0"
		encoding="UTF-8"
		indent="yes"
		omit-xml-declaration="no"/>

	<xsl:include href="../../../generic-params.xsl"/>
	<xsl:include href="../generic-rtf-params.xsl"/>
	<xsl:include href="../generic-rtf-tables-html.xsl"/>
	<xsl:include href="../generic-rtf-default-elements.xsl"/>

	<xsl:template match="/">

		<xsl:element name="table">
			<xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
			<!--<xsl:namespace name="xi">http://www.w3.org/2001/XInclude</xsl:namespace>
			<xsl:namespace name="cals">http://www.oasis-open.org/specs/tm9502.html</xsl:namespace>-->
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">bmjk-table.xsd</xsl:attribute>
			<xsl:attribute name="width">100%</xsl:attribute>
			<xsl:attribute name="border">1</xsl:attribute>

			<xsl:element name="caption">
				<!-- fix: avoid bold if possible -->
				<xsl:apply-templates select="/uci:document/uci:body[1]/uci:par[string-length(.)!=0][1]"/>

				<xsl:if test="contains(/uci:document/uci:body[1]/uci:par[string-length(.)!=0][1], 'GRADE')">
					<xsl:comment>
						<xsl:text>grade-table</xsl:text>
					</xsl:comment>
				</xsl:if>

			</xsl:element>

			<xsl:apply-templates select="//html:table[1]/html:thead"/>
			<xsl:apply-templates select="//html:table[1]/html:tbody"/>
			<!--<xsl:copy-of select="$grade-table-footnote"/>-->

		</xsl:element>

	</xsl:template>

	    <xsl:param name="grade-table-footnote">
	        <tr>
	            <td colspan="1" align="left"></td>
	        </tr>
	        <tr>
	            <td colspan="3" align="left"><strong>POB = Pyramid of benefit layer</strong> (1 = survival; 2 = prevention of disease/disease progression/harm;  3 = symptom reduction; 4 = prevention of complications of disease; 5 = quality of life; 6 = surrogate outcomes)</td>
	        </tr>
	        <tr>
	            <td colspan="3" align="left">* Nephropathy defined as  increase in serum creatinine levels  above threshold value</td>
	        </tr>
	        <tr>
	            <td colspan="3" align="left"><em>Type of evidence</em></td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left">Score</td>
	            <td colspan="1" align="left">4</td>
	            <td colspan="1" align="left">RCTs/ SR of RCTs, +/- other types of evidence</td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left"/>
	            <td colspan="1" align="left">2</td>
	            <td colspan="1" align="left">Observational</td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left"/>
	            <td colspan="1" align="left">1</td>
	            <td colspan="1" align="left">Non-analytical (expert opinion)</td>
	        </tr>
	        <tr>
	            <td colspan="3" align="left"><em>Quality</em></td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left">Base on</td>
	            <td colspan="2" align="left">Blinding and allocation process</td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left"/>
	            <td colspan="2" align="left">Follow up and withdrawals</td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left"/>
	            <td colspan="2" align="left">Sparse data</td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left"/>
	            <td colspan="2" align="left">Other concerns</td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left">Score</td>
	            <td colspan="1" align="left">0</td>
	            <td colspan="1" align="left">No problems</td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left"/>
	            <td colspan="1" align="left">-1</td>
	            <td colspan="1" align="left">Problem with 1 category</td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left"/>
	            <td colspan="1" align="left">-2</td>
	            <td colspan="1" align="left">Problem with 2 categories</td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left"/>
	            <td colspan="1" align="left">-3</td>
	            <td colspan="1" align="left">Problem with 3 or more categories</td>
	        </tr>
	        <tr>
	            <td colspan="3" align="left">Add 1 point if adjustment for confounders would have increased effect size</td>
	        </tr>
	        <tr>
	            <td colspan="3" align="left"><em>Consistency</em></td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left">Base on</td>
	            <td colspan="2" align="left">Significant difference for comparison and outcome reported by each study</td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left">Score</td>
	            <td colspan="1" align="left">0</td>
	            <td colspan="1" align="left">All/most studies show benefit (or harm)</td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left"/>
	            <td colspan="1" align="left">-1</td>
	            <td colspan="1" align="left">No agreement between studies</td>
	        </tr>
	        <tr>
	            <td colspan="3" align="left">Add 1 point if evidence of dose response across or within studies (or inconsistency across studies is explained by a dose response)</td>
	        </tr>
	        <tr>
	            <td colspan="3" align="left"><em>Directness</em></td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left">Base on</td>
	            <td colspan="2" align="left">Generaliseability of population and outcomes from each study to population of interest</td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left">Score</td>
	            <td colspan="1" align="left">0</td>
	            <td colspan="1" align="left">Population and outcomes generaliseable</td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left"/>
	            <td colspan="1" align="left">-1</td>
	            <td colspan="1" align="left">Population OR outcome not generaliseable</td>
	        </tr>
	        <tr>
	            <td colspan="1" align="left"/>
	            <td colspan="1" align="left">-2</td>
	            <td colspan="1" align="left">Population AND outcome not generaliseable</td>
	        </tr>
    </xsl:param>

</xsl:stylesheet>

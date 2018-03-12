<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.1"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink">
	
	<xsl:template match="list">
		<xsl:choose>
			<xsl:when test="@style='i'">
				<xsl:element name="list" use-attribute-sets="list-i">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:when>
			<xsl:when test="@style='1'">
				<xsl:element name="list" use-attribute-sets="list-1">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:when>
			<xsl:when test="@style='I'">
				<xsl:element name="list" use-attribute-sets="list-I">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:when>
			<xsl:when test="@style='a'">
				<xsl:element name="list" use-attribute-sets="list-a">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:when>
			<xsl:when test="@style='A'">
				<xsl:element name="list" use-attribute-sets="list-A">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:when>
			<xsl:when test="@style='bullet'">
				<xsl:element name="list" use-attribute-sets="list-bullet">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:when>
			<xsl:when test="@style='none'">
				<xsl:element name="list" use-attribute-sets="list-none">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="list" use-attribute-sets="list-none">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="item">
		<xsl:element name="item" use-attribute-sets="">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="para">
		<xsl:element name="par" use-attribute-sets="normal">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<!-- because our references stylesheet output tends to recurse with apply-templates we want to control them here --> 
	<xsl:template match="section[ancestor::references] | heading[ancestor::references] | par[ancestor::references]">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="organism">
		<xsl:element name="inline" use-attribute-sets="organism">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>

	<xsl:template match="drug">
		<xsl:element name="inline" use-attribute-sets="drug">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>

	<!-- LINKS -->
	<xsl:template match="reference-link">
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="combined-references">
			<xsl:element name="combined-references">
				<xsl:element name="reference">
					<xsl:call-template name="process-reference-links">
						<xsl:with-param name="item-count" select="1"/>
						<xsl:with-param name="link-index" select="1"/>
						<xsl:with-param name="link-count" select="count(//reference-link) + 1"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:variable>
		<xsl:element name="reference" use-attribute-sets="reference-link" xmlns:xlink="http://www.w3.org/1999/xlink">
			<xsl:for-each select="$combined-references//reference">
				<xsl:if test="processing-instruction()[name()='target'] = $target">
					<xsl:attribute name="xlink:href">
						<xsl:text>ref</xsl:text>
						<xsl:value-of select="processing-instruction()[name()='position']"/>
					</xsl:attribute>
				</xsl:if>
			</xsl:for-each>
			<xsl:attribute name="action">jump</xsl:attribute>
		</xsl:element>
		<xsl:text disable-output-escaping="yes"> </xsl:text>
	</xsl:template>
	
	<xsl:template match="evidence-score-link">
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="evidence-scores">
			<xsl:element name="evidence-scores">
				<xsl:element name="evidence-score">
					<xsl:call-template name="process-evidence-score-links">
						<xsl:with-param name="item-count" select="1"/>
						<xsl:with-param name="link-index" select="1"/>
						<xsl:with-param name="link-count" select="count(//evidence-score-link) + 1"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:variable>
		<xsl:element name="inline" use-attribute-sets="link">
			<xsl:text>[</xsl:text>
			<xsl:text>evid</xsl:text>
			<xsl:for-each select="$evidence-scores//evidence-score">
				<xsl:if test="processing-instruction()[name()='target'] = $target">
					<xsl:value-of select="processing-instruction()[name()='position']"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:text>]</xsl:text>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="figure-link">
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="figures">
			<xsl:element name="figures">
				<xsl:element name="figure">
					<xsl:call-template name="process-figure-links">
						<xsl:with-param name="item-count" select="1"/>
						<xsl:with-param name="link-index" select="1"/>
						<xsl:with-param name="link-count" select="count(//figure-link) + 1"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:variable>
		<xsl:element name="inline" use-attribute-sets="link">
			<xsl:text>[</xsl:text>
			<xsl:if  test="@inline = true">
				<xsl:text>-inline</xsl:text>
			</xsl:if>
			<xsl:text>img</xsl:text>
			<xsl:for-each select="$figures//figure">
				<xsl:if test="processing-instruction()[name()='target'] = $target">
					<xsl:value-of select="processing-instruction()[name()='position']"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:text>]</xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- system image link -->
	<xsl:template match="image-link">
		<xsl:element name="image" use-attribute-sets="">
			<xsl:attribute name="xlink:href">
				<xsl:value-of select="@target" />	
			</xsl:attribute>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="uri-link | monograph-plan-link | bmjk-review-plan-link | systematic-review-link">
		<!-- do something -->
	</xsl:template>

</xsl:stylesheet>

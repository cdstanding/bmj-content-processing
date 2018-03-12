<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:saxon="http://icl.com/saxon" exclude-result-prefixes="saxon">

	<xsl:import href="../libs/general-lib.xsl" />

	<xsl:output method="html" omit-xml-declaration="yes" />

	<!-- text for title bar -->
	<xsl:param name="monographTitle" />

	<xsl:template match="*:xquery-result">
		<html>
			<head>
				<title>
					<xsl:value-of select="$monographTitle" />
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">emergencies</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">emergencies.red-flags</xsl:with-param>
					</xsl:call-template>					
				 -
                    <xsl:value-of select="'Best Practice'" />
				</title>
			</head>
			<body>
				<div id="main-body">
					<div class="body-copy">
						<h1>
				            <xsl:call-template name="translate">
								<xsl:with-param name="messagekey">emergencies.red-flags</xsl:with-param>
							</xsl:call-template>						
						</h1>
						<ul>
							<xsl:apply-templates select=".//redflags" />
						</ul>
					</div><!-- /body copy -->
				</div><!-- /main body -->
				<div class="clear">
					<!-- x -->
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="redflags">
		<xsl:for-each select="./differential">
			<xsl:apply-templates select=".//ddx-name">
				<xsl:with-param name="differentialId" select="@id" />
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="ddx-name">
		<xsl:param name="differentialId" />
		<li>
			<a tabindex="45">
				<xsl:attribute name="href">
			    <xsl:call-template name="basic-path" />
				<xsl:value-of
						select="'/diagnosis/differential-diagnosis.html#expsec-'" />
				<xsl:value-of select="$differentialId" />
			  </xsl:attribute>
				<xsl:apply-templates />
			</a>
		</li>
	</xsl:template>
</xsl:stylesheet>


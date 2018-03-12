<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:oak="http://schema.bmj.com/delivery/oak"
	xmlns:ce="http://schema.bmj.com/delivery/oak-ce">

	<xsl:import href="../libs/general-lib.xsl" />
	<xsl:import href="../libs/oak-general-lib.xsl" />
	<!-- <xsl:import href="oak-html-tables.xsl" /> -->

	<!-- request context path -->
	<xsl:param name="ctxPath" />

	<!-- text for title bar -->
	<xsl:param name="monographTitle" />
	<xsl:param name="monographId" />

	<xsl:output method="html" omit-xml-declaration="yes" />

	<xsl:template match="*:xquery-result">
		<html>
			<head>
				<title>
					<xsl:value-of select="$monographTitle" />
					 - Clinical Evidence - 
			  		<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">resources.glossary</xsl:with-param>
					</xsl:call-template>   					 
					 - 
                    <xsl:value-of select="'Best Practice'" />
				</title>
			</head>
			<body>
				<div class="head">
					<h4>
				  		<xsl:call-template name="translate">
							<xsl:with-param name="messagekey">resources.glossary</xsl:with-param>
						</xsl:call-template>   					 					
					</h4>
					<div class="button" style="display:none">
						<a tabindex="45" href="#" class="close">Close</a>
					</div>
				</div>
				<div class="body">
					<p>
						<xsl:apply-templates />
					</p>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="oak:gloss">
      <p class="gloss"><xsl:apply-templates /></p>
	</xsl:template>

    <xsl:template match="oak:p[@class='term']">
      <strong><xsl:apply-templates/></strong>
      <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="oak:p[@class='definition']">
      <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>

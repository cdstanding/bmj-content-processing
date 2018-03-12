<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:oak="http://schema.bmj.com/delivery/oak">

	<xsl:import href="../libs/general-lib.xsl" />
	<xsl:import href="../libs/oak-general-lib.xsl" />

	<xsl:output method="html" omit-xml-declaration="yes" />

	<!-- text for title bar -->
	<xsl:param name="monographTitle" />

	<xsl:template match="*:xquery-result">
		<html>
			<head>
				<title>
					<xsl:value-of select="$monographTitle" />
					<xsl:text> - Clinical Evidence - </xsl:text>
			  		<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">resources.reference.bp</xsl:with-param>
					</xsl:call-template>                   					
					-
                    <xsl:value-of select="'Best Practice'" />
				</title>
			</head>
			<body>
				<div class="head">
					<h4>
				  		<xsl:call-template name="translate">
							<xsl:with-param name="messagekey">resources.reference.bp</xsl:with-param>
						</xsl:call-template>                   										
					</h4>
					<div class="button">
						<a tabindex="45" href="#" class="close">Close</a>
					</div>
				</div>
				<div class="body">
					<xsl:apply-templates />
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="oak:reference">
      <p>
		<strong>
			<xsl:call-template name="reference-id-template">
				<xsl:with-param name="unique-id" select="@id" />
			</xsl:call-template>
			<xsl:value-of select="'. '" />
		</strong>
		<xsl:apply-templates />
      </p>
      <div class="action">
        <p>
          <a tabindex="45">
            <xsl:attribute name="href">
              <xsl:call-template name="basic-evidence-path" />
              <xsl:value-of select="'/references/'" />
              <xsl:value-of select="substring-after(substring-before(@id, '-ref'), 'sr-')"/>
              <xsl:value-of select="'.html'"/>
            </xsl:attribute>
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.resources.references.view-all</xsl:with-param>
			</xsl:call-template>                   
          </a>
        </p>
      </div>
	</xsl:template>

	<xsl:template match="oak:p">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="oak:i">
		<em>
			<xsl:apply-templates />
		</em>
	</xsl:template>

</xsl:stylesheet>
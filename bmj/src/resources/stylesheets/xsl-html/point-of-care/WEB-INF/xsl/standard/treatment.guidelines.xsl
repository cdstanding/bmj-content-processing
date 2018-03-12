<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://icl.com/saxon" exclude-result-prefixes="saxon">

  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:include href="../libs/guideline-lib.xsl" />
  <!-- text for title bar -->
  <xsl:param name="monographTitle" />

  <xsl:output method="html" omit-xml-declaration="yes" />

  <xsl:template match="*:xquery-result">
    <html>
      <head>
        <title>
          <xsl:value-of select="$monographTitle" />
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">treatment</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">treatment.guidelines</xsl:with-param>
					</xsl:call-template>	
				  -
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
        <div id="main-body">
          <div class="body-copy">
            <div id="guidelines">
              <h1>
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.treatment.guidelines.treatment-guidelines</xsl:with-param>
				</xsl:call-template>	
              </h1>
              <xsl:choose>
                <xsl:when test="./treatment-guidlines/region">
                   <xsl:call-template name="showRegionalGuideline">
                   <xsl:with-param name="regions" select=".//region"/>
                   </xsl:call-template>
              	</xsl:when>
                <xsl:when test="./treatment-guidlines/non-region/guideline">
					<xsl:call-template name="showNonRegionalGuideline">
					 	<xsl:with-param name="regions" select="."/>
                  	</xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <p>
					<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.treatment.guidelines.evidence-centre</xsl:with-param>
					</xsl:call-template>	
                  </p>
                </xsl:otherwise>
              </xsl:choose>
            </div><!-- /guidelines -->
          </div><!-- /body-copy -->
        </div><!-- /main-body -->
        <div class="clear"></div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
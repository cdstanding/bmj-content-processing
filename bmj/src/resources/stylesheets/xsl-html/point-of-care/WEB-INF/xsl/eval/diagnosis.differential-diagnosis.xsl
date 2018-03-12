<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../libs/differential-diagnosis-lib.xsl" />
  
  <xsl:output method="html" omit-xml-declaration="yes" />
    
  <!-- text for title bar -->
  <xsl:param name="monographTitle" />
  <xsl:template match="*:xquery-result">
    <html>
      <head>
        <title>
          <xsl:value-of select="$monographTitle" />
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">diagnosis</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">diagnosis.differential-diagnosis</xsl:with-param>
					</xsl:call-template>					
				 -
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
        <div class="body-copy">
          <div class="differential-diagnosis">
            <h2>
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">diagnosis.differential-diagnosis</xsl:with-param>
				</xsl:call-template>            
            </h2>
            <div class="sort">
				<xsl:call-template name="translate-with-arguments">
					<xsl:with-param name="messagekey">body.diagnosis.differential-diagnosis.sort-by</xsl:with-param>
					<xsl:with-param name="arguments">
						<xsl:call-template name="basic-path" />
						<xsl:value-of select="'/diagnosis/differential-diagnosis/by-category.html'" />
					</xsl:with-param>
					<xsl:with-param name="argumentseparator"></xsl:with-param>
				</xsl:call-template>                   
            </div>
            <xsl:apply-templates select="differentials"/>
          </div>
        </div><!-- /body copy -->
        <div class="clear">
            <!-- x -->
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="common">
    <xsl:call-template name="differentialGroupTemplate" />
  </xsl:template>
  <xsl:template match="uncommon">
    <xsl:call-template name="differentialGroupTemplate" />
  </xsl:template>
  
</xsl:stylesheet>
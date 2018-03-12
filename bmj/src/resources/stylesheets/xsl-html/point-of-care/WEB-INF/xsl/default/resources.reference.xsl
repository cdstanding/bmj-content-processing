<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../libs/references-lib.xsl" />
  
  <xsl:output method="html" omit-xml-declaration="yes" />
  
  <!-- text for title bar -->
  <xsl:param name="monographTitle" />

  <xsl:template match="*:xquery-result">
    <html>
      <head>
        <title>
          <xsl:value-of select="$monographTitle" />
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">resources</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
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
            <a tabindex="45" href="#" class="close">
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">close</xsl:with-param>
				</xsl:call-template>               
            </a>
          </div>
        </div>
        <div class="body">
            <xsl:for-each select=".//reference">
              <xsl:call-template name="referenceTemplate">
                <xsl:with-param name="numbered" select="'true'" />
              </xsl:call-template>
            </xsl:for-each>
          <div class="action">
            <p>
              <a tabindex="45">
                <xsl:attribute name="href">
                  <xsl:call-template name="basic-path" />
                  <xsl:value-of select="'/resources/references.html'" />
                </xsl:attribute>
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.resources.references.view-all</xsl:with-param>
				</xsl:call-template>                   
              </a>
            </p>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../libs/references-lib.xsl" />

  <!-- text for title bar -->
  <xsl:param name="monographTitle" />
  <xsl:param name="siteName" />
  <xsl:output method="html" omit-xml-declaration="yes" />

  <xsl:template match="*:xquery-result">
    <html>
      <head>
        <title>
          <xsl:value-of select="$monographTitle" />
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">resources</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">resources.patient-leaflets</xsl:with-param>
					</xsl:call-template>	
				  -          
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
        <div id="main-body">
            <div class="body-copy">
                <div class="patient-leaflets">
                    <xsl:choose>
                        <xsl:when test="related-patient-summaries">
                            <xsl:apply-templates />
                        </xsl:when>
                        <xsl:otherwise>
                            <h1>
								<xsl:call-template name="translate-with-arguments">
			                        <xsl:with-param name="messagekey">body.resources.patient-leaflets.leaflets-from</xsl:with-param>
			                        <xsl:with-param name="arguments">
			                            <xsl:value-of select="$siteName"/>
			                        </xsl:with-param>
			                        <xsl:with-param name="argumentseparator"></xsl:with-param>
			                    </xsl:call-template>         
                            </h1>
						    <p>
						        <xsl:call-template name="translate">
						            <xsl:with-param name="messagekey">body.resources.patient-leaflets.no-leaflets</xsl:with-param>
						        </xsl:call-template>   						    
						    </p>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    
                    <div class="clear"><!-- x --></div>
                </div><!-- /patient-leaflets -->
            </div><!-- /body-copy -->
        </div><!-- /main-body -->
      </body>
    </html>
  </xsl:template>

  <xsl:template match="related-patient-summaries">
    <h1>
		<xsl:call-template name="translate-with-arguments">
            <xsl:with-param name="messagekey">body.resources.patient-leaflets.leaflets-from</xsl:with-param>
            <xsl:with-param name="arguments">
                <xsl:value-of select="$siteName"/>
            </xsl:with-param>
            <xsl:with-param name="argumentseparator"></xsl:with-param>
        </xsl:call-template>       
    </h1>
    <ul class="leaflet-list">
      <xsl:for-each select="patient-summary-link">
        <xsl:choose>
            <xsl:when test="position()=last()">
                <li class="end"><xsl:apply-templates select="."/></li>
            </xsl:when>
            <xsl:otherwise>
                <li><xsl:apply-templates select="."/></li>
            </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </ul>
  </xsl:template>
  
</xsl:stylesheet>

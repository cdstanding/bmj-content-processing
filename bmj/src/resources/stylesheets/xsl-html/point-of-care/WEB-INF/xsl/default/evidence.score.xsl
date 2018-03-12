<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../libs/evidence-score-lib.xsl" />
  
  <xsl:output method="html" omit-xml-declaration="yes" />

  <!-- text for title bar -->
  <xsl:param name="monographTitle" />
  <xsl:template match="*:xquery-result">
    <html>
      <head>
        <title>
          <xsl:value-of select="$monographTitle" />
          - <xsl:call-template name="translate">
				<xsl:with-param name="messagekey">treatment.evidence.score</xsl:with-param>
			</xsl:call-template>
        </title>
      </head>
      <body>
        <div class="ce">
          <div id="sub-nav">
            <ul>
              <li class="active">
                <span>
                	<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">treatment.evidence.score</xsl:with-param>
					</xsl:call-template>
				</span>
              </li>
            </ul>
          </div>
          <!-- /sub-nav -->
          <div class="clear">
          <!-- x -->
          </div>
          <div id="main-body">
            <div class="body-copy">
              <xsl:apply-templates />
            </div><!-- /body copy -->
          </div><!-- /main body -->
        </div>
        <div class="clear">
        <!-- x -->
        </div>
        <!-- /ce -->
        <div id="global-body" />
        <!-- /global body  -->
        <div class="clear" />
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="evidence-score">
    <div>
        <xsl:call-template name="evidence-score-level" />
  	</div>
  	<xsl:apply-templates />
  </xsl:template>
  
</xsl:stylesheet>
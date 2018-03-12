<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../libs/references-lib.xsl" />

  <!-- text for title bar -->
  <xsl:param name="monographTitle" />

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
						<xsl:with-param name="messagekey">resources.references</xsl:with-param>
					</xsl:call-template>	
				  -          
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
        <div id="references">
          <xsl:apply-templates select="references"/>
        </div><!-- /references -->      
        <div class="clear"><!-- x --></div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="references">
    <div class="body-copy">
      <h1>
		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.resources.references.citations</xsl:with-param>
		</xsl:call-template>        
      </h1> 
      <xsl:apply-templates select="./*[name() != 'systematic-reviews']" />
    </div> <!-- body-copy -->
    <xsl:apply-templates select="systematic-reviews"/>
  </xsl:template>

  <xsl:template match="key-articles">
    <xsl:if test="./reference">
        <a tabindex="45" id="key-articles" name="key-articles" />
        <h3>
			<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.resources.references.key-articles</xsl:with-param>
			</xsl:call-template>                
        </h3>
        <ul>
          <a tabindex="45" id="key-articles" name="key-articles" />
          <xsl:for-each select="reference">
          <xsl:choose>
          <xsl:when test="position()=last()">
            <xsl:call-template name="referenceTemplate">
                <xsl:with-param name="numbered" />
                <xsl:with-param name="endClass" select="'end'" />
              </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="referenceTemplate">
                <xsl:with-param name="numbered" />
                <xsl:with-param name="endClass" select="''" />
              </xsl:call-template>
          </xsl:otherwise>
          </xsl:choose>
          </xsl:for-each>
        </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template match="referenced-articles">
      <a tabindex="45" id="reference-articles" name="reference-articles" />
      <h3>
			<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.resources.references.reference-articles</xsl:with-param>
			</xsl:call-template>        
      </h3>
      <ul>
      <xsl:for-each select="reference">
        <xsl:choose>
            <xsl:when test="position()=last()">
                <xsl:call-template name="referenceTemplate">
                  <xsl:with-param name="numbered" select="'true'" />
                  <xsl:with-param name="endClass" select="'end'" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="referenceTemplate">
                  <xsl:with-param name="numbered" select="'true'" />
                  <xsl:with-param name="endClass" select="''" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      </ul>
  </xsl:template>

</xsl:stylesheet>
<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../libs/general-lib.xsl" />

  <!-- text for title bar -->
  <xsl:param name="monographTitle" />

  <!-- request context path -->
  <xsl:param name="ctxPath" />

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
						<xsl:with-param name="messagekey">resources.images</xsl:with-param>
					</xsl:call-template>	
				  -          
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
        <div class="head">
          <div class="button" style="display:none">
            <a tabindex="45" href="#" class="print">
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">page.print</xsl:with-param>
				</xsl:call-template>               
            </a>
            
            <a tabindex="45" href="#" class="close">
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">close</xsl:with-param>
				</xsl:call-template>                
            </a>
          </div>
        </div>
        <br/>
        <div class="body">
            <xsl:for-each select=".//figure">
              <xsl:variable name="image-target">
                <xsl:value-of select="./image-link/@target" />
              </xsl:variable>
              <xsl:if test="not(contains($image-target,'iline'))">
                <xsl:element name="div">
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="(position() mod 3)= 0">
                        <xsl:value-of select="'image-box end'" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="'image-box'" />
                      </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                    <xsl:apply-templates select="image-link">
                      <xsl:with-param name="caption" select="./caption" />
                    </xsl:apply-templates>
                  <p class="caption">
                    <xsl:apply-templates select="caption"/>
                  </p>
                  <p class="credit">
                    <xsl:apply-templates select="source"/>
                  </p>
                  <br/>
                </xsl:element>
              </xsl:if>
            </xsl:for-each>
          </div><!-- /body -->
        <div class="clear">
          <!-- x -->
        </div>
      </body>
    </html>
  </xsl:template>


</xsl:stylesheet>

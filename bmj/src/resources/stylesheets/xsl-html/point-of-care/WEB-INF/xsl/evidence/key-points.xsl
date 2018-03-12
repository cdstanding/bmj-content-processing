<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:oak="http://schema.bmj.com/delivery/oak"
  xmlns:ce="http://schema.bmj.com/delivery/oak-ce">

  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../libs/oak-general-lib.xsl" />

  <!-- request context path -->
  <xsl:param name="ctxPath" />

  <xsl:param name="systematicReviewId"/>
  <xsl:param name="evidenceStandalone"/>
  
  <xsl:output method="html" omit-xml-declaration="yes" />

  <xsl:template match="*:xquery-result">
    <html>
      <head>
        <title>
          <xsl:choose>
            <xsl:when test="$monographTitle">
              <xsl:value-of select="$monographTitle" />
              <xsl:text> - Clinical Evidence - </xsl:text>
              <xsl:value-of select="//oak:review-title-abridged"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="//oak:review-title-abridged"/>
              <xsl:text> - Clinical Evidence</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
			- 
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">evidence.key-points</xsl:with-param>
			</xsl:call-template>             
          <xsl:text> - Best Practice</xsl:text>
        </title>
      </head>
      <body>
        <div class="ce">
          <div id="sub-nav">
            <ul>
              <li class="active">
                <xsl:element name="span">
                  <xsl:choose>
                    <xsl:when test="$monographId">
				  		<xsl:call-template name="translate">
							<xsl:with-param name="messagekey">body.evidence.key-points.related-systematic-reviews-key-points</xsl:with-param>
						</xsl:call-template>  
                    </xsl:when>
                    <xsl:otherwise>
				  		<xsl:call-template name="translate">
							<xsl:with-param name="messagekey">body.evidence.key-points.systematic-reviews-key-points</xsl:with-param>
						</xsl:call-template>  
                    </xsl:otherwise>  
                  </xsl:choose>    
                </xsl:element>
              </li>
            </ul>
          </div>
          <!-- /sub-nav -->
          <div class="clear">
            <!-- x -->
          </div>
          <div id="main-body">
            <div class="body-copy">
              <div id="box" class="slate">
                <p>
                  <strong>
		  			<xsl:call-template name="translate-with-arguments">
						<xsl:with-param name="messagekey">body.evidence.key-points.view-interventions</xsl:with-param>
						<xsl:with-param name="arguments">
							<xsl:call-template name="basic-evidence-path"/>
							<xsl:if test="$evidenceStandalone">/<xsl:value-of select="$systematicReviewId"/></xsl:if>
							<xsl:text>.html</xsl:text>
						</xsl:with-param>
						<xsl:with-param name="argumentseparator"/>
					</xsl:call-template>  
                  </strong>
                </p>
              </div>
              <div class="key-point-list">
                <xsl:apply-templates select="//oak:section[@class='key-point-list']"/>
              </div><!-- /key-point-list -->
              <xsl:call-template name="evidence-publication-date"/>
            </div><!-- /body copy -->
          </div><!-- /main body -->
        </div> <!-- ce -->
        <div id="sub-body">
          <div class="body-copy">
          </div><!-- /body copy -->
        </div><!-- /sub body -->
        <div class="clear">
        <!-- x -->
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="oak:title"/>
</xsl:stylesheet>

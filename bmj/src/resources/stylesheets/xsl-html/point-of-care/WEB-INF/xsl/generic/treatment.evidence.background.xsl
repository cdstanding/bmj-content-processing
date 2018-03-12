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
				<xsl:with-param name="messagekey">body.treatment.evidence.background.background</xsl:with-param>
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
							<xsl:with-param name="messagekey">body.treatment.evidence.background.related-systematic-reviews-background</xsl:with-param>
						</xsl:call-template>     
                    </xsl:when>
                    <xsl:otherwise>
						<xsl:call-template name="translate">
							<xsl:with-param name="messagekey">body.treatment.evidence.background.systematic-review-background</xsl:with-param>
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
              <div class="background">
                <xsl:apply-templates select="oak:section[@class='background']"/>
              </div><!-- /background -->
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

  <xsl:template match="oak:section[@class='background']">
    <xsl:element name="h5">
      <xsl:attribute name="class">smlText</xsl:attribute>
		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.treatment.evidence.background.in-this-section</xsl:with-param>
		</xsl:call-template>  
    </xsl:element>
    <xsl:element name="p">
      <xsl:for-each select="./oak:section">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:value-of select="concat('#', @class)"/>
          </xsl:attribute>
          <xsl:value-of select="./oak:title"/>
        </xsl:element>
        <xsl:if test="not(position() = last())">
          <xsl:text> | </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:element>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="oak:title">
    <xsl:if test="not(./parent::oak:section[@class='background'])">
      <xsl:element name="a">
        <xsl:attribute name="name">
          <xsl:value-of select="./parent::oak:section/@class"/>
        </xsl:attribute>
      </xsl:element>
      <xsl:element name="h3">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

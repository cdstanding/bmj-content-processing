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
						<xsl:with-param name="messagekey">resources.nice-guideline</xsl:with-param>
					</xsl:call-template>	
				  -          
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
        <div class="head">
          <h4><span>
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">resources.nice-guideline</xsl:with-param>
				</xsl:call-template>          
          </span></h4>
          <div class="button">
            <a tabindex="45" href="#" class="close">
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">close</xsl:with-param>
				</xsl:call-template>                 
            </a>
          </div>
        </div>
        <div class="body">
          <p>
            <strong>
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="//guideline-url"/>
                </xsl:attribute>
                <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
                <xsl:apply-templates select="(//nice-title | //title)[1]"/>
              </xsl:element>
            </strong>
            <br/>
            <strong>
              <xsl:apply-templates select="//recommendation-title"/>
            </strong>
            <br/>
            <xsl:apply-templates select="//comments"/>
          </p>
          
          <xsl:if test="string-length(./nice-guideline/@grade) > 0">
            <div class="evidence-level">
              <p>
                <strong>
					<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.resources.nice-guideline.evidence-grade</xsl:with-param>
					</xsl:call-template>    
					<xsl:value-of select="./nice-guideline/@grade"/></strong>
                <br/>
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="//grade-url"/>
                  </xsl:attribute>
                  <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
					<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.resources.nice-guideline.evidence-grading-scheme</xsl:with-param>
					</xsl:call-template>                     
                </xsl:element>
              </p>
            </div>
          </xsl:if>
                    
          <div class="action">
            <p>
              <xsl:element name="a">
                <xsl:attribute name="tabindex">45</xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="//recommendation-url"/>
                </xsl:attribute>
                <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
                	<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.resources.nice-guideline.recommendations</xsl:with-param>
					</xsl:call-template>      
              </xsl:element>
            </p>
          </div>
          
          <div class="action">
            <p>
              <xsl:element name="a">
                <xsl:attribute name="tabindex">45</xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="//detailed-guidance-url"/>
                </xsl:attribute>
                <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
                	<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.resources.nice-guideline.detailed-guidance</xsl:with-param>
					</xsl:call-template>                      
              </xsl:element>
            </p>
          </div>
          
          
        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>

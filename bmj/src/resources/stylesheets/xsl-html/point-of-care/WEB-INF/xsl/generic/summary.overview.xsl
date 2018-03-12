<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:saxon="http://icl.com/saxon" exclude-result-prefixes="saxon">

	<xsl:import href="../libs/general-lib.xsl" />

    <!-- text for title bar -->
    <xsl:param name="monographTitle" />
    	
	<xsl:output method="html" omit-xml-declaration="yes"/>
	
	<xsl:template match="*:xquery-result">
	    <html>
            <head>
              <title>
                <xsl:value-of select="$monographTitle" />
                 - 
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">summary.overview</xsl:with-param>
				</xsl:call-template>                 
                 - 
                <xsl:value-of select="'Best Practice'" />
              </title>
            </head>
	        <body>
              <div id="generic">
                <xsl:apply-templates/>
              </div> <!-- /generic -->
				<div class="clear">
				    <!-- x -->
				</div>
	        </body>
	    </html>
	</xsl:template>
	
    <xsl:template match="sections">
        <div id="sub-body">
          <div class="body-copy">
            <h2>
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.summary.overview.contents</xsl:with-param>
				</xsl:call-template>             
			</h2>
            <ul class="tabNavigation">
              <xsl:for-each select="section">
                <li>
                  <xsl:element name="a">
                    <xsl:attribute name="tabindex">
                        <xsl:value-of select="'45'"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                      <xsl:text>#panel-</xsl:text>
                      <xsl:value-of select="position()"/>
                    </xsl:attribute>
                    <xsl:choose>
                      <xsl:when test="section-header">
                        <xsl:value-of select="section-header"/>
                      </xsl:when>
                      <xsl:otherwise>-</xsl:otherwise>
                    </xsl:choose>
                  </xsl:element>
                </li>
              </xsl:for-each>
            </ul>
          </div> <!-- /body-copy -->
        </div> <!-- /sub-body -->
        <div id="main-body">
          <div class="body-copy">
            <div class="tabs">
              <xsl:for-each select="section">
                <div>
                  <xsl:attribute name="id">
                    <xsl:text>panel-</xsl:text>
                    <xsl:value-of select="position()"/>
                  </xsl:attribute>
                  <xsl:if test="section-header">
                    <xsl:apply-templates select="section-header"/>
                  </xsl:if>
                  <xsl:apply-templates select="section-text"/>
                </div>
              </xsl:for-each>
            </div>
          </div><!-- /body copy -->
        </div><!-- /main body -->
    </xsl:template>

</xsl:stylesheet>
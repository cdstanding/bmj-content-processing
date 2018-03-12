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
					<xsl:with-param name="messagekey">overview.conditions</xsl:with-param>
				</xsl:call-template> 
				-
                <xsl:value-of select="'Best Practice'" />
              </title>
            </head>
            <body>
                <div id="overview-content">
                    <div id="main-body">
                        <div class="body-copy">
                            <div class="allopenable expandable-section">
                                <h1>
						   			<xsl:call-template name="translate">
										<xsl:with-param name="messagekey">overview.conditions</xsl:with-param>
									</xsl:call-template>                                
                                 <span tabindex="45" class="showall"/></h1>
                                <xsl:apply-templates select="disease-subtypes"/>
                            </div>
                        </div><!-- /body copy -->
                    </div><!-- /main body -->
                    <div class="clear">
                        <!-- x -->
                    </div>
                </div><!-- /overview -->
            </body>
        </html>
    </xsl:template>
    
   <xsl:template match="disease-subtypes">
    <xsl:for-each select="subtype">
        <xsl:choose>
            <xsl:when test="position()=last()">
              <xsl:call-template name="subtypeTemplate">
                  <xsl:with-param name="endClass" select="'end'" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="subtypeTemplate">
                    <xsl:with-param name="endClass" select="''" />
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="subtypeTemplate">
      <xsl:param name="endClass" />
        <dl>
          <xsl:attribute name="class">
              <xsl:value-of select="'expandable '"/>
              <xsl:value-of select="$endClass"/>
          </xsl:attribute>
          <dt tabindex="45"><xsl:apply-templates select="name"/></dt>
          <dd>
            <xsl:apply-templates select="monograph-link"/>
            <xsl:apply-templates select="detail/para"/>
          </dd>
        </dl>
    </xsl:template>
    
</xsl:stylesheet>
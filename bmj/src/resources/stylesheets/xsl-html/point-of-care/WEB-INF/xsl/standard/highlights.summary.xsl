<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:saxon="http://icl.com/saxon" exclude-result-prefixes="saxon">

	<xsl:import href="../libs/general-lib.xsl" />

    <!-- text for title bar -->
    <xsl:param name="monographTitle" />
    
    <!-- context path for linking -->
    <xsl:param name="ctxPath"/>
    
	<xsl:output method="html" omit-xml-declaration="yes"/>
	
	<xsl:template match="*:xquery-result">
	    <html>
            <head>
              <title>
                <xsl:value-of select="$monographTitle" />
                - 
                <xsl:call-template name="translate">
			        <xsl:with-param name="messagekey">highlights.summary</xsl:with-param>
			    </xsl:call-template>
                - 
                <xsl:value-of select="'Best Practice'" />
              </title>
            </head>
	        <body>
			    <div id="main-body">
					<div class="body-copy">
					    <xsl:apply-templates select="highlights"/>
					</div><!-- /body copy -->
				</div><!-- /main body -->
        
                <div id="sub-body">
                  <div class="body-copy">
                    <xsl:apply-templates select="related-topics"/>
                  </div>
                </div>
        
				<div class="clear">
				    <!-- x -->
				</div>
	        </body>
	    </html>
	</xsl:template>
	
	<!-- ***************************** 
           HIGHLIGHTS 
         *****************************  -->

    <xsl:template match="highlights">
        <h1>
	        <xsl:call-template name="translate">
		    	<xsl:with-param name="messagekey">highlights.summary</xsl:with-param>
			</xsl:call-template>        
        </h1>
        <ul><xsl:apply-templates/></ul>
    </xsl:template>

    <xsl:template match="highlight">
        <li><xsl:apply-templates/></li>
    </xsl:template>
    
    <!-- RELATED TOPICS -->
    
    <xsl:template match="related-topics">
      <div class="differential-diagnosis">
        <h3>
	        <xsl:call-template name="translate">
		    	<xsl:with-param name="messagekey">body.highlights.summary.other-related-conditions</xsl:with-param>
			</xsl:call-template>
        </h3>
        <ul>
          <xsl:for-each select="monograph-link">
            <li>
              <xsl:element name="a">
                <xsl:attribute name="tabindex">
                    <xsl:value-of select="'45'"/>
                </xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="$ctxPath"/>
                  <xsl:text>/monograph/</xsl:text>
                  <xsl:choose>
                    <xsl:when test="contains(@target, '.xml')">
                      <xsl:value-of select="substring-before(@target, '.xml')"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="@target"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text>.html</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="."/>
              </xsl:element>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </xsl:template>
      
</xsl:stylesheet>

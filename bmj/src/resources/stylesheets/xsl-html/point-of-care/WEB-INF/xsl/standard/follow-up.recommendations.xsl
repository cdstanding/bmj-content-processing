<?xml version="1.0" encoding="utf-8" ?>
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
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">follow-up</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">follow-up.recommendations</xsl:with-param>
					</xsl:call-template>	
				  -
                <xsl:value-of select="'Best Practice'" />
              </title>
            </head>
	        <body>
			    <div id="main-body">
					<div class="body-copy">
					   <xsl:apply-templates select="recommendations/monitoring"/>
                       <xsl:apply-templates select="recommendations/patient-instructions"/>
					</div><!-- /body copy -->
				</div><!-- /main body -->
				<div class="clear">
				    <!-- x -->
				</div>
	        </body>
	    </html>
	</xsl:template>
	
    <xsl:template match="monitoring">
        <h2>
          	<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.follow-up.recommendations.monitoring</xsl:with-param>
			</xsl:call-template>        
        </h2>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="patient-instructions">
        <h2>
          	<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.follow-up.recommendations.patient-instructions</xsl:with-param>
			</xsl:call-template>                
        </h2>
        <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>
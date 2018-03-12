<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:saxon="http://icl.com/saxon" exclude-result-prefixes="saxon">

	<xsl:import href="../libs/general-lib.xsl" />
	
	<xsl:output method="html" omit-xml-declaration="yes"/>
	
	<!-- text for title bar -->
	<xsl:param name="monographTitle"/>
  
	<xsl:template match="*:xquery-result">
	    <html>
	        <head>
	            <title>
                    <xsl:value-of select="$monographTitle"/>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">prevention</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">prevention.primary</xsl:with-param>
					</xsl:call-template>	
				  -
                    <xsl:value-of select="'Best Practice'" />
                </title>
	        </head>
	        <body>
			    <div id="main-body">
					<div class="body-copy">
					    <h1>
					        <xsl:call-template name="translate">
						    	<xsl:with-param name="messagekey">body.prevention.primary.primary-prevention</xsl:with-param>
							</xsl:call-template>
					    </h1>
					    <xsl:apply-templates/>
					</div><!-- /body copy -->
				</div><!-- /main body -->
				<div class="clear">
				    <!-- x -->
				</div>
	        </body>
	    </html>
	</xsl:template>
	
</xsl:stylesheet>
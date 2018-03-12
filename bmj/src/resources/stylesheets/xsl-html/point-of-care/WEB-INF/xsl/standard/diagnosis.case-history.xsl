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
						<xsl:with-param name="messagekey">diagnosis</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">diagnosis.case-history</xsl:with-param>
					</xsl:call-template>					
				 -
                <xsl:value-of select="'Best Practice'" />
              </title>
            </head>
	        <body>
			    <div id="main-body">
					<div class="body-copy">
					   <xsl:apply-templates/>
					</div><!-- /body copy -->
				</div><!-- /main body -->
				<div class="clear">
				    <!-- x -->
				</div>
	        </body>
	    </html>
	</xsl:template>
	
	<xsl:template match="vignettes/vignette">
        <h1>
			<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">diagnosis.case-history</xsl:with-param>
			</xsl:call-template>        
            <xsl:if test="last() > 1">
                <xsl:value-of select="' #'" />
                <xsl:value-of select="position()" />
            </xsl:if>
        </h1>
        <xsl:if test="./*">
            <xsl:apply-templates/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="other-presentations">
        <h1>
			<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.diagnosis.case-history.other-presentations</xsl:with-param>
			</xsl:call-template>        
        </h1>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
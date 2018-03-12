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
						<xsl:with-param name="messagekey">diagnosis.step-by-step</xsl:with-param>
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
							<xsl:with-param name="messagekey">body.diagnosis.step-by-step.diagnostic-approach</xsl:with-param>
						</xsl:call-template>
					   </h1>
					   <xsl:apply-templates select="approach" />
                       <xsl:if test="guidelines">
                         <xsl:element name="a">
                            <xsl:attribute name="tabindex">
                                <xsl:value-of select="'45'" />
                            </xsl:attribute>
    				        <xsl:attribute name="href">
                              <xsl:call-template name="basic-path" />
                              <xsl:text>/diagnosis/guidelines.html</xsl:text>
                            </xsl:attribute>
							<xsl:call-template name="translate">
								<xsl:with-param name="messagekey">body.diagnosis.step-by-step.click-to-view-diagnostic-guideline-references</xsl:with-param>
							</xsl:call-template>                            
                         </xsl:element>
                       </xsl:if>
					</div><!-- /body copy -->
				</div><!-- /main body -->
				<div class="clear">
				    <!-- x -->
				</div>
	        </body>
	    </html>
	</xsl:template>

</xsl:stylesheet>
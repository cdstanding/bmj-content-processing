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
						<xsl:with-param name="messagekey">treatment</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">treatment.emerging</xsl:with-param>
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
	
    <xsl:template match="emerging-txs">
        <h1>
			<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.treatment.emerging.emerging-treatments</xsl:with-param>
			</xsl:call-template>        
        </h1>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="emerging-tx/name">
        <h4><xsl:apply-templates/></h4>
    </xsl:template> 
    
    <xsl:template match="emerging-tx/detail">
        <p><xsl:apply-templates/></p>
    </xsl:template> 

</xsl:stylesheet>
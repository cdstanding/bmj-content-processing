<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../libs/general-lib.xsl" />
	
	<!-- request context path -->
  <xsl:param name="ctxPath" />
  
    <!-- text for title bar -->
  <xsl:param name="monographTitle" />
  <xsl:param name="monographId" />
  
  <xsl:output method="html" omit-xml-declaration="yes" />
  
  <xsl:template match="*:xquery-result">
    <html>
      <head>
        <title>
          <xsl:value-of select="$monographTitle" />
          - <xsl:call-template name="translate">
				<xsl:with-param name="messagekey">highlights</xsl:with-param>
			</xsl:call-template>
		  - <xsl:call-template name="translate">
		        <xsl:with-param name="messagekey">highlights.overview</xsl:with-param>
		    </xsl:call-template>
		  -
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
        <div id="main-body">
          <div class="left">
            <div class="body-copy">
              <h2>
                <a tabindex="45">
                  <xsl:attribute name="href">
                      <xsl:value-of select="$ctxPath" />
                      <xsl:value-of select="'/monograph/'" />
                      <xsl:value-of select="$monographId" />
                      <xsl:value-of select="'/diagnosis/history-and-examination.html'" />
                  </xsl:attribute>
                  <xsl:call-template name="translate">
                  	<xsl:with-param name="messagekey">body.highlights.overview.history-and-exam</xsl:with-param>
                  </xsl:call-template>
                </a>
              </h2>
              <xsl:if test='//factor[@key-factor="true"]'>
                <h3>
                	<xsl:call-template name="translate">
			            <xsl:with-param name="messagekey">body.highlights.overview.key-factors</xsl:with-param>
			        </xsl:call-template>
                </h3>
                <ul>
                  <xsl:for-each select='//factor[@key-factor="true"]'>
                    <li><xsl:value-of select="factor-name" /></li>
                  </xsl:for-each>
                </ul>
              </xsl:if>
              <xsl:if test='//factor[@key-factor="false"]'>
                <!-- If key factors exist then show title as 'Other'-->
                <xsl:choose>
                  <xsl:when test='//factor[@key-factor="true"]'>
                      <h3>
                      	<xsl:call-template name="translate">
			            	<xsl:with-param name="messagekey">body.highlights.overview.other-diagnostic-factors</xsl:with-param>
			            </xsl:call-template>
			          </h3>
                  </xsl:when>
                  <xsl:otherwise>
                      <h3>
                      	<xsl:call-template name="translate">
			            	<xsl:with-param name="messagekey">body.highlights.overview.diagnostic-factors</xsl:with-param>
			            </xsl:call-template>
			          </h3>                  
                  </xsl:otherwise>
                </xsl:choose>
                
                <ul>
                  <xsl:for-each select='//factor[@key-factor="false"]'>
                    <li><xsl:value-of select="factor-name" /></li>
                  </xsl:for-each>
                </ul>
              </xsl:if>
              <h4>
                <a tabindex="45">
                  <xsl:attribute name="href">
                      <xsl:value-of select="$ctxPath" />
                      <xsl:value-of select="'/monograph/'" />
                      <xsl:value-of select="$monographId" />
                      <xsl:value-of select="'/diagnosis/history-and-examination.html'" />
                  </xsl:attribute>
         		  <xsl:call-template name="translate">
         		  	<xsl:with-param name="messagekey">body.highlights.overview.history-and-exam-details</xsl:with-param>
	              </xsl:call-template>                  
                </a>
              </h4>
            </div><!-- /body copy -->
           </div><!-- /left -->
           <div class="right">
              <div class="body-copy">
                <h2>
                  <a tabindex="46">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$ctxPath" />
                        <xsl:value-of select="'/monograph/'" />
                        <xsl:value-of select="$monographId" />
                        <xsl:value-of select="'/diagnosis/tests.html'" />
                    </xsl:attribute>
	                <xsl:call-template name="translate">
    	             	<xsl:with-param name="messagekey">body.highlights.overview.diagnostic-tests</xsl:with-param>
        	        </xsl:call-template>                    
                  </a>
                </h2>
                <xsl:if test='//test[@order="initial"]'>
                  <h3>
                  	<xsl:call-template name="translate">
         		  		<xsl:with-param name="messagekey">body.highlights.overview.1st-tests-to-order</xsl:with-param>
         		  	</xsl:call-template>
         		  </h3>
                  <ul>
                    <xsl:for-each select='//test[@order="initial"]'>
                      <li><xsl:value-of select="name" /></li>
                    </xsl:for-each>
                  </ul>
                </xsl:if>
                <xsl:if test='//test[@order="subsequent"]'>
                  <h3>
                  	<xsl:call-template name="translate">
         		  		<xsl:with-param name="messagekey">body.highlights.overview.tests-to-consider</xsl:with-param>
         		  	</xsl:call-template>
         		  </h3>
                  <ul>
                    <xsl:for-each select='//test[@order="subsequent"]'>
                      <li><xsl:value-of select="name" /></li>
                    </xsl:for-each>
                  </ul>
                </xsl:if>
                <xsl:if test='//test[@order="emerging"]'>
                  <h3>
                  	<xsl:call-template name="translate">
         		  		<xsl:with-param name="messagekey">body.highlights.overview.emerging-tests</xsl:with-param>
         		  	</xsl:call-template>
         		  </h3>
                  <ul>
                    <xsl:for-each select='//test[@order="emerging"]'>
                      <li><xsl:value-of select="name" /></li>
                    </xsl:for-each>
                  </ul>
                </xsl:if>
                <h4>
                  <a tabindex="46">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$ctxPath" />
                        <xsl:value-of select="'/monograph/'" />
                        <xsl:value-of select="$monographId" />
                        <xsl:value-of select="'/diagnosis/tests.html'" />
                    </xsl:attribute>
         		  	<xsl:call-template name="translate">
         		  		<xsl:with-param name="messagekey">body.highlights.overview.diagnostic-tests-details</xsl:with-param>
	              	</xsl:call-template>                           
                  </a>
                </h4>
              </div>
           </div><!-- /right -->
	    </div><!-- /main body -->
        <div id="sub-body">
          <div class="body-copy">
            <h2>
              <a tabindex="47">
                <xsl:attribute name="href">
                    <xsl:value-of select="$ctxPath" />
                    <xsl:value-of select="'/monograph/'" />
                    <xsl:value-of select="$monographId" />
                    <xsl:value-of select="'/treatment/details.html'" />
                </xsl:attribute>
       		  	<xsl:call-template name="translate">
       		  		<xsl:with-param name="messagekey">body.highlights.overview.treatment-details</xsl:with-param>
             	</xsl:call-template>                     
              </a>
            </h2>
            <xsl:apply-templates select="timeframes"/>
            <h4>
              <a tabindex="47">
                <xsl:attribute name="href">
                    <xsl:value-of select="$ctxPath" />
                    <xsl:value-of select="'/monograph/'" />
                    <xsl:value-of select="$monographId" />
                    <xsl:value-of select="'/treatment/details.html'" />
                </xsl:attribute>
       		  	<xsl:call-template name="translate">
       		  		<xsl:with-param name="messagekey">body.highlights.overview.treatment-details</xsl:with-param>
             	</xsl:call-template>           
              </a>
            </h4>
          </div>
        </div>
        <div class="clear">
        <!-- x -->
        </div>
	  </body>
	</html>
  </xsl:template>
  
  <xsl:template match='timeframe[@type="presumptive"]'>
	<h3>
	  	<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.highlights.overview.presumptive</xsl:with-param>
		</xsl:call-template>
	</h3>
    <xsl:call-template name="pt-groups-main-template">
      <xsl:with-param name="timeframe" select="." />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match='timeframe[@type="acute"]'>
	<h3>
	  	<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.highlights.overview.acute</xsl:with-param>
		</xsl:call-template>
	</h3>
    <xsl:call-template name="pt-groups-main-template">
      <xsl:with-param name="timeframe" select="." />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match='timeframe[@type="ongoing"]'>
	<h3>
	  	<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.highlights.overview.ongoing</xsl:with-param>
		</xsl:call-template>
	</h3>
    <xsl:call-template name="pt-groups-main-template">
      <xsl:with-param name="timeframe" select="." />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="pt-groups-main-template">
    <xsl:param name="timeframe" />
    <xsl:for-each select="$timeframe/pt-groups/pt-group">
      <h4><xsl:value-of select="name" /></h4>
      <ul>
        <xsl:apply-templates select="tx-options/tx-option" />
        <xsl:apply-templates select="pt-groups/pt-group" />
      </ul>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="pt-group">
    <li>
      <strong><xsl:value-of select="name" /></strong>        
      <ul>
        <xsl:apply-templates select="tx-options/tx-option" />
        <xsl:apply-templates select="pt-groups/pt-group" />
      </ul>
    </li>
  </xsl:template>
   
  <xsl:template match="tx-options/tx-option">
    <li><xsl:value-of select="tx-type" /></li>
  </xsl:template>
  
</xsl:stylesheet>

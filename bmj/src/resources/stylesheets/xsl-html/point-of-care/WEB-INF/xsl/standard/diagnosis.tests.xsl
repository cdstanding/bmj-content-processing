<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../libs/general-lib.xsl" />
	
  <!-- request context path -->
  <xsl:param name="ctxPath" />
	
  <!-- text for title bar -->
  <xsl:param name="monographTitle" />
  
  <xsl:output method="html" omit-xml-declaration="yes" />
  
  <xsl:template match="*:xquery-result">
    <html>
      <head>
        <title>
          <xsl:value-of select="$monographTitle" />
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">diagnosis</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">diagnosis.tests</xsl:with-param>
					</xsl:call-template>					
				 -             
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
        <div class="body-copy">
          <h1>
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.diagnosis.tests.diagnostic-tests</xsl:with-param>
			</xsl:call-template>
          </h1>
          <!--<xsl:apply-templates match="ordered-tests" />-->
          <xsl:apply-templates select="ordered-tests" />
        </div>
		<!-- /body copy -->
        <div class="clear">
		  <!-- x -->
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="initial-tests">
  	<xsl:variable name="title">
  		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.diagnosis.tests.1st-tests-to-order</xsl:with-param>
		</xsl:call-template>
  	</xsl:variable>
    <xsl:call-template name="testSectionTemplate">
      <xsl:with-param name="sectionTitle" select="$title" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="other-tests">
  	<xsl:variable name="title">
  		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.diagnosis.tests.tests-to-consider</xsl:with-param>
		</xsl:call-template>
  	</xsl:variable>
    <xsl:call-template name="testSectionTemplate">
      <xsl:with-param name="sectionTitle" select="$title" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="emerging-tests">
  	<xsl:variable name="title">
  		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.diagnosis.tests.emerging-tests</xsl:with-param>
		</xsl:call-template>
  	</xsl:variable>  
    <xsl:call-template name="testSectionTemplate">
      <xsl:with-param name="sectionTitle" select="$title" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="testSectionTemplate">
    <xsl:param name="sectionTitle" />
      <xsl:if test="./test">
      <div class="allopenable expandable-section">
        <h3>
          <xsl:value-of select="$sectionTitle" /> 
          <span tabindex="45" class='showall'></span>
        </h3>
        <table class="default diagnostic-tests" cellspacing="0" cellpadding="5" border="0">
          <caption>
            <xsl:value-of select="$sectionTitle" /> 
       		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.diagnosis.tests.table-for</xsl:with-param>
			</xsl:call-template>
            <xsl:value-of select="$monographTitle" />
          </caption>
          <tbody>
            <tr>
              <th class="test">
	       		<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.diagnosis.tests.test</xsl:with-param>
				</xsl:call-template>              
              </th>
              <th class="result">
	       		<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.diagnosis.tests.result</xsl:with-param>
				</xsl:call-template>              
              </th>
            </tr>
            <xsl:for-each select='./test'>
              <xsl:choose>
                <xsl:when test="position()=last()">
                  <xsl:call-template name="testTemplate">
                    <xsl:with-param name="endClass" select="'end'" />
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="testTemplate">
                    <xsl:with-param name="endClass" select="''" />
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </tbody>
        </table>
      </div>
    </xsl:if> 
  </xsl:template>
  
  <xsl:template name="testTemplate">
    <xsl:param name="endClass" />
    <tr>
      <td>
        <xsl:attribute name="class">
            <xsl:value-of select="'test '" />
            <xsl:value-of select="$endClass" />
        </xsl:attribute>
        <dl class="expandable">
          <dt tabindex="45">
              <xsl:apply-templates select="./name" />
          </dt>
          <dd>
            <xsl:for-each select="./detail/para">
            <xsl:apply-templates select="." />
            </xsl:for-each>
            
          </dd>
        </dl>
      </td>
      <td>
        <xsl:attribute name="class">
            <xsl:value-of select="'result '" />
            <xsl:value-of select="$endClass" />
        </xsl:attribute>
        <xsl:apply-templates select="./result" />
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
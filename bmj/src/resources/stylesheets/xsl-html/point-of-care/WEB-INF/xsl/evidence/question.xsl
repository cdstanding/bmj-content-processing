<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:oak="http://schema.bmj.com/delivery/oak">
  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../libs/oak-general-lib.xsl" />
  
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
          <xsl:choose>
            <xsl:when test="$monographTitle">
              <xsl:value-of select="$monographTitle" />
              <xsl:text> - Clinical Evidence - </xsl:text>
              <xsl:value-of select="//oak:review-title-abridged"/>
              <xsl:text> - </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="//oak:review-title-abridged"/>
              <xsl:text> - Clinical Evidence - </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="//oak:ce-question-title-abridged"/>
          <xsl:text> - </xsl:text>
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
        <div class="ce">
          <div id="sub-nav">
            <ul>
              <li class="one-before">
                <xsl:call-template name="sr-questions-breadcrumb"/>
              </li>
              <li class="active">
                <span>
		  		<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.evidence.question.intervention-table</xsl:with-param>
				</xsl:call-template>                  
                </span>
              </li>
            </ul>
          </div>
          <!-- /sub-nav -->
          <div class="clear">
          <!-- x -->
          </div>
          <div id="main-body">
            <div class="body-copy">
              <xsl:apply-templates select="//oak:ce-question" />
              <xsl:call-template name="evidence-publication-date"/>
            </div><!-- /body copy -->
          </div><!-- /main body -->
        </div>
        
        <div class="clear">
        <!-- x -->
        </div>
        <!-- /ce -->
        <div id="global-body"></div>
        <!-- /global body  -->
        <div class="clear">
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="oak:ce-questions/oak:title">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="oak:intervention/oak:title">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="oak:ce-question">
    <div class="intervention-table">
      <h4><xsl:value-of select="./@title" /></h4>
      <table cellspacing="0" cellpadding="0">
        <xsl:attribute name="summary">
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.question.intervention-table-for</xsl:with-param>
			</xsl:call-template>  
			<xsl:text> </xsl:text>
            <xsl:value-of select="$monographTitle" />            
        </xsl:attribute>  
        <tbody>
          <xsl:apply-templates select="oak:intervention-group"/>
        </tbody>
      </table>
    </div>
    <xsl:apply-templates select="oak:footnote"/>
  </xsl:template>
  
  <xsl:template match="oak:ce-question-title-abridged"/>
  
  <xsl:template match="oak:intervention-group[@efficacy='beneficial']">
      <xsl:call-template name="intervention-group-template">
        <xsl:with-param name="efficacy">
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.question.beneficial</xsl:with-param>
			</xsl:call-template>          
        </xsl:with-param>
        <xsl:with-param name="imageicon" select="'icon-beneficial.gif'"/>
      </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="oak:intervention-group[@efficacy='likely-to-be-beneficial']">
      <xsl:call-template name="intervention-group-template">
        <xsl:with-param name="efficacy">
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.question.likely-to-be-beneficial</xsl:with-param>
			</xsl:call-template>        
        </xsl:with-param>
        <xsl:with-param name="imageicon" select="'icon-likelybeneficial.gif'"/>
      </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="oak:intervention-group[@efficacy='trade-off-between-benefits-and-harms']">
      <xsl:call-template name="intervention-group-template">
        <xsl:with-param name="efficacy">
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.question.trade-off-between-benefits-and-harms</xsl:with-param>
			</xsl:call-template>                
        </xsl:with-param>
        <xsl:with-param name="imageicon" select="'icon-tradeoff.gif'"/>
      </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="oak:intervention-group[@efficacy='unknown-effectiveness']">
      <xsl:call-template name="intervention-group-template">
        <xsl:with-param name="efficacy">
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.question.unknown-effectiveness</xsl:with-param>
			</xsl:call-template>        
        </xsl:with-param>
        <xsl:with-param name="imageicon" select="'icon-unknowneffectiveness.gif'"/>
      </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="oak:intervention-group[@efficacy='unlikely-to-be-beneficial']">
      <xsl:call-template name="intervention-group-template">
        <xsl:with-param name="efficacy">
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.question.unlikely-to-be-beneficial</xsl:with-param>
			</xsl:call-template>                
        </xsl:with-param>
        <xsl:with-param name="imageicon" select="'icon-unlikelybeneficial.gif'"/>
      </xsl:call-template>
  </xsl:template>
  
  <xsl:template match="oak:intervention-group[@efficacy='likely-to-be-ineffective-or-harmful']">
      <xsl:call-template name="intervention-group-template">
        <xsl:with-param name="efficacy">
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.question.likely-to-be-ineffective-or-harmful</xsl:with-param>
			</xsl:call-template>                        
        </xsl:with-param>
        <xsl:with-param name="imageicon" select="'icon-ineffharmful.gif'"/>
      </xsl:call-template>
  </xsl:template>
  
  
  <xsl:template name="intervention-group-template">
    <xsl:param name="efficacy" />
    <xsl:param name="imageicon"/>
    <xsl:if test="oak:intervention">
      <tr>
        <th><xsl:value-of select="$efficacy" /></th>
        <td class="efficacyIconCol">
          <a tabindex="45" target="_blank" href="http://clinicalevidence.bmj.com/ceweb/about/guide.jsp#icons">
              <!-- the above URL just goes to the front page since 2012 -->
            <img height="16" width="24">
              <xsl:attribute name="src">
                <xsl:value-of select="$ctxPath"/>/images/<xsl:value-of select="$imageicon"/>
              </xsl:attribute>
              <xsl:attribute name="alt"><xsl:value-of select="$efficacy"/></xsl:attribute>
            </img>
          </a>
        </td>
        <td>
          <ul>
            <xsl:for-each select="oak:intervention">
              <li>
                <a tabindex="45">
                  <xsl:attribute name="href">
                    <xsl:call-template name="basic-evidence-path"/>
                    <xsl:value-of select="'/intervention/'" />
                    <xsl:value-of select="@sr-id" />
                    <xsl:value-of select="'/0/'" />
                    <xsl:value-of select="@id" />
                    <xsl:value-of select="'.html'" />
                  </xsl:attribute>
                  <xsl:apply-templates select="./oak:title" />
                </a>
                <xsl:if test="contains(./oak:intervention-summary-title, '*')">
                  <a href="#star">*</a>
                </xsl:if>
                <xsl:if test="contains(./oak:intervention-summary-title, '†')">
                  <a href="#dagger">†</a>
                </xsl:if>
              </li>
            </xsl:for-each>
          </ul>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="oak:footnote">
    <div class="footnote">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="oak:footnote/oak:title">
    <h4><xsl:apply-templates/></h4>
  </xsl:template>
  
  <xsl:template match="oak:footnote/oak:p">
    <p>
      <xsl:element name="a">
        <xsl:attribute name="name">
          <xsl:choose>
            <xsl:when test="substring(., 1, 1) = '*'">star</xsl:when>
            <xsl:when test="substring(., 1, 1) = '†'">dagger</xsl:when>
            <xsl:otherwise>footnote</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:apply-templates/>
      </xsl:element>
    </p>
  </xsl:template>
</xsl:stylesheet>

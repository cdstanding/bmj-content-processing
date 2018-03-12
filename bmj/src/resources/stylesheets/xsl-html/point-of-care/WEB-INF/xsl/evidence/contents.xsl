<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:oak="http://schema.bmj.com/delivery/oak"
  xmlns:ce="http://schema.bmj.com/delivery/oak-ce"
  xmlns:common="http://exslt.org/common">
  
  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../libs/oak-general-lib.xsl" />
  <xsl:import href="../evidence/efficacy-list.xsl" />
 
  
  <!-- request context path -->
  <xsl:param name="ctxPath" />
  
  <!-- text for title bar -->
  <xsl:param name="monographTitle" />
  <xsl:param name="monographId" />
  
  <xsl:param name="systematicReviewId"/>
  <xsl:param name="evidenceStandalone"/>
  
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
	   			<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.evidence.contents.contents</xsl:with-param>
				</xsl:call-template>             
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="//oak:review-title-abridged"/>
              <xsl:text> - Clinical Evidence - </xsl:text>
	   			<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.evidence.contents.contents</xsl:with-param>
				</xsl:call-template>                        
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
              <li class="active"><span>
	   			<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.evidence.contents.systematic-review-contents</xsl:with-param>
				</xsl:call-template></span></li>
            </ul>
          </div>
          <!-- /sub-nav -->
          <div class="clear">
          <!-- x -->
          </div>
          <div id="main-body">
            <div class="body-copy">
              <xsl:call-template name="key-point-link"/>
              <xsl:call-template name="question-summary"/>
              <xsl:apply-templates select="//oak:section[@class='question-list']" />
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
  
  <xsl:template name="key-point-link">
    <xsl:element name="div">
      <xsl:attribute name="id">box</xsl:attribute>
      <xsl:attribute name="class">slate</xsl:attribute>
      
      <xsl:element name="p">
        <xsl:element name="strong">
			<xsl:call-template name="translate-with-arguments">
				<xsl:with-param name="messagekey">body.evidence.contents.read-key-points</xsl:with-param>
				<xsl:with-param name="arguments">
				<xsl:value-of select="concat($ctxPath, '/evidence/key-points/', $systematicReviewId, '.html')"/>
				</xsl:with-param>
				<xsl:with-param name="argumentseparator"/>
			</xsl:call-template>  
        </xsl:element>
      </xsl:element>
      
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="question-summary">
    <!-- show question anchors at the top, but only if there is more than one question -->
    <xsl:if test="count(//oak:section[@class='question']) > 1">
    
      <xsl:element name="p">
	   			<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.evidence.contents.list-of-clinical-questions</xsl:with-param>
				</xsl:call-template>      
      </xsl:element>
      
      <xsl:element name="div">
        <xsl:attribute name="id">question-list</xsl:attribute>
        <xsl:element name="ul">
        
          <xsl:for-each select="//oak:section[@class='question']">
            <xsl:element name="li">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('#Q', count(./preceding-sibling::oak:section[@class='question'])+1)"/>
                </xsl:attribute>
                <xsl:apply-templates select="./oak:title"/>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="oak:section[@class='option']/oak:title">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="oak:section[@class='question']">
    <div class="intervention-table">
      <xsl:element name="a">
        <xsl:attribute name="name">
          <xsl:value-of select="concat('Q', count(./preceding-sibling::oak:section[@class='question'])+1)"/>
        </xsl:attribute>
      </xsl:element>

      <h4><xsl:apply-templates select="./oak:title" /></h4>

      <table cellspacing="0" cellpadding="0">
        <xsl:attribute name="summary">
          <xsl:value-of select="concat('Interventions table for ', ./oak:title)" />            
        </xsl:attribute>  
        <xsl:call-template name="intervention-table-body">
          <xsl:with-param name="question-element" select="."/>
        </xsl:call-template>
      </table>
    </div>
    <xsl:apply-templates select="oak:footnote"/>
  </xsl:template>


  <xsl:template name="intervention-table-body">
    <xsl:param name="question-element"/>
    <tbody>
      <xsl:for-each select="common:node-set($CEEfficacyList)//efficacy/@id">
      
        <xsl:variable name="efficacy-id"><xsl:value-of select="."/></xsl:variable>
        <xsl:if test="$question-element/oak:section[@class='option'][oak:metadata/oak:key[@ce:name='intervention-efficacy'][@value=$efficacy-id]]">

          <xsl:variable name="efficacy">
            <xsl:call-template name="efficacy-name">
              <xsl:with-param name="id" select="$efficacy-id"/>
            </xsl:call-template>
          </xsl:variable>
          
          <xsl:variable name="imageicon">
            <xsl:call-template name="efficacy-icon">
              <xsl:with-param name="id" select="$efficacy-id"/>
            </xsl:call-template>
          </xsl:variable>
  
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
                <xsl:for-each select="$question-element/oak:section[@class='option'][oak:metadata/oak:key[@ce:name='intervention-efficacy'][@value=$efficacy-id]]">
                  <xsl:sort select="./oak:title"/>
                  <xsl:apply-templates select="."/>
                </xsl:for-each>
              </ul>
            </td>
          </tr>
          
        </xsl:if>
      </xsl:for-each>
    </tbody>
  </xsl:template>    
  
  <!-- need to exclude some titles -->
  <xsl:template match="oak:section[@class='question-list']/oak:title"/>
  <xsl:template match="oak:ce-question-title-abridged"/>
  
  
  <xsl:template match="oak:section[@class='option']">
    <xsl:element name="li">
    
      <xsl:element name="a">
        <xsl:attribute name="tabindex">45</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:call-template name="basic-evidence-path"/>
          <xsl:value-of select="'/intervention/'" />
          <xsl:value-of select="$systematicReviewId" />
          <xsl:value-of select="'/0/'" />
          <xsl:value-of select="@id" />
          <xsl:value-of select="'.html'" />
        </xsl:attribute>
        <xsl:apply-templates select="./oak:title" />
      </xsl:element>
      
      <xsl:if test="contains(./oak:metadata/oak:key[@ce:name='summary-title']/@value, '*')">
        <a href="#star">*</a>
      </xsl:if>
      
      <xsl:if test="contains(./oak:metadata/oak:key[@ce:name='summary-title']/@value, '†')">
        <a href="#dagger">†</a>
      </xsl:if>
      
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="oak:section[@class='footnote']">
    <div class="footnote">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="oak:section[@class='future-issues']"/>
  
  <xsl:template match="oak:section[@class='footnote']/oak:title">
    <h4><xsl:apply-templates/></h4>
  </xsl:template>
  
  <xsl:template match="oak:section[@class='footnote']/oak:p">
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

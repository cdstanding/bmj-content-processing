<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:oak="http://schema.bmj.com/delivery/oak">
  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../libs/oak-general-lib.xsl" />
  <xsl:import href="../libs/evidence-score-lib.xsl" />
  
  <!-- request context path -->
  <xsl:param name="ctxPath" />
  <xsl:param name="competitionKeyId"/>
  
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
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="//oak:name"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text> - Clinical Evidence - </xsl:text>
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
        <div class="ce">
        
          <xsl:if test="//oak:systematic-reviews">
            <xsl:choose>
              <xsl:when test="$competitionKeyId">
                <div id="sub-nav-rosette">
                  <ul>
                    <li class="active">
                      <xsl:element name="span">
                        <xsl:choose>
                          <xsl:when test="$monographId">
                            <xsl:call-template name="translate">
                              <xsl:with-param name="messagekey">body.evidence.question.related-systematic-reviews-questions</xsl:with-param>
                            </xsl:call-template>                                  
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:call-template name="translate">
                              <xsl:with-param name="messagekey">body.evidence.question.systematic-reviews-questions</xsl:with-param>
                            </xsl:call-template>                                  
                          </xsl:otherwise>  
                        </xsl:choose>    
                      </xsl:element>
                    </li>
                  </ul>
                </div>              
              </xsl:when>   
              <xsl:otherwise>
                <div id="sub-nav">
                  <ul>
                    <li class="active">
                      <xsl:element name="span">
                        <xsl:choose>
                          <xsl:when test="$monographId">
                            <xsl:call-template name="translate">
                              <xsl:with-param name="messagekey">body.evidence.question.related-systematic-reviews-questions</xsl:with-param>
                            </xsl:call-template>                                  
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:call-template name="translate">
                              <xsl:with-param name="messagekey">body.evidence.question.systematic-reviews-questions</xsl:with-param>
                            </xsl:call-template>                                  
                          </xsl:otherwise>  
                        </xsl:choose>    
                      </xsl:element>
                    </li>
                  </ul>
                </div>                
              </xsl:otherwise>
            </xsl:choose>

            <!-- /sub-nav -->
            <div class="clear">
              <!-- x -->
            </div>
          </xsl:if>
          
          <div id="main-body">
            <div class="body-copy">
              <xsl:apply-templates />
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
          <!-- x -->
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="oak:systematic-reviews">
    <div>
      <xsl:element name="h3">
        <xsl:choose>
          <xsl:when test="$monographId">
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.question.related-systematic-reviews-questions</xsl:with-param>
			</xsl:call-template>               
          </xsl:when>
          <xsl:otherwise>
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.question.systematic-reviews-questions</xsl:with-param>
			</xsl:call-template>               
          </xsl:otherwise>  
        </xsl:choose>    
      </xsl:element>
      <xsl:for-each select="oak:systematic-review">
        <xsl:call-template name="systematic-review-template">
            <xsl:with-param name="endClass" select="position()=last()"/>
            <xsl:with-param name="topicId" select="./@id"/>
        </xsl:call-template>        
      </xsl:for-each>
    </div>
  </xsl:template>
  
  <xsl:template name="systematic-review-template">
    <xsl:param name="endClass" />
    <xsl:param name="topicId" />
    <dl>
      <xsl:if test="$endClass">
        <xsl:attribute name="class">
          <xsl:value-of select="'end'" />
        </xsl:attribute>
      </xsl:if>
      <dt>
          <xsl:apply-templates select="oak:name" />
          <!-- xsl:apply-templates select="oak:status" /-->
      </dt>
      <dd>
          <ul>
            <xsl:for-each select="oak:questions/oak:question">
              <li>
                  <a tabindex="45">
                    <xsl:attribute name="href">
                        <xsl:call-template name="basic-evidence-path"/>
                        <xsl:value-of select="'/question/'" />
                        <xsl:value-of select="$topicId" />
                        <xsl:value-of select="'/'" />
                        <xsl:value-of select="./oak:number" />
                        <xsl:value-of select="'.html'" />
                    </xsl:attribute>
                    <xsl:apply-templates select="./oak:title" />
                  </a>
              </li>
            </xsl:for-each>
          </ul>
      </dd>
    </dl>
  </xsl:template>

  <xsl:template match="oak:status">
    <xsl:if test=". = 'archive'">
      <xsl:element name="span">
          <xsl:attribute name="class">ce-archived</xsl:attribute>
          <xsl:value-of select="' (Archived)'"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="evidence-scores">
    <xsl:element name="h3">
  		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.evidence.question.evidence-scores</xsl:with-param>
		</xsl:call-template>                   
    </xsl:element>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="evidence-score">
    <xsl:element name="p">
      <xsl:attribute name="class">evidence-score</xsl:attribute>
      
      <xsl:element name="a">
          <xsl:attribute name="title">
            <xsl:call-template name="evidence-score-description">
              <xsl:with-param name="score" select="@score"/>
            </xsl:call-template>
          </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="concat('evidence-score-', @id)"/>
        </xsl:attribute>
        <xsl:attribute name="class">
            <xsl:value-of select="'reflink jstooltip evidence-score-'" />
            <xsl:value-of select="@score" />
        </xsl:attribute>
        <span>
           <xsl:value-of select="'['" />
           <xsl:value-of select="@score" />
           <xsl:value-of select="' Evidence]'" />
        </span>
      </xsl:element>
      
      <xsl:apply-templates/>
      
    </xsl:element>
   </xsl:template>
   
   <!-- override evidence-score-lib behaviour here, we don't want a new <p> -->
   <xsl:template match="evidence-score/comments">
    <xsl:apply-templates/>
   </xsl:template>
</xsl:stylesheet>

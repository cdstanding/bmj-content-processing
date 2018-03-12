<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:oak="http://schema.bmj.com/delivery/oak"
  xmlns:ce="http://schema.bmj.com/delivery/oak-ce"
  xmlns:common="http://exslt.org/common">

  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../libs/oak-general-lib.xsl" />

  <!-- request context path -->
  <xsl:param name="ctxPath" />

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
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="//oak:review-title-abridged"/>
              <xsl:text> - Clinical Evidence</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
            <xsl:text> - </xsl:text>          
         	<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.updates.updates</xsl:with-param>
			</xsl:call-template>   
          <xsl:text> - Best Practice</xsl:text>
        </title>
      </head>
      <body>
        <div class="ce">
        
          <div id="sub-nav">
            <ul>
              <li class="active">
                <xsl:element name="span">
                  <xsl:choose>
                    <xsl:when test="$monographId">
			         	<xsl:call-template name="translate">
							<xsl:with-param name="messagekey">body.evidence.updates.related-systematic-reviews-updates</xsl:with-param>
						</xsl:call-template>                       
                    </xsl:when>
                    <xsl:otherwise>
			         	<xsl:call-template name="translate">
							<xsl:with-param name="messagekey">body.evidence.updates.systematic-reviews-updates</xsl:with-param>
						</xsl:call-template>  
                    </xsl:otherwise>  
                  </xsl:choose>    
                </xsl:element>
              </li>
            </ul>
          </div>
          <!-- /sub-nav -->
          <div class="clear">
            <!-- x -->
          </div>
          
          <div id="main-body">
            <div class="body-copy">
            
              <xsl:choose>
                <xsl:when test="count(category) &gt; 0">
                  <xsl:call-template name="updates-div"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:element name="p">
		         	<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.evidence.updates.found-no-relevant-review</xsl:with-param>
					</xsl:call-template>                    
                  </xsl:element>
                </xsl:otherwise>
              </xsl:choose>
              
            </div><!-- /body copy -->
          </div><!-- /main body -->
          
        </div> <!-- ce -->
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



  <xsl:template name="updates-div">

    <div class="updates">
    
      <h1>
         	<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.updates.updates</xsl:with-param>
			</xsl:call-template>      
      </h1>
      
      <p>
         	<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.updates.recent-articles</xsl:with-param>
			</xsl:call-template>            
      </p>
      
      <p>
        <a href="http://clinicalevidence.bmj.com/ceweb/about/bmjupdates.jsp">
            <!-- the above URL just goes to the front page since 2012 -->
         	<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.updates.about-updates</xsl:with-param>
			</xsl:call-template>           
        </a>
        <xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;</xsl:text>
        <a href="http://clinicalevidence.bmj.com/ceweb/about/bmjupdates_disclaimer.jsp">
            <!-- the above URL just goes to the front page since 2012 -->
         	<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.updates.disclaimer</xsl:with-param>
			</xsl:call-template>                   
        </a>
      </p>                
      
      <div class="allopenable expandable-section">
        <h3>
         	<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.updates.categories</xsl:with-param>
			</xsl:call-template>                
          <span tabindex="45" class='showall'></span>
        </h3>
      
        <!-- <dl class="expandable"> -->
          <xsl:apply-templates select="category"/>
        <!-- </dl> -->
      </div> <!-- /categories -->
      
      <div class="mcmaster">
            <xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.updates.in-association-with</xsl:with-param>
			</xsl:call-template>            
        <a href="http://clinicalevidence.bmj.com/ceweb/about/bmjupdates.jsp">
            <!-- the above URL just goes to the front page since 2012 -->
          <xsl:element name="img">
            <xsl:attribute name="alt">McMaster Plus</xsl:attribute>
            <xsl:attribute name="src">http://clinicalevidence.bmj.com/images/logo-mcmaster.gif</xsl:attribute>
          </xsl:element>
        </a>
      </div>
    </div><!-- /updates -->
  
  </xsl:template>


  <xsl:template match="category[not(parent::categories)]">
    <dl class="expandable">
      <dt class="expanded"><xsl:value-of select="@name"/></dt>
      <dd class="update-category"><xsl:apply-templates select="update"/></dd>
    </dl>
  </xsl:template>

  <xsl:template match="update">
    <div class="update">
      <xsl:apply-templates/>
      <div class="mcmaster-logo">
        <img alt="McMaster Icon" src="http://clinicalevidence.bmj.com/images/icon-mcmaster.gif"/>
      </div>
    </div> 
    <xsl:comment>/update</xsl:comment>
  </xsl:template>

  <xsl:template match="update/title">
    <xsl:choose>
      <xsl:when test="parent::update/@pubmed-id">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>http://www.ncbi.nlm.nih.gov/pubmed/</xsl:text>
            <xsl:value-of select="parent::update/@pubmed-id"/>
            <xsl:text>?tool=bestpractice.bmj.com</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="class">web-link</xsl:attribute>
          <xsl:attribute name="rel">external</xsl:attribute>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="disciplines[discipline]">
    <dl class="expandable">
      <dt class="expanded">
         	<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.updates.ratings</xsl:with-param>
			</xsl:call-template>                      
      </dt>
      <dd>
      
        <table summary="Clinical Evidence update ratings" class="update-table">

          <thead>
            <tr>
              <th class="rated">
	         	<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.evidence.updates.rated-by-doctors</xsl:with-param>
				</xsl:call-template>                                    
              </th>
              <th>
	         	<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.evidence.updates.relevance</xsl:with-param>
				</xsl:call-template>                                                  
              </th>
              <th>
	         	<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.evidence.updates.newsworthiness</xsl:with-param>
				</xsl:call-template>                                    
              </th>
            </tr>
          </thead>
          
          <tbody>
            <xsl:apply-templates/>
          </tbody>

        </table>
        
      </dd>
    </dl>
  </xsl:template>


  <xsl:template match="discipline">
    <xsl:element name="tr">
      
      <xsl:element name="td">
        <xsl:apply-templates select="@name"/>
      </xsl:element>
      
      <xsl:element name="td">
        <xsl:call-template name="star-rating">
          <xsl:with-param name="star-count" select="number(@rating_relevance)"/>
        </xsl:call-template>
      </xsl:element>
      
      <xsl:element name="td">
        <xsl:call-template name="star-rating">
          <xsl:with-param name="star-count" select="number(@rating_newsworthiness)"/>
        </xsl:call-template>
      </xsl:element>
      
    </xsl:element>
  </xsl:template>


  <!-- Variables for star ratings -->
  <xsl:variable name="counter">
    <counters>
      <position>1</position>
      <position>2</position>
      <position>3</position>
      <position>4</position>
      <position>5</position>
      <position>6</position>
      <position>7</position>
    </counters>
  </xsl:variable>
    
    
  <xsl:template name="star-rating">
    <xsl:param name="star-count"/>
    
    <xsl:choose>

      <xsl:when test="$star-count &lt;= 0">
      	<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.evidence.updates.not-rated</xsl:with-param>
		</xsl:call-template>    
      </xsl:when>

      <xsl:otherwise>
        <xsl:for-each select="common:node-set($counter)//position">
          <xsl:element name="b">
            <xsl:choose>
              <xsl:when test="number(.) &lt;= $star-count">
                <tt>*</tt>
              </xsl:when>
              <xsl:otherwise>
                <i></i>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:for-each>    
      </xsl:otherwise>
      
    </xsl:choose>
    
  </xsl:template>

  <xsl:template match="oak:title"/>
</xsl:stylesheet>

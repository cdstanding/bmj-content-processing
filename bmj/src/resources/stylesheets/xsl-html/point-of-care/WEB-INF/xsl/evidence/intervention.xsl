<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:oak="http://schema.bmj.com/delivery/oak">
  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../libs/oak-general-lib.xsl" />
  
  <!-- request context path -->
  <xsl:param name="ctxPath" />
  
  <!-- text for title bar -->
  <xsl:param name="monographTitle" />
  <xsl:output method="html" omit-xml-declaration="yes" />
  
  <xsl:template match="*:xquery-result">
    <html>
      <head>
        <title>
          <xsl:choose>
            <xsl:when test="$monographTitle">
              <xsl:value-of select="$monographTitle" />
              <xsl:text> - Clinical Evidence - </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="//oak:review-title-abridged"/>
              <xsl:text> - Clinical Evidence - </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of disable-output-escaping="yes" select="//oak:question-title" />
          <xsl:text> - </xsl:text>
          <xsl:value-of disable-output-escaping="yes" select="//oak:intervention-title-abridged"/>
          <xsl:text> - </xsl:text>
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
        <div class="ce">
          <div id="sub-nav">
            <ul>
              <li>
                <xsl:call-template name="sr-questions-breadcrumb"/>
              </li>
              <li class="one-before">
                <xsl:call-template name="sr-question-breadcrumb"/>
              </li>
              <li class="active">
                <span>
			  		<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.evidence.intervention.evidence</xsl:with-param>
					</xsl:call-template></span>
              </li>
            </ul>
          </div>
          <!-- /sub-nav -->
          <div class="clear">
          <!-- x -->
          </div>
          <div id="main-body">
            <div class="body-copy">
              
              <xsl:apply-templates />
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
  
  <xsl:template match="oak:intervention">
    <h2 class="question">
        <xsl:choose>
            <xsl:when test="oak:intervention-question/oak:question-number[string-length(.)!=0]">
              <a tabindex="45">
                  <xsl:attribute name="href">
                    <xsl:call-template name="basic-evidence-path"/>
                    <xsl:value-of select="'/question/'" />
                    <xsl:value-of select="oak:sr-id" />
                    <xsl:value-of select="'/'" />
                    <xsl:value-of select="oak:intervention-question/oak:question-number" />
                    <xsl:value-of select="'.html'" />
                  </xsl:attribute>
                  <xsl:value-of disable-output-escaping="yes" select="oak:intervention-question/oak:question-title"/>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="oak:intervention-question/oak:question-title"/>
            </xsl:otherwise>
        </xsl:choose>
    </h2>
    <h2><xsl:apply-templates select="oak:intervention-title" /></h2>
    <h5 class="smlText">
  		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.treatment.evidence.background.in-this-section</xsl:with-param>
		</xsl:call-template>    
    </h5>
    <p>
    <xsl:for-each select="oak:intervention-section">
      <xsl:apply-templates select="oak:title" mode="breadcrumb"/>
      <xsl:if test="position() != last()">
        <xsl:value-of select="' | '"/>
        </xsl:if>
    </xsl:for-each>
    </p>
    <xsl:apply-templates select="oak:intervention-section" />
    <div class="spacer"/>
  </xsl:template>
  
  <xsl:template match="oak:title" mode="breadcrumb">
    <xsl:element name="a">
      <xsl:attribute name="tabindex"><xsl:value-of select="'45'"/></xsl:attribute>
      <xsl:attribute name="href"><xsl:value-of select="'#'"/><xsl:value-of select="../@class"/></xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  
   <xsl:template match="oak:p">
     <xsl:choose>
       <xsl:when test="ancestor::oak:section[@class ='notes']">
         <xsl:apply-templates/>
       </xsl:when>
       <xsl:otherwise>
         <p><xsl:apply-templates /></p>
       </xsl:otherwise>
     </xsl:choose>
  </xsl:template>
  
  <xsl:template match="oak:intervention-section">
      <a tabindex="45">
        <xsl:attribute name="id">
             <xsl:value-of select="@class" />
        </xsl:attribute>
        <xsl:attribute name="name">
             <xsl:value-of select="@class" />
        </xsl:attribute>
      </a>
      <div class="top">
          <a tabindex="45" href="javascript:scrollTo(0,0);">
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">top</xsl:with-param>
			</xsl:call-template>             
          </a>
      </div>
    <xsl:apply-templates />             
  </xsl:template>

  <!-- Template taken from CE, matching 'b' rather than 'strong'. -->
  <xsl:template match="oak:b">
    <xsl:choose>
      <xsl:when test="ancestor::oak:intervention-section[@class='key-points']">
        <b><xsl:apply-templates/></b>       
      </xsl:when>
      <xsl:otherwise>
          <!-- do we have anything before us? -->
          <xsl:if test="preceding-sibling::node()[last()]">
              <xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
          </xsl:if>
          <h4>
              <xsl:apply-templates select="node()">
                  <xsl:with-param name="noP">true</xsl:with-param>
              </xsl:apply-templates>
          </h4>
          <!-- do we have anything after us? -->
          <xsl:if test="name(following-sibling::node()[1])!='b'">
              <xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
          </xsl:if>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
  
  <!-- Template taken from CE, matching 'i' rather than 'em'. -->
  <xsl:template match="oak:i">
    <xsl:choose>
        <xsl:when test="ancestor::oak:intervention-section[@class='summary-statement']">
            <!-- do we have anything before us? -->
            <xsl:if test="preceding-sibling::node()[last()]">
                <xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
            </xsl:if>
            <xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
            <em>
                <xsl:apply-templates select="node()">
                    <xsl:with-param name="noP">true</xsl:with-param>
                </xsl:apply-templates>
            </em>
            <xsl:text disable-output-escaping="yes"> </xsl:text>
        </xsl:when>
      <xsl:when test="ancestor::oak:intervention-section[@class='key-points']">
        <i><xsl:apply-templates/></i>       
      </xsl:when>
        <xsl:otherwise>
            <em>
                <xsl:apply-templates/>
            </em>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="oak:title">
    <xsl:variable name="parentClass" select="../@class" />
  <xsl:choose>
        <xsl:when test="name(..) = 'intervention-title'">
          <h2><xsl:apply-templates/></h2>
        </xsl:when>
    <xsl:when test="$parentClass = 'benefits' or $parentClass = 'harms' or
      $parentClass = 'summary-statement' or $parentClass = 'comment' or $parentClass='comparison-set'  or $parentClass='key-points' ">
      <h3><xsl:apply-templates /></h3>
    </xsl:when>
      <xsl:when test="$parentClass = 'pico-set' ">
        <h5><xsl:apply-templates /></h5>
      </xsl:when>   
    <xsl:otherwise>
      <h4><xsl:apply-templates /></h4>  
    </xsl:otherwise>
  </xsl:choose>
  </xsl:template>
  
  <xsl:template match="oak:section[@class='pico-set']">
  <xsl:choose>
      <xsl:when test="./oak:section[@class!='pico-first'] and  (preceding-sibling::oak:section/oak:section/@class = 'pico-first')">
      </xsl:when>
      <xsl:when test="./oak:section[@class='pico-first'] and  (following-sibling::oak:section/oak:section/@class = 'pico')">
        <div class="intervention-table comparison-set">
          <table cellspacing="0" cellpadding="0">
            <xsl:attribute name="summary">
		 		<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.evidence.intervention.intervention-table-for</xsl:with-param>
				</xsl:call-template>
				<xsl:text> </xsl:text>                 
              <xsl:value-of select="./oak:title" />            
            </xsl:attribute>  
            <tbody>
              <xsl:call-template name="intervention-table-header">
                <xsl:with-param name="question-element" select="."/>
              </xsl:call-template>
              <tr><td colspan="6"><xsl:apply-templates select="oak:title"/></td></tr>
              <xsl:call-template name="intervention-table-body">
                <xsl:with-param name="question-element" select="."/>
              </xsl:call-template>
              <xsl:for-each select="following-sibling::oak:section">
              <xsl:if test="@class = 'pico' or @class = 'pico-first' or @class = 'pico-set'">
                <tr><td colspan="6"><xsl:apply-templates select="oak:title"/></td></tr>
                <xsl:call-template name="intervention-table-body">
                  <xsl:with-param name="question-element" select="."/>
                </xsl:call-template>
                </xsl:if>
              </xsl:for-each>
            </tbody>
          </table>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="intervention-tables"/>
      </xsl:otherwise>
    </xsl:choose>
   <xsl:apply-templates select="oak:footnote"/>
  </xsl:template>
  
  
  <xsl:template match="oak:section[@class='pico-first']/oak:section/oak:section[@class='comparators']/oak:title | oak:section[@class='pico']/oak:section/oak:section[@class='comparators']/oak:title">
    <h5><xsl:apply-templates/></h5>
  </xsl:template>
  
  <xsl:template match="oak:section[@class='pico-first']/oak:section/oak:title">
    </xsl:template>
 
  <xsl:template match="oak:section[@class='pico']/oak:section/oak:title | oak:section[@class='effect-size']/oak:p">
  </xsl:template>
  
  <xsl:template match="oak:section[@class='pico-first']/oak:section/oak:title" mode="pico">
    <xsl:apply-templates/>
  </xsl:template>
    
    <xsl:template match="oak:section[@class='reference']">
      <p><xsl:apply-templates/></p>
    </xsl:template>
    
   	<xsl:template match="oak:section[@class='comparators']/oak:title | oak:section[@class='comment-other']/oak:title">
	 <p><strong><xsl:apply-templates/></strong></p>
    </xsl:template>
    
    <xsl:template match="oak:section[@class='effect-size']/oak:metadata/oak:key">
    <xsl:if test="@value !='unset' and @value !='not-reported'">
    	<xsl:element name="p">
    	<xsl:attribute name="class">
    	<xsl:text>effect-size </xsl:text>
    	<xsl:value-of select="@value"/>
    	</xsl:attribute>
    	<span><xsl:value-of select="@value"/></span>
    	</xsl:element>
    	</xsl:if>
    </xsl:template>
    
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:oak="http://schema.bmj.com/delivery/oak"
  xmlns:ce="http://schema.bmj.com/delivery/oak-ce"
  xmlns:common="http://exslt.org/common">

  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../libs/oak-general-lib.xsl" />
  <xsl:import href="../evidence/subject-names.xsl"/>
  
  <!-- request context path -->
  <xsl:param name="ctxPath" />
  
  <xsl:output method="html" omit-xml-declaration="yes" />

  <xsl:template match="*:xquery-result">
    <html>
      <head>
        <xsl:element name="title">
          <xsl:text>Clinical Evidence - </xsl:text>
          <xsl:choose>
            <xsl:when test="//oak:conditions">
              <xsl:call-template name="ce-section-name">
                <xsl:with-param name="id">
                  <xsl:value-of select=".//oak:conditions/@subject"/>
                </xsl:with-param>
              </xsl:call-template>      
            </xsl:when>
            <xsl:otherwise>
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.evidence.browse.sections</xsl:with-param>
				</xsl:call-template>  
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text> - Best Practice</xsl:text>
        </xsl:element>
        <meta name="decorator" content="main"/>
      </head>
      <body>
        <div class="ce">
          <div id="sub-nav">
            <ul>
              <li class="active">
                <xsl:element name="span">
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                      <xsl:value-of select="$ctxPath"/>
                      <xsl:text>/evidence.html</xsl:text>
                    </xsl:attribute>
                    <xsl:text>Systematic reviews</xsl:text>
                  </xsl:element>
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
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="oak:subjects">
    <xsl:element name="div">
      <xsl:attribute name="class">ce-subject-list</xsl:attribute>
      <xsl:element name="h3">
		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.evidence.browse.sections</xsl:with-param>
		</xsl:call-template>        
      </xsl:element>
      <xsl:variable name="subject-list" select="."/>
      <xsl:element name="ul">
        <!--  need to sort this by section title 
          - titles only available in CESectionNames -->
        <xsl:for-each select="common:node-set($CESectionNames)//section">
          <xsl:sort select="."/>
          <xsl:variable name="subject-id" select="./@id"/>
          <xsl:apply-templates select="$subject-list/oak:subject[text() = $subject-id]"/>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="oak:subject">
    <xsl:element name="li">
      <xsl:variable name="subjectid"><xsl:value-of select="."/></xsl:variable>
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="$ctxPath"/>
          <xsl:text>/evidence/browse/bysubject/</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>.html</xsl:text>
        </xsl:attribute>
        <xsl:call-template name="ce-section-name">
          <xsl:with-param name="id" select="$subjectid"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="oak:conditions">
    <xsl:element name="div">
      <xsl:attribute name="class">ce-condition-list</xsl:attribute>
      
      <xsl:element name="h3">
        <xsl:call-template name="ce-section-name">
          <xsl:with-param name="id" select="./@subject"/>
        </xsl:call-template>      
      </xsl:element>
      
      <xsl:apply-templates/>
    
    </xsl:element>
  </xsl:template>    

  <xsl:template match="oak:primary-conditions">
    <xsl:choose>

      <xsl:when test="count(./*) > 0">
        <xsl:element name="ul">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:element name="p">
			<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.browse.topics-in-this-section</xsl:with-param>
			</xsl:call-template>          
        </xsl:element>
      </xsl:otherwise>
      
    </xsl:choose>
  </xsl:template>

  <xsl:template match="oak:secondary-conditions">
    <xsl:if test="count(./*) > 0">
      <xsl:element name="div">
        <xsl:attribute name="class">ce-secondary-condition-list</xsl:attribute>
        <xsl:element name="h4">
			<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.evidence.browse.covered-elsewhere</xsl:with-param>
			</xsl:call-template>             
        </xsl:element>
        <xsl:element name="ul">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="oak:condition">
    <xsl:element name="li">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="$ctxPath"/>
          <xsl:text>/evidence/</xsl:text>
          <xsl:value-of select="substring(@id, 4,7)"/>
          <xsl:text>.html</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates/>
      </xsl:element>
      <!-- xsl:apply-templates select="oak:status"/-->
    </xsl:element>
  </xsl:template>
  
   <xsl:template match="oak:status">
    <xsl:if test="text() = 'archive'">
      <xsl:element name="span">
        <xsl:attribute name="class">
          <xsl:value-of select="'ce-archived'"/>     
        </xsl:attribute>
        <xsl:value-of select="' (Archived)'"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>

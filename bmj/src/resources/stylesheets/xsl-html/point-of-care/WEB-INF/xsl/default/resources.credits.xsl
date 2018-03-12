<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../libs/general-lib.xsl" />

  <!-- text for title bar -->
  <xsl:param name="monographTitle" />

  <!-- request context path -->
  <xsl:param name="ctxPath" />

  <xsl:output method="html" omit-xml-declaration="yes" />

  <xsl:template match="*:xquery-result">
    <html>
      <head>
        <title>
          <xsl:value-of select="$monographTitle" />
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">resources</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">resources.credits</xsl:with-param>
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
					<xsl:with-param name="messagekey">resources.credits</xsl:with-param>
				</xsl:call-template>            
            </h1>
            <div class="updated">
              <xsl:apply-templates select="*[not(self::last-updated)]"/>
            </div>
          </div><!-- /body-copy -->
        </div><!-- /main-body -->
        <!-- xsl:apply-templates select="last-updated" /-->
        <div class="clear">
          <!-- x -->
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- xsl:template match="last-updated">
	<xsl:element name="div">
		<xsl:attribute name="id">sub-body</xsl:attribute>
    	<xsl:element name="div">
    		<xsl:attribute name="class">body-copy</xsl:attribute>
			<xsl:element name="p">
				<xsl:attribute name="class">last-updated</xsl:attribute>
				<xsl:element name="strong">
					<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.resources.credits.topic-last-updated</xsl:with-param>
					</xsl:call-template> 				
				</xsl:element>
				<xsl:text> </xsl:text>
				<xsl:value-of select="." />
			</xsl:element>
		</xsl:element>
	</xsl:element>
  </xsl:template-->

  <xsl:template match="authors">
    <h2>
		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.resources.credits.authors</xsl:with-param>
		</xsl:call-template> 				    
	</h2>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="peer-reviewers">
    <h2>
		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.resources.credits.peer-reviewers</xsl:with-param>
		</xsl:call-template> 	    
    </h2>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="author">
    <a tabindex="45">
      <xsl:attribute name="id">
        <xsl:value-of select="position()" /> 
      </xsl:attribute>
    </a>
    <div class="author clearfix">
      <xsl:call-template name="photoTemplate">
        <xsl:with-param name="author" select="." />
      </xsl:call-template>      
      <dl class="description">
        <dt>
          <xsl:value-of select="name" />
          <xsl:value-of select="', '" />
          <xsl:value-of select="degree" />
        </dt>
        <xsl:apply-templates select="title-affil/para" />
        <xsl:apply-templates select="disclosures" />
      </dl>
    </div>
  </xsl:template>

  <xsl:template match="peer-reviewer">
    <div class="author">
      <dl class="description">
        <dt>
          <xsl:value-of select="name" />
          <xsl:value-of select="', '" />
          <xsl:value-of select="degree" />
        </dt>
        <xsl:apply-templates select="title-affil/para" />
        <xsl:apply-templates select="disclosures" />
      </dl>
    </div>
  </xsl:template>

  <xsl:template match="title-affil/para">
    <dd>
      <xsl:apply-templates />
    </dd>
  </xsl:template>

  <xsl:template match="disclosures">
    <dt class="disclosures">
		<xsl:call-template name="translate">
			<xsl:with-param name="messagekey">body.resources.credits.disclosures</xsl:with-param>
		</xsl:call-template>
    </dt>
    <dd class="disclosures-desc">
      <xsl:value-of select="." />
    </dd>
  </xsl:template>

  <xsl:template name="photoTemplate">
	<xsl:param name="author" />
    <xsl:if test="$author/image-link">
      <div class="photo">
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:call-template name="image-source">
              <xsl:with-param name="path"
                select="$author/image-link/@target" />
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:call-template name="author-name">
              <xsl:with-param name="author" select="." />
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="author-name">
              <xsl:with-param name="author" select="." />
            </xsl:call-template>
          </xsl:attribute>
        </xsl:element>
        <br />
        <p>
          <xsl:call-template name="author-name">
            <xsl:with-param name="author" select="." />
          </xsl:call-template>
        </p>
      </div>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
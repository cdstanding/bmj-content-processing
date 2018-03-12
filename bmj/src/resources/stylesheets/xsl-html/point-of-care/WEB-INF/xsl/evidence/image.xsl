<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:oak="http://schema.bmj.com/delivery/oak">

	<xsl:import href="../libs/general-lib.xsl" />
	<xsl:import href="../libs/oak-general-lib.xsl" />

	<!-- text for title bar -->
	<xsl:param name="monographTitle" />

	<!-- request context path -->
	<xsl:param name="ctxPath" />
    <xsl:param name="cdnUrl" />
    
	<xsl:output method="html" omit-xml-declaration="yes" />

  <xsl:template match="*:xquery-result">
	<html>
      <head>
        <title>
          <xsl:value-of select="$monographTitle" />
           - Clinical Evidence - 
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">resources.image.bp</xsl:with-param>
			</xsl:call-template>   					 
 			- 
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
              <li>
                <xsl:call-template name="sr-question-breadcrumb"/>
              </li>
              <li class="one-before"><span>
		  		<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.resources.image.evidence</xsl:with-param>
				</xsl:call-template></span></li>
              <li class="active"><span>
		  		<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">resources.image.bp</xsl:with-param>
				</xsl:call-template></span></li>
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
        <div id="sub-body">
          <div class="body-copy">
            <img>
              <xsl:attribute name="src">
                <xsl:value-of select="$cdnUrl" />
                <xsl:value-of select="$ctxPath" />
                <xsl:value-of select="'/images/logo-ce.gif'" />
              </xsl:attribute>
            </img>
          </div>
        </div>
        <!-- /sub-body -->
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

	<xsl:template match="oak:figure">
      <div>
        <h1>
	  		<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.resources.image.figure</xsl:with-param>
			</xsl:call-template>        
            <xsl:value-of select='substring-after(substring-after(substring-after(@id, "-"), "-"), "f")' />
        </h1>
        <xsl:apply-templates />
        <xsl:variable name="image-path">
          <xsl:call-template name="oak-image-source">
          	<xsl:with-param name="path" select="@image" />
          </xsl:call-template>
        </xsl:variable>
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:value-of select="$image-path" />
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:value-of select="oak:caption/oak:p/text()" />
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:value-of select="oak:caption/oak:p/text()" />
          </xsl:attribute>
        </xsl:element>
      </div>
	</xsl:template>

	<xsl:template match="oak:caption">
	   <xsl:apply-templates />
	</xsl:template>

	<xsl:template match="oak:p">
		<p>
			<xsl:apply-templates />
		</p>
	</xsl:template>


</xsl:stylesheet>
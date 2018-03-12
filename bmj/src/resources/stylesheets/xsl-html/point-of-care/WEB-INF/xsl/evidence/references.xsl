<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:oak="http://schema.bmj.com/delivery/oak">

    <xsl:import href="../libs/general-lib.xsl" />
    <xsl:import href="../libs/oak-general-lib.xsl" />

    <!-- text for title bar -->
    <xsl:param name="monographTitle" />
        
	<xsl:output method="html" omit-xml-declaration="yes"/>
	
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
					<xsl:with-param name="messagekey">references</xsl:with-param>
				</xsl:call-template>            
                <xsl:text> - </xsl:text>                
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="//oak:review-title-abridged"/>
                <xsl:text> - Clinical Evidence - </xsl:text>
		  		<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">references</xsl:with-param>
				</xsl:call-template>            
                <xsl:text> - </xsl:text>                
              </xsl:otherwise>
            </xsl:choose>
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
						<xsl:with-param name="messagekey">references</xsl:with-param>
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
                <xsl:apply-templates />
                <xsl:call-template name="evidence-publication-date"/>
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
  
    <xsl:template match="oak:review-title-abridged"/>
  
    <xsl:template match="oak:sr-references">
      <xsl:choose>
        <xsl:when test="$monographTitle">
          <h2><xsl:value-of select="@title" /></h2>
        </xsl:when>
        <xsl:otherwise>
          <h2>
		  		<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">references</xsl:with-param>
				</xsl:call-template>          
          </h2>
        </xsl:otherwise>
      </xsl:choose>
      
      <xsl:apply-templates />
      
    </xsl:template>
    
    <xsl:template match="oak:reference">
      <a tabindex="45">
        <xsl:attribute name="id">
          <xsl:value-of select="@id" />
        </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="@id" />
        </xsl:attribute>
      </a>
      <p>
        <strong>
          <xsl:call-template name="reference-id-template">
            <xsl:with-param name="unique-id" select="@id"/>
          </xsl:call-template>
          <xsl:value-of select="'. '" />
        </strong>
        <xsl:apply-templates />
      </p>
    </xsl:template>
    
    <xsl:template match="oak:p" >
      <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="oak:i" >
      <em><xsl:apply-templates /></em>
    </xsl:template>
    
    
    
</xsl:stylesheet>
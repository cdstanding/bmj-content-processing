<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:common="http://exslt.org/common"
  xmlns:set="http://exslt.org/sets">

  <!-- 
      NOTE: this XSL makes use of the EXSLT "common" and "set" extension 
      functions, so is not guaranteed to work with all transformers - it is 
      known to work with Xalan.
      
      KEITHM - 2009-11-19
   -->

  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../default/image-backlinks.xsl"/>
  
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
						<xsl:with-param name="messagekey">resources.image.bp</xsl:with-param>
					</xsl:call-template>	
				  -          
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
      
          <div class="head">
             <div class="button" style="display:none">
                <a tabindex="45" href="#" class="print">
					<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">page.print</xsl:with-param>
					</xsl:call-template>                     
                </a>
                
                <a tabindex="45" href="#" class="close">
					<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">close</xsl:with-param>
					</xsl:call-template>                           
                </a>
             </div>
          </div>
          <br/>
          <div class="body">
            <xsl:apply-templates select="figure/image-link">
               <xsl:with-param name="caption" select="figure/caption" />
            </xsl:apply-templates>
            <p class="caption">
              <xsl:apply-templates select="figure/caption"/>
            </p>
            <p class="credit">
              <xsl:apply-templates select="figure/source"/>
            </p>
            <xsl:apply-templates select="figure/backlinks"/>
          </div>
         
      </body>
    </html>
  </xsl:template>


  <xsl:template match="backlinks">
    <!-- this is tricky, because we need a distinct list here: -->
    <!-- prepare the full list of page-labels first -->
    <xsl:variable name="backlink-pagelabels">
      <xsl:element name="page-labels">
        <xsl:for-each select="backlink-uri">
          <xsl:call-template name="back-link-page-label-template">
            <xsl:with-param name="backlink-uri" select="."/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:element>
    </xsl:variable>
          
    <xsl:element name="p">
      <xsl:attribute name="class">image-back-links</xsl:attribute>
      <!--<xsl:choose>
        <xsl:when test="count(set:distinct(common:node-set($backlink-pagelabels)//uri)) = 1">
          <xsl:call-template name="translate">
            <xsl:with-param name="messagekey">body.resources.image.bp.referenced-in-places</xsl:with-param>
          </xsl:call-template>				
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="translate">
            <xsl:with-param name="messagekey">body.resources.image.bp.referenced-in-places</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
        </xsl:choose>-->
      <xsl:call-template name="translate">
        <xsl:with-param name="messagekey">body.resources.image.bp.referenced-in-places</xsl:with-param>
      </xsl:call-template>
    </xsl:element>
    
    <xsl:element name="ul">
      <xsl:attribute name="class">image-back-links</xsl:attribute>
     
      <!-- attempt to select a unique set of page-labels -->
      <!--<xsl:for-each select="set:distinct(common:node-set($backlink-pagelabels)//uri)">
        <xsl:element name="li">
          <xsl:call-template name="back-link-href-template">
            <xsl:with-param name="backlink" select="."/>
          </xsl:call-template>
        </xsl:element>
      </xsl:for-each>-->

    </xsl:element>
  </xsl:template>
  
<!-- 
  <xsl:template match="backlink-uri">
    <xsl:element name="li">
      <xsl:variable name="backlink">
        <xsl:call-template name="back-link-page-label-template">
          <xsl:with-param name="backlink-uri"><xsl:value-of select="."/></xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      
      <xsl:call-template name="back-link-href-template">
        <xsl:with-param name="backlink"><xsl:value-of select="$backlink"/></xsl:with-param>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>
-->
</xsl:stylesheet>
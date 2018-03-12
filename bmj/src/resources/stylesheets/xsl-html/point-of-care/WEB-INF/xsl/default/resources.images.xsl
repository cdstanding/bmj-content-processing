<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../libs/general-lib.xsl" />

  <!-- text for title bar -->
  <xsl:param name="monographTitle" />

  <!-- request context path -->
  <xsl:param name="ctxPath" />

  <!-- To show the error when javascript is off and none of images is selected -->
  <xsl:param name="isError" select="false"/>
  
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
						<xsl:with-param name="messagekey">resources.images</xsl:with-param>
					</xsl:call-template>	
				  -          
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
        <xsl:element name="form">
          <xsl:attribute name="id"><xsl:value-of select="'imageform'" /></xsl:attribute>
          <xsl:attribute name="name"><xsl:value-of select="'imageform'" /></xsl:attribute>
            <xsl:attribute name="action">
              <xsl:value-of select="$ctxPath" />
              <xsl:value-of select="'/printImages.html'" />
            </xsl:attribute>
          <xsl:attribute name="method">post</xsl:attribute>
        <div id="images">
          <div class="body-copy">
            <h1>
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">resources.images</xsl:with-param>
				</xsl:call-template>            
            </h1>
            <p>
				<xsl:call-template name="translate-with-arguments">
					<xsl:with-param name="messagekey">body.resources.images.click-on-image</xsl:with-param>
					<xsl:with-param name="arguments">#popuplink-print-images</xsl:with-param>
					<xsl:with-param name="argumentseparator"></xsl:with-param>
				</xsl:call-template>              
			</p>
            <xsl:for-each select=".//figure">
              <xsl:variable name="image-target">
                <xsl:value-of select="./image-link/@target" />
              </xsl:variable>
              <xsl:if test="not(contains($image-target,'iline'))">
                <xsl:element name="div">
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="(position() mod 3)= 0">
                        <xsl:value-of select="'image-box end'" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="'image-box'" />
                      </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:element name="a">
                    <xsl:attribute name="tabindex">
                        <xsl:value-of select="'45'"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$ctxPath" />
                        <xsl:value-of select="'/monograph/'" />
                        <xsl:value-of select="$monographId" />
                        <xsl:value-of select="'/resources/image/bp/'" />
                        <xsl:value-of select="./@id" />
                        <xsl:value-of select="'.html'" />
                    </xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="'popuplink-img-bp_'" />
                            <xsl:value-of select="./@id" />
                    </xsl:attribute>
                    <xsl:attribute name="class">reflink</xsl:attribute>
                    <xsl:apply-templates select="image-link">
                      <xsl:with-param name="caption" select="./caption" />
                    </xsl:apply-templates>
                  </xsl:element>
                  <xsl:apply-templates select="caption" />
                  <xsl:if test="./source">
                    <p class="credit">
                      <xsl:value-of select="'Credited'" />
                    </p>
                  </xsl:if>
                  <p>
                    <xsl:element name="input">
                      <xsl:attribute name="type">checkbox</xsl:attribute>
                      <xsl:attribute name="id">image<xsl:value-of select="./@id" /></xsl:attribute>
                      <xsl:attribute name="name">image</xsl:attribute>
                      <xsl:attribute name="value"><xsl:value-of select="./@id" /></xsl:attribute>                      
                    </xsl:element>
                  </p>
                </xsl:element>
              </xsl:if>
            </xsl:for-each>
            </div><!-- /body copy -->
            <div class="clear">
              <!-- x -->
            </div>
            <div class="body-copy">
                <div class="button">
                     <xsl:element name="input">
                        <xsl:attribute name="name"><xsl:value-of select="'redirectUrl'" /></xsl:attribute>                
                        <xsl:attribute name="type"><xsl:value-of select="'hidden'" /></xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="$ctxPath" />
                          <xsl:value-of select="'/monograph/'" />
                          <xsl:value-of select="$monographId" />
                          <xsl:value-of select="'/resources/images/print/'" />
                    </xsl:attribute>
                    </xsl:element>
                    <xsl:element name="input">
                        <xsl:attribute name="id"><xsl:value-of select="'popuplink-print-images'" /></xsl:attribute>                
                        <xsl:attribute name="type"><xsl:value-of select="'submit'" /></xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="'Open selected images'" /></xsl:attribute>
                        <xsl:attribute name="class"><xsl:value-of select="'print-images'" /></xsl:attribute>
                    </xsl:element>
                </div><!-- /button -->
            </div><!-- /body-copy -->
        </div><!-- /images -->
        </xsl:element>
      </body>
    </html>
  </xsl:template>


  <xsl:template match="caption">
    <xsl:variable name="image-caption">
      <xsl:apply-templates />
    </xsl:variable>
    <p class="caption">
      <xsl:choose>
        <xsl:when test="(string-length($image-caption) > 120)">
          <xsl:value-of select="substring($image-caption, 1, 120)" />
          <xsl:value-of select="'...'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$image-caption" />
        </xsl:otherwise>
      </xsl:choose>
    </p>
  </xsl:template>

  <xsl:template match="image-link">
    <xsl:param name="caption" />
    <xsl:variable name="image-path">
      <xsl:call-template name="image-source">
        <xsl:with-param name="path" select="@target" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="thumbnail-extention">
      <xsl:value-of select="'-tn'" />
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($image-path,'_default')">
        <xsl:variable name="thumbnail">
          <xsl:value-of
            select="substring-before($image-path, '_default')" />
        </xsl:variable>
        <xsl:variable name="thumbnail-path">
          <xsl:value-of
            select="concat($thumbnail,$thumbnail-extention,'_default.jpg')" />
        </xsl:variable>
        <xsl:call-template name="image-thumbnail">
          <xsl:with-param name="image-path" select="$image-path" />
          <xsl:with-param name="thumbnail-path"
            select="$thumbnail-path" />
          <xsl:with-param name="caption" select="$caption" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="thumbnail">
          <xsl:value-of select="substring-before($image-path, '.jpg')" />
        </xsl:variable>
        <xsl:variable name="thumbnail-path">
          <xsl:value-of
            select="concat($thumbnail,$thumbnail-extention,'.jpg')" />
        </xsl:variable>
        <xsl:call-template name="image-thumbnail">
          <xsl:with-param name="image-path" select="$image-path" />
          <xsl:with-param name="thumbnail-path"
            select="$thumbnail-path" />
          <xsl:with-param name="caption" select="$caption" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="image-thumbnail">
    <xsl:param name="thumbnail-path" />
    <xsl:param name="image-path" />
    <xsl:param name="caption" />
    <xsl:element name="img">
      <xsl:attribute name="id">
              <xsl:value-of select="$image-path" />
          </xsl:attribute>
      <xsl:attribute name="class">
              <xsl:value-of select="'thumbnail'" />
          </xsl:attribute>
      <xsl:attribute name="src">
              <xsl:value-of select="$thumbnail-path" />
          </xsl:attribute>
      <xsl:attribute name="alt">
              <xsl:value-of select="$image-path" />
          </xsl:attribute>
      <xsl:attribute name="title">
              <xsl:value-of select="$caption" />
          </xsl:attribute>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

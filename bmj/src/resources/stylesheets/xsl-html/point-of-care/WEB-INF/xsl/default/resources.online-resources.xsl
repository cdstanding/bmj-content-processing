<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../libs/references-lib.xsl" />

  <!-- text for title bar -->
  <xsl:param name="monographTitle" />

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
						<xsl:with-param name="messagekey">resources.online-resources</xsl:with-param>
					</xsl:call-template>	
				  -          
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
        <div id="references">
          <div class="body-copy">
            <h1>
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">resources.online-resources</xsl:with-param>
				</xsl:call-template>            
            </h1>
                <ul>
                    <xsl:apply-templates />
                </ul>
          </div><!-- /body copy -->
        </div><!-- /main body -->
        <div id="sub-body">
          <div class="body-copy"></div><!-- /body copy -->
        </div><!-- /sub body -->
        <div class="clear">
          <!-- x -->
        </div><!-- /references -->
      </body>
    </html>
  </xsl:template>

  <xsl:template match="online-references">
      <xsl:for-each select="reference">
        <xsl:choose>
          <xsl:when test="position()=last()">
             <xsl:call-template name="online-referenceTemplate">
                <xsl:with-param name="endClass" select="'end'" />
             </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="online-referenceTemplate">
                <xsl:with-param name="endClass" select="''" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
  </xsl:template>
  
   <xsl:template name="online-referenceTemplate">
    <xsl:param name="endClass" />
    <li>
        <xsl:attribute name="class">
            <xsl:value-of select="$endClass"/>
        </xsl:attribute>
        <strong><a name="ref-{@id}"><xsl:value-of select="@id"/>.</a></strong>
          <a tabindex="45">
            <xsl:attribute name="rel">external</xsl:attribute>
            <xsl:attribute name="class">web-link</xsl:attribute>
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:attribute name="href">               
                <xsl:value-of select="./poc-citation/url" />
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="./title">
                    <xsl:value-of select="./title" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="./poc-citation/citation" />
                </xsl:otherwise>
            </xsl:choose>
          </a>
     </li>
   </xsl:template>
  
</xsl:stylesheet>
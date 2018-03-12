<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:oak="http://schema.bmj.com/delivery/oak"
	xmlns:ce="http://schema.bmj.com/delivery/oak-ce">
	
	<xsl:import href="../libs/general-lib.xsl" />
	<xsl:import href="../libs/oak-general-lib.xsl" />
	
	<!-- request context path -->
	<xsl:param name="ctxPath" />

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
					<xsl:with-param name="messagekey">body.evidence.table.table</xsl:with-param>
				</xsl:call-template>            
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
                <li>
                  <xsl:call-template name="sr-question-breadcrumb"/>
                </li>
                <li class="one-before"><span>
			  		<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.evidence.table.evidence</xsl:with-param>
					</xsl:call-template></span></li>                
                <li class="active"><span>
			  		<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.evidence.table.table</xsl:with-param>
					</xsl:call-template></span></li>
              </ul>
            </div>
            <!-- /sub-nav -->
            <div class="clear">
                <!-- x -->
            </div>
            <div class="body-copy">
              <xsl:apply-templates select="//oak:table"/>
              <xsl:call-template name="evidence-publication-date"/>
            </div>
            <!-- /body copy -->
        
            <div class="clear">
                <!-- x -->
            </div>
          </div>
          <!-- /ce -->
        </body>
      </html>
	</xsl:template>

    <xsl:template match="oak:table">
        <table frame="box" rules="all" class="grade">
            <xsl:apply-templates/>
        </table>
       
    </xsl:template>
    
    <xsl:template match="oak:thead//oak:td">
        <xsl:element name="th">
            <xsl:if test="@align">
                <xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@colspan">
                <xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="oak:thead | oak:tbody | oak:tfoot | oak:tr | oak:td | oak:br">
        <xsl:element name="{name()}">
            <xsl:if test="@align">
                <xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@colspan">
                <xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="oak:caption">
        <xsl:element name="caption">
            <xsl:for-each select="oak:p">
                <xsl:apply-templates select="node()"/>
                <xsl:text disable-output-escaping="yes"> </xsl:text>
            </xsl:for-each> 
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>

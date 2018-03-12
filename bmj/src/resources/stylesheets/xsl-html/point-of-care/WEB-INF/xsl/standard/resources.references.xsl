<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../default/resources.references.xsl" />
  
  <xsl:output method="html" omit-xml-declaration="yes"/>

  <xsl:template match="systematic-reviews">
    <xsl:if test="systematic-review">
      <a id="systematic-reviews" name="systematic-reviews" />
      <div class="ce">
        <div id="sub-nav">
          <ul>
            <li class="active">
                <span>
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.resource.references.systematic-review-references</xsl:with-param>
				</xsl:call-template>                
                </span>
            </li>
          </ul>
        </div><!-- /sub-nav -->
        <div class="clear"><!-- x --></div>
        <div class="body-copy">
          <ul>
            <xsl:for-each select="systematic-review">
            <li>
            <xsl:choose>
                <xsl:when test="position()=last()">
                   <xsl:attribute name="class">
                      <xsl:value-of select="'end'" />
                   </xsl:attribute> 
                </xsl:when>
            </xsl:choose>
                <a>
                  <xsl:attribute name="href">
                      <xsl:call-template name="basic-path"/>
                      <xsl:value-of select="'/treatment/evidence/references/'" />
                      <xsl:value-of select="sr-id" />
                      <xsl:value-of select="'.html'" />
                  </xsl:attribute>
                  <xsl:value-of select="sr-title" />
                </a>
              </li>
            </xsl:for-each>
          </ul>
        </div><!-- /body-copy -->
     </div><!-- /ce -->
    </xsl:if>
</xsl:template>
    
</xsl:stylesheet>
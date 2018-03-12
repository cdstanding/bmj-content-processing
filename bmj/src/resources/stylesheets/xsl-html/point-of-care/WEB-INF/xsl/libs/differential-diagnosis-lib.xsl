<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="../libs/general-lib.xsl" />
    
  <!--  GENERIC STYLING FOR HANDLING DIFFERENTIAL DIAGNOSIS DISPLAY -->
    
  <xsl:output method="html" omit-xml-declaration="yes" />
  
  <xsl:template name="differentialGroupTemplate">
    <xsl:if test="differential">
      <div class="allopenable expandable-section">
        <h3>
          <xsl:value-of select="name" />
          <span tabindex="45" class='showall'></span>
        </h3>
        <xsl:apply-templates select="differential"/>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="differential">
    <dl>
      <xsl:attribute name="class">
        <xsl:value-of select="'expandable '" />
        <xsl:if test="position()=last()">
            <xsl:value-of select="'end'" />
        </xsl:if>
      </xsl:attribute>
      <dt tabindex="45">
        <xsl:apply-templates select="ddx-name" />
        <a tabindex="45" class="expandable-anchor">
          <xsl:attribute name="id">
            <xsl:value-of select="'expsec-'" />
            <xsl:value-of select="@id" />
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="'expsec-'" />
            <xsl:value-of select="@id" />
          </xsl:attribute>
        </a>       
      </dt>
      <dd>
        <xsl:apply-templates select="monograph-link" /> 
        <table border="0" cellpadding="0" cellspacing="0" class="default differential-diagnosis">
          <tbody>
            <tr>
              <th scope="col" class="history">
	            <xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.differential-diagnosis-lib.history</xsl:with-param>
				</xsl:call-template>              
              </th>
              <th scope="col" class="exam">
	            <xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.differential-diagnosis-lib.exam</xsl:with-param>
				</xsl:call-template>                  
              </th>
              <th scope="col" class="first-test">
	            <xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.differential-diagnosis-lib.1st-test</xsl:with-param>
				</xsl:call-template>                  
              </th>
              <th scope="col" class="other-tests">
	            <xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.differential-diagnosis-lib.other-tests</xsl:with-param>
				</xsl:call-template>                  
              </th>
            </tr>
            <tr>
              <td class="history"><xsl:apply-templates select="history" /></td>
              <td class="exam"><xsl:apply-templates select="exam" /></td>
              <td class="first-test">
                <ul>
                  <xsl:for-each select="tests/test[@first='true']">
                    <xsl:call-template name="testTemplate" />
                  </xsl:for-each>
                </ul>
              </td>
              <td class="other-tests">
                <ul>
                  <xsl:for-each select="tests/test[@first='false']">
                    <xsl:call-template name="testTemplate" />
                  </xsl:for-each>
                </ul>
              </td>
            </tr>
          </tbody>
        </table>
      </dd>
    </dl>
  </xsl:template>
  
  <xsl:template name="testTemplate">
    <li>
      <strong>
        <xsl:value-of select="name" />
        <xsl:value-of select="': '" />
      </strong>
      <xsl:apply-templates select="result" />
      
      <xsl:if test="comments">
        <a tabindex="45" href="#" class="reflink more-link">
          <xsl:attribute name="id">
            <xsl:value-of select="'popuplink-diff-comment_'" />
            <xsl:value-of select="generate-id(name)" />
          </xsl:attribute>
          <span>
	            <xsl:call-template name="translate">
					<xsl:with-param name="messagekey">more</xsl:with-param>
				</xsl:call-template>              
          </span>
        </a>
        
        <!-- Hidden comments popup div -->
        <div style="display:none">
          <xsl:attribute name="id">
            <xsl:value-of select="'popup-content_'" />
            <xsl:value-of select="generate-id(name)" />
          </xsl:attribute>
          <div class="head">
            <h4><xsl:value-of select="name" /></h4>
            <div>
              <xsl:attribute name="id">
                  <xsl:value-of select="'close_'" />
                  <xsl:value-of select="generate-id(name)" />
              </xsl:attribute>
              <xsl:attribute name="class">
                   <xsl:value-of select="'button'" />
               </xsl:attribute>
             </div>
          </div>
          <div class="body">
            <xsl:apply-templates select="comments" />
          </div><!-- /Hidden comments popup div -->
        </div>
      </xsl:if>
    </li>
  </xsl:template>
  
  <xsl:template match='comments/para/figure-link[@inline="false"]'>
   <xsl:choose>
      <xsl:when test="name(following-sibling::figure-link) = 'figure-link' ">
      </xsl:when>
      <xsl:when test="count(following-sibling::figure-link) =0 and name(preceding-sibling::figure-link) = 'figure-link'">
        <xsl:variable name="preceding-target">
        <xsl:for-each select="preceding-sibling::figure-link">
          <xsl:value-of select="@target" />
          <xsl:value-of select="'-'"></xsl:value-of>
        </xsl:for-each>
        </xsl:variable>
        <xsl:call-template name="createInlineImageLink">
          <xsl:with-param name="target">
            <xsl:value-of select="$preceding-target"/>
            <xsl:value-of select="@target"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="createInlineImageLink">
          <xsl:with-param name="target" select="@target"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
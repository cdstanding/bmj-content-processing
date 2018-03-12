<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oak="http://schema.bmj.com/delivery/oak">

	<xsl:import href="general-lib.xsl" />
	
	<xsl:output method="html" omit-xml-declaration="yes" />
    
   <xsl:template match="guideline">
   <xsl:call-template name="showGuideline">
   <xsl:with-param name="guideline" select="."/>
   </xsl:call-template>
  </xsl:template>
  
   <xsl:template name="showGuideline">
  	<xsl:param name="guideline"/>
  	 <h3>
       <xsl:choose>
         <xsl:when test="url">
            <a tabindex="45">
              <xsl:attribute name="rel">external</xsl:attribute>
              <xsl:attribute name="class">web-link</xsl:attribute>
              <xsl:attribute name="target">_blank</xsl:attribute>
              <xsl:attribute name="href">
                  <xsl:apply-templates select="url" />
                  </xsl:attribute>
              <xsl:apply-templates select="title" />
            </a>
          </xsl:when>
          <xsl:otherwise>
              <strong><xsl:apply-templates select="title" /></strong>
          </xsl:otherwise>
        </xsl:choose>
      </h3>
      <xsl:choose>
  		<xsl:when test="summary/para/text()">
  			<xsl:call-template name="show-published-information"/>
  			<dl>
  				<xsl:choose>
  					<xsl:when test="position()=last()">
  						<xsl:attribute name="class">
  						<xsl:value-of select="'expandable end'" />
  						</xsl:attribute>
  					</xsl:when>
  					<xsl:otherwise>
  						<xsl:attribute name="class">
  						<xsl:value-of select="'expandable'" />
  						</xsl:attribute>
  					</xsl:otherwise>
  				</xsl:choose>
  				<dt tabindex="45">
			        <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.guideline-lib.summary</xsl:with-param>
					</xsl:call-template>  				
				</dt>
  				<dd>
  					<table cellpadding="0" cellspacing="0" border="0"  class="default">
  						<tr>
  							<td colspan="2">
  								<p>
  									<xsl:apply-templates select="summary" />
  								</p>
  							</td>
  						</tr>
  					</table>
  				</dd>
  			</dl>
  		</xsl:when>
  		<xsl:otherwise>
  			<dl>
  				<dd>
  					<xsl:call-template name="show-published-information"/>
  				</dd>
  			</dl>
  		</xsl:otherwise>
  	</xsl:choose>
  	</xsl:template>
  	<xsl:template name="show-published-information">
  		<table cellpadding="0" cellspacing="0" border="0" class="default">              
  			<tr>
  				<td>
  					<strong>
			        <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.guideline-lib.published-by</xsl:with-param>
					</xsl:call-template></strong>
  				</td>
  				<td>
  					<xsl:apply-templates select="source" />
  				</td>
  			</tr>
  			<tr>
  				<td>
  					<strong>
			        <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.guideline-lib.last-published</xsl:with-param>
					</xsl:call-template></strong>
  				</td>
  				<td>
  					<xsl:apply-templates select="last-published" />
  				</td>
  			</tr>
  		</table>
  	</xsl:template>
  
    <xsl:template name="showRegionalGuideline">
    	<xsl:param name="regions"/>
  	<xsl:for-each select="$regions">
  		<xsl:choose>
  			<xsl:when test=".//summary/para/text()">
  				<div class="allopenable expandable-section">
  				<h2>
  				<xsl:value-of select="@id" />
  				<span tabindex="45" class='showall'/>
  				</h2>
  				<xsl:apply-templates select="guideline" />
  				</div>
  			</xsl:when>                    
  			<xsl:otherwise>
  				<h2>
  				<xsl:value-of select="@id" />
  				<span tabindex="45"/>
  				</h2>
  				<xsl:apply-templates select="guideline" />
  			</xsl:otherwise>
  		</xsl:choose>
  	</xsl:for-each>
  	  </xsl:template>
  	  
  	<xsl:template name="showNonRegionalGuideline">
  		<xsl:param name="regions"/>
  		<xsl:choose>
  			<xsl:when test="$regions//summary/para/text()">
  				<div class="allopenable expandable-section">
  					<h2>
			        <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.guideline-lib.international</xsl:with-param>
					</xsl:call-template>  					
  					<span tabindex="45" class='showall'/>
  					</h2>
  					<xsl:apply-templates/>
  				</div>
  			</xsl:when>                    
  			<xsl:otherwise>
  				<h2>
			        <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">body.guideline-lib.international</xsl:with-param>
					</xsl:call-template>  			
  					<span tabindex="45"/>
  				</h2>
  				<xsl:apply-templates/>
  			</xsl:otherwise>
  		</xsl:choose>
  	</xsl:template>
    <xsl:template match="title">
      <xsl:apply-templates />
    </xsl:template>
  
    <xsl:template match="source">
      <xsl:apply-templates />
    </xsl:template>
  
    <xsl:template match="last-published">
      <xsl:apply-templates />
    </xsl:template>
  
    <xsl:template match="url">
      <xsl:apply-templates />
    </xsl:template>
  
    <xsl:template match="summary">
      <xsl:apply-templates />
  </xsl:template>
</xsl:stylesheet>
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:saxon="http://icl.com/saxon" exclude-result-prefixes="saxon">

    <xsl:import href="../libs/general-lib.xsl" />
    
    <xsl:output method="html" omit-xml-declaration="yes"/>
    
    <!-- text for title bar -->
    <xsl:param name="monographTitle"/>

    <xsl:template match="*:xquery-result">
        <html>
            <head>
                <title>
                    <xsl:value-of select="$monographTitle"/>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">overview</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">overview.summary</xsl:with-param>
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
								<xsl:with-param name="messagekey">overview.summary</xsl:with-param>
							</xsl:call-template>			                        
                        </h1>
                        <xsl:apply-templates select=".//overview"/>
                    </div> <!-- /body-copy -->
                </div> <!-- /main-body -->
                
                <div id="sub-body">
                    <div class="body-copy">
                   		<div class="differential-diagnosis">
                    		<h3>
								<xsl:call-template name="translate">
									<xsl:with-param name="messagekey">diagnosis.differential-diagnosis</xsl:with-param>
								</xsl:call-template>                      		
                    		</h3>
		                    <div class="sort">
								<xsl:call-template name="translate-with-arguments">
									<xsl:with-param name="messagekey">body.overview.summary.sort-by</xsl:with-param>
									<xsl:with-param name="arguments">
										<xsl:value-of select="concat($ctxPath, '/monograph/', $monographId, '/overview/summary.html')"/>%<xsl:value-of select="concat($ctxPath, '/monograph/', $monographId, '/overview/summary/by-category.html')"/>
									</xsl:with-param>
									<xsl:with-param name="argumentseparator">%</xsl:with-param>
								</xsl:call-template>                                                               
		                    </div>                    		
	                        <xsl:apply-templates select=".//differentials"/>
	                    </div> <!-- /differential-diagnosis -->
                    </div> <!-- /body-copy -->
                </div> <!-- /sub-body --> 
                <!-- /body-left -->
                <div class="clear">
                    <!-- x -->
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="overview">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="differentials">
     <dl>
        <xsl:apply-templates select="common"/>
        <xsl:apply-templates select="uncommon"/>        
     </dl>
    </xsl:template>
    
    <xsl:template match="common">
  		<xsl:if test="differential">
			<dt>
	            <xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.overview.summary.common</xsl:with-param>
				</xsl:call-template>			
			</dt>
		    <xsl:call-template name="group-differential-template"/>
	    </xsl:if>
    </xsl:template>
    
    <xsl:template match="uncommon">
		<xsl:if test="differential">
			<dt>
	            <xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.overview.summary.uncommon</xsl:with-param>
				</xsl:call-template>				
			</dt>
		    <xsl:call-template name="group-differential-template"/>
		</xsl:if>
    </xsl:template>
        
    <xsl:template name="group-differential-template">
        <dd>
    		<ul>
		      <xsl:for-each select="differential">
			    <xsl:call-template name="differential-template">
	            	<xsl:with-param name="differentialId" select="./@id"/>
       			</xsl:call-template>        
		      </xsl:for-each>
			</ul>
		</dd>
    </xsl:template>
    
    <xsl:template name="differential-template">
        <xsl:param name="differentialId" />
	    <li>
	    	<xsl:choose>
	    		<xsl:when test="$differentialId">
		           <a tabindex="47">
		             <xsl:attribute name="href">
		                 <xsl:value-of select="$ctxPath" />
		                 <xsl:value-of select="'/monograph/'" />
		                 <xsl:value-of select="$monographId" />
		                 <xsl:value-of select="'/diagnosis/differential-diagnosis.html#expsec-'" />
		                 <xsl:value-of select="$differentialId" />
		             </xsl:attribute>
		             <xsl:value-of select="ddx-name" />
		           </a>	    	    		
	    		</xsl:when>
	    		<xsl:otherwise>
		             <xsl:value-of select="ddx-name" />
	    		</xsl:otherwise>
	    	</xsl:choose>
    	</li>    	
    </xsl:template>   
</xsl:stylesheet>
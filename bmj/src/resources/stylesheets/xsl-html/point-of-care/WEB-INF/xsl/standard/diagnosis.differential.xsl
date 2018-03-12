<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../libs/general-lib.xsl" />
	
	<!-- request context path -->
	<xsl:param name="ctxPath"/>
	
	<!-- text for title bar -->
	<xsl:param name="monographTitle"/>
	
	<xsl:output method="html" omit-xml-declaration="yes"/>
	
	<xsl:template match="*:xquery-result">
	    <html>
	        <head>
	            <title>
                    <xsl:value-of select="$monographTitle"/>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">diagnosis</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">diagnosis.differential</xsl:with-param>
					</xsl:call-template>					
				 -
                    <xsl:value-of select="'Best Practice'" />
                </title>
	        </head>
	        <body>
		        <div class="body-copy">
		            <h1>
						<xsl:call-template name="translate">
							<xsl:with-param name="messagekey">body.diagnosis.differential.differential-diagnosis</xsl:with-param>
						</xsl:call-template>		            
		            </h1>
		            <table class="default differential" border="0" cellspacing="0" cellpadding="5">
		                <caption>
							<xsl:call-template name="translate">
								<xsl:with-param name="messagekey">body.diagnosis.differential.differential-diagnosis-table-for</xsl:with-param>
							</xsl:call-template>		                
			                <xsl:value-of select="$monographTitle"/>
		                </caption>
		                <tr>
		                    <th class="condition">
								<xsl:call-template name="translate">
									<xsl:with-param name="messagekey">body.diagnosis.differential.condition</xsl:with-param>
								</xsl:call-template>		                    
		                    </th>
		                    <th class="signs">
								<xsl:call-template name="translate">
									<xsl:with-param name="messagekey">body.diagnosis.differential.differentiating-signs</xsl:with-param>
								</xsl:call-template>			                    
		                    </th>
		                    <th class="tests">
								<xsl:call-template name="translate">
									<xsl:with-param name="messagekey">body.diagnosis.differential.differentiating-tests</xsl:with-param>
								</xsl:call-template>			                    
		                    </th>
		                </tr>
		                <xsl:apply-templates select=".//differential"/>
		            </table>
		        </div>
		        <!-- /body copy -->
		
		        <div class="clear">
		            <!-- x -->
		        </div>
 
	        </body>
	    </html>
	</xsl:template>

	<xsl:template match="differential">
	    <tr>
	        <xsl:if test="position()=last()">
                <xsl:attribute name="class">
                    <xsl:value-of select="' end'"/>
                </xsl:attribute>
            </xsl:if>
              
			<td class="condition">
				<xsl:choose>
					<xsl:when test="monograph-link/@target">
						<xsl:element name="a">
                            <xsl:attribute name="tabindex">
                                <xsl:value-of select="'45'"/>
                            </xsl:attribute>
							<xsl:attribute name="href">
								<xsl:value-of select="$ctxPath"/>
                                <xsl:text>/monograph/</xsl:text>
                                <xsl:choose>
                                  <xsl:when test="contains(monograph-link/@target, '.xml')">
                                    <xsl:value-of select="substring-before(monograph-link/@target, '.xml')"/>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="monograph-link/@target"/>
                                  </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text>.html</xsl:text>
                            </xsl:attribute>
			           		<xsl:apply-templates select="name"/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
			           	<xsl:apply-templates select="name"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
           	<td class="signs">
               	<ul>
               		<xsl:for-each select="sign-symptoms/para">
               			<li><xsl:apply-templates select="."/></li>
               		</xsl:for-each>
               	</ul>
           	</td>
           	<td class="tests">
				<ul>
					<xsl:for-each select="tests/para">
						<li><xsl:apply-templates select="."/></li>
					</xsl:for-each>
				</ul>
           	</td>
       </tr>
	</xsl:template>

</xsl:stylesheet>
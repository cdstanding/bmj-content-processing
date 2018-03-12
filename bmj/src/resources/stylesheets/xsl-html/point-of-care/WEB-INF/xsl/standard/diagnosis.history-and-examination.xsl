<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
						<xsl:with-param name="messagekey">diagnosis.history-and-examination</xsl:with-param>
					</xsl:call-template>					
				 -                    
                    <xsl:value-of select="'Best Practice'" />
                </title>
            </head>
            <body>
                <div id="body-left">
                    <div class="body-copy">
                        <h1>
							<xsl:call-template name="translate">
								<xsl:with-param name="messagekey">diagnosis.history-and-examination</xsl:with-param>
							</xsl:call-template>                        
                        </h1>
                        <xsl:apply-templates select=".//diagnostic-factors"/>
                    </div>
                    <!-- /body-copy -->
                </div>
                <div id="body-right">
                    <div class="body-copy">
                        <xsl:apply-templates select=".//risk-factors"/>
                    </div>
                </div>    
                <!-- /body-left -->
                <div class="clear">
                    <!-- x -->
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="risk-factors">
        <div class="risk-factors allopenable expandable-section">
        <h3>
			<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.diagnosis.history-and-examination.risk-factors</xsl:with-param>
			</xsl:call-template>        
         <span tabindex="47" class='showall'/></h3>
        <xsl:apply-templates/>
    </div>
    </xsl:template>
    
    <xsl:template match="strong-risk-factors">
        <xsl:if test="./*">
            <h4>
			<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.diagnosis.history-and-examination.strong</xsl:with-param>
			</xsl:call-template>                
            </h4>
            <xsl:call-template name="riskFactorTemplate"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="weak-risk-factors">
        <xsl:if test="./*"> 
            <h4>
		    <xsl:call-template name="translate">
			     <xsl:with-param name="messagekey">body.diagnosis.history-and-examination.weak</xsl:with-param>
		    </xsl:call-template>                 
            </h4>
            <xsl:call-template name="riskFactorTemplate"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="riskFactorTemplate">
        <xsl:for-each select="risk-factor">
            <xsl:choose>
                <xsl:when test="position()=last()">
                    <xsl:call-template name="riskFactorDetailTemplate">
                        <xsl:with-param name="classStyle" select="'expandable end'" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="riskFactorDetailTemplate">
                        <xsl:with-param name="classStyle" select="'expandable'" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="riskFactorDetailTemplate">
        <xsl:param name="classStyle"/>
        <dl>
            <xsl:attribute name="class">
                <xsl:value-of select="$classStyle" />
            </xsl:attribute>
            
            <dt tabindex="47"><xsl:value-of select="name"/></dt>
            <xsl:for-each select="detail">
                <dd>
                    <ul>
                        <xsl:for-each select="./para">
                            <li><xsl:apply-templates/></li>
                        </xsl:for-each>
                    </ul>
                </dd>
            </xsl:for-each>
        </dl>
    </xsl:template>
   
    <xsl:template match="diagnostic-factors">
        <div class="diagnostic-factors allopenable expandable-section">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="key-diagnostic-factors">
        <xsl:if test="./*">
            <div class="allopenable expandable-section">
                <h3>
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.diagnosis.history-and-examination.key-diagnostic-factors</xsl:with-param>
				</xsl:call-template>                
                 <span tabindex="45" class='showall'/></h3>
                <xsl:call-template name="diagnosticTemplate"/>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="other-diagnostic-factors">
        <xsl:if test="./*">
            <div class="allopenable expandable-section">
                <!-- If key factors exist then show title as 'Other'-->
                <xsl:choose>
                    <xsl:when test="../key-diagnostic-factors/*">
                        <h3>
							<xsl:call-template name="translate">
								<xsl:with-param name="messagekey">body.diagnosis.history-and-examination.other-diagnostic-factors</xsl:with-param>
							</xsl:call-template>                         
                         <span tabindex="45" class='showall'/></h3>
                    </xsl:when>
                    <xsl:otherwise>
                        <h3>
							<xsl:call-template name="translate">
								<xsl:with-param name="messagekey">body.diagnosis.history-and-examination.diagnostic-factors</xsl:with-param>
							</xsl:call-template> 
                         <span tabindex="45" class='showall'/></h3>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="diagnosticTemplate"/>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="diagnosticTemplate">
        <xsl:for-each select="factor">
            <xsl:choose>
                <xsl:when test="position()=last()">
                    <xsl:call-template name="diagnosticDetailTemplate">
                        <xsl:with-param name="classStyle" select="'expandable end'" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="diagnosticDetailTemplate">
                        <xsl:with-param name="classStyle" select="'expandable'" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="diagnosticDetailTemplate">
        <xsl:param name="classStyle"/>
        <dl>
            <xsl:attribute name="class">
                <xsl:value-of select="$classStyle" />
            </xsl:attribute>
            
            <dt tabindex="45">
                <xsl:value-of select="factor-name"/>
                <span class="frequency"> (<xsl:value-of select="@frequency"/>)</span>
            </dt>
            <dd>
                <ul>
                    <xsl:choose>
		                <xsl:when test="./detail">
		                    <xsl:for-each select="./detail/para">
		                        <li><xsl:apply-templates/></li>
		                    </xsl:for-each>
		                </xsl:when>
		                <xsl:otherwise>
		                    <xsl:choose>
		                        <xsl:when test="./@key-factor='true'">
		                            <li>
									<xsl:call-template name="translate">
										<xsl:with-param name="messagekey">body.diagnosis.history-and-examination.is-a-key-diagnostic-factor</xsl:with-param>
									</xsl:call-template>
		                            </li>
		                        </xsl:when>
		                        <xsl:otherwise>
		                        
		                            <li>
									<xsl:call-template name="translate">
										<xsl:with-param name="messagekey">body.diagnosis.history-and-examination.is-a-diagnostic-factor</xsl:with-param>
									</xsl:call-template>
									</li>
		                        </xsl:otherwise>
		                    </xsl:choose>
		                </xsl:otherwise>
		            </xsl:choose>
                    
                </ul>
            </dd>
        </dl>
    </xsl:template>
</xsl:stylesheet>
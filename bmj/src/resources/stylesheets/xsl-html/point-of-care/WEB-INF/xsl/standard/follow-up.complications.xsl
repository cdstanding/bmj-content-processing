<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../libs/general-lib.xsl" />

	<!-- request context path -->
	<xsl:param name="ctxPath" />

	<!-- text for title bar -->
	<xsl:param name="monographTitle" />

	<xsl:output method="html" omit-xml-declaration="yes" />

	<xsl:template match="*:xquery-result">
		<html>
			<head>
				<title>
					<xsl:value-of select="$monographTitle" />
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">follow-up</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">follow-up.complications</xsl:with-param>
					</xsl:call-template>	
				  -
                    <xsl:value-of select="'Best Practice'" />
				</title>
			</head>
			<body>
					<div class="body-copy">
						<div class="allopenable expandable-section">
							<h2>
					          	<xsl:call-template name="translate">
									<xsl:with-param name="messagekey">follow-up.complications</xsl:with-param>
								</xsl:call-template>	
							</h2>

							<table cellpadding="5" cellspacing="0"
								border="0" class="default complications">
								<caption>
						          	<xsl:call-template name="translate">
										<xsl:with-param name="messagekey">body.follow-up.complications.complication.table.for</xsl:with-param>
									</xsl:call-template>									
									<xsl:value-of
										select="$monographTitle" />
								</caption>
								<tr>
									<th class="complication">
							          	<xsl:call-template name="translate">
											<xsl:with-param name="messagekey">body.follow-up.complications.complication</xsl:with-param>
										</xsl:call-template>									
										<span tabindex="45" class="showall"/>
									</th>
									<th class="timeframe">
							          	<xsl:call-template name="translate">
											<xsl:with-param name="messagekey">body.follow-up.complications.timeframe</xsl:with-param>
										</xsl:call-template>													
									</th>

									<th class="likelihood">
							          	<xsl:call-template name="translate">
											<xsl:with-param name="messagekey">body.follow-up.complications.likehood</xsl:with-param>
										</xsl:call-template>									
									</th>
								</tr>
								<xsl:for-each
									select='.//complication'>
									<xsl:choose>
										<xsl:when
											test="position()=last()">
											<xsl:call-template
												name="complicationTemplate">
												<xsl:with-param
													name="endClass" select="'end'" />
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template
												name="complicationTemplate">
												<xsl:with-param
													name="endClass" select="''" />
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</table>
						</div>
					</div>


					<div class="clear">
						<!-- x -->
					</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="complicationTemplate">
		<xsl:param name="endClass" />
		<tr>
			<xsl:element name="td">
				<xsl:attribute name="class">
				complication <xsl:value-of select="$endClass" />
			  </xsl:attribute>
				<div>
					<dl class="expandable">
						<dt tabindex="45" style="cursor: pointer;"
							class="collapsed">
							<xsl:apply-templates select="./name" />
						</dt>
						<dd>
							<xsl:apply-templates
								select="./monograph-link" />
							<xsl:for-each select="./detail/para">
								<xsl:apply-templates select="." />
							</xsl:for-each>
						</dd>
					</dl>
				</div>
			</xsl:element>
			<xsl:element name="td">
				<xsl:attribute name="class">
				timeframe 
				<xsl:value-of select="$endClass" />
			  </xsl:attribute>
				<xsl:apply-templates select="@timeframe" />
			</xsl:element>
			<xsl:element name="td">
				<xsl:attribute name="class">
				likelihood 
				<xsl:value-of select="$endClass" />
			  </xsl:attribute>
				<xsl:apply-templates select="@likelihood" />
			</xsl:element>
		</tr>
	</xsl:template>

</xsl:stylesheet>


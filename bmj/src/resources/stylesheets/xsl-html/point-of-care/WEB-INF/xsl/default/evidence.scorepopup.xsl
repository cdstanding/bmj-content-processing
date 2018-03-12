<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../libs/general-lib.xsl" />
	<xsl:import href="../libs/evidence-score-lib.xsl" />

	<xsl:output method="html" omit-xml-declaration="yes" />

	<!-- text for title bar -->
	<xsl:param name="monographTitle" />

	<xsl:template match="*:xquery-result">
		<html>
			<head>
				<title>
					<xsl:value-of select="$monographTitle" />
					- 
                	<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">treatment.evidence.scorepopup</xsl:with-param>
					</xsl:call-template> 
				</title>
			</head>
			<body>
				<div class="head">
					<h4>
                	<xsl:call-template name="translate">
						<xsl:with-param name="messagekey">treatment.evidence.scorepopup</xsl:with-param>
					</xsl:call-template> 					
					</h4>
					<div class="button">
						<a href="#" class="close">
		                	<xsl:call-template name="translate">
								<xsl:with-param name="messagekey">close</xsl:with-param>
							</xsl:call-template> 						
						</a>
					</div>
				</div>
				<div class="body">
						<xsl:apply-templates/>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="evidence-score">
		<xsl:apply-templates select="comments"/>
		<div class="evidence-level">
			<xsl:call-template name="evidence-score-level" />
		</div>
		<div class="action">
			<p>
				<xsl:apply-templates select="option-link" />
			</p>
		</div>
	</xsl:template>

</xsl:stylesheet>
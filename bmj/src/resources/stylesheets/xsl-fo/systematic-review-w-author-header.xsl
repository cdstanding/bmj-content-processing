<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE xsl:stylesheet [
	<!ENTITY ceblue "#0d519f">
	<!ENTITY celightblue "#c5c9e6">
	<!ENTITY cegrey "#cccccc">
]>

<?altova_samplexml C:\dev\docato-install\BMJ\systematic-review-publish.xml?>

<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	xmlns:xi="http://www.w3.org/2001/XInclude" 
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html">

	<xsl:include href="systematic-review-shared.xsl"/>

	<xsl:template match="/">

		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<xsl:call-template name="do-page-masters"/>
			
			
			<fo:page-sequence master-reference="my-sequence">
				<xsl:call-template name="do-static-content"/>
				
				
				<fo:flow flow-name="xsl-region-body" font-size="9pt" text-align="justify">
					<xsl:call-template name="do-headers"/>
					
					<xsl:call-template name="do-intervention-table"/>
					
					<xsl:call-template name="do-clinical-context"/>

					<xsl:call-template name="do-background"/>

					<xsl:call-template name="do-questions"/>
					
					<xsl:call-template name="do-references"/>
					
					<xsl:call-template name="do-contributors"/>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
	version="2.0">

	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"/>

	<xsl:strip-space elements="*"/>		

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- copy everything -->
	<xsl:template match="@*|node()">
	    <xsl:copy>
	        <xsl:apply-templates select="@*|node()"/>
	    </xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*[name()!='xmlns:xi' and name()!='id'] ">
	    <xsl:copy>
	        <xsl:apply-templates select="@*"/>
	    </xsl:copy>
	</xsl:template>
	
	<xsl:template match="@id [not(parent::article_ref or parent::clinical_ref or parent::image_ref  or parent::online_ref)]"/>
	
	<xsl:template match="@type[parent::component]"/>
	
	<!-- Added for Mantis ID 12117 -->
	<xsl:template match="@status[parent::guideline or parent::patient-summary-link or parent::figure or parent::resource]"/>
	
	
			
</xsl:stylesheet>

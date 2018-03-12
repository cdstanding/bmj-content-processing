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
		encoding="UTF-8" 
		indent="yes"/>
	
	<xsl:strip-space elements="*"/>

	<xsl:param name="resource-dir"/>
	<xsl:param name="dxid"/>
	<xsl:param name="scheme-id"/>

	<!-- 
		 stylesheet that handles replacing CMS component/drug names with corresponding term names in
		 Drug Link Manager (DB) using the Drug link api
		 
		 call this if there's a need to update drug names for customer. Currently used for EPOC.
	-->
	
	<xsl:variable name="allComponentsLocation">
		<xsl:value-of select="legacytag:retrieveAllComponentsOfMonographInDrugDB($dxid,$resource-dir)"/>		
	</xsl:variable>
	<xsl:variable name="componentsDoc" select="document($allComponentsLocation)"/>
    
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
    	    
	<xsl:template match="component">
		<xsl:element name="component">
			<xsl:if test="./@modifier">
				<xsl:attribute name="modifier"><xsl:value-of select="@modifier"/></xsl:attribute>
			</xsl:if>
 			<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			
			<xsl:variable name="componentId"><xsl:value-of select="@id"/></xsl:variable>
			
			<xsl:attribute name="type"><xsl:value-of select="$componentsDoc//annotation[statement/external-id/text() = $componentId][1]/term/@type"/></xsl:attribute>
 			
 			<xsl:choose>
 				<xsl:when test="./name/drug">
 					<xsl:element name="name">
 						<xsl:element name="drug">
	 						<xsl:if test="./name/drug/@bnf!=''"><xsl:attribute name="bnf"><xsl:value-of select="./name/drug/@bnf"/></xsl:attribute></xsl:if>
	 						<xsl:if test="./name/drug/@mart-id!=''"><xsl:attribute name="mart-id"><xsl:value-of select="./name/drug/@mart-id"/></xsl:attribute></xsl:if>
	 						<xsl:if test="./name/drug/@ban!=''"><xsl:attribute name="ban"><xsl:value-of select="./name/drug/@ban"/></xsl:attribute></xsl:if>
	 						<xsl:if test="./name/drug/@usan!=''"><xsl:attribute name="usan"><xsl:value-of select="./name/drug/@usan"/></xsl:attribute></xsl:if>
	 						<xsl:if test="./name/drug/@rinn!=''"><xsl:attribute name="rinn"><xsl:value-of select="./name/drug/@rinn"/></xsl:attribute></xsl:if>
	 						<xsl:if test="./name/drug/@mart-title!=''"><xsl:attribute name="mart-title"><xsl:value-of select="./name/drug/@mart-title"/></xsl:attribute></xsl:if>
	 						<xsl:if test="./name/drug/@usp!=''"><xsl:attribute name="usp"><xsl:value-of select="./name/drug/@usp"/></xsl:attribute></xsl:if>
 							<xsl:choose>
 								<xsl:when test="$componentsDoc//annotation[statement/external-id/text() = $componentId]/term/external-entry[@scheme-id = $scheme-id]/entry-name">
 									<xsl:value-of select="$componentsDoc//annotation[statement/external-id/text() = $componentId]/term/external-entry[@scheme-id = $scheme-id]/entry-name"/> 							
 								</xsl:when>
 								<xsl:otherwise>
 									<xsl:value-of select="$componentsDoc//annotation[statement/external-id/text() = $componentId][1]/term/term-name"/>
 								</xsl:otherwise>
 							</xsl:choose>
	 					</xsl:element>
 					</xsl:element>
 				</xsl:when>
 				<xsl:otherwise>
 					<xsl:element name="name">
 						<xsl:choose>
 							<xsl:when test="$componentsDoc//annotation[statement/external-id/text() = $componentId]/term/external-entry[@scheme-id = $scheme-id]/entry-name">
 								<xsl:value-of select="$componentsDoc//annotation[statement/external-id/text() = $componentId]/term/external-entry[@scheme-id = $scheme-id]/entry-name"/> 							
 							</xsl:when>
 							<xsl:otherwise>
 								<xsl:value-of select="$componentsDoc//annotation[statement/external-id/text() = $componentId][1]/term/term-name"/>
 							</xsl:otherwise>
 						</xsl:choose>
 					</xsl:element>
 				</xsl:otherwise>
 			</xsl:choose>

			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="name[parent::component]"/>
	
	<!-- copy everything -->
	<xsl:template match="@*|node()">
	    <xsl:copy>
	        <xsl:apply-templates select="@*|node()"/>
	    </xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*[name()!='xmlns:xi' ] ">
	    <xsl:copy>
	        <xsl:apply-templates select="@*"/>
	    </xsl:copy>
	</xsl:template>
    
        
</xsl:stylesheet>

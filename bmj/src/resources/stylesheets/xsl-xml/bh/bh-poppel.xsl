<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	version="2.0">
	
	<xsl:output method="xml" indent="yes" name="xmlOutput" encoding="UTF-8"/>

	<xsl:param name="metapath"/>
	<xsl:param name="metapath-base"/>
	<xsl:param name="topresourcepath"/>
	<xsl:param name="source"/>
	<xsl:param name="language"/>
	<xsl:param name="todays-date-iso"/>
	
	<xsl:strip-space elements="*"/>
	
	
	<!-- Xinclude stuff START -->
	
	<xsl:template name="xinclude-copy-attributes">
		<xsl:param name="version"/>
		<xsl:param name="abstract-id"/>
		<xsl:param name="instance-id"/>
		<xsl:param name="base-version"/>
		<xsl:param name="base-instance-id"/>
		<xsl:for-each select="./@*[name()!='xsi:noNamespaceSchemaLocation']">
			<xsl:copy-of select="." />
		</xsl:for-each>
		<xsl:if test="$version != ''">
			<xsl:attribute name="version" select="$version"/>
		</xsl:if>
		<xsl:if test="$abstract-id != ''">
			<xsl:attribute name="abstract-id" select="$abstract-id"/>
		</xsl:if>
		<xsl:if test="$instance-id != ''">
			<xsl:attribute name="instance-id" select="$instance-id"/>
		</xsl:if>
		<xsl:if test="$base-version != ''">
			<xsl:attribute name="base-version" select="$base-version"/>
		</xsl:if>
		<xsl:if test="$base-instance-id != ''">
			<xsl:attribute name="base-instance-id" select="$base-instance-id"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="//xi:include">
				<xsl:variable name="resolved-doc">
					<xsl:apply-templates mode="xinclude" />
				</xsl:variable>
				<xsl:apply-templates select="$resolved-doc" mode="normal" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="/" mode="normal">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="node()" mode="xinclude">
		<xsl:param name="version"/>
		<xsl:param name="abstract-id"/>
		<xsl:param name="instance-id"/>
		<xsl:param name="base-version"/>
		<xsl:param name="base-instance-id"/>
		<xsl:copy>
			<xsl:call-template name="xinclude-copy-attributes" >
				<xsl:with-param name="version" select="$version"/>
				<xsl:with-param name="abstract-id" select="$abstract-id"/>
				<xsl:with-param name="instance-id" select="$instance-id"/>
				<xsl:with-param name="base-version" select="$base-version"/>
				<xsl:with-param name="base-instance-id" select="$base-instance-id"/>
			</xsl:call-template>
			<xsl:apply-templates select="node()" mode="xinclude" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="xi:include" mode="xinclude">
		<xsl:variable name="xpath" select="@href" />
		<xsl:choose>
			<xsl:when test="$xpath != ''">
				<xsl:variable name="metadoc" select="document(translate(concat($metapath, replace(@href,'\.\./','/')),'\','/'))"></xsl:variable>
				<xsl:variable name="version" select="$metadoc//version"/>
				<xsl:variable name="abstract-id" select="$metadoc//abstract-id"/>
				<xsl:variable name="instance-id" select="$metadoc//id"/>
				
				<xsl:variable name="metadoc-base" select="document(translate(concat($metapath-base, replace(@href,'\.\./','/')),'\','/'))"></xsl:variable>
				<xsl:variable name="base-version" select="$metadoc-base//version"/>
				<xsl:variable name="base-instance-id" select="$metadoc-base//id"/>
				
				<xsl:apply-templates select="document($xpath)" mode="xinclude" >
					<xsl:with-param name="version" select="$version"/>
					<xsl:with-param name="abstract-id" select="$abstract-id"/>
					<xsl:with-param name="instance-id" select="$instance-id"/>
					<xsl:with-param name="base-version" select="$base-version"/>
					<xsl:with-param name="base-instance-id" select="$base-instance-id"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>Xinclude: Failed to get a value for the href= attribute of xi:include element.</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Xinclude stuff END-->
	
	<xsl:template match="/*">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="{$name}">
			
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">
				<xsl:text>http://schema.bmj.com/delivery/poppel/nlm-hybrid-article-patient.xsd</xsl:text>
			</xsl:attribute>
			
			<xsl:attribute name="article-type" select="@article-type"/>
			
			<!--  look up version number in meta-->
			<xsl:variable name="metadoc" select="document(translate(replace($topresourcepath,'bmjk','meta/bmjk'),'\','/'))"></xsl:variable>
			<xsl:attribute name="version"><xsl:value-of select="$metadoc//version"/></xsl:attribute>
			<xsl:attribute name="abstract-id"><xsl:value-of select="$metadoc//abstract-id"/></xsl:attribute>
			<xsl:attribute name="instance-id"><xsl:value-of select="$metadoc//id"/></xsl:attribute>
			<xsl:attribute name="language"><xsl:value-of select="$language"/></xsl:attribute>
			<xsl:attribute name="source"><xsl:value-of select="$source"/></xsl:attribute>
			
			<!--  find instance and version id of base file if translation -->
			<xsl:variable name="metadoc-file" select="replace($topresourcepath,$language,$source)"></xsl:variable>
			<xsl:variable name="metadoc-base" select="document(translate(replace($metadoc-file,'bmjk','meta/bmjk'),'\','/'))"></xsl:variable>
			<xsl:attribute name="base-version"><xsl:value-of select="$metadoc-base//version"/></xsl:attribute>
			<xsl:attribute name="base-instance-id"><xsl:value-of select="$metadoc-base//id"/></xsl:attribute>
			
			<!-- export date -->
			<xsl:element name="export-date"><xsl:value-of select="$todays-date-iso"/></xsl:element>
			
			<xsl:apply-templates select="*"/>
			
		</xsl:element>
	</xsl:template>

	<xsl:template match="*">
		<xsl:element name="{name()}">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>    
	
</xsl:stylesheet>

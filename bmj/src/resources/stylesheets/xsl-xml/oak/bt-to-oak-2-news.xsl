<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:bt="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"
	xmlns="http://www.bmjgroup.com/2007/07/BMJ-OAK">

	<xsl:output method="xml" indent="yes"/>

	<xsl:include href="../../xsl-lib/bmj-string-lib.xsl"/>
	
	<xsl:param name="filename"/>
	
	<xsl:param name="gloss-dir">gloss-dir</xsl:param>
	
	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:template match="section[@class='introduction']" priority="2" mode="#all">
		<section>
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
			
			<!-- xsl:apply-templates select="title"/ -->

			<xsl:apply-templates/>
			
		</section>
	</xsl:template>
	
	<xsl:template match="section" priority="1" mode="#all">
		<section>
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
		
<!--
			<xsl:apply-templates select="metadata"/>
-->			
			<!-- xsl:apply-templates select="title"/ -->
			
			<xsl:apply-templates/>
			
		</section>
	</xsl:template>
	
	<xsl:template match="strong" mode="#all">
		<b><xsl:apply-templates mode="#current"/></b>
	</xsl:template>
	
	<xsl:template match="em" mode="#all">
		<i><xsl:apply-templates mode="#current"/></i>
	</xsl:template>
	
	<xsl:template match="uri-link" mode="#all">
		<link>
			<xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
			<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="name(.)"/></xsl:attribute>
			<xsl:apply-templates mode="#current"/>
		</link>
	</xsl:template>	
	
	
	<xsl:template match="heading2">
		<title bt:oen="heading2">
			<xsl:apply-templates/>
		</title>
	</xsl:template>
	
	<xsl:template match="heading1">
		<title bt:oen="heading1">
			<xsl:apply-templates/>
		</title>
	</xsl:template>
	
	<xsl:template match="heading3">
		<title bt:oen="heading3">
			<xsl:apply-templates/>
		</title>
	</xsl:template>
	
	<xsl:template match="p" mode="#all">
		<!-- if this p has nothing in it, don't output it -->
		<xsl:choose>
			<xsl:when test="not(.='')">
				<p>
					<xsl:if test="$debug='true'"><xsl:comment>[visible p]</xsl:comment></xsl:if>
					<xsl:apply-templates mode="#current"/></p>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$debug='true'">
					<xsl:if test="$debug='true'"><xsl:comment>[hidden empty p]</xsl:comment></xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="title" mode="#all">
		<!-- if this title has nothing in it, don't output it -->
		
		<xsl:choose>
			<xsl:when test="not(.='')">
				<title>
				
					<xsl:if test="$debug='true'"><xsl:comment>[visible title]</xsl:comment></xsl:if>
					<xsl:apply-templates mode="#current"/></title>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:if test="$debug='true'">
					<xsl:if test="$debug='true'"><xsl:comment>[hidden empty title]</xsl:comment></xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="list" mode="#all">
		<list>
			<xsl:if test="$debug='true'">
				<xsl:comment>[list h1]</xsl:comment>
			</xsl:if>
			
			<xsl:apply-templates/>
		</list>
	</xsl:template>



	<!-- elements we supress -->

	<xsl:template match="b[ancestor::link | ancestor::caption]" mode="#all">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="i[ancestor::link | ancestor::caption]" mode="#all">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	<!-- match any other element, writing it out and calling apply-templates for any children -->
	<xsl:template match="*" mode="#all" priority="-1">
		<xsl:if test="$debug='true'">
			<xsl:comment>[*<xsl:value-of select="name()"/>]</xsl:comment>
		</xsl:if>

		<xsl:element name="{name()}">

			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
			
			
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>


</xsl:stylesheet>

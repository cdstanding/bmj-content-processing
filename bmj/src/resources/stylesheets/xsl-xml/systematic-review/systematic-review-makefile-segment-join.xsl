<?xml version="1.0"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	version="2.0">

	<xsl:output 
		method="xml" 
		encoding="UTF-8" 
		indent="yes" 
		omit-xml-declaration="no" 
		exclude-result-prefixes="xsi"/>

	<xsl:param name="systematic-review-makefile-segment-fileset"/>
	<xsl:param name="systematic-review-sections"/>
	
	<xsl:variable name="systematic-review-makefile-segment-joined">
		
		<xsl:element name="systematic-review-makefile-segment-joined">
			
			<xsl:for-each select="document(tokenize(translate($systematic-review-makefile-segment-fileset, '\\', '/'), ','))/sr-makefile-segment">
				
				<xsl:sort select="document(concat(translate($systematic-review-sections, '\\', '/'), substring-after(section-list/section-link[1]/@target, 'sections/')))//title"/>
				<xsl:sort select="normalize-space(title)"/>
				
				<xsl:copy-of select="."/>
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:variable>
	
	<xsl:template match="/">

		<xsl:element name="CONDITIONS">
			<xsl:attribute name="DOCTYPE">conditions_root</xsl:attribute>
			<xsl:attribute name="ID">conditions</xsl:attribute>
			<xsl:attribute name="TITLE">Conditions search</xsl:attribute>
			<xsl:attribute name="SHORTTITLE">Condition search</xsl:attribute>
			
			<xsl:apply-templates select="$systematic-review-makefile-segment-joined//sr-makefile-segment"/>
			
			<xsl:call-template name="process-speudo-sections"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="sr-makefile-segment">
		
		<!-- create primary section grouping --> 
		<xsl:if 
			test="
			section-list/section-link[1]/@target
			!= preceding-sibling::sr-makefile-segment[1]/section-list/section-link[1]/@target
			or position() = 1
			">
			
			<xsl:text disable-output-escaping="yes">&#13;&lt;SECTION</xsl:text>
			<xsl:text disable-output-escaping="yes"> DOCTYPE="section"</xsl:text>
			<xsl:text disable-output-escaping="yes"> ID="</xsl:text>
			<xsl:value-of select="document(concat(translate($systematic-review-sections, '\\', '/'), substring-after(section-list/section-link[1]/@target, 'sections/')))//@id"/>
			<xsl:text disable-output-escaping="yes">"</xsl:text>
			<xsl:text disable-output-escaping="yes"> TITLE="</xsl:text>
			<xsl:value-of select="document(concat(translate($systematic-review-sections, '\\', '/'), substring-after(section-list/section-link[1]/@target, 'sections/')))//title"/>
			<xsl:text disable-output-escaping="yes">"</xsl:text>
			<xsl:text disable-output-escaping="yes"> SHORTTITLE="</xsl:text>
			<xsl:value-of select="document(concat(translate($systematic-review-sections, '\\', '/'), substring-after(section-list/section-link[1]/@target, 'sections/')))//abridged-title"/>
			<xsl:text disable-output-escaping="yes">"</xsl:text>
			<xsl:text disable-output-escaping="yes"> URL="</xsl:text>
			<xsl:text>/ceweb/conditions/</xsl:text>
			<xsl:value-of select="document(concat(translate($systematic-review-sections, '\\', '/'), substring-after(section-list/section-link[1]/@target, 'sections/')))//@id"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="document(concat(translate($systematic-review-sections, '\\', '/'), substring-after(section-list/section-link[1]/@target, 'sections/')))//@id"/>
			<xsl:text>.jsp</xsl:text>
			<xsl:text disable-output-escaping="yes">"</xsl:text>
			<xsl:text disable-output-escaping="yes">&gt;&#13;</xsl:text>
			
		</xsl:if>
		
		<!-- create condition elements -->
		<xsl:element name="CONDITION">
			
			<xsl:attribute name="DOCTYPE">condition</xsl:attribute>
			<xsl:attribute name="ID" select="@id"/>
			<xsl:attribute name="PUBDATE" select="@pubdate"/>
			<xsl:attribute name="PUBSTATUS" select="@pubstatus"/>
			<xsl:attribute name="TITLE" select="normalize-space(title)"/>
			<xsl:attribute name="SHORTTITLE" select="normalize-space(abridged-title)"/>
			<xsl:attribute name="URL">
				<xsl:text>/ceweb/conditions/</xsl:text>
				<xsl:value-of select="document(concat(translate($systematic-review-sections, '\\', '/'), substring-after(section-list/section-link[1]/@target, 'sections/')))//@id"/>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="@id"/>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="@id"/>
				<xsl:text>.jsp</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="BAND" select="@band"/>
			
		</xsl:element>
		
		<!-- create closing primary section grouping 
			and create any secondary condition section-links -->
		<xsl:if 
			test="
			section-list/section-link[1]/@target
			!= following-sibling::sr-makefile-segment[1]/section-list/section-link[1]/@target
			or position() = last()
			">

			<!-- create secondary condition section-links -->
			<xsl:variable name="section-link-target" select="section-list/section-link[1]/@target"/>
			
			<xsl:for-each select="//sr-makefile-segment[section-list/section-link[@target = $section-link-target and position()!=1]]">
			
				<xsl:sort select="normalize-space(title)"/>
				
				<xsl:element name="CONDITION">
					<xsl:attribute name="DOCTYPE">cross_ref</xsl:attribute>
					<xsl:attribute name="ID" select="@id"/>
				</xsl:element>
				
			</xsl:for-each>
			
			<!-- close primary section grouping -->
			<xsl:text disable-output-escaping="yes">&#13;&lt;/SECTION&gt;&#13;</xsl:text>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="process-speudo-sections">
		
		<!-- create pseudo/secondary section grouping -->
		<xsl:for-each select="$systematic-review-makefile-segment-joined//section-list/section-link[position()!=1]">
			<xsl:sort select="@target"/>
			
			<xsl:variable name="section-link-target" select="@target"/>
			<xsl:variable name="section-link-id" select="generate-id(.)"/>
			<xsl:variable name="section-link-first" select="generate-id((//section-link[@target = $section-link-target])[position()=1])"/>
			
			<xsl:if test="not($systematic-review-makefile-segment-joined//section-list/section-link[position()=1 and @target = $section-link-target])">
				
				<xsl:if test="$section-link-id = $section-link-first">
				
					<!-- create secondary section grouping -->
					<xsl:text disable-output-escaping="yes">&#13;&lt;SECTION</xsl:text>
					<xsl:text disable-output-escaping="yes"> DOCTYPE="section_cross_ref"</xsl:text>
					<xsl:text disable-output-escaping="yes"> ID="</xsl:text>
					<xsl:value-of select="document(concat(translate($systematic-review-sections, '\\', '/'), substring-after($section-link-target, 'sections/')))//@id"/>
					<xsl:text disable-output-escaping="yes">"</xsl:text>
					<xsl:text disable-output-escaping="yes"> TITLE="</xsl:text>
					<xsl:value-of select="document(concat(translate($systematic-review-sections, '\\', '/'), substring-after($section-link-target, 'sections/')))//title"/>
					<xsl:text disable-output-escaping="yes">"</xsl:text>
					<xsl:text disable-output-escaping="yes"> SHORTTITLE="</xsl:text>
					<xsl:value-of select="document(concat(translate($systematic-review-sections, '\\', '/'), substring-after($section-link-target, 'sections/')))//abridged-title"/>
					<xsl:text disable-output-escaping="yes">"</xsl:text>
					<xsl:text disable-output-escaping="yes"> URL="</xsl:text>
					<xsl:text>/ceweb/conditions/</xsl:text>
					
					
					
					<xsl:value-of select="document(concat(translate($systematic-review-sections, '\\', '/'), substring-after($section-link-target, 'sections/')))//@id"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="document(concat(translate($systematic-review-sections, '\\', '/'), substring-after($section-link-target, 'sections/')))//@id"/>
					<xsl:text>.jsp</xsl:text>
					<xsl:text disable-output-escaping="yes">"</xsl:text>
					<xsl:text disable-output-escaping="yes">&gt;&#13;</xsl:text>
					
					<!-- create condition elements -->
					<xsl:for-each select="$systematic-review-makefile-segment-joined//sr-makefile-segment[.//section-link/@target = $section-link-target]">
						<xsl:element name="CONDITION">
							<xsl:attribute name="DOCTYPE">cross_ref</xsl:attribute>
							<xsl:attribute name="ID" select="@id"/>
						</xsl:element>
					</xsl:for-each>

					<!-- close secondary section grouping -->
					<xsl:text disable-output-escaping="yes">&#13;&lt;/SECTION&gt;&#13;</xsl:text>
					
				</xsl:if>
				
			</xsl:if>
			
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>

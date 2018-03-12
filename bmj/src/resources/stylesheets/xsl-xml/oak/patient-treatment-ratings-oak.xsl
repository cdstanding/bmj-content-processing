<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:xi="http://www.w3.org/2001/XInclude" 
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns="http://schema.bmj.com/delivery/oak"
	xmlns:tr="http://schema.bmj.com/delivery/oak-tr"
	xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
	version="2.0">

	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"
		/>
	
	<xsl:param name="proof"/>
	<xsl:param name="lang"/>
	<xsl:param name="xmlns"/>
	<xsl:param name="path"/>
	<xsl:param name="server"/>
	<xsl:param name="date-amended"/>
	<xsl:param name="date-updated"/>
	<xsl:param name="components"/>
	<xsl:param name="strings-variant-fileset"/>
	
	<xsl:param name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝ'"/>
	<xsl:param name="lower" select="'abcdefghijklmnopqrstuvwxyzáâãäåæçèéêëìíîïðñòóôõöøùúûüý'"/>
	
	<xsl:param name="base-url" select="xs:string('http://preview.www-besttreatments-org.internal.bmjgroup.com/btus/conditions/')" />

	<xsl:include href="generic-oak-redline-annotation.xsl"/>
	<xsl:include href="../../xsl-lib/strings/publication-labels-process-shared.xsl"/>
	
	<xsl:template match="/*">
		<xsl:variable name="name" select="name()"/>
		<xsl:element name="section">
			<xsl:namespace name="tr">http://schema.bmj.com/delivery/oak-tr</xsl:namespace>
			<xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
			<xsl:attribute name="xsi:schemaLocation">http://schema.bmj.com/delivery/oak http://schema.bmj.com/delivery/oak/bmj-oak-strict.xsd</xsl:attribute>
			<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="id" select="concat('_', @id)"/>
			<xsl:attribute name="xml:lang" select="$lang"/>
			
			<xsl:element name="title">
				<xsl:apply-templates select="title/node()"/>
			</xsl:element>
			
			<!--
				condition-id="6046" 
				condition-intro-id="14421" 
				condition-content-type="extended concise"
				crh-condition-type="chronic"
			-->
			
			<!--
				<creation-date>Sep 12, 2008</creation-date>
				<update-date>Sep 12, 2008</update-date>
				<export-date>Sep 12, 2008</export-date>
			-->
			
			<xsl:apply-templates select="treatment-ratings-set">
				<!--<xsl:sort select="heading"/>-->
			</xsl:apply-templates>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="treatment-ratings-set">
		<xsl:variable name="name" select="name()"/>
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:element name="title">
				<xsl:apply-templates select="heading/node()"/>
			</xsl:element>
			
			<!-- TODO add some warning if conditions below don't match -->
			<xsl:for-each 
				select="
				treatment-rating[@rating-score='treatments-that-work'][1] |
				treatment-rating[@rating-score='treatments-that-are-likely-to-work'][1] |
				treatment-rating[@rating-score='treatments-that-work-but-whose-harms-may-outweigh-benefits'][1] |
				treatment-rating[@rating-score='treatments-that-need-further-study'][1] |
				treatment-rating[@rating-score='treatments-that-are-unlikely-to-work'][1] |
				treatment-rating[@rating-score='treatments-that-are-likely-to-be-ineffective-or-harmful'][1] |
				treatment-rating[@rating-score='other-treatments'][1] |
				treatment-rating[@rating-score='usual-treatments'][1] 
				">
				<!--and @treatment-rating-type='rated']-->
				<!--treatment-rating[@treatment-rating-type='unusal']--> 
				
				<xsl:variable name="section" select="name()"/>
				<xsl:variable name="group" select="@rating-score"/>
				<xsl:variable name="name" select="concat($group, '-', $section, '-group')"/>
				
				<xsl:element name="section">
					
					<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
					<xsl:attribute name="class" select="$name" />
					
					<xsl:element name="title">
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="$name"/>
						</xsl:call-template>
					</xsl:element>
					
					<xsl:for-each select="parent::*/*[name()=$section and @*=$group]">
						<xsl:apply-templates select=".">
							<xsl:sort select="treatment-name"/>
						</xsl:apply-templates>
					</xsl:for-each>
					
				</xsl:element>
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="treatment-rating">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			
			<xsl:element name="title">
				
				<xsl:element name="link">
					<xsl:attribute name="class" select="xs:string('uri-link')" />
					<xsl:attribute name="target">
						<xsl:value-of select="concat($base-url, @reference-article-id, '.html')" />
					</xsl:attribute>
					<xsl:apply-templates select="treatment-name/node()" />
				</xsl:element>
				
				<xsl:if test="treatment-examples/treatment-example[string-length(normalize-space(.))!=0]">
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					
					<xsl:element name="inline">
						<xsl:attribute name="class" select="string('treatment-examples')" />
						
						<xsl:text>(</xsl:text>
						
						<xsl:for-each select="treatment-examples/treatment-example">
							
							<xsl:choose>
								
								<xsl:when test="position()=1">
									<xsl:apply-templates/>
								</xsl:when>
								
								<xsl:when test="position()!=last()">
									<!--<xsl:text>, </xsl:text>-->
									<xsl:text> | </xsl:text>
									<xsl:apply-templates/>
								</xsl:when>
								
								<xsl:otherwise>
									<!--<xsl:text> and </xsl:text>-->
									<xsl:text> | </xsl:text>
									<xsl:apply-templates/>
									<!--<xsl:text>.</xsl:text>-->
								</xsl:otherwise>
								
							</xsl:choose>
							
						</xsl:for-each>
						
						<xsl:text>)</xsl:text>
						
					</xsl:element>
				</xsl:if>
				
			</xsl:element>
			
			<!--
				reference-article-id="1000397709" 
				treatment-rating-type="rated" 
				ahfs-drug-class-id="20:28.18" 
				ndc-drug-id="01181968153"
				crh-treatment-type="drug"
			-->
			
			<xsl:apply-templates select="treatment-forms"/>
			<xsl:apply-templates select="description"/>
			<xsl:apply-templates select="effect"/>
			<xsl:apply-templates select="research"/>
			<xsl:apply-templates select="research/@evidence-score"/>
			<xsl:apply-templates select="harms"/>
			
		</xsl:element>
	</xsl:template> 

	<xsl:template match="
		treatment-forms |
		description | 
		effect | 
		research | 
		harms
		">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			
			<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:element name="p">
				
				<xsl:choose>
					
					<xsl:when test="treatment-form | harm">
						
						<xsl:for-each select="treatment-form | harm">
							
							<xsl:choose>
								
								<xsl:when test="position()=1">
									<xsl:apply-templates/>
								</xsl:when>
								
								<xsl:when test="position()!=last()">
									<!--<xsl:text>, </xsl:text>-->
									<xsl:text> | </xsl:text>
									<xsl:apply-templates/>
								</xsl:when>
								
								<xsl:otherwise>
									<!--<xsl:text> and </xsl:text>-->
									<xsl:text> | </xsl:text>
									<xsl:apply-templates/>
									<!--<xsl:text>. </xsl:text>-->
								</xsl:otherwise>
								
							</xsl:choose>
							
						</xsl:for-each>
						
					</xsl:when>
					
					<xsl:when test="$name = 'research' and @evidence-article-id[string-length(normalize-space(.))!=0]">
						
						<xsl:element name="link">
							<xsl:attribute name="class" select="xs:string('uri-link')" />
							<xsl:attribute name="target" select="concat($base-url, @evidence-article-id, '.html')" />
							<xsl:apply-templates/>
						</xsl:element>
						
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
					
				</xsl:choose>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="@evidence-score[string-length(.)!=0]">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			
			<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:element name="p">
				<xsl:value-of select="." />
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<!-- dev output test -->
	<xsl:template match="element()|@*">
		<xsl:comment select="concat('unmatched-', name())"/>
	</xsl:template>
	
</xsl:stylesheet>

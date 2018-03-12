<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xi xsi cals"
	version="2.0">
	
	<xsl:output
		method="xml"
		version="1.0"
		encoding="UTF-8"
		indent="yes"
		use-character-maps="custom-map-renderx"
		doctype-public="-//BMJ//DTD FO:ROOT//EN"
		doctype-system="http://www.renderx.com/Tests/validator/fo2000.dtd"/>
	
	<xsl:preserve-space elements=""/>
	<xsl:strip-space elements="fo:basic-link fo:inline fo:page-number-citation"/>
	
	<xsl:include href="common-bh-rtf-fo.xsl"/>
	
	<xsl:include href="patient-table-fo.xsl"/>
	
	<xsl:template match="/">
		<xsl:element name="fo:root" use-attribute-sets="">
			
			<xsl:element name="fo:layout-master-set" use-attribute-sets="">
				<xsl:element name="fo:simple-page-master" use-attribute-sets="">
					<xsl:attribute name="master-name">my-page</xsl:attribute>
					<xsl:element name="fo:region-body" use-attribute-sets="">
						<xsl:attribute name="margin">0.8in</xsl:attribute>
					</xsl:element>
					<xsl:element name="fo:region-before" use-attribute-sets="">
						<xsl:attribute name="region-name">header</xsl:attribute>
						<xsl:attribute name="extent">0.5in</xsl:attribute>
					</xsl:element>
					<xsl:element name="fo:region-after" use-attribute-sets="">
						<xsl:attribute name="region-name">footer</xsl:attribute>
						<xsl:attribute name="extent">0.5in</xsl:attribute>
					</xsl:element>
					<xsl:element name="fo:region-start" use-attribute-sets="">
						<xsl:attribute name="extent">0.8in</xsl:attribute>
					</xsl:element>
					<xsl:element name="fo:region-end" use-attribute-sets="">
						<xsl:attribute name="extent">0.8in</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:page-sequence" use-attribute-sets="">
				<xsl:attribute name="master-reference">my-page</xsl:attribute>
			
				<xsl:element name="fo:static-content" use-attribute-sets="">
					<xsl:attribute name="flow-name">header</xsl:attribute>
					<xsl:element name="fo:retrieve-marker">
						<xsl:attribute name="retrieve-class-name">header_marker</xsl:attribute>
						<xsl:attribute name="retrieve-position">first-including-carryover</xsl:attribute>
					</xsl:element>
				</xsl:element>
				
				<xsl:element name="fo:static-content" use-attribute-sets="">
					<xsl:attribute name="flow-name">footer</xsl:attribute>
					<xsl:call-template name="footer_copyright"/>
					<xsl:element name="fo:retrieve-marker">
						<xsl:attribute name="retrieve-class-name">footer_published_date</xsl:attribute>
						<xsl:attribute name="retrieve-position">last-ending-within-page</xsl:attribute>
					</xsl:element>					
					<xsl:call-template name="footer_page_number"/>
				</xsl:element>
				
				<xsl:element name="fo:flow" use-attribute-sets="">
					<xsl:attribute name="flow-name">xsl-region-body</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:element name="fo:block" use-attribute-sets="">
							<xsl:attribute name="padding-before">10pt</xsl:attribute>			
							<xsl:attribute name="text-align">right</xsl:attribute>
							<xsl:element name="fo:external-graphic">
								<xsl:attribute name="content-height">12%</xsl:attribute>
								<xsl:attribute name="content-width">12%</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:text>url('</xsl:text><xsl:value-of select="$image-logo"/><xsl:text>')</xsl:text>
								</xsl:attribute>
							</xsl:element>		
						</xsl:element>
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:attribute name="font-weight">bold</xsl:attribute>
						<xsl:attribute name="font-size">14pt</xsl:attribute>
						<xsl:attribute name="space-after">5pt</xsl:attribute>
						Patient information from the BMJ Group
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:attribute name="space-after">5pt</xsl:attribute>
						<xsl:element name="fo:inline" use-attribute-sets="topic-title">
							<xsl:value-of select="//article-title"/>
						</xsl:element>					
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:element name="fo:marker">
							<xsl:attribute name="marker-class-name">header_marker</xsl:attribute>
							<xsl:element name="fo:block" use-attribute-sets="">
								<xsl:attribute name="padding-before">20pt</xsl:attribute>
								<xsl:attribute name="text-align">center</xsl:attribute>
								<xsl:attribute name="font-weight">bold</xsl:attribute>
								<xsl:value-of select="//article-title"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:apply-templates select="//body"/>				
					</xsl:element>

					<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
						<xsl:element name="fo:leader">
							<xsl:attribute name="leader-length">90%</xsl:attribute>
						</xsl:element>
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:apply-templates select="//article-references"/>				
					</xsl:element>
										
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:attribute name="id">theEnd</xsl:attribute>
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:call-template name="declaration_text"/>
					</xsl:element>

					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:element name="fo:marker">
							<xsl:attribute name="marker-class-name">footer_published_date</xsl:attribute>
							<xsl:element name="fo:block" use-attribute-sets="">
								<xsl:attribute name="font-size">8pt</xsl:attribute>
								Last published: <xsl:value-of select="$published-date"/>				
							</xsl:element>
						</xsl:element>
					</xsl:element>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="body">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="introduction">
		<xsl:element name="fo:block" use-attribute-sets="bold">
			<xsl:apply-templates select="sec">
				<xsl:with-param name="sectionDepth">0</xsl:with-param>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
		
	<xsl:template match="content">
		<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
			<xsl:attribute name="id"><xsl:value-of select="name()"/></xsl:attribute>	
			<xsl:apply-templates select="sec">
				<xsl:with-param name="sectionDepth">0</xsl:with-param>
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
		
</xsl:stylesheet>

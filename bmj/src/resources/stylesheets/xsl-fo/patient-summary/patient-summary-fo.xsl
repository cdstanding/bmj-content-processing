<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
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
	
	<xsl:param name="image-logo"/>
	<xsl:param name="image-footer"/>
	<xsl:param name="published-date"/>
	
	<xsl:include href="../../xsl-entities/custom-map-renderx.xsl"/>
		
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
						<xsl:element name="fo:marker">
							<xsl:attribute name="marker-class-name">header_marker</xsl:attribute>
							<xsl:element name="fo:block" use-attribute-sets="">
								<xsl:attribute name="padding-before">10pt</xsl:attribute>			
								<xsl:attribute name="text-align">right</xsl:attribute>
								<xsl:element name="fo:external-graphic">
									<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
									<xsl:attribute name="content-height">20%</xsl:attribute>
									<xsl:attribute name="content-width">20%</xsl:attribute>
									<xsl:attribute name="src">
										<xsl:text>url('</xsl:text><xsl:value-of select="$image-logo"/><xsl:text>')</xsl:text>
									</xsl:attribute>
								</xsl:element>		
							</xsl:element>
						</xsl:element>
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:attribute name="font-weight">bold</xsl:attribute>
						<xsl:attribute name="font-size">14pt</xsl:attribute>
						<xsl:attribute name="space-after">5pt</xsl:attribute>
						Patient leaflets from the BMJ Group
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:attribute name="space-after">5pt</xsl:attribute>
						<xsl:element name="fo:inline" use-attribute-sets="topic-title">
							<xsl:value-of select="//topic-info/title"/>
						</xsl:element>					
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:element name="fo:marker">
							<xsl:attribute name="marker-class-name">header_marker</xsl:attribute>
							<xsl:element name="fo:block" use-attribute-sets="">
								<xsl:attribute name="padding-before">20pt</xsl:attribute>
								<xsl:attribute name="text-align">center</xsl:attribute>
								<xsl:attribute name="font-weight">bold</xsl:attribute>
								<xsl:value-of select="//topic-info/title"/>
							</xsl:element>
						</xsl:element>
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:apply-templates select="//topic-info"/>				
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
	
	<xsl:template name="footer_copyright">
		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:text disable-output-escaping="yes">&#xA9;</xsl:text> 
			BMJ Publishing Group Limited 2010. All rights reserved.
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="footer_page_number">
		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="color">#CCCCCC</xsl:attribute>
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			page <fo:page-number/> of  <fo:page-number-citation ref-id="theEnd"/>
		</xsl:element>	
	</xsl:template>
	
	<xsl:template name="declaration_text">
		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="space-before">20pt</xsl:attribute>
			<xsl:element name="fo:external-graphic">
				<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
				<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
				<xsl:attribute name="height">0.075in</xsl:attribute>
				<xsl:attribute name="width">6.4in</xsl:attribute>
				<xsl:attribute name="scaling">non-uniform</xsl:attribute>
				<xsl:attribute name="src">
					<xsl:text>url('</xsl:text><xsl:value-of select="$image-footer"/><xsl:text>')</xsl:text>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="keep-together">always</xsl:attribute>
			<xsl:attribute name="space-before">5pt</xsl:attribute>
			<xsl:attribute name="font-size">9pt</xsl:attribute>
			This information is aimed at a UK patient audience. This information however does not replace medical advice.
			<xsl:element name="fo:block" use-attribute-sets=""/>
			If you have a medical problem please see your doctor. Please see our full Conditions of Use for this content 
			<xsl:element name="fo:basic-link">
				<xsl:attribute name="external-destination">
					<xsl:text>url('http://besttreatments.bmj.com/btuk/about/12.html')</xsl:text>
				</xsl:attribute>
				<xsl:element name="fo:inline" use-attribute-sets="link">
					<xsl:text>http://besttreatments.bmj.com/btuk/about/12.html.</xsl:text>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:attribute name="padding-before">5pt</xsl:attribute>			
			<xsl:attribute name="text-align">right</xsl:attribute>
			<xsl:element name="fo:external-graphic">
				<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
				<xsl:attribute name="content-height">20%</xsl:attribute>
				<xsl:attribute name="content-width">20%</xsl:attribute>
				<xsl:attribute name="src">
					<xsl:text>url('</xsl:text><xsl:value-of select="$image-logo"/><xsl:text>')</xsl:text>
				</xsl:attribute>
			</xsl:element>		
		</xsl:element>		
	</xsl:template>
	
	
	<xsl:template match="topic-info">
		<xsl:apply-templates select="illustration"/>
		<xsl:apply-templates select="introduction"/>
		<xsl:apply-templates select="body-text"/>
	</xsl:template>
	
	
	<xsl:template match="illustration">
		<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template match="introduction">
		<xsl:element name="fo:block" use-attribute-sets="bold">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="p">
		<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="strong">
		<xsl:element name="fo:inline" use-attribute-sets="bold">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="sub">
		<xsl:element name="fo:inline" use-attribute-sets="sub">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="sup">
		<xsl:element name="fo:inline" use-attribute-sets="sup">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="heading1">
		<xsl:element name="fo:block"
			use-attribute-sets="heading1 space-before space-after keep-with-next">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="heading2">
		<xsl:element name="fo:block"
			use-attribute-sets="heading2 space-before space-after keep-with-next">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="heading3">
		<xsl:element name="fo:block"
			use-attribute-sets="heading3 space-before space-after keep-with-next">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="em">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="list">
		<xsl:element name="fo:list-block">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="item">
		<xsl:element name="fo:list-item" use-attribute-sets="space-before-small space-after-small">
			<fo:list-item-label end-indent="label-end()">
				<fo:block>&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="title">
		<xsl:element name="fo:block" use-attribute-sets="space-before space-after">Nav: <xsl:value-of
			select="."/></xsl:element>
	</xsl:template>
	
	<xsl:template match="headline">
		<xsl:element name="fo:block" use-attribute-sets="headline-title space-before space-after">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="byline">
		<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	
	<!-- Attribute sets -->
	<xsl:attribute-set name="link">
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
		<xsl:attribute name="color">#0D519F</xsl:attribute>
		<!-- blue -->
	</xsl:attribute-set>
	
	<xsl:attribute-set name="drug">
		<xsl:attribute name="color">#5E8F39</xsl:attribute>
		<!-- dark green -->
	</xsl:attribute-set>
	
	
	<xsl:attribute-set name="bold">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="heading1">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">#990000</xsl:attribute>
		<!-- red -->
		<xsl:attribute name="font-size">14pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="heading2">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="heading3">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">#990000</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="topic-title">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">24pt</xsl:attribute>
		<xsl:attribute name="color">#0000FF</xsl:attribute>
		<!-- bluer blue -->
	</xsl:attribute-set>
	
	<xsl:attribute-set name="headline-title">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">15pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="section-title">
		<xsl:attribute name="text-transform">uppercase</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="space-before">
		<xsl:attribute name="space-before.minimum">5pt</xsl:attribute>
		<xsl:attribute name="space-before.maximum">20pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">10pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="space-after">
		<xsl:attribute name="space-after.minimum">5pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">20pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">10pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="space-before-small">
		<xsl:attribute name="space-before.minimum">3pt</xsl:attribute>
		<xsl:attribute name="space-before.maximum">10pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">5pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="space-after-small">
		<xsl:attribute name="space-after.minimum">3pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">10pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">5pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="keep-with-next">
		<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="image">
		<xsl:attribute name="space-after.minimum">5pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">20pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">10pt</xsl:attribute>
	</xsl:attribute-set>
	
	
	<xsl:attribute-set name="sub">
		<xsl:attribute name="baseline-shift">sub</xsl:attribute>
		<xsl:attribute name="font-size">8pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="sup">
		<xsl:attribute name="baseline-shift">super</xsl:attribute>
		<xsl:attribute name="font-size">8pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="blue-background">
		<xsl:attribute name="background-color">#C5C9E6</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="leader">
		<xsl:attribute name="leader-length">5in</xsl:attribute>
		<xsl:attribute name="leader-pattern">rule</xsl:attribute>
		<xsl:attribute name="alignment-baseline">middle</xsl:attribute>
		<xsl:attribute name="rule-thickness">0.5pt</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="page-id">
		<xsl:attribute name="color">#CCCCCC</xsl:attribute>
		<xsl:attribute name="font-size">7pt</xsl:attribute>
	</xsl:attribute-set>
	
</xsl:stylesheet>

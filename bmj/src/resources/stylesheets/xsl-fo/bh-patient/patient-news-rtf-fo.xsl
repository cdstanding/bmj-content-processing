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
		
	<xsl:param name="image-logo"/>
	<xsl:param name="image-footer"/>
	<xsl:param name="data-folder"/>
	<xsl:param name="published-date"/>
	<xsl:param name="language"/>
	
	<xsl:variable name="audience">
		<xsl:choose>
			<xsl:when test="$language = 'en-gb'">
				<xsl:text>UK</xsl:text>
			</xsl:when>
			<xsl:when test="$language = 'en-us'">
				<xsl:text>US</xsl:text>
			</xsl:when>			
			<xsl:otherwise>
				<xsl:value-of select="$language"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>		
	
	<xsl:variable name="bhurl">
		<xsl:text>http://besthealth.bmj.com</xsl:text>				
	</xsl:variable>		
	
	<xsl:include href="../../xsl-entities/custom-map-renderx.xsl"/>
	
	<xsl:variable name="publicationYear" select="substring-after($published-date, ', ')"/>
	
	<xsl:include href="patient-table-fo.xsl"/>
	
	
	<xsl:template match="/">
		<xsl:element name="fo:root">
			
			<xsl:element name="fo:layout-master-set">
				<xsl:element name="fo:simple-page-master">
					<xsl:attribute name="master-name">my-page</xsl:attribute>
					<xsl:element name="fo:region-body">
						<xsl:attribute name="margin">0.8in</xsl:attribute>
					</xsl:element>
					<xsl:element name="fo:region-before">
						<xsl:attribute name="region-name">header</xsl:attribute>
						<xsl:attribute name="extent">0.5in</xsl:attribute>
					</xsl:element>
					<xsl:element name="fo:region-after">
						<xsl:attribute name="region-name">footer</xsl:attribute>
						<xsl:attribute name="extent">0.5in</xsl:attribute>
					</xsl:element>
					<xsl:element name="fo:region-start">
						<xsl:attribute name="extent">0.8in</xsl:attribute>
					</xsl:element>
					<xsl:element name="fo:region-end">
						<xsl:attribute name="extent">0.8in</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:page-sequence">
				<xsl:attribute name="master-reference">my-page</xsl:attribute>
			
				<xsl:element name="fo:static-content">
					<xsl:attribute name="flow-name">header</xsl:attribute>
					<xsl:element name="fo:retrieve-marker">
						<xsl:attribute name="retrieve-class-name">header_marker</xsl:attribute>
						<xsl:attribute name="retrieve-position">first-including-carryover</xsl:attribute>
					</xsl:element>
				</xsl:element>
				
				<xsl:element name="fo:static-content">
					<xsl:attribute name="flow-name">footer</xsl:attribute>
					<xsl:call-template name="footer_copyright"/>
					<xsl:element name="fo:retrieve-marker">
						<xsl:attribute name="retrieve-class-name">footer_published_date</xsl:attribute>
						<xsl:attribute name="retrieve-position">last-ending-within-page</xsl:attribute>
					</xsl:element>					
					<xsl:call-template name="footer_page_number"/>
				</xsl:element>
				
				<xsl:element name="fo:flow">
					<xsl:attribute name="flow-name">xsl-region-body</xsl:attribute>
					
					<!-- removed image to keep file size down -->
					<!-- xsl:element name="fo:block">
						<xsl:element name="fo:block">
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
					</xsl:element -->

					<xsl:element name="fo:block" use-attribute-sets="space-before">
						<xsl:attribute name="font-family">Arial</xsl:attribute>
						<xsl:attribute name="font-size">10.5pt</xsl:attribute>
						Exported: <xsl:value-of select="//custom-meta[child::meta-name[text() = 'export-date']]/meta-value"/>
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="space-after-hugh">
						<xsl:attribute name="font-family">Arial</xsl:attribute>
						<xsl:attribute name="font-size">10.5pt</xsl:attribute>
						Embargo date: <xsl:value-of select="//custom-meta[child::meta-name[text() = 'embargo-date']]/meta-value"/>
					</xsl:element>

					<xsl:element name="fo:block" use-attribute-sets="space-after space-before-hugh">
						<xsl:attribute name="border-bottom-width">thin</xsl:attribute>
						<xsl:attribute name="border-bottom-style">solid</xsl:attribute>
						<xsl:attribute name="font-family">Arial</xsl:attribute>
						<xsl:attribute name="font-size">15pt</xsl:attribute>
						<xsl:element name="fo:inline">
							<xsl:value-of select="/article/front/article-meta/title-group/article-title"/>
						</xsl:element>					
					</xsl:element>

					<xsl:element name="fo:block"  use-attribute-sets="space-after space-before">
						<xsl:attribute name="font-family">Arial</xsl:attribute>
						<xsl:attribute name="font-size">10.5pt</xsl:attribute>
						By <xsl:value-of select="//custom-meta[child::meta-name[text() = 'byline']]/meta-value"/>
					</xsl:element>
					
					<xsl:apply-templates select="/article/body/introduction"/>				

					<xsl:apply-templates select="/article/body/content"/>				

					<xsl:element name="fo:block">
						<xsl:attribute name="id">theEnd</xsl:attribute>
					</xsl:element>
					
					<xsl:element name="fo:block">
						<xsl:element name="fo:marker">
							<xsl:attribute name="marker-class-name">footer_published_date</xsl:attribute>
							<xsl:element name="fo:block">
								<xsl:attribute name="font-size">8pt</xsl:attribute>
								Last published: <xsl:value-of select="$published-date"/>				
							</xsl:element>
						</xsl:element>
					</xsl:element>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="content">

		<xsl:for-each select="./sec">
			<xsl:element name="fo:block">
				<xsl:attribute name="font-family">Arial</xsl:attribute>
				<xsl:attribute name="font-size">10.5pt</xsl:attribute>
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:for-each>

	</xsl:template>
	
	<xsl:template match="introduction">
		<xsl:element name="fo:block" use-attribute-sets="space-after space-before-hugh">
			<xsl:attribute name="font-family">Arial</xsl:attribute>
			<xsl:attribute name="font-size">10.5pt</xsl:attribute>
			<xsl:for-each select="./sec/p">
				<xsl:apply-templates/>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template name="footer_copyright">
		<xsl:element name="fo:block">
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:text disable-output-escaping="yes">&#xA9;</xsl:text> 
			BMJ Publishing Group Limited <xsl:value-of select="$publicationYear"/>. All rights reserved.
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="footer_page_number">
		<xsl:element name="fo:block">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="color">#CCCCCC</xsl:attribute>
			<xsl:attribute name="font-size">8pt</xsl:attribute>
			page <fo:page-number/> of  <fo:page-number-citation ref-id="theEnd"/>
		</xsl:element>	
	</xsl:template>

	<xsl:template match="sec">
		<xsl:element name="fo:block">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	
	<xsl:template match="title">
		<xsl:element name="fo:block" use-attribute-sets="heading1 keep-with-next">
			<xsl:apply-templates/>
		</xsl:element>		
	</xsl:template>
	
	<xsl:template match="p">
		<xsl:element name="fo:block" use-attribute-sets="space-before space-after">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="p" mode="gloss">
		<xsl:element name="fo:block">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
		
	<xsl:template match="bold">
		<xsl:element name="fo:inline" use-attribute-sets="bold">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="ext-link">
		<xsl:apply-templates/>
	</xsl:template>
    	
	<xsl:template match="italic">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="list">
	    <xsl:element name="fo:list-block"><xsl:apply-templates/></xsl:element>
	</xsl:template>
    
	<xsl:template match="list-item">
	        <xsl:element name="fo:list-item" use-attribute-sets="space-before-small space-after-small">
	            <fo:list-item-label end-indent="label-end()">
	                <fo:block>&#x2022;</fo:block>
	            </fo:list-item-label>
	            <fo:list-item-body start-indent="body-start()">
	                <fo:block><xsl:apply-templates/></fo:block>
	            </fo:list-item-body>
	        </xsl:element>
	</xsl:template>
	
	<xsl:template match="article-title">
		<xsl:element name="fo:block" use-attribute-sets="space-before space-after">Nav: <xsl:value-of select="."/></xsl:element>
	</xsl:template>

	<xsl:template match="xref[@ref-type='fig']">
		<xsl:variable name="figureid" select="@rid"/>
		<xsl:element name="fo:block" use-attribute-sets="space-after-small">
			<xsl:attribute name="padding-before">5pt</xsl:attribute>			
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:element name="fo:external-graphic">
				<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
				<xsl:attribute name="content-height">60%</xsl:attribute>
				<xsl:attribute name="content-width">60%</xsl:attribute>
				<xsl:attribute name="src">
					<xsl:text>url('</xsl:text><xsl:value-of select="$data-folder"/><xsl:text>/</xsl:text><xsl:value-of select="//article-figures/figure[@id=$figureid]/@image"/><xsl:text>')</xsl:text>
				</xsl:attribute>
			</xsl:element>		
			<xsl:element name="fo:inline" use-attribute-sets="font-8pt pale-grey-background">
				<xsl:attribute name="text-align">center</xsl:attribute>
				<xsl:apply-templates select="//article-figures/figure[@id=$figureid]/caption"/>
			</xsl:element>			
		</xsl:element>	
	</xsl:template>

	<xsl:template match="xref[@ref-type='gloss']">
		<xsl:variable name="glossid" select="@rid"/>
		<xsl:element name="fo:basic-link">
			<xsl:attribute name="internal-destination"><xsl:value-of select="@rid"/></xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
			<xsl:attribute name="color">brown</xsl:attribute>
			<xsl:apply-templates select="//article-glossaries/gloss[@id=$glossid]/term"/>
		</xsl:element>
	</xsl:template>
		
	<xsl:template match="xref[@ref-type='bibr']">
		<xsl:variable name="id"><xsl:value-of select="@rid"/></xsl:variable>
		<xsl:element name="fo:basic-link"  use-attribute-sets="ref-link">
			<xsl:attribute name="internal-destination">
				<xsl:value-of select="@rid"/>
			</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>
			<xsl:text>[</xsl:text>
		   	        <xsl:call-template name="findLinkPosition">
			            <xsl:with-param name="target"><xsl:value-of select="@rid"/></xsl:with-param>
			            <xsl:with-param name="type">bibr</xsl:with-param>
			        </xsl:call-template>
   			<xsl:text>]</xsl:text>
		</xsl:element>		
	</xsl:template>

    	<xsl:template match="xref[@ref-type='patient-treatment']">
		<xsl:choose>
			<xsl:when test="//article[@article-type = 'patient-topic']/@id = @topic-id">
				<xsl:element name="fo:basic-link"  use-attribute-sets="link">
					<xsl:attribute name="internal-destination">
						<xsl:value-of select="@rid"/>
						<xsl:text>/</xsl:text>
						<xsl:value-of select="@section"/>
					</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>						
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
    	</xsl:template>

	<xsl:template match="xref[@ref-type='patient-topic']">
		<xsl:choose>
			<xsl:when test="//article[@article-type = 'patient-topic']/@id = @rid">
				<xsl:element name="fo:basic-link" use-attribute-sets="link">
					<xsl:attribute name="internal-destination">
						<xsl:value-of select="@section"/>
					</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>						
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
    	</xsl:template>
        
	    
	<xsl:template match="caption">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template name="findLinkPosition">
	        <xsl:param name="target"/>
	        <xsl:param name="type"/>        
	        <xsl:for-each select="//xref[@ref-type=$type and not(@rid = preceding::xref/@rid)]">
	            <xsl:if test="$target = @rid">
	                <xsl:value-of select="position()"/>
	            </xsl:if>
	        </xsl:for-each>
	</xsl:template>
    
    	<!-- Attribute sets -->
	<xsl:attribute-set name="link">
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
		<xsl:attribute name="color">#0D519F</xsl:attribute>
		<!-- blue -->
	</xsl:attribute-set>

	<xsl:attribute-set name="ref-link">
		<xsl:attribute name="vertical-align">super</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
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
		<xsl:attribute name="color">#008000</xsl:attribute>
		<xsl:attribute name="font-family">Arial</xsl:attribute>
		<xsl:attribute name="font-size">13pt</xsl:attribute>
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
		<xsl:attribute name="space-before.minimum">2pt</xsl:attribute>
		<xsl:attribute name="space-before.maximum">7pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">5pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="space-before-hugh">
		<xsl:attribute name="space-before.minimum">10pt</xsl:attribute>
		<xsl:attribute name="space-before.maximum">20pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">15pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="space-after">
		<xsl:attribute name="space-after.minimum">2pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">7pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">5pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="space-after-hugh">
		<xsl:attribute name="space-after.minimum">10pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">20pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">15pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="space-before-small">
		<xsl:attribute name="space-before.minimum">1pt</xsl:attribute>
		<xsl:attribute name="space-before.maximum">5pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">3pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="space-after-small">
		<xsl:attribute name="space-after.minimum">1pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">5pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">3pt</xsl:attribute>
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

	<xsl:attribute-set name="grey-background">
		<xsl:attribute name="background-color">#CCCCCC</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="pale-blue-background">
		<xsl:attribute name="background-color">#E6EEEE</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="pale-grey-background">
		<xsl:attribute name="background-color">#f4f4f4</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="reference-title">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>				
	</xsl:attribute-set>			

	<xsl:attribute-set name="font-8pt">
		<xsl:attribute name="font-size">8pt</xsl:attribute>
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

	<xsl:attribute-set name="further-information-box">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="border-width">1mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name='border'>
		<xsl:attribute name='border-before-style'>solid</xsl:attribute>
		<xsl:attribute name='border-after-style'>solid</xsl:attribute>
		<xsl:attribute name='border-start-style'>solid</xsl:attribute>
		<xsl:attribute name='border-end-style'>solid</xsl:attribute>
		
		<xsl:attribute name='border-before-width'>.1mm</xsl:attribute>
		<xsl:attribute name='border-after-width'>.1mm</xsl:attribute>
		<xsl:attribute name='border-start-width'>.1mm</xsl:attribute>
		<xsl:attribute name='border-end-width'>.1mm</xsl:attribute>
	</xsl:attribute-set>		


		
	<xsl:attribute-set name="padding-small">
		<xsl:attribute name="padding-left">5pt</xsl:attribute>
		<xsl:attribute name="padding-right">5pt</xsl:attribute>
		<xsl:attribute name="padding-top">5pt</xsl:attribute>
		<xsl:attribute name="padding-bottom">5pt</xsl:attribute>				
	</xsl:attribute-set>


</xsl:stylesheet>

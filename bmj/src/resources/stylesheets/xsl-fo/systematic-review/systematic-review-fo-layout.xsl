<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
	exclude-result-prefixes="rx xi xsi cals"
	version="2.0">
	
	<xsl:template name="process-layout-meta-info">
		
		<xsl:element name="rx:meta-info" use-attribute-sets="">
			
			<xsl:element name="rx:meta-field" use-attribute-sets="">
				<xsl:attribute name="name" select="string('author')"/>
				<xsl:attribute name="value" select="normalize-space(/systematic-review/info/collective-name)"/>
			</xsl:element>
			
			<xsl:choose>
				
				<xsl:when test="contains($proof, 'cr-health')">
					
					<xsl:element name="rx:meta-field" use-attribute-sets="">
						<xsl:attribute name="name" select="string('title')"/>
					
						<xsl:attribute name="value">
							
							<xsl:choose>
								
								<!--<xsl:when test="nothing"/>-->
								<xsl:when test="string-length(normalize-space(legacytag:getPatientTopicTitleFromCEId(concat('_', $cid), 'en-us')))!=0">
									<xsl:value-of select="legacytag:getPatientTopicTitleFromCEId(concat('_', $cid), 'en-us')"/>
								</xsl:when>
								
								<xsl:otherwise>
									<xsl:attribute name="value" select="normalize-space(/systematic-review/info/title)"/>
								</xsl:otherwise>
								
							</xsl:choose>
							
							<xsl:text> - </xsl:text>The clinical evidence</xsl:attribute>
						
					</xsl:element>
					
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:element name="rx:meta-field" use-attribute-sets="">
						<xsl:attribute name="name" select="string('title')"/>
						<xsl:attribute name="value" select="normalize-space(/systematic-review/info/title)"/>
					</xsl:element>
				</xsl:otherwise>
				
			</xsl:choose>
			
			<xsl:element name="rx:meta-field" use-attribute-sets="">
				<xsl:attribute name="name" select="string('creator')"/>
				
				<xsl:attribute name="value">© BMJ Publishing Group Ltd<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:value-of select="substring-before($date, '-')"/>
					
					<xsl:text disable-output-escaping="yes">. </xsl:text>All rights reserved<xsl:text disable-output-escaping="yes">. </xsl:text>
					
				</xsl:attribute>
				
			</xsl:element>
			
			<xsl:element name="rx:meta-field" use-attribute-sets="">
				<xsl:attribute name="name" select="string('subject')"/>
				<xsl:attribute name="value" select="normalize-space($primary-section-title)"/>
			</xsl:element>
			
			<!--<xsl:element name="rx:meta-field" use-attribute-sets="">
				<xsl:attribute name="name" select="string('keywords')"/>
				<xsl:attribute name="value" select="normalize-space()"/>
			</xsl:element>-->
			
		</xsl:element>
			
	</xsl:template>
	
	<xsl:template name="process-layout-master-set">
	
		<xsl:comment>layout-master-set</xsl:comment>
		
		<xsl:element name="fo:layout-master-set" use-attribute-sets="">
		
			<xsl:element name="fo:simple-page-master" use-attribute-sets="page-margin page-orientation-portrait">
				<xsl:attribute name="master-name">first-page</xsl:attribute>
				<xsl:element name="fo:region-body" use-attribute-sets="body-margin">
					<xsl:attribute name="region-name">xsl-region-body</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-before" use-attribute-sets="">
					<xsl:attribute name="region-name">first-header</xsl:attribute>
					<xsl:attribute name="extent">0pt</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-after" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">first-footer</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-start" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-left</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-end" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-right</xsl:attribute>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:simple-page-master" use-attribute-sets="page-margin page-orientation-portrait">
				<xsl:attribute name="master-name">all-pages</xsl:attribute>
				<xsl:element name="fo:region-body" use-attribute-sets="body-margin">
					<xsl:attribute name="region-name">xsl-region-body</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-before" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-header</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-after" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-footer</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-start" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-left</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-end" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-right</xsl:attribute>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:simple-page-master" use-attribute-sets="page-margin page-orientation-landscape">
				<xsl:attribute name="master-name">landscape-pages</xsl:attribute>
				<xsl:element name="fo:region-body" use-attribute-sets="body-margin">
					<xsl:attribute name="region-name">xsl-region-body</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-before" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-header</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-after" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-footer</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-start" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-left</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-end" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-right</xsl:attribute>
				</xsl:element>
			</xsl:element>

			<xsl:element name="fo:page-sequence-master" use-attribute-sets="">
				<xsl:attribute name="master-name">my-sequence</xsl:attribute>
				<xsl:element name="fo:single-page-master-reference" use-attribute-sets="">
					<xsl:attribute name="master-reference">first-page</xsl:attribute>
					<!--<xsl:attribute name="master-name">my-sequence</xsl:attribute>-->
				</xsl:element>
				<xsl:element name="fo:repeatable-page-master-reference" use-attribute-sets="">
					<xsl:attribute name="master-reference">all-pages</xsl:attribute>
					<!--<xsl:attribute name="master-name">my-sequence</xsl:attribute>-->
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:page-sequence-master" use-attribute-sets="">
				<xsl:attribute name="master-name">my-sequence-landscape</xsl:attribute>
				<xsl:element name="fo:repeatable-page-master-reference" use-attribute-sets="">
					<xsl:attribute name="master-reference">landscape-pages</xsl:attribute>
					<!--<xsl:attribute name="master-name">my-sequence</xsl:attribute>-->
				</xsl:element>
			</xsl:element>

		</xsl:element>

	</xsl:template>

	<xsl:template name="process-static-header">

		<xsl:comment>static-header</xsl:comment>
		
		<xsl:element name="fo:static-content" use-attribute-sets="">
			<xsl:attribute name="flow-name">first-header</xsl:attribute>
			<xsl:element name="fo:block" use-attribute-sets="last-justify">
				<xsl:attribute name="vertical-align">top</xsl:attribute>
				
				<xsl:element name="fo:inline" use-attribute-sets="align-left">
					<xsl:element name="fo:external-graphic">
						<!--<xsl:attribute name="content-height">30pt</xsl:attribute>-->
						<xsl:attribute name="scaling">uniform</xsl:attribute>
						<xsl:attribute name="overflow">visible</xsl:attribute>
						<xsl:attribute name="content-width">200pt</xsl:attribute>
						<xsl:attribute name="src">
							<xsl:text>url('</xsl:text>
							<xsl:value-of select="$images-input"/>
							<xsl:text>ce-logo</xsl:text>
							<xsl:if test="contains($system, 'docato')">
								<xsl:text>_default</xsl:text>
							</xsl:if>	
							<!--<xsl:text>.svg</xsl:text>-->
							<xsl:text>.gif</xsl:text>
							<xsl:text>')</xsl:text>
						</xsl:attribute>
					</xsl:element>
				</xsl:element>
				
				<xsl:element name="fo:leader" use-attribute-sets="default-leader color-white"/>
				
				<xsl:choose>
					<xsl:when test="contains($proof, 'cr-health')">
						<xsl:element name="fo:inline" use-attribute-sets="align-right">
							<xsl:element name="fo:external-graphic">
								<xsl:attribute name="content-width">100pt</xsl:attribute>
								<!--<xsl:attribute name="content-height">30pt</xsl:attribute>-->
								<xsl:attribute name="scaling">uniform</xsl:attribute>
								<xsl:attribute name="overflow">visible</xsl:attribute>
								<xsl:attribute name="src">
									<xsl:text>url('</xsl:text>
									<xsl:value-of select="$images-input"/>
									<xsl:text>cr-health-logo</xsl:text>
									<xsl:if test="contains($system, 'docato')">
										<xsl:text>_default</xsl:text>
									</xsl:if>
									<xsl:text>.jpg</xsl:text>
									<xsl:text>')</xsl:text>
								</xsl:attribute>
							</xsl:element>
						</xsl:element>						
					</xsl:when>
					<xsl:otherwise>
						<!--<xsl:element name="fo:inline" use-attribute-sets="strong huge align-right">
							<xsl:apply-templates select="/systematic-review/info/title"/>
							</xsl:element>-->
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:element>
		</xsl:element>
		
		<xsl:element name="fo:static-content" use-attribute-sets="">
			<xsl:attribute name="flow-name">all-header</xsl:attribute>
			<xsl:choose>
				<xsl:when test="/systematic-review/info/title[string-length(.) &lt; 50]">
					<xsl:element name="fo:block" use-attribute-sets="strong huge align-right color-tinted-blue">
						<xsl:apply-templates select="/systematic-review/info/title"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="fo:block" use-attribute-sets="strong large align-right color-tinted-blue">
						<xsl:apply-templates select="/systematic-review/info/title"/>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
		
		<!--<xsl:element name="fo:static-content" use-attribute-sets="">
			<xsl:attribute name="flow-name">first-right</xsl:attribute>
			<xsl:element name="fo:block-container" use-attribute-sets="running-head">
				<xsl:element name="fo:block" use-attribute-sets="last-justify">
					<xsl:element name="fo:inline" use-attribute-sets="strong huge color-tinted-blue">
						<xsl:value-of select="$primary-section-title"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>-->
		
		<xsl:element name="fo:static-content" use-attribute-sets="">
			<xsl:attribute name="flow-name">all-right</xsl:attribute>
			<xsl:element name="fo:block-container" use-attribute-sets="running-head">			
				<xsl:element name="fo:block" use-attribute-sets="strong huge color-tinted-blue">
					<xsl:value-of select="$primary-section-title"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>

	</xsl:template>

	<xsl:template name="process-static-footer">
		
		<xsl:comment>static-footer</xsl:comment>
			
		<xsl:element name="fo:static-content" use-attribute-sets="">
			<xsl:attribute name="flow-name">first-footer</xsl:attribute>
			
			<xsl:element name="fo:block" use-attribute-sets="last-justify">
				
				<xsl:element name="fo:inline" use-attribute-sets="tiny">© BMJ Publishing Group Ltd<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:value-of select="substring-before($date, '-')"/>
					<xsl:text disable-output-escaping="yes">. </xsl:text>All rights reserved<xsl:text disable-output-escaping="yes">. </xsl:text>
					
				</xsl:element>
				
				<xsl:element name="fo:leader" use-attribute-sets="default-leader color-white"/>
				
				<xsl:element name="fo:inline" use-attribute-sets="">
					<xsl:element name="fo:page-number" use-attribute-sets=""/>
				</xsl:element>
				
				<xsl:element name="fo:leader" use-attribute-sets="default-leader color-white"/>
				
				<xsl:element name="fo:inline" use-attribute-sets="tiny">
					
					<xsl:element name="fo:inline" use-attribute-sets="em">
						<xsl:value-of select="$journal-title"/>
					</xsl:element>
					
					<xsl:choose>
						<xsl:when test="contains($proof, 'sign-off')">
							<xsl:text disable-output-escaping="yes"> </xsl:text>
							<xsl:value-of select="substring-before($date, '-')"/>
							<xsl:text disable-output-escaping="yes">;</xsl:text>
							<xsl:value-of select="substring-before(substring-after($date, '-'), '-')"/>
							<xsl:text disable-output-escaping="yes">:</xsl:text>
							<xsl:choose>
								<xsl:when test="starts-with($cid, '0')">
									<xsl:value-of select="substring($cid, 2)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$cid"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text disable-output-escaping="yes"> </xsl:text>
							<xsl:value-of select="$year"/>
							<xsl:text disable-output-escaping="yes">;</xsl:text>
							<!--<xsl:value-of select="$volume"/>-->
							<xsl:text disable-output-escaping="yes">#</xsl:text>
							<xsl:text disable-output-escaping="yes">:</xsl:text>
							<fo:page-number-citation>
								<xsl:attribute name="ref-id">first-page</xsl:attribute>
							</fo:page-number-citation>
							<xsl:text disable-output-escaping="yes">-</xsl:text>
							<fo:page-number-citation>
								<xsl:attribute name="ref-id">last-page</xsl:attribute>
							</fo:page-number-citation>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				
			</xsl:element>
			
			<xsl:if test="contains($proof, 'cr-health')">
				
				<xsl:element name="fo:block" use-attribute-sets="space-before border-top-black align-left">
					
					<xsl:element name="fo:inline" use-attribute-sets="tiny">This information is made available to subscribers of ConsumerReportsHealth.org to facilitate discussion with their health-care providers</xsl:element>
					
				</xsl:element>
				
			</xsl:if>
			
		</xsl:element>
		
		<xsl:element name="fo:static-content" use-attribute-sets="">
			<xsl:attribute name="flow-name">all-footer</xsl:attribute>
			
			<xsl:element name="fo:block" use-attribute-sets="last-justify">
				
				<xsl:element name="fo:inline" use-attribute-sets="tiny">© BMJ Publishing Group Ltd<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:value-of select="substring-before($date, '-')"/>
					
					<xsl:text disable-output-escaping="yes">. </xsl:text>All rights reserved<xsl:text disable-output-escaping="yes">. </xsl:text>
					
				</xsl:element>
				
				<xsl:element name="fo:leader" use-attribute-sets="default-leader color-white"/>
				
				<xsl:element name="fo:inline" use-attribute-sets="">
					<xsl:element name="fo:page-number" use-attribute-sets=""/>
				</xsl:element>
				
			</xsl:element>
			
			<xsl:if test="contains($proof, 'cr-health')">
				
				<xsl:element name="fo:block" use-attribute-sets="space-before border-top-black align-left">
					
					<xsl:element name="fo:inline" use-attribute-sets="tiny">This information is made available to subscribers of ConsumerReportsHealth.org to facilitate discussion with their health-care providers</xsl:element>
					
				</xsl:element>
				
			</xsl:if>
			
		</xsl:element>
		
	</xsl:template>

</xsl:stylesheet>

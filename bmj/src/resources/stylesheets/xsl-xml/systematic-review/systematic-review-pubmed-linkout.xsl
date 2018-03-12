<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	
	<xsl:output 
		method="xml" 
		version="1.0" 
		indent="yes"
		omit-xml-declaration="yes"
		doctype-public="-//NLM//DTD LinkOut 1.0//EN" 
		doctype-system="http://www.ncbi.nlm.nih.gov/projects/linkout/doc/LinkOut.dtd" />
	
	<!-- info: http://www.ncbi.nlm.nih.gov/books/bv.fcgi?rid=helplinkout.section.files.Resource_File -->
	
	<xsl:param name="lang"/>
	<xsl:param name="media"/>
	<xsl:param name="date"/>
	<xsl:param name="systematic-review-xml-input"/>
	
	<xsl:include href="../../generic-params.xsl"/>
	<xsl:include href="../../systematic-review-params.xsl"/>
	<xsl:include href="../../xsl-glue-text/bmj-publisher-glue-text.xsl"/>
	
	<xsl:variable name="cid" select="substring-after(/systematic-review/@id, '_')"/>
	<xsl:variable name="bmjk-review-plan" select="document(/systematic-review/info/bmjk-review-plan-link/@target)/*"/>
	
	<xsl:template match="/">
			
		<xsl:element name="LinkSet">
			
			<xsl:element name="Link">
				
				<!-- Identifier assigned to link by provider -->
				<!--<xsl:element name="LinkId">
					<xsl:value-of select="substring-before($date, '-')"/>
					<xsl:text disable-output-escaping="yes">-</xsl:text>
					<xsl:value-of select="substring-before(substring-after($date, '-'), '-')"/>
					<xsl:text disable-output-escaping="yes">-</xsl:text>
					<xsl:choose>
						<xsl:when test="starts-with($cid, '0')">
							<xsl:value-of select="substring($cid, 2)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$cid"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>-->
				<xsl:element name="LinkId">
					<xsl:text>clinicalevidence.bmj.com</xsl:text>
				</xsl:element>
				
				<!-- ProviderId is assigned by NCBI -->
				<xsl:element name="ProviderId">
					<!--<xsl:value-of select="$issn"/>-->
					<xsl:value-of select="$ncbi-provider-id" />
				</xsl:element>
				
				<!-- URL of icon to be displayed on Entrez records -->
				<xsl:element name="IconUrl">
					<xsl:text>http://www.clinicalevidence.bmj.com/images/clinical-evidence-linkout-icon.png</xsl:text>
				</xsl:element>
				
				<xsl:element name="ObjectSelector">
					
					<!-- Entrez database in which links will appear -->
					<xsl:element name="Database">
						<xsl:text>PubMed</xsl:text>
					</xsl:element>
					
					<xsl:element name="ObjectList">
						<!-- http://www.ncbi.nlm.nih.gov/books/bv.fcgi?rid=helplinkout.section.ft.File_Preparation_Res#ft._Selecting_Records_Us -->
						<xsl:element name="Query">
							
							<!-- author [au] -->
							<!--<xsl:call-template name="do-contributors"/>-->
							
							<!-- title abbreviation [ta] -->
							<xsl:text>"Clin Evid (Online)" [ta]</xsl:text>

							<!-- publisher id [pii] -->
							<!--<xsl:text> AND </xsl:text>
							<xsl:value-of select="$cid"/>
							<xsl:text> [pii]</xsl:text>-->
							
							
							<!-- date of publication [dp] -->
							<!--<xsl:text> AND </xsl:text>
							<xsl:value-of select="substring($date, 1, 4)"/>
							<xsl:text disable-output-escaping="yes">/</xsl:text>
							<xsl:value-of select="substring($date, 5, 2)"/>
							<xsl:text disable-output-escaping="yes">/</xsl:text>
							<xsl:value-of select="substring($date, 9, 2)"/>
							<xsl:text> [dp]</xsl:text>-->
							
						</xsl:element>
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="ObjectUrl">
					
					<!-- Stable portion of URL for provider’s resource -->
					<xsl:element name="Base">
						<xsl:text>http://www.clinicalevidence.bmj.com/ceweb/pmc/</xsl:text>
					</xsl:element>
					
					<!-- Variable portion of URL for resource -->
					<!--<xsl:element name="Rule">
						<xsl:value-of select="substring-before($date, '-')"/>
						<xsl:text disable-output-escaping="yes">/</xsl:text>
						<xsl:value-of select="substring-before(substring-after($date, '-'), '-')"/>
						<xsl:text disable-output-escaping="yes">/</xsl:text>
						<xsl:choose>
							<xsl:when test="starts-with($cid, '0')">
								<xsl:value-of select="substring($cid, 2)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$cid"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text disable-output-escaping="yes">/</xsl:text>
						</xsl:element>-->
					<xsl:element name="Rule">
						<xsl:text disable-output-escaping="yes">&amp;lo.year;/&amp;lo.mo;/&amp;lo.pii;</xsl:text>
					</xsl:element>
					
					<!-- http://www.ncbi.nlm.nih.gov/books/bv.fcgi?rid=helplinkout.section.files.Special_Elements_Sub#files.Medical -->
					<!--<xsl:element name="SubjectType">
						<xsl:text></xsl:text>
						</xsl:element>-->
					
					<xsl:element name="Attribute">
						<!--<xsl:text>full-text PDF</xsl:text>-->
						<xsl:text>full-text online</xsl:text>
					</xsl:element>
					
					<xsl:element name="Attribute">
						<xsl:text>subscription/membership/fee required</xsl:text>
					</xsl:element>
					
					<!-- Link Resolver or Service Name -->
					<!--<xsl:element name="UrlName">
						<xsl:text></xsl:text>
						</xsl:element>-->
					
				</xsl:element>
				
			</xsl:element>
		
		</xsl:element>
			
	</xsl:template>
	
	<xsl:template name="do-contributors">
		
		<xsl:for-each select="$bmjk-review-plan//contributor-set/person-link">
			<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@target, '../'))"/>
			<xsl:variable name="person" select="document($filename)/*"/>
			
			<xsl:value-of select="$person//last-name"/>
			<xsl:text disable-output-escaping="yes"> </xsl:text>
			<xsl:value-of select="substring($person//first-name, 1, 1)"/>
			<xsl:if test="$person//middle-name[string-length(.)!=0]">
				<xsl:value-of select="substring($person//middle-name, 1, 1)"/>
			</xsl:if>
			<xsl:text> [au]</xsl:text>
			<xsl:text> AND </xsl:text>
		</xsl:for-each>
		
	</xsl:template>
	
</xsl:stylesheet>

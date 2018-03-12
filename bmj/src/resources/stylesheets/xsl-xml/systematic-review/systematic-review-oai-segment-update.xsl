<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:oai="http://www.openarchives.org/OAI/2.0/"
	xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
	xmlns:dc="http://purl.org/dc/elements/1.1/">

	<xsl:output 
		method="xml" 
		encoding="UTF-8" 
		indent="yes" 
		omit-xml-declaration="no"/>

	<xsl:param name="lang"/>
	<xsl:param name="media"/>
	<xsl:param name="date"/>
	<xsl:param name="process-stream"/>
	
	<xsl:include href="../../generic-params.xsl"/>
	<xsl:include href="../../systematic-review-params.xsl"/>
	<xsl:include href="../../xsl-glue-text/bmj-publisher-glue-text.xsl"/>

	<xsl:variable name="cid" select="substring-after(/systematic-review/@id, '_')"/>
	<xsl:variable name="bmjk-review-plan" select="document(/systematic-review/info/bmjk-review-plan-link/@target)/*"/>
	
	<xsl:template match="/">
		
		<xsl:element name="Repository" namespace="http://www.openarchives.org/OAI/2.0/static-repository">
			<xsl:namespace name="oai" select="'http://www.openarchives.org/OAI/2.0/'"/>
			<xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'"/>
			<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
			<xsl:attribute name="xsi:schemaLocation" select="'http://www.openarchives.org/OAI/2.0/static-repository http://www.openarchives.org/OAI/2.0/static-repository.xsd'"/>
			
			<xsl:element name="Identify" xmlns="http://www.openarchives.org/OAI/2.0/static-repository">
				<xsl:element name="oai:repositoryName">
					<xsl:text>Demo repository</xsl:text>
				</xsl:element>
				<xsl:element name="oai:baseURL">
					<xsl:text>http://gateway.institution.org/oai/an.oai.org/ma/mini.xml</xsl:text>
				</xsl:element>
				<xsl:element name="oai:protocolVersion">
					<xsl:text>2.0</xsl:text>
				</xsl:element>
				<xsl:element name="oai:adminEmail">
					<xsl:text>jondoe@oai.org</xsl:text>
				</xsl:element>
				<xsl:element name="oai:earliestDatestamp">
					<xsl:text>2002-09-19</xsl:text>
				</xsl:element>
				<xsl:element name="oai:deletedRecord">
					<xsl:text>no</xsl:text>
				</xsl:element>
				<xsl:element name="oai:granularity">
					<xsl:text>YYYY-MM-DD</xsl:text>
				</xsl:element>
			</xsl:element>
				
			<xsl:element name="ListMetadataFormats" xmlns="http://www.openarchives.org/OAI/2.0/static-repository">
				<xsl:element name="oai:metadataFormat">
					<xsl:element name="oai:metadataPrefix">
						<xsl:text>oai_dc</xsl:text>
					</xsl:element>
					<xsl:element name="oai:schema">
						<xsl:text>http://www.openarchives.org/OAI/2.0/oai_dc.xsd</xsl:text>
					</xsl:element>
					<xsl:element name="oai:metadataNamespace">
						<xsl:text>http://www.openarchives.org/OAI/2.0/oai_dc/</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="ListRecords" xmlns="http://www.openarchives.org/OAI/2.0/static-repository">
				<xsl:attribute name="metadataPrefix" select="'oai_dc'"/>
				<xsl:apply-templates select="systematic-review"/>
				<xsl:apply-templates select="//xi:include[contains(@href, 'option')]" mode="option"/>
			</xsl:element>
				
		</xsl:element>
	</xsl:template>
			
	<xsl:template match="systematic-review">
		
		<xsl:element name="oai:record">
			
			<xsl:element name="oai:header">
				
				<xsl:element name="oai:identifier">
					<xsl:text>oai:bestpractice.bmj.com/</xsl:text>
					<xsl:value-of select="$cid"/>
				</xsl:element>
				
				<xsl:element name="oai:datestamp">
					<xsl:value-of select="$date"/>
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="oai:metadata">
				
				<xsl:element name="oai_dc:dc" namespace="http://www.openarchives.org/OAI/2.0/oai_dc/">
					<xsl:namespace name="oai_dc" select="'http://www.openarchives.org/OAI/2.0/oai_dc/'"/>
					<xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'"/>
					<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
					<xsl:attribute name="xsi:schemaLocation" select="'http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd'"/>
					
					<xsl:element name="dc:title">
						<xsl:value-of select="normalize-space(info/title)"/>
					</xsl:element>
					
					<xsl:element name="dc:type">
						<xsl:value-of select="'Systematic Review'"/>
					</xsl:element>
					
					<xsl:for-each select="$bmjk-review-plan//contributor-set/person-link">
						<xsl:variable name="person" select="document(@target)//*"/>
						<xsl:element name="dc:creator">
							<xsl:apply-templates select="$person//first-name"/>
							<xsl:if test="$person//middle-name[string-length(normalize-space(.))!=0]">
								<xsl:text disable-output-escaping="yes"> </xsl:text>
								<xsl:apply-templates select="$person//middle-name"/>
							</xsl:if>
							<xsl:text disable-output-escaping="yes"> </xsl:text>
							<xsl:apply-templates select="$person//last-name"/>
						</xsl:element>
					</xsl:for-each>
					
					<xsl:element name="dc:subject">
						<xsl:value-of select="normalize-space(document($bmjk-review-plan//info/section-list/section-link[1]/@target)//abridged-title)"/>
					</xsl:element>
					
					<xsl:element name="dc:description">
						<xsl:choose>
							<xsl:when test="abstract/*[1][string-length(.)!=0]">
								<xsl:for-each select="/systematic-review/abstract/element()">
									<xsl:variable name="abstract-label" select="concat('abstract-', name())"/>
									<xsl:value-of select="translate($glue-text//element()[name()=$abstract-label][contains(@lang, $lang)], $lower, $upper)"/>
									<xsl:text>: </xsl:text>
									<xsl:apply-templates/>
									<xsl:text> </xsl:text>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>We have evaluated the treatments for </xsl:text>
								<xsl:value-of select="normalize-space(info/title)"/>
								<xsl:text> and categorised them according to the evidence on their benefits and harms.</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:element>
					
					<xsl:element name="dc:date">
						<xsl:value-of select="$date"/>
					</xsl:element>
					
					<xsl:element name="dc:identifier">
						<xsl:text>http://bestpractice.bmj.com/best-practice/evidence/</xsl:text>
						<xsl:value-of select="$cid"/>
						<xsl:text>.html</xsl:text>
					</xsl:element>
					
					<xsl:element name="dc:publisher">
						<xsl:value-of select="$bmj-publisher-glue-text/publisher-name[contains(@lang, $lang)]"/>
					</xsl:element>
					
					<xsl:element name="dc:rights">
						<xsl:value-of select="$bmj-publisher-glue-text/copyright[contains(@lang, $lang)]"/>
						<xsl:text disable-output-escaping="yes"> </xsl:text>
						<xsl:value-of select="substring($date, 1, 4)"/>
					</xsl:element>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="xi:include" mode="option">
		
		<!-- chpping '../options/_op1003_I1.xml' to get option id -->
		<xsl:variable 
			name="iid" 
			select="
			concat('sr-',$cid, '-i', 
			replace(
			@href 
			, '^.*?[I\-](\d+).*?$'
			, '$1'))
			"/>
		<xsl:variable name="option" select="document(@href)/*"/>
		
		<xsl:element name="oai:record">
			
			<xsl:element name="oai:header">
				
				<xsl:element name="oai:identifier">
					<xsl:text>oai:bestpractice.bmj.com/</xsl:text>
					<xsl:value-of select="$iid"/>
				</xsl:element>
				
				<xsl:element name="oai:datestamp">
					<xsl:value-of select="$date"/>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="oai:metadata">
				
				<xsl:element name="oai_dc:dc" namespace="http://www.openarchives.org/OAI/2.0/oai_dc/">
					<xsl:namespace name="oai_dc" select="'http://www.openarchives.org/OAI/2.0/oai_dc/'"/>
					<xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'"/>
					<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
					<xsl:attribute name="xsi:schemaLocation" select="'http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd'"/>
					
					<xsl:element name="dc:title">
						<xsl:value-of select="normalize-space($option/title)"/>
					</xsl:element>
					
					<xsl:element name="dc:type">
						<xsl:value-of select="'Systematic Review'"/>
					</xsl:element>
					
					<xsl:for-each select="$bmjk-review-plan//contributor-set/person-link">
						<xsl:variable name="person" select="document(@target)//*"/>
						<xsl:element name="dc:creator">
							<xsl:apply-templates select="$person//first-name"/>
							<xsl:if test="$person//middle-name[string-length(normalize-space(.))!=0]">
								<xsl:text disable-output-escaping="yes"> </xsl:text>
								<xsl:apply-templates select="$person//middle-name"/>
							</xsl:if>
							<xsl:text disable-output-escaping="yes"> </xsl:text>
							<xsl:apply-templates select="$person//last-name"/>
						</xsl:element>
					</xsl:for-each>
					
					<xsl:element name="dc:subject">
						<xsl:value-of select="normalize-space(document($bmjk-review-plan//info/section-list/section-link[1]/@target)//abridged-title)"/>
						<xsl:text> :: </xsl:text>
						<xsl:value-of select="normalize-space(parent::question/abridged-title)"/>
						<xsl:text> :: </xsl:text>
						<xsl:value-of select="normalize-space($option/abridged-title)"/>
					</xsl:element>
					
					<xsl:element name="dc:description">
						<xsl:choose>
							<xsl:when test="string-length($option/summary-statement)">
								<xsl:apply-templates select="$option/summary-statement" mode="single-para"/>
							</xsl:when>
							<xsl:when test="count($option/intervention-set/intervention) = 1">
								<xsl:apply-templates select="$option/intervention-set/intervention/summary-statement" mode="single-para"/>
							</xsl:when>
						</xsl:choose>
					</xsl:element>
					
					<xsl:element name="dc:date">
						<xsl:value-of select="$date"/>
					</xsl:element>
					
					<xsl:element name="dc:identifier">
						<xsl:text>http://bestpractice.bmj.com/best-practice/evidence/intervention/</xsl:text>
						<xsl:value-of select="$cid"/>
						<xsl:text>/0/</xsl:text>
						<xsl:value-of select="$iid"/>
						<xsl:text>.html</xsl:text>
					</xsl:element>
					
					<xsl:element name="dc:publisher">
						<xsl:value-of select="$bmj-publisher-glue-text/publisher-name[contains(@lang, $lang)]"/>
					</xsl:element>
					
					<xsl:element name="dc:rights">
						<xsl:value-of select="$bmj-publisher-glue-text/copyright[contains(@lang, $lang)]"/>
						<xsl:text disable-output-escaping="yes"> </xsl:text>
						<xsl:value-of select="substring($date, 1, 4)"/>
					</xsl:element>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
	</xsl:template>
	
	<!--special formatting control for mixed content in summary-statement-->
	<xsl:template match="summary-statement" mode="single-para">
		<xsl:for-each select="node()">
			<xsl:choose>
				<xsl:when test="name()='strong' and (table-link or contains(translate(., $upper, $lower), 'table') or contains(translate(., $upper, $lower), 'grade'))">
					<xsl:comment select="'grade statement removed'"/>
				</xsl:when>
				<xsl:when test="name()='strong'">
					<xsl:value-of select="translate(normalize-space(.), $lower, $upper)"/>
					<xsl:text disable-output-escaping="yes"> </xsl:text>
				</xsl:when>
				<xsl:when test="name()='em'">
					<xsl:value-of select="normalize-space(.)"/>
					<xsl:text disable-output-escaping="yes">: </xsl:text>
				</xsl:when>
				<!--<xsl:when test="name()='gloss-link'">
					<xsl:value-of select="normalize-space(.)"/>
				</xsl:when>-->
				<xsl:when test="string-length(normalize-space(.))!=0">
					<xsl:value-of select="normalize-space(.)"/>
					<xsl:text disable-output-escaping="yes"> </xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>

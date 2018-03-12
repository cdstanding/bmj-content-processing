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
		omit-xml-declaration="no" />

	<xsl:param name="lang" />
	<xsl:param name="media" />
	<xsl:param name="process-stream" />
	
	<xsl:param name="date" />
	
	<xsl:param name="article-type" select="string('Monograph')" />
	
	<xsl:include href="../../generic-params.xsl" />
	<xsl:include href="../../xsl-glue-text/point-of-care-glue-text.xsl" />
	<xsl:include href="../../xsl-glue-text/bmj-publisher-glue-text.xsl" />

	<xsl:variable name="mono-id" select="/*/@dx-id" />
	<xsl:variable name="mono-title" select="normalize-space(/*/monograph-info/title)" />
	<xsl:variable name="mono-categories">
		<xsl:copy-of select="/*/monograph-info/categories" />
	</xsl:variable>
	<xsl:variable name="monograph-plan" select="document(/*/monograph-info/monograph-plan-link/@target)/*" />
	
	
	<xsl:template match="/">
		
		<xsl:element name="Repository" namespace="http://www.openarchives.org/OAI/2.0/static-repository">
			<xsl:namespace name="oai" select="'http://www.openarchives.org/OAI/2.0/'" />
			<xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'" />
			<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'" />
			<xsl:attribute name="xsi:schemaLocation" select="'http://www.openarchives.org/OAI/2.0/static-repository http://www.openarchives.org/OAI/2.0/static-repository.xsd'" />
			
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
				<xsl:attribute name="metadataPrefix" select="'oai_dc'" />
				<xsl:apply-templates select="monograph-full | monograph-overview | monograph-generic | monograph-eval" />
			</xsl:element>
				
		</xsl:element>
	</xsl:template>
			
	<xsl:template match="monograph-full | monograph-overview | monograph-generic | monograph-eval">
		
		<xsl:comment select="name()" />
		
		<xsl:element name="oai:record">
			
			<xsl:element name="oai:header">
				
				<xsl:element name="oai:identifier">
					<xsl:text>oai:bestpractice.bmj.com/</xsl:text>
					<xsl:value-of select="$mono-id" />
				</xsl:element>
				
				<xsl:element name="oai:datestamp">
					<xsl:value-of select="$date" />
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="oai:metadata">
				
				<xsl:element name="oai_dc:dc" namespace="http://www.openarchives.org/OAI/2.0/oai_dc/">
					<xsl:namespace name="oai_dc" select="'http://www.openarchives.org/OAI/2.0/oai_dc/'" />
					<xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'" />
					<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'" />
					<xsl:attribute name="xsi:schemaLocation" select="'http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd'" />
					
					<xsl:element name="dc:title">
						<xsl:value-of select="$mono-title" />
					</xsl:element>
					
					<xsl:element name="dc:type">
						<xsl:value-of select="$article-type" />
					</xsl:element>
					
					<xsl:for-each select="$monograph-plan//authors/person-link[@person-type='author']">
						<xsl:variable name="person" select="document(@target)//*" />
						<xsl:element name="dc:creator">
							<xsl:apply-templates select="$person//name" />
						</xsl:element>
					</xsl:for-each>
					
					<xsl:if test="$mono-categories//category[string-length(normalize-space(.))!=0]">
						
						<xsl:variable name="category-position">
							<xsl:choose>
								<xsl:when test="$mono-categories//category[string-length(normalize-space(.))!=0][position()=last()]">
									<xsl:value-of select="generate-id($mono-categories//category[string-length(normalize-space(.))!=0][position()=last()])" />
								</xsl:when>
								<xsl:when test="count($mono-categories//category[string-length(normalize-space(.))!=0])=1">
									<xsl:text>single</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<!--<xsl:text>single</xsl:text>-->
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:for-each select="$mono-categories//category[string-length(normalize-space(.))!=0]">
							<xsl:element name="dc:subject">
								<xsl:value-of select="normalize-space(.)" />
							</xsl:element>
						</xsl:for-each>
						
					</xsl:if>
					
					<xsl:element name="dc:description">
						<xsl:text>Monograph on </xsl:text>
						<xsl:value-of select="$mono-title" />
						<xsl:text>. </xsl:text>
					</xsl:element>
					
					<xsl:element name="dc:date">
						<xsl:value-of select="$date" />
					</xsl:element>
					
					<xsl:element name="dc:identifier">
						<xsl:text>http://bestpractice.bmj.com</xsl:text>
						<xsl:text>/best-practice/monograph/</xsl:text>
						<xsl:value-of select="$mono-id" />
						<xsl:text>.html</xsl:text>
					</xsl:element>
					
					<xsl:element name="dc:publisher">
						<xsl:value-of select="$bmj-publisher-glue-text/publisher-name[contains(@lang, $lang)]" />
					</xsl:element>
					
					<xsl:element name="dc:rights">&#169;<xsl:text disable-output-escaping="yes"> </xsl:text><xsl:value-of select="substring($date, 1, 4)" /></xsl:element>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
		<!-- basics section aetiology and prevention -->
		<xsl:apply-templates select="document(//xi:include[contains(@href, 'monograph-standard-basics')]/@href)/*" mode="basics" />
		
		<!-- diagnosis section -->
		<xsl:apply-templates select="document(//xi:include[contains(@href, 'monograph-standard-diagnosis')]/@href)/*" mode="diagnosis" />

		<!-- do tx-options -->
		<!-- xsl:for-each select="document(//xi:include[contains(@href, 'monograph-standard-treatment')]/@href)/*">
			<xsl:apply-templates select="document(//tx-options/xi:include[contains(@href, 'tx-option')]/@href)/*" mode="tx-option" />
		</xsl:for-each -->

		<!-- treament index -->
		<xsl:if test="document(//xi:include[contains(@href, 'monograph-standard-treatment')]/@href)/*">
			<xsl:call-template name="treatment"/>
		</xsl:if>

		<!-- evidence section -->
		<xsl:if test="document(//xi:include[contains(@href, 'monograph-standard-evidence-score')]/@href)/*">
			<xsl:call-template name="evidence"/>
		</xsl:if>
		
		<!-- prognosis section -->
		<xsl:apply-templates select="document(//xi:include[contains(@href, 'monograph-standard-followup')]/@href)/*" mode="followup" />

	</xsl:template>
	
	
	<xsl:template name="treatment">
		
		<xsl:comment>
			<xsl:text>treatments</xsl:text>
		</xsl:comment>		
		
		<xsl:element name="oai:record">
			
			<xsl:element name="oai:header">
				
				<xsl:element name="oai:identifier">
					<xsl:text>oai:bestpractice.bmj.com/</xsl:text>
					<xsl:value-of select="$mono-id" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="@id" />
				</xsl:element>
				
				<xsl:element name="oai:datestamp">
					<xsl:value-of select="$date" />
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="oai:metadata">
				
				<xsl:element name="oai_dc:dc" namespace="http://www.openarchives.org/OAI/2.0/oai_dc/">
					<xsl:namespace name="oai_dc" select="'http://www.openarchives.org/OAI/2.0/oai_dc/'" />
					<xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'" />
					<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'" />
					<xsl:attribute name="xsi:schemaLocation" select="'http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd'" />
					
					<xsl:element name="dc:title">
						<xsl:value-of select="$mono-title" />
						<xsl:text>: Treatments</xsl:text>
					</xsl:element>
					
					<xsl:element name="dc:type">
						<xsl:value-of select="$article-type" />
					</xsl:element>
					
					<xsl:for-each select="$monograph-plan//authors/person-link[@person-type='author']">
						<xsl:variable name="person" select="document(@target)//*" />
						<xsl:element name="dc:creator">
							<xsl:apply-templates select="$person//name" />
						</xsl:element>
					</xsl:for-each>
					
					<xsl:variable name="category-position">
						<xsl:choose>
							<xsl:when test="$mono-categories//category[string-length(normalize-space(.))!=0][position()=last()]">
								<xsl:value-of select="generate-id($mono-categories//category[string-length(normalize-space(.))!=0][position()=last()])" />
							</xsl:when>
							<xsl:when test="count($mono-categories//category[string-length(normalize-space(.))!=0])=1">
								<xsl:text>single</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:for-each select="$mono-categories//category[string-length(normalize-space(.))!=0]">
						<xsl:element name="dc:subject">
							<xsl:value-of select="normalize-space(.)" />
						</xsl:element>
					</xsl:for-each>
					
					<xsl:element name="dc:description">
						<xsl:text>Treatments from monograph </xsl:text>
						<xsl:value-of select="$mono-title" />
					</xsl:element>
					
					<xsl:element name="dc:date">
						<xsl:value-of select="$date" />
					</xsl:element>
					
					<xsl:element name="dc:identifier">
						<xsl:text>http://bestpractice.bmj.com</xsl:text>
						<xsl:text>/best-practice/monograph/</xsl:text>
						<xsl:value-of select="$mono-id" />
						<xsl:text>/treatment/details.html</xsl:text>
					</xsl:element>
					
					<xsl:element name="dc:publisher">
						<xsl:value-of select="$bmj-publisher-glue-text/publisher-name[contains(@lang, $lang)]" />
					</xsl:element>
					
					<xsl:element name="dc:rights">&#169;<xsl:text disable-output-escaping="yes"> </xsl:text><xsl:value-of select="substring($date, 1, 4)" /></xsl:element>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>			
		
	</xsl:template>
	
	
	
	<xsl:template match="tx-option" mode="tx-option">
		
		<xsl:variable name="parent" select="pt-group" />
		<xsl:variable name="timeframe" select="@timeframe" />
		
		<!-- if the parent has no children we include the parent -->
		<xsl:choose>
			<xsl:when test="count(.//tx-options/xi:include[contains(@href, 'tx-option')]) = 0">

				<xsl:element name="oai:record">
					
					<xsl:element name="oai:header">
						
						<xsl:element name="oai:identifier">
							<xsl:text>oai:bestpractice.bmj.com/</xsl:text>
							<xsl:value-of select="$mono-id" />
							<xsl:text>/</xsl:text>
							<xsl:value-of select="@id" />
						</xsl:element>
						
						<xsl:element name="oai:datestamp">
							<xsl:value-of select="$date" />
						</xsl:element>
					</xsl:element>
					
					<xsl:element name="oai:metadata">
						
						<xsl:element name="oai_dc:dc" namespace="http://www.openarchives.org/OAI/2.0/oai_dc/">
							<xsl:namespace name="oai_dc" select="'http://www.openarchives.org/OAI/2.0/oai_dc/'" />
							<xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'" />
							<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'" />
							<xsl:attribute name="xsi:schemaLocation" select="'http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd'" />
							
							<xsl:element name="dc:title">
								<xsl:value-of select="$mono-title" />
								<xsl:text>: </xsl:text>
								<xsl:value-of select="$parent" />
								<xsl:text> </xsl:text>
								<xsl:value-of select="concat(translate(substring($timeframe,1,1),'abcdefghijklmnopqrstuvwxyz',
									'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),substring($timeframe,2,string-length($timeframe)))"/>
							</xsl:element>
							
							<xsl:element name="dc:type">
								<xsl:value-of select="$article-type" />
							</xsl:element>
							
							<xsl:for-each select="$monograph-plan//authors/person-link[@person-type='author']">
								<xsl:variable name="person" select="document(@target)//*" />
								<xsl:element name="dc:creator">
									<xsl:apply-templates select="$person//name" />
								</xsl:element>
							</xsl:for-each>
							
							<xsl:variable name="category-position">
								<xsl:choose>
									<xsl:when test="$mono-categories//category[string-length(normalize-space(.))!=0][position()=last()]">
										<xsl:value-of select="generate-id($mono-categories//category[string-length(normalize-space(.))!=0][position()=last()])" />
									</xsl:when>
									<xsl:when test="count($mono-categories//category[string-length(normalize-space(.))!=0])=1">
										<xsl:text>single</xsl:text>
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							
							<xsl:for-each select="$mono-categories//category[string-length(normalize-space(.))!=0]">
								<xsl:element name="dc:subject">
									<xsl:value-of select="normalize-space(.)" />
								</xsl:element>
							</xsl:for-each>
							
							
							<xsl:element name="dc:description">
								<xsl:text>Monograph on </xsl:text>
								<xsl:value-of select="$mono-title" />
								<xsl:text> with treatments covering patient group on </xsl:text>
								<xsl:value-of select="$parent" />
								<xsl:text disable-output-escaping="yes"> (</xsl:text>
								<xsl:value-of select="$timeframe" />
								<xsl:text disable-output-escaping="yes"> timeframe). </xsl:text>
							</xsl:element>
							
							<xsl:element name="dc:date">
								<xsl:value-of select="$date" />
							</xsl:element>
							
							<xsl:element name="dc:identifier">
								<xsl:text>http://bestpractice.bmj.com</xsl:text>
								<xsl:text>/best-practice/monograph/</xsl:text>
								<xsl:value-of select="$mono-id" />
								<xsl:text>/treatment/details.html</xsl:text>
							</xsl:element>
							
							<xsl:element name="dc:publisher">
								<xsl:value-of select="$bmj-publisher-glue-text/publisher-name[contains(@lang, $lang)]" />
							</xsl:element>
							
							<xsl:element name="dc:rights">&#169;<xsl:text disable-output-escaping="yes"> </xsl:text><xsl:value-of select="substring($date, 1, 4)" /></xsl:element>
							
						</xsl:element>
					</xsl:element>
				</xsl:element>		
				
			</xsl:when>
			<xsl:otherwise>
				<!-- we need to loop every included document and get a unique list or pt-group -->
				<xsl:for-each-group select="document(.//tx-options/xi:include[contains(@href, 'tx-option')]/@href)/*" group-by="pt-group">
					
					<xsl:variable name="patient" select="current-grouping-key()" />
					
					<xsl:element name="oai:record">
						
						<xsl:element name="oai:header">
							
							<xsl:element name="oai:identifier">
								<xsl:text>oai:bestpractice.bmj.com/</xsl:text>
								<xsl:value-of select="$mono-id" />
								<xsl:text>/</xsl:text>
								<xsl:value-of select="@id" />
							</xsl:element>
							
							<xsl:element name="oai:datestamp">
								<xsl:value-of select="$date" />
							</xsl:element>
						</xsl:element>
						
						<xsl:element name="oai:metadata">
							
							<xsl:element name="oai_dc:dc" namespace="http://www.openarchives.org/OAI/2.0/oai_dc/">
								<xsl:namespace name="oai_dc" select="'http://www.openarchives.org/OAI/2.0/oai_dc/'" />
								<xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'" />
								<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'" />
								<xsl:attribute name="xsi:schemaLocation" select="'http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd'" />
								
								<xsl:element name="dc:title">
									<xsl:value-of select="$mono-title" />
									<xsl:text>: </xsl:text>
									<xsl:value-of select="$parent" />
									<xsl:text>: </xsl:text>
									<xsl:value-of select="normalize-space($patient)" />
									<xsl:text> </xsl:text>
									<xsl:value-of select="concat(translate(substring($timeframe,1,1),'abcdefghijklmnopqrstuvwxyz',
										'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),substring($timeframe,2,string-length($timeframe)))"/>
								</xsl:element>
								
								<xsl:element name="dc:type">
									<xsl:value-of select="$article-type" />
								</xsl:element>
								
								<xsl:for-each select="$monograph-plan//authors/person-link[@person-type='author']">
									<xsl:variable name="person" select="document(@target)//*" />
									<xsl:element name="dc:creator">
										<xsl:apply-templates select="$person//name" />
									</xsl:element>
								</xsl:for-each>
								
								<xsl:variable name="category-position">
									<xsl:choose>
										<xsl:when test="$mono-categories//category[string-length(normalize-space(.))!=0][position()=last()]">
											<xsl:value-of select="generate-id($mono-categories//category[string-length(normalize-space(.))!=0][position()=last()])" />
										</xsl:when>
										<xsl:when test="count($mono-categories//category[string-length(normalize-space(.))!=0])=1">
											<xsl:text>single</xsl:text>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>
								
								<xsl:for-each select="$mono-categories//category[string-length(normalize-space(.))!=0]">
									<xsl:element name="dc:subject">
										<xsl:value-of select="normalize-space(.)" />
									</xsl:element>
								</xsl:for-each>
								
								
								<xsl:element name="dc:description">
									<xsl:text>Monograph on </xsl:text>
									<xsl:value-of select="$mono-title" />
									<xsl:text> with treatments covering patient group on </xsl:text>
									<xsl:value-of select="$parent" />
									<xsl:text>: </xsl:text>
									<xsl:value-of select="normalize-space($patient)" />
									<xsl:text disable-output-escaping="yes"> (</xsl:text>
									<xsl:value-of select="$timeframe" />
									<xsl:text disable-output-escaping="yes"> timeframe). </xsl:text>
								</xsl:element>
								
								<xsl:element name="dc:date">
									<xsl:value-of select="$date" />
								</xsl:element>
								
								<xsl:element name="dc:identifier">
									<xsl:text>http://bestpractice.bmj.com</xsl:text>
									<xsl:text>/best-practice/monograph/</xsl:text>
									<xsl:value-of select="$mono-id" />
									<xsl:text>/treatment/details.html</xsl:text>
								</xsl:element>
								
								<xsl:element name="dc:publisher">
									<xsl:value-of select="$bmj-publisher-glue-text/publisher-name[contains(@lang, $lang)]" />
								</xsl:element>
								
								<xsl:element name="dc:rights">&#169;<xsl:text disable-output-escaping="yes"> </xsl:text><xsl:value-of select="substring($date, 1, 4)" /></xsl:element>
								
							</xsl:element>
						</xsl:element>
					</xsl:element>			
					
					
				</xsl:for-each-group>
				
			</xsl:otherwise>
		</xsl:choose>
		
		
	</xsl:template>
	
	
	<xsl:template match="basics" mode="basics">
		
		<!-- Aetiology -->
		<xsl:if test="/basics/etiology">

			<xsl:comment>
				<xsl:text>basics - aetiology</xsl:text>
			</xsl:comment>		
			
			<xsl:element name="oai:record">
				
				<xsl:element name="oai:header">
					
					<xsl:element name="oai:identifier">
						<xsl:text>oai:bestpractice.bmj.com/</xsl:text>
						<xsl:value-of select="$mono-id" />
						<xsl:text>/</xsl:text>
						<xsl:value-of select="@id" />
					</xsl:element>
					
					<xsl:element name="oai:datestamp">
						<xsl:value-of select="$date" />
					</xsl:element>
				</xsl:element>
				
				<xsl:element name="oai:metadata">
					
					<xsl:element name="oai_dc:dc" namespace="http://www.openarchives.org/OAI/2.0/oai_dc/">
						<xsl:namespace name="oai_dc" select="'http://www.openarchives.org/OAI/2.0/oai_dc/'" />
						<xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'" />
						<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'" />
						<xsl:attribute name="xsi:schemaLocation" select="'http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd'" />
						
						<xsl:element name="dc:title">
							<xsl:value-of select="$mono-title" />
							<xsl:text>: Aetiology</xsl:text>
						</xsl:element>
						
						<xsl:element name="dc:type">
							<xsl:value-of select="$article-type" />
						</xsl:element>
						
						<xsl:for-each select="$monograph-plan//authors/person-link[@person-type='author']">
							<xsl:variable name="person" select="document(@target)//*" />
							<xsl:element name="dc:creator">
								<xsl:apply-templates select="$person//name" />
							</xsl:element>
						</xsl:for-each>
						
						<xsl:variable name="category-position">
							<xsl:choose>
								<xsl:when test="$mono-categories//category[string-length(normalize-space(.))!=0][position()=last()]">
									<xsl:value-of select="generate-id($mono-categories//category[string-length(normalize-space(.))!=0][position()=last()])" />
								</xsl:when>
								<xsl:when test="count($mono-categories//category[string-length(normalize-space(.))!=0])=1">
									<xsl:text>single</xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:for-each select="$mono-categories//category[string-length(normalize-space(.))!=0]">
							<xsl:element name="dc:subject">
								<xsl:value-of select="normalize-space(.)" />
							</xsl:element>
						</xsl:for-each>
						
						<xsl:element name="dc:description">
							<xsl:text>Aetiology from monograph </xsl:text>
							<xsl:value-of select="$mono-title" />
						</xsl:element>
						
						<xsl:element name="dc:date">
							<xsl:value-of select="$date" />
						</xsl:element>
						
						<xsl:element name="dc:identifier">
							<xsl:text>http://bestpractice.bmj.com</xsl:text>
							<xsl:text>/best-practice/monograph/</xsl:text>
							<xsl:value-of select="$mono-id" />
							<xsl:text>/basics/aetiology.html</xsl:text>
						</xsl:element>
						
						<xsl:element name="dc:publisher">
							<xsl:value-of select="$bmj-publisher-glue-text/publisher-name[contains(@lang, $lang)]" />
						</xsl:element>
						
						<xsl:element name="dc:rights">&#169;<xsl:text disable-output-escaping="yes"> </xsl:text><xsl:value-of select="substring($date, 1, 4)" /></xsl:element>

					</xsl:element>
				</xsl:element>
			</xsl:element>			
		</xsl:if>
		
		<!-- prevention -->
		<xsl:if test="/basics/prevention">
			
			<xsl:comment>
				<xsl:text>basics - prevention</xsl:text>
			</xsl:comment>		
			
			<xsl:element name="oai:record">
				
				<xsl:element name="oai:header">
					
					<xsl:element name="oai:identifier">
						<xsl:text>oai:bestpractice.bmj.com/</xsl:text>
						<xsl:value-of select="$mono-id" />
						<xsl:text>/</xsl:text>
						<xsl:value-of select="@id" />
					</xsl:element>
					
					<xsl:element name="oai:datestamp">
						<xsl:value-of select="$date" />
					</xsl:element>
				</xsl:element>
				
				<xsl:element name="oai:metadata">
					
					<xsl:element name="oai_dc:dc" namespace="http://www.openarchives.org/OAI/2.0/oai_dc/">
						<xsl:namespace name="oai_dc" select="'http://www.openarchives.org/OAI/2.0/oai_dc/'" />
						<xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'" />
						<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'" />
						<xsl:attribute name="xsi:schemaLocation" select="'http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd'" />
						
						<xsl:element name="dc:title">
							<xsl:value-of select="$mono-title" />
							<xsl:text>: Prevention</xsl:text>
						</xsl:element>
						
						<xsl:element name="dc:type">
							<xsl:value-of select="$article-type" />
						</xsl:element>
						
						<xsl:for-each select="$monograph-plan//authors/person-link[@person-type='author']">
							<xsl:variable name="person" select="document(@target)//*" />
							<xsl:element name="dc:creator">
								<xsl:apply-templates select="$person//name" />
							</xsl:element>
						</xsl:for-each>
						
						<xsl:variable name="category-position">
							<xsl:choose>
								<xsl:when test="$mono-categories//category[string-length(normalize-space(.))!=0][position()=last()]">
									<xsl:value-of select="generate-id($mono-categories//category[string-length(normalize-space(.))!=0][position()=last()])" />
								</xsl:when>
								<xsl:when test="count($mono-categories//category[string-length(normalize-space(.))!=0])=1">
									<xsl:text>single</xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:for-each select="$mono-categories//category[string-length(normalize-space(.))!=0]">
							<xsl:element name="dc:subject">
								<xsl:value-of select="normalize-space(.)" />
							</xsl:element>
						</xsl:for-each>
						
						<xsl:element name="dc:description">
							<xsl:text>Prevention from monograph </xsl:text>
							<xsl:value-of select="$mono-title" />
						</xsl:element>
						
						<xsl:element name="dc:date">
							<xsl:value-of select="$date" />
						</xsl:element>
						
						<xsl:element name="dc:identifier">
							<xsl:text>http://bestpractice.bmj.com</xsl:text>
							<xsl:text>/best-practice/monograph/</xsl:text>
							<xsl:value-of select="$mono-id" />
							<xsl:text>/prevention.html</xsl:text>
						</xsl:element>
						
						<xsl:element name="dc:publisher">
							<xsl:value-of select="$bmj-publisher-glue-text/publisher-name[contains(@lang, $lang)]" />
						</xsl:element>
						
						<xsl:element name="dc:rights">&#169;<xsl:text disable-output-escaping="yes"> </xsl:text><xsl:value-of select="substring($date, 1, 4)" /></xsl:element>
						
					</xsl:element>
				</xsl:element>
			</xsl:element>			
		</xsl:if>
		
		
	</xsl:template>
	

	<xsl:template match="diagnosis" mode="diagnosis">
		
		<xsl:comment>
			<xsl:text>basics - diagnosis</xsl:text>
		</xsl:comment>		
		
		<xsl:element name="oai:record">
			
			<xsl:element name="oai:header">
				
				<xsl:element name="oai:identifier">
					<xsl:text>oai:bestpractice.bmj.com/</xsl:text>
					<xsl:value-of select="$mono-id" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="@id" />
				</xsl:element>
				
				<xsl:element name="oai:datestamp">
					<xsl:value-of select="$date" />
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="oai:metadata">
				
				<xsl:element name="oai_dc:dc" namespace="http://www.openarchives.org/OAI/2.0/oai_dc/">
					<xsl:namespace name="oai_dc" select="'http://www.openarchives.org/OAI/2.0/oai_dc/'" />
					<xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'" />
					<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'" />
					<xsl:attribute name="xsi:schemaLocation" select="'http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd'" />
					
					<xsl:element name="dc:title">
						<xsl:value-of select="$mono-title" />
						<xsl:text>: Diagnosis</xsl:text>
					</xsl:element>
					
					<xsl:element name="dc:type">
						<xsl:value-of select="$article-type" />
					</xsl:element>
					
					<xsl:for-each select="$monograph-plan//authors/person-link[@person-type='author']">
						<xsl:variable name="person" select="document(@target)//*" />
						<xsl:element name="dc:creator">
							<xsl:apply-templates select="$person//name" />
						</xsl:element>
					</xsl:for-each>
					
					<xsl:variable name="category-position">
						<xsl:choose>
							<xsl:when test="$mono-categories//category[string-length(normalize-space(.))!=0][position()=last()]">
								<xsl:value-of select="generate-id($mono-categories//category[string-length(normalize-space(.))!=0][position()=last()])" />
							</xsl:when>
							<xsl:when test="count($mono-categories//category[string-length(normalize-space(.))!=0])=1">
								<xsl:text>single</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:for-each select="$mono-categories//category[string-length(normalize-space(.))!=0]">
						<xsl:element name="dc:subject">
							<xsl:value-of select="normalize-space(.)" />
						</xsl:element>
					</xsl:for-each>
					
					<xsl:element name="dc:description">
						<xsl:text>Diagnosis from monograph </xsl:text>
						<xsl:value-of select="$mono-title" />
					</xsl:element>
					
					<xsl:element name="dc:date">
						<xsl:value-of select="$date" />
					</xsl:element>
					
					<xsl:element name="dc:identifier">
						<xsl:text>http://bestpractice.bmj.com</xsl:text>
						<xsl:text>/best-practice/monograph/</xsl:text>
						<xsl:value-of select="$mono-id" />
						<xsl:text>/diagnosis.html</xsl:text>
					</xsl:element>
					
					<xsl:element name="dc:publisher">
						<xsl:value-of select="$bmj-publisher-glue-text/publisher-name[contains(@lang, $lang)]" />
					</xsl:element>
					
					<xsl:element name="dc:rights">&#169;<xsl:text disable-output-escaping="yes"> </xsl:text><xsl:value-of select="substring($date, 1, 4)" /></xsl:element>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>			
	
	</xsl:template>
	
	<xsl:template name="evidence">

		<xsl:comment>
			<xsl:text>evidence</xsl:text>
		</xsl:comment>		
		
		<xsl:element name="oai:record">
			
			<xsl:element name="oai:header">
				
				<xsl:element name="oai:identifier">
					<xsl:text>oai:bestpractice.bmj.com/</xsl:text>
					<xsl:value-of select="$mono-id" />
					<xsl:text>/</xsl:text>
					<xsl:value-of select="@id" />
				</xsl:element>
				
				<xsl:element name="oai:datestamp">
					<xsl:value-of select="$date" />
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="oai:metadata">
				
				<xsl:element name="oai_dc:dc" namespace="http://www.openarchives.org/OAI/2.0/oai_dc/">
					<xsl:namespace name="oai_dc" select="'http://www.openarchives.org/OAI/2.0/oai_dc/'" />
					<xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'" />
					<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'" />
					<xsl:attribute name="xsi:schemaLocation" select="'http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd'" />
					
					<xsl:element name="dc:title">
						<xsl:value-of select="$mono-title" />
						<xsl:text>: Evidence</xsl:text>
					</xsl:element>
					
					<xsl:element name="dc:type">
						<xsl:value-of select="$article-type" />
					</xsl:element>
					
					<xsl:for-each select="$monograph-plan//authors/person-link[@person-type='author']">
						<xsl:variable name="person" select="document(@target)//*" />
						<xsl:element name="dc:creator">
							<xsl:apply-templates select="$person//name" />
						</xsl:element>
					</xsl:for-each>
					
					<xsl:variable name="category-position">
						<xsl:choose>
							<xsl:when test="$mono-categories//category[string-length(normalize-space(.))!=0][position()=last()]">
								<xsl:value-of select="generate-id($mono-categories//category[string-length(normalize-space(.))!=0][position()=last()])" />
							</xsl:when>
							<xsl:when test="count($mono-categories//category[string-length(normalize-space(.))!=0])=1">
								<xsl:text>single</xsl:text>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:for-each select="$mono-categories//category[string-length(normalize-space(.))!=0]">
						<xsl:element name="dc:subject">
							<xsl:value-of select="normalize-space(.)" />
						</xsl:element>
					</xsl:for-each>
					
					<xsl:element name="dc:description">
						<xsl:text>Evidence from monograph </xsl:text>
						<xsl:value-of select="$mono-title" />
					</xsl:element>
					
					<xsl:element name="dc:date">
						<xsl:value-of select="$date" />
					</xsl:element>
					
					<xsl:element name="dc:identifier">
						<xsl:text>http://bestpractice.bmj.com</xsl:text>
						<xsl:text>/best-practice/monograph/</xsl:text>
						<xsl:value-of select="$mono-id" />
						<xsl:text>/treatment/evidence.html</xsl:text>
					</xsl:element>
					
					<xsl:element name="dc:publisher">
						<xsl:value-of select="$bmj-publisher-glue-text/publisher-name[contains(@lang, $lang)]" />
					</xsl:element>
					
					<xsl:element name="dc:rights">&#169;<xsl:text disable-output-escaping="yes"> </xsl:text><xsl:value-of select="substring($date, 1, 4)" /></xsl:element>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>			
		
	</xsl:template>
	
	
	<xsl:template match="followup" mode="followup">
		
		<!-- Prognosis -->
		<xsl:if test="/followup/outlook">
			
			<xsl:comment>
				<xsl:text>basics - prognosis</xsl:text>
			</xsl:comment>		
			
			<xsl:element name="oai:record">
				
				<xsl:element name="oai:header">
					
					<xsl:element name="oai:identifier">
						<xsl:text>oai:bestpractice.bmj.com/</xsl:text>
						<xsl:value-of select="$mono-id" />
						<xsl:text>/</xsl:text>
						<xsl:value-of select="@id" />
					</xsl:element>
					
					<xsl:element name="oai:datestamp">
						<xsl:value-of select="$date" />
					</xsl:element>
				</xsl:element>
				
				<xsl:element name="oai:metadata">
					
					<xsl:element name="oai_dc:dc" namespace="http://www.openarchives.org/OAI/2.0/oai_dc/">
						<xsl:namespace name="oai_dc" select="'http://www.openarchives.org/OAI/2.0/oai_dc/'" />
						<xsl:namespace name="dc" select="'http://purl.org/dc/elements/1.1/'" />
						<xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'" />
						<xsl:attribute name="xsi:schemaLocation" select="'http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd'" />
						
						<xsl:element name="dc:title">
							<xsl:value-of select="$mono-title" />
							<xsl:text>: Prognosis</xsl:text>
						</xsl:element>
						
						<xsl:element name="dc:type">
							<xsl:value-of select="$article-type" />
						</xsl:element>
						
						<xsl:for-each select="$monograph-plan//authors/person-link[@person-type='author']">
							<xsl:variable name="person" select="document(@target)//*" />
							<xsl:element name="dc:creator">
								<xsl:apply-templates select="$person//name" />
							</xsl:element>
						</xsl:for-each>
						
						<xsl:variable name="category-position">
							<xsl:choose>
								<xsl:when test="$mono-categories//category[string-length(normalize-space(.))!=0][position()=last()]">
									<xsl:value-of select="generate-id($mono-categories//category[string-length(normalize-space(.))!=0][position()=last()])" />
								</xsl:when>
								<xsl:when test="count($mono-categories//category[string-length(normalize-space(.))!=0])=1">
									<xsl:text>single</xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:for-each select="$mono-categories//category[string-length(normalize-space(.))!=0]">
							<xsl:element name="dc:subject">
								<xsl:value-of select="normalize-space(.)" />
							</xsl:element>
						</xsl:for-each>
						
						<xsl:element name="dc:description">
							<xsl:text>Prognosis from monograph </xsl:text>
							<xsl:value-of select="$mono-title" />
						</xsl:element>
						
						<xsl:element name="dc:date">
							<xsl:value-of select="$date" />
						</xsl:element>
						
						<xsl:element name="dc:identifier">
							<xsl:text>http://bestpractice.bmj.com</xsl:text>
							<xsl:text>/best-practice/monograph/</xsl:text>
							<xsl:value-of select="$mono-id" />
							<xsl:text>/follow-up/prognosis.html</xsl:text>
						</xsl:element>
						
						<xsl:element name="dc:publisher">
							<xsl:value-of select="$bmj-publisher-glue-text/publisher-name[contains(@lang, $lang)]" />
						</xsl:element>
						
						<xsl:element name="dc:rights">&#169;<xsl:text disable-output-escaping="yes"> </xsl:text><xsl:value-of select="substring($date, 1, 4)" /></xsl:element>
						
					</xsl:element>
				</xsl:element>
			</xsl:element>			
		</xsl:if>
		
	</xsl:template>
	
</xsl:stylesheet>

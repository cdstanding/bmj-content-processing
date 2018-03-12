<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
	version="2.0">

	<xsl:output
		method="xml"
		version="1.0"
		encoding="UTF-8"
		indent="yes"
		use-character-maps="custom-map-renderx"
		/>
	<!--doctype-public="-//BMJ//DTD FO:ROOT//EN"
	doctype-system="http://www.renderx.com/Tests/validator/fo2000.dtd"-->
	
	<xsl:param name="lang"/>
	<xsl:param name="proof"/>
	<xsl:param name="server"/>
	<xsl:param name="components"/>
	<xsl:param name="date"/>
	<xsl:param name="images-path"/>
	<xsl:param name="resourse-export-path"/>
	<xsl:param name="strings-variant-fileset"/>
	
	<xsl:include href="../../xsl-entities/custom-map-renderx.xsl"/>
	<xsl:include href="../../xsl-lib/xinclude.xsl"/>
	
	<xsl:include href="../../generic-params.xsl"/>
	<xsl:include href="monograph-fo-params.xsl"/>
	
	<xsl:include href="../../xsl-lib/strings/publication-labels-process-shared.xsl"/>
	
	<xsl:include href="../generic-fo-page-sizes.xsl"/>
	<xsl:include href="../generic-fo-fonts.xsl"/>
	
	<xsl:include href="../generic-fo-default-elements.xsl"/>
	<xsl:include href="monograph-fo-inline-elements.xsl"/>
	
	<xsl:include href="monograph-shared-outline-match.xsl"/>
	<xsl:include href="monograph-fo-outline-output.xsl"/>
	<xsl:include href="monograph-shared-reference-lists.xsl"/>
	<xsl:include href="monograph-fo-standard-treatment-option.xsl"/>
	<xsl:include href="monograph-fo-evaluation-differential.xsl"/>
	
	<xsl:template match="authors | peer-reviewers | editors">
		<xsl:variable name="name" select="name()" />
		
		<xsl:element name="fo:block" use-attribute-sets="default-padding">
			
			<xsl:element name="fo:block" use-attribute-sets="h2">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:for-each select="person-link">
				<xsl:variable name="filename" select="concat($resourse-export-path, '/', @target)"/>
				<xsl:apply-templates select="document($filename)/monograph-person/node()"/>	
			</xsl:for-each>
			
			<xsl:element name="fo:block" use-attribute-sets="">
				
				<xsl:for-each select="person-link">
					<xsl:variable name="filename" select="concat($resourse-export-path, '/', @target)"/>
					
					<xsl:if test="document($filename)//disclosures[string-length(normalize-space(.))!=0]">
						
						<xsl:element name="fo:block" use-attribute-sets="">
							<xsl:apply-templates select="document($filename)//disclosures[string-length(normalize-space(.))!=0]/node()"/>
						</xsl:element>
						
					</xsl:if>
					
				</xsl:for-each>
				
			</xsl:element>
			
		</xsl:element>
		
		<!-- include author photo's -->
		<xsl:if test="person-link[parent::authors and document(concat($resourse-export-path, '/', @target))]//author//image-link[string-length(normalize-space(.))!=0]">
			
			<xsl:element name="fo:block" use-attribute-sets="">
				
				<xsl:for-each select="person-link[parent::authors]">
					
					<xsl:variable name="filename" select="concat($resourse-export-path, '/', @target)"/>
					<xsl:variable name="author" select="document($filename)//author"/>
					
					<xsl:element name="fo:block" use-attribute-sets="">

						<xsl:apply-templates select="$author//image-link"/>
						
						<xsl:element name="fo:block" use-attribute-sets="">
							<xsl:apply-templates select="$author//name/node()"/>
							<xsl:text disable-output-escaping="yes"> </xsl:text>
							<xsl:apply-templates select="$author//degree/node()"/>
						</xsl:element>
						
					</xsl:element>
					
				</xsl:for-each>
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="author | peer-reviewer | editor">
		<xsl:variable name="person-id" select="concat(name(), '-', position())"/>
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:element name="fo:block" use-attribute-sets="">
				<xsl:apply-templates select="name/node()"/>
			</xsl:element>
			
			<xsl:element name="fo:block">
				<xsl:for-each select="title-affil/para">
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:apply-templates />
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<!-- documentinfo property -->
	<xsl:template match="deadline-date">
		
		<xsl:element name="fo:block" use-attribute-sets="default-padding">
			<xsl:apply-templates/>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="section">
		
		<xsl:element name="fo:block" use-attribute-sets="default-padding">
			<xsl:apply-templates />
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="section-header">
		
		<xsl:element name="fo:block" use-attribute-sets="h3">
			<xsl:apply-templates />
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="section-text">
		
		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:apply-templates />
		</xsl:element>
		
	</xsl:template>
	
	<!-- our stylesheet might get confused which namespace to match 
		for variable content passed back with apply-templates --> 
	<!--<xsl:template match="figures">
		<xsl:apply-templates/>
	</xsl:template>-->
	
	<xsl:template match="figure">
		
		<xsl:element name="fo:block" use-attribute-sets="default-padding">
			
			<xsl:attribute name="id">
				<xsl:text>fig</xsl:text>
				<xsl:value-of select="processing-instruction()[name()='position']"/>
			</xsl:attribute>
			
			<xsl:apply-templates select="image-link"/>
			<xsl:element name="fo:block" use-attribute-sets="default-padding">
				<xsl:apply-templates select="caption" />
				<xsl:apply-templates select="source[string-length(normalize-space(.))!=0]" />
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="figure" mode="inline">
		
		<xsl:element name="fo:block" use-attribute-sets="default-padding">
			
			<xsl:apply-templates select="image-link"/>
			<xsl:element name="fo:block" use-attribute-sets="default-padding">
				<xsl:apply-templates select="caption" />
				<xsl:apply-templates select="source[string-length(normalize-space(.))!=0]" />
			</xsl:element>
			
		</xsl:element>
			
	</xsl:template>
	
	<xsl:template match="image-link">
		
		<xsl:element name="fo:external-graphic" use-attribute-sets="align-center">
			<xsl:attribute name="scaling">uniform</xsl:attribute>
			<xsl:attribute name="content-width">140mm</xsl:attribute>
		
			<xsl:attribute name="src">
				<xsl:text>url('</xsl:text>
				<xsl:value-of select="$images-path"/>
				<xsl:value-of 
					select="
					replace(
					@target
					, '^\.\./monograph-images/(.+?)(_default)?\.(.+?)$'
					, '$1$2.$3')
					"/>
				<xsl:text>')</xsl:text>
			</xsl:attribute>
			
		</xsl:element>

	</xsl:template>
	
	<xsl:template match="caption">
		
		<xsl:element name="fo:block" use-attribute-sets="align-center">
			<xsl:apply-templates/>
		</xsl:element>
		
	</xsl:template>	
	
	<xsl:template match="source">
		
		<xsl:element name="fo:block" use-attribute-sets="align-center">
			
			<xsl:element name="fo:inline" use-attribute-sets="strong">
				<xsl:text>Source: </xsl:text>
			</xsl:element>
			
			<xsl:choose>
				
				<!-- todo following-sibling http may appear more than once, cause error -->
				<xsl:when test="starts-with(normalize-space(.), 'http') and count(tokenize(normalize-space(.), ' '))=0">
					<xsl:element name="fo:basic-link" use-attribute-sets="link">
						<xsl:attribute name="external-destination">
							<xsl:text>url('</xsl:text>
							<xsl:value-of select="normalize-space(.)"/>
							<xsl:text>')</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="normalize-space(.)"/>
					</xsl:element>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(.)"/>
				</xsl:otherwise>
				
			</xsl:choose>
			
		</xsl:element>
		
	</xsl:template>
	
	<!-- todo: this is not getting used!? -->
	<xsl:template match="evidence-score">
		<xsl:param name="position-id" select="generate-id()"/>
		
		<xsl:element name="fo:list-item" use-attribute-sets="">
			
			<xsl:for-each select="parent::*/*">
				
				<xsl:if test="generate-id()=$position-id">
					<xsl:attribute name="id">
						<xsl:text>evid</xsl:text>
						<xsl:value-of select="position()" />
					</xsl:attribute>
				</xsl:if>
				
			</xsl:for-each>
			
			<xsl:element name="fo:list-item-label" use-attribute-sets="">
				<xsl:attribute name="end-indent">label-end()</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="">
					<xsl:element name="fo:inline" use-attribute-sets="">
						<xsl:attribute name="padding-left">10pt</xsl:attribute>
						
						<xsl:for-each select="parent::*/*">
							
							<xsl:if test="generate-id()=$position-id">
								
								<xsl:element name="fo:block" use-attribute-sets="">
									<xsl:text>e</xsl:text>
									<xsl:value-of select="position()" />
									<xsl:text>.</xsl:text>
								</xsl:element>
								
							</xsl:if>
							
						</xsl:for-each>
						
					</xsl:element>
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:list-item-body" use-attribute-sets="">
				<xsl:attribute name="start-indent">body-start()</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="">
					
					<xsl:apply-templates 
						select="
						preceding-sibling::node()[1]
						[
						self::text() 
						and string-length(normalize-space(.))=0
						]
						/preceding-sibling::node()[1]
						[
						self::processing-instruction() 
						and name() = 'serna-redline-start'
						]
						
						|
						
						preceding-sibling::node()[1]
						[
						self::processing-instruction() 
						and name() = 'serna-redline-start'
						]
						">
						<xsl:with-param name="process-redline" select="string('true')"/>
					</xsl:apply-templates>
					
					<xsl:apply-templates select="comments/node()"/>
					
					<!--<xsl:value-of select="$prompt-separator"/>-->
					
					<!--TODO bmj-url or option-link??-->
					<xsl:if test="option-link">
						
						<xsl:element name="fo:inline" use-attribute-sets="strong">
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="string('option-link')"/>
							</xsl:call-template>
							<xsl:text>: </xsl:text>
						</xsl:element>
						
						<xsl:element name="fo:basic-link" use-attribute-sets="link">
							<xsl:attribute name="internal-destination" select="@target"/>
							<xsl:text>[</xsl:text>
							<xsl:text>link</xsl:text>
							<xsl:text>]</xsl:text>
						</xsl:element>
						
						<!--<xsl:value-of select="$prompt-separator"/>-->
						
					</xsl:if>
					
					<xsl:apply-templates select="@score"/> 
					
					<xsl:apply-templates 
						select="
						following-sibling::node()[1]
						[
						self::text() 
						and string-length(normalize-space(.))=0
						]
						/following-sibling::node()[1]
						[
						self::processing-instruction() 
						and name() = 'serna-redline-end'
						]

						|

						following-sibling::node()[1]
						[
						self::processing-instruction() 
						and name() = 'serna-redline-end'
						]
						">
						<xsl:with-param name="process-redline" select="string('true')"/>
					</xsl:apply-templates>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="reference[parent::key-article-references]">
		
		<xsl:element name="fo:list-item" use-attribute-sets="">
			
			<xsl:element name="fo:list-item-label" use-attribute-sets="">
				<xsl:attribute name="end-indent">label-end()</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="strong">
					<xsl:element name="fo:inline" use-attribute-sets="">
						<xsl:attribute name="padding-left">10pt</xsl:attribute>
						<xsl:value-of select="$bullet-icon"/>
					</xsl:element>
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:list-item-body" use-attribute-sets="">
				<xsl:attribute name="start-indent">body-start()</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="">
					
					<xsl:apply-templates select="poc-citation/citation/node()"/>
					
					<xsl:if test="unique-id[@source='medline' and string-length(normalize-space(.))!=0]">
						
						<xsl:element name="fo:basic-link" use-attribute-sets="link">
							<xsl:attribute name="external-destination">
								<xsl:text>url('</xsl:text>
								<xsl:value-of select="concat($pubmed-url, unique-id)" />
								<xsl:text>')</xsl:text>
							</xsl:attribute>
							<xsl:text>[</xsl:text>
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="string('abstract-url')"/>
							</xsl:call-template>
							<xsl:text>]</xsl:text>
						</xsl:element>
						
					</xsl:if>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="reference[parent::online-references]">
		
		<xsl:element name="fo:list-item" use-attribute-sets="">
			
			<xsl:attribute name="id">
				<xsl:text>web</xsl:text>
				<xsl:value-of select="processing-instruction()[name()='position']"/>
			</xsl:attribute>
			
			<xsl:element name="fo:list-item-label" use-attribute-sets="">
				<xsl:attribute name="end-indent">label-end()</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="">
					<xsl:element name="fo:inline" use-attribute-sets="">
						<xsl:attribute name="padding-left">10pt</xsl:attribute>
						
						<xsl:element name="fo:block" use-attribute-sets="">
							<xsl:text>w</xsl:text>
							<xsl:value-of select="processing-instruction()[name()='position']"/>
							<xsl:text>.</xsl:text>
						</xsl:element>
						
					</xsl:element>
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:list-item-body" use-attribute-sets="">
				<xsl:attribute name="start-indent">body-start()</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="">
					
					<xsl:element name="fo:basic-link" use-attribute-sets="link">
						<xsl:attribute name="external-destination">
							<xsl:text>url('</xsl:text>
							<xsl:value-of select="poc-citation/url" />
							<xsl:text>')</xsl:text>
						</xsl:attribute>
						<xsl:apply-templates select="title/node()"/>
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<!--<xsl:template match="combined-references | article-references">
		
		<xsl:element name="fo:block" use-attribute-sets="default-padding">
			<xsl:apply-templates/>
		</xsl:element>
		
	</xsl:template>-->
	
	<xsl:template match="reference[parent::article-references]">
		
		<xsl:element name="fo:list-item" use-attribute-sets="">
			
			<xsl:attribute name="id">
				<xsl:text>ref</xsl:text>
				<xsl:value-of select="processing-instruction()[name()='position']"/>
			</xsl:attribute>
			
			<xsl:element name="fo:list-item-label" use-attribute-sets="">
				<xsl:attribute name="end-indent">label-end()</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="">
					<xsl:attribute name="padding-left">10pt</xsl:attribute>
					<xsl:value-of select="processing-instruction()[name()='position']"/>
					<xsl:text>.</xsl:text>
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:list-item-body" use-attribute-sets="">
				<xsl:attribute name="start-indent">body-start()</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="">
					
					<xsl:apply-templates select="poc-citation/citation/node()"/>
					
					<xsl:if test="unique-id[@source='medline' and string-length(normalize-space(.))!=0]">
						
						<xsl:element name="fo:basic-link" use-attribute-sets="link">
							<xsl:attribute name="external-destination">
								<xsl:text>url('</xsl:text>
								<xsl:value-of select="concat($pubmed-url, unique-id)" />
								<xsl:text>')</xsl:text>
							</xsl:attribute>
							<xsl:text>[</xsl:text>
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="string('abstract-url')"/>
							</xsl:call-template>
							<xsl:text>]</xsl:text>
						</xsl:element>
						
					</xsl:if>
					
					<xsl:if test="poc-citation/fulltext-url[string-length(normalize-space(.))!=0]">
						
						<xsl:element name="fo:basic-link" use-attribute-sets="link">
							<xsl:attribute name="external-destination">
								<xsl:attribute name="external-destination">
									<xsl:text>url('</xsl:text>
									<xsl:value-of select="normalize-space(poc-citation/fulltext-url)" />
									<xsl:text>')</xsl:text>
								</xsl:attribute>
							</xsl:attribute>
							<xsl:text>[</xsl:text>
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="string('fulltext-url')"/>
							</xsl:call-template>
							<xsl:text>]</xsl:text>
						</xsl:element>
						
					</xsl:if>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<!-- para prompt _not_ enumerated -->
	<xsl:template match="
		source[parent::guideline] | 
		last-published | 
		tx-type | 
		parent-pt-group | 
		pt-group | 
		category | 
		result
		"><!--source[parent::figure] |-->
		<xsl:variable name="name" select="name()" />
		
		<xsl:element name="fo:block" use-attribute-sets="default-padding">
			
			<xsl:element name="fo:block" use-attribute-sets="">
				
				<xsl:element name="fo:inline" use-attribute-sets="strong">
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="$name"/>
					</xsl:call-template>
					<xsl:text>: </xsl:text>
				</xsl:element>
				
				<xsl:apply-templates />
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="url[parent::guideline]">
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:element name="fo:basic-link" use-attribute-sets="link">
				<xsl:attribute name="external-destination">
					<xsl:attribute name="external-destination">
						<xsl:text>url('</xsl:text>
						<xsl:value-of select="."/>
						<xsl:text>')</xsl:text>
					</xsl:attribute>
				</xsl:attribute>
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="string('guideline-url')"/>
				</xsl:call-template>
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<!-- inline prompt -->
	<!-- ??NOTE removed @strength |@order | @key-factor are now being managed to group section -->
	<xsl:template match="
		@id | 
		@dx-id | 
		@tier | 
		@score | 
		@likelihood | 
		@modifier | 
		@tx-line | 
		@frequency |  
		@timeframe[parent::complication] | 
		@timeframe[parent::tx-option] | 
		@type[parent::poc-citation] | 
		@key-article | 
		@common | 
		@red-flag | 
		@first | 
		@strength |
		@order | 
		@key-factor 
		"> 
		
		<xsl:variable name="name" select="name()" />
		
		<xsl:element name="fo:inline" use-attribute-sets="strong">
			<xsl:call-template name="process-string-variant">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
			<xsl:text>: </xsl:text>
		</xsl:element>
		
		<xsl:element name="fo:inline" use-attribute-sets="">
			<xsl:value-of select="."/>
			<xsl:text disable-output-escaping="yes"> </xsl:text>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="
		@type[parent::test] | 
		@type[parent::factor]  
		">

		<xsl:variable name="name" select="name()" />
		
		<xsl:element name="fo:inline" use-attribute-sets="strong">
			<xsl:call-template name="process-string-variant">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
			<xsl:text>: </xsl:text>
		</xsl:element>
		
		<xsl:element name="fo:inline" use-attribute-sets="">
			<xsl:value-of select="."/>
			<xsl:text> </xsl:text>
		</xsl:element>
		
	</xsl:template>
	
	<!-- dev output test -->
	<xsl:template match="element()|@*">
		<xsl:comment select="concat('unmatched-', name())"/>
	</xsl:template>
	
	<xsl:template match="comment()">
		<xsl:copy-of select="." />
	</xsl:template>
	
	
</xsl:stylesheet>

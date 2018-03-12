<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
	version="2.0">

	<xsl:output 
		method="xml" 
		encoding="UTF-8"
		indent="yes" 
		exclude-result-prefixes="xi"/>
	
	<xsl:strip-space elements="reference-link figure-link organism drug"/>
	
	<xsl:param name="topresourcepath"/>
	<xsl:param name="metapath"/>
	
	<xsl:param name="title-synonyms"/>
	
	<xsl:param name="path"/>
	<xsl:param name="server"/>
	
	<xsl:param name="date-amended"/>
	<xsl:param name="date-updated"/>
	<xsl:param name="last-reviewed"/>

	<xsl:param name="date-amended-iso"/>
	<xsl:param name="date-updated-iso"/>
	<xsl:param name="last-reviewed-iso"/>
	<xsl:param name="todays-date-iso"/>
	
	<xsl:param name="first-publication"/>
	<xsl:param name="first-publication-iso"/>
	<xsl:param name="lang"/>
	<xsl:param name="mono-id"/>
	
	
	<xsl:param name="pubmed-url">http://www.ncbi.nlm.nih.gov/pubmed/</xsl:param>
	 <xsl:param name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝ'"/>
	 <xsl:param name="lower" select="'abcdefghijklmnopqrstuvwxyzáâãäåæçèéêëìíîïðñòóôõöøùúûüý'"/>
	
	<xsl:param name="titleSynonymsList" select="document(concat('file:///', $title-synonyms))"></xsl:param> 
	
	<xsl:include href="monograph-row-standard-treatment-option.xsl"/>
	<xsl:include href="monograph-shared-reference-lists.xsl"/>
	<xsl:include href="../../xsl-lib/strings/monograph-strings.xsl"/>
	
	<xsl:variable name="monograph-plan" select="document(concat($path, '/', //monograph-info/monograph-plan-link/@target))"/>
	
	
	<!-- Xinclude stuff START -->
	
	<xsl:template name="xinclude-copy-attributes">
		<xsl:param name="version"/>
		<xsl:for-each select="./@*[name()!='xsi:noNamespaceSchemaLocation']">
			<xsl:copy-of select="." />
		</xsl:for-each>
		<xsl:if test="$version != ''">
			<xsl:attribute name="version" select="$version"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="//xi:include">
				<xsl:variable name="resolved-doc">
					<xsl:apply-templates mode="xinclude" />
				</xsl:variable>
				<xsl:apply-templates select="$resolved-doc" mode="normal" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="/" mode="normal">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="node()" mode="xinclude">
		<xsl:param name="version"/>
		<xsl:copy>
			<xsl:call-template name="xinclude-copy-attributes" >
				<xsl:with-param name="version" select="$version"/>
			</xsl:call-template>
			<xsl:apply-templates select="node()" mode="xinclude" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="xi:include" mode="xinclude">
		<xsl:variable name="xpath" select="@href" />
		<xsl:choose>
			<xsl:when test="$xpath != ''">
				
				<!-- look up version number in meta-->
				<xsl:choose>
					
					<!-- short tx option -->
					<xsl:when test="starts-with(@href, 'tx-option-') or starts-with(@href, 'monograph-standard-treatment-option-')">
						<xsl:variable name="metadoc" select="document(translate(concat($metapath, '/monograph-standard-treatment-option/',@href),'\','/'))"/>
						<xsl:variable name="version" select="$metadoc//version"/>
						
						<xsl:message>version:<xsl:value-of select="$version"/> path:<xsl:value-of select="translate(concat($metapath, '/monograph-standard-treatment-option/',@href),'\','/')"/></xsl:message>
						
						<xsl:message>including <xsl:value-of select="$xpath"/></xsl:message>
						<xsl:comment>including <xsl:value-of select="$xpath"/></xsl:comment>
						
						<xsl:apply-templates select="document($xpath)" mode="xinclude" >
							<xsl:with-param name="version" select="$version"/>
						</xsl:apply-templates>
						
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:variable name="metadoc" select="document(translate(concat($metapath, replace(@href,'\.\./','/')),'\','/'))"/>
						<xsl:variable name="version" select="$metadoc//version"/>
						
						<xsl:message>version:<xsl:value-of select="$version"/> path:<xsl:value-of select="translate(concat($metapath, replace(@href,'\.\./','/')),'\','/')"/></xsl:message>
						
						<xsl:message>including <xsl:value-of select="$xpath"/></xsl:message>
						<xsl:comment>including <xsl:value-of select="$xpath"/></xsl:comment>
						
						<xsl:apply-templates select="document($xpath)" mode="xinclude" >
							<xsl:with-param name="version" select="$version"/>
						</xsl:apply-templates>
						
					</xsl:otherwise>
					
				</xsl:choose>
				
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:message>Xinclude: Failed to get a value for the href= attribute of xi:include element.</xsl:message>
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
	<!-- Xinclude stuff END-->
	
	<xsl:template match="/*">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="{$name}">
			
			<xsl:namespace name="xi">http://www.w3.org/2001/XInclude</xsl:namespace>
			
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">
				<xsl:text>http://schema.bmj.com/delivery/rowan/bmjk-monograph-row-</xsl:text>
				<xsl:choose>
					<xsl:when test="contains($name, 'full')">
						<xsl:text>standard</xsl:text>
					</xsl:when>
					<xsl:when test="contains($name, 'eval')">
						<xsl:text>evaluation</xsl:text>
					</xsl:when>
					<xsl:when test="contains($name, 'overview')">
						<xsl:text>overview</xsl:text>
					</xsl:when>
					<xsl:when test="contains($name, 'generic')">
						<xsl:text>generic</xsl:text>
					</xsl:when>
				</xsl:choose>
				<xsl:text>.xsd</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="dx-id" select="@dx-id"/>
			<xsl:attribute name="lang" select="$lang"/>
			
			<!-- look up version number in meta-->
			<xsl:variable name="metadoc" select="document(translate(replace($topresourcepath,'bmjk','meta/bmjk'),'\','/'))"></xsl:variable>
			<xsl:attribute name="version"><xsl:value-of select="$metadoc//version"/></xsl:attribute>
			<!-- xsl:comment><xsl:value-of select="translate(replace($topresourcepath,'bmjk','meta/bmjk'),'\','/')"/></xsl:comment -->
			
			<xsl:apply-templates select="*[name()!='evidence-scores'][name()!='figures']"/>
			
			<xsl:variable name="article-references">
				 <xsl:element name="references">
					<xsl:element name="article-references">
						<xsl:call-template name="process-article-reference-links">
							<xsl:with-param name="item-count" select="1"/>
							<xsl:with-param name="link-index" select="1"/>
							<xsl:with-param name="link-count" select="count(//reference-link[@type='article']) + 1"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element> 
			</xsl:variable>
			
			<xsl:variable name="online-references">
				<xsl:element name="references">
					<xsl:element name="online-references">
						<xsl:call-template name="process-online-reference-links">
							<xsl:with-param name="item-count" select="1"/>
							<xsl:with-param name="link-index" select="1"/>
							<xsl:with-param name="link-count" select="count(//reference-link[@type='online']) + 1"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:element>
			</xsl:variable>

			<xsl:apply-templates select="//figures"/>
			
			<xsl:if test="//evidence-score-link">
				<xsl:apply-templates select="//evidence-scores"/>
			</xsl:if>
			
			<xsl:if test="//reference-link[@type='article']">
				<xsl:apply-templates select="$article-references//article-references"/>
			</xsl:if>
			
			<xsl:if test="//reference-link[@type='online']">
				<xsl:apply-templates select="$online-references//online-references"/>
			</xsl:if>
			
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="monograph-info">
		<xsl:element name="monograph-info">
			
			<xsl:element name="amended-date">
				<xsl:choose>
					<xsl:when test="$server='offline'">
						<xsl:text>2008-08-08</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="iso" select="$date-amended-iso"/>
						<xsl:value-of select="$date-amended"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="last-updated">
				<xsl:choose>
					<xsl:when test="$server='offline'">
						<xsl:text>2008-08-08</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="iso" select="$date-updated-iso"/>
						<xsl:value-of select="$date-updated"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="export-date">
				<xsl:choose>
					<xsl:when test="$server='offline'">
						<xsl:text>2008-08-08</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="iso" select="$todays-date-iso"/>
						<xsl:value-of select="legacytag:getTodaysDate()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="last-reviewed">
				<xsl:choose>
					<xsl:when test="$server='offline'">
						<xsl:text>2008-08-08</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="iso" select="$last-reviewed-iso"/>
						<xsl:value-of select="$last-reviewed"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="first-publication">
				<xsl:choose>
					<xsl:when test="$server='offline'">
						<xsl:text>2008-08-08</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="iso" select="$first-publication-iso"/>
						<xsl:value-of select="$first-publication"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			
			<xsl:choose>
				<xsl:when test="$titleSynonymsList//monograph[@id=$mono-id]//title">
					<xsl:apply-templates select="$titleSynonymsList//monograph[@id=$mono-id]//title"/>
				</xsl:when>
				<xsl:otherwise><xsl:apply-templates select="title"/></xsl:otherwise>
			</xsl:choose>
			
			
			<xsl:apply-templates select="$monograph-plan//monograph-info/authors"/>
			<xsl:apply-templates select="$monograph-plan//monograph-info/peer-reviewers"/>
			<xsl:apply-templates select="$monograph-plan//monograph-info/editors"/>

			<xsl:choose>
				<xsl:when test="$titleSynonymsList//monograph[@id=$mono-id]//topic-synonyms">
					<xsl:apply-templates select="$titleSynonymsList//monograph[@id=$mono-id]//topic-synonyms"/>
				</xsl:when>
				<xsl:otherwise><xsl:apply-templates select="topic-synonyms"/></xsl:otherwise>
			</xsl:choose>

			<xsl:apply-templates select="related-topics[monograph-link]"/>
			<xsl:apply-templates select="related-patient-summaries"/>
			<xsl:apply-templates select="categories"/>
			<!--  Added for Mantis ID 12117 -->
			 <xsl:apply-templates select="mono-version-history"/> 
			
			
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="synonym[string-length(.)=0]">
		<!-- do nothing -->
	</xsl:template>
	
	<xsl:template match="category[parent::differential]">
		<xsl:element name="category">
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="person-link">
		<xsl:apply-templates select="document(concat($path, '/', @target))/monograph-person/*"/>
	</xsl:template>
	
	<xsl:template match="reference">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@id"/>
			<xsl:if test="@status">
			<xsl:copy-of select="@status"/>
			</xsl:if>
			
			<xsl:apply-templates select="title"/>
			<xsl:apply-templates select="unique-id"/>
			<xsl:apply-templates select="poc-citation"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="reference-link[@type='article']">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="article-references">
			<xsl:element name="article-references">
				<xsl:element name="reference">
					 <xsl:call-template name="process-article-reference-links">
						<xsl:with-param name="item-count" select="1"/>
						<xsl:with-param name="link-index" select="1"/>
						<xsl:with-param name="link-count" select="count(//reference-link[@type='article']) + 1"/>
					</xsl:call-template> 
				</xsl:element>
			</xsl:element>
		</xsl:variable>
		<xsl:element name="{$name}">	
			<xsl:for-each select="$article-references//reference">
				<xsl:if test="processing-instruction()[name()='target'] = $target">
					<xsl:attribute name="target" select="processing-instruction()[name()='position']"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:attribute name="type" select="@type"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="reference-link[@type='online']">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="online-references">
			<xsl:element name="online-references">
				<xsl:element name="reference">
					 <xsl:call-template name="process-online-reference-links">
						<xsl:with-param name="item-count" select="1"/>
						<xsl:with-param name="link-index" select="1"/>
						<xsl:with-param name="link-count" select="count(//reference-link[@type='online']) + 1"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:variable>
			
		<xsl:for-each select="$online-references//reference">
			<xsl:if test="processing-instruction()[name()='target'] = $target">
				<xsl:element name="reference">
			 		<xsl:apply-templates select="title"/>
					<xsl:apply-templates select="poc-citation"/> 
				</xsl:element>
			</xsl:if>
		</xsl:for-each>

	</xsl:template>
	
	<xsl:template match="evidence-score">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="position-id" select="generate-id()"/>
		
		<xsl:for-each select="parent::*/*">
			<xsl:if test="generate-id()=$position-id">
				<xsl:element name="{name()}">
					<xsl:attribute name="id" select="position()" />
					<xsl:attribute name="score" select="@score"/>
					<xsl:if test="@version">
						<xsl:attribute name="version" select="@version"/>
					</xsl:if>
					<xsl:apply-templates/>	
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template match="evidence-score-link">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="target" select="@target"/>
		
		<xsl:for-each select="//evidence-score">
			<xsl:variable name="id" select="substring-after(preceding-sibling::comment()[1], 'including ')"/>
			<xsl:variable name="position-id" select="generate-id()"/>
			<xsl:if test="$id = $target">
				<xsl:for-each select="parent::*/*">
					<xsl:if test="generate-id()=$position-id">
						<xsl:element name="{$name}">
							<xsl:attribute name="target" select="position()" />
							<xsl:attribute name="score" select="document(concat($path, '/', $target))//@score"/>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="figure">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="position-id" select="generate-id()"/>
		
		<xsl:for-each select="parent::*/*">
			<xsl:if test="generate-id()=$position-id">
				<xsl:element name="{name()}">
					<xsl:attribute name="id" select="position()" />
					<xsl:if test="@version">
						<xsl:attribute name="version" select="@version"/>
					</xsl:if>
					<!-- Added for Mantis ID 12117 -->
					<xsl:if test="@status">
						<xsl:attribute name="status" select="@status"/>
					</xsl:if>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template match="figure-link">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="inline" select="@inline"/>
		
		<xsl:for-each select="//figures/figure">
			<xsl:variable name="id" select="substring-after(preceding-sibling::comment()[1], 'including ')"/>
			<xsl:variable name="position-id" select="generate-id()"/>
			<xsl:if test="$id = $target">
				<xsl:for-each select="parent::*/*">
					<xsl:if test="generate-id()=$position-id">
						
						<!-- export thumb nail image if found in respositiory -->
						<!-- xsl:variable name="image-name" select="substring-after(image-link/@target, 'images/')"/>
						<xsl:variable name="image-path" select="concat(substring-before($path, 'monograph-plan'), 'monograph-images')"/>
						
						<xsl:if test="$server!='offline'">
							<xsl:processing-instruction name="thumb">
								<xsl:value-of select="legacytag:copyOverThumbImages($image-path ,$image-name)"/>
							</xsl:processing-instruction>
						</xsl:if -->
						
						<xsl:choose>
							<xsl:when test="$inline = 'true'">
								<xsl:element name="figure">
									<xsl:apply-templates select="image-link"/>
									<xsl:apply-templates select="caption"/>
									<xsl:apply-templates select="source"/>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:element name="{$name}">
									<xsl:attribute name="target" select="position()"/>
									<xsl:attribute name="inline" select="$inline"/>
								</xsl:element>					
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:if>
					
				</xsl:for-each>
				
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template match="caption[parent::figure]">
		<xsl:element name="caption">
			<xsl:for-each select="node()">
				<xsl:choose>
					<xsl:when test="position()!=last()">
						<xsl:apply-templates select="self::node()"/>
					</xsl:when>
					<xsl:when test="position()=last() and self::text() and matches(self::node(), '^.*\. *$$')">
						<xsl:value-of select="replace(self::node(), '^(.*)\. *$$', '$1')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="self::node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="image-link">
		<xsl:element name="{name()}">
			<xsl:attribute name="target">
				<xsl:text>../images/</xsl:text>
				<xsl:value-of select="substring-after(@target, 'images/')"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="monograph-link">
		<xsl:choose>
			<xsl:when test="contains(@target, '../')">
				<xsl:variable name="mono-doc" select="document(concat($path, '/', @target))"/>
				<xsl:element name="monograph-link">
					<xsl:attribute name="target" select="concat($mono-doc/node()/@dx-id,'.xml')"/>
					<!-- if in related links section then get title from source doc -->
					<xsl:choose>
					<!-- Dont get the title from the related monograph for Brazilian monographs  -->
						<xsl:when test="parent::related-topics and $lang != 'pt-br'">
							<xsl:value-of select="$mono-doc/node()/monograph-info/title"/>						
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates />						
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="file-type" select="/node()/name()"/>
					<xsl:choose>
						<xsl:when test="$file-type = 'monograph-eval'">
							<xsl:variable name="mono-doc" select="document(concat($path, '/', '../monograph-evaluation/',@target))"/>
							<xsl:element name="monograph-link">
								<xsl:attribute name="target" select="concat($mono-doc/node()/@dx-id,'.xml')"/>
								<!-- if in related links section then get title from source doc -->
								<xsl:choose>
								<!-- Dont get the title from the related monograph for Brazilian monographs  -->
									<xsl:when test="parent::related-topics and $lang != 'pt-br'">
										<xsl:value-of select="$mono-doc/node()/monograph-info/title"/>						
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates />						
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:when>
						<xsl:when test="$file-type = 'monograph-generic'">
							<xsl:variable name="mono-doc" select="document(concat($path, '/', '../monograph-generic/',@target))"/>
							<xsl:element name="monograph-link">
								<xsl:attribute name="target" select="concat($mono-doc/node()/@dx-id,'.xml')"/>
								<!-- if in related links section then get title from source doc -->
								<xsl:choose>
								<!-- Dont get the title from the related monograph for Brazilian monographs  -->
									<xsl:when test="parent::related-topics and $lang != 'pt-br'">
										<xsl:value-of select="$mono-doc/node()/monograph-info/title"/>						
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates />						
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:when>
						<xsl:when test="$file-type = 'monograph-overview'">
							<xsl:variable name="mono-doc" select="document(concat($path, '/', '../monograph-overview/',@target))"/>
							<xsl:element name="monograph-link">
								<xsl:attribute name="target" select="concat($mono-doc/node()/@dx-id,'.xml')"/>
								<!-- if in related links section then get title from source doc -->
								<xsl:choose>
								<!-- Dont get the title from the related monograph for Brazilian monographs  -->
									<xsl:when test="parent::related-topics and $lang != 'pt-br'">
										<xsl:value-of select="$mono-doc/node()/monograph-info/title"/>						
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates />						
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:when>
						<xsl:when test="$file-type = 'monograph-full'">
							<xsl:variable name="mono-doc" select="document(concat($path, '/', '../monograph-standard/',@target))"/>
							<xsl:element name="monograph-link">
								<xsl:attribute name="target" select="concat($mono-doc/node()/@dx-id,'.xml')"/>
								<!-- if in related links section then get title from source doc -->
								<xsl:choose>
								<!-- Dont get the title from the related monograph for Brazilian monographs  -->
									<xsl:when test="parent::related-topics and $lang != 'pt-br'">
										<xsl:value-of select="$mono-doc/node()/monograph-info/title"/>						
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates />						
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:when>
					</xsl:choose>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="option-link">
		<xsl:variable name="target" select="@target"/>
		
		<!-- get topic id -->
		<xsl:variable name="topicid" select="legacytag:getSystematicReviewId($target)"/>
		
		<!-- get option id -->
		<xsl:variable name="optionid">
			<xsl:choose>
				<!-- old option file name '../options/_op0203_I5.xml' -->
				<xsl:when test="contains($target,'_op')">
					<xsl:text>I</xsl:text>
					<xsl:value-of select="substring-before((substring-after($target, 'I')),'.xml')"/>
				</xsl:when>
				<!-- new option file name '../options/option-1194864898395.xml' -->
				<xsl:otherwise>
					<xsl:text>I</xsl:text>
					<xsl:value-of select="substring-before((substring-after($target, '-')),'.xml')"/>
				</xsl:otherwise>
			</xsl:choose>	
		</xsl:variable>
		
		<xsl:element name="option-link">
			<xsl:attribute name="target" select="concat($topicid, '/', $optionid)"/>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="patient-summary-link">
		<xsl:element name="patient-summary-link">
			<!--ie Stopping smoking
				resource uri = /bmjk/patient-summary/patient-summary-1183649906149
				target = ../patient-summary/patient-summary-1183649906149.xml
				abstract id = 532808
				new target id = 532808.pdf
			-->
	        <xsl:variable name="summaryname"><xsl:value-of select="replace(@target, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>
	        <xsl:variable name="abstractid"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/patient-summary/', replace($summaryname, '.xml', '')))"/></xsl:variable>	        

			<xsl:attribute name="target" select="concat($abstractid,'.pdf')"/>
			<xsl:if test="@status">
			<xsl:attribute name="status" select="@status"/>
			</xsl:if>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<!-- TODO consider lifting out such a template to external shared file 
		to systematicly remove listed closed empty tags -->
	<xsl:template match="
		notes | 
		source[string-length(normalize-space(.))=0] |
		@xml:base 
		">
		<!--do nothing-->
	</xsl:template>

	<xsl:template match="@*[name()!='xmlns:xi' ] | element()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>

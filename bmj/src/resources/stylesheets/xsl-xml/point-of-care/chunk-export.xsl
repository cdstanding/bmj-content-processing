<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xi="http://www.w3.org/2001/XInclude"
	version="2.0">
	
	<xsl:output 
		method="xml" 
		encoding="UTF-8" 
		indent="yes" 
		omit-xml-declaration="no"
		name="xml-format"
	/>
	
	<xsl:param name="metapath"/>
	<xsl:param name="lang"/>
	<xsl:param name="topresourcepath"/>
	
	<xsl:strip-space elements="*"/>
	
	<xsl:variable name="mono-id" select="/*/@dx-id" />
	<xsl:variable name="mono-type" select="/node()/name()"/>

	<!-- Xinclude stuff START -->
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

	<xsl:template name="xinclude-copy-attributes">
		<xsl:param name="version"/>
		<xsl:param name="abstract-id"/>
		<xsl:param name="instance-id"/>
		
		<xsl:for-each select="./@*[name()!='xsi:noNamespaceSchemaLocation']">
			<xsl:copy-of select="." />
		</xsl:for-each>
		<xsl:if test="$version != ''">
			<xsl:attribute name="version" select="$version"/>
		</xsl:if>
		<xsl:if test="$abstract-id != ''">
			<xsl:attribute name="abstract-id" select="$abstract-id"/>
		</xsl:if>
		<xsl:if test="$instance-id != ''">
			<xsl:attribute name="instance-id" select="$instance-id"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="xinclude">
		<xsl:param name="version"/>
		<xsl:param name="abstract-id"/>
		<xsl:param name="instance-id"/>
		<xsl:copy>
			<xsl:call-template name="xinclude-copy-attributes" >
				<xsl:with-param name="version" select="$version"/>
				<xsl:with-param name="abstract-id" select="$abstract-id"/>
				<xsl:with-param name="instance-id" select="$instance-id"/>
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
						<xsl:variable name="metadoc" select="document(translate(concat($metapath, '/monograph-standard-treatment-option/',@href),'\','/'))"></xsl:variable>
						<xsl:variable name="version" select="$metadoc//version"/>
						<xsl:variable name="abstract-id" select="$metadoc//abstract-id"/>
						<xsl:variable name="instance-id" select="$metadoc//id"/>
						<xsl:apply-templates select="document($xpath)" mode="xinclude" >
							<xsl:with-param name="version" select="$version"/>
							<xsl:with-param name="abstract-id" select="$abstract-id"/>
							<xsl:with-param name="instance-id" select="$instance-id"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="metadoc" select="document(translate(concat($metapath, replace(@href,'\.\./','/')),'\','/'))"></xsl:variable>
						<xsl:variable name="version" select="$metadoc//version"/>
						<xsl:variable name="abstract-id" select="$metadoc//abstract-id"/>
						<xsl:variable name="instance-id" select="$metadoc//id"/>
						<xsl:apply-templates select="document($xpath)" mode="xinclude" >
							<xsl:with-param name="version" select="$version"/>
							<xsl:with-param name="abstract-id" select="$abstract-id"/>
							<xsl:with-param name="instance-id" select="$instance-id"/>
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
			<xsl:attribute name="dx-id" select="@dx-id"/>
			
			<!--  look up version number in meta-->
			<xsl:variable name="metadoc" select="document(translate(replace($topresourcepath,'bmjk','meta/bmjk'),'\','/'))"></xsl:variable>
			<xsl:attribute name="version"><xsl:value-of select="$metadoc//version"/></xsl:attribute>
			<xsl:attribute name="abstract-id"><xsl:value-of select="$metadoc//abstract-id"/></xsl:attribute>
			<xsl:attribute name="instance-id"><xsl:value-of select="$metadoc//id"/></xsl:attribute>
			
			<xsl:apply-templates />
			
			<!-- process treatment options -->
			<xsl:if test="//tx-option">
				<xsl:apply-templates select="//tx-option[parent::tx-options/parent::treatment]"/>
			</xsl:if>
			
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template match="
		highlights |
		overview |
		ddx-etiology |
		urgent-considerations |
		diagnostic-approach |
		guidelines |
		summary[parent::monograph-overview] |
		disease-subtypes
		">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="filename">
			<xsl:value-of select="$mono-type" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$mono-id" />
			<xsl:text>_</xsl:text>
			<xsl:value-of select="$name" />
			<xsl:text>.xml</xsl:text>
		</xsl:variable>
		
		<xsl:variable name="xpath">
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$mono-type" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$name" />
		</xsl:variable>
		
		<!--  look up version number in meta-->
		<xsl:variable name="metadoc" select="document(translate(replace($topresourcepath,'bmjk','meta/bmjk'),'\','/'))"></xsl:variable>
		
		<xsl:call-template name="write-file" >
			<xsl:with-param name="filename" select="$filename"/>
			<xsl:with-param name="abstract-id" select="$metadoc//abstract-id"/>
			<xsl:with-param name="instance-id" select="$metadoc//id"/>
			<xsl:with-param name="version" select="$metadoc//version"/>
			<xsl:with-param name="xpath" select="$xpath"/>
		</xsl:call-template>
		
	</xsl:template>

	
	<xsl:template match="

		basics/definition |
		basics/classifications |
		basics/vignettes |
		basics/other-presentations |
		basics/epidemiology |
		basics/etiology |
		basics/pathophysiology |
		basics/risk-factors |
		basics/prevention |
		
		diagnosis/approach |
		diagnosis/diagnostic-factors |
		diagnosis/tests |
		diagnosis/differentials |
		diagnosis/diagnostic-criteria |
		diagnosis/screening |
		diagnosis/guidelines |
		
		followup/outlook |
		followup/complications |
		followup/recommendations |
		
		treatment/approach |
		treatment/emerging-txs |
		treatment/guidelines

		">
	
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="parent-name" select="name(parent::*)" />
		
		
		<xsl:variable name="filename">
			<xsl:value-of select="$mono-type" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$parent-name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$mono-id" />
			<xsl:text>_</xsl:text>
			<xsl:value-of select="$name" />
			<xsl:text>.xml</xsl:text>
		</xsl:variable>
		
		<xsl:variable name="xpath">
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$mono-type" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$parent-name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$name" />
		</xsl:variable>
		
		
		<xsl:call-template name="write-file" >
			<xsl:with-param name="filename" select="$filename"/>
			<xsl:with-param name="abstract-id" select="parent::*/@abstract-id"/>
			<xsl:with-param name="instance-id" select="parent::*/@instance-id"/>
			<xsl:with-param name="version" select="parent::*/@version"/>
			<xsl:with-param name="xpath" select="$xpath"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="
		
		monograph-info/topic-synonyms |
		monograph-info/related-topics |
		monograph-info/related-patient-summaries |
		monograph-info/categories 
		
		">
		
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="parent-name" select="name(parent::*)" />
		
		
		<xsl:variable name="filename">
			<xsl:value-of select="$mono-type" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$parent-name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$mono-id" />
			<xsl:text>_</xsl:text>
			<xsl:value-of select="$name" />
			<xsl:text>.xml</xsl:text>
		</xsl:variable>
		
		<xsl:variable name="xpath">
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$mono-type" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$parent-name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$name" />
		</xsl:variable>
		
		<!--  look up version number in meta-->
		<xsl:variable name="metadoc" select="document(translate(replace($topresourcepath,'bmjk','meta/bmjk'),'\','/'))"></xsl:variable>

		<xsl:call-template name="write-file" >
			<xsl:with-param name="filename" select="$filename"/>
			<xsl:with-param name="abstract-id" select="$metadoc//abstract-id"/>
			<xsl:with-param name="instance-id" select="$metadoc//id"/>
			<xsl:with-param name="version" select="$metadoc//version"/>
			<xsl:with-param name="xpath" select="$xpath"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="tx-options">
		<xsl:for-each select="./tx-option">

			<xsl:variable name="name" select="name()"/>
			<xsl:variable name="parent-name" select="name(parent::*)" />
			<xsl:variable name="tx-id" select="@id"/>
			
			<xsl:variable name="filename">
				<xsl:value-of select="$mono-type" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="$parent-name" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="$name" />
				<xsl:text>/</xsl:text>
				<xsl:value-of select="$mono-id" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="$tx-id" />
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$name" />
				<xsl:text>.xml</xsl:text>
			</xsl:variable>
			
			<xsl:variable name="filename2">
				<xsl:value-of select="$mono-id" />
				<xsl:text>-</xsl:text>
				<xsl:value-of select="$tx-id" />
				<xsl:text>_</xsl:text>
				<xsl:value-of select="$name" />
				<xsl:text>.xml</xsl:text>
			</xsl:variable>
			
			<!-- xsl:comment>P1:<xsl:value-of select="name(parent::*)"></xsl:value-of></xsl:comment>
			<xsl:comment>P2:<xsl:value-of select="name(parent::*/parent::*)"></xsl:value-of></xsl:comment -->
			
			<xsl:choose>
				<xsl:when test="name(parent::*/parent::*)='treatment'">
					<xsl:element name="xi:include">
						<xsl:attribute name="href" select="$filename"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="xi:include">
						<xsl:attribute name="href" select="$filename2"/>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>	
			
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="tx-option">

		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="parent-name" select="name(parent::*)" />
		<xsl:variable name="tx-id" select="@id"/>
		
		<xsl:variable name="filename">
			<xsl:value-of select="$mono-type" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$parent-name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$mono-id" />
			<xsl:text>-</xsl:text>
			<xsl:value-of select="$tx-id" />
			<xsl:text>_</xsl:text>
			<xsl:value-of select="$name" />
			<xsl:text>.xml</xsl:text>
		</xsl:variable>
		
		<xsl:variable name="xpath">
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$mono-type" />
			<xsl:text>/treatment/</xsl:text>
			<xsl:value-of select="$parent-name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$name" />
		</xsl:variable>
				
		<xsl:call-template name="write-file">
			<xsl:with-param name="filename" select="$filename"/>
			<xsl:with-param name="abstract-id" select="./@abstract-id"/>
			<xsl:with-param name="instance-id" select="./@instance-id"/>
			<xsl:with-param name="version" select="./@version"/>
			<xsl:with-param name="xpath" select="$xpath"/>
		</xsl:call-template>
		
		<xsl:for-each select="tx-options/tx-option">
			<xsl:variable name="tx-id" select="@id"/>
			<xsl:choose>
				<xsl:when test="(count(//tx-option[@id=$tx-id]) gt 1) and (following::tx-option[@id=$tx-id])">

				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
	</xsl:template>
	

	<xsl:template match="
		evidence-score |
		differential[parent::differentials]
		">
		
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="parent-name" select="name(parent::*)" />
		<xsl:variable name="id" select="@id"/>
		
		<xsl:variable name="filename">
			<xsl:value-of select="$mono-type" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$parent-name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$mono-id" />
			<xsl:text>-</xsl:text>
			<xsl:value-of select="$id" />
			<xsl:text>_</xsl:text>
			<xsl:value-of select="$name" />
			<xsl:text>.xml</xsl:text>
		</xsl:variable>

		<xsl:element name="xi:include">
			<xsl:attribute name="href" select="$filename"/>
		</xsl:element>
		
		<xsl:variable name="xpath">
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$mono-type" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$parent-name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$name" />
		</xsl:variable>
		
		<xsl:call-template name="write-file">
			<xsl:with-param name="filename" select="$filename"/>
			<xsl:with-param name="abstract-id" select="./@abstract-id"/>
			<xsl:with-param name="instance-id" select="./@instance-id"/>
			<xsl:with-param name="version" select="./@version"/>
			<xsl:with-param name="xpath" select="$xpath"/>
		</xsl:call-template>
		
	</xsl:template>

	<xsl:template match="figure">
		
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="parent-name" select="name(parent::*)" />

		<xsl:variable name="id" select="substring-before(substring-after(./image-link/@target, '../monograph-images/'), '_default')"/>
		
		<xsl:variable name="filename">
			<xsl:value-of select="$mono-type" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$parent-name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$id" />
			<xsl:text>_</xsl:text>
			<xsl:value-of select="$name" />
			<xsl:text>.xml</xsl:text>
		</xsl:variable>

		<xsl:variable name="xpath">
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$mono-type" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$parent-name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$name" />
		</xsl:variable>
		
		<xsl:element name="xi:include">
			<xsl:attribute name="href" select="$filename"/>
		</xsl:element>
				
		<xsl:call-template name="write-file">
			<xsl:with-param name="filename" select="$filename"/>
			<xsl:with-param name="abstract-id" select="./@abstract-id"/>
			<xsl:with-param name="instance-id" select="./@instance-id"/>
			<xsl:with-param name="version" select="./@version"/>
			<xsl:with-param name="xpath" select="$xpath"/>
		</xsl:call-template>
		
	</xsl:template>
	

	<xsl:template name="write-file">
		<xsl:param name="filename"/>
		<xsl:param name="abstract-id"/>
		<xsl:param name="version"/>
		<xsl:param name="instance-id"/>
		<xsl:param name="xpath"/>
		
		<xsl:result-document format="xml-format" href="{$filename}">
			<xsl:element name="{name()}">
				<xsl:for-each select="@*">
					<xsl:attribute name="{name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
				<!-- meta data -->
				<xsl:attribute name="version" select="$version"/>
				<xsl:attribute name="abstract-id" select="$abstract-id"/>
				<xsl:attribute name="instance-id" select="$instance-id"/>
				<xsl:attribute name="lang" select="$lang"/>
				<xsl:attribute name="path" select="$xpath"/>
				<xsl:attribute name="product">bp</xsl:attribute>
				<xsl:attribute name="monograph-id" select="$mono-id"/>
				
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:result-document>
	</xsl:template>		
	
	<xsl:template match="*">
		<xsl:element name="{name()}">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>    
	
	
</xsl:stylesheet>

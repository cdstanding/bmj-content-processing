<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	version="2.0">
	
	<xsl:output method="xml" indent="yes" name="xmlOutput" encoding="UTF-8"/>

	<!-- xsl:include href="../../xsl-lib/xinclude.xsl"/ -->
	<xsl:param name="path"/>
	<xsl:param name="metapath"/>
	<xsl:param name="metapath-base"/>
	<xsl:param name="topresourcepath"/>
	<xsl:param name="source"/>
	<xsl:param name="language"/>
	<xsl:param name="todays-date-iso"/>
	
	<xsl:strip-space elements="*"/>
	
	<xsl:variable name="monograph-plan" select="document(concat($path, '/', //monograph-info/monograph-plan-link/@target))"/>
	
	<!-- Xinclude stuff START -->
	
	<xsl:template name="xinclude-copy-attributes">
		<xsl:param name="version"/>
		<xsl:param name="abstract-id"/>
		<xsl:param name="instance-id"/>
		<xsl:param name="base-version"/>
		<xsl:param name="base-instance-id"/>
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
		<xsl:if test="$base-version != ''">
			<xsl:attribute name="base-version" select="$base-version"/>
		</xsl:if>
		<xsl:if test="$base-instance-id != ''">
			<xsl:attribute name="base-instance-id" select="$base-instance-id"/>
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
		<xsl:param name="abstract-id"/>
		<xsl:param name="instance-id"/>
		<xsl:param name="base-version"/>
		<xsl:param name="base-instance-id"/>
		<xsl:copy>
			<xsl:call-template name="xinclude-copy-attributes" >
				<xsl:with-param name="version" select="$version"/>
				<xsl:with-param name="abstract-id" select="$abstract-id"/>
				<xsl:with-param name="instance-id" select="$instance-id"/>
				<xsl:with-param name="base-version" select="$base-version"/>
				<xsl:with-param name="base-instance-id" select="$base-instance-id"/>
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
						
						<xsl:variable name="metadoc-base" select="document(translate(concat($metapath-base, '/monograph-standard-treatment-option/',@href),'\','/'))"></xsl:variable>
						<xsl:variable name="base-version" select="$metadoc-base//version"/>
						<xsl:variable name="base-instance-id" select="$metadoc-base//id"/>
						
						<xsl:apply-templates select="document($xpath)" mode="xinclude" >
							<xsl:with-param name="version" select="$version"/>
							<xsl:with-param name="abstract-id" select="$abstract-id"/>
							<xsl:with-param name="instance-id" select="$instance-id"/>
							<xsl:with-param name="base-version" select="$base-version"/>
							<xsl:with-param name="base-instance-id" select="$base-instance-id"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="metadoc" select="document(translate(concat($metapath, replace(@href,'\.\./','/')),'\','/'))"></xsl:variable>
						<xsl:variable name="version" select="$metadoc//version"/>
						<xsl:variable name="abstract-id" select="$metadoc//abstract-id"/>
						<xsl:variable name="instance-id" select="$metadoc//id"/>
						
						<xsl:variable name="metadoc-base" select="document(translate(concat($metapath-base, replace(@href,'\.\./','/')),'\','/'))"></xsl:variable>
						<xsl:variable name="base-version" select="$metadoc-base//version"/>
						<xsl:variable name="base-instance-id" select="$metadoc-base//id"/>
						
						<xsl:apply-templates select="document($xpath)" mode="xinclude" >
							<xsl:with-param name="version" select="$version"/>
							<xsl:with-param name="abstract-id" select="$abstract-id"/>
							<xsl:with-param name="instance-id" select="$instance-id"/>
							<xsl:with-param name="base-version" select="$base-version"/>
							<xsl:with-param name="base-instance-id" select="$base-instance-id"/>
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
			
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">
				<xsl:text>http://schema.bmj.com/delivery/linden/bmj-monograph-linden-</xsl:text>
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
			
			<!--  look up version number in meta-->
			<xsl:variable name="metadoc" select="document(translate(replace($topresourcepath,'bmjk','meta/bmjk'),'\','/'))"></xsl:variable>
			<xsl:attribute name="version"><xsl:value-of select="$metadoc//version"/></xsl:attribute>
			<xsl:attribute name="abstract-id"><xsl:value-of select="$metadoc//abstract-id"/></xsl:attribute>
			<xsl:attribute name="instance-id"><xsl:value-of select="$metadoc//id"/></xsl:attribute>
			<xsl:attribute name="language"><xsl:value-of select="$language"/></xsl:attribute>
			<xsl:attribute name="source"><xsl:value-of select="$source"/></xsl:attribute>
			
			<!--  find instance and version id of base file if translation -->
			<xsl:variable name="metadoc-file" select="replace($topresourcepath,$language,$source)"></xsl:variable>
			<xsl:variable name="metadoc-base" select="document(translate(replace($metadoc-file,'bmjk','meta/bmjk'),'\','/'))"></xsl:variable>
			<xsl:attribute name="base-version"><xsl:value-of select="$metadoc-base//version"/></xsl:attribute>
			<xsl:attribute name="base-instance-id"><xsl:value-of select="$metadoc-base//id"/></xsl:attribute>
			
			<!-- export date -->
			<xsl:element name="export-date"><xsl:value-of select="$todays-date-iso"/></xsl:element>
			
			<!-- Include people content mentioned in the plan-->
			<xsl:for-each select="$monograph-plan//person-link">
				<xsl:variable name="person" select="document(concat($path, '/', ./@target),/)/*"/>
				<xsl:element name="monograph-person">
					<!-- Add metadata -->
					<xsl:variable name="metadoc2" select="document(translate(concat($metapath, replace(@target,'\.\./','/')),'\','/'))"></xsl:variable>
					<xsl:attribute name="abstract-id"><xsl:value-of select="$metadoc2//abstract-id"/></xsl:attribute>					
					<xsl:attribute name="instance-id"><xsl:value-of select="$metadoc2//id"/></xsl:attribute>
					<xsl:attribute name="version"><xsl:value-of select="$metadoc2//version"/></xsl:attribute>
					
					<xsl:variable name="metadoc2-base" select="document(translate(concat($metapath-base, replace(@target,'\.\./','/')),'\','/'))"></xsl:variable>
					<xsl:attribute name="base-version"><xsl:value-of select="$metadoc2-base//version"/></xsl:attribute>
					<xsl:attribute name="base-instance-id"><xsl:value-of select="$metadoc2-base//id"/></xsl:attribute>
					
					<xsl:apply-templates select="$person/*"/>
				</xsl:element>
			</xsl:for-each>
			
			<xsl:apply-templates select="*[name()!='evidence-scores'][name()!='figures'][name()!='differentials']"/>
			
			<!-- process treatment options -->
			<xsl:if test="//tx-option">
				<xsl:apply-templates select="//tx-option[parent::tx-options/parent::treatment]"/>
			</xsl:if>
			
			<xsl:if test="//differentials[parent::monograph-eval]">
				<xsl:apply-templates select="//differentials[parent::monograph-eval]"/>
			</xsl:if>

			<xsl:if test="//figures">
				<xsl:apply-templates select="//figures"/>
			</xsl:if>
			
			<xsl:if test="//evidence-scores">
				<xsl:apply-templates select="//evidence-scores"/>
			</xsl:if>
			
		</xsl:element>
	</xsl:template>

	<xsl:template match="figures|evidence-scores">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="differentials[parent::monograph-eval]">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	
	<xsl:template match="tx-options">
		<xsl:element name="tx-options">
			<xsl:for-each select="./tx-option">
				<xsl:element name="treatment-link">
					<xsl:attribute name="abstract-id"><xsl:value-of select="./@abstract-id"/></xsl:attribute>					
					<xsl:attribute name="instance-id"><xsl:value-of select="./@instance-id"/></xsl:attribute>
					<xsl:attribute name="version"><xsl:value-of select="./@version"/></xsl:attribute>
					<xsl:attribute name="base-instance-id"><xsl:value-of select="./@base-instance-id"/></xsl:attribute>
					<xsl:attribute name="base-version"><xsl:value-of select="./@base-version"/></xsl:attribute>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tx-option">
		
		<xsl:element name="tx-option">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:element>
		
		<!-- does the tx-option have children? -->
		<xsl:for-each select="tx-options/tx-option">
			<xsl:variable name="tx-id" select="@id"/>
			<xsl:choose>
				<xsl:when test="(count(//tx-option[@id=$tx-id]) gt 1) and (following::tx-option[@id=$tx-id])">
				<!-- Already outputted-->
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
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

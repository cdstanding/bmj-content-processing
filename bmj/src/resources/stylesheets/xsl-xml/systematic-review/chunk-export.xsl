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
	
	<xsl:variable name="id" select="/*/@id" />
	
	<xsl:template match="/*">
		<xsl:variable name="name" select="name()"/>
		<xsl:element name="{$name}">
			<xsl:attribute name="id" select="@id"/>

			<!--  look up version number in meta-->
			<xsl:variable name="metadoc" select="document(translate(replace($topresourcepath,'bmjk','meta/bmjk'),'\','/'))"></xsl:variable>
			<xsl:attribute name="version"><xsl:value-of select="$metadoc//version"/></xsl:attribute>
			<xsl:attribute name="abstract-id"><xsl:value-of select="$metadoc//abstract-id"/></xsl:attribute>
			<xsl:attribute name="instance-id"><xsl:value-of select="$metadoc//id"/></xsl:attribute>
			
			<xsl:apply-templates select="//xi:include[contains(@href, 'option')]" mode="option"/>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template match="
		abstract |
		key-point-list
		">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="filename">
			<xsl:text>systematic-review/</xsl:text>
			<xsl:value-of select="$name" />
			<xsl:text>/</xsl:text>
			<xsl:value-of select="$id" />
			<xsl:text>_</xsl:text>
			<xsl:value-of select="$name" />
			<xsl:text>.xml</xsl:text>
		</xsl:variable>
		
		<xsl:variable name="xpath">
			<xsl:text>/systematic-review/</xsl:text>
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
	
	
	<xsl:template match="xi:include">
		<!-- xsl:comment><xsl:value-of select="./@href"></xsl:value-of></xsl:comment -->

		<xsl:variable 
			name="iid" 
			select="
			concat('sr-',$id, '-i', 
			replace(
			@href 
			, '^.*?[I\-](\d+).*?$'
			, '$1'))
			"/>
		
		<xsl:variable name="filename">
			<xsl:text>systematic-review/option/</xsl:text>
			<xsl:value-of select="$iid" />
			<xsl:text>.xml</xsl:text>
		</xsl:variable>
		
		<xsl:element name="xi:include">
			<xsl:attribute name="href" select="$filename"/>
		</xsl:element>
		
		
	</xsl:template>
	
	<xsl:template match="xi:include" mode="option">
		
		<xsl:variable 
			name="iid" 
			select="
			concat('sr-',$id, '-i', 
			replace(
			@href 
			, '^.*?[I\-](\d+).*?$'
			, '$1'))
			"/>
		<xsl:variable name="option" select="document(@href)/*"/>

		
		<xsl:variable name="filename">
			<xsl:text>systematic-review/option/</xsl:text>
			<xsl:value-of select="$iid" />
			<xsl:text>.xml</xsl:text>
		</xsl:variable>

		<xsl:variable name="metadoc" select="document(translate(concat($metapath, replace(@href,'\.\./','/')),'\','/'))"></xsl:variable>
		<xsl:variable name="version" select="$metadoc//version"/>
		<xsl:variable name="abstract-id" select="$metadoc//abstract-id"/>
		<xsl:variable name="instance-id" select="$metadoc//id"/>
		
		<xsl:variable name="xpath">
			<xsl:text>/systematic-review/question-list/question</xsl:text>
		</xsl:variable>

		<xsl:result-document format="xml-format" href="{$filename}">
			<xsl:element name="option">
				<!-- meta data -->
				<xsl:attribute name="version" select="$version"/>
				<xsl:attribute name="abstract-id" select="$abstract-id"/>
				<xsl:attribute name="instance-id" select="$instance-id"/>
				<xsl:attribute name="lang" select="$lang"/>
				<xsl:attribute name="path" select="$xpath"/>
				<xsl:attribute name="product">ce</xsl:attribute>
				<xsl:attribute name="monograph-id" select="$id"/>
				<xsl:attribute name="id" select="$option/@id"/>
				<xsl:attribute name="link-target" select="$option/@link-target"/>
				
				<xsl:apply-templates select="$option/node()"/>
				
			</xsl:element>
		</xsl:result-document>

	</xsl:template>
	
	<xsl:template match="
		
		background/definition |
		background/incidence |
		background/aetiology |
		background/prognosis |
		background/aims |
		background/outcomes |
		background/methods 

		">
	
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="parent-name" select="name(parent::*)" />
		
		<xsl:variable name="filename">
			<xsl:text>systematic-review/</xsl:text>
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
			<xsl:text>/systematic-review/</xsl:text>
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
				<xsl:attribute name="product">ce</xsl:attribute>
				<xsl:attribute name="monograph-id" select="$id"/>
				
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

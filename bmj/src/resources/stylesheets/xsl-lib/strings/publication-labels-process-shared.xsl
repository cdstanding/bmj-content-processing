<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	
	<xsl:variable name="strings">
		<!--<xsl:for-each select="tokenize($strings-variant-fileset, ',')">
			<xsl:copy-of select="document(normalize-space(.))/strings"/>
			</xsl:for-each>-->
		<xsl:copy-of select="document(replace($strings-variant-fileset, '\\', '/'))/strings"/>
	</xsl:variable>
	
	<xsl:template name="process-string-variant">
		
		<xsl:param name="name"/><!-- required : element name -->
		
		<xsl:param name="oen">true</xsl:param><!-- optional : is original element name true/false -->
		
		<xsl:param name="lang">
			
			<xsl:choose>
				
				<xsl:when 
					test="
					$strings//abstract
						[
						@name=$name
						and variant
							[
							@lang=$lang 
							and friendly[string-length(normalize-space(.))!=0]
							]
						]
					">
					<xsl:value-of select="$lang" />
				</xsl:when>
				
				<xsl:when 
					test="
					$strings//abstract
						[
						@name=$name
						and variant
							[
							@lang='en-gb' 
							and friendly[string-length(normalize-space(.))!=0]
							]
						]					">
					<xsl:text>en-gb</xsl:text>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:text>asdf</xsl:text>
				</xsl:otherwise>
				
			</xsl:choose>
			
		</xsl:param><!-- optional : if document lang param used -->
		
		<xsl:param name="type">friendly</xsl:param><!-- optional : friendly default -->

		<xsl:param name="case">default</xsl:param><!-- optional : default(unmodified?), Sentence case, UPPERCASE, lowercase, Title Case, tOGGLE cASE -->
		
		<xsl:param name="axis">default</xsl:param><!-- optional : is axis/group of ?? parent::questions -->
		
		<!-- default asdf if no match also use asdf when test/asdf control -->
		<!-- default fallback if name not available -->
		<!-- default/prefered order lang fallback if variant not available -->		
		<!-- allow mixed markup control from $str -->
		<!-- TODO links/id's ?? -->
		<!-- TODO imply structure/axis ?? -->
		<!-- xsl to auto generate str file from new article xml -->
		<!-- also xsl to auto generate oak oen xsd from new article xml -->
		
		<xsl:variable name="abstract" select="$strings//abstract[@name=$name]"/>
		
		<!-- manage case and text tranformations -->
		<xsl:choose>
			
			<xsl:when test="$lang='asdf'">
				<xsl:text>asdf</xsl:text>
				<xsl:value-of select="substring($abstract//variant[@lang=$lang]/*[name()=$type]/node(), 2)"/>
			</xsl:when>
			
			<xsl:when test="$case='sentance'">
				<xsl:value-of select="translate(substring($abstract//variant[@lang=$lang]/*[name()=$type]/node(), 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($abstract//variant[@lang=$lang]/*[name()=$type]/node(), 2)"/>
			</xsl:when>
			
			<xsl:when test="$case='upper'">
				<xsl:value-of select="translate($abstract//variant[@lang=$lang]/*[name()=$type]/node(), $lower, $upper)"/>
			</xsl:when>
			
			<xsl:when test="$case='lower'">
				<xsl:value-of select="translate($abstract//variant[@lang=$lang]/*[name()=$type]/node(), $upper, $lower)"/>
			</xsl:when>
			
			<xsl:when test="$case='default'">
				<xsl:value-of select="$abstract//variant[@lang=$lang]/*[name()=$type]/node()"/>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:value-of select="$abstract//variant[@lang=$lang]/*[name()=$type]/node()"/>
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
</xsl:stylesheet>

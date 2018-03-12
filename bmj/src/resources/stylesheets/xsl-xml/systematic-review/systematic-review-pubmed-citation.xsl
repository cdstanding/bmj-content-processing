<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="us-ascii" 
		indent="yes"
		omit-xml-declaration="yes"
		doctype-public="-//NLM//DTD PubMed 2.0//EN" 
		doctype-system="http://www.ncbi.nlm.nih.gov:80/entrez/query/static/PubMed.dtd"
		use-character-maps="iso8879"
	/>
	
	<xsl:param name="lang"/>
	<xsl:param name="media"/>
	<xsl:param name="systematic-review-xml-input"/>
	<xsl:param name="date"/>
	<xsl:param name="pmid"/>

	<xsl:include href="../../xsl-entities/iso8879/iso8879map.xsl"/>
	<xsl:include href="../../xsl-glue-text/bmj-publisher-glue-text.xsl"/>
	<xsl:include href="../../generic-params.xsl"/>
	<xsl:include href="../../systematic-review-params.xsl"/>	
	
	<xsl:variable name="cid" select="substring-after(/systematic-review/@id, '_')"/>
	<xsl:variable name="bmjk-review-plan" select="document(/systematic-review/info/bmjk-review-plan-link/@target)/*"/>
	
	<xsl:template match="/">
		
		<xsl:element name="ArticleSet">
		
			<xsl:element name="Article">
				
				<xsl:element name="Journal">
					
					<xsl:element name="PublisherName">
						<xsl:value-of select="$bmj-publisher-glue-text/publisher-name[contains(@lang, $lang)]"/>
					</xsl:element>
					<xsl:element name="JournalTitle">
						<xsl:value-of select="$journal-title"/>
					</xsl:element>
					
					<xsl:element name="Issn">
						<xsl:value-of select="$issn"/>
					</xsl:element>
					
					<xsl:element name="Volume">
						<xsl:value-of select="substring($date, 1, 4)"/>
						</xsl:element>
					
					<xsl:element name="PubDate">
						<xsl:attribute name="PubStatus">
							<xsl:text>epublish</xsl:text>
						</xsl:attribute>
						<xsl:element name="Year">
							<xsl:value-of select="substring($date, 1, 4)"/>
						</xsl:element>
						<xsl:element name="Month">
							<xsl:value-of select="substring($date, 6, 2)"/>
						</xsl:element>
						<xsl:element name="Day">
							<xsl:value-of select="substring($date, 9, 2)"/>
						</xsl:element>
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="ArticleTitle">
					<xsl:value-of select="normalize-space(/systematic-review/info/title)"/>
				</xsl:element>
				
				<xsl:element name="ELocationID">
					<xsl:attribute name="EIdType">pii</xsl:attribute>
					<xsl:value-of select="$cid"/>
				</xsl:element>
				
				<xsl:element name="Language">
					<xsl:value-of select="translate(substring-before($lang, '-'), $lower, $upper)"/>
				</xsl:element>
				
				<xsl:call-template name="process-contributors"/>
				
				<xsl:element name="ArticleIdList">
					<xsl:element name="ArticleId">
						<xsl:attribute name="IdType">pii</xsl:attribute>
						<xsl:value-of select="$cid"/>
					</xsl:element>
				</xsl:element>

				<xsl:call-template name="process-abstract"/>
				
			</xsl:element>
			
		</xsl:element>
				
	</xsl:template>
	
	<xsl:template name="process-contributors">
		
		<xsl:element name="AuthorList">
			
			<xsl:for-each select="$bmjk-review-plan//contributor-set/person-link">
				<xsl:variable name="filename" select="concat($systematic-review-xml-input, substring-after(@target, '../'))"/>
				<xsl:variable name="person" select="document($filename)/*"/>
		
				<xsl:if test="$person//first-name[string-length(.)!=0] and $person//last-name[string-length(.)!=0]">
					
					<xsl:element name="Author">
						
						<xsl:element name="FirstName">
							<xsl:value-of select="normalize-space($person//first-name)"/>
						</xsl:element>
						
						<xsl:if test="$person//middle-name[string-length(.)!=0]">
							<xsl:element name="MiddleName">
								<xsl:value-of select="normalize-space($person//middle-name)"/>
							</xsl:element>
						</xsl:if>
						
						<xsl:element name="LastName">
							<xsl:value-of select="normalize-space($person//last-name)"/>
						</xsl:element>
							
						<xsl:if test="position()=1 and $person//country[string-length(.)!=0]">
							<xsl:element name="Affiliation">
								<xsl:if test="$person//affiliation[string-length(.)!=0]">
									<xsl:value-of select=" normalize-space($person//affiliation)"/>
									<xsl:text>, </xsl:text>	
								</xsl:if><xsl:if test="$person//city[string-length(.)!=0]">
									<xsl:value-of select=" normalize-space($person//city)"/>
									<xsl:text>, </xsl:text>	
								</xsl:if><xsl:if test="$person//country[string-length(.)!=0]">
									<xsl:value-of select=" normalize-space($person//country)"/>
								</xsl:if>
							</xsl:element>
						</xsl:if>
						
					</xsl:element>
				</xsl:if>
				
			</xsl:for-each>
		
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-abstract">
		<xsl:choose>
			<xsl:when test="/systematic-review/abstract/element()[string-length(.)!=0]">
				<xsl:element name="Abstract">
					<xsl:for-each select="/systematic-review/abstract/element()">
						<xsl:variable name="abstract-label" select="concat('abstract-', name())"/>
						<xsl:value-of select="translate($glue-text//element()[name()=$abstract-label][contains(@lang, $lang)], $lower, $upper)"/>
						<xsl:text>: </xsl:text>
						<xsl:apply-templates mode="mixed"/>
						<xsl:text> </xsl:text>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="Abstract"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="sup" mode="mixed">
		<xsl:element name="sup">
			<xsl:apply-templates mode="mixed"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="sub" mode="mixed">
		<xsl:element name="inf">
			<xsl:apply-templates mode="mixed"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="text()" mode="mixed">
		<xsl:choose>
			<xsl:when test="matches(self::node(), '^.+?BMJ Clinical Evidence.+?$$')">
				<xsl:value-of select="replace(self::node(), '^(.+?)BMJ Clinical Evidence(.+?)$$', '$1Clinical Evidence$2')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="self::node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>

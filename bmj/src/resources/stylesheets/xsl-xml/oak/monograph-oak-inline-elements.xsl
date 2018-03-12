<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns="http://schema.bmj.com/delivery/oak"
	xmlns:bp="http://schema.bmj.com/delivery/oak-bp"
	version="2.0">
	
	<xsl:template match="list">
		<xsl:element name="list">
			<!-- none bullet 1 a A i I -->
			<xsl:attribute name="class" select="@style" />
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="item">
		<xsl:element name="li">
			<xsl:apply-templates select="para/node()|list"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="para">
		<xsl:element name="p">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<!-- because our references stylesheet output tends to recurse with apply-templates we want to control them here --> 
	<xsl:template match="section[ancestor::references] | heading[ancestor::references] | par[ancestor::references]">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="organism">
		<!--<xsl:element name="i">
			<xsl:apply-templates />
			</xsl:element>-->
		<xsl:element name="inline">
			<xsl:attribute name="class" select="name()"/>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="drug">
		<xsl:variable name="name" select="name()"/>
		<!--<xsl:variable name="target" select="@target"/>-->
		<!--<xsl:element name="link">
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="target">
				<xsl:value-of select="$target"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>-->
		<xsl:element name="inline">
			<xsl:attribute name="class" select="name()"/>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>

	<!-- LINKS -->
	<xsl:template match="monograph-link[not(parent::related-topics)] | option-link">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="target" select="@target"/>
		<xsl:element name="p">
			<xsl:element name="inline">
				<xsl:attribute name="class">prompt</xsl:attribute>
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
				<xsl:text>: </xsl:text>
			</xsl:element>
			<xsl:element name="link">
				<xsl:attribute name="class" select="$name"/>
				<xsl:attribute name="target" select="$target"/>
				<xsl:choose>
					<xsl:when test="string-length(normalize-space(.))!=0">
						<xsl:text>[</xsl:text>
						<xsl:apply-templates/>
						<xsl:text>]</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>[</xsl:text>
						<xsl:text>link</xsl:text>
						<xsl:text>]</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="monograph-link[parent::related-topics] | patient-summary-link">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="target" select="@target"/>
		<xsl:element name="li">
			<xsl:element name="inline">
				<xsl:attribute name="class">prompt</xsl:attribute>
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
				<xsl:text>: </xsl:text>
			</xsl:element>
			<xsl:element name="link">
				<xsl:attribute name="class" select="$name"/>
				<xsl:attribute name="target" select="$target"/>
				<xsl:choose>
					<xsl:when test="string-length(normalize-space(.))!=0">
						<xsl:text>[</xsl:text>
						<xsl:apply-templates/>
						<xsl:text>]</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>[</xsl:text>
						<xsl:text>link</xsl:text>
						<xsl:text>]</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<!--<xsl:template match="reference-link">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="combined-references">
			<xsl:element name="combined-references">
				<xsl:element name="reference">
					<xsl:call-template name="process-reference-links">
						<xsl:with-param name="item-count" select="1"/>
						<xsl:with-param name="link-index" select="1"/>
						<xsl:with-param name="link-count" select="count(//reference-link) + 1"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:variable>
		<xsl:element name="link">
			<xsl:for-each select="$combined-references//reference">
				<xsl:if test="processing-instruction()[name()='target'] = $target">
					<xsl:attribute name="target">
						<xsl:text>ref</xsl:text>
						<xsl:value-of select="processing-instruction()[name()='position']"/>
					</xsl:attribute>
					<xsl:attribute name="class" select="$name"/>
					<xsl:text>[</xsl:text>
					<xsl:value-of select="processing-instruction()[name()='position']"/>
					<xsl:text>]</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
		<xsl:text disable-output-escaping="yes"> </xsl:text>
		</xsl:template>-->
	
	<xsl:template match="reference-link[@type='article']">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="article-references">
			<xsl:element name="article-references">
				<xsl:element name="reference">
					
					<!-- we need to make sure the actual source document our list needs to be built from 
						is put in perspective again because some parent nodes might be created from with 
						apply-templates on other variable content -->
					<!--<xsl:variable name="filename">
						<xsl:value-of  select="$path"/>
						<xsl:text>/../monograph-standard/</xsl:text>
						<xsl:value-of  select="$src-filename"/>
					</xsl:variable>
					
					<xsl:for-each select="document($filename)/*">-->
						
						<xsl:call-template name="process-article-reference-links">
							<xsl:with-param name="item-count" select="1"/>
							<xsl:with-param name="link-index" select="1"/>
							<xsl:with-param name="link-count" select="count(//reference-link[@type='article']) + 1"/>
						</xsl:call-template>
						
					<!--</xsl:for-each>-->
					
				</xsl:element>
			</xsl:element>
		</xsl:variable>
		
		<xsl:for-each select="$article-references//reference">
			<xsl:if test="processing-instruction()[name()='target'] = $target">
				<xsl:element name="link">
					<xsl:attribute name="target">
						<xsl:text>ref</xsl:text>
						<xsl:value-of select="processing-instruction()[name()='position']"/>
					</xsl:attribute>
					<xsl:attribute name="class" select="$name"/>
					<xsl:text>[</xsl:text>
					<!--<xsl:text>ref</xsl:text>-->
					<xsl:value-of select="processing-instruction()[name()='position']"/>
					<xsl:text>]</xsl:text>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
		<xsl:text disable-output-escaping="yes"> </xsl:text>
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
				<xsl:element name="link">
					<xsl:attribute name="target">
						<xsl:text>web</xsl:text>
						<xsl:value-of select="processing-instruction()[name()='position']"/>
					</xsl:attribute>
					<xsl:attribute name="class" select="$name"/>
					<xsl:text>[</xsl:text>
					<xsl:text>w</xsl:text>
					<xsl:value-of select="processing-instruction()[name()='position']"/>
					<xsl:text>]</xsl:text>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
		<xsl:text disable-output-escaping="yes"> </xsl:text>
	</xsl:template>
	
	<!--<xsl:template match="evidence-score-link">
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
	</xsl:template>-->
	
	<xsl:template match="evidence-score-link">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="target" select="@target"/>
		<xsl:for-each select="//evidence-score">
			<xsl:variable name="id" select="substring-after(preceding-sibling::comment()[1], 'including ')"/>
			<xsl:variable name="position-id" select="generate-id()"/>
			<xsl:if test="$id = $target">
				<xsl:for-each select="parent::*/*">
					<xsl:if test="generate-id()=$position-id">
						<xsl:element name="link">
							<xsl:attribute name="target">
								<xsl:text>evid</xsl:text>
								<xsl:value-of select="position()" />
							</xsl:attribute>
							<xsl:attribute name="class" select="$name"/>
							<xsl:text>[</xsl:text>
							<xsl:text>e</xsl:text>
							<xsl:value-of select="position()" />		
							<xsl:text>]</xsl:text>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template match="figure-link">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="inline" select="@inline"/>
		<xsl:variable name="figures">
			<xsl:element name="figures">
				<xsl:element name="figure">
					<xsl:call-template name="process-figure-links">
						<xsl:with-param name="item-count" select="1"/>
						<xsl:with-param name="link-index" select="1"/>
						<xsl:with-param name="link-count" select="count(//figure-link) + 1"/>
					</xsl:call-template>
				</xsl:element> 
			</xsl:element>
		</xsl:variable>
		<xsl:for-each select="$figures//figure">
			<xsl:if test="processing-instruction()[name()='target'] = $target">
				<xsl:choose>
					<xsl:when test="$inline = 'true' ">
						<xsl:apply-templates select="." mode="inline"/>	
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="link">
							<xsl:attribute name="target">
								<xsl:text>fig</xsl:text>
								<xsl:value-of select="processing-instruction()[name()='position']"/>
							</xsl:attribute>
							<xsl:attribute name="class" select="$name"/>
							<xsl:text>[</xsl:text>
							<!--<xsl:text>img</xsl:text>
							<xsl:value-of select="processing-instruction()[name()='position']"/>-->
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="string('image')"/>
							</xsl:call-template>
							<xsl:text>]</xsl:text>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>

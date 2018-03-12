<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	exclude-result-prefixes="xi xsi cals"
	version="2.0">	
	
	<!-- ignore inline content for delete redline and comment redline --> 
	<xsl:template 
		match="
		node()
		[preceding-sibling::processing-instruction()[1]
		[name() = 'serna-redline-start' 
		and (. = '400 ' or . = '0 ')]]
		[following-sibling::processing-instruction()[1]
			[name() = 'serna-redline-end']]
		">
		<xsl:if test="contains($proof, 'draft')">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="processing-instruction()[contains(name(), 'serna-redline')]">
		
		<xsl:choose>
			<!-- redline-start-insert -->
			<xsl:when 
				test="
				name()='serna-redline-start' 
				and matches(., '^1000 ')
				and contains($proof, 'draft') 
				">
				<xsl:element name="fo:inline" use-attribute-sets="">
					<xsl:attribute name="color">#CCCCCC</xsl:attribute>
					<xsl:text>[</xsl:text>
				</xsl:element>
				<xsl:text disable-output-escaping="yes">&lt;fo:inline </xsl:text>
				<xsl:text disable-output-escaping="yes">text-decoration="underline" color="#00FF00" keep-together="auto"</xsl:text>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</xsl:when>
			<!-- redline-start-delete -->
			<xsl:when 
				test="
				name()='serna-redline-start' 
				and matches(., '^400 ')
				and contains($proof, 'draft')
				">
				<xsl:element name="fo:inline" use-attribute-sets="">
					<xsl:attribute name="color">#CCCCCC</xsl:attribute>
					<xsl:text>[</xsl:text>
				</xsl:element>
				<xsl:text disable-output-escaping="yes">&lt;fo:inline </xsl:text>
				<xsl:text disable-output-escaping="yes">text-decoration="line-through" color="#FF0000" keep-together="auto"</xsl:text>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</xsl:when>
			<!-- redline-start-comment -->
			<xsl:when 
				test="
				name()='serna-redline-start' 
				and matches(., '^0 ')
				and contains($proof, 'draft')
				">
				<xsl:element name="fo:inline" use-attribute-sets="">
					<xsl:attribute name="color">#CCCCCC</xsl:attribute>
					<xsl:text>[</xsl:text>
				</xsl:element>
				<xsl:text disable-output-escaping="yes">&lt;fo:inline </xsl:text>
				<xsl:text disable-output-escaping="yes">background-color="#FFFF00" keep-together="auto"</xsl:text>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</xsl:when>
			<!-- redline-end -->
			<xsl:when 
				test="
				name()='serna-redline-end' 
				and contains($proof, 'draft')
				">
				<xsl:text disable-output-escaping="yes">&lt;/fo:inline&gt;</xsl:text>
				<xsl:element name="fo:inline" use-attribute-sets="">
					<xsl:attribute name="color">#CCCCCC</xsl:attribute>
					<xsl:text>]</xsl:text>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="pi-comment">
		<xsl:choose>
			<xsl:when 
				test="
				(contains($proof, 'peer-review') 
					or contains($proof, 'draft'))
				and @type='q-to-pr'
				">
				<xsl:element name="fo:inline" use-attribute-sets="comment-q-to-pr">
					<xsl:text>[</xsl:text>
					<xsl:value-of select="translate(@type, $lower, $upper)"/>
					<xsl:text>: </xsl:text>
					<xsl:apply-templates/>
					<xsl:text>]</xsl:text>
				</xsl:element>
			</xsl:when>
			<xsl:when 
				test="
				contains($proof, 'draft')
				and @type='q-to-a'
				">
				<xsl:element name="fo:inline" use-attribute-sets="comment-q-to-a">
					<xsl:text>[</xsl:text>
					<xsl:value-of select="translate(@type, $lower, $upper)"/>
					<xsl:text>: </xsl:text>
					<xsl:apply-templates/>
					<xsl:text>]</xsl:text>
				</xsl:element>
			</xsl:when>
			<xsl:when 
				test="
				contains($proof, 'draft')
				and @type='q-to-ed'
				">
				<xsl:element name="fo:inline" use-attribute-sets="comment-q-to-ed">
					<xsl:text>[</xsl:text>
					<xsl:value-of select="translate(@type, $lower, $upper)"/>
					<xsl:text>: </xsl:text>
					<xsl:apply-templates/>
					<xsl:text>]</xsl:text>
				</xsl:element>
			</xsl:when>
			<xsl:when 
				test="
				contains($proof, 'draft')
				and @type='q-to-teched'
				">
				<xsl:element name="fo:inline" use-attribute-sets="comment-q-to-teched">
					<xsl:text>[</xsl:text>
					<xsl:value-of select="translate(@type, $lower, $upper)"/>
					<xsl:text>: </xsl:text>
					<xsl:apply-templates/>
					<xsl:text>]</xsl:text>
				</xsl:element>
			</xsl:when>
			<xsl:when 
				test="
				contains($proof, 'draft')
				and @type='q-to-prod'
				">
				<xsl:element name="fo:inline" use-attribute-sets="comment-q-to-prod">
					<xsl:text>[</xsl:text>
					<xsl:value-of select="translate(@type, $lower, $upper)"/>
					<xsl:text>: </xsl:text>
					<xsl:apply-templates/>
					<xsl:text>]</xsl:text>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<!-- do nothing -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--<xsl:attribute-set name="comment-q-to-a" use-attribute-sets="">
		<xsl:attribute name="keep-together">auto</xsl:attribute>
		<xsl:attribute name="padding">1pt</xsl:attribute>
		<xsl:attribute name="background-color">#FFFF00</xsl:attribute>
		</xsl:attribute-set>
		<xsl:attribute-set name="comment-q-to-pr" use-attribute-sets="">
		<xsl:attribute name="keep-together">auto</xsl:attribute>
		<xsl:attribute name="padding">1pt</xsl:attribute>
		<xsl:attribute name="background-color">#FFFF00</xsl:attribute>
		</xsl:attribute-set>
		<xsl:attribute-set name="comment-q-to-ed" use-attribute-sets="">
		<xsl:attribute name="keep-together">auto</xsl:attribute>
		<xsl:attribute name="padding">1pt</xsl:attribute>
		<xsl:attribute name="background-color">#FF0000</xsl:attribute>
		</xsl:attribute-set>
		<xsl:attribute-set name="comment-q-to-teched" use-attribute-sets="">
		<xsl:attribute name="keep-together">auto</xsl:attribute>
		<xsl:attribute name="padding">1pt</xsl:attribute>
		<xsl:attribute name="background-color">#00FF00</xsl:attribute>
		</xsl:attribute-set>
		<xsl:attribute-set name="comment-q-to-prod" use-attribute-sets="">
		<xsl:attribute name="keep-together">auto</xsl:attribute>
		<xsl:attribute name="padding">1pt</xsl:attribute>
		<xsl:attribute name="background-color">#00FFFF</xsl:attribute>
		</xsl:attribute-set>-->
	
	<xsl:template match="em|EM|italic|ITALIC|organism">
		<xsl:element name="fo:inline" use-attribute-sets="em">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="strong|STRONG|b|B|term">
		<xsl:element name="fo:inline" use-attribute-sets="strong">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="br|BR">
		<xsl:element name="fo:block" use-attribute-sets=""/>
	</xsl:template>
	
	<xsl:template match="sub|SUB">
		<xsl:element name="fo:inline" use-attribute-sets="sub">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="sup|SUP">
		<xsl:element name="fo:inline" use-attribute-sets="sup">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>

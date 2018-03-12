<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://schema.bmj.com/delivery/oak"
	xmlns:ce="http://schema.bmj.com/delivery/oak-ce"
	xmlns:tr="http://schema.bmj.com/delivery/oak-tr">
	
	<!-- ignore inline content for delete redline and comment redline if not draft mode --> 
	<xsl:template 
		match="
		node()
		[preceding-sibling::processing-instruction()[1]
		[name() = 'serna-redline-start' 
		and (. = '400 ' or . = '0 ' or . = '1000 ')]]
		[following-sibling::processing-instruction()[1]
		[name() = 'serna-redline-end']]
		">
		<xsl:if test="contains($proof, 'draft')">
			<xsl:choose>
				<!-- redline-start-insert -->
				<xsl:when test="preceding-sibling::processing-instruction()[1][. = '1000 ']">
					<xsl:element name="inline">
						<xsl:attribute name="class">redline-insert</xsl:attribute>
						<xsl:text>[</xsl:text><xsl:value-of select="."/><xsl:text>]</xsl:text>
					</xsl:element>
				</xsl:when>
				<!-- redline-start-delete -->
				<xsl:when test="preceding-sibling::processing-instruction()[1][. = '400 ']">
					<xsl:element name="inline">
						<xsl:attribute name="class">redline-delete</xsl:attribute>
						<xsl:text>[</xsl:text><xsl:value-of select="."/><xsl:text>]</xsl:text>
					</xsl:element>
				</xsl:when>
				<!-- redline-start-comment -->
				<xsl:when test="preceding-sibling::processing-instruction()[1][. = '0 ' ]">
					<xsl:element name="inline">
						<xsl:attribute name="class">redline-comment</xsl:attribute>
						<xsl:text>[</xsl:text><xsl:value-of select="."/><xsl:text>]</xsl:text>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="pi-comment">
		<xsl:choose>
			<xsl:when 
				test="
				(contains($proof, 'peer-review') 
				or contains($proof, 'draft'))
				and @type='q-to-pr'
				">
				<xsl:element name="inline">
					<xsl:attribute name="class" select="string('comment-q-to-pr')" />
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
				<xsl:element name="inline">
					<xsl:attribute name="class" select="string('comment-q-to-a')" />
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
				<xsl:element name="inline">
					<xsl:attribute name="class" select="string('comment-q-to-ed')" />
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
				<xsl:element name="inline">
					<xsl:attribute name="class" select="string('comment-q-to-teched')" />
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
				<xsl:element name="inline">
					<xsl:attribute name="class" select="string('comment-q-to-prod')" />
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

</xsl:stylesheet>
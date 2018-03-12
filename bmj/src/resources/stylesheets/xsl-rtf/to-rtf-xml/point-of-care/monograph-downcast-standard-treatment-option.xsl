<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="1.1" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:html="http://www.w3.org/HTML/1998/html4"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal">
	

	<xsl:template match="tx-option">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="section" use-attribute-sets="section">
			<xsl:element name="heading" use-attribute-sets="heading-3">
				<xsl:value-of select="$strings//str[@name=$name]/friendly" />
				<xsl:text> - </xsl:text>
				<!--<xsl:value-of select="@id"/>-->
				<xsl:if test="parent::tx-options/parent::tx-option">
					<xsl:variable name="parent-position-id" select="parent::tx-options/parent::tx-option/generate-id()"/>
					<xsl:for-each select="//treatment/tx-options/tx-option">
						<xsl:if test="generate-id()=$parent-position-id">
							<xsl:value-of select="position()" />
							<xsl:text>.</xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
				<xsl:variable name="position-id" select="generate-id()"/>
				<xsl:for-each select="parent::*/*">
					<xsl:if test="generate-id()=$position-id">
						<xsl:value-of select="position()" />
					</xsl:if>
				</xsl:for-each>
			</xsl:element>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="regimens">
		<!--<xsl:element name="table" use-attribute-sets="">
			<xsl:element name="tgroup" use-attribute-sets="">
				<xsl:attribute name="cols">7</xsl:attribute>
				<xsl:element name="thead" use-attribute-sets="">
					<xsl:element name="row" use-attribute-sets="">
						<xsl:element name="entry" use-attribute-sets="thead-entry">
							<xsl:element name="par" use-attribute-sets="">
								<xsl:value-of select="$strings//str[@name='tier']" />
							</xsl:element>
						</xsl:element>
						<xsl:element name="entry" use-attribute-sets="thead-entry">
							<xsl:element name="par" use-attribute-sets="">
								<xsl:value-of select="$strings//str[@name='regimen']" />
							</xsl:element>
						</xsl:element>
						<xsl:element name="entry" use-attribute-sets="thead-entry">
							<xsl:element name="par" use-attribute-sets="">
								<xsl:value-of select="$strings//str[@name='regimen-name']" />
							</xsl:element>
						</xsl:element>
						<xsl:element name="entry" use-attribute-sets="thead-entry">
							<xsl:element name="par" use-attribute-sets="">
								<xsl:value-of select="$strings//str[@name='treatment-name']" />
							</xsl:element>
						</xsl:element>
						<xsl:element name="entry" use-attribute-sets="thead-entry">
							<xsl:element name="par" use-attribute-sets="">
								<xsl:value-of select="$strings//str[@name='treatment-details']" />
							</xsl:element>
						</xsl:element>
						<xsl:element name="entry" use-attribute-sets="thead-entry">
							<xsl:element name="par" use-attribute-sets="">
								<xsl:value-of select="$strings//str[@name='comments']" />
							</xsl:element>
						</xsl:element>
						<xsl:element name="entry" use-attribute-sets="thead-entry">
							<xsl:element name="par" use-attribute-sets="">
								<xsl:value-of select="$strings//str[@name='modifier']" />
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				
				<xsl:element name="tbody" use-attribute-sets="">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:element>
		</xsl:element>-->
	</xsl:template>
	
	<xsl:template match="regimen | components">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="component">
		<xsl:element name="row" use-attribute-sets="">
			<xsl:element name="entry" use-attribute-sets="tbody-entry">
				<xsl:element name="par" use-attribute-sets="">
					<xsl:value-of select="ancestor::regimen/@tier" />
				</xsl:element>
			</xsl:element>
			<xsl:element name="entry" use-attribute-sets="tbody-entry">
				<xsl:element name="par" use-attribute-sets="">
				</xsl:element>
			</xsl:element>
			<xsl:element name="entry" use-attribute-sets="tbody-entry">
				<xsl:element name="par" use-attribute-sets="">
					<xsl:value-of select="ancestor::regimen/regimen-name" />
				</xsl:element>
			</xsl:element>
			<xsl:element name="entry" use-attribute-sets="tbody-entry">
				<xsl:element name="par" use-attribute-sets="">
					<xsl:value-of select="name" />
				</xsl:element>
			</xsl:element>
			<xsl:element name="entry" use-attribute-sets="tbody-entry">
				<xsl:element name="par" use-attribute-sets="">
					<xsl:apply-templates select="details/node()" />
				</xsl:element>
			</xsl:element>
			<xsl:element name="entry" use-attribute-sets="tbody-entry">
				<xsl:apply-templates select="comments/node()" />
			</xsl:element>
			<xsl:element name="entry" use-attribute-sets="tbody-entry">
				<xsl:element name="par" use-attribute-sets="">
					<xsl:value-of select="@modifier" />
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>

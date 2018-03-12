<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xi xsi cals"
	version="2.0">
	

	<xsl:template match="table">
		
		<xsl:element name="fo:table-and-caption">
			<xsl:element name="fo:table">
				<xsl:choose>
					<xsl:when test="@border">
						<xsl:attribute name="border" select="@border"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="border">1</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:attribute name="width">100%</xsl:attribute>
				<xsl:call-template name="build-columns" />
				<xsl:element name="fo:table-body">
					<xsl:apply-templates select="thead" />
					<xsl:apply-templates select="tbody" />
					<xsl:apply-templates select="tfoot" />
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="build-columns">
		
		<!-- calc num of columns -->
		<xsl:param name="page-width-mm"><xsl:text>450</xsl:text></xsl:param>
		
		<xsl:param name="cols">
			<xsl:variable name="cols">
				<xsl:for-each select="*:tbody/*:tr">
					<xsl:sort select="count(*:td)" />
					<xsl:element name="row-cell-count">
						<xsl:value-of select="count(*:td)" />
					</xsl:element>
				</xsl:for-each>
			</xsl:variable>
			<xsl:value-of select="$cols/row-cell-count[last()]" />
		</xsl:param>
		<xsl:param name="ave-width"><xsl:value-of select="($page-width-mm div $cols)"/></xsl:param>
		<xsl:param name="format-ave-width"><xsl:value-of select="format-number(($page-width-mm div $cols),'###')"/></xsl:param>
		
		<xsl:comment>page-width-mm:<xsl:value-of select="$page-width-mm"></xsl:value-of></xsl:comment>
		<xsl:comment>cols:<xsl:value-of select="$cols"></xsl:value-of></xsl:comment>
		<xsl:comment>ave-width:<xsl:value-of select="$ave-width"></xsl:value-of></xsl:comment>
		<xsl:comment>format-ave-width:<xsl:value-of select="$format-ave-width"></xsl:value-of></xsl:comment>
		
		<!-- create cols -->     
		<xsl:choose>
			<xsl:when test="$cols = 1 or $cols = 0">
				<xsl:call-template name="make-columns">
					<xsl:with-param name="max-cols">
						<xsl:value-of select="1"/>
					</xsl:with-param>
					<xsl:with-param name="current-col">
						<xsl:value-of select="0"/>
					</xsl:with-param>
					<xsl:with-param name="col-width">
						<xsl:value-of select="$page-width-mm"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="make-columns">
					<xsl:with-param name="max-cols">
						<xsl:value-of select="$cols"/>
					</xsl:with-param>
					<xsl:with-param name="current-col">
						<xsl:value-of select="0"/>
					</xsl:with-param>
					<xsl:with-param name="col-width">
						<xsl:value-of select="$format-ave-width"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="make-columns">
		<xsl:param name="max-cols" />
		<xsl:param name="current-col" />
		<xsl:param name="col-width" />
		
		<xsl:if test="number($current-col) &lt; number($max-cols)">
			
			<xsl:element name="fo:table-column">
				<xsl:attribute name="column-width"><xsl:value-of select="$col-width"/>pt</xsl:attribute>
			</xsl:element>
			
			<xsl:call-template name="make-columns">
				<xsl:with-param name="max-cols">
					<xsl:value-of select="$max-cols"/>
				</xsl:with-param>
				<xsl:with-param name="current-col">
					<xsl:value-of select="$current-col + 1"/>
				</xsl:with-param>
				<xsl:with-param name="col-width">
					<xsl:value-of select="$col-width"/>
				</xsl:with-param>
			</xsl:call-template>
			
		</xsl:if> 
	</xsl:template>
	
	<xsl:template match="thead">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="tr">
		<xsl:element name="fo:table-row">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="tbody">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="tfoot">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="td|th">
		<fo:table-cell 
			padding-start="3pt" padding-end="3pt"
			padding-before="3pt" padding-after="3pt">
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@border='1' or 
				ancestor::tr[@border='1'] or
				ancestor::thead[@border='1'] or
				ancestor::table[@border='1']">
				<xsl:attribute name="border-style">
					<xsl:text>solid</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="border-color">
					<xsl:text>black</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="border-width">
					<xsl:text>1pt</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<xsl:variable name="align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:choose>
							<xsl:when test="@align='center'">
								<xsl:text>center</xsl:text>
							</xsl:when>
							<xsl:when test="@align='right'">
								<xsl:text>end</xsl:text>
							</xsl:when>
							<xsl:when test="@align='justify'">
								<xsl:text>justify</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>start</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="ancestor::tr[@align]">
						<xsl:choose>
							<xsl:when test="ancestor::tr/@align='center'">
								<xsl:text>center</xsl:text>
							</xsl:when>
							<xsl:when test="ancestor::tr/@align='right'">
								<xsl:text>end</xsl:text>
							</xsl:when>
							<xsl:when test="ancestor::tr/@align='justify'">
								<xsl:text>justify</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>start</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="ancestor::thead">
						<xsl:text>center</xsl:text>
					</xsl:when>
					<xsl:when test="ancestor::table[@align]">
						<xsl:choose>
							<xsl:when test="ancestor::table/@align='center'">
								<xsl:text>center</xsl:text>
							</xsl:when>
							<xsl:when test="ancestor::table/@align='right'">
								<xsl:text>end</xsl:text>
							</xsl:when>
							<xsl:when test="ancestor::table/@align='justify'">
								<xsl:text>justify</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>start</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>start</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<fo:block text-align="{$align}" >
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<xsl:choose>
					<xsl:when test="ancestor::thead">
						<xsl:attribute name="font">bold</xsl:attribute>
					</xsl:when>
				</xsl:choose>
				<xsl:apply-templates select="*|text()"/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	


</xsl:stylesheet>

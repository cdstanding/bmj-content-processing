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
	
	<xsl:strip-space elements="reference-link fo:basic-link fo:inline"/>
	
	<xsl:variable name="reference-range-list"/>
	
	<xsl:template match="reference-link">
		<xsl:param name="dim" />
		
		<xsl:if test="contains($components, 'references')">
			<xsl:variable name="target" select="@target"/>
			
			<xsl:for-each select="$links//reference-link">
				<xsl:if test="@target=$target">
					
					<xsl:call-template name="do-reference-display">
						<xsl:with-param name="reference-range-id" select="concat($cid, '_REF', position())"/>
						<xsl:with-param name="reference-range-num" select="position()"/>
						<xsl:with-param name="reference-range-reset">test</xsl:with-param>
						<xsl:with-param name="reference-range-test">blue</xsl:with-param>
					</xsl:call-template>
					
				</xsl:if>

			</xsl:for-each>
			
			<xsl:choose>
				<!-- 
					is this the _only_ item in a reference-range?
					test for _no_ direct preceding white-space+reference-link or reference-link
					and _no_ direct following white-space+reference-link or reference-link or is end node
				-->	
				<xsl:when test="
					(preceding-sibling::node()[1]
						[string(normalize-space(.))!='' and name()!='reference-link']
					or
					preceding-sibling::node()[1]
						[string(normalize-space(.))='']
						/preceding-sibling::node()[1][name()!='reference-link']) 
					and
					(following-sibling::node()[1]
						[string(normalize-space(.))!='' and name()!='reference-link'] 
					or
					following-sibling::node()[1]
						[string(normalize-space(.))='']
						/following-sibling::node()[1]
							[name()!='reference-link'])
					">
					<!--
					or
					following-sibling::node()[1]
						[string(normalize-space(.))='']
						[position()=last()]
					-->
					<xsl:for-each select="$links//reference-link">
						<xsl:if test="@target=$target">
							<xsl:call-template name="do-reference-display">
								<xsl:with-param name="reference-range-id" select="concat($cid, '_REF', position())"/>
								<xsl:with-param name="reference-range-num" select="position()"/>
								<xsl:with-param name="reference-range-reset">single</xsl:with-param>
								<xsl:with-param name="reference-range-test">green</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<!-- 
					is this the _first_ item in a reference-range?
					test for _no_ direct preceding white-space+reference-link or reference-link
					and direct following white-space+reference-link or reference-link
				-->	
				<xsl:when test="
					(preceding-sibling::node()[1]
						[string(normalize-space(.))!='' and name()!='reference-link']
					or
					preceding-sibling::node()[1]
						[string(normalize-space(.))='']
						/preceding-sibling::node()[1][name()!='reference-link']) 
					and
					(following-sibling::node()[1]
						[name()='reference-link'] 
					or
					following-sibling::node()[1]
						[string(normalize-space(.))='']
						/following-sibling::node()[1]
							[name()='reference-link'])
					">
					<xsl:for-each select="$links//reference-link">
						<xsl:if test="@target=$target">
							<xsl:call-template name="do-reference-display">
								<xsl:with-param name="reference-range-id" select="concat($cid, '_REF', position())"/>
								<xsl:with-param name="reference-range-num" select="position()"/>
								<xsl:with-param name="reference-range-reset">first</xsl:with-param>
								<xsl:with-param name="reference-range-test">orange</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
					<!-- 
						for-each item directly after the first item in a reference-range
						test direct following white-space+reference-link or reference-link
					-->
					<xsl:for-each select="
						following-sibling::node()
							[string(normalize-space(.))='' or name()='reference-link'] 
							[preceding-sibling::node()[1]
								[string(normalize-space(.))='' or name()='reference-link']]
						">
							<xsl:variable name="following-target" select="@target"/>
							<xsl:variable name="reference-range-id-first" select="concat($cid, '_REF', position())"/>
							<xsl:for-each select="$links//reference-link">
								<xsl:if test="@target=$following-target">
									<xsl:choose>
										<xsl:when test="
											not(following-sibling::node()[1]
												[string(normalize-space(.))!='' and name()!='reference-link'] 
											or
											following-sibling::node()[1]
												[string(normalize-space(.))='']
												/following-sibling::node()[1]
													[name()!='reference-link'])
											">
											<xsl:call-template name="do-reference-display">
												<xsl:with-param name="reference-range-id" select="$reference-range-id-first"/>
												<xsl:with-param name="reference-range-num" select="position()"/>
												<xsl:with-param name="reference-range-reset">range</xsl:with-param>
												<xsl:with-param name="reference-range-test">red</xsl:with-param>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="do-reference-display">
												<xsl:with-param name="reference-range-id" select="$reference-range-id-first"/>
												<xsl:with-param name="reference-range-num" select="position()"/>
												<xsl:with-param name="reference-range-reset">last</xsl:with-param>
												<xsl:with-param name="reference-range-test">red</xsl:with-param>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:for-each>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="do-reference-display">
	
		<xsl:param name="reference-range-id"/>
		<xsl:param name="reference-range-num"/>
		<xsl:param name="reference-range-reset"/>
		<xsl:param name="reference-range-test"/>
		
		<xsl:choose>
		
			<xsl:when test="$reference-range-reset='test'">
				<xsl:element name="fo:basic-link" use-attribute-sets="">
					<xsl:attribute name="internal-destination" select="$reference-range-id"/>
					<xsl:element name="fo:inline" use-attribute-sets="link color-blue sup">
						<xsl:text>[</xsl:text>
						<xsl:value-of select="$reference-range-num"/>
						<xsl:text>]</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:when>
			
			<!--xsl:when test="$reference-range-reset='single'">
				<xsl:element name="fo:basic-link" use-attribute-sets="">
					<xsl:attribute name="internal-destination" select="$reference-range-id"/>
					<xsl:element name="fo:inline" use-attribute-sets="sup">
						<xsl:attribute name="color" select="$reference-range-test"/>
						<xsl:text>[</xsl:text>
						<xsl:value-of select="$reference-range-num"/>
						<xsl:text>]</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:when-->
			
			<xsl:when test="$reference-range-reset='first'">
				<xsl:variable name="reference-range-list">
					<xsl:element name="reference">
						<xsl:value-of select="$reference-range-num"/>
					</xsl:element>
				</xsl:variable>
			</xsl:when>
			
			<xsl:when test="$reference-range-reset='range'">
				<xsl:variable name="reference-range-list">
					<xsl:copy-of select="$reference-range-list"/>
					<xsl:element name="reference">
						<xsl:value-of select="$reference-range-num"/>
					</xsl:element>
				</xsl:variable>
			</xsl:when>
			
			<xsl:when test="$reference-range-reset='last'">
				<xsl:variable name="reference-range-list">
					<xsl:copy-of select="$reference-range-list"/>
					<xsl:element name="reference">
						<xsl:value-of select="$reference-range-num"/>
					</xsl:element>
				</xsl:variable>
				
				<xsl:element name="fo:basic-link" use-attribute-sets="">
					<xsl:attribute name="internal-destination" select="$reference-range-id"/>
					<xsl:element name="fo:inline" use-attribute-sets="sup">
						<xsl:attribute name="color" select="$reference-range-test"/>
						<xsl:text>[</xsl:text>
						<xsl:choose>
						<xsl:when test="count($reference-range-list//reference) = 2">
							<xsl:value-of select="$reference-range-list//reference[1]"/>
							<xsl:text>,</xsl:text>
							<xsl:value-of select="$reference-range-list//reference[1]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="$reference-range-list//reference">
								<xsl:value-of select="."/>
								<xsl:text>,</xsl:text>
							</xsl:for-each>
						</xsl:otherwise>
						</xsl:choose>
						<xsl:text>]</xsl:text>
					</xsl:element>
				</xsl:element>
				
			</xsl:when>
		</xsl:choose>

	</xsl:template>

</xsl:stylesheet>

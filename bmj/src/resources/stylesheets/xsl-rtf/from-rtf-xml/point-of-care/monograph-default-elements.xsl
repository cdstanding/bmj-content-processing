<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/HTML/1998/html4"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal">

	<xsl:template name="process-section">
		
		<xsl:choose>
			<xsl:when test="count(html:td) = 1 and html:td[1][string-length(normalize-space(.))!=0]">
				<xsl:element name="section_text">
					<xsl:for-each select="html:td[1]/(uci:par|uci:list)">
						<xsl:call-template name="process-para"/>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:when test="count(html:td) = 2">
				<xsl:if test="html:td[1][string-length(normalize-space(.))!=0]">
					<xsl:element name="section_header">
						<xsl:apply-templates select="html:td[1]/uci:par[1]"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="html:td[2][string-length(normalize-space(.))!=0]">
					<xsl:element name="section_text">
						<xsl:for-each select="html:td[2]/(uci:par|uci:list)">
							<xsl:call-template name="process-para"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="section_text"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="process-para">
		
		<xsl:choose>
			<xsl:when test="name()='uci:par' and string-length(normalize-space(.))!=0">
				<xsl:element name="para">
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="name()='uci:list'">
				<xsl:element name="list">
					<xsl:attribute name="style">
						<xsl:choose>
							<!-- numeric i.e. 1,2,3 -->
							<xsl:when test="uci:item[1][contains(@uci:numberingtext, '1')]">
								<xsl:text>1</xsl:text>
							</xsl:when>
							<!-- alphabet i.e. a,b,c -->
							<xsl:when test="uci:item[1][contains(@uci:numberingtext, 'a')]">
								<xsl:text>a</xsl:text>
							</xsl:when>
							<!-- alphabet i.e. A,B,C -->
							<xsl:when test="uci:item[1][contains(@uci:numberingtext, 'A')]">
								<xsl:text>A</xsl:text>
							</xsl:when>
							<!-- roman i.e. i,ii,iii -->
							<xsl:when test="uci:item[1][contains(@uci:numberingtext, 'i')]">
								<xsl:text>i</xsl:text>
							</xsl:when>
							<!-- roman i.e. I,II,III -->
							<xsl:when test="uci:item[1][contains(@uci:numberingtext, 'I')]">
								<xsl:text>I</xsl:text>
							</xsl:when>
							<!-- bullet -->
							<xsl:when test="uci:item[1][contains(@uci:numberingtext, '•')]">
								<xsl:text>bullet</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>none</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:for-each select="uci:item">
						<xsl:element name="item">
							<xsl:for-each select="(uci:par|uci:list)">
								<xsl:call-template name="process-para"/>
							</xsl:for-each>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:when test="normalize-space(.)=''">
				<!-- do nothing for empty para's -->
			</xsl:when>
		</xsl:choose>
	</xsl:template>
		
	<xsl:template match="uci:gentext">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="uci:inline">
		<xsl:choose>
			<xsl:when 
				test="
				contains(@uci:diffStyle, 'italic')
				or contains(@uci:diffStyle, 'sup')
				or contains(@uci:diffStyle, 'sub')
				or contains(@uci:diffStyle, 'bold')
				">
				<xsl:apply-templates mode="italic"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="uci:inline" mode="italic">
		<xsl:choose>
			<xsl:when test="contains(@uci:diffStyle, 'italic')">
				<xsl:element name="organism">
					<!--<xsl:apply-templates mode="italic"/>-->
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<!--<xsl:apply-templates mode="super"/>-->
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--
	<xsl:template match="uci:inline" mode="super">
		<xsl:choose>
			<xsl:when test="contains(@uci:diffStyle, 'super')">
				<xsl:element name="sup">
					<xsl:apply-templates mode="italic"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="sub"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="uci:inline" mode="sub">
		<xsl:choose>
			<xsl:when test="contains(@uci:diffStyle, 'sub')">
				<xsl:element name="sub">
					<xsl:apply-templates mode="italic"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="bold"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="uci:inline" mode="bold">
		<xsl:choose>
			<xsl:when test="contains(@uci:diffStyle, 'bold')">
				<xsl:element name="bold">
					<xsl:apply-templates mode="italic"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	-->
	
	<!-- grabbing inline tinted background comments will *not* always work 
		as rtf will force background-color property to parent uci:par 
		if all para is assumed to be tinted i.e. para content is only comment --> 
	<xsl:template match="uci:inline[contains(@uci:diffStyle, 'background-color')]">
		<xsl:choose>
			<xsl:when test="contains(., '[Q to ')">
				<xsl:comment select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="process-text">
		<xsl:param name="str"/>
		<xsl:param name="parent-tabel-label"/>
		
		<xsl:choose>
			
			<!-- manage ascii bracketed references -->
			<xsl:when test="contains($str,'[')">
				
				<xsl:if test="$debug='true'">
					<xsl:comment>DEBUG bracket found -<xsl:value-of select="$str"/>-</xsl:comment>
				</xsl:if>
				
				
				<xsl:variable name="target" select="substring-before(substring-after($str, '['), ']')"/>
				<!-- if the stuff in square brackets is an integer, add a reference link -->

				<xsl:if test="$debug='true'">
					<xsl:comment>DEBUG bracket target <xsl:value-of select="$target"/></xsl:comment>
				</xsl:if>
				

				<xsl:choose>
					
					<!-- normal reference [99] -->
					<xsl:when test="matches($target, '^\d+$')">
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-before($str,'[')"/>
						</xsl:call-template>
						<!--<xsl:comment>99</xsl:comment>-->
						<xsl:element name="foot">
							<xsl:attribute name="id_ref" select="$target"/>
							<xsl:attribute name="type">reference</xsl:attribute>
						</xsl:element>
						<xsl:text/>
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-after(substring-after($str, '['), ']')"/>
						</xsl:call-template>
					</xsl:when>
					
					<!-- evidence reference [e99] -->
					<xsl:when test="matches($target, '^[Ee]\d+$')">
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-before($str,'[')"/>
						</xsl:call-template>
						<!--<xsl:comment>e99</xsl:comment>-->
						<xsl:element name="foot">
							<xsl:attribute name="id_ref" select="replace($target, '^.*?(\d+).*?$', '$1')"/>
							<xsl:attribute name="type">evidence</xsl:attribute>
						</xsl:element>
						<xsl:text/>
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-after(substring-after($str, '['), ']')"/>
						</xsl:call-template>
					</xsl:when>
					
					<!-- resource reference [r99] -->
					<xsl:when test="matches($target, '^[Rr]\d+$')">
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-before($str,'[')"/>
						</xsl:call-template>
						<!--<xsl:comment>r99</xsl:comment>-->
						<xsl:element name="foot">
							<xsl:attribute name="id_ref" select="replace($target, '^.*?(\d+).*?$', '$1')"/>
							<xsl:attribute name="type">resource</xsl:attribute>
						</xsl:element>
						<xsl:text/>
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-after(substring-after($str, '['), ']')"/>
						</xsl:call-template>
					</xsl:when>
					
					<!-- image reference [i99] -->
					<xsl:when test="matches($target, '^[Ii][Ll]?\d+$')">
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-before($str,'[')"/>
						</xsl:call-template>
						<xsl:element name="images">
							<xsl:element name="image">
								<xsl:attribute name="id_ref" select="replace($target, '^.*?(\d+).*?$', '$1')"/>
								<!-- fix: need way to determine if inline true or false -->
								<xsl:choose>
									<!-- inline image link control for evaluation monographs -->
									<xsl:when 
										test="
										matches($target, '^[Ii][Ll]\d+$')
										and //html:table
										//html:td[1]
										[contains(@uci:diffStyle, 'background-color')]
										[contains(translate(., $upper, $lower), 'monograph title')]
										/following-sibling::html:td[1]
										[contains(translate(., $upper, $lower), 'evaluation')]
										">
										<xsl:choose>
											<xsl:when 
												test="
												contains($parent-tabel-label, 'overview')
												or contains($parent-tabel-label, 'etiology')
												or contains($parent-tabel-label, 'urgent considerations')
												or contains($parent-tabel-label, 'diagnostic approach')
												">
												<xsl:attribute name="inline">true</xsl:attribute>
												<xsl:comment select="normalize-space($parent-tabel-label)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="inline">true</xsl:attribute>
												<!--<xsl:element name="{$warning}">
													<xsl:text>inline image link not allowed here</xsl:text>
												</xsl:element>-->
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<!-- inline image link control for standard monographs -->
									<xsl:when test="matches($target, '^[Ii][Ll]\d+$')">
										<xsl:choose>
											<xsl:when test="
												contains($parent-tabel-label, 'basics: definition')
												or contains($parent-tabel-label, 'basics: classification')
												or contains($parent-tabel-label, 'basics: common vignette #1')
												or contains($parent-tabel-label, 'basics: common vignette #2')
												or contains($parent-tabel-label, 'basics: other presentations')
												or contains($parent-tabel-label, 'basics: epidemiology')
												or contains($parent-tabel-label, 'basics: etiology &amp; pathophysiology')
												or contains($parent-tabel-label, 'basics: primary prevention')
												or contains($parent-tabel-label, 'diagnosis: diagnostic approach')
												or contains($parent-tabel-label, 'diagnosis: criteria')
												or contains($parent-tabel-label, 'diagnosis: screening')
												or contains($parent-tabel-label, 'treatment: treatment approach')
												or contains($parent-tabel-label, 'treatment: emerging')
												or contains($parent-tabel-label, 'follow-up: patient outlook')
												or contains($parent-tabel-label, 'follow-up: recommendations')
												">
												<xsl:attribute name="inline">true</xsl:attribute>
												<xsl:comment select="normalize-space($parent-tabel-label)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="inline">true</xsl:attribute>
												<!--<xsl:element name="{$warning}">
													<xsl:text>inline image link not allowed here</xsl:text>
												</xsl:element>-->
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="inline">false</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
						</xsl:element>
						<xsl:text/>
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-after(substring-after($str, '['), ']')"/>
						</xsl:call-template>
					</xsl:when>
					
					<!-- image reference [i97,98,99] -->
					<xsl:when test="matches($target, '^[Ii]\d+[,\d]+$')">
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-before($str,'[')"/>
						</xsl:call-template>
						<xsl:element name="images">
							<xsl:element name="image">
								<xsl:attribute name="id_ref" select="replace($target, '^[Ii](\d+),[,\d]+$', '$1')"/>
								<xsl:attribute name="inline">false</xsl:attribute>
							</xsl:element>
							<xsl:for-each select="tokenize($target, ',')">
								<xsl:if test="not(contains(translate(., $upper, $lower), 'i'))">
									<xsl:element name="image">
										<xsl:attribute name="id_ref" select="."/>
										<xsl:attribute name="inline">false</xsl:attribute>
									</xsl:element>
								</xsl:if>
							</xsl:for-each>
						</xsl:element>
						<xsl:text/>
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-after(substring-after($str, '['), ']')"/>
						</xsl:call-template>
					</xsl:when>
					
					<xsl:otherwise>
						<!-- there might be more square brackets later... -->
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-before($str,'[')"/>
						</xsl:call-template>
						<xsl:text>[</xsl:text>
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-after($str,'[')"/>
						</xsl:call-template>
					</xsl:otherwise>
					
				</xsl:choose>
				
			</xsl:when>
			
			<!-- manage inline escaped organism mark-up from rtf --> 
			<xsl:when test="contains($str,'&lt;organism&gt;')">
				<xsl:call-template name="process-text">
					<xsl:with-param name="str" select="substring-before($str,'&lt;organism&gt;')"/>
				</xsl:call-template>
				<xsl:text disable-output-escaping="yes">&lt;organism&gt;</xsl:text>
				<xsl:call-template name="process-text">
					<xsl:with-param name="str" select="substring-after($str,'&lt;organism&gt;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($str,'&lt;/organism&gt;')">
				<xsl:call-template name="process-text">
					<xsl:with-param name="str" select="substring-before($str,'&lt;/organism&gt;')"/>
				</xsl:call-template>
				<xsl:text disable-output-escaping="yes">&lt;/organism&gt;</xsl:text>
				<xsl:call-template name="process-text">
					<xsl:with-param name="str" select="substring-after($str,'&lt;/organism&gt;')"/>
				</xsl:call-template>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="text()">
		<!-- fix: we can't always be sure we can do the following test with $parent-tabel-label 
		as text() maybe passed back here as string and not a node-set :( --> 
		<xsl:variable name="parent-tabel-label">
			<xsl:if test="count(ancestor::html:table//uci:par[1]) = 1">
				<xsl:value-of select="translate(normalize-space(ancestor::html:table//uci:par[1]), $upper, $lower)"/>
			</xsl:if>
		</xsl:variable>
		<xsl:call-template name="process-text">
			<xsl:with-param name="str" select="."/>
			<xsl:with-param name="parent-tabel-label" select="$parent-tabel-label"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="uci:linebreak">
		<xsl:text disable-output-escaping="yes"> </xsl:text>
	</xsl:template>
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:ce="http://www.bmjgroup.com/2007/07/BMJ-OAK-CE"
	xmlns:bt="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"
	xmlns:oak="http://www.bmjgroup.com/2007/07/BMJ-OAK"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output 
		method="xml" 
		indent="yes" 
		name="xml-format"/>
	
	<xsl:key name="reference-link-keys" match="link[@type='reference']" use="@target" />
	
	<!-- these params are passed in by ant using these parameters on its xslt task: 
		filenameparameter="filename"
		filedirparameter="filedir"
	-->
	<xsl:param name="filename"/>
	<xsl:param name="filedir">.</xsl:param>

	<!-- root section -->
	<xsl:template match="/oak:section">
		
		<xsl:element name="{name()}" namespace="{namespace-uri()}">
			<xsl:namespace name="bt">http://www.bmjgroup.com/2007/07/BMJ-OAK-BT</xsl:namespace>
			
			<xsl:for-each select="@* ">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>

			<xsl:for-each select="ancestor-or-self::*[position() = last()]/@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>

			<xsl:variable name="root-element-id" select="generate-id()"></xsl:variable>

			<xsl:if test="//oak:section[parent::*[1][generate-id()=$root-element-id] 
				and not(@class='introduction') 
				and not(@class='glossary')
				and @id]">
				<xsl:element name="metadata" namespace="{namespace-uri()}">
					<xsl:for-each select="//oak:section[parent::*[1][generate-id()=$root-element-id] 
						and not(@class='introduction') 
						and not(@class='glossary')
						and @id]">
	
						<xsl:element name="key" namespace="{namespace-uri()}">
							<xsl:attribute name="name" 
								namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT">child-filename</xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="substring-before($filename, '.')"/>-<xsl:value-of select="@id"/>.xml</xsl:attribute>
							
							<xsl:element name="key" namespace="{namespace-uri()}">
								<xsl:attribute name="name" 
									namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT">section-type</xsl:attribute>
		
								<xsl:attribute name="value"><xsl:value-of select="oak:metadata/oak:key[1]/@value"/></xsl:attribute>
							</xsl:element>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
			
			<xsl:apply-templates />
			
			<!--call refs and gloss for intro doc -->
			<xsl:variable name="current-id" select="@id"/>
			
			<xsl:variable name="links">
				<xsl:for-each select="descendant::oak:link">
					<!-- if the first ancestor section id arrived at is the current id select me-->
					<xsl:if test="ancestor::oak:section[@id][1]/@id=$current-id">
						<xsl:element name="link">
							<xsl:attribute name="target">
								<xsl:call-template name="find-link-target">
									<xsl:with-param name="link" select="@target"/>
								</xsl:call-template>
							</xsl:attribute>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			
			<!-- output references that contain reference tags -->
			<xsl:variable name="references">
				<xsl:for-each select="//oak:references/oak:reference">
					<xsl:variable name="current-id" select="@id"/>
					<xsl:if test="$links/link[@target=$current-id]">
						<xsl:apply-templates select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			
			<xsl:if test="$references/oak:reference">
				<xsl:element name="references" namespace="{namespace-uri()}">
					<xsl:apply-templates select="$references"/>
				</xsl:element>
			</xsl:if>
			
			<!-- output sections that contain glossary tags -->
			<xsl:variable name="sections-containing-glossary">
				<xsl:for-each select="//oak:section/oak:gloss">
					<xsl:variable name="current-id" select="@id"/>
					<xsl:if test="$links/link[@target=$current-id]">
						<xsl:apply-templates select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>

			<xsl:if test="$sections-containing-glossary/oak:gloss">
				<xsl:element name="section" namespace="{namespace-uri()}">
					<xsl:attribute name="class">glossary</xsl:attribute>
					<xsl:apply-templates select="$sections-containing-glossary"/>
				</xsl:element>
			</xsl:if>
		</xsl:element>
	</xsl:template>

	<xsl:template match="oak:references" mode="#all"></xsl:template>
	<xsl:template match="oak:section[@class='glossary']" mode="#all"></xsl:template>
	

	<!-- sub-sections -->
	<xsl:template
		match="oak:section[parent::* 
            and not(@class='introduction') 
            and not(@class='glossary')
            and @id]">
		<xsl:variable name="current-id" select="@id"/>
		<xsl:variable name="result-filename">
			<xsl:value-of select="substring-before($filename, '.')"/>
			<xsl:text>-</xsl:text>
			<xsl:value-of select="@id"/>
			<xsl:text>.xml</xsl:text>
		</xsl:variable>

		<xsl:result-document href="{$result-filename}" format="xml-format">
			<xsl:element name="{name()}" namespace="{namespace-uri()}">

				<xsl:for-each select="ancestor-or-self::*[position() = last()]/@*">
					<xsl:attribute name="{name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>

				<xsl:for-each select="@* ">
					<xsl:attribute name="{name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>

				<!-- add in metadata to hold the parent filename -->
				<xsl:element name="metadata" namespace="{namespace-uri()}">
					<xsl:element name="key" namespace="{namespace-uri()}">
						<xsl:attribute name="name" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT">parent-filename</xsl:attribute>
						<xsl:attribute name="value" select="$filename" />
					</xsl:element>
				</xsl:element>						
				
				<xsl:apply-templates/>

				<xsl:variable name="links">
					<xsl:for-each select="descendant::oak:link">

						<!-- if the first ancestor section id arrived at is the current id select me-->
						<xsl:if test="ancestor::oak:section[@id][1]/@id=$current-id">

							<xsl:element name="link">
								<xsl:attribute name="target">
									<xsl:call-template name="find-link-target">
										<xsl:with-param name="link" select="@target"/>
									</xsl:call-template>
								</xsl:attribute>
							</xsl:element>

						</xsl:if>


					</xsl:for-each>
				</xsl:variable>

				<!-- output references that contain reference tags -->
				<xsl:variable name="references">
					<xsl:for-each select="//oak:references/oak:reference">
						<xsl:variable name="current-id" select="@id"/>
						<xsl:if test="$links/link[@target=$current-id]">
							<xsl:apply-templates select="."/>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>

				<xsl:if test="$references/oak:reference">
					<xsl:element name="references" namespace="{namespace-uri()}">
						<xsl:apply-templates select="$references"/>
					</xsl:element>
				</xsl:if>

				<!-- output sections that contain glossary tags -->
				<xsl:variable name="sections-containing-glossary">
					<xsl:for-each select="//oak:section/oak:gloss">
						<xsl:variable name="current-id" select="@id"/>
						<xsl:if test="$links/link[@target=$current-id]">
							<xsl:apply-templates select="."/>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:if test="$sections-containing-glossary/oak:gloss">
					<xsl:element name="section" namespace="{namespace-uri()}">
						<xsl:attribute name="class">glossary</xsl:attribute>
						<xsl:apply-templates select="$sections-containing-glossary"/>
					</xsl:element>
				</xsl:if>


			</xsl:element>
		</xsl:result-document>
	</xsl:template>

	<!--every link whose target is now in a separate xml file, add the filename of the xml file as a prefix to the link -->
	<xsl:template match="oak:link">

		<!-- extract the current target -->
		<xsl:variable name="current-target">
			<xsl:call-template name="find-link-target">
				<xsl:with-param name="link" select="@target"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="current-filename">
			<xsl:call-template name="find-link-filename">
				<xsl:with-param name="link" select="@target"/>
			</xsl:call-template>
		</xsl:variable>
		
<!--		<xsl:comment>Current target is <xsl:value-of select="$current-target"/></xsl:comment>
		<xsl:comment>Current filename is <xsl:value-of select="$current-filename"/></xsl:comment>
-->		
<!--		<xsl:comment>blah is 

			<xsl:choose>
				<xsl:when test="//oak:section/oak:section/oak:metadata/oak:key[@bt:name='section-type'][@value=$current-target]">
					YES!
				</xsl:when>
				<xsl:otherwise>NO!</xsl:otherwise>
			</xsl:choose>
			
		</xsl:comment>
-->
		<xsl:choose>
			<xsl:when test="$current-filename='CURRENT'">
				<!-- this is a link in the current file -->
				<xsl:choose>
					<xsl:when test="$current-target='topic-info'">
						<xsl:element name="link" namespace="{namespace-uri()}">
							<xsl:attribute name="target">
								<xsl:value-of select="concat($filename,@target)"/>
							</xsl:attribute>

							<xsl:for-each select="@*[name()!='target']">
								<xsl:attribute name="{name()}" namespace="{namespace-uri()}">
									<xsl:value-of select="."/>
								</xsl:attribute>
							</xsl:for-each>
						</xsl:element>
					</xsl:when>
					
					<!-- link to another section in this document -->
					<xsl:when test="//oak:section[@id =$current-target]">
						<xsl:element name="link" namespace="{namespace-uri()}">
							<xsl:attribute name="target">
								<xsl:choose>
									<!-- this bit shouldn't be necessary: it's a link to another file -->
									<xsl:when test="contains(@target,'xml')">
										<xsl:value-of select="@target"/>
									</xsl:when>
									
									<xsl:otherwise>
										<xsl:variable name="new-filename">
											<xsl:value-of select="substring-before($filename, '.')"/>
											<xsl:text>-</xsl:text>
											<xsl:value-of select="$current-target"/>
											<xsl:text>.xml</xsl:text>
										</xsl:variable>
										<xsl:value-of select="concat($new-filename,@target)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							
							<xsl:for-each select="@*[name()!='target']">
								<xsl:attribute name="{name()}" namespace="{namespace-uri()}">
									<xsl:value-of select="."/>
								</xsl:attribute>
							</xsl:for-each>
							
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
				
					<xsl:otherwise>
						<xsl:next-match/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			
			<xsl:otherwise>
				<!-- link to another file -->
				
				<xsl:choose>
					<xsl:when test="$current-target='topic-info'">
						<xsl:next-match/>
					</xsl:when>
					<xsl:when test="document($current-filename, .)//oak:section[@id =$current-target]">
						<!-- link to a section in another document which will be a child document of the main document -->
						
						<xsl:element name="link" namespace="{namespace-uri()}">
							<xsl:attribute name="target">
								<xsl:variable name="new-filename">
									<xsl:value-of select="substring-before($current-filename, '.')"/>
									<xsl:text>-</xsl:text>
									<xsl:value-of select="$current-target"/>
									<xsl:text>.xml</xsl:text>
								</xsl:variable>
								
								<xsl:value-of select="$new-filename"/>
								<xsl:text>#xpointer(id('</xsl:text>
								<xsl:value-of select="$current-target"/>
								<xsl:text>')</xsl:text>
								
							</xsl:attribute>
							
							<xsl:for-each select="@*[name()!='target']">
								<xsl:attribute name="{name()}" namespace="{namespace-uri()}">
									<xsl:value-of select="."/>
								</xsl:attribute>
							</xsl:for-each>
							
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:next-match/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- This template returns  to caller the 'extracted id' of an internal link-->
	<xsl:template name="find-link-target">
		<xsl:param name="link"/>

		<!-- choose between an external or internal link -->
		<xsl:choose>
			<!-- external link-->
			<xsl:when test="substring-before($link,'#')">
				<xsl:if test="substring-before(substring-after($link, '('), '(') = 'id'">
					<xsl:variable name="id" select="substring-before(substring-after($link, ''''), '''')"/>
					<xsl:value-of select="$id"/>
				</xsl:if>
			</xsl:when>
			<!-- internal link -->
			<xsl:otherwise>
				<xsl:if test="substring-before(substring-after($link, '('), '(') = 'id'">
					<xsl:variable name="id" select="substring-before(substring-after($link, ''''), '''')"/>
					<xsl:value-of select="$id"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="find-link-filename">
		<xsl:param name="link"/>
		
		<!-- choose between an external or internal link -->
		<xsl:choose>
			<!-- external link-->
			<xsl:when test="substring-before($link,'#')">
				<xsl:variable name="filename" select="substring-before($link,'#')"/>
				
				<xsl:value-of select="$filename"/>
			</xsl:when>
			<!-- internal link -->
			<xsl:otherwise>
				<xsl:text>CURRENT</xsl:text>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>

	<!-- match any other element, writing it out and calling apply-templates for any children -->
	<xsl:template match="*" mode="#all">
		<xsl:element name="{name()}" namespace="{namespace-uri()}">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>

			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>

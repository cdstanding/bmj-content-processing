<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="2.0"
	xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"   
	exclude-result-prefixes="legacytag" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:bt="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"
	xmlns:oak="http://www.bmjgroup.com/2007/07/BMJ-OAK"
	xmlns:refman="http://www.bmj.com/bmjk/behive/refman/2006-10">
	
	<xsl:output 
		method="xml" 
		indent="yes"/>
	
	<xsl:include href="../../xsl-lib/bmj-string-lib.xsl"/>
	
	<xsl:param name="filename"/>
	<xsl:param name="filedir"/>
	<xsl:param name="amended-date"/>
	<xsl:param name="last-update"/>
	
	<xsl:variable name="root-legacy-id"><xsl:value-of select="/*/@legacy-id"/></xsl:variable>

	<xsl:key name="sidebar-links-key" match="sidebar-link" use="@target" />
	
	<xsl:variable name="topic-doc" select="/"/>
	
	<xsl:template match="/patient-topic | /elective-surgery | /patient-summary | /patient-howtouse" mode="#all">
		<section>
			<xsl:attribute name="id" select="/*/topic-info/@type"/>
			
			<xsl:element name="metadata">
			
				<!-- change schema for this new meta field? -->
				<xsl:if test="/patient-summary/topic-info/systematic-review-link/@target">
					<xsl:variable name="reviewlink" select="/patient-summary/topic-info/systematic-review-link/@target" />
					<xsl:element name="key" namespace="{namespace-uri()}">
						<xsl:attribute name="name" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT">related-article-filename</xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="legacytag:getPatientTopicFileName($reviewlink, 'en-gb')"/></xsl:attribute>						
					</xsl:element>
				</xsl:if>
	
				<xsl:element name="key" namespace="{namespace-uri()}">
					<xsl:attribute name="name" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT">exported</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="legacytag:getTodaysDate()"/></xsl:attribute>						
				</xsl:element>

				<xsl:if test="$amended-date!=''">
					<xsl:element name="key" namespace="{namespace-uri()}">
						<xsl:attribute name="name" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT">amended</xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="$amended-date"/></xsl:attribute>						
					</xsl:element>
				</xsl:if>

				<xsl:if test="$last-update!=''">
					<xsl:element name="key" namespace="{namespace-uri()}">
						<xsl:attribute name="name" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT">updated</xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="$last-update"/></xsl:attribute>						
					</xsl:element>
				</xsl:if>
			</xsl:element>
			
			<title><xsl:apply-templates select="/*/topic-info/title/node()"/></title>

			<p>Publication date <date><xsl:value-of select="legacytag:getTodaysDate()"/></date></p>
			
			<xsl:apply-templates select="/*/topic-info/introduction"/>
			
			<xsl:apply-templates select="/*/topic-info/body-text/p"/>

			<xsl:apply-templates select="/*/news-info"/>

			<xsl:apply-templates select="/*/topic-element"/>
		</section>
	</xsl:template>

	<xsl:template match="/patient-news" mode="#all">
		<section>
			<xsl:element name="metadata">
				<xsl:element name="key" namespace="{namespace-uri()}">
					<xsl:attribute name="name" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT">publication-date</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="legacytag:getTodaysDate()"/></xsl:attribute>						
				</xsl:element>
				<xsl:element name="key" namespace="{namespace-uri()}">
					<xsl:attribute name="name" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT">embargo-date</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="/*/news-info/embargo-date"/></xsl:attribute>						
				</xsl:element>
			</xsl:element>
		
			<title><xsl:apply-templates select="/*/news-info/headline/node()"/></title>
			
			<xsl:if test="/*/news-info/byline[string-length(normalize-space(.))!=0]">
				<p><xsl:apply-templates select="/*/news-info/byline/node()"/></p>
			</xsl:if>
			
			<xsl:apply-templates select="/*/topic-info/introduction"/>
			
			<xsl:apply-templates select="/*/topic-info/body-text/p"/>
			
			<xsl:apply-templates select="/*/news-info"/>
			
			<xsl:apply-templates select="/*/topic-element"/>
		</section>
	</xsl:template>
	
	<xsl:template match="introduction" mode="#all">
		<section class="introduction">
			<!-- empty title to help the next spreadsheet -->
			<title/>
			<p><xsl:apply-templates select="node()" mode="#current"/></p>
		</section>
	</xsl:template>
	
	<xsl:template match="news-info" mode="#all">
		<xsl:for-each select="introduction | background | feature | whats-new | findings | reliability | source | relevance | action | source-reference | further-information">
			<xsl:if test="string-length(normalize-space(.))!=0">
				<section>
					<xsl:attribute name="class" select="name()" />
					<xsl:apply-templates select="node()"/>
				</section>		
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="introduction" mode="#all">
		<section class="introduction">
			<!-- empty title to help the next spreadsheet -->
			<title/>
			<p><xsl:apply-templates select="node()" mode="#current"/></p>
		</section>
	</xsl:template>
	
	<xsl:template match="/*/topic-element | sidebar | treatment | evidence" mode="#all">
		<section>
			
			<xsl:attribute name="bt:oen"><xsl:value-of select="name(.)"/></xsl:attribute>
			
			<xsl:choose>
				<xsl:when test="name()='topic-element'">
					<xsl:attribute name="id" select="@type"/>
				</xsl:when>
				<xsl:when test="@legacy-id">
					<xsl:attribute name="id">bt_<xsl:value-of select="@legacy-id"/></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="id">bt_transient_<xsl:value-of select="generate-id()"/></xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:if test="name()='topic-element'">
				<xsl:element name="metadata">
					<xsl:element name="key" namespace="{namespace-uri()}">
						<xsl:attribute name="name" 
							namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT">section-type</xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="@type"/></xsl:attribute>						
					</xsl:element>
				</xsl:element>
			</xsl:if>
			
			<title><xsl:apply-templates select="headline/node()"/></title>
			<!-- title -->
			<!--teaser-->
			
			<xsl:apply-templates select="introduction"/>
			
			<xsl:apply-templates select="body-text/p"/>

			<!-- include all sidebars, etc that are part of this topic -->
			<xsl:apply-templates select="xi:include"/>
			
			<!-- also, dodgily include sidebars that are part of other topics
			<xsl:for-each select="//sidebar-link[generate-id()=generate-id(key('sidebar-links-key', @target)[1])]">
				<xsl:if test="not(//xi:include[@href=@target])">
					<xsl:comment>out of condition sidebar link <xsl:value-of select="@target"/></xsl:comment>
					
					<xsl:apply-templates select="document(@target, .)/*[1]" mode="#current"/>

					<xsl:comment>end of out of condition sidebar link</xsl:comment>
				</xsl:if>
			</xsl:for-each>
			-->
		</section>
	</xsl:template>

	<xsl:template match="strong" mode="#all">
		<b><xsl:apply-templates mode="#current"/></b>
	</xsl:template>

	<xsl:template match="em" mode="#all">
		<i><xsl:apply-templates mode="#current"/></i>
	</xsl:template>

	<xsl:template match="pi-comment" mode="#all"/>

	<xsl:template match="internal-link" mode="#all">
		<xsl:choose>
			<!-- currently don't link to any of the about us pages -->
			<xsl:when test="not(ends-with(@target, '/4.xml') or ends-with(@target, '/44.xml'))">
				
				<xsl:variable name="file-exists">
					<xsl:call-template name="file-exists">
						<xsl:with-param name="relative-uri" select="@target" />
					</xsl:call-template>
				</xsl:variable>
				
				<xsl:choose>
					<xsl:when test="$file-exists='false'">
						<xsl:message>*** Couldn't find file <xsl:value-of select="@target"/> for <xsl:value-of select="name()"/> ***</xsl:message>
						<xsl:apply-templates mode="#current"/>
					</xsl:when>

					<!-- howtouse links -->
					<xsl:when test="contains(@target, 'howtouse')">
						
						<xsl:variable name="external-legacy-id">
							<xsl:call-template name="substring-after-last">
								<xsl:with-param name="string"><xsl:value-of select="@target"></xsl:value-of></xsl:with-param>
								<xsl:with-param name="delimiter">/</xsl:with-param>
							</xsl:call-template>
						</xsl:variable>
						
						<xsl:comment>how to use link: <xsl:value-of select="$external-legacy-id"/></xsl:comment>
						
						<link>
							<xsl:attribute name="target">decision-support-bt_<xsl:value-of select="$external-legacy-id"/>#xpointer(id('topic-info')</xsl:attribute>
							<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="name(.)"/></xsl:attribute>
							<xsl:apply-templates mode="#current"/>
						</link>
						
					</xsl:when>
					
					<!-- howtouse links end -->
					
					
					<xsl:otherwise>
						<xsl:variable name="includedFile" select="document(@target, .)"/>
						
						<xsl:variable name="legacy-id"><xsl:value-of select="$includedFile/*[1]/@legacy-id"/></xsl:variable>
				
						<xsl:variable name="external-legacy-id">
							<xsl:choose>
								<!-- if it's a link to ourselves, we don't include any filename before the # -->
								<xsl:when test="$legacy-id=$root-legacy-id"></xsl:when>
								
								<!-- if it's a link to another patient topic, we use the full filename -->
								<!-- but we only take anything after the last / -->
								<xsl:when test="$includedFile/patient-topic">
									<xsl:choose>
										<xsl:when test="contains(@target, '/')"><xsl:call-template name="substring-after-last">
											<xsl:with-param name="string"><xsl:value-of select="@target"></xsl:value-of></xsl:with-param>
											<xsl:with-param name="delimiter">/</xsl:with-param>
										</xsl:call-template></xsl:when>
										<xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								
								<!-- else us the legacy id -->
								<!-- todo: should this be prefixed with bt_ -->
								<xsl:otherwise><xsl:value-of select="$legacy-id"/>.xml</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						
						<xsl:comment>external legacy id: <xsl:value-of select="$external-legacy-id"/></xsl:comment>
						
						<link>
							<xsl:attribute name="target"><xsl:value-of select="$external-legacy-id"/>#xpointer(id('<xsl:value-of select="@target-element"/>')</xsl:attribute>
							
							<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="name(.)"/></xsl:attribute>
							<xsl:apply-templates mode="#current"/>
						</link>
						</xsl:otherwise>
					</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>	
		 
	<xsl:template match="uri-link" mode="#all">
		<xsl:choose>
			<xsl:when test="contains(@target, 'clinicalevidence')">
				<!-- Do nothing we are stripping out links to ce  -->
			</xsl:when>
			<xsl:when test="contains(@target, 'bmicalc')">
				<link>
					<xsl:attribute name="target">http://besthealth.bmj.com/btuk/scripts/BmiCalculator.html</xsl:attribute>
					<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="name(.)"/></xsl:attribute>
					<xsl:apply-templates mode="#current"/>
				</link>
			</xsl:when>
			<xsl:otherwise>
				<link>
					<xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
					<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="name(.)"/></xsl:attribute>
					<xsl:apply-templates mode="#current"/>
				</link>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<xsl:template match="gloss-link" mode="inside-gloss" priority="2">
		<link>
			<xsl:attribute name="type">gloss</xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
			<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="name(.)"/></xsl:attribute>
			<xsl:apply-templates mode="#current"/>
		</link>
	</xsl:template>	
	
	<xsl:template match="gloss-link" mode="#all" priority="1">
		<link>
			<xsl:attribute name="type">gloss</xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
			<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="name(.)"/></xsl:attribute>
			<xsl:apply-templates mode="#current"/>
		</link>
	</xsl:template>	


	<xsl:template match="reference-link" mode="inside-reference">
		<link>
			<xsl:attribute name="type">reference</xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
			<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="name(.)"/></xsl:attribute>
			<xsl:apply-templates/>
		</link>
	</xsl:template>
	
	<xsl:template match="elective-surgery-link" mode="#all">
		<xsl:apply-templates/>
	</xsl:template>
		
	<xsl:template match="reference-link" mode="#all">
		<link>
			<xsl:attribute name="type">reference</xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
			<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="name(.)"/></xsl:attribute>
			<xsl:apply-templates/>
			
			<!-- copy the whole references document into here -->
			<xsl:variable name="file-exists">
				<xsl:call-template name="file-exists">
					<xsl:with-param name="relative-uri" select="@target" />
				</xsl:call-template>
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="$file-exists='false'">
					<xsl:message>*** Couldn't find file <xsl:value-of select="@target"/> for <xsl:value-of select="name()"/> ***</xsl:message>
					<xsl:apply-templates mode="#current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="document(@target, .)" mode="inside-reference"/>
				</xsl:otherwise>
			</xsl:choose>
		</link>
	</xsl:template>	

	<xsl:template match="sidebar-link | treatment-link | evidence-link" mode="#all">
		<xsl:variable name="file-exists">
			<xsl:call-template name="file-exists">
				<xsl:with-param name="relative-uri" select="@target" />
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$file-exists='false'">
				<xsl:message>*** Couldn't find file <xsl:value-of select="@target"/> for <xsl:value-of select="name()"/> ***</xsl:message>
				<xsl:apply-templates mode="#current"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="includedFile" select="document(@target, .)"/>
				
				<xsl:variable name="legacy-id"><xsl:value-of select="$includedFile/*[1]/@legacy-id"/></xsl:variable>
				
				<link>
					<xsl:choose>
						<xsl:when test="$legacy-id">
		
							<xsl:variable name="current-target">
								<xsl:choose>
									<xsl:when test="contains(@target, '/')">
										<xsl:call-template name="substring-after-last">
											<xsl:with-param name="string" select="@target" />
											<xsl:with-param name="delimiter" select="'/'" />
										</xsl:call-template>
									</xsl:when>
									
									<xsl:otherwise>
										<xsl:value-of select="@target"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
				
							<!-- is it in a different topic? -->
							<xsl:variable name="sidebar-topic-filename"><xsl:value-of select="@topic"/>.xml</xsl:variable>
							
							<xsl:variable name="xi-includes">
								<xsl:for-each select="$topic-doc//xi:include">
									<xsl:variable name="target-stripped">
										<xsl:choose>
											<xsl:when test="contains(@href, '/')">
												<xsl:call-template name="substring-after-last">
													<xsl:with-param name="string" select="@href" />
													<xsl:with-param name="delimiter" select="'/'" />
												</xsl:call-template>
											</xsl:when>
											
											<xsl:otherwise>
												<xsl:value-of select="@href"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									
									<xi:include>
										<xsl:attribute name="href" select="$target-stripped"/>
									</xi:include>
								</xsl:for-each>
							</xsl:variable>

							<xsl:choose>
								<xsl:when test="$sidebar-topic-filename=$filename or 
									$xi-includes//xi:include[@href=$current-target]">
									<!-- this topic (determine either because there's an xi:include to it, or the topic is the same as this filename -->
									<xsl:attribute name="target">#xpointer(id('bt_<xsl:value-of select="$legacy-id"/>')</xsl:attribute>
									<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="name(.)"/></xsl:attribute>
								</xsl:when>
								
								<xsl:otherwise>
									<!-- another topic -->
									<xsl:attribute name="target"><xsl:value-of select="$sidebar-topic-filename"/>#xpointer(id('bt_<xsl:value-of select="$legacy-id"/>')</xsl:attribute>
									<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="name(.)"/></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							
							<!--<xsl:comment>sidebar topic filename is <xsl:value-of select="$sidebar-topic-filename"/></xsl:comment>
							<xsl:comment>current target is <xsl:value-of select="$current-target"/></xsl:comment>

							<test>
								<xsl:copy-of select="$xi-includes"/>
							</test>
							-->
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="target">todo-<xsl:value-of select="name()"/></xsl:attribute>
							<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="name(.)"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:apply-templates mode="#current"/>
				</link>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="drug" mode="#all">
		<span class="drugname"><xsl:apply-templates mode="#current"/></span>
	</xsl:template>
	
	<xsl:template match="item" mode="#all">
		<li><xsl:apply-templates mode="#current"/></li>
	</xsl:template>
	
	<xsl:template match="th" mode="#all">
		<td>
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
			
			<xsl:apply-templates mode="#current"/></td>
	</xsl:template>
	
	<xsl:template match="p">
		<xsl:choose>
			<!-- if the first child is a text node, open a p tag -->
			<xsl:when test="not(name(node()[1])) and normalize-space(node()[1]) != ''">
				<xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
				<!-- open p1 -->
			</xsl:when>

			<!-- if the first child isn't a list or a heading, open a p tag -->
			<xsl:when test="not(name(child::*[1]) = 'list') and 
				not(name(child::*[1]) = 'heading1') and 
				not(name(child::*[1]) = 'heading2') and 
				not(name(child::*[1]) = 'table')">
				<!-- yes: open the p tag -->
				<xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
				<!-- open p2 -->
			</xsl:when>
		</xsl:choose>
		
		<xsl:apply-templates select="node()" mode="para1"/>
		
		<!-- if the last element is a list, we don't need to close the p tag -->
		<xsl:choose>
			<xsl:when test="not(name(node()[last()])) and normalize-space(node()[last()]) != ''">
				<xsl:text disable-output-escaping="yes">&lt;/p&gt;&#13;</xsl:text>
				<!-- close p1 -->
			</xsl:when>

			<!-- if the last child isn't a list, close a p tag -->
			<xsl:when test="not(name(child::*[last()]) = 'list') and 
				not(name(child::*[last()]) = 'heading1') and 
				not(name(child::*[last()]) = 'heading2') and
				not(name(child::*[last()]) = 'table')">
				<!-- yes: close the p tag -->
				<xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
				<!-- close p2 -->
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	

	<!-- go through every node before us
		if any of them are element nodes, or non-empty text nodes we need to 
		close the previous p-tag
	-->
	<xsl:template name="close-p-tags">
		<xsl:param name="node-set"/>
		
		<xsl:choose>
			<xsl:when test="name($node-set[last()])">
				<!-- it's an element, output the p tag and don't go any further back -->
				<xsl:text disable-output-escaping="yes">&lt;/p&gt;&#13;</xsl:text>
				<xsl:comment>close p2</xsl:comment>
			</xsl:when>
			
			<xsl:otherwise>
				<!-- it's a text node -->
				
				<!--xsl:comment>
					<xsl:text>prior text node is </xsl:text>
					<xsl:value-of select="$node-set[last()]"/>
					</xsl:comment-->
				
				<xsl:choose>
					<xsl:when test="normalize-space($node-set[last()]) != ''">
						<xsl:text disable-output-escaping="yes">&lt;/p&gt;&#13;</xsl:text>
						<xsl:comment>close p3</xsl:comment>
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:if test="$node-set/preceding-sibling::node()">
							<!--
								<xsl:comment>would recurse with <xsl:value-of select="$node-set/preceding-sibling::node()"></xsl:value-of></xsl:comment>
							-->
							
							<xsl:call-template name="close-p-tags">
								<xsl:with-param name="node-set" select="$node-set/preceding-sibling::node()"/>
							</xsl:call-template>
						</xsl:if>
						
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<!-- go through every node before us
		if any of them are element nodes, or non-empty text nodes we need to 
		close the previous p-tag
	-->
	<xsl:template name="open-p-tags">
		<xsl:param name="node-set"/>
		
		<xsl:choose>
			<xsl:when test="name($node-set[1])">
				<!-- it's an element, output the p tag and don't go any further forward -->
				<xsl:text disable-output-escaping="yes">&lt;p&gt;&#13;</xsl:text>
				<xsl:comment>open p2</xsl:comment> 
			</xsl:when>
			
			<xsl:otherwise>
				<!-- it's a text node -->
				
				<!--xsl:comment>
					<xsl:text>prior text node is </xsl:text>
					<xsl:value-of select="$node-set[last()]"/>
					</xsl:comment-->
				
				<xsl:choose>
					<xsl:when test="normalize-space($node-set[1]) != ''">
						<xsl:text disable-output-escaping="yes">&lt;p&gt;&#13;</xsl:text>
						<xsl:comment>open p3</xsl:comment>
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:if test="$node-set/following-sibling::node()">
							<!--
								<xsl:comment>would recurse with <xsl:value-of select="$node-set/preceding-sibling::node()"></xsl:value-of></xsl:comment>
							-->
							
							<xsl:call-template name="open-p-tags">
								<xsl:with-param name="node-set" select="$node-set/following-sibling::node()"/>
							</xsl:call-template>
						</xsl:if>
						
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>

<!--currently hide these-->
	<!--<xsl:template match="heading1|heading2|internal-link" mode="#all"></xsl:template>-->
	
	<xsl:template match="list|heading1|heading2|table" mode="para1">
		<!-- if we have something before us we might need to close the p tag -->
		<xsl:if test="preceding-sibling::node()[last()]">
			<xsl:call-template name="close-p-tags">
				<xsl:with-param name="node-set" select="preceding-sibling::node()"/>
			</xsl:call-template>
		</xsl:if>
		
		<xsl:element name="{name()}">
			<xsl:apply-templates select="node()" mode="#current"/>
		</xsl:element>
		
		<!-- if we have anything after us we might need to open a p tag -->
		<xsl:if test="following-sibling::node()[1]">
			<xsl:call-template name="open-p-tags">
				<xsl:with-param name="node-set" select="following-sibling::node()"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="image-link" mode="#all">
		<figure>
			<xsl:variable name="after-slash">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="string" select="@target" />
					<xsl:with-param name="delimiter" select="'/'" />
				</xsl:call-template>
			</xsl:variable>
			
			<xsl:attribute name="image">images/<xsl:value-of select="$after-slash"/></xsl:attribute>

			<caption><p>
				<xsl:choose>
					<xsl:when test="@caption and normalize-space(@caption)!=''"><xsl:value-of select="@caption"/></xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</p></caption>
			
			<!-- todo: alignment -->
		</figure>
	</xsl:template>
	
	<xsl:template match="xi:include" mode="#all">
		<xsl:comment>xi:include <xsl:value-of select="@href"/></xsl:comment>

		<xsl:variable name="file-exists">
			<xsl:call-template name="file-exists">
				<xsl:with-param name="relative-uri" select="@href" />
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$file-exists='false'">
				<xsl:message>*** Couldn't find file <xsl:value-of select="@href"/> for <xsl:value-of select="name()"/> ***</xsl:message>
				<xsl:apply-templates mode="#current"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="document(@href, .)/*[1]" mode="#current"/>
				<xsl:comment>end xi:include</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="file-exists" xmlns:file="java.io.File">
		<xsl:param name="relative-uri" as="xs:string"/>
		
		<xsl:variable name="absolute-uri" select="resolve-uri($relative-uri, base-uri(.))" as="xs:anyURI"/>
		
		<xsl:variable name="file-exists"><xsl:value-of select="file:exists(file:new($absolute-uri))"/></xsl:variable>
		
		<!--<xsl:message>uri=<xsl:value-of select="$absolute-uri"/> exists=<xsl:value-of select="$file-exists"/></xsl:message>-->
		
		<xsl:value-of select="$file-exists"></xsl:value-of>
	</xsl:template>
	
	<!-- match any other element, writing it out and calling apply-templates for any children -->
	<xsl:template match="*" mode="#all">
		<xsl:element name="{name()}">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
			
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xi="http://www.w3.org/2001/XInclude" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html" 
	xmlns:oak="http://schema.bmj.com/delivery/oak" 
	xmlns:ce="http://schema.bmj.com/delivery/oak-ce" 
	version="2.0">
	
	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"/>
	
	<xsl:param name="lang"/>
	<xsl:param name="media"/>
	<xsl:param name="links-xml-input"/>
	<xsl:param name="systematic-review-xml-input"/>
	<xsl:param name="process-stream"/>
	<xsl:param name="proof"/>
	<xsl:param name="systematic-review-meta-input"/>

	<xsl:param name="strings-variant-fileset"/>
	<xsl:param name="xmlns" select="string('ce')"/>
	
	<xsl:include href="../../generic-params.xsl"/>
	<xsl:include href="../../systematic-review-params.xsl"/>
	
	<xsl:include href="../../xsl-lib/strings/publication-labels-process-shared.xsl"/>
	
	<xsl:include xpath-default-namespace="" href="../oak/systematic-review-oak-comparisons-serial.xsl"/>
	<xsl:include xpath-default-namespace="" href="../oak/systematic-review-oak-comparisons-grade-table.xsl"/>

	<xsl:variable name="cid" select="substring-after(/systematic-review/@id, '_')"/>
	<xsl:variable name="id-lead-text" select="''"/>
	<xsl:variable name="systematic-review-title" select="/systematic-review/info/title/node()"/>
	
	<xsl:variable name="links" select="document(translate($links-xml-input, '\\', '/'))/*"/>
	
	<xsl:variable name="bmjk-review-plan" select="document(/systematic-review/info/bmjk-review-plan-link/@target)/*"/>
	
	<xsl:variable name="question-list">
		<xsl:element name="question-list">
			<xsl:for-each select="/systematic-review/question-list/question">
				<xsl:element name="question">
					<xsl:copy-of select="title"/>
					<xsl:choose>
						<xsl:when test="option">
							<xsl:for-each select="option">
								<xsl:copy-of select="self::option"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="xi:include[contains(@href, 'option')]">
								<xsl:copy-of select="document(@href)/*"/>	
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>	
	</xsl:variable>
	
	<xsl:variable name="evidence-appraisal-grade-table">
		<xsl:choose>
			<xsl:when test="$question-list//*:question/*:option/*:comparison-set/*:comparison/*:grade/*:evidence-appraisal">
				<xsl:text>true</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>false</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:template match="/">
		
		<condition>
			<xsl:attribute name="id">
				<xsl:value-of select="$cid"/>
			</xsl:attribute>
			
			<xsl:choose>
				<xsl:when test="translate($process-stream, $upper, $lower) = 'new'">
					<xsl:attribute name="is-new">
						<xsl:text>true</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="translate($process-stream, $upper, $lower) = 'archive'">
					<xsl:attribute name="is-archived">
						<xsl:text>true</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="is-updated">
						<xsl:text>true</xsl:text>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:if test="/systematic-review[@pubdate!='']">
				<xsl:attribute name="pubdate">
						<xsl:value-of select="/systematic-review/@pubdate"/>
					</xsl:attribute>
			</xsl:if>
			<xsl:if test="/systematic-review[@weight!='']">
				<xsl:attribute name="weight">
						<xsl:value-of select="/systematic-review/@weight"/>
					</xsl:attribute>
			</xsl:if>
			
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">http://schema.bmj.com/delivery/hackberry/condition.xsd</xsl:attribute>
			
			<!--<xsl:attribute name="xmlns:ce">http://schema.bmj.com/delivery/oak-ce</xsl:attribute>-->

			<!-- add cms version number from seperate metadata file -->
			<xsl:comment>
				<xsl:text>version:</xsl:text>
				<xsl:value-of select="document(translate($systematic-review-meta-input, '\\', '/'), /)/meta/version"/>
			</xsl:comment>
						
			<xsl:call-template name="process-section-info"/>
			
			<condition-info>			
				
				<condition-long-title>
					<xsl:value-of select="/systematic-review/info/title"/>
				</condition-long-title>
				
				<condition-abridged-title>
					<xsl:value-of select="/systematic-review/info/abridged-title"/>
				</condition-abridged-title>
				
				<search-date>
					<xsl:choose>
						<xsl:when test="contains(translate(/systematic-review/info/search-date, $upper, $lower), 'search date ')">
							<xsl:value-of select="normalize-space(/systematic-review/info/search-date)"/>							
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Search date </xsl:text>
							<xsl:value-of select="normalize-space(/systematic-review/info/search-date)"/>
						</xsl:otherwise>
					</xsl:choose>
				</search-date>
				
				<collective-name>
					<xsl:value-of select="/systematic-review/info/collective-name"/>
				</collective-name>
				
				<xsl:call-template name="process-contributors"/>
				
				<xsl:element name="footnote">
					<xsl:choose>
						<xsl:when test="/systematic-review/info/footnote/p[1][string-length(.)!=0]">
							<xsl:for-each select="/systematic-review/info/footnote/p">
								<p>
									<xsl:apply-templates/>
								</p>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<p/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				
				<xsl:element name="covered-elsewhere">
					<xsl:choose>
						<xsl:when test="/systematic-review/info/covered-elsewhere/p[1][string-length(.)!=0]">
							<xsl:for-each select="/systematic-review/info/covered-elsewhere/p">
								<p>
									<xsl:apply-templates/>
								</p>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<p/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				
				<xsl:element name="future-updates">
					<xsl:choose>
						<xsl:when test="$bmjk-review-plan//info/future-issues/p[1][string-length(.)!=0]">
							<xsl:for-each select="$bmjk-review-plan//info/future-issues/p">
								<xsl:apply-templates select="."/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<p/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				
			</condition-info>
			<xsl:call-template name="process-clinical-context"/>
			<xsl:call-template name="process-summary-view"/>
			<xsl:call-template name="process-key-points"/>
			<xsl:call-template name="process-background"/>
			<xsl:call-template name="process-questions"/>
			<xsl:call-template name="process-substantive-changes"/>
			<xsl:call-template name="process-glossary"/>
			<xsl:call-template name="process-references"/>
			<xsl:call-template name="process-figures"/>
			
			<xsl:if test="$links//table-link or $evidence-appraisal-grade-table = 'true'">
				<xsl:call-template name="process-tables"/>
			</xsl:if>
			
		</condition>

	</xsl:template>
	
	<xsl:template name="process-section-info">
		<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after($bmjk-review-plan//info/section-list/section-link[1]/@target, '../'))"/>
		<xsl:variable name="primary-section-info" select="document($filename)/*"/>
		<primary-section-info>
			<xsl:attribute name="id" select="$primary-section-info//@id"/>
			<section-long-title>
				<xsl:value-of select="$primary-section-info//title"/>
			</section-long-title>
			<section-abridged-title>
				<xsl:value-of select="$primary-section-info//abridged-title"/>
			</section-abridged-title>
			<section-advisors>
				<xsl:for-each select="$primary-section-info//advisor-set/person-link">
					<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
					<xsl:variable name="person" select="document($filename)/*"/>
					<advisor>
						<xsl:for-each select="$person/*">
							<xsl:copy-of select="."/>
						</xsl:for-each>
					</advisor>
				</xsl:for-each>
			</section-advisors>
		</primary-section-info>
		
		<xsl:for-each select="$bmjk-review-plan//info/section-list/section-link[position()!=1]/*">
			<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
			<xsl:variable name="additional-section-info" select="document($filename)/*"/>
			<secondary-section-info>
				<xsl:attribute name="id">
					<xsl:value-of select="$additional-section-info//@id"/>
				</xsl:attribute>
				<section-long-title>
					<xsl:value-of select="$additional-section-info//title"/>
				</section-long-title>
				<section-abridged-title>
					<xsl:value-of select="$additional-section-info//abridged-title"/>
				</section-abridged-title>
				<section-advisors>
					<xsl:for-each select="$additional-section-info//advisor-set/person-link">
						<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
						<xsl:variable name="person" select="document($filename)/*"/>
						<advisor>
							<xsl:attribute name="id">
								<xsl:value-of select="concat($cid, '_CONTRIB', position())"/>
							</xsl:attribute>
							<xsl:for-each select="$person//*">
								<xsl:copy-of select="."/>
							</xsl:for-each>
						</advisor>
					</xsl:for-each>
				</section-advisors>
			</secondary-section-info>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="process-contributors">
		<contributors>
			<xsl:for-each select="$bmjk-review-plan//contributor-set/person-link">
				<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
				<xsl:variable name="person" select="document($filename)/*"/>
				<contributor>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($cid, '_CONTRIB', position())"/>
					</xsl:attribute>
					<xsl:for-each select="$person//*">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</contributor>
			</xsl:for-each>
		</contributors>
	    
		<!--<xsl:copy-of select="/systematic-review/info/competing-interests"/>-->
	    
	    <xsl:element name="competing-interests">
	        
	        <xsl:for-each select="/systematic-review/info/competing-interests/p">
	            <xsl:element name="p">
	                <xsl:apply-templates select="node()"/>
	            </xsl:element>
	        </xsl:for-each>
	        
	    </xsl:element>
	    
	</xsl:template>
	
	<xsl:template name="process-summary-view">
		<summary-view>
			
			<xsl:for-each select="/systematic-review/question-list/question">
				
				<question-list>
					<xsl:attribute name="refid" select="concat($cid, '_Q', position())"/>
					
					<title>
						<xsl:apply-templates select="title"/>
					</title>
					<abridged-title>
						<xsl:apply-templates select="abridged-title"/>
					</abridged-title>
					
					<xsl:variable name="question">
						<xsl:for-each select=".//xi:include[contains(@href, 'option')]">
							<xsl:element name="{name()}">
								<xsl:attribute name="href" select="@href"/>
								<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@href, '../'))"/>
								<xsl:copy-of select="document($filename)/*"/>
							</xsl:element>
						</xsl:for-each>
					</xsl:variable>
										
					<xsl:for-each select="$efficacy-order/*">
						<xsl:variable name="efficacy-type" select="name()"/>
						
						<xsl:if test="$question//intervention[@efficacy = $efficacy-type]">
							
							<efficacy-list>
								<xsl:attribute name="efficacy">
									<xsl:value-of select="$efficacy-type"/>
								</xsl:attribute>
								
								<title>
									<xsl:value-of select="$glue-text/*[name()=$efficacy-type][contains(@lang, $lang)]"/>
								</title>
								
								<xsl:for-each select="$question//intervention">
									<xsl:sort select="title[1]"/>
									
									<xsl:if test="@efficacy = $efficacy-type">
										<!-- chpping '../options/_op1003_I1.xml' or 
										'../options/option-1179218159900_en-gb.xml' to get option id -->
										<xsl:variable name="iid" select="concat($cid, '_I', replace(ancestor::xi:include[contains(@href, 'option')]/@href, '^.*?[I\-](\d+).*?$', '$1'))"/>
										<intervention>
											<xsl:attribute name="refid" select="$iid"/>
											<xsl:if test="parent::option[substantive-change-set/substantive-change/@status = 'new-option']">
												<xsl:attribute name="is-new">true</xsl:attribute>
											</xsl:if>
											
											<title>
												<xsl:apply-templates select="title"/>
											</title>
											
											<!-- summary-statement -->
											<xsl:choose>
												<xsl:when test="string-length(summary-statement[1])">
													<xsl:for-each select="summary-statement">
														<key-message>
															<xsl:apply-templates/>
														</key-message>	
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<key-message>
														<xsl:apply-templates select="ancestor::option/summary-statement"/>
													</key-message>
												</xsl:otherwise>
											</xsl:choose>
											
										</intervention>
										
									</xsl:if>
									
								</xsl:for-each>
								
							</efficacy-list>
							
						</xsl:if>
						
					</xsl:for-each>
					
				</question-list>
			
			</xsl:for-each>
			
		</summary-view>

	</xsl:template>

	<xsl:template name="process-key-points">
		<keypoint-list>
			<xsl:attribute name="id" select="concat($cid, '_KEYPOINT')"/>
			<xsl:for-each select="/systematic-review/key-point-list/node()">
				<xsl:apply-templates select="."/>
			</xsl:for-each>			
		</keypoint-list>
	</xsl:template>
	
	<xsl:template name="process-background">
		
		<xsl:variable name="background">
			
			<!-- first extract from topic -->
			<xsl:for-each select="/systematic-review/background/*">
				
				<xsl:variable name="name" select="name()"/>
				
				<xsl:element name="{$name}">
					<xsl:attribute name="id" select="concat($cid, '_', translate(name(), $lower, $upper))"/>
					
					<xsl:apply-templates select="p/node()"/>
					
					<xsl:if test="$evidence-appraisal-grade-table='true' and $name='methods'">
						
						<xsl:text disable-output-escaping="yes"> </xsl:text>
						
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="string('methods-performed-grade-evaluation')"/>
						</xsl:call-template>
						
						<xsl:text disable-output-escaping="yes"> (</xsl:text>
						
						<xsl:element name="link">
							<xsl:attribute name="type">table</xsl:attribute>
							<xsl:attribute name="target" select="concat($cid, '-t', 'g')"/>
							
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="string('see-table')"/>
								<xsl:with-param name="case" select="string('lower')"/>
							</xsl:call-template>
							
						</xsl:element>
						
						<xsl:text disable-output-escaping="yes">). </xsl:text>
						
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="string('methods-performed-grade-evaluation-description')"/>
						</xsl:call-template>
						
					</xsl:if>
					
				</xsl:element>
				
			</xsl:for-each>
			
			<!-- secondly extract from plan -->
			<!--xsl:for-each select="$bmjk-review-plan//background/*">
				<xsl:element name="{name()}">
					<xsl:attribute name="id">
						<xsl:value-of select="concat($cid, '_', translate(name(), $lower, $upper))"/>
					</xsl:attribute>
					<xsl:apply-templates select="p/node()"/>
				</xsl:element>
				</xsl:for-each-->
			
		</xsl:variable>
		
		<!-- then rebuild + order -->
		<xsl:element name="background">
			<xsl:for-each select="$background-order/*">
				<xsl:variable name="name" select="name()"/>
				<xsl:if test="$background/node()[name()=$name][string-length(.)!=0]">
					<xsl:copy-of select="$background/node()[name()=$name]"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
		
	</xsl:template>

	<xsl:template name="process-questions">
		
		<questions>
		
			<!-- questions -->
			<xsl:for-each select="/systematic-review/question-list/question">
			
				<question>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($cid, '_Q', position())"/>
					</xsl:attribute>
					
					<question-long-title>
						<xsl:apply-templates select="title"/>
					</question-long-title>
					<question-abridged-title>
						<xsl:apply-templates select="abridged-title"/>
					</question-abridged-title>
						
					<!-- options -->
					<xsl:for-each select=".//xi:include[contains(@href, 'option')]">
						
						<!-- chpping '../options/_op1003_I1.xml' or 
							'../options/option-1179218159900_en-gb.xml' to get option id -->
						<xsl:variable name="iid" select="concat($cid, '_I', replace(@href, '^.*?[I\-](\d+).*?$', '$1'))"/>
						
						<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@href, '../'))"/>
						<xsl:variable name="option" select="document($filename)/*"/>
						
						<option>
							<xsl:attribute name="id" select="$iid"/>
							
							<!-- add cms version number from seperate metadata file -->
							<xsl:comment>
								<xsl:text>version:</xsl:text>
								<xsl:value-of select="document(concat(translate($systematic-review-xml-input, '\\', '/'), 'meta/', substring-after(@href, '../')))/meta/version"/>
							</xsl:comment>
							
							<option-long-title>
								<xsl:apply-templates select="$option/title"/>
							</option-long-title>
							<option-abridged-title>
								<xsl:apply-templates select="$option/abridged-title"/>
							</option-abridged-title>
							
							<xsl:if test="$option/option-contributor[string-length(.)!=0]">
								<option-contributor>
									<xsl:apply-templates select="$option/option-contributor"/>
								</option-contributor>
							</xsl:if>
							
							<!-- summary-statement -->
							<xsl:choose>
								
								<xsl:when test="string-length($option/summary-statement)">
									<key-message>
										<xsl:apply-templates select="$option/summary-statement"/>
									</key-message>
								</xsl:when>
								
								<xsl:when test="count($option/intervention-set/intervention) = 1">

									<xsl:if test="$option/comparison-set">
										<xsl:comment>new comparison model replacing benefits and harms can suggest multiple key-messages in the new format</xsl:comment>
									</xsl:if>
									
									<xsl:for-each select="$option/intervention-set/intervention/summary-statement">
										<key-message>
											<xsl:apply-templates/>
										</key-message>
									</xsl:for-each>
									
								</xsl:when>
								
							</xsl:choose>
	
							<!-- intervention summary -->
							<xsl:for-each select="$option/intervention-set/intervention">
								
								<intervention-summary>
									
									<intervention-title>
										<xsl:attribute name="efficacy" select="@efficacy"/>
										<xsl:apply-templates select="title"/>
									</intervention-title>
									
									<xsl:if test="$option/comparison-set">
										<xsl:comment>new comparison model replacing benefits and harms can suggest multiple key-messages in the new format</xsl:comment>
									</xsl:if>
									
									<xsl:if test="$evidence-appraisal-grade-table = 'true'">
										
										<xsl:element name="key-message">
											
											<xsl:text>For </xsl:text>
											
											<xsl:call-template name="process-string-variant">
												<xsl:with-param name="name" select="string('grade')"/>
											</xsl:call-template>
											
											<xsl:text disable-output-escaping="yes"> </xsl:text>
											
											<xsl:call-template name="process-string-variant">
												<xsl:with-param name="name" select="string('evaluation-of-interventions')"/>
												<xsl:with-param name="case" select="string('lower')"/>
											</xsl:call-template>
											
											<xsl:text> for </xsl:text>
											
											<xsl:apply-templates select="$systematic-review-title"/>
											
											<xsl:text>, </xsl:text>
											
											<xsl:element name="link">
												<xsl:attribute name="target" select="concat($id-lead-text, $cid, '-t', 'g')"/>
												<xsl:attribute name="type" select="string('table')"/>
												
												<xsl:call-template name="process-string-variant">
													<xsl:with-param name="name" select="string('see-table')"/>
													<xsl:with-param name="case" select="string('lower')"/>
												</xsl:call-template>
												
											</xsl:element>
											
											<xsl:text>. </xsl:text>
											
										</xsl:element>
										
									</xsl:if>
									
									<xsl:for-each select="summary-statement">
										
										<key-message>
											<xsl:apply-templates/>
										</key-message>
										
									</xsl:for-each>
									
								</intervention-summary>
								
							</xsl:for-each>
							
							<xsl:choose>
								
								<xsl:when test="$option/comparison-set">
									
									<!--<xsl:apply-templates select="intervention-set/intervention" mode="comparison-serial" />-->
									
									<xsl:comment>original hackberry xml format benefits and harms elements have been replaced 
										with new content model comparison-set as oak xml format</xsl:comment>
									
									<xsl:apply-templates select="$option/comparison-set" mode="comparisons-serial">
										<xsl:with-param name="iid" select="$iid"/>
									</xsl:apply-templates>
									
									<xsl:apply-templates select="$option/drug-safety-alert">
										<xsl:with-param name="iid" select="$iid"/>
									</xsl:apply-templates>
									
									<xsl:apply-templates select="$option/comment">
										<xsl:with-param name="iid" select="$iid"/>
									</xsl:apply-templates>
									
									<!--<xsl:apply-templates select="$option/substantive-change-set"/>-->
									
								</xsl:when>
								
								<xsl:otherwise>
									
									<!-- over-arching statement -->
									<!--<xsl:choose>
										
										<xsl:when test="summary-statement[string-length(normalize-space(.))!=0]">
											<xsl:apply-templates select="summary-statement" />
										</xsl:when>
										
										<xsl:when test="count(intervention-set/intervention) = 1">
											<xsl:apply-templates select="intervention-set/intervention/summary-statement" />
										</xsl:when>
										
									</xsl:choose>-->
									
									<!-- individual intervention statements -->
									<!--<xsl:for-each select="intervention-set[count(intervention) &gt; 1]/intervention">
										
										<xsl:element name="section">
											
											<xsl:apply-templates select="title" mode="title"/>
											
											<xsl:element name="metadata">
												<xsl:element name="key">
													<xsl:attribute name="{concat($xmlns, ':name')}" select="'intervention-efficacy'"/>
													<xsl:attribute name="value" select="@efficacy"/>
												</xsl:element>
											</xsl:element>
											
											<xsl:apply-templates select="summary-statement" />
											
										</xsl:element>
										
									</xsl:for-each>-->
									
									<xsl:apply-templates select="$option/benefits">
										<xsl:with-param name="iid" select="$iid"/>
									</xsl:apply-templates>
									
									<xsl:apply-templates select="$option/harms">
										<xsl:with-param name="iid" select="$iid"/>
									</xsl:apply-templates>
									
									<xsl:apply-templates select="$option/drug-safety-alert">
										<xsl:with-param name="iid" select="$iid"/>
									</xsl:apply-templates>
									
									<xsl:apply-templates select="$option/comment">
										<xsl:with-param name="iid" select="$iid"/>
									</xsl:apply-templates>
									
									<!--<xsl:apply-templates select="$option/substantive-change-set"/>-->
									
								</xsl:otherwise>
							</xsl:choose>
							
							<!-- substantive-changes -->
							<xsl:element name="substantive-changes">
								<xsl:element name="substantive-change">
									<xsl:attribute name="status">
										<xsl:choose>
											<xsl:when test="$option//substantive-change-set/substantive-change/@status and string-length($option//substantive-change-set/substantive-change/@status)!=0">
												<xsl:value-of select="$option//substantive-change-set/substantive-change[1]/@status"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>no-new-evidence</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:apply-templates select="$option//substantive-change-set/substantive-change/node()"/>
								</xsl:element>
							</xsl:element>
							
						</option>
						
					</xsl:for-each>			
				
				</question>
				
			</xsl:for-each>
			
		</questions>
		
	</xsl:template>
	
	<xsl:template match="benefits | harms | comment[parent::option]">
		<xsl:param name="iid"/>
		
		<xsl:element name="{name()}">
			<xsl:attribute name="id" select="concat($iid, '_', translate(name(), $lower, $upper))"/>
			
			<xsl:for-each select="p">
				<xsl:apply-templates select="node()"/>
				<xsl:text> </xsl:text>
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="drug-safety-alert">
		<xsl:param name="iid"/>
		
		<xsl:element name="{name()}">
			<xsl:attribute name="id" select="concat($iid, '_ALERT')"/>
			
			<xsl:for-each select="p">
				<xsl:element name="p">
					<xsl:apply-templates select="node()"/>
				</xsl:element>
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-glossary">
		
		<xsl:if test="$links//gloss-link">
			
			<xsl:element name="glossary">
				
				<xsl:variable name="glossary">
					
					<xsl:for-each select="$links//gloss-link">
						<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
						<xsl:variable name="gloss" select="document($filename)/*"/>
						
						<xsl:element name="gloss">
							<xsl:attribute name="id" select="concat($cid, '_G', position())"/>
							
							<xsl:if test="string-length(normalize-space($gloss))=0">
								<xsl:element name="error-glossary-element-empty" />
							</xsl:if>
							
							<xsl:apply-templates select="$gloss"/>
							
						</xsl:element>
						
					</xsl:for-each>
					
				</xsl:variable>
				
				<xsl:for-each select="$glossary/element()">
					<xsl:sort select="."/>
					<xsl:copy-of select="."/>
				</xsl:for-each>
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="process-substantive-changes">
		
		<xsl:if test="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='new-evidence-conclusions-confirmed' or @status='new-evidence-conclusions-changed']">
			
			<xsl:element name="substantive-changes">
				
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='new-evidence-conclusions-confirmed']">
					
					<xsl:element name="substantive-change">
						<xsl:attribute name="status" select="@status"/>
						
						<xsl:apply-templates select="node()"/>
						
					</xsl:element>
					
				</xsl:for-each>
				
				<xsl:for-each select="document(//xi:include[contains(@href, 'option')]/@href)//substantive-change-set/substantive-change[@status='new-evidence-conclusions-changed']">
					
					<xsl:element name="substantive-change">
						<xsl:attribute name="status" select="@status"/>
						
						<xsl:apply-templates select="node()"/>
						
					</xsl:element>
					
				</xsl:for-each>
				
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="process-references">
		
		<xsl:element name="references">
			
			<xsl:for-each select="$links//reference-link">
				<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
				<xsl:variable name="reference" select="document($filename)/*"/>
				
				<xsl:element name="reference">
					<xsl:attribute name="id" select="concat($cid, '_REF', position())"/>
					
					<xsl:if test="$reference//unique-id[@source='medline' and string-length(normalize-space(.))!=0]">
						<xsl:attribute name="pubmed-id" select="$reference//unique-id"/>
					</xsl:if>
					
					<xsl:apply-templates select="$reference//clinical-citation"/>
					
				</xsl:element>
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-figures">
		
		<xsl:if test="$links//figure-link">
			
			<xsl:element name="figures">
				
				<xsl:for-each select="$links//figure-link">
					<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
					<xsl:variable name="figure" select="document($filename)/*"/>
					
					<xsl:element name="figure">
						<xsl:attribute name="id" select="concat($cid, '_F', position())"/>
						<xsl:attribute name="media" select="$media"/>
						
						<xsl:element name="graphic">
							<xsl:attribute name="url">
								<!--<xsl:text>http://www.clinicalevidence.bmj.com/images/</xsl:text>-->
								<!--<image-link target="../images/0201_figure_1_default.jpg"/>-->
								<xsl:value-of select="replace($figure//image-link/@target, '^\.\./images/(.+?)(_default)?\.(.+?)$', '$1')"/>
							</xsl:attribute>
						</xsl:element>
						
						<xsl:element name="caption">
							<xsl:apply-templates select="$figure//caption/node()"/>
						</xsl:element>
						
					</xsl:element>
					
				</xsl:for-each>
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template name="process-clinical-context">

		<xsl:variable name="clinical-context">			
			<!-- first extract from topic -->
			<xsl:for-each select="/systematic-review/clinical-context/*">				
				<xsl:variable name="name" select="name()"/>				
				<xsl:element name="{$name}">
					<xsl:attribute name="id" select="concat($cid, '_', translate(name(), $lower, $upper))"/>					
					<xsl:apply-templates select="p/node()"/>					
				</xsl:element>				
			</xsl:for-each>			
		</xsl:variable>
		
		<!-- then rebuild + order -->
		<xsl:element name="clinical-context">
			<xsl:for-each select="$clinical-context-order/*">
				<xsl:variable name="name" select="name()"/>
				<xsl:if test="$clinical-context/node()[name()=$name][string-length(.)!=0]">
					<xsl:copy-of select="$clinical-context/node()[name()=$name]"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
		
		
	</xsl:template>
	
	
	<xsl:template name="process-tables">
		
		<xsl:element name="tables">
			
			<xsl:for-each select="$links//table-link">
				
				<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after(@target, '../'))"/>
				<xsl:apply-templates select="document($filename)/*" mode="inline-grade-table-hackberry">
					<xsl:with-param name="position" select="position()"/>
				</xsl:apply-templates>
				
			</xsl:for-each>
			
			<xsl:variable name="comparisons-grade-table-oak">
				<xsl:call-template name="process-comparisons-grade-table"/>	
			</xsl:variable>
			
			<xsl:apply-templates select="$comparisons-grade-table-oak" mode="comparisons-grade-table-oak"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="*:table" mode="inline-grade-table-hackberry">
		<xsl:param name="position"/>
		
		<xsl:if test="(contains(translate(caption, $upper, $lower), 'grade') or @grade='true') and $evidence-appraisal-grade-table = 'true'">
			<xsl:element name="error-more-than-one-grade-table-not-allowed"/>
		</xsl:if>
		
		<xsl:element name="table-data">
			<xsl:attribute name="id" select="concat($cid, '_T', $position)"/>
			<xsl:attribute name="media" select="$media"/>
			
			<xsl:attribute name="grade">
				<xsl:choose>
					<xsl:when test="contains(translate(caption, $upper, $lower), 'grade') or @grade='true'">
						<xsl:text>true</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>false</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:element name="caption">
				<xsl:apply-templates select="caption/node()"/>
			</xsl:element>
			
			<xsl:element name="cals:table">
				<xsl:attribute name="orient" select="string('LAND')"/>
				<xsl:attribute name="frame" select="string('NONE')"/>
				
				<xsl:element name="cals:tgroup">
					<xsl:attribute name="cols" select="count(tbody/tr[count(td)!=1][1]/td)"/>
					<xsl:attribute name="colsep">0</xsl:attribute>
					<xsl:attribute name="rowsep">0</xsl:attribute>
					
					<xsl:for-each select="tbody/tr[count(td)!=1][1]/td">
						<xsl:element name="cals:colspec">
							<xsl:attribute name="colnum" select="position()"/>
							<xsl:attribute name="colname" select="concat('col', position())"/>
							<xsl:attribute name="colwidth">1*</xsl:attribute>
							<xsl:attribute name="align" select="translate(@align, $lower, $upper)"/>
						</xsl:element>
					</xsl:for-each>
					
				</xsl:element>
				
				<xsl:apply-templates select="*:thead|*:tbody|*:tfoot"/>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="*:table" mode="comparisons-grade-table-oak">
		
		<xsl:element name="table-data">
			<xsl:attribute name="id" select="@id"/>
			<xsl:attribute name="media" select="string('web print')"/>
			<xsl:attribute name="grade" select="string('true')"/>
			
			<xsl:element name="caption">
				<xsl:apply-templates select="*:caption/*:p/node()"/>
			</xsl:element>
			
			<xsl:element name="cals:table">
				<xsl:attribute name="orient" select="string('LAND')"/>
				<xsl:attribute name="frame" select="string('NONE')"/>
				
				<cals:tgroup cols="10" colsep="0" rowsep="0">
					<cals:colspec colnum="1" colname="col1" colwidth="1*"/>
					<cals:colspec colnum="2" colname="col2" colwidth="1*"/>
					<cals:colspec colnum="3" colname="col3" colwidth="1*"/>
					<cals:colspec colnum="4" colname="col4" colwidth="1*"/>
					<cals:colspec colnum="5" colname="col5" colwidth="1*"/>
					<cals:colspec colnum="6" colname="col6" colwidth="1*"/>
					<cals:colspec colnum="7" colname="col7" colwidth="1*"/>
					<cals:colspec colnum="8" colname="col8" colwidth="1*"/>
					<cals:colspec colnum="9" colname="col9" colwidth="1*"/>
					<cals:colspec colnum="10" colname="col10" colwidth="1*"/>
				</cals:tgroup>
				
				<xsl:apply-templates select="*:thead|*:tbody|*:tfoot"/>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="*:thead|*:tbody|*:tfoot">
		
		<xsl:element name="{concat('cals:', name())}">
			<xsl:apply-templates/>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="*:tr">
		
		<xsl:choose>
			
			<xsl:when test="count(.//*:th | *:td) = 0">
				<xsl:comment>empty row removed</xsl:comment>
			</xsl:when>
			
			<xsl:otherwise>
				
				<xsl:element name="cals:row">
					
					<xsl:for-each select="*:th | *:td">
						
						<xsl:element name="cals:entry">
							
							<xsl:choose>
								
								<xsl:when test="@colspan='1'">
									<xsl:attribute name="colname" select="concat('col', position())"/>
								</xsl:when>
								
								<xsl:when test="@colspan > 1">
									<xsl:attribute name="namest" select="concat('col', position())"/>
									<xsl:attribute name="nameend" select="concat('col', position() + @colspan -1)"/>
								</xsl:when>
								
								<xsl:otherwise>
									<xsl:attribute name="colname" select="concat('col', position())"/>
								</xsl:otherwise>
								
							</xsl:choose>
							
							<xsl:if test="@rowspan > 1">
								<xsl:attribute name="morerows" select="@rowspan -1"/>
							</xsl:if>
							
							<xsl:if test="@align[string-length(.)!=0]">
								<xsl:attribute name="align" select="translate(@align, $lower, $upper)"/>
							</xsl:if>
							
							<xsl:apply-templates/>
							
						</xsl:element>
						
					</xsl:for-each>
					
				</xsl:element>
				
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="em|strong|term|sub|sup|br|p|ul|li">
		<xsl:element name="{name()}">
			<!-- attribute -->
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<!-- manage to: internal-glossary|internal|option-key-messages|question|background -->
	
	<xsl:template match="option-link">
		
		<!--<xsl:variable name="iid" select="concat($cid, '_', substring-after(substring-after(substring-before(@target, '.xml'), '_op'), '_'))"/>-->
		<!-- chpping '../options/_op1003_I1.xml' or 
			'../options/option-1179218159900_en-gb.xml' to get option id -->
		<xsl:variable name="iid" select="concat($cid, '_I', replace(@target, '^.*?[I\-](\d+).*?$', '$1'))"/>
		<xsl:element name="link">
			<xsl:choose>
				<xsl:when test="@xpointer='benefits'">
					<xsl:attribute name="type">option-benefits</xsl:attribute>
					<!--<xsl:attribute name="target" select="concat(substring-before(substring-after(@target, '_'), '.xml'), '_BENEFITS')"/>-->
					<!--<xsl:attribute name="target" select="concat($iid, '_BENEFITS')"/>-->
				    <xsl:attribute name="target" select="$iid"/>
				</xsl:when>
				<xsl:when test="@xpointer='harms'">
					<xsl:attribute name="type">option-harms</xsl:attribute>
					<!--<xsl:attribute name="target" select="concat(substring-before(substring-after(@target, '_'), '.xml'), '_HARMS')"/>-->
					<!--<xsl:attribute name="target" select="concat($iid, '_HARMS')"/>-->
				    <xsl:attribute name="target" select="$iid"/>
				</xsl:when>
				<xsl:when test="@xpointer='comment'">
					<xsl:attribute name="type">option-comment</xsl:attribute>
					<!--<xsl:attribute name="target" select="concat(substring-before(substring-after(@target, '_'), '.xml'), '_COMMENT')"/>-->
					<!--<xsl:attribute name="target" select="concat($iid, '_COMMENT')"/>-->
				    <xsl:attribute name="target" select="$iid"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="type">option</xsl:attribute>
					<!--<xsl:attribute name="target" select="substring-before(substring-after(@target, '_'), '.xml')"/>-->
					<xsl:attribute name="target" select="$iid"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="gloss-link">
		<xsl:variable name="target" select="@target"/>
		<xsl:element name="link">
			<xsl:attribute name="type">glossary</xsl:attribute>
			<xsl:for-each select="$links//gloss-link">
				<xsl:if test="@target=$target">
					<xsl:attribute name="target" select="concat($cid, '_G', position())"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="figure-link">
		<xsl:variable name="target" select="@target"/>
		<xsl:element name="link">
			<xsl:attribute name="type">figure</xsl:attribute>
			<xsl:for-each select="$links//figure-link">
				<xsl:if test="@target=$target">
					<xsl:attribute name="target" select="concat($cid, '_F', position())"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="table-link">
		<xsl:variable name="target" select="@target"/>
		<xsl:element name="link">
			<xsl:attribute name="type">table</xsl:attribute>
			<xsl:for-each select="$links//table-link">
				<xsl:if test="@target=$target">
					<xsl:attribute name="target" select="concat($cid, '_T', position())"/>
				</xsl:if>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="reference-link">
		<xsl:variable name="target" select="@target"/>
		<xsl:element name="link">
			<xsl:attribute name="type">reference</xsl:attribute>
			<xsl:for-each select="$links//reference-link">
				<xsl:if test="@target=$target">
					<xsl:attribute name="target" select="concat($cid, '_REF', position())"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="systematic-review-link">
		<xsl:choose>
			<xsl:when test="matches(@target, '[0-9][0-9][0-9][0-9]')">
				<xsl:element name="link">
					<xsl:attribute name="type">condition</xsl:attribute>
					<xsl:attribute name="target">
						<xsl:analyze-string select="@target" regex="([0-9][0-9][0-9][0-9])">
							<xsl:matching-substring>
								<xsl:value-of select="regex-group(1)"/>
							</xsl:matching-substring>
						</xsl:analyze-string>
					</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="uri-link[ancestor::drug-safety-alert]">
		<xsl:element name="link">
			<xsl:attribute name="type">url</xsl:attribute>
			<xsl:attribute name="target">
				<xsl:choose>
					<xsl:when test="starts-with(@target, 'www')">
						<xsl:text>http://</xsl:text>
						<xsl:value-of select="@target"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@target"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	

	<xsl:template 
		match="
		node()
		[preceding-sibling::processing-instruction()[1]
		[name() = 'serna-redline-start' 
		and (. = '400 ' or . = '0 ' or . = '1000 ')]]
		[following-sibling::processing-instruction()[1]
		[name() = 'serna-redline-end']]
		">
		
		<xsl:choose>
			
			<xsl:when test="preceding-sibling::processing-instruction()[1][. = '1000 ']">
				
				<xsl:element name="redline-insert">
					<xsl:value-of select="."/>
				</xsl:element>
				
			</xsl:when>
			
			<xsl:when test="preceding-sibling::processing-instruction()[1][. = '400 ']">
				
				<xsl:element name="redline-delete">
					<xsl:value-of select="."/>
				</xsl:element>
				
			</xsl:when>
			
			<xsl:when test="preceding-sibling::processing-instruction()[1][. = '0 ' ]">
				
				<xsl:element name="redline-comment">
					<xsl:value-of select="."/>
				</xsl:element>
				
			</xsl:when>
			
		</xsl:choose>
		
	</xsl:template>
	
	
	<xsl:template match="pi-comment">
		
		<xsl:choose>
			
			<xsl:when test="@type='q-to-pr'">
				
				<xsl:element name="comment-q-to-pr">
					<xsl:apply-templates/>
				</xsl:element>
				
			</xsl:when>
			
			<xsl:when test="@type='q-to-a'">
				
				<xsl:element name="comment-q-to-a">
					<xsl:apply-templates/>
				</xsl:element>
				
			</xsl:when>
			
			<xsl:when test="@type='q-to-ed'">
				
				<xsl:element name="comment-q-to-ed">
					<xsl:apply-templates/>
				</xsl:element>
				
			</xsl:when>
			
			<xsl:when test="@type='q-to-teched'">
				
				<xsl:element name="comment-q-to-teched">
					<xsl:apply-templates/>
				</xsl:element>
				
			</xsl:when>
			
			<xsl:when test="@type='q-to-prod'">
				
				<xsl:element name="comment-q-to-prod">
					<xsl:apply-templates/>
				</xsl:element>
				
			</xsl:when>
			
			<xsl:otherwise>
				<!-- do nothing -->
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
</xsl:stylesheet>

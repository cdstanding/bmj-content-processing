<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	
	xmlns="http://schema.bmj.com/delivery/oak"
	
	xmlns:oak="http://schema.bmj.com/delivery/oak"
	xmlns:ce="http://schema.bmj.com/delivery/oak-ce"
	
	version="2.0">
	
	<xsl:template match="comparison-set" mode="comparisons-serial">
		<xsl:param name="name" select="name()" />
		
		<xsl:element name="section" inherit-namespaces="no">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="name()"/>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:apply-templates select="comparison" mode="comparisons-serial" />
			<xsl:apply-templates select="reference-notes" mode="comparisons-serial"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="comparison" mode="comparisons-serial">
		<xsl:param name="name" select="name()" />
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:apply-templates select="title" mode="comparisons-serial-comparison" />
			<xsl:apply-templates select="p" mode="comparisons-serial" />
			
			<xsl:apply-templates select="grade | adverse-effects" mode="comparisons-serial">
				<xsl:with-param name="comparison-title" select="title" />
			</xsl:apply-templates>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="title" mode="comparisons-serial-comparison">
		
		<xsl:element name="title">
			
			<xsl:for-each select="node()">
				
				<xsl:choose>
					
					<xsl:when test="name()='strong'">
						<!--<xsl:comment>strong</xsl:comment>-->
						<xsl:apply-templates select="node()" />
					</xsl:when>
					
					<xsl:otherwise>
						<!--<xsl:comment>non-strong</xsl:comment>-->
						<xsl:apply-templates select="." />
					</xsl:otherwise>
					
				</xsl:choose>
				
			</xsl:for-each>
			
			<xsl:text>: </xsl:text>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="grade" mode="comparisons-serial">
		<xsl:param name="comparison-title" />
		<xsl:param name="name" select="name()" />
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:element name="title">
				<xsl:apply-templates select="outcome/class/node()" />
				<xsl:if test="outcome/timeframe[string-length(normalize-space(.))!=0]">
					<xsl:text> (</xsl:text>
					<xsl:apply-templates select="outcome/timeframe/node()" />
					<xsl:text>)</xsl:text>
				</xsl:if>
			</xsl:element>
			
			<xsl:apply-templates select="evidence-appraisal/p" mode="comparisons-serial" />
			
			<xsl:apply-templates select="pico-set" mode="comparisons-serial">
				<xsl:with-param name="parent-outcome">
					<xsl:copy-of select="outcome" />
				</xsl:with-param>
				<xsl:with-param name="pico-set-count" select="count(pico-set)" />
			</xsl:apply-templates>
			<xsl:apply-templates select="reference-no-data" mode="comparisons-serial" />
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="adverse-effects" mode="comparisons-serial">
		<xsl:param name="name" select="name()" />
		
		<!--p[string-length(normalize-space(.))!=0]--> 
		<xsl:if test="pico-set or reference-no-data/reference-link">
		
			<xsl:element name="section">
				<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
				<xsl:attribute name="class" select="name()"/>
				
				<xsl:element name="title">
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="concat(name(), '-', 'type', '-', @type)"/>
					</xsl:call-template>
				</xsl:element>
				
				<!--<xsl:apply-templates select="p" mode="comparisons-serial" />-->
				
				<xsl:apply-templates select="pico-set" mode="comparisons-serial">
					<xsl:with-param name="parent-outcome">
						<xsl:element name="outcome">
							<xsl:element name="class">
								<xsl:call-template name="process-string-variant">
									<xsl:with-param name="name" select="concat(name(), '-', 'type', '-', @type)"/>
								</xsl:call-template>
							</xsl:element>
							<xsl:element name="timeframe" />
						</xsl:element>
					</xsl:with-param>
					<xsl:with-param name="pico-set-count" select="count(pico-set)" />
				</xsl:apply-templates>
				<xsl:apply-templates select="reference-no-data" mode="comparisons-serial" />
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="pico-set" mode="comparisons-serial">
		<xsl:param name="parent-outcome" />
		<xsl:param name="pico-set-count" />
		
		<xsl:variable name="name" select="name()" />
		
		<xsl:variable name="parent-pico-set-position">
			<xsl:variable name="generate-id" select="generate-id()" />
			<xsl:for-each select="parent::*/*[name()=$name]">
				<xsl:if test="generate-id()=$generate-id and position()=1">
					<xsl:text>first</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="$name"/>
			
			<!--<xsl:when 
				test="
				$parent-outcome/outcome[not(timeframe) or timeframe[string-length(normalize-space(.))=0]] 
				and translate(normalize-space(outcome), $upper, $lower) = translate(normalize-space($parent-outcome/outcome), $upper, $lower)
				and $pico-set-count = 1
				">
				<xsl:comment>parent outcome matched so single study group title ignored</xsl:comment>
				</xsl:when>-->
				
			<xsl:if test="outcome[string-length(normalize-space(.))!=0]">
				<xsl:element name="title">
					<xsl:apply-templates select="outcome/class/node()" />
				</xsl:element>
			</xsl:if>
			
			<xsl:apply-templates select="pico" mode="comparisons-serial">
				<xsl:with-param name="parent-pico-set-position" select="$parent-pico-set-position" />
			</xsl:apply-templates>
			
		</xsl:element>
			
	</xsl:template>
	
	<xsl:template match="pico" mode="comparisons-serial">
		<xsl:param name="name" select="name()" />
		<xsl:param name="parent-pico-set-position" />
		
		<xsl:variable name="pico-position">
			<xsl:variable name="generate-id" select="generate-id()" />
			<xsl:for-each select="parent::*/*[name()=$name]">
				<xsl:if test="generate-id()=$generate-id and position()=1">
					<xsl:text>first</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			
			<xsl:choose>
				<xsl:when test="$pico-position = 'first' and $parent-pico-set-position = 'first'">
					<xsl:attribute name="class" select="concat(name(), '-first')"/>		
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="name()"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:apply-templates select="reference-studies" mode="comparisons-serial" />
			<xsl:apply-templates select="population" mode="comparisons-serial">
				<xsl:with-param name="reference-studies" select="reference-studies" />
			</xsl:apply-templates>
			<xsl:apply-templates select="notes" mode="comparisons-serial">
				<xsl:with-param name="oen" select="name()" />
			</xsl:apply-templates>
			<xsl:apply-templates select="absolute-results" mode="comparisons-serial" />
			<xsl:apply-templates select="statistical-analysis" mode="comparisons-serial" />
			<xsl:apply-templates select="statistical-analysis/favour" mode="comparisons-serial" />
			
		</xsl:element>
		
	</xsl:template>
	
	<!-- reference-studies -->
	<xsl:template match="reference-studies" mode="comparisons-serial">
		<xsl:param name="name" select="name()" />
		
		<xsl:variable name="current-pico-references">
			<xsl:for-each select="(reference-original | reference-related)">
				<xsl:copy-of select="reference-link" />
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:element name="title">
				
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="string('ref')"/>
				</xsl:call-template>
				
				<xsl:text disable-output-escaping="yes"> (</xsl:text>
				
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="string('type')"/>
					<xsl:with-param name="case" select="string('lower')"/>
				</xsl:call-template>
				
				<xsl:text>)</xsl:text>
				
			</xsl:element>
			
			<xsl:apply-templates select="reference-original" mode="comparisons-serial" />
			
			<xsl:apply-templates select="comment" mode="comparisons-serial">
				<xsl:with-param name="oen" select="$name" />
			</xsl:apply-templates>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="reference-original" mode="comparisons-serial">	
		<xsl:param name="name" select="name()" />
		
		<xsl:choose>
			
			<xsl:when test="reference-link[contains(@target, 'MISSING_LINK') or string-length(@target)=0] or not(reference-link)">
				<xsl:comment>empty reference-link apparently</xsl:comment>	
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:element name="p">
					<xsl:apply-templates select="reference-link" />
				</xsl:element>			
			</xsl:otherwise>
			
		</xsl:choose>
			
		<xsl:if test="@type!='unset'">
			<xsl:element name="p">
				<xsl:attribute name="class" select="string('reference-original-type')" />
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="concat(name(), '-', 'type', '-', @type)"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:if>
		
		<!-- @design -->
		<xsl:if test="@design!='parallel-group' and @design!='unset'">
			
			<xsl:element name="p">
				<xsl:attribute name="class" select="string('reference-original-design')" />
				
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="concat('reference-original', '-', 'design', '-', @design)"/>
				</xsl:call-template>
				
			</xsl:element>
			
		</xsl:if>
		
		<!--@number-of-arms-->
		<xsl:if test="@number-of-arms &gt;= 3 or @number-of-arms != 'unset'">
			
			<xsl:element name="p">
				
				<xsl:choose>
					<!--<xsl:when test="@number-of-arms = '1'"><xsl:text>1-armed trial</xsl:text></xsl:when>-->
					<!--<xsl:when test="@number-of-arms = '2'"><xsl:text>2-armed trial (not displayed)</xsl:text></xsl:when>-->
					<xsl:when test="@number-of-arms = '3'"><xsl:text>3-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '4'"><xsl:text>4-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '5'"><xsl:text>5-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '6'"><xsl:text>6-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '7'"><xsl:text>7-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '8'"><xsl:text>8-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '9'"><xsl:text>9-armed trial</xsl:text></xsl:when>
					<!--<xsl:when test="@number-of-arms = 'unset'"><xsl:text>How many arms? (not displayed)</xsl:text></xsl:when>-->
				</xsl:choose>
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<!-- population -->
	<xsl:template match="population" mode="comparisons-serial">
		<xsl:param name="reference-studies" />
		<xsl:param name="name" select="name()" />
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="name()"/>
				</xsl:call-template>

			</xsl:element>
			
			<xsl:apply-templates select="p" mode="comparisons-serial" />
			
			<xsl:if test="$reference-studies//reference-related/reference-link and $reference-studies//reference-related/@type!='unset'">
				
				<xsl:element name="p">
					<xsl:attribute name="class" select="string('reference-related-type')" />
					
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="concat('reference-related', '-', 'type', '-', $reference-studies//reference-related/@type)"/>
					</xsl:call-template>
					
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					
					<xsl:apply-templates select="$reference-studies//reference-related/reference-link" />
					
				</xsl:element>
				
			</xsl:if>
			
			<xsl:if test="@trials-identified!='unset' and @trials-identified!='0'"> <!--and @trials-identified!='2'-->
				
				<xsl:element name="p">
					<xsl:attribute name="class" select="string('pupulation-trials-identified')" />
					
					<xsl:choose>
						
						<xsl:when test="@trials-identified='1'">
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="concat($name, '-', 'trials-identified', '-', @trials-identified)"/>
							</xsl:call-template>
						</xsl:when>
						
						<xsl:otherwise>
							<xsl:value-of select="@trials-identified" />
							<xsl:text disable-output-escaping="yes"> </xsl:text>
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="concat($name, '-', 'trials-identified')"/>
							</xsl:call-template>
						</xsl:otherwise>
						
					</xsl:choose>
					
				</xsl:element>
				
			</xsl:if>
			
			<xsl:if test="@analysis!='unset' and @analysis!='complete' ">
				
				<xsl:element name="p">
					<xsl:attribute name="class" select="string('pupulation-analysis')" />
					
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="concat($name, '-', 'analysis', '-', @analysis)"/>
					</xsl:call-template>
					
				</xsl:element>
				
			</xsl:if>
			
			<!-- moved to first column -->
			<!--<xsl:if test="$reference-studies//reference-original/@design!='parallel-group' and $reference-studies//reference-original/@design!='unset'">
				
				<xsl:element name="p">
					<xsl:attribute name="class" select="string('reference-original-design')" />
					
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="concat('reference-original', '-', 'design', '-', $reference-studies//reference-original/@design)"/>
					</xsl:call-template>
					
				</xsl:element>
				
			</xsl:if>-->
			
			<xsl:apply-templates select="comment" mode="comparisons-serial">
				<xsl:with-param name="oen" select="$name" />
			</xsl:apply-templates>
			
		</xsl:element>
		
	</xsl:template>
	
	<!-- absolute-results -->
	<xsl:template match="absolute-results" mode="comparisons-serial">
		<xsl:param name="name" select="name()" />
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="name()"/>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:element name="section">
				<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>-->
				<xsl:attribute name="class" select="string('comparators')"/>
			
				<xsl:element name="title">
					
					<xsl:apply-templates select="outcome/class/node()" />
					
					<xsl:if test="outcome/timeframe[string-length(normalize-space(.))!=0]">
						<xsl:text>, </xsl:text>
						<xsl:apply-templates select="outcome/timeframe/node()" />
					</xsl:if>
					
				</xsl:element>
				
				<xsl:apply-templates select="comparators" mode="comparisons-serial" />
				
				<xsl:if test="@reporting!='unset' and @reporting!='complete' ">
					
					<xsl:element name="p">
						<xsl:attribute name="class" select="string('absolute-results-reporting')" />
						
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="concat($name, '-', 'reporting', '-', @reporting)"/>
						</xsl:call-template>
						
					</xsl:element>
					
				</xsl:if>
				
			</xsl:element>

			<xsl:apply-templates select="comment" mode="comparisons-serial">
				<xsl:with-param name="oen" select="$name" />
			</xsl:apply-templates>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="comparators" mode="comparisons-serial">
		<xsl:param name="name" select="name()" />
		
		<!--<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:apply-templates select="intervention" mode="comparisons-serial" />
			
		</xsl:element>-->
		
		<xsl:apply-templates select="intervention" mode="comparisons-serial" />
		
	</xsl:template>
	
	<xsl:template match="intervention" mode="comparisons-serial">
		<xsl:param name="name" select="name()" />
		
			
			<xsl:element name="p">
				
				<xsl:apply-templates select="data/node()"/>
					<xsl:text disable-output-escaping="yes"> with </xsl:text>
				<xsl:apply-templates select="class/node()"/>
				
			</xsl:element>	
			
	
		
	</xsl:template>
			
	<!-- statistical-analysis -->
	<xsl:template match="statistical-analysis" mode="comparisons-serial">
		<xsl:param name="name" select="name()" />
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:element name="title">
				
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="name()" />
				</xsl:call-template>
				
			</xsl:element>
			
			<xsl:apply-templates select="sec" mode="comparisons-serial" />
			
			<xsl:apply-templates select="comment" mode="comparisons-serial">
				<xsl:with-param name="oen" select="$name" />
			</xsl:apply-templates>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="favour" mode="comparisons-serial">
		<xsl:param name="name" select="name()" />
		
		
		<!-- effect-size column -->
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="string('effect-size')"/>
			
			<xsl:element name="metadata">
				<xsl:element name="key">
					<xsl:attribute name="name" select="string('effect-size')" />
					<xsl:attribute name="value" select="@evaluated-effect" />
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="string('effect-size')"/>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:if test="@evaluated-effect!='not-reported' and @evaluated-effect!='unset'">
				
				<xsl:element name="p">
					
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="concat($name, '-', 'evaluated-effect', '-', @evaluated-effect)" />
					</xsl:call-template>
					
				</xsl:element>
				
			</xsl:if>
		
			<!--<xsl:choose>
				
				<xsl:when test="
					@evaluated-effect='small' 
					or @evaluated-effect='moderate'
					or @evaluated-effect='large'
					">
					
					<xsl:element name="title">
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="string('effect-size')"/>
						</xsl:call-template>
					</xsl:element>
					
					<xsl:element name="figure">
						<xsl:attribute name="image">
							<xsl:text>../images/</xsl:text>
							<xsl:text>icon-effect-</xsl:text>
							<xsl:value-of select="@evaluated-effect" />
							<xsl:text>_default.gif</xsl:text>
						</xsl:attribute>
					</xsl:element>
					
				</xsl:when>
				
				<xsl:when test="@evaluated-effect='not-calculated'">
					
					<xsl:element name="title">
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="string('effect-size')"/>
						</xsl:call-template>
					</xsl:element>
					
					<xsl:element name="figure">
						<xsl:attribute name="image">
							<xsl:text>../images/</xsl:text>
							<xsl:text>icon-effect-no-size</xsl:text>
							<xsl:text>_default.gif</xsl:text>
						</xsl:attribute> 
					</xsl:element>
					
				</xsl:when>
				
				<xsl:when test="@evaluated-effect='not-significant'">
					
					<xsl:element name="title">
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="string('effect-size')"/>
						</xsl:call-template>
					</xsl:element>
					
					<xsl:element name="figure">
						<xsl:attribute name="image">
							<xsl:text>../images/</xsl:text>
							<xsl:text>icon-effect-no-diff</xsl:text>
							<xsl:text>_default.gif</xsl:text>
						</xsl:attribute>
					</xsl:element>
					
				</xsl:when>
				
				<xsl:when test="@evaluated-effect='not-reported'" />
				
				<xsl:when test="@evaluated-effect='unset'" />
				
			</xsl:choose>-->
			
		</xsl:element>
		
		
		<!-- favour column -->
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="string('favours')"/>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:if test="@evaluated-effect='not-significant'">
				<xsl:element name="p">
					<xsl:attribute name="class" select="string('effect-size-not-significant')" />
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="concat($name, '-', 'evaluated-effect', '-', @evaluated-effect)"/>
						<xsl:with-param name="case" select="string('lower')"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:if>
			
			<xsl:if test="string-length(normalize-space(.))!=0 and @evaluated-effect!='not-significant' and @evaluated-effect!='not-reported'">
				<xsl:element name="p">
					<xsl:apply-templates />	
				</xsl:element>
			</xsl:if>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="sec" mode="comparisons-serial" priority="1">
		<xsl:param name="oen" />
		<xsl:param name="name" select="name()" />
		
		<xsl:choose>
			
			<xsl:when test="string-length(normalize-space(.))=0">
				<xsl:comment>string zero apparently</xsl:comment>	
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:element name="section">
					<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>-->
					<xsl:attribute name="class" select="name()"/>
					
					<xsl:apply-templates mode="comparisons-serial" />
					
				</xsl:element>				
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="p" mode="comparisons-serial" priority="1">
		
		<xsl:choose>
			
			<xsl:when test="string-length(normalize-space(.))=0">
				<xsl:comment>string zero apparently</xsl:comment>	
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:element name="p">
					<xsl:apply-templates />
				</xsl:element>				
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="title" mode="comparisons-serial" priority="1">
		<xsl:element name="title">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="*" mode="comparisons-serial-cell-text">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="comment" mode="comparisons-serial" priority="1">
		<xsl:param name="oen" />
		<xsl:param name="name" select="name()" />
		
		<xsl:if test="string-length(normalize-space(.))!=0">
			
			<xsl:element name="section">
				<xsl:choose>
					<xsl:when test="$oen!='evidence-appraisal'">
						<xsl:attribute name="class" select="concat(name(), '-other')" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="class" select="name()" />
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:element name="title">
					<xsl:choose>
						<xsl:when test="$oen!='evidence-appraisal'">
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="concat(name(), '-other')"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="name()"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				
				<xsl:apply-templates select="p|sec" mode="comparisons-serial">
					<xsl:with-param name="oen" select="$oen" />
				</xsl:apply-templates>
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="reference-notes" mode="comparisons-serial">
		<xsl:param name="name" select="name()" />
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="name()"/>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:choose>
				
				<xsl:when test="reference[reference-link or (p|sec)[string-length(normalize-space(.))!=0]]">
					<xsl:apply-templates select="reference" mode="comparisons-serial" />		
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:element name="p">
						<xsl:attribute name="class" select="string('reference-notes-none')" />
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="string('none')"/>
						</xsl:call-template>
						<xsl:text>. </xsl:text>
					</xsl:element>
				</xsl:otherwise>
				
			</xsl:choose>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="reference" mode="comparisons-serial">
		<xsl:param name="name" select="name()" />
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:apply-templates select="reference-link"/>
		
			<xsl:element name="section">
				<xsl:attribute name="class" select="string('notes')"/>
				
				<xsl:apply-templates select="p|sec" mode="comparisons-serial">
					<xsl:with-param name="oen" select="name()" />
				</xsl:apply-templates>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="reference-no-data" mode="comparisons-serial">
		<xsl:param name="name" select="name()" />
		
		<xsl:if test="reference-link">

			<xsl:element name="section">
				<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
				<xsl:attribute name="class" select="name()"/>
				
				<xsl:element name="p">
					
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="concat(name(), '-', 'description')"/>
					</xsl:call-template>
					
					<xsl:text disable-output-escaping="yes">.</xsl:text>
					
					<xsl:apply-templates select="reference-link" />
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
</xsl:stylesheet>

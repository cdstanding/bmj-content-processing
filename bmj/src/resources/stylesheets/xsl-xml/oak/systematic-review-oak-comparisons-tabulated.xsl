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
			
			<xsl:if test="pico-set">
				<xsl:call-template name="comparisons-tabulated-pico"/>
			</xsl:if>
			
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
				
				<xsl:if test="pico-set">
					<xsl:call-template name="comparisons-tabulated-pico"/>
				</xsl:if>
				
				<xsl:apply-templates select="reference-no-data" mode="comparisons-serial" />
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>

				
	<xsl:template name="comparisons-tabulated-pico">
		
		<xsl:element name="table">
			
			<xsl:element name="thead">
				
				<xsl:element name="tr">
					
					<xsl:element name="td">
						<xsl:text>Ref</xsl:text>
						<xsl:text disable-output-escaping="yes"> (type)</xsl:text>
					</xsl:element>
					
					<xsl:element name="td">
						<xsl:text>Population</xsl:text>
					</xsl:element>
					
					<xsl:element name="td">
						<xsl:text>Outcome, Interventions</xsl:text>
					</xsl:element>
					
					<xsl:element name="td">
						<xsl:text>Results and statistical analysis</xsl:text>
					</xsl:element>
					
					<xsl:element name="td">
						<xsl:text>Effect size</xsl:text>
					</xsl:element>
					
					<xsl:element name="td">
						<xsl:text>Favours</xsl:text>
					</xsl:element>
					
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="tbody">
				<xsl:apply-templates select="pico-set" mode="comparisons-tabulated" />
			</xsl:element>
			
		</xsl:element>
				
	</xsl:template>
	
	<xsl:template match="pico-set" mode="comparisons-tabulated">
		
		<xsl:element name="tr">
			<xsl:element name="td">
				<xsl:apply-templates select="outcome/class" mode="comparisons-tabulated" />
			</xsl:element>
		</xsl:element>
		
		<xsl:apply-templates select="pico" mode="comparisons-tabulated" />
		
	</xsl:template>
	
	<xsl:template match="pico-set/outcome/class" mode="comparisons-tabulated">
		
		<xsl:element name="bold">
			<xsl:apply-templates />
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="pico" mode="comparisons-tabulated">
		
		<xsl:element name="tr">
			<xsl:apply-templates select="reference-studies" mode="comparisons-tabulated" />
			<xsl:apply-templates select="population" mode="comparisons-tabulated">
				<xsl:with-param name="reference-studies" select="reference-studies"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="absolute-results" mode="comparisons-tabulated" />
			<xsl:apply-templates select="statistical-analysis" mode="comparisons-tabulated" />
			<xsl:apply-templates select="statistical-analysis/favour" mode="comparisons-tabulated" />
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="reference-studies" mode="comparisons-tabulated">
		
		<xsl:element name="td">
			
			<xsl:apply-templates select="reference-original" mode="comparisons-tabulated" />
			<xsl:apply-templates select="comment" mode="comparisons-tabulated" />
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="reference-original" mode="comparisons-tabulated">
		
		<xsl:apply-templates select="reference-link"/>
		
		<xsl:if test="@type!='unset'">
			
			<xsl:text disable-output-escaping="yes"> </xsl:text>
			<xsl:element name="br" />
			
			<xsl:choose>
				<xsl:when test="@type='rct'"><xsl:text>RCT</xsl:text></xsl:when>
				<xsl:when test="@type='pseudo-rct'"><xsl:text>Pseudo-randomised trial</xsl:text></xsl:when>
				<xsl:when test="@type='systematic-review'"><xsl:text>Systematic review</xsl:text></xsl:when>
				<xsl:when test="@type='non-systematic-review'"><xsl:text>Non-systematic review</xsl:text></xsl:when>
				<xsl:when test="@type='cohort'"><xsl:text>Cohort study</xsl:text></xsl:when>
				<xsl:when test="@type='case-control'"><xsl:text>Case control</xsl:text></xsl:when>
				<xsl:when test="@type='cross-section'"><xsl:text>Cross-sectional study</xsl:text></xsl:when>
			</xsl:choose>
			
		</xsl:if>
		
		<xsl:if test="@design='cross-over'">
			
			<xsl:text disable-output-escaping="yes"> </xsl:text>
			<xsl:element name="br" />
			
			<xsl:element name="bold">
				<xsl:text>Crossover design</xsl:text>
			</xsl:element>
			
		</xsl:if>
		
		<xsl:if test="@number-of-arms &gt;= 3">
			
			<xsl:text disable-output-escaping="yes"> </xsl:text>
			<xsl:element name="br" />
				
			<xsl:element name="bold">
			
				<xsl:choose>
					<xsl:when test="@number-of-arms = '1'"><xsl:text>1-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '2'"/>
					<xsl:when test="@number-of-arms = '3'"><xsl:text>3-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '4'"><xsl:text>4-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '5'"><xsl:text>5-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '6'"><xsl:text>6-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '7'"><xsl:text>7-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '8'"><xsl:text>8-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '9'"><xsl:text>9-armed trial</xsl:text></xsl:when>
				</xsl:choose>
			
			</xsl:element>
				
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="population" mode="comparisons-tabulated">
		<xsl:param name="reference-studies" />
		<xsl:param name="name" select="name()" />
		
		<xsl:element name="td">
			
			<xsl:apply-templates select="p/node()" />
			
			<xsl:if test="$reference-studies//reference-related/reference-link and $reference-studies//reference-related/@type!='unset'">
				
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:element name="br" />
				
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="concat('reference-related', '-', 'type', '-', $reference-studies//reference-related/@type)"/>
				</xsl:call-template>
				
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:apply-templates select="$reference-studies//reference-related/reference-link" />
					
			</xsl:if>
			
			<xsl:if test="@trials-identified!='unset' and @trials-identified!='0'"> <!--and @trials-identified!='2'-->
				
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:element name="br" />
					
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
					
			</xsl:if>
			
			<xsl:if test="@analysis!='unset' and @analysis!='complete'">
				
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:element name="br" />
				
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="concat($name, '-', 'analysis', '-', @analysis)"/>
				</xsl:call-template>
				
			</xsl:if>
			
			<xsl:apply-templates select="comment" mode="comparisons-tabulated" />
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="absolute-results" mode="comparisons-tabulated">
		
		<xsl:element name="td">
			
			<xsl:apply-templates select="outcome" mode="comparisons-tabulated">
				<xsl:with-param name="oen" select="string('comparators')" />
			</xsl:apply-templates>
			
			<xsl:apply-templates select="comparators" mode="comparisons-tabulated">
				<xsl:with-param name="absolute-results-reporting" select="@reporting" />
			</xsl:apply-templates>
			
			<xsl:if test="@reporting!='complete' and @reporting!='unset'">
				
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:element name="br" />
				
				<xsl:choose>
					<xsl:when test="@reporting = 'complete'"><xsl:text>Absolute results reported completely (not displayed)</xsl:text></xsl:when>
					<xsl:when test="@reporting = 'graphical'"><xsl:text>Absolute results reported graphically</xsl:text></xsl:when>
					<xsl:when test="@reporting = 'percentage-only'"><xsl:text>Absolute numbers not reported</xsl:text></xsl:when>
					<xsl:when test="@reporting = 'none'"><xsl:text>Absolute results not reported</xsl:text></xsl:when>
					<xsl:when test="@reporting = 'unset'"><xsl:text>How were results reported?</xsl:text></xsl:when>
				</xsl:choose>
				
			</xsl:if>
			
			<xsl:apply-templates select="comment" mode="comparisons-tabulated" />
				
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="comparators" mode="comparisons-tabulated">
		<xsl:param name="absolute-results-reporting" />
		
		<xsl:apply-templates select="intervention" mode="comparisons-tabulated">
			<xsl:with-param name="absolute-results-reporting" select="$absolute-results-reporting" />
		</xsl:apply-templates>
		
	</xsl:template>
	
	<xsl:template match="intervention" mode="comparisons-tabulated">
		<xsl:param name="absolute-results-reporting" />
		
		<xsl:text disable-output-escaping="yes"> </xsl:text>
		<xsl:element name="br" />
			
		<xsl:apply-templates select="data" mode="comparisons-tabulated-intervention"/>
		<xsl:text disable-output-escaping="yes"> with </xsl:text>
		<xsl:apply-templates select="class" mode="comparisons-tabulated-intervention" />
			
	</xsl:template>
	
	<xsl:template match="class | data" mode="comparisons-tabulated-intervention">
		<xsl:apply-templates select="node()"/>	
	</xsl:template>
	
	<xsl:template match="statistical-analysis" mode="comparisons-tabulated">
		
		<xsl:element name="td">
				
			<xsl:apply-templates select="sec" mode="comparisons-tabulated" />
			<xsl:apply-templates select="comment" mode="comparisons-tabulated" />
				
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="favour" mode="comparisons-tabulated">
		<xsl:variable name="name" select="name()" />
		
		<xsl:element name="td">
			
			<xsl:choose>
				
				<xsl:when test="
					@evaluated-effect='small' 
					or @evaluated-effect='moderate'
					or @evaluated-effect='large'
					">
					
					<!--<xsl:element name="fo:external-graphic">
						<xsl:attribute name="src">
							<xsl:value-of select="concat('url(', $images-input, 'icon-effect-', @evaluated-effect, '_default.gif', ')')"/>
						</xsl:attribute>
					</xsl:element>-->
					
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="concat($name, '-evaluated-effect-', @evaluated-effect)"/>
					</xsl:call-template>
					
				</xsl:when>
				
				<xsl:when test="@evaluated-effect='not-calculated'">
					
					<!--<xsl:element name="fo:external-graphic">
						<xsl:attribute name="src">
							<xsl:value-of select="concat('url(', $images-input, 'icon-effect-no-size_default.gif', ')')"/>
						</xsl:attribute>
					</xsl:element>-->
					
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="concat($name, '-evaluated-effect-', @evaluated-effect)"/>
					</xsl:call-template>
					
				</xsl:when>
				
				<xsl:when test="@evaluated-effect='not-significant'">
					
					<!--<xsl:element name="fo:external-graphic">
						<xsl:attribute name="src">
							<xsl:value-of select="concat('url(', $images-input, 'icon-effect-no-diff_default.gif', ')')"/>
						</xsl:attribute>
					</xsl:element>-->
					
					<!--<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="concat($name, '-evaluated-effect-', @evaluated-effect)"/>
					</xsl:call-template>-->
					
				</xsl:when>
				
				<!-- todo: if serna then yellow prompt -->
				<xsl:when test="@evaluated-effect='not-reported'">
					
					<!-- do nothing ?? -->
					
				</xsl:when>
				
				<!-- todo: if serna then yellow prompt -->
				<xsl:when test="@evaluated-effect='unset'">
					
					<!-- do nothing ?? -->
					
				</xsl:when>
				
			</xsl:choose>
			
		</xsl:element>
		
		<xsl:element name="td">
			
			<xsl:choose>
				
				<xsl:when test="@evaluated-effect='not-significant'">
					<xsl:text>Not significant</xsl:text>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:apply-templates />
				</xsl:otherwise>
				
			</xsl:choose>
			
		</xsl:element>
		
	</xsl:template>

	<xsl:template match="comment" mode="comparisons-tabulated">
		
		<xsl:for-each select="p">
			<xsl:text disable-output-escaping="yes"> </xsl:text>
			<xsl:element name="br"/>
			<xsl:apply-templates />
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template match="sec" mode="comparisons-tabulated">
		<xsl:apply-templates mode="comparisons-tabulated" />
	</xsl:template>
	
	<xsl:template match="p" mode="comparisons-tabulated">
		<xsl:variable name="position">
			<xsl:variable name="generate-id" select="generate-id()" />
			<xsl:for-each select="parent::*/node()">
				<xsl:if test="generate-id()=$generate-id">
					<xsl:value-of select="position()"/>
				</xsl:if>
			</xsl:for-each>	
		</xsl:variable>
		
		<xsl:if test="string-length(normalize-space(.))!=0">
			
			<xsl:if test="$position!=1">
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:element name="br"/>				
			</xsl:if>
			
			<xsl:apply-templates />
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="p" mode="comparisons-serial">
		
		<xsl:if test="string-length(normalize-space(.))!=0">
			<xsl:element name="p">
				<xsl:apply-templates />
			</xsl:element>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="title" mode="comparisons-serial">
		<xsl:element name="title">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="title" mode="comparisons-tabulated">
		<xsl:element name="bold">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="outcome" mode="comparisons-tabulated">
		<xsl:param name="oen"/>
		<xsl:choose>
			<xsl:when test="$oen='comparators'">
				<xsl:element name="bold">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="title">
					<xsl:apply-templates />
				</xsl:element>				
			</xsl:otherwise>
		</xsl:choose>
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

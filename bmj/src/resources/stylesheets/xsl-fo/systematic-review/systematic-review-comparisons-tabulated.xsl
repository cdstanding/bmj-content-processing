<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:se="http://syntext.com/XSL/Format-1.0"
	xmlns:sf="http://www.syntext.com/Extensions/Functions"
	xmlns:xse="http://www.syntext.com/Extensions/XSLT-1.0"
	xmlns:bmj="http://bmjpg.com/BMJKXML/Extensions"
	version="1.1">
	
	<xsl:template match="comparison-set" mode="comparisons-tabulated">
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:element name="fo:block" use-attribute-sets="background-blue strong color-white keep-with-next"><!--option-title-->
				
				<xsl:element name="fo:block" use-attribute-sets="default-margin">
					<xsl:text>Benefits and harms</xsl:text>
				</xsl:element>
				
			</xsl:element>
			
			<xsl:apply-templates select="comparison" mode="comparisons-tabulated" />
			
			<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
			
			<xsl:apply-templates select="reference-notes" mode="comparisons-serial"/>
			
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="comparison" mode="comparisons-tabulated">
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:apply-templates select="title" mode="comparisons-serial-comparison" />
			<xsl:apply-templates select="p" mode="comparisons-serial" />
			
			<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
			
			<xsl:apply-templates select="grade" mode="comparisons-tabulated">
				<xsl:with-param name="comparison-title" select="title" />
			</xsl:apply-templates>
			
			<xsl:apply-templates select="adverse-effects" mode="comparisons-tabulated">
				<xsl:with-param name="comparison-title" select="title" />
			</xsl:apply-templates>
			
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="grade" mode="comparisons-tabulated">
		<xsl:param name="comparison-title" />
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:apply-templates select="outcome" mode="comparisons-serial-outcome-banner">
				<xsl:with-param name="oen" select="name()" /> 
			</xsl:apply-templates>
			
			<xsl:choose>
				<xsl:when test="evidence-appraisal/p[string-length(normalize-space(.))!=0]">
					<xsl:apply-templates select="evidence-appraisal/p" mode="comparisons-serial" />		
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:if test="pico-set">
				<xsl:call-template name="comparisons-tabulated-pico"/>
			</xsl:if>
			
			<xsl:apply-templates select="reference-no-data" mode="comparisons-tabulated" />
			
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="adverse-effects" mode="comparisons-tabulated">
		
		<xsl:if test="pico-set or reference-no-data/reference-link">
			
			<xsl:element name="fo:block" use-attribute-sets="">
				
				<xsl:element name="fo:block" use-attribute-sets="p strong keep-with-next">
					<xsl:attribute name="border-bottom-color">#000000</xsl:attribute>
					<xsl:attribute name="border-bottom-style">solid</xsl:attribute>
					<xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
					
					<xsl:choose>
						<xsl:when test="@type = 'standard'"><xsl:text>Adverse effects</xsl:text></xsl:when>
						<xsl:when test="@type = 'other'"><xsl:text>Other adverse effects</xsl:text></xsl:when>
						<xsl:when test="@type = 'unset'"><xsl:text>Adverse effects type?</xsl:text></xsl:when>
					</xsl:choose>
					
				</xsl:element>
				
				<xsl:choose>
					<xsl:when test="p[string-length(normalize-space(.))!=0]">
						<xsl:apply-templates select="p" mode="comparisons-serial" />		
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:if test="pico-set">
					<xsl:call-template name="comparisons-tabulated-pico"/>
				</xsl:if>
				
				<xsl:apply-templates select="reference-no-data" mode="comparisons-tabulated" />
				
			</xsl:element>
		
			<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="comparisons-tabulated-pico">
		
		<xsl:element name="fo:block" use-attribute-sets="">
		
			<xsl:element name="fo:table" use-attribute-sets="">
				
				<xsl:element name="fo:table-column" use-attribute-sets="">
					<xsl:attribute name="column-width">10%</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:table-column" use-attribute-sets="">
					<xsl:attribute name="column-width">15%</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:table-column" use-attribute-sets="">
					<xsl:attribute name="column-width">25%</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:table-column" use-attribute-sets="">
					<xsl:attribute name="column-width">25%</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:table-column" use-attribute-sets="">
					<xsl:attribute name="column-width">10%</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:table-column" use-attribute-sets="">
					<xsl:attribute name="column-width">15%</xsl:attribute>
				</xsl:element>
				
				<xsl:element name="fo:table-header" use-attribute-sets="keep-with-next">
					<xsl:element name="fo:table-row" use-attribute-sets="keep-with-next">
						
						<xsl:element name="fo:table-cell" use-attribute-sets="comparisons-table-head-cell keep-with-next">
							<xsl:element name="fo:block" use-attribute-sets="keep-with-next">
								<xsl:text>Ref</xsl:text>
								<xsl:text disable-output-escaping="yes"> (type)</xsl:text>
							</xsl:element>
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="comparisons-table-head-cell keep-with-next">
							<xsl:element name="fo:block" use-attribute-sets="keep-with-next">
								<xsl:text>Population</xsl:text>
							</xsl:element>
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="comparisons-table-head-cell keep-with-next">
							<xsl:element name="fo:block" use-attribute-sets="keep-with-next">
								<xsl:text>Outcome, Interventions</xsl:text>
							</xsl:element>
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="comparisons-table-head-cell keep-with-next">
							<xsl:element name="fo:block" use-attribute-sets="keep-with-next">
								<xsl:text>Results and statistical analysis</xsl:text>
							</xsl:element>
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="comparisons-table-head-cell keep-with-next">
							<xsl:element name="fo:block" use-attribute-sets="keep-with-next">
								<xsl:text>Effect size</xsl:text>
							</xsl:element>
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="comparisons-table-head-cell keep-with-next">
							<xsl:element name="fo:block" use-attribute-sets="keep-with-next">
								<xsl:text>Favours</xsl:text>
							</xsl:element>
						</xsl:element>
						
					</xsl:element>
				</xsl:element>
				
				<xsl:element name="fo:table-body">
					<xsl:apply-templates select="pico-set" mode="comparisons-tabulated" />
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
		<!--<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>-->
		
	</xsl:template>
	
	<xsl:template match="pico-set" mode="comparisons-tabulated">
		
		<xsl:element name="fo:table-row" use-attribute-sets="keep-with-next">
			<xsl:element name="fo:table-cell" use-attribute-sets="comparisons-table-title-cell keep-with-next">
				
				<xsl:element name="fo:block" use-attribute-sets="">				
					<xsl:apply-templates select="outcome/class" mode="comparisons-tabulated" />
				</xsl:element>
				
			</xsl:element>
		</xsl:element>
		
		<xsl:apply-templates select="pico" mode="comparisons-tabulated" />
		
	</xsl:template>
	
	<xsl:template match="pico-set/outcome/class" mode="comparisons-tabulated">
		
		<xsl:element name="fo:block" use-attribute-sets="strong keep-with-next">
			<xsl:apply-templates />
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="pico" mode="comparisons-tabulated">
		
		<xsl:element name="fo:table-row">
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
		
		<xsl:element name="fo:table-cell" use-attribute-sets="comparisons-table-body-cell">
			
			<xsl:apply-templates select="reference-original" mode="comparisons-tabulated" />
			<xsl:apply-templates select="comment" mode="comparisons-tabulated" />
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="reference-original" mode="comparisons-tabulated">
		
		<xsl:element name="fo:block" use-attribute-sets="p">
			<xsl:apply-templates select="reference-link">
			</xsl:apply-templates>
		</xsl:element>
		
		<xsl:if test="@type!='unset'">
			
			<xsl:element name="fo:block" use-attribute-sets="p">
				<xsl:choose>
					<xsl:when test="@type='rct'"><xsl:text>RCT</xsl:text></xsl:when>
					<xsl:when test="@type='pseudo-rct'"><xsl:text>Pseudo-randomised trial</xsl:text></xsl:when>
					<xsl:when test="@type='systematic-review'"><xsl:text>Systematic review</xsl:text></xsl:when>
					<xsl:when test="@type='non-systematic-review'"><xsl:text>Non-systematic review</xsl:text></xsl:when>
					<xsl:when test="@type='cohort'"><xsl:text>Cohort study</xsl:text></xsl:when>
					<xsl:when test="@type='case-control'"><xsl:text>Case control</xsl:text></xsl:when>
					<xsl:when test="@type='cross-section'"><xsl:text>Cross-sectional study</xsl:text></xsl:when>
					<xsl:when test="@type='unset'"><xsl:text>What type of study?</xsl:text></xsl:when>
				</xsl:choose>
			</xsl:element>
			
		</xsl:if>
		
		<xsl:if test="@design='cross-over'">
			
			<xsl:element name="fo:block" use-attribute-sets="p strong">
				<xsl:text>Crossover design</xsl:text>
			</xsl:element>
			
		</xsl:if>
		
		<xsl:if test="@number-of-arms &gt;= 3">
			
			<xsl:element name="fo:block" use-attribute-sets="p strong">
				
				<xsl:choose>
					<xsl:when test="@number-of-arms = '1'"><xsl:text>1-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '2'"><xsl:text>2-armed trial (not displayed)</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '3'"><xsl:text>3-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '4'"><xsl:text>4-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '5'"><xsl:text>5-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '6'"><xsl:text>6-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '7'"><xsl:text>7-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '8'"><xsl:text>8-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = '9'"><xsl:text>9-armed trial</xsl:text></xsl:when>
					<xsl:when test="@number-of-arms = 'unset'"><xsl:text>How many arms? (not displayed)</xsl:text></xsl:when>
				</xsl:choose>
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="population" mode="comparisons-tabulated">
		<xsl:param name="reference-studies" />
		<xsl:param name="name" select="name()" />
		
		<xsl:element name="fo:table-cell" use-attribute-sets="comparisons-table-body-cell">
			
			<xsl:element name="fo:block" use-attribute-sets="p">
				<xsl:apply-templates select="p/node()" />
			</xsl:element>
			
			<xsl:if test="$reference-studies//reference-related/reference-link and $reference-studies//reference-related/@type!='unset'">
				
				<xsl:element name="fo:block" use-attribute-sets="p">

					<xsl:choose>
						<xsl:when test="$reference-studies//reference-related/@type = 'trial-in-review'"><xsl:text>In review</xsl:text></xsl:when>
						<xsl:when test="$reference-studies//reference-related/@type = 'further-report'"><xsl:text>Further report of reference</xsl:text></xsl:when>
					</xsl:choose>
					
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					
					<xsl:apply-templates select="$reference-studies//reference-related/reference-link" />
					
				</xsl:element>
				
			</xsl:if>
			
			<xsl:if test="@trials-identified!='unset' and @trials-identified!='0'"> <!--and @trials-identified!='2'-->
				
				<xsl:element name="fo:block" use-attribute-sets="p">
					
					<xsl:choose>
						
						<xsl:when test="@trials-identified='1'">
							<xsl:text>Data from 1 RCT</xsl:text>
						</xsl:when>
						
						<xsl:otherwise>
							<xsl:value-of select="@trials-identified" />
							<xsl:text disable-output-escaping="yes"> RCTs in this analysis</xsl:text>
						</xsl:otherwise>
						
					</xsl:choose>
					
				</xsl:element>
				
			</xsl:if>
			
			<xsl:if test="@analysis!='unset' and @analysis!='complete' ">
				
				<xsl:element name="fo:block" use-attribute-sets="p">
					<xsl:choose>
						<xsl:when test="@analysis = 'subgroup'"><xsl:text>Subgroup analysis</xsl:text></xsl:when>
						<xsl:when test="@analysis = 'sensitivity'"><xsl:text>Sensitivity analysis</xsl:text></xsl:when>
					</xsl:choose>
				</xsl:element>
				
			</xsl:if>
			
			<xsl:apply-templates select="comment" mode="comparisons-tabulated" />
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="absolute-results" mode="comparisons-tabulated">
		
		<xsl:element name="fo:table-cell" use-attribute-sets="comparisons-table-body-cell">
			
			<xsl:element name="fo:block" use-attribute-sets="">
				
				<xsl:apply-templates select="outcome" mode="comparisons-tabulated">
					<xsl:with-param name="oen" select="string('comparators')" />
				</xsl:apply-templates>
				
				<xsl:apply-templates select="comparators" mode="comparisons-tabulated">
					<xsl:with-param name="absolute-results-reporting" select="@reporting" />
				</xsl:apply-templates>
				
				<xsl:if test="@reporting!='complete' and @reporting!='unset'">
					
					<xsl:element name="fo:block" use-attribute-sets="p">
						<xsl:choose>
							<xsl:when test="@reporting = 'complete'"><xsl:text>Absolute results reported completely (not displayed)</xsl:text></xsl:when>
							<xsl:when test="@reporting = 'graphical'"><xsl:text>Absolute results reported graphically</xsl:text></xsl:when>
							<xsl:when test="@reporting = 'percentage-only'"><xsl:text>Absolute numbers not reported</xsl:text></xsl:when>
							<xsl:when test="@reporting = 'none'"><xsl:text>Absolute results not reported</xsl:text></xsl:when>
							<xsl:when test="@reporting = 'unset'"><xsl:text>How were results reported?</xsl:text></xsl:when>
						</xsl:choose>
					</xsl:element>
					
				</xsl:if>
				
				<xsl:apply-templates select="comment" mode="comparisons-tabulated" />
				
			</xsl:element>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="comparators" mode="comparisons-tabulated">
		<xsl:param name="absolute-results-reporting" />
		
		<xsl:element name="fo:block" use-attribute-sets="">
			<xsl:apply-templates select="intervention" mode="comparisons-tabulated">
				<xsl:with-param name="absolute-results-reporting" select="$absolute-results-reporting" />
			</xsl:apply-templates>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="intervention" mode="comparisons-tabulated">
		<xsl:param name="absolute-results-reporting" />
		
		<xsl:element name="fo:block" use-attribute-sets="p">
			
			<xsl:apply-templates select="data" mode="comparisons-tabulated-intervention"/>
			
			<xsl:text disable-output-escaping="yes"> with </xsl:text>
			
			<xsl:apply-templates select="class" mode="comparisons-tabulated-intervention" />
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="class | data" mode="comparisons-tabulated-intervention">
		<xsl:element name="fo:inline" use-attribute-sets="">
			<xsl:apply-templates select="node()"/>	
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="statistical-analysis" mode="comparisons-tabulated">
		
		<xsl:element name="fo:table-cell" use-attribute-sets="comparisons-table-body-cell">
			<xsl:element name="fo:block" use-attribute-sets="">
				
				<xsl:apply-templates select="sec" mode="comparisons-tabulated" />
				<xsl:apply-templates select="comment" mode="comparisons-tabulated" />
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="favour" mode="comparisons-tabulated">
		
		<xsl:element name="fo:table-cell" use-attribute-sets="comparisons-table-body-cell">
			<xsl:attribute name="display-align">center</xsl:attribute>
			
			<xsl:element name="fo:block" use-attribute-sets="p">
				<xsl:attribute name="text-align">center</xsl:attribute>
				
				
				<xsl:choose>
					
					<xsl:when test="
						@evaluated-effect='small' 
						or @evaluated-effect='moderate'
						or @evaluated-effect='large'
						">
						
						<xsl:element name="fo:external-graphic">
							<xsl:attribute name="src">
								<xsl:value-of select="concat('url(', $images-input, 'icon-effect-', @evaluated-effect, '_default.gif', ')')"/>
							</xsl:attribute>
						</xsl:element>
						
					</xsl:when>
					
					<xsl:when test="@evaluated-effect='not-calculated'">
						
						<xsl:element name="fo:external-graphic">
							<xsl:attribute name="src">
								<xsl:value-of select="concat('url(', $images-input, 'icon-effect-no-size_default.gif', ')')"/>
							</xsl:attribute>
						</xsl:element>
						
					</xsl:when>
					
					<xsl:when test="@evaluated-effect='not-significant'">
						
						<xsl:element name="fo:external-graphic">
							<xsl:attribute name="src">
								<xsl:value-of select="concat('url(', $images-input, 'icon-effect-no-diff_default.gif', ')')"/>
							</xsl:attribute>
						</xsl:element>
						
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
			
		</xsl:element>
		
		<xsl:element name="fo:table-cell" use-attribute-sets="comparisons-table-body-cell">
			<xsl:attribute name="display-align">center</xsl:attribute>
			
			<xsl:element name="fo:block" use-attribute-sets="p">
			
				<xsl:choose>
					
					<xsl:when test="@evaluated-effect='not-significant'">
					
						<xsl:element name="fo:inline" use-attribute-sets="">
							<xsl:text>Not significant</xsl:text>
						</xsl:element>
						
					</xsl:when>
					
					<xsl:otherwise>
						
						<xsl:element name="fo:inline" use-attribute-sets="">
							<xsl:apply-templates />
						</xsl:element>
						
					</xsl:otherwise>
					
				</xsl:choose>
			
				<xsl:if test="string-length(normalize-space(.))!=0 and (@evaluated-effect='not-significant' or @evaluated-effect='not-reported')">
					
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					
					<xsl:element name="fo:inline" use-attribute-sets="generated-autotext sup">
						<xsl:text>favour should be blank</xsl:text>
					</xsl:element>
					
				</xsl:if>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="outcome" priority="1" mode="comparisons-tabulated">
		<xsl:param name="oen" />
		
		<xsl:element name="fo:block" use-attribute-sets="p strong">
			
			<xsl:apply-templates select="class" mode="comparisons-tabulated"/>
			
			<xsl:if test="$oen != 'pico-set'">
				<xsl:apply-templates select="timeframe" mode="comparisons-tabulated"/>
			</xsl:if>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="class" priority="1" mode="comparisons-tabulated">
		
		<xsl:element name="fo:inline" use-attribute-sets="">
			<xsl:apply-templates />
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="timeframe[string-length(normalize-space(.))!=0]" mode="comparisons-tabulated">

		<xsl:element name="fo:inline" use-attribute-sets="">
			<xsl:text>, </xsl:text>
			<xsl:apply-templates />
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="sec" mode="comparisons-tabulated">
		
		<xsl:apply-templates mode="comparisons-tabulated" />
		
	</xsl:template>
	
	<xsl:template match="comment" mode="comparisons-tabulated">
		
		<xsl:apply-templates mode="comparisons-tabulated" />
		
	</xsl:template>
	
	<xsl:template match="p" mode="comparisons-tabulated">
		
		<xsl:element name="fo:block" use-attribute-sets="p">
			<xsl:apply-templates />
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="reference-no-data[reference-link]" mode="comparisons-tabulated">
		
		<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="p">
			<xsl:text>No data from the following reference on this outcome.</xsl:text>
			<xsl:apply-templates select="reference-link" />
		</xsl:element>
		
	</xsl:template>
	
</xsl:stylesheet>

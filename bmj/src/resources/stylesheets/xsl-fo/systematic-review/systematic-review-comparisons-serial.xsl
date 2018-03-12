<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:se="http://syntext.com/XSL/Format-1.0"
	xmlns:sf="http://www.syntext.com/Extensions/Functions"
	xmlns:xse="http://www.syntext.com/Extensions/XSLT-1.0"
	xmlns:bmj="http://bmjpg.com/BMJKXML/Extensions"
	version="1.1">
	
	<xsl:template match="comparison-set" mode="comparisons-serial">
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:apply-templates select="comparison" mode="comparisons-serial" />
			<xsl:apply-templates select="reference-notes" mode="comparisons-serial"/>
			
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="comparison" mode="comparisons-serial">
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:apply-templates select="title" mode="comparisons-serial-comparison" />
			<xsl:apply-templates select="p" mode="comparisons-serial" />
		
			<xsl:apply-templates select="grade" mode="comparisons-serial">
				<xsl:with-param name="comparison-title" select="title" />
			</xsl:apply-templates>
			
			<xsl:apply-templates select="adverse-effects" mode="comparisons-serial">
				<xsl:with-param name="comparison-title" select="title" />
			</xsl:apply-templates>
			
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="title" mode="comparisons-serial-comparison">
		
		<xsl:element name="fo:block" use-attribute-sets="strong color-blue keep-with-next default-padding">
			<xsl:apply-templates />
			<xsl:text>: </xsl:text>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="grade" mode="comparisons-serial">
		<xsl:param name="comparison-title" />
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:apply-templates select="outcome" mode="comparisons-serial-outcome-banner" >
				<xsl:with-param name="oen" select="name()" />
				<xsl:with-param name="pico-set">
					<xsl:if test="pico-set">
						<xsl:text>true</xsl:text>
					</xsl:if>
				</xsl:with-param>
			</xsl:apply-templates>
			
			<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
			
			<xsl:apply-templates select="evidence-appraisal" mode="comparisons-serial">
				<xsl:with-param name="comparison-title" select="$comparison-title" />
				<xsl:with-param name="grade-outcome" select="outcome/class" />
			</xsl:apply-templates>
			
			<xsl:apply-templates select="pico-set" mode="comparisons-serial">
				<xsl:with-param name="pico-set-parent-outcome" select="outcome" />
			</xsl:apply-templates>
			<xsl:apply-templates select="reference-no-data" mode="comparisons-serial" />
			
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="adverse-effects" mode="comparisons-serial">
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:element name="fo:block" use-attribute-sets="p strong keep-with-next">
				<xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
				<xsl:attribute name="border-bottom-color">black</xsl:attribute>
				
				<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">
					<xsl:choose>
						<xsl:when test="@type = 'standard'"><xsl:text>Adverse effects</xsl:text></xsl:when>
						<xsl:when test="@type = 'other'"><xsl:text>Other adverse effects</xsl:text></xsl:when>
						<xsl:when test="@type = 'unset'"><xsl:text>Adverse effects type?</xsl:text></xsl:when>
					</xsl:choose>
				</xsl:element>
				
				<xsl:apply-templates select="@type" mode="comparisons-serial">
					<xsl:with-param name="oen" select="name()" />
				</xsl:apply-templates>
				
				<xsl:if test="not(pico-set)">
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:element name="fo:inline" use-attribute-sets="generated-autotext sup">create new group of studies (not displayed if blank)</xsl:element>
				</xsl:if>
				
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:element name="fo:inline" use-attribute-sets="generated-autotext sup">does not contribute to grade table</xsl:element>
				
			</xsl:element>
			
			<xsl:apply-templates select="p" mode="comparisons-serial" />
			
			<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
			
			<xsl:apply-templates select="pico-set" mode="comparisons-serial">
				<xsl:with-param name="pico-set-parent-outcome">
					<xsl:element name="outcome">
						<xsl:element name="class">
							<xsl:choose>
								<xsl:when test="@type = 'standard'"><xsl:text>Adverse effects</xsl:text></xsl:when>
								<xsl:when test="@type = 'other'"><xsl:text>Other adverse effects</xsl:text></xsl:when>
								<xsl:when test="@type = 'unset'"><xsl:text>Adverse effects type?</xsl:text></xsl:when>
							</xsl:choose>
						</xsl:element>
						<xsl:element name="timeframe" />
					</xsl:element>
				</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="reference-no-data" mode="comparisons-serial" />
			
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="evidence-appraisal" mode="comparisons-serial">
		<xsl:param name="comparison-title" />
		<xsl:param name="grade-outcome" />
		
		<xsl:variable name="name" select="name()" />
		
		<xsl:element name="fo:block" use-attribute-sets="gray-box">
			
			<xsl:element name="fo:block" use-attribute-sets="p strong keep-with-next">
				<xsl:text>Evidence appraisal</xsl:text>
				<xsl:text> (GRADE)</xsl:text>
			</xsl:element>
			
			<xsl:apply-templates select="reference-studies" mode="comparisons-serial-grade-row" />
			
			<xsl:element name="fo:table" use-attribute-sets="">
				
				<xsl:element name="fo:table-header" use-attribute-sets="">
					<xsl:element name="fo:table-row" use-attribute-sets="">

						<xsl:element name="fo:table-cell" use-attribute-sets="strong">
							<xsl:attribute name="text-align">center</xsl:attribute>
							<xsl:attribute name="display-align">after</xsl:attribute>
							<xsl:element name="fo:block" use-attribute-sets="p">Type of evidence</xsl:element>
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="strong">
							<xsl:attribute name="text-align">center</xsl:attribute>
							<xsl:attribute name="display-align">after</xsl:attribute>
							<xsl:element name="fo:block" use-attribute-sets="p">Quality</xsl:element>
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="strong">
							<xsl:attribute name="text-align">center</xsl:attribute>
							<xsl:attribute name="display-align">after</xsl:attribute>
							<xsl:element name="fo:block" use-attribute-sets="p">Consistency</xsl:element>
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="strong">
							<xsl:attribute name="text-align">center</xsl:attribute>
							<xsl:attribute name="display-align">after</xsl:attribute>
							<xsl:element name="fo:block" use-attribute-sets="p">Directness</xsl:element>
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="strong">
							<xsl:attribute name="text-align">center</xsl:attribute>
							<xsl:attribute name="display-align">after</xsl:attribute>
							<xsl:element name="fo:block" use-attribute-sets="p">Effect size</xsl:element>
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="strong">
							<xsl:attribute name="text-align">center</xsl:attribute>
							<xsl:attribute name="display-align">after</xsl:attribute>
							<xsl:element name="fo:block" use-attribute-sets="p">GRADE</xsl:element>
						</xsl:element>
						
					</xsl:element>
				</xsl:element>
				
				<xsl:element name="fo:table-body">
					
					<xsl:element name="fo:table-row" use-attribute-sets="">
						
						<xsl:element name="fo:table-cell" use-attribute-sets="">
							<xsl:apply-templates select="@best-evidence" mode="comparisons-serial" />
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="">
							<xsl:apply-templates select="@methodlogical-quality" mode="comparisons-serial" />
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="">
							<xsl:apply-templates select="@consistency" mode="comparisons-serial" />
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="">
							<xsl:apply-templates select="@directness" mode="comparisons-serial" />
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="">
							<xsl:apply-templates select="@effect-size" mode="comparisons-serial" />
						</xsl:element>
						
						<xsl:element name="fo:table-cell" use-attribute-sets="">
							<xsl:apply-templates select="@evidence-quality" mode="comparisons-serial" />
						</xsl:element>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
			<xsl:apply-templates select="p" mode="comparisons-serial" />
			
			<xsl:apply-templates select="comment" mode="comparisons-serial">
				<xsl:with-param name="oen" select="$name" />
			</xsl:apply-templates>
 			<xsl:apply-templates select="notes" mode="comparisons-serial">
 				<xsl:with-param name="oen" select="$name" />
 			</xsl:apply-templates>
			
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="reference-studies" mode="comparisons-serial-grade-row">
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:element name="fo:block" use-attribute-sets="p strong keep-with-next">
				
				<xsl:element name="fo:inline">References</xsl:element>
				
				<xsl:apply-templates select="@study-count" mode="comparisons-serial" />
				<xsl:apply-templates select="@participants" mode="comparisons-serial" />
				
				<xsl:element name="fo:inline">
					<xsl:text disable-output-escaping="yes"> </xsl:text>
				</xsl:element>
				
				<xsl:element name="fo:inline" use-attribute-sets="">
					<xsl:attribute name="font-weight" select="string('normal')" />
					<xsl:apply-templates select="reference-link"/>
				</xsl:element>
				
				<xsl:if test="not(reference-link)">
					
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					
					<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">
						<xsl:text>insert reference-link</xsl:text>
					</xsl:element>
					
				</xsl:if>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="pico-set" mode="comparisons-serial">
		
		<xsl:element name="fo:list-block">
			
			<xsl:element name="fo:list-item" use-attribute-sets="">
				
				<xsl:element name="fo:list-item-label" use-attribute-sets="">
					<xsl:attribute name="end-indent">15pt</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
				</xsl:element>
				
				<xsl:element name="fo:list-item-body" use-attribute-sets="">
					<xsl:attribute name="start-indent">15pt</xsl:attribute>
					
					<xsl:apply-templates select="outcome" mode="comparisons-serial-outcome-banner">
						<xsl:with-param name="oen" select="name()" />
					</xsl:apply-templates>
					
					<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:apply-templates select="pico" mode="comparisons-serial" />
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="pico" mode="comparisons-serial">
		
		
		<xsl:element name="fo:block" use-attribute-sets="green-box">
			
			<xsl:apply-templates select="reference-studies" mode="comparisons-serial" />
			<xsl:apply-templates select="population" mode="comparisons-serial">
				<xsl:with-param name="reference-type" select="reference-studies/reference-original/@type" />
			</xsl:apply-templates>
			<xsl:apply-templates select="notes" mode="comparisons-serial">
				<xsl:with-param name="oen" select="name()" />
			</xsl:apply-templates>
			<xsl:apply-templates select="absolute-results" mode="comparisons-serial" />
			<xsl:apply-templates select="statistical-analysis" mode="comparisons-serial" />
			<xsl:apply-templates select="statistical-analysis/favour" mode="comparisons-serial" />
			
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
		
	</xsl:template>
	
	<!-- reference-studies -->
	<xsl:template match="reference-studies" mode="comparisons-serial">
		
		<xsl:variable name="name" select="name()" />
		
		<xsl:variable name="current-pico-references">
			<xsl:for-each select="(reference-original|reference-related)">
				<xsl:copy-of select="reference-link" />
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:element name="fo:block" use-attribute-sets=""><!--green-box-->
			
			<xsl:element name="fo:block" use-attribute-sets="p strong keep-with-next">REFERENCE</xsl:element>
			
			<xsl:element name="fo:list-block">
				
				<xsl:element name="fo:list-item" use-attribute-sets="">
					
					<xsl:element name="fo:list-item-label" use-attribute-sets="">
						<xsl:attribute name="end-indent">30pt</xsl:attribute>
						<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
					</xsl:element>
					
					<xsl:element name="fo:list-item-body" use-attribute-sets="">
						<xsl:attribute name="start-indent">30pt</xsl:attribute>
						
						<xsl:element name="fo:block" use-attribute-sets="">
							
							<xsl:apply-templates select="reference-original" mode="comparisons-serial" />
							<xsl:apply-templates select="reference-related" mode="comparisons-serial" />
							<xsl:apply-templates select="comment" mode="comparisons-serial">
								<xsl:with-param name="oen" select="$name" />
							</xsl:apply-templates>
							<xsl:apply-templates select="notes" mode="comparisons-serial">
								<xsl:with-param name="oen" select="$name" />
							</xsl:apply-templates>
							
						</xsl:element>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="reference-original | reference-related" mode="comparisons-serial">	
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:element name="fo:block" use-attribute-sets="p">
				
				<xsl:choose>
					<xsl:when test="name() = 'reference-original'"><xsl:text>Original reference</xsl:text></xsl:when>
					<xsl:when test="name() = 'reference-related'"><xsl:text>Related reference</xsl:text></xsl:when>
				</xsl:choose>
				
				<xsl:apply-templates select="reference-link" />
				
				<xsl:if test="not(reference-link)">
					
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					
					<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">
						<xsl:text>insert reference-link</xsl:text>
					</xsl:element>
					
				</xsl:if>
				
				<xsl:apply-templates select="@*" mode="comparisons-serial" >
					<xsl:with-param name="oen" select="name()" />
				</xsl:apply-templates>
				
			</xsl:element>
				
		</xsl:element>
		
	</xsl:template>
	
	<!-- population -->
	<xsl:template match="population" mode="comparisons-serial">
		<xsl:param name="reference-type" />
		
		<xsl:variable name="name" select="name()" />
		
		<xsl:element name="fo:block" use-attribute-sets=""><!--green-box-->
			
			<xsl:element name="fo:block" use-attribute-sets="p strong keep-with-next">
				<xsl:text>POPULATION</xsl:text>
				
				<xsl:apply-templates select="@analysis" mode="comparisons-serial">
					<xsl:with-param name="oen" select="name()" />
				</xsl:apply-templates>
				
				<xsl:apply-templates select="@trials-identified" mode="comparisons-serial">
					<xsl:with-param name="oen" select="name()" />
					<xsl:with-param name="reference-type" select="@type" />
				</xsl:apply-templates>
				
			</xsl:element>
			
			<xsl:element name="fo:list-block">
				
				<xsl:element name="fo:list-item" use-attribute-sets="">
					
					<xsl:element name="fo:list-item-label" use-attribute-sets="">
						<xsl:attribute name="end-indent">30pt</xsl:attribute>
						<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
					</xsl:element>
					
					<xsl:element name="fo:list-item-body" use-attribute-sets="">
						<xsl:attribute name="start-indent">30pt</xsl:attribute>
						
						<xsl:element name="fo:block" use-attribute-sets="">
							
							<xsl:apply-templates select="p" mode="comparisons-serial" />
							<xsl:apply-templates select="comment" mode="comparisons-serial">
								<xsl:with-param name="oen" select="$name" />
							</xsl:apply-templates>
							<xsl:apply-templates select="notes" mode="comparisons-serial">
								<xsl:with-param name="oen" select="$name" />
							</xsl:apply-templates>
							
						</xsl:element>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<!-- absolute-results -->
	<xsl:template match="absolute-results" mode="comparisons-serial">
		
		<xsl:variable name="name" select="name()" />
		
		<xsl:element name="fo:block" use-attribute-sets=""><!--red-box-->
			
			<xsl:element name="fo:block" use-attribute-sets="p strong keep-with-next">
				
				<xsl:text>OUTCOME, INTERVENTIONS</xsl:text>
				
				<xsl:apply-templates select="@reporting" mode="comparisons-serial" >
					<xsl:with-param name="oen" select="name()" />
				</xsl:apply-templates>
				
				<xsl:choose>
					<xsl:when test="comparators/intervention/data-dichotomous">
						<xsl:text disable-output-escaping="yes"> </xsl:text>
						<xsl:element name="fo:inline" use-attribute-sets="generated-autotext sup">data-dichotomous field no longer used</xsl:element>
					</xsl:when>
					<xsl:when test="comparators/intervention/data-continuous">
						<xsl:text disable-output-escaping="yes"> </xsl:text>
						<xsl:element name="fo:inline" use-attribute-sets="generated-autotext sup">data-continuous field no longer used</xsl:element>
					</xsl:when>
				</xsl:choose>
				
			</xsl:element>
			
			<xsl:element name="fo:list-block">
				
				<xsl:element name="fo:list-item" use-attribute-sets="">
					
					<xsl:element name="fo:list-item-label" use-attribute-sets="">
						<xsl:attribute name="end-indent">30pt</xsl:attribute>
						<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
					</xsl:element>
					
					<xsl:element name="fo:list-item-body" use-attribute-sets="">
						<xsl:attribute name="start-indent">30pt</xsl:attribute>
						
						<xsl:element name="fo:block" use-attribute-sets="">
							
							<xsl:apply-templates select="outcome" mode="comparisons-serial">
								<xsl:with-param name="oen" select="name()" />
							</xsl:apply-templates>
							
							<xsl:apply-templates select="comparators" mode="comparisons-serial" />
							<xsl:apply-templates select="comment" mode="comparisons-serial">
								<xsl:with-param name="oen" select="$name" />
							</xsl:apply-templates>
							<xsl:apply-templates select="notes" mode="comparisons-serial">
								<xsl:with-param name="oen" select="$name" />
							</xsl:apply-templates>
							
						</xsl:element>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="comparators" mode="comparisons-serial">
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:apply-templates select="intervention" mode="comparisons-serial" />
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="intervention" mode="comparisons-serial">
		
		<xsl:element name="fo:block" use-attribute-sets="p">
			
			<xsl:apply-templates select="data | data-dichotomous | data-continuous" mode="comparisons-serial" />
			
			<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">
				<xsl:text disable-output-escaping="yes"> with </xsl:text>
			</xsl:element>
			
			<xsl:choose>
				
				<xsl:when test="$comparisons-tabulated='true'">
					<xsl:apply-templates select="class/node()"/>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:element name="fo:inline" use-attribute-sets="prompt-bordered-box">
						<xsl:apply-templates select="class"/>
					</xsl:element>	
				</xsl:otherwise>
			
			</xsl:choose>

		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="data" mode="comparisons-serial">
		
		<xsl:element name="fo:inline" use-attribute-sets="prompt-bordered-box">
			<!--<xsl:copy-of select="node()" />-->
			<xsl:apply-templates />
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="data-dichotomous" mode="comparisons-serial">
		
		<xsl:element name="fo:inline" use-attribute-sets="">
			<xsl:text disable-output-escaping="yes"> </xsl:text>
		</xsl:element>
		
		<xsl:apply-templates select="numerator" mode="comparisons-serial" />
		
		<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">
			<xsl:text> / </xsl:text>
		</xsl:element>
		
		<xsl:apply-templates select="denominator" mode="comparisons-serial" />
		
		<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">
			<xsl:text> (</xsl:text>
		</xsl:element>
		
		<xsl:apply-templates select="percentage" mode="comparisons-serial" />
		
		<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">
			<xsl:text>%) </xsl:text>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="numerator | denominator | percentage" mode="comparisons-serial">
		
		<xsl:element name="fo:inline" use-attribute-sets="prompt-bordered-box">
			<!--<xsl:copy-of select="node()" />-->
			<xsl:apply-templates />
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="data-continuous" mode="comparisons-serial">
		
		<xsl:element name="fo:inline" use-attribute-sets="generated-autotext sup">data-continuous field no longer used</xsl:element>
		
		<xsl:element name="fo:inline" use-attribute-sets="">
			<xsl:text disable-output-escaping="yes"> </xsl:text>
		</xsl:element>
		
		<xsl:element name="fo:inline" use-attribute-sets="prompt-bordered-box">
			<xsl:apply-templates />
		</xsl:element>
		
		<xsl:element name="fo:inline" use-attribute-sets="">
			<xsl:text disable-output-escaping="yes"> </xsl:text>
		</xsl:element>
		
		<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">data-continuous field no longer used</xsl:element>

	</xsl:template>
			
	<!-- statistical-analysis -->
	<xsl:template match="statistical-analysis" mode="comparisons-serial">
		
		<xsl:variable name="name" select="name()" />
		
		<xsl:element name="fo:block" use-attribute-sets=""><!--green-box-->
			
			<xsl:element name="fo:block" use-attribute-sets="p strong keep-with-next">
				
				<xsl:text>RESULTS AND STATISTICAL ANALYSIS</xsl:text>
			
				<xsl:if test="not(sec)">
					
					<xsl:element name="fo:inline" use-attribute-sets="">
						<xsl:text disable-output-escaping="yes"> </xsl:text>
					</xsl:element>
					
					<xsl:element name="fo:inline" use-attribute-sets="generated-autotext sup">risk, confidence, and p-value fields no longer used</xsl:element>
					
				</xsl:if>
				
			</xsl:element>
			
			<xsl:element name="fo:list-block">
				
				<xsl:element name="fo:list-item" use-attribute-sets="">
					
					<xsl:element name="fo:list-item-label" use-attribute-sets="">
						<xsl:attribute name="end-indent">30pt</xsl:attribute>
						<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
					</xsl:element>
					
					<xsl:element name="fo:list-item-body" use-attribute-sets="">
						<xsl:attribute name="start-indent">30pt</xsl:attribute>
						
						<xsl:element name="fo:block" use-attribute-sets="">
							
							<xsl:apply-templates select="risk" mode="comparisons-serial" />
							<xsl:apply-templates select="confidence" mode="comparisons-serial" />
							<xsl:apply-templates select="p-value" mode="comparisons-serial" />
							
							<xsl:apply-templates select="sec" mode="comparisons-serial" />
							
							<xsl:apply-templates select="comment" mode="comparisons-serial">
								<xsl:with-param name="oen" select="$name" />
							</xsl:apply-templates>
							<xsl:apply-templates select="notes" mode="comparisons-serial">
								<xsl:with-param name="oen" select="$name" />
							</xsl:apply-templates>
							
						</xsl:element>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="risk" mode="comparisons-serial">
		
		<xsl:element name="fo:block" use-attribute-sets="p">
			
			<xsl:choose>
				<xsl:when test="$comparisons-tabulated='true'">
					<!-- do nothing -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Risk</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:text disable-output-escaping="yes"> </xsl:text>
			
			<xsl:choose>
				
				<xsl:when test="@comparison-method='other' and string-length(normalize-space(@other-method))!=0">
					<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext">
						<xsl:value-of select="@other-method"/>
					</xsl:element>
				</xsl:when>
				
				<xsl:when test="@comparison-method='other' and (not(@other-method) or string-length(normalize-space(@other-method))=0)">
					<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">other comparison method required</xsl:element>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext">
						<xsl:choose>
							<xsl:when test="@comparison-method = 'or'"><xsl:text>OR</xsl:text></xsl:when>
							<xsl:when test="@comparison-method = 'rr'"><xsl:text>RR</xsl:text></xsl:when>
							<xsl:when test="@comparison-method = 'hr'"><xsl:text>HR</xsl:text></xsl:when>
							<xsl:when test="@comparison-method = 'smd'"><xsl:text>SMD</xsl:text></xsl:when>
							<xsl:when test="@comparison-method = 'wmd'"><xsl:text>WMD</xsl:text></xsl:when>
							<xsl:when test="@comparison-method = 'smd'"><xsl:text>SMD</xsl:text></xsl:when>
							<xsl:when test="@comparison-method = 'other'"><xsl:text>Other method</xsl:text></xsl:when>
							<xsl:when test="@comparison-method = 'unset'"><xsl:text>RR, OR or other?</xsl:text></xsl:when>
						</xsl:choose>
					</xsl:element>
				</xsl:otherwise>
				
			</xsl:choose>
				
			<xsl:text disable-output-escaping="yes"> </xsl:text>
			
			<xsl:choose>
				<xsl:when test="$comparisons-tabulated='true'">
					<xsl:value-of select="." />
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="fo:inline" use-attribute-sets="prompt-bordered-box">
						<xsl:apply-templates />
					</xsl:element>
					<xsl:apply-templates select="@reporting" mode="comparisons-serial">
						<xsl:with-param name="oen" select="name()" />
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="confidence" mode="comparisons-serial">
		
		<xsl:element name="fo:block" use-attribute-sets="p">
			
			<xsl:apply-templates select="interval" mode="comparisons-serial" />
			
			<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">
				<xsl:text>% </xsl:text>
			</xsl:element>
			
			<xsl:choose>
				<xsl:when test="$comparisons-tabulated='true'">
					<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">
						<xsl:text>CI</xsl:text>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">confidence interval</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:text disable-output-escaping="yes"> </xsl:text>
			
			<xsl:apply-templates select="lower-limit" mode="comparisons-serial" />
			
			<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">
				<xsl:text> to </xsl:text>
			</xsl:element>
			
			<xsl:apply-templates select="upper-limit" mode="comparisons-serial" />
			
			<xsl:choose>
				<xsl:when test="$comparisons-tabulated='true'">
					<!-- do nothing -->		
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="@reporting" mode="comparisons-serial">
						<xsl:with-param name="oen" select="string('confidence')" />
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:element>
	
	</xsl:template>
	
	<xsl:template match="interval | lower-limit | upper-limit" mode="comparisons-serial">
		
		<xsl:choose>
			<xsl:when test="$comparisons-tabulated='true'">
				<xsl:element name="fo:inline" use-attribute-sets="">
					<xsl:value-of select="." />
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="fo:inline" use-attribute-sets="prompt-bordered-box">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="p-value" mode="comparisons-serial">
		
		<xsl:element name="fo:block" use-attribute-sets="p">
			
			<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">
				
				<xsl:choose>
					
					<xsl:when test="$comparisons-tabulated='true'">
						<xsl:text>P</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>P value</xsl:text>
					</xsl:otherwise>
					
				</xsl:choose>
				
			</xsl:element>
			
			<xsl:text disable-output-escaping="yes"> </xsl:text>
			
			<xsl:apply-templates select="@operator" mode="comparisons-serial" >
				<xsl:with-param name="oen" select="name()" />
			</xsl:apply-templates>
			
			<xsl:choose>
				
				<xsl:when test="$comparisons-tabulated='true'">
					<xsl:element name="fo:inline" use-attribute-sets="">
						<xsl:value-of select="." />
					</xsl:element>
				</xsl:when>
				
				<xsl:otherwise>
					
					<xsl:element name="fo:inline" use-attribute-sets="prompt-bordered-box">
						<xsl:apply-templates />
					</xsl:element>
					
					<xsl:apply-templates select="@reported" mode="comparisons-serial" >
						<xsl:with-param name="oen" select="name()" />
					</xsl:apply-templates>
					
				</xsl:otherwise>
				
			</xsl:choose>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="favour" mode="comparisons-serial">
		
		<xsl:element name="fo:block" use-attribute-sets=""><!--gray-box-->
			
			<xsl:element name="fo:block" use-attribute-sets="p strong keep-with-next">
				
				<xsl:text>FAVOURS</xsl:text>
				
				<xsl:apply-templates select="@evaluated-effect" mode="comparisons-serial">
					<xsl:with-param name="oen" select="name()" />
				</xsl:apply-templates>
				
				<xsl:if test="string-length(normalize-space(.))!=0 and (@evaluated-effect='not-significant' or @evaluated-effect='not-reported')">
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:element name="fo:inline" use-attribute-sets="generated-autotext sup">favour should be blank</xsl:element>
				</xsl:if>
								
			</xsl:element>
			
			<xsl:element name="fo:list-block">
				
				<xsl:element name="fo:list-item" use-attribute-sets="">
					
					<xsl:element name="fo:list-item-label" use-attribute-sets="">
						<xsl:attribute name="end-indent">30pt</xsl:attribute>
						<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
					</xsl:element>
					
					<xsl:element name="fo:list-item-body" use-attribute-sets="">
						<xsl:attribute name="start-indent">30pt</xsl:attribute>
						
						<xsl:element name="fo:block" use-attribute-sets="">
							
							<xsl:element name="fo:block" use-attribute-sets="p">
								
								<xsl:apply-templates />
								
							</xsl:element>
							
						</xsl:element>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="sec" priority="1" mode="comparisons-serial">
		<xsl:param name="oen" />
		
		<xsl:element name="fo:list-block" use-attribute-sets="">
			
			<xsl:element name="fo:list-item" use-attribute-sets="">
				
				<xsl:element name="fo:list-item-label" use-attribute-sets="">
					<xsl:choose>
						<xsl:when test="$oen='reference-studies' or $oen='population' or $oen='absolute-results' or $oen='statistical-analysis'">
							<xsl:attribute name="end-indent">45pt</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="end-indent">30pt</xsl:attribute>		
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
				</xsl:element>
				
				<xsl:element name="fo:list-item-body" use-attribute-sets="">
					
					<xsl:choose>
						<xsl:when test="$oen='reference-studies' or $oen='population' or $oen='absolute-results' or $oen='statistical-analysis'">
							<xsl:attribute name="start-indent">45pt</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="start-indent">30pt</xsl:attribute>		
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:element name="fo:block" use-attribute-sets="default-padding">
						
						<xsl:attribute name="border-left-style">solid</xsl:attribute>
						<xsl:attribute name="border-left-width">3pt</xsl:attribute>
						<xsl:attribute name="border-left-color">#C0C0C0</xsl:attribute><!--lightgray-->
						
						<xsl:apply-templates mode="comparisons-serial" />
						
					</xsl:element>
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="p" priority="1" mode="comparisons-serial">
		<xsl:element name="fo:block" use-attribute-sets="p">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="title" priority="1" mode="comparisons-serial">
		<xsl:element name="fo:block" use-attribute-sets="p strong">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="*" mode="comparisons-serial-cell-text">
		<xsl:element name="fo:block" use-attribute-sets="p">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="comment" priority="1" mode="comparisons-serial">
		<xsl:param name="oen" />
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:element name="fo:block" use-attribute-sets="strong p keep-with-next">
				<xsl:choose>
					<xsl:when test="$oen!='evidence-appraisal'">Other comment</xsl:when>
					<xsl:otherwise>Comment</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			
			<xsl:apply-templates select="p|sec" mode="comparisons-serial">
				<xsl:with-param name="oen" select="$oen" />
			</xsl:apply-templates>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="notes" mode="comparisons-serial">
		<xsl:param name="oen" />
		
		<xsl:element name="fo:block" use-attribute-sets="default-margin default-padding">
		
			<xsl:element name="fo:block" use-attribute-sets="">
				
				<xsl:element name="fo:block" use-attribute-sets="p strong keep-with-next">Notes</xsl:element>
				
				<xsl:apply-templates select="p|sec" mode="comparisons-serial">
					<xsl:with-param name="oen" select="$oen" />
				</xsl:apply-templates>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="outcome" priority="1" mode="comparisons-serial-outcome-banner">
		<xsl:param name="oen" />
		<xsl:param name="pico-set" />
		<xsl:param name="pico-set-parent-outcome" />
		
		<xsl:variable name="current-outcome" select="self::outcome" />
		
		<xsl:element name="fo:block" use-attribute-sets="strong keep-with-next">
			<xsl:attribute name="border-bottom-color">#000000</xsl:attribute>
			<xsl:attribute name="border-bottom-style">solid</xsl:attribute>
			<xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
			
			
			<xsl:apply-templates select="class" mode="comparisons-serial">
				<xsl:with-param name="banner" select="string('true')" />
				<xsl:with-param name="oen" select="$oen" />
			</xsl:apply-templates>
			
			<xsl:if test="$oen != 'pico-set'">
				<xsl:apply-templates select="timeframe" mode="comparisons-serial">
					<xsl:with-param name="banner" select="string('true')" />
					<xsl:with-param name="oen" select="$oen" />
				</xsl:apply-templates>
			</xsl:if>
			
			<xsl:if 
				test="
				($oen='grade' or $oen='adverse-effects') 
				and $pico-set != 'true' 
				and $comparisons-tabulated != 'true'
				">
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:element name="fo:inline" use-attribute-sets="generated-autotext sup">create new group of studies (not displayed if blank)</xsl:element>
			</xsl:if>
			

		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="outcome" priority="1" mode="comparisons-serial">
		<xsl:param name="oen" />
		<xsl:param name="pico-set" />
		
		<xsl:element name="fo:block" use-attribute-sets="p strong keep-with-next">
			
			<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">
				
				<xsl:choose>
					<xsl:when test="$oen = 'grade'"><xsl:text>GRADE outcome</xsl:text></xsl:when>
					<xsl:when test="$oen = 'pico-set'"><xsl:text>Outcome group</xsl:text></xsl:when>
					<xsl:when test="$oen = 'absolute-results'"><xsl:text>Reported outcome</xsl:text></xsl:when>
				</xsl:choose>
				
				<xsl:if test="$oen = 'grade'">
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:element name="fo:inline" use-attribute-sets="generated-autotext sup">table column</xsl:element>
				</xsl:if>
				
				<xsl:if test="$oen = 'pico-set'">
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:element name="fo:inline" use-attribute-sets="generated-autotext sup">table sub-title</xsl:element>
				</xsl:if>
				
				<xsl:text>: </xsl:text>
				
			</xsl:element>
			
			<xsl:apply-templates select="class" mode="comparisons-serial">
				<xsl:with-param name="banner" select="string('false')" />
				<xsl:with-param name="oen" select="$oen" />
			</xsl:apply-templates>
			
			<xsl:if test="$oen != 'pico-set'">
				<xsl:apply-templates select="timeframe" mode="comparisons-serial">
					<xsl:with-param name="banner" select="string('false')" />
					<xsl:with-param name="oen" select="$oen" />
				</xsl:apply-templates>
			</xsl:if>
			
			<xsl:if test="$oen='grade' and $pico-set!='true'">
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:element name="fo:inline" use-attribute-sets="generated-autotext sup">create new group of studies (not displayed if blank)</xsl:element>
			</xsl:if>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="class" priority="1" mode="comparisons-serial">
		<xsl:param name="banner" />
		<xsl:param name="oen" />
		
		<xsl:choose>
			<xsl:when test="$oen='pico-set' or $comparisons-tabulated='true'">
				<xsl:element name="fo:inline" use-attribute-sets="">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="fo:inline" use-attribute-sets="prompt-bordered-box">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="timeframe" mode="comparisons-serial">
		<xsl:param name="banner" />
		<xsl:param name="oen" />
		
		<xsl:choose>
			<xsl:when test="$banner='true' and $comparisons-tabulated!='true'">
				<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">
					<xsl:text> (</xsl:text>
				</xsl:element>
			</xsl:when>
			<xsl:when test="$banner='true' and string-length(normalize-space(.))!=0">
				<xsl:element name="fo:inline" use-attribute-sets="">
					<xsl:text> (</xsl:text>
				</xsl:element>
			</xsl:when>
			<xsl:when test="$banner='false' and $comparisons-tabulated!='true'">
				<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">
					<xsl:text>, </xsl:text>
				</xsl:element>
			</xsl:when>
			<xsl:when test="$banner='false' and string-length(normalize-space(.))!=0">
				<xsl:element name="fo:inline" use-attribute-sets="">
					<xsl:text>, </xsl:text>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="$comparisons-tabulated!='true'">
				<xsl:element name="fo:inline" use-attribute-sets="prompt-bordered-box">
					<xsl:apply-templates />
				</xsl:element>		
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="fo:inline" use-attribute-sets="">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="$banner='true' and  $comparisons-tabulated!='true'">
				<xsl:element name="fo:inline" use-attribute-sets="generated-autotext">
					<xsl:text>)</xsl:text>
				</xsl:element>
			</xsl:when>
			<xsl:when test="$banner='true' and string-length(normalize-space(.))!=0">
				<xsl:element name="fo:inline" use-attribute-sets="">
					<xsl:text>)</xsl:text>
				</xsl:element>
			</xsl:when>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="reference-notes" mode="comparisons-serial">
		
		<xsl:element name="fo:block" use-attribute-sets="gray-box">
			
			<xsl:element name="fo:block" use-attribute-sets="p strong keep-with-next">Further information on studies</xsl:element>
			
			<xsl:choose>
				
				<xsl:when test="not(contains($system, 'serna')) and $comparisons-tabulated='true'">
					<xsl:apply-templates select="reference" mode="comparisons-serial-docato" />
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:apply-templates select="reference" mode="comparisons-serial" />
				</xsl:otherwise>
				
			</xsl:choose>
			
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="reference" mode="comparisons-serial">
		
		<xsl:element name="fo:block" use-attribute-sets="p strong">
			
			<xsl:text>Reference</xsl:text>
			
			<xsl:element name="fo:inline" use-attribute-sets="">
				<xsl:attribute name="font-weight" select="string('normal')" />
				<xsl:apply-templates select="reference-link"/>
			</xsl:element>
			
			<xsl:if test="not(reference-link)">
				
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				
				<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">
					<xsl:text>insert reference-link</xsl:text>
				</xsl:element>
				
			</xsl:if>
			
		</xsl:element>
		
		<xsl:apply-templates select="p|sec" mode="comparisons-serial">
			<xsl:with-param name="oen" select="name()" />
		</xsl:apply-templates>
		
	</xsl:template>
	
	<xsl:template match="reference" mode="comparisons-serial-docato">
		
		<xsl:element name="fo:list-block">
			
			<xsl:element name="fo:list-item" use-attribute-sets="">
				
				<xsl:element name="fo:list-item-label" use-attribute-sets="">
					<xsl:attribute name="end-indent">20pt</xsl:attribute>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:apply-templates select="reference-link"/>
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="fo:list-item-body" use-attribute-sets="">
					<xsl:attribute name="start-indent">20pt</xsl:attribute>
					
					<xsl:apply-templates select="p|sec" mode="comparisons-serial">
						<xsl:with-param name="oen" select="name()" />
					</xsl:apply-templates>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="reference-no-data" mode="comparisons-serial">
		
		<xsl:element name="fo:block" use-attribute-sets="p">
			
			<xsl:text>No data from the following reference on this outcome</xsl:text>
			
			<xsl:text disable-output-escaping="yes">.</xsl:text>
			
			<xsl:apply-templates select="reference-link" />
			
			<xsl:if test="not(reference-link)">
				
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				
				<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">
					<xsl:text>insert reference-link</xsl:text>
				</xsl:element>
				
			</xsl:if>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="@trials-identified" mode="comparisons-serial">
		<xsl:param name="oen" />
		<xsl:param name="reference-type" />
		
		<xsl:text disable-output-escaping="yes"> </xsl:text>
		
		<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">
			
			<xsl:choose>
				
				<xsl:when test="normalize-space(.)=1">
					<xsl:text>Data from 1 RCT</xsl:text>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:text>RCTs in this analysis</xsl:text>
				</xsl:otherwise>
				
			</xsl:choose>
			
		</xsl:element>
		
		<xsl:if 
			test="($reference-type!='systematic-review' or $reference-type!='non-systematic-review')
			and (.!='0' or string-length(normalize-space(.))!=0)
			">
			<xsl:text disable-output-escaping="yes"> </xsl:text>
			<xsl:element name="fo:inline" use-attribute-sets="generated-autotext sup">trials identified n/a (not displayed)</xsl:element>
		</xsl:if>
		
	</xsl:template>

	<xsl:template match="@reported" mode="comparisons-serial">
		<xsl:param name="oen" /><!-- p-value -->
		<xsl:param name="reference-type" />
		<xsl:text disable-output-escaping="yes"> </xsl:text>
		<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">
		<xsl:choose>
			<xsl:when test="normalize-space(.) = 'true'"><xsl:text>p value reported</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = 'false'"><xsl:text>p value not reported (not displayed)</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = 'unset'"><xsl:text>p value reported?</xsl:text></xsl:when>
		</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="@reporting" mode="comparisons-serial">
		<xsl:param name="oen" /><!-- absolute-results   risk    confidence -->
		<xsl:param name="reference-type" />
		
		<xsl:text disable-output-escaping="yes"> </xsl:text>
		
		<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">
		<xsl:choose>
			<xsl:when test="$oen = 'absolute-results'">
				<xsl:choose>
					<xsl:when test="normalize-space(.) = 'complete'"><xsl:text>absolute results reported completely (not displayed)</xsl:text></xsl:when>
					<xsl:when test="normalize-space(.) = 'graphical'"><xsl:text>absolute results reported graphically</xsl:text></xsl:when>
					<xsl:when test="normalize-space(.) = 'percentage-only'"><xsl:text>absolute numbers not reported</xsl:text></xsl:when>
					<xsl:when test="normalize-space(.) = 'none'"><xsl:text>absolute results not reported</xsl:text></xsl:when>
					<xsl:when test="normalize-space(.) = 'unset'"><xsl:text>how were results reported?</xsl:text></xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$oen = 'risk'">
				<xsl:choose>
					<xsl:when test="normalize-space(.) = 'complete'"><xsl:text>[risk comparison method] reported completely (not displayed)</xsl:text></xsl:when>
					<xsl:when test="normalize-space(.) = 'graphical'"><xsl:text>[risk comaparison method] reported graphically</xsl:text></xsl:when>
					<xsl:when test="normalize-space(.) = 'none'"><xsl:text>[risk comaparison method] not reported</xsl:text></xsl:when>
					<xsl:when test="normalize-space(.) = 'unset'"><xsl:text>how were results reported?</xsl:text></xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$oen = 'confidence'">
				<xsl:choose>
					<xsl:when test="normalize-space(.) = 'complete'"><xsl:text>95% ci reported completely (not displayed)</xsl:text></xsl:when>
					<xsl:when test="normalize-space(.) = 'lower-limit-only'"><xsl:text>95% ci lower limit reported only</xsl:text></xsl:when>
					<xsl:when test="normalize-space(.) = 'upper-limit-only'"><xsl:text>95% ci upper limit reported only</xsl:text></xsl:when>
					<xsl:when test="normalize-space(.) = 'graphical'"><xsl:text>95% ci reported graphically</xsl:text></xsl:when>
					<xsl:when test="normalize-space(.) = 'none'"><xsl:text>95% ci not reported</xsl:text></xsl:when>
					<xsl:when test="normalize-space(.) = 'unset'"><xsl:text>how were results reported?</xsl:text></xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
		</xsl:element>
	</xsl:template>

	<xsl:template match="@analysis" mode="comparisons-serial">
		<xsl:param name="oen" /> <!-- population -->
		<xsl:param name="reference-type" />
		
		<xsl:text disable-output-escaping="yes"> </xsl:text>

		<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">
		<xsl:choose>
			<xsl:when test="normalize-space(.) = 'complete'"><xsl:text>complete analysis</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = 'subgroup'"><xsl:text>subgroup analysis</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = 'sensitivity'"><xsl:text>sensitivity analysis</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = 'unset'"><xsl:text>analysis of complete population?</xsl:text></xsl:when>
		</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="@reported-as-significant" mode="comparisons-serial">
		<xsl:param name="oen" /> 
		<xsl:param name="reference-type" />
		
		<xsl:text disable-output-escaping="yes"> </xsl:text>

		<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">
		<xsl:choose>
			<xsl:when test="normalize-space(.) = 'true'"><xsl:text>reported as significant</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = 'false'"><xsl:text>reported as not significant</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = 'not-reported'"><xsl:text>significance not assessed</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = 'unset'"><xsl:text>results significant?</xsl:text></xsl:when>
		</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="@type" mode="comparisons-serial">
		<xsl:param name="oen" /> <!-- adverse-effects & reference-original   reference-related-->
		<xsl:param name="reference-type" />
		
		<xsl:text disable-output-escaping="yes"> </xsl:text>
		
		<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">
			
			<xsl:choose>
				<xsl:when test="$oen='adverse-effects'">
					<xsl:choose>
						<xsl:when test="normalize-space(.) = 'standard'"><xsl:text>adverse effects</xsl:text></xsl:when>
						<xsl:when test="normalize-space(.) = 'other'"><xsl:text>other adverse effects</xsl:text></xsl:when>
						<xsl:when test="normalize-space(.) = 'unset'"><xsl:text>adverse effects type?</xsl:text></xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$oen='reference-original'">
					<xsl:choose>
						<xsl:when test="normalize-space(.)='rct'"><xsl:text>rct</xsl:text></xsl:when>
						<xsl:when test="normalize-space(.)='pseudo-rct'"><xsl:text>pseudo-randomised trial</xsl:text></xsl:when>
						<xsl:when test="normalize-space(.)='systematic-review'"><xsl:text>systematic review</xsl:text></xsl:when>
						<xsl:when test="normalize-space(.)='non-systematic-review'"><xsl:text>non-systematic review</xsl:text></xsl:when>
						<xsl:when test="normalize-space(.)='cohort'"><xsl:text>cohort study</xsl:text></xsl:when>
						<xsl:when test="normalize-space(.)='case-control'"><xsl:text>case control</xsl:text></xsl:when>
						<xsl:when test="normalize-space(.)='cross-section'"><xsl:text>cross-sectional study</xsl:text></xsl:when>
						<xsl:when test="normalize-space(.)='unset'"><xsl:text>what type of study?</xsl:text></xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$oen='reference-related'">
					<xsl:choose>
						<xsl:when test="normalize-space(.) = 'trial-in-review'"><xsl:text>in review</xsl:text></xsl:when>
						<xsl:when test="normalize-space(.) = 'further-report'"><xsl:text>further report of reference</xsl:text></xsl:when>
						<xsl:when test="normalize-space(.) = 'unset'"><xsl:text>how is the original reference related?</xsl:text></xsl:when>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="@design" mode="comparisons-serial">
		<xsl:param name="oen" />  <!-- reference-original -->
		<xsl:param name="reference-type" />
		
		<xsl:text disable-output-escaping="yes"> </xsl:text>
		<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">
		<xsl:choose>
			<xsl:when test="normalize-space(.)='parallel-group'"><xsl:text>parallel group (not displayed)</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.)='cross-over'"><xsl:text>crossover design</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.)='unset'"><xsl:text>design?</xsl:text></xsl:when>
		</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="@number-of-arms" mode="comparisons-serial">
		<xsl:param name="oen" />  <!-- reference-original -->
		<xsl:param name="reference-type" />
		
		<xsl:text disable-output-escaping="yes"> </xsl:text>
		<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">
		<xsl:choose>
			<xsl:when test="normalize-space(.) = '1'"><xsl:text>1-armed trial</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = '2'"><xsl:text>2-armed trial (not displayed)</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = '3'"><xsl:text>3-armed trial</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = '4'"><xsl:text>4-armed trial</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = '5'"><xsl:text>5-armed trial</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = '6'"><xsl:text>6-armed trial</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = '7'"><xsl:text>7-armed trial</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = '8'"><xsl:text>8-armed trial</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = '9'"><xsl:text>9-armed trial</xsl:text></xsl:when>
			<xsl:when test="normalize-space(.) = 'unset'"><xsl:text>how many arms? (not displayed)</xsl:text></xsl:when>
		</xsl:choose>
		</xsl:element>
		
	</xsl:template>

	<xsl:template match="@operator" mode="comparisons-serial">
		<xsl:param name="oen" />
		
		<xsl:text disable-output-escaping="yes"> </xsl:text>
		
		<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext">
			<xsl:choose>
				<xsl:when test=".='equals'"><xsl:text>=</xsl:text></xsl:when>
				<xsl:when test=".='greater-than'"><xsl:text>&gt;</xsl:text></xsl:when>
				<xsl:when test=".='less-than'"><xsl:text>&lt;</xsl:text></xsl:when>
				<xsl:when test=".='greater-than-or-equal-to'"><xsl:text>≥</xsl:text></xsl:when>
				<xsl:when test=".='less-than-or-equal-to'"><xsl:text>≤</xsl:text></xsl:when>
				<xsl:when test=".='unset'"><xsl:text>operator?</xsl:text></xsl:when>
				<xsl:when test=".='equals-text'"><xsl:text>equals</xsl:text></xsl:when>
				<xsl:when test=".='greater-than-text'"><xsl:text>greater-than</xsl:text></xsl:when>
				<xsl:when test=".='less-than-text'"><xsl:text>less-than</xsl:text></xsl:when>
				<xsl:when test=".='greater-than-or-equal-to-text'"><xsl:text>greater than or equal to</xsl:text></xsl:when>
				<xsl:when test=".='less-than-or-equal-to-text'"><xsl:text>less than or equal to</xsl:text></xsl:when>
				<xsl:when test=".='unset-text'"><xsl:text>operator?</xsl:text></xsl:when>
			</xsl:choose>
		</xsl:element>
		
		<xsl:text disable-output-escaping="yes"> </xsl:text>
		
	</xsl:template>
	
	<xsl:template match="@study-count | @participants" mode="comparisons-serial">
		
		<xsl:text disable-output-escaping="yes"> </xsl:text>
		
		<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">
			
			<xsl:choose>
				<xsl:when test="name() = 'study-count'"><xsl:text>study count</xsl:text></xsl:when>
				<xsl:when test="name() = 'participants'"><xsl:text>participants</xsl:text></xsl:when>
			</xsl:choose>
			
			<xsl:text disable-output-escaping="yes"> (</xsl:text>
			
			<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext">
				<xsl:value-of select="."/>
			</xsl:element>
			
			<xsl:text disable-output-escaping="yes">) </xsl:text>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="@best-evidence | @evidence-quality" mode="comparisons-serial">
		
		<xsl:element name="fo:block" use-attribute-sets="p">
			<xsl:attribute name="text-align">center</xsl:attribute>
			
			<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext">
				<xsl:value-of select="."/>
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	 
	<xsl:template match="@methodlogical-quality | @consistency | @directness | @effect-size" mode="comparisons-serial">
		
		<xsl:element name="fo:block" use-attribute-sets="p">
			<xsl:attribute name="text-align">center</xsl:attribute>
			
			<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext">
				<xsl:value-of select="."/>
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="@evaluated-effect" mode="comparisons-serial">
		<xsl:param name="oen" />
		
    		<xsl:element name="fo:inline" use-attribute-sets="attribute-autotext sup">
    
	  		<xsl:text disable-output-escaping="yes"> </xsl:text>
	  		
	  		<xsl:choose>
	  			<xsl:when test=".='small'"><xsl:text>small effect size</xsl:text></xsl:when>
	  			<xsl:when test=".='moderate'"><xsl:text>moderate effect size</xsl:text></xsl:when>
	  			<xsl:when test=".='large'"><xsl:text>large effect size</xsl:text></xsl:when>
	  			<xsl:when test=".='not-significant'"><xsl:text>not significant</xsl:text></xsl:when>
	  			<xsl:when test=".='not-calculated'"><xsl:text>effect size not calculated</xsl:text></xsl:when>
	  			<xsl:when test=".='not-reported'"><xsl:text>effect size not reported (not displayed)</xsl:text></xsl:when>
	  			<xsl:when test=".='unset'"><xsl:text>which icon?</xsl:text></xsl:when>
	  		</xsl:choose>

      		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>

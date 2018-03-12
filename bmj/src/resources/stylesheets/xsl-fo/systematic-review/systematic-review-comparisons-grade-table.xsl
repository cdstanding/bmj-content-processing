<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:se="http://syntext.com/XSL/Format-1.0"
	xmlns:sf="http://www.syntext.com/Extensions/Functions"
	xmlns:xse="http://www.syntext.com/Extensions/XSLT-1.0"
	xmlns:bmj="http://bmjpg.com/BMJKXML/Extensions"
	version="1.1">
	<!--  <xsl:include href="../generic-fo-default-elements.xsl"/> -->
	<xsl:template name="process-comparisons-grade-table">
			
		<xsl:if test="$evidence-appraisal-grade-table = 'true'">
		
			<xsl:element name="fo:block" use-attribute-sets="keep-together">
				<xsl:attribute name="id" select="concat($cid, '_T', 'G')"/>
				
				<xsl:call-template name="process-comparisons-grade-table-caption" />
				
				<xsl:element name="fo:table" use-attribute-sets="table small background-tinted-blue">
					
					<xsl:choose>
						<xsl:when test="$system='docato'">
							
							<xsl:call-template name="process-comparisons-grade-table-header">
								<xsl:with-param name="outcomes">
									
									<xsl:element name="outcomes">
																	
										<xsl:for-each select="$question-list//grade/outcome/class">
									
											<xsl:sort select="translate(normalize-space(.), $upper, $lower)" />
											
											<xsl:element name="class">
											<!-- Updated to highlight the changes in grade table-->
												<!-- <xsl:value-of select="."></xsl:value-of> -->
												<xsl:copy-of select="./node()" /> 
											
											</xsl:element>
											
										</xsl:for-each>
										
									</xsl:element>
									
								</xsl:with-param>
							</xsl:call-template>
							
							<xsl:call-template name="process-comparisons-grade-table-footer" />
							<xsl:call-template name="process-comparisons-grade-table-body" />
							
						</xsl:when>
						
						<xsl:otherwise>
							
							<xsl:call-template name="process-comparisons-grade-table-header">
								
								<xsl:with-param name="outcomes">
									
									<xsl:element name="outcomes">
										
										<xsl:for-each select="$question-list//grade/outcome/class">
											<xsl:sort select="translate(normalize-space(.), $upper, $lower)" />
											
											<xsl:element name="class">
											<!-- Updated to highlight the changes in grade table-->
											<!-- <xsl:value-of select="."/> -->
												<xsl:copy-of select="./node()" /> 
											</xsl:element>
											
										</xsl:for-each>
										
									</xsl:element>
									
								</xsl:with-param>
								
							</xsl:call-template>
							
							<xsl:call-template name="process-comparisons-grade-table-body" />
							<xsl:call-template name="process-comparisons-grade-table-footer" />
							
						</xsl:otherwise>
						
					</xsl:choose>
					
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="process-comparisons-grade-table-caption">
		
		<xsl:element name="fo:list-block" use-attribute-sets="">
			
			<xsl:element name="fo:list-item" use-attribute-sets="background-tinted-blue">
				
				<xsl:element name="fo:list-item-label" use-attribute-sets="">
					<xsl:attribute name="end-indent">60pt</xsl:attribute>
					
					<xsl:element name="fo:block" use-attribute-sets="strong background-blue color-white">
						<xsl:element name="fo:block" use-attribute-sets="default-margin">GRADE</xsl:element>
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="fo:list-item-body" use-attribute-sets="">
					<xsl:attribute name="start-indent">60pt</xsl:attribute>
					
					<xsl:element name="fo:block" use-attribute-sets="strong background-tinted-blue">
						
						<xsl:element name="fo:block" use-attribute-sets="default-margin">
							
							<xsl:text>Evaluation of interventions</xsl:text>
							
							<xsl:text> for </xsl:text>
							
							<xsl:apply-templates select="/systematic-review/info/title/node()" />
							
							<xsl:text>. </xsl:text>
							
						</xsl:element>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
		<xsl:element name="fo:block" use-attribute-sets="narrow-white-line">-</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-comparisons-grade-table-header">
		<xsl:param name="outcomes" />
		
		<xsl:element name="fo:table-header" use-attribute-sets="strong thead">
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="display-align">after</xsl:attribute>
			
			<xsl:element name="fo:table-row" use-attribute-sets="">
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					
					<xsl:if test="contains($proof, 'draft') and $system='docato'">
						<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
						<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
						<xsl:attribute name="border">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin"><xsl:text>Important outcomes</xsl:text></xsl:element>
					
				</xsl:element>
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					
					<xsl:if test="contains($proof, 'draft') and $system='docato'">
						<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
						<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
						<xsl:attribute name="border">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:attribute name="number-columns-spanned">9</xsl:attribute>
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						
						<xsl:for-each select="$outcomes//class">
							
							<xsl:if test="translate(normalize-space(self::class), $upper, $lower) != translate(normalize-space(preceding-sibling::class[1]), $upper, $lower)">
							
								 <!-- Updated to highlight the changes in grade table-->
								 <!-- <xsl:value-of select="."/> -->
								 <xsl:apply-templates select="./node()"></xsl:apply-templates> 
								
							</xsl:if>
							
							<xsl:if test="position()!=last() and translate(normalize-space(self::class), $upper, $lower) != translate(normalize-space(following-sibling::class[1]), $upper, $lower)">
								<xsl:text>, </xsl:text>
							</xsl:if>
							
						</xsl:for-each>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:table-row" use-attribute-sets="">
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					
					<xsl:if test="contains($proof, 'draft') and $system='docato'">
						<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
						<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
						<xsl:attribute name="border">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						<xsl:text>Studies (Participants)</xsl:text>
					</xsl:element>
				</xsl:element>
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					
					<xsl:if test="contains($proof, 'draft') and $system='docato'">
						<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
						<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
						<xsl:attribute name="border">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						<xsl:text>Outcome</xsl:text>
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					
					<xsl:if test="contains($proof, 'draft') and $system='docato'">
						<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
						<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
						<xsl:attribute name="border">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						<xsl:text>Comparison</xsl:text>
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					
					<xsl:if test="contains($proof, 'draft') and $system='docato'">
						<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
						<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
						<xsl:attribute name="border">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						<xsl:text>Type of evidence</xsl:text>
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					
					<xsl:if test="contains($proof, 'draft') and $system='docato'">
						<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
						<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
						<xsl:attribute name="border">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						<xsl:text>Quality</xsl:text>
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					
					<xsl:if test="contains($proof, 'draft') and $system='docato'">
						<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
						<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
						<xsl:attribute name="border">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						<xsl:text>Consistency</xsl:text>
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					
					<xsl:if test="contains($proof, 'draft') and $system='docato'">
						<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
						<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
						<xsl:attribute name="border">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						<xsl:text>Directness</xsl:text>
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					
					<xsl:if test="contains($proof, 'draft') and $system='docato'">
						<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
						<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
						<xsl:attribute name="border">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						<xsl:text>Effect size</xsl:text>
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					
					<xsl:if test="contains($proof, 'draft') and $system='docato'">
						<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
						<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
						<xsl:attribute name="border">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						<xsl:text>GRADE</xsl:text>
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					
					<xsl:if test="contains($proof, 'draft') and $system='docato'">
						<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
						<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
						<xsl:attribute name="border">2pt</xsl:attribute>
					</xsl:if>

					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						<xsl:text>Comment</xsl:text>
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-comparisons-grade-table-body">
		
		<xsl:element name="fo:table-body" use-attribute-sets="tbody">
			
			<xsl:for-each select="/systematic-review/question-list/question">
				
				<xsl:variable name="question">
					<xsl:element name="question">
						<xsl:copy-of select="title" />
						<xsl:choose>
							<xsl:when test="option">
								<xsl:for-each select="option">
									<xsl:copy-of select="self::option"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="xi:include[contains(@href, 'option')]">
									<xsl:copy-of select="document(@href)/*" />	
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:variable>
				
				<xsl:apply-templates select="$question/question[option/comparison-set/comparison/grade/evidence-appraisal]" mode="comparisons-grade-table" />
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-comparisons-grade-table-footer">
		
		<xsl:element name="fo:table-footer" use-attribute-sets="tfoot">
			
			<xsl:element name="fo:table-row" use-attribute-sets="">
				
				<xsl:element name="fo:table-cell" use-attribute-sets="">
					<xsl:attribute name="number-columns-spanned">10</xsl:attribute>
					
					<xsl:if test="contains($proof, 'draft') and $system='docato'">
						<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
						<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
						<xsl:attribute name="border">2pt</xsl:attribute>
					</xsl:if>
					
					<xsl:element name="fo:block" use-attribute-sets="default-margin">
						<xsl:text>We initially allocate 4 points to evidence from RCTs, and 2 points to evidence from observational studies. To attain the final GRADE score for a given comparison, points are deducted or added  from this initial score based on preset criteria relating to the categories of quality, directness, consistency, and effect size. &#10;Quality: based on issues affecting methodological rigour (e.g., incomplete reporting of results, quasi-randomisation, sparse data [&lt;200 people in the analysis]). &#10;Consistency: based on similarity of results across studies. &#10;Directness: based on generalisability of population or outcomes. &#10;Effect size: based on magnitude of effect as measured by statistics such as relative risk, odds ratio, or hazard ratio.</xsl:text>
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="question" mode="comparisons-grade-table">
		
		<xsl:element name="fo:table-row" use-attribute-sets="">
			
			<xsl:element name="fo:table-cell" use-attribute-sets="">
				
				<xsl:if test="contains($proof, 'draft') and $system='docato'">
					<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
					<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
					<xsl:attribute name="border">2pt</xsl:attribute>
				</xsl:if>
				
				<xsl:attribute name="number-columns-spanned">10</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="default-margin em">
					<xsl:apply-templates select="title/node()" />
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
		<xsl:apply-templates select="option/comparison-set/comparison" mode="comparisons-grade-table" />
			
	</xsl:template>
	
	<xsl:template match="comparison" mode="comparisons-grade-table">
		
		<xsl:apply-templates select="grade" mode="comparisons-grade-table">
			<xsl:with-param name="comparison-title" select="title" />
		</xsl:apply-templates>
		
	</xsl:template>
	
	<xsl:template match="grade" mode="comparisons-grade-table">
		<xsl:param name="comparison-title" />
		
		<xsl:if test="pico-set/pico/reference-studies">
			<xsl:variable name="reference-links">
				<xsl:element name="reference-links">
					<xsl:for-each select="pico-set/pico/reference-studies[@grade-contribution='true']">
						<xsl:copy-of select="reference-original/reference-link" />
					</xsl:for-each>
				</xsl:element>
			</xsl:variable>
			
			<xsl:apply-templates select="evidence-appraisal" mode="comparisons-grade-table">
				<xsl:with-param name="comparison-title" select="$comparison-title" />
				<xsl:with-param name="grade-outcome" select="outcome/class" />
				<xsl:with-param name="reference-links" select="$reference-links" />
			</xsl:apply-templates>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="evidence-appraisal" mode="comparisons-grade-table">
		<xsl:param name="comparison-title" />
		<xsl:param name="grade-outcome" />
		<xsl:param name="reference-links" />
		
		<xsl:element name="fo:table-row" use-attribute-sets="">
			
			<xsl:element name="fo:table-cell" use-attribute-sets="">
				
				<xsl:if test="contains($proof, 'draft') and $system='docato'">
					<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
					<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
					<xsl:attribute name="border">2pt</xsl:attribute>
				</xsl:if>
				
				<xsl:element name="fo:block" use-attribute-sets="default-margin">
					
					<xsl:value-of select="normalize-space(reference-studies/@study-count)" />
				
					<xsl:text> (</xsl:text>
					
					<xsl:value-of select="normalize-space(reference-studies/@participants)" />
					
					<xsl:text>)</xsl:text>
					
					<xsl:apply-templates select="reference-studies/reference-link">
						<xsl:with-param name="dim" select="string('true')" />
					</xsl:apply-templates>
					
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:table-cell" use-attribute-sets="">
				
				<xsl:if test="contains($proof, 'draft') and $system='docato'">
					<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
					<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
					<xsl:attribute name="border">2pt</xsl:attribute>
				</xsl:if>
				
				<xsl:element name="fo:block" use-attribute-sets="default-margin">
				<!-- Updated to highlight the changes in grade table-->
					<!-- <xsl:value-of select="normalize-space($grade-outcome)" /> -->
					<xsl:apply-templates select="$grade-outcome" />
				</xsl:element>
				
			</xsl:element>

			<xsl:element name="fo:table-cell" use-attribute-sets="">
				
				<xsl:if test="contains($proof, 'draft') and $system='docato'">
					<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
					<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
					<xsl:attribute name="border">2pt</xsl:attribute>
				</xsl:if>
				
				<xsl:element name="fo:block" use-attribute-sets="default-margin">
				<!-- Updated to highlight the changes in grade table-->
					<!-- <xsl:value-of select="normalize-space($comparison-title)" /> -->
					<xsl:apply-templates select="$comparison-title" />
					
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:table-cell" use-attribute-sets="">
				
				<xsl:if test="contains($proof, 'draft') and $system='docato'">
					<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
					<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
					<xsl:attribute name="border">2pt</xsl:attribute>
				</xsl:if>
				
				<xsl:attribute name="text-align">center</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="default-margin">
					<xsl:value-of select="@best-evidence" />
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:table-cell" use-attribute-sets="">
				
				<xsl:if test="contains($proof, 'draft') and $system='docato'">
					<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
					<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
					<xsl:attribute name="border">2pt</xsl:attribute>
				</xsl:if>
				
				<xsl:attribute name="text-align">center</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="default-margin">
					<xsl:value-of select="@methodlogical-quality" />
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:table-cell" use-attribute-sets="">
				
				<xsl:if test="contains($proof, 'draft') and $system='docato'">
					<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
					<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
					<xsl:attribute name="border">2pt</xsl:attribute>
				</xsl:if>
				
				<xsl:attribute name="text-align">center</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="default-margin">
					<xsl:value-of select="@consistency" />
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:table-cell" use-attribute-sets="">
				
				<xsl:if test="contains($proof, 'draft') and $system='docato'">
					<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
					<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
					<xsl:attribute name="border">2pt</xsl:attribute>
				</xsl:if>
				
				<xsl:attribute name="text-align">center</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="default-margin">
					<xsl:value-of select="@directness" />
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:table-cell" use-attribute-sets="">
				
				<xsl:if test="contains($proof, 'draft') and $system='docato'">
					<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
					<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
					<xsl:attribute name="border">2pt</xsl:attribute>
				</xsl:if>
				
				<xsl:attribute name="text-align">center</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="default-margin">
					<xsl:value-of select="@effect-size" />
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:table-cell" use-attribute-sets="">
				
				<xsl:if test="contains($proof, 'draft') and $system='docato'">
					<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
					<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
					<xsl:attribute name="border">2pt</xsl:attribute>
				</xsl:if>
				
				<xsl:attribute name="text-align">center</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="default-margin">
					<xsl:value-of select="translate(substring(@evidence-quality,1,1), $lower, $upper)" />
					<xsl:value-of select="translate(substring(@evidence-quality,2), '-', ' ')" />
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="fo:table-cell" use-attribute-sets="">
				
				<xsl:if test="contains($proof, 'draft') and $system='docato'">
					<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
					<xsl:attribute name="border-color">#C5C9E6</xsl:attribute>
					<xsl:attribute name="border">2pt</xsl:attribute>
				</xsl:if>
				
				<xsl:element name="fo:block" use-attribute-sets="default-margin">
				<!-- Updated to highlight the changes in grade table-->
				<!-- <xsl:value-of select="comment/p"> -->
					<xsl:apply-templates select="comment/p/node()"></xsl:apply-templates>
				</xsl:element>
			</xsl:element>
		</xsl:element></xsl:template>
		
</xsl:stylesheet>


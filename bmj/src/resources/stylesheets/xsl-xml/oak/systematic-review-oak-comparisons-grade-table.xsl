<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xi="http://www.w3.org/2001/XInclude"	
	xmlns="http://schema.bmj.com/delivery/oak"	
	xmlns:oak="http://schema.bmj.com/delivery/oak"
	xmlns:ce="http://schema.bmj.com/delivery/oak-ce"	
	version="2.0">
	
	<xsl:template name="process-comparisons-grade-table">
		
		<xsl:if test="$evidence-appraisal-grade-table = 'true'">
		
			<xsl:element name="table" inherit-namespaces="yes">
				<xsl:attribute name="id" select="concat($id-lead-text, $cid, '-t', 'g')"/>
				<xsl:attribute name="class">grade-table</xsl:attribute>	
				
				<xsl:call-template name="process-comparisons-grade-table-caption" />
				
				<xsl:call-template name="process-comparisons-grade-table-header">
					
					<xsl:with-param name="outcomes">
						
						<xsl:element name="outcomes">
							
							<xsl:for-each select="$question-list//*:grade/*:outcome/*:class">
								<xsl:sort select="translate(normalize-space(.), $upper, $lower)" />
								
								<xsl:element name="class">
									<!-- <xsl:value-of select="normalize-space(.)" /> -->
									<xsl:copy-of select="./node()" /> 
										
								</xsl:element>
								
							</xsl:for-each>
							
						</xsl:element>
						
					</xsl:with-param>
					
				</xsl:call-template>
				
				<xsl:call-template name="process-comparisons-grade-table-body" />
				<xsl:call-template name="process-comparisons-grade-table-footer" />
				
			</xsl:element>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template name="process-comparisons-grade-table-caption">
		
		<xsl:element name="caption" inherit-namespaces="yes">
			
			<xsl:element name="p">
				
				<xsl:element name="inline">
					<xsl:attribute name="class">label</xsl:attribute>
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('grade')"/>
					</xsl:call-template>
				</xsl:element>
				
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="string('evaluation-of-interventions')"/>
				</xsl:call-template>
				
				<xsl:text> for </xsl:text>
				
				<xsl:apply-templates select="/systematic-review/info/title/node()" />
				
				<xsl:text>. </xsl:text>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-comparisons-grade-table-header">
		<xsl:param name="outcomes" />
		
		<xsl:element name="thead" inherit-namespaces="yes">
			
			<xsl:element name="tr">
				
				<xsl:element name="td">
					<xsl:attribute name="colspan">1</xsl:attribute>
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('important-outcomes')"/>
					</xsl:call-template>
				</xsl:element>
				
				<xsl:element name="td">
					<xsl:attribute name="colspan">9</xsl:attribute>
					
					<xsl:for-each select="$outcomes//*:class">
					
						<xsl:if test="translate(normalize-space(self::*:class), $upper, $lower) != translate(normalize-space(preceding-sibling::*:class[1]), $upper, $lower)">
							<!-- Updated to highlight the changes in grade table-->
							<!-- <xsl:value-of select="." /> -->
							<xsl:apply-templates select="./node()"/>
						</xsl:if>
						
						<xsl:if test="position()!=last() and translate(normalize-space(self::*:class), $upper, $lower) != translate(normalize-space(following-sibling::*:class[1]), $upper, $lower)">
							<xsl:text>, </xsl:text>
						</xsl:if>
						
					</xsl:for-each>
					
				</xsl:element>
				
			</xsl:element>
			
			<xsl:element name="tr">
				
				<xsl:element name="td">
					
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('Studies')"/>
					</xsl:call-template>
					
					<xsl:text> (</xsl:text>
					
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('participants')"/>
					</xsl:call-template>
					
					<xsl:text>)</xsl:text>
					
				</xsl:element>
				
				<xsl:element name="td">
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('outcome')"/>
					</xsl:call-template>
				</xsl:element>
				
				<xsl:element name="td">
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('comparison')"/>
					</xsl:call-template>
				</xsl:element>
				
				<xsl:element name="td">
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('evidence-type')"/>
					</xsl:call-template>
				</xsl:element>
				
				<xsl:element name="td">
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('quality')"/>
					</xsl:call-template>
				</xsl:element>
				
				<xsl:element name="td">
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('consistency')"/>
					</xsl:call-template>
				</xsl:element>
				
				<xsl:element name="td">
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('directness')"/>
					</xsl:call-template>
				</xsl:element>
				
				<xsl:element name="td">
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('effect-size')"/>
					</xsl:call-template>
				</xsl:element>
				
				<xsl:element name="td">
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('grade')"/>
					</xsl:call-template>
				</xsl:element>
				
				<xsl:element name="td">
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('comment')"/>
					</xsl:call-template>
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-comparisons-grade-table-footer">
		
		<xsl:element name="tfoot" inherit-namespaces="yes">
			<xsl:element name="tr">
				<xsl:element name="td">
					<xsl:attribute name="colspan">10</xsl:attribute>
					
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('grade-footnote')"/>
					</xsl:call-template>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-comparisons-grade-table-body">
		
		<xsl:element name="tbody" inherit-namespaces="yes">
			
			<xsl:for-each select="/systematic-review/question-list/question">
				
				<xsl:variable name="question">
					<xsl:element name="question" inherit-namespaces="no">
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
				
				<xsl:apply-templates select="$question/*:question[*:option/*:comparison-set/*:comparison/*:grade/*:evidence-appraisal]" mode="comparisons-grade-table" />
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="*:question" mode="comparisons-grade-table">
		
		<xsl:element name="tr">
			<xsl:element name="td">
				<xsl:attribute name="colspan">10</xsl:attribute>
				<!-- Updated to highlight the changes in grade table-->
				<!-- <xsl:value-of select="*:title/node()" /> -->
				<xsl:apply-templates select="*:title/node()" />
			</xsl:element>
		</xsl:element>
		
		<xsl:apply-templates select="*:option/*:comparison-set/*:comparison" mode="comparisons-grade-table" />
		
	</xsl:template>
	
	<xsl:template match="comparison" mode="comparisons-grade-table">
		
		<xsl:apply-templates select="*:grade" mode="comparisons-grade-table">
			<xsl:with-param name="comparison-title" select="*:title" />
		</xsl:apply-templates>
		
	</xsl:template>
	
	<xsl:template match="grade" mode="comparisons-grade-table">
		<xsl:param name="comparison-title" />
		
		<xsl:if test="*:pico-set/*:pico/*:reference-studies">
			<xsl:variable name="reference-links">
				<xsl:element name="reference-links">
					<xsl:for-each select="*:pico-set/*:pico/*:reference-studies">
						<xsl:copy-of select="reference-original/reference-link" />
					</xsl:for-each>
				</xsl:element>
			</xsl:variable>
			
			<xsl:apply-templates select="*:evidence-appraisal" mode="comparisons-grade-table">
				<xsl:with-param name="comparison-title" select="$comparison-title" />
				<xsl:with-param name="grade-outcome" select="*:outcome/*:class" />
				<xsl:with-param name="reference-links" select="$reference-links" />
			</xsl:apply-templates>
			
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="*:evidence-appraisal" mode="comparisons-grade-table">
		<xsl:param name="comparison-title" />
		<xsl:param name="grade-outcome" />
		<xsl:param name="reference-links" />
		
		<xsl:element name="tr" use-attribute-sets="">
			
			<xsl:element name="td" use-attribute-sets="">
				
				<xsl:value-of select="normalize-space(reference-studies/@study-count)" />
				
				<xsl:text> (</xsl:text>
				
				<xsl:value-of select="normalize-space(reference-studies/@participants)" />
				
				<xsl:text>)</xsl:text>
				
				<xsl:apply-templates select="reference-studies/reference-link">
					<xsl:with-param name="dim" select="string('true')" />
				</xsl:apply-templates>
				
			</xsl:element>
			
			<xsl:element name="td" use-attribute-sets="">
			<!-- Updated to highlight the changes in grade table-->
				<!-- <xsl:value-of select="$grade-outcome"/> -->
				<xsl:apply-templates select="$grade-outcome"></xsl:apply-templates>
			</xsl:element>
			
			<xsl:element name="td" use-attribute-sets="">
			<!-- Updated to highlight the changes in grade table-->
					<!-- <xsl:calue-of select="$comparison-title"/> -->
					<xsl:apply-templates select="$comparison-title"></xsl:apply-templates>
			</xsl:element>
			
			<xsl:element name="td" use-attribute-sets="">
				<xsl:value-of select="@best-evidence" />
			</xsl:element>
			
			<xsl:element name="td" use-attribute-sets="">
				<xsl:value-of select="@methodlogical-quality" />
			</xsl:element>
			
			<xsl:element name="td" use-attribute-sets="">
				<xsl:value-of select="@consistency" />
			</xsl:element>
			
			<xsl:element name="td" use-attribute-sets="">
				<xsl:value-of select="@directness" />
			</xsl:element>
			
			<xsl:element name="td" use-attribute-sets="">
				<xsl:value-of select="@effect-size" />
			</xsl:element>
			
			<xsl:element name="td" use-attribute-sets="">
				<xsl:value-of select="translate(substring(@evidence-quality,1,1), $lower, $upper)" />
				<xsl:value-of select="translate(substring(@evidence-quality,2), '-', ' ')" />
			</xsl:element>
			
			<xsl:element name="td" use-attribute-sets="">
			<!-- Updated to highlight the changes in grade table-->
			<!-- <xsl:value-of select="normalize-space(comment/p)"/> --> 
				<xsl:apply-templates select="comment/p/node()"></xsl:apply-templates>
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>
	
</xsl:stylesheet>

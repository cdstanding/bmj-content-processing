<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:oak="http://schema.bmj.com/delivery/oak"
    xmlns:bt="http://schema.bmj.com/delivery/oak-bt"
    xmlns:bp="http://schema.bmj.com/delivery/oak-bp"
    xmlns:ce="http://schema.bmj.com/delivery/oak-ce"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0"
    exclude-result-prefixes="oak ce bt bp xs xsl xsi xlink">

	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"/>
    
	<xsl:param name="proof">draft</xsl:param>
	<xsl:param name="xmlns" >ce</xsl:param>
	<xsl:param name="lang"/>
	<xsl:param name="strings-variant-fileset"/>
	<xsl:param name="images-input"/>
	<xsl:param name="system"/>
	<xsl:param name="date"/>
    
	<xsl:include href="../generic-fo-fonts.xsl"/>
	<xsl:include href="../generic-fo-page-sizes.xsl"/>
	<xsl:include href="systematic-review-fo-params.xsl"/>
	<xsl:include href="../../generic-params.xsl"/>
	<xsl:include href="../../xsl-lib/strings/publication-labels-process-shared.xsl"/>
	
	<xsl:variable name="cid" select="substring-after(/oak:section/@id, '-')"/>
	
	<xsl:template match="/*">

		<xsl:element name="fo:root"  use-attribute-sets="root">
			
			<xsl:call-template name="process-layout-master-set"/>
			
			<xsl:element name="fo:page-sequence">
				
				<xsl:attribute name="master-reference">my-sequence</xsl:attribute>
				
				<xsl:call-template name="process-static-footer"/>
				
				<xsl:element name="fo:flow" use-attribute-sets="flow">
					
					<xsl:attribute name="flow-name">xsl-region-body</xsl:attribute>
					
					<xsl:element name="fo:block">
						<xsl:attribute name="id">first-page</xsl:attribute>
					</xsl:element>
					
					<xsl:element name="fo:block" use-attribute-sets="space-before">
						<!-- logo -->
						<xsl:element name="fo:block" use-attribute-sets="last-justify">
							<xsl:element name="fo:inline" use-attribute-sets="align-left">
								<xsl:element name="fo:external-graphic">
									<xsl:attribute name="width">334px</xsl:attribute>
									<xsl:attribute name="height ">33px</xsl:attribute>
									<xsl:attribute name="src">
										<xsl:text>url('</xsl:text>
										<xsl:value-of select="$images-input"/>
										<xsl:text>ce-logo</xsl:text>
										<xsl:if test="contains($system, 'docato')">
											<xsl:text>_default</xsl:text>
										</xsl:if>	
										<xsl:text>.gif</xsl:text>
										<xsl:text>')</xsl:text>
									</xsl:attribute>
								</xsl:element>
							</xsl:element>
						</xsl:element>
						
						<xsl:apply-templates select="*[name()!='person-group' and name()!='references' and name()!='table']"/>
						<!-- <xsl:call-template name="process-substantive-change-set"/> -->
						<xsl:apply-templates select="oak:references"/>
						<!-- <xsl:apply-templates select="oak:table"/> -->
						<xsl:apply-templates select="oak:person-group"/>
						
					</xsl:element>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:page-sequence">
				<xsl:attribute name="master-reference">my-sequence-landscape</xsl:attribute>
				<xsl:call-template name="process-static-footer"/>
				<xsl:element name="fo:flow" use-attribute-sets="flow">
					<xsl:attribute name="flow-name">xsl-region-body</xsl:attribute>
					<xsl:apply-templates select="oak:table"/>
					<xsl:element name="fo:block">
						<xsl:attribute name="id">last-page</xsl:attribute>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			
		</xsl:element>
	</xsl:template>
    
	<xsl:template name="process-static-footer">
		
		<xsl:element name="fo:static-content" use-attribute-sets="">
			<xsl:attribute name="flow-name">all-footer</xsl:attribute>
			
			<xsl:element name="fo:block">
				
				<xsl:element name="fo:inline">
					<xsl:attribute name="font-size">8pt</xsl:attribute>
					
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('copyright')"/>
					</xsl:call-template>
					
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:value-of select="substring-before($date, '-')"/>
					
					<xsl:text disable-output-escaping="yes">. </xsl:text>
					
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('rights')"/>
					</xsl:call-template>
					<xsl:text disable-output-escaping="yes">. </xsl:text>
					
					<xsl:text disable-output-escaping="yes">Generated:</xsl:text>
					<xsl:value-of select="$date"/>
					<xsl:text disable-output-escaping="yes">. </xsl:text>
					
					<xsl:text disable-output-escaping="yes">Page </xsl:text>
					<fo:page-number/>
					<xsl:text disable-output-escaping="yes"> of </xsl:text>
					<fo:page-number-citation ref-id="last-page"/>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
	</xsl:template>
    
	<xsl:attribute-set name="root">
		<xsl:attribute name="font-family" select="$body.font.family"/>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="text-align" select="$text-align"/>
		<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
		<xsl:attribute name="hyphenate" select="$hyphenate"/>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="rtf-huge">
		<xsl:attribute name="font-size">22pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="extra-large">
		<xsl:attribute name="font-size">13pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table-borders-thin">
		<xsl:attribute name="border-width">1px</xsl:attribute>
		<xsl:attribute name="border-style">solid</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="metadata">
		<xsl:attribute name="color">#CCCCCC</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="border-bottom">1pt</xsl:attribute>
		<xsl:attribute name="border-bottom-color">#CCCCCC</xsl:attribute>
		<xsl:attribute name="border-bottom-style">dotted</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="space-before-big">
		<xsl:attribute name="space-before.minimum">10pt</xsl:attribute>
		<xsl:attribute name="space-before.maximum">25pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">15pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="space-after-big">
		<xsl:attribute name="space-after.minimum">10pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">25pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">15pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="color-dark-green">
		<xsl:attribute name="color">#33715A</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="background-dark-green">
		<xsl:attribute name="background-color">#33715A</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="color-dark-blue">
		<xsl:attribute name="color">#0055A5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="background-dark-blue">
		<xsl:attribute name="background-color">#0055A5</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="process-layout-master-set">
		
		<xsl:comment>layout-master-set</xsl:comment>
		
		<xsl:element name="fo:layout-master-set">
			
			<xsl:element name="fo:simple-page-master" use-attribute-sets="page-margin page-orientation-portrait">
				<xsl:attribute name="master-name">first-page</xsl:attribute>
				<xsl:element name="fo:region-body" use-attribute-sets="body-margin">
					<xsl:attribute name="region-name">xsl-region-body</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-before">
					<xsl:attribute name="region-name">first-header</xsl:attribute>
					<xsl:attribute name="extent">0pt</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-after" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-footer</xsl:attribute>
				</xsl:element>
				
				<xsl:element name="fo:region-start" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-left</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-end" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-right</xsl:attribute>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:simple-page-master" use-attribute-sets="page-margin page-orientation-portrait">
				<xsl:attribute name="master-name">all-pages</xsl:attribute>
				<xsl:element name="fo:region-body" use-attribute-sets="body-margin">
					<xsl:attribute name="region-name">xsl-region-body</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-before" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-header</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-after" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-footer</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-start" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-left</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-end" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-right</xsl:attribute>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:simple-page-master" use-attribute-sets="page-margin page-orientation-landscape">
				<xsl:attribute name="master-name">landscape-pages</xsl:attribute>
				<xsl:element name="fo:region-body" use-attribute-sets="body-margin">
					<xsl:attribute name="region-name">xsl-region-body</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-before" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-header</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-after" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-footer</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-start" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-left</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:region-end" use-attribute-sets="region-extent">
					<xsl:attribute name="region-name">all-right</xsl:attribute>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:page-sequence-master" use-attribute-sets="">
				<xsl:attribute name="master-name">my-sequence</xsl:attribute>
				<xsl:element name="fo:single-page-master-reference" use-attribute-sets="">
					<xsl:attribute name="master-reference">first-page</xsl:attribute>
				</xsl:element>
				<xsl:element name="fo:repeatable-page-master-reference" use-attribute-sets="">
					<xsl:attribute name="master-reference">all-pages</xsl:attribute>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:page-sequence-master" use-attribute-sets="">
				<xsl:attribute name="master-name">my-sequence-landscape</xsl:attribute>
				<xsl:element name="fo:repeatable-page-master-reference" use-attribute-sets="">
					<xsl:attribute name="master-reference">landscape-pages</xsl:attribute>
				</xsl:element>
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>

	<!-- not used now -->
	<xsl:template name="process-substantive-change-set">
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:element name="fo:block" use-attribute-sets="strong color-blue extra-large space-before">
				<xsl:value-of select="translate('substantive-change', $lower, $upper)"/>
			</xsl:element>
			
			<xsl:element name="fo:list-block">
				
				<xsl:for-each select="//*:section[@class='option']/*:section[@class='substantive-change-set']/*:p">
					
					<xsl:element name="fo:list-item">
						<xsl:element name="fo:list-item-label">
							<xsl:attribute name="end-indent">30pt</xsl:attribute>
							<xsl:element name="fo:block">
								<xsl:text>&#x2022;</xsl:text>
							</xsl:element>
						</xsl:element>
						<xsl:element name="fo:list-item-body">
							<xsl:attribute name="start-indent">30pt</xsl:attribute>
							<xsl:element name="fo:block">
								<xsl:apply-templates />
							</xsl:element>
						</xsl:element>
					</xsl:element>
					
				</xsl:for-each>
				
			</xsl:element>			
			
		</xsl:element>
		
	</xsl:template>

	<xsl:template match="oak:title">
		<xsl:choose>
			<!-- first article section title -->
			<xsl:when test="count(ancestor::oak:section) = 1">
				<xsl:comment>debug 1</xsl:comment>
				<xsl:element name="fo:block" use-attribute-sets="strong rtf-huge  space-before space-after">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:when>
			
			<!-- header greater than h6 level -->
			<xsl:when test="count(ancestor::oak:section[oak:title]) &gt; 7">
				<xsl:comment>class:<xsl:value-of select="parent::oak:section/@class"></xsl:value-of> debug 2</xsl:comment>
				<xsl:variable name="class"><xsl:value-of select="parent::oak:section/@class"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="$class='comparators' 
						and count(parent::oak:section//oak:p) = 0
						">
						<xsl:comment>Not display title as no content - p count:<xsl:value-of select="count(parent::oak:section//oak:p)"/></xsl:comment>
					</xsl:when>
					<xsl:when test="$class='comment-other'
						and count(parent::oak:section/parent::oak:section/oak:section[@class='comparators']//oak:p) = 0 
						">
						<xsl:comment>Not display title as no content for intervention - p count:<xsl:value-of select="count(parent::oak:section/parent::oak:section/oak:section[@class='comparators']//oak:p)"/></xsl:comment>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="fo:block" use-attribute-sets="strong">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:when>
			
			<xsl:when test="$xmlns='ce'">
				<xsl:comment>class:<xsl:value-of select="parent::oak:section/@class"></xsl:value-of> debug 3</xsl:comment>
				<xsl:variable name="class"><xsl:value-of select="parent::oak:section/@class"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="$class = 'questions-summary'">
						<xsl:comment>debug 3 A</xsl:comment>
						<xsl:element name="fo:block" use-attribute-sets="strong background-black color-white huge align-center space-before space-after">
							<xsl:value-of select="translate(., $lower, $upper)"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$class = 'interventions-summary'">
						<xsl:comment>debug 3 B</xsl:comment>
						<xsl:element name="fo:block" use-attribute-sets="strong background-blue color-white huge align-center space-before space-after">
							<xsl:value-of select="translate(., $lower, $upper)"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$class = 'beneficial'
						or $class = 'likely-to-be-beneficial'
						or $class = 'trade-off-between-benefits-and-harms'
						or $class = 'unknown-effectiveness'
						or $class = 'unlikely-to-be-beneficial'
						or $class = 'likely-to-be-ineffective-or-harmful'
						">
						<xsl:comment>debug 3 C</xsl:comment>
						<xsl:element name="fo:block" use-attribute-sets="space-before-large space-after-large">
							<xsl:element name="fo:inline" use-attribute-sets="align-left">
								<xsl:element name="fo:external-graphic">
									<xsl:attribute name="width">20px</xsl:attribute>
									<xsl:attribute name="height ">10px</xsl:attribute>
									<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
									<xsl:attribute name="content-height ">scale-to-fit</xsl:attribute>
									<xsl:attribute name="scaling ">uniform</xsl:attribute>
									<xsl:attribute name="src">
										<xsl:text>url('</xsl:text>
										<xsl:value-of select="$images-input"/>
										<xsl:value-of select="$class"/>
										<xsl:if test="contains($system, 'docato')">
											<xsl:text>_default</xsl:text>
										</xsl:if>	
										<xsl:text>.gif</xsl:text>
										<xsl:text>')</xsl:text>
									</xsl:attribute>
								</xsl:element>
							</xsl:element>
							<xsl:element name="fo:inline" use-attribute-sets="strong color-blue large space-before space-after">
								<xsl:value-of select="translate(., $lower, $upper)"/>
							</xsl:element>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$class = 'key-point-list'
						or $class = 'background'
						or $class = 'summary-statement'
						or $class = 'not-given'
						or $class = 'benefits'
						or $class = 'harms'
						or $class = 'comment'
						or $class = 'substantive-change-set'
						or $class = 'substantive-change-list'
						or $class = 'disclaimer'
						or $class = 'notes'
						or $class = 'key-points'
						or $class = 'comparison-set'
						or $class = 'reference-notes'
						or $class = 'future-issues'
						">
						<xsl:comment>debug 3 D</xsl:comment>
						<xsl:element name="fo:block" use-attribute-sets="strong color-blue extra-large space-before">
							<xsl:value-of select="translate(., $lower, $upper)"/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$class = 'clinical-context'">
						<xsl:comment>debug 3 D</xsl:comment>
						<xsl:element name="fo:block" use-attribute-sets="strong color-blue huge space-before">
					
							<xsl:value-of select="translate(., $lower, $upper)"/>
						</xsl:element>
						</xsl:when>
					<xsl:when test="$class = 'question'">
						<xsl:choose>
							<xsl:when test="ancestor::oak:section[@class='interventions-summary']">
								<xsl:comment>debug 3 E</xsl:comment>
								<xsl:element name="fo:block"  use-attribute-sets="strong extra-large space-before space-after">
									<xsl:apply-templates/>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:comment>debug 3 F</xsl:comment>
								<xsl:element name="fo:block" use-attribute-sets="strong background-black color-white space-before">
									<xsl:text>QUESTION</xsl:text>
								</xsl:element>
								<xsl:element name="fo:block" use-attribute-sets="background-grey strong keep-with-next space-after">
									<xsl:value-of select="translate(., $lower, $upper)"/>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$class = 'option'">
						<xsl:comment>debug 3 G</xsl:comment>
						<xsl:element name="fo:block" use-attribute-sets="strong background-black color-white space-before">
							<xsl:text>OPTION</xsl:text>
						</xsl:element>
						<xsl:element name="fo:block" use-attribute-sets="background-tinted-blue strong color-blue keep-with-next space-after">
							<xsl:value-of select="translate(., $lower, $upper)"/>
						</xsl:element>
						<xsl:element name="fo:block" use-attribute-sets="strong extra-large space-after">
							<xsl:text>INTERVENTION EFFICACY: </xsl:text>
							<xsl:value-of select="parent::oak:section/oak:metadata/oak:key[@*:name='intervention-efficacy']/@value"/>
						</xsl:element>						
					</xsl:when>
					<xsl:when test="$class = 'section'
						or $class = 'comparison'">
						<xsl:comment>debug 3 H</xsl:comment>
						<xsl:element name="fo:block"  use-attribute-sets="strong large space-after space-before">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$class = 'grade' or $class = 'adverse-effects'">
						<xsl:comment>debug 3 I</xsl:comment>
						<xsl:element name="fo:block" use-attribute-sets="strong color-blue large space-before">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:when>
					<!-- do nothing -->
					<xsl:when test="$class = 'pico-set'">
						<xsl:comment>debug 3 K</xsl:comment>
					</xsl:when>
					<xsl:otherwise>
						<xsl:comment>debug 3 Z</xsl:comment>
						<xsl:element name="fo:block" use-attribute-sets="strong extra-large">
							<xsl:apply-templates/>
						</xsl:element>						
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
			<!-- all other headers -->
			<xsl:otherwise>
				<xsl:comment>debug 4</xsl:comment>
				<xsl:element name="fo:block" use-attribute-sets="keep-with-next space-after border-top-black">
					<xsl:element name="fo:inline" use-attribute-sets="background-black">
						<xsl:element name="fo:inline" use-attribute-sets="color-white background-black default-padding strong">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
			
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="oak:section">
		<xsl:variable name="class" select="@class"/>
		<xsl:choose>
			<xsl:when test="$class = 'reference-no-data'">
				<xsl:if test="string-length(normalize-space(.))!=0">
					<xsl:element name="fo:block">
						<xsl:if test="@id">
							<xsl:attribute name="id" select="@id"/>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="count(./oak:p//oak:link) > 1">
								<xsl:comment>TODO CONVERT INTO PLURAL link count:<xsl:value-of select="count(./oak:p//oak:link)"/></xsl:comment>
								<xsl:element name="fo:block" use-attribute-sets="p">
									<xsl:if test="@id">
										<xsl:attribute name="id" select="@id"/>
									</xsl:if>
									No data from the following references on this outcome.
									<xsl:for-each select="./oak:p/oak:link">
										<xsl:apply-templates select="."/>	
									</xsl:for-each>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates/>								
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$class = 'pico-set'">
				<xsl:comment>debug 3 K</xsl:comment>
				<xsl:element name="fo:block" use-attribute-sets="space-before-big">
					<xsl:comment>spacer</xsl:comment>
				</xsl:element>
				<xsl:element name="fo:table-and-caption" use-attribute-sets="space-after-large space-before-large">
					<xsl:element name="fo:table" use-attribute-sets="space-after-large space-before-large table-borders-thin">
						<xsl:element name="fo:table-column"><xsl:attribute name="column-width">46pt</xsl:attribute></xsl:element>
						<xsl:element name="fo:table-column"><xsl:attribute name="column-width">91pt</xsl:attribute></xsl:element>
						<xsl:element name="fo:table-column"><xsl:attribute name="column-width">136pt</xsl:attribute></xsl:element>
						<xsl:element name="fo:table-column"><xsl:attribute name="column-width">91pt</xsl:attribute></xsl:element>
						<xsl:element name="fo:table-column"><xsl:attribute name="column-width">46pt</xsl:attribute></xsl:element>
						<xsl:element name="fo:table-column"><xsl:attribute name="column-width">46pt</xsl:attribute></xsl:element>
						<xsl:element name="fo:table-body">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:when>
					<xsl:when test="$class = 'clinical-context'">				
			
			<xsl:element name="fo:block" use-attribute-sets="strong color-blue space-before space-after rtf-huge">
				<xsl:value-of select="./title"></xsl:value-of>
			</xsl:element>
			<xsl:element name="fo:block">
				<xsl:apply-templates/>			
		</xsl:element>
						
				
			</xsl:when>
			<!-- first table row -->
			<xsl:when test="$class = 'pico-first'">
				
				<!-- table header for pic-first -->
				<xsl:element name="fo:table-row"  use-attribute-sets="strong background-dark-green color-white">
					<xsl:for-each select="./oak:section">
						<fo:table-cell padding-start="3pt" padding-end="3pt" padding-before="3pt" padding-after="3pt">
							<fo:block>
								<xsl:attribute name="font-size">8pt</xsl:attribute>
								<xsl:apply-templates select="./oak:title"/>
							</fo:block>
						</fo:table-cell>				
					</xsl:for-each>
				</xsl:element>
				
				<!--parent pico-set title-->
				<xsl:element name="fo:table-row" use-attribute-sets="strong background-dark-blue color-white keep-with-next">
					<fo:table-cell padding-start="3pt" padding-end="3pt" padding-before="3pt" padding-after="3pt" number-columns-spanned="6">
						<xsl:element name="fo:block"  >
							<xsl:attribute name="font-size">8pt</xsl:attribute>
							<xsl:attribute name="id" select="@id"/>
							<xsl:value-of select="parent::oak:section/oak:title"/>
						</xsl:element>
					</fo:table-cell>				
				</xsl:element>
				
				<xsl:element name="fo:table-row">
					<xsl:for-each select="./oak:section">
						<xsl:variable name="local-class" select="@class"/>
						<xsl:comment>sec class:<xsl:value-of select="$local-class"/></xsl:comment>
						<xsl:variable name="eff-class-value" select=".//oak:key/@value"/>
						<xsl:choose>
							<!-- add linking image -->
							<xsl:when test="$eff-class-value = 'small'
								or $eff-class-value = 'moderate'
								or $eff-class-value = 'large'
								or $eff-class-value = 'not-calculated'
								or $eff-class-value = 'not-significant'
								">
								<fo:table-cell padding-start="3pt" padding-end="3pt" padding-before="3pt" padding-after="3pt">
									<fo:block>
										<xsl:attribute name="font-size">8pt</xsl:attribute>
										<xsl:call-template name="add-eff-image">
											<xsl:with-param name="eff-value" select="$eff-class-value"/>
										</xsl:call-template>
									</fo:block>
								</fo:table-cell>				
							</xsl:when>
							<xsl:when test="$local-class = 'absolute-results'">
							<!-- need to keep the titles in these secs -->
								<fo:table-cell padding-start="3pt" padding-end="3pt" padding-before="3pt" padding-after="3pt">
									<fo:block>
										<xsl:attribute name="font-size">8pt</xsl:attribute>
										<xsl:apply-templates select="./oak:section"/>
									</fo:block>
								</fo:table-cell>				
							</xsl:when>
							<xsl:otherwise>
								<fo:table-cell padding-start="3pt" padding-end="3pt" padding-before="3pt" padding-after="3pt">
									<fo:block>
										<xsl:attribute name="font-size">8pt</xsl:attribute>
										<xsl:apply-templates select=".//oak:p"/>
									</fo:block>
								</fo:table-cell>				
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			
			<!-- table row -->
			<xsl:when test="$class = 'pico'">
				
				<xsl:variable name="position">
					<xsl:variable name="generate-id" select="generate-id()" />
					<xsl:for-each select="parent::oak:section/oak:section">
						<xsl:if test="generate-id()=$generate-id">
							<xsl:value-of select="position()" />
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				
				<!--parent pico-set title-->
				<xsl:if test="$position=1">
					
					<xsl:element name="fo:table-row" use-attribute-sets="strong background-dark-blue color-white keep-with-next">
						<fo:table-cell padding-start="3pt" padding-end="3pt" padding-before="3pt" padding-after="3pt" number-columns-spanned="6">
							<xsl:element name="fo:block"  >
								<xsl:attribute name="font-size">8pt</xsl:attribute>
								<xsl:attribute name="id" select="@id"/>
								<xsl:value-of select="parent::oak:section/oak:title"/>
							</xsl:element>
						</fo:table-cell>				
					</xsl:element>
					
				</xsl:if>
				
				<xsl:element name="fo:table-row">
					<xsl:for-each select="./oak:section">
						<xsl:variable name="local-class" select="@class"/>
						<xsl:comment>sec class:<xsl:value-of select="$local-class"/></xsl:comment>
						<xsl:variable name="eff-class-value" select=".//oak:key/@value"/>
						<xsl:choose>
							<!-- add linking image -->
							<xsl:when test="$eff-class-value = 'small'
								or $eff-class-value = 'moderate'
								or $eff-class-value = 'large'
								or $eff-class-value = 'not-calculated'
								or $eff-class-value = 'not-significant'
								">
								<fo:table-cell padding-start="3pt" padding-end="3pt" padding-before="3pt" padding-after="3pt">
									<fo:block>
										<xsl:attribute name="font-size">8pt</xsl:attribute>
										<xsl:call-template name="add-eff-image">
											<xsl:with-param name="eff-value" select="$eff-class-value"/>
										</xsl:call-template>
									</fo:block>
								</fo:table-cell>				
							</xsl:when>
							<xsl:when test="$local-class = 'absolute-results'">
								<!-- need to keep the titles in these secs -->
								<fo:table-cell padding-start="3pt" padding-end="3pt" padding-before="3pt" padding-after="3pt">
									<fo:block>
										<xsl:attribute name="font-size">8pt</xsl:attribute>
										<xsl:apply-templates select="./oak:section"/>
									</fo:block>
								</fo:table-cell>				
							</xsl:when>
							<xsl:otherwise>
								<fo:table-cell padding-start="3pt" padding-end="3pt" padding-before="3pt" padding-after="3pt">
									<fo:block>
										<xsl:attribute name="font-size">8pt</xsl:attribute>
										<xsl:apply-templates select=".//oak:p"/>
									</fo:block>
								</fo:table-cell>				
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="string-length(normalize-space(.))!=0">
					<xsl:element name="fo:block">
						<xsl:if test="@id">
							<xsl:attribute name="id" select="@id"/>
						</xsl:if>
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="add-eff-image">
		<xsl:param name="eff-value" />
		<xsl:element name="fo:basic-link">
			<xsl:attribute name="internal-destination">g-<xsl:value-of select="$eff-value"/></xsl:attribute>
			<xsl:element name="fo:external-graphic">
				<xsl:attribute name="width">24px</xsl:attribute>
				<xsl:attribute name="height ">8px</xsl:attribute>
				<xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
				<xsl:attribute name="content-height ">scale-to-fit</xsl:attribute>
				<xsl:attribute name="scaling ">uniform</xsl:attribute>
				<xsl:attribute name="src">
					<xsl:text>url('</xsl:text>
					<xsl:value-of select="$images-input"/>
					<xsl:choose>
						<xsl:when test="$eff-value = 'small'"><xsl:text>icon-effect-small</xsl:text></xsl:when>
						<xsl:when test="$eff-value = 'moderate'"><xsl:text>icon-effect-moderate</xsl:text></xsl:when>
						<xsl:when test="$eff-value = 'large'"><xsl:text>icon-effect-large</xsl:text></xsl:when>
						<xsl:when test="$eff-value = 'not-calculated'"><xsl:text>icon-effect-no-size</xsl:text></xsl:when>
						<xsl:when test="$eff-value = 'not-significant'"><xsl:text>icon-effect-no-diff</xsl:text></xsl:when>
					</xsl:choose>
					<xsl:if test="contains($system, 'docato')"><xsl:text>_default</xsl:text></xsl:if>	
					<xsl:text>.gif</xsl:text>
					<xsl:text>')</xsl:text>
				</xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="oak:metadata">
		<xsl:choose>
			<xsl:when test="ancestor::oak:section[@class='interventions-summary']">
				<xsl:comment>not showing metadata</xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="fo:block"  use-attribute-sets="metadata space-before space-after">
					<xsl:element name="fo:block">
						<xsl:element name="fo:block"> 
							<xsl:text>metadata</xsl:text>
						</xsl:element>
						<xsl:element name="fo:list-block">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="oak:key">
		<xsl:comment>DEBUUG KEY</xsl:comment>
		<xsl:element name="fo:list-item">
			<xsl:element name="fo:list-item-label">
				<xsl:attribute name="end-indent">30pt</xsl:attribute>
				<xsl:element name="fo:block">
					<xsl:text>&#x2022;</xsl:text>
				</xsl:element>
			</xsl:element>
			<xsl:element name="fo:list-item-body">
				<xsl:attribute name="start-indent">30pt</xsl:attribute>
				<xsl:element name="fo:block">
					<xsl:value-of select="@*:name"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="@value"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="oak:abstract">
		<xsl:element name="fo:block">
			<xsl:element name="fo:block" use-attribute-sets="strong color-blue huge space-before space-after">
				<xsl:text>ABSTRACT</xsl:text>
			</xsl:element>
			<xsl:element name="fo:block">
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="oak:p">
		<xsl:if test="string-length(normalize-space(.))!=0 or element()">
			<xsl:element name="fo:block" use-attribute-sets="p">
				<xsl:if test="@id">
					<xsl:attribute name="id" select="@id"/>
				</xsl:if>
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="oak:list">
		<xsl:if test="count(.//oak:li) > 0">
			<xsl:element name="fo:block">
				<xsl:element name="fo:list-block">
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="oak:li">
		
		<xsl:element name="fo:list-item">
			
			<xsl:if test="@id">
				<xsl:attribute name="id" select="@id"/>
			</xsl:if>
			
			<!-- TODO pick right style of  list -->
			<xsl:element name="fo:list-item-label">
				<xsl:attribute name="end-indent">30pt</xsl:attribute>
				<xsl:element name="fo:block" use-attribute-sets="p">
					<xsl:text>&#x2022;</xsl:text>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="fo:list-item-body">
				<xsl:attribute name="start-indent">30pt</xsl:attribute>
				<xsl:element name="fo:block" use-attribute-sets="p">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	

	<xsl:template match="oak:link">
		<xsl:variable name="target" select="@target"/>
		<xsl:variable name="target-id" select="substring-before(substring-after($target, ''''), '''')"/>
		<xsl:variable name="class" select="@class"/>
		<xsl:comment>link class:<xsl:value-of select="$class"/></xsl:comment>
		<xsl:choose>
			<xsl:when test="$class = 'gloss'
				or $class = 'table-link'
				or $class = 'question-link'
				or $class = 'option'
				or $class = 'option-link'
				or $class = 'table-link'
				or $class = 'table'
				">
				<xsl:element name="fo:basic-link">
					<xsl:attribute name="internal-destination">
						<xsl:choose>
							<xsl:when test="$target-id = ''"><xsl:value-of select="$target"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$target-id"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="color">blue</xsl:attribute>
					<xsl:attribute name="text-decoration">underline</xsl:attribute>
					<xsl:choose>
						<xsl:when test="string-length(normalize-space(.))!=0">
							<xsl:apply-templates/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>[link]</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:when>
			<xsl:when test="$class = 'systematic-review-link'
				or $class = 'pubmed-link'
				or $class = 'uri-link'
				">
				<xsl:element name="fo:basic-link">
					<xsl:attribute name="external-destination">
						<xsl:choose>
							<xsl:when test="contains($target, 'http') or contains($target, 'www')">
								<xsl:if test="starts-with($target, 'www')">
									<xsl:text>http://</xsl:text>
								</xsl:if>
								<xsl:value-of select="$target"/>
							</xsl:when>
							<xsl:when test="contains($target, '#xpointer(id(') and not(starts-with($target, '#xpointer(id('))">
								<xsl:variable name="filename" select="replace(substring-before($target, '#'), 'xml','html')"/>
								<xsl:if test="substring-before(substring-after($target, '('), '(') = 'id'">
									<xsl:value-of select="concat($filename, '#', $target-id)"/>
								</xsl:if>
							</xsl:when>
							<xsl:when test="starts-with($target, '#xpointer(id(')">
								<xsl:variable name="id" select="substring-before(substring-after($target, ''''), '''')"/>
								<xsl:value-of select="concat('#', $target-id)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('#', $target)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="color">blue</xsl:attribute>
					<xsl:attribute name="text-decoration">underline</xsl:attribute>
					<xsl:choose>
						<xsl:when test="string-length(normalize-space(.))!=0">
							<xsl:apply-templates/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>[link]</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:when>
			<xsl:when test="$class = 'reference'">
				<xsl:for-each select="//oak:reference">
					<xsl:if test="@id=$target-id">
						<xsl:element name="fo:basic-link">
							<xsl:attribute name="internal-destination"><xsl:value-of select="$target-id"/></xsl:attribute>
							<xsl:attribute name="color">blue</xsl:attribute>
							<xsl:attribute name="text-decoration">underline</xsl:attribute>
							<xsl:text>[</xsl:text>
							<xsl:value-of select="position()"/>
							<xsl:text>]</xsl:text>
						</xsl:element>						
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="oak:b">
		<fo:inline font-weight="bold">
			<xsl:apply-templates />
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="oak:i">
		<fo:inline font-style="italic">
			<xsl:apply-templates />
		</fo:inline>		
	</xsl:template>
	
	<xsl:template match="oak:br">
		<fo:block> </fo:block>
	</xsl:template>
	
	<xsl:template match="oak:span">
		<xsl:element name="fo:inline">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<!-- 
		span.comment-q-to-a                     { background-color:yellow; }
		span.comment-q-to-pr                    { background-color:yellow; }
		span.comment-q-to-ed                    { background-color:red; }
		span.comment-q-to-teched                { background-color:green; }
		span.comment-q-to-prod                  { background-color:aqua; }
		
		redline-insert		green text and green underline
		redline-delete		red text red strike through
		redline-comment	yellow background
		
	-->
	
	<xsl:template match="oak:inline">
		<xsl:variable name="class" select="@class"/>
		<xsl:comment>link class:<xsl:value-of select="$class"/></xsl:comment>
		<xsl:element name="fo:inline">
			<xsl:choose>
				<xsl:when test="$class = 'comment-q-to-a'
					or $class = 'comment-q-to-pr'
					">
					<xsl:attribute name="background-color">#FFFF00</xsl:attribute>
				</xsl:when>
				<xsl:when test="$class = 'comment-q-to-ed'">
					<xsl:attribute name="background-color">#FF0000</xsl:attribute>
				</xsl:when>
				<xsl:when test="$class = 'comment-q-to-teched'">
					<xsl:attribute name="background-color">#00FF00</xsl:attribute>
				</xsl:when>
				<xsl:when test="$class = 'comment-q-to-prod'">
					<xsl:attribute name="background-color">#00FFFF</xsl:attribute>
				</xsl:when>
				<xsl:when test="$class = 'redline-insert'">
					<xsl:attribute name="color">#00FF00</xsl:attribute>
					<xsl:attribute name="text-decoration">underline</xsl:attribute>
				</xsl:when>
				<xsl:when test="$class = 'redline-delete'">
					<xsl:attribute name="color">#FF0000</xsl:attribute>
					<xsl:attribute name="text-decoration">line-through</xsl:attribute>
				</xsl:when>
				<xsl:when test="$class = 'redline-comment'">
					<xsl:attribute name="background-color">#FFFF00</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="oak:person-group">
		<xsl:element name="fo:block"  use-attribute-sets="align-right space-before">
			<xsl:element name="fo:block" use-attribute-sets="strong color-blue extra-large space-before space-after">
				<xsl:text>AUTHORS</xsl:text>
			</xsl:element>
			<xsl:apply-templates select="oak:person" />
			<xsl:apply-templates select="oak:notes" />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="oak:person">
		<xsl:element name="fo:block">
			<xsl:element name="fo:block" use-attribute-sets="p strong">
				<xsl:apply-templates select="oak:prefix"/>
				<xsl:apply-templates select="oak:given-names"/>
				<xsl:apply-templates select="oak:family-names"/>
				<xsl:apply-templates select="oak:honorific"/>
			</xsl:element>
			<xsl:apply-templates select="oak:address"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="oak:prefix | oak:given-names | oak:family-names">
		<xsl:apply-templates/>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="oak:honorific">
		<xsl:element name="fo:inline">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="oak:address">
		<xsl:element name="fo:block">
			<xsl:apply-templates select="parent::oak:person/oak:role"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="oak:role">
		<xsl:element name="fo:block" use-attribute-sets="p">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="oak:notes">
		<xsl:element name="fo:block" use-attribute-sets="align-left space-before">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="oak:date">
		<xsl:element name="fo:inline">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="oak:datetime">
		<xsl:element name="fo:inline">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="oak:gloss">
		
		<xsl:if test="not(preceding-sibling::oak:gloss) and count(ancestor-or-self::*)=2">
			<xsl:element name="fo:block" use-attribute-sets="strong color-blue extra-large space-before space-after">
				<xsl:text>GLOSSARY</xsl:text>
			</xsl:element>
			
			<!-- small'
				or $eff-class-value = 'moderate'
				or $eff-class-value = 'large'
				or $eff-class-value = 'not-calculated'
				or $eff-class-value = 'not-significant 
			
			<xsl:when test="$eff-value = 'small'"><xsl:text>icon-effect-small</xsl:text></xsl:when>
			<xsl:when test="$eff-value = 'moderate'"><xsl:text>icon-effect-moderate</xsl:text></xsl:when>
			<xsl:when test="$eff-value = 'large'"><xsl:text>icon-effect-large</xsl:text></xsl:when>
			<xsl:when test="$eff-value = 'not-calculated'"><xsl:text>icon-effect-no-size</xsl:text></xsl:when>
			<xsl:when test="$eff-value = 'not-significant'"><xsl:text>icon-effect-no-diff</xsl:text></xsl:when>
			
			-->
			
			<xsl:element name="fo:block"  use-attribute-sets="space-before space-after">
				<xsl:element name="fo:block">
					<xsl:attribute name="id" >g-small</xsl:attribute>
					<fo:inline>
						<xsl:element name="fo:external-graphic">
							<xsl:attribute name="src">
								<xsl:text>url('</xsl:text>
								<xsl:value-of select="$images-input"/><xsl:text>icon-effect-small</xsl:text>
								<xsl:if test="contains($system, 'docato')"><xsl:text>_default</xsl:text></xsl:if>	
								<xsl:text>.gif</xsl:text>
								<xsl:text>')</xsl:text>
							</xsl:attribute>
						</xsl:element>
					</fo:inline>
					<xsl:text disable-output-escaping="yes"> Difference is significant, with RR/OR/HR </xsl:text>&lt;<xsl:text disable-output-escaping="yes">=2 or RR/OR/HR </xsl:text>&gt;<xsl:text disable-output-escaping="yes">=0.5</xsl:text>
				</xsl:element>
			</xsl:element>
			<xsl:element name="fo:block"  use-attribute-sets="space-before space-after">
				<xsl:element name="fo:block">
					<xsl:attribute name="id" >g-moderate</xsl:attribute>
					<fo:inline>
						<xsl:element name="fo:external-graphic">
							<xsl:attribute name="src">
								<xsl:text>url('</xsl:text>
								<xsl:value-of select="$images-input"/><xsl:text>icon-effect-moderate</xsl:text>
								<xsl:if test="contains($system, 'docato')"><xsl:text>_default</xsl:text></xsl:if>	
								<xsl:text>.gif</xsl:text>
								<xsl:text>')</xsl:text>
							</xsl:attribute>
						</xsl:element>
					</fo:inline>
					<xsl:text disable-output-escaping="yes"> Difference is significant, with RR/OR/HR </xsl:text>&gt;<xsl:text disable-output-escaping="yes">2 or RR/OR/HR </xsl:text>&lt;<xsl:text disable-output-escaping="yes">0.5</xsl:text>
				</xsl:element>
			</xsl:element>
			<xsl:element name="fo:block"  use-attribute-sets="space-before space-after">
				<xsl:element name="fo:block">
					<xsl:attribute name="id" >g-large</xsl:attribute>
					<fo:inline>
						<xsl:element name="fo:external-graphic">
							<xsl:attribute name="src">
								<xsl:text>url('</xsl:text>
								<xsl:value-of select="$images-input"/><xsl:text>icon-effect-large</xsl:text>
								<xsl:if test="contains($system, 'docato')"><xsl:text>_default</xsl:text></xsl:if>	
								<xsl:text>.gif</xsl:text>
								<xsl:text>')</xsl:text>
							</xsl:attribute>
						</xsl:element>
					</fo:inline>
					<xsl:text disable-output-escaping="yes"> Difference is significant, with RR/OR/HR </xsl:text>&gt;<xsl:text disable-output-escaping="yes">5 or RR/OR/HR </xsl:text>&lt;<xsl:text disable-output-escaping="yes">0.2</xsl:text>
				</xsl:element>
			</xsl:element>
			<xsl:element name="fo:block"  use-attribute-sets="space-before space-after">
				<xsl:element name="fo:block">
					<xsl:attribute name="id" >g-not-calculated</xsl:attribute>
					<fo:inline>
						<xsl:element name="fo:external-graphic">
							<xsl:attribute name="src">
								<xsl:text>url('</xsl:text>
								<xsl:value-of select="$images-input"/><xsl:text>icon-effect-no-size</xsl:text>
								<xsl:if test="contains($system, 'docato')"><xsl:text>_default</xsl:text></xsl:if>	
								<xsl:text>.gif</xsl:text>
								<xsl:text>')</xsl:text>
							</xsl:attribute>
						</xsl:element>
					</fo:inline>
					<xsl:text disable-output-escaping="yes"> Difference is significant and only P value is reported, or difference is reported as significant but no RR/OR/HR is reported</xsl:text>
				</xsl:element>
			</xsl:element>
			<xsl:element name="fo:block"  use-attribute-sets="space-before space-after">
				<xsl:element name="fo:block">
					<xsl:attribute name="id" >g-not-significant</xsl:attribute>
					<fo:inline>
						<xsl:element name="fo:external-graphic">
							<xsl:attribute name="src">
								<xsl:text>url('</xsl:text>
								<xsl:value-of select="$images-input"/><xsl:text>icon-effect-no-diff</xsl:text>
								<xsl:if test="contains($system, 'docato')"><xsl:text>_default</xsl:text></xsl:if>	
								<xsl:text>.gif</xsl:text>
								<xsl:text>')</xsl:text>
							</xsl:attribute>
						</xsl:element>
					</fo:inline>
					<xsl:text disable-output-escaping="yes"> Difference is not significant, with non-significant P value, or RR/OR/HR, or difference is reported as not significant and no statistical data are given</xsl:text>
				</xsl:element>
			</xsl:element>
		</xsl:if>
		
		<xsl:element name="fo:block"  use-attribute-sets="space-before space-after">
			<xsl:element name="fo:block">
				<xsl:attribute name="id" select="@id"/>
				<fo:inline font-weight="bold">
					<xsl:apply-templates select="oak:p[@class='term']/node()"/>	
				</fo:inline>
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:apply-templates select="oak:p[@class='definition']/node()"/>
			</xsl:element>
		</xsl:element>
	
	</xsl:template>
	
	<xsl:template match="oak:references">
		<xsl:element name="fo:block" use-attribute-sets="strong color-blue extra-large space-before space-after">
			<xsl:text>REFERENCES</xsl:text>
		</xsl:element>
		<xsl:for-each select="./oak:reference">
			<xsl:element name="fo:block" use-attribute-sets="space-after space-before">
					<xsl:attribute name="id" select="@id"/>
					<xsl:element name="fo:inline">	
						<fo:inline font-weight="bold"><xsl:number value="position()" format="1" /><xsl:text>.</xsl:text></fo:inline><xsl:text disable-output-escaping="yes"> </xsl:text>
						<xsl:for-each select="oak:p">
							<xsl:apply-templates select="node()"/>
							<xsl:text disable-output-escaping="yes"> </xsl:text>
						</xsl:for-each>
					</xsl:element>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="oak:figure[parent::oak:p]">
		<fo:inline><fo:external-graphic src="{@src}" /></fo:inline>
		<xsl:if test="oak:caption[string-length(normalize-space(.))!=0]">
			<fo:inline>
				<xsl:apply-templates select="oak:caption/node()"/>
			</fo:inline>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="oak:figure[not(parent::oak:p)]">
		<xsl:if test="not(preceding-sibling::oak:figure) and count(ancestor-or-self::*)=2">
			<xsl:element name="fo:block" use-attribute-sets="">
				<xsl:text>Figures</xsl:text>
			</xsl:element>
		</xsl:if>
		<xsl:element name="fo:block">
			<xsl:attribute name="id" select="@id"/>
			<fo:inline><fo:external-graphic src="{@image}" /></fo:inline>	
			<xsl:if test="oak:caption[string-length(normalize-space(.))!=0]">
				<fo:inline>
					<xsl:apply-templates select="oak:caption/node()"/>
				</fo:inline>
			</xsl:if>
		</xsl:element>
	</xsl:template>

	<xsl:template match="oak:table">
		
		<xsl:if test="not(preceding-sibling::oak:table) and count(ancestor-or-self::*)=2">
			<xsl:element name="fo:block" use-attribute-sets="strong color-blue extra-large space-before space-after">
				TABLES
			</xsl:element>
		</xsl:if>
		
		<xsl:element name="fo:block" use-attribute-sets="background-grey strong keep-with-next space-before-large">
			<xsl:attribute name="id" select="@id"/>
			<xsl:for-each select="./oak:caption/oak:p">
				<xsl:apply-templates select="node()"/>
				<xsl:text disable-output-escaping="yes"> </xsl:text>
			</xsl:for-each>
		</xsl:element>
		
		<xsl:element name="fo:table-and-caption" use-attribute-sets="space-after-large space-before-large">
			<xsl:element name="fo:table" use-attribute-sets="space-after-large space-before-large table-borders-thin">
				<xsl:choose>
					<xsl:when test="@border">
						<xsl:attribute name="border" select="@border"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="border">1</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:attribute name="width">100%</xsl:attribute>
				<xsl:call-template name="build-columns" />
				<xsl:element name="fo:table-body">
					<xsl:apply-templates select="./oak:thead" />
					<xsl:apply-templates select="./oak:tbody" />
					<xsl:apply-templates select="./oak:tfoot" />
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="build-columns">
		
		<!-- calc num of columns -->
		<xsl:param name="page-width-mm"><xsl:text>705</xsl:text></xsl:param>
		<!--<xsl:param name="cols"><xsl:value-of select="sum(.//oak:thead//oak:tr[1]//oak:td/@colspan)"/></xsl:param>-->
		<xsl:param name="cols">
			<xsl:variable name="cols">
				<xsl:for-each select="*:tbody/*:tr">
					<xsl:sort select="count(*:td)" />
					<xsl:element name="row-cell-count">
						<xsl:value-of select="count(*:td)" />
					</xsl:element>
				</xsl:for-each>
			</xsl:variable>
			<xsl:value-of select="$cols/row-cell-count[last()]" />
		</xsl:param>
		<xsl:param name="ave-width"><xsl:value-of select="($page-width-mm div $cols)"/></xsl:param>
		<xsl:param name="format-ave-width"><xsl:value-of select="format-number(($page-width-mm div $cols),'###')"/></xsl:param>
		
		<xsl:comment>page-width-mm:<xsl:value-of select="$page-width-mm"></xsl:value-of></xsl:comment>
		<xsl:comment>cols:<xsl:value-of select="$cols"></xsl:value-of></xsl:comment>
		<xsl:comment>ave-width:<xsl:value-of select="$ave-width"></xsl:value-of></xsl:comment>
		<xsl:comment>format-ave-width:<xsl:value-of select="$format-ave-width"></xsl:value-of></xsl:comment>
		
		<!-- create cols -->     
		<xsl:choose>
			<xsl:when test="$cols = 1 or $cols = 0">
				<xsl:call-template name="make-columns">
					<xsl:with-param name="max-cols">
						<xsl:value-of select="1"/>
					</xsl:with-param>
					<xsl:with-param name="current-col">
						<xsl:value-of select="0"/>
					</xsl:with-param>
					<xsl:with-param name="col-width">
						<xsl:value-of select="$page-width-mm"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="make-columns">
					<xsl:with-param name="max-cols">
						<xsl:value-of select="$cols"/>
					</xsl:with-param>
					<xsl:with-param name="current-col">
						<xsl:value-of select="0"/>
					</xsl:with-param>
					<xsl:with-param name="col-width">
						<xsl:value-of select="$format-ave-width"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="make-columns">
		<xsl:param name="max-cols" />
		<xsl:param name="current-col" />
		<xsl:param name="col-width" />
		
		<xsl:if test="number($current-col) &lt; number($max-cols)">
			
			<xsl:element name="fo:table-column">
				<xsl:attribute name="column-width"><xsl:value-of select="$col-width"/>pt</xsl:attribute>
			</xsl:element>
			
			<xsl:call-template name="make-columns">
				<xsl:with-param name="max-cols">
					<xsl:value-of select="$max-cols"/>
				</xsl:with-param>
				<xsl:with-param name="current-col">
					<xsl:value-of select="$current-col + 1"/>
				</xsl:with-param>
				<xsl:with-param name="col-width">
					<xsl:value-of select="$col-width"/>
				</xsl:with-param>
			</xsl:call-template>
			
		</xsl:if> 
	</xsl:template>
	
	<xsl:template match="oak:thead">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="oak:tr">
		<xsl:element name="fo:table-row"  use-attribute-sets="background-tinted-blue">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="oak:tbody">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="oak:tfoot">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="oak:td">
		<fo:table-cell 
			padding-start="3pt" padding-end="3pt"
			padding-before="3pt" padding-after="3pt">
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@border='1' or 
				ancestor::tr[@border='1'] or
				ancestor::thead[@border='1'] or
				ancestor::table[@border='1']">
				<xsl:attribute name="border-style">
					<xsl:text>solid</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="border-color">
					<xsl:text>black</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="border-width">
					<xsl:text>1pt</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<xsl:variable name="align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:choose>
							<xsl:when test="@align='center'">
								<xsl:text>center</xsl:text>
							</xsl:when>
							<xsl:when test="@align='right'">
								<xsl:text>end</xsl:text>
							</xsl:when>
							<xsl:when test="@align='justify'">
								<xsl:text>justify</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>start</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="ancestor::tr[@align]">
						<xsl:choose>
							<xsl:when test="ancestor::tr/@align='center'">
								<xsl:text>center</xsl:text>
							</xsl:when>
							<xsl:when test="ancestor::tr/@align='right'">
								<xsl:text>end</xsl:text>
							</xsl:when>
							<xsl:when test="ancestor::tr/@align='justify'">
								<xsl:text>justify</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>start</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="ancestor::thead">
						<xsl:text>center</xsl:text>
					</xsl:when>
					<xsl:when test="ancestor::table[@align]">
						<xsl:choose>
							<xsl:when test="ancestor::table/@align='center'">
								<xsl:text>center</xsl:text>
							</xsl:when>
							<xsl:when test="ancestor::table/@align='right'">
								<xsl:text>end</xsl:text>
							</xsl:when>
							<xsl:when test="ancestor::table/@align='justify'">
								<xsl:text>justify</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>start</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>start</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<fo:block text-align="{$align}" >
				<xsl:attribute name="font-size">9pt</xsl:attribute>
				<xsl:apply-templates select="*|text()"/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	exclude-result-prefixes="xi xsi cals rx"
	version="2.0">

	<xsl:param name="paper.type">A4</xsl:param>
	<xsl:param name="page.orientation">portrait</xsl:param>
	
	<xsl:param name="title-print-in-header">true</xsl:param>
	<xsl:param name="page-number-print-in-footer">true</xsl:param>
	<xsl:param name="citation-print-in-footer">true</xsl:param>
	<xsl:param name="hyphenate">true</xsl:param>
	<xsl:param name="writing-mode">lr-tb</xsl:param>
	<xsl:param name="text-align">start</xsl:param>
	<xsl:param name="indent">0</xsl:param>

	<xsl:attribute-set name="root">
		<xsl:attribute name="font-family" select="$body.font.family"/>
		<xsl:attribute name="font-size" select="$body.font.size"/>
		<xsl:attribute name="text-align" select="$text-align"/>
		<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
		<xsl:attribute name="hyphenate" select="$hyphenate"/>
		<!--xsl:attribute name="letter-spacing"></xsl:attribute-->
		<!--xsl:attribute name="word-spacing"></xsl:attribute-->
	</xsl:attribute-set>

	<xsl:attribute-set name="flow">
	</xsl:attribute-set>

	<xsl:attribute-set name="body">
	</xsl:attribute-set>

	<xsl:param name="bullet-icon">&#x2022;</xsl:param>
	<xsl:param name="glossary-icon"></xsl:param>
	<xsl:param name="change-start-icon"></xsl:param>
	<xsl:param name="change-end-icon"></xsl:param>
	<xsl:param name="url-icon"></xsl:param>

	<!-- use-attribute-sets for seperating formatting from fo xsl -->
	<xsl:attribute-set name="page-margin">
		<!-- page-width | page-height from generic-pdf-page-sizes.xsl -->
		<xsl:attribute name="page-width" select="$page.width"/>
		<xsl:attribute name="page-height" select="$page.height"/>
		<xsl:attribute name="margin-top">30pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">30pt</xsl:attribute>
		<xsl:attribute name="margin-left">40pt</xsl:attribute>
		<xsl:attribute name="margin-right">40pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="body-margin">
		<xsl:attribute name="margin">30pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="region-extent">
		<xsl:attribute name="extent">30pt</xsl:attribute>
	</xsl:attribute-set>
	<!-- are these used ? -->
	<xsl:param name="page-header-margin">35pt</xsl:param>
	<xsl:param name="page-footer-margin">35pt</xsl:param>
	
	<xsl:attribute-set name="default-margin">
		<xsl:attribute name="margin-top">2pt</xsl:attribute>
		<xsl:attribute name="margin-left">5pt</xsl:attribute>
		<xsl:attribute name="margin-right">5pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="default-padding">
		<xsl:attribute name="padding-top">2pt</xsl:attribute>
		<xsl:attribute name="padding-left">5pt</xsl:attribute>
		<xsl:attribute name="padding-right">5pt</xsl:attribute>
		<xsl:attribute name="padding-bottom">2pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="preview" use-attribute-sets="color-dark-grey">
		<xsl:attribute name="border">1pt</xsl:attribute>
		<xsl:attribute name="border-color">#777777</xsl:attribute>
		<xsl:attribute name="border-style">dotted</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="link">
		<!--<xsl:attribute name="text-decoration">underline</xsl:attribute>-->
		<xsl:attribute name="color">#0D519F</xsl:attribute>
		<xsl:attribute name="keep-together">auto</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="two-column">
		<xsl:attribute name="column-count">2</xsl:attribute>
		<xsl:attribute name="column-gap">0pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="two-column-gap">
		<xsl:attribute name="column-count">2</xsl:attribute>
		<xsl:attribute name="column-gap">10pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="running-head">
		<xsl:attribute name="reference-orientation">-90</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="page-break-before">
		<xsl:attribute name="break-before">page</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="border-top-black">
		<xsl:attribute name="border-top-color">#000000</xsl:attribute>
		<xsl:attribute name="border-top-style">solid</xsl:attribute>
		<xsl:attribute name="border-top-width">1pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="border-top-blue">
		<xsl:attribute name="border-top-color">#0D519F</xsl:attribute>
		<xsl:attribute name="border-top-style">solid</xsl:attribute>
		<xsl:attribute name="border-top-width">1pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="default-leader">
		<xsl:attribute name="leader-pattern">dots</xsl:attribute>
		<xsl:attribute name="leader-pattern-width">5pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hanging-indent">
		<xsl:attribute name="text-indent">-5pt</xsl:attribute>
		<xsl:attribute name="start-indent">5pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="preserve-linefeed">
		<xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="align-left">
		<xsl:attribute name="text-align">left</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="align-right">
		<xsl:attribute name="text-align">right</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="align-center">
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="align-justify">
		<xsl:attribute name="text-align">justify</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="last-right">
		<xsl:attribute name="text-align-last">right</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="last-justify">
		<xsl:attribute name="text-align-last">justify</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="space-before-large">
		<xsl:attribute name="space-before.minimum">5pt</xsl:attribute>
		<xsl:attribute name="space-before.maximum">30pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">10pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="space-after-large">
		<xsl:attribute name="space-after.minimum">5pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">30pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">10pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="space-before">
		<xsl:attribute name="space-before.minimum">5pt</xsl:attribute>
		<xsl:attribute name="space-before.maximum">20pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">10pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="space-after">
		<xsl:attribute name="space-after.minimum">5pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">20pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">10pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="space-before-small">
		<xsl:attribute name="space-before.minimum">2pt</xsl:attribute>
		<xsl:attribute name="space-before.maximum">8pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">4pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="space-after-small">
		<xsl:attribute name="space-after.minimum">2pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">8pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">4pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="space-before-tiny">
		<xsl:attribute name="space-before.minimum">1pt</xsl:attribute>
		<xsl:attribute name="space-before.maximum">3pt</xsl:attribute>
		<xsl:attribute name="space-before.optimum">2pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="space-after-tiny">
		<xsl:attribute name="space-after.minimum">1pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">3pt</xsl:attribute>
		<xsl:attribute name="space-after.optimum">2pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="flow-section-space-filler">
		<xsl:attribute name="space-after.minimum">0pt</xsl:attribute>
		<xsl:attribute name="space-after.maximum">200pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="ignore-white-space">
		<xsl:attribute name="xml:space">default</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="keep-together">
		<xsl:attribute name="keep-together">always</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="keep-with-previous">
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="keep-with-next">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="table">
		<xsl:attribute name="table-omit-header-at-break">false</xsl:attribute>
		<xsl:attribute name="table-omit-footer-at-break">false</xsl:attribute>
		<xsl:attribute name="table-layout">auto</xsl:attribute>
		<xsl:attribute name="width">100%</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="thead">
		<xsl:attribute name="vertical-align">bottom</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="tbody">
		<xsl:attribute name="vertical-align">top</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="tfoot">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="strong">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="keep-together">auto</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="em">
		<xsl:attribute name="font-style">italic</xsl:attribute>
		<xsl:attribute name="keep-together">auto</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="sub">
		<xsl:attribute name="baseline-shift">sub</xsl:attribute>
		<xsl:attribute name="font-size" select="$tiny.font.size"/>
		<xsl:attribute name="keep-together">auto</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="sup">
		<xsl:attribute name="baseline-shift">super</xsl:attribute>
		<xsl:attribute name="font-size" select="$tiny.font.size"/>
		<xsl:attribute name="keep-together">auto</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="tiny">
		<xsl:attribute name="font-size" select="$tiny.font.size"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="small">
		<xsl:attribute name="font-size" select="$small.font.size"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="large">
		<xsl:attribute name="font-size" select="$large.font.size"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="huge">
		<xsl:attribute name="font-size" select="$huge.font.size"/>
	</xsl:attribute-set>

	<!-- reflex-blue (100% cyan, 72% magenta, 6% black) -->
	<!-- specific clin-evid colours -->
	<xsl:attribute-set name="color-blue">
		<xsl:attribute name="color">#0D519F</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="background-blue">
		<xsl:attribute name="background-color">#0D519F</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="color-tinted-blue">
		<xsl:attribute name="color">#C5C9E6</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="background-tinted-blue">
		<xsl:attribute name="background-color">#C5C9E6</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="color-black">
		<xsl:attribute name="color">#000000</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="background-black">
		<xsl:attribute name="background-color">#000000</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="color-grey">
		<xsl:attribute name="color">#CCCCCC</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="background-grey">
		<xsl:attribute name="background-color">#CCCCCC</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="color-dark-grey">
		<xsl:attribute name="color">#777777</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="background-dark-grey">
		<xsl:attribute name="background-color">#777777</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="color-white">
		<xsl:attribute name="color">#FFFFFF</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="background-white">
		<xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="color-red">
		<xsl:attribute name="color">#FF0000</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="background-red">
		<xsl:attribute name="background-color">#FF0000</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="color-yellow">
		<xsl:attribute name="color">#FFFF00</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="background-yellow">
		<xsl:attribute name="background-color">#FFFF00</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="color-green">
		<xsl:attribute name="color">#00FF00</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="background-green">
		<xsl:attribute name="background-color">#00FF00</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="color-aqua">
		<xsl:attribute name="color">#00FFFF</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="background-aqua">
		<xsl:attribute name="background-color">#00FFFF</xsl:attribute>
	</xsl:attribute-set>
	  
	<xsl:attribute-set name="comment-q-to-a" use-attribute-sets="background-yellow default-padding">
		<xsl:attribute name="keep-together">auto</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="comment-q-to-pr" use-attribute-sets="background-yellow default-padding">
		<xsl:attribute name="keep-together">auto</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="comment-q-to-ed" use-attribute-sets="background-red default-padding">
		<xsl:attribute name="keep-together">auto</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="comment-q-to-teched" use-attribute-sets="background-green default-padding">
		<xsl:attribute name="keep-together">auto</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="comment-q-to-prod" use-attribute-sets="background-aqua default-padding">
		<xsl:attribute name="keep-together">auto</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="redline-insert" use-attribute-sets="color-green">
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
		<xsl:attribute name="keep-together">auto</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="redline-delete" use-attribute-sets="color-red">
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
		<xsl:attribute name="keep-together">auto</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="redline-not-matched" use-attribute-sets="background-yellow">
		<xsl:attribute name="keep-together">auto</xsl:attribute>
	</xsl:attribute-set>
	<xsl:variable name="redline-insert-attribute-set">
		<xsl:text disable-output-escaping="yes">text-decoration="underline" color="#00FF00" keep-together="auto"</xsl:text>
	</xsl:variable>
	<xsl:variable name="redline-delete-attribute-set">
		<xsl:text disable-output-escaping="yes">text-decoration="line-through" color="#FF0000" keep-together="auto"</xsl:text>
	</xsl:variable>
	<xsl:variable name="redline-not-matched-attribute-set">
		<xsl:text disable-output-escaping="yes">background-color="#FFFF00" keep-together="auto"</xsl:text>
	</xsl:variable>
	
	<!-- fix: perhaps  move block information back to originla stylesheet -->
	<xsl:template name="process-key-heading">
		<xsl:param name="label"/>
		
		<xsl:element name="fo:block" use-attribute-sets="keep-with-next space-after border-top-black">
			<xsl:element name="fo:inline" use-attribute-sets="background-black">
				<xsl:element name="fo:inline" use-attribute-sets="color-white background-black default-padding strong">
					<xsl:value-of select="$label"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="process-list-first-level">
		
		<xsl:element name="fo:list-block" use-attribute-sets="">
			<xsl:element name="fo:list-item" use-attribute-sets="">
				<xsl:element name="fo:list-item-label" use-attribute-sets="">
					<xsl:attribute name="end-indent">7pt</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets="strong space-before-small">
						<xsl:value-of select="$bullet-icon"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="fo:list-item-body" use-attribute-sets="">
					<xsl:attribute name="start-indent">7pt</xsl:attribute> 
					<xsl:element name="fo:block" use-attribute-sets="space-after-small">
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-list-second-level">
		
		<xsl:element name="fo:list-block" use-attribute-sets="">
			<xsl:element name="fo:list-item" use-attribute-sets="">
				<xsl:element name="fo:list-item-label" use-attribute-sets="">
					<xsl:attribute name="end-indent">14pt</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets=""/>
				</xsl:element>
				<xsl:element name="fo:list-item-body" use-attribute-sets="">
					<xsl:attribute name="start-indent">14pt</xsl:attribute> 
					<xsl:element name="fo:block" use-attribute-sets="space-after-small">
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="process-blue-ruled-block">
		<xsl:param name="label"/>
		
		<xsl:element name="fo:list-block" use-attribute-sets="border-top-blue">
			<xsl:element name="fo:list-item" use-attribute-sets="">
				<xsl:element name="fo:list-item-label" use-attribute-sets="">
					<xsl:attribute name="end-indent">70pt</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets="strong color-blue preserve-linefeed">
						<xsl:attribute name="margin-top">2pt</xsl:attribute>
						<xsl:attribute name="id" select="concat($cid, '_', translate($label, $lower, $upper))"/>
						<xsl:value-of select="translate($glue-text//*[name()=$label][contains(@lang, $lang)], $lower, $upper)"/>
					</xsl:element>
				</xsl:element>
				<xsl:element name="fo:list-item-body" use-attribute-sets="">
					<xsl:attribute name="start-indent">70pt</xsl:attribute> 
					<xsl:element name="fo:block" use-attribute-sets="color-blue space-after align-justify">
						<xsl:attribute name="margin-top">2pt</xsl:attribute>
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="process-ruled-heading">
		<xsl:param name="text"/>
		
		<xsl:element name="fo:block" use-attribute-sets="keep-with-next space-after border-top-black">
			<xsl:attribute name="margin-top">2pt</xsl:attribute>
			<xsl:element name="fo:inline" use-attribute-sets="strong em large">
				<xsl:copy-of select="$text"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="process-question-title">
		<xsl:param name="label"/>
		<xsl:param name="id"/>
		
		<xsl:element name="fo:list-block" use-attribute-sets="background-grey space-after">
			<xsl:element name="fo:list-item" use-attribute-sets="">
				<xsl:element name="fo:list-item-label" use-attribute-sets="">
					<xsl:attribute name="end-indent">60pt</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets="strong background-black color-white">
						<xsl:element name="fo:block" use-attribute-sets="default-margin">
							<xsl:value-of select="translate($label, $lower, $upper)"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="fo:list-item-body" use-attribute-sets="">
					<xsl:attribute name="start-indent">60pt</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets="strong background-grey keep-with-next">
						<xsl:attribute name="id" select="$id"/>
						<xsl:element name="fo:block" use-attribute-sets="default-margin">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="process-option-title">
		<xsl:param name="label"/>
		<xsl:param name="id"/>
		<xsl:param name="text"/>
		
		<xsl:element name="fo:list-block" use-attribute-sets="background-tinted-blue space-after">
			<xsl:element name="fo:list-item" use-attribute-sets="">
				<xsl:element name="fo:list-item-label" use-attribute-sets="">
					<xsl:attribute name="end-indent">60pt</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets="strong background-blue color-white">
						<xsl:element name="fo:block" use-attribute-sets="default-margin">
							<xsl:value-of select="translate($label, $lower, $upper)"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="fo:list-item-body" use-attribute-sets="">
					<xsl:attribute name="start-indent">60pt</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets="strong background-tinted-blue color-blue keep-with-next">
						<xsl:attribute name="id" select="$id"/>
						<xsl:element name="fo:block" use-attribute-sets="default-margin last-justify">
							<xsl:copy-of select="$text"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="process-sub-option-component-block">
		<xsl:param name="label"/>
		<xsl:param name="id"/>
		<xsl:param name="text"/>
		
		<xsl:element name="fo:list-block" use-attribute-sets="">
			<xsl:element name="fo:list-item" use-attribute-sets="">
				<xsl:element name="fo:list-item-label" use-attribute-sets="">
					<xsl:attribute name="end-indent">70pt</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets="strong color-blue">
						<xsl:value-of select="$label"/>
						<xsl:text>:</xsl:text>
					</xsl:element>
				</xsl:element>
				<xsl:element name="fo:list-item-body" use-attribute-sets="">
					<xsl:attribute name="start-indent">70pt</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets="space-after">
						<xsl:attribute name="id" select="$id"/>
						<xsl:copy-of select="$text"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template name="process-caption">
		<xsl:param name="label"/>
		<xsl:param name="id"/>
		<xsl:param name="text"/>
		
		<xsl:element name="fo:list-block" use-attribute-sets="">
			<xsl:element name="fo:list-item" use-attribute-sets="">
				<xsl:element name="fo:list-item-label" use-attribute-sets="">
					<xsl:attribute name="end-indent">60pt</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets="strong background-blue color-white">
						<xsl:element name="fo:block" use-attribute-sets="default-margin">
							<xsl:value-of select="translate($label, $lower, $upper)"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="$id"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<xsl:element name="fo:list-item-body" use-attribute-sets="">
					<xsl:attribute name="start-indent">60pt</xsl:attribute>
					<xsl:element name="fo:block" use-attribute-sets="strong background-tinted-blue space-after">
						<xsl:attribute name="id" select="$id"/>
						<xsl:element name="fo:block" use-attribute-sets="default-margin">
							<xsl:copy-of select="$text"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		
	</xsl:template>
	
</xsl:stylesheet>

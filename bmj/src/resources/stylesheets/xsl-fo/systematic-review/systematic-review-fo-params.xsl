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

	<xsl:attribute-set name="page-margin">
		<xsl:attribute name="margin-top">30pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">30pt</xsl:attribute>
		<xsl:attribute name="margin-left">40pt</xsl:attribute>
		<xsl:attribute name="margin-right">40pt</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="page-orientation-portrait">
		<xsl:attribute name="page-width">210mm</xsl:attribute>
		<xsl:attribute name="page-height">297mm</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="page-orientation-landscape">
		<xsl:attribute name="page-width">297mm</xsl:attribute>
		<xsl:attribute name="page-height">210mm</xsl:attribute>
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
	
	<xsl:attribute-set name="p" use-attribute-sets="para"/>
	
	<xsl:attribute-set name="para">
		<xsl:attribute name="padding-bottom">5pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="preview">
		<xsl:attribute name="color">#CCCCCC</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="border">1pt</xsl:attribute>
		<xsl:attribute name="border-color">#CCCCCC</xsl:attribute>
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
	
	<xsl:attribute-set name="border-bottom-black">
		<xsl:attribute name="border-bottom-color">#000000</xsl:attribute>
		<xsl:attribute name="border-bottom-style">solid</xsl:attribute>
		<xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
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
		<xsl:attribute name="table-layout">auto</xsl:attribute>
		<xsl:attribute name="width">100%</xsl:attribute>
		<xsl:attribute name="table-omit-header-at-break">false</xsl:attribute>
		<xsl:attribute name="table-omit-footer-at-break">true</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="thead">
		<xsl:attribute name="vertical-align">bottom</xsl:attribute>
		
	</xsl:attribute-set>
	<xsl:attribute-set name="tbody">
		<xsl:attribute name="vertical-align">top</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="tfoot">
		
	</xsl:attribute-set>
	
	<xsl:attribute-set name="xhtml-inside-table">
		<xsl:attribute name="start-indent">0pt</xsl:attribute>
		<xsl:attribute name="end-indent">0pt</xsl:attribute>
		<xsl:attribute name="text-indent">0pt</xsl:attribute>
		<xsl:attribute name="last-line-end-indent">0pt</xsl:attribute>
		<xsl:attribute name="text-align">start</xsl:attribute>
		<xsl:attribute name="text-align-last">relative</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="xhtml-table-and-caption">
		<xsl:attribute name="display-align">center</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="xhtml-table">
		<xsl:attribute name="font-size">8pt</xsl:attribute>
		<xsl:attribute name="border-width">1px</xsl:attribute>
		<xsl:attribute name="width">auto</xsl:attribute>
		<!--<xsl:attribute name="table-omit-header-at-break">false</xsl:attribute>-->
		<!--<xsl:attribute name="table-omit-footer-at-break">false</xsl:attribute>-->
		<!--<xsl:attribute name="table-layout">auto</xsl:attribute>-->
		<!--<xsl:attribute name="border-collapse">separate</xsl:attribute>-->
		<!--<xsl:attribute name="border-spacing">2px</xsl:attribute>-->
	</xsl:attribute-set>
	
	<xsl:attribute-set name="xhtml-table-caption" use-attribute-sets="xhtml-inside-table">
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="xhtml-table-column">
	</xsl:attribute-set>
	
	<xsl:attribute-set name="xhtml-thead" use-attribute-sets="xhtml-inside-table">
		<xsl:attribute name="background-color">#CCCCCC</xsl:attribute>
		<!--<xsl:attribute name="vertical-align">bottom</xsl:attribute>-->
	</xsl:attribute-set>
	
	<xsl:attribute-set name="xhtml-tfoot" use-attribute-sets="xhtml-inside-table">
		<!--<xsl:attribute name="vertical-align">top</xsl:attribute>-->
	</xsl:attribute-set>
	
	<xsl:attribute-set name="xhtml-tbody" use-attribute-sets="xhtml-inside-table">
		<!--<xsl:attribute name="vertical-align">top</xsl:attribute>-->
	</xsl:attribute-set>
	
	<xsl:attribute-set name="xhtml-tr">
		<!--<xsl:attribute name="keep-together">always</xsl:attribute>-->
	</xsl:attribute-set>
	
	<xsl:attribute-set name="xhtml-th">
		<xsl:attribute name="font-weight">bolder</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="border-width">1px</xsl:attribute>
		<xsl:attribute name="padding">1px</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="xhtml-td">
		<xsl:attribute name="border-width">1px</xsl:attribute>
		<xsl:attribute name="padding">1px</xsl:attribute>
		<xsl:attribute name="width">auto</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="info-table" use-attribute-sets="tiny">
		<xsl:attribute name="border-left-width">1pt</xsl:attribute>
		<xsl:attribute name="border-right-width">1pt</xsl:attribute>
		<xsl:attribute name="border-top-width">1pt</xsl:attribute>
		<xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
		<xsl:attribute name="border-left-color">black</xsl:attribute>
		<xsl:attribute name="border-right-color">black</xsl:attribute>
		<xsl:attribute name="border-top-color">black</xsl:attribute>
		<xsl:attribute name="border-bottom-color">black</xsl:attribute>
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
	
	
	<!-- added for benefit of shared serna ce comparisons data -->
	
	<xsl:attribute-set name="normal">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.size"/>
		</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="option-title">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.size"/>
		</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="background-color">#000099</xsl:attribute>
		<xsl:attribute name="color">#FFFFFF</xsl:attribute>
		<xsl:attribute name="padding">5px</xsl:attribute>
		<xsl:attribute name="border-color">#000099</xsl:attribute>
		<xsl:attribute name="border-width">1px</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="option-abridged-title">
		<xsl:attribute name="font-size">
			<xsl:value-of select="$body.font.size"/>
		</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="background-color">#7F7FCC</xsl:attribute>
		<xsl:attribute name="color">#FFFFFF</xsl:attribute>
		<xsl:attribute name="padding">5px</xsl:attribute>
		<xsl:attribute name="border-color">#7F7FCC</xsl:attribute>
		<xsl:attribute name="border-width">1px</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="narrow-white-line">
		<xsl:attribute name="padding">5px</xsl:attribute>
		<xsl:attribute name="color">#FFFFFF</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- benefits box -->
	<xsl:attribute-set name="green-box" use-attribute-sets="">
		<xsl:attribute name="padding">5px</xsl:attribute>
		<xsl:attribute name="border-width">1px</xsl:attribute>
		<xsl:attribute name="background-color">#F6FFF6</xsl:attribute>
		<xsl:attribute name="border-color">#BCC9BC</xsl:attribute>
		<xsl:attribute name="color">#004400</xsl:attribute>
	</xsl:attribute-set>
	
	<!--<xsl:attribute-set name="blue-box" use-attribute-sets="">
		<xsl:attribute name="padding">5px</xsl:attribute>
		<xsl:attribute name="border-width">1px</xsl:attribute>
		<xsl:attribute name="background-color">#F6FFF6</xsl:attribute>
		<xsl:attribute name="border-color">#BCC9BC</xsl:attribute>
		<xsl:attribute name="color">#004400</xsl:attribute>
		</xsl:attribute-set>-->
	
	<!-- harms box -->
	<xsl:attribute-set name="red-box" use-attribute-sets="">
		<xsl:attribute name="padding">5px</xsl:attribute>
		<xsl:attribute name="background-color">#FFF6F6</xsl:attribute>
		<xsl:attribute name="border-color">#D5BCBC</xsl:attribute>
		<xsl:attribute name="border-width">1px</xsl:attribute>
		<xsl:attribute name="color">#440000</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- comment box -->
	<xsl:attribute-set name="gray-box" use-attribute-sets="">
		<xsl:attribute name="padding">5px</xsl:attribute>
		<xsl:attribute name="border-width">1px</xsl:attribute>
		<xsl:attribute name="background-color">#F6F6F6</xsl:attribute>
		<xsl:attribute name="border-color">#CCCCCC</xsl:attribute>
		<xsl:attribute name="color">#444444</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="attribute-autotext" use-attribute-sets="">
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="background-color">#F8F9AF</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="generated-autotext" use-attribute-sets="">
		<xsl:attribute name="color">gray</xsl:attribute>
		<xsl:attribute name="background-color">light-gray</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="prompt-bordered-box" use-attribute-sets="">
		<xsl:attribute name="border-width">1px</xsl:attribute>
		<xsl:attribute name="border-color">#CCCCCC</xsl:attribute>
		<xsl:attribute name="padding-left">2pt</xsl:attribute>
		<xsl:attribute name="padding-right">2pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="comparisons-table-head-cell" use-attribute-sets="strong">
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="display-align">after</xsl:attribute>
		<xsl:attribute name="background-color">green</xsl:attribute>
		<xsl:attribute name="color">white</xsl:attribute>
		<xsl:attribute name="border-style">solid</xsl:attribute>
		<xsl:attribute name="border">1pt</xsl:attribute>
		<xsl:attribute name="border-width">1pt</xsl:attribute>
		<xsl:attribute name="border-color">green</xsl:attribute>
		<xsl:attribute name="padding-top">5px</xsl:attribute>
		<xsl:attribute name="padding-bottom">5px</xsl:attribute>
		<xsl:attribute name="padding-left">5px</xsl:attribute>
		<xsl:attribute name="padding-right">5px</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="comparisons-table-title-cell" use-attribute-sets="strong small normal">
		<xsl:attribute name="number-columns-spanned">6</xsl:attribute>
		<xsl:attribute name="background-color">#F8F9AF</xsl:attribute>
		<xsl:attribute name="border-style">solid</xsl:attribute>
		<xsl:attribute name="border">1pt</xsl:attribute>
		<xsl:attribute name="border-width">1pt</xsl:attribute>
		<xsl:attribute name="border-color">green</xsl:attribute>
		<xsl:attribute name="border-left-width">1pt</xsl:attribute>
		<xsl:attribute name="border-right-width">1pt</xsl:attribute>
		<xsl:attribute name="border-top-width">1pt</xsl:attribute>
		<xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
		<xsl:attribute name="border-left-color">green</xsl:attribute>
		<xsl:attribute name="border-right-color">green</xsl:attribute>
		<xsl:attribute name="border-top-color">green</xsl:attribute>
		<xsl:attribute name="border-bottom-color">green</xsl:attribute>
		<xsl:attribute name="padding-top">5px</xsl:attribute>
		<xsl:attribute name="padding-bottom">5px</xsl:attribute>
		<xsl:attribute name="padding-left">5px</xsl:attribute>
		<xsl:attribute name="padding-right">5px</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="comparisons-table-body-cell" use-attribute-sets="small">
		<xsl:attribute name="border-style">solid</xsl:attribute>
		<xsl:attribute name="border">1pt</xsl:attribute>
		<xsl:attribute name="border-width">1pt</xsl:attribute>
		<xsl:attribute name="border-color">green</xsl:attribute>
		<xsl:attribute name="border-left-width">1pt</xsl:attribute>
		<xsl:attribute name="border-right-width">1pt</xsl:attribute>
		<xsl:attribute name="border-top-width">1pt</xsl:attribute>
		<xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
		<xsl:attribute name="border-left-color">green</xsl:attribute>
		<xsl:attribute name="border-right-color">green</xsl:attribute>
		<xsl:attribute name="border-top-color">green</xsl:attribute>
		<xsl:attribute name="border-bottom-color">green</xsl:attribute>
		<xsl:attribute name="padding-top">5px</xsl:attribute>
		<xsl:attribute name="padding-bottom">5px</xsl:attribute>
		<xsl:attribute name="padding-left">5px</xsl:attribute>
		<xsl:attribute name="padding-right">5px</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="tabletitle">
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<!--<xsl:attribute name="text-align">center</xsl:attribute>-->
		<xsl:attribute name="background-color">#a1a1a1</xsl:attribute>
		<xsl:attribute name="border-width">1pt</xsl:attribute>
		<xsl:attribute name="border-color">#000000</xsl:attribute>
	</xsl:attribute-set>
	
	
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
		<xsl:param name="methods-performed-grade-evaluation-description"/>
		
		<xsl:element name="fo:list-block" use-attribute-sets="border-top-blue">
			
			<xsl:element name="fo:list-item" use-attribute-sets="">
				
				<xsl:element name="fo:list-item-label" use-attribute-sets="">
					<xsl:attribute name="end-indent">70pt</xsl:attribute>
					
						<xsl:choose>
							<xsl:when test="$label eq 'definition'">
								<xsl:element name="fo:block" use-attribute-sets="strong color-blue preserve-linefeed">
									<xsl:attribute name="margin-top">2pt</xsl:attribute>
									<xsl:attribute name="id" select="concat($cid, '_', translate($label, $lower, $upper))"/>DEFINITION</xsl:element>
							</xsl:when>							
							<xsl:when test="$label eq 'aetiology'">
								<xsl:element name="fo:block" use-attribute-sets="strong color-blue preserve-linefeed">
									<xsl:attribute name="margin-top">2pt</xsl:attribute>
									<xsl:attribute name="id" select="concat($cid, '_', translate($label, $lower, $upper))"/>AETIOLOGY/&#10;RISK FACTORS</xsl:element>	
							</xsl:when>	
							<xsl:when test="$label eq 'incidence'">
								<xsl:element name="fo:block" use-attribute-sets="strong color-blue preserve-linefeed">
									<xsl:attribute name="margin-top">2pt</xsl:attribute>
									<xsl:attribute name="id" select="concat($cid, '_', translate($label, $lower, $upper))"/>INCIDENCE/&#10;PREVALENCE</xsl:element>	
							</xsl:when>	
							<xsl:when test="$label eq 'prognosis'">
								<xsl:element name="fo:block" use-attribute-sets="strong color-blue preserve-linefeed">
									<xsl:attribute name="margin-top">2pt</xsl:attribute>
									<xsl:attribute name="id" select="concat($cid, '_', translate($label, $lower, $upper))"/>PROGNOSIS</xsl:element>	
							</xsl:when>
							<xsl:when test="$label eq 'aims'">
								<xsl:element name="fo:block" use-attribute-sets="strong color-blue preserve-linefeed">
									<xsl:attribute name="margin-top">2pt</xsl:attribute>
									<xsl:attribute name="id" select="concat($cid, '_', translate($label, $lower, $upper))"/>AIMS OF &#10;INTERVENTION</xsl:element>	
							</xsl:when>
							<xsl:when test="$label eq 'outcomes'">
								<xsl:element name="fo:block" use-attribute-sets="strong color-blue preserve-linefeed">
									<xsl:attribute name="margin-top">2pt</xsl:attribute>
									<xsl:attribute name="id" select="concat($cid, '_', translate($label, $lower, $upper))"/>OUTCOMES</xsl:element>	
							</xsl:when>
							<xsl:when test="$label eq 'methods'">
								<xsl:element name="fo:block" use-attribute-sets="strong color-blue preserve-linefeed">
									<xsl:attribute name="margin-top">2pt</xsl:attribute>
									<xsl:attribute name="id" select="concat($cid, '_', translate($label, $lower, $upper))"/>METHODS</xsl:element>	
							</xsl:when>
							<xsl:when test="$label eq 'general-background'">
								<xsl:element name="fo:block" use-attribute-sets="strong color-blue preserve-linefeed">
									<xsl:attribute name="margin-top">2pt</xsl:attribute>
									<xsl:attribute name="id" select="concat($cid, '_', translate($label, $lower, $upper))"/>GENERAL BACKGROUND</xsl:element>	
							</xsl:when>
							<xsl:when test="$label eq 'focus-of-the-review'">
								<xsl:element name="fo:block" use-attribute-sets="strong color-blue preserve-linefeed">
									<xsl:attribute name="margin-top">2pt</xsl:attribute>
									<xsl:attribute name="id" select="concat($cid, '_', translate($label, $lower, $upper))"/>FOCUS OF THE REVIEW</xsl:element>	
							</xsl:when>
							<xsl:when test="$label eq 'comments-on-evidence'">
								<xsl:element name="fo:block" use-attribute-sets="strong color-blue preserve-linefeed">
									<xsl:attribute name="margin-top">2pt</xsl:attribute>
									<xsl:attribute name="id" select="concat($cid, '_', translate($label, $lower, $upper))"/>COMMENTS ON EVIDENCE</xsl:element>	
							</xsl:when>
							<xsl:when test="$label eq 'search-and-appraisal-summary'">
								<xsl:element name="fo:block" use-attribute-sets="strong color-blue preserve-linefeed">
									<xsl:attribute name="margin-top">2pt</xsl:attribute>
									<xsl:attribute name="id" select="concat($cid, '_', translate($label, $lower, $upper))"/>SEARXH AND APPRAISAL SUMMARY</xsl:element>	
							</xsl:when>
							<xsl:when test="$label eq 'additional-information'">
								<xsl:element name="fo:block" use-attribute-sets="strong color-blue preserve-linefeed">
									<xsl:attribute name="margin-top">2pt</xsl:attribute>
									<xsl:attribute name="id" select="concat($cid, '_', translate($label, $lower, $upper))"/>ADDITIONAL INFORMATION</xsl:element>	
							</xsl:when>
							
						</xsl:choose>
					
								
				</xsl:element>
				
				<xsl:element name="fo:list-item-body" use-attribute-sets="">
					<xsl:attribute name="start-indent">70pt</xsl:attribute>
					
					<xsl:element name="fo:block" use-attribute-sets="color-blue space-after align-justify">
						<xsl:attribute name="margin-top">2pt</xsl:attribute>
						
						<xsl:apply-templates/>
						
						<xsl:if test="string-length(normalize-space($methods-performed-grade-evaluation-description))!=0">
							<!--<xsl:apply-templates select="$methods-performed-grade-evaluation-description" />-->
							<xsl:copy-of select="$methods-performed-grade-evaluation-description" />
						</xsl:if>
						
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
		<xsl:param name="text"/>
		
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
					<xsl:element name="fo:block" use-attribute-sets="background-grey strong keep-with-next">
						<xsl:attribute name="id" select="$id"/>
						<xsl:element name="fo:block" use-attribute-sets="default-margin">
							<xsl:copy-of select="$text"/>
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
					<xsl:element name="fo:block" use-attribute-sets="background-tinted-blue strong color-blue keep-with-next">
						<xsl:attribute name="id" select="$id"/>
						<xsl:element name="fo:block" use-attribute-sets="default-margin last-justify">
							<xsl:copy-of select="$text"/>
						</xsl:element>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="process-caption">
		<xsl:param name="label"/>
		<xsl:param name="id"/>
		<xsl:param name="text"/>
		
		<xsl:element name="fo:list-block" use-attribute-sets="space-after">
			<xsl:element name="fo:list-item" use-attribute-sets="background-tinted-blue">
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
					<xsl:element name="fo:block" use-attribute-sets="strong background-tinted-blue">
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

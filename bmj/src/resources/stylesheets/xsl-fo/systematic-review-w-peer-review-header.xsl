<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY ceblue "#0d519f">
	<!ENTITY celightblue "#c5c9e6">
	<!ENTITY cegrey "#cccccc">
]>

<?altova_samplexml C:\dev\docato-install\BMJ\systematic-review-publish.xml?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:rx="http://www.renderx.com/XSL/Extensions" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:cals="http://www.oasis-open.org/specs/tm9502.html">
	<xsl:include href="systematic-review-shared.xsl"/>
	
	<xsl:template name="do-peer-review">
		<fo:flow flow-name="xsl-region-body" font-size="10pt" text-align="justify">
			<fo:block text-align="center" font-size="12pt" font-weight="bold"><fo:inline font-style="italic">Clinical Evidence</fo:inline> Reviewer Form</fo:block>
			<fo:block>When completed please return by email (preferable) to Becky Simmons on rsimmons@bmjgroup.com OR by fax (44) 20 7383 6198.  Thank you.</fo:block>
			<fo:block space-before="10pt"><fo:inline font-weight="bold">Topic title: </fo:inline><xsl:value-of select="//systematic-review/info/title"/></fo:block>
			
			<fo:block space-before="10pt" text-align-last="justify"><fo:inline font-weight="bold">Reviewer name, title and address: </fo:inline><fo:leader leader-pattern="rule"/></fo:block>
			<fo:block space-before="10pt" text-align-last="justify"><fo:leader leader-pattern="rule"/></fo:block>
			<fo:block space-before="10pt" text-align-last="justify"><fo:leader leader-pattern="rule"/></fo:block>
			<fo:block space-before="10pt" text-align-last="justify"><fo:leader leader-pattern="rule"/></fo:block>
			
			<fo:block space-before="10pt" text-align-last="justify"><fo:inline font-weight="bold">Email address: </fo:inline><fo:leader leader-pattern="rule"/></fo:block>
			<fo:block space-before="10pt">Thank you for agreeing to non exclusively review specific sections of <fo:inline font-style="italic">Clinical Evidence</fo:inline>,  ("CE") from time to time, which is published by the BMJ Publishing Group Limited ("BMJPG").</fo:block>
			
			<fo:list-block provisional-distance-between-starts="18pt" provisional-label-separation="3pt" space-before="10pt">
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block>&#x2022;</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block>In reviewing each section, please note that the BMJPG  aims to provide readers of CE with <fo:inline font-style="italic">reliable summaries of best available research findings,</fo:inline> even when this means stating that there is little reliable research available to answer a particular question.</fo:block>
					</fo:list-item-body>
				</fo:list-item>
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block>&#x2022;</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block>Unlike many other publications, CE  is not a prescriptive textbook, and deliberately avoids making unsubstantiated, prescriptive statements of any kind. Its aim is simply to filter research since 1966 in order to tell readers what reliable research is available. It does not attempt to tell readers what to do. The ‘filters’ used, drawing from epidemiology and statistics, aim to weed out studies that, due to structural faults of bias, confounding, poor internal or external validity, or low power, are not likely to yield reliable results.</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
			
			<fo:block space-before="10pt">We would be most grateful, therefore, if you could review the piece by asking the questions that follow, using additional sheets if necessary. Where possible, please make changes directly on the text.</fo:block>
			<fo:block space-before="10pt">Please can you complete your review by the specified deadline.</fo:block>
			<fo:block space-before="10pt">Once you have returned your review, we will use this internally to evaluate the original piece within CE  and in future research designed to improve our editorial processes. If however, a contributor requests a copy of your review and /or, your name, we will disclose that to them in the interests of transparency. We will never disclose your address. We may then also use your contact information  to contact you in the future about further reviews, if you answer affirmatively to question 4 below. Please  advise us of any change in your contact details or other personal data.  </fo:block>
			
			<fo:list-block provisional-distance-between-starts="18pt" provisional-label-separation="3pt" space-before="10pt">
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block>&#x2022;</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block>If you have any questions, please contact Becky Simmons on (44) 207 383 6916 or rsimmons@bmjgroup.com</fo:block>
					</fo:list-item-body>
				</fo:list-item>
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block>&#x2022;</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block><fo:inline font-weight="bold">Please note that</fo:inline> in consideration for your peer review services <fo:inline font-weight="bold">you will receive a free copy of</fo:inline> the edition relating to your review of <fo:inline font-style="italic" font-weight="bold">Clinical Evidence Concise.</fo:inline></fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
			
			<fo:block font-weight="bold" space-before="10pt">1. RELEVANCE: scope and content.</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">1.	Is the piece relevant to clinical practice?</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">2.	Specifically, are any important questions, interventions, population groups, or outcomes missing?</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">3.	Is the Introductory section (definition to methods) accurate and sufficiently referenced?</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">4.	Does any part of the piece contain dogma, unsubstantiated opinion, or inaccurate information</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">5.	Are you aware of any of the interventions discussed being unavailable or for some reason problematic where you work (or in another part of the world)?</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">6.	Are you aware of any of the interventions discussed having another name in another part of the world? (E.g. America versus England/Europe versus Australasia)?</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">7.	Please comment on the usefulness of the piece to your practice.</fo:block>
			<fo:block font-weight="bold" space-before="10pt">2.  VALIDITY:</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">1.	Does the piece cover all the important, reliable research findings you know of? Has it missed any?</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">2.	Has it included too many (or too much detail of) poor quality studies?</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">3.	Does the piece link research cited accurately to reflect the questions asked?</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">4.	In the Introductory ‘Interventions’ section, have the interventions been placed in appropriate categories (e.g. Beneficial, Unknown Effectiveness)? </fo:block>
			<fo:block font-weight="bold" space-before="10pt">3.   ACCESSIBILITY: </fo:block>
			<fo:block margin-left="10pt" space-after="50pt">1.	Is the piece (language and structure) easy to read for the ordinary practitioner, who is not trained in epidemiology or statistics? If not, what would improve it?</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">2.	Are there sections that do not make sense?</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">3.	Are there sections that are a struggle to read?</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">4.	If tables and figures have been added, do they help the reader, or are they unnecessary?</fo:block>
			<fo:block margin-left="10pt" space-after="50pt">5.	Should tables or figures be added to help the reader? If so, what would be their titles?</fo:block>
			<fo:block font-weight="bold" space-before="10pt">4.   FUTURE REVIEWING</fo:block>
			<fo:list-block provisional-distance-between-starts="18pt" provisional-label-separation="3pt" margin-left="10pt" space-after="50pt">
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block>&#x2022;</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block>Would you be interested in reviewing an updated version of this chapter in the future, or any other topic or clinical area?</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
			<fo:block font-weight="bold" space-before="10pt">5.   OTHER COMMENTS</fo:block>
			<fo:list-block provisional-distance-between-starts="18pt" provisional-label-separation="3pt" margin-left="10pt" space-after="50pt">
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block>&#x2022;</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block>Please tell us anything else about this piece that you think we should know in order to ensure that it become reliable, relevant and accessible for readers. </fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:flow>
	</xsl:template>
	
	<xsl:template match="/">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<xsl:call-template name="do-page-masters"/>

			<fo:page-sequence master-reference="my-sequence">
				<xsl:call-template name="do-peer-review"/>
			</fo:page-sequence>
			
			<fo:page-sequence master-reference="my-sequence">
				<xsl:call-template name="do-static-content"/>
				
				<fo:flow flow-name="xsl-region-body" font-size="9pt" text-align="justify">
					<xsl:call-template name="do-headers"/>
					<xsl:call-template name="do-intervention-table"/>
					<xsl:call-template name="do-clinical-context"/>
					<xsl:call-template name="do-background"/>
					<xsl:call-template name="do-questions"/>
					
					<xsl:call-template name="do-references"/>
					<xsl:call-template name="do-contributors"/>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
</xsl:stylesheet>

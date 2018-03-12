<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:se="http://syntext.com/XSL/Format-1.0" xmlns:fo="http://www.w3.org/1999/XSL/Format">

	<xsl:output  method="xml" indent="no"/>
	
   	<xsl:strip-space  elements="*"/>

	<xsl:attribute-set name="typing-box">
		<xsl:attribute name="font-family">Arial</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="border-color">#aaaadd</xsl:attribute>
		<xsl:attribute name="border-width">1px</xsl:attribute>
		<xsl:attribute name="padding">5px</xsl:attribute>
	</xsl:attribute-set>
  
	<xsl:attribute-set name="main-prompt">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="padding-top">12pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="prompt">
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="padding-top">10pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="minor-prompt">
		<xsl:attribute name="padding-top">8pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="question-prompt">
		<xsl:attribute name="padding-top">8pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="hint">
		<xsl:attribute name="font-family">Arial</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
		<xsl:attribute name="background-color">#eeeeee</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template match="/bmjk-review-plan">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<fo:layout-master-set>
				<fo:simple-page-master master-name="my-page">
					<fo:region-body margin="1in"/>
				</fo:simple-page-master>
			</fo:layout-master-set>
		
			<fo:page-sequence master-reference="my-page">
				<fo:flow flow-name="xsl-region-body" font-size="12pt">
					<fo:block  font-weight="bold" font-size="20pt">
						<xsl:text>BMJK review plan: </xsl:text><xsl:value-of select="//bmjk-review-plan/info/title"/>
					</fo:block>
					
					<xsl:apply-templates select="info" mode="first"/>
					<xsl:apply-templates select="background"/>
					
					<xsl:apply-templates select="questions"/>
					
					<xsl:apply-templates select="search-info"/>
					
					<xsl:apply-templates select="patient-info"/>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
				
	</xsl:template>
	
	<xsl:template match="search-date">
		<fo:block padding-top="14pt"  xsl:use-attribute-sets="prompt">
			<xsl:text>Proposed Search Date:</xsl:text>
		</fo:block>
			
		<fo:block xsl:use-attribute-sets="typing-box"><xsl:apply-templates/></fo:block>
	</xsl:template>

	<xsl:template match="planning-date">
		<fo:block padding-top="14pt" xsl:use-attribute-sets="prompt">
			<xsl:text>Review planning date:</xsl:text>
		</fo:block>
			
		<fo:block xsl:use-attribute-sets="typing-box"><xsl:apply-templates/></fo:block>
	</xsl:template>

	<xsl:template match="title" mode="topic-title">
		<fo:block padding-top="14pt" xsl:use-attribute-sets="prompt">
			<xsl:text>Review title:</xsl:text>
		</fo:block>
		
		<fo:block xsl:use-attribute-sets="typing-box"><xsl:apply-templates/></fo:block>
	</xsl:template>

	<xsl:template match="info" mode="first">
		<xsl:apply-templates select="title" mode="topic-title"/>
		<xsl:apply-templates select="search-date"/>
		<xsl:apply-templates select="planning-date"/>
		
		<xsl:call-template name="output-spacer"/>
		

		<!-- clinical sections -->
		<xsl:apply-templates select="section-list" mode="clinical"/>
		
		<!-- patient sections -->
		<xsl:apply-templates select="../patient-info/section-list" mode="patient"></xsl:apply-templates>

		<xsl:call-template name="output-spacer"/>

		<xsl:apply-templates select="contributor-set"/>
		<xsl:apply-templates select="clinical-editors-set"/>
		<xsl:apply-templates select="patient-editors-set"/>
		
		<xsl:apply-templates select="information-specialists-set"/>
		
		<xsl:apply-templates select="future-issues"/>
		<xsl:apply-templates select="clinical-notes"/>
	</xsl:template>

	<xsl:template match="section-list" mode="clinical">
		<fo:block padding-top="12pt">
			<xsl:text>Section(s): </xsl:text>
		</fo:block>
			
		<fo:block xsl:use-attribute-sets="typing-box">
			<xsl:for-each select="section-link">
				<xsl:apply-templates select="."/>
				
				<xsl:if test="position()!=last()">
					<xsl:text> - </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="section-list" mode="patient">
		<fo:block padding-top="12pt">
			<xsl:text>Patient condition centres(s): </xsl:text>
		</fo:block>

			<fo:block xsl:use-attribute-sets="typing-box">
				<xsl:for-each select="section-link">
					<xsl:apply-templates select="."/>
					
					<xsl:if test="position()!=last()">
						<xsl:text> - </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</fo:block>
	</xsl:template>
	
	<xsl:template match="section-link">
		<fo:inline>
			<xsl:text>[</xsl:text>
			<xsl:value-of select="document(@target, /)/section/title"/>
			<xsl:text>]</xsl:text>
		</fo:inline>
	</xsl:template>	
	
	
	
	<xsl:template match="contributor-set">
		<fo:block padding-top="12pt">
			<xsl:text>Review contributor(s): </xsl:text>
		</fo:block>

		<fo:block xsl:use-attribute-sets="typing-box">
			<xsl:for-each select="person-link">
				<xsl:apply-templates select="."/>	
				<xsl:if test="position()!=last()">
					<xsl:text> - </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</fo:block>
	</xsl:template>

	<xsl:template match="clinical-editors-set">
		<fo:block padding="8px">
			<xsl:text>Clinical editor: </xsl:text>
		</fo:block>

		<fo:block xsl:use-attribute-sets="typing-box">
			<xsl:for-each select="person-link">
				<xsl:apply-templates select="."/>	

				<xsl:if test="position()!=last()">
					<xsl:text> - </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="patient-editors-set">
		<fo:block padding="8px">
			<xsl:text>Patient editor: </xsl:text>
		</fo:block>
		<fo:block xsl:use-attribute-sets="typing-box">
				<xsl:for-each select="person-link">
					<xsl:apply-templates select="."/>	
	
					<xsl:if test="position()!=last()">
						<xsl:text> - </xsl:text>
					</xsl:if>
				</xsl:for-each>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="information-specialists-set">
		<fo:block padding="8px">
			<xsl:text>Information specialist(s): </xsl:text>
		</fo:block>

		<fo:block xsl:use-attribute-sets="typing-box">
				<xsl:for-each select="person-link">
					<xsl:apply-templates select="."/>	
	
					<xsl:if test="position()!=last()">
						<xsl:text> - </xsl:text>
					</xsl:if>
				</xsl:for-each>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="person-link">
		<fo:inline>
			<xsl:text>[</xsl:text>
				<xsl:apply-templates select="document(@target, /)"/>
			<xsl:text>]</xsl:text>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="person">
		<xsl:choose>
			<xsl:when test="middle-name != ''"><xsl:value-of select="first-name"/><xsl:text> </xsl:text><xsl:value-of select="middle-name"/><xsl:text> </xsl:text><xsl:value-of select="last-name"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="first-name"/><xsl:text> </xsl:text><xsl:value-of select="last-name"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
	
	
	<xsl:template match="future-issues">
		<fo:block  text-decoration="underline" font-weight="bold" padding-top="10pt">
			Future coverage:
		</fo:block>
		
		<fo:block xsl:use-attribute-sets="typing-box">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>


	<xsl:template match="clinical-notes">
		<fo:block  text-decoration="underline" font-weight="bold" padding-top="10pt">
			Notes (this section is not published):
		</fo:block>
		
		<fo:block xsl:use-attribute-sets="typing-box">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	
	<xsl:template match="p">
		<fo:block><xsl:apply-templates/></fo:block>
	</xsl:template>
	
	<!--END TOPIC INFO -->

	<!-- BACKGROUND-->
	
	<xsl:template match="background">
		<xsl:apply-templates select="definition"/> 
		<xsl:apply-templates select="aims"/>
		<xsl:apply-templates select="outcomes"/>
		<xsl:apply-templates select="diagnosis"/>
	</xsl:template>
	
	
	<xsl:template match="definition">
		<fo:block xsl:use-attribute-sets="prompt">
			<xsl:text>Definition:</xsl:text>
		</fo:block>
		<fo:block xsl:use-attribute-sets="typing-box">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="aims">
		<fo:block xsl:use-attribute-sets="prompt">
			<xsl:text>Aims:</xsl:text>
		</fo:block>
		<fo:block  xsl:use-attribute-sets="typing-box">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="outcomes">
		<fo:block xsl:use-attribute-sets="main-prompt">
			<xsl:text>Outcomes:</xsl:text>
		</fo:block>
		<fo:block  xsl:use-attribute-sets="typing-box">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="diagnosis">
		<fo:block xsl:use-attribute-sets="prompt">
			<xsl:text>Diagnosis:</xsl:text>
		</fo:block>
		<fo:block  xsl:use-attribute-sets="typing-box">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="population">
		<fo:block xsl:use-attribute-sets="prompt">
			<xsl:text>Population:</xsl:text>
		</fo:block>
		<fo:block  xsl:use-attribute-sets="typing-box">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="em">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	
	<xsl:template match="strong">
		<fo:inline font-weight="bold"><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<!--END BACKGROUND-->
	
	<!--QUESTIONS INTERVENTIONS COMPARISONS-->
	
	<xsl:template match="questions">
		<fo:block xsl:use-attribute-sets="prompt">
			<xsl:text>Questions</xsl:text>
		</fo:block>
		
		<fo:block xsl:use-attribute-sets="hint">
			<xsl:text>Please list all the questions to be included. A separate question should be asked for treating a different population, or for treatment versus prevention, but a separate question should not be asked for each intervention. Please consider if different populations should be considered separately, for example by disease severity, older/younger people, in pregnancy, etc. Please define all terms used, for example if children should be considered separately what is the age cut off for childhood, or if severe cases should be considered separately what counts as a severe case. Please provide the rationale/evidence for any such population divisions, i.e. why you think there is likely to be a variation in effect by that factor, for example what are the effects of interventions to prevent myocardial infarction? Option 1: aspirin. For this question we could consider separately the effects of interventions in people who have already experienced a myocardial infarction and in those who have not.</xsl:text>
		</fo:block>		
		
		<xsl:call-template name="output-spacer"></xsl:call-template>
		
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="question">
		<fo:block>
			<fo:inline xsl:use-attribute-sets="question-prompt">Question: </fo:inline>
			<fo:inline><xsl:apply-templates select="title" mode="question-title"/></fo:inline>
			
			<xsl:apply-templates select="intervention-list"/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="title" mode="question-title">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="title" mode="intervention-title">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="title" mode="comparison-title">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="intervention-list">	
		<fo:list-block>
			<xsl:apply-templates/>
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="intervention">
		<fo:list-item>
			<fo:list-item-label/>
			<fo:list-item-body>
				<fo:block>
		<!--		<xsl:call-template name="output-spacer2"></xsl:call-template>-->
					<fo:inline  xsl:use-attribute-sets="question-prompt" padding-left="50px">Intervention: </fo:inline>
					<xsl:apply-templates select="title" mode="intervention-title"/>
					<fo:block>
					<fo:inline font-style="italic" font-size="10pt" padding-left="60px"><xsl:text>Combinations acceptable? </xsl:text></fo:inline><xsl:apply-templates select="@combinations-acceptable"/>
					</fo:block>
					
					<xsl:apply-templates select="comparison-list"/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="comparison-list">
		<fo:list-block>
			<xsl:apply-templates/>
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="comparison">
		<fo:list-item>
			<fo:list-item-label/>
			<fo:list-item-body>
				<fo:block>
				<fo:inline  xsl:use-attribute-sets="question-prompt" padding-left="100px">Comparison: </fo:inline>
				<xsl:apply-templates select="title" mode="comparison-title"/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<!--END QUESTIONS INTERVENTIONS COMPARISONS-->
	
	<!--SEARCH NOTES-->
	
	<xsl:template match="study-type|blindings|length-of-follow-up|max-loss-to-follow-up|trial-size|search-period|keywords|background-search|harms-search">
		<fo:block xsl:use-attribute-sets="typing-box"><xsl:apply-templates select="node()"/></fo:block>
	</xsl:template>
	


	<xsl:template match="search-info">
		<fo:block>
			<fo:block xsl:use-attribute-sets="main-prompt">
				<xsl:text>Instructions to IS</xsl:text>
			</fo:block>
			
			<fo:block xsl:use-attribute-sets="prompt">
				<xsl:text>Study types</xsl:text>
			</fo:block>
			<fo:block xsl:use-attribute-sets="hint">
				<xsl:text>We will search for systematic reviews and RCTs unless requested otherwise. If you want observational studies, the type of study must be explicitly specified (e.g. cohorts – prospective/retrospective, control group; case control; case series, etc)</xsl:text>
			</fo:block>		
			<xsl:apply-templates select="study-type"/>
			
			<fo:block xsl:use-attribute-sets="prompt">
				<xsl:text>Blinding:</xsl:text>
			</fo:block>
			<fo:block xsl:use-attribute-sets="hint">
				<xsl:text>Default is at least single blinding (where interventions are able to be blinded). We will exclude open, open label, or non-blinded unless you state otherwise. Please state if open studies are required</xsl:text>
			</fo:block>		
			<xsl:apply-templates select="blindings"/>
	
			<fo:block xsl:use-attribute-sets="prompt">
				<xsl:text>Length of follow up:</xsl:text>
			</fo:block>
			<fo:block xsl:use-attribute-sets="hint">
				<xsl:text>Default is no minimum length</xsl:text>
			</fo:block>		
			<xsl:apply-templates select="length-of-follow-up"/>
	
			<fo:block xsl:use-attribute-sets="prompt">
				<xsl:text>Maximum loss to follow up:</xsl:text>
			</fo:block>
			<fo:block xsl:use-attribute-sets="hint">
				<xsl:text>Default is 80% follow up</xsl:text>
			</fo:block>		
			<xsl:apply-templates select="max-loss-to-follow-up"/>
	
			<fo:block xsl:use-attribute-sets="prompt">
				<xsl:text>Trial size:</xsl:text>
			</fo:block>
			<fo:block xsl:use-attribute-sets="hint">
				<xsl:text>Our default is 20 people per study (at least 10 people per treatment arm)</xsl:text>
			</fo:block>		
			<xsl:apply-templates select="trial-size"/>
	
			<fo:block xsl:use-attribute-sets="prompt">
				<xsl:text>Search period:</xsl:text>
			</fo:block>
			<fo:block xsl:use-attribute-sets="hint">
				<xsl:text>We will search Medline, Embase (and PsychInfo as appropriate) back to 20 years ago. We also search the most recent issue of the Cochrane Library. If you require us to search back more than 20 years, please state here which year we should search back to.</xsl:text>
			</fo:block>		
			<xsl:apply-templates select="search-period"/>
			
			<fo:block xsl:use-attribute-sets="prompt">
				<xsl:text>Keywords:</xsl:text>
			</fo:block>
			<fo:block xsl:use-attribute-sets="hint">
				<xsl:text>Any keywords and synonyms here will help the search</xsl:text>
			</fo:block>		
			<xsl:apply-templates select="keywords"/>
			
			<fo:block xsl:use-attribute-sets="prompt">
				<xsl:text>Background search:</xsl:text>
			</fo:block>
			<fo:block xsl:use-attribute-sets="hint">
				<xsl:text>We will carry out a search of overviews for the background section (definition, incidence/prevalence, aetiology/risk factors, prognosis). You will be sent this as a separate file along with the rest of your search results. You will not have to mark inclusion/exclusion of the overviews; they are provided to help you include current international data in the background section. If there is any particular aspect of the background you would like us to include in this search, please indicate here. Otherwise we will carry out a general search for this condition.</xsl:text>
			</fo:block>		
			<xsl:apply-templates select="background-search"/>
			
			<fo:block xsl:use-attribute-sets="prompt">
				<xsl:text>Harms search:</xsl:text>
			</fo:block>
			<fo:block xsl:use-attribute-sets="hint">
				<xsl:text>On request, we can carry out a search for pre-specified harm(s) of an intervention. Note any harms search requests here for more discussion</xsl:text>
			</fo:block>
			<xsl:apply-templates select="harms-search"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="patient-info">
		<fo:block>



			<fo:block xsl:use-attribute-sets="main-prompt">
				<xsl:text>Joint review planning between patient and clinical editor</xsl:text>
			</fo:block>

<!--		<fo:block padding-top="2.5px">
			<xsl:text>Patient condition centres(s): </xsl:text><fo:inline><xsl:apply-templates select="./section-list"/></fo:inline>
		</fo:block>
		<xsl:call-template name="output-spacer"/>-->

			<fo:block xsl:use-attribute-sets="hint">
				<xsl:text>Below are the issues to be considered at the review planning meeting between patient and clinical editor. They are intended as prompts for discussion and agreement between patient and clinical editor even where a BT topic is not currently planned.</xsl:text>
			</fo:block>		
		</fo:block>			
		<xsl:apply-templates select="evaluation-considerations"/>
		<xsl:apply-templates select="structure-requirements"/>
		<xsl:apply-templates select="es-structure-requirements"/>
		<xsl:apply-templates select="instructions-to-is"/>
	</xsl:template>
	

	<xsl:template match="evaluation-considerations">

		<fo:block xsl:use-attribute-sets="minor-prompt">
			<xsl:text>What key questions should BT/CE put to  the CE contributor concerning patient/clinician issues?</xsl:text>
		</fo:block>

		<fo:block xsl:use-attribute-sets="minor-prompt">
			<xsl:text>Does current plan take account of important national guidance/regulatory authorities e.g. NICE guidelines, MHRA?</xsl:text>
			<xsl:apply-templates select="@takes-account-of-guidance"></xsl:apply-templates>				
		</fo:block>
		
		<fo:block xsl:use-attribute-sets="minor-prompt">
			<xsl:text>Do interventions in the plan reflect/include all those used in clinical practice?</xsl:text>
			<xsl:apply-templates select="@used-in-clinical-practice"></xsl:apply-templates>				
		</fo:block>

		<fo:block xsl:use-attribute-sets="minor-prompt">
			<xsl:text>Are there any interventions which should be added?</xsl:text>
			<xsl:apply-templates select="@add-any-interventions"></xsl:apply-templates>				
		</fo:block>

		<fo:block xsl:use-attribute-sets="minor-prompt">
			<xsl:text>Are there any interventions which are outdated/no longer used?</xsl:text>
			<xsl:apply-templates select="@outdated"></xsl:apply-templates>				
		</fo:block>

		<fo:block>
			<xsl:text>Comments on design/structure of review plan</xsl:text>
		</fo:block>

		<fo:block>
			<xsl:text>Are the questions/outcomes most relevant to patients/clinicians?</xsl:text>
		</fo:block>

		<fo:block>
			<xsl:text>Does design of plan reflect common situations likely to arise in practice?</xsl:text>
		</fo:block>

		<fo:block>
			<xsl:text>What impact will any CE plans to restructure/divide a review have on corresponding BT topic?</xsl:text>
		</fo:block>


		<fo:block  xsl:use-attribute-sets="typing-box">
			<fo:block xsl:use-attribute-sets="hint">(Enter your notes below)</fo:block>
			<xsl:apply-templates/>
		</fo:block>
		
	</xsl:template>

	<xsl:template match="@background-search-required | @background-search-for-new-required | @harms-search-required | @background-search-for-new-required | @mechanism-of-action-for-new-required | @patient-specific-search-required | @searched-from-news-file-required | @updated-guidelines-search-required|@combinations-acceptable">
		<fo:inline font-size="10pt">
			<xsl:text>  </xsl:text>
			<xsl:value-of select="."/>
		</fo:inline>
	</xsl:template>
		
		<xsl:template match="@used-in-clinical-practice | @add-any-interventions | @outdated | @takes-account-of-guideance">
		<fo:inline font-size="10pt">
			<xsl:text>  </xsl:text>
			<xsl:value-of select="."/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="structure-requirements">
		<fo:block xsl:use-attribute-sets="prompt">
			<xsl:text>Requirements for BT structure</xsl:text>
		</fo:block>
		<fo:block xsl:use-attribute-sets="hint">
			<xsl:text>Below is an outline of a standard BT topic.  Please add notes accordingly.</xsl:text>
		</fo:block>
		<fo:block>
			<xsl:text>What treatments work?</xsl:text>
		</fo:block>	

		<fo:block>
			<xsl:text>What is it?</xsl:text>
		</fo:block>	
		
		<fo:block>
			<xsl:text>What are the symptoms?</xsl:text>
		</fo:block>	
		
		<fo:block>
			<xsl:text>How is it diagnosed?</xsl:text>
		</fo:block>	
		
		<fo:block>
			<xsl:text>How common is it?</xsl:text>
		</fo:block>	
		
		<fo:block>
			<xsl:text>What will happen?</xsl:text>
		</fo:block>	

		<fo:block>
			<xsl:text>How is it diagnosed (BTfull only)?</xsl:text>
		</fo:block>	


		<fo:block  xsl:use-attribute-sets="typing-box">
			<fo:block xsl:use-attribute-sets="hint">(Enter your notes below)</fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template name="output-spacer">
		<fo:block padding="5px" color="#ffffff">-</fo:block>
	</xsl:template>
	<xsl:template name="output-spacer2">
		<fo:block padding="2.5px" color="#ffffff">-</fo:block>
	</xsl:template>


	<xsl:template match="es-structure-requirements">
		<fo:block xsl:use-attribute-sets="prompt">
			<xsl:text>Requirements for BT elective surgery structure</xsl:text>
		</fo:block>
		<fo:block xsl:use-attribute-sets="hint">
			<xsl:text>Below is an outline of a standard BT topic for elective surgery. Please add notes accordingly</xsl:text>
		</fo:block>
		<fo:block>
			<xsl:text>What is X?</xsl:text>
		</fo:block>	

		<fo:block>
			<xsl:text>Why do I need X/Can I have X?</xsl:text>
		</fo:block>	
		
		<fo:block>
			<xsl:text>What happens during X?</xsl:text>
		</fo:block>	
		
		<fo:block>
			<xsl:text>Will it work?</xsl:text>
		</fo:block>	
		
		<fo:block>
			<xsl:text>What are the risks of X?</xsl:text>
		</fo:block>	
		
		<fo:block>
			<xsl:text>Are there any alternatives?</xsl:text>
		</fo:block>	

		<fo:block>
			<xsl:text>What will happen afterwards?</xsl:text>
		</fo:block>	


		<fo:block  xsl:use-attribute-sets="typing-box">
			<fo:block xsl:use-attribute-sets="hint">(Enter your notes below)</fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

<xsl:template match="instructions-to-is">
		<fo:block xsl:use-attribute-sets="prompt">
			<xsl:text>Instructions to IS</xsl:text>
		</fo:block>
		<fo:block xsl:use-attribute-sets="hint">
			<xsl:text>Must be completed before the BT search can take place. Please add as much detail as possible.</xsl:text>
		</fo:block>
		
		<fo:block xsl:use-attribute-sets="minor-prompt">
			<xsl:text>Extra BT specific search required?</xsl:text>
			<xsl:apply-templates select="@patient-specific-search-required"></xsl:apply-templates>				
		</fo:block>
		
		<fo:block xsl:use-attribute-sets="minor-prompt">
			<xsl:text>Any front end (background) search needed?</xsl:text>
			<xsl:apply-templates select="@background-search-required"></xsl:apply-templates>				
		</fo:block>
		
		<fo:block xsl:use-attribute-sets="minor-prompt">
			<xsl:text>Any searches for updated guidelines needed?</xsl:text>
			<xsl:apply-templates select="@updated-guidelines-search-required"></xsl:apply-templates>				
		</fo:block>
		
		<fo:block xsl:use-attribute-sets="minor-prompt">
			<xsl:text>Any background searches for new treatments?</xsl:text>
			<xsl:apply-templates select="@background-search-for-new-required"></xsl:apply-templates>				
		</fo:block>
		
		<fo:block xsl:use-attribute-sets="minor-prompt">
			<xsl:text>Any searches needed on mechanism of action for new treatments?</xsl:text>
			<xsl:apply-templates select="@mechanism-of-action-for-new-required"></xsl:apply-templates>				
		</fo:block>
		
		<fo:block xsl:use-attribute-sets="minor-prompt">
			<xsl:text>Any extra harms searches for new treatments?</xsl:text>
			<xsl:apply-templates select="@harms-search-required"></xsl:apply-templates>				
		</fo:block>
		
		<fo:block xsl:use-attribute-sets="minor-prompt">
			<xsl:text>Any searches arising from BT news file – whether interventions or front end?</xsl:text>
			<xsl:apply-templates select="@searched-from-news-file-required"></xsl:apply-templates>				
		</fo:block>

		<fo:block  xsl:use-attribute-sets="typing-box">
			<fo:block xsl:use-attribute-sets="hint">(Enter your notes below)</fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>


   <xsl:template match="reference-link">
		<fo:inline color="red" background-color="#BBBBBB">
			<xsl:choose>
				<xsl:when test="document(@target, /)//bmjk-citation">
					<xsl:text> [</xsl:text><xsl:value-of select="document(@target, /)//bmjk-citation"/><xsl:text>] </xsl:text>
				</xsl:when>
				<xsl:otherwise>
				<xsl:text> [</xsl:text><xsl:value-of select="@target"/><xsl:text>]</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		 </fo:inline>

	</xsl:template>

   <xsl:template match="gloss-link">
		<fo:inline color="#630000" background-color="#BBBBBB" text-decoration="underline"><xsl:apply-templates/></fo:inline>
	</xsl:template>

   <xsl:template match="table-link">
   	<fo:inline color="#630044" background-color="#BBBBBB"><xsl:apply-templates/></fo:inline>

	</xsl:template>

   <xsl:template match="figure-link">
   	<fo:inline color="#630055" background-color="#BBBBBB"><xsl:apply-templates/></fo:inline>

	</xsl:template>

	<xsl:template match="sup">
		<fo:inline baseline-shift="super" font-size="6pt"><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="sub">
		<fo:inline baseline-shift="sub" font-size="6pt"><xsl:apply-templates/></fo:inline>
	</xsl:template>
	

</xsl:stylesheet>
    

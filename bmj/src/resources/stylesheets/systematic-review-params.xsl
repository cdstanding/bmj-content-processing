<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	
	<xsl:param name="publisher-name">BMJ Publishing Group</xsl:param>
	<xsl:param name="journal-title">Clinical Evidence</xsl:param>
	<xsl:param name="journal-title-abbr">Clin Evid</xsl:param><!-- note: add ' (Online)' to PubMed given journal title abbreviation -->
	<xsl:param name="issn">1752-8526</xsl:param>
	<xsl:param name="ncbi-provider-id">3979</xsl:param>
	<xsl:param name="language">EN</xsl:param>
	<xsl:param name="volume">19</xsl:param>
	<xsl:param name="year">2008</xsl:param>
	<xsl:param name="month">June</xsl:param>
	<xsl:param name="day">01</xsl:param>
	<xsl:param name="copyright">© BMJ Publishing Group Ltd</xsl:param>

	<xsl:param name="glue-text">
		
		<copyright lang="en-gb" media="web,print">© BMJ Publishing Group Ltd</copyright>
		<copyright lang="es" media="web,print">© BMJ Publishing Group Ltd</copyright>
		
		<rights lang="en-gb" media="web,print">All rights reserved.</rights>
		<rights lang="es" media="web,print">All rights reserved.</rights>
		
		<disclaimer-label lang="en-gb" media="web,print">Disclaimer</disclaimer-label>
		<disclaimer-label lang="es" media="web,print">Disclaimer</disclaimer-label>

		<disclaimer lang="en-gb" media="web,print">The information contained in this publication is intended for medical professionals. Categories presented in Clinical Evidence indicate a judgement about the strength of the evidence available to our contributors prior to publication and the relevant importance of benefit and harms. We rely on our contributors to confirm the accuracy of the information presented and to adhere to describe accepted practices. Readers should be aware that professionals in the field may have different opinions. Because of this and regular advances in medical research we strongly recommend that readers' independently verify specified treatments and drugs including manufacturers' guidance. Also, the categories do not indicate whether a particular treatment is generally appropriate or whether it is suitable for a particular individual. Ultimately it is the readers' responsibility to make their own professional judgements, so to appropriately advise and treat their patients. &#10;To the fullest extent permitted by law, BMJ Publishing Group Limited and its editors are not responsible for any losses, injury or damage caused to any person or property (including under contract, by negligence, products liability or otherwise) whether they be direct or indirect, special, incidental or consequential, resulting from the application of the information in this publication.</disclaimer>
		<disclaimer lang="es" media="web,print">The information contained in this publication is intended for medical professionals. Categories presented in Clinical Evidence indicate a judgement about the strength of the evidence available to our contributors prior to publication and the relevant importance of benefit and harms. We rely on our contributors to confirm the accuracy of the information presented and to adhere to describe accepted practices. Readers should be aware that professionals in the field may have different opinions. Because of this and regular advances in medical research we strongly recommend that readers' independently verify specified treatments and drugs including manufacturers' guidance. Also, the categories do not indicate whether a particular treatment is generally appropriate or whether it is suitable for a particular individual. Ultimately it is the readers' responsibility to make their own professional judgements, so to appropriately advise and treat their patients. &#10;To the fullest extent permitted by law, BMJ Publishing Group Limited and its editors are not responsible for any losses, injury or damage caused to any person or property (including under contract, by negligence, products liability or otherwise) whether they be direct or indirect, special, incidental or consequential, resulting from the application of the information in this publication.</disclaimer>
		
		<clinical-context lang="en-gb" media="web,print">Clinical Context</clinical-context>
        <general-background lang="en-gb" media="web,print">General background</general-background>        
        <focus-of-the-review lang="en-gb" media="web,print">Focus of the review</focus-of-the-review>        
        <comments-on-evidence lang="en-gb" media="web,print">Comments on evidence</comments-on-evidence>        
        <search-and-appraisal-summary lang="en-gb" media="web,print">Search and appraisal summary</search-and-appraisal-summary>        
        <additional-information lang="en-gb" media="web,print">Additional information</additional-information>		
		
		<disclaimer-abridged lang="en-gb" media="web,print">The information contained in this publication is intended for medical professionals. The BMJ Group does not confirm the accuracy of this information. Please see our full disclaimer online on the Clinical Evidence website's terms and conditions.</disclaimer-abridged>
		<disclaimer-abridged lang="es" media="web,print">The information contained in this publication is intended for medical professionals. The BMJ Group does not confirm the accuracy of this information. Please see our full disclaimer online on the Clinical Evidence website's terms and conditions.</disclaimer-abridged>
		
		<journal-title lang="en-gb" media="web,print"><em>Clinical Evidence</em></journal-title>
		<journal-title lang="es" media="web,print"><em>Evidencia Clínica</em></journal-title>
		
		<journal-title-abbr lang="en-gb" media="web,print"><em>Clin Evid</em></journal-title-abbr>
		<journal-title-abbr lang="es" media="web,print"><em>Evidencia Clínica</em></journal-title-abbr>
		
		<questions lang="en-gb" media="web,print">Questions</questions>
		<questions lang="es" media="web,print">Preguntas</questions>
		
		<interventions lang="en-gb" media="web,print">Interventions</interventions>
		<interventions lang="es" media="web,print">Intervenciones</interventions>
		
		<interventions-byline lang="en-gb" media="web,print">We have searched the evidence for systematic and rigorous answers to the clinical questions and situations below, focusing on the outcomes that matter most to patients and clinicians. We have then categorised each treatment or intervention according to its harms and benefits in those situations.</interventions-byline>
		<interventions-byline lang="es" media="web,print">We have searched the evidence for systematic and rigorous answers to the clinical questions and situations below, focusing on the outcomes that matter most to patients and clinicians. We have then categorised each treatment or intervention according to its harms and benefits in those situations.</interventions-byline>
		
		<new lang="en-gb" media="web,print">New</new>
		<new lang="es" media="web,print">Nuevo</new>
		
		<web-only lang="en-gb" media="web,print">Web only</web-only>
		<web-only lang="es" media="web,print">Web only</web-only>
		
		<beneficial lang="en-gb" media="web,print">Beneficial</beneficial>
		<beneficial lang="es" media="web,print">Beneficiosas</beneficial>
		
		<likely-to-be-beneficial lang="en-gb" media="web,print">Likely to be beneficial</likely-to-be-beneficial>
		<likely-to-be-beneficial lang="es" media="web,print">Probablemente beneficiosas</likely-to-be-beneficial>
		
		<trade-off-between-benefits-and-harms lang="en-gb" media="web,print">Trade-off between benefits and harms</trade-off-between-benefits-and-harms>
		<trade-off-between-benefits-and-harms lang="es" media="web,print">Equilibrio entre beneficios y daños</trade-off-between-benefits-and-harms>
		
		<unknown-effectiveness lang="en-gb" media="web,print">Unknown effectiveness</unknown-effectiveness>
		<unknown-effectiveness lang="es" media="web,print">Efectividad desconocida</unknown-effectiveness>
		
		<unlikely-to-be-beneficial lang="en-gb" media="web,print">Unlikely to be beneficial</unlikely-to-be-beneficial>
		<unlikely-to-be-beneficial lang="es" media="web,print">Probablemente no beneficiosas</unlikely-to-be-beneficial>
		
		<likely-to-be-ineffective-or-harmful lang="en-gb" media="web,print">Likely to be ineffective or harmful</likely-to-be-ineffective-or-harmful>
		<likely-to-be-ineffective-or-harmful lang="es" media="web,print">Probablemente no efectivas o perjudiciales</likely-to-be-ineffective-or-harmful>
		
		<covered-elsewhere lang="en-gb" media="web,print">Covered elsewhere in <em>Clinical Evidence</em></covered-elsewhere>
		<covered-elsewhere lang="es" media="web,print">Otros tema relacionados en <em>Evidencia Clínica</em></covered-elsewhere>
		
		<future-issues lang="en-gb" media="web,print">To be covered in future updates</future-issues>
		<future-issues lang="es" media="web,print">Estáran en futuras ediciones de <em>Evidencia Clínica</em></future-issues>
		<future-updates lang="en-gb" media="web,print">To be covered in future updates</future-updates>
		<future-updates lang="es" media="web,print">Estáran en futuras ediciones de <em>Evidencia Clínica</em></future-updates>
		
		<summary-footnote lang="en-gb" media="web,print">Footnote</summary-footnote>
		<summary-footnote lang="es" media="web,print">Footnote</summary-footnote>
		
		<key-messages lang="en-gb" media="web,print">Key Messages</key-messages>
		<key-messages lang="es" media="web,print">Mensajes clave</key-messages>
		
		<key-point-list lang="en-gb" media="web,print">Key Points</key-point-list>
		<key-point-list lang="es" media="web,print">Mensajes clave</key-point-list>
		
		<key-points lang="en-gb" media="web,print">Key Points</key-points>
		<key-points lang="es" media="web,print">Mensajes clave</key-points>
		
		<about-this-condition lang="en-gb" media="web,print">About this condition</about-this-condition>
		<about-this-condition lang="es" media="web,print">About this condition</about-this-condition>
		
		<background lang="en-gb" media="web,print">About this condition</background>
		<background lang="es" media="web,print">About this condition</background>
		
		<definition lang="en-gb" media="web,print">Definition</definition>
		<definition lang="es" media="web,print">Definición</definition>
		
		<incidence lang="en-gb" media="web,print">Incidence/&#10;Prevalence</incidence>
		<incidence lang="es" media="web,print">Incidencia/&#10;prevalencia</incidence>
		
		<aetiology lang="en-gb" media="web,print">Aetiology/&#10;Risk factors</aetiology>
		<aetiology lang="es" media="web,print">Etiología/&#10;factores &#10;de riesgo</aetiology>
		
		<diagnosis lang="en-gb" media="web,print">Diagnosis</diagnosis>
		<diagnosis lang="es" media="web,print">Diagnosis</diagnosis>
		
		<prognosis lang="en-gb" media="web,print">Prognosis</prognosis>
		<prognosis lang="es" media="web,print">Pronóstico</prognosis>
		
		<aims lang="en-gb" media="web,print">Aims of &#10;intervention</aims>
		<!-- Objetivos de la intervención -->
		<aims lang="es" media="web,print">Objetivos</aims>
		
		<outcomes lang="en-gb" media="web,print">Outcomes</outcomes>
		<outcomes lang="es" media="web,print">Medidas de &#10;resultado</outcomes>
		
		<methods lang="en-gb" media="web,print">Methods</methods>
		<methods lang="es" media="web,print">Métodos</methods>
		
		<in-this-section lang="en-gb" media="web,print">In this section:</in-this-section>
		<in-this-section lang="es" media="web,print">In this section:</in-this-section>
		
		<contributor-details lang="en-gb" media="web,print">Contributor details</contributor-details>
		<contributor-details lang="es" media="web,print">Contributor details</contributor-details>
		
		<competing-interests lang="en-gb" media="web,print">Competing interests</competing-interests>
		<competing-interests lang="es" media="web,print">Competing interests</competing-interests>
		
		<question-list lang="en-gb" media="web,print">Questions</question-list>
		<question-list lang="es" media="web,print">Pregunta</question-list>
		
		<question lang="en-gb" media="web,print">Question</question>
		<question lang="es" media="web,print">Pregunta</question>
		
		<option lang="en-gb" media="web,print">Option</option>
		<option lang="es" media="web,print">Opción</option>
		
		<summary-statement lang="en-gb" media="web,print">Summary statement</summary-statement>
		<summary-statement lang="es" media="web,print">Summary statement</summary-statement>
		
		<summary lang="en-gb" media="web,print">Summary</summary>
		<summary lang="es" media="web,print">Summary</summary>
		
		<benefits lang="en-gb" media="web,print">Benefits</benefits>
		<benefits lang="es" media="web,print">Beneficios</benefits>
		
		<harms lang="en-gb" media="web,print">Harms</harms>
		<harms lang="es" media="web,print">Daños</harms>
		
		<drug-safety-alert lang="en-gb" media="web,print">Drug safety alert</drug-safety-alert>
		<drug-safety-alert lang="es" media="web,print">Drug safety alert</drug-safety-alert>
		
		<comment lang="en-gb" media="web,print">Comment</comment>
		<comment lang="es" media="web,print">Comentario</comment>
		
		<new-option lang="en-gb" media="web,print">New option</new-option>
		<new-option lang="es" media="web,print">New option</new-option>
		
		<new-evidence-conclusions-changed lang="en-gb" media="web,print">New evidence conclusions changed</new-evidence-conclusions-changed>
		<new-evidence-conclusions-changed lang="es" media="web,print">New evidence conclusions changed</new-evidence-conclusions-changed>
		
		<new-evidence-conclusions-confirmed lang="en-gb" media="web,print">New evidence conclusions confirmed</new-evidence-conclusions-confirmed>
		<new-evidence-conclusions-confirmed lang="es" media="web,print">New evidence conclusions confirmed</new-evidence-conclusions-confirmed>
		
		<no-new-evidence lang="en-gb" media="web,print">No new evidence</no-new-evidence>
		<no-new-evidence lang="es" media="web,print">No new evidence</no-new-evidence>
		
		<glossary lang="en-gb" media="web,print">Glossary</glossary>
		<glossary lang="es" media="web,print">Glosario</glossary>
		
		<substantive-change-set lang="en-gb" media="web,print">Substantive changes</substantive-change-set>
		<substantive-change-set lang="es" media="web,print">Cambios importantes desde la última actualización</substantive-change-set>
		
		<substantive-changes lang="en-gb" media="web,print">Substantive changes</substantive-changes>
		<substantive-changes lang="es" media="web,print">Cambios importantes desde la última actualización</substantive-changes>
		
		<substantive-change lang="en-gb" media="web,print">Substantive change</substantive-change>
		<substantive-change lang="es" media="web,print">Cambios importantes desde la última actualización</substantive-change>
		
		<references lang="en-gb" media="web,print">References</references>
		<references lang="es" media="web,print">Referencias</references>
		
		<table lang="en-gb" media="web,print">Table</table>
		<table lang="es" media="web,print">Tabla</table>
		
		<figure lang="en-gb" media="web,print">Figure</figure>
		<figure lang="es" media="web,print">Figure</figure>
		
		<refer-to-fulltext lang="en-gb" media="web,print">Please refere to the <em>Clinical Evidence</em> website for full text and references.</refer-to-fulltext>
		<refer-to-fulltext lang="es" media="web,print">Please refere to the <em>Clinical Evidence</em> website for full text and references.</refer-to-fulltext>
		
		<web-publication-date lang="en-gb" media="web,print">Web publication date:</web-publication-date>
		<web-publication-date lang="es" media="web,print">Web publication date:</web-publication-date>

		<provided-by lang="en-gb" media="web,print">Provided &#10;by</provided-by>
		<provided-by lang="es" media="web,print">Provided &#10;by</provided-by>

		<cr-health-text lang="en-gb" media="web,print">This information is made available to subscribers of ConsumerReportsHealth.org to facilitate discussion with their health-care providers.</cr-health-text>
		<cr-health-text lang="es" media="web,print">This information is made available to subscribers of ConsumerReportsHealth.org to facilitate discussion with their health-care providers.</cr-health-text>
		
		<abstract lang="en-gb" media="web,print">Abstract</abstract>
		<abstract lang="es" media="web,print">Abstract</abstract>
		
		<abstract-intro lang="en-gb" media="web,print">Introduction</abstract-intro>
		<abstract-intro lang="es" media="web,print">Introduction</abstract-intro>
		
		<abstract-methods lang="en-gb" media="web,print">Methods and outcomes</abstract-methods>
		<abstract-methods lang="es" media="web,print">Medidas de resultado Métodos</abstract-methods>
		
		<abstract-results lang="en-gb" media="web,print">Results</abstract-results>
		<abstract-results lang="es" media="web,print">Results</abstract-results>
		
		<abstract-conclusions lang="en-gb" media="web,print">Conclusions</abstract-conclusions>
		<abstract-conclusions lang="es" media="web,print">Conclusions</abstract-conclusions>
		
	</xsl:param>
	
	<xsl:param name="efficacy-order">	
		<beneficial/>
		<likely-to-be-beneficial/>
		<trade-off-between-benefits-and-harms/>
		<unknown-effectiveness/>
		<unlikely-to-be-beneficial/>
		<likely-to-be-ineffective-or-harmful/>
	</xsl:param>
	<xsl:param name="background-order">		
		<definition/>
		<incidence/>
		<aetiology/>
		<diagnosis/>
		<prognosis/>
		<aims/>
		<outcomes/>
		<methods/>
	</xsl:param>
	
	<xsl:param name="clinical-context-order">		
		<general-background/>
		<focus-of-the-review/>
		<comments-on-evidence/>
		<search-and-appraisal-summary/>
		<additional-information/>
	</xsl:param>
	
	<xsl:param name="substantive-changes-order">		
		<new-option/>
		<new-evidence-colclusions-changed/>
		<new-evidence-colclusions-confirmed/>
		<no-new-evidence/>
	</xsl:param>
		
</xsl:stylesheet>
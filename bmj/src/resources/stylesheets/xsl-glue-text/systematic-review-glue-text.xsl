<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:param name="systematic-review-glue-text">
        
        <!-- note!! glue-text is still managed in systematic-review-params.xsl -->
        
        <journal-title lang="en-gb" media="web,print"><em>Clinical Evidence</em></journal-title>
        <journal-title lang="es" media="web,print"><em>Evidencia Clínica</em></journal-title>

        <journal-title-abbr lang="en-gb" media="web,print">Clin Evid</journal-title-abbr>
        
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
        
        <trade-off-between-benefits-and-harms lang="en-gb" media="web,print">Trade off between benefits and harms</trade-off-between-benefits-and-harms>
        <trade-off-between-benefits-and-harms lang="es" media="web,print">Equilibrio entre beneficios y daños</trade-off-between-benefits-and-harms>
        
        <unknown-effectiveness lang="en-gb" media="web,print">Unknown effectiveness</unknown-effectiveness>
        <unknown-effectiveness lang="es" media="web,print">Efectividad desconocida</unknown-effectiveness>
        
        <unlikely-to-be-beneficial lang="en-gb" media="web,print">Unlikely to be beneficial</unlikely-to-be-beneficial>
        <unlikely-to-be-beneficial lang="es" media="web,print">Probablemente no beneficiosas</unlikely-to-be-beneficial>
        
        <likely-to-be-ineffective-or-harmful lang="en-gb" media="web,print">Likely to be ineffective or harmful</likely-to-be-ineffective-or-harmful>
        <likely-to-be-ineffective-or-harmful lang="es" media="web,print">Probablemente no efectivas o perjudiciales</likely-to-be-ineffective-or-harmful>
        
        <covered-elsewhere lang="en-gb" media="web,print">Covered elsewhere in <em>Clinical Evidence</em></covered-elsewhere>
        <covered-elsewhere lang="es" media="web,print">Otros tema relacionados en <em>Evidencia Clínica</em></covered-elsewhere>
        
        <future-updates lang="en-gb" media="web,print">To be covered in future updates</future-updates>
        <future-updates lang="es" media="web,print">Estáran en futuras ediciones de <em>Evidencia Clínica</em></future-updates>
        
        <summary-footnote lang="en-gb" media="web,print">Footnote</summary-footnote>
        <summary-footnote lang="es" media="web,print">Footnote</summary-footnote>
        
        <key-messages lang="en-gb" media="web,print">Key Messages</key-messages>
        <key-messages lang="es" media="web,print">Mensajes clave</key-messages>
        
        <key-points lang="en-gb" media="web,print">Key Points</key-points>
        <key-points lang="es" media="web,print">Mensajes clave</key-points>
        
        <about-this-condition lang="en-gb" media="web,print">About this condition</about-this-condition>
        <about-this-condition lang="es" media="web,print">About this condition</about-this-condition>
        
        <clinical-context lang="en-gb" media="web,print">Clinical context</clinical-context>        
        <general-background lang="en-gb" media="web,print">General background</general-background>        
        <focus-of-the-review lang="en-gb" media="web,print">Focus of the review</focus-of-the-review>        
        <comments-on-evidence lang="en-gb" media="web,print">Comments on evidence</comments-on-evidence>        
        <search-and-appraisal-summary lang="en-gb" media="web,print">Search and appraisal summary</search-and-appraisal-summary>        
        <additional-information lang="en-gb" media="web,print">Additional informatiob</additional-information>        
        
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
        
        <substantive-changes lang="en-gb" media="web,print">Substantive changes</substantive-changes>
        <substantive-changes lang="es" media="web,print">Cambios importantes desde la última actualización</substantive-changes>
        
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
        
        <disclaimer lang="en-gb" media="web,print">The information contained in this publication is intended for medical professionals. Categories presented in Clinical Evidence indicate a judgement about the strength of the evidence available to our contributors prior to publication and the relevant importance of benefit and harms. We rely on our contributors to confirm the accuracy of the information presented and to adhere to describe accepted practices. Readers should be aware that professionals in the field may have different opinions. Because of this and regular advances in medical research we strongly recommend that readers' independently verify specified treatments and drugs including manufacturers' guidance. Also, the categories do not indicate whether a particular treatment is generally appropriate or whether it is suitable for a particular individual. Ultimately it is the readers' responsibility to make their own professional judgements, so to appropriately advise and treat their patients. To the fullest extent permitted by law, BMJ Publishing Group Limited and its editors are not responsible for any losses, injury or damage caused to any person or property (including under contract, by negligence, products liability or otherwise) whether they be direct or indirect, special, incidental or consequential, resulting from the application of the information in this publication.</disclaimer>
        
    </xsl:param>

</xsl:stylesheet>
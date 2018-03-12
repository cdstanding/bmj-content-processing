<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	
	<xsl:param name="strings">
		
		<strings xml:lang="en-gb">
		
			<!-- 
				system to allow:
				id's vs labels
				model for reference reapeating element name
				model to allow different context for reapeating element name
				validation
				fallback 
				on xsl selection can do this by <str> element name or id
				params for tranforming the result string
				allow for mixed markup in instrcution and example fields
				allow for instruction short and long descriptions
				followingstyle property
			-->
		
			<!-- monograph and monograph types  -->
			<str name="monographs">
				<friendly>Monographs</friendly>
				<instruction />
			</str>
		
			<str name="monograph">
				<friendly>Monograph</friendly>
				<instruction />
			</str>
		
			<str name="monograph-full">
				<friendly>Monograph Standard</friendly>
				<instruction />
			</str>
		
			<str name="monograph-eval">
				<friendly>Monograph Evaluation</friendly>
				<instruction />
			</str>
		
			<str name="monograph-overview">
				<friendly>Monograph Overview</friendly>
				<instruction />
			</str>
		
			<str name="monograph-generic">
				<friendly>Monograph Generic</friendly>
				<instruction />
			</str>
			
			<str name="monograph-plan">
				<friendly>Monograph Plan</friendly>
				<instruction />
			</str>
			
			<!-- info -->
			<str name="monograph-info">
				<friendly>Monograph Info</friendly>
				<instruction />
			</str>
			
			<str name="notes">
				<friendly>Notes</friendly>
				<instruction />
			</str>
		
			<str name="credits">
				<friendly>Credits</friendly>
				<instruction />
			</str>
			
			<str name="authors">
				<friendly>Authors</friendly>
				<instruction />
			</str>
			<str name="author">
				<friendly>Author</friendly>
				<instruction />
			</str>
		
			<str name="title-affil">
				<friendly>Title Affil</friendly>
				<instruction />
			</str>
		
			<str name="photo">
				<friendly>Photo</friendly>
				<instruction />
			</str>
		
			<str name="peer-reviewer">
				<friendly>Peer Reviewer</friendly>
				<instruction />
			</str>
		
			<str name="peer-reviewers">
				<friendly>Peer Reviewers</friendly>
				<instruction />
			</str>
		
			<str name="editor">
				<friendly>Editor</friendly>
				<instruction />
			</str>
		
			<str name="editors">
				<friendly>Editors</friendly>
				<instruction />
			</str>
		
			<str name="version-history">
				<friendly>Version History</friendly>
				<instruction />
			</str>
		
			<str name="version">
				<friendly>Version</friendly>
				<instruction />
			</str>
		
			<str name="history">
				<friendly>History</friendly>
				<instruction />
			</str>
		
			<str name="topic-synonyms">
				<friendly>Topic Synonyms</friendly>
				<instruction>If there are any common synonyms for the monograph condition that an end user might
		   be more familiar with, please write them in the boxes below. For example: a synonym for
		   Pseudo-membranous colitis is Clostridium difficile-associated disease (CDAD).</instruction>
			</str>
		
			<str name="synonym">
				<friendly>Synonym</friendly>
				<instruction />
			</str>
		
			<str name="related-topics">
				<friendly>Related Topics</friendly>
				<instruction>This section is to help physicians find related conditions in the BMJ In Practice
		   product. In the boxes below, please list diseases that are: • Similar to the monograph condition
		   • Common or well-recognized complications of the monograph condition • The main risk factors that
		   have a direct relationship (e.g., hypertension for myocardial infarction).</instruction>
			</str>
		
			<str name="related-topic">
				<friendly>Related Topic</friendly>
				<instruction />
			</str>
			
			<str name="monograph-link">
				<friendly>Related Topic</friendly>
				<instruction />
			</str>
			
			<str name="monograph-summary">
				<friendly>Summary</friendly>
				<instruction />
			</str>
		
			<str name="highlights">
				<friendly>Key Highlights</friendly>
				<instruction>In the boxes below, please write 3 to 6 key clinical facts about the monograph
		   condition. You may find it easier to write this section once you have completed the
		  monograph.</instruction>
			</str>
		
			<str name="highlight">
				<friendly>Hightlight</friendly>
				<instruction />
			</str>
		
			<!-- basics -->
			<str name="basics">
				<friendly>Basics</friendly>
				<instruction />
			</str>
		
			<str name="definition">
				<friendly>Definition</friendly>
				<instruction>In the box below, please write a simple definition of the monograph condition in one
		   paragraph. You may include key characteristics of the pathophysiology and/or characteristics from
		   any diagnostic criteria (if available). PLEASE CITE REFERENCES AT THE END OF THE STATEMENTS THE
		   REFERENCES ARE MEANT TO SUPPORT. References can be cited by reference number, e.g., [1][2][3]
		   with the full details listed in the reference section at the end of the monograph. Please do not
		   use any reference formatting in the text, such as Endnote superscripts. </instruction>
			</str>
		
			<str name="classifications">
				<friendly>Classifications</friendly>
				<instruction>Please write in the box below a commonly accepted classification schema for
		   categorizing subtypes/subgroups of the monograph condition. For example: the REAL classification
		   for non-Hodgkin’s lymphoma. If there is more than one classification framework, please write each
		   one in a separate row. If there is a commonly accepted clinical classification system in use that
		   is not a formal classification system, then please state this in the classification detail box.
		   PLEASE CITE THE REFERENCE FROM WHICH THE CLASSIFICATION SCHEMA IS DERIVED.</instruction>
			</str>
		
			<str name="classification">
				<friendly>Classification</friendly>
				<instruction />
			</str>
		
			<str name="vignettes">
				<friendly>Vignette</friendly>
				<instruction />
			</str>
		
			<str name="vignette">
				<friendly>Common Vignette</friendly>
				<instruction />
			</str>
		
			<str name="vignette-1">
				<friendly>Vignette # 1</friendly>
				<instruction>Please write a summary of the most common clinical presentation of the monograph
		   condition into the box below. Please include the following information in your case presentation:
		   • Typical age/gender • Typical/common features in the history. Please format as a case
		   presentation. For example: "A 45-year-old man presents with central crushing chest pain. He is
		   being treated for hypertension and smokes 20 cigarettes a day…" </instruction>
			</str>
		
			<str name="vignette-1">
				<friendly>Vignette # 2</friendly>
				<instruction>Please include this second case presentation ONLY if it occurs as frequently as the
		   case presentation in Common Vignette #1.</instruction>
			</str>
		
			<str name="other-presentations">
				<friendly>Other Presentations</friendly>
				<instruction>Please write in the box below a summary of other ways in which the monograph
		   condition can present. Please include: • Atypical presentations • Highly specific/pathognomic
		   features. PLEASE NOTE THAT WE WOULD LIKE YOU TO WRITE THIS SECTION IN PROSE FORM AND NOT AS A
		   CASE PRESENTATION.</instruction>
			</str>
		
			<str name="epidemiology">
				<friendly>Epidemiology</friendly>
				<instruction>Please write a summary of the epidemiology of the monograph condition, including: •
		   Epidemiology in the U.S. (prevalence, incidence, gender, age group, ethnicity predominance) •
		   U.S. and global trends in incidence/prevalence • Global differences in epidemiology. PLEASE CITE
		   REFERENCES AT THE END OF THE STATEMENTS THE REFERENCES ARE MEANT TO SUPPORT.</instruction>
			</str>
		
			<str name="etiology">
				<friendly>Etiology</friendly>
				<instruction>Please write a summary of the underlying cause for the monograph
		  condition.</instruction>
			</str>
		
			<str name="pathophysiology">
				<friendly>Pathphysiology</friendly>
				<instruction>Please write a summary of pathophysiologic features that are most relevant to the
					diagnosis and management of the monograph condition. Please include implications for treatment,
					if any.</instruction>
			</str>
			<str name="pathphysiology">
				<friendly>Pathphysiology</friendly>
				<instruction>Please write a summary of pathophysiologic features that are most relevant to the
					diagnosis and management of the monograph condition. Please include implications for treatment,
					if any.</instruction>
			</str>
		
			<str name="risk-factors">
				<friendly>Risk Factors</friendly>
				<instruction />
			</str>
		
			<str name="prevention">
				<friendly>Prevention</friendly>
				<instruction>Please write a brief summary of primary prevention measures for the monograph
		   condition. For example: cholesterol reduction in coronary heart disease or vaccines to prevent
		   influenza.</instruction>
			</str>
		
			<!-- diagnosis -->
			<str name="diagnosis">
				<friendly>Diagnosis</friendly>
				<instruction />
			</str>
		
			<str name="diagnostic-factors">
				<friendly>History and Exam, Diagnostic Factors</friendly>
				<instruction>Please include from 10 to 20 diagnostic factors (one per row). Start with history
		   (e.g., patient characteristics, age, gender, past medical history, behavioral risk factors,
		   family history) then symptoms followed by signs on physical examination. Please list the factors
		   you have put in the common vignette and other clinical clues. PLEASE CITE REFERENCES AT THE END
		   OF THE STATEMENTS THE REFERENCES ARE MEANT TO SUPPORT. </instruction>
			</str>
		
			<str name="tests">
				<friendly>Tests</friendly>
				<instruction />
			</str>
		
			<str name="test">
				<friendly>Test</friendly>
				<instruction />
			</str>
		
			<str name="differentials">
				<friendly>Differentials</friendly>
				<instruction>For each differential diagnosis, please write the key characteristics in the history and physical examination that will distinguish the differential condition from the monograph condition. Please describe how symptoms and signs differ from those found in the monograph condition. PLEASE CITE REFERENCES AT THE END OF THE STATEMENTS THE REFERENCES ARE MEANT TO SUPPORT. : Please give the tests that are used to differentiate this condition from the monograph condition. PLEASE GIVE THE EXPECTED RESULTS OF THE TESTS. For example: CT will show intracerebral hematomas. If the test result is a blood test please give the expected value of the blood test (e.g., ALP >150 IU/L). PLEASE CITE REFERENCES AT THE END OF THE STATEMENTS THE REFERENCES ARE MEANT TO SUPPORT.</instruction>
			</str>
			<str name="differential">
				<friendly>Differential</friendly>
				<instruction />
			</str>
			<str name="differentials-history-and-exam">
				<friendly>History and Exam</friendly>
				<instruction />
			</str>
			<str name="differentials-tests">
				<friendly>Diagnostic Tests</friendly>
				<instruction />
			</str>
			
			<str name="true-differential-group">
				<friendly>Common</friendly>
				<instruction />
			</str>
			<str name="false-differential-group">
				<friendly>Uncommon</friendly>
				<instruction />
			</str>
			
			<str name="true-test-group">
				<friendly>1st Tests</friendly>
				<instruction />
			</str>
			<str name="false-test-group">
				<friendly>Other Tests</friendly>
				<instruction />
			</str>
		
			<str name="diagnostic-criteria">
				<friendly>Diagnostic Criteria</friendly>
				<instruction>Please write a summary of the commonly accepted diagnostic criteria that are used to
		   diagnose the monograph condition (e.g., Jones criteria for diagnosis of rheumatic fever). PLEASE
		   CITE THE REFERENCE FROM WHICH THE DIAGNOSTIC CRITERIA ARE DERIVED.</instruction>
			</str>
		
			<str name="screening">
				<friendly>Screening</friendly>
				<instruction>Please write a summary/overview of the approach to screening of the ASYMPTOMATIC
		   POPULATION. Please include: • Reason for screening, including impact of screening and early
		   treatment • Which populations to screen • Tests to use and when • Evidence to support screening.
		   If the asymptomatic population is not generally screened for the monograph condition, then please
		   leave blank. If the absence of screening notable or important please comment. PLEASE CITE
		   REFERENCES AT THE END OF THE STATEMENTS THE REFERENCES ARE MEANT TO SUPPORT. </instruction>
			</str>
		
			<!-- treatment -->
			<str name="treatment">
				<friendly>Treatment</friendly>
				<instruction />
			</str>
		
			<str name="tx-options">
				<friendly>Treatment Options</friendly>
				<instruction />
			</str>
		
			<str name="tx-option">
				<friendly>Treatment Option</friendly>
				<instruction />
			</str>

			<str name="tx-type">
				<friendly>Treatment Type</friendly>
				<instruction />
			</str>
			
			<str name="tx-line">
				<friendly>Treatment Line</friendly>
				<instruction />
			</str>
			<str name="tx-line-1">
				<friendly>1st</friendly>
				<instruction />
			</str>
			<str name="tx-line-2">
				<friendly>2nd</friendly>
				<instruction />
			</str>
			<str name="tx-line-3">
				<friendly>3rd</friendly>
				<instruction />
			</str>
			<str name="tx-line-4">
				<friendly>4th</friendly>
				<instruction />
			</str>
			<str name="tx-line-5">
				<friendly>5th</friendly>
				<instruction />
			</str>
			<str name="tx-line-A">
				<friendly>adjunct</friendly>
				<instruction />
			</str>
			<str name="tx-line-P">
				<friendly>plus</friendly>
				<instruction />
			</str>
		
			<str name="timeframe">
				<friendly>Timeframe</friendly>
				<instruction />
			</str>
		
			<str name="components">
				<friendly>Components</friendly>
				<instruction />
			</str>
		
			<str name="component">
				<friendly>Component</friendly>
				<instruction />
			</str>
		
			<str name="tier">
				<friendly>Tier</friendly>
				<instruction />
			</str>
		
			<str name="pt-group">
				<friendly>Patient Group</friendly>
				<instruction />
			</str>
		
			<str name="parent-pt-group">
				<friendly>Parent Patient Group</friendly>
				<instruction />
			</str>
		
			<str name="regimens">
				<friendly>Regimens</friendly>
				<instruction />
			</str>
		
			<str name="regimen">
				<friendly>Regimen</friendly>
				<instruction />
			</str>
			
			<str name="1-regimen-group">
				<friendly>Primary Options</friendly>
				<instruction />
			</str>
			<str name="2-regimen-group">
				<friendly>Secondary Options</friendly>
				<instruction />
			</str>
			<str name="3-regimen-group">
				<friendly>Tertiary Options</friendly>
				<instruction />
			</str>
			<str name="4-regimen-group">
				<friendly>Quaternary Options</friendly>
				<instruction />
			</str>
			<str name="5-regimen-group">
				<friendly>Quinary Options</friendly>
				<instruction />
			</str>
		
			<str name="regimen-tier">
				<friendly>Regimen Tier</friendly>
				<instruction />
			</str>
		
			<str name="regimen-name">
				<friendly>Regimen Name</friendly>
				<instruction />
			</str>
		
			<str name="treatment-name">
				<friendly>Tx Name</friendly>
				<instruction />
			</str>
		
			<str name="treatment-details">
				<friendly>Drug Dosing/Tx Detail</friendly>
				<instruction />
			</str>
		
			<str name="modifier">
				<friendly>Modifier</friendly>
				<instruction />
			</str>
		
			<str name="emerging-txs">
				<friendly>Emerging Treatments</friendly>
				<instruction>Please write a brief summary about the emerging treatment. Please include the
		   following: • How the new treatment works (or is presumed to work) • Whether the new treatment is
		   FDA approved • When the new treatment is expected to be available (if possible) • What effect
		   trials (if any) have shown • What/when further trials (if any) are planned • Alternative options
		   if the new treatment fails (the alternatives could include current treatments) • Which patients
		   the new treatment may be suitable for. PLEASE CITE REFERENCES AT THE END OF THE STATEMENT THE
		   REFERENCES ARE MEANT TO SUPPORT. </instruction>
			</str>
		
			<str name="emerging-tx">
				<friendly>Emerging Treatment</friendly>
				<instruction />
			</str>
		
			<!-- followup -->
			<str name="followup">
				<friendly>Followup</friendly>
				<instruction>Please write an overview of any long-term monitoring of the monograph condition (if
		   applicable) that the physician should carry out. Please try to be specific. For example: "HbA1c
		   should be measured every 3 to 6 months."</instruction>
			</str>
			<str name="outlook">
				<friendly>Outlook</friendly>
				<instruction>In the box below, please write a summary of the prognosis for the patient following
		   treatment. What is the prognosis/typical course for this condition? What is the natural course of
		   this disease (once treated)? Will it recur? Brief information about complications can be
		   included, but please do not go into detail as this will be covered in a separate complications
		   section. PLEASE CITE REFERENCES AT THE END OF THE STATEMENTS THE REFERENCES ARE MEANT TO SUPPORT.
				</instruction>
			</str>
		
			<str name="complications">
				<friendly>Complications</friendly>
				<instruction />
			</str>
		
			<str name="complication">
				<friendly>Complication</friendly>
				<instruction />
			</str>
			
			<str name="recommendations">
				<friendly>Recommendations</friendly>
				<instruction />
			</str>
		
			<str name="monitoring">
				<friendly>Monitoring</friendly>
				<instruction>Please write an overview of any long-term monitoring of the monograph condition (if
		   applicable) that the physician should carry out. Please try to be specific. For example: "HbA1c
		   should be measured every 3 to 6 months."</instruction>
			</str>
		
			<str name="patient-instructions">
				<friendly>Patient Instructions</friendly>
				<instruction>Please write an overview of what physicians should advise patients about. This may
		   include self-help instructions such as how often to monitor blood glucose and when to come back
		   for follow-up.</instruction>
			</str>
		
			<str name="preventive-actions">
				<friendly>Secondary Prevention</friendly>
				<instruction>Please write a brief overview of secondary prevention measures for the monograph
		   condition. For example: screening of close contacts, treating STDs in sexual partners, removing
		   allergens.</instruction>
			</str>
			
			<str name="disease-subtypes">
				<friendly>Disease subtypes</friendly>
				<instruction />
			</str>
			
			<str name="subtype">
				<friendly>Subtype</friendly>
				<instruction />
			</str>
		
			<!-- references section -->
			<str name="references">
				<friendly>References</friendly>
				<instruction />
			</str>
			<str name="citation">
				<friendly>Citation</friendly>
				<instruction />
			</str>
			
			<str name="combined-references">
				<friendly>Referenced Articles</friendly>
				<instruction />
			</str>
			<str name="article-references">
				<friendly>Referenced Articles</friendly>
				<instruction />
			</str>
			<str name="key-article-references">
				<friendly>Key Articles</friendly>
				<instruction />
			</str>
			<str name="article-refs">
				<friendly>Referenced Articles</friendly>
				<instruction />
			</str>
			<str name="article-ref">
				<friendly>Referenced Article</friendly>
				<instruction />
			</str>
			
			<str name="abstract-url">
				<friendly>Abstract</friendly>
				<instruction />
			</str>
			
			<str name="key-articles">
				<friendly>Key Articles</friendly>
				<instruction />
			</str>
			<str name="key-article">
				<friendly>Key Article</friendly>
				<instruction />
			</str>
			<str name="online-references">
				<friendly>Other Online Resources</friendly>
				<instruction />
			</str>
			<str name="online-refs">
				<friendly>Other Online Resources</friendly>
				<instruction />
			</str>
			<str name="online-ref">
				<friendly>Online Resource</friendly>
				<instruction />
			</str>
			
			<str name="evidence-scores">
				<friendly>Evidence Scores</friendly>
				<instruction />
			</str>
			
			<str name="evidence-score">
				<friendly>Evidence Score</friendly>
				<instruction />
			</str>
			
			<str name="clinical-refs">
				<friendly>Clinical References</friendly>
				<instruction />
			</str>
		
			<str name="clinical-ref">
				<friendly>Clinical Reference</friendly>
				<instruction />
			</str>
		
			<str name="score">
				<friendly>Score</friendly>
				<instruction />
			</str>
		
			<str name="image-refs">
				<friendly>Image References</friendly>
				<instruction />
			</str>
		
			<str name="image-ref">
				<friendly>Image Reference</friendly>
				<instruction />
			</str>
		
			<str name="filename">
				<friendly>Filename</friendly>
				<instruction />
			</str>
		
			<str name="caption">
				<friendly>Caption</friendly>
				<instruction />
			</str>
		
			<str name="source">
				<friendly>Source</friendly>
				<instruction />
			</str>
		
			<str name="last-accessed">
				<friendly>Last Accessed</friendly>
				<instruction />
			</str>
		
			<str name="last-published">
				<friendly>Last Published</friendly>
				<instruction />
			</str>
		
			<str name="option-link">
				<friendly>Clinical Evidence</friendly>
				<instruction />
			</str>
			<str name="fulltext-url">
				<friendly>Full Text </friendly>
				<instruction />
			</str>
			<str name="url">
				<friendly>URL</friendly>
				<instruction />
			</str>
			<str name="guideline-url">
				<friendly>View Guidelines</friendly>
				<instruction />
			</str>
		
			<!-- common -->
			<str name="comments">
				<friendly>Comments</friendly>
				<instruction />
			</str>
		
			<str name="detail">
				<friendly>Detail</friendly>
				<instruction />
			</str>
		
			<str name="summary">
				<friendly>Summary</friendly>
				<instruction />
			</str>
			
			<str name="sections">
				<friendly>Sections</friendly>
				<instruction />
			</str>
		
			<str name="section">
				<friendly>Section</friendly>
				<instruction />
			</str>
		
			<str name="section-header">
				<friendly>Section Header</friendly>
				<instruction />
			</str>
		
			<str name="section-text">
				<friendly>Section Text</friendly>
				<instruction />
			</str>
		
			<str name="para">
				<friendly>Paragraph</friendly>
				<instruction />
			</str>
		
			<str name="list">
				<friendly>List</friendly>
				<instruction />
			</str>
		
			<str name="item">
				<friendly>Item</friendly>
				<instruction />
			</str>
		
			<str name="title">
				<friendly>Title</friendly>
				<instruction />
			</str>
		
			<str name="name">
				<friendly>Name</friendly>
				<instruction />
			</str>
		
			<str name="result">
				<friendly>Result</friendly>
				<instruction />
			</str>
		
			<str name="approach">
				<friendly>Approach</friendly>
				<instruction />
			</str>
		
			<str name="guidelines">
				<friendly>Guidelines</friendly>
				<instruction />
			</str>
		
			<!-- inline -->
			<str name="foot">
				<friendly>Foot</friendly>
				<instruction />
			</str>
		
			<str name="images">
				<friendly>Image Library</friendly>
				<instruction>We would like to include an appropriate image for the title page of every monograph.
					Please email images as a separate attachment containing photos (as jpeg or gif file), algorithms,
					figures or tables etc. If permission is required, please send us any relevant documentation.
					However, if you wish to include a clearly identifiable patient image, please request a permission
					form from BMJ. </instruction>
			</str>
			
			<str name="figures">
				<friendly>Image Library</friendly>
				<instruction/>
			</str>
		
			<str name="image">
				<friendly>Image</friendly>
				<instruction />
			</str>
		
			<str name="inline">
				<friendly>Inline</friendly>
				<instruction />
			</str>
		
			<str name="organism">
				<friendly>Organism</friendly>
				<instruction />
			</str>
		
			<str name="criteria">
				<friendly>Criteria</friendly>
				<instruction />
			</str>
		
			<str name="date">
				<friendly>Date</friendly>
				<instruction />
			</str>
		
			<str name="ddx-etiology">
				<friendly>Differential Etiology</friendly>
				<instruction />
			</str>
		
			<str name="ddx-name">
				<friendly>Differential Name</friendly>
				<instruction />
			</str>
		
			<str name="disclosures">
				<friendly>Disclosures</friendly>
				<instruction />
			</str>
		
			<str name="exam">
				<friendly>Exam</friendly>
				<instruction />
			</str>
		
			<str name="risk-factor">
				<friendly>Risk Factor</friendly>
				<instruction />
			</str>
		
			<str name="factor">
				<friendly>Factor</friendly>
				<instruction />
			</str>
		
			<str name="factor-name">
				<friendly>Factor Name</friendly>
				<instruction />
			</str>
		
			<str name="frequency">
				<friendly>Frequency</friendly>
				<instruction />
			</str>
		
			<str name="global-prevalence">
				<friendly>Global Prevalence</friendly>
				<instruction />
			</str>
		
			<str name="key-factor">
				<friendly>Key Factor</friendly>
				<instruction />
			</str>
			
			<str name="true-factor-group">
				<friendly>Key Diagnostic Factors</friendly>
				<instruction />
			</str>
			<str name="false-factor-group">
				<friendly>Other Diagnostic Factors</friendly>
				<instruction />
			</str>
			<str name="unset-factor-group">
				<friendly>Unset Key Factor</friendly>
				<instruction />
			</str>
			
			<str name="acute-tx-option-group">
				<friendly>Acute</friendly>
				<instruction />
			</str>
			<str name="ongoing-tx-option-group">
				<friendly>Ongoing</friendly>
				<instruction />
			</str>
			<str name="presumptive-tx-option-group">
				<friendly>Presumptive</friendly>
				<instruction />
			</str>
			
			<str name="likelihood">
				<friendly>Likelihood</friendly>
				<instruction />
			</str>
		
			<str name="morbidity">
				<friendly>Morbidity</friendly>
				<instruction />
			</str>
		
			<str name="overview">
				<friendly>Overview</friendly>
				<instruction />
			</str>
		
			<str name="revised-by">
				<friendly>Revised by</friendly>
				<instruction />
			</str>
		
			<str name="sign-symptoms">
				<friendly>Sign/Symptoms</friendly>
				<instruction/>
			</str>
		
			<str name="statistics">
				<friendly>Statistics</friendly>
				<instruction />
			</str>
		
			<str name="strength">
				<friendly>Strength</friendly>
				<instruction />
			</str>
			
			<str name="strong-risk-factor-group">
				<friendly>Strong</friendly>
				<instruction />
			</str>
			<str name="weak-risk-factor-group">
				<friendly>Weak</friendly>
				<instruction />
			</str>
			<str name="Unset-risk-factor-group">
				<friendly>Unset Strength</friendly>
				<instruction />
			</str>
			
			<str name="type">
				<friendly>Type</friendly>
				<instruction />
			</str>
			
			<str name="first">
				<friendly>First</friendly>
				<instruction />
			</str>
		
			<str name="urgent-considerations">
				<friendly>Urgent Considerations</friendly>
				<instruction />
			</str>
		
			<str name="diagnostic-approach">
				<friendly>Diagnostic Approach</friendly>
				<instruction />
			</str>
		
			<str name="us-prevalence">
				<friendly>US Prevalence</friendly>
				<instruction />
			</str>
			
			<str name="categories">
				<friendly>Categories</friendly>
				<instruction />
			</str>
		
			<str name="category">
				<friendly>Category</friendly>
				<instruction />
			</str>
		
			<!--attributes-->
			<str name="dx-id">
				<friendly>ID</friendly>
				<instruction />
			</str>
		
			<str name="id">
				<friendly>ID</friendly>
				<instruction />
			</str>
		
			<str name="id-ref">
				<friendly>ID</friendly>
				<instruction />
			</str>
		
			<str name="style">
				<friendly>Style</friendly>
				<instruction />
			</str>
		
			<str name="order">
				<friendly>Order</friendly>
				<instruction />
			</str>
			
			<str name="initial-test-group">
				<friendly>1st Tests To Order</friendly>
				<instruction />
			</str>
			<str name="subsequent-test-group">
				<friendly>Other Tests to Consider</friendly>
				<instruction />
			</str>
			<str name="emerging-test-group">
				<friendly>Emerging Tests</friendly>
				<instruction />
			</str>
			<str name="unset-test-group">
				<friendly>Unset Order</friendly>
				<instruction />
			</str>
		
			<str name="red-flag">
				<friendly>Red Flag</friendly>
				<instruction />
			</str>
		
			<str name="common">
				<friendly>Common</friendly>
				<instruction />
			</str>
		
			<str name="cols">
				<friendly>Columns</friendly>
				<instruction />
			</str>
		
		</strings>		
		
	</xsl:param>
	
</xsl:stylesheet>

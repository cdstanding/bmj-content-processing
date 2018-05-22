<?xml version="1.0" encoding="UTF-8"?>

<!-- This performs validation checks on the JATS XML after creation from eXtyles for rules specific to BMJ production processes-->

<sch:schema 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    queryBinding="xslt2">
    <sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
    <sch:title>BMJ Schematron</sch:title>
    
    
    <sch:pattern>
        <sch:title>Check for valid filename of XML file against article ID</sch:title>
        <sch:rule context="article/front/article-meta/article-id[@pub-id-type = 'publisher-id']">
            <sch:report
                test="not(./text() eq replace(document-uri(/), '.*?([^\\|^/|^\.]+)\..*$', '$1'))"
                role="error"
                >The filename of the XML should match the article ID in the XML. Please make sure these match. If this is for the short version of your article, check the long version folder in the content store and delete any instances of the short version if they are present.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:title>Check for the presence of a volume number</sch:title>
        <sch:rule context="article-meta">
            <sch:assert test="volume/text()" role="warning"
                >The article does not contain a volume number. Will not be able to create "Cite this as:" line.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:title>Check for elocation ID</sch:title>
        <sch:rule context="article/front/article-meta">
            <sch:assert test="elocation-id/text()" role="error"
                >The elocation ID is not present. Please make sure to include this.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:title>Check for publication date (Temporary check for date due to ID XSLT expecting this. 
            Should not be required in future as Tech Eds will not necessarily know the date at this point)</sch:title>
        <sch:rule context="article/front/article-meta">
            <sch:assert test="pub-date[@pub-type = 'epub']/year/text()" role="error">The publication date is not present and your article may have failed to process. Please enter the publication date in eXtyles and run your article through the process again.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:title>Check for correct article ID DOI naming convention for BMJ and SBMJ</sch:title>
        <sch:rule context="//article-id[@pub-id-type='doi']">
            <sch:report test="text()[not(matches(.,'^\d+.\d+(/bmj.|/sbmj.)\D+\d+'))]" role="error"
                >The DOI article ID does not follow the correct naming convention, for example this should look like '10.1136/bmj.a1234' or '10.1136/sbmj.a1234'.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:title>Check for bold tags in article title</sch:title>
        <sch:rule context="front/article-meta/title-group/article-title">
            <sch:report test="bold" role="error">Article title contains a &lt;bold&gt; tag. Please remove this in eXtyles and process again. This will cause problems with online rendition.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:title>Check for empty hrefs in graphics</sch:title>
        <sch:rule context="fig/graphic">
            <sch:assert test="@xlink:href != ''" role="error">There are no links to the graphic file. Please check your styles in eXtyles and apply the correct style</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:title>Check for the use of inline graphics (these cause a problem with graphic import and are generally not used even though they are allowed in the schema)</sch:title>
        <sch:rule context="p/inline-graphic">
            <sch:report test="." role="error">Inline graphic has been used here. Please check your tagging in eXtyles and make sure your figure is tagged as Fig Caption with surrounding &lt;graphic&gt; tags</sch:report>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:title>Check for empty hrefs in supplementary files</sch:title>
        <sch:rule context="supplementary-material/media">
            <sch:assert test="@xlink:href != ''" role="error" >There are no links to the supplementary file. Please check your styles in eXtyles and apply the correct style</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:title>Check for empty subject</sch:title>
        <sch:rule context="article-categories/subj-group/subject">
            <sch:assert test=". != ''" role="error">The article "subject" is not present. Please make sure to include this then process the article again.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:title>Check for DOI outside of &lt;pub-id&gt; in references</sch:title>
        <sch:rule context="//mixed-citation/pub-id[@pub-id-type='doi']">
            <sch:report test="./preceding-sibling::text()[contains(.,'doi')]" role="error">This DOI is not marked up properly in the references, please check this reference in eXtyles and make sure that the text "doi:" is highlighted with the rest of the DOI. If this is unhighlighted text, select the full string of text - making sure to include the text "doi:" - then style manually from the style drop-down menu with the style "bib_doi".</sch:report>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:title>Check for correct Pub Date Year</sch:title>
        <sch:rule context="//pub-date/year">
            <sch:assert test="./text() = year-from-date(current-date())" role="warning">The Pub Date year does not match the current year. Unless this article is for embargo next year, please make sure to enter this correctly in the eXtyles Update Document Information window.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern>
        <sch:title>Check for correct Copyright Year</sch:title>
        <sch:rule context="//permissions/copyright-year">
            <sch:assert test="./text() = year-from-date(current-date())" role="warning">The copyright year does not match the current year. Unless this article is for embargo next year,  please make sure to enter this correctly in the eXtyles Update Document Information window.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:title>Check for correct figure markup</sch:title>
        <sch:rule context="//fig[not(label)][count(//fig) > 1]/caption/p">
            <sch:assert test="./text() = //fig/graphic/@xlink:href" role="error">The figure ID in the XML and the graphic link in the XML do not match. If this is a captionless figure, make sure to surround the figure ID with &lt;graphic&gt; tags in eXtyles (e.g. &lt;graphic&gt;abcd1234.f1&lt;/graphic&gt;), otherwise this will output a default name ending in a letter for the graphic link in the XML (for example, &lt;graphic&gt;abcd1234.fa&lt;/graphic&gt;). If this figure should have a caption, make sure to style this with "Fig[number]" followed by the caption text, for example, "Fig 1 The caption goes here".</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:title>Check for Topic codes for Careers</sch:title>
        <sch:rule context="//article-categories/subj-group[@subj-group-type='heading'][subject/text()[contains(.,'Careers')]]">
            <sch:assert test="//article-categories/subj-group[@subj-group-type='hwp-journal-coll']" role="error">There are no topic codes for this article, please add the corresponding topic code/s.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:title>Check for Topic codes for Careers: Make sure codes are no longer than 4 characters long</sch:title>
        <sch:rule context="//article-categories/subj-group[@subj-group-type='heading'][subject/text()[contains(.,'Careers')]]">
            <sch:report test="//article-categories/subj-group[@subj-group-type='hwp-journal-coll']/subject/text()[matches(.,'([0-9]+){5}')]" role="error">One or more topic codes contain more than 4 characters. Check the topic codes to see that they are all 4 characters long.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:title>Check for spaces in xlink:hrefs</sch:title>
        <sch:rule context="//pub-id[@pub-id-type='doi']">
            <sch:report test="text()[contains(.,' ')]" role="error">DOI link contains spaces, check in the Word document for any spaces (including line breaks) and remove.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:title>Check for ext-link in Corrections articles</sch:title>
        <sch:rule context="subj-group[@subj-group-type='heading']/subject[contains(.,'Corrections')]">
            <sch:assert test="./following::ext-link[@ext-link-type='doi']" role="error">This article does not contain a valid DOI. This is required to generate the related article link. Please make sure the DOI for the related article is properly formatted in the Word doc, with no spaces and no extra formatting/styling. For example: "doi:10.1136/bmj.a1234".</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:title>Check for 'title' in 'fn' to prevent failure when transforming from JATS to NLM XML</sch:title>
        <sch:rule context="//ack">
            <sch:report test="title" role="error">Acknowledgements should not contain a title.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:title>Check for missing authors in an article. Give a warning if no authors are present.</sch:title>
        <sch:rule context="//article-meta">
            <sch:assert test="contrib-group" role="warning">Authors have not been tagged for this article or they have not been included.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:title>Check for empty ext-link tags.</sch:title>
        <sch:rule context="//ext-link">
            <sch:report test=".[not(text())]" role="error">This link does not contain any text. Please insert a valid URI for this link.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:title>Check for any file extension added to supplementary file reference.</sch:title>
        <sch:rule context="//supplementary-material/media">
            <sch:report test="@xlink:href[matches(.,'(.+)(\.avi|\.doc|\.docx|\.eps|\.gif|\.jpg|\.jpeg|\.mpg|\.pdf|\.tif|\.tiff|\.xls)')]" role="error">The reference to the supplementary material contains a file extension, this may cause a problem with file checking in the folder. Please remove the file extension in the reference in Word and process again.</sch:report>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="1.1">
    
    <!-- THIS STYLESHEET IS DOCUMENT IS SHARED WITH OTHER PROJECTS -->
    <!-- 
        this inluded and shared stylesheet for different output formats tries to 
        match what we think are a repeating structure outline in the source xml 
        and then we pass them ysing call-template  to an output format specific 
        stylesheet to handle what the format should be on output ie downcast rtf, 
        serna fo, pdf fo, oak, etc. xml
    -->
    
    <xsl:template match="
        monograph-full | 
        monograph-eval | 
        monograph-overview | 
        monograph-generic | 
        bmjk-monograph-plan
        " 
        priority="2">
        
        <xsl:call-template name="process-fo-root"/>
                
    </xsl:template>
    
    <xsl:template match="monograph-info">
        <xsl:call-template name="process-info-level"/>
    </xsl:template>
    
    <xsl:template match="
        notes | 
        
        basics[ancestor::monograph-full] | 
        diagnosis[ancestor::monograph-full] | 
        treatment[ancestor::monograph-full] | 
        followup[ancestor::monograph-full] | 
        
        overview[ancestor::monograph-eval] | 
        ddx-etiology[ancestor::monograph-eval] |
        urgent-considerations[ancestor::monograph-eval] |
        diagnostic-approach[ancestor::monograph-eval] |
        differentials[ancestor::monograph-eval] |
        
        summary[ancestor::monograph-overview] | 
        disease-subtypes[ancestor::monograph-overview] |
        
        sections[ancestor::monograph-generic] |
        
        references
        "><!-- differentials[ancestor::monograph-eval] |-->
        
        <xsl:call-template name="process-level-1-section-with-heading"/>
        
    </xsl:template>
    
    <!--<xsl:template match="highlights">
        
        <xsl:call-template name="process-level-1-section-with-heading-and-with-implied-list-content"/>
        
    </xsl:template>-->
    
    <xsl:template match="
        diagnostic-factors | 
        tests | 
        tx-options |
        differentials[parent::monograph-eval]
        " 
        mode="summary">
        
        <xsl:call-template name="process-summary-level"/>
        
    </xsl:template>
    
    <!-- TODO move preventive-actions after presebtion and change title to 'secondarry prevention' --> 
    <!--    /monograph-full/basics/prevention    -->
    <!--    /monograph-full/followup/recommendations/preventive-actions    -->
    
    <xsl:template match="
        statistics | 
        definition | 
        classifications | 
        vignettes | 
        other-presentations | 
        epidemiology | 
        etiology | 
        pathophysiology | 
        prevention | 
        diagnostic-criteria | 
        screening | 
        guidelines[parent::treatment or parent::diagnosis and ancestor::monograph-full] | 
        approach[parent::treatment or parent::diagnosis and ancestor::monograph-full] | 
        emerging-txs | 
        outlook | 
        complications | 
        recommendations | 
        differentials[parent::diagnosis and ancestor::monograph-full] |
        evidence-scores |
        key-article-references |
        online-references |
        article-references | 
        figures
        "><!--figures | combined-references | article-references -->
        
        <xsl:call-template name="process-level-2-section-with-heading"/>
        
    </xsl:template>
       
    <xsl:template match="
        highlights | 
        categories[category[1][string-length(normalize-space(.))!=0]] | 
        topic-synonyms | 
        related-topics | 
        patient-summaries
        ">
        
        <xsl:call-template name="process-level-2-section-with-heading-and-with-implied-list-content"/>
        
    </xsl:template>
    
    <xsl:template match="
        risk-factors | 
        diagnostic-factors | 
        tests[parent::diagnosis and ancestor::monograph-full] | 
        tx-options[parent::treatment]  
        ">
        
        <xsl:call-template name="process-level-2-section-with-heading-and-with-implied-grouping"/>
        
    </xsl:template>
    
    <xsl:template match="
        differentials[parent::monograph-eval]
        ">
        
        <xsl:call-template name="process-level-2-section-with-heading-and-with-implied-grouping-differential-history-and-exam"/>
        <xsl:call-template name="process-level-2-section-with-heading-and-with-implied-grouping-differential-tests"/>
        
    </xsl:template>
    
    <xsl:template match="
        us-prevalence | 
        global-prevalence | 
        morbidity | 
        vignette | 
        monitoring | 
        patient-instructions | 
        preventive-actions 
        ">
        
        <xsl:call-template name="process-level-3-section-with-heading"/>
        
    </xsl:template>
    
    <xsl:template match="
        classification | 
        risk-factor | 
        criteria | 
        factor | 
        emerging-tx | 
        guideline[ancestor::treatment or ancestor::diagnosis and ancestor::monograph-full] | 
        subtype[ancestor::monograph-overview]
        ">
        
        <xsl:call-template name="process-level-3-section-with-ordered-content" />
        
    </xsl:template>
    
    <xsl:template match="test[ancestor::diagnosis and ancestor::monograph-full]">
        
        <xsl:call-template name="process-level-3-section-with-tabulated-content-test" />
        
    </xsl:template>
    
    <xsl:template match="differential[ancestor::diagnosis and ancestor::monograph-full]">
        
        <xsl:call-template name="process-level-3-section-with-tabulated-content-differential" />
        
    </xsl:template>
    
    <xsl:template match="complication">
        
        <xsl:call-template name="process-level-3-section-with-tabulated-content-complication" />
        
    </xsl:template>
    
    <xsl:template match="
        exam | 
        history[parent::differential]  
        ">
        
        <xsl:call-template name="process-level-4-section-with-heading-and-with-para-and-list-content"/>
        
    </xsl:template>
    
    <xsl:template match="
        summary[not(ancestor::monograph-overview)]
        ">
        
        <!-- TODO if we are to imply list content then we should assume the schema only allows para's and not alternatively lists !! -->
        <xsl:call-template name="process-level-4-section-with-heading-and-with-implied-list-content"/>
        
    </xsl:template>
    
    <xsl:template match="
        detail[parent::risk-factor] | 
        detail[parent::factor] |  
        detail[parent::test] | 
        detail[parent::complication] |
        comments |
        sign-symptoms |
        tests[parent::differential and ancestor::monograph-full]  
        ">
        
        <!-- TODO if we are to imply list content then we should assume the schema only allows para's and not alternatively lists !! -->
        <xsl:call-template name="process-level-4-section-without-heading-and-with-implied-list-content"/>
        
    </xsl:template>
    
    <xsl:template match="
        detail[parent::classification] | 
        detail[parent::criteria] | 
        detail[parent::emerging-tx] | 
        detail[parent::subtype] 
        ">
        
        <xsl:call-template name="process-level-4-section-without-heading-and-with-para-and-list-content"/>
        
    </xsl:template>
    
</xsl:stylesheet>

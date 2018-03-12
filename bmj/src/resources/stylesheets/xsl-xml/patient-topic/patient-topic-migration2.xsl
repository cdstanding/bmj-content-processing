<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  version="2.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:output 
        method="xml" 
        encoding="UTF-8"
        indent="yes"/>
    
    <xsl:strip-space elements="*"/>
    
    <!-- 
        stylesheet to format for transformed1 xml
        partitioning each sec in description and treatment-points into corresponding type
        - creating description (overview, key-points, explanation, risk factor, classification) 
        - creating treatment-points (introduction, key-points, treatment-groups)
        
        TODO: 
        know how to distinguish a section for staging in description and treatment-approach in treatment-points
    -->
    
    
    <xsl:key name="KeyPoints" match="sec[title[contains(text(), 'Key points') or contains(text(), 'Key messages')]]" use="generate-id(parent::description)"/>
    <xsl:key name="DescriptionExplanation" match="sec[title[contains(text(), 'What') or contains(text(), 'How') or contains(text(), 'Your')]]" use="generate-id(parent::description)"/>
    <xsl:key name="DescriptionRiskFactor" match="sec[title[contains(text(), 'Why me') or contains(text(), 'Risk factor') or contains(text(), 'risk factor')]]" use="generate-id(parent::description)"/>
    <xsl:key name="DescriptionClassification" match="sec[title[contains(text(), 'Types of')]]" use="generate-id(parent::description)"/>
    <xsl:key name="TreatmentKeyPoints" match="sec[title[contains(text(), 'Key points') or contains(text(), 'Key messages')]]" use="generate-id(parent::treatment-points)"/>
    <xsl:key name="TreatmentWhichTreatmentsWorkBest" match="sec[title[contains(text(), 'Which treatments work best') or contains(text(), 'treatments work best')]]" use="generate-id(parent::treatment-points)"/>
    <xsl:key name="TreatmentGroups" match="sec[title[contains(text(), 'Treatments for') or contains(text(), 'treatments for') or contains(text(), 'Preventing') or contains(text(), 'Treating') or contains(text(), 'Treatments to') 
        or contains(text(), 'Treatment of') or contains(text(), 'Treatments of') or contains(text(), 'Surgery for') or contains(text(), 'Drug treatments for') or contains(text(), 'Drug treatments to')]]" use="generate-id(parent::treatment-points)"/>

    <!-- nested treatment-->
    <xsl:key name="NestedTreatmentKeyPoints" match="sec[title[contains(text(), 'Key points') or contains(text(), 'Key messages')]]" use="generate-id(parent::temp-group)"/>
    <xsl:key name="NestedTreatmentWhichTreatmentsWorkBest" match="sec[title[contains(text(), 'Which treatments work best') or contains(text(), 'treatments work best')]]" use="generate-id(parent::temp-group)"/>
    <xsl:key name="NestedTreatmentGroups" match="sec[title[contains(text(), 'Treatments for') or contains(text(), 'treatments for') or contains(text(), 'Preventing') or contains(text(), 'Treating') or contains(text(), 'Treatments to') 
        or contains(text(), 'Treatment of') or contains(text(), 'Treatments of') or contains(text(), 'Surgery for') or contains(text(), 'Drug treatments for') or contains(text(), 'Drug treatments to')]]" use="generate-id(parent::temp-group)"/>
    <xsl:key name="SectionNestedTreatmentGroupsNoMatch" match="sec[title[starts-with(text(), 'Treatments that')] and parent::temp-group]" use="generate-id(parent::temp-group)"/>
    
    <xsl:key name="SectionTreatmentGroupsNoMatch" match="sec[title[starts-with(text(), 'Treatments that work') or starts-with(text(), 'Treatments that are') or starts-with(text(), 'Treatments that need')] and parent::treatment-points]" use="generate-id(parent::treatment-points)"/>
    
    <xsl:key name="SectionNoMatchNoPrecedingSection" match="sec[title[not(contains(text(), 'Key points') or contains(text(), 'Key messages') or 
        contains(text(), 'What') or contains(text(), 'How') or contains(text(), 'Your') or contains(text(), 'Why me') or contains(text(), 'Risk factor') or contains(text(), 'risk factor')
        or contains(text(), 'Types of')
        or contains(text(), 'Treatments for') or contains(text(), 'treatments for') or contains(text(), 'Preventing') or contains(text(), 'Treating') or contains(text(), 'Treatments to')  
        or contains(text(), 'Which treatments work best') or contains(text(), 'treatments work best')
        or contains(text(), 'Treatment of') or contains(text(), 'Treatments of') or contains(text(), 'Surgery for') or contains(text(), 'Drug treatments for') or contains(text(), 'Drug treatments to')
        or starts-with(text(), 'Treatments that work') or starts-with(text(), 'Treatments that are') or starts-with(text(), 'Treatments that need')
        )] and not(preceding-sibling::sec)]" use="generate-id(parent::treatment-points)"/>
    
    <xsl:key name="SectionNoMatch" match="sec[title[not(contains(text(), 'Key points') or contains(text(), 'Key messages') or 
        contains(text(), 'What') or contains(text(), 'How') or contains(text(), 'Your') or contains(text(), 'Why me') or contains(text(), 'Risk factor') or contains(text(), 'risk factor')
        or contains(text(), 'Types of')
        or contains(text(), 'Treatments for') or contains(text(), 'treatments for') or contains(text(), 'Preventing') or contains(text(), 'Treating') or contains(text(), 'Treatments to')
        or contains(text(), 'Which treatments work best') or contains(text(), 'treatments work best')
        or contains(text(), 'Treatment of') or contains(text(), 'Treatments of') or contains(text(), 'Surgery for') or contains(text(), 'Drug treatments for') or contains(text(), 'Drug treatments to')
        or starts-with(text(), 'Treatments that work') or starts-with(text(), 'Treatments that are') or starts-with(text(), 'Treatments that need')
        )]]" use="generate-id((preceding-sibling::sec)[last()])"/>
    
    <xsl:key name="SectionDescriptionNoMatch" match="sec[title[not(contains(text(), 'What') or contains(text(), 'How') or contains(text(), 'Your')
        or contains(text(), 'Why me') or contains(text(), 'Risk factor') or contains(text(), 'risk factor') or contains(text(), 'Types of')
        )]]" use="generate-id(parent::description)"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*[name()!='xmlns:xi' ] ">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="description">
        <xsl:element name="description">
            <xsl:apply-templates select="sec-intro"/>

            <xsl:element name="key-points">
                    <xsl:if test="key('KeyPoints',generate-id())">
                    <xsl:apply-templates select="key('KeyPoints',generate-id())" mode="section-match"/>
                    </xsl:if>
            </xsl:element>
    
            <xsl:element name="explanation">
                    <xsl:if test="key('DescriptionExplanation',generate-id())">
                    <xsl:apply-templates select="key('DescriptionExplanation',generate-id())" mode="section-match"/>
                    </xsl:if>
            </xsl:element>
            
            <xsl:element name="risk-factors">
                    <xsl:if test="key('DescriptionRiskFactor',generate-id())">
                    <xsl:apply-templates select="key('DescriptionRiskFactor',generate-id())" mode="section-match"/>
                    </xsl:if>            
            </xsl:element>

            <xsl:element name="staging"/>
            
            <xsl:element name="classification">
                    <xsl:if test="key('DescriptionClassification',generate-id())">
                    <xsl:apply-templates select="key('DescriptionClassification',generate-id())" mode="section-match"/>
                    </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="treatment-points">
        <xsl:element name="treatment-points">
            <xsl:apply-templates select="sec-intro"/>
            <xsl:if test="key('TreatmentKeyPoints',generate-id())">
                <xsl:element name="key-points">
                    <xsl:apply-templates select="key('TreatmentKeyPoints',generate-id())" mode="section-match"/>    
                </xsl:element>
            </xsl:if>
            <xsl:if test="key('TreatmentWhichTreatmentsWorkBest',generate-id()) or (//temp-group and key('TreatmentGroups',generate-id()))">
                <xsl:element name="which-treatments-work-best">
                    <xsl:apply-templates select="key('TreatmentWhichTreatmentsWorkBest',generate-id())" mode="section-match"/>    
                    <xsl:if test="//temp-group and key('TreatmentGroups',generate-id())">
                        <xsl:apply-templates select="key('TreatmentGroups',generate-id())" mode="section-match"/>    
                    </xsl:if>
                </xsl:element>
            </xsl:if>           
            <xsl:element name="treatment-groups">
                        <xsl:if test="not(//temp-group) and key('TreatmentGroups',generate-id())">
                        <xsl:apply-templates select="key('TreatmentGroups',generate-id())" mode="section-match-group-normal"/>    
                        </xsl:if>
                        <xsl:if test="not(//temp-group) and key('SectionTreatmentGroupsNoMatch',generate-id())">
                            <xsl:element name="group">
                                <xsl:element name="treatments">
                                    <xsl:element name="sec">
                                        <xsl:element name="title"><xsl:text>Treatments for </xsl:text><xsl:value-of select="//article-title"/></xsl:element>
                                        <xsl:apply-templates select="key('SectionTreatmentGroupsNoMatch',generate-id())" mode="section-match"/>        
                                    </xsl:element>                                    
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="//temp-group">
                            <xsl:apply-templates select="following-sibling::temp-group" mode="match"/>
                        </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="temp-group"/>
    
    <xsl:template match="temp-group" mode="match">
        <xsl:element name="group">
            <xsl:apply-templates select="sec-intro"/>
            <xsl:element name="key-points">
                <xsl:apply-templates select="key('NestedTreatmentKeyPoints',generate-id())" mode="section-match"/>    
            </xsl:element>
            <xsl:if test="key('NestedTreatmentWhichTreatmentsWorkBest',generate-id())">
                <xsl:element name="which-treatments-work-best">
                    <xsl:apply-templates select="key('NestedTreatmentWhichTreatmentsWorkBest',generate-id())" mode="section-match"/>    
                </xsl:element>
            </xsl:if>      
            <xsl:if test="key('NestedTreatmentGroups',generate-id())">
                <xsl:element name="treatments">
                    <xsl:apply-templates select="key('NestedTreatmentGroups',generate-id())" mode="section-match"/>    
                </xsl:element>
            </xsl:if>            
            <xsl:if test="key('SectionNestedTreatmentGroupsNoMatch',generate-id())">
                <xsl:element name="treatments">
                    <xsl:apply-templates select="key('SectionNestedTreatmentGroupsNoMatch',generate-id())" mode="section-match"/>    
                </xsl:element>                
            </xsl:if>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="sec-intro[parent::description]" >
        <xsl:element name="overview">
            <xsl:element name="sec">
                <xsl:apply-templates/>
            </xsl:element>
            <xsl:apply-templates select="key('SectionDescriptionNoMatch',generate-id(parent::description))" mode="simple-section"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="sec" mode="simple-section">
        <xsl:element name="sec">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="sec-intro[parent::temp-group]" >
        <xsl:element name="introduction">
            <xsl:element name="sec">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="sec" mode="section-match">
            <xsl:element name="sec">
                <xsl:apply-templates/>
            </xsl:element>
        <xsl:apply-templates select="key('SectionNoMatch',generate-id())" mode="section-match"/>
    </xsl:template>

    <xsl:template match="sec" mode="section-match-group-normal">
        <xsl:element name="group">
            <xsl:element name="treatments">
                <xsl:element name="sec">
                    <xsl:apply-templates/>
                </xsl:element>                
            </xsl:element>
        </xsl:element>
        <xsl:apply-templates select="key('SectionNoMatch',generate-id())" mode="section-match-group-normal"/>
    </xsl:template>
    
    <xsl:template match="sec-intro[parent::treatment-points]">
        <xsl:element name="introduction">
            <xsl:element name="sec">
                <xsl:apply-templates/>
            </xsl:element>
            <xsl:apply-templates select="key('SectionNoMatchNoPrecedingSection',generate-id(parent::treatment-points))" mode="section-match"/>            
        </xsl:element>
    </xsl:template>
    

    
</xsl:stylesheet>

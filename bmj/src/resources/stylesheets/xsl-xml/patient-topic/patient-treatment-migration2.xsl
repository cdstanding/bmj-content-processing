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
    
    <xsl:param name="path"/>
    <!-- 

    -->
    <xsl:key name="Introduction" match="p[parent::body]" use="generate-id(parent::body)"></xsl:key>
    <xsl:key name="DoesItWork" match="sec[title[contains(text(), 'Do they work') or contains(text(), 'Does it work')]]" use="generate-id()"/>
    <xsl:key name="WhatIsIt" match="sec[title[contains(text(), 'What is it') or contains(text(), 'What are they')]]" use="generate-id()"/>
    <xsl:key name="Benefits" match="sec[title[contains(text(), 'How can they help') or contains(text(), 'How can it help') or contains(text(), 'How do they help') or contains(text(), 'How does it help')]]" use="generate-id()"/>
    <xsl:key name="HowDoesItWork" match="sec[title[contains(text(), 'Why should they work') or contains(text(), 'Why should it work')]]" use="generate-id()"/>
    <xsl:key name="Harms" match="sec[title[contains(text(), 'Can they be harmful') or contains(text(), 'Can it be harmful')]]" use="generate-id()"/>

    <xsl:key name="SectionNoMatch" match="sec[title[not(contains(text(), 'Do they work') or contains(text(), 'Does it work') 
        or contains(text(), 'What is it') or contains(text(), 'What are they')
        or contains(text(), 'How can they help') or contains(text(), 'How can it help')  or contains(text(), 'How do they help') or contains(text(), 'How does it help')
        or contains(text(), 'Why should they work') or contains(text(), 'Why should it work')
        or contains(text(), 'Can they be harmful') or contains(text(), 'Can it be harmful'))]]" 
        use="generate-id((preceding-sibling::sec)[last()])"/>

    <xsl:key name="SectionNoMatchNoPrecedingSection" 
        match="sec[title[not(contains(text(), 'Do they work') or contains(text(), 'Does it work') 
        or contains(text(), 'What is it') or contains(text(), 'What are they')
        or contains(text(), 'How can they help') or contains(text(), 'How can it help')  or contains(text(), 'How do they help') or contains(text(), 'How does it help')
        or contains(text(), 'Why should they work') or contains(text(), 'Why should it work')
        or contains(text(), 'Can they be harmful') or contains(text(), 'Can it be harmful'))] and parent::body and not(preceding-sibling::sec)]" 
        use="generate-id(parent::body)"/>
    
    
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
    
    <xsl:template match="body">
        <xsl:element name="body">
            <xsl:element name="introduction">
                <xsl:if test="key('Introduction',generate-id())">
                    <xsl:element name="sec">
                        <xsl:apply-templates select="key('Introduction',generate-id())" mode="para"/>
                    </xsl:element>                    
                </xsl:if>
                <xsl:apply-templates select="key('SectionNoMatchNoPrecedingSection',generate-id())" mode="section-match"/>                
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="title[parent::body]|p[parent::body]"/>
    
    <xsl:template match="p[parent::body]" mode="para">
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="sec[parent::body]">
            <xsl:if test="key('DoesItWork',generate-id())">
                <xsl:element name="does-it-work">
                    <xsl:apply-templates select="key('DoesItWork',generate-id())" mode="section-match"/>    
                </xsl:element>
            </xsl:if>            
            <xsl:if test="key('WhatIsIt',generate-id())">
                <xsl:element name="what-is-it">
                    <xsl:apply-templates select="key('WhatIsIt',generate-id())" mode="section-match"/>    
                </xsl:element>
            </xsl:if>                        
            <xsl:if test="key('Benefits',generate-id())">
                <xsl:element name="benefits">
                    <xsl:apply-templates select="key('Benefits',generate-id())" mode="section-match"/>    
                </xsl:element>
            </xsl:if>
        <xsl:if test="key('HowDoesItWork',generate-id())">
            <xsl:element name="how-does-it-work">
                <xsl:apply-templates select="key('HowDoesItWork',generate-id())" mode="section-match"/>    
            </xsl:element>
        </xsl:if>
        <xsl:if test="key('Harms',generate-id())">
            <xsl:element name="harms">
                <xsl:apply-templates select="key('Harms',generate-id())" mode="section-match"/>    
            </xsl:element>
        </xsl:if>        
        
    </xsl:template>
    
    <xsl:template match="sec" mode="section-match">
        <xsl:element name="sec">
            <xsl:apply-templates/>
        </xsl:element>
        <xsl:apply-templates select="key('SectionNoMatch',generate-id())" mode="section-match"/>
    </xsl:template>
    
    <xsl:template match="evidence-link">
        <xsl:element name="how-good-is-the-research">
            <xsl:variable name="targetvalue"><xsl:value-of select="@target"/></xsl:variable>
            
            <xsl:variable name="evidence" select="document(concat($path, '/', substring-after(@target,'../evidence/')))"></xsl:variable>
            <!-- 
            <xsl:comment>evidence-link target='<xsl:value-of select="@target"/> topic='<xsl:value-of select="@topic"/></xsl:comment>
            -->
            <xsl:apply-templates select="$evidence/evidence/*"/>            
        </xsl:element>
        
        

    </xsl:template>

</xsl:stylesheet>

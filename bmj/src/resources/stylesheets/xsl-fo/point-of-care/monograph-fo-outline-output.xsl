<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
    version="2.0">

    <xsl:template name="process-fo-root">
        
        <xsl:element name="fo:root">
            
            <xsl:element name="fo:layout-master-set">
                
                <xsl:element name="fo:simple-page-master">
                    <xsl:attribute name="master-name">Body-page</xsl:attribute>
                    <!--<xsl:attribute name="page-height" select="$page-height"/>
                        <xsl:attribute name="page-width" select="$page-width"/>-->
                    
                    <xsl:element name="fo:region-body" use-attribute-sets="">
                        <xsl:attribute name="region-name">xsl-region-body</xsl:attribute>
                        <xsl:attribute name="margin-top">2.5cm</xsl:attribute>
                        <xsl:attribute name="margin-bottom">2.5cm</xsl:attribute>
                        <xsl:attribute name="margin-left">2.0cm</xsl:attribute>
                        <xsl:attribute name="margin-right">2.0cm</xsl:attribute>
                        <!--<xsl:attribute name="padding-top" select="$text-padding"/>
                            <xsl:attribute name="padding-bottom" select="$text-padding"/>
                            <xsl:attribute name="padding-left" select="$text-padding"/>
                            <xsl:attribute name="padding-right" select="$text-padding"/>-->
                    </xsl:element>
                    
                    <xsl:element name="fo:region-before" use-attribute-sets="">
                        <xsl:attribute name="region-name">xsl-region-before</xsl:attribute>
                        <!--<xsl:attribute name="padding-top" select="$text-padding"/>
                            <xsl:attribute name="padding-bottom" select="$text-padding"/>
                            <xsl:attribute name="padding-left" select="$text-padding"/>
                            <xsl:attribute name="padding-right" select="$text-padding"/>-->
                            <xsl:attribute name="extent">2.5cm</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:element name="fo:region-after" use-attribute-sets="">
                        <xsl:attribute name="region-name">xsl-region-after</xsl:attribute>
                        <!--<xsl:attribute name="padding-top" select="$text-padding"/>
                            <xsl:attribute name="padding-bottom" select="$text-padding"/>
                            <xsl:attribute name="padding-left" select="$text-padding"/>
                            <xsl:attribute name="padding-right" select="$text-padding"/>-->
                            <xsl:attribute name="extent">2.0cm</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:element name="fo:region-start" use-attribute-sets="">
                        <xsl:attribute name="region-name">xsl-region-start</xsl:attribute>
                        <xsl:attribute name="extent">2.0cm</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:element name="fo:region-end" use-attribute-sets="">
                        <xsl:attribute name="region-name">xsl-region-end</xsl:attribute>
                        <xsl:attribute name="extent">2.0cm</xsl:attribute>
                    </xsl:element>
                    
                </xsl:element>
                
                <xsl:element name="fo:page-sequence-master">
                    <xsl:attribute name="master-name">poc</xsl:attribute>
                    
                    <xsl:element name="fo:repeatable-page-master-alternatives">
                        <xsl:element name="fo:conditional-page-master-reference">
                            <xsl:attribute name="master-reference">Body-page</xsl:attribute>
                            <!--<xsl:attribute name="master-name">Body-page</xsl:attribute>-->
                            <xsl:attribute name="page-position">any</xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                    
                </xsl:element>
                
            </xsl:element>
            
            <xsl:element name="fo:page-sequence">
                <xsl:attribute name="master-reference">poc</xsl:attribute>
                <!--<xsl:attribute name="master-name">poc</xsl:attribute>-->
                
                <xsl:element name="fo:static-content">
                    <xsl:attribute name="flow-name">xsl-region-after</xsl:attribute>
                    
                    <xsl:element name="fo:block" use-attribute-sets=""><!--Body-->
                        <xsl:attribute name="font-family">Times-New-Roman</xsl:attribute>
                        <xsl:text>Page </xsl:text>
                        <xsl:element name="fo:page-number"/>
                    </xsl:element>
                    
                </xsl:element>
                
                <xsl:element name="fo:flow">
                    <xsl:attribute name="flow-name">xsl-region-body</xsl:attribute>
                    
                    <xsl:element name="fo:block" use-attribute-sets=""><!--Body-->
                        <xsl:attribute name="font-family">Times-New-Roman</xsl:attribute>
                        <xsl:attribute name="font-size">10pt</xsl:attribute>
                        
                        <xsl:call-template name="process-top-level"/>
                        
                    </xsl:element>
                    
                </xsl:element>
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>

    <xsl:template name="process-top-level">
        <xsl:variable name="name" select="name()"/>
        
        <xsl:element name="fo:block" use-attribute-sets="default-padding">
            
            <xsl:apply-templates select="monograph-info"/>
            
            <xsl:if test="($name = 'monograph-full' or $name = 'monograph-eval')">
                
                <xsl:element name="fo:block" use-attribute-sets="">
                    
                    <xsl:variable name="name">monograph-summary</xsl:variable>
                    
                    <xsl:element name="fo:block" use-attribute-sets="h1">
                        <xsl:call-template name="process-string-variant">
                            <xsl:with-param name="name" select="$name"/>
                        </xsl:call-template>
                    </xsl:element>
                        
                    <xsl:apply-templates select="highlights"/>
                    
                    <xsl:if test="$name = 'monograph-full'">
                        <xsl:apply-templates select="//figure[contains(image-link/@target, 'hlight')]"/>
                    </xsl:if>
                    
                    <xsl:element name="fo:table" use-attribute-sets="default-padding">
                        <xsl:attribute name="border">0</xsl:attribute>
                        
                        <xsl:element name="fo:table-body" use-attribute-sets="">
                            
                            <xsl:element name="fo:table-row" use-attribute-sets="">
                                
                                <xsl:apply-templates select="/monograph-full/diagnosis/diagnostic-factors" mode="summary"/>
                                <xsl:apply-templates select="/monograph-full/diagnosis/tests" mode="summary"/>
                                <xsl:apply-templates select="/monograph-full/treatment/tx-options" mode="summary"/>
                                <xsl:apply-templates select="/monograph-eval/differentials" mode="summary"/>
                                
                            </xsl:element>
                            
                        </xsl:element>
                        
                    </xsl:element>
                    
                </xsl:element>
                
            </xsl:if>
            
            <xsl:apply-templates select="
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
                
                sections[ancestor::monograph-generic]
                "/>		
            
            <!-- TODO can these not go to top of stylesheet and not duplicate work later too ?? -->
            <xsl:variable name="combined-references">
                <xsl:element name="references">
                    <xsl:element name="combined-references">
                        <xsl:call-template name="process-reference-links">
                            <xsl:with-param name="item-count" select="1"/>
                            <xsl:with-param name="link-index" select="1"/>
                            <xsl:with-param name="link-count" select="count(//reference-link) + 1"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:variable>
            
            <xsl:variable name="article-references">
                <xsl:element name="references">
                    <xsl:element name="article-references">
                        <xsl:call-template name="process-article-reference-links">
                            <xsl:with-param name="item-count" select="1"/>
                            <xsl:with-param name="link-index" select="1"/>
                            <xsl:with-param name="link-count" select="count(//reference-link[@type='article']) + 1"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:variable>
            
            <xsl:variable name="online-references">
                <xsl:element name="references">
                    <xsl:element name="online-references">
                        <xsl:call-template name="process-online-reference-links">
                            <xsl:with-param name="item-count" select="1"/>
                            <xsl:with-param name="link-index" select="1"/>
                            <xsl:with-param name="link-count" select="count(//reference-link[@type='online']) + 1"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:variable>
            
            <xsl:variable name="key-article-references">
                <xsl:element name="references">
                    <xsl:element name="key-article-references">
                        <xsl:for-each select="$article-references//reference[poc-citation/@key-article='true']">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:variable>
            
            <xsl:variable name="figures">
                <xsl:element name="references">
                    <xsl:element name="figures">
                        <xsl:call-template name="process-figure-links">
                            <xsl:with-param name="item-count" select="1"/>
                            <xsl:with-param name="link-index" select="1"/>
                            <xsl:with-param name="link-count" select="count(//figure-link) + 1"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:variable>
            
            <xsl:apply-templates select="evidence-scores[*]"/>
            
            <xsl:apply-templates select="$key-article-references//key-article-references[*]" />
            <xsl:apply-templates select="$online-references//online-references[*]" />
            <xsl:apply-templates select="$article-references//article-references[*]" />
            <xsl:apply-templates select="$figures//figures[*]" />
            
            <xsl:element name="fo:block" use-attribute-sets="default-padding">
                
                <xsl:element name="fo:block" use-attribute-sets="h1">
                    <xsl:call-template name="process-string-variant">
                        <xsl:with-param name="name" select="string('credits')"/>
                    </xsl:call-template>
                </xsl:element>
                
                <xsl:variable name="monograph-plan-filename" select="concat($resourse-export-path, '/', //monograph-plan-link/@target)"/>
                <xsl:variable name="monograph-plan" select="document($monograph-plan-filename)"/>
                
                <!-- TODO credits -->
                <xsl:apply-templates select="$monograph-plan//authors" />
                <xsl:apply-templates select="$monograph-plan//peer-reviewers" />
                <!--<xsl:apply-templates select="$monograph-plan//editors" />-->
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>

    <xsl:template name="process-info-level">
        <xsl:variable name="name" select="name()"/>
        
        <xsl:element name="fo:block" use-attribute-sets="default-padding">
            
            <!--<xsl:element name="metadata">
                
                <xsl:element name="key">
                    <xsl:attribute name="name">amended-date</xsl:attribute>
                    <xsl:attribute name="value" select="$date-amended"/>
                </xsl:element>
                
                <xsl:element name="key">
                    <xsl:attribute name="name">last-updated</xsl:attribute>
                    <xsl:attribute name="value" select="$date-updated"/>
                </xsl:element>
                
                <xsl:element name="key">
                    <xsl:attribute name="name">export-date</xsl:attribute>
                </xsl:element>
                
            </xsl:element>-->
            
            <xsl:element name="fo:block" use-attribute-sets="h1">
                <xsl:apply-templates select="title/node()" />
            </xsl:element>
            
            <xsl:element name="fo:block" use-attribute-sets="default-padding">
                
                <xsl:element name="fo:block" use-attribute-sets="">
                    <xsl:apply-templates select="../@dx-id" />
                </xsl:element>
               
                <xsl:element name="fo:block" use-attribute-sets="">
                    
                    <xsl:element name="fo:inline" use-attribute-sets="strong">
                        <xsl:call-template name="process-string-variant">
                            <xsl:with-param name="name" select="string('type')"/>
                        </xsl:call-template>
                        <xsl:text>: </xsl:text>
                    </xsl:element>
                    
                    <xsl:variable name="monograph-type" select="name(parent::*)"/>
                    
                    <xsl:call-template name="process-string-variant">
                        <xsl:with-param name="name" select="$monograph-type"/>
                    </xsl:call-template>
                    
                    <xsl:element name="fo:inline">
                        <xsl:text disable-output-escaping="yes"> [</xsl:text>
                        <xsl:value-of select="$lang" />
                        <xsl:text disable-output-escaping="yes">]</xsl:text>
                    </xsl:element>
                    
                </xsl:element>
                
            </xsl:element>
            
            <xsl:apply-templates select="topic-synonyms" />
            <xsl:apply-templates select="related-topics[monograph-link]" />
            <xsl:apply-templates select="related-patient-summaries" />
            <xsl:apply-templates select="categories" />
            <xsl:apply-templates select="statistics" /><!-- used?-->
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template name="process-summary-level">
        <xsl:variable name="name" select="name()"/>
        
        <xsl:element name="fo:table-cell" use-attribute-sets="">
            <xsl:attribute name="width">30%</xsl:attribute>
            
            <xsl:element name="fo:block" use-attribute-sets="default-margin">
                <!--<xsl:attribute name="border">1pt</xsl:attribute>
                <xsl:attribute name="border-color">#000000</xsl:attribute>
                <xsl:attribute name="border-style">solid</xsl:attribute>
                <xsl:attribute name="border-top">0pt</xsl:attribute>-->
                
                <xsl:element name="fo:block" use-attribute-sets="h2">
                    <xsl:call-template name="process-string-variant">
                        <xsl:with-param name="name" select="$name"/>
                    </xsl:call-template>
                </xsl:element>
                
                <xsl:for-each 
                    select="
                    factor[@key-factor='true']
                        [factor-name[string-length(normalize-space(.))!=0]][1] |
                    factor[@key-factor='false']
                        [factor-name[string-length(normalize-space(.))!=0]][1] |
                    factor[@key-factor='unset']
                        [factor-name[string-length(normalize-space(.))!=0]][1] |
                    
                    test[@order='initial'] 
                        [name[string-length(normalize-space(.))!=0]][1] | 
                    test[@order='subsequent']
                        [name[string-length(normalize-space(.))!=0]][1] |
                    test[@order='emerging']
                        [name[string-length(normalize-space(.))!=0]][1] |
                    test[@order='unset']
                        [name[string-length(normalize-space(.))!=0]][1] |
                    
                    tx-option[@timeframe='presumptive'][1] | 
                    tx-option[@timeframe='acute'][1] |
                    tx-option[@timeframe='ongoing'][1]   
                    ">
                    <xsl:variable name="section" select="name()"/>
                    <xsl:variable name="group" select="@key-factor | @order | @timeframe"/>
                    <xsl:variable name="name" select="concat($group, '-', $section, '-group')"/>
                    
                    <xsl:element name="fo:block" use-attribute-sets="default-margin">
                        
                        <xsl:choose>
                            
                            <xsl:when 
                                test="
                                $name='weak-risk-factor-group' 
                                or $name='false-factor-group' 
                                or $name='subsequent-test-group' 
                                or $name='emerging-test-group' 
                                or $name='acute-tx-option-group' 
                                or $name='ongoing-tx-option-group' 
                                or $name='true-differential-group' 
                                or $name='false-differential-group'
                                ">
                                
                                <xsl:element name="fo:block" use-attribute-sets="strong background-navy color-white default-padding">
                                    <xsl:call-template name="process-string-variant">
                                        <xsl:with-param name="name" select="$name"/>
                                    </xsl:call-template>
                                </xsl:element>
                                
                            </xsl:when>
                            
                            <xsl:when 
                                test="
                                $name='strong-risk-factor-group' 
                                or $name='true-factor-group' 
                                or $name='initial-test-group' 
                                or $name='presumptive-tx-option-group' 
                                ">
                                
                                <xsl:element name="fo:block" use-attribute-sets="strong background-maroon color-white default-padding">
                                    <xsl:call-template name="process-string-variant">
                                        <xsl:with-param name="name" select="$name"/>
                                    </xsl:call-template>
                                </xsl:element>
                                
                            </xsl:when>
                            
                            <xsl:otherwise>
                                
                                <xsl:element name="fo:block" use-attribute-sets="strong background-grey color-white default-padding">
                                    <xsl:call-template name="process-string-variant">
                                        <xsl:with-param name="name" select="$name"/>
                                    </xsl:call-template>
                                </xsl:element>
                                
                            </xsl:otherwise>
                            
                        </xsl:choose>
                        
                        <xsl:element name="fo:block" use-attribute-sets="default-padding">
                            
                            <xsl:element name="fo:list-block" use-attribute-sets="">
                                
                                <xsl:for-each select="parent::*/*[name()=$section and @*=$group]">
                                    
                                    <xsl:choose>
        
                                        <xsl:when test="$section='tx-option'">
                                            <xsl:variable name="current-pt-name" select="translate(normalize-space(.), $upper, $lower)"/>
                                            
                                            <xsl:if test="true()"><!--following-sibling::tx-option[translate(normalize-space(.), $upper, $lower)!=$current-pt-name]-->
                                                
                                                <xsl:element name="fo:list-item" use-attribute-sets="">
                                                    
                                                    <xsl:element name="fo:list-item-label" use-attribute-sets="">
                                                        <xsl:attribute name="end-indent">label-end()</xsl:attribute>
                                                        
                                                        <xsl:element name="fo:block" use-attribute-sets="strong">
                                                            <xsl:element name="fo:inline" use-attribute-sets="">
                                                                <xsl:attribute name="padding-left">10pt</xsl:attribute>
                                                                <xsl:value-of select="$bullet-icon"/>
                                                            </xsl:element>
                                                        </xsl:element>
                                                        
                                                    </xsl:element>
                                                    
                                                    <xsl:element name="fo:list-item-body" use-attribute-sets="">
                                                        <xsl:attribute name="start-indent">body-start()</xsl:attribute>
                                                        
                                                        <xsl:element name="fo:block" use-attribute-sets="">
                                                            <xsl:apply-templates select="pt-group/node()"/>
                                                        </xsl:element>
                                                        
                                                    </xsl:element>
                                                    
                                                </xsl:element>
                                                
                                                <xsl:element name="fo:list-item" use-attribute-sets="">
                                                    
                                                    <xsl:element name="fo:list-item-label" use-attribute-sets="">
                                                        <xsl:attribute name="end-indent">label-end()</xsl:attribute>
                                                        
                                                        <xsl:element name="fo:block" use-attribute-sets=""/>
                                                        
                                                    </xsl:element>
                                                    
                                                    <xsl:element name="fo:list-item-body" use-attribute-sets="">
                                                        <xsl:attribute name="start-indent">body-start()</xsl:attribute>
                                                        
                                                        <xsl:element name="fo:block" use-attribute-sets="">
                                                            
                                                            <xsl:element name="fo:list-block" use-attribute-sets="">
                                                                
                                                                <xsl:element name="fo:list-item" use-attribute-sets="">
                                                                    
                                                                    <xsl:element name="fo:list-item-label" use-attribute-sets="">
                                                                        <xsl:attribute name="end-indent">label-end()</xsl:attribute>
                                                                        
                                                                        <xsl:element name="fo:block" use-attribute-sets="strong">
                                                                            <xsl:element name="fo:inline" use-attribute-sets="">
                                                                                <xsl:attribute name="padding-left">10pt</xsl:attribute>
                                                                                <xsl:value-of select="$bullet-icon"/>
                                                                            </xsl:element>
                                                                        </xsl:element>
                                                                        
                                                                    </xsl:element>
                                                                    
                                                                    <xsl:element name="fo:list-item-body" use-attribute-sets="">
                                                                        <xsl:attribute name="start-indent">body-start()</xsl:attribute>
                                                                        
                                                                        <xsl:element name="fo:block" use-attribute-sets="">
                                                                            <xsl:apply-templates select="tx-type/node()"/>
                                                                        </xsl:element>
                                                                        
                                                                    </xsl:element>
                                                                    
                                                                </xsl:element>
                                                                
                                                            </xsl:element>
                                                            
                                                        </xsl:element>
                                                        
                                                    </xsl:element>
                                                    
                                                </xsl:element>
                                                
                                            </xsl:if>
                                            
                                            <xsl:if test="tx-options/tx-option">
                                                
                                                <xsl:element name="fo:list-item" use-attribute-sets="">
                                                    
                                                    <xsl:element name="fo:list-item-label" use-attribute-sets="">
                                                        <xsl:attribute name="end-indent">label-end()</xsl:attribute>
                                                        
                                                        <xsl:element name="fo:block" use-attribute-sets=""/>
                                                        
                                                    </xsl:element>
                                                    
                                                    <xsl:element name="fo:list-item-body" use-attribute-sets="">
                                                        <xsl:attribute name="start-indent">body-start()</xsl:attribute>
                                                        
                                                        <xsl:element name="fo:list-block" use-attribute-sets="">
                                                            
                                                            <xsl:for-each select="tx-options/tx-option">
                                                                
                                                                <xsl:element name="fo:list-item" use-attribute-sets="">
                                                                    
                                                                    <xsl:element name="fo:list-item-label" use-attribute-sets="">
                                                                        <xsl:attribute name="end-indent">label-end()</xsl:attribute>
                                                                        
                                                                        <xsl:element name="fo:block" use-attribute-sets="strong">
                                                                            <xsl:element name="fo:inline" use-attribute-sets="">
                                                                                <xsl:attribute name="padding-left">10pt</xsl:attribute>
                                                                                <xsl:value-of select="$bullet-icon"/>
                                                                            </xsl:element>
                                                                        </xsl:element>
                                                                        
                                                                    </xsl:element>
                                                                    
                                                                    <xsl:element name="fo:list-item-body" use-attribute-sets="">
                                                                        <xsl:attribute name="start-indent">body-start()</xsl:attribute>
                                                                        
                                                                        <xsl:element name="fo:block" use-attribute-sets="">
                                                                            <xsl:apply-templates select="pt-group/node()"/>
                                                                        </xsl:element>
                                                                        
                                                                        <xsl:element name="fo:list-block" use-attribute-sets="">
                                                                            
                                                                            <xsl:element name="fo:list-item" use-attribute-sets="">
                                                                                
                                                                                <xsl:element name="fo:list-item-label" use-attribute-sets="">
                                                                                    <xsl:attribute name="end-indent">label-end()</xsl:attribute>
                                                                                    
                                                                                    <xsl:element name="fo:block" use-attribute-sets="strong">
                                                                                        <xsl:element name="fo:inline" use-attribute-sets="">
                                                                                            <xsl:attribute name="padding-left">10pt</xsl:attribute>
                                                                                            <xsl:value-of select="$bullet-icon"/>
                                                                                        </xsl:element>
                                                                                    </xsl:element>
                                                                                    
                                                                                </xsl:element>
                                                                                
                                                                                <xsl:element name="fo:list-item-body" use-attribute-sets="">
                                                                                    <xsl:attribute name="start-indent">body-start()</xsl:attribute>
                                                                                    
                                                                                    <xsl:element name="fo:block" use-attribute-sets="">
                                                                                        <xsl:apply-templates select="tx-type/node()"/>
                                                                                    </xsl:element>
                                                                                    
                                                                                </xsl:element>
                                                                                
                                                                            </xsl:element>
                                                                            
                                                                        </xsl:element>
                                                                        
                                                                    </xsl:element>
                                                                    
                                                                </xsl:element>
                                                                
                                                            </xsl:for-each>
                                                            
                                                        </xsl:element>
                                                        
                                                    </xsl:element>
                                                    
                                                </xsl:element>
                                                
                                            </xsl:if>
                                            
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
                                            
                                            <xsl:element name="fo:list-item" use-attribute-sets="">
                                                
                                                <xsl:element name="fo:list-item-label" use-attribute-sets="">
                                                    <xsl:attribute name="end-indent">label-end()</xsl:attribute>
                                                    
                                                    <xsl:element name="fo:block" use-attribute-sets="strong">
                                                        <xsl:element name="fo:inline" use-attribute-sets="">
                                                            <xsl:attribute name="padding-left">10pt</xsl:attribute>
                                                            <xsl:value-of select="$bullet-icon"/>
                                                        </xsl:element>
                                                    </xsl:element>
                                                    
                                                </xsl:element>
                                                
                                                <xsl:element name="fo:list-item-body" use-attribute-sets="">
                                                    <xsl:attribute name="start-indent">body-start()</xsl:attribute>
                                                    
                                                    <xsl:element name="fo:block" use-attribute-sets="">
                                                        <xsl:apply-templates select="factor-name/node() | name/node() | pt-group/node()"/>
                                                    </xsl:element>
                                                    
                                                </xsl:element>
                                                
                                            </xsl:element>
                                            
                                        </xsl:otherwise>
                                        
                                    </xsl:choose>
                                    
                                </xsl:for-each>
                                <!-- TODO add link to full section -->
                            </xsl:element>        
                            
                        </xsl:element>
                        
                    </xsl:element>
                </xsl:for-each>
                
                <xsl:if test="differential[ancestor::monograph-eval]/category[string-length(normalize-space(.))!=0]">
    <!--                <xsl:element name="fo:block" use-attribute-sets="">                    
                        <xsl:attribute name="{concat($xmlns, ':oen')}">differential</xsl:attribute>
                        
                        <xsl:element name="fo:block" use-attribute-sets="">
                            <xsl:call-template name="process-string-variant">
                            <xsl:with-param name="name" select="string('differential-category-summary')"/>
                            </xsl:call-template>
                            
                        </xsl:element>
    -->                    
                    <xsl:for-each select="differential[ancestor::monograph-eval]">
                        <xsl:sort select="normalize-space(category)"/>
                        
                        <xsl:variable name="current-differential-category" select="translate(normalize-space(category), $upper, $lower)"/>
                        
                        <xsl:if test="position()=1 or translate(normalize-space(preceding-sibling::differential[1]/category), $upper, $lower) != $current-differential-category">
                            <xsl:text disable-output-escaping="yes">&lt;fo:block&gt;</xsl:text>
                            <xsl:text disable-output-escaping="yes">&lt;fo:block&gt;</xsl:text>
                            <xsl:apply-templates select="category/node()"/>
                            <xsl:text disable-output-escaping="yes">&lt;/fo:block&gt;</xsl:text>
                            <xsl:text disable-output-escaping="yes">&lt;fo:list-block&gt;</xsl:text>
                        </xsl:if>
                        
                        <xsl:element name="fo:list-item" use-attribute-sets="">
                            
                            <xsl:element name="fo:list-item-label" use-attribute-sets="">
                                <xsl:attribute name="end-indent">label-end()</xsl:attribute>
                                
                                <xsl:element name="fo:block" use-attribute-sets="strong">
                                    <xsl:element name="fo:inline" use-attribute-sets="">
                                        <xsl:attribute name="padding-left">10pt</xsl:attribute>
                                        <xsl:value-of select="$bullet-icon"/>
                                    </xsl:element>
                                </xsl:element>
                                
                            </xsl:element>
                            
                            <xsl:element name="fo:list-item-body" use-attribute-sets="">
                                <xsl:attribute name="start-indent">body-start()</xsl:attribute>
                                
                                <xsl:element name="fo:block" use-attribute-sets="">
                                    <xsl:apply-templates select="ddx-name/node()"/>
                                    <xsl:text disable-output-escaping="yes"> - </xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="@common = 'true'"><xsl:text disable-output-escaping="yes">common</xsl:text></xsl:when>
                                        <xsl:when test="@common = 'false'"><xsl:text disable-output-escaping="yes">uncommon</xsl:text></xsl:when>
                                        <xsl:otherwise><xsl:text disable-output-escaping="yes">not set</xsl:text></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                                
                            </xsl:element>
                            
                        </xsl:element>
                        
                        <xsl:if test="position()=last() or translate(normalize-space(following-sibling::differential[1]/category), $upper, $lower) != $current-differential-category">
                            <xsl:text disable-output-escaping="yes">&lt;/fo:list-block&gt;</xsl:text>
                            <xsl:text disable-output-escaping="yes">&lt;/fo:block&gt;</xsl:text>
                        </xsl:if>
                        
                    </xsl:for-each>
                    
                    <!--</xsl:element>-->
                    
                </xsl:if>
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template name="process-level-1-section-with-heading">
        <xsl:variable name="name" select="name()" />
        
        <xsl:element name="fo:block" use-attribute-sets="default-padding">
                
            <xsl:element name="fo:block" use-attribute-sets="h1">
                <xsl:call-template name="process-string-variant">
                    <xsl:with-param name="name" select="$name"/>
                </xsl:call-template>
            </xsl:element>
            
            <xsl:apply-templates />
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template name="process-level-1-section-with-heading-and-with-implied-list-content">
        <xsl:variable name="name" select="name()" />
        
        <xsl:element name="fo:block" use-attribute-sets="default-padding">
            
            <xsl:element name="fo:block" use-attribute-sets="h1">
                <xsl:call-template name="process-string-variant">
                    <xsl:with-param name="name" select="$name"/>
                </xsl:call-template>
            </xsl:element>
            
            <xsl:element name="fo:list-block" use-attribute-sets="">
                
                <xsl:for-each select="element()">
                
                    <xsl:element name="fo:list-item" use-attribute-sets="">
                        
                        <xsl:element name="fo:list-item-label" use-attribute-sets="">
                            <xsl:attribute name="end-indent">label-end()</xsl:attribute>
                            
                            <xsl:element name="fo:block" use-attribute-sets="strong">
                                <xsl:element name="fo:inline" use-attribute-sets="">
                                    <xsl:attribute name="padding-left">10pt</xsl:attribute>
                                    <xsl:value-of select="$bullet-icon"/>
                                </xsl:element>
                            </xsl:element>
                            
                        </xsl:element>
                        
                        <xsl:element name="fo:list-item-body" use-attribute-sets="">
                            <xsl:attribute name="start-indent">body-start()</xsl:attribute>
                            
                            <xsl:element name="fo:block" use-attribute-sets="">
                                <xsl:apply-templates />
                            </xsl:element>
                            
                        </xsl:element>
                        
                    </xsl:element>
                    
                </xsl:for-each>
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>

    <xsl:template name="process-level-2-section-with-heading">
        <xsl:variable name="name" select="name()" />
        <xsl:variable name="parent-name" select="name(parent::*)" />
        
        <xsl:element name="fo:block" use-attribute-sets="default-padding">
            
            <xsl:element name="fo:block" use-attribute-sets="h2">
                
                <!-- we concat the level-1 section name to our level-2 headings -->
                <xsl:if 
                    test="$parent-name
                    and ($name != 'combined-references' 
                    and $name != 'article-references'
                    and $name != 'online-references'
                    and $name != 'key-article-references'
                    and $name != 'evidence-scores'
                    and $name != 'figures')
                    ">
                    <xsl:call-template name="process-string-variant">
                        <xsl:with-param name="name" select="$parent-name"/>
                    </xsl:call-template>
                    <xsl:text>: </xsl:text>
                </xsl:if>
                
                <!-- these two fields are shared in both diagnosis and treatment sections so we want to concat more relevant heading name -->
                <xsl:if test="$name = 'approach' or $name = 'guidelines'">
                    <xsl:call-template name="process-string-variant">
                        <xsl:with-param name="name" select="$parent-name"/>
                    </xsl:call-template>
                    <xsl:text> </xsl:text>
                </xsl:if>
                
                <xsl:call-template name="process-string-variant">
                    <xsl:with-param name="name" select="$name"/>
                </xsl:call-template>
                
            </xsl:element>
            
            <xsl:choose>
                <xsl:when test="
                    $name = 'combined-references' 
                    or $name = 'article-references'
                    or $name = 'online-references'
                    or $name = 'key-article-references'
                    or $name = 'evidence-scores'
                    ">
                    
                    <xsl:element name="fo:list-block" use-attribute-sets="">
                        <xsl:apply-templates />
                    </xsl:element>
                    
                </xsl:when>
                
                <xsl:when test="$name = 'prevention' ">
                    
                    <xsl:apply-templates />
                    <xsl:apply-templates select="/monograph-full/followup/recommendations/preventive-actions"/>
                    
                </xsl:when>
                
                <xsl:when test="$name = 'recommendations' ">
                    <xsl:apply-templates select="*[name()!='preventive-actions']"/>
                </xsl:when>
                
                <xsl:when test="$name = 'differentials' ">
                    
                    <xsl:element name="fo:table" use-attribute-sets="default-padding">
                        <xsl:attribute name="border">0</xsl:attribute>
                        <xsl:attribute name="table-omit-header-at-break">true</xsl:attribute>
                        
                        <xsl:element name="fo:table-header" use-attribute-sets="">
                            
                            <xsl:element name="fo:table-row" use-attribute-sets="">
                                <xsl:attribute name="border-bottom">1pt</xsl:attribute>
                                <xsl:attribute name="border-color">#000000</xsl:attribute>
                                <xsl:attribute name="border-style">solid</xsl:attribute>
                                <xsl:attribute name="border-top">0pt</xsl:attribute>
                                
                                <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                                    <xsl:attribute name="width">20%</xsl:attribute>
                                    <xsl:attribute name="display-align">after</xsl:attribute>
                                    
                                    <xsl:element name="fo:block" use-attribute-sets="strong align-center">
                                        <xsl:call-template name="process-string-variant">
                                            <xsl:with-param name="name" select="string('condition')"/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    
                                </xsl:element>
                                
                                <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                                    <xsl:attribute name="width">40%</xsl:attribute>
                                    <xsl:attribute name="display-align">after</xsl:attribute>
                                    
                                    <xsl:element name="fo:block" use-attribute-sets="strong align-center">
                                        <xsl:call-template name="process-string-variant">
                                            <xsl:with-param name="name" select="string('sign-symptoms')"/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    
                                </xsl:element>
                                
                                <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                                    <xsl:attribute name="width">40%</xsl:attribute>
                                    <xsl:attribute name="display-align">after</xsl:attribute>
                                    
                                    <xsl:element name="fo:block" use-attribute-sets="strong align-center">
                                        <xsl:call-template name="process-string-variant">
                                            <xsl:with-param name="name" select="string('differentials-tests')"/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    
                                </xsl:element>
                                
                            </xsl:element>
                            
                        </xsl:element>
                        
                        <xsl:element name="fo:table-body" use-attribute-sets="">
                        
                            <xsl:apply-templates />
                            
                        </xsl:element>
                        
                    </xsl:element>
                    
                </xsl:when>
                
                <xsl:when test="$name = 'complications' ">
                    
                    <xsl:element name="fo:table" use-attribute-sets="default-padding">
                        <xsl:attribute name="border">0</xsl:attribute>
                        <xsl:attribute name="table-omit-header-at-break">true</xsl:attribute>
                        
                        <xsl:element name="fo:table-header" use-attribute-sets="">
                            
                            <xsl:element name="fo:table-row" use-attribute-sets="">
                                <xsl:attribute name="border-bottom">1pt</xsl:attribute>
                                <xsl:attribute name="border-color">#000000</xsl:attribute>
                                <xsl:attribute name="border-style">solid</xsl:attribute>
                                <xsl:attribute name="border-top">0pt</xsl:attribute>
                                
                                <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                                    <xsl:attribute name="width">80%</xsl:attribute>
                                    <xsl:attribute name="display-align">after</xsl:attribute>
                                    
                                    <xsl:element name="fo:block" use-attribute-sets="strong align-center">
                                        <xsl:call-template name="process-string-variant">
                                            <xsl:with-param name="name" select="string('complication')"/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    
                                </xsl:element>
                                
                                <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                                    <xsl:attribute name="width">10%</xsl:attribute>
                                    <xsl:attribute name="display-align">after</xsl:attribute>
                                    
                                    <xsl:element name="fo:block" use-attribute-sets="strong align-center">
                                        <xsl:call-template name="process-string-variant">
                                            <xsl:with-param name="name" select="string('likelihood')"/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    
                                </xsl:element>
                                
                                <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                                    <xsl:attribute name="width">10%</xsl:attribute>
                                    <xsl:attribute name="display-align">after</xsl:attribute>
                                    
                                    <xsl:element name="fo:block" use-attribute-sets="strong align-center">
                                        <xsl:call-template name="process-string-variant">
                                            <xsl:with-param name="name" select="string('timeframe')"/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    
                                </xsl:element>
                                
                            </xsl:element>
                            
                        </xsl:element>
                        
                        <xsl:element name="fo:table-body" use-attribute-sets="">
                            
                            <xsl:apply-templates />
                            
                        </xsl:element>
                        
                    </xsl:element>
                    
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates />
                </xsl:otherwise>
                
            </xsl:choose>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template name="process-level-2-section-with-heading-and-with-implied-grouping">
        <xsl:variable name="name" select="name()" />
        <xsl:variable name="parent-name" select="name(parent::*)" />
        
        <xsl:element name="fo:block" use-attribute-sets="default-padding">
            
            <xsl:element name="fo:block" use-attribute-sets="h2">
                
                <!-- we concat the level-1 section name to our level-2 headings -->
                <xsl:if test="$parent-name">
                    <xsl:call-template name="process-string-variant">
                        <xsl:with-param name="name" select="$parent-name"/>
                    </xsl:call-template>
                    <xsl:text>: </xsl:text>
                </xsl:if>
                
                <xsl:call-template name="process-string-variant">
                    <xsl:with-param name="name" select="$name"/>
                </xsl:call-template>
                
            </xsl:element>
            
            <!-- TODO order these enumerations the same in schema as here -->
            <xsl:for-each 
                select="
                risk-factor[@strength='strong'][1] |
                risk-factor[@strength='weak'][1] |
                risk-factor[@strength='unset'][1] |
                
                factor[@key-factor='true'][1] |
                factor[@key-factor='false'][1] |
                factor[@key-factor='unset'][1] |
                
                test[@order='initial'][1] |
                test[@order='subsequent'][1] |
                test[@order='emerging'][1] |
                test[@order='unset'][1] | 
                
                tx-option[@timeframe='presumptive'][1] | 
                tx-option[@timeframe='acute'][1] |
                tx-option[@timeframe='ongoing'][1] 
                ">
                
                <xsl:variable name="section" select="name()" />
                <xsl:variable name="group" select="@strength | @key-factor | @order | @timeframe" />
                <xsl:variable name="name" select="concat($group, '-', $section, '-group')" />
                
                <xsl:element name="fo:block" use-attribute-sets="default-padding">
                    
                    <xsl:choose>
                        
                        <xsl:when 
                            test="
                            $name='weak-risk-factor-group' 
                            or $name='false-factor-group' 
                            or $name='subsequent-test-group' 
                            or $name='emerging-test-group' 
                            or $name='acute-tx-option-group' 
                            or $name='ongoing-tx-option-group' 
                            or $name='true-differential-group' 
                            or $name='false-differential-group'
                            ">
                            
                            <xsl:element name="fo:block" use-attribute-sets="strong background-navy color-white default-padding">
                                <xsl:call-template name="process-string-variant">
                                    <xsl:with-param name="name" select="$name"/>
                                </xsl:call-template>
                            </xsl:element>
                            
                        </xsl:when>
                        
                        <xsl:when 
                            test="
                            $name='strong-risk-factor-group' 
                            or $name='true-factor-group' 
                            or $name='initial-test-group' 
                            or $name='presumptive-tx-option-group' 
                            ">
                            
                            <xsl:element name="fo:block" use-attribute-sets="strong background-maroon color-white default-padding">
                                <xsl:call-template name="process-string-variant">
                                    <xsl:with-param name="name" select="$name"/>
                                </xsl:call-template>
                            </xsl:element>
                            
                        </xsl:when>
                        
                        <xsl:otherwise>
                            
                            <xsl:element name="fo:block" use-attribute-sets="strong background-grey color-white default-padding">
                                <xsl:call-template name="process-string-variant">
                                    <xsl:with-param name="name" select="$name"/>
                                </xsl:call-template>
                            </xsl:element>
                            
                        </xsl:otherwise>
                        
                    </xsl:choose>
                    
                    <xsl:choose>
                        
                        <xsl:when test="$section='tx-option'">
                            <xsl:call-template name="process-first-tx-option-in-timeframe-group" />
                        </xsl:when>
                        
                        <xsl:when test="$section='test'">
                            
                            <xsl:element name="fo:table" use-attribute-sets="default-padding">
                                <xsl:attribute name="border">0</xsl:attribute>
                                <xsl:attribute name="table-omit-header-at-break">true</xsl:attribute>
                                
                                <xsl:element name="fo:table-header" use-attribute-sets="">
                                    
                                    <xsl:element name="fo:table-row" use-attribute-sets="">
                                        <xsl:attribute name="border-bottom">1pt</xsl:attribute>
                                        <xsl:attribute name="border-color">#000000</xsl:attribute>
                                        <xsl:attribute name="border-style">solid</xsl:attribute>
                                        <xsl:attribute name="border-top">0pt</xsl:attribute>
                                        
                                        <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                                            <xsl:attribute name="width">55%</xsl:attribute>
                                            <xsl:attribute name="display-align">after</xsl:attribute>
                                            
                                            <xsl:element name="fo:block" use-attribute-sets="strong align-center">
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="string('test')"/>
                                                </xsl:call-template>
                                            </xsl:element>
                                            
                                        </xsl:element>
                                        
                                        <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                                            <xsl:attribute name="width">45%</xsl:attribute>
                                            <xsl:attribute name="display-align">after</xsl:attribute>
                                            
                                            <xsl:element name="fo:block" use-attribute-sets="strong align-center">
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="string('result')"/>
                                                </xsl:call-template>
                                            </xsl:element>
                                            
                                        </xsl:element>
                                        
                                    </xsl:element>
                                    
                                </xsl:element>
                                
                                <xsl:element name="fo:table-body" use-attribute-sets="">
                                    <xsl:apply-templates select="parent::*/*[name()=$section and @*=$group]" />
                                </xsl:element>
                                
                            </xsl:element>
                            
                        </xsl:when>
                        
                        <xsl:when test="$section='differential'">
                            
                            <xsl:element name="fo:table" use-attribute-sets="default-padding">
                                <xsl:attribute name="border">0</xsl:attribute>
                                <xsl:attribute name="table-omit-header-at-break">true</xsl:attribute>
                                
                                <xsl:element name="fo:table-header" use-attribute-sets="">
                                    
                                    <xsl:element name="fo:table-row" use-attribute-sets="">
                                        <xsl:attribute name="border-bottom">1pt</xsl:attribute>
                                        <xsl:attribute name="border-color">#000000</xsl:attribute>
                                        <xsl:attribute name="border-style">solid</xsl:attribute>
                                        <xsl:attribute name="border-top">0pt</xsl:attribute>
                                        
                                        <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                                            <xsl:attribute name="width">20%</xsl:attribute>
                                            <xsl:attribute name="display-align">after</xsl:attribute>
                                            
                                            <xsl:element name="fo:block" use-attribute-sets="strong align-center">
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="string('condition')"/>
                                                </xsl:call-template>
                                            </xsl:element>
                                            
                                        </xsl:element>
                                        
                                        <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                                            <xsl:attribute name="width">40%</xsl:attribute>
                                            <xsl:attribute name="display-align">after</xsl:attribute>
                                            
                                            <xsl:element name="fo:block" use-attribute-sets="strong align-center">
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="string('sign-symptoms')"/>
                                                </xsl:call-template>
                                            </xsl:element>
                                            
                                        </xsl:element>
                                        
                                        <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                                            <xsl:attribute name="width">40%</xsl:attribute>
                                            <xsl:attribute name="display-align">after</xsl:attribute>
                                            
                                            <xsl:element name="fo:block" use-attribute-sets="strong align-center">
                                                <xsl:call-template name="process-string-variant">
                                                    <xsl:with-param name="name" select="string('differentials-tests')"/>
                                                </xsl:call-template>
                                            </xsl:element>
                                            
                                        </xsl:element>
                                        
                                    </xsl:element>
                                    
                                </xsl:element>
                                
                                <xsl:element name="fo:table-body" use-attribute-sets="">
                                    <xsl:apply-templates select="parent::*/*[name()=$section and @*=$group]" />
                                </xsl:element>
                                
                            </xsl:element>
                            
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:apply-templates select="parent::*/*[name()=$section and @*=$group]" />
                        </xsl:otherwise>
                        
                    </xsl:choose>
                    
                </xsl:element>
                
            </xsl:for-each>
            
        </xsl:element>
        
    </xsl:template>

    <xsl:template name="process-level-2-section-with-heading-and-with-implied-list-content">
        <xsl:variable name="name" select="name()" />
        
        <xsl:element name="fo:block" use-attribute-sets="default-padding">
            
            <xsl:element name="fo:block" use-attribute-sets="h2">
                <xsl:call-template name="process-string-variant">
                    <xsl:with-param name="name" select="$name"/>
                </xsl:call-template>
            </xsl:element>
            
            <xsl:element name="fo:list-block" use-attribute-sets="">
                
                <xsl:for-each select="element()">
                    
                    <xsl:element name="fo:list-item" use-attribute-sets="">
                        
                        <xsl:element name="fo:list-item-label" use-attribute-sets="">
                            <xsl:attribute name="end-indent">label-end()</xsl:attribute>
                            
                            <xsl:element name="fo:block" use-attribute-sets="strong">
                                <xsl:element name="fo:inline" use-attribute-sets="">
                                    <xsl:attribute name="padding-left">10pt</xsl:attribute>
                                    <xsl:value-of select="$bullet-icon"/>
                                </xsl:element>
                            </xsl:element>
                            
                        </xsl:element>
                        
                        <xsl:element name="fo:list-item-body" use-attribute-sets="">
                            <xsl:attribute name="start-indent">body-start()</xsl:attribute>
                            
                            <xsl:element name="fo:block" use-attribute-sets="">
                                <xsl:apply-templates />
                            </xsl:element>
                            
                        </xsl:element>
                        
                    </xsl:element>
                    
                </xsl:for-each>
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>

    <xsl:template name="process-level-3-section-with-heading">
        <xsl:variable name="name" select="name()" />
        <xsl:variable name="position" select="position()" />
        
        <xsl:element name="fo:block" use-attribute-sets="">
            
            <xsl:element name="fo:block" use-attribute-sets="h3">
                
                <xsl:call-template name="process-string-variant">
                    <xsl:with-param name="name" select="$name"/>
                </xsl:call-template>
                
                <xsl:if test="$name = 'vignette' and count(parent::vignettes/vignette)=3"><!--//vignette[string-length(normalize-space(.))!=0]-->
                    <xsl:text disable-output-escaping="yes"> </xsl:text>
                    <xsl:variable name="position-id" select="generate-id()"/>
                    
                    <xsl:for-each select="parent::*/*">
                        
                        <xsl:if test="generate-id()=$position-id">
                            <xsl:value-of select="position()" />
                        </xsl:if>
                        
                    </xsl:for-each>
                    
                </xsl:if>
            </xsl:element>
            
            <xsl:apply-templates />
            
        </xsl:element>
        
    </xsl:template>

    <xsl:template name="process-level-3-section-with-ordered-content">
        <xsl:variable name="name" select="name()" />
        <xsl:variable name="generate-id" select="generate-id()"/>
        <xsl:variable name="group" select="@strength | @key-factor | @order | @timeframe" />
        
        <xsl:element name="fo:block" use-attribute-sets="default-padding">

            <xsl:choose>
                
                <xsl:when test="string-length(normalize-space($group))!=0 and not(@timeframe) and position()=1">
                    <xsl:attribute name="id" select="concat('first-in-', $group, '-', $name, '-group')" />
                </xsl:when>
                
                <xsl:when test="@timeframe">
                    
                    <xsl:for-each select="parent::*/*">
                        
                        <xsl:if test="generate-id()=$generate-id and position()=1">
                            <xsl:attribute name="id" select="concat('first-in-', $name, '-group')" />
                        </xsl:if>
                        
                    </xsl:for-each>
                    
                </xsl:when>
                
                <xsl:when test="string-length(normalize-space($group))=0 or @timeframe">
                    <xsl:for-each select="parent::*/*">
                        
                        <xsl:if test="generate-id()=$generate-id and position()=1">
                            <xsl:attribute name="id" select="concat('first-in-', $name, '-group')" />
                        </xsl:if>
                        
                    </xsl:for-each>
                    
                </xsl:when>
                
                <xsl:otherwise>
                    <!--<xsl:comment select="position()" />-->        
                </xsl:otherwise>
                
            </xsl:choose>

            <!-- header types -->
            
            <xsl:element name="fo:block" use-attribute-sets="">
                
                <xsl:for-each select="title | name | factor-name | ddx-name">
                        
                    <xsl:element name="fo:inline" use-attribute-sets="h3">
                    
                        <xsl:apply-templates select="node()"/>
                        
                    </xsl:element>
                    
                </xsl:for-each>
                
                <xsl:if test="@frequency">
                    
                    <xsl:text disable-output-escaping="yes"> </xsl:text>
                    
                    <xsl:element name="fo:inline" use-attribute-sets="">
                        <xsl:text>(</xsl:text>
                        <xsl:value-of select="@frequency" />
                        <xsl:text>)</xsl:text>
                    </xsl:element>
                    
                </xsl:if>
                
            </xsl:element>
            
            <xsl:if test="@likelihood | @timeframe">
                
                <xsl:for-each select="@likelihood | @timeframe">
                    
                    <xsl:element name="fo:block" use-attribute-sets="">
                        <xsl:apply-templates select="."/>
                    </xsl:element>
                    
                </xsl:for-each>
                
            </xsl:if>
            
            <!-- prompt types : para -->
            <xsl:apply-templates select="url[parent::guideline]"/>
            <xsl:apply-templates select="result"/> 
            <xsl:apply-templates select="source[parent::figure]"/>
            <xsl:apply-templates select="source[parent::guideline]"/>
            <xsl:apply-templates select="last-published "/>
            <xsl:apply-templates select="pt-group"/>
            <xsl:apply-templates select="parent-pt-group"/>
            <xsl:apply-templates select="tx-type"/>
            <xsl:apply-templates select="category"/>

            <!-- body types -->
            <xsl:apply-templates select="sign-symptoms" />
            <xsl:apply-templates select="detail[parent::risk-factor]" />
            <xsl:apply-templates select="detail[parent::factor]" />
            <xsl:apply-templates select="detail[parent::complication]" />
            <xsl:apply-templates select="detail[parent::test]" />
            <xsl:apply-templates select="detail[parent::classification]" />
            <xsl:apply-templates select="detail[parent::criteria]" />
            <xsl:apply-templates select="detail[parent::emerging-tx]" />
            <xsl:apply-templates select="detail[parent::subtype]" />
            <xsl:apply-templates select="summary[string-length(normalize-space(.))!=0]" />
            <xsl:apply-templates select="history" />
            <xsl:apply-templates select="exam" />
            <xsl:apply-templates select="tests[parent::diagnosis and ancestor::monograph-full]" />
            <xsl:apply-templates select="tests[parent::differential and ancestor::monograph-full]" />
            <xsl:apply-templates select="tests[parent::differential and ancestor::monograph-eval]" />

        </xsl:element>
    </xsl:template>
                        
    <xsl:template name="process-level-3-section-with-tabulated-content-test">
        
        <xsl:element name="fo:table-row" use-attribute-sets="">
            
            <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                <xsl:attribute name="width">55%</xsl:attribute>
                
                <xsl:element name="fo:block" use-attribute-sets="">
                
                    <xsl:element name="fo:block" use-attribute-sets="strong default-padding">
                        
                        <xsl:apply-templates select="name/node()"/>
                        
                    </xsl:element>
                    
                    <xsl:apply-templates select="detail[parent::test]" />
                
                </xsl:element>
                
            </xsl:element>
            
            <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                <xsl:attribute name="width">45%</xsl:attribute>
                
                <xsl:element name="fo:block" use-attribute-sets="default-padding">
                    <xsl:apply-templates select="result/node()"/>
                </xsl:element>
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>

    <xsl:template name="process-level-3-section-with-tabulated-content-differential">
        
        <xsl:element name="fo:table-row" use-attribute-sets="">
            
            <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                <xsl:attribute name="width">20%</xsl:attribute>
                
                <xsl:element name="fo:block" use-attribute-sets="">
                    
                    <xsl:element name="fo:block" use-attribute-sets="default-padding">
                        
                        <xsl:apply-templates select="name/node()"/>
                        
                    </xsl:element>
                    
                    <xsl:apply-templates select="detail" />
                    
                </xsl:element>
                
            </xsl:element>
            
            <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                <xsl:attribute name="width">40%</xsl:attribute>
                
                <xsl:apply-templates select="sign-symptoms" />
                
            </xsl:element>
            
            <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                <xsl:attribute name="width">40%</xsl:attribute>
                
                <xsl:apply-templates select="tests" />
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template name="process-level-3-section-with-tabulated-content-complication">
        
        <xsl:element name="fo:table-row" use-attribute-sets="">
            
            <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                <xsl:attribute name="width">80%</xsl:attribute>
                
                <xsl:element name="fo:block" use-attribute-sets="">
                    
                    <xsl:element name="fo:block" use-attribute-sets="default-padding">
                        
                        <xsl:apply-templates select="name/node()"/>
                        
                    </xsl:element>
                    
                    <xsl:apply-templates select="detail" />
                    
                </xsl:element>
                
            </xsl:element>
            
            <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                <xsl:attribute name="width">10%</xsl:attribute>
                
                <xsl:element name="fo:block" use-attribute-sets="">
                    <xsl:value-of select="@likelihood" />
                </xsl:element>
                
            </xsl:element>
            
            <xsl:element name="fo:table-cell" use-attribute-sets="default-margin">
                <xsl:attribute name="width">10%</xsl:attribute>
                
                <xsl:element name="fo:block" use-attribute-sets="">
                    <xsl:value-of select="@timeframe" />
                </xsl:element>
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template name="process-level-4-section-with-heading-and-with-para-and-list-content">
        <xsl:variable name="name" select="name()" />
    
        <xsl:element name="fo:block" use-attribute-sets="default-padding">
       
            <xsl:element name="fo:block" use-attribute-sets="h4">
                <xsl:call-template name="process-string-variant">
                    <xsl:with-param name="name" select="$name"/>
                </xsl:call-template>
            </xsl:element>
            
            <xsl:choose>
                
                <xsl:when test="para | list">
                    <xsl:apply-templates />
                </xsl:when>
                
                <xsl:otherwise>
                    
                    <xsl:element name="fo:block" use-attribute-sets="">
                        <xsl:apply-templates />
                    </xsl:element>
                    
                </xsl:otherwise>
                
            </xsl:choose>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template name="process-level-4-section-with-heading-and-with-implied-list-content">
        <xsl:variable name="name" select="name()" />
        
        <xsl:element name="fo:block" use-attribute-sets="default-padding">
            
            <xsl:element name="fo:block" use-attribute-sets="h4">
                <xsl:call-template name="process-string-variant">
                    <xsl:with-param name="name" select="$name"/>
                </xsl:call-template>
            </xsl:element>
            
            <xsl:element name="fo:list-block" use-attribute-sets="">
                
                <xsl:for-each select="para">
                    
                    <xsl:element name="fo:list-item" use-attribute-sets="">
                        
                        <xsl:element name="fo:list-item-label" use-attribute-sets="">
                            <xsl:attribute name="end-indent">label-end()</xsl:attribute>
                            
                            <xsl:element name="fo:block" use-attribute-sets="strong">
                                <xsl:element name="fo:inline" use-attribute-sets="">
                                    <xsl:attribute name="padding-left">10pt</xsl:attribute>
                                    <xsl:value-of select="$bullet-icon"/>
                                </xsl:element>
                            </xsl:element>
                            
                        </xsl:element>
                        
                        <xsl:element name="fo:list-item-body" use-attribute-sets="">
                            <xsl:attribute name="start-indent">body-start()</xsl:attribute>
                            
                            <xsl:element name="fo:block" use-attribute-sets="">
                                <xsl:apply-templates />
                            </xsl:element>
                            
                        </xsl:element>
                        
                    </xsl:element>
                    
                </xsl:for-each>
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template name="process-level-4-section-without-heading-and-with-implied-list-content">
        <xsl:variable name="name" select="name()" />
        
        <xsl:element name="fo:block" use-attribute-sets="default-padding">
            
            <xsl:element name="fo:list-block" use-attribute-sets="">
                
                <xsl:for-each select="para">
                    
                    <xsl:element name="fo:list-item" use-attribute-sets="">
                        
                        <xsl:element name="fo:list-item-label" use-attribute-sets="">
                            <xsl:attribute name="end-indent">label-end()</xsl:attribute>
                            
                            <xsl:element name="fo:block" use-attribute-sets="strong">
                                <xsl:element name="fo:inline" use-attribute-sets="">
                                    <xsl:attribute name="padding-left">10pt</xsl:attribute>
                                    <xsl:value-of select="$bullet-icon"/>
                                </xsl:element>
                            </xsl:element>
                            
                        </xsl:element>
                        
                        <xsl:element name="fo:list-item-body" use-attribute-sets="">
                            <xsl:attribute name="start-indent">body-start()</xsl:attribute>
                            
                            <xsl:element name="fo:block" use-attribute-sets="">
                                <xsl:apply-templates />
                            </xsl:element>
                            
                        </xsl:element>
                        
                    </xsl:element>
                    
                </xsl:for-each>
                
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template name="process-level-4-section-without-heading-and-with-para-and-list-content">
        <xsl:variable name="name" select="name()" />
        
        <xsl:element name="fo:block" use-attribute-sets="default-padding">
            
            <xsl:choose>
                
                <xsl:when test="para | list">
                    <xsl:apply-templates />
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:element name="fo:block" use-attribute-sets="">
                        <xsl:apply-templates />
                    </xsl:element>
                </xsl:otherwise>
                
            </xsl:choose>
            
        </xsl:element>
        
    </xsl:template>

</xsl:stylesheet>

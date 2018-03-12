<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns="http://schema.bmj.com/delivery/oak"
    xmlns:bp="http://schema.bmj.com/delivery/oak-bp"
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
    version="2.0">
    
    <xsl:template name="process-top-level">
        <xsl:variable name="name" select="name()"/>
        
        <xsl:element name="section">
            <xsl:namespace name="bp">http://schema.bmj.com/delivery/oak-bp</xsl:namespace>
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:attribute name="xsi:schemaLocation">http://schema.bmj.com/delivery/oak http://schema.bmj.com/delivery/oak/bmj-oak-strict.xsd</xsl:attribute>
            <!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
            <xsl:attribute name="class" select="$name"/>
            <xsl:attribute name="id" select="concat('_', @dx-id)"/>
            <!--<xsl:attribute name="xml:lang" select="$lang"/>-->
            
            <xsl:apply-templates select="monograph-info"/>
            
            <!--<xsl:apply-templates select="person-group" mode="short-hand"/>-->
            <!--<xsl:apply-templates select="last-updated" mode="short-hand"/>-->
            
            <xsl:if test="($name = 'monograph-full' or $name = 'monograph-eval')">
                
                <xsl:element name="section">
                    <xsl:attribute name="class" select="$name"/>
                    
                    <xsl:variable name="name">monograph-summary</xsl:variable>
                    
                    <xsl:element name="title">
                        <xsl:call-template name="process-string-variant">
                            <xsl:with-param name="name" select="$name"/>
                        </xsl:call-template>
                    </xsl:element>
                        
                    <xsl:apply-templates select="highlights"/>
                    
                    <xsl:if test="$name = 'monograph-full'">
                        <xsl:apply-templates select="//figure[contains(image-link/@target, 'hlight')]"/>
                    </xsl:if>
                    
                    <xsl:apply-templates select="/monograph-full/diagnosis/diagnostic-factors" mode="summary"/>
                    <xsl:apply-templates select="/monograph-full/diagnosis/tests" mode="summary"/>
                    <xsl:apply-templates select="/monograph-full/treatment/tx-options" mode="summary"/>
                    <xsl:apply-templates select="/monograph-eval/differentials" mode="summary"/>
                        
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
            
            <!--<xsl:variable name="evidence-scores">
                <xsl:element name="references">
                <xsl:element name="evidence-scores">
                <xsl:call-template name="process-evidence-score-links">
                <xsl:with-param name="item-count" select="1"/>
                <xsl:with-param name="link-index" select="1"/>
                <xsl:with-param name="link-count" select="count(//evidence-score-link) + 1"/>
                </xsl:call-template>
                </xsl:element>
                </xsl:element>
                </xsl:variable>-->
            
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
            
            <xsl:apply-templates select="$key-article-references//key-article-references[*]" xpath-default-namespace="http://schema.bmj.com/delivery/oak" />
            <xsl:apply-templates select="$online-references//online-references[*]" xpath-default-namespace="http://schema.bmj.com/delivery/oak" />
            <xsl:apply-templates select="$article-references//article-references[*]" xpath-default-namespace="http://schema.bmj.com/delivery/oak" />
            <xsl:apply-templates select="$figures//figures[*]" xpath-default-namespace="http://schema.bmj.com/delivery/oak" />
            
            <xsl:element name="section">
                <!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
                <xsl:attribute name="class">credits</xsl:attribute>
                
                <xsl:element name="title">
                    <xsl:call-template name="process-string-variant">
                        <xsl:with-param name="name" select="string('credits')"/>
                    </xsl:call-template>
                </xsl:element>
                
                <xsl:variable name="monograph-plan-filename" select="concat($path, '/', //monograph-plan-link/@target)"/>
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
        
        <xsl:element name="section">
            <xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
            <xsl:attribute name="class" select="$name"/>
            
            <xsl:element name="metadata">
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
                    <!--<xsl:attribute name="value">
                        <xsl:if test="$server!='offline'">
                            <xsl:value-of select="legacytag:getTodaysDate()"/>
                        </xsl:if>
                    </xsl:attribute>-->
                </xsl:element>
            </xsl:element>
            
            <xsl:element name="title">
                <xsl:apply-templates select="title/node()" />
            </xsl:element>
            
            <xsl:element name="p">
                
                <xsl:apply-templates select="../@dx-id" />
                
                <xsl:value-of select="$prompt-separator"/>
                
                <xsl:element name="inline">
                    <xsl:attribute name="class">prompt</xsl:attribute>
                    <xsl:call-template name="process-string-variant">
                        <xsl:with-param name="name" select="string('type')"/>
                    </xsl:call-template>
                    <xsl:text>: </xsl:text>
                </xsl:element>
                
                <xsl:variable name="monograph-type" select="name(parent::*)"/>
                
                <xsl:call-template name="process-string-variant">
                    <xsl:with-param name="name" select="$monograph-type"/>
                </xsl:call-template>
                
                <xsl:element name="inline">
                    <xsl:text disable-output-escaping="yes"> [</xsl:text>
                    <xsl:value-of select="$lang" />
                    <xsl:text disable-output-escaping="yes">]</xsl:text>
                </xsl:element>
                
            </xsl:element>
            
            <!--TODO colective-name
                <xsl:element name="p">
                <xsl:element name="inline">
                <xsl:call-template name="process-string-variant">
                <xsl:with-param name="name" select="strings('authors')"/>
                </xsl:call-template>
                <xsl:text>: </xsl:text>
                </xsl:element>
                <xsl:element name="inline">
                <xsl:for-each select="document($monograph-plan//authors/person-link/@target)/monograph-person/author/name">
                <xsl:apply-templates select="node()"/>
                <xsl:text> </xsl:text>
                </xsl:for-each>
                </xsl:element>
                </xsl:element>-->
            
            <!-- TODO last updated -->
            
            <xsl:apply-templates select="topic-synonyms" />
            <xsl:apply-templates select="related-topics[monograph-link]" />
            <xsl:apply-templates select="related-patient-summaries" />
            <xsl:apply-templates select="categories" />
            <xsl:apply-templates select="statistics" /><!-- used?-->
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template name="process-summary-level">
        <xsl:variable name="name" select="name()"/>
        <xsl:element name="section">
            <xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
            <xsl:attribute name="class" select="concat($name, '-summary')"/>
            
            <xsl:element name="title">
                <!--
                    <xsl:call-template name="process-string-variant">
                    <xsl:with-param name="name" select="strings('summary')"/>
                    </xsl:call-template>
                    <xsl:text>: </xsl:text>-->
                <xsl:call-template name="process-string-variant">
                    <xsl:with-param name="name" select="$name"/>
                </xsl:call-template>
            </xsl:element>
            
            <!--risk-factor[@strength='strong'][1] |
                risk-factor[@strength='weak'][1] |
                risk-factor[@strength='unset'][1] |-->
            
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
                
                <xsl:element name="section">
                    
                    <!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
                    <xsl:attribute name="class" select="$name" />
                    
                    <xsl:element name="title">
                        <xsl:call-template name="process-string-variant">
                            <xsl:with-param name="name" select="$name"/>
                        </xsl:call-template>
                    </xsl:element>
                    
                    <xsl:element name="list">
                        
                        <xsl:for-each select="parent::*/*[name()=$section and @*=$group]">
                            
                            <xsl:choose>

                                <xsl:when test="$section='tx-option'">
                                    <xsl:variable name="current-pt-name" select="translate(normalize-space(.), $upper, $lower)"/>
                                    <xsl:if test="true()"><!--following-sibling::tx-option[translate(normalize-space(.), $upper, $lower)!=$current-pt-name]-->
                                        <xsl:element name="li">
                                            <!--[tx-option=<xsl:value-of select="@id"/>]-->
                                            <xsl:apply-templates select="pt-group/node()"/>
                                        </xsl:element>
                                        <xsl:element name="list">
                                            <xsl:element name="li">
                                                <!--[tx-type]-->
                                                <xsl:apply-templates select="tx-type/node()"/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:if test="tx-options/tx-option">
                                        <xsl:element name="list">
                                            <xsl:for-each select="tx-options/tx-option">
                                                <xsl:element name="li">
                                                    <!--[tx-option=<xsl:value-of select="@id"/>]-->
                                                    <xsl:apply-templates select="pt-group/node()"/>
                                                </xsl:element>
                                                <xsl:element name="list">
                                                    <xsl:element name="li">
                                                        <!--[tx-type]-->
                                                        <xsl:apply-templates select="tx-type/node()"/>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:for-each>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:element name="li">
                                        <xsl:apply-templates select="factor-name/node() | name/node() | pt-group/node()"/>
                                    </xsl:element>
                                </xsl:otherwise>
                                
                            </xsl:choose>
                            
                        </xsl:for-each>
                        <!-- TODO add link to full section -->
                    </xsl:element>        
                    
                </xsl:element>
            </xsl:for-each>
            
            <xsl:if test="differential[ancestor::monograph-eval]/category[string-length(normalize-space(.))!=0]">
<!--                <xsl:element name="section">                    
                    <xsl:attribute name="{concat($xmlns, ':oen')}">differential</xsl:attribute>
                    <xsl:attribute name="class">differential-category-summary</xsl:attribute>
                    
                    <xsl:element name="title">
                        <xsl:call-template name="process-string-variant">
                        <xsl:with-param name="name" select="strings('differential-category-summary')"/>
                        </xsl:call-template>
                    </xsl:element>
-->                    
                <xsl:for-each select="differential[ancestor::monograph-eval]">
                    <xsl:sort select="normalize-space(category)"/>
                    <xsl:variable name="current-differential-category" select="translate(normalize-space(category), $upper, $lower)"/>
                        <xsl:if test="position()=1 or translate(normalize-space(preceding-sibling::differential[1]/category), $upper, $lower) != $current-differential-category">
                            <xsl:text disable-output-escaping="yes">&lt;section class="differential-category-group"&gt;</xsl:text>
                            <xsl:text disable-output-escaping="yes">&lt;title&gt;</xsl:text>
                            <xsl:apply-templates select="category/node()"/>
                            <xsl:text disable-output-escaping="yes">&lt;/title&gt;</xsl:text>
                            <xsl:text disable-output-escaping="yes">&lt;list&gt;</xsl:text>
                        </xsl:if>
                        <xsl:element name="li">
                            <xsl:apply-templates select="ddx-name/node()"/>
                        </xsl:element>
                        <xsl:if test="position()=last() or translate(normalize-space(following-sibling::differential[1]/category), $upper, $lower) != $current-differential-category">
                            <xsl:text disable-output-escaping="yes">&lt;/list&gt;</xsl:text>
                            <xsl:text disable-output-escaping="yes">&lt;/section&gt;</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                <!--</xsl:element>-->
            </xsl:if>
            
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="process-level-1-section-with-heading">
        <xsl:variable name="name" select="name()" />
        
            <xsl:element name="section">
                <xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
                <xsl:attribute name="class" select="$name" />
                
                <xsl:element name="title">
                    <xsl:call-template name="process-string-variant">
                        <xsl:with-param name="name" select="$name"/>
                    </xsl:call-template>
                </xsl:element>
                
                <xsl:apply-templates />
                
            </xsl:element>
        
    </xsl:template>
    
    <xsl:template name="process-level-1-section-with-heading-and-with-implied-list-content">
        <xsl:variable name="name" select="name()" />
        
        <xsl:element name="section">
            <xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
            <xsl:attribute name="class" select="$name" />
            
            <xsl:element name="title">
                <xsl:call-template name="process-string-variant">
                    <xsl:with-param name="name" select="$name"/>
                </xsl:call-template>
            </xsl:element>
            
            <xsl:element name="list">
                <xsl:for-each select="element()">
                    <xsl:element name="li" use-attribute-sets="">
                        <xsl:apply-templates />
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>

    <xsl:template name="process-level-2-section-with-heading">
        <xsl:variable name="name" select="name()" />
        <xsl:variable name="parent-name" select="name(parent::*)" />
        
        <xsl:element name="section">
            <xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
            <xsl:attribute name="class" select="$name" />
            
            <xsl:element name="title">
                <!-- we concat the level-1 section name to our level-2 headings -->
                <xsl:if test="$parent-name">
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
                    <xsl:element name="list">
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
                <xsl:otherwise>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template name="process-level-2-section-with-heading-and-with-implied-grouping">
        <xsl:variable name="name" select="name()" />
        <xsl:variable name="parent-name" select="name(parent::*)" />
        
        <xsl:element name="section">
            <xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
            <xsl:attribute name="class" select="$name" />
            
            <xsl:element name="title">
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
                
                <xsl:element name="section">
                    <!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
                    <xsl:attribute name="class" select="$name" />
                    
                    <xsl:element name="title">
                        <xsl:call-template name="process-string-variant">
                            <xsl:with-param name="name" select="$name"/>
                        </xsl:call-template>
                    </xsl:element>
                    
                    <xsl:choose>
                        
                        <xsl:when test="$section='tx-option'">
                            <!--<xsl:call-template name="process-first-tx-option-in-timeframe-group" />-->
                            <xsl:apply-templates select="self::*"/>
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
        
        <xsl:element name="section">
            <xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
            <xsl:attribute name="class" select="$name" />
            
            <xsl:element name="title">
                <xsl:call-template name="process-string-variant">
                    <xsl:with-param name="name" select="$name"/>
                </xsl:call-template>
            </xsl:element>
            
            <xsl:element name="list">
                <xsl:for-each select="element()">
                    <xsl:element name="li" use-attribute-sets="">
                        <xsl:apply-templates />
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>

    <xsl:template name="process-level-3-section-with-heading">
        <xsl:variable name="name" select="name()" />
        <xsl:variable name="position" select="position()" />
        
        <xsl:element name="section">
            <xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
            <xsl:attribute name="class" select="$name" />
            
            <xsl:element name="title">
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
        
        <xsl:element name="section">
            <xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
            <xsl:attribute name="class" select="$name" />
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
            <xsl:for-each select="title | name | factor-name | ddx-name">
                <xsl:element name="title">
                    <xsl:choose>
                        <xsl:when test="preceding-sibling::monograph-link">
                            <xsl:element name="link">
                                <xsl:attribute name="target" select="preceding-sibling::monograph-link/@target"/>
                                <xsl:apply-templates select="node()"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="node()"/>        
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:for-each>
            
            <!-- prompt types : tabbed -->
            <!--<xsl:variable name="attrib-names">frequency,type,likelihood,timeframe</xsl:variable>-->
            
            <!-- ??NOTE removed @strength |@order | @key-factor are now being managed to group section -->
            
            <xsl:for-each select="@*[name()!='strength' or name()!='key-factor' or name()!='order' ]">
                <xsl:comment select="concat('test-attrib-', name())"/>
            </xsl:for-each>
            
            <xsl:if test="@frequency | @type | @likelihood | @timeframe">
                <xsl:element name="section">
                    <xsl:attribute name="class">prompt</xsl:attribute>
                    <xsl:element name="p">
                        <xsl:for-each select="@frequency | @type | @likelihood | @timeframe">
                            <xsl:apply-templates select="."/>
                            <!--TODO and count @* != 1 -->
                            <xsl:if test="position()!=last()">
                                <xsl:copy-of select="$prompt-separator"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            
            <!-- prompt types : para -->
            <xsl:apply-templates select="result"/> 
            <xsl:apply-templates select="source[parent::figure]"/>
            <xsl:apply-templates select="source[parent::guideline]"/>
            <xsl:apply-templates select="url[parent::guideline]"/>
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
            <xsl:apply-templates select="summary" />
            <xsl:apply-templates select="history" />
            <xsl:apply-templates select="exam" />
            <xsl:apply-templates select="tests[parent::diagnosis and ancestor::monograph-full]" />
            <xsl:apply-templates select="tests[parent::differential and ancestor::monograph-full]" />
            <xsl:apply-templates select="tests[parent::differential and ancestor::monograph-eval]" />

        </xsl:element>
    </xsl:template>

    <xsl:template name="process-level-4-section-with-heading-and-with-para-and-list-content">
        <xsl:variable name="name" select="name()" />
            <xsl:element name="section">
                <xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
                <xsl:attribute name="class" select="$name" />
                <xsl:element name="title">
                    <xsl:call-template name="process-string-variant">
                        <xsl:with-param name="name" select="$name"/>
                    </xsl:call-template>
                </xsl:element>
                <xsl:choose>
                    <xsl:when test="para | list">
                        <xsl:apply-templates />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="p">
                            <xsl:apply-templates />
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
    </xsl:template>
    
    <xsl:template name="process-level-4-section-with-heading-and-with-implied-list-content">
        <xsl:variable name="name" select="name()" />
        <xsl:element name="section">
            <xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
            <xsl:attribute name="class" select="$name" />
            <xsl:element name="title">
                <xsl:call-template name="process-string-variant">
                    <xsl:with-param name="name" select="$name"/>
                </xsl:call-template>
            </xsl:element>
            <xsl:element name="list">
            <xsl:for-each select="para">
                <xsl:element name="li">
                    <xsl:apply-templates/>
                    </xsl:element>
            </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="process-level-4-section-without-heading-and-with-implied-list-content">
        <xsl:variable name="name" select="name()" />
        <xsl:element name="section">
            <xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
            <xsl:attribute name="class" select="$name" />
            <xsl:element name="list">
                <xsl:for-each select="para">
                    <xsl:element name="li">
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="process-level-4-section-without-heading-and-with-para-and-list-content">
        <xsl:variable name="name" select="name()" />
            <xsl:element name="section">
                <xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
                <xsl:attribute name="class" select="$name" />
                <xsl:choose>
                    <xsl:when test="para | list">
                        <xsl:apply-templates />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="p">
                            <xsl:apply-templates />
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
    </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  version="2.0"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
     xmlns:xi="http://www.w3.org/2001/XInclude"
     xmlns:xlink="http://www.w3.org/1999/xlink">
     
     <xsl:import href="common-heading1.xsl"/>
     <xsl:param name="maintopicname"/>
     
     <xsl:output 
          method="xml" 
          encoding="UTF-8"
          indent="yes"/>
     
     <xsl:strip-space elements="*"/>
     
     <!-- 
          stylesheet to format for the main xml, placing all heading1 inside sec
          and partitioning each topic-element into corresponding type
          - creating the introduction, description, symptoms, incidence, prognosis, diagnosis, questions-to-ask and treatment-points 
          - xref, table-wrap, list-item
          
          TODO:
          fix links, know correct naming for treatments, figure
     -->
     
     
     <!--this wrapper is just so output is well-formed     -->
     <xsl:template match="/">
          <xsl:element name="article">
               <xsl:namespace name="xi">http://www.w3.org/2001/XInclude</xsl:namespace>
               <xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>
               <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
               <xsl:attribute name="xsi:noNamespaceSchemaLocation">
                    <xsl:text>../../schemas/nlm-hybrid-article-patient.xsd</xsl:text>
               </xsl:attribute>
               <xsl:attribute name="article-type">patient-topic</xsl:attribute>
               
               <!-- front includes article metadata, custom meta group, related-article(systematic review and reference list) and notes -->
               <xsl:element name="front">
                    <xsl:element name="article-meta">
                         <xsl:element name="title-group">
                              <xsl:element name="article-title">
                                   <xsl:value-of select="/patient-topic/topic-info/title"/>    
                              </xsl:element>
                              <xsl:element name="alt-title">
                                   <xsl:attribute name="alt-title-type">abridged</xsl:attribute>
                                   <xsl:value-of select="/patient-topic/topic-info/title"/>    
                              </xsl:element>          
                              
                              <xsl:for-each select="/patient-topic/topic-info/synonyms/synonym">
                                   <xsl:element name="alt-title">
                                           <xsl:value-of select="."/>
                                   </xsl:element>                                   
                              </xsl:for-each>                              
                         </xsl:element>
                         
                         <xsl:element name="related-article">
                              <xsl:attribute name="href"><xsl:value-of select="/patient-topic/topic-info/systematic-review-link/@target"/></xsl:attribute>
                              <xsl:attribute name="related-article-type">systematic-review</xsl:attribute>
                              <xsl:attribute name="section"></xsl:attribute>
                         </xsl:element>
                         
                         <xsl:element name="custom-meta-group">
                              <xsl:call-template name="add-custom-meta">
                                   <xsl:with-param name="name">condition-centre</xsl:with-param>
                                   <xsl:with-param name="value"></xsl:with-param>
                              </xsl:call-template>
                         </xsl:element>
                    </xsl:element>
                    
                    <xsl:element name="notes">
                         <xsl:element name="sec">
                              <xsl:element name="title"/>
                              <xsl:element name="p"/>
                         </xsl:element>
                    </xsl:element>
               </xsl:element>
               <!--end of font -->
               
               <xsl:element name="body">
                    <xsl:apply-templates/>
               </xsl:element>
               
               <xsl:element name="floats-group">
                    <!-- 
                    <xsl:for-each select="//figure">
                         <xsl:if test="not(@href = preceding::figure/@href)">
                              <xsl:element name="xi:include">
                                   <xsl:attribute name="href" select="@href"/>
                              </xsl:element>                              
                         </xsl:if>
                    </xsl:for-each>
                    -->
               </xsl:element>
          </xsl:element>
     </xsl:template>
     
     
     <!-- PROCESS BODY -->
     <xsl:template match="topic-info">
          <xsl:call-template name="add-body-section">
               <xsl:with-param name="param"><xsl:text>introduction</xsl:text></xsl:with-param>
          </xsl:call-template>        
     </xsl:template>
     
     <!--template to process list-->
     <xsl:template match="topic-element">
          <xsl:variable name="topic-type" select="@type"/>
          <xsl:choose>
               <xsl:when test="$topic-type = 'treatments'">
                    <xsl:call-template name="add-body-section">
                         <xsl:with-param name="param">treatment-points</xsl:with-param>
                    </xsl:call-template>                    
               </xsl:when>
               <xsl:otherwise>
                    <xsl:call-template name="add-body-section">
                         <xsl:with-param name="param"><xsl:value-of select="$topic-type"/></xsl:with-param>
                    </xsl:call-template>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>
     
     
     <!-- CREATES section for introduction, symptoms, incidence, prognosis, diagnosis, questions-to-ask -->
     <xsl:template name="add-body-section">
          <xsl:param name="param"/>
          <xsl:element name="{$param}">
               <xsl:choose>
                    <xsl:when test="$param = 'description'">
                         <xsl:apply-templates select="body-text" mode="withintro" />               
                    </xsl:when>
                    <xsl:when test="$param = 'treatment-points'">
                         <xsl:apply-templates select="body-text" mode="withintro" />               
                    </xsl:when>
                    <xsl:when test="$param = 'temp-group'">
                         <xsl:attribute name="id" select="@id"/>
                         <xsl:apply-templates select="body-text" mode="withintro" />               
                    </xsl:when>                                          
                    <xsl:otherwise>
                         <xsl:apply-templates select="body-text" mode="nointro" />
                    </xsl:otherwise>
               </xsl:choose>
          </xsl:element>
     </xsl:template>    
     
     <!-- match body text and apply templates for known children-->
     <xsl:template match="body-text" mode="nointro">
          <xsl:variable name="topictype" select="current()/ancestor::topic-element/@type"/>
          <xsl:variable name="headingForThisType" select="key('HeadingType', generate-id($topictype))"></xsl:variable>
          
          <xsl:element name="sec">
               <xsl:apply-templates select="preceding-sibling::title" mode="head1"/>     
               <xsl:apply-templates select="preceding-sibling::introduction"/>
               <xsl:choose>
                    <xsl:when test="not($headingForThisType)">
                         <xsl:apply-templates select="key('WholeSection',generate-id())" mode="para"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:apply-templates select="key('ParaBefore1stHeading1',generate-id())" mode="para"/>
                         <xsl:apply-templates select="key('Before1stHeading1',generate-id())" mode="para"/>
                    </xsl:otherwise>
               </xsl:choose>
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     
     <xsl:template match="body-text" mode="withintro">
          <xsl:variable name="topictype" select="current()/ancestor::topic-element/@type"/>
          <xsl:variable name="headingForThisType" select="key('HeadingType', generate-id($topictype))"></xsl:variable>
          
          <xsl:element name="sec-intro">
               <xsl:apply-templates select="preceding-sibling::title" mode="head1"/>     
               <xsl:apply-templates select="preceding-sibling::introduction"/>
               <xsl:choose>
                    <xsl:when test="not($headingForThisType)">
                         <xsl:apply-templates select="key('WholeSection',generate-id())" mode="para"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:apply-templates select="key('ParaBefore1stHeading1',generate-id())" mode="para"/>
                         <xsl:apply-templates select="key('Before1stHeading1',generate-id())" mode="para"/>
                    </xsl:otherwise>
               </xsl:choose>
          </xsl:element>
          
          <xsl:apply-templates/>
     </xsl:template>
     
     <!-- match heading1, set up sec container and then pull in content using keyed components-->
     <xsl:template match="heading1">
          
          <xsl:element name="sec">
               <!--process the title-->
               <xsl:apply-templates select="." mode="head1"/>
               <xsl:variable name="type">
                    <xsl:choose>
                         <xsl:when test="ancestor::topic-info">
                              <xsl:text>introduction</xsl:text>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:value-of select="ancestor::topic-element/@type"/>          
                         </xsl:otherwise>
                    </xsl:choose>
               </xsl:variable>
               
               
               <xsl:if test="key('OddPara',generate-id())">
                    <xsl:element name="p">
                         <xsl:apply-templates select="key('OddPara',generate-id())" mode="para"/>                         
                    </xsl:element>
               </xsl:if>
               
               <xsl:apply-templates select="key('NormalParaTopicElement', concat(generate-id(ancestor::topic-element), generate-id()))" mode="para"/>
          </xsl:element>
     </xsl:template>
     
     
     <xsl:template name="add-custom-meta">
          <xsl:param name="name"/>
          <xsl:param name="value"/>
          <xsl:element name="custom-meta">
               <xsl:element name="meta-name"><xsl:value-of select="$name"/></xsl:element>
               <xsl:element name="meta-value"><xsl:value-of select="$value"/></xsl:element>
          </xsl:element>
     </xsl:template>
     
     <xsl:template match="treatment-link" mode="para">
          <xsl:choose>
               <xsl:when test="//topic-element[@type='temp-group']/@id = @target">
                    <xsl:element name="internal-link">
                         <xsl:attribute name="target"><xsl:value-of select="concat($maintopicname, '.xml')"/></xsl:attribute>
                         <xsl:attribute name="target-element">
                              <xsl:text>treatment-points/group[</xsl:text>
                              <xsl:call-template name="findGroupPosition">
                                   <xsl:with-param name="groupId" select="@target"/>
                              </xsl:call-template>
                              <xsl:text>]/treatments</xsl:text>
                         </xsl:attribute>
                         <xsl:apply-templates mode="para"/>
                    </xsl:element>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:element name="{name()}">
                         <xsl:for-each select="@*">
                              <xsl:attribute name="{name()}">
                                   <xsl:value-of select="."/>
                              </xsl:attribute>
                         </xsl:for-each>
                         <xsl:apply-templates mode="para"/>
                    </xsl:element>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:template>
     
     <xsl:template name="findGroupPosition">
          <xsl:param name="groupId"/>
          <xsl:for-each select="//topic-element[@type='temp-group']">
               <xsl:if test="$groupId = @id">
                    <xsl:value-of select="position()"/>
               </xsl:if>
          </xsl:for-each>
     </xsl:template>
    
</xsl:stylesheet>

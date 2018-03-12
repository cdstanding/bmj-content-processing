<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  version="2.0"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
     xmlns:xi="http://www.w3.org/2001/XInclude"
     xmlns:xlink="http://www.w3.org/1999/xlink">
     
     <xsl:import href="../patient-topic/common-heading1.xsl"/>
    
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
               <xsl:attribute name="article-type">patient-summary</xsl:attribute>
               
               <!-- front includes article metadata, custom meta group, related-article(systematic review and reference list) and notes -->
               <xsl:element name="front">
                    <xsl:element name="article-meta">
                         <xsl:element name="title-group">
                              <xsl:element name="article-title">
                                   <xsl:value-of select="/patient-summary/topic-info/title"/>    
                              </xsl:element>
                              <xsl:element name="alt-title">
                                   <xsl:attribute name="alt-title-type">abridged</xsl:attribute>
                                   <xsl:value-of select="/patient-summary/topic-info/title"/>    
                              </xsl:element>          
                              
                              <xsl:for-each select="/patient-summary/topic-info/synonyms/synonym">
                                   <xsl:element name="alt-title">
                                           <xsl:value-of select="."/>
                                   </xsl:element>                                   
                              </xsl:for-each>                              
                         </xsl:element>
                         
                         <xsl:element name="related-article">
                              <xsl:attribute name="href"><xsl:value-of select="/patient-summary/topic-info/systematic-review-link/@target"/></xsl:attribute>
                              <xsl:attribute name="related-article-type">systematic-review</xsl:attribute>
                              <xsl:attribute name="section"></xsl:attribute>
                         </xsl:element>
                         
                         <xsl:element name="custom-meta-group"/>
                              
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
                    <xsl:apply-templates select="/patient-summary/topic-info/introduction"/>
                    <xsl:apply-templates select="/patient-summary/topic-info/body-text"/>
               </xsl:element>
               
               <xsl:element name="floats-group">
               </xsl:element>
          </xsl:element>
     </xsl:template>
     
     
     <!-- PROCESS BODY -->
     <!--xsl:template match="topic-info">
          <xsl:apply-templates/>
          
     </xsl:template-->
     
     <xsl:template match="introduction">
          <xsl:element name="introduction">
               <xsl:element name="sec">
                    <xsl:element name="p">
                         <xsl:apply-templates select="node()" mode="para"/>
                    </xsl:element>
                    <xsl:apply-templates select="following-sibling::body-text" mode="intro"/>
               </xsl:element>
          </xsl:element>
     </xsl:template>
     
     <xsl:key name="TextBefore1stHeading1" 
          match="text()[parent::p[parent::body-text and child::heading1 and not(preceding-sibling::p[child::heading1])] and not(preceding-sibling::heading1 or name()='heading1') ]" 
          use="generate-id((ancestor::body-text)[last()])"/>
     
     <xsl:template match="body-text" mode="intro">
          <xsl:apply-templates select="key('ParaBefore1stHeading1',generate-id())" mode="para"/>
          <xsl:if test="key('TextBefore1stHeading1',generate-id())">
               <xsl:element name="p">
                    <xsl:apply-templates select="key('TextBefore1stHeading1',generate-id())" mode="para"/>     
               </xsl:element>
          </xsl:if>          
     </xsl:template>
     
     <!-- match body text and apply templates for known children-->
     <xsl:template match="body-text" mode="#default">
          <xsl:element name="content">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     
     <!-- match heading1, set up sec container and then pull in content using keyed components-->
     <xsl:template match="heading1">
          
          <xsl:element name="sec">
               <!--process the title-->
               <xsl:apply-templates select="." mode="head1"/>
              
               <xsl:if test="key('OddPara',generate-id())">
                    <xsl:element name="p">
                         <xsl:apply-templates select="key('OddPara',generate-id())" mode="para"/>                         
                    </xsl:element>
               </xsl:if>
               
               <xsl:apply-templates select="key('NormalPara', generate-id())" mode="para"/>
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
     
</xsl:stylesheet>


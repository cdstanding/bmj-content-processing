<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bmjpg="http://bmjpg.com/schemas/bmjpg/cms" xmlns:xlink="http://www.w3.org/1999/xlink">
     <xsl:variable name="day" select="day-from-date(current-date())"/>
     <xsl:variable name="month" select="month-from-date(current-date())"/>
     <xsl:variable name="year" select="year-from-date(current-date())"/>
     
     <xsl:template match="*|@*|text()" mode="#default">
          <xsl:copy>
               <xsl:apply-templates select="*|@*|text()" mode="#current"/>
          </xsl:copy>
     </xsl:template>
     
     <xsl:template match="*|@*|text()" mode="no-namespace">
          <xsl:copy copy-namespaces="no" inherit-namespaces="no">
               <xsl:apply-templates select="*|@*|text()" mode="#current"/>
          </xsl:copy>
     </xsl:template>
     
     <xsl:template match="article/@xsi:noNamespaceSchemaLocation">
          <xsl:attribute name="noNamespaceSchemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance">
               <xsl:text>http://dtd.nlm.nih.gov/publishing/2.3/xsd/journalpublishing.xsd</xsl:text>
          </xsl:attribute>
     </xsl:template>
     
     <xsl:template match="/">
          <xsl:apply-templates/>
     </xsl:template>
     
     
     <xsl:template match="article-meta">
          <xsl:element name="article-meta">
               <xsl:apply-templates select="child::*" mode="no-namespace"/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="pub-date" mode="#all">
          <xsl:choose>
               <xsl:when test="@pub-type='epub' and not(./day)">
                    <xsl:element name="pub-date">
                         <xsl:attribute name="pub-type">
                              <xsl:text>epub</xsl:text>
                         </xsl:attribute>
                         <xsl:element name="day">
                              <xsl:value-of select="$day"/>
                         </xsl:element>
                         <xsl:element name="month">
                              <xsl:value-of select="$month"/>
                         </xsl:element>
                         <xsl:element name="year">
                              <xsl:value-of select="$year"/>
                         </xsl:element>
                    </xsl:element>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:copy-of select="." copy-namespaces="no"/>
               </xsl:otherwise>
               
          </xsl:choose>
          
     </xsl:template>
     
     <!--<xsl:template match="//front/notes[@notes-type='data-supplement']">
                    **********************************************
                    SUPPRESS DATA-SUPPLEMENT OUTPUT FOR EXTERNAL NON-HIGHWIRE CUSTOMERS?
               *****************************************
     </xsl:template>-->

     <!--     filenames only of target MMO objects-->
     <xsl:template match="self-uri/@xlink:href|supplementary-material/@xlink:href" mode="#all">
          <xsl:variable name="link-basename">
               <xsl:value-of select="replace(.,'.*?([^/]+)\.[^\.]+$','$1.jpg')"/>
          </xsl:variable>
          <xsl:attribute name="href" namespace="http://www.w3.org/1999/xlink" select="$link-basename"/>
     </xsl:template>
    
    <xsl:template match="graphic/@xlink:href">
        <xsl:attribute name="xlink:href">
            <xsl:value-of select="."/><xsl:text>.jpg</xsl:text>
        </xsl:attribute>
     </xsl:template>
    
    
     <!--     doi of target only, need to work on this to derive the doi from a linked target rather then scraping the text-->
     <xsl:template match="related-article" mode="#all">
          <xsl:variable name="href" select="@xlink:href"/>
          <xsl:variable name="content" select="text()"/>
          <xsl:variable name="doi-from-text">
               <xsl:value-of select="replace(text(),&quot;^.*?(10\.\d+/([^\p{Zs}]+)([^).,:;?\] \r\n$\p{Pd}]+)).*?$&quot;,&quot;$1&quot;)"/>
          </xsl:variable>
          <xsl:message select="$doi-from-text"/>
          <xsl:element name="related-article">
               <xsl:choose>
                    <xsl:when test="matches($href,'MISSING','i') and $doi-from-text !=''">
                         <xsl:attribute name="xlink:href" select="$doi-from-text"/>
                    </xsl:when>
                    <xsl:when test="matches($href, 'MISSING', 'i')">
                         <xsl:attribute name="xlink:href" select="MISSING-LINK"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:attribute name="xlink:href" select="$doi-from-text"/>
                    </xsl:otherwise>
               </xsl:choose>
               <xsl:apply-templates select="@ext-link-type|@related-article-type|@xlink:type"/>
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     
     <!--Suppress Pull Quote output-->
     <xsl:template match="//disp-quote[@content-type='style3']" mode="#all"/>
     
     <!--remove comments and processing instructions in the file-->
     <xsl:template match="comment()|processing-instruction()" mode="#all"/>
     
</xsl:stylesheet>
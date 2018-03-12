<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
     xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/"
     xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/">
<xsl:template match="table" mode="#all">
     <xsl:text>&#x0A;</xsl:text>
     <xsl:element name="Table">
          <xsl:attribute name="table" namespace="http://ns.adobe.com/AdobeInDesign/4.0/">
               <xsl:text>table</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="trows" namespace="http://ns.adobe.com/AdobeInDesign/4.0/" select="count(.//tr)"/>
          <xsl:attribute name="tcols" namespace="http://ns.adobe.com/AdobeInDesign/4.0/" select="sum(tbody/tr[1]//@colspan)"/>
          <xsl:attribute name="tablestyle" namespace="http://ns.adobe.com/AdobeInDesign/5.0/" select="'Table1'"/>
          <xsl:apply-templates/>
     </xsl:element>
</xsl:template>

     <xsl:template match="thead|tbody" mode="#all">
          <xsl:apply-templates/>
     </xsl:template>
     
     <xsl:template match="tr" mode="#all">
          <xsl:apply-templates/>
     </xsl:template>
     
     <xsl:template match="th" mode="#all">
          <xsl:element name="Cell">
               <xsl:attribute name="table" namespace="http://ns.adobe.com/AdobeInDesign/4.0/">
                    <xsl:text>cell</xsl:text>
               </xsl:attribute>
               <xsl:attribute name="crows" namespace="http://ns.adobe.com/AdobeInDesign/4.0/" select="@rowspan"/>
               <xsl:attribute name="ccols" namespace="http://ns.adobe.com/AdobeInDesign/4.0/" select="@colspan"/>
               <xsl:attribute name="theader" namespace="http://ns.adobe.com/AdobeInDesign/4.0/"/>
               <xsl:attribute name="cellstyle" namespace="http://ns.adobe.com/AdobeInDesign/5.0/" select="'head'"/>
                    <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="td" mode="#all">
          <xsl:element name="Cell">
               <xsl:attribute name="table" namespace="http://ns.adobe.com/AdobeInDesign/4.0/">
                    <xsl:text>cell</xsl:text>
               </xsl:attribute>
               <xsl:attribute name="crows" namespace="http://ns.adobe.com/AdobeInDesign/4.0/" select="@rowspan"/>
               <xsl:attribute name="ccols" namespace="http://ns.adobe.com/AdobeInDesign/4.0/" select="@colspan"/>
               <xsl:attribute name="cellstyle" namespace="http://ns.adobe.com/AdobeInDesign/5.0/" select="'body'"/>
                    <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="td[@content-type='TableSubHead']" mode="#all">
          <xsl:element name="Cell">
               <xsl:attribute name="table" namespace="http://ns.adobe.com/AdobeInDesign/4.0/">
                    <xsl:text>cell</xsl:text>
               </xsl:attribute>
               <xsl:attribute name="crows" namespace="http://ns.adobe.com/AdobeInDesign/4.0/" select="@rowspan"/>
               <xsl:attribute name="ccols" namespace="http://ns.adobe.com/AdobeInDesign/4.0/" select="@colspan"/>
               <xsl:attribute name="cellstyle" namespace="http://ns.adobe.com/AdobeInDesign/5.0/" select="'subhead'"/>
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     <xsl:template match="bold[ancestor::td[@content-type='TableSubHead']]" mode="#all">
               <xsl:apply-templates/>
     </xsl:template>
     
</xsl:stylesheet>

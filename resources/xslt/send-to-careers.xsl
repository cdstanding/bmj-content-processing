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
     
     <xsl:template match="article/@xsi:noNamespaceSchemaLocation"/>
     
     <xsl:template match="/">
          <xsl:apply-templates/>
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
     
     
     <xsl:template match="//graphic">
         <xsl:element name="graphic">
            <xsl:attribute name="xlink:href">
                <xsl:text>../../graphics/</xsl:text><xsl:value-of select="./@xlink:href"/><xsl:text>.jpg</xsl:text>
            </xsl:attribute>
         </xsl:element>
         <xsl:apply-templates/>
     </xsl:template>
     
     <!--Suppress Pull Quote output-->
     <xsl:template match="//disp-quote[@content-type='style3']" mode="#all"/>
     
     <!--remove comments and processing instructions in the file-->
     <xsl:template match="comment()|processing-instruction()" mode="#all"/>
     
</xsl:stylesheet>
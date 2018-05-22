<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0"
    exclude-result-prefixes="xsi xlink">
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:param name="art-doi"/>
    <xsl:param name="art-id"/>
    <xsl:param name="article-title"/>
    <xsl:param name="art-section"/>
    <xsl:param name="elocator"/>
    <xsl:param name="first-author-given-name"/>
    <xsl:param name="first-author-surname"/>
    <xsl:param name="graphics"/>
    <xsl:param name="journal-nlm"/>
    <xsl:param name="qa-report-path"/>
    <xsl:param name="series-title"/>
    <xsl:param name="source-filename"/>
    <xsl:param name="source-filename-no-ext"/>
    <xsl:param name="supps"/>
    <xsl:param name="time-now"/>
    <xsl:param name="valid"/>
    <xsl:param name="volume"/>
    <xsl:param name="warning"/>
    
    <xsl:variable name="qa-doc" select="doc(concat('file:///',$qa-report-path))"/>
    
    <xsl:template match="/">
        <item tstamp="{$time-now}">
            <meta name="journal">
                <xsl:if test="$journal-nlm != '${journal-nlm}'">
                    <xsl:value-of select="$journal-nlm"/>
                </xsl:if>
            </meta>
            <meta name="pub-id">
                <xsl:if test="$source-filename-no-ext != '${art-id}'">
                    <xsl:value-of select="$source-filename-no-ext"/>
                </xsl:if>
            </meta>
            <meta name="file">
                <xsl:if test="$elocator != '${elocator}'">
                    <xsl:value-of select="concat('bmj.',$elocator)"/>
                </xsl:if>
            </meta>
            <meta report="{concat('../qa_reports/',$source-filename-no-ext,'-QA-report.html')}" name="status">
                <xsl:choose>
                    <!-- If the property 'valid' is set to false then this means the xml is badly formed and the process will have skipped straight to QA Reporting -->
                    <xsl:when test="$valid = 'false'">
                        <xsl:text>eXtyles XML Broken</xsl:text>
                    </xsl:when>
                    <xsl:when test="$warning = 'true'">
                        <xsl:text>eXtyles XML Warning</xsl:text>
                    </xsl:when>
                    <xsl:when test="$valid != 'false'">
                        <xsl:choose>
                            <xsl:when test="$qa-doc//@class='fail'">
                                <xsl:text>QA Fail</xsl:text>
                            </xsl:when>
                            <xsl:when test="$qa-doc//@class='warn'">
                                <xsl:text>QA Warning</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>QA Pass</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </meta>
            <meta name="section">
                <xsl:if test="$art-section != '${art-section}'">
                    <xsl:value-of select="$art-section"/>
                </xsl:if>
                <xsl:if test="$art-section = '${art-section}'">
                    <xsl:text>No section found</xsl:text>
                </xsl:if>
            </meta>
            <meta name="series">
                <xsl:if test="$series-title != '${series-title}'">
                    <xsl:value-of select="$series-title"/>
                </xsl:if>
            </meta>
            <meta name="title">
                <xsl:if test="$article-title != '${article-title}'">
                    <xsl:value-of select="$article-title"/>
                </xsl:if>
            </meta>
            <meta name="first-auth">
                <xsl:if test="$first-author-given-name != '${first-author-given-name}'">
                    <xsl:value-of select="$first-author-given-name"/>
                </xsl:if>
                <xsl:if test="$first-author-surname != '${first-author-surname}'">
                    <xsl:text>&#x0020;</xsl:text>
                    <xsl:value-of select="$first-author-surname"/>
                </xsl:if>
            </meta>
            <meta name="graphics">
                <xsl:if test="$graphics != '${graphics-xml-sorted}'">
                    <xsl:value-of select="$graphics"/>
                </xsl:if>
            </meta>
            <meta name="data-supps">
                <xsl:if test="$supps != '${supp-files-xml-sorted}'">
                    <xsl:value-of select="$supps"/>
                </xsl:if>
            </meta>
        </item>
    </xsl:template>
    
</xsl:stylesheet>

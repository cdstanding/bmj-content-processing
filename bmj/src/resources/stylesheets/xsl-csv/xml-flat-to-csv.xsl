<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    version="2.0">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

    <xsl:strip-space elements="*" />

    <xsl:param name="delim">
        <xsl:text disable-output-escaping="yes">,</xsl:text>
    </xsl:param>
    <xsl:param name="quote">
        <xsl:text disable-output-escaping="yes">&quot;</xsl:text>
    </xsl:param>
    <xsl:param name="break">
        <xsl:text disable-output-escaping="yes">&#10;</xsl:text>
    </xsl:param>

    <xsl:template match="/">
        <xsl:apply-templates select="/*" mode="worksheet" />
    </xsl:template>

    <xsl:template match="*" mode="worksheet">
        <xsl:apply-templates mode="row" />
    </xsl:template>

    <xsl:template match="*" mode="row">
        <xsl:param name="position">
            <xsl:variable name="generate-id" select="generate-id()" />
            <xsl:for-each select="parent::*/element()">
                <xsl:if test="generate-id()=$generate-id">
                    <xsl:value-of select="position()" />
                </xsl:if>
            </xsl:for-each>
        </xsl:param>

        <xsl:if test="$position=1">

            <xsl:for-each select="*">
                <xsl:variable name="position">
                    <xsl:variable name="generate-id" select="generate-id()" />
                    <xsl:for-each select="parent::*/element()">
                        <xsl:if test="generate-id()=$generate-id">
                            <xsl:value-of select="position()" />
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>

                <xsl:copy-of select="$quote" />
                <xsl:value-of select="name()" />
                <xsl:copy-of select="$quote" />

                <xsl:if test="$position!=last()">
                    <xsl:copy-of select="$delim" />
                </xsl:if>

            </xsl:for-each>

            <xsl:copy-of select="$break" />

        </xsl:if>

        <xsl:apply-templates select="*" mode="cell" />

        <xsl:if test="$position!=last()">
            <xsl:copy-of select="$break" />
        </xsl:if>

    </xsl:template>

    <xsl:template match="*" mode="cell" xml:space="default">
        <xsl:param name="position">
            <xsl:variable name="generate-id" select="generate-id()" />
            <xsl:for-each select="parent::*/element()">
                <xsl:if test="generate-id()=$generate-id">
                    <xsl:value-of select="position()" />
                </xsl:if>
            </xsl:for-each>
        </xsl:param>

        <xsl:copy-of select="$quote" />
        <xsl:apply-templates xml:space="default" />
        <xsl:copy-of select="$quote" />

        <xsl:if test="$position!=last()">
            <xsl:copy-of select="$delim" />
        </xsl:if>

    </xsl:template>

    <xsl:template match="processing-instruction()[name()='break']" xml:space="default" />

    <xsl:template match="text()" xml:space="default">
        <xsl:value-of select="normalize-space(self::text())" xml:space="default" />
    </xsl:template>

    <xsl:template match="span" xml:space="default">
        <xsl:element name="span" xml:space="default">
            <xsl:attribute name="class" select="@class" />
            <xsl:apply-templates xml:space="default" />
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>

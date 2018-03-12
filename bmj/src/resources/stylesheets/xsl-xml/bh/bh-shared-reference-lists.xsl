<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
    version="1.1">
    
    <!-- THIS STYLESHEET DOCUMENT IS SHARED WITH OTHER PROJECTS -->
    <xsl:key name="reference-link-keys" match="xref[@ref-type='bibr']" use="@rid"/><!--[not(ancestor::notes)]-->
    
    <xsl:template name="process-nlm-reference-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//xref[@ref-type='bibr'])[$link-index]/@rid"/>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//xref[@ref-type='bibr'])[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('reference-link-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //xref[@ref-type='bibr' and @rid=$link-target]">
                    <xsl:variable name="filename">
                        <!--<xsl:text>file://localhost</xsl:text>-->
                        <!--<xsl:text>/</xsl:text>-->
                        <!--<xsl:value-of select="substring-before(translate($resourse-export-path,'\','/'), '/monograph-type')"/>
                            <xsl:value-of select="substring-after($link-target, '../')"/>-->
                        <xsl:value-of select="translate($resourse-export-path,'\','/')"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="$link-target"/>
                    </xsl:variable>
                    <xsl:element name="reference">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$item-count"/>
                        </xsl:attribute>
                        <xsl:copy-of select="document($filename)//reference/@*[name()!='xsi:noNamespaceSchemaLocation']"/>
                        <xsl:processing-instruction name="filename">
                            <xsl:value-of select="$filename"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="target">
                            <xsl:value-of select="$link-target"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="position">
                            <xsl:value-of select="$item-count"/>
                        </xsl:processing-instruction>
                        <xsl:copy-of select="document($filename)//reference/node()"/>    
                    </xsl:element>
                    <xsl:call-template name="process-nlm-reference-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-nlm-reference-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>

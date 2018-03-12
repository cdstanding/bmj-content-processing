<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
    version="1.1">
    
    <!-- THIS STYLESHEET DOCUMENT IS SHARED WITH OTHER PROJECTS -->
    
    <xsl:key name="reference-link-keys" match="reference-link" use="@target"/><!--[not(ancestor::notes)]-->
    <xsl:key name="article-reference-link-keys" match="reference-link[@type='article']" use="@target"/>
    <xsl:key name="online-reference-link-keys" match="reference-link[@type='online']" use="@target"/>
    <xsl:key name="evidence-score-link-keys" match="evidence-score-link" use="@target"/>
    <xsl:key name="figure-link-keys" match="figure-link" use="@target"/>
    
    <xsl:key name="table-link-keys" match="table-link" use="@target"/><!-- added for ce -->
    <xsl:key name="gloss-link-keys" match="gloss-link" use="@target"/><!-- added for ce -->
    <xsl:key name="gloss-xref-keys" match="xref[@ref-type='gloss']" use="@rid"/><!-- added for bh -->
    <xsl:key name="table-xref-keys" match="xref[@ref-type='table']" use="@rid"/><!-- added for bh -->
    <xsl:key name="figure-xref-keys" match="xref[@ref-type='fig']" use="@rid"/><!-- added for bh -->
    
    <xsl:template name="process-reference-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//reference-link)[$link-index]/@target"/>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//reference-link)[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('reference-link-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //reference-link[@target=$link-target]">
                    <xsl:variable name="filename">
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
                    <xsl:call-template name="process-reference-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-reference-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="process-article-reference-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//reference-link[@type='article'])[$link-index]/@target"/>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//reference-link[@type='article'])[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('article-reference-link-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //reference-link[@target=$link-target]">
                    <xsl:variable name="filename">
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
                        <xsl:copy-of select="document($filename)/reference/node()"/>    
                    </xsl:element>
                    <xsl:call-template name="process-article-reference-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-article-reference-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="process-online-reference-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//reference-link[@type='online'])[$link-index]/@target"/>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//reference-link[@type='online'])[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('online-reference-link-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //reference-link[@target=$link-target]">
                    <xsl:variable name="filename">
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
                    <xsl:call-template name="process-online-reference-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-online-reference-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="process-evidence-score-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//evidence-score-link)[$link-index]/@target"/>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//evidence-score-link)[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('evidence-score-link-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //evidence-score-link[@target=$link-target]">
                    <xsl:variable name="filename">
                        <xsl:value-of select="translate($resourse-export-path,'\','/')"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="$link-target"/>
                    </xsl:variable>
                    <xsl:element name="evidence-score">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$item-count"/>
                        </xsl:attribute>
                        <xsl:copy-of select="document($filename)//evidence-score/@*[name()!='xsi:noNamespaceSchemaLocation']"/>
                        <xsl:processing-instruction name="filename">
                            <xsl:value-of select="$filename"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="target">
                            <xsl:value-of select="$link-target"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="position">
                            <xsl:value-of select="$item-count"/>
                        </xsl:processing-instruction>
                        <xsl:copy-of select="document($filename)//evidence-score/node()"/>    
                    </xsl:element>
                    <xsl:call-template name="process-evidence-score-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-evidence-score-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="process-figure-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//figure-link)[$link-index]/@target"/>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//figure-link)[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('figure-link-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //figure-link[@target=$link-target]">
                    <xsl:variable name="filename">
                        <xsl:value-of select="translate($resourse-export-path,'\','/')"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="$link-target"/>
                    </xsl:variable>
                    <xsl:element name="figure">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$item-count"/>
                        </xsl:attribute>
                        <xsl:copy-of select="document($filename)//figure/@*[name()!='xsi:noNamespaceSchemaLocation']"/>
                        <xsl:processing-instruction name="filename">
                            <xsl:value-of select="$filename"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="target">
                            <xsl:value-of select="$link-target"/>
                        </xsl:processing-instruction> 
                        <xsl:processing-instruction name="position">
                            <xsl:value-of select="$item-count"/>
                        </xsl:processing-instruction>
                        <!-- export thumbnail image if found in respositiory -->
                        <xsl:variable name="image-name" select="substring-after(document($filename)//figure/image-link/@target, 'images/')"/>
                        <xsl:variable name="image-path" select="concat(substring-before($resourse-export-path, 'monograph-plan'), 'monograph-images')"/>
                        <xsl:if test="$server!='offline'">
                            <xsl:processing-instruction name="thumb">
                                <xsl:value-of select="legacytag:copyOverThumbImages($image-path ,$image-name)"/>
                            </xsl:processing-instruction>
                        </xsl:if>
                        <xsl:copy-of select="document($filename)//figure/node()"/>
                    </xsl:element>
                    <xsl:call-template name="process-figure-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-figure-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="process-table-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//table-link)[$link-index]/@target"/>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//table-link)[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('table-link-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //table-link[@target=$link-target]">
                    <xsl:variable name="filename">
                        <xsl:value-of select="translate($resourse-export-path,'\','/')"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="$link-target"/>
                    </xsl:variable>
                    <xsl:element name="table">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$item-count"/>
                        </xsl:attribute>
                        <xsl:copy-of select="document($filename)//table/@*[name()!='xsi:noNamespaceSchemaLocation']"/>
                        <xsl:processing-instruction name="filename">
                            <xsl:value-of select="$filename"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="target">
                            <xsl:value-of select="$link-target"/>
                        </xsl:processing-instruction> 
                        <xsl:processing-instruction name="position">
                            <xsl:value-of select="$item-count"/>
                        </xsl:processing-instruction>
                        <xsl:copy-of select="document($filename)//table/node()"/>
                    </xsl:element>
                    <xsl:call-template name="process-table-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-table-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="process-gloss-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//gloss-link)[$link-index]/@target"/>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//gloss-link)[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('gloss-link-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //gloss-link[@target=$link-target]">
                    <xsl:variable name="filename">
                        <xsl:value-of select="translate($resourse-export-path,'\','/')"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="$link-target"/>
                    </xsl:variable>
                    <xsl:element name="gloss">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$item-count"/>
                        </xsl:attribute>
                        <xsl:copy-of select="document($filename)//gloss/@*[name()!='xsi:noNamespaceSchemaLocation']"/>
                        <xsl:processing-instruction name="filename">
                            <xsl:value-of select="$filename"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="target">
                            <xsl:value-of select="$link-target"/>
                        </xsl:processing-instruction> 
                        <xsl:processing-instruction name="position">
                            <xsl:value-of select="$item-count"/>
                        </xsl:processing-instruction>
                        <xsl:copy-of select="document($filename)//gloss/node()"/>
                    </xsl:element>
                    <xsl:call-template name="process-gloss-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-gloss-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="process-gloss-xref-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//xref[@ref-type='gloss'])[$link-index]/@rid"/>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//xref[@ref-type='gloss'])[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('gloss-xref-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //xref[@rid=$link-target]">
                    <xsl:variable name="filename">
                        <xsl:value-of select="translate($resourse-export-path,'\','/')"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="$link-target"/>
                    </xsl:variable>
                    <xsl:element name="gloss">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$item-count"/>
                        </xsl:attribute>
                        <xsl:copy-of select="document($filename)//gloss/@*[name()!='xsi:noNamespaceSchemaLocation']"/>
                        <xsl:processing-instruction name="filename">
                            <xsl:value-of select="$filename"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="target">
                            <xsl:value-of select="$link-target"/>
                        </xsl:processing-instruction> 
                        <xsl:processing-instruction name="position">
                            <xsl:value-of select="$item-count"/>
                        </xsl:processing-instruction>
                        <xsl:copy-of select="document($filename)//gloss/node()"/>
                    </xsl:element>
                    <xsl:call-template name="process-gloss-xref-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-gloss-xref-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="process-table-xref-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//xref[@ref-type='table'])[$link-index]/@rid"/>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//xref[@ref-type='table'])[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('table-xref-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //xref[@rid=$link-target]">
                    <xsl:variable name="filename">
                        <xsl:value-of select="translate($resourse-export-path,'\','/')"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="$link-target"/>
                    </xsl:variable>
                    <xsl:element name="table">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$item-count"/>
                        </xsl:attribute>
                        <xsl:copy-of select="document($filename)//table/@*[name()!='xsi:noNamespaceSchemaLocation']"/>
                        <xsl:processing-instruction name="filename">
                            <xsl:value-of select="$filename"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="target">
                            <xsl:value-of select="$link-target"/>
                        </xsl:processing-instruction> 
                        <xsl:processing-instruction name="position">
                            <xsl:value-of select="$item-count"/>
                        </xsl:processing-instruction>
                        <xsl:copy-of select="document($filename)//table/node()"/>
                    </xsl:element>
                    <xsl:call-template name="process-table-xref-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-table-xref-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="process-figure-xref-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//xref[@ref-type='fig'])[$link-index]/@rid"/>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//xref[@ref-type='fig'])[$link-index])"/>
                <xsl:variable name="key-id" select="generate-id(key('figure-xref-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //xref[@rid=$link-target]">
                    <xsl:variable name="filename">
                        <xsl:value-of select="translate($resourse-export-path,'\','/')"/>
                        <xsl:value-of select="$link-target"/>
                    </xsl:variable>
                    <xsl:element name="figure">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$item-count"/>
                        </xsl:attribute>
                        <xsl:copy-of select="document($filename)//figure/@*[name()!='xsi:noNamespaceSchemaLocation']"/>
                        <xsl:processing-instruction name="filename">
                            <xsl:value-of select="$filename"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="target">
                            <xsl:value-of select="$link-target"/>
                        </xsl:processing-instruction> 
                        <xsl:processing-instruction name="position">
                            <xsl:value-of select="$item-count"/>
                        </xsl:processing-instruction>
                        <xsl:copy-of select="document($filename)//figure/node()"/>
                    </xsl:element>
                    <xsl:call-template name="process-figure-xref-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-figure-xref-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>

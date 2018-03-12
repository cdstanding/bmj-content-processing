<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="1.1">

    <xsl:template name="process-level-1-section-with-heading">
        <xsl:variable name="name" select="name()" />
        <xsl:element name="block" use-attribute-sets="margin">
            <xsl:element name="section" use-attribute-sets="section">
                <!--<xsl:attribute name="class">
                    <xsl:value-of select="$name" />
                </xsl:attribute>-->
                <xsl:element name="heading" use-attribute-sets="heading-1">
                    <xsl:value-of select="$strings//str[@name=$name]/friendly" />
                </xsl:element>
                <xsl:if
                    test="$strings//str[@name=$name]/instruction[string-length(normalize-space(.))!=0] and position()=1">
                    <xsl:element name="par" use-attribute-sets="instruction">
                        <xsl:value-of select="$strings//str[@name=$name]/instruction" />
                    </xsl:element>
                </xsl:if>
                <xsl:apply-templates />
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="process-level-2-section-with-heading">
        <xsl:variable name="name" select="name()" />
        <xsl:variable name="parent-name" select="name(parent::*)" />
        <xsl:element name="block" use-attribute-sets="margin">
            <xsl:element name="section" use-attribute-sets="section">
                <!--<xsl:attribute name="class">
                    <xsl:value-of select="$name" />
                </xsl:attribute>-->
                <xsl:element name="heading" use-attribute-sets="heading-2">
                    <!-- we concat the level-1 section name to our level-2 headings -->
                    <xsl:if test="$parent-name">
                        <xsl:value-of select="$strings//str[@name=$parent-name]/friendly" />
                        <xsl:text>: </xsl:text>
                    </xsl:if>
                    <!-- these two fields are shared in both diagnosis and treatment sections so we want to concat more relevant heading name -->
                    <xsl:if test="$name = 'approach' or $name = 'guidelines'">
                        <xsl:value-of select="$strings//str[@name=$parent-name]/friendly" />
                        <xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="$strings//str[@name=$name]/friendly" />
                </xsl:element>
                <xsl:if
                    test="$strings//str[@name=$name]/instruction[string-length(normalize-space(.))!=0] and position()=1">
                    <xsl:element name="par" use-attribute-sets="instruction">
                        <xsl:value-of select="$strings//str[@name=$name]/instruction" />
                    </xsl:element>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$parent-name = 'references'">
                        <xsl:element name="list" use-attribute-sets="list-1">
                            <xsl:apply-templates />
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="process-level-2-section-with-heading-and-with-implied-list-content">
        <xsl:variable name="name" select="name()" />
        <xsl:element name="block" use-attribute-sets="margin">
            <xsl:element name="section" use-attribute-sets="section">
                <!--<xsl:attribute name="class">
                    <xsl:value-of select="$name" />
                </xsl:attribute>-->
                <xsl:element name="heading" use-attribute-sets="heading-2">
                    <xsl:value-of select="$strings//str[@name=$name]/friendly" />
                </xsl:element>
                <xsl:if
                    test="$strings//str[@name=$name]/instruction[string-length(normalize-space(.))!=0] and position()=1">
                    <xsl:element name="par" use-attribute-sets="instruction">
                        <xsl:value-of select="$strings//str[@name=$name]/instruction" />
                    </xsl:element>
                </xsl:if>
                <xsl:element name="list" use-attribute-sets="list-bullet">
                    <xsl:for-each select="element()">
                        <xsl:element name="item" use-attribute-sets="">
                            <xsl:element name="par" use-attribute-sets="normal">
                                <xsl:apply-templates />
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="process-level-3-section-with-heading">
        <xsl:variable name="name" select="name()" />
        <xsl:element name="block" use-attribute-sets="margin">
            <xsl:element name="section" use-attribute-sets="section">
                <!--<xsl:attribute name="class">
                    <xsl:value-of select="$name" />
                </xsl:attribute>-->
                <xsl:element name="heading" use-attribute-sets="heading-3">
                    <xsl:value-of select="$strings//str[@name=$name]/friendly" />
                    <xsl:if test="$name = 'vignette'">
                        <xsl:text> #</xsl:text>
                        <xsl:variable name="position-id" select="generate-id()"/>
                        <xsl:for-each select="parent::*/*">
                            <xsl:if test="generate-id()=$position-id">
                                <xsl:value-of select="position()" />
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:element>
                <xsl:if
                    test="$strings//str[@name=$name]/instruction[string-length(normalize-space(.))!=0] and position()=1">
                    <xsl:element name="par" use-attribute-sets="instruction">
                        <xsl:value-of select="$strings//str[@name=$name]/instruction" />
                    </xsl:element>
                </xsl:if>
                <xsl:apply-templates />
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="process-level-3-section-without-heading">
        <xsl:variable name="name" select="name()" />
        <xsl:element name="block" use-attribute-sets="margin">
            <xsl:element name="section" use-attribute-sets="section">
                <!--<xsl:attribute name="class">
                    <xsl:value-of select="$name" />
                </xsl:attribute>-->

                <!-- header types -->
                <xsl:apply-templates select="title" />
                <xsl:apply-templates select="factor-name" />
                <xsl:apply-templates select="name" />
                <xsl:apply-templates select="result" />

                <!-- prompt types : para -->
                <xsl:apply-templates select="monograph-link" />

                <!-- prompt types : inline -->
                <!-- TODO test to avoid empty <par/> -->
                <!-- TODO control prmpt-seperator -->
                <xsl:element name="par" use-attribute-sets="normal">
                    <xsl:apply-templates select="@frequency" />
                    <xsl:apply-templates select="@key-factor" />
                    <xsl:apply-templates select="@strength" />
                    <xsl:apply-templates select="@likelihood" />
                    <xsl:apply-templates select="@timeframe" />
                    <xsl:apply-templates select="@type" />
                    <xsl:apply-templates select="@order" />
                </xsl:element>

                <!-- body types -->
                <xsl:apply-templates select="sign-symptoms" />
                <xsl:apply-templates select="tests" />
                <xsl:apply-templates select="detail" />

                <xsl:for-each select="node()|@*">
                    <xsl:comment select="name()" />
                </xsl:for-each>

            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- TODO verify why we needed to do this -->
    <xsl:template name="process-level-3-heading-only">
        <!--<xsl:element name="block" use-attribute-sets="margin">
            <xsl:element name="section" use-attribute-sets="section">-->
        <xsl:element name="heading" use-attribute-sets="heading-3">
            <xsl:apply-templates />
        </xsl:element>
        <!--</xsl:element>
            </xsl:element>-->
    </xsl:template>

    <xsl:template name="process-level-4-section-with-heading-and-with-para-and-list-content">
        <xsl:variable name="name" select="name()" />
        <xsl:element name="block" use-attribute-sets="margin">
            <xsl:element name="section" use-attribute-sets="section">
                <!--<xsl:attribute name="class">
                    <xsl:value-of select="$name" />
                </xsl:attribute>-->
                <xsl:element name="heading" use-attribute-sets="heading-4">
                    <xsl:value-of select="$strings//str[@name=$name]/friendly" />
                </xsl:element>
                <xsl:if
                    test="$strings//str[@name=$name]/instruction[string-length(normalize-space(.))!=0] and position()=1">
                    <xsl:element name="par" use-attribute-sets="instruction">
                        <xsl:value-of select="$strings//str[@name=$name]/instruction" />
                    </xsl:element>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="para | list">
                        <xsl:apply-templates />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="par" use-attribute-sets="normal">
                            <xsl:apply-templates />
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="process-level-4-section-without-heading-and-with-para-and-list-content">
        <xsl:variable name="name" select="name()" />
        <xsl:element name="block" use-attribute-sets="margin">
            <xsl:element name="section" use-attribute-sets="section">
                <!--<xsl:attribute name="class">
                    <xsl:value-of select="$name" />
                </xsl:attribute>-->
                <xsl:choose>
                    <xsl:when test="para | list">
                        <xsl:apply-templates />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="par" use-attribute-sets="normal">
                            <xsl:apply-templates />
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>

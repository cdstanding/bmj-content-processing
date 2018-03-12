<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"   
    version="2.0">
    
    <xsl:param name="path"/>
    <xsl:param name="outputpath"/>
    <xsl:param name="inputpath"/>
    <xsl:param name="published-date"/>
    <xsl:param name="amended-date"/>
    <xsl:param name="last-update"/>
    <xsl:param name="last-reviewed"/>
    
    <xsl:param name="date-amended-iso"/>
    <xsl:param name="date-updated-iso"/>
    <xsl:param name="last-reviewed-iso"/>
    <xsl:param name="todays-date-iso"/>
    
    <xsl:param name="topresourcename"/>
    <xsl:param name="metapath"/>
    <xsl:param name="rootdocdir"/>
    
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:output method="xml" indent="yes" name="xmlOutput" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="metadoc" select="document(translate(concat($metapath, $rootdocdir , $topresourcename),'\','/'))"></xsl:variable>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="article">
        <xsl:element name="treatment-ratings">
            <xsl:attribute name="xsi:noNamespaceSchemaLocation"><xsl:text>http://schema.bmj.com/delivery/ash/bmjk-rating-table.xsd</xsl:text></xsl:attribute>
            <xsl:attribute name="condition-id"><xsl:value-of select="@id"/></xsl:attribute>
            <xsl:attribute name="version"><xsl:value-of select="@version"/></xsl:attribute>
    
            <!-- add dates etc -->
            <xsl:element name="amended-date"><xsl:value-of select="$amended-date"/></xsl:element>
            <xsl:element name="amended-date-iso"><xsl:value-of select="$date-amended-iso"/></xsl:element>
            <xsl:element name="last-updated"><xsl:value-of select="$last-update"/></xsl:element>
            <xsl:element name="last-updated-iso"><xsl:value-of select="$date-updated-iso"/></xsl:element>
            <xsl:element name="export-date"><xsl:value-of select="$published-date"/></xsl:element>
            <xsl:element name="export-date-iso"><xsl:value-of select="$todays-date-iso"/></xsl:element>
            <xsl:element name="last-reviewed"><xsl:value-of select="$last-reviewed"/></xsl:element>
            <xsl:element name="last-reviewed-iso"><xsl:value-of select="$last-reviewed-iso"/></xsl:element>
            
            <!-- loop each group and create set -->
            <xsl:for-each select="//group">

                <xsl:element name="treatment-ratings-set">
                    <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
                    <xsl:attribute name="heading"><xsl:value-of select="./treatments/sec[1]/title[1]"/></xsl:attribute>
                    
                    <!-- process each xinclude -->
                    <xsl:for-each select="./treatments/xi:include">
                    
                        <!-- load file -->
                        <xsl:variable name="name"><xsl:value-of select="replace(@href, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.$3')"/></xsl:variable>
                        <xsl:variable name="includepath">file://localhost/<xsl:value-of select="translate($inputpath,'\','/')"/>/<xsl:value-of select="$name"/></xsl:variable>
                        <xsl:variable name="treatmentfile" select="document($includepath)"/>
                        <xsl:variable name="metadoc" select="document(translate(concat($metapath, replace(@href,'\.\./','/')),'\','/'))"></xsl:variable>
                            
                        <xsl:element name="treatment-rating">
                            <xsl:attribute name="id"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/patient-treatment/', replace($name, '.xml', '')))"/></xsl:attribute>
                            <xsl:attribute name="version"><xsl:value-of select="$metadoc//version"/></xsl:attribute>
                            
                            <!-- get value of the rating score and id -->
                            <xsl:variable name="rate-score-value"><xsl:value-of select="$treatmentfile//custom-meta/meta-name[. = 'rating-score']/following-sibling::meta-value"/></xsl:variable>
                            
                            <xsl:choose>
                                <xsl:when test="$rate-score-value = 'treatments-that-work'">
                                    <xsl:attribute name="rating-score">1</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$rate-score-value = 'treatments-that-are-likely-to-work'">
                                    <xsl:attribute name="rating-score">2</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$rate-score-value = 'treatments-that-work-but-whose-harms-may-outweigh-benefits'">
                                    <xsl:attribute name="rating-score">3</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$rate-score-value = 'treatments-that-need-further-study'">
                                    <xsl:attribute name="rating-score">4</xsl:attribute>                                
                                </xsl:when>
                                <xsl:when test="$rate-score-value = 'treatments-that-are-unlikely-to-work'">
                                    <xsl:attribute name="rating-score">5</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$rate-score-value = 'treatments-that-are-likely-to-be-ineffective-or-harmful'">
                                    <xsl:attribute name="rating-score">6</xsl:attribute>                                    
                                </xsl:when>
                                <xsl:when test="$rate-score-value = 'other-treatments'">
                                    <xsl:attribute name="rating-score">7</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$rate-score-value = 'usual-treatments'">
                                    <xsl:attribute name="rating-score">8</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$rate-score-value = ''">
                                    <xsl:attribute name="rating-score"></xsl:attribute>
                                </xsl:when>
                            </xsl:choose>
                            
                            <xsl:attribute name="treatment-name"><xsl:value-of select="$treatmentfile//article-title"/></xsl:attribute>
                            
                            <xsl:attribute name="treatment-rating-type">
                                <xsl:choose>
                                    <xsl:when test="$rate-score-value = 'usual-treatments'">
                                        <xsl:value-of>usual</xsl:value-of>
                                    </xsl:when>
                                    <xsl:when test="$rate-score-value = 'other-treatments'">
                                        <xsl:value-of>other</xsl:value-of>
                                    </xsl:when>
                                    <xsl:when test="$rate-score-value = 'treatments-that-need-further-study'">
                                        <xsl:value-of>needs further study</xsl:value-of>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of>rated</xsl:value-of>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            
                            <xsl:element name="treatment-examples">
                                <xsl:for-each select="$treatmentfile//treatment-example">
                                    <xsl:element name="treatment-example"><xsl:value-of select="."/></xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                            
                            <xsl:element name="treatment-forms">
                                <xsl:for-each select="$treatmentfile//custom-meta/meta-name[. = 'treatment-form']/following-sibling::meta-value">
                                    <xsl:element name="treatment-form"><xsl:value-of select="."/></xsl:element>
                                </xsl:for-each>
                            </xsl:element>
    						
    						<xsl:element name="description">
	                            <xsl:apply-templates select="$treatmentfile//front/treatment-rating/description/sec"/>
                            </xsl:element>
                            
    						<xsl:element name="effect">                            
	                            <xsl:apply-templates select="$treatmentfile//front/treatment-rating/effect/sec"/>
                            </xsl:element>

                            <xsl:element name="research">
                                <xsl:attribute name="evidence-score"><xsl:value-of select="$treatmentfile//custom-meta/meta-name[. = 'grade-score']/following-sibling::meta-value"/></xsl:attribute>
                                <xsl:apply-templates select="$treatmentfile//front/treatment-rating/research/sec"/>
                            </xsl:element>

                            <xsl:element name="harms">
                                <xsl:for-each select="$treatmentfile//harm">
                                    <xsl:element name="harm"><xsl:value-of select="."/></xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                    
                        </xsl:element>
                    </xsl:for-each>

                </xsl:element>
            </xsl:for-each>
        </xsl:element>

    </xsl:template>
    
    
    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>    
    
</xsl:stylesheet>

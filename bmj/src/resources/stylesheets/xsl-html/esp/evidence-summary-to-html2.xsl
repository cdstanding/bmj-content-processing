<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"   
    exclude-result-prefixes="legacytag"
    version="2.0">
   
    <xsl:output 
        method="xml" 
        encoding="UTF-8"
        indent="yes" 
        />
    
    <xsl:param name="pub-stream"/>
    <xsl:param name="ukdir"/>
    <xsl:param name="usdir"/>
    
    <xsl:variable name="ceweb"><xsl:value-of>http://clinicalevidence.bmj.com/ceweb/conditions/abc/</xsl:value-of></xsl:variable>
    <xsl:variable name="ukmonoweb"><xsl:value-of>http://bestpractice.bmj.com/best-practice/monograph/</xsl:value-of></xsl:variable>
    <xsl:variable name="usmonoweb"><xsl:value-of>http://bestpracticedx.bmj.com/best-practice-dx/monograph/</xsl:value-of></xsl:variable>
    
    <xsl:strip-space elements="*"/>
    
   
    <xsl:template match="summary-info">

        <xsl:element name="summary-info">

            <!-- put a list of related bh summ links into summary info section -->
            <xsl:element name="summ-links">
                <xsl:for-each-group select="//es-internal-link[@xpointer='patient-summary/topic-info']" group-by="@target">
                    <xsl:variable name="datarget"><xsl:value-of select="current-grouping-key()"/></xsl:variable>
                    <xsl:variable name="summaryname"><xsl:value-of select="replace($datarget, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>
                    <xsl:variable name="abstractid"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/patient-summary/', replace($summaryname, '.xml', '')))"/></xsl:variable> 
                    <xsl:element name="sumlink">
                        <xsl:attribute name="target"><xsl:value-of select="$datarget"/></xsl:attribute>
                        <xsl:attribute name="id"><xsl:value-of select="$abstractid"/></xsl:attribute>
                    </xsl:element>
                </xsl:for-each-group>
            </xsl:element>
            

            <!-- put a list of related ce links into summary info section -->
            <xsl:element name="ce-links">
                <xsl:for-each-group select="//es-internal-link[@xpointer='option/intervention-set']" group-by="@target">
                    
                    <xsl:variable name="datarget"><xsl:value-of select="current-grouping-key()"/></xsl:variable>
                    <xsl:variable name="topicid"><xsl:value-of select="legacytag:getSystematicReviewId($datarget)"/></xsl:variable>
                    <xsl:variable name="topictitle"><xsl:value-of select="legacytag:getSystematicReviewTitle($datarget)"/></xsl:variable>
        
                    <xsl:element name="celink">
                        <xsl:attribute name="target"><xsl:value-of select="$datarget"/></xsl:attribute>
                        <xsl:attribute name="topic-id"><xsl:value-of select="$topicid"/></xsl:attribute>
                        <xsl:attribute name="href"><xsl:value-of select="concat($ceweb,$topicid,'/',$topicid,'.jsp')"/></xsl:attribute>
                        <xsl:value-of select="$topictitle"/>
                    </xsl:element>
                    
                </xsl:for-each-group>
            </xsl:element>
            
            <!-- put a list of related monograph links into summary info section -->
            <xsl:element name="mono-links">
                <xsl:for-each-group select="//es-internal-link[@xpointer!='option/intervention-set' and @xpointer!='patient-summary/topic-info']" group-by="@target">
                    
                    <xsl:variable name="datarget"><xsl:value-of select="current-grouping-key()"/></xsl:variable>
                    
                    <xsl:choose>
                        
                        <xsl:when test="$pub-stream='en-us'">
                            
                            <xsl:variable name="monoid"><xsl:value-of select="legacytag:getMonographId($datarget, 'en-us')"/></xsl:variable>
                            <xsl:variable name="monotitle"><xsl:value-of select="legacytag:getMonographTitle($datarget, 'en-us')"/></xsl:variable>
                            
                            <xsl:element name="monolink">
                                <xsl:attribute name="target"><xsl:value-of select="$datarget"/></xsl:attribute>
                                <xsl:attribute name="monoid"><xsl:value-of select="$monoid"/></xsl:attribute>
                                <xsl:attribute name="href"><xsl:value-of select="concat($usmonoweb,$monoid,'.html')"/></xsl:attribute>
                                <xsl:value-of select="$monotitle"/>
                            </xsl:element>
                            
                        </xsl:when>
                        <xsl:otherwise>
                            
                            <xsl:variable name="monoid"><xsl:value-of select="legacytag:getMonographId($datarget, 'en-gb')"/></xsl:variable>
                            <xsl:variable name="monotitle"><xsl:value-of select="legacytag:getMonographTitle($datarget, 'en-gb')"/></xsl:variable>
                            
                            <xsl:element name="monolink">
                                <xsl:attribute name="target"><xsl:value-of select="$datarget"/></xsl:attribute>
                                <xsl:attribute name="monoid"><xsl:value-of select="$monoid"/></xsl:attribute>
                                <xsl:attribute name="href"><xsl:value-of select="concat($ukmonoweb,$monoid,'.html')"/></xsl:attribute>
                                <xsl:value-of select="$monotitle"/>
                            </xsl:element>
                            
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:for-each-group>
            </xsl:element>
            
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="comment()">
        <xsl:comment select="." />
    </xsl:template>
   
    <xsl:template match="*|@*|text()">
        <xsl:copy>
            <xsl:apply-templates select="*|@*|text()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
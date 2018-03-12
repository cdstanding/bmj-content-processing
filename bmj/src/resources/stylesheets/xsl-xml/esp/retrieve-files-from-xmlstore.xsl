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
    
    <xsl:strip-space elements="*"/>
   
    <xsl:template match="evidence-summary">
        <xsl:element name="evidence-summary">
            <xsl:apply-templates select="//summ-links"/> 
            <xsl:apply-templates select="//ce-links"/> 
            <xsl:apply-templates select="//mono-links"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="summ-links">
        <xsl:choose>
            <xsl:when test="$pub-stream='en-gb'">
                
                <xsl:comment>Related BH Sum links - exporting files from xml store</xsl:comment>
                <xsl:element name="bh-summary-links">
                    <xsl:for-each-group select="sumlink" group-by="@target">
                        <xsl:element name="bh-summary-link">
                            <xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
                            <xsl:attribute name="file-id"><xsl:value-of select="@id"/></xsl:attribute>
                            <xsl:variable name="target-id"><xsl:value-of select="@id"/></xsl:variable>
                            <xsl:variable name="export-message"><xsl:value-of select="legacytag:retrieveBHSummaryFromXMLStore($target-id, $ukdir, $usdir,$pub-stream)"/></xsl:variable>
                            <xsl:value-of select="$export-message"/>
                        </xsl:element>
                    </xsl:for-each-group>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>Related BH Sum links - NOT as US pub stream, bh files already exported under UK pub stream</xsl:comment>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="ce-links">
        
        <xsl:choose>
            <xsl:when test="$pub-stream='en-gb'">
                
                <xsl:comment>Related CE links - exporting files from xml store</xsl:comment>
                
                <xsl:element name="systematic-review-links">
                    <xsl:for-each-group select="celink" group-by="@href">
                        <xsl:element name="systematic-review-link">
                            <xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
                            <xsl:attribute name="file-id"><xsl:value-of select="@topic-id"/></xsl:attribute>
                            <xsl:variable name="id"><xsl:value-of select="@topic-id"/></xsl:variable>
                            <xsl:variable name="export-message"><xsl:value-of select="legacytag:retrieveSystematicReviewFromXMLStore($id, $ukdir, $usdir,$pub-stream)"/></xsl:variable>
                            <xsl:value-of select="$export-message"/>
                        </xsl:element>
                    </xsl:for-each-group>
                </xsl:element>
                
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>Related CE links - NOT as US pub stream, ce files already exported under UK pub stream</xsl:comment>
            </xsl:otherwise>
        </xsl:choose>
        
        
    </xsl:template>
    
    <xsl:template match="mono-links">

        <xsl:comment>Related monograph links - exporting files from xml store</xsl:comment>
        
        <xsl:element name="monograph-links">
            <xsl:for-each-group select="monolink" group-by="@href">
                <xsl:element name="monograph-link">
                    <xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
                    <xsl:attribute name="file-id"><xsl:value-of select="@monoid"/></xsl:attribute>
                    <xsl:variable name="id"><xsl:value-of select="@monoid"/></xsl:variable>
                    <xsl:variable name="export-message"><xsl:value-of select="legacytag:retrieveMonographFromXMLStore($id, $ukdir, $usdir,$pub-stream)"/></xsl:variable>
                    <xsl:value-of select="$export-message"/>
                </xsl:element>
            </xsl:for-each-group>
        </xsl:element>
        
    </xsl:template>
    
    
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="xs"
    version="2.0">
    
    
    <xsl:param name="art-section"/>
    <xsl:param name="journal-nlm"/>
    
    <xsl:template match="/">
        <article>
            <journal>
                <xsl:if test="$journal-nlm[contains(.,'Student')]">
                     <xsl:text>sbmj</xsl:text>
                </xsl:if>
                <xsl:if test="$journal-nlm[not(contains(.,'Student'))]">
                     <xsl:text>bmj</xsl:text>
                </xsl:if>
            </journal>
            <section>
                <xsl:choose>
                    <xsl:when test="$art-section[contains(.,'Editor''s Choice')]">
                        <xsl:text>choice</xsl:text>
                    </xsl:when>
                    <xsl:when test="$art-section[contains(.,'Research Methods &amp; Reporting')]">
                        <xsl:text>research-methods-and-reporting</xsl:text>
                    </xsl:when>
                    <xsl:when test="$art-section[contains(.,'Views and Reviews')]">
                        <xsl:text>views</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace(lower-case($art-section),' ','-')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </section>
        </article>
    </xsl:template>
    
    
</xsl:stylesheet>
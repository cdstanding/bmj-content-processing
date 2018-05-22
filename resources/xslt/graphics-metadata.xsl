<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="xs"
    version="2.0">
    
    
    <xsl:param name="article-id"/>
    <xsl:param name="article-doi"/>
    <xsl:param name="article-doi-tail"/>
    <xsl:param name="article-section"/>
    <xsl:param name="article-type"/>
    <xsl:param name="graphic"/>
    <xsl:param name="graphics-in-xml"/>
    <xsl:param name="graphics-in-folder"/>
    <xsl:param name="journal"/>
    <xsl:param name="journal-nlm"/>
    <xsl:param name="source-file"/>
    <xsl:param name="supp-files-in-folder"/>
    <xsl:param name="supp-files-in-xml"/>
    
    
    <xsl:template match="/">
        <article>
            <art-id><xsl:value-of select="$article-id"/></art-id>
            <art-doi><xsl:value-of select="$article-doi"/></art-doi>
            <art-doi-tail><xsl:value-of select="substring-after($article-doi-tail,'/')"/></art-doi-tail>
            <art-type><xsl:value-of select="$article-type"/></art-type>
            <elps></elps>
            <graphics-in-xml>
                <xsl:analyze-string select="$graphics-in-xml" regex="[^,]+">
                     <xsl:matching-substring>
                             <xsl:for-each select=".">
                                 <graphic><xsl:value-of select="."/></graphic>
                             </xsl:for-each>
                     </xsl:matching-substring>
                </xsl:analyze-string>
            </graphics-in-xml>
            <graphics-in-folder>
                <xsl:analyze-string select="$graphics-in-folder" regex="[^,]+">
                     <xsl:matching-substring>
                             <xsl:for-each select=".[not(contains(.,'${graphics-text}'))][not(contains(.,'${graphic-file-folder}'))]">
                                 <graphic><xsl:value-of select="."/></graphic>
                             </xsl:for-each>
                     </xsl:matching-substring>
                </xsl:analyze-string>
            </graphics-in-folder>
            <supp-files-in-xml>
                <xsl:analyze-string select="$supp-files-in-xml" regex="[^,]+">
                     <xsl:matching-substring>
                             <xsl:for-each select=".">
                                 <supp-file><xsl:value-of select="."/></supp-file>
                             </xsl:for-each>
                     </xsl:matching-substring>
                </xsl:analyze-string>
            </supp-files-in-xml>
            <supp-files-in-folder>
                <xsl:analyze-string select="$supp-files-in-folder" regex="[^,]+">
                     <xsl:matching-substring>
                             <xsl:for-each select=".[not(contains(.,'${supps-text}'))][not(contains(.,'${supp-file-folder}'))]">
                                 <supp-file><xsl:value-of select="."/></supp-file>
                             </xsl:for-each>
                     </xsl:matching-substring>
                </xsl:analyze-string>
            </supp-files-in-folder>
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
                    <xsl:when test="$article-section[contains(.,'Editor''s Choice')]">
                        <xsl:text>choice</xsl:text>
                    </xsl:when>
                    <xsl:when test="$article-section[contains(.,'Research Methods &amp; Reporting')]">
                        <xsl:text>research-methods-and-reporting</xsl:text>
                    </xsl:when>
                    <xsl:when test="$article-section[contains(.,'Views and Reviews')]">
                        <xsl:text>views</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace(lower-case($article-section),' ','-')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </section>
            <section-abbrev></section-abbrev>
        </article>
    </xsl:template>
    
    
</xsl:stylesheet>
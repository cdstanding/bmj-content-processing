<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:param name="abridged-set"/>
    <xsl:param name="art-journal"/>
    <xsl:param name="art-section"/>
    <xsl:param name="doi"/>
    <xsl:param name="eloc"/>
    <xsl:param name="embargo-set"/>
    <xsl:param name="embargo-date"/>
    <xsl:param name="embargo-time"/>
    <xsl:param name="embargo-timezone"/>
    <xsl:param name="graphic"/>
    <xsl:param name="graphic-files-available"/>
    <xsl:param name="pe-id"/>
    <xsl:param name="ppr-set"/>
    <xsl:param name="ppr-vol"/>
    <xsl:param name="supp-file"/>
    <xsl:param name="supp-files-available"/>
    <xsl:param name="volume"/>
    
    <xsl:template match="/">
        <picklist>
            
            <xsl:attribute name="date">
                <xsl:if test="number(day-from-date(current-date())) &lt; 9">
                    <xsl:text>0</xsl:text>
                </xsl:if>
                <xsl:value-of select="number(day-from-date(current-date()))"/>
                <xsl:text>/</xsl:text>
                <xsl:text>0</xsl:text>
                <xsl:value-of select="number(month-from-date(current-date()))"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="number(year-from-date(current-date()))"/>
            </xsl:attribute>
            
            <metadata>
                
                <!-- For Embargo -->
                <xsl:if test="$embargo-set = 'y'">
                    <meta>
                        <xsl:attribute name="name">
                            <xsl:text>embargo.date</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="$embargo-date"/>
                    </meta>
                    
                    <meta>
                        <xsl:attribute name="name">
                            <xsl:text>embargo.time</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="$embargo-time"/>
                    </meta>
                    
                    <meta>
                        <xsl:attribute name="name">
                            <xsl:text>embargo.timezone</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="$embargo-timezone"/>
                    </meta>
                    
                    <meta>
                    <xsl:attribute name="name">
                        <xsl:text>pub.hwx</xsl:text>
                    </xsl:attribute>
                    <xsl:text>true</xsl:text>
                    </meta>
                    
                    <meta>
                        <xsl:attribute name="name">
                            <xsl:text>Volume</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="$volume"/>
                    </meta>
                    
                </xsl:if>
                
                <!-- For Green to Go -->
                <xsl:if test="$embargo-set = 'n'">
                    <meta>
                    <xsl:attribute name="name">
                        <xsl:text>pub.hwx</xsl:text>
                    </xsl:attribute>
                    <xsl:text>true</xsl:text>
                    </meta>
                    
                    <xsl:if test="not($ppr-set = 'true')">
                        <meta>
                            <xsl:attribute name="name">
                                <xsl:text>Volume</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of select="$volume"/>
                        </meta>
                    </xsl:if>
                </xsl:if>
                
                <!-- For Post Production Resend -->
                <xsl:if test="$ppr-set = 'true'">
                    <meta>
                        <xsl:attribute name="name">
                            <xsl:text>Volume</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="$ppr-vol"/>
                    </meta>
                    
                    <meta>
                        <xsl:attribute name="name">
                            <xsl:text>peid</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="$pe-id"/>
                    </meta>
                </xsl:if>
                
                
                <!-- For all scenarios -->
                <meta>
                    <xsl:attribute name="name">
                        <xsl:text>doi-list</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="$doi"/>
                </meta>
                
            </metadata>
            <xsl:if test="$abridged-set != 'true'">
                <item xlink:href="../{$art-journal}/{$art-section}/bmj.{$eloc}.xml"/>
            </xsl:if>
            <xsl:if test="$abridged-set = 'true'">
                <item xlink:href="../abridged/{$art-journal}/{$art-section}/bmj.{$eloc}.xml"/>
            </xsl:if>
        </picklist>
        
        
    </xsl:template>
    
    
</xsl:stylesheet>
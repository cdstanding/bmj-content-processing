<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0"
    exclude-result-prefixes="xsi xlink">
    
    <xsl:strip-space elements="*"/>
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:param name="article-link"/>
    <xsl:param name="date"/>
    <xsl:param name="time"/>
    <xsl:param name="fail-msg"/>
    <xsl:param name="info"/>
    <xsl:param name="peid"/>
    <xsl:param name="pub-hwx"/>
    <xsl:param name="status"/>
    <xsl:param name="volume-number"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Remove any existing meta elements if they already exist from a previous publishing attempt -->
    <xsl:template match="meta[@name='embargo.date']"/>
    <xsl:template match="meta[@name='embargo.time']"/>
    <xsl:template match="meta[@name='hwbatch']"/>
    <xsl:template match="meta[@name='info']"/>
    <xsl:template match="meta[@name='pub.hwx']"/>
    <xsl:template match="meta[@name='status']"/>
    <xsl:template match="meta[@name='vol']"/>
    
    
    <xsl:template match="item">
        
        <item>
            
            <xsl:copy-of select="@*"/>
            
            <xsl:apply-templates/>
            
            <meta name="status">
                <xsl:if test="$fail-msg = 'true'">
                    <xsl:copy-of select="meta[@name='status']/@*"/>
                    <xsl:value-of select="meta[@name='status']/text()"/>
                </xsl:if>
                <xsl:if test="$fail-msg = 'false'">
                    <xsl:copy-of select="meta[@name='status']/@report"/>
                    <xsl:if test="$peid != '${peid}'">
                        <xsl:attribute name="sent">
                            <xsl:text>true</xsl:text>
                        </xsl:attribute>
                        <xsl:text>Sent to HWX</xsl:text>
                    </xsl:if>
                </xsl:if>
            </meta>
            <meta name="info">
                <xsl:if test="$fail-msg = 'true'">
                    <xsl:value-of select="$info"/>
                </xsl:if>
            </meta>
            <meta name="pub.hwx">
                <xsl:value-of select="$pub-hwx"/>
            </meta>
            <meta name="embargo.date">
                <xsl:value-of select="$date"/>
            </meta>
            <meta name="embargo.time">
                <xsl:value-of select="$time"/>
            </meta>
            <meta name="vol">
                <xsl:value-of select="$volume-number"/>
            </meta>
            <meta link="{$article-link}" name="hwbatch">
                <xsl:if test="$peid != '${peid}'">
                    <xsl:value-of select="$peid"/>
                </xsl:if>
            </meta>
        </item>
        
        
    </xsl:template>
    
    
</xsl:stylesheet>

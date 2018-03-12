<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0">
    
    <xsl:template name="process-rss-description">
        
        <!-- new condition -->
        <xsl:if test="/condition[@is-new = 'true']">
            <xsl:text>New condition. </xsl:text>
        </xsl:if>
        
        <!-- options -->
        <xsl:variable name="options" select="document($temp-xml-input)/options"/>
        
        <!-- new-option -->
        
        <xsl:if test="$options//substantive-change[@status = 'new-option']">
            <xsl:choose>
                <!-- one item -->
                <xsl:when test="count($options//substantive-change[@status = 'new-option']) = 1">
                    <xsl:text>New option added for </xsl:text>
                    <xsl:value-of select="$options//substantive-change[@status = 'new-option']/ancestor::option/option-abridged-title"/>
                    <xsl:text>. </xsl:text>
                </xsl:when>
                <!-- two items -->
                <xsl:when test="count($options//substantive-change[@status = 'new-option']) = 2">
                    <xsl:text>New options added for </xsl:text>
                    <xsl:value-of select="
                        ($options//substantive-change[@status = 'new-option']
                        /ancestor::option/option-abridged-title)[1]"/>
                    <xsl:text> and </xsl:text>
                    <xsl:value-of select="
                        ($options//substantive-change[@status = 'new-option']
                        /ancestor::option/option-abridged-title)[2]"/>
                    <xsl:text>. </xsl:text>
                </xsl:when>
                <!-- more than two items -->
                <xsl:when test="count($options//substantive-change[@status = 'new-option']) &gt; 2">
                    <xsl:text>New options added for </xsl:text>
                    <xsl:for-each select="
                        ($options//substantive-change[@status = 'new-option'])
                        [position()!=last() and position()!=last()-1]">
                        <!-- all items but last two -->
                        <xsl:value-of select="ancestor::option/option-abridged-title"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <!-- second from last item -->
                    <xsl:value-of select="
                        ($options//substantive-change[@status = 'new-option']
                        /ancestor::option/option-abridged-title)
                        [position()=last()-1]"/>
                    <xsl:text> and </xsl:text>
                    <!-- last item -->
                    <xsl:value-of select="
                        ($options//substantive-change[@status = 'new-option']
                        /ancestor::option/option-abridged-title)
                        [last()]"/>
                    <xsl:text>. </xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        
        <!-- new-evidence-conclusions-changed -->
        <xsl:if test="$options//substantive-change[@status = 'new-evidence-conclusions-changed']">
            <xsl:choose>
                <!-- one item -->
                <xsl:when test="count($options//substantive-change[@status = 'new-evidence-conclusions-changed']) = 1">
                    <xsl:text>New evidence; conclusion changed for </xsl:text>
                    <xsl:value-of select="$options//substantive-change[@status = 'new-evidence-conclusions-changed']/ancestor::option/option-abridged-title"/>
                    <xsl:text>. </xsl:text>
                </xsl:when>
                <!-- two items -->
                <xsl:when test="count($options//substantive-change[@status = 'new-evidence-conclusions-changed']) = 2">
                    <xsl:text>New evidence; conclusions changed for </xsl:text>
                    <xsl:value-of select="
                        ($options//substantive-change[@status = 'new-evidence-conclusions-changed']
                        /ancestor::option/option-abridged-title)[1]"/>
                    <xsl:text> and </xsl:text>
                    <xsl:value-of select="
                        ($options//substantive-change[@status = 'new-evidence-conclusions-changed']
                        /ancestor::option/option-abridged-title)[2]"/>
                    <xsl:text>. </xsl:text>
                </xsl:when>
                <!-- more than two items -->
                <xsl:when test="count($options//substantive-change[@status = 'new-evidence-conclusions-changed']) &gt; 2">
                    <xsl:text>New evidence; conclusions changed for </xsl:text>
                    <xsl:for-each select="
                        ($options//substantive-change[@status = 'new-evidence-conclusions-changed'])
                        [position()!=last() and position()!=last()-1]">
                        <!-- all items but last two -->
                        <xsl:value-of select="ancestor::option/option-abridged-title"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <!-- second from last item -->
                    <xsl:value-of select="
                        ($options//substantive-change[@status = 'new-evidence-conclusions-changed']
                        /ancestor::option/option-abridged-title)
                        [position()=last()-1]"/>
                    <xsl:text> and </xsl:text>
                    <!-- last item -->
                    <xsl:value-of select="
                        ($options//substantive-change[@status = 'new-evidence-conclusions-changed']
                        /ancestor::option/option-abridged-title)
                        [last()]"/>
                    <xsl:text>. </xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        
        <!-- new-evidence-conclusions-confirmed -->
        <xsl:if test="$options//substantive-change[@status = 'new-evidence-conclusions-confirmed']">
            <xsl:choose>
                <!-- one item -->
                <xsl:when test="count($options//substantive-change[@status = 'new-evidence-conclusions-confirmed']) = 1">
                    <xsl:text>New evidence; conclusion confirmed for </xsl:text>
                    <xsl:value-of select="$options//substantive-change[@status = 'new-evidence-conclusions-confirmed']/ancestor::option/option-abridged-title"/>
                    <xsl:text>. </xsl:text>
                </xsl:when>
                <!-- two items -->
                <xsl:when test="count($options//substantive-change[@status = 'new-evidence-conclusions-confirmed']) = 2">
                    <xsl:text>New evidence; conclusions confirmed for </xsl:text>
                    <xsl:value-of select="
                        ($options//substantive-change[@status = 'new-evidence-conclusions-confirmed']
                        /ancestor::option/option-abridged-title)[1]"/>
                    <xsl:text> and </xsl:text>
                    <xsl:value-of select="
                        ($options//substantive-change[@status = 'new-evidence-conclusions-confirmed']
                        /ancestor::option/option-abridged-title)[2]"/>
                    <xsl:text>. </xsl:text>
                </xsl:when>
                <!-- more than two items -->
                <xsl:when test="count($options//substantive-change[@status = 'new-evidence-conclusions-confirmed']) &gt; 2">
                    <xsl:text>New evidence; conclusion confirmed for </xsl:text>
                    <xsl:for-each select="
                        ($options//substantive-change[@status = 'new-evidence-conclusions-confirmed'])
                        [position()!=last() and position()!=last()-1]">
                        <!-- all items but last two -->
                        <xsl:value-of select="ancestor::option/option-abridged-title"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <!-- second from last item -->
                    <xsl:value-of select="
                        ($options//substantive-change[@status = 'new-evidence-conclusions-confirmed']
                        /ancestor::option/option-abridged-title)
                        [position()=last()-1]"/>
                    <xsl:text> and </xsl:text>
                    <!-- last item -->
                    <xsl:value-of select="
                        ($options//substantive-change[@status = 'new-evidence-conclusions-confirmed']
                        /ancestor::option/option-abridged-title)
                        [last()]"/>
                    <xsl:text>. </xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        
        <!-- no-new-evidence -->
        <xsl:if test="
            count($options//substantive-change
            [@status = 'new-option' or 
            @status = 'new-evidence-conclusions-changed' or 
            @status = 'new-evidence-conclusions-confirmed']) = 0">
            <xsl:text>New search performed and critically appraised; no new evidence selected for inclusion.</xsl:text>
        </xsl:if>
        
    </xsl:template>
    
</xsl:stylesheet>

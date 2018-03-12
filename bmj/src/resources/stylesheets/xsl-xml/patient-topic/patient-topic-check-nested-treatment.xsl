<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  version="2.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:output method="xml" indent="yes" name="xml" encoding="UTF-8"/>
    
    <xsl:param name="temppath"/>
    <xsl:param name="maintopicname"/>
    <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*[name()!='xmlns:xi' ] ">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
            <xsl:element name="patient-topic">
                <xsl:apply-templates select="patient-topic/*"/>
                <xsl:call-template name="add-temporary-group-for-nested-treatment"/>

            </xsl:element>
    </xsl:template>
    
    <xsl:template match="xi:include|patient-topic"/>
    
    <xsl:template name="add-temporary-group-for-nested-treatment">
        <xsl:for-each select="//topic-element[@type='treatments']//treatment-link">
            <xsl:variable name="topicLowerCase" select="replace(translate(@topic, $ucletters,$lcletters), ' ', '-')"></xsl:variable>
            <xsl:if test="not(@target = preceding::treatment-link[ancestor::topic-element[@type='treatments']]/@target) and ($maintopicname = $topicLowerCase)">
                <xsl:variable name="targetfile"><xsl:value-of select="substring-after(@target, '../' )"/></xsl:variable>
                <xsl:variable name="treatmentdoc" select="document(concat($temppath, '/', $targetfile))"></xsl:variable>
                                
                <!--
                    <xsl:variable name="treatmentdoc" select="document($targetfile)"></xsl:variable>
                <xsl:call-template name="copyFile">
                    <xsl:with-param name="treatment" select="$treatment"/>
                </xsl:call-template>
                -->
                

                <xsl:if test="
                ($treatmentdoc//heading1 and $treatmentdoc//heading1[
                	contains(text(), 'Key points') or 
                	contains(text(), 'Key messages') or 
                	contains(text(), 'Treatments that work') or 
                	contains(text(), 'Treatments that need further study') or 
                	contains(text(), 'Treatments that are likely to work') or 
                	contains(text(), 'Treatments that are unlikely to work') or 
                	contains(text(), 'Treatments that are likely to be ineffective or harmful')] ) or 
                ($treatmentdoc//heading2 and $treatmentdoc//heading2[
                	contains(text(), 'Key points') or 
                	contains(text(), 'Key messages')])
				or @target='../treatments/_1000404898.xml'
		        or @target='../treatments/_1000404896.xml'
		        or @target='../treatments/_1000418851.xml'
		        or @target='../treatments/_1000418940.xml'
		        or @target='../treatments/_1000418939.xml'
		        or @target='../treatments/_1000418938.xml'">
                    <xsl:element name="topic-element">
                            <xsl:attribute name="type">temp-group</xsl:attribute>
                            <xsl:attribute name="id" select="@target"/>
                            <xsl:apply-templates select="$treatmentdoc/treatment/*"></xsl:apply-templates>
                        </xsl:element>
                    </xsl:if>

            </xsl:if>

        </xsl:for-each>     
    </xsl:template>
    
    <xsl:template match="treatment-link">
            <xsl:copy>
                <xsl:attribute name="topic" select="@topic"/>
                <xsl:attribute name="target">
                    <xsl:choose>
                        <xsl:when test="starts-with(@target, '../treatments/')">
                            <xsl:value-of select="@target"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('../treatments/', @target)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:copy>
    </xsl:template>
    
    <!-- 
    <xsl:template name="add-temporary-figure-link">
        <xsl:for-each select="//image-link">
            <xsl:variable name="targetfile1"><xsl:value-of select="replace(@target, '^\.\./images/(.+?)(_default)?\.(.+?)$' , '$1')"/></xsl:variable>
            <xsl:variable name="figfile"><xsl:text>../patient-figure/fig-</xsl:text><xsl:value-of select="$maintopicname"/><xsl:text>-</xsl:text><xsl:value-of select="replace($targetfile1, '^(.+?)(_default)$', '$1')"/><xsl:text>.xml</xsl:text></xsl:variable>
            <xsl:element name="figure">
                <xsl:attribute name="href" select="$figfile"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    -->
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:output 
        method="xml" 
        encoding="UTF-8"
        indent="yes"
        name="xml"/>
    
    <xsl:strip-space elements="*"/>
    <xsl:param name="maintopicname"/>
    <xsl:param name="path"/>
    <xsl:param name="temppath"/>
    
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
        <xsl:element name="file-transferred">
            <xsl:apply-templates select="//xi:include" mode="transfer"/>
        </xsl:element>            
    </xsl:template>
    
    <xsl:template match="xi:include" mode="transfer">
            <xsl:if test="not(@href = preceding::xi:include/@href)">
                <xsl:call-template name="copyFile">
                    <xsl:with-param name="target" select="@href"/>
                </xsl:call-template>     
            </xsl:if>                
    </xsl:template>
    
    <xsl:template name="copyFile">
        <xsl:param name="target"/>                        
        <xsl:variable name="file" select="substring-after($target, '../patient-treatment/')"></xsl:variable>
        
        <xsl:variable name="treatmentdoc" select="document(concat($temppath, '/treatments/', $file))"></xsl:variable>
        <xsl:variable name="filename">file:///<xsl:value-of select="translate($path,'\','/')"/>/patient-treatment-temp/<xsl:value-of select="$file"/></xsl:variable>
        
  
        <xsl:result-document href="{$filename}">
            <xsl:apply-templates select="$treatmentdoc/*"/>
        </xsl:result-document>
  
        <xsl:element name="filename">
            <xsl:value-of select="$filename"/>
        </xsl:element>
        
    </xsl:template>
        
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">

    <xsl:output 
        method="xml" 
        encoding="UTF-8"
        indent="yes"/>
    
    <xsl:param name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝ'"/>
    <xsl:param name="lower" select="'abcdefghijklmnopqrstuvwxyzáâãäåæçèéêëìíîïðñòóôõöøùúûüý'"/>
    <xsl:variable name="evidenceSummaryLinkUS">http://evidencesummary.bmj.com/en-us/</xsl:variable>
    <xsl:variable name="evidenceSummaryLinkUK">http://evidencesummary.bmj.com/en-gb/</xsl:variable>
    
    <!-- add schema -->
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="KNOWLEDGEPLAN">
        <xsl:element name="care-plan">
            <xsl:attribute name="xsi:noNamespaceSchemaLocation">
                <xsl:text>../../schemas/bmjk-care-plan.xsd</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="id">
                <xsl:text>1</xsl:text>
            </xsl:attribute>   
            
            
            <xsl:call-template name="add-attribute">
                <xsl:with-param name="value"><xsl:value-of select="./SOURCEORDERSETTYPE"/></xsl:with-param>
                <xsl:with-param name="name">plan-type</xsl:with-param>
            </xsl:call-template>
            
            <xsl:call-template name="add-attribute">
                <xsl:with-param name="value"><xsl:value-of select="./TYPEMEAN"/></xsl:with-param>
                <xsl:with-param name="name">powerplan-type</xsl:with-param>
            </xsl:call-template>
            
            <xsl:call-template name="add-cki-attribute"/>
            
            <xsl:element name="notes"/>
            
            <xsl:element name="care-plan-info">
                <xsl:apply-templates select="*[name() = 'EVIDENCEURL' or name() = 'CAPTION']"/>
            </xsl:element>
            
            <xsl:element name="action-set-list">
                <xsl:apply-templates select="*[name() = 'ORDERSETLIST']"/> 
            </xsl:element>
            
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="EVIDENCEURL">
        <xsl:call-template name="set-evidence-url">
            <xsl:with-param name="evidenceLink"><xsl:value-of select="."/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="CAPTION">
        <xsl:element name="title"><xsl:value-of select="."/></xsl:element>
    </xsl:template>
    
    <xsl:template match="DISPLAY">
        <xsl:call-template name="change-name-to-lowercase" />
    </xsl:template>    
    
    <xsl:template match="CLINICALCATEGORYDISP">
        <xsl:element name="clinical-category-disp"><xsl:value-of select="."/></xsl:element>
    </xsl:template>
    
    <!-- SENTENCE -->
    
    <xsl:template match="DISPLAYLINE">
        <xsl:element name="display-line"><xsl:value-of select="."/></xsl:element>
    </xsl:template>
    
    
    <!-- DETAILS -->
    
    <xsl:template match="FIELDDESC">
        <xsl:element name="description"><xsl:value-of select="normalize-space(.)"/></xsl:element>
    </xsl:template>
    <xsl:template match="FIELDDISPVALUE">
        <xsl:element name="value"><xsl:value-of select="normalize-space(.)"/></xsl:element>
    </xsl:template>
    
    <xsl:template match="ORDERSET">
        <xsl:element name="action-set">
            <xsl:call-template name="add-attribute">
                <xsl:with-param name="value"><xsl:value-of select="./TYPEMEAN"/></xsl:with-param>
                <xsl:with-param name="name">type</xsl:with-param>
            </xsl:call-template>            
            <xsl:call-template name="add-cki-attribute"/>
            <xsl:apply-templates select="*[name() != 'CKI' and name() !='TYPEMEAN']"/>                    
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="CATEGORYLIST">
        <xsl:element name="category-list">
            <xsl:apply-templates select="*"/>                    
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="CATEGORY">
        <xsl:element name="category">
            <xsl:call-template name="add-attribute">
                <xsl:with-param name="value"><xsl:value-of select="./CLINICALCATEGORYMEAN"/></xsl:with-param>
                <xsl:with-param name="name">clinical</xsl:with-param>
            </xsl:call-template>            
            <xsl:apply-templates select="*[name() != 'CLINICALCATEGORYMEAN']"/>             
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="SUBCATEGORYLIST">
        <xsl:element name="sub-category-list">
            <xsl:apply-templates select="*"/>                    
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="SUBCATEGORY">
        <xsl:element name="sub-category">
            <xsl:call-template name="add-attribute">
                <xsl:with-param name="value"><xsl:value-of select="./CLINICALSUBCATEGORYMEAN"/></xsl:with-param>
                <xsl:with-param name="name">clinical</xsl:with-param>
            </xsl:call-template>            
            <xsl:apply-templates select="*[name() != 'CLINICALSUBCATEGORYMEAN']"/>                    
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="COMPONENTLIST">
        <xsl:element name="component-list">
            <xsl:apply-templates select="*"/>                    
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="COMPONENT">
        <xsl:element name="component">
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="./ORDERABLETYPE = 'O'">orderable</xsl:when>
                    <xsl:when test="./ORDERABLETYPE = 'L'">note</xsl:when>
                    <xsl:when test="./ORDERABLETYPE = 'R'">outcome</xsl:when>
                    <xsl:when test="./ORDERABLETYPE = 'S'">sub-phase</xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="default">
                <xsl:choose>
                    <xsl:when test="./DEFAULTSELECTED = '0'">false</xsl:when>
                    <xsl:when test="./DEFAULTSELECTED = '1'">true</xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:attribute>
            <xsl:call-template name="add-cki-attribute"/>
            <xsl:apply-templates select="*[name() != 'CKI' and name() != 'ORDERABLETYPE' and name() != 'DEFAULTSELECTED']"/>                    
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="SENTENCELIST">
        <xsl:element name="sentence-list">
            <xsl:apply-templates select="*"/>                   
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="SENTENCE">
        <xsl:element name="sentence">
            <xsl:apply-templates select="*"/>                  
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="DETAILSLIST">
        <xsl:element name="details-list">
            <xsl:apply-templates select="*"/>              
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="DETAILS">
        <xsl:element name="details">
            <xsl:call-template name="add-attribute">
                <xsl:with-param name="value"><xsl:value-of select="./FIELDMEAN"/></xsl:with-param>
                <xsl:with-param name="name">type</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="add-cki-attribute"/>
            <xsl:apply-templates select="*[name() != 'CKI' and name() != 'FIELDMEAN']"/>                    
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="add-cki-attribute">
        <xsl:if test="./CKI and string(./CKI) != ''">
            <xsl:attribute name="cki">
                <xsl:value-of select="normalize-space(./CKI)"/>
            </xsl:attribute>            
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template name="add-attribute">
        <xsl:param name="value"/>
        <xsl:param name="name"/>
        
        <xsl:if test="$value and string($value) != ''">
            <xsl:attribute name="{$name}">
                <xsl:value-of select="translate(normalize-space($value),$upper,$lower)"/>
            </xsl:attribute>            
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="change-name-to-lowercase">
        <xsl:variable name="name" select="translate(name(), $upper, $lower)"/>
        <xsl:element name="{$name}">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="set-evidence-url">
        <xsl:param name="evidenceLink"/>
        
        <xsl:element name="evidence-url">
            <xsl:if test="text()[normalize-space($evidenceLink)]">
                <xsl:choose>
                    <xsl:when test="contains(.,$evidenceSummaryLinkUS)">
                        <xsl:attribute name="target">../evidence-summary/<xsl:value-of select="substring-after(substring-before($evidenceLink, '.html'), $evidenceSummaryLinkUS)"/>.xml</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(.,$evidenceSummaryLinkUK)">
                        <xsl:attribute name="target">../evidence-summary/<xsl:value-of select="substring-after(substring-before($evidenceLink, '.html'), $evidenceSummaryLinkUK)"/>.xml</xsl:attribute>
                    </xsl:when>                    
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>

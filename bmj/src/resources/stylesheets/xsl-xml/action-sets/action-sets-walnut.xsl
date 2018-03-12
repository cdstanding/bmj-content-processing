<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">
    
    <xsl:output 
        method="xml" 
        encoding="UTF-8" 
        indent="yes"/>
    
    <xsl:param name="lang"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="action-set">
        <xsl:element name="KNOWLEDGEPLAN">
            
            <xsl:attribute name="xsi:noNamespaceSchemaLocation">
                <xsl:text>http://schema.bmj.com/delivery/walnut/bmj-action-sets-cms-import.xsd</xsl:text>
            </xsl:attribute>
            
            <xsl:attribute name="CMSID">
                <xsl:value-of select="./@id"/>
            </xsl:attribute>   
            
            <xsl:attribute name="CreationDate">
                <xsl:value-of select="./@creation-date"/>
            </xsl:attribute>   
            
            <xsl:attribute name="ExpireDate">
                <xsl:value-of select="./@expire-date"/>
            </xsl:attribute>   
            
            <xsl:attribute name="Status">
                <xsl:value-of select="./@status"/>
            </xsl:attribute>   
            
            <xsl:attribute name="UpdateDate">
                <xsl:value-of select="./@update-date"/>
            </xsl:attribute>   
            
            <xsl:attribute name="Version">
                <xsl:value-of select="./@version"/>
            </xsl:attribute>   
            
            <xsl:attribute name="ageRange">
                <xsl:value-of select="./@age-range"/>
            </xsl:attribute>   
            
            <xsl:attribute name="bmjID">
                <xsl:value-of select="./@bmj-id"/>
            </xsl:attribute>   
            
            <xsl:attribute name="clientID">
                <xsl:value-of select="./@client-id"/>
            </xsl:attribute>   
            
            <xsl:attribute name="lang">
                <xsl:value-of select="./@language"/>
            </xsl:attribute>   
            
            <xsl:element name="CareSetting">
                <xsl:apply-templates select="//care-setting/node()"/>
            </xsl:element>
            
            <xsl:element name="GroupInfo">
                <xsl:apply-templates select="//group-info/node()"/>
            </xsl:element>
            
            <xsl:element name="Condition">
                <xsl:apply-templates select="//condition/node()"/>
            </xsl:element>

            <xsl:element name="ESPIDs">
                <xsl:apply-templates select="//esp-ids/node()"/>
            </xsl:element>
            
            <xsl:element name="ORDERSET">
                <xsl:apply-templates/>
            </xsl:element>
           
        </xsl:element>
    </xsl:template>      

    <xsl:template match="care-setting">
        <!-- do nothing -->
    </xsl:template>
    
    <xsl:template match="esp-ids">
        <!-- do nothing -->
    </xsl:template>
    
    <xsl:template match="condition">
        <!-- do nothing -->
    </xsl:template>
    
    <xsl:template match="group-info">
        <!-- do nothing -->
    </xsl:template>
    
    <!-- 
        From
        <evidence-summary-link hash="scope" id="scope" target="../evidence-summary/evidence-summary-1229003887289.xml"/>
        to
        <EVIDENCEURL>http://evidencesummary.bmj.com/x/en-us/evidence-summary-1229003887289.html?id=scope#scope</EVIDENCEURL>
     -->
    
    <xsl:template match="evidence-summary-link">
        <xsl:element name="EVIDENCEURL">http://evidencesummary.bmj.com/x/<xsl:value-of select="$lang"/><xsl:value-of select="replace(replace(./@target,'../evidence-summary/','/'),'.xml','.html')"/>?id=<xsl:value-of select="./@id"/>#<xsl:value-of select="./@hash"/></xsl:element>
    </xsl:template>
       
    <xsl:template match="group-id">
        <xsl:element name="GroupID">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="seq-no">
        <xsl:element name="SeqNo">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="cond-name">
        <xsl:element name="CondName">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="cond-code">
        <xsl:element name="CondCode">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="code-cat">
        <xsl:element name="CodeCat">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="type-mean">
        <xsl:element name="TYPEMEAN">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="category-list">
        <xsl:element name="CATEGORYLIST">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="clinical-category-mean">
        <xsl:element name="CLINICALCATEGORYMEAN">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="component-list">
        <xsl:element name="COMPONENTLIST">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="default-selected">
        <xsl:element name="DEFAULTSELECTED">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="orderable-type">
        <xsl:element name="ORDERABLETYPE">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="default-osind">
        <xsl:element name="DEFAULTOSIND">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="field-mean">
        <xsl:element name="FIELDMEAN">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="field-desc">
        <xsl:element name="FIELDDESC">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="field-display-value">
        <xsl:element name="FIELDDISPVALUE">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="bundle-group-id">
        <xsl:element name="BUNDLEGROUPID">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="sentence-list">
        <xsl:element name="SENTENCELIST">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="display-line">
        <xsl:element name="DISPLAYLINE">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="details-list">
        <xsl:element name="DETAILSLIST">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="sub-category-list">
        <xsl:element name="SUBCATEGORYLIST">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="sub-category">
        <xsl:element name="SUBCATEGORY">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="esp-id">
        <xsl:element name="ESPID">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="clinical-sub-category-mean">
        <xsl:element name="CLINICALSUBCATEGORYMEAN">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="caption">
        <xsl:element name="CAPTION">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="display">
        <xsl:element name="DISPLAY">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="category">
        <xsl:element name="CATEGORY">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="component">
        <xsl:element name="COMPONENT">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="cki">
        <xsl:element name="CKI">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="details">
        <xsl:element name="DETAILS">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="sentence">
        <xsl:element name="SENTENCE">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="code">
        <xsl:element name="Code">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
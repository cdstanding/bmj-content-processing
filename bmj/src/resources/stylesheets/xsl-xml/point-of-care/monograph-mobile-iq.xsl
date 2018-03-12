<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://my.pressrun.com/xsd/toc.xsd" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs #default"
    version="2.0" >
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Get the parameters from the publication -->
    <xsl:param name="mono-id" />
    <!--  Set to published date. In YYYY-MM-DD format -->
    <xsl:param name="published-date"/>
    <xsl:param name="language" />
    <xsl:param name="categoryList"/>
    
    <xsl:param name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝ'"/>
    <xsl:param name="lower" select="'abcdefghijklmnopqrstuvwxyzáâãäåæçèéêëìíîïðñòóôõöøùúûüý'"/>
    
    <!-- Used to access the category list for US monographs -->
    <xsl:param name="USCategoryList" select="document(concat('file:///', $categoryList))"></xsl:param> 
    
    <!-- variable to get different types of properties -->
    <xsl:variable name="propertyList" as="xs:string*"
        select="('type.appconfig', 'synonyms.appconfig', 'displaysynonyms.appconfig','categories.appconfig')"/>
    
    <!-- variable that defines which target platforms to make the issue available for  -->
    <xsl:variable name="applicationList" as="xs:string*"
        select="('ipad', 'android', 'kindlefire')"/>
    
    <xsl:variable name="root" select="/"/>
    
    <!-- Get the version number from the root node -->
    <xsl:variable name="version">
        <xsl:value-of select="/*/@version"> </xsl:value-of>
    </xsl:variable> 
    
    <!-- Variable to create a new line -->
    <xsl:variable name="newline" select="'&#10;&#160;&#160;&#160;'" />
    
    <!-- Variable to get the monograph type -->
    <xsl:variable name="mono-type" select="name(*)" />
    
    <!-- Variable to save the monograph title -->
    <xsl:variable name="monographTitle">
        
        <!-- If the monograph is evalution monograph, then remove  'Assessment of' and to translate the first letter to upper case -->
        <xsl:choose>
            <xsl:when test="$mono-type = 'monograph-eval'">
                <xsl:choose>
                    <xsl:when test="contains(/*/monograph-info/title, 'Assessment of ')">
                        <xsl:variable name="no-ass" select="(substring-after(/*/monograph-info/title, 'Assessment of '))"/>
                        <xsl:variable name= "ufirstChar" select="translate(substring($no-ass,1,1),$lower,$upper)"/>  
                        <xsl:value-of select="normalize-space(concat($ufirstChar,substring($no-ass,2)))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(/*/monograph-info/title)"></xsl:value-of>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- For other monographs get the title as it is  -->
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(/*/monograph-info/title)"></xsl:value-of>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- Variable to get the monograph-type as per the business rules
        monograph-full=disease, monograph-eval=symptom, monograph-overview=overview, monograph-generic=generic -->
    
    <xsl:variable name="monographType">
        <xsl:choose>
            <xsl:when test="($mono-type = 'monograph-full')">
                <xsl:value-of select="'disease'"/></xsl:when>
            <xsl:when test="($mono-type = 'monograph-overview')">
                <xsl:value-of select="'overview'"/></xsl:when>
            <xsl:when test="($mono-type = 'monograph-eval')">
                <xsl:value-of select="'symptom'"/></xsl:when>
            <xsl:when test="($mono-type = 'monograph-generic')">
                <xsl:value-of select="'generic'"/></xsl:when>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template match="/">
        <!-- Create the root element -->    
        <issue  
            xsi:schemaLocation="http://my.pressrun.com/xsd/toc.xsd toc2.xsd"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"         
            version="0.1">
            <xsl:element name="title">
                <xsl:value-of select="$monographTitle"/>
            </xsl:element>
            
            <xsl:element name="deadline">
                <xsl:value-of select="$published-date"/>
            </xsl:element>
            <!--   <xsl:element name="version">
                <xsl:copy-of select="$version"/>
                </xsl:element> -->
            <!-- Call the template to display the list of properties -->
            <xsl:call-template name="properties"></xsl:call-template>
            
            <xsl:element name="variants"></xsl:element>
            <!-- Call the template to display the list of applications -->
            <xsl:call-template name="applications"></xsl:call-template>
            
            <xsl:element name="sources">
                <xsl:call-template name="sources"></xsl:call-template>
            </xsl:element>
        </issue>
        
    </xsl:template>
    
    <xsl:template name="sources">
        <xsl:element name="source">
            <xsl:attribute name="href">
                <xsl:value-of select="concat($mono-id, '/', $mono-id, '.xml')"></xsl:value-of>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="'xmlv2'"></xsl:value-of>
            </xsl:attribute>
            <xsl:element name="contents">
                <xsl:call-template name="content">
                    
                </xsl:call-template>    
            </xsl:element>
        </xsl:element>
        
    </xsl:template>
    
    
    <xsl:template name="properties">
        <xsl:element name="properties">
            <!-- Traverse through the propertyList array -->
            <xsl:for-each select="$propertyList">
                <xsl:variable name="propertyValue" select="."></xsl:variable>
                <xsl:element name="property">
                    <xsl:attribute name="name">
                        <xsl:value-of select="$propertyValue"/>
                    </xsl:attribute>
                    <xsl:call-template name="property">
                        <xsl:with-param name="propertyName" select="$propertyValue"></xsl:with-param>
                    </xsl:call-template>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="applications">
        <xsl:element name="applications">
            <!-- Traverse through the applicationList array -->
            <xsl:for-each select="$applicationList">
                <xsl:variable name="applicationValue" select="."></xsl:variable>
                <xsl:element name="application">
                    <xsl:attribute name="type">
                        <xsl:value-of select="$applicationValue"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="content">
        <xsl:element name="content">
            
            <xsl:attribute name="type">
                <xsl:value-of select="'article'"/>
            </xsl:attribute>
            <xsl:element name="name">
                <xsl:value-of select="$mono-id"></xsl:value-of>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="property">
        <xsl:param name="propertyName"></xsl:param>
        <xsl:choose>
            <xsl:when test="($propertyName = 'type.appconfig')">
                <xsl:value-of select="$monographType"/>          
            </xsl:when>
            <xsl:when test="($propertyName = 'synonyms.appconfig')">
                
                <xsl:choose>
                    <xsl:when test="count($root/*/monograph-info/topic-synonyms//synonym) = 0">
                        <xsl:text>[]</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="$root/*/monograph-info/topic-synonyms">
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:when>

            <xsl:when test="($propertyName = 'displaysynonyms.appconfig')">
                <xsl:call-template name="displayable"/>
            </xsl:when>
            
            <xsl:when test="($propertyName = 'categories.appconfig' and $language = 'en-gb')">
                <xsl:apply-templates select="$root/*/monograph-info/categories">
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="($propertyName = 'categories.appconfig' and $language = 'pt-br')">
                <xsl:apply-templates select="$root/*/monograph-info/categories">
                </xsl:apply-templates>
            </xsl:when>
            <!-- For US monographs, categories are saved in external file and we will get the location of the file from the publication -->
            <xsl:when test="($propertyName = 'categories.appconfig' and $language = 'en-us')">
	            <xsl:variable name="monograph-first-category">
	            	<xsl:value-of select="$USCategoryList//categories[../id/text() = $mono-id]/category[1]/text()"></xsl:value-of>
	            </xsl:variable>
	            <xsl:if test="string-length($monograph-first-category)&lt;= 0">
	            	<xsl:message terminate="yes">ERROR: Missing Categories </xsl:message>
	            </xsl:if>
	            <xsl:apply-templates select="$USCategoryList//categories[../id/text() = $mono-id]"></xsl:apply-templates>
	        </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>    
        
    </xsl:template>
    
    <!-- updated for Mantis ID  -->
    
   <xsl:template match="topic-synonyms">
        <xsl:text>[</xsl:text>
        <xsl:for-each select="child::*">
	           <!-- to delete the (Assessment of) from the synonym -->
              <xsl:choose>
                <xsl:when test="contains(., ' (Assessment of)') "> 
 
              <xsl:variable name="no-ass" select="(substring-before(normalize-space(text()), ' (Assessment of)'))"/>
                   <xsl:text>"</xsl:text><xsl:value-of select="$no-ass"/><xsl:text>"</xsl:text>
              </xsl:when>   
	<!-- to delete the assessment of from the synonym -->  	
	<xsl:when test="contains(., ', assessment of') "> 
 
              <xsl:variable name="no-ass" select="(substring-before(normalize-space(text()), ', assessment of'))"/>
                   <xsl:text>"</xsl:text><xsl:value-of select="$no-ass"/><xsl:text>"</xsl:text>
              </xsl:when>        	
       <xsl:otherwise>
       	<xsl:text>"</xsl:text><xsl:value-of select="normalize-space(text())"/><xsl:text>"</xsl:text>
       </xsl:otherwise>
       
       </xsl:choose>
       
       
            <xsl:if test="position()!=last()">
                <xsl:text>,</xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    
    
 	<!-- Comma separated list of the displayable categories -->    
        <xsl:template match="categories ">
        <xsl:text>[</xsl:text>
        <xsl:for-each select="child::*">
            <xsl:text>"</xsl:text><xsl:value-of select="normalize-space(text())"/><xsl:text>"</xsl:text>
            <xsl:if test="position()!=last()">
                <xsl:text>,</xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <xsl:template name="displayable">
        <xsl:text>[</xsl:text>
        <xsl:for-each select="$root/*/monograph-info/topic-synonyms/synonym[@displayable='true']">
              <xsl:choose>
	<!-- to delete the (Assessment of) from the synonym -->
       <xsl:when test="contains(., ' (Assessment of)') "> 
 
              <xsl:variable name="no-ass" select="(substring-before(normalize-space(text()), ' (Assessment of)'))"/>
                   <xsl:text>"</xsl:text><xsl:value-of select="$no-ass"/><xsl:text>"</xsl:text>
              </xsl:when>   
  	<!-- to delete the assessment of from the synonym -->  
	<xsl:when test="contains(., ', assessment of') "> 
 
              <xsl:variable name="no-ass" select="(substring-before(normalize-space(text()), ', assessment of'))"/>
                   <xsl:text>"</xsl:text><xsl:value-of select="$no-ass"/><xsl:text>"</xsl:text>
              </xsl:when>        	
       <xsl:otherwise>
       	<xsl:text>"</xsl:text><xsl:value-of select="normalize-space(text())"/><xsl:text>"</xsl:text>
       </xsl:otherwise>
       
       </xsl:choose>
            <xsl:if test="position()!=last()">
                <xsl:text>,</xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    
    
    
    
    
    
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:oak="http://schema.bmj.com/delivery/oak"
    
    xmlns:saxon="http://saxon.sf.net/"
    
    version="2.0">
    
    <xsl:output 
        method="xml" 
        encoding="UTF-8" 
        indent="yes"
        name="result-document"
    />
    
    <xsl:param name="xsl-dir"/>
    <xsl:param name="publish-dir"/>
    <xsl:param name="page-query"/>
    <xsl:param name="self-filename"/>
    
    <xsl:param name="pub.resource.id"/>
    <xsl:param name="pub.resource.name"/>
    
    <xsl:param name="message-source"/>
    
    <xsl:variable name="self-doc">
        <xsl:copy-of select="/*"/>
    </xsl:variable>

    <xsl:template match="/*">
        
        <xsl:element name="project">
            <xsl:attribute name="name" select="string('build-autopopulated')"/>
            
            <!--<delete dir="target/xml/$pub.resource.id"/>
            <delete dir="target/html/$pub.resource.id"/>-->
        
            <xsl:for-each select="tokenize($page-query, ',')">
                <xsl:variable name="filename" select="translate(normalize-space(.), '\', '/')"/>
                <xsl:message select="substring-after($filename, 'page-query/')"/>
                
                <xsl:for-each select="document($filename)/pages/page">
                    <xsl:variable name="monograph-type" select="string(parent::pages/@monograph_type)"/>
                    <xsl:variable name="page-label" select="string(@label)"/>
                    
                    <xsl:variable name="presence-xquery">
                        
                        <xsl:for-each select="tokenize(presence-xquery/body, ',')">
                            <xsl:variable name="xpath" select="normalize-space(.)"/>
                            
                            <xsl:if test="$self-doc/saxon:evaluate($xpath)/(element()|text())">
                                <xsl:element name="item">
                                    <xsl:attribute name="xpath" select="$xpath"/>
                                </xsl:element>    
                            </xsl:if>
                            
                        </xsl:for-each>
                        
                    </xsl:variable>
                    
                    <xsl:if test="count($presence-xquery/item)!=0">
                        <xsl:variable name="filename" select="translate(concat($publish-dir, '/xml/', $page-label, '.xml'), '\', '/')"/>
                        <xsl:message select="substring-after($filename, '/xml/')"/>
                        
                        <xsl:result-document 
                            href="{$filename}" 
                            format="result-document">
                            
                            <xsl:element name="xquery-result">
                                
                                <xsl:element name="body">
                                
                                    <xsl:choose>
                                        
                                        <xsl:when test="contains(retrieval-xquery/body, '$') or contains(retrieval-xquery/body, '{')">
                                            
                                            <xsl:for-each select="tokenize(presence-xquery/body, ',')">
                                                <xsl:variable name="xpath" select="normalize-space(.)"/>
                                                
                                                <xsl:copy-of select="$self-doc/saxon:evaluate($xpath)"/>
                                                
                                            </xsl:for-each>
                                            
                                        </xsl:when>
                                        
                                        <xsl:otherwise>
    
                                            <xsl:for-each select="tokenize(retrieval-xquery/body, ',')">
                                                <xsl:variable name="xpath" select="normalize-space(.)"/>
                                                
                                                <xsl:copy-of select="$self-doc/saxon:evaluate($xpath)"/>
                                                
                                            </xsl:for-each>
                                            
                                        </xsl:otherwise>
                                        
                                    </xsl:choose>
                                
                                </xsl:element>
                                
                            </xsl:element>
                            
                        </xsl:result-document>
                        
                        <!-- continue build.xml -->
                        <xsl:element name="saxon-xslt">
                            <xsl:attribute name="in" select="translate(concat($publish-dir, '/xml/', $page-label, '.xml'), '\', '/')"/>
                            <xsl:attribute name="out" select="translate(concat($publish-dir, '/html/', $page-label, '.html'), '\', '/')"/>
                            <xsl:attribute name="style" select="translate(concat($xsl-dir, '/', $monograph-type, '/', $page-label, '.xsl'), '\', '/')"/>
                            <xsl:attribute name="force" select="string('true')"/>
                                
                            <xsl:element name="param">
                                <xsl:attribute name="name" select="string('ctxPath')" />
                                <xsl:attribute name="expression" select="string('ctxPath')" />
                            </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="name" select="string('cdnUrl')" />
                                <xsl:attribute name="expression" select="string('cdnUrl')" />
                            </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="name" select="string('locale')" /> 
                                <xsl:attribute name="expression" select="string('en-gb')" />
                            </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="name" select="string('imagePath')" />
                                <xsl:attribute name="expression" select="string('imagePath')" />
                            </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="name" select="string('pdfPath')" />
                                <xsl:attribute name="expression" select="string('pdfPath')" />
                            </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="name" select="string('messageSource')" />
                                <xsl:attribute name="expression" select="translate(normalize-space($message-source), '\', '/')" />
                            </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="name" select="string('drugDatabases')" />
                                <xsl:attribute name="expression" select="string('drugDatabases')" />
                            </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="name" select="string('selectedDrugDB')" />
                                <xsl:attribute name="expression" select="string('selectedDrugDB')" />
                            </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="name" select="string('enableDrugLinks')" />
                                <xsl:attribute name="expression" select="string('false')" />
                            </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="name" select="string('isInternalDrugLink')" />
                                <xsl:attribute name="expression" select="string('isInternalDrugLink')" />
                            </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="name" select="string('monographTitle')" />
                                <xsl:attribute name="expression" select="normalize-space($self-doc/*/@dx-id)" />
                            </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="name" select="string('monographId')" />
                                <xsl:attribute name="expression" select="normalize-space($self-doc/*/monograph-info/title)" />
                            </xsl:element>
                            
                        </xsl:element>
                        
                    </xsl:if>
                        
                </xsl:for-each>
                
            </xsl:for-each>
            
        </xsl:element>
        
    </xsl:template>

</xsl:stylesheet>
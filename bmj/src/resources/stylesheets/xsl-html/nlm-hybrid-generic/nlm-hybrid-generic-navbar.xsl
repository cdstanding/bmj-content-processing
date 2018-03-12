<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
    
    version="2.0">
    
    <xsl:output 
        method="xml" 
        encoding="UTF-8" 
        indent="yes"
    />
    
    <xsl:output
        doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
        method="xhtml"
        version="1.0" 
        encoding="UTF-8" 
        indent="yes"
        name="result-document"
    />
    
    <xsl:param name="systematic-reviews-ebm-fileset"/>
    <xsl:param name="systematic-reviews-ebm-sections"/>
    
    <xsl:variable name="systematic-reviews-ebm-fileset-metadata">
        
        <xsl:for-each select="tokenize($systematic-reviews-ebm-fileset, ',')">
            <xsl:variable name="section" select="replace(., '^.+?[/\\]([^/^\\]+?)[/\\][^/^\\]+?.xml$', '$1')"/>
            <xsl:variable name="href" select="replace(., '^.+?[/\\][^/^\\]+?[/\\]([^/^\\]+?.xml)$', '$1')"/>
            
            <xsl:for-each select="document(translate(normalize-space(.),'\','/'))/*">
                
                <xsl:element name="item">
                    <xsl:attribute name="section" select="$section"/>
                    <xsl:attribute name="title" select="normalize-space(/article/front/article-meta/title-group/article-title)"/>
                    <xsl:attribute name="href" select="$href"/>
                    
                    <xsl:copy-of select="/article/front/article-meta/related-article[@related-article-type='navbar']"/>
                    
                </xsl:element>
                
            </xsl:for-each>
            
        </xsl:for-each>
        
    </xsl:variable>
    
    <xsl:template match="/article">
        
        <xsl:element name="root">
            
            <xsl:comment>ingore this this temp document</xsl:comment>
            
            <xsl:copy-of select="$systematic-reviews-ebm-fileset-metadata"/>
            
            <xsl:for-each select="tokenize($systematic-reviews-ebm-sections, ',')">
                <xsl:variable name="section" select="normalize-space(.)"/>
                <xsl:variable name="filename" select="concat($section, '/navbar.xml')"/>
                
                <xsl:result-document 
                    href="{$filename}" 
                    format="result-document">
                    
                    <xsl:element name="xhtml">

                        <xsl:element name="ul">
                            <xsl:attribute name="id" select="concat('navigation-', $section)"/>
                            
                            <!-- TODO need to determine root doc(s) without hardcoing index.xml ?? -->
                            <xsl:for-each select="$systematic-reviews-ebm-fileset-metadata/item[@section=$section and @href='index.xml']">
                                
                                <xsl:call-template name="process-sub-navbar"/>
                                
                            </xsl:for-each>
                            
                        </xsl:element>
                        
                    </xsl:element>
                        
                </xsl:result-document>
                
            </xsl:for-each>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template name="process-sub-navbar">
        <xsl:variable name="section" select="@section"/>
        
        <xsl:choose>
            
            <xsl:when test="related-article">
                
                <xsl:element name="li">
                    
                    <xsl:element name="span">
                        <xsl:value-of select="@title"/>
                    </xsl:element>
                    
                    <xsl:element name="ul">
                        
                        <xsl:element name="li">
                            
                            <xsl:if test="@href='index.xml'">
                                <xsl:attribute name="style" select="('display:none;')"/>
                            </xsl:if> 
                            
                            <xsl:element name="a">
                                <xsl:attribute name="href" 
                                    select="
                                    concat(
                                    legacytag:getAbstractId(
                                    concat(
                                    '/bmjk/systematic-reviews-ebm/', 
                                    $section, 
                                    '/', 
                                    replace(@href, '^(.+?).xml$', '$1')
                                    )
                                    ),
                                    '.html'
                                    )
                                    "/>
                                
                                <xsl:value-of select="@title"/>
                                
                            </xsl:element>    
                            
                        </xsl:element>
                        
                        <xsl:for-each select="related-article">
                            <xsl:variable name="href-related-article" select="@href"/>
                            
                            <xsl:for-each select="$systematic-reviews-ebm-fileset-metadata/item[@section=$section and @href = $href-related-article]">
                                
                                <xsl:call-template name="process-sub-navbar"/>
                                
                            </xsl:for-each>
                            
                        </xsl:for-each>
                        
                    </xsl:element>
                    
                </xsl:element>
                
            </xsl:when>
            
            <xsl:otherwise>
                
                <xsl:element name="li">
                    
                    <xsl:element name="a">
                        <xsl:attribute name="href" 
                            select="
                            concat(
                            legacytag:getAbstractId(
                            concat(
                            '/bmjk/systematic-reviews-ebm/', 
                            $section, 
                            '/', 
                            replace(@href, '^(.+?).xml$', '$1')
                            )
                            ),
                            '.html'
                            )
                            "/>
                        
                        <xsl:value-of select="@title"/>
                        
                    </xsl:element>
                    
                </xsl:element>
                
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    
</xsl:stylesheet>
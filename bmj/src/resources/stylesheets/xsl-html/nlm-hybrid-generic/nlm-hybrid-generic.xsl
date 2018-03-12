<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
    
    version="2.0">
    
    <xsl:output 
        doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
        method="xhtml" 
        encoding="UTF-8" 
        indent="yes"
    />
    
    <xsl:param name="images-input"/>
    <xsl:param name="section"/>
    
    <xsl:param name="date-amended"/>
    <xsl:param name="date-updated"/>
    <xsl:param name="date-amended-iso"/>
    <xsl:param name="date-updated-iso"/>
    <xsl:param name="todays-date-iso"/>
    
    
    <xsl:template match="/article">
        
        
        <xsl:element name="xhtml"><!-- should be html ?? -->
            
            <xsl:element name="metadata">
                
                <xsl:element name="key">
                    <xsl:attribute name="amended-date-iso" select="$date-amended-iso"/>
                </xsl:element>
                
                <xsl:element name="key">
                    <xsl:attribute name="date-updated-iso" select="$date-updated-iso"/>
                </xsl:element>
                
                <xsl:element name="key">
                    <xsl:attribute name="export-date-iso" select="$todays-date-iso"/>
                </xsl:element>
                
            </xsl:element>
            

            <xsl:if test="not(/body/sec[1]/title) and /article/front/article-meta/title-group/article-title">
                
                <xsl:element name="h1">
                    <xsl:apply-templates select="/article/front/article-meta/title-group/article-title/node()"/>
                </xsl:element>    
                
            </xsl:if>
            
            <xsl:apply-templates select="body/*"/>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="sec|table-wrap|caption">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="title">
        
        <xsl:element name="{concat('h', count( ancestor::sec))}">
            
            <xsl:if test="parent::sec[contains(@sec-type, 'highlight')]">
                <xsl:attribute name="class" select="parent::sec/@sec-type"/>
            </xsl:if> 
              
            <xsl:apply-templates/>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="list">
        <xsl:element name="ul">
            <xsl:apply-templates/>            
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="list-item">
        <xsl:element name="li">
            
            <xsl:choose>
                
                <xsl:when test="count(p) = 1">
                    <xsl:apply-templates select="p/node()"/>        
                </xsl:when>
                
                <xsl:when test="count(p) &gt; 1">
                    <xsl:comment>cms xml to html tried to flattent multiple para markup to list item text</xsl:comment>
                    <xsl:for-each select="p">
                        <xsl:apply-templates/>
                        <xsl:text disable-output-escaping="yes"> </xsl:text>
                    </xsl:for-each>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:apply-templates select="p/node()"/>
                </xsl:otherwise>
                
            </xsl:choose>
            
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="bold">
        <xsl:element name="strong">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="italic">
        <xsl:element name="em">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="xref">
        
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:text>/x/set/static/ebm/</xsl:text>
                <xsl:value-of select="$section"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of 
                    select="
                    legacytag:getAbstractId(
                        concat(
                            '/bmjk/systematic-reviews-ebm/',
                            $section, 
                            '/', 
                            replace(@rid, '^.*?([^\\^/]+?)\.xml$', '$1') 
                            )
                        )
                        "/>
                <xsl:text>.html</xsl:text>
            </xsl:attribute>
            
            <xsl:apply-templates/>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="ext-link">
        <xsl:element name="a">
            <xsl:attribute name="href" select="@href"/>
            <xsl:if test="not(starts-with(@href, '/x/'))">
                <xsl:attribute name="target" select="string('_blank')"/>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="graphic">
        <xsl:element name="img">
            <xsl:attribute name="src" select="concat('/x/images/ce/en-gb/', substring-after(@href, '/images/'))"/>
            <xsl:attribute name="alt" select="normalize-space(caption)"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="media">
        <xsl:element name="a">
            
            <xsl:choose>
                
                <xsl:when test="contains(@href, '.pdf')">
                    <xsl:attribute name="href" select="replace(concat('/x/pdf/clinical-evidence/en-gb/ebm/', substring-after(@href, '/mmo/')), '^(.+?)(_default)(.+?)$', '$1$2$3')"/>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:attribute name="href" select="replace(concat('/x/mmo/ce/en-gb/', substring-after(@href, '/mmo/')), '^(.+?)(_default)(.+?)$', '$1$2$3')"/>
                </xsl:otherwise>
                
            </xsl:choose>
            
            <xsl:apply-templates select="caption/p/node()" />
            
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="element()">
        <xsl:element name="{name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
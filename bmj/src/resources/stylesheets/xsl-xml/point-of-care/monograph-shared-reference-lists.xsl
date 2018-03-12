<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
    version="1.1">
    
    <!-- THIS STYLESHEET DOCUMENT IS SHARED WITH OTHER PROJECTS -->
    
    <xsl:key name="reference-link-keys" match="reference-link" use="@target"/><!--[not(ancestor::notes)]-->
    <xsl:key name="article-reference-link-keys" match="reference-link[@type='article']" use="@target"/>
    <xsl:key name="online-reference-link-keys" match="reference-link[@type='online']" use="@target"/>
    <xsl:key name="evidence-score-link-keys" match="evidence-score-link" use="@target"/>
    <xsl:key name="figure-link-keys" match="figure-link" use="@target"/>
    
    <xsl:template name="process-reference-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//reference-link)[$link-index]/@target"/>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//reference-link)[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('reference-link-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //reference-link[@target=$link-target]">
                    <xsl:variable name="filename">
                        <xsl:text>file://localhost/</xsl:text>
                        <!--<xsl:text>/</xsl:text>-->
                        <!--<xsl:value-of select="substring-before(translate($path,'\','/'), '/monograph-type')"/>
                            <xsl:value-of select="substring-after($link-target, '../')"/>-->
                        <xsl:value-of select="translate($path,'\','/')"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="$link-target"/>
                    </xsl:variable>
                    <xsl:element name="reference">
                         <xsl:attribute name="id">
                            <xsl:value-of select="$item-count"/>
                        </xsl:attribute> 
                        <xsl:copy-of select="document($filename)//reference/@*[name()!='xsi:noNamespaceSchemaLocation']"/>
                        <xsl:processing-instruction name="filename">
                            <xsl:value-of select="$filename"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="target">
                            <xsl:value-of select="$link-target"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="position">
                            <xsl:value-of select="$item-count"/>
                        </xsl:processing-instruction>
                        <xsl:copy-of select="document($filename)//reference/node()"/>    
                    </xsl:element>
                    <xsl:call-template name="process-reference-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-reference-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="process-article-reference-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//reference-link[@type='article'])[$link-index]/@target"/>
        <xsl:variable name="status"><xsl:value-of select="(//reference-link[@type='article'])[$link-index]/@status"/>
                    </xsl:variable>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//reference-link[@type='article'])[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('article-reference-link-keys', $link-target)[1])"/>
            
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //reference-link[@target=$link-target]">
                    <xsl:variable name="filename">
                         <xsl:text>file://localhost/</xsl:text>
                        <!--<xsl:text>/</xsl:text>-->
                        <!--<xsl:value-of select="substring-before(translate($path,'\','/'), '/monograph-type')"/>
                        <xsl:value-of select="substring-after($link-target, '../')"/>-->
                          <xsl:value-of select="translate($path,'\','/')"/> 
                         <xsl:text>/</xsl:text>
                        <xsl:value-of select="$link-target"/>
                    </xsl:variable>
                    <!--  Added for Mantis ID 12117 to check if the value for status attribute is present -->
                  <!--   <xsl:variable name="status">
                    <xsl:value-of select="document($filename)//reference/poc-citation/@status"/>
                    </xsl:variable>-->
                    <xsl:element name="reference">
                          <xsl:attribute name="id">
                            <xsl:value-of select="$item-count"/>
                        </xsl:attribute>
                        
                        <!--  Added for Mantis ID 12117 -->
                         <xsl:if test="string-length($status)>0"> 
                      <xsl:attribute name="status">
                       <xsl:value-of select="$status"/>
                       </xsl:attribute>
                       </xsl:if> 
                       
                         
                        <xsl:copy-of select="document($filename)//reference/@*[name()!='xsi:noNamespaceSchemaLocation']"/>
                        <xsl:processing-instruction name="filename">
                            <xsl:value-of select="$filename"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="target">
                            <xsl:value-of select="$link-target"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="position">
                            <xsl:value-of select="$item-count"/>
                        </xsl:processing-instruction>
                        <xsl:copy-of select="document($filename)/reference/node()"/>    
                    </xsl:element>
                    <xsl:call-template name="process-article-reference-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-article-reference-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="process-online-reference-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//reference-link[@type='online'])[$link-index]/@target"/>
       <xsl:variable name="status"><xsl:value-of select="(//reference-link[@type='online'])[$link-index]/@status"/>
                    </xsl:variable>
        
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//reference-link[@type='online'])[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('online-reference-link-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //reference-link[@target=$link-target]">
                    <xsl:variable name="filename">
                        <xsl:text>file://localhost/</xsl:text> 
                        <!--<xsl:text>/</xsl:text>-->
                        <!--<xsl:value-of select="substring-before(translate($path,'\','/'), '/monograph-type')"/>
                            <xsl:value-of select="substring-after($link-target, '../')"/>-->
                          <xsl:value-of select="translate($path,'\','/')"/> 
                         <xsl:text>/</xsl:text>
                        <xsl:value-of select="$link-target"/>
                    </xsl:variable>
                      <!--  Added for Mantis ID 12117 to check if the value for status attribute is present -->
                   <!--  <xsl:variable name="status">
                    <xsl:value-of select="document($filename)//reference/poc-citation/@status"/>
                    </xsl:variable>-->
                    <xsl:element name="reference">
                     <xsl:attribute name="id">
                            <xsl:value-of select="$item-count"/>
                        </xsl:attribute>
                      
                        <xsl:if test="string-length($status)>0"> 
                      <xsl:attribute name="status">
                       <xsl:value-of select="$status"/>
                       </xsl:attribute>
                       </xsl:if>
                       
                       
                        <xsl:copy-of select="document($filename)//reference/@*[name()!='xsi:noNamespaceSchemaLocation']"/>
                        <xsl:processing-instruction name="filename">
                            <xsl:value-of select="$filename"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="target">
                            <xsl:value-of select="$link-target"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="position">
                            <xsl:value-of select="$item-count"/>
                        </xsl:processing-instruction>
                        <xsl:copy-of select="document($filename)//reference/node()"/>    
                    </xsl:element>
                    <xsl:call-template name="process-online-reference-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-online-reference-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="process-figure-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//figure-link)[$link-index]/@target"/>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//figure-link)[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('figure-link-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //figure-link[@target=$link-target]">
                    <xsl:variable name="filename">
                         <xsl:text>file://localhost/</xsl:text> 
                        <!--<xsl:text>/</xsl:text>-->
                        <!--<xsl:value-of select="substring-before(translate($path,'\','/'), '/monograph-type')"/>
                            <xsl:value-of select="substring-after($link-target, '../')"/>-->
                          <xsl:value-of select="translate($path,'\','/')"/> 
                         <xsl:text>/</xsl:text>
                        <xsl:value-of select="$link-target"/>
                    </xsl:variable>
                    <xsl:element name="figure">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$item-count"/>
                        </xsl:attribute>
                        <xsl:copy-of select="document($filename)//figure/@*[name()!='xsi:noNamespaceSchemaLocation']"/>
                        <xsl:processing-instruction name="filename">
                            <xsl:value-of select="$filename"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="target">
                            <xsl:value-of select="$link-target"/>
                        </xsl:processing-instruction> 
                        <xsl:processing-instruction name="position">
                            <xsl:value-of select="$item-count"/>
                        </xsl:processing-instruction>
                        <!-- export thumb nail image if found in respositiory -->
                        <xsl:variable name="image-name" select="substring-after(document($filename)//figure/image-link/@target, 'images/')"/>
                        <xsl:variable name="image-path" select="concat(substring-before($path, 'monograph-plan'), 'monograph-images')"/>
                        <xsl:if test="$server!='offline'">
                            <xsl:processing-instruction name="thumb">
                                <xsl:value-of select="legacytag:copyOverThumbImages($image-path ,$image-name)"/>
                            </xsl:processing-instruction>
                        </xsl:if>
                        <xsl:copy-of select="document($filename)//figure/node()"/>
                    </xsl:element>
                    <xsl:call-template name="process-figure-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-figure-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="process-evidence-score-links">
        <xsl:param name="link-index"/>
        <xsl:param name="item-count"/>
        <xsl:param name="link-count"/>
        <xsl:variable name="link-target" select="(//evidence-score-link)[$link-index]/@target"/>
        <xsl:if test="$link-index &lt; $link-count">
            <xsl:variable name="link-id" select="generate-id((//evidence-score-link)[$link-index])"/>
            <xsl:variable name="key-id" select="generate-id(key('evidence-score-link-keys', $link-target)[1])"/>
            <xsl:choose>
                <xsl:when test="$link-id = $key-id and //evidence-score-link[@target=$link-target]">
                    <xsl:variable name="filename">
                        <xsl:text>file://localhost/</xsl:text>
                        <!--<xsl:text>/</xsl:text>-->
                        <!--<xsl:value-of select="substring-before(translate($path,'\','/'), '/monograph-type')"/>
                            <xsl:value-of select="substring-after($link-target, '../')"/>-->
                        <xsl:value-of select="translate($path,'\','/')"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="$link-target"/>
                    </xsl:variable>
                    <xsl:element name="evidence-score">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$item-count"/>
                        </xsl:attribute>
                        <xsl:copy-of select="document($filename)//evidence-score/@*[name()!='xsi:noNamespaceSchemaLocation']"/>
                        <xsl:processing-instruction name="filename">
                            <xsl:value-of select="$filename"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="target">
                            <xsl:value-of select="$link-target"/>
                        </xsl:processing-instruction>
                        <xsl:processing-instruction name="position">
                            <xsl:value-of select="$item-count"/>
                        </xsl:processing-instruction>
                        <xsl:copy-of select="document($filename)//evidence-score/node()"/>    
                    </xsl:element>
                    <xsl:call-template name="process-evidence-score-links">
                        <xsl:with-param name="item-count" select="$item-count + 1"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="process-evidence-score-links">
                        <xsl:with-param name="item-count" select="$item-count"/>
                        <xsl:with-param name="link-index" select="$link-index + 1"/>
                        <xsl:with-param name="link-count" select="$link-count"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>

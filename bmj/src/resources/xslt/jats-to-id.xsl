<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    exclude-result-prefixes="xs"
    version="2.0">
     
     <xsl:output indent="no"/>
     <xsl:strip-space elements="*"/>
     
     <xsl:template match="node()">
          <xsl:copy copy-namespaces="no">
               <xsl:apply-templates select="node()"/>
          </xsl:copy>
     </xsl:template>
    
    <!-- Create citation-info -->
    <xsl:template name="add-citation-info">
        <xsl:element name="citation-info">
            <xsl:text>Cite this as: </xsl:text>
            <xsl:element name="italic">
                <xsl:value-of select="/article/front/journal-meta/journal-id[@journal-id-type='nlm-ta']"/>
            </xsl:element>
            <xsl:text> </xsl:text>
            <xsl:value-of select="/article/front/article-meta/pub-date/year"/>
            <xsl:text>;</xsl:text>
            <xsl:choose>
                <xsl:when test="string-length(normalize-space(/article/front/article-meta/volume)) !=0">
                    <xsl:value-of select="/article/front/article-meta/volume"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>[VOLNO]</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>:</xsl:text>
            <xsl:choose>
                <xsl:when test="/article/front/article-meta/elocation-id">
                    <xsl:value-of select="/article/front/article-meta/elocation-id"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>ERROR NEED ELOCATION ID</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="references">
        <xsl:for-each select="//ref">
            <xsl:element name="ref-citation">
                <xsl:value-of select="mixed-citation"/>
            </xsl:element>
            <xsl:text>&#x0A;</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
     
     
     <!-- /////////////////////////////////////////////////////// -->
     <!-- ****************** Front & Metadata ******************* -->
     <!-- /////////////////////////////////////////////////////// -->
     <xsl:template match="article">
          <xsl:element name="article">
               <xsl:attribute name="id">
                    <xsl:value-of select="//article-id[@pub-id-type='publisher-id']"/>
               </xsl:attribute>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="front">
                   <xsl:text>&#x0A;</xsl:text>
                    <xsl:apply-templates select="front"/>
                   <xsl:text>&#x0A;</xsl:text>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="flow">
                   <xsl:text>&#x0A;</xsl:text>
                    <xsl:apply-templates select="body"/>
                   <xsl:call-template name="references"/>
                   <!-- Add citation info -->
                   <xsl:call-template name="add-citation-info"/>
                   <xsl:text>&#x0A;</xsl:text>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:call-template name="floats"/>
          </xsl:element>
     </xsl:template>
     
     <xsl:template match="front">
          <xsl:apply-templates/>
     </xsl:template>
     
     <xsl:template match="article-meta">
          <xsl:apply-templates/>
     </xsl:template>
     
     <xsl:template match="article-id"/>
     <xsl:template match="history"/>
     <xsl:template match="journal-meta"/>
     
     
     <xsl:template match="title-group">
          <xsl:apply-templates/>
     </xsl:template>
     
     <xsl:template match="article-categories">
          <xsl:apply-templates select="series-title" />
          <xsl:text>&#x0A;</xsl:text>
          <xsl:apply-templates select="./parent::article-categories/following-sibling::title-group/article-title"/>
     </xsl:template>
     
     <xsl:template match="author-notes"/>
     
     <xsl:template match="contrib-group">
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="author">
               <xsl:text>&#x0A;</xsl:text>
               <xsl:for-each select="contrib">
               <xsl:element name="contrib">
                         <xsl:apply-templates/>
                     <xsl:if test=".[following-sibling::contrib]">
                         <xsl:text>,&#x00A0;</xsl:text>
                     </xsl:if>
               </xsl:element>
               </xsl:for-each>
               <xsl:text>&#x0A;</xsl:text>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="addresses">
               <xsl:for-each select="aff">
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:element name="aff">
                         <xsl:apply-templates/>
                    </xsl:element>
               </xsl:for-each>
               <xsl:for-each select="./following-sibling::author-notes">
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>&#x0A;</xsl:text>
               </xsl:for-each>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="contrib/name">
          <xsl:element name="name">
               <xsl:element name="given-name">
                    <xsl:value-of select="given-names"/>
               </xsl:element>
               <xsl:text>&#x00A0;</xsl:text>
               <xsl:element name="surname">
                    <xsl:value-of select="surname"/>
               </xsl:element>
          </xsl:element>
     </xsl:template>
     
     <xsl:template match="pub-date"/>
     <xsl:template match="volume"/>
     <xsl:template match="elocation-id"/>
     <xsl:template match="permissions"/>
     <xsl:template match="list">
          <xsl:apply-templates/>
     </xsl:template>
     <xsl:template match="list-item">
          <xsl:apply-templates/>
     </xsl:template>
     <!--/////////////////////////////////////////////////////////-->
     
     
     
     
     <!-- /////////////////////////////////////////////////////// -->
     <!-- ************************ Body ************************* -->
     <!-- /////////////////////////////////////////////////////// -->
     
     <xsl:template match="body">
          <xsl:apply-templates/>
     </xsl:template>
     
     <xsl:template match="caption">
          <xsl:element name="caption">
               <xsl:apply-templates/>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="caption[parent::table-wrap]">
          <xsl:element name="table-wrap-caption">
               <xsl:apply-templates/>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="italic[ancestor::article-title]">
          <xsl:element name="italic-title">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     
     <xsl:template match="label">
          <xsl:element name="label">
               <xsl:apply-templates/>
          </xsl:element>
          <xsl:text>&#x00A0;</xsl:text>
     </xsl:template>
     
     <xsl:template match="label[parent::aff]">
          <xsl:element name="address-label">
               <xsl:apply-templates/>
          </xsl:element>
          <xsl:text>&#x00A0;</xsl:text>
     </xsl:template>
     
     <xsl:template match="p">
          <xsl:element name="p">
               <xsl:apply-templates/>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="p[ancestor::list][not(ancestor::boxed-text)]">
          <xsl:element name="p-{./parent::list-item/parent::list/@list-type}-list">
               <xsl:apply-templates/>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="p[ancestor::list[parent::boxed-text|ancestor::boxed-text]]">
          <xsl:element name="p-box-{./parent::list-item/parent::list/@list-type}-list">
               <xsl:apply-templates/>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="p[1][not(ancestor::boxed-text)]">
          <xsl:element name="p-1">
               <xsl:apply-templates/>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="p[position()>1][not(ancestor::boxed-text)]">
          <xsl:element name="p">
               <xsl:apply-templates/>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="sec">
          <xsl:apply-templates/>
     </xsl:template>
     
     <xsl:template match="title[parent::caption]">
          <xsl:if test=".[not(parent::caption[preceding-sibling::label])]">
               <xsl:element name="box-title">
                    <xsl:apply-templates/>
               </xsl:element>
          </xsl:if>
          <xsl:if test=".[parent::caption[preceding-sibling::label]]">
               <xsl:element name="box-title">
                    <xsl:value-of select="./parent::caption/preceding-sibling::label"/>
                    <xsl:text>&#x00A0;</xsl:text>
                    <xsl:apply-templates/>
               </xsl:element>
          </xsl:if>
     </xsl:template>
     
     <xsl:template match="title[parent::sec[not(ancestor::boxed-text)]]">
          <xsl:element name="head-{./parent::sec/count(ancestor::sec)+1}">
               <xsl:apply-templates/>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="title[parent::sec[parent::boxed-text]]">
          <xsl:element name="box-title">
               <xsl:apply-templates/>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="ref-list"/>
     
     <xsl:template match="xref[@ref-type='fig']">
          <xsl:value-of select="text()"/>
     </xsl:template>
     
     <xsl:template match="xref[@ref-type='table']">
          <xsl:value-of select="text()"/>
     </xsl:template>
     
     <!-- //////////////////////////////////////////////////////// -->
     <!-- ************************ Floats************************* -->
     <!-- //////////////////////////////////////////////////////// -->
     
     <xsl:template match="boxed-text">
          <xsl:element name="typesetter-note">PLACE BOXED TEXT <xsl:value-of select="@id"/> NEAR HERE</xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="boxed-text" mode="float">
          <xsl:element name="boxed-text">
               <xsl:copy-of select="@id|@content-type"/>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:apply-templates/>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="boxed-text/label"/>
     
     
     <xsl:template match="disp-quote"/>
     <xsl:template match="disp-quote" mode="float">
          <xsl:element name="disp-quote">
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     
     <xsl:template match="fig">
          <xsl:element name="typesetter-note">PLACE FIGURE <xsl:value-of select="@id"/> NEAR HERE</xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     <xsl:template match="fig" mode="float">
          <xsl:element name="fig">
               <xsl:copy-of select="@id"/>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="typesetter-note">USE GRAPHIC <xsl:value-of select="graphic/@xlink:href"/></xsl:element>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="fig-caption">
                    <xsl:if test="label">
                         <xsl:value-of select="label"/><xsl:text>| </xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="caption/p/child::node()"/>
               </xsl:element>
               <xsl:text>&#x0A;</xsl:text>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="table-wrap">
          <xsl:element name="typesetter-note">PLACE TABLE <xsl:value-of select="@id"/> NEAR HERE</xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="table-wrap" mode="float">
          <xsl:element name="table-wrap">
               <xsl:copy-of select="@id"/>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:apply-templates mode="float"/>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="table-wrap/label" mode="float"/>
     
     <xsl:template match="table-wrap/caption" mode="float">
          <xsl:element name="table-wrap-caption">
               <xsl:if test=".[preceding-sibling::label]">
                     <xsl:value-of select="preceding-sibling::label"/><xsl:text>| </xsl:text>
               </xsl:if>
               <xsl:apply-templates select="p/child::node()"/>
          </xsl:element>
     </xsl:template>
     
     <xsl:template match="col"/>
     
     <xsl:template match="thead|tbody|tr">
          <xsl:apply-templates/>
     </xsl:template>
     
     <xsl:template match="table"/>
     
     <xsl:template match="table" mode="float">
          <xsl:element name="Table" 
               xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/">
               <xsl:attribute name="aid:table">
                    <xsl:text>table</xsl:text>
               </xsl:attribute>
               <xsl:attribute name="aid:tcols">
                    <xsl:value-of select="count(col)"/>
               </xsl:attribute>
               <xsl:attribute name="aid:trows">
                    <xsl:value-of select="count(//tr)"/>
               </xsl:attribute>
               <xsl:attribute name="aid5:tablestyle">
                    <xsl:text>Table1</xsl:text>
               </xsl:attribute>
               <xsl:apply-templates/>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
     </xsl:template>
     
     <xsl:template match="th">
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="Cell"
               xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/">
               <xsl:attribute name="aid:table">
                    <xsl:text>cell</xsl:text>
               </xsl:attribute>
               <xsl:attribute name="aid:ccols">
                    <xsl:value-of select="@colspan"/>
               </xsl:attribute>
               <xsl:attribute name="aid:crows">
                    <xsl:value-of select="@rowspan"/>
               </xsl:attribute>
               <xsl:attribute name="aid5:cellstyle">
                    <xsl:text>head</xsl:text>
               </xsl:attribute>
               <xsl:attribute name="aid:theader"/>
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     
     <xsl:template match="td">
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="Cell"
               xmlns:aid="http://ns.adobe.com/AdobeInDesign/4.0/" xmlns:aid5="http://ns.adobe.com/AdobeInDesign/5.0/">
               <xsl:attribute name="aid:table">
                    <xsl:text>cell</xsl:text>
               </xsl:attribute>
               <xsl:attribute name="aid:ccols">
                    <xsl:value-of select="@colspan"/>
               </xsl:attribute>
               <xsl:attribute name="aid:crows">
                    <xsl:value-of select="@rowspan"/>
               </xsl:attribute>
               <xsl:if test=".[not(@TableSubHead)]">
                    <xsl:attribute name="aid5:cellstyle">
                         <xsl:text>body</xsl:text>
                    </xsl:attribute>
               </xsl:if>
               <xsl:if test=".[@TableSubHead]">
                    <xsl:attribute name="aid5:cellstyle">
                         <xsl:text>subhead</xsl:text>
                    </xsl:attribute>
               </xsl:if>
               <xsl:apply-templates/>
          </xsl:element>
     </xsl:template>
     
     <xsl:template match="table-wrap-foot" mode="float">
               <xsl:for-each select="fn">
                    <xsl:element name="table-wrap-foot-p">
                         <xsl:value-of select="label"/>
                         <xsl:apply-templates select="p/node()"/>
                    </xsl:element>
                    <xsl:text>&#x0A;</xsl:text>
               </xsl:for-each>
     </xsl:template>
     
     <xsl:template name="floats">
         <xsl:text>&#x0A;</xsl:text>
          <xsl:if test="//boxed-text|//disp-quote|//fig|//table-wrap">
               <xsl:element name="floats">
                    <xsl:text>&#x0A;</xsl:text>
                    <xsl:apply-templates select="//boxed-text" mode="float"/>
                    <xsl:apply-templates select="//disp-quote" mode="float"/>
                    <xsl:apply-templates select="//fig" mode="float"/>
                    <xsl:apply-templates select="//table-wrap" mode="float"/>
               </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
          </xsl:if>
     </xsl:template>
    
    
</xsl:stylesheet>

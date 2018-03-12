<?xml version='1.0' encoding='ISO-8859-1'?>

<!-- =============================================================== -->
<!--                                                                 -->
<!-- Convert XSL FO (as in REC 2001-10-15) to HTML                    -->
<!--                                                                 -->
<!-- © RenderX 2000-2001                                             -->
<!-- Permission to copy and modify is granted, provided this notice  -->
<!-- is included in all copies and/or derived work.                  -->
<!--                                                                 -->
<!-- Author: Nikolai Grigoriev, grig@renderx.com                     -->
<!--                                                                 -->
<!-- "Modified" by Chris Standing for specific                       -->
<!-- use rendering BMJ Best Practice FO XML (2016-08)                -->
<!-- =============================================================== -->


<!DOCTYPE xsl:stylesheet [
  <!ENTITY anchor "<xsl:apply-templates select='@id' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'/>">
  <!ENTITY add-style "<xsl:call-template name='add-style-attribute' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'/>">
]>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                exclude-result-prefixes="fo">

<xsl:output method="xhtml"
            encoding="utf-8"
            indent="yes"/>
    
<xsl:strip-space elements="*"/>
    
    <xsl:param name="language"/>
    <xsl:param name="file-number"/>

<!-- =============================================================== -->
<!-- Root. Create the bone and call templates for each page sequence -->
<!-- =============================================================== -->

<xsl:template match="fo:root">
  <html>
    <head>
      <title>
        <xsl:choose>
          <xsl:when test="descendant::fo:title[1]">
            <xsl:value-of select="fo:title"/>
          </xsl:when>
          <xsl:otherwise>BP FO Document</xsl:otherwise>
        </xsl:choose>
      </title>
      <META http-equiv="Content-Style-Type" content="text/css"/>
        <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro' rel='stylesheet' type='text/css'></link>
        <link href='http://fonts.googleapis.com/css?family=Lato' rel='stylesheet' type='text/css'></link>
      <style type="text/css">
         a { border: none; color: black; text-decoration: none; }
         body { font-family: "Lato"; padding-left: 50px; padding-right: 50px; }
         div { font-family: inherit; font-size: inherit;}
         h1 { font-family: "Lato"; font-size:18pt;}
         h2 { font-family: "Lato";}
         img { border: none; font-size: inherit;}
         li { margin-top:5px; margin-bottom:5px; }
         span { font-family: "Lato";}
         td { font-size:10pt; padding:5px;}
         ul { margin-top:20px; margin-bottom:20px; }
      </style>
    </head>

    <body>
      <xsl:apply-templates select="fo:page-sequence"/>
    </body>
  </html>

</xsl:template>

<!-- =============================================================== -->
<!-- fo:page-sequence. Draws a header before and a footer after.     -->
<!-- Sidebars are skipped: there's no way to rotate the text in HTML -->
<!-- and horizontal text in the sidebars eats up too much space.     -->
<!-- =============================================================== -->

<xsl:template match="fo:page-sequence">

    <xsl:variable name="current-master"><xsl:value-of select="@master-reference"/></xsl:variable>

    <!-- One page master will be used for the whole page sequence -->
    <xsl:variable name="page-master-name">
      <xsl:choose>
        <xsl:when test="../fo:layout-master-set/fo:simple-page-master[@master-name=$current-master]">
          <!-- specified master is a page master: use it -->
          <xsl:value-of select="$current-master"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- specified master is a page sequence master: -->
          <!-- find master name for the first page -->
          <xsl:apply-templates select="../fo:layout-master-set/fo:page-sequence-master[@master-name=$current-master]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Load the page master into a variable. No problem if it's null; should work the same ;-) -->
    <xsl:variable name="page-master" select="../fo:layout-master-set/fo:simple-page-master[@master-name=$page-master-name]"/>


    <!-- Start real drawing -->
    <!--<br/>  <!-\- make an offset before each page sequence -\->-->

    <!-- Header -->
    <xsl:if test="fo:static-content[@flow-name='even-page-header']">
        <br/>
        <h1>
            <xsl:attribute name="style">
                <xsl:text>font-size: 22pt; font-weight: bold; color: #cadce7;</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="fo:static-content[@flow-name='even-page-header']//fo:table-cell[last()]/fo:block/text()"/>
        </h1>
    </xsl:if>
    

    <!-- Body -->
    <xsl:apply-templates select="fo:flow">
      <xsl:with-param name="region" select="$page-master/fo:region-body"/>
    </xsl:apply-templates>
    

    <!-- Footer -->
    <!--<xsl:variable name="footer-region" select="$page-master/fo:region-after"/>
    <xsl:apply-templates select="fo:static-content[@flow-name = $footer-region/@region-name
                              or (@flow-name='xsl-region-after' and not($footer-region/@region-name))]">
      <xsl:with-param name="region" select="$footer-region"/>
    </xsl:apply-templates>-->

    <!--<br/>  <!-\- make an offset after each page sequence -\->-->
    
</xsl:template>

<xsl:template match="fo:page-sequence[@master-reference='content-disclaimer']"/>
    
    
    
<!-- ============================== -->
<!-- =========== Summary ========== -->
<!-- ============================== -->


<xsl:template match="fo:page-sequence[@master-reference='summary-page']/fo:flow/fo:block-container/fo:block/fo:inline">
    <p style="font-size: 18pt; font-family: 'InterFace DaMa';">
        <xsl:apply-templates select="text()"/>
    </p>
</xsl:template>
    
<xsl:template match="fo:page-sequence[@master-reference='summary-page']/fo:flow/fo:block[1]/fo:block">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="fo:page-sequence[@master-reference='toc-page']"/>


<!-- =============================================================== -->
<!-- =========  fo:block (modified for BMJ Best Practice) ========== -->
<!-- =============================================================== -->

<!-- Blocks to be removed -->
<xsl:template match="fo:block[fo:external-graphic][ancestor::fo:page-sequence[@master-reference='first-page']]"/>
<xsl:template match="fo:block[child::fo:leader]"/>
<xsl:template match="fo:block[@id='treatment-details-overview-id']"/>
<xsl:template match="fo:block[preceding-sibling::fo:block[1][@id='treatment-details-overview-id']]"/>
<xsl:template match="fo:block[preceding-sibling::fo:block[1]/preceding-sibling::fo:block[1][@id='treatment-details-overview-id']]"/>

    
<!-- Choices to treat specific blocks differently (for spacing, styling, converting to specific HTML elements and for exclusion) -->
<xsl:template match="fo:block">
    <xsl:choose>
        
        <xsl:when test=".[@id][not(child::node())]">
            <div>
                <a>
                    <xsl:attribute name="name">
                        <xsl:value-of select="@id"/>
                    </xsl:attribute>
                </a>
            </div>
        </xsl:when>
        
        <xsl:when test=".[ancestor::fo:flow[child::fo:block[@id='images-id']]][text()]">
            <p>
                <xsl:value-of select="text()"/>
            </p>
        </xsl:when>
        
        <xsl:when test=".[@font-size='45pt'][ancestor::fo:page-sequence[@master-reference='first-page']]">
            <div>
                <xsl:attribute name="style">
                    <xsl:text>background-color:#FFFFFF; color:#000000; font-family: "Lato"; font-size:45pt; font-weight:bold; text-align:center; margin-left:10px; margin-right:10px; padding:10px;</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates select="fo:block/text()"/>
            </div>
        </xsl:when>
        
        <xsl:when test=".[text()[contains(.,'Diagnosis criteria')]]">
            <xsl:apply-templates/>
        </xsl:when>
        
        <xsl:when test=".[@font-size='18pt']">
            <xsl:if test=".[preceding-sibling::fo:block[child::fo:list-block]]">
                <br/>
            </xsl:if>
     &anchor;<h2>&add-style;
            <xsl:apply-templates select="fo:inline"/>
            </h2>
        </xsl:when>
        
        <xsl:when test=".[@font-size='16pt']">
            <xsl:if test=".[preceding-sibling::fo:block[child::fo:list-block]]">
                <br/>
            </xsl:if>
            <xsl:if test=".[not(preceding-sibling::fo:block)]">
                <div style="margin-bottom: 14pt;"></div>
            </xsl:if>
    &anchor;<h3>&add-style;
                <xsl:apply-templates/>
            </h3>
        </xsl:when>
        
        <xsl:when test=".[@font-size='14pt']">
            <xsl:if test=".[preceding-sibling::fo:block[child::fo:list-block]]">
                <br/>
            </xsl:if>
            <xsl:if test=".[not(preceding-sibling::fo:block)]">
                <div style="margin-bottom: 14pt;"></div>
            </xsl:if>
    &anchor;<h4>&add-style;
                <xsl:apply-templates/>
            </h4>
        </xsl:when>
        
        <xsl:when test=".[@font-size='12pt']">
            <xsl:if test=".[preceding-sibling::fo:block[child::fo:list-block]]">
                <br/>
            </xsl:if>
            <xsl:if test=".[not(preceding-sibling::fo:block)]">
                <div style="margin-bottom: 14pt;"></div>
            </xsl:if>
    &anchor;<h5>&add-style;
                <xsl:apply-templates/>
            </h5>
        </xsl:when>
        
        <xsl:when test=".[preceding-sibling::fo:block][following-sibling::fo:block][@line-height='15pt']">
            <div>
                <xsl:apply-templates/>
            </div>
        </xsl:when>
        
        <xsl:when test=".[preceding-sibling::fo:block][parent::fo:block][@line-height='15pt']">
            <div>
                <xsl:if test=".[@space-after='10pt']">
                    <xsl:attribute name="style">
                        <xsl:text>margin-bottom: 10pt</xsl:text>
                    </xsl:attribute>
                </xsl:if>
                <xsl:apply-templates/>
            </div>
            <xsl:if test=".[@space-after='10pt']">
                <br/>
            </xsl:if>
        </xsl:when>
        
        <xsl:when test=".[parent::fo:table-cell]">
        <xsl:choose>
            <xsl:when test=".[not(@color)][parent::fo:table-cell[parent::fo:table-row[parent::fo:table-header[@font-size='14pt'][@font-weight='bold']]]]">
        &anchor;<p>
                    <xsl:attribute name="style">
                        <xsl:text>font-size: 14pt; font-weight: bold; padding-top:10px; padding-bottom:10px;</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:when test=".[@color='#2A6EBB'][parent::fo:table-cell[parent::fo:table-row[parent::fo:table-header[@font-size='14pt'][@font-weight='bold']]]]">
        &anchor;<p>
                    <xsl:attribute name="style">
                        <xsl:text>color: #2A6EBB; font-size: 14pt; font-weight: bold; padding-top:10px; padding-bottom:10px;</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
        &anchor;<p>&add-style;
                    <xsl:apply-templates mode="check-for-pre"/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:when>
        
        <xsl:when test=".[parent::fo:block[parent::fo:table-cell]]">
            &anchor;<span>&add-style;<xsl:apply-templates mode="check-for-pre"/></span>
        </xsl:when>
        
        <xsl:when test=".[parent::fo:inline]">
        &anchor;<span>&add-style;<xsl:apply-templates mode="check-for-pre"/></span>
        </xsl:when>
        
        <xsl:when test=".[child::fo:block][parent::fo:list-item-body]|.[parent::fo:block[parent::fo:list-item-body]]|.[parent::fo:list-item-body][not(child::fo:block)]">
     &anchor;<span>&add-style;
        <xsl:apply-templates/>
            </span>
        </xsl:when>
        
        <xsl:otherwise>
   &anchor;<div>&add-style;<xsl:apply-templates mode="check-for-pre"/></div>
        </xsl:otherwise>
    </xsl:choose>
    
    
</xsl:template>


<!-- =============================================================== -->
<!-- fo:inline-sequence                                              -->
<!-- =============================================================== -->

<xsl:template match="fo:inline | fo:wrapper">
  &anchor;<span>&add-style;<xsl:apply-templates/></span>
</xsl:template>

<!-- =============================================================== -->
<!-- fo:list-block                                                   -->
<!-- =============================================================== -->
    
<!--<xsl:template match="fo:block[child::fo:list-block]">
&anchor;<div>&add-style;
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
    </div>
    <br/>
</xsl:template>
    
    <xsl:template match="fo:block[preceding-sibling::fo:list-block]">
&anchor;<div>&add-style;
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
    </div>
</xsl:template>-->

<xsl:template match="fo:list-block">

  <xsl:variable name="label-separation">
    <xsl:choose>
      <xsl:when test="@provisional-label-separation">
        <xsl:apply-templates select="@provisional-label-separation"
                             mode="convert-to-pixels"/>
      </xsl:when>
      <xsl:otherwise>8</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="body-offset">
    <xsl:choose>
      <xsl:when test="@provisional-distance-between-starts">
        <xsl:apply-templates select="@provisional-distance-between-starts"
                             mode="convert-to-pixels"/>
      </xsl:when>
      <xsl:otherwise>32</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
    
      <ul style="list-style-type: none;">
          <xsl:apply-templates select="fo:list-item"/>
      </ul>
    
</xsl:template>

<!-- =============================================================== -->
<!-- ======== fo:list-item (modified for BMJ Best Practice) ======== -->
<!-- =============================================================== -->


<xsl:template match="fo:list-item">
    <li>
        <xsl:apply-templates select="fo:list-item-label|fo:list-item-body"/>
    </li>
</xsl:template>
    
<xsl:template match="fo:list-item-label">
&anchor;<span>&add-style;
        <xsl:apply-templates select="fo:block/text()"/>
    </span>
</xsl:template>

<xsl:template match="fo:list-item-body">
        <xsl:choose>
            <xsl:when test=".[child::fo:block[child::fo:block]]">
                <xsl:if test="fo:block/fo:block/@id">
                        <a>
                            <xsl:attribute name="name">
                                <xsl:value-of select="fo:block/fo:block/@id"/>
                            </xsl:attribute>
                        </a>
                </xsl:if>
        &anchor;<span>&add-style;
                    <xsl:apply-templates select="fo:block/fo:block"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="fo:block/@id">
                        <a>
                            <xsl:attribute name="name">
                                <xsl:value-of select="fo:block/@id"/>
                            </xsl:attribute>
                        </a>
                </xsl:if>
        &anchor;<span>&add-style;
                    <xsl:apply-templates select="fo:block"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
</xsl:template>

<!--<xsl:template match="fo:list-item"><!-\-
  <xsl:param name="label-width"/>
  <xsl:param name="gap-width"/>-\->

  <li>&add-style;
<!-\-    <xsl:apply-templates select="fo:list-item-label" mode="draw-cell">
       <xsl:with-param name="width" select="$label-width"/>
    </xsl:apply-templates>
    <xsl:if test="$gap-width &gt; 0">
      <td width="{$gap-width}">&#160;</td>
    </xsl:if>-\->

    <xsl:apply-templates select="fo:list-item-body" mode="draw-cell"/>
  </li>-->
<!--</xsl:template>-->

<!-- =============================================================== -->
<!-- fo:list-item-label - itemless lists                             -->
<!-- =============================================================== -->

<!--<xsl:template match="fo:list-block/fo:list-item-label">
  <xsl:param name="label-width"/>
  <xsl:param name="gap-width"/>

  <li>
 <!-\-   <xsl:apply-templates select="." mode="draw-cell">
       <xsl:with-param name="width" select="$label-width"/>
    </xsl:apply-templates>
    <xsl:if test="$gap-width &gt; 0">
      <td width="{$gap-width}">&#160;</td>
    </xsl:if>-\->

    <xsl:apply-templates select="following-sibling::fo:list-item-body[1]" mode="draw-cell"/>
  </li>
</xsl:template>-->


<!-- =============================================================== -->
<!-- fo:list-item-body - itemless lists                              -->
<!-- =============================================================== -->

<!--<xsl:template match="fo:list-item-label | fo:list-item-body" mode="draw-cell">
  <xsl:param name="width" select="'auto'"/>
  <li valign="top">&add-style;&anchor;
<!-\-    <xsl:if test="$width != 'auto'">
      <xsl:attribute name="width">
        <xsl:value-of select="$width"/>
      </xsl:attribute>
    </xsl:if>-\->

    <xsl:apply-templates mode="check-for-pre"/>
  </li>
</xsl:template>-->


<!-- =============================================================== -->
<!-- fo:table and its components  (modified for BMJ Best Practice)   -->
<!-- =============================================================== -->

<xsl:template match="fo:table">
<xsl:choose>
    
    <xsl:when test=".[ancestor::fo:page-sequence[@master-reference='toc-page']]|.[ancestor::fo:page-sequence[@master-reference='summary-page']]">
        <xsl:apply-templates/>
    </xsl:when>
    
    <xsl:when test=".[ancestor::fo:page-sequence[@master-reference='first-page']]">
        <xsl:apply-templates/>
    </xsl:when>
    
    <xsl:when test=".[parent::fo:block[parent::fo:table-cell]]">
        <xsl:apply-templates select="fo:table-body/fo:table-row/fo:table-cell[2]/fo:block/node()"/>
    </xsl:when>
    
   <!-- <xsl:when test=".[parent::fo:block[parent::fo:block[parent::fo:table-cell]]]">
        <xsl:apply-templates select="fo:table-body/fo:table-row/fo:table-cell/fo:block/node()"/>
    </xsl:when>-->
    
    
    <xsl:when test=".[@border[contains(.,'0.25')]]">
            <table>
                <xsl:attribute name="style">
                    <xsl:text>border:solid; border-width:1pt; border-color:#b7cfde; width: 100%;</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates mode="check-for-pre"/>
            </table>
    </xsl:when>
    
    <xsl:otherwise>
&anchor;<table>
                <xsl:attribute name="style">
                    <xsl:text>width: 100%;</xsl:text>
                </xsl:attribute>
            <xsl:apply-templates/>
        </table>
        <br/>
    </xsl:otherwise>
</xsl:choose>
</xsl:template>
    
<xsl:template match="fo:table-column">
<xsl:choose>
    <xsl:when test=".[ancestor::fo:page-sequence[@master-reference='toc-page']]|.[ancestor::fo:page-sequence[@master-reference='summary-page']]">
        <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
        <col>
            <xsl:attribute name="style">
                <xsl:text>width: </xsl:text>
                <xsl:value-of select="@column-width"/>
                <xsl:text>;</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </col>
    </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="fo:table-header">
    <xsl:choose>
        <xsl:when test=".[ancestor::fo:page-sequence[@master-reference='toc-page']]|.[ancestor::fo:page-sequence[@master-reference='summary-page']]">
            <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
    &anchor;<thead>&add-style;
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
            </thead>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="fo:table-footer">
    <xsl:choose>
        <xsl:when test=".[ancestor::fo:page-sequence[@master-reference='toc-page']]|.[ancestor::fo:page-sequence[@master-reference='summary-page']]">
            <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
            <tfoot>&add-style;
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
            </tfoot>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="fo:table-body">
    
      <xsl:choose>
        <xsl:when test=".[ancestor::fo:page-sequence[@master-reference='toc-page']]|.[ancestor::fo:page-sequence[@master-reference='summary-page']]">
            <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
    &anchor;<tbody>&add-style;
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
            </tbody>
        </xsl:otherwise>
    </xsl:choose>
    
  
</xsl:template>

<xsl:template match="fo:table-row">
  
  <xsl:choose>
        <xsl:when test=".[ancestor::fo:page-sequence[@master-reference='summary-page']]">
            <tr>&add-style;
                <xsl:copy-of select="@*"/>
                <span><xsl:apply-templates select="fo:table-cell[2]/fo:block/text()"/>&#x00A0;</span>
                <xsl:apply-templates select="fo:table-cell[last()]/fo:block/fo:inline"/>
            </tr>
        </xsl:when>
      <xsl:when test=".[@page-break-inside='avoid'][@font-size='14pt']">
            <tr>&add-style;
              <xsl:apply-templates mode="display"/>
            </tr>
        </xsl:when>
      <xsl:when test=".[@border[contains(.,'0.25')]]">
            <tr>
                <xsl:attribute name="style">
                    <xsl:text>border:solid; border-width:1pt; border-color:#b7cfde;</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates mode="display"/>
            </tr>
    </xsl:when>
        <xsl:otherwise>
            <tr>&add-style;
              <xsl:apply-templates mode="display"/>
            </tr>
        </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="fo:table-cell" mode="display">
    <xsl:choose>
        <xsl:when test=".[parent::fo:table-row[not(preceding-sibling::fo:table-row)]][ancestor::fo:table-header[@background-color='#2A6EBB']]">
            <td>
                <xsl:attribute name="style">
                    <xsl:text>background-color: #2A6EBB; color: #FFFFFF</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates mode="check-for-pre"/>
            </td>
        </xsl:when>
        
        <xsl:when test=".[@border[contains(.,'0.25')]]">
            <td>
                <xsl:attribute name="text-align">
                    <xsl:value-of select="@text-align"/>
                </xsl:attribute>
                <xsl:attribute name="style">
                    <xsl:text>border:solid; border-width:1pt; border-color:#b7cfde;</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates mode="check-for-pre"/>
            </td>
        </xsl:when>
        
        <xsl:otherwise>
        <td>&add-style;
            <xsl:if test="not(@display-align)">
                <xsl:attribute name="valign">top</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@*" mode="get-table-attributes"/>
            <xsl:apply-templates mode="check-for-pre"/>
        </td>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="fo:table-cell" priority="-1"/>

<!-- This template accounts for "rowless" tables -->
<xsl:template priority="1"
              match="fo:table-cell[not(parent::fo:table-row)]
              [not(preceding-sibling::fo:table-cell) or @starts-row='true'
               or preceding-sibling::fo:table-cell[1][@ends-row='true']]">
  <tr>
    <xsl:call-template name="enumerate-rowless-cells"/>
  </tr>
</xsl:template>

<xsl:template name="enumerate-rowless-cells">
  <xsl:apply-templates select="." mode="display"/>
  <xsl:if test="not(@ends-row='true')">
    <xsl:for-each select="following-sibling::fo:table-cell[1]
                          [not(@starts-row='true')]">
      <xsl:call-template name="enumerate-rowless-cells"/>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<!-- =============================================================== -->
<!-- fo:inline-graphic                                               -->
<!-- =============================================================== -->

<!--<xsl:template match="fo:external-graphic">
  <xsl:variable name="cleaned-url">
    <xsl:apply-templates select="@src" mode="unbracket-url"/>
  </xsl:variable>
  &anchor;<img src="{$cleaned-url}"><xsl:apply-templates select="@height|@width|@*[starts-with(name(),'border')]"/></img>
</xsl:template>-->


<xsl:template match="fo:external-graphic[ancestor::fo:flow[fo:block[@id='images-id']]]">
    <p>
        <a style="color: #2a6ebb;">
            <xsl:attribute name="href">
                <xsl:if test="$language = 'az-az'">
                    <xsl:text>http://azerbaijan.bestpractice.bmj.com/best-practice/images/bp/</xsl:text>
                </xsl:if>
                <xsl:if test="$language = 'en-gb'">
                    <xsl:text>http://bestpractice.bmj.com/best-practice/images/bp/</xsl:text>
                </xsl:if>
                <xsl:if test="$language = 'en-us'">
                    <xsl:text>http://us.bestpractice.bmj.com/best-practice/images/bp/</xsl:text>
                </xsl:if>
                <xsl:if test="$language = 'es-es'">
                    <xsl:text>http://es.bestpractice.bmj.com/best-practice/images/bp/</xsl:text>
                </xsl:if>
                <xsl:if test="$language = 'ka-ge'">
                    <xsl:text>http://georgia.bestpractice.bmj.com/best-practice/images/bp/</xsl:text>
                </xsl:if>
                <xsl:if test="$language = 'pt-br'">
                    <xsl:text>http://brasil.bestpractice.bmj.com/best-practice/images/bp/</xsl:text>
                </xsl:if>
                <xsl:if test="$language = 'pt-pt'">
                    <xsl:text>http://portugal.bestpractice.bmj.com/best-practice/images/bp/</xsl:text>
                </xsl:if>
                <xsl:if test="$language = 'uk-ua'">
                    <xsl:text>http://ukraine.bestpractice.bmj.com/best-practice/images/bp/</xsl:text>
                </xsl:if>
                <xsl:if test="$language = 'zh-cn'">
                    <xsl:text>http://china.bestpractice.bmj.com/best-practice/images/bp/</xsl:text>
                </xsl:if>
                <xsl:value-of select="$language"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$file-number"/>
                <xsl:value-of select="replace(@src,'^(.+)(\d+)(\-)(\d+)(\D)(.+)(\.)(\w+)(.+)','$3$4$5$6$7$8')"/>
            </xsl:attribute>
            <xsl:text>(</xsl:text><xsl:value-of select="replace(@src,'^(url)(\D+)(.+)(\.\w+)(.+)','$3$4')"/><xsl:text>)</xsl:text>
        </a>
    </p>
    <br/>
</xsl:template>

<!-- =============================================================== -->
<!-- fo:basic-link                                                  -->
<!-- =============================================================== -->

<xsl:template match="fo:basic-link[@external-destination]">

  <xsl:variable name="cleaned-url">
    <xsl:apply-templates select="@external-destination" mode="unbracket-url"/>
  </xsl:variable>

&anchor;<a href="{$cleaned-url}">&add-style;
      <xsl:apply-templates/>
        </a>
</xsl:template>

<xsl:template match="fo:basic-link[@internal-destination]">
  &anchor;<a href="#{@internal-destination}">&add-style;<xsl:apply-templates/></a>
</xsl:template>


<!-- =============================================================== -->
<!-- fo:marker/fo:retrieve-marker                                    -->
<!-- =============================================================== -->

<xsl:template match="fo:marker"/>
<xsl:template match="fo:marker" mode="retrieve-marker">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="fo:retrieve-marker">

  <xsl:variable name="class-name" select="@retrieve-class-name"/>
  <xsl:variable name="matching-markers"
                select="ancestor::fo:page-sequence/descendant::fo:marker[@marker-class-name=$class-name]"/>

  <xsl:choose>
    <xsl:when test="@retrieve-position='last-starting-within-page'
                 or @retrieve-position='last-ending-within-page'">
      <xsl:apply-templates select="$matching-markers[position()=last()]" mode="retrieve-marker"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$matching-markers[1]" mode="retrieve-marker"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>





<!-- *************************************************************** -->
<!-- Treatment of attributes that are either identical to their CSS1 -->
<!-- counterparts, of find an equivalent expression there            -->

<!-- =============================================================== -->
<!-- Default rule: copy CSS1 attributes and suppress all other       -->
<!-- =============================================================== -->

<xsl:template match="@*" priority="-2" mode="collect-style-attributes"/>

<xsl:template match="@color |
                     @background |
                     @background-color |
                     @background-image |
                     @background-position |
                     @background-repeat |
                     @padding |
                     @padding-top |
                     @padding-bottom |
                     @padding-right |
                     @padding-left |
                     @margin |
                     @margin-top |
                     @margin-bottom |
                     @margin-right |
                     @margin-left |
                     @border |
                     @border-top |
                     @border-bottom |
                     @border-right |
                     @border-left |
                     @border-width |
                     @border-top-width |
                     @border-bottom-width |
                     @border-right-width |
                     @border-left-width |
                     @border-color |
                     @border-top-color |
                     @border-bottom-color |
                     @border-right-color |
                     @border-left-color |
                     @border-style |
                     @border-top-style |
                     @border-bottom-style |
                     @border-right-style |
                     @border-left-style |
                     @letter-spacing |
                     @word-spacing |
                     @line-height |
                     @font |
                     @font-family |
                     @font-size |
                     @font-weight |
                     @font-style |
                     @font-variant |
                     @vertical-align |
                     @text-decoration |
                     @text-indent |
                     @text-transform"
                     mode="collect-style-attributes">
  <xsl:value-of select="name()"/>
  <xsl:text>: </xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>; </xsl:text>
</xsl:template>

<!-- =============================================================== -->
<!-- Some attributes deserve special treatment -->

<xsl:template match="@text-align" mode="collect-style-attributes">
  <xsl:text>text-align: </xsl:text>
  <xsl:choose>
    <xsl:when test=".='start' or .='inside'">left</xsl:when>
    <xsl:when test=".='end' or .='outside'">right</xsl:when>
    <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
  </xsl:choose>
  <xsl:text>; </xsl:text>
</xsl:template>

<!-- =============================================================== -->
<!-- Handling writing-mode in borders, padding, and margins          -->
<!-- This version presumes lr-tb writing mode only.                  -->

<xsl:template match="@space-before.optimum |
                     @space-before [not (../@space-before.optimum)] |
                     @space-before.minimum [not (../@space-before.optimum) and not (../@space-before)] |
                     @space-before.maximum [not (../@space-before.optimum) and not (../@space-before) and not (../@space-before.minimum)] |
                     @space-after.optimum |
                     @space-after [not (../@space-after.optimum)] |
                     @space-after.minimum [not (../@space-after.optimum) and not (../@space-after)] |
                     @space-after.maximum [not (../@space-after.optimum) and not (../@space-after) and not (../@space-after.minimum)] |
                     @space-start.optimum |
                     @space-start [not (../@space-start.optimum)] |
                     @space-start.minimum [not (../@space-start.optimum) and not (../@space-start)] |
                     @space-start.maximum [not (../@space-start.optimum) and not (../@space-start) and not (../@space-start.minimum)] |
                     @space-end.optimum |
                     @space-end [not (../@space-end.optimum)] |
                     @space-end.minimum [not (../@space-end.optimum) and not (../@space-end)] |
                     @space-end.maximum [not (../@space-end.optimum) and not (../@space-end) and not (../@space-end.minimum)] |
                     @start-indent[not(parent::fo:list-item-body)] |
                     @end-indent[not(parent::fo:list-item-label)] |
                     @padding-before |
                     @padding-before.length |
                     @margin-before |
                     @border-before |
                     @border-before-width |
                     @border-before-width.length |
                     @border-before-color |
                     @border-before-style |
                     @padding-after |
                     @padding-after.length |
                     @margin-after |
                     @border-after |
                     @border-after-width |
                     @border-after-width.length |
                     @border-after-color |
                     @border-after-style |
                     @padding-start |
                     @padding-start.length |
                     @margin-start |
                     @border-start |
                     @border-start-width |
                     @border-start-width.length |
                     @border-start-color |
                     @border-start-style |
                     @padding-end |
                     @padding-end.length |
                     @margin-end |
                     @border-end |
                     @border-end-width |
                     @border-end-width.length |
                     @border-end-color |
                     @border-end-style"
              mode="collect-style-attributes">

  <xsl:variable name="property">
    <xsl:choose>
      <xsl:when test="starts-with(name(), 'border')">border</xsl:when>
      <xsl:when test="starts-with(name(), 'padding')">padding</xsl:when>
      <xsl:when test="starts-with(name(), 'margin')">margin</xsl:when>
      <xsl:when test="starts-with(name(), 'space')">margin</xsl:when>
      <xsl:when test="contains(name(), '-indent')">margin</xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="side">
    <xsl:choose>
      <xsl:when test="contains(name(), '-before') or contains(name(), '-top')">-top</xsl:when>
      <xsl:when test="contains(name(), '-after') or contains(name(), '-bottom')">-bottom</xsl:when>
      <xsl:when test="contains(name(), '-start') or starts-with(name(), 'start-') or contains(name(), '-left')">-left</xsl:when>
      <xsl:when test="contains(name(), '-end') or starts-with(name(), 'end-') or contains(name(), '-right')">-right</xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="parameter">
    <xsl:choose>
      <xsl:when test="contains(name(), '-width')">-width</xsl:when>
      <xsl:when test="contains(name(), '-color')">-color</xsl:when>
      <xsl:when test="contains(name(), '-style')">-style</xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="concat($property, $side, $parameter)"/>
  <xsl:text>: </xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>; </xsl:text>
</xsl:template>

<xsl:template match="*" mode="check-for-pre" priority="-1">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="*[@white-space-collapse='false'
                    or @linefeed-treatment='preserve'
                    or @wrap-option='no-wrap'
                    or @white-space='pre']"
                     mode="check-for-pre">
  <pre><xsl:apply-templates select="."/></pre>
</xsl:template>

<!-- =============================================================== -->
<!-- Recalculate a length to pixels. 1 in = 96 px, 1 em = 1 pc;      -->
<!-- this gives reasonable results for 800x600 and 1024x768 screens  -->
<!-- =============================================================== -->

<xsl:template match="@*" mode="convert-to-pixels">
  <xsl:variable name="scaling-factor">
    <xsl:choose>
      <xsl:when test="contains (., 'pt')">1.33</xsl:when>
      <xsl:when test="contains (., 'px')">1</xsl:when>
      <xsl:when test="contains (., 'pc')">16</xsl:when>
      <xsl:when test="contains (., 'in')">96</xsl:when>
      <xsl:when test="contains (., 'cm')">37.8</xsl:when>
      <xsl:when test="contains (., 'mm')">3.78</xsl:when>
      <xsl:when test="contains (., 'em')">16</xsl:when> <!-- guess: 1em = 12pt -->
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="numeric-value"
       select="translate (., '-0123456789.ptxcinme', '-0123456789.')"/>
  <xsl:value-of select="number($numeric-value) * number($scaling-factor)"/>
</xsl:template>

<!-- =============================================================== -->
<!-- Remove brackets & quotes around URLs                            -->
<!-- =============================================================== -->

<xsl:template match="@*" mode="unbracket-url">
  <xsl:variable name="href" select="normalize-space(.)"/>

  <xsl:choose>
    <xsl:when test="(starts-with($href, 'url(') or starts-with($href, 'url ('))
                     and substring ($href, string-length($href)) = ')'">
      <!-- Remove 'url' from the beginning -->
      <xsl:variable name="bracketed"
           select="normalize-space(substring($href, 4))"/>
      <!-- Remove brackets -->
      <xsl:variable name="quoted"
           select="normalize-space(substring($bracketed, 2, string-length ($bracketed) - 2 ))"/>

      <xsl:variable name="q" select="'&quot;'"/>
      <xsl:variable name="a" select='"&apos;"'/>
      <!-- Remove optional quotes -->
      <xsl:choose>
        <xsl:when test="( substring($quoted, 1, 1) = $q and
                          substring($quoted, string-length($quoted), 1) = $q )
                     or ( substring($quoted, 1, 1) = $a and
                          substring($quoted, string-length($quoted), 1) = $a )">
          <xsl:value-of select="substring($quoted, 2, string-length($quoted) - 2)"/>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$quoted"/></xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- =============================================================== -->
<!-- Page number - replace by a bullet                               -->
<!-- =============================================================== -->

<xsl:template match="fo:page-number | fo:page-number-citation">
  <span>&add-style;<xsl:text>&#x2022;</xsl:text></span>
</xsl:template>

<!-- =============================================================== -->
<!-- Leader - replace by a space                                     -->
<!-- =============================================================== -->

<xsl:template match="fo:leader">
  <xsl:text> &#xA0;&#xA0;&#xA0; </xsl:text>
</xsl:template>



<!-- =============================================================== -->
<!-- Static content - add a <hr/> before or after it                 -->
<!-- =============================================================== -->

<xsl:template match="fo:flow | fo:static-content">
    <xsl:param name="region"/>
    <xsl:choose>
        <xsl:when test=".[parent::fo:page-sequence[@master-reference='first-page']]">
            <div>
                <xsl:apply-templates/>
            </div>
        </xsl:when>
        <xsl:when test=".[@flow-name='even-page-header']">
            <div>&add-style;
                <xsl:apply-templates/>
            </div>
        </xsl:when>
        <xsl:otherwise>
            <div>
              <xsl:apply-templates select="$region"/>
              <xsl:apply-templates/><!--
              <xsl:if test=".//fo:footnote">
                <br/><hr/>
                <xsl:apply-templates select=".//fo:footnote" mode="after-text"/>
              </xsl:if>-->
            </div>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- =============================================================== -->
<!-- Footnotes                                                       -->
<!-- =============================================================== -->

<xsl:template match="fo:footnote">
  <xsl:apply-templates select="fo:inline"/>
</xsl:template>

<xsl:template match="fo:footnote" mode="after-text">
  <div>&add-style;&anchor;
    <xsl:apply-templates select="fo:footnote-body"/>
  </div>
</xsl:template>

<!-- =============================================================== -->
<!-- Copy all CSS1-compatible attributes to "style" property         -->
<!-- =============================================================== -->

<xsl:template name="add-style-attribute">
  <xsl:param name="orientation" select="0"/>
  <xsl:variable name="style">
    <xsl:apply-templates select="@*" mode="collect-style-attributes"/>
  </xsl:variable>

  <xsl:if test="string-length($style) &gt; 0">
    <xsl:attribute name="style"><xsl:value-of select="normalize-space($style)"/></xsl:attribute>
  </xsl:if>
</xsl:template>

<!-- =============================================================== -->
<!-- Create an anchor                                                -->
<!-- =============================================================== -->

<xsl:template match="@id"><a name="{.}"/></xsl:template>

<!-- =============================================================== -->
<!-- Table cell geometry                                             -->
<!-- =============================================================== -->

<xsl:template match="@*" mode="get-table-attributes" priority="-1"/>

<xsl:template match="@number-columns-spanned"
                     mode="get-table-attributes">
  <xsl:attribute name="colspan"><xsl:value-of select="."/></xsl:attribute>
</xsl:template>

<xsl:template match="@number-rows-spanned"
                     mode="get-table-attributes">
  <xsl:attribute name="rowspan"><xsl:value-of select="."/></xsl:attribute>
</xsl:template>



<!-- =============================================================== -->
<!-- Page layout: determine master name for the first page           -->
<!-- =============================================================== -->

<xsl:template match="fo:page-sequence-master">
  <xsl:apply-templates select="*[1]"/>
</xsl:template>

<xsl:template match="fo:single-page-master-reference
                   | fo:repeatable-page-master-reference">
  <xsl:value-of select="@master-reference"/>
</xsl:template>

<xsl:template match="fo:repeatable-page-master-alternatives">
  <xsl:choose>
    <xsl:when test="fo:conditional-page-master-reference[@page-position='first']">
      <xsl:value-of select="fo:conditional-page-master-reference[@page-position='first'][1]/@master-reference"/>
    </xsl:when>
    <xsl:when test="fo:conditional-page-master-reference[@odd-or-even='odd' and not (@blank-or-not-blank='blank')]">
      <xsl:value-of select="fo:conditional-page-master-reference[@odd-or-even='odd' and not (@blank-or-not-blank='blank')][1]/@master-reference"/>
    </xsl:when>
    <xsl:when test="fo:conditional-page-master-reference[not(@odd-or-even='even') and not (@blank-or-not-blank='blank')]">
      <xsl:value-of select="fo:conditional-page-master-reference[not(@odd-or-even='even') and not (@blank-or-not-blank='blank')][1]/@master-reference"/>
    </xsl:when>
    <xsl:otherwise> <!-- cannot guess; take the first -->
      <xsl:value-of select="fo:conditional-page-master-reference[1]/@master-reference"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- =============================================================== -->
<!-- Header/footer properties                                        -->
<!-- =============================================================== -->


<xsl:template match="@extent">
  <xsl:attribute name="width"><xsl:apply-templates select="." mode="convert-to-pixels"/></xsl:attribute>
</xsl:template>

<xsl:template match="@width | @height">
  <xsl:attribute name="{name()}"><xsl:apply-templates select="." mode="convert-to-pixels"/></xsl:attribute>
</xsl:template>

<xsl:template match="fo:region-before | fo:region-after">
  <xsl:call-template name="get-area-attributes"/>

  <!-- For header and footer, we suppress margins and padding -->
  <xsl:variable name="style">
    <xsl:apply-templates
          select="@*[not (starts-with (name(), 'margin')
                          or starts-with (name(), 'space')
                          or starts-with (name(), 'padding'))]"
          mode="collect-style-attributes">
      <xsl:with-param name="orientation" select="@reference-orientation"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:if test="string-length($style) &gt; 0">
    <xsl:attribute name="style"><xsl:value-of select="normalize-space($style)"/></xsl:attribute>
  </xsl:if>

</xsl:template>

<xsl:template match="fo:region-body">
  <xsl:call-template name="get-area-attributes"/>

  <!-- For region-body, we suppress margin attributes -->
  <xsl:variable name="style">
    <xsl:apply-templates
          select="@*[not (starts-with (name(), 'margin')
                          or starts-with (name(), 'space'))]"
          mode="collect-style-attributes">
      <xsl:with-param name="orientation" select="@reference-orientation"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:if test="string-length($style) &gt; 0">
    <xsl:attribute name="style"><xsl:value-of select="normalize-space($style)"/></xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template match="fo:region-start | fo:region-end"/>

<xsl:template name="get-area-attributes">
  <xsl:attribute name="valign">
    <xsl:choose>
      <xsl:when test="@display-align"><xsl:value-of select="@display-align"/></xsl:when>
      <xsl:otherwise>top</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="utf-8"?>
<!-- ============================================================= -->
<!--  MODULE:    groups-table-wraps-1-0.xsl                        -->
<!--  VERSION:   1.0                                               -->
<!--  DATE:      September 2004                                    -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!-- SYSTEM:     Archiving and Interchange DTD Suite               -->
<!--             Journal Article Formatting                        -->
<!--                                                               -->
<!-- PURPOSE:    A module of article-fo.xsl that handles           -->
<!--             tables.                                           -->
<!--                                                               -->
<!-- CONTAINS:   Key:                                              -->
<!--             1) legit-table-wraps                              -->
<!--             Templates for:                                    -->
<!--             1) table-wrap-group                               -->
<!--             2) table-wrap                                     -->
<!--             3) table-wrap/label, caption, and copyright       -->
<!--             4) table and its contents                         -->
<!--             5) table-wrap-foot                                -->
<!--             6) Named template: decide-make-table-wrap-labels  -->
<!--             7) Named template: determine-table-wrap-label     -->
<!--                                                               -->
<!-- CREATED FOR:                                                  -->
<!--             Digital Archive of Journal Articles               -->
<!--             National Center for Biotechnology Information     -->
<!--                (NCBI)                                         -->
<!--             National Library of Medicine (NLM)                -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             September 2004                                    -->
<!--                                                               -->
<!-- CREATED BY: Kate Hamilton (Mulberry Technologies, Inc.)       -->
<!--             Deborah Lapeyre (Mulberry Technologies, Inc.)     -->
<!--                                                               -->
<!--             Suggestions for refinements and enhancements to   -->
<!--             this stylesheet suite should be sent in email to: -->
<!--                 publishing-dtd@ncbi.nlm.nih.gov               -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                    VERSION/CHANGE HISTORY                     -->
<!-- ============================================================= -->
<!--
     =============================================================

No.  Reason/Occasion                       (who) vx.x (yyyymmdd)

     =============================================================
 1.  Original version                            v1.0  20040823    
                                                                   -->
                                                                     
<!-- ============================================================= -->
<!--                    XSL STYLESHEET INVOCATION                  -->
<!-- ============================================================= -->

<xsl:stylesheet version="2.0"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:rx="http://www.renderx.com/XSL/Extensions">


<!-- ============================================================= -->
<!-- KEY: LEGIT-TABLE-WRAPS                                        -->
<!-- ============================================================= -->


<xsl:key name="legit-table-wraps" 
         match="body/table-wrap
              | sec/table-wrap
              | app/table-wrap
              | table-wrap-group/table-wrap"
         use="local-name()"/>
                                       
     <xsl:template match="table-wrap | table-wrap-group">
<!--          <xsl:variable name="label">
               <xsl:choose>
                    <xsl:when test="contains(name(), 'fig')">
                         <xsl:text>Figure(s) at end of document</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(name(), 'table')">
                         <xsl:text>Table(s) at end of document</xsl:text>
                    </xsl:when>
               </xsl:choose>
          </xsl:variable>
          <fo:block space-before="$leading-around-narrative-blocks"
               space-after="$leading-around-narrative-blocks"
               background-color="#D3E9F5"
               font-size="{$textsize}"
               font-family="{titlefont}">
               <xsl:copy-of select="$label"/>
          </fo:block>
-->     </xsl:template>
<!-- ============================================================= -->
<!-- TABLE-WRAP-GROUP                                              -->
<!-- ============================================================= -->


<!-- Not handled this round (but the contained table-wraps are).   -->

<xsl:template match="table-wrap-group">
  <fo:block id="{@id}">
    <xsl:apply-templates select="table-wrap"/>
  </fo:block>
</xsl:template>


<!-- ============================================================= -->
<!-- TABLE-WRAP                                                    -->
<!-- ============================================================= -->


<!-- table-wrap: contains 
     label, caption, table or other content, and table-wrap-foot.  -->

<xsl:template match="table-wrap" mode="put-at-end">
     
     
  <xsl:param name="my-gid" select="generate-id()"/>
  
  <xsl:param name="make-table-wrap-labels">
    <!-- this logic is externalized because it is
         also used by xref -->
    <xsl:call-template name="decide-make-table-wrap-labels">
      <xsl:with-param name="object-gid" select="$my-gid"/>
    </xsl:call-template>
  </xsl:param>

  <xsl:param name="float">
    <xsl:choose>
      <xsl:when test="@position='float'">
<!--        <xsl:text>before</xsl:text>
-->           <xsl:text>none</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>none</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  
  <xsl:param name="space-before" select="$leading-around-narrative-blocks"/>   
  <xsl:param name="space-after" select="$leading-around-narrative-blocks"/>
     <xsl:variable name="my-label">
               <xsl:if test="key('legit-table-wraps', 'table-wrap')[generate-id()=$my-gid]
                    and ($make-table-wrap-labels='yes' or child::label)">
                    <fo:inline font-family="{$titlefont}"
                         font-size="7pt"
                         font-weight="bold"
                         color="#A1A7AD"
                         >
                    <xsl:call-template name="determine-table-wrap-label">
                         <xsl:with-param name="object-gid" select="$my-gid"/>
                    </xsl:call-template>
                    </fo:inline>
                    <xsl:text>| </xsl:text>
               </xsl:if>
     </xsl:variable>
  <fo:float float="{$float}">

    <fo:table-and-caption
         margin-bottom="50pt"
         border-top="0.5pt solid black">
         <xsl:if test="count(preceding::table) &gt;= 1">
              <xsl:attribute name="break-before">page</xsl:attribute>
         </xsl:if>

      <fo:table-caption>

        <!-- a block of 9/10B for the label and title -->
        <fo:block id="{@id}"
                  text-align="start"
                  space-before="2pt" space-before.precedence="1"
                  space-after="{$space-after}"   space-after.precedence="1"
                  line-height="9pt">

          <!-- label -->
          <fo:inline font-family="{$titlefont}"
                      font-weight="bold"
                      color="#A1A7AD"
               >
            <!-- title, if any: same line and typog -->
            <xsl:apply-templates select="caption/title" mode="display"/>
          </fo:inline>
        </fo:block>

        <!-- a block 9/10R for the caption paragraphs if any -->

        
          <fo:wrapper font-weight="normal">
            <xsl:apply-templates select="caption" mode="display">
                 <xsl:with-param name="label">
                      <xsl:copy-of select="$my-label"/>
                 </xsl:with-param>
            </xsl:apply-templates>
            <!-- copyright-statement if any -->
            <xsl:apply-templates select="copyright-statement" mode="display"/>
          </fo:wrapper>
        

      </fo:table-caption>

      <!-- now at last the table or other table-wrap content -->

        <xsl:apply-templates select="*[not(self::label)
                                   and not(self::caption)
                                   and not(self::table-wrap-foot)
                                   and not(self::copyright-statement)]"/>
      
    </fo:table-and-caption>

  </fo:float>
  
</xsl:template>



<!-- ============================================================= -->
<!-- TABLE-WRAP LABEL, CAPTION, COPYRIGHT-STATEMENT                -->
<!-- ============================================================= -->


<!-- label in mode=display; this is the number -->
<xsl:template match="table-wrap/label" mode="display">
  <xsl:apply-templates/>
</xsl:template>

<!-- a caption can contain ONLY title and p's, and we've
     already dealt with the title (if any) -->
<xsl:template match="table-wrap/caption" mode="display">
     <xsl:param name="label"/>
     <fo:block space-after="5pt" font-family="{$titlefont}" font-size="{$textsize*0.8}pt" font-weight="bold">
          <xsl:choose>
          <xsl:when test="string-length($label) !=0">
               <xsl:comment>cond1:</xsl:comment>
                    <xsl:copy-of select="$label"/>
					<xsl:apply-templates/>
                    <!--<xsl:apply-templates select="p[1]/node()" mode="display"/>
                    <xsl:apply-templates select="p[position() &gt; 1]" mode="display"/>-->
          </xsl:when>
          <xsl:otherwise>
               <xsl:comment>cond2</xsl:comment>
               <xsl:apply-templates select="p" mode="display"/>
          </xsl:otherwise>
     </xsl:choose>
     </fo:block>
     
</xsl:template>

<!-- caption/title in mode=display -->
<xsl:template match="table-wrap/caption/title" mode="display">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="table-wrap/copyright-statement" mode="display">
  <fo:block>
    <fo:wrapper font-family="{$textfont}"
                font-size="9pt"
                font-weight="normal">
      <xsl:apply-templates select="copyright" mode="display"/>
    </fo:wrapper>
  </fo:block>
</xsl:template>

<!-- suppress in no-mode -->
<xsl:template match="table-wrap/label | table-wrap/caption | table-wrap/copyright-statement"/>


<!-- ============================================================= -->
<!-- TABLE AND ITS CONTENT: THEAD, TFOOT, TR, TD                   -->
<!-- ============================================================= -->


<!-- the table itself -->
<xsl:template match="table">
<!--  <fo:table start-indent="0pc"
            border-collapse="separate"
            border-separation.inline-progression-direction="6pt"
            border-separation.block-progression-direction="2pt"
        >-->
       <fo:table start-indent="0pc"
            border-collapse="separate"
            border-separation.inline-progression-direction="0pt"
            border-separation.block-progression-direction="0pt"
            >
            <xsl:attribute name="rx:table-omit-initial-header">true</xsl:attribute>
    <xsl:apply-templates/>
  </fo:table>
</xsl:template>


<!-- table/thead -->
<xsl:template match="thead">
     <xsl:param name="continuation-text">
          <fo:block font-family="{$titlefont}" font-size="{$textsize*0.8}pt" font-weight="bold">
               <xsl:value-of select="ancestor::table-wrap/label"/>
               <xsl:text> (continued)</xsl:text>
          </fo:block>
     </xsl:param>
     
     <xsl:variable name="column-count">
          <xsl:value-of select="floor(sum(following::tr[1]//@colspan))"/>
     </xsl:variable>
     <fo:table-header
          background-color="#C9F2F5">
          <fo:table-row background-color="white">
               <fo:table-cell
                    number-columns-spanned="{$column-count}"
                    padding-bottom="6pt">
                         <xsl:copy-of  select="$continuation-text"/>
               </fo:table-cell>
          </fo:table-row>
          <xsl:apply-templates/>
     </fo:table-header>
     <fo:table-body background-color="#C9F2F5">
          <xsl:apply-templates/>
     </fo:table-body>
</xsl:template>


<!-- table/tfoot -->
<xsl:template match="tfoot">
  <fo:table-footer>
    <xsl:apply-templates/>
  </fo:table-footer>
</xsl:template>


<!-- table/tbody -->
<xsl:template match="tbody">
  <fo:table-body>
    <xsl:apply-templates/>
<!--       Make the table footer the last row. Tried table-footer but this did not work with XEP-->
    <xsl:apply-templates select="ancestor::table-wrap/table-wrap-foot"/>
       
  </fo:table-body>
</xsl:template>


<!-- rows -->
<xsl:template match="tr">

  <!-- pick up just two values from the 
       source attributes of row -->
       
  <xsl:param name="text-align">
    <xsl:choose>
      <xsl:when test="@align='center'">center</xsl:when>
      <xsl:when test="@align='right'">end</xsl:when>
      <xsl:when test="@align='left'">start</xsl:when>
      <xsl:otherwise>inherit</xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  
  <xsl:param name="display-align">
    <xsl:choose>
      <xsl:when test="@valign='center'">center</xsl:when>
      <xsl:when test="@valign='bottom'">after</xsl:when>
      <xsl:when test="@valign='top'">before</xsl:when>
      <xsl:otherwise>inherit</xsl:otherwise>
    </xsl:choose>
  </xsl:param>
     <xsl:param name="keep-with-next">
          <xsl:choose>
               <xsl:when test="./td[1]/@content-type='TableSubHead'">always</xsl:when>
               <xsl:otherwise>auto</xsl:otherwise>
          </xsl:choose>
     </xsl:param>
     

  <fo:table-row text-align="{$text-align}"
                display-align="{$display-align}"
                 keep-with-next="{$keep-with-next}">
    <xsl:apply-templates/>
  </fo:table-row>
</xsl:template>


<!-- cells -->
<xsl:template match="td|th"> 

  <!-- first pick up in parameters several of the
       XHTML attributes used in the source -->

  <xsl:param name="number-rows-spanned">
    <xsl:choose>
      <xsl:when test="@rowspan">
        <xsl:value-of select="@rowspan"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  
  <xsl:param name="number-columns-spanned">
    <xsl:choose>
      <xsl:when test="@colspan">
        <xsl:value-of select="@colspan"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  
  <xsl:param name="text-align">
    <xsl:choose>
      <xsl:when test="@align='center'">center</xsl:when>
      <xsl:when test="@align='right'">end</xsl:when>
      <xsl:when test="@align='left'">start</xsl:when>
      <xsl:when test="@align='char'"><xsl:value-of select="@char"/></xsl:when>
      <xsl:otherwise>inherit</xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  
  <xsl:param name="display-align">
    <xsl:choose>
      <xsl:when test="@valign='center'">center</xsl:when>
      <xsl:when test="@valign='bottom'">after</xsl:when>
      <xsl:when test="@valign='top'">before</xsl:when>
      <xsl:otherwise>inherit</xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  
  <!-- embolden if we're in a (true) header or footer cell -->

  <xsl:param name="font-weight">
    <xsl:choose>
      <xsl:when test="ancestor::thead or ancestor::tfoot">
        <xsl:text>bold</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>normal</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  
  <!-- OK, now get down to setting the table-cell -->
  
<!--  <fo:table-cell text-align="from-table-column()"
                 display-align="{$display-align}"
                 number-rows-spanned="{$number-rows-spanned}"
                 number-columns-spanned="{$number-columns-spanned}"
                 border-color="black"
                 border-width="1pt">-->
       <fo:table-cell
            text-align="{$text-align}"
            display-align="{$display-align}"
            number-rows-spanned="{$number-rows-spanned}"
            number-columns-spanned="{$number-columns-spanned}"
            padding-right="4pt"
            padding-bottom="2pt"
            padding-top="2pt">
            <xsl:if test="$number-rows-spanned &gt; 1">
                 <xsl:attribute name="padding-left">
                      <xsl:text>3pt</xsl:text>
                 </xsl:attribute>
            </xsl:if>
            <xsl:if test="ancestor-or-self::td">
                 <xsl:attribute name="border-bottom">
                      <xsl:text>0.25pt solid black</xsl:text>
                 </xsl:attribute>
            </xsl:if>
            <xsl:if test="(ancestor-or-self::th) and (@colspan &gt; 1) and (count(ancestor::thead/tr) &gt; 1) and (parent::tr/position() !=last())">
                 <xsl:attribute name="border-bottom">
                      <xsl:text>0.25pt solid black</xsl:text>
                 </xsl:attribute>
            </xsl:if>
       
    
    <fo:block line-height="{$fnleading}pt"
              text-align="{$text-align}">
      <fo:wrapper font-family="{$titlefont}"
                  font-size="{$fnsize*0.9}pt"
                  font-weight="{$font-weight}"> 
        <xsl:apply-templates/>
      </fo:wrapper>
    </fo:block>
  </fo:table-cell>
</xsl:template>


<!-- ============================================================= -->
<!-- TABLE-WRAP-FOOT                                               -->
<!-- ============================================================= -->


<!-- most usually contains table footnotes. 
     NOT the same as tfoot which becomes fo:table-footer. -->
<xsl:template match="table-wrap-foot" mode="pseudo-footnote">
     <xsl:variable name="column-count">
<!--          <xsl:value-of select="floor(sum(preceding::table[1]/thead/tr[1]//@colspan))"/>-->
          
          <xsl:value-of select="floor(sum(preceding-sibling::table[1]/thead[1]/tr[1]//@colspan))"/>
     </xsl:variable>
          <fo:table-row>
               <fo:table-cell
                    number-columns-spanned="{$column-count}"
                    padding-right="4pt"
                    padding-bottom="2pt"
                    padding-top="8pt">
                    <xsl:attribute name="border-bottom">
                         <xsl:text>0.5pt solid black</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="fn[ancestor::table-wrap-foot]" mode="pseudo-footnote"/>
               </fo:table-cell>
          </fo:table-row>
     
  
</xsl:template>

<xsl:template match="table-wrap-foot">
     <xsl:variable name="column-count">
<!--          <xsl:value-of select="floor(sum(preceding::table[1]/thead/tr[1]//@colspan))"/>-->
          
          <xsl:value-of select="floor(sum(preceding-sibling::table[1]/thead[1]/tr[1]//@colspan))"/>
     </xsl:variable>
          <fo:table-row>
               <fo:table-cell
                    number-columns-spanned="{$column-count}"
                    padding-right="4pt"
                    padding-bottom="2pt"
                    padding-top="8pt">
                    <xsl:attribute name="border-bottom">
                         <xsl:text>0.5pt solid black</xsl:text>
                    </xsl:attribute>
					<xsl:attribute name="font-family">
                         <xsl:text>FreeSans</xsl:text>
                    </xsl:attribute>
					<xsl:attribute name="font-size">
                         <xsl:text>6.75pt</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
               </fo:table-cell>
          </fo:table-row>
     
  
</xsl:template>
    
    <!-- Modified to deal with fn in table-wrap-foot in JATS. 
        Creates a list block and calculates indents based upon the character count of the label-->
    <xsl:template match="table-wrap-foot/fn">
        <xsl:choose>
            <xsl:when test="label">
                <xsl:for-each select=".">
                    <xsl:variable name="body-item-indent">
                        <xsl:choose>
                            <xsl:when test="label/text()[string-length() eq 1]">
                                <xsl:text>0.4pc</xsl:text>
                            </xsl:when>
                            <xsl:when test="label/text()[string-length() eq 2]">
                                <xsl:text>0.7pc</xsl:text>
                            </xsl:when>
                            <xsl:when test="label/text()[string-length() eq 3]">
                                <xsl:text>1pc</xsl:text>
                            </xsl:when>
                            <xsl:when test="label/text()[string-length() eq 4]">
                                <xsl:text>1.3pc</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>0pc</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <fo:list-block 
                        space-before="1pt" 
                        space-before.precedence="1" 
                        space-after="0pt" 
                        space-after.precedence="1" 
                        margin-left="1pc" 
                        provisional-distance-between-starts="0.5pc" 
                        provisional-label-separation="0.5pc" 
                        font-family="FreeSans" 
                        font-size="6.75pt">
                          <fo:list-item>
                              <fo:list-item-label start-indent="0pc" end-indent="0.2pc">
                                  <fo:block font-family="FreeSans" 
                        font-size="6.75pt">
                                      <xsl:apply-templates select="label"/>
                                  </fo:block>
                              </fo:list-item-label>
                              <fo:list-item-body start-indent="{$body-item-indent}" font-family="FreeSans" 
                        font-size="6.75pt">
                                  <xsl:apply-templates select="p"/>
                              </fo:list-item-body>
                          </fo:list-item>
                      </fo:list-block>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="p"/>
            </xsl:otherwise>
          </xsl:choose>
    </xsl:template>


<!-- ============================================================= -->
<!-- NAMED TEMPLATE: DECIDE-MAKE-TABLE-WRAP-LABELS                 -->
<!-- ============================================================= -->


<!-- Figures use a similar mechanism. Here, though, we -could- 
     use a global variable, since tables are simpler than figures,
     but it seems more helpful to keep the fig and table-wrap 
     numbering mechanisms the same. -->

<xsl:template name="decide-make-table-wrap-labels">

  <xsl:param name="object-gid"/>

  <xsl:choose>
  
    <!-- if ANY legit table-wrap has a label,
         DON'T generate numbers for table-wraps -->
    <xsl:when test="count(key('legit-table-wraps', 'table-wrap')[child::label]) != 0">
      <xsl:value-of select="'no'"/>
    </xsl:when>

    <!-- otherwise, in this document no legit table-wrap has a label, 
         so we'll set the value to true, and when the time comes 
         we'll use that to put out a string AND number -->
    <xsl:otherwise>
      <xsl:value-of select="'yes'"/>
    </xsl:otherwise>
    
  </xsl:choose>

</xsl:template>


<!-- ============================================================= -->
<!-- NAMED TEMPLATE: DETERMINE-TABLE-WRAP-LABEL                    -->
<!-- ============================================================= -->


<!-- we get here IFF the table-wrap is in a legitimate context
     for labeling AND either we're generating the string and label
     or there is a label in the document -->
     
  <!-- if SOME legit table-wraps in this document have labels
  
         if this table-wrap HAS a label 
          - if it has no space in it, put out the appropriate word
          - then put out the label
          
         if this table-wrap HAS NO label
          - don't put one out
          
       if NO legit table-wraps in this document have labels
         create one
  -->

<xsl:template name="determine-table-wrap-label">

  <!-- from table-wrap or xref template -->
  <xsl:param name="object-gid"/>
  
  <xsl:choose>

		<!-- if there's a label with a space in it, assume the
				 label contains both string and number -->
    <xsl:when test="contains(label, ' ')">
      <xsl:apply-templates select="label" mode="display"/>
    </xsl:when>
    
		<!-- if there's a label (with no space in it), 
				 generate a string and use the label -->
    <xsl:when test="label">
      <xsl:value-of select="$label-strings[@source-elem-name='table-wrap']/@display-string"/>
      <xsl:apply-templates select="label" mode="display"/>
    </xsl:when>

    <!-- otherwise, generate string AND number -->
    <xsl:otherwise>
        <xsl:value-of select="$label-strings[@source-elem-name='table-wrap']/@display-string"/>
        <xsl:call-template name="calculate-table-wrap-number">
        <xsl:with-param name="object-gid" select="$object-gid"/>
      </xsl:call-template>
    </xsl:otherwise>

  </xsl:choose>
       
</xsl:template>


</xsl:stylesheet>
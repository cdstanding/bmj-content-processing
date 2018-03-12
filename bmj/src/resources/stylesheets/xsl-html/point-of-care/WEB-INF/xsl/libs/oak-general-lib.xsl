<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times" extension-element-prefixes="date"
    xmlns:oak="http://schema.bmj.com/delivery/oak" 
>

    <xsl:import href="../libs/functions-lib.xsl" />
    <xsl:import href="../libs/references-lib.xsl" />
    
    <xsl:output method="html" omit-xml-declaration="yes"/>
    
    <!-- request context path -->
    <xsl:param name="ctxPath" />
    
    <!-- text for title bar -->
    <xsl:param name="monographTitle" />
    <xsl:param name="monographId" />
    <xsl:param name="sectionName" />
    <xsl:param name="evidenceStandalone"/>
    <xsl:param name="systematicReviewId"/>
    
    <!-- Evidence publication dates -->
    <xsl:param name="publishDate">
        <xsl:value-of select="//oak:review-publication-date" />
    </xsl:param>
    
    <xsl:param name="searchDate">
        <xsl:value-of select="//oak:review-search-date" />
    </xsl:param>
    
    <!-- BASIC ELEMENTS -->
   <xsl:template match="oak:p|oak:ul|oak:li|oak:sup|oak:sub|oak:i|oak:b">
      <xsl:element name="{name()}">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:template>

    <xsl:template match="oak:list">
      <xsl:element name="ul"><xsl:apply-templates/></xsl:element>
    </xsl:template>


    <!-- INTERVENTION LINKS -->
    <xsl:template match="oak:link[@class='option']">
      <xsl:variable name="srid">
        <xsl:call-template name="srid"><xsl:with-param name="target" select="@target"/></xsl:call-template>
      </xsl:variable>
      <xsl:variable name="optionId">
        <xsl:call-template name="xpointer"><xsl:with-param name="target" select="@target"/></xsl:call-template>
      </xsl:variable>
      <xsl:variable name="interventionUrl">
        <xsl:call-template name="basic-evidence-path"/>
        <xsl:value-of select="'/intervention'"/>
      </xsl:variable>
      
      <!-- HACK: This extra blank space helps in cases where the content is broken due
      to editors not adding enough whitespace. We can't add one after the link though,
      because there might be punctuation. Adding this here helps to mirror CE
      behaviour. -->
      <xsl:text> </xsl:text>
      
      <!-- 
        optionIds might have a fourth component - "harms" or "benefits"
        If so, we need to add that as an anchor e.g. #harms and split the
        actual intervention ID off the front.
      
        damn XSL "variables" are scoped inside the choose so we have to
        repeat the link syntax here .. very bad practice but no obvious
        way around it without using call-template which clutters up the code
        
        XSLT 2.0 supports "replace" which would work much better here but we 
        can't use it until/unless X-Hive sort out their issue with Saxon.
        
        NB the second parameter ('0') here is the question number and is actually
        now redundant, but we keep it here because Google has indexed URLs of this
        type and people may have bookmarked them. It's not used, as far as I am aware,
        but the number of parameters has to remain at 3. It is illegal to leave it 
        blank e.g. "//" since that contravenes the URL spec and Google gets annoyed.
       -->
      <xsl:choose>
        <xsl:when test="contains($optionId, '-harms')">
          <xsl:variable name="intId" select="substring-before($optionId, '-harms')"/>
          <xsl:variable name="anchor">#harms</xsl:variable>
          <a tabindex="45" href="{$interventionUrl}/{$srid}/0/{$intId}.html{$anchor}"><xsl:apply-templates/></a>
        </xsl:when>
        <xsl:when test='contains($optionId, "-benefits")'>
          <xsl:variable name="intId" select="substring-before($optionId, '-benefits')"/> 
          <xsl:variable name="anchor">#benefits</xsl:variable> 
          <a tabindex="45" href="{$interventionUrl}/{$srid}/0/{$intId}.html{$anchor}"><xsl:apply-templates/></a>
        </xsl:when>
        <xsl:when test="contains($optionId, '-comment')">
          <xsl:variable name="intId" select="substring-before($optionId, '-comment')"/>
          <xsl:variable name="anchor">#comment</xsl:variable>
          <a tabindex="45" href="{$interventionUrl}/{$srid}/0/{$intId}.html{$anchor}"><xsl:apply-templates/></a>
        </xsl:when>
        <xsl:otherwise>
          <a tabindex="45" href="{$interventionUrl}/{$srid}/0/{$optionId}.html"><xsl:apply-templates/></a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <!-- TABLE LINKS -->
    <xsl:template match="oak:link[@class='table']">
        <!-- 
            the target uses stupid xpointer syntax which is a pain
            so we have something like: #xpointer(id('sr-0317-t1'))
            which we need to parse. 
        -->
        <xsl:variable name="srid">
            <xsl:value-of select='substring(@target, 18, 4)'/>
        </xsl:variable>
        <xsl:variable name="tableId">
            <xsl:value-of select='substring-before(substring-after(@target, "#xpointer(id(&apos;"), "&apos;))")'/>
        </xsl:variable>
        <xsl:variable name="tableUrl">
          <xsl:call-template name="basic-evidence-path"/>
          <xsl:value-of select="'/table'"/>
        </xsl:variable>
        
        <a tabindex="45" href="{$tableUrl}/{$srid}/{$tableId}.html"><xsl:apply-templates/></a>
    </xsl:template>
    
   <xsl:template match="oak:link[@class='table-link']">
        <!-- 
            For the new CE OAk schema we have class changesd from table to table link and link is now sr-0317-t1
        -->
        <xsl:variable name="srid">
            <xsl:value-of select='substring(@target, 4, 4)'/>
        </xsl:variable>
        <xsl:variable name="tableId">
            <xsl:value-of select="@target"/>
        </xsl:variable>
        <xsl:variable name="tableUrl">
          <xsl:call-template name="basic-evidence-path"/>
          <xsl:value-of select="'/table'"/>
        </xsl:variable>
        
        <a tabindex="45" href="{$tableUrl}/{$srid}/{$tableId}.html"><xsl:apply-templates/></a>
    </xsl:template>
    
    <xsl:template match="oak:link[@class='gloss']">
      <xsl:variable name="srid">
        <xsl:call-template name="srid">
            <xsl:with-param name="target" select="@target"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="glossId">
        <xsl:call-template name="xpointer">
            <xsl:with-param name="target" select="@target"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="glossUrl">
        <xsl:call-template name="basic-evidence-path"/>
        <xsl:value-of select="'/glossary'"/>
      </xsl:variable>
      <a tabindex="45" class="reflink" href="{$glossUrl}/{$srid}/{$glossId}.html"
         ><xsl:attribute name="id">
           <xsl:value-of select="'popuplink-glos-sr_'" />
           <xsl:value-of select="$srid" />
           <xsl:value-of select="'_'" />
           <xsl:value-of select="$glossId" />
         </xsl:attribute>
         <xsl:apply-templates/></a>
    </xsl:template>
    
    <!--  REFERENCE LINKS 
           - for references with pubmed type uri-link-->
    <xsl:template match="oak:link[@class='pubmed-link']">
      <a tabindex="45">
        <xsl:attribute name="href">
          <xsl:value-of select="@target" />               
        </xsl:attribute>
        <xsl:attribute name="rel">external</xsl:attribute>
        <xsl:attribute name="class">web-link</xsl:attribute>
        <xsl:attribute name="target">_blank</xsl:attribute>
        <xsl:value-of select="'[Abstract]'" />
      </a>
      
      <!-- add OpenURL link  -->
      <xsl:if test="$openUrlLink">
        <!-- we're reliant on the format of the PubMed URL in order to extract
               the PubMed ID since it isn't stored separately -->
        <xsl:if test="starts-with(@target, 'http://www.ncbi.nlm.nih.gov/pubmed/')">
          <xsl:call-template name="openurl-link">
            <xsl:with-param name="medlineId" select="substring-after(@target, 'http://www.ncbi.nlm.nih.gov/pubmed/')" />
          </xsl:call-template>
        </xsl:if>
      </xsl:if>
      
    </xsl:template>
    
    <!--  uri links tend to show up as drug safety alerts, also other places
        the content is broken at present, lots of missing targets and text that
        is too long for the screen (which editorial can fix)  
        
        REFERENCE LINKS
            - for references with online type citation text with uri-link
            - for drug-safety-alert section with online type uri-link
        -->
    <xsl:template match="oak:link[@class='uri-link']">
      <a tabindex="45">
        <xsl:attribute name="href">
          <!-- if it doesn't start with "http://" then add it -->
          <xsl:if test="not(substring(@target, 1, 4) = 'http')">
            <xsl:text>http://</xsl:text>
          </xsl:if>
          <xsl:value-of select="@target" />               
        </xsl:attribute>
        <xsl:attribute name="rel">external</xsl:attribute>
        <xsl:attribute name="class">web-link</xsl:attribute>
        <xsl:attribute name="target">_blank</xsl:attribute>
        <!-- need to truncate if too long -->
        <xsl:call-template name="truncate">
          <xsl:with-param name="stringToTruncate" select="./text()"/>
        </xsl:call-template>
      </a>
    </xsl:template>
    
    <xsl:template match="oak:link[@class='figure']">
      <xsl:variable name="srid">
        <xsl:call-template name="srid">
            <xsl:with-param name="target" select="@target"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="unique-reference-id">
        <xsl:call-template name="xpointer">
            <xsl:with-param name="target" select="@target"/>
        </xsl:call-template>
      </xsl:variable>
      <a tabindex="45">
        <xsl:attribute name="href">
          <xsl:call-template name="basic-evidence-path" />
          <xsl:value-of select="'/image/'" />
          <xsl:value-of select="$srid" />
          <xsl:value-of select="'/'"/>
          <xsl:value-of select="$unique-reference-id" />
          <xsl:value-of select="'.html'"/>
        </xsl:attribute>
        <xsl:value-of select="." />
      </a>
    </xsl:template>
    
    <xsl:template match="oak:link[@class='reference']">
      <xsl:variable name="srid">
        <xsl:call-template name="srid">
            <xsl:with-param name="target" select="@target"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="unique-reference-id">
        <xsl:call-template name="xpointer">
            <xsl:with-param name="target" select="@target"/>
        </xsl:call-template>
      </xsl:variable>
      <a tabindex="45">
        <xsl:attribute name="href">
          <xsl:call-template name="basic-evidence-path" />
          <xsl:value-of select="'/references/'"/>
          <xsl:value-of select="$srid"/>
          <xsl:value-of select="'.html#'"/>
          <xsl:value-of select="$unique-reference-id"/>
         </xsl:attribute>
         <xsl:attribute name="id">
           <xsl:value-of select="'popuplink-ref-sr_'" />
           <xsl:value-of select="$srid" />
           <xsl:value-of select="'_'" />
           <xsl:value-of select="$unique-reference-id" />
         </xsl:attribute>
         <xsl:attribute name="class">reflink</xsl:attribute>
         <xsl:value-of select="'['" />
         <xsl:call-template name="reference-id-template">
            <xsl:with-param name="unique-id" select="$unique-reference-id"/>
        </xsl:call-template>
        <xsl:value-of select="']'" />
      </a>
    </xsl:template>
    
    <xsl:template name="evidence-publication-date">
     <xsl:if test="$publishDate">
     <h3></h3>
     <p class="publishedDate">
		<xsl:call-template name="translate-with-arguments">
			<xsl:with-param name="messagekey">oak-general-lib.web-publication</xsl:with-param>
			<xsl:with-param name="arguments">
				<xsl:value-of select="date:day-in-month($publishDate)"/>%<xsl:value-of select="date:month-abbreviation($publishDate)"/>%<xsl:value-of select="date:year($publishDate)"/>
				%<xsl:value-of select="date:month-name($searchDate)"/>%<xsl:value-of select="date:year($searchDate)"/>
			</xsl:with-param>
			<xsl:with-param name="argumentseparator">%</xsl:with-param>
		</xsl:call-template>                                                      
     </p>
     </xsl:if>
    </xsl:template> 
    
    <xsl:template name="srid">
      <xsl:param name="target"/>
      <xsl:value-of select='substring($target, 18, 4)'/>
    </xsl:template>

    <xsl:template name="xpointer">
      <xsl:param name="target"/>
      <xsl:value-of select='substring-before(substring-after($target, "#xpointer(id(&apos;"), "&apos;))")'/>
    </xsl:template> 
    
    <xsl:template name="reference-id-template">
      <xsl:param name="unique-id"/>
      <xsl:value-of select="substring($unique-id, 12)" />
    </xsl:template>   
    
    <xsl:template name="oak-image-source">
      <xsl:param name="path"/>
      <xsl:value-of select="$ctxPath" />
      <xsl:value-of select="'/images/sr/'" />
      <xsl:value-of select='substring-after($path, "images/")' />
    </xsl:template> 
    
    <xsl:template name="sr-questions-breadcrumb">
      <xsl:element name="a">
        <xsl:attribute name="tabindex">
            <xsl:value-of select="'45'"/>
        </xsl:attribute>
        <xsl:attribute name="href">
          <xsl:call-template name="basic-evidence-path"/>
          <xsl:if test="$evidenceStandalone">/<xsl:value-of select="$systematicReviewId"/></xsl:if>
          <xsl:value-of select="'.html'"/>
        </xsl:attribute>
        <xsl:element name="span">
          <xsl:choose>
            <xsl:when test="$monographId">
		        <xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.oak-general-lib.related-systematic-reviews-questions</xsl:with-param>
				</xsl:call-template>  			            
            </xsl:when>
            <xsl:otherwise>
		        <xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.oak-general-lib.systematic-reviews-questions</xsl:with-param>
				</xsl:call-template>  			            
            </xsl:otherwise>  
          </xsl:choose>    
        </xsl:element>
      </xsl:element>
    </xsl:template>
    
    <xsl:template name="sr-question-breadcrumb">
      <xsl:choose>
        <xsl:when test=".//oak:question-number[string-length(.)!=0]">
          <a tabindex="45">
              <xsl:attribute name="href">
                <xsl:call-template name="basic-evidence-path"/>
                <xsl:value-of select="'/question/'" />
                <xsl:value-of select="//oak:sr-id" />
                <xsl:value-of select="'/'" />
                <xsl:value-of select="//oak:question-number" />
                <xsl:value-of select="'.html'" />
              </xsl:attribute>
              <span>
		        <xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.oak-general-lib.intervention-table</xsl:with-param>
				</xsl:call-template></span>
          </a>
        </xsl:when>
        <xsl:otherwise>
              <span>
		        <xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.oak-general-lib.intervention-table</xsl:with-param>
				</xsl:call-template></span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <!-- Basic path including the monographID -->
    <xsl:template name="basic-path">
        <xsl:value-of select="$ctxPath" />
        <xsl:value-of select="'/monograph/'" />
        <xsl:value-of select="$monographId" />
    </xsl:template>
    
    <!-- If we're in a monograph context the base URL changes -->
    <xsl:template name="basic-evidence-path">
      <xsl:choose>
        <xsl:when test="$monographId">
          <xsl:call-template name="basic-path"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="$sectionName"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$ctxPath" />
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>/evidence</xsl:text>
    </xsl:template>
    
    <!-- These templates are to handle new Intervention tables -->
     <xsl:template name="intervention-tables">
    <div class="intervention-table comparison-set">
      <table cellspacing="0" cellpadding="0">
          <xsl:attribute name="summary">
            <xsl:value-of select="concat('Interventions table for ', ./oak:title)" />            
          </xsl:attribute>  
         <tbody>
           <xsl:call-template name="intervention-table-header">
             <xsl:with-param name="question-element" select="."/>
           </xsl:call-template>
           <tr><td colspan="6"><xsl:apply-templates select="oak:title"/></td></tr>
           <xsl:call-template name="intervention-table-body">
             <xsl:with-param name="question-element" select="."/>
           </xsl:call-template>
         </tbody>
      </table>
    </div>
 </xsl:template>

  <xsl:template name="intervention-table-header">
    <xsl:param name="question-element"/>
    <xsl:for-each select="$question-element/oak:section">
      <xsl:choose>
        <xsl:when test="@class='pico-first'">
          <tr>
            <xsl:for-each select="./oak:section">
              <th>
                <xsl:apply-templates select="oak:title" mode="pico"/>
              </th>                  
            </xsl:for-each>
          </tr>                         
        </xsl:when>
        <xsl:otherwise/>  
      </xsl:choose>
    </xsl:for-each>
    
  </xsl:template>    
  
  <xsl:template name="intervention-table-body">
    <xsl:param name="question-element"/>
      <xsl:for-each select="$question-element/oak:section">
              <tr>
              <xsl:for-each select="./oak:section">
                <td>
                  <xsl:apply-templates/>
                </td>
              </xsl:for-each>
              </tr>        
      </xsl:for-each>
  </xsl:template>   
</xsl:stylesheet>

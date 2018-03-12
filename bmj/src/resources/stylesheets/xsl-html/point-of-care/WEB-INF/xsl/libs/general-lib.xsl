<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    xmlns:oak="http://schema.bmj.com/delivery/oak"
    
    xmlns:f="Functions"
    
    xmlns:java="java">
    <!--xmlns:xslhelper="com.bmj.bpweb.util.XSLHelper"-->

    <xsl:output method="html" omit-xml-declaration="yes" />

    <!-- request context path -->
    <xsl:param name="ctxPath" />
    <xsl:param name="cdnUrl" />
    <xsl:param name="locale" /> 
    <xsl:param name="imagePath" />   
    <xsl:param name="pdfPath" />       
    <xsl:param name="messageSource" />      
    <xsl:param name="drugDatabases" />
    <xsl:param name="selectedDrugDB" />
    
    <!-- Indicates whether to enable drug links-->
    <xsl:param name="enableDrugLinks"/>
    <xsl:param name="isInternalDrugLink"/>

    <!-- Monograph parameters -->
    <xsl:param name="monographTitle" />
    <xsl:param name="monographId" />
    
    <xsl:variable name="messages" select="unparsed-text($messageSource)" as="xs:string"/>

    <xsl:template match="title">
        <h4>
            <xsl:apply-templates />
        </h4>
    </xsl:template>

    <xsl:template match="para">
        <p>
            <xsl:apply-templates />
        </p>
    </xsl:template>

    <xsl:template match="section-header">
        <h2>
            <xsl:apply-templates />
        </h2>
    </xsl:template>

    <xsl:template match="list">
        <xsl:variable name="style" select="./@style"/>
        <xsl:choose>
            <xsl:when test="$style ='1'">
                <ol class="decimal">
		            <xsl:apply-templates />
		        </ol>
            </xsl:when>
            <xsl:otherwise>
                <ul>
                    <xsl:apply-templates />
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="item">
        <li>
            <xsl:apply-templates />
        </li>
    </xsl:template>
    
    <!-- Display drug links -->
    <xsl:template match="name">
        <xsl:variable name="component-id" select="../@id"/>
        <xsl:variable name="component-type" select="../@type"/>
        <xsl:choose>
            <xsl:when test="$enableDrugLinks ='true' and (../../component/* or ../../comments/* or ../../../../sections/* or ../../../../../../sections/*) and not($component-type != '' and $component-type != 'drug')">
                <a tabindex="45" rel="external" class="druglink">
                    <xsl:attribute name="id">
			            <xsl:value-of select="../@id"/>
			        </xsl:attribute>
                    
                    <xsl:if test="$selectedDrugDB = 'BNF' or $selectedDrugDB = 'MARTINDALE'">
                        <xsl:attribute name="target">
	                        <xsl:value-of select="'_blank'"/>
	                    </xsl:attribute>
                    </xsl:if>
                        
                    <xsl:attribute name="href">
                        <xsl:value-of select="$ctxPath"/>
                        <xsl:value-of select="'/druglink.html'"/>
                        <xsl:value-of select="'?component-id='"/>
                        <xsl:value-of select="$component-id"/>
                        <xsl:value-of select="'&amp;optionId=expsec-'"/>
                        <xsl:value-of select="ancestor-or-self::tx-option/@id"/>
                        <xsl:if test="$selectedDrugDB">
                            <xsl:value-of select="'&amp;dd='"/>
                            <xsl:value-of select="$selectedDrugDB"/>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Display monograph links -->
    <xsl:template match="monograph-link">
        <xsl:param name="target">
            <xsl:value-of select="@target" />
        </xsl:param>
        <p class="monograph-link">
            <a tabindex="45">
                <xsl:attribute name="href">
                <xsl:value-of select="$ctxPath" />
                <xsl:value-of select="'/monograph/'" />
                <xsl:value-of
                        select='substring-before($target, ".xml")' />
                <xsl:value-of select="'.html'" />
            </xsl:attribute>
			<xsl:call-template name="translate-with-arguments">
				<xsl:with-param name="messagekey">body.general-lib.see-our-comprehensive-coverage</xsl:with-param>
				<xsl:with-param name="arguments">
					<xsl:value-of select="."/>
				</xsl:with-param>
				<xsl:with-param name="argumentseparator"></xsl:with-param>
			</xsl:call-template>   
            </a>
        </p>
    </xsl:template>

    <xsl:template match="reference-link[@type='article']">
        <xsl:element name="a">
            <xsl:attribute name="tabindex">
                <xsl:value-of select="'45'"/>
            </xsl:attribute>
            <xsl:attribute name="href">
          <xsl:call-template name="basic-path" />
          <xsl:value-of select="'/resources/references.html#ref-'" />
          <xsl:value-of select="@target" />
        </xsl:attribute>
            <xsl:attribute name="id">
          <xsl:value-of select="'popuplink-ref-bp_'" />
          <xsl:value-of select="@target" />
        </xsl:attribute>
            <xsl:attribute name="class">
          <xsl:value-of select="'reflink'" />
        </xsl:attribute>
            <xsl:value-of select="' ['" />
            <xsl:value-of select="@target" />
            <xsl:value-of select="']'" />
            <xsl:value-of select="' '" />
        </xsl:element>
    </xsl:template>

     <xsl:template match="reference">
      <xsl:variable name="title">
        <xsl:value-of select="title" />
      </xsl:variable>
      <xsl:if test="poc-citation[@type='online']">
          <xsl:value-of select="'  '" />
          <a tabindex="45" class="web-link">
            <xsl:attribute name="href">
              <xsl:apply-templates select="poc-citation/url"/>
            </xsl:attribute>
            <xsl:attribute name="target">
              <xsl:value-of select="'_blank'"/>
            </xsl:attribute>
            <xsl:value-of select="' ['" />
            <xsl:value-of select="$title" />
            <xsl:value-of select="'] '" />
          </a>
      </xsl:if>
    </xsl:template>

    <xsl:template name="image-source">
        <xsl:param name="path" />
        <xsl:value-of select="$cdnUrl" />
        <xsl:value-of select="$ctxPath" />
        <xsl:value-of select="$imagePath" />
        <xsl:value-of select='substring-after($path, "images/")' />
    </xsl:template>

    <xsl:template name="author-name">
        <xsl:param name="author" />
        <xsl:value-of select="$author/name" />
        <xsl:value-of select="', '" />
        <xsl:value-of select="$author/degree" />
    </xsl:template>

    <!-- Popup images -->
   <xsl:template match='figure-link[@inline="false"]'>
        <xsl:call-template name="createInlineImageLink">
             <xsl:with-param name="target" select="@target"/>
         </xsl:call-template>
    </xsl:template>

    <xsl:template name="createInlineImageLink">
        <xsl:param name="target"/>
        <a tabindex="45">
            <xsl:attribute name="href">
                <xsl:call-template name="basic-path" />
                <xsl:value-of select="'/resources/images/print/'" />
                <xsl:value-of select="$target" />
                <xsl:value-of select="'.html'" />
            </xsl:attribute>
            <xsl:attribute name="class">reflink image-link</xsl:attribute>
            <xsl:attribute name="id">
                <xsl:value-of select="'popuplink-img-bp_'" />
                <xsl:value-of select="$target" />
            </xsl:attribute>
            <span>
		        <xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.general-lib.view-image</xsl:with-param>
				</xsl:call-template>            
            </span>
        </a>
    </xsl:template>
    <!-- Popup evidence scores -->
    <xsl:template match='evidence-score-link'>
        <a tabindex="45">
            <xsl:attribute name="href">
          <xsl:call-template name="basic-path" />
          <xsl:value-of select="'/treatment/evidence/score/'" />
          <xsl:value-of select="@target" />
          <xsl:value-of select="'.html'" />
        </xsl:attribute>
            <xsl:attribute name="id">
          <xsl:value-of select="'popuplink-ref-score_'" />
          <xsl:value-of select="@target" />
        </xsl:attribute>
            <xsl:attribute name="class">
                <xsl:value-of select="'reflink evidence-score-'" />
                <xsl:value-of select="@score" />
            </xsl:attribute>
            <span>
               <xsl:value-of select="'['" />
               <xsl:value-of select="@score" />
               <xsl:value-of select="' Evidence]'" />
            </span>
        </a>
    </xsl:template>

    <!-- Popup NICE guidelines -->
    <xsl:template match='nice-guideline-link'>
        <a tabindex="45">
            <xsl:attribute name="href">
          <xsl:call-template name="basic-path" />
          <xsl:value-of select="'/resources/guideline/nice/'" />
          <xsl:value-of select="@target" />
          <xsl:value-of select="'.html'" />
        </xsl:attribute>
            <xsl:attribute name="id">
          <xsl:value-of select="'popuplink-nice-guideline_'" />
          <xsl:value-of select="@target" />
        </xsl:attribute>
            <xsl:attribute name="class">
                <xsl:value-of select="'reflink'" />
            </xsl:attribute>
            <span>
               <xsl:value-of select="'[NICE]'" />
            </span>
        </a>
    </xsl:template>

    <xsl:template match="patient-summary-link">
      <xsl:element name="a">
        <xsl:attribute name="tabindex">
            <xsl:value-of select="'45'"/>
        </xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="$ctxPath"/>
          <xsl:value-of select="$pdfPath"/>
          <xsl:value-of select="@target"/>
        </xsl:attribute>
        <xsl:attribute name="target">
            <xsl:value-of select="'_blank'"/>
        </xsl:attribute>
        <xsl:attribute name="class">pdf-doc</xsl:attribute>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:template>

    <!--<xsl:template match="*:xquery-result">
        <xsl:call-template name="mainTemplate" />
    </xsl:template>-->
    
    <xsl:template name="basic-path">
        <xsl:value-of select="$ctxPath" />
        <xsl:value-of select="'/monograph/'" />
        <xsl:value-of select="$monographId" />
    </xsl:template>

    <!-- Image templates -->
    <xsl:template match="figure">
        <xsl:apply-templates select="image-link">
           <xsl:with-param name="caption" select="./caption" />
       </xsl:apply-templates>
       <span class="caption">
        <xsl:apply-templates select="caption"/>
       </span>
       <span class="credit">
        <xsl:apply-templates select="source"/>
       </span>
    </xsl:template>

    <xsl:template match="caption">
        <xsl:apply-templates />
    </xsl:template>
    
    <xsl:template match="source">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="image-link">
        <xsl:param name="caption" />
        <xsl:variable name="image-path">
            <xsl:call-template name="image-source">
                <xsl:with-param name="path" select="@target" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:element name="img">
            <xsl:attribute name="src">
            <xsl:value-of select="$image-path" />
          </xsl:attribute>
          <xsl:attribute name="class">
            <xsl:value-of select="'img'" />
          </xsl:attribute>
            <xsl:attribute name="alt">
            <xsl:value-of select="$image-path" />
          </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:apply-templates select="$caption"/>
          </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <!-- /Image templates -->

    <xsl:template match="organism">
      <span class="organism"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="lexi-drug">
        <xsl:if test="position() = 1">
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:value-of select="$ctxPath"/>
                    <xsl:value-of select="'/lexicomp/monograph/'"/>
                    <xsl:value-of select="@lexi-monoId"/>
                    <xsl:value-of select="'.html'"/>
                </xsl:attribute>
                <xsl:attribute name="class"> <xsl:value-of select="'druglink'"/></xsl:attribute>
                <xsl:value-of select="' [Open Drug Monograph]'"/>           
            </xsl:element>              
        </xsl:if>
    </xsl:template>
    
    <!-- internalisation : finds corresponding translation -->
    <xsl:template name="translate">
        <xsl:param name="messagekey"/>

        <!--<xsl:value-of disable-output-escaping="yes" select="xslhelper:getMessage($messageSource, $locale, $messagekey)"/>-->
        <!--<xsl:value-of disable-output-escaping="yes" select="concat('[', $messageSource, '][', $locale, '][', $messagekey, ']')"/>-->
        <!--<xsl:value-of disable-output-escaping="yes" select="concat('[messagekey: ', f:getProperty($messagekey), ']')"/>-->
        
        <xsl:value-of disable-output-escaping="yes" select="f:getProperty($messagekey)"/>
        
    </xsl:template>
    
    <xsl:function name="f:getProperty" as="xs:string?">
        <xsl:param name="key" as="xs:string"/>
        <xsl:variable name="lines" as="xs:string*" select="
            for $x in 
            for $i in tokenize($messages, '\n')[matches(., '^[^!#]')] return
            tokenize($i, '=')
            return translate(normalize-space($x), '\', '')"/> 
        <xsl:sequence select="$lines[index-of($lines, $key)+1]"/>
    </xsl:function>

    <xsl:template name="translate-with-arguments">
        <xsl:param name="messagekey"/>
        <xsl:param name="arguments"/>
        <xsl:param name="argumentseparator"/>
        <!--<xsl:value-of disable-output-escaping="yes" select="xslhelper:getMessage($messageSource, $locale, $messagekey, $argumentseparator, $arguments )"/>-->
        <xsl:value-of disable-output-escaping="yes" select="concat('[', $messageSource, '][', $locale, '][', $messagekey, '][', $argumentseparator, '][', $arguments, ']')"/>
    </xsl:template>    
    
    <xsl:template name="drug-database-list">
        <!--<xsl:value-of disable-output-escaping="yes" select="xslhelper:getDrugDatabaseOptions($drugDatabases)"/>-->
        <xsl:value-of disable-output-escaping="yes" select="$drugDatabases"/>
    </xsl:template>
    
</xsl:stylesheet>

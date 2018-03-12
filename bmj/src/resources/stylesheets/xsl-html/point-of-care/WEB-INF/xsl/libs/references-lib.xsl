<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:oak="http://schema.bmj.com/delivery/oak">
  
  <xsl:import href="general-lib.xsl" />

  <!--  GENERIC STYLING FOR HANDLING REFERENCE DISPLAY -->

  <xsl:output method="html" omit-xml-declaration="yes" />

  <!-- request context path -->
  <xsl:param name="ctxPath" />

  <!-- Monograph paramters -->
  <xsl:param name="monographTitle" />
  <xsl:param name="monographId" />

  <!-- OpenUrl link informaton parameters -->
  <xsl:param name="openUrlImage" />
  <xsl:param name="openUrlLabel" />
  <xsl:param name="openUrlLink" />

  <xsl:template name="referenceTemplate">
    <xsl:param name="numbered" />
    <xsl:param name="endClass" />
    <p>
      <xsl:attribute name="class">
            <xsl:value-of select="$endClass" />
        </xsl:attribute>
      <xsl:if test="$numbered">
        <!-- Reference anchor -->
        <a tabindex="45">
          <xsl:attribute name="id">
              <xsl:value-of select="'ref-'" />
              <xsl:value-of select="@id" />
            </xsl:attribute>
          <xsl:attribute name="name">
              <xsl:value-of select="'ref-'" />
              <xsl:value-of select="@id" />
            </xsl:attribute>
        </a>
        <strong>
          <xsl:value-of select="@id" />
          <xsl:value-of select="'. '" />
        </strong>
      </xsl:if>
      <xsl:apply-templates select="poc-citation/citation" />
      <br />
      <xsl:if test="poc-citation/*[name() != 'citation'] | unique-id">
        <span class="ref-bar">
          <xsl:apply-templates
            select="poc-citation/*[name() != 'citation']" />
          <xsl:apply-templates select="unique-id" />
        </span>
      </xsl:if>
    </p>
  </xsl:template>

  <xsl:template match="poc-citation">
    <xsl:apply-templates />
  </xsl:template>

  <!-- 
    <xsl:template match="poc-citation[@type='article']">
    <xsl:apply-templates select="citation"/><br />
    <span>
    <a class="web-link"/>
    <xsl:apply-templates select="fulltext-url"/>
    </span>
    </xsl:template>
    
    <xsl:template match="poc-citation[@type!='article']">
    <xsl:apply-templates/>
    </xsl:template>
  -->

  <!-- Handles only medline ids -->
  <xsl:template match="unique-id">
    <xsl:if test='@source = "medline"'>
      <a tabindex="45">
        <xsl:attribute name="rel">external</xsl:attribute>
        <xsl:attribute name="class">web-link</xsl:attribute>
        <xsl:attribute name="target">_blank</xsl:attribute>
        <xsl:attribute name="href">
              <xsl:value-of
            select="'http://www.ncbi.nlm.nih.gov/pubmed/'" />               
              <xsl:value-of select="." />
              <xsl:text>?tool=bestpractice.bmj.com</xsl:text>
          </xsl:attribute>
          <xsl:text> </xsl:text>
          <xsl:call-template name="translate">
			<xsl:with-param name="messagekey">resource.reference.abstract</xsl:with-param>
          </xsl:call-template>               
      </a>
      <!-- add OpenURL link  -->
      <xsl:if test="$openUrlLink">
        <xsl:call-template name="openurl-link">
          <xsl:with-param name="medlineId" select="." />
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="fulltext-url">
    <a tabindex="45">
      <xsl:attribute name="rel">external</xsl:attribute>
      <xsl:attribute name="class">web-link</xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="href">               
            <xsl:value-of select="." />
        </xsl:attribute>
          <xsl:text> </xsl:text>
          <xsl:call-template name="translate">
			<xsl:with-param name="messagekey">resource.reference.fulltext</xsl:with-param>
          </xsl:call-template>               
    </a>
  </xsl:template>

  <xsl:template match="abstract-url">
    <a tabindex="45">
      <xsl:attribute name="rel">external</xsl:attribute>
      <xsl:attribute name="class">web-link</xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="href">               
            <xsl:value-of select="." />
        </xsl:attribute>
          <xsl:text> </xsl:text>
          <xsl:call-template name="translate">
			<xsl:with-param name="messagekey">resource.reference.abstract</xsl:with-param>
          </xsl:call-template>               
    </a>
  </xsl:template>

  <xsl:template match="url">
    <a tabindex="45">
      <xsl:attribute name="rel">external</xsl:attribute>
      <xsl:attribute name="class">web-link</xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="href">               
            <xsl:value-of select="." />
        </xsl:attribute>
          <xsl:text> </xsl:text>
          <xsl:call-template name="translate">
			<xsl:with-param name="messagekey">resource.reference.url</xsl:with-param>
          </xsl:call-template>               
    </a>
  </xsl:template>


  <xsl:template name="openurl-link">
    <xsl:param name="medlineId" />
    <a tabindex="45">
      <xsl:attribute name="href">               
				<xsl:value-of select="$ctxPath" />
                <xsl:value-of select="'/openUrl.html'" />
                <xsl:value-of select="'?medlineId='" />
				<xsl:value-of select="$medlineId" />                   
	        </xsl:attribute>
      <xsl:attribute name="rel">external</xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>

      <xsl:choose>
        <xsl:when test="$openUrlImage != ''">
          <img>
            <xsl:attribute name="src"><xsl:value-of
                select="$openUrlImage" />
            </xsl:attribute>
            <xsl:attribute name="alt"><xsl:value-of
                select="$openUrlLabel" />
            </xsl:attribute>
          </img>
        </xsl:when>
        <xsl:when test="$openUrlLabel != ''">
          <xsl:attribute name="class">web-link</xsl:attribute>
          <xsl:value-of select="' '" />
          <xsl:value-of select="$openUrlLabel" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">web-link</xsl:attribute>
          <xsl:text> </xsl:text>
          <xsl:call-template name="translate">
			<xsl:with-param name="messagekey">resource.reference.openurl</xsl:with-param>
          </xsl:call-template>               
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>

</xsl:stylesheet>

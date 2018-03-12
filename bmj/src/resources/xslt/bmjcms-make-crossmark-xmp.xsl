<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:x="adobe:ns:meta/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:pdfx="http://ns.adobe.com/pdfx/1.3/"
    xmlns:pdfaid="http://www.aiim.org/pdfa/ns/id/" xmlns:xap="http://ns.adobe.com/xap/1.0/"
    xmlns:xapRights="http://ns.adobe.com/xap/1.0/rights/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:prism="http://prismstandard.org/namespaces/basic/2.0/"
    xmlns:crossmark="http://crossref.org/crossmark/1.0/" version="2.0">
    <xsl:param name="this.pdfdate"/>
    <xsl:param name="backup.pdfdate"/>
    
    <xsl:template match="/">
        <xsl:variable name="this.doi"
            select="/article/front/article-meta/article-id[@pub-id-type='doi']/text()"/>
        <xsl:variable name="this.title">
            <xsl:apply-templates
                select="/article/front/article-meta/title-group/article-title//text()"/>
        </xsl:variable>

        <xsl:variable name="this.authorstring">
            <xsl:choose>
                <xsl:when test="/article/front/article-meta/contrib-group">
                    <xsl:for-each select="/article/front/article-meta/contrib-group/contrib">
                        <xsl:if test="position() !=1">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="./name">
                                <xsl:value-of
                                    select="concat(./name/given-names/text(), ' ',./name/surname/text())"
                                />
                            </xsl:when>
                            <xsl:when test="./collab">
                                <xsl:apply-templates select="./collab//text()"/>
                            </xsl:when>
                            <xsl:when test="./anonymous">
                                <xsl:text>Anonymous</xsl:text>
                            </xsl:when>
                        </xsl:choose>

                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>

        </xsl:variable>

        <xsl:variable name="this.pubday"
            select="replace(normalize-space(/article/front/article-meta/pub-date[@pub-type='epub']/day/text()),'^(\d)$','0$1')"/>

        <xsl:variable name="this.pubmonth"
            select="replace(normalize-space(/article/front/article-meta/pub-date[@pub-type='epub']/month/text()),'^(\d)$','0$1')"/>
        <xsl:variable name="this.pubyear"
            select="normalize-space(/article/front/article-meta/pub-date[@pub-type='epub']/year/text())"/>
        
        <xsl:variable name="this.MajorVersionDate">
            <xsl:choose>
                <xsl:when test="string-length(normalize-space($this.pdfdate))!=0">
                    <xsl:value-of select="replace($this.pdfdate,'(\d+)/(\d+)/(\d+)','$3-$2-$1')"/>
                </xsl:when>
                <xsl:when test="string-length($this.pubday) !=0 and string-length($this.pubmonth) !=0 and string-length($this.pubyear) !=0">
                    <xsl:value-of select="concat($this.pubyear,'-',$this.pubmonth,'-',$this.pubday)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$backup.pdfdate"/>
                </xsl:otherwise>
            </xsl:choose>
            
        </xsl:variable>
        
        
        
        
        
        <xsl:processing-instruction name="xpacket">
            <xsl:text>begin="?" id="W5M0MpCehiHzreSzNTczkc9d"</xsl:text>
        </xsl:processing-instruction>

        <xsl:element name="x:xmpmeta">
            <xsl:attribute name="x:xmptk">
                <xsl:text>Adobe XMP Core 4.0-c316 44.253921, Sun Oct 01 2006 17:14:39</xsl:text></xsl:attribute>
            <xsl:element name="rdf:RDF">
                <xsl:namespace name="pdfx">http://ns.adobe.com/pdfx/1.3/</xsl:namespace>
                <xsl:namespace name="pdfaid">http://www.aiim.org/pdfa/ns/id/</xsl:namespace>
                <xsl:namespace name="xap">http://ns.adobe.com/xap/1.0/</xsl:namespace>
                <xsl:namespace name="xapRights">http://ns.adobe.com/xap/1.0/rights/</xsl:namespace>
                <xsl:namespace name="dc">http://purl.org/dc/elements/1.1/</xsl:namespace>
                <xsl:namespace name="dcterms">http://purl.org/dc/terms/</xsl:namespace>
                <xsl:namespace name="prism">http://prismstandard.org/namespaces/basic/2.0/</xsl:namespace>
                <xsl:namespace name="crossmark">http://crossref.org/crossmark/1.0/</xsl:namespace>
                <xsl:element name="rdf:Description">
                    <xsl:attribute name="rdf:about"/>
                    <!--                    dublin core-->
                    <xsl:element name="dc:identifier">
                        <xsl:value-of select="concat('doi:',normalize-space($this.doi))"/>
                    </xsl:element>
                    <!--                    prism-->
                    <xsl:element name="prism:doi">
                        <xsl:value-of select="normalize-space($this.doi)"/>
                    </xsl:element>
                    <xsl:element name="prism:url">
                        <xsl:value-of
                            select="concat('http://dx.doi.org/doi:',normalize-space($this.doi))"/>
                    </xsl:element>
                    <!--                    pdfx-->
                    <xsl:element name="pdfx:doi">
                        <xsl:value-of select="normalize-space($this.doi)"/>
                    </xsl:element>
                    <xsl:element name="pdfx:Title">
                        <xsl:value-of select="normalize-space($this.title)"/>
                    </xsl:element>
                    <xsl:element name="pdfx:Author">
                        <xsl:value-of select="$this.authorstring"/>
                    </xsl:element>
                    <xsl:element name="pdfx:CrossmarkMajorVersionDate">
                        <xsl:value-of select="$this.MajorVersionDate"/>
                    </xsl:element>
                    <xsl:element name="pdfx:CrossmarkDomainExclusive">
                        <xsl:text>false</xsl:text>
                    </xsl:element>
                    <xsl:element name="pdfx:CrossMarkDomains">
                        <xsl:element name="rdf:Seq">
                            <xsl:element name="rdf:li">
                                <xsl:text>bmj.com</xsl:text>
                            </xsl:element>
                        </xsl:element>
                        </xsl:element>
                        
                    <!--                    crossmark-->
                    <xsl:element name="crossmark:DOI">
                        <xsl:value-of select="normalize-space($this.doi)"/>
                    </xsl:element>
                    <xsl:element name="crossmark:MajorVersionDate">
                        <xsl:value-of select="$this.MajorVersionDate"/>
                    </xsl:element>
                    <xsl:element name="crossmark:CrossmarkDomainExclusive">
                        <xsl:text>false</xsl:text>
                    </xsl:element>
                    <xsl:element name="crossmark:CrossMarkDomains">
                        <xsl:element name="rdf:Seq">
                            <xsl:element name="rdf:li">
                                <xsl:text>bmj.com</xsl:text>
                            </xsl:element>
                        </xsl:element>

                    </xsl:element>




                </xsl:element>
            </xsl:element>
        </xsl:element>



        <!--<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 4.0-c316 44.253921, Sun Oct 01 2006 17:14:39">
            <rdf:RDF xmlns:rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:pdfx = "http://ns.adobe.com/pdfx/1.3/"
                xmlns:pdfaid = "http://www.aiim.org/pdfa/ns/id/"
                xmlns:xap = "http://ns.adobe.com/xap/1.0/"
                xmlns:xapRights = "http://ns.adobe.com/xap/1.0/rights/"
                xmlns:dc = "http://purl.org/dc/elements/1.1/"
                xmlns:dcterms = "http://purl.org/dc/terms/"
                xmlns:prism = "http://prismstandard.org/namespaces/basic/2.0/"
                xmlns:crossmark = "http://crossref.org/crossmark/1.0/">
                <dc:identifier>doi:10.1136/bmj.f2310</dc:identifier>
                <dc:title>Impact of autologous blood injections in treatment of mid-portion Achilles tendinopathy: double blind randomised controlled trial</dc:title>
                <pdfx:Title>Impact of autologous blood injections in treatment of mid-portion Achilles tendinopathy: double blind randomised controlled trial</pdfx:Title>
                <pdfx:Author>Kevin J Bell, Mark L Fulcher, David S Rowlands, Ngaire Kerse</pdfx:Author>            
                <dc:creator>Kevin J Bell, Mark L Fulcher, David S Rowlands, Ngaire Kerse</dc:creator>
                <prism:doi>10.1136/bmj.f2310</prism:doi>
                <prism:url>http://dx.doi.org/doi:10.1136/bmj.f2310</prism:url>
                <crossmark:MajorVersionDate>2013-05-15</crossmark:MajorVersionDate>
                <crossmark:CrossmarkDomainExclusive>false</crossmark:CrossmarkDomainExclusive>
                <crossmark:DOI>doi:10.1136/bmj.f2310</crossmark:DOI>
                <crossmark:CrossMarkDomains>
                <rdf:Seq>
                <rdf:li>bmj.com</rdf:li>
                </rdf:Seq>
                </crossmark:CrossMarkDomains>
                <pdfx:doi>doi:10.1136/bmj.f2310</pdfx:doi>
                <pdfx:CrossmarkMajorVersionDate>2013-05-15</pdfx:CrossmarkMajorVersionDate>
                <pdfx:CrossmarkDomainExclusive>false</pdfx:CrossmarkDomainExclusive>
                <pdfx:CrossMarkDomains>
                <rdf:Seq>
                <rdf:li>bmj.com</rdf:li>
                </rdf:Seq>
                </pdfx:CrossMarkDomains>
                </rdf:RDF>
        </x:xmpmeta>-->
        <xsl:processing-instruction name="xpacket">
            <xsl:text>end="w"</xsl:text>
        </xsl:processing-instruction>



    </xsl:template>



</xsl:stylesheet>
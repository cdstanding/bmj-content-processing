<!-- This stylesheet transforms JATS ot NLM XML into a generic HTML
with <divs> and <spans> and takes the local name (element name) for each
element and turns it into an attribute "class". The classes can then be 
referenced by CSS.-->
<xsl:stylesheet xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="xs" version="2.0">
    
    <!-- Above are all the namespaces you need to declare if you're using them anywhere in the XSLT -->
    <xsl:output method="html" indent="yes" encoding="utf-8"/>
    
    <!-- This preserves all the whitespace on all elements. The * (wildcard) signifies all elements. -->
    <xsl:preserve-space elements="*"/>
    
    <!-- This is a fixed template to output the main HTML and body. 
        I am stating what the output should look like-->
    <xsl:template match="article">
        <html>
            <head>
                <!-- Links to CSS files for formatting go here -->
                <link rel="stylesheet" type="text/css"
                    href="//bmj1.bmauk.net/bmj/Editorial/_content_processing/css/JATS_NLM_preview.css"/>
                <link href="http://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet"
                    type="text/css"/>
            </head>
            <body>
                <div class="meta">
                    <div class="article-info">
                        <p class="article-info-title">
                            <b>Article info</b>
                        </p>
                        <p>
                            <b>Subject:</b>
                            <span>
                                <xsl:value-of
                                    select="//article-meta/article-categories/subj-group[@subj-group-type = 'heading']/subject"/>
                            </span>
                        </p>
                        <xsl:if
                            test="//article-meta/article-categories/subj-group[@subj-group-type = 'hwp-journal-coll']">
                            <p>
                                <b>Subject:</b>
                                <span>
                                    <xsl:value-of
                                        select="//article-meta/article-categories/subj-group[@subj-group-type = 'hwp-journal-coll']/subject"/>
                                </span>
                            </p>
                        </xsl:if>
                        <p>
                            <b>Electronic pub date:</b>
                            <span>
                                <xsl:value-of select="//article-meta/pub-date/year"/>
                            </span>
                        </p>
                        <xsl:if test="//article-meta/history/date[@date-type = 'accepted']">
                            <p>
                                <b>Accepted date:</b>
                                <span>
                                    <xsl:value-of
                                        select="//article-meta/history/date[@date-type = 'accepted']/day"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of
                                        select="//article-meta/history/date[@date-type = 'accepted']/month"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of
                                        select="//article-meta/history/date[@date-type = 'accepted']/year"/>
                                </span>
                            </p>
                        </xsl:if>
                        <p>
                            <b>Volume:</b>
                            <span>
                                <xsl:value-of select="//article-meta/volume"/>
                            </span>
                        </p>
                        <p>
                            <b>E-location ID:</b>
                            <span>
                                <xsl:value-of select="//article-meta/elocation-id"/>
                            </span>
                        </p>
                        <p>
                            <b>Publisher ID:</b>
                            <span>
                                <xsl:value-of select="//article-meta/article-id[@pub-id-type = 'publisher-id']"/>
                            </span>
                        </p>
                        <p>
                            <b>DOI:</b>
                            <span>
                                <xsl:value-of select="//article-meta/article-id[@pub-id-type = 'doi']"/>
                            </span>
                        </p>
                    </div>
                    <div class="journal-info">
                        <p class="journal-info-title">
                            <b>Journal info</b>
                        </p>
                        <p>
                            <b>Journal ID [nlm-ta]:</b>
                            <span>
                                <xsl:value-of select="//journal-meta/journal-id[@journal-id-type = 'nlm-ta']"/>
                            </span>
                        </p>
                        <p>
                            <b>Journal ID [publisher-id]:</b>
                            <span>
                                <xsl:value-of
                                    select="//journal-meta/journal-id[@journal-id-type = 'publisher-id']"/>
                            </span>
                        </p>
                        <p>
                            <b>Journal ID [hwp]:</b>
                            <span>
                                <xsl:value-of select="//journal-meta/journal-id[@journal-id-type = 'hwp']"/>
                            </span>
                        </p>
                        <p>
                            <b>ISSN:</b>
                            <span>
                                <xsl:value-of select="//journal-meta/issn[@pub-type = 'ppub']"/>
                            </span>
                        </p>
                        <p>
                            <b>ISSN:</b>
                            <span>
                                <xsl:value-of select="//journal-meta/issn[@pub-type = 'epub']"/>
                            </span>
                        </p>
                        <p>
                            <b>Publisher:</b>
                            <span>
                                <xsl:value-of select="//journal-meta/publisher/publisher-name"/>
                            </span>
                        </p>
                    </div>
                </div>
                <xsl:if test="//abstract/title | //abstract/sec/title | //body/sec/title">
                    <p class="toc-title">Table of contents</p>
                    <div class="toc">
                        <xsl:for-each select="//abstract | //abstract/sec | //body/sec">
                            <ul>
                                <li>
                                    <b>
                                        <a href="#{title/text()}">
                                            <xsl:value-of select="title"/>
                                        </a>
                                    </b>
                                    <xsl:for-each select="sec[ancestor::sec]">
                                        <ul>
                                            <li>
                                                <a href="#{title/text()}">
                                                  <xsl:value-of select="title"/>
                                                </a>
                                            </li>
                                        </ul>
                                    </xsl:for-each>
                                </li>
                            </ul>
                        </xsl:for-each>
                    </div>
                </xsl:if>
                <xsl:if test="//table-wrap">
                    <p class="toc-table-title">Tables</p>
                    <div class="tocTables">
                        <xsl:for-each select="//table-wrap[@id]">
                            <ul>
                                <li>
                                    <b>
                                        <a href="#{@id}">
                                            <xsl:text>Table&#x00A0;</xsl:text>
                                            <xsl:value-of select="@id/substring-after(., 'tbl')"/>
                                            <xsl:text>&#x00A0;</xsl:text>
                                            <xsl:text>&#x00A0;</xsl:text>
                                            <xsl:text>&#x00A0;</xsl:text>
                                        </a>
                                        <a href="#openModal{@id/substring-after(.,'tbl')}">
                                            <xsl:text>[Click for popup]</xsl:text>
                                        </a>
                                    </b>
                                </li>
                            </ul>
                        </xsl:for-each>
                    </div>
                </xsl:if>
                <!-- This is the root element. The apply-templates will look for all other templates and pop them all within here. -->
                <div class="article">
                    <xsl:if test="//article-categories/series-title">
                        <div class="series-title">
                            <xsl:value-of select="//article-categories/series-title"/>
                        </div>
                    </xsl:if>
                    <xsl:if test="//article-meta/title-group/article-title">
                        <div class="article-title">
                            <xsl:value-of select="//article-meta/title-group/article-title"/>
                        </div>
                    </xsl:if>
                    <xsl:if test="//permissions">
                        <p class="copyright">
                            <span>
                                <xsl:apply-templates
                                    select="//permissions/copyright-statement/node()"/>
                            </span>
                        </p>
                    </xsl:if>
                    <xsl:if test="//permissions/license">
                        <xsl:if test="//permissions/license[@license-type = 'open-access']">
                            <p class="license-oa">
                                <span>
                                    <xsl:apply-templates
                                        select="//permissions/license/license-p/node() | //permissions/license/p/node()"
                                    />
                                </span>
                            </p>
                        </xsl:if>
                        <xsl:if test="//permissions/license[not(@license-type = 'open-access')]">
                            <p class="license">
                                <span>
                                    <xsl:apply-templates
                                        select="//permissions/license/license-p/node() | //permissions/license/p/node()"
                                    />
                                </span>
                            </p>
                        </xsl:if>
                    </xsl:if>
                    <!--All generic template happen here-->
                    <xsl:apply-templates/>
                </div>
            </body>
        </html>
    </xsl:template>
    <!-- ........................................... -->
    <!-- Elements not to be displayed in the preview -->
    <!-- ........................................... -->
    <xsl:template match="journal-meta"/>
    <xsl:template match="article-id[parent::article-meta]"/>
    <xsl:template match="article-categories"/>
    <xsl:template match="pub-date"/>
    <xsl:template match="volume[preceding-sibling::pub-date]"/>
    <xsl:template match="elocation-id"/>
    <xsl:template match="permissions"/>
    <xsl:template match="history"/>
    <!-- .......................................... -->
    <xsl:template name="element-attrib">
        <xsl:if test="@id">
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:attribute name="class">
            <xsl:value-of select="local-name()"/>
            <xsl:if test="@*[1]">
                <xsl:text> </xsl:text>
                <xsl:value-of select="@*[1]"/>
            </xsl:if>
            <xsl:if test="@*[position() > 1]">
                <xsl:text> </xsl:text>
                <xsl:value-of select="@*[position() > 1]"/>
            </xsl:if>
        </xsl:attribute>
        <xsl:apply-templates/>
    </xsl:template>
    <!-- All block elements to be turned into <div>s -->
    <xsl:template
        match="
            abbrev-journal-title
            | access-date
            | ack
            | addr-line
            | address
            | aff
            | aff-alternatives
            | alt-text
            | alt-title
            | alternatives
            | annotation
            | anonymous
            | app
            | app-group
            | array
            | article-id
            | article-meta
            | attrib
            | author-comment
            | author-notes
            | award-group
            | award-id
            | back
            | bio
            | body
            | boxed-text
            | caption
            | chem-struct
            | chem-struct-wrap
            | citation-alternatives
            | code
            | collab-alternatives
            | compound-kwd
            | compound-kwd-part
            | compound-subject
            | compound-subject-part
            | conf-acronym
            | conf-date
            | conf-loc
            | conf-name
            | conf-num
            | conf-sponsor
            | conf-theme
            | conference
            | contrib
            | contrib-group
            | contrib-id
            | corresp
            | country
            | counts
            | custom-meta
            | custom-meta-group
            | data-file
            | date
            | day
            | def
            | def-head
            | def-item
            | def-list
            | degrees
            | disp-formula
            | disp-formula-group
            | disp-quote
            | element-citation
            | equation-count
            | era
            | fax
            | fig
            | fig-count
            | floats-group
            | funding-source
            | funding-statement
            | glossary
            | institution
            | institution-id
            | institution-wrap
            | issn
            | issn-l
            | issue-id
            | issue-part
            | issue-sponsor
            | issue-title
            | journal-id
            | journal-subtitle
            | journal-title-group
            | kwd
            | kwd-group
            | license
            | license-p
            | long-desc
            | media
            | meta-value
            | nlm-citation
            | note
            | notes
            | object-id
            | open-access
            | page-count
            | page-range
            | phone
            | postal-code
            | prefix
            | preformat
            | principal-award-recipient
            | principal-investigator
            | product
            | publisher
            | ref
            | ref-count
            | response
            | season
            | sec
            | sec-meta
            | self-uri
            | series
            | series-text
            | series-title
            | sig
            | sig-block
            | speaker
            | speech
            | statement
            | string-date
            | sub-article
            | subj-group
            | subtitle
            | table-count
            | table-wrap-foot
            | table-wrap-group
            | term-head
            | tex-math
            | textual-form
            | time-stamp
            | trans-abstract
            | verse-group
            | verse-line
            | version
            | volume-issue-group
            | volume-series
            | word-count
            ">
        <!-- Calls the template further up which contains an apply-templates, which will then apply all templates in thie template -->
        <div>
            <xsl:call-template name="element-attrib"/>
        </div>
    </xsl:template>
    <!-- All inline elements to be turned into <span>s -->
    <xsl:template
        match="
            abbrev
            | chapter-title
            | citation
            | city
            | collab
            | copyright-statement
            | copyright-year
            | copyright-holder
            | date-in-citation
            | edition
            | fixed-case
            | given-names
            | glyph-data
            | glyph-ref
            | gov
            | inline-formula
            | inline-graphic
            | inline-supplementary-material
            | isbn
            | issue
            | label
            | lpage
            | mixed-citation
            | monospace
            | name
            | name-alternatives
            | named-content
            | nested-kwd
            | on-behalf-of
            | overline
            | part-title
            | patent
            | person-group
            | price
            | private-char
            | pub-id
            | publisher-loc
            | publisher-name
            | rb
            | related-object
            | role
            | roman
            | rt
            | ruby
            | sans-serif
            | sc
            | size
            | source
            | state
            | std
            | std-organization
            | strike
            | string-name
            | styled-content
            | subject
            | suffix
            | supplement
            | surname
            | target
            | term
            | trans-source
            | trans-subtitle
            | trans-title
            | trans-title-group
            | underline
            | uri
            | volume
            | volume-id
            | year">
        <!-- Calls the template further up which contains an apply-templates, which will then apply all templates in thie template -->
        <span>
            <xsl:call-template name="element-attrib"/>
        </span>
    </xsl:template>
    <!-- All templates below are for very specific things I want to do to certain elements where they can't just be divs or spans -->
    <xsl:template match="abstract">
        <div>
            <xsl:if test="title">
                <xsl:call-template name="element-attrib"/>
            </xsl:if>
            <xsl:if test="not(title)">
                <xsl:attribute name="class">abstract</xsl:attribute>
                <div class="title" id="Abstract">Abstract</div>
                <xsl:apply-templates/>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="article-meta/title-group/article-title"/>
    <xsl:template match="article-title[ancestor::mixed-citation]">
        <span class="ref-article-title">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="bold">
        <b>
            <xsl:call-template name="element-attrib"/>
        </b>
    </xsl:template>
    <xsl:template match="break">
        <br>
            <xsl:call-template name="element-attrib"/>
        </br>
    </xsl:template>
    <xsl:template match="col">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="colgroup">
        <colgroup>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </colgroup>
    </xsl:template>
    <xsl:template match="email">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="@xlink:href"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    <xsl:template match="etal">
        <xsl:if test="self::node()">
            <xsl:if test=".[not(following-sibling::node())]">
                <xsl:text>&#x00A0;et al</xsl:text>
            </xsl:if>
            <xsl:if test=".[following-sibling::node()]">
                <xsl:text>&#x00A0;et al.&#x00A0;</xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="ext-link[not(parent::citation)][not(parent::mixed-citation)]">
        <xsl:if test=".[@ext-link-type = 'doi']">
            <a>
                <xsl:attribute name="href">
                    <xsl:text>http://dx.doi.org/</xsl:text>
                    <xsl:value-of select="text()"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </a>
        </xsl:if>
        <xsl:if test=".[@ext-link-type = 'pmid']">
            <a>
                <xsl:attribute name="href">
                    <xsl:text>http://www.ncbi.nlm.nih.gov/pubmed/?term=</xsl:text>
                    <xsl:value-of select="text()/substring-after(., 'pmid:')"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </a>
        </xsl:if>
        <xsl:if test=".[@ext-link-type = 'uri']">
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="@xlink:href"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </a>
        </xsl:if>
    </xsl:template>
    <xsl:template match="ext-link[parent::citation] | ext-link[parent::mixed-citation]">
        <xsl:if test="preceding-sibling::ext-link">
            <xsl:text>&#x00A0;</xsl:text>
        </xsl:if>
        <xsl:if test=".[@ext-link-type = 'doi']">
            <xsl:text>&#x00A0;</xsl:text>
            <a>
                <xsl:attribute name="href">
                    <xsl:text>http://dx.doi.org/</xsl:text>
                    <xsl:value-of select="text()"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </a>
        </xsl:if>
        <xsl:if test=".[@ext-link-type = 'pmid']">
            <xsl:text>&#x00A0;</xsl:text>
            <a>
                <xsl:attribute name="href">
                    <xsl:text>http://www.ncbi.nlm.nih.gov/pubmed/?term=</xsl:text>
                    <xsl:value-of select="text()/substring-after(., 'pmid:')"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </a>
        </xsl:if>
        <xsl:if test=".[@ext-link-type = 'uri']">
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="@xlink:href"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </a>
        </xsl:if>
    </xsl:template>
    <xsl:template match="fn">
        <span class="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="graphic">
        <img src="..\..\preview\graphics\{@xlink:href}.jpg"/>
    </xsl:template>
    <xsl:template match="hr">
        <hr>
            <xsl:call-template name="element-attrib"/>
        </hr>
    </xsl:template>
    <xsl:template match="italic">
        <i>
            <xsl:call-template name="element-attrib"/>
        </i>
    </xsl:template>
    <xsl:template match="label[parent::aff]">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>]</xsl:text>
        <xsl:text> </xsl:text>
    </xsl:template>
    <xsl:template match="list">
        <ul>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="list-item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="mml:math">
        <mml:math>
            <xsl:call-template name="element-attrib"/>
        </mml:math>
    </xsl:template>
    <xsl:template match="notes[parent::back]">
        <h2>
            <xsl:text>Notes</xsl:text>
        </h2>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="notes[parent::front]">
        <div class="meta-notes">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="p">
        <p>
            <xsl:call-template name="element-attrib"/>
        </p>
    </xsl:template>
    <xsl:template match="pub-id[parent::citation] | pub-id[parent::mixed-citation]">
        <xsl:if test=".[@pub-id-type = 'doi']">
            <xsl:text>&#x00A0;</xsl:text>
            <a>
                <xsl:attribute name="href">
                    <xsl:text>http://dx.doi.org/</xsl:text>
                    <xsl:value-of select="text()"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </a>
        </xsl:if>
        <xsl:if test=".[@pub-id-type = 'pmid']">
            <xsl:text>&#x00A0;&#x00A0;</xsl:text>
            <a>
                <xsl:attribute name="href">
                    <xsl:text>http://www.ncbi.nlm.nih.gov/pubmed/?term=</xsl:text>
                    <xsl:value-of select="text()"/>
                </xsl:attribute>
                <xsl:text>pmid:</xsl:text>
                <xsl:apply-templates/>
            </a>
        </xsl:if>
    </xsl:template>
    <xsl:template match="ref-list">
        <h2>References</h2>
        <div>
            <xsl:call-template name="element-attrib"/>
        </div>
    </xsl:template>
    <xsl:template match="related-article">
        <div>
            <xsl:attribute name="class">
                <xsl:value-of select="local-name()"/>
            </xsl:attribute>
            <xsl:if test="ext-link">
                <xsl:copy-of select="@*"/>
                <xsl:text>Related article:&#x00A0;</xsl:text>
                <xsl:apply-templates/>
            </xsl:if>
            <xsl:if test="not(ext-link)">
                <xsl:copy-of select="@*"/>
                <xsl:text>Related article:&#x00A0;</xsl:text>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:text>http://dx.doi.org/</xsl:text>
                        <xsl:value-of select="@xlink-href"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:if>
        </div>
    </xsl:template>
    <xsl:template match="sub">
        <sub>
            <xsl:call-template name="element-attrib"/>
        </sub>
    </xsl:template>
    <xsl:template match="sup">
        <sup>
            <xsl:call-template name="element-attrib"/>
        </sup>
    </xsl:template>
    <xsl:template match="supplementary-material">
        <div>
            <a>
                <xsl:attribute name="href">
                    <xsl:text>../../data-supp/</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates/>
            </a>
        </div>
    </xsl:template>
    <xsl:template match="table-wrap">
        <div class="clickForTable">
            <b>
                <a id="{@id}" href="#openModal{@id/substring-after(.,'tbl')}">
                    <xsl:text>Table&#x00A0;</xsl:text>
                    <xsl:value-of select="@id/substring-after(., 'tbl')"/>
                </a>
            </b>
            <div id="openModal{@id/substring-after(.,'tbl')}" class="modalDialog">
                <div>
                    <xsl:apply-templates select="table/preceding-sibling::*"/>
                    <div class="modalWindow">
                        <a href="#close" title="Close" class="close">X</a>
                        <xsl:apply-templates select="table"/>
                    </div>
                    <xsl:apply-templates select="table/following-sibling::*"/>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="table">
        <table class="modalTable">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    <xsl:template match="tbody">
        <tbody>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </tbody>
    </xsl:template>
    <xsl:template match="td">
        <td>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </td>
    </xsl:template>
    <xsl:template match="tfoot">
        <tfoot>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </tfoot>
    </xsl:template>
    <xsl:template match="th">
        <th>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </th>
    </xsl:template>
    <xsl:template match="title">
        <div class="{local-name()}" id="{text()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="thead">
        <thead>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </thead>
    </xsl:template>
    <xsl:template match="tr">
        <tr>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    <xsl:template match="xref">
        <a>
            <xsl:attribute name="class">
                <xsl:value-of select="local-name()"/>
            </xsl:attribute>
            <xsl:attribute name="ref-type">
                <xsl:value-of select="@ref-type"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#</xsl:text>
                <xsl:value-of select="@rid"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
    <xsl:template match="//text()[matches(., '^-')]">
        <xsl:if test=".[preceding-sibling::xref]">
            <sup>&#x00A0;<xsl:value-of select="."/></sup>
        </xsl:if>
        <xsl:if test=".[not(preceding-sibling::xref)]">
            <xsl:value-of select="."/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs" 
    version="2.0">
    
    <xsl:output method="xhtml" indent="yes" encoding="UTF-8" media-type="text/html"/>
    
    <xsl:param name="art-id"/>
    <xsl:param name="article-section"/>
    <xsl:param name="content-store"/>
    <xsl:param name="extyles-xml"/>
    <xsl:param name="graphic-file-extension"/>
    <xsl:param name="graphics-folder-available"/>
    <xsl:param name="graphics-found-filepath"/>
    <xsl:param name="graphics-info-folder-sorted"/>
    <xsl:param name="graphics-info-xml-sorted"/>
    <xsl:param name="qa-svrl"/>
    <xsl:param name="meta"/>
    <xsl:param name="schema-invalid"/>
    <xsl:param name="source"/>
    <xsl:param name="source-filename"/>
    <xsl:param name="supp-files-home"/>
    
    <xsl:variable name="filename" select="fileset/file/@name"/>
    <xsl:variable name="gff" select="doc(concat('file:///',$graphics-found-filepath))"/>
    <xsl:variable name="qa-file" select="doc(concat('file:///',$qa-svrl))"/>
    <xsl:variable name="source-file" select="doc(concat('file:///',$source))"/>
    
    <xsl:template match="/">
        <html>
            <p class="browserWarning"
                >Please note: This page and the HTML preview will only work properly in Google Chrome.</p>
            <head>
                <title>
                    <xsl:value-of select="$filename"/>
                </title>
                <link href="http://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet"
                    type="text/css"/>
                <style>
                    /*------------------------------------*/
                    /*----------Main HTML template--------*/
                    /*------------------------------------*/
                    html
                    {
                        height: 100%;
                        font-family: "Open Sans", Arial, Helvetica;
                    }
                    
                    a
                    {
                        color: #2A6EBB;
                    }
                    
                    body
                    {
                        margin: 0px;
                        width: auto;
                    }
                    
                    .browserWarning
                    {
                        color: red;
                        font-family: courier, fixed, monospace;
                        font-size: 8pt;
                        margin-top: 10px;
                        margin-right: 10px;
                        text-align: right;
                    }
                    
                    .error-container
                    {
                    }
                    
                    .guide
                    {
                        font-size: 9pt;
                    }
                    
                    .head
                    {
                        background-color: #B8B8B8;
                        font-weight: bold;
                    }
                    
                    hr
                    {
                        color: #DDDDDD;
                    }
                    
                    ol
                    {
                        font-size: 9pt;
                    }
                    
                    .qaReport
                    {
                        color: #2A6EBB;
                        font-family: "Open Sans", Arial, Helvetica;
                        font-size: 40pt;
                        font-weight: bold;
                        padding-bottom: 20px;
                    }
                    
                    table
                    {
                        border-collapse: collapse;
                        display: block;
                        font-family: "Open Sans", Arial, Helvetica;
                        font-size: 12pt;
                        margin-left: 10px;
                        right: 10px;
                        width: 99%;
                    }
                    
                    tbody
                    {
                        border-collapse: collapse;
                        display: block;
                        font-family: "Open Sans", Arial, Helvetica;
                        font-size: 12pt;
                    }
                    
                    tr
                    {
                        right: 10px;
                        width: 100%;
                    }
                    
                    td
                    {
                        border-bottom: solid;
                        border-width: 1px;
                        border-color: #DDDDDD;
                        padding: 10px;
                        vertical-align: text-top;
                    }
                    
                    th
                    {
                        padding: 10px;
                        vertical-align: text-top;
                    }
                    
                    
                    .thText
                    {
                        font-weight: bold;
                    }
                    
                    
                    /*--------------------------------*/
                    /*-------------Colours------------*/
                    /*--------------------------------*/
                    
                    
                    .pass
                    {
                        background-color: #009933;
                        font-weight: bold;
                    }
                    
                    .warn
                    {
                        background-color: #FFA319;
                        font-weight: bold;
                    }
                    
                    .fail
                    {
                        background-color: #CC0000;
                        font-weight: bold;
                    }
                    
                    .passtext
                    {
                        color: #009933;
                        font-weight: bold;
                    }
                    
                    .warntext
                    {
                        color: #FFA319;
                        font-weight: bold;
                    }
                    
                    .failtext
                    {
                        color: #CC0000;
                        font-weight: bold;
                    }
                    
                    
                    
                    /*-------------------------------------------------*/
                    /*----------Webkit add-ons for fancy things--------*/
                    /*-------------------------------------------------*/
                    
                    ::-webkit-scrollbar
                    {
                        width: 12px;
                    }
                    
                    ::-webkit-scrollbar-track
                    {
                        -webkit-box-shadow: inset 0 0 1px rgba(0, 0, 0, 0.3);
                        border-radius: 0px;
                    }
                    
                    ::-webkit-scrollbar-thumb
                    {
                        border-radius: 0px;
                        -webkit-box-shadow: inset 0 0 1px rgba(0, 0, 0, 0.5);
                    }</style>
            </head>
            <body>
                <table>
                    <colgroup>
                        <col colname="col1" width="25%"/>
                        <col colname="col2" width="15%"/>
                        <col colname="col3" width="30%"/>
                        <col colname="col4" width="30%"/>
                    </colgroup>
                    <tbody>
                        <xsl:choose>
                            <xsl:when test="$source-file//qa-fail-template">
                                <xsl:call-template name="badly-formed-xml"/>
                            </xsl:when>
                            <xsl:when test="$source-file//comment()[matches(., 'Warning:', 'i')]">
                                <xsl:call-template name="extyles-warning"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="schematron"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </tbody>
                </table>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template name="badly-formed-xml">
        <!-- Schema QA for eXtyles output -->
        <tr>
            <td class="qaReport" colspan="4">Article QA Report</td>
        </tr>
        <tr>
            <td class="th">
                <b>Article</b>
            </td>
            <td colspan="3">
                <xsl:value-of select="$art-id"/>
            </td>
        </tr>
        <tr>
            <td class="head">Check</td>
            <td class="head">Status</td>
            <td colspan="2" class="head">Message</td>
        </tr>
        <tr>
            <td>
                <p>
                    <b>Stage 1 validation (Check XML is well formed)</b>
                </p>
                <p class="guide">
                    <b>Options for error resolution:</b>
                </p>
                <ul class="guide">
                    <li>Run the BMJ JATS 1.1 DTD XML (valid) export option from eXtyles and look for warning message in the result XML file to find the source of the problem.</li>
                </ul>
                <ul class="guide">
                    <li>Check the <a href="https://docs.google.com/document/d/1AFG4oYB57crabyfUcCM7DlyefMLluMTeffCA-hwtwEA/edit?usp=sharing"><b>Common styling issues</b></a> documentation</li>
                </ul>
                <ul class="guide">
                    <li>If you need further instruction on the QA Process, please refer to the <a
                            href="https://docs.google.com/document/d/1PeIjCCkwpqWJRSgMKirrUDUweqT6JIZx9B-MnLm7elk/edit?usp=sharing"
                                ><b>Extyles XML QA Process documentation</b></a></li>
                </ul>
            </td>
            <td class="fail">Fail</td>
            <td colspan="2">
                <div class="error-container">
                    <p class="error"><xsl:value-of select="$source-file//p/text()"/></p>
                    <hr/>
                </div>
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template name="extyles-warning">
        <!-- Schema QA for eXtyles output -->
        <tr>
            <td class="qaReport" colspan="4">Article QA Report</td>
        </tr>
        <tr>
            <td class="th">
                <b>Article</b>
            </td>
            <td colspan="3">
                <xsl:value-of select="$art-id"/>
            </td>
        </tr>
        <tr>
            <td class="head">Check</td>
            <td class="head">Status</td>
            <td colspan="2" class="head">Message</td>
        </tr>
        <tr>
            <td>
                <p>
                    <b>Stage 1 validation (eXtyles)</b>
                </p>
                <p class="guide">
                    <b>Options for error resolution:</b>
                </p>
                <ul class="guide">
                    <li>Red text is the tag that is the source of the error in the <a href="{$extyles-xml}"
                                ><b>XML</b></a>.</li>
                    <li>Text near source of error (if present) will indicate the location of the error in both Word and XML.</li>
                    <li>If the styling error isn't obvious, compare your article with an earlier one with the same styling that worked.</li>
                    <li>Check the <a
                            href="https://docs.google.com/document/d/1GOPE7IwtL9Qry6DbbQTxK72_eijfd4SIsbFcm7EWKNw"
                                ><b>eXtyles User Documentation</b></a> for styling guidelines.</li>
                    <li>Check the <a href="https://docs.google.com/document/d/1AFG4oYB57crabyfUcCM7DlyefMLluMTeffCA-hwtwEA/edit?usp=sharing"><b>Common styling issues</b></a> documentation</li>
                    <li>If you need further instruction on the QA Process, please refer to the <a
                            href="https://docs.google.com/document/d/1PeIjCCkwpqWJRSgMKirrUDUweqT6JIZx9B-MnLm7elk/edit?usp=sharing"
                                ><b>Extyles XML QA Process documentation</b></a></li>
                </ul>
            </td>
            <td class="fail">Fail</td>
            <td colspan="2">
                <div class="error-container">
                    <xsl:for-each select="$source-file//comment()[matches(., 'Warning:', 'i')]">
                        <p class="error">The element 
                            <b class="fail">
                                <xsl:if test=".[following-sibling::*]">
                                    <xsl:value-of select="./following-sibling::*[1]/local-name()"/>
                                </xsl:if>
                                <xsl:if test=".[not(following-sibling::*)]">
                                    <xsl:value-of select="./parent::*/local-name()"/>
                                </xsl:if>
                            </b> is not allowed here.</p>
                        <p>
                            <b>Text near source of error: </b>
                            <xsl:value-of select="preceding::*[1][text()]/text()"/>
                        </p>
                        <hr/>
                    </xsl:for-each>
                </div>
            </td>
        </tr>
    </xsl:template>
    
    
    <xsl:template name="schematron">
        
        <xsl:message>
            <xsl:text>The schematron template has been called...</xsl:text>
        </xsl:message>
        
        <xsl:variable name="meta-file" select="doc(concat('file:///',$meta))"/>
        <xsl:variable name="graphics-in-folder"
            select="$meta-file//graphics-in-folder/graphic/text()"/>
        <xsl:variable name="graphics-in-xml" select="$meta-file//graphics-in-xml/graphic/text()"/>
        <xsl:variable name="supp-files-in-folder"
            select="$meta-file//supp-files-in-folder/supp-file/text()"/>
        <xsl:variable name="supp-files-in-xml"
            select="$meta-file//supp-files-in-xml/supp-file/text()"/>
        
        <xsl:for-each select="$qa-file//svrl:schematron-output">
            <xsl:message>
                <xsl:text>Looking at QA report file...</xsl:text>
            </xsl:message>
            <xsl:message>
                <xsl:text>This is the qa file...</xsl:text>
            </xsl:message>
            <!-- Schema QA for eXtyles output -->
            <tr>
                <td class="qaReport" colspan="4">Article QA Report</td>
            </tr>
            <tr>
                <td class="th" colspan="4">
                    <a href="https://docs.google.com/document/d/1AFG4oYB57crabyfUcCM7DlyefMLluMTeffCA-hwtwEA/edit?usp=sharing"><b>Common styling issues</b></a>
                </td>
            </tr>
            <tr>
                <td class="th">
                    <b>Article</b>
                </td>
                <td colspan="3">
                    <xsl:value-of select="$art-id"/>
                </td>
            </tr>
            <tr>
                <td class="th">
                    <b>Article type</b>
                </td>
                <td colspan="3">
                    <xsl:value-of select="$article-section"/>
                </td>
            </tr>
            <tr>
                <td class="th" colspan="3">
                    <b><a href="../previews/{$art-id}/{$source-filename}.html">HTML Preview</a></b>
                </td>
            </tr>
            <tr>
                <td class="th" colspan="3">
                    <b><a href="../pdfs/{$art-id}.pdf">PDF</a></b>
                </td>
            </tr>
            <tr>
                <td class="th">
                    <b>Stage 1 validation (eXtyles JATS XML)</b>
                </td>
                <td class="pass">Pass</td>
                <td class="passtext" colspan="2">Your JATS XML from eXtyles is valid!</td>
            </tr>
            <xsl:if test="not(//svrl:failed-assert | //svrl:successful-report)">
                <tr>
                    <td class="th">
                        <b>Stage 2 validation (BMJ rules)</b>
                    </td>
                    <td class="pass">Pass</td>
                    <td class="passtext" colspan="2">Your JATS XML is valid to BMJ rules!</td>
                </tr>
            </xsl:if>
            <xsl:if
                test="svrl:failed-assert[@role = 'warning'] | svrl:successful-report[@role = 'warning']">
                <tr>
                    <td class="th">
                        <b>Stage 2 validation (BMJ rules)</b>
                    </td>
                    <td class="warn">Warning</td>
                    <td colspan="2">
                        <xsl:for-each
                            select="svrl:failed-assert[@role = 'warning'] | svrl:successful-report[@role = 'warning']">
                            <p class="warntext">
                                <b>Report <xsl:number/></b>
                            </p>
                            <p class="warntext">
                                <xsl:value-of select="svrl:text/text()"/>
                            </p>
                            <xsl:if
                                test="./following-sibling::svrl:failed-assert | ./following-sibling::svrl:successful-report">
                                <hr/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="svrl:failed-assert[@role = 'error'] | svrl:successful-report[@role = 'error']">
                <tr>
                    <td class="th">
                        <b>Stage 2 validation (BMJ rules)</b>
                    </td>
                    <td class="fail">Fail</td>
                    <td colspan="2">
                        <xsl:for-each
                            select="svrl:failed-assert[@role = 'error'] | svrl:successful-report[@role = 'error']">
                            <p class="failtext">
                                <b>Error report <xsl:number/></b>
                            </p>
                            <p class="failtext">
                                <xsl:value-of select="svrl:text/text()"/>
                            </p>
                            <xsl:if
                                test="./following-sibling::svrl:failed-assert | ./following-sibling::svrl:successful-report">
                                <hr/>
                            </xsl:if>
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <!-- !!!!!!!!!!SUPPLEMENTARY FILES TESTING!!!!!!!!!! -->
            <xsl:if test="$supp-files-in-xml and not($supp-files-in-folder)">
                <tr>
                    <td class="th" rowspan="2">
                        <b>Supplementary files</b>
                    </td>
                    <td class="fail" rowspan="2">Fail</td>
                    <td class="head">Supplementary files available in the <a class="thText"
                        href="{$supp-files-home}">folder</a>.</td>
                    <td class="head">Supplementary files referenced in the <a class="thText"
                        href="{$content-store}/jats-xml/{$art-id}.xml">XML</a></td>
                </tr>
                <tr>
                    <td>
                        <p class="failtext"
                            >There is no data-supp folder or the filenames do not match.</p>
                        <p class="failtext"
                            >Please either create a data-supp folder for this article or check the filenames and correct where necessary.</p>
                    </td>
                    <td>
                        <xsl:for-each select="$supp-files-in-xml">
                            <p class="failtext">
                                <xsl:value-of select="."/>
                            </p>
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="$supp-files-in-xml and $supp-files-in-folder">
                <xsl:if test="count($supp-files-in-xml) = count($supp-files-in-folder)">
                    <tr>
                        <td class="th" rowspan="2">
                            <b>Supplementary files</b>
                        </td>
                        <td class="pass" rowspan="2">Pass</td>
                        <td class="head">Supplementary files available in the <a class="thText"
                            href="{$supp-files-home}">folder</a>.</td>
                        <td class="head">Supplementary files referenced in the <a class="thText"
                            href="{$content-store}/jats-xml/{$art-id}.xml">XML</a></td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="$supp-files-in-folder">
                                <p class="passtext">
                                    <xsl:value-of select="."/>
                                </p>
                            </xsl:for-each>
                        </td>
                        <td>
                            <xsl:for-each select="$supp-files-in-xml">
                                <p class="passtext">
                                    <xsl:value-of select="."/>
                                </p>
                            </xsl:for-each>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="count($supp-files-in-xml) != count($supp-files-in-folder)">
                    <tr>
                        <td class="th" rowspan="3">
                            <b>Supplementary files</b>
                        </td>
                        <td class="fail" rowspan="3">Fail</td>
                        <td class="head">Supplementary files available in the <a class="thText"
                            href="{$supp-files-home}">folder</a>.</td>
                        <td class="head">Supplementary files referenced in the <a class="thText"
                            href="{$content-store}/jats-xml/{$art-id}.xml">XML</a></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <p class="failtext"
                                >The supplementary file references in the document do not match the supplementary files in the folder.</p>
                            <p class="failtext"
                                >Please check the names of the files and change where necessary.</p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="$supp-files-in-folder">
                                <p class="failtext">
                                    <xsl:value-of select="."/>
                                </p>
                            </xsl:for-each>
                        </td>
                        <td>
                            <xsl:for-each select="$supp-files-in-xml">
                                <p class="failtext">
                                    <xsl:value-of select="."/>
                                </p>
                            </xsl:for-each>
                        </td>
                    </tr>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$graphics-folder-available = 'false'">
                <tr>
                    <td class="th" rowspan="2">
                        <b>Graphic files</b>
                    </td>
                    <td class="fail" rowspan="2">Fail</td>
                    <td class="head">Graphic files available in the <a class="thText"
                        href="{$content-store}/graphics">folder</a>.</td>
                    <td class="head">Graphic files referenced in the <a class="thText"
                        href="{$content-store}/jats-xml/{$art-id}.xml">XML</a></td>
                </tr>
                <tr>
                    <td>
                        <p class="failtext"
                            >There is no graphics folder available. Please create a graphics folder for this article.</p>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="$graphics-folder-available = 'true'">
                <xsl:message>
                    <xsl:text>This is the list of graphic files found in the xml: </xsl:text>
                    <xsl:value-of select="$graphics-info-xml-sorted"/>
                </xsl:message>
                <xsl:message>
                    <xsl:text>This is the list of graphic files found in the folder: </xsl:text>
                    <xsl:value-of select="$graphics-info-folder-sorted"/>
                </xsl:message>
                <xsl:if test="$graphics-info-xml-sorted = $graphics-info-folder-sorted">
                    <tr>
                        <td class="th" rowspan="2">
                            <b>Graphic files</b>
                        </td>
                        <td class="pass" rowspan="2">Pass</td>
                        <td class="head">Graphic files available in the <a class="thText"
                            href="{$content-store}/graphics">folder</a>.</td>
                        <td class="head">Graphic files referenced in the <a class="thText"
                            href="{$content-store}/jats-xml/{$art-id}.xml">XML</a></td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="$gff//graphic-folder/text()">
                                <p class="passtext">
                                    <xsl:value-of select="."/>
                                </p>
                            </xsl:for-each>
                        </td>
                        <td>
                            <xsl:for-each select="$gff//graphic-xml/text()">
                                <p class="passtext">
                                    <xsl:value-of select="."/>
                                </p>
                            </xsl:for-each>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:if test="$graphics-info-xml-sorted != $graphics-info-folder-sorted">
                    <tr>
                        <td class="th" rowspan="3">
                            <b>Graphic files</b>
                        </td>
                        <td class="fail" rowspan="3">Fail</td>
                        <td class="head">Graphic files available in the <a class="thText"
                            href="{$content-store}/graphics">folder</a>.</td>
                        <td class="head">Graphic files referenced in the <a class="thText"
                            href="{$content-store}/jats-xml/{$art-id}.xml">XML</a></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <p class="failtext"
                                >The graphic references in the document do not match the graphics in the folder.</p>
                            <p class="failtext"
                                >Check the names of the graphics listed below and correct where necessary.</p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <xsl:for-each select="$gff//graphic-folder/text()">
                                <p class="failtext">
                                    <xsl:value-of select="."/>
                                </p>
                            </xsl:for-each>
                        </td>
                        <td>
                            <xsl:for-each select="$gff//graphic-xml/text()">
                                <p class="failtext">
                                    <xsl:value-of select="."/>
                                </p>
                            </xsl:for-each>
                        </td>
                    </tr>
                </xsl:if>
            </xsl:if>
            
        </xsl:for-each>
        
    </xsl:template>
</xsl:stylesheet>

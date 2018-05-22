<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink">
    
    <xsl:output method="xhtml" indent="yes" encoding="UTF-8" media-type="text/html"/>
    
    <xsl:param name="infoset"/>
    <xsl:param name="info"/>
    <xsl:param name="process"/>
    
    <xsl:template name="header">
        <tr class="tr-header">
            <td class="td-section">Section</td>
            <td class="td-art-id">Article ID</td>
            <td class="td-title">Title</td>
            <td class="td-author">Author</td>
            <td class="td-added">Added</td>
            <td class="td-status-colour">QA&#x00A0;Report</td>
            <td class="td-status">Status</td>
            <td class="td-info">Info</td>
            <td class="td-batch">HWX Batch</td>
            <td class="td-embargo">Publication</td>
        </tr>
    </xsl:template>
    
    <xsl:template name="item">
        <tr>
            <td>
                <xsl:value-of select="meta[@name = 'section']"/>
            </td>
            <td>
                <xsl:value-of select="meta[@name = 'pub-id']"/>
                <xsl:text>&#x0020;</xsl:text>
                <xsl:text>(</xsl:text>
                <xsl:value-of select="meta[@name = 'file']"/>
                <xsl:text>)</xsl:text>
            </td>
            <td>
                <xsl:value-of select="meta[@name = 'title']"/>
            </td>
            <td>
                <xsl:value-of select="meta[@name = 'first-auth']"/>
            </td>
            <td>
                <xsl:value-of select="@tstamp"/>
            </td>
            <td>
                <div>
                    <xsl:if test="meta[@name = 'status'][not(@sent)]">
                        <xsl:if test="meta[@name = 'status']/text()[matches(., 'QA Pass')]">
                            <xsl:attribute name="class">
                                <xsl:text>status-pass</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="meta[@name = 'status']/text()[matches(., 'QA Warning')]">
                            <xsl:attribute name="class">
                                <xsl:text>status-warning</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="meta[@name = 'status']/text()[matches(., 'QA Fail')]">
                            <xsl:attribute name="class">
                                <xsl:text>status-fail</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="meta[@name = 'status']/text()[matches(., 'eXtyles XML Warning')]">
                            <xsl:attribute name="class">
                                <xsl:text>status-xml-warning</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="meta[@name = 'status']/text()[matches(., 'eXtyles XML Broken')]">
                            <xsl:attribute name="class">
                                <xsl:text>status-xml-broken</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="meta[@name = 'status']/@sent = 'true'">
                        <a href="{meta[@name='status']/@report}" target="_blank">
                            <xsl:text>Article Report</xsl:text>
                        </a>
                    </xsl:if>
                    <xsl:text>&#x00A0;</xsl:text>
                </div>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="meta[@name='status']/@sent = 'true'">
                        <xsl:value-of select="meta[@name = 'status']/text()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <a href="{meta[@name='status']/@report}" target="_blank">
                            <xsl:value-of select="meta[@name = 'status']/text()"/>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <xsl:if test="meta[@name='info']/text()">
                    <xsl:value-of select="meta[@name='info']"/>
                </xsl:if>
            </td>
            <td>
                <xsl:if test="meta[@name='hwbatch']">
                    <a target="_blank">
                        <xsl:attribute name="href">
                            <xsl:text>https://production.highwire.org/cgi/pestatus?peid=</xsl:text>
                            <xsl:value-of select="meta[@name='hwbatch']/text()"/>
                            <xsl:text>&amp;level=1&amp;phase=preintake</xsl:text>
                        </xsl:attribute>
                        <xsl:value-of select="meta[@name='hwbatch']/text()"/>
                    </a>
                    <a target="_blank">
                        <xsl:attribute name="href">
                            <xsl:text>https://www.bmj.com/content/</xsl:text>
                            <xsl:value-of select="meta[@name='vol']/text()"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="meta[@name='file']"/>
                        </xsl:attribute>
                        <xsl:text>Full Text Preview</xsl:text>
                    </a>
                </xsl:if>
            </td>
            <td>
                <xsl:if test="meta[@name='pub.hwx']/text()[matches(.,'send-to-hw-embargo')]">
                            <xsl:text>Embargo&#x00A0;for&#x00A0;</xsl:text>
                            <xsl:value-of select="meta[@name='embargo.date']/text()"/>
                            <xsl:text>&#x00A0;at&#x00A0;</xsl:text>
                            <xsl:value-of select="meta[@name='embargo.time']/text()"/>
                </xsl:if>
                <xsl:if test="meta[@name='pub.hwx']/text()[matches(.,'send-to-hw-green-to-go')]">
                    <xsl:text>Green&#x00A0;to&#x00A0;Go</xsl:text>
                </xsl:if>
                <xsl:if test="meta[@name='pub.hwx']/text()[matches(.,'ppr')]">
                    <xsl:text>Post Production Resend</xsl:text>
                </xsl:if>
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Prodtracker</title>
                <link href="../../../src/resources/css/prodtracker-table.css" rel="stylesheet" type="text/css"/>
            </head>
            <body>
                <table class="section-selection">
                    <tr>
                        <xsl:for-each-group select="//item" group-by="meta[@name = 'section']">
                            <xsl:sort select="meta[@name = 'section']/text()" order="ascending"/>
                            <td class="section-box">
                                <a href="#{meta[@name = 'section']}">
                                    <xsl:value-of select="current-grouping-key()"/>
                                </a>
                            </td>
                        </xsl:for-each-group>
                    </tr>
                </table>
                <table id="myTable" class="all-items">
                    <thead class="main-thead-grouping">
                        <tr>
                            <th colspan="10">All items (Newest to Oldest)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:call-template name="header"/>
                        <xsl:for-each select="//item">
                            <xsl:sort select="@tstamp" order="descending"/>
                            <xsl:call-template name="item"/>
                        </xsl:for-each>
                    </tbody>
                </table>
                <table class="items-by-section">
                    <thead class="main-thead-grouping">
                        <tr>
                            <th colspan="10">Items by Section</th>
                        </tr>
                    </thead>
                </table>
                <xsl:for-each-group select="//item" group-by="meta[@name = 'section']">
                    <xsl:sort select="meta[@name = 'section']/text()" order="ascending"/>
                    <table class="section-grouping">
                        <thead>
                            <tr class="section-grouping">
                                <td colspan="10" id="{meta[@name = 'section']}">
                                    <xsl:value-of select="meta[@name = 'section']"/>
                                </td>
                            </tr>
                        </thead>
                        <tbody class="section-grouping">
                            <xsl:call-template name="header"/>
                            <xsl:for-each select="current-group()">
                                <xsl:sort select="@tstamp" order="descending"/>
                                <xsl:call-template name="item"/>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </xsl:for-each-group>
            </body>
        </html>
    </xsl:template>
    
</xsl:stylesheet>

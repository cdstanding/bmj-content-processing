<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

 
     
     <xsl:template name="lib-authors-model-a">
          <xsl:param name="contrib-group"/>
          <xsl:param name="author-notes"/>
          <xsl:param name="series-title-label"/>
          
          <xsl:text>&#x0A;</xsl:text>
          <xsl:for-each select="$contrib-group//contrib">
               <xsl:if test="position() !=1">
                    <xsl:text>&#x2028;</xsl:text>
               </xsl:if>
               <xsl:variable name="myadd">
                    <xsl:value-of select="./xref/@rid"/>
               </xsl:variable>
<!--               <xsl:call-template name="add-paragraph-return"/>-->
               <xsl:variable name="myname">
                    <xsl:if test="$series-title-label!=''">
                         <xsl:value-of select="$series-title-label"/>
                         <xsl:text>-</xsl:text>
                    </xsl:if>
               </xsl:variable>
               <xsl:element name="{concat($myname,'contrib')}">
                    <xsl:choose>
                         <xsl:when test="./collab">
                              <xsl:copy-of select="." copy-namespaces="no"/>
                              <xsl:text>&#x0A;</xsl:text>
                         </xsl:when>
                         <xsl:when test="./name">
                              <xsl:element name="name">
                                   <xsl:apply-templates select="./name/given-names"/>
                                   <xsl:text> </xsl:text>
                                   <xsl:apply-templates select="./name/surname"/>
                              </xsl:element>
                         </xsl:when>
                    </xsl:choose>
                    
                    <xsl:if test="./role">
                         <xsl:text> </xsl:text>
<!--                         <xsl:copy-of select="./role" copy-namespaces="no"/>-->
                         <xsl:apply-templates select="./role"/>
                         
                    </xsl:if>
                    <xsl:if test="$myadd!='' and count(//aff) !=1">
                         <xsl:text>, </xsl:text>
                         <xsl:apply-templates select="../aff[@id=$myadd]" mode="author-model-a"/>
                    </xsl:if>
                    <xsl:if test="count(//aff)=1">
                         <xsl:text>, </xsl:text>
                         <xsl:apply-templates select="//aff" mode="author-model-a"/>
                    </xsl:if>
                    
                    <xsl:if test="./email">
                         <xsl:text> </xsl:text>
<!--                         <xsl:copy-of select="./email" copy-namespaces="no"/>-->
                         <xsl:apply-templates select="./email"/>
                    </xsl:if>
                    <xsl:if test="@corresp='yes'">
                         <xsl:text> </xsl:text>
<!--                         <xsl:copy-of select="$author-notes//email" copy-namespaces="no"/>-->
                         <xsl:apply-templates select="$author-notes//email"/>
                    </xsl:if>
               </xsl:element>
               
               
          </xsl:for-each>
          <xsl:call-template name="process-on-behalf-of">
               <xsl:with-param name="contrib-group" select="$contrib-group"/>
          </xsl:call-template>
     </xsl:template>
          
     <xsl:template name="lib-authors-model-views">
          <xsl:param name="contrib-group"/>
          <xsl:param name="author-notes"/>
          <xsl:param name="art-section"/>
          <xsl:param name="series-title-label"/>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:variable name="myname">
               <xsl:if test="$series-title-label!=''">
                    <xsl:value-of select="$series-title-label"/>
                    <xsl:text>-</xsl:text>
               </xsl:if>
               <xsl:text>contrib</xsl:text>
          </xsl:variable>
          <xsl:for-each select="$contrib-group//contrib">
               <xsl:if test="position() !=1">
                    <xsl:text>&#x2028;</xsl:text>
               </xsl:if>
               <xsl:variable name="myadd">
                    <xsl:value-of select="./xref/@rid"/>
               </xsl:variable>
               <!--               <xsl:call-template name="add-paragraph-return"/>-->
               <xsl:element name="{$myname}">
                    <xsl:choose>
                         <xsl:when test="./collab">
                              <xsl:copy-of select="." copy-namespaces="no"/>
                              <xsl:text>&#x0A;</xsl:text>
                         </xsl:when>
                         <xsl:when test="./name">
                              <xsl:element name="name">
                                   <xsl:apply-templates select="./name/given-names"/>
                                   <xsl:text> </xsl:text>
                                   <xsl:apply-templates select="./name/surname"/>
                              </xsl:element>
                         </xsl:when>
                    </xsl:choose>
                    <!--<xsl:choose>
                         <xsl:when test="./role and $series-title-label ='MC'">
                              <xsl:text> </xsl:text>
                              <xsl:copy-of select="./role" copy-namespaces="no"/>
                         </xsl:when>
                         <xsl:when test="./role and $art-section='views' and count($contrib-group//contrib) gt 1">
                              <xsl:text> is </xsl:text>
                              <xsl:copy-of select="./role" copy-namespaces="no"/>
                         </xsl:when>
                         <xsl:when test="./role and $art-section='views' and count($contrib-group//contrib) gt 1">
                              <xsl:text> is </xsl:text>
                              <xsl:copy-of select="./role" copy-namespaces="no"/>
                         </xsl:when>
                         <xsl:when test="./role and $art-section='views'">
                              <xsl:text> is </xsl:text>
                              <xsl:copy-of select="./role" copy-namespaces="no"/>
                              </xsl:when>
                         <xsl:otherwise>
                              <xsl:text> </xsl:text>
                              <xsl:copy-of select="./role" copy-namespaces="no"/>
                         </xsl:otherwise>
                         </xsl:choose>-->
                    <xsl:choose>
                         <xsl:when test="./role and $series-title-label ='MC'">
                              <xsl:text> </xsl:text>
                              <xsl:apply-templates select="./role"/>
                         </xsl:when>
                         <xsl:when test="./role and $art-section='views' and count($contrib-group//contrib) gt 1">
                              <xsl:text> is </xsl:text>
                              <xsl:apply-templates select="./role"/>
                         </xsl:when>
                         <xsl:when test="./role and $art-section='views' and count($contrib-group//contrib) gt 1">
                              <xsl:text> is </xsl:text>
                              <xsl:apply-templates select="./role/node()" /> 
                         </xsl:when>
                         <xsl:when test="./role and $art-section='views'">
                              <xsl:text> is </xsl:text>
                              <xsl:apply-templates select="./role"/>
                         </xsl:when>
                         <xsl:otherwise>
                              <xsl:text> </xsl:text>
                              <xsl:apply-templates select="./role"/>
                         </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:if test="$myadd!='' and count(//aff) !=1">
                         <xsl:text>, </xsl:text>
                         <xsl:apply-templates select="../aff[@id=$myadd]" mode="author-model-a"/>
                    </xsl:if>
                    <xsl:if test="count(//aff)=1">
                         <xsl:text>, </xsl:text>
                         <xsl:apply-templates select="//aff" mode="author-model-a"/>
                    </xsl:if>
                    
                    <xsl:if test="./email">
                         <xsl:text> </xsl:text>
                         <xsl:apply-templates select="./email"/>
                    </xsl:if>
                    <xsl:if test="@corresp='yes'">
                         <xsl:text> </xsl:text>
                         <xsl:apply-templates select="$author-notes//email"/>
                    </xsl:if>
               </xsl:element>
          </xsl:for-each>
          <xsl:call-template name="process-on-behalf-of">
               <xsl:with-param name="contrib-group" select="$contrib-group"/>
               <xsl:with-param name="series-title-label" select="$series-title-label"/>
          </xsl:call-template>
     </xsl:template>
     
     <xsl:template name="lib-authors-model-endgames">
          <xsl:param name="contrib-group"/>
          <xsl:param name="author-notes"/>
          <xsl:param name="art-section"/>
          <xsl:param name="series-title-label"/>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:variable name="myname">
               <xsl:if test="$series-title-label!=''">
                    <xsl:value-of select="$series-title-label"/>
                    <xsl:text>-</xsl:text>
               </xsl:if>
               <xsl:text>contrib</xsl:text>
          </xsl:variable>
          <xsl:element name="{$myname}">
               <xsl:text>Submitted by </xsl:text>
               <xsl:for-each select="$contrib-group//contrib">
                    <xsl:if test="position() !=1 and count($contrib-group//contrib) > 2">
                         <xsl:text>,</xsl:text>
                    </xsl:if>
                    <xsl:if test="position() !=1">
                         <xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:if test="count($contrib-group//contrib) > 1 and position() =last()">
                         <xsl:text>and </xsl:text>
                    </xsl:if>
                         <xsl:choose>
                              <xsl:when test="./collab">
                                   <xsl:copy-of select="." copy-namespaces="no"/>
                                   <xsl:text>&#x0A;</xsl:text>
                              </xsl:when>
                              <xsl:when test="./name">
                                   <xsl:element name="name">
                                        <xsl:apply-templates select="./name/given-names"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:apply-templates select="./name/surname"/>
                                   </xsl:element>
                              </xsl:when>
                         </xsl:choose>
               </xsl:for-each>
          </xsl:element>
          
          <xsl:call-template name="process-on-behalf-of">
               <xsl:with-param name="contrib-group" select="$contrib-group"/>
               <xsl:with-param name="series-title-label" select="$series-title-label"/>
          </xsl:call-template>
     </xsl:template>
     
     
     
     <xsl:template name="lib-authors-model-news">
          <xsl:param name="contrib-group"/>
          <xsl:param name="author-notes"/>
          <xsl:param name="art-section"/>
          <xsl:param name="series-title-label"/>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:variable name="myname">
               <xsl:if test="$series-title-label!=''">
                    <xsl:value-of select="$series-title-label"/>
                    <xsl:text>-</xsl:text>
               </xsl:if>
               <xsl:text>contrib</xsl:text>
          </xsl:variable>
          <xsl:for-each select="$contrib-group//contrib">
               <xsl:if test="position() !=1">
                    <xsl:text>&#x2028;</xsl:text>
               </xsl:if>
               <xsl:variable name="myadd">
                    <xsl:value-of select="./xref/@rid"/>
               </xsl:variable>
               <!--               <xsl:call-template name="add-paragraph-return"/>-->
               <xsl:element name="{$myname}">
                    <xsl:choose>
                         <xsl:when test="./collab">
                              <xsl:copy-of select="." copy-namespaces="no"/>
                              <xsl:text>&#x0A;</xsl:text>
                         </xsl:when>
                         <xsl:when test="./name">
                              <xsl:element name="name">
                                   <xsl:apply-templates select="./name/given-names"/>
                                   <xsl:text> </xsl:text>
                                   <xsl:apply-templates select="./name/surname"/>
                              </xsl:element>
                         </xsl:when>
                    </xsl:choose>
                    <xsl:if test="./role">
                         <xsl:text> </xsl:text>
                         <xsl:copy-of select="./role" copy-namespaces="no"/>
                    </xsl:if>
                    
                    <xsl:if test="$myadd!='' and count(//aff) !=1">
                         <xsl:text> </xsl:text>
                         <xsl:apply-templates select="../aff[@id=$myadd]" mode="news"/>
                    </xsl:if>
                    <xsl:if test="count(//aff)=1">
                         <xsl:text> </xsl:text>
                         <xsl:apply-templates select="//aff" mode="news"/>
                    </xsl:if>
                    
                    <xsl:if test="./email">
                         <xsl:text> </xsl:text>
                         <xsl:copy-of select="./email" copy-namespaces="no"/>
                    </xsl:if>
                    <xsl:if test="@corresp='yes'">
                         <xsl:text> </xsl:text>
                         <xsl:copy-of select="$author-notes//email" copy-namespaces="no"/>
                    </xsl:if>
               </xsl:element>
          </xsl:for-each>
          <xsl:call-template name="process-on-behalf-of">
               <xsl:with-param name="contrib-group" select="$contrib-group"/>
               <xsl:with-param name="series-title-label" select="$series-title-label"/>
          </xsl:call-template>
     </xsl:template>
     
     
     
     <xsl:template name="lib-authors-model-analysis">
          <xsl:param name="journal"/>
          <xsl:param name="contrib-group"/>
          <xsl:param name="author-notes"/>
          <xsl:param name="art-section"/>
          <xsl:param name="series-title-label"/>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:for-each select="$contrib-group//contrib">
               <xsl:variable name="myname">
                    <xsl:if test="$series-title-label!=''">
                         <xsl:value-of select="$series-title-label"/>
                         <xsl:text>-</xsl:text>
                    </xsl:if>
                    <xsl:text>contrib</xsl:text>
                    <xsl:if test="position() =1 and $journal='sbmj'">
                         <xsl:text>-1</xsl:text>
                    </xsl:if>
               </xsl:variable>
               <xsl:if test="position() !=1">
                    <xsl:text>&#x0A;</xsl:text>
               </xsl:if>
               <xsl:variable name="myadd">
                    <xsl:value-of select="./xref/@rid"/>
               </xsl:variable>
               <!--               <xsl:call-template name="add-paragraph-return"/>-->
               <xsl:element name="{$myname}">
                    <xsl:choose>
                         <xsl:when test="./collab">
                              <xsl:copy-of select="." copy-namespaces="no"/>
                              <xsl:text>&#x0A;</xsl:text>
                         </xsl:when>
                         <xsl:when test="./name">
                              <xsl:element name="name">
                                   <xsl:apply-templates select="./name/given-names"/>
                                   <xsl:text> </xsl:text>
                                   <xsl:apply-templates select="./name/surname"/>
                              </xsl:element>
                         </xsl:when>
                    </xsl:choose>
                    <xsl:if test="./role">
                         <xsl:text> </xsl:text>
                         <xsl:copy-of select="./role" copy-namespaces="no"/>
                    </xsl:if>
                    <xsl:if test="$myadd!='' and count(//aff) !=1">
                         <xsl:text>, </xsl:text>
                         <xsl:apply-templates select="../aff[@id=$myadd]" mode="author-model-a"/>
                    </xsl:if>
                    <xsl:if test="count(//aff)=1">
                         <xsl:text>, </xsl:text>
                         <xsl:apply-templates select="//aff" mode="author-model-a"/>
                    </xsl:if>
                    <xsl:if test="./email">
                         <xsl:text> </xsl:text>
                         <xsl:copy-of select="./email" copy-namespaces="no"/>
                    </xsl:if>
               </xsl:element>
          </xsl:for-each>
          <xsl:call-template name="process-on-behalf-of">
               <xsl:with-param name="contrib-group" select="$contrib-group"/>
               <xsl:with-param name="series-title-label" select="$series-title-label"/>
          </xsl:call-template>
          <xsl:if test="$author-notes//corresp">
               <xsl:text>&#x0A;</xsl:text>
               <xsl:apply-templates select="$author-notes//corresp"/>
          </xsl:if>
     </xsl:template>
     
     
     <xsl:template name="lib-authors-model-careers">
          <xsl:param name="contrib-group"/>
          <xsl:param name="author-notes"/>
          <xsl:param name="art-section"/>
          <xsl:param name="series-title-label"/>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:variable name="myname">
               <xsl:if test="$series-title-label!=''">
                    <xsl:value-of select="$series-title-label"/>
                    <xsl:text>-</xsl:text>
               </xsl:if>
               <xsl:text>contrib</xsl:text>
          </xsl:variable>
          <xsl:for-each select="$contrib-group//contrib">
               <xsl:if test="position() !=1">
                    <xsl:text>&#x0A;</xsl:text>
               </xsl:if>
               <xsl:variable name="myadd">
                    <xsl:value-of select="./xref/@rid"/>
               </xsl:variable>
               <!--               <xsl:call-template name="add-paragraph-return"/>-->
               <xsl:element name="{$myname}">
                    <xsl:choose>
                         <xsl:when test="./collab">
                              <xsl:copy-of select="." copy-namespaces="no"/>
                              <xsl:text>&#x0A;</xsl:text>
                         </xsl:when>
                         <xsl:when test="./name">
                              <xsl:element name="name">
                                   <xsl:apply-templates select="./name/given-names"/>
                                   <xsl:text> </xsl:text>
                                   <xsl:apply-templates select="./name/surname"/>
                              </xsl:element>
                         </xsl:when>
                    </xsl:choose>
                    <xsl:if test="./role">
                         <xsl:text>, </xsl:text>
                         <xsl:copy-of select="./role" copy-namespaces="no"/>
                    </xsl:if>
                    <xsl:if test="$myadd!='' and count(//aff) !=1">
                         <xsl:text>, </xsl:text>
                         <xsl:apply-templates select="../aff[@id=$myadd]" mode="author-model-a"/>
                    </xsl:if>
                    <xsl:if test="count(//aff)=1">
                         <xsl:text>, </xsl:text>
                         <xsl:apply-templates select="//aff" mode="author-model-a"/>
                    </xsl:if>
                    <xsl:if test="./email">
                         <xsl:text> </xsl:text>
                         <xsl:copy-of select="./email" copy-namespaces="no"/>
                    </xsl:if>
               </xsl:element>
          </xsl:for-each>
          <xsl:call-template name="process-on-behalf-of">
               <xsl:with-param name="contrib-group" select="$contrib-group"/>
               <xsl:with-param name="series-title-label" select="$series-title-label"/>
          </xsl:call-template>
          <xsl:if test="$author-notes//corresp">
               <xsl:text>&#x2028;</xsl:text>
               <xsl:apply-templates select="$author-notes//corresp"/>
          </xsl:if>
     </xsl:template>
     
     
     
     
     <xsl:template name="lib-authors-model-minerva">
          <xsl:param name="contrib-group"/>
          <xsl:param name="author-notes"/>
          <xsl:param name="art-section"/>
          <xsl:param name="series-title-label"/>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:variable name="myname">
               <xsl:if test="$series-title-label!=''">
                    <xsl:value-of select="$series-title-label"/>
                    <xsl:text>-</xsl:text>
               </xsl:if>
               <xsl:text>contrib</xsl:text>
          </xsl:variable>
          <xsl:for-each select="$contrib-group//contrib">
               <xsl:if test="position() !=1">
                    <xsl:text>, </xsl:text>
               </xsl:if>
               <xsl:variable name="myadd">
                    <xsl:value-of select="./xref/@rid"/>
               </xsl:variable>
               <!--               <xsl:call-template name="add-paragraph-return"/>-->
               <xsl:element name="{$myname}">
                    <xsl:choose>
                         <xsl:when test="./collab">
                              <xsl:apply-templates select="./collab"/>
                              <xsl:text>&#x0A;</xsl:text>
                         </xsl:when>
                         <xsl:when test="./name">
                              <xsl:element name="name">
                                   <xsl:apply-templates select="./name/given-names"/>
                                   <xsl:text> </xsl:text>
                                   <xsl:apply-templates select="./name/surname"/>
                              </xsl:element>
                         </xsl:when>
                    </xsl:choose>
                    <xsl:if test="@corresp='yes'">
                         <xsl:text> (</xsl:text>
                         <xsl:apply-templates select="$author-notes//email"/>
                         <xsl:text>)</xsl:text>
                    </xsl:if>
                    <xsl:if test="./role">
                         <xsl:text>, </xsl:text>
                         <xsl:apply-templates select="./role"/>
                    </xsl:if>
                    <xsl:if test="$myadd!='' and count(//aff) !=1 and ((following-sibling::contrib[1]/xref/@rid !=$myadd) or position()=last())">
                         <xsl:text>, </xsl:text>
                         <xsl:apply-templates select="../aff[@id=$myadd]" mode="author-model-a"/>
                    </xsl:if>
                    
                    <xsl:if test="position()=last() and count(//aff) =1">
                         <xsl:text>, </xsl:text>
                         <xsl:apply-templates select="../aff" mode="author-model-a"/>
                    </xsl:if>
               </xsl:element>
          </xsl:for-each>
          <xsl:call-template name="process-on-behalf-of">
               <xsl:with-param name="contrib-group" select="$contrib-group"/>
               <xsl:with-param name="series-title-label" select="$series-title-label"/>
          </xsl:call-template>
     </xsl:template>


     <xsl:template name="lib-authors-model-research">
          <xsl:param name="contrib-group"/>
          <xsl:param name="author-notes"/>
          <xsl:param name="series-title-label"/>
          <xsl:variable name="myname">
               <xsl:if test="$series-title-label!=''">
                    <xsl:value-of select="$series-title-label"/>
                    <xsl:text>-</xsl:text>
               </xsl:if>
               <xsl:text>contrib</xsl:text>
          </xsl:variable>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="{$myname}">
               <xsl:for-each select="$contrib-group//contrib">
                    <xsl:if test="position() !=1">
                         <xsl:text> </xsl:text>
                    </xsl:if>
                    <xsl:variable name="myadd">
                         <xsl:value-of select="./xref/@rid"/>
                    </xsl:variable>
                    <!--               <xsl:call-template name="add-paragraph-return"/>-->
                    
                         <xsl:choose>
                              <xsl:when test="./collab">
                                   <xsl:copy-of select="." copy-namespaces="no"/>
                                   <xsl:text>&#x0A;</xsl:text>
                              </xsl:when>
                              <xsl:when test="./name">
                                   <xsl:element name="name">
                                        <xsl:apply-templates select="./name/given-names"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:apply-templates select="./name/surname"/>
                                   </xsl:element>
                              </xsl:when>
                         </xsl:choose>
                         
                         <!--<xsl:if test="./role">
                              <xsl:text> </xsl:text>
                              <xsl:copy-of select="./role" copy-namespaces="no"/>
                              </xsl:if>-->
                         <xsl:if test="$myadd!='' and count(//aff) !=1 and not(position()=last())">
                              <xsl:text>,</xsl:text>
                              <xsl:element name="address-label">
                                   <xsl:for-each select="./xref[@ref-type='aff']">
                                        <xsl:if test="position()!=1">
                                             <xsl:text> </xsl:text>
                                        </xsl:if>
                                        <xsl:apply-templates/>
                                   </xsl:for-each>
                              </xsl:element>
                         </xsl:if>
                    <xsl:if test="$myadd!='' and count(//aff) =1 and not(position()=last())">
                         <xsl:text>,</xsl:text>
                    </xsl:if>
                    <xsl:if test="$myadd='' and count(//aff) =1 and not(position()=last())">
                         <xsl:text>,</xsl:text>
                    </xsl:if>
                    <xsl:if test="$myadd='' and count(//aff) =0 and count(//contrib)&gt;1 and not(position()=last())">
                         <xsl:text>,</xsl:text>
                    </xsl:if>
                    <xsl:if test="position()=last() and count(//aff) &gt;1">
                              <xsl:if test="$contrib-group//on-behalf-of">
                                   <xsl:text>,</xsl:text>
                              </xsl:if>
                              <xsl:element name="address-label">
                                   <xsl:for-each select="./xref[@ref-type='aff']">
                                        <xsl:if test="position()!=1">
                                             <xsl:text> </xsl:text>
                                        </xsl:if>
                                        <xsl:apply-templates/>
                                   </xsl:for-each>
                              </xsl:element>
                         </xsl:if>
                    <!--<xsl:if test="position()=last() and count(//aff)=1">
                              <xsl:element name="address-label">
                                   <xsl:text>1</xsl:text>
                              </xsl:element>
                         </xsl:if>-->
               </xsl:for-each>
               <xsl:call-template name="process-on-behalf-of">
                    <xsl:with-param name="contrib-group" select="$contrib-group"/>
               </xsl:call-template>
          </xsl:element>
          
          
     </xsl:template>

     <xsl:template name="lib-author-info-model-research">
          <xsl:param name="series-title-label"/>
          <xsl:param name="contrib-group"/>
          <xsl:param name="author-notes"/>
          <xsl:for-each select="$contrib-group//aff">
               <xsl:variable name="myname">
                    <xsl:if test="$series-title-label!=''">
                         <xsl:value-of select="$series-title-label"/>
                         <xsl:text>-</xsl:text>
                    </xsl:if>
                    <xsl:text>address</xsl:text>
               </xsl:variable>
               <xsl:text>&#x0A;</xsl:text>
               <xsl:element name="{$myname}">
                    <xsl:apply-templates mode="author-model-research"/> 
               </xsl:element>
          </xsl:for-each>
          <xsl:if test="$author-notes//corresp">
               <xsl:text>&#x0A;</xsl:text>
               <xsl:apply-templates select="$author-notes//corresp"/>
          </xsl:if>
     </xsl:template>
     
     
     
     
     <xsl:template name="meta-author">
          <xsl:param name="contrib-group"/>
          <p>
               
               <xsl:if test="count(//aff)=1">
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="//aff"/>
                    <xsl:element name="br"/>
               </xsl:if>
          </p>
     </xsl:template>
     
     <xsl:template name="process-on-behalf-of">
          <xsl:param name="contrib-group"/>
          <xsl:param name="series-title-label"/>
          <xsl:variable name="myname">
               <xsl:if test="$series-title-label!=''">
                    <xsl:value-of select="$series-title-label"/>
                    <xsl:text>-</xsl:text>
               </xsl:if>
               <xsl:text>on-behalf-of</xsl:text>
          </xsl:variable>
          <xsl:for-each select="$contrib-group//on-behalf-of">
               <xsl:text> </xsl:text>
               <xsl:element name="{$myname}">
                    <xsl:apply-templates/>
               </xsl:element>
          </xsl:for-each>
     </xsl:template>
     
     <xsl:template match="aff">
          <xsl:apply-templates/>
     </xsl:template>
     <xsl:template match="aff" mode="news">
          <xsl:element name="address">
               <xsl:apply-templates mode="#current"/>
          </xsl:element>
     </xsl:template>
     
     <xsl:template match="aff/label" mode="author-model-a"/>
     <xsl:template match="aff/label" mode="author-model-research">
          <xsl:if test="count(//aff) !=1">
               <xsl:element name="address-label">
                    <xsl:apply-templates/>
               </xsl:element>
          </xsl:if>
     </xsl:template>
     <xsl:template match="aff/label" mode="news"/>
     
</xsl:stylesheet>

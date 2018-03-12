<?xml version="1.0"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xalanredirect="org.apache.xalan.xslt.extensions.Redirect"
  extension-element-prefixes="xalanredirect"
  version="2.0">

  <xsl:strip-space elements="*"/>
  
  <xsl:param name="diff-instance-self-type"/><!-- select="string('source')"--> 
  <xsl:param name="diff-instance-self-meta-uri" />
  <xsl:param name="diff-instance-compared-uri" />
  <xsl:param name="diff-instance-compared-doc" select="document(replace($diff-instance-compared-uri, '\\', '/'))" />
  
  <xsl:param name="redline-start-pi">
    <xsl:choose>
      <xsl:when test="$diff-instance-self-type='source'">
        <xsl:processing-instruction name="serna-redline-start" select="string('1000 ')"/>    
      </xsl:when>
      <xsl:when test="$diff-instance-self-type='target'">
        <xsl:processing-instruction name="serna-redline-start" select="string('400 ')"/>    
      </xsl:when>
      <xsl:otherwise>
        <xsl:processing-instruction name="serna-redline-start" select="string('0 ')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="redline-end-pi">
    <xsl:processing-instruction name="serna-redline-end" />
  </xsl:param>
  
  <xsl:template match="__xh_outer">
    <xsl:call-template name="diffmarkup">
      <xsl:with-param name="root" select="."/>
      <xsl:with-param name="type" select="@__xh_docType"/>
      <xsl:with-param name="merge" select="@__xh_merge"/>
      <xsl:with-param name="threeway" select="@__xh_threeway"/>
      <xsl:with-param name="unmatchedSourceColor" select="@__xh_unmatchedSourceColor"/>
      <xsl:with-param name="unmatchedTargetColor" select="@__xh_unmatchedTargetColor"/>
      <xsl:with-param name="movedColor" select="@__xh_movedColor"/>
      <xsl:with-param name="acceptedChangeColor" select="@__xh_acceptedChangeColor"/>
      <xsl:with-param name="rejectedChangeColor" select="@__xh_rejectedChangeColor"/>
      <xsl:with-param name="acceptedOldChangeColor" select="@__xh_acceptedOldChangeColor"/>
      <xsl:with-param name="rejectedOldChangeColor" select="@__xh_rejectedOldChangeColor"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="diffmarkup">
    <xsl:param name="root"/>
    <xsl:param name="type"/>
    <xsl:param name="merge"/>
    <xsl:param name="threeway"/>
    <xsl:param name="unmatchedSourceColor"/>
    <xsl:param name="unmatchedTargetColor"/>
    <xsl:param name="movedColor"/>
    <xsl:param name="acceptedChangeColor"/>
    <xsl:param name="rejectedChangeColor"/>
    <xsl:param name="acceptedOldChangeColor"/>
    <xsl:param name="rejectedOldChangeColor"/>
    <xsl:apply-templates select="$root/*"/>
  </xsl:template>

  <xsl:template match="__xh_doc">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="__xh_ai">
    
    <xsl:choose>
      
      <xsl:when test="name()='noNamespaceSchemaLocation'"/>
      
      <xsl:when test="__xh_change">
        
        <xsl:call-template name="process-change">
          <xsl:with-param name="elt" select="."/>
          <xsl:with-param name="ancestor-is-attribute" select="string('true')"/>
          <xsl:with-param name="redline-type" select="string('start')"/>
          <xsl:with-param name="xh-diff-pi">
            <xsl:processing-instruction name="xh-diff-pi" select="concat('matched:', @__xh_matched, ' mId:', @__xh_mId, ' id:', @__xh_id)"/>  
          </xsl:with-param>
        </xsl:call-template>
        
        <xsl:text disable-output-escaping="yes"> </xsl:text>
        <xsl:choose>
          <xsl:when test="@__xh_ni">
            <xsl:value-of select="@__xh_nsName"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="@__xh_pf">
              <xsl:value-of select="@__xh_pf"/>
              <xsl:text>:</xsl:text>
            </xsl:if>
            <xsl:value-of select="name(.)"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>="</xsl:text>
        <xsl:apply-templates>
          <xsl:with-param name="ancestor-is-attribute" select="string('true')"/>
        </xsl:apply-templates>
        <xsl:text>"</xsl:text>
        
        <xsl:call-template name="process-change">
          <xsl:with-param name="ancestor-is-attribute" select="string('true')"/>
          <xsl:with-param name="redline-type" select="string('end')"/>
        </xsl:call-template>
        
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:text disable-output-escaping="yes"> </xsl:text>
        <xsl:choose>
          <xsl:when test="@__xh_ni">
            <xsl:value-of select="@__xh_nsName"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="@__xh_pf">
              <xsl:value-of select="@__xh_pf"/>
              <xsl:text>:</xsl:text>
            </xsl:if>
            <xsl:value-of select="name(.)"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>="</xsl:text>
        <xsl:apply-templates>
          <xsl:with-param name="ancestor-is-attribute" select="string('true')"/>
        </xsl:apply-templates>
        <xsl:text>"</xsl:text>
      </xsl:otherwise>
      
    </xsl:choose>
    
  </xsl:template>

  <xsl:template match="__xh_txt">
    <xsl:param name="ancestor-is-attribute"/>
    
    <xsl:choose>
      
      <xsl:when 
        test="
        string-length(normalize-space(.))=0
        
        and 
        (
        preceding-sibling::element()[1][name()!='__xh_txt']
        or following-sibling::element()[1][name()!='__xh_txt']
        )
        ">
        <!--<xsl:comment>eronious white space redline ignored</xsl:comment>-->
      </xsl:when>
      
      <!--<xsl:when test="__xh_change or __xh_st/__xh_change">-->
      <xsl:when test="__xh_change"><!--  and not(__xh_st/__xh_change) -->
        
        <xsl:choose>
          
          <xsl:when test="@__xh_attr">
            
            <xsl:call-template name="process-change">
              <xsl:with-param name="elt" select="."/>
              <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
              <xsl:with-param name="redline-type" select="string('start')"/>
              <xsl:with-param name="xh-diff-pi">
                <xsl:processing-instruction name="xh-diff-pi" select="concat('matched:', @__xh_matched, ' mId:', @__xh_mId, ' id:', @__xh_id)"/>  
              </xsl:with-param>
            </xsl:call-template>
            
            <xsl:apply-templates select="__xh_st">
              <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
            </xsl:apply-templates>
            
            <xsl:call-template name="process-change">
              <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
              <xsl:with-param name="redline-type" select="string('end')"/>
            </xsl:call-template>
            
          </xsl:when>
          
          <xsl:otherwise>
            
            <!--<xsl:call-template name="process-change">
              <xsl:with-param name="elt" select="."/>
              <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
              <xsl:with-param name="redline-type" select="string('start')"/>
              <xsl:with-param name="xh-diff-pi">
                <xsl:processing-instruction name="xh-diff-pi" select="concat('matched:', @__xh_matched, ' mId:', @__xh_mId, ' id:', @__xh_id)"/>  
              </xsl:with-param>
            </xsl:call-template>-->
            
            <xsl:apply-templates select="__xh_st">
              <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
            </xsl:apply-templates>
            
            <!--<xsl:call-template name="process-change">
              <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
              <xsl:with-param name="redline-type" select="string('end')"/>
            </xsl:call-template>-->
            
          </xsl:otherwise>
          
        </xsl:choose>
        
      </xsl:when>
      
      <xsl:otherwise>
        
        <xsl:choose>
          
          <xsl:when test="@__xh_attr">
              <xsl:apply-templates select="__xh_st">
                <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
              </xsl:apply-templates>
          </xsl:when>
          
          <xsl:otherwise>
            
              <xsl:apply-templates select="__xh_st">
                  <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
              </xsl:apply-templates>
            
          </xsl:otherwise>
          
        </xsl:choose>
        
      </xsl:otherwise>
      
    </xsl:choose>
    
  </xsl:template>

  <xsl:template match="__xh_st">
    <xsl:param name="ancestor-is-attribute"/>
    
    <xsl:choose>
      
      <!-- source: 
      <__xh_st __xh_id="s64_4" __xh_matched="ums" __xh_show="">
      
        <__xh_change __xh_accepted="accepted" __xh_changeId="6" __xh_changeType="text_change"
        __xh_changedNodeId="s64" __xh_matchedNodeId="t77" />
        
        More 
        
      </__xh_st>
      -->
      
      <!-- target: 
      <__xh_txt __xh_id="t61" __xh_matched="umt" __xh_show="">
        
        <__xh_change __xh_accepted="accepted" __xh_changeId="3" __xh_changeType="text_um"
          __xh_changedNodeId="t61" __xh_matchedNodeId="-1" />
        
        <__xh_st __xh_id="t61_0" __xh_matched="umt" __xh_show="">More than 80% of children
          experience at least one episode of AOM before the age of 2 years with a peak
          incidence between 6 and 18 months.</__xh_st>
        
      </__xh_txt>
      -->
      
      <!--<xsl:when 
        test="
        self::__xh_st[@__xh_matched='ums' or @__xh_matched='umt']
        /__xh_change[@__xh_changeType='text_change']
        
        or
        
        self::__xh_st
        [
        @__xh_matched='ums' or @__xh_matched='umt' 
        and parent::__xh_txt/__xh_change
        [@__xh_changeType='text_um' and @__xh_matchedNodeId='-1']
        ]
        ">
        
        <xsl:choose>
          
          <xsl:when test="string-length(normalize-space(.))=0">
            <xsl:text disable-output-escaping="yes"> </xsl:text>
          </xsl:when>
          
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
          
        </xsl:choose>
        
      </xsl:when>-->
      
      <xsl:when test="self::__xh_st[@__xh_matched!='ma' and @__xh_matched!='lma']">
        
        <xsl:call-template name="process-change">
          <xsl:with-param name="elt" select="."/>
          <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
          <xsl:with-param name="redline-type" select="string('start')"/>
          <xsl:with-param name="xh-diff-pi">
            <xsl:processing-instruction name="xh-diff-pi" select="concat('matched:', @__xh_matched, ' mId:', @__xh_mId, ' id:', @__xh_id)"/>  
          </xsl:with-param>
        </xsl:call-template>
        
        <xsl:choose>
          
          <xsl:when test="string-length(normalize-space(.))=0">
            <xsl:text disable-output-escaping="yes"> </xsl:text>
          </xsl:when>
          
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
          
        </xsl:choose>
        
        <xsl:call-template name="process-change">
          <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
          <xsl:with-param name="redline-type" select="string('end')"/>    
        </xsl:call-template>
        
      </xsl:when>
      
      <xsl:otherwise>
        
        <xsl:choose>
          
          <xsl:when test="string-length(normalize-space(.))=0">
            <xsl:text disable-output-escaping="yes"> </xsl:text>
          </xsl:when>
          
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
          
        </xsl:choose>
        
      </xsl:otherwise>
      
    </xsl:choose>
    
  </xsl:template>

  <xsl:template match="__xh_pi"/>
  <xsl:template match="__xh_comm"/>

  <xsl:template match="__xh_dtd_internal_subset">
    <xsl:text disable-output-escaping="yes"> [ </xsl:text>
    <xsl:apply-templates/>
    <xsl:text disable-output-escaping="yes">]</xsl:text>
  </xsl:template>
  
  <xsl:template match="__xh_documentType">
    <xsl:choose>
      <xsl:when test="__xh_change or __xh_st/__xh_change">
        
          <xsl:call-template name="process-change">
            <xsl:with-param name="elt" select="."/>
          </xsl:call-template>
        
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates/>
    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
  </xsl:template>
  
  <xsl:template match="__xh_elementDecl |
  __xh_attrDecl | 
  __xh_intEntityDecl |
  __xh_extEntityDecl |
  __xh_unpEntityDecl |
  __xh_parameterEntity |
  __xh_notationDecl |
  __xh_dtd_pi |
  __xh_dtd_comment |
  __xh_dtd_name | __xh_systemID | __xh_publicID">
    <xsl:choose>
      <xsl:when test="__xh_change or __xh_st/__xh_change">
        
          <xsl:call-template name="process-change">
            <xsl:with-param name="elt" select="."/>
          </xsl:call-template>
        
          <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="__xh_st"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="__xh_cdata">
    <xsl:choose>
      <xsl:when test="__xh_change or __xh_st/__xh_change">
        
          <xsl:call-template name="process-change">
            <xsl:with-param name="elt" select="."/>
            <xsl:with-param name="xh-diff-pi">
              <xsl:processing-instruction name="xh-diff-pi" select="concat('matched:', @__xh_matched, ' mId:', @__xh_mId, ' id:', @__xh_id)"/>  
            </xsl:with-param>
          </xsl:call-template>
        
        <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
              <xsl:apply-templates/>
        <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
          <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
            <xsl:value-of select="__xh_st"/>
        <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="__xh_er">
    <xsl:choose>
      <xsl:when test="__xh_change or __xh_st/__xh_change">
        
          <xsl:call-template name="process-change">
            <xsl:with-param name="elt" select="."/>
            <xsl:with-param name="xh-diff-pi">
              <xsl:processing-instruction name="xh-diff-pi" select="concat('matched:', @__xh_matched, ' mId:', @__xh_mId, ' id:', @__xh_id)"/>  
            </xsl:with-param>
          </xsl:call-template>
        
        <xsl:text disable-output-escaping="yes">&amp;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text disable-output-escaping="yes">;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text disable-output-escaping="yes">&amp;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text disable-output-escaping="yes">;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="__xh_change">
  </xsl:template>

  <xsl:template match="__xh_marker">
    <xsl:param name="id" select="@__xh_id" />
    
    <xsl:choose>
      
      <xsl:when test="parent::__xh_txt"/>
      
      <xsl:otherwise>
        
        <xsl:variable name="diff-instance-compared-doc-matched-node-id" select="@__xh_id"/>
        <xsl:variable name="diff-instance-compared-doc-matched-node" select="$diff-instance-compared-doc//*[@__xh_id=$diff-instance-compared-doc-matched-node-id]"/>
        
        <xsl:if test="$diff-instance-compared-doc-matched-node[name()!='__xh_txt' and not(@__xh_ai)]">
          <xsl:processing-instruction name="diff-instance-compared-doc-matched-node-id" select="$diff-instance-compared-doc-matched-node-id"/>
        </xsl:if>
        
      </xsl:otherwise>
      
    </xsl:choose>
    
  </xsl:template>

  <xsl:template name="process-change">
    <xsl:param name="elt"/>
    <xsl:param name="ancestor-is-attribute"/>
    <xsl:param name="redline-type"/>
    <xsl:param name="xh-diff-pi"/>

    <xsl:if test="$ancestor-is-attribute!='true'">
      
      <!--
        <xsl:for-each select="$elt/__xh_change[@__xh_changeType != '' and @__xh_changeId != '-1']">
        <span>
          <xsl:attribute name="class"><xsl:value-of select="@__xh_accepted"/></xsl:attribute>
          <xsl:attribute name="id"><xsl:value-of select="@__xh_changeId"/></xsl:attribute>
          <xsl:attribute name="changedNodeId"><xsl:value-of select="@__xh_changedNodeId"/></xsl:attribute>
          <xsl:attribute name="matchedNodeId"><xsl:value-of select="@__xh_matchedNodeId"/></xsl:attribute>
          <xsl:attribute name="accepted"><xsl:value-of select="@__xh_accepted"/></xsl:attribute>
          <xsl:attribute name="changeType"><xsl:value-of select="@__xh_changeType"/></xsl:attribute>
          <xsl:attribute name="myValue"><xsl:value-of select="@__xh_myValue"/></xsl:attribute>
          <xsl:attribute name="matchedValue"><xsl:value-of select="@__xh_matchedValue"/></xsl:attribute>
        </span>
        </xsl:for-each>
      -->
      
      <!--<xsl:if test="no-parent-change">-->
        
        <xsl:choose>
          
          <xsl:when test="$redline-type='start'">
            <xsl:copy-of select="$xh-diff-pi"/>
            <xsl:copy-of select="$redline-start-pi"/>
          </xsl:when>
          
          <xsl:when test="$redline-type='end'">
            <xsl:copy-of select="$redline-end-pi"/>
          </xsl:when>
          
        </xsl:choose>
        
      <!--</xsl:if>-->
      
    </xsl:if>
    
  </xsl:template>

  <xsl:template match="*">
    <xsl:param name="ancestor-is-attribute"/>
    
    <xsl:choose>
      <xsl:when test="@__xh_ai">
        <xsl:call-template name="__xh_ai"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          
          <xsl:when 
            test="
            __xh_change 

            or 
            self::element()
            [
            not(starts-with(name(), '__xh'))
            and *[@__xh_ai and (__xh_txt/__xh_change or __xh_txt/__xh_st/__xh_change)]
            and not(*[starts-with(name(), '__xh')])
            ]
            ">
            <!--and (@__xh_matched!='ma' and @__xh_matched!='lma')-->
            
            <xsl:call-template name="process-change">
              <xsl:with-param name="elt" select="."/>
              <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
              <xsl:with-param name="redline-type" select="string('start')"/>
              <xsl:with-param name="xh-diff-pi">
                <xsl:processing-instruction name="xh-diff-pi" select="concat('matched:', @__xh_matched, ' mId:', @__xh_mId, ' id:', @__xh_id)"/>  
              </xsl:with-param>
            </xsl:call-template>
            
            <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
            <xsl:if test="@__xh_pf">
              <xsl:value-of select="@__xh_pf"/>
              <xsl:text>:</xsl:text>
            </xsl:if>
              <xsl:if test="name()='include'">
                  <xsl:text>xi:</xsl:text>
              </xsl:if>  
            <xsl:value-of select="name(.)"/>
            
            <xsl:apply-templates select="*[@__xh_ai]">
              <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
            </xsl:apply-templates>
            
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            
            <xsl:if test="*[@__xh_ai and (__xh_change or __xh_txt/__xh_change)] and $diff-instance-self-type='target'">
              <xsl:call-template name="process-attribute-change"/>
            </xsl:if>
            
            <xsl:if test="parent::__xh_doc">
              <xsl:choose>
                <xsl:when test="$diff-instance-self-type='source'">
                  <xsl:processing-instruction name="source-version-number" select="normalize-space(document(replace($diff-instance-self-meta-uri, '\\', '/'),/)/meta/version)"/>
                </xsl:when>
                <xsl:when test="$diff-instance-self-type='target'">
                  <xsl:processing-instruction name="target-version-number" select="normalize-space(document(replace($diff-instance-self-meta-uri, '\\', '/'),/)/meta/version)"/>
                </xsl:when>
              </xsl:choose>
            </xsl:if>
            
            <xsl:apply-templates select="*[count(@__xh_ai) = 0]">
              <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
            </xsl:apply-templates>
            
            <xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
            <xsl:if test="@__xh_pf">
              <xsl:value-of select="@__xh_pf"/>
              <xsl:text>:</xsl:text>
            </xsl:if>
              <xsl:if test="name()='include'">
                  <xsl:text>xi:</xsl:text>
              </xsl:if>
            <xsl:value-of select="name(.)"/>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            
            <xsl:call-template name="process-change">
              <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
              <xsl:with-param name="redline-type" select="string('end')"/>
            </xsl:call-template>
            
          </xsl:when>
          
          <xsl:otherwise>
            <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
            <xsl:if test="@__xh_pf">
              <xsl:value-of select="@__xh_pf"/>
              <xsl:text>:</xsl:text>
            </xsl:if>
              <xsl:if test="name()='include'">
                  <xsl:text>xi:</xsl:text>
              </xsl:if>
            <xsl:value-of select="name(.)"/>
            
            <xsl:apply-templates select="*[@__xh_ai]">
              <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
            </xsl:apply-templates>
            
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            
            <xsl:if test="*[@__xh_ai and (__xh_change or __xh_txt/__xh_change)]">
              <xsl:call-template name="process-attribute-change"/>
            </xsl:if>
            
            <xsl:if test="parent::__xh_doc">
              <xsl:choose>
                <xsl:when test="$diff-instance-self-type='source'">
                  <xsl:processing-instruction name="source-version-number" select="normalize-space(document(replace($diff-instance-self-meta-uri, '\\', '/'),/)/meta/version)"/>
                </xsl:when>
                <xsl:when test="$diff-instance-self-type='target'">
                  <xsl:processing-instruction name="target-version-number" select="normalize-space(document(replace($diff-instance-self-meta-uri, '\\', '/'),/)/meta/version)"/>
                </xsl:when>
              </xsl:choose>
            </xsl:if>
            
            <xsl:apply-templates select="*[count(@__xh_ai) = 0]">
              <xsl:with-param name="ancestor-is-attribute" select="$ancestor-is-attribute"/>
            </xsl:apply-templates>
            
            <xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
            <xsl:if test="@__xh_pf">
              <xsl:value-of select="@__xh_pf"/>
              <xsl:text>:</xsl:text>
            </xsl:if>
              <xsl:if test="name()='include'">
                  <xsl:text>xi:</xsl:text>
              </xsl:if>
            <xsl:value-of select="name(.)"/>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="process-attribute-change">
    
    <xsl:for-each select="*[@__xh_ai and (__xh_change or __xh_txt/__xh_change)]">
      <xsl:variable name="name" select="name()"/>
      <xsl:variable name="diff-instance-compared-doc-matched-node-id" select="parent::*/@__xh_mId"/>
      <xsl:variable name="diff-instance-compared-doc-matched-node" select="$diff-instance-compared-doc//*[@__xh_id=$diff-instance-compared-doc-matched-node-id]"/>
      
      <xsl:choose>
        
        <xsl:when test="$diff-instance-self-type='source'">

          <xsl:processing-instruction name="{concat('attribute-change-in-', $diff-instance-self-type)}">
            
            <xsl:choose>
              
              <xsl:when test="@__xh_ni">
                <xsl:text> </xsl:text>
                <xsl:value-of select="@__xh_nsName" />
              </xsl:when>
              
              <xsl:otherwise>
                <xsl:text> </xsl:text>
                <xsl:if test="@__xh_pf">
                  <xsl:value-of select="@__xh_pf" />
                  <xsl:text>:</xsl:text>
                </xsl:if>
                <xsl:value-of select="$name" />
              </xsl:otherwise>
              
            </xsl:choose>
            
            <xsl:text>="</xsl:text>
            
            <xsl:choose>
              
              <xsl:when test="$diff-instance-compared-doc-matched-node/*[@__xh_ai and name()=$name]/__xh_txt/__xh_change">
                <xsl:for-each select="$diff-instance-compared-doc-matched-node/*[@__xh_ai and name()=$name]/__xh_txt/*[name()!='__xh_change']">
                  <xsl:value-of select="normalize-space(.)" />
                </xsl:for-each>
              </xsl:when>
              
              <xsl:otherwise>
                <xsl:value-of select="normalize-space($diff-instance-compared-doc-matched-node/*[@__xh_ai and name()=$name])" />
              </xsl:otherwise>
              
            </xsl:choose>
              
            <xsl:text>"</xsl:text>
            
          </xsl:processing-instruction>
          
        </xsl:when>
        
        <xsl:when test="$diff-instance-self-type='target'">
          
          <xsl:processing-instruction name="{concat('attribute-change-in-', $diff-instance-self-type)}">
            
            <xsl:choose>
              
              <xsl:when test="@__xh_ni">
                <xsl:text> </xsl:text>
                <xsl:value-of select="@__xh_nsName" />
              </xsl:when>
              
              <xsl:otherwise>
                <xsl:text> </xsl:text>
                <xsl:if test="@__xh_pf">
                  <xsl:value-of select="@__xh_pf" />
                  <xsl:text>:</xsl:text>
                </xsl:if>
                <xsl:value-of select="$name" />
              </xsl:otherwise>
              
            </xsl:choose>
            
            <xsl:text>="</xsl:text>
            
            <!--<xsl:value-of select="normalize-space(.)"/>
            <xsl:text>-test3</xsl:text>-->
            
            <xsl:choose>
              
              <xsl:when test="__xh_txt/__xh_change">
                <xsl:for-each select="__xh_txt/*[name()!='__xh_change']">
                  <xsl:value-of select="normalize-space(.)" />
                </xsl:for-each>
              </xsl:when>
              
              <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)" />
              </xsl:otherwise>
              
            </xsl:choose>
            
            <xsl:text>"</xsl:text>
            
          </xsl:processing-instruction>
          
        </xsl:when>
        
      </xsl:choose>
      
    </xsl:for-each>
    
  </xsl:template>

</xsl:stylesheet>
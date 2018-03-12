<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:oak="http://schema.bmj.com/delivery/oak"
    xmlns:ce="http://schema.bmj.com/delivery/oak-ce"    
    xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"   
    exclude-result-prefixes="legacytag xsi"
    version="2.0">
    <xsl:output 
        method="xml" 
        encoding="UTF-8"
        indent="yes"
    />
    <!-- 
        Publication business rules
        
        monograph content                en-au and en-gb get UK version of content, en-us get US version
        ce content                                 all publications have this content
        bt summs                                 all publications have this content
        related links                              display accorrding to lang selection, if lang = none then display. 
        performance measure           display accorrding to lang selection, if lang = none then display
        external link                              display accorrding to lang selection, if lang = none then display
    -->
    <xsl:param name="pub-stream"/>
    <xsl:param name="ukdir"/>
    <xsl:param name="usdir"/>
    <xsl:param name="file-name"/>
    <xsl:param name="published-date"/>
    <xsl:param name="amended-date"/>
    <xsl:param name="last-update"/>
    
    <xsl:strip-space elements="*"/>
 
    <xsl:template match="evidence-summary">
        <xsl:element name="evidence-summary">
            
            
            <xsl:attribute name="id"><xsl:value-of select="$file-name"/></xsl:attribute>
            
            <!-- add some usefull dates -->
            <xsl:element name="published-date"><xsl:value-of select="$published-date"/></xsl:element>
            <xsl:element name="last-update"><xsl:value-of select="$last-update"/></xsl:element>
            <xsl:element name="amended-date"><xsl:value-of select="$amended-date"/></xsl:element>

            <xsl:apply-templates/>
            
        </xsl:element>
    </xsl:template>

    <xsl:template match="summ-links">
    <!-- remove unneed summ links -->
    </xsl:template>
    

    <xsl:template match="ce-links">
        <!-- xsl:comment>Related CE links</xsl:comment -->
        <xsl:element name="systematic-review-links">
            <xsl:for-each-group select="celink" group-by="@href">
                <xsl:element name="systematic-review-link">
                    <xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
                    <xsl:attribute name="file-id"><xsl:value-of select="@topic-id"/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:for-each-group>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mono-links">
        <!-- xsl:comment>Related monograph links</xsl:comment -->
        <xsl:element name="monograph-links">
            <xsl:for-each-group select="monolink" group-by="@href">
                <xsl:element name="monograph-link">
                    <xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
                    <xsl:attribute name="file-id"><xsl:value-of select="@monoid"/></xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:for-each-group>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="external-evidence-link">
        <!--  display accorrding to lang selection, if lang = none then display -->
        <xsl:variable name="lang"><xsl:value-of select="@lang"/></xsl:variable>
        <xsl:variable name="class"><xsl:value-of select="@class"/></xsl:variable>
        
        <xsl:comment>external-evidence-link pub-stream:<xsl:value-of select="$pub-stream"/> lang:<xsl:value-of select="$lang"/> class:<xsl:value-of select="$class"/></xsl:comment>
        
        <xsl:choose>
            <xsl:when test="$lang=$pub-stream or $lang='none'">

                <xsl:element name="external-evidence-link">
                    <xsl:attribute name="lang" select="@lang"/>
                    <xsl:attribute name="class" select="@class"/>
                    <xsl:apply-templates/>
                </xsl:element>
                
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        
    </xsl:template>

    <xsl:template match="internal-evidence-link">
        <!--  display accorrding to lang selection, if lang = none then display -->
        <xsl:variable name="lang"><xsl:value-of select="@lang"/></xsl:variable>
        <xsl:variable name="class"><xsl:value-of select="@class"/></xsl:variable>
        
        <xsl:comment>internal-evidence-link pub-stream:<xsl:value-of select="$pub-stream"/> lang:<xsl:value-of select="$lang"/> class:<xsl:value-of select="$class"/></xsl:comment>
        
        <xsl:choose>
            <xsl:when test="$lang=$pub-stream or $lang='none'">
                
                <xsl:element name="internal-evidence-link">
                    <xsl:attribute name="lang" select="@lang"/>
                    <xsl:attribute name="class" select="@class"/>
                    <xsl:apply-templates/>
                </xsl:element>
                
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        
    </xsl:template>
    

    <xsl:template match="es-internal-link">
        
        <xsl:variable name="target" select="@target"/>
        <xsl:variable name="xpath" select="@xpointer"/>

        <xsl:variable name="targetid">
            <xsl:call-template name="target-id">
                <xsl:with-param name="target" select="@target"/>
                <xsl:with-param name="xpointer" select="@xpointer"/>                
            </xsl:call-template>
        </xsl:variable>
                
        <!-- 
            if pub stream is US then select US version of the monograph else use UK version
        -->
        
        <xsl:variable name="doclocation">
            <xsl:call-template name="doc-location">
                <xsl:with-param name="target" select="@target"/>
                <xsl:with-param name="targetid" select="$targetid"/>                
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="doc" select="document($doclocation)"/>
    
        <!-- 
            cant seem to pass the xpath as a variable - use a nasty if else statement 
        -->
        
        <xsl:element name="es-internal-link">

            <xsl:variable name="target"><xsl:value-of select="@target"/></xsl:variable>

            <xsl:attribute name="target" select="@target"/>
            <xsl:attribute name="xpointer" select="@xpointer"/>
            
            
            <!-- if a monograph add type and mono id -->
            <xsl:if 
                test="
                @xpointer!='option/intervention-set' 
                and @xpointer!='patient-summary/topic-info' 
                ">
                <xsl:attribute name="type">monograph</xsl:attribute>
                <xsl:attribute name="file-id"><xsl:value-of select="$targetid"/></xsl:attribute>

                <xsl:choose>
                    <!-- chunk with id -->
                    <xsl:when test="starts-with($xpath ,'#')">
                        <xsl:variable name="daid"><xsl:value-of select="substring-after($xpath, '#')"/></xsl:variable>
                        <xsl:attribute name="chunk-id"><xsl:value-of select="$daid"/></xsl:attribute>
                    </xsl:when>
                    <!-- no id -->
                    <xsl:otherwise>
                        <xsl:attribute name="chunk-id"></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:if>
                
            <!-- if ce add type and ce file name -->
            <xsl:if 
                test="
                @xpointer='option/intervention-set' 
                ">
                <xsl:attribute name="type">systematic-review</xsl:attribute>
                <xsl:attribute name="file-id"><xsl:value-of select="$targetid"/></xsl:attribute>
                <xsl:choose>
                    <!-- old option file name -->
                    <xsl:when test="contains(@target,'_op')">
                        <xsl:variable name="interid"><xsl:value-of select="substring-before((substring-after(@target, 'I')),'.xml')"/></xsl:variable>
                        <xsl:attribute name="chunk-id"><xsl:value-of select="$interid"/></xsl:attribute>
                    </xsl:when>
                    <!-- new option file name -->
                    <xsl:otherwise>
                        <xsl:variable name="interid"><xsl:value-of select="substring-before((substring-after(@target, '-')),'.xml')"/></xsl:variable>
                        <xsl:attribute name="chunk-id"><xsl:value-of select="$interid"/></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            
            <!-- patient leaflet -->
            <xsl:if 
                test="
                @xpointer='patient-summary/topic-info' 
                ">
                <xsl:attribute name="type">patient-summary</xsl:attribute>

				<!--ie Stopping smoking
					resource uri = /bmjk/patient-summary/patient-summary-1183649906149
					target = ../patient-summary/patient-summary-1183649906149.xml
					abstract id = 532808
					new target id = 532808.pdf
				-->
		        <xsl:variable name="summaryname"><xsl:value-of select="replace($target, '^\.\./(.+?)/(.+?)?\.(.+?)$', '$2.xml')"/></xsl:variable>
		        <xsl:variable name="abstractid"><xsl:value-of select="legacytag:getAbstractId(concat('/bmjk/patient-summary/', replace($summaryname, '.xml', '')))"/></xsl:variable>	        

                <xsl:attribute name="file-id"><xsl:value-of select="$abstractid"/></xsl:attribute>
                <xsl:attribute name="chunk-id"></xsl:attribute>
            </xsl:if>

            <xsl:choose>
                <xsl:when test="$xpath = 'basics/definition'">
                    <xsl:apply-templates select="$doc//basics/definition" />
                </xsl:when>
                <xsl:when test="$xpath = 'basics/risk-factors'">
                    <xsl:apply-templates select="$doc//basics/risk-factors" />
                </xsl:when>
                <xsl:when test="$xpath = 'basics/prevention'">
                    <xsl:apply-templates select="$doc//basics/prevention" />
                </xsl:when>
                <xsl:when test="$xpath = 'basics/classifications'">
                    <xsl:apply-templates select="$doc//basics/classifications" />
                </xsl:when>
                <xsl:when test="$xpath = 'diagnosis/diagnostic-factors'">
                    <xsl:apply-templates select="$doc//diagnosis/diagnostic-factors" />
                </xsl:when>
                <xsl:when test="$xpath = 'diagnosis/approach'">
                    <xsl:apply-templates select="$doc//diagnosis/approach" />
                </xsl:when>
                <xsl:when test="$xpath = 'diagnosis/screening'">
                    <xsl:apply-templates select="$doc//diagnosis/screening" />
                </xsl:when>
                <xsl:when test="$xpath = 'diagnosis/tests'">
                    <xsl:apply-templates select="$doc//diagnosis/tests" />
                </xsl:when>
                <xsl:when test="$xpath = 'diagnosis/differentials'">
                    <xsl:apply-templates select="$doc//diagnosis/differentials" />
                </xsl:when>
                <xsl:when test="$xpath = 'diagnosis/diagnostic-criteria'">
                    <xsl:element name="h2">Diagnostic criteria</xsl:element>
                    <xsl:apply-templates select="$doc//diagnosis/diagnostic-criteria" />
                </xsl:when>
                <xsl:when test="$xpath = 'diagnosis/guidelines'">
                    <xsl:apply-templates select="$doc//diagnosis/guidelines" />
                </xsl:when>
                <xsl:when test="$xpath = 'treatment/approach'">
                    <xsl:element name="h2">Treatment approach</xsl:element>
                    <xsl:apply-templates select="$doc//treatment/approach" />
                </xsl:when>
                <xsl:when test="$xpath = 'treatment/emerging-txs'">
                    <xsl:apply-templates select="$doc//treatment/emerging-txs" />
                </xsl:when>
                <xsl:when test="$xpath = 'followup/recommendations'">
                    <xsl:element name="h2">Follow up recommendations</xsl:element>
                    <xsl:apply-templates select="$doc//followup/recommendations" />
                </xsl:when>
                <xsl:when test="$xpath = 'followup/complications'">
                    <xsl:apply-templates select="$doc//followup/complications" />
                </xsl:when>
                <xsl:when test="$xpath = 'followup/outlook'">
                    <xsl:apply-templates select="$doc//followup/outlook" />
                </xsl:when>
                
                <!-- eval elements -->
                <xsl:when test="$xpath = 'monograph-eval/overview'">
                    <xsl:apply-templates select="$doc//monograph-eval/overview" />
                </xsl:when>
                <xsl:when test="$xpath = 'monograph-eval/ddx-etiology'">
                    <xsl:apply-templates select="$doc//monograph-eval/ddx-etiology" />
                </xsl:when>
                <xsl:when test="$xpath = 'monograph-eval/urgent-considerations'">
                    <xsl:apply-templates select="$doc//monograph-eval/urgent-considerations" />
                </xsl:when>
                <xsl:when test="$xpath = 'monograph-eval/diagnostic-approach'">
                    <xsl:apply-templates select="$doc//monograph-eval/diagnostic-approach" />
                </xsl:when>
                <xsl:when test="$xpath = 'differential'">
                        <xsl:apply-templates select="$doc//differential" />
                </xsl:when>
                
                <xsl:when test="$xpath = 'followup/recommendations/monitoring'">
                    <xsl:apply-templates select="$doc//followup/recommendations/monitoring" />
                </xsl:when>
                <xsl:when test="$xpath = 'followup/recommendations/patient-instructions'">
                    <xsl:apply-templates select="$doc//followup/recommendations/patient-instructions" />
                </xsl:when>
                <xsl:when test="$xpath = 'followup/recommendations/preventive-actions'">
                    <xsl:apply-templates select="$doc//followup/recommendations/preventive-actions" />
                </xsl:when>
                

                <!-- CE elements -->
                <xsl:when test="$xpath = 'option/intervention-set'">
	                <xsl:element name="option">
	                	<xsl:attribute name="id" select="concat('_op', $targetid)"/>
	                	<xsl:attribute name="link-target" select="'option'"/>
	                	<xsl:variable name="footnotechunk" select="$doc//oak:section[@ce:oen='footnote' and @class='footnote']"/>	                	
	                    <xsl:choose>
		                    <!-- old option file name -->
		                    <xsl:when test="contains(@target,'_op')">
		                        <xsl:variable name="interid"><xsl:value-of select="concat('sr-', $targetid, '-i', substring-before((substring-after(@target, 'I')),'.xml'))"/></xsl:variable>
		                        <xsl:variable name="optionchunk" select="$doc//oak:section[@class='option' and @id=$interid]" />
		                        <xsl:element name="title"><xsl:value-of select="$optionchunk/oak:title"/></xsl:element>
		                        <xsl:element name="abridged-title"><xsl:value-of select="$optionchunk/oak:metadata/oak:key[@ce:name='abridged-title']/@value"/></xsl:element>		                        
		                        <xsl:element name="intervention-set">
		                        	<xsl:element name="intervention">
		                        			<xsl:attribute name="efficacy"><xsl:value-of select="$optionchunk/oak:metadata/oak:key[@ce:name='intervention-efficacy']/@value"/></xsl:attribute>		                        	
        			                        <!-- <xsl:element name="title"><xsl:value-of select="$optionchunk/oak:metadata/oak:key[@ce:name='summary-title']/@value"/></xsl:element>
					                        <xsl:apply-templates select="$optionchunk/oak:section[@ce:oen='summary-statement']" />-->
					                        <xsl:variable name="summarytitle" select="$optionchunk/oak:metadata/oak:key[@ce:name='summary-title']/@value" 	 />
					                        <xsl:element name="title"><xsl:value-of select="$summarytitle"/></xsl:element>	                        	
					                        <xsl:apply-templates select="$optionchunk/oak:section[@ce:oen='summary-statement']"/>
					                        <!--  Added the below section for Mantis Id 12561 -->
					                         <xsl:if test="substring($summarytitle, string-length($summarytitle)) = '*'">
					                         <footnote>
					                       		 <xsl:apply-templates select="$footnotechunk/oak:list/oak:li"></xsl:apply-templates>
					                        </footnote> 
					                        </xsl:if>		                        
		                        	</xsl:element>
		                        </xsl:element>
		                    </xsl:when>
		                    <!-- new option file name -->
		                    <xsl:otherwise>
		                        <xsl:variable name="interid"><xsl:value-of select="concat('sr-', $targetid, '-i', substring-before((substring-after(@target, '-')),'.xml'))"/></xsl:variable>	                    
		                        <xsl:variable name="optionchunk" select="$doc//oak:section[@class='option' and @id=$interid]" />
		                        <xsl:element name="title"><xsl:value-of select="$optionchunk/oak:title"/></xsl:element>		                        
		                        <xsl:element name="abridged-title"><xsl:value-of select="$optionchunk/oak:metadata/oak:key[@ce:name='abridged-title']/@value"/></xsl:element>		                        
		                        <xsl:element name="intervention-set">
		                        	<xsl:element name="intervention">
		                        			<xsl:attribute name="efficacy"><xsl:value-of select="$optionchunk/oak:metadata/oak:key[@ce:name='intervention-efficacy']/@value"/></xsl:attribute>
        			                      <!--   <xsl:element name="title"><xsl:value-of select="$optionchunk/oak:metadata/oak:key[@ce:name='summary-title']/@value"/></xsl:element>
					                        <xsl:apply-templates select="$optionchunk/oak:section[@ce:oen='summary-statement']" />-->
					                        <xsl:variable name="summarytitle" select="$optionchunk/oak:metadata/oak:key[@ce:name='summary-title']/@value" 	 />	                        	
        			                        <xsl:element name="title"><xsl:value-of select="$summarytitle"/></xsl:element>
					                        <xsl:apply-templates select="$optionchunk/oak:section[@ce:oen='summary-statement']"/>
					                        <!--  Added the below section for Mantis Id 12561 -->
					                         <xsl:if test="substring($summarytitle, string-length($summarytitle)) = '*'">
					                         <footnote>
					                       		 <xsl:apply-templates select="$footnotechunk/oak:list/oak:li"></xsl:apply-templates>
					                        </footnote> 
					                        </xsl:if>		                        
		                        	</xsl:element>
		                        </xsl:element>		                                         		                        
		                    </xsl:otherwise>
		                </xsl:choose>                    
	                </xsl:element>
                </xsl:when>
                
                <!-- summary pdf on CE website -->
                <xsl:when test="$xpath = 'patient-summary/topic-info'">
                    <xsl:element name="title"><xsl:value-of select="$doc//article/front/article-meta/title-group/article-title"/></xsl:element>
                    <xsl:apply-templates/>
                </xsl:when>
                
                <!-- linking to id sections -->
                <xsl:when test="starts-with($xpath ,'#')">
                    <xsl:variable name="daid"><xsl:value-of select="substring-after($xpath, '#')"/></xsl:variable>
                    <!-- xsl:comment>REMOVE THIS COMMENT NEW ID SECTION xpointer:<xsl:value-of select="$xpath"/> target:<xsl:value-of select="$target"/> id:<xsl:value-of select="$daid"/></xsl:comment -->
                    <xsl:apply-templates select="$doc//*[@id=$daid]" />
                </xsl:when>
                
                
                
                <!-- catch errors -->
                <xsl:otherwise>
                    <xsl:comment>ERROR SECTION NOT MATCHED xpointer:<xsl:value-of select="$xpath"/> target:<xsl:value-of select="$target"/></xsl:comment>
                </xsl:otherwise>


            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template match="option">
        <xsl:element name="option">
            <xsl:if test="@id != ''">
                <xsl:attribute name="id" select="@id"/>
            </xsl:if>
            <xsl:if test="@link-target != ''">
                <xsl:attribute name="link-target" select="@link-target"/>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>            
    </xsl:template>
    
    <xsl:template match="oak:section[@ce:oen='summary-statement']">
    	<xsl:apply-templates select="oak:p | oak:list"/>
    </xsl:template>
    
    <xsl:template match="oak:list[parent::oak:section[@ce:oen='summary-statement']]">
		<xsl:for-each select="oak:li">
			<xsl:choose>
			    <xsl:when test="(contains(., 'GRADE') or contains(., 'grade')) and (not(contains(., 'grades')))">
					<xsl:comment select="'grade statement node removed'"/>
				</xsl:when>
				<xsl:when test="oak:link[@class='table']">
					<xsl:comment select="'node with table-link removed'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="summary-statement">
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:otherwise>             
			</xsl:choose>
		</xsl:for-each>
    </xsl:template>

    <xsl:template match="oak:p[parent::oak:section[@ce:oen='summary-statement']]">
        <xsl:element name="summary-statement">
	            <xsl:for-each select="node()">
	                <xsl:choose>
						<xsl:when test="self::comment()"/>
						
	                    <xsl:when test="name()='b' and link[@class='table']">
	                        <xsl:comment select="'grade statement node removed'"/>
	                    </xsl:when>
	                    
	                    <xsl:when test="preceding-sibling::node()[name()='b' and link[@class='table']]">
	                        <xsl:comment select="'further grade statement nodes removed'"/>
	                    </xsl:when>
	                    
	                    <xsl:when test="name()='b' and (contains(., 'GRADE') or contains(., 'grade') )">
	                        <xsl:comment select="'fragmented grade markup strong node removed'"/>
	                    </xsl:when>
	                    
	                    <xsl:when test="name()='link' and @class='table'">
	                        <xsl:comment select="'un-nested grade table-link removed'"/>
	                    </xsl:when>
	                    
	                    <xsl:when test="preceding-sibling::link[@class='table']">
	                        <xsl:comment select="'any nodes folloing table-link removed'"/>
	                    </xsl:when>
                    	                    
	                    <xsl:when test="name()='b'">
	                        <!--<xsl:element name="br" />-->
	                        <xsl:element name="strong">
	                            <xsl:value-of select="."/>
	                        </xsl:element>
	                        <!--<xsl:element name="br" />-->
	                    </xsl:when>
	                    
	                    <xsl:when test="name()='i'">
	                        <xsl:element name="em">
	                            <xsl:value-of select="."/>
	                        </xsl:element>
	                        <xsl:text disable-output-escaping="yes"> </xsl:text>
	                    </xsl:when>
	                    
	                    <xsl:when test="string-length(normalize-space(.))!=0">
	                        <xsl:value-of select="normalize-space(.)"/>
	                        <xsl:text disable-output-escaping="yes"> </xsl:text>
	                    </xsl:when>
	                    
	                </xsl:choose>
            </xsl:for-each>
           
        </xsl:element>

    </xsl:template>
    

    <xsl:template match="differential">
        <xsl:element name="differential">
            <xsl:if test="@id != ''">
                <xsl:attribute name="id" select="@id"/>
            </xsl:if>
            <xsl:if test="@common != ''">
                <xsl:attribute name="common" select="@common"/>
            </xsl:if>
            <xsl:if test="@red-flag != ''">
                <xsl:attribute name="red-flag" select="@red-flag"/>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>            
    </xsl:template>


    <xsl:template match="performance-measure">
        
        <!--  display accorrding to lang selection, if lang = none then display -->
        <xsl:variable name="lang"><xsl:value-of select="@lang"/></xsl:variable>
        
        <xsl:comment>performance measure pub-stream:<xsl:value-of select="$pub-stream"/> lang:<xsl:value-of select="$lang"/></xsl:comment>
        
        <xsl:choose>
            <xsl:when test="$lang=$pub-stream or $lang='none'">
        
                <xsl:element name="performance-measure">
                    <xsl:attribute name="lang" select="@lang"/>
                    <xsl:attribute name="class" select="@class"/>
                    <xsl:apply-templates/>
                </xsl:element>
        
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        
        
    </xsl:template>

    <xsl:template match="scope">

        <!--  display accorrding to lang selection, if lang = none then display -->
        <xsl:variable name="lang"><xsl:value-of select="@lang"/></xsl:variable>
        
        <xsl:comment>scope pub-stream:<xsl:value-of select="$pub-stream"/> lang:<xsl:value-of select="$lang"/></xsl:comment>
        
        <xsl:choose>
            <xsl:when test="$lang=$pub-stream or $lang='none' or $lang=''">
                <xsl:element name="scope">
                    <xsl:attribute name="lang" select="@lang"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>

    </xsl:template>
    
    <!--  Added the below template for Mantis request 12636 -->
  <xsl:template match="summary-info">
  <summary-info>
    <xsl:if test="child::node()[name()='title']">
	<xsl:variable name="title">
    	 <xsl:value-of select="descendant::node()[name()='title'][./@lang=$pub-stream]/text()"> </xsl:value-of>
    </xsl:variable>
    <!-- If the title is not present form the pub-stream language then get the en-gb title as default title -->
    <xsl:variable name="default-title">
    	 <xsl:value-of select="descendant::node()[name()='title'][./@lang='en-gb']/text()"> </xsl:value-of>
    </xsl:variable>
    <xsl:variable name="default-title-no-lang">
    	 <xsl:value-of select="descendant::node()[name()='title'][not(@lang)]/text()"> </xsl:value-of>
    </xsl:variable>
    
    <xsl:choose>
	<xsl:when test="string-length($title)>0">
	       <xsl:element name="title">
         <xsl:value-of select="$title"></xsl:value-of> 
               </xsl:element>
         
	</xsl:when>
	<xsl:when test="string-length($default-title)>0">
	       <xsl:element name="title">
         <xsl:value-of select="$default-title"></xsl:value-of> 
               </xsl:element>
         
	</xsl:when>
	<xsl:otherwise>
	       <xsl:element name="title">
         <xsl:value-of select="$default-title-no-lang"></xsl:value-of> 
               </xsl:element>
    
	</xsl:otherwise>
	</xsl:choose>
	</xsl:if>
	<xsl:apply-templates/></summary-info>
	 </xsl:template> 
	<!-- Added for mantis request 12636 -->
    <xsl:template match="title[parent::summary-info]"></xsl:template> 

    <xsl:template name="doc-location">
		<xsl:param name="target"/>        
        <xsl:param name="targetid"/>        
        <xsl:variable name="targetChop">
	        <xsl:choose>
	            <xsl:when test="starts-with($target, '../options/')">
		        	<xsl:value-of select="concat('systematic-reviews/', $targetid, '.xml')"/>
	            </xsl:when>
	            <xsl:when test="starts-with($target, '../monograph-')">
		        	<xsl:value-of select="concat('monographs/', $targetid, '.xml')"/>
	            </xsl:when>
	            <xsl:when test="starts-with($target, '../patient-summary/')">
	                <xsl:value-of select="concat('patient-summary/', $targetid, '.xml')"/>
	            </xsl:when>
	            <xsl:otherwise>
		            <xsl:value-of select="replace($target, '\.\./', '')"/>
	            </xsl:otherwise>
	        </xsl:choose>        
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$pub-stream='en-us' and starts-with($target, '../monograph-')">
                <xsl:value-of select="concat($usdir,$targetChop)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($ukdir,$targetChop)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="target-id">
        <xsl:param name="target"/>
        <xsl:param name="xpointer"/>
        
        <xsl:choose>
            <xsl:when test="$xpointer!='option/intervention-set' and $xpointer!='patient-summary/topic-info'">
            	<xsl:value-of select="/evidence-summary/summary-info/mono-links/monolink[@target=$target]/@monoid"/>
            </xsl:when>
            <xsl:when test="$xpointer='option/intervention-set' ">
                <xsl:value-of select="/evidence-summary/summary-info/ce-links/celink[@target=$target]/@topic-id"/>
            </xsl:when>
            <xsl:when test="$xpointer='patient-summary/topic-info' ">
                <xsl:value-of select="/evidence-summary/summary-info/summ-links/sumlink[@target=$target]/@id"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="comment()"/>
    
    <!-- remove fig links as not used and need stop caption showing -->
    <xsl:template match="figure-link"/>
    
    <xsl:template match="*">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*">
                    <xsl:attribute name="{name()}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>    

</xsl:stylesheet>

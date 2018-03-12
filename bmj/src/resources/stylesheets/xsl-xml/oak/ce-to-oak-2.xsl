<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ce="http://www.bmjgroup.com/2007/07/BMJ-OAK-CE">
		
	<xsl:output method="xml" indent="yes"/>
	
	<xsl:param name="lang"/>

	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:include href="../../xsl-lib/bmj-string-lib.xsl"/>
	
	<xsl:key name="reference-link-keys" match="link[@type='reference']" use="@target" />
	<xsl:key name="gloss-link-keys" match="link[@type='gloss']" use="@target" />
	<xsl:key name="table-link-keys" match="link[@type='table']" use="@target" />
	<xsl:key name="figure-link-keys" match="link[@type='figure']" use="@target" />
		
	<xsl:template match="/section" >
		<xsl:element name="section" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
			<xsl:namespace name="ce">http://www.bmjgroup.com/2007/07/BMJ-OAK-CE</xsl:namespace>
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">http://schema.bmj.com/delivery/oak/bmj-oak-strict.xsd</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="./@id"/></xsl:attribute>
			<xsl:attribute name="class"><xsl:value-of select="./@class"/></xsl:attribute>
			<xsl:apply-templates/>
			<xsl:call-template name="output-table"></xsl:call-template>
			<xsl:call-template name="output-figure"></xsl:call-template>
			<xsl:call-template name="output-glossary"></xsl:call-template>
			<xsl:call-template name="output-references"></xsl:call-template>
		</xsl:element>
	</xsl:template>
	

	<!-- table stuff -->
	
	<xsl:template name="output-table">
		<xsl:if test="//link[@type='table']">
			<xsl:call-template name="output-table-sub">
				<xsl:with-param name="find-in" select="/"/>
				<xsl:with-param name="table-count" select="1"/>
				<xsl:with-param name="link-index" select="1"/>
				<xsl:with-param name="link-count" select="count(//link[@type='table'])+1"/>
			</xsl:call-template>	
		</xsl:if>	
	</xsl:template>
	
	<xsl:template name="output-table-sub">
		<xsl:param name="find-in"/>
		<xsl:param name="link-index"/>
		<xsl:param name="table-count"/>
		<xsl:param name="link-count"/>
		
		<xsl:variable name="link-target" select="(//link[@type='table'])[$link-index]/@target"/>
		
		<xsl:if test="$link-index &lt; $link-count">			
			<!-- if the current link is the same element as the first element in the list, indexed on link target, then print the gloss-->
			
			<xsl:variable name="link-id"><xsl:value-of select="generate-id((//link[@type='table'])[$link-index])"/></xsl:variable>
			<xsl:variable name="key-id"><xsl:value-of select="generate-id(key('table-link-keys', $link-target)[1])"/></xsl:variable>
			
			
			<xsl:choose>
				<xsl:when test="$link-id = $key-id and $find-in//link[@target=$link-target]">
					
					<xsl:apply-templates select="(//link[@target=$link-target])[1]" mode="table"/>
					
					<!-- Call WITH an incremented referenceCount -->
					<xsl:call-template name="output-table-sub">
						<xsl:with-param name="find-in" select="$find-in"/>
						<xsl:with-param name="table-count" select="$table-count +1"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:when>
				
				<xsl:otherwise>
					<!-- Call WITHOUT an incremented referenceCount -->
					<xsl:call-template name="output-table-sub">
						<xsl:with-param name="find-in" select="$find-in"/>
						<xsl:with-param name="table-count" select="$table-count"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="link[@type='table']" mode="table" priority="2">
		<xsl:variable name="link-target"><xsl:value-of select="@target"/></xsl:variable>
		<xsl:element name="table" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
			<xsl:attribute name="id">ce_t_<xsl:value-of select="generate-id(key('table-link-keys', $link-target)[1])"></xsl:value-of></xsl:attribute>
			<xsl:attribute name="border"><xsl:value-of select="./table/@border"></xsl:value-of></xsl:attribute>
			<xsl:apply-templates select="./table/node()"/>
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template match="link[@type='table']"  priority="1">
		<xsl:if test="$debug='true'">
			<xsl:comment>table link</xsl:comment>
		</xsl:if>
		<xsl:variable name="link-target"><xsl:value-of select="@target"/></xsl:variable>
		<xsl:element name="link" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
			<xsl:attribute name="target">#xpointer(id('ce_t_<xsl:value-of select="generate-id(key('table-link-keys', $link-target)[1])"/>'))</xsl:attribute>
			<xsl:attribute name="class">table</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="table"/>

	<xsl:template match="pi-comment"/>

	<!-- figure stuff <xsl:key name="figure-link-keys" match="link[@type='figure']" use="@target" /> -->

	<xsl:template name="output-figure">
		<xsl:if test="//link[@type='figure']">
			<xsl:call-template name="output-figure-sub">
				<xsl:with-param name="find-in" select="/"/>
				<xsl:with-param name="figure-count" select="1"/>
				<xsl:with-param name="link-index" select="1"/>
				<xsl:with-param name="link-count" select="count(//link[@type='figure'])+1"/>
			</xsl:call-template>	
		</xsl:if>	
	</xsl:template>
	
	<xsl:template name="output-figure-sub">
		<xsl:param name="find-in"/>
		<xsl:param name="link-index"/>
		<xsl:param name="figure-count"/>
		<xsl:param name="link-count"/>
		
		<xsl:variable name="link-target" select="(//link[@type='figure'])[$link-index]/@target"/>
		
		<xsl:if test="$link-index &lt; $link-count">			
			<!-- if the current link is the same element as the first element in the list, indexed on link target, then print the gloss-->
			
			<xsl:variable name="link-id"><xsl:value-of select="generate-id((//link[@type='figure'])[$link-index])"/></xsl:variable>
			<xsl:variable name="key-id"><xsl:value-of select="generate-id(key('figure-link-keys', $link-target)[1])"/></xsl:variable>
			
			
			<xsl:choose>
				<xsl:when test="$link-id = $key-id and $find-in//link[@target=$link-target]">
					
					<xsl:apply-templates select="(//link[@target=$link-target])[1]" mode="figure"/>
					
					<!-- Call WITH an incremented referenceCount -->
					<xsl:call-template name="output-figure-sub">
						<xsl:with-param name="find-in" select="$find-in"/>
						<xsl:with-param name="figure-count" select="$figure-count +1"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:when>
				
				<xsl:otherwise>
					<!-- Call WITHOUT an incremented referenceCount -->
					<xsl:call-template name="output-figure-sub">
						<xsl:with-param name="find-in" select="$find-in"/>
						<xsl:with-param name="figure-count" select="$figure-count"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="link[@type='figure']" mode="figure" priority="2">
		<xsl:variable name="link-target"><xsl:value-of select="@target"/></xsl:variable>
		<xsl:element name="figure" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
			<xsl:attribute name="id">ce_t_<xsl:value-of select="generate-id(key('figure-link-keys', $link-target)[1])"></xsl:value-of></xsl:attribute>
			<xsl:attribute name="image"><xsl:value-of select="./figure/image-link/@target"></xsl:value-of></xsl:attribute>
			<xsl:element name="caption" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
				<xsl:element name="p" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
					<xsl:apply-templates select="./figure/caption/node()"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	
	<xsl:template match="link[@type='figure']"  priority="1">
		<xsl:if test="$debug='true'">
			<xsl:comment>figure link</xsl:comment>
		</xsl:if>
		<xsl:variable name="link-target"><xsl:value-of select="@target"/></xsl:variable>
		<xsl:element name="link" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
			<xsl:attribute name="target">#xpointer(id('ce_t_<xsl:value-of select="generate-id(key('figure-link-keys', $link-target)[1])"/>'))</xsl:attribute>
			<xsl:attribute name="class">figure</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="figure"/>
		
		

	<!-- glossary stuff -->
	
	<xsl:template name="output-glossary">
		<xsl:if test="//link[@type='gloss']">
			<xsl:element name="section"  namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
				<xsl:attribute name="class">glossary</xsl:attribute>
				<xsl:call-template name="output-gloss-sub">
					<xsl:with-param name="find-in" select="/"/>
					<xsl:with-param name="reference-count" select="1"/>
					<xsl:with-param name="link-index" select="1"/>
					<xsl:with-param name="link-count" select="count(//link[@type='gloss'])+1"/>
				</xsl:call-template>	
			</xsl:element>
		</xsl:if>	
	</xsl:template>
	
	<xsl:template name="output-gloss-sub">
		<xsl:param name="find-in"/>
		<xsl:param name="link-index"/>
		<xsl:param name="reference-count"/>
		<xsl:param name="link-count"/>
		
		<xsl:variable name="link-target" select="(//link[@type='gloss'])[$link-index]/@target"/>
		
		<xsl:if test="$link-index &lt; $link-count">			
			<!-- if the current link is the same element as the first element in the list, indexed on link target, then print the gloss-->
			
			<xsl:variable name="link-id"><xsl:value-of select="generate-id((//link[@type='gloss'])[$link-index])"/></xsl:variable>
			<xsl:variable name="key-id"><xsl:value-of select="generate-id(key('gloss-link-keys', $link-target)[1])"/></xsl:variable>
			
			
			<xsl:choose>
				<xsl:when test="$link-id = $key-id and $find-in//link[@target=$link-target]">
					
					<xsl:apply-templates select="(//link[@target=$link-target])[1]" mode="gloss"/>
					
					<!-- Call WITH an incremented referenceCount -->
					<xsl:call-template name="output-gloss-sub">
						<xsl:with-param name="find-in" select="$find-in"/>
						<xsl:with-param name="reference-count" select="$reference-count +1"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:when>
				
				<xsl:otherwise>
					<!-- Call WITHOUT an incremented referenceCount -->
					<xsl:call-template name="output-gloss-sub">
						<xsl:with-param name="find-in" select="$find-in"/>
						<xsl:with-param name="reference-count" select="$reference-count"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>


	<xsl:template match="link[@type='gloss']" mode="gloss" priority="2">
		<xsl:variable name="link-target"><xsl:value-of select="@target"/></xsl:variable>
		<xsl:element name="gloss" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
			<xsl:attribute name="id">ce_t_<xsl:value-of select="generate-id(key('gloss-link-keys', $link-target)[1])"></xsl:value-of></xsl:attribute>
			<xsl:element name="p" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
				<xsl:attribute name="class">term</xsl:attribute>
				<xsl:element name="b" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
				<xsl:apply-templates select="gloss//term/node()"/>
				</xsl:element>
			</xsl:element>
			<xsl:element name="p" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
				<xsl:attribute name="class">definition</xsl:attribute>
				<xsl:apply-templates select="gloss//definition/node()"/>
			</xsl:element>
		</xsl:element>			
	</xsl:template>
	
	<xsl:template match="link[@type='gloss']"  priority="1">
		<xsl:if test="$debug='true'">
			<xsl:comment>gloss link</xsl:comment>
		</xsl:if>
		<xsl:variable name="link-target"><xsl:value-of select="@target"/></xsl:variable>
		<xsl:element name="link" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
			<xsl:attribute name="target">#xpointer(id('ce_t_<xsl:value-of select="generate-id(key('gloss-link-keys', $link-target)[1])"/>'))</xsl:attribute>
			<xsl:attribute name="class">glossary</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	

	<xsl:template match="gloss"></xsl:template>
	
	
	<!-- reference stuff -->
	
	<xsl:template name="output-references">
		<xsl:if test="//link[@type='reference']">
			<xsl:element name="references" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
				<xsl:call-template name="output-reference-sub">
					<xsl:with-param name="find-in" select="/"/>
					<xsl:with-param name="reference-count" select="1"/>
					<xsl:with-param name="link-index" select="1"/>
					<xsl:with-param name="link-count" select="count(//link[@type='reference'])+1"/>
				</xsl:call-template>	
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="output-reference-sub">
		<xsl:param name="find-in"/>
		<xsl:param name="link-index"/>
		<xsl:param name="reference-count"/>
		<xsl:param name="link-count"/>
		
		<xsl:variable name="link-target" select="(//link[@type='reference'])[$link-index]/@target"/>
		
		<xsl:if test="$link-index &lt; $link-count">			
			<!-- if the current link is the same element as the first element in the list, indexed on link target, then print the reference-->
			
			<xsl:variable name="link-id"><xsl:value-of select="generate-id((//link[@type='reference'])[$link-index])"/></xsl:variable>
			<xsl:variable name="key-id"><xsl:value-of select="generate-id(key('reference-link-keys', $link-target)[1])"/></xsl:variable>
			
			
			<xsl:choose>
				<xsl:when test="$link-id = $key-id and $find-in//link[@target=$link-target]">
					
					<xsl:apply-templates select="(//link[@target=$link-target])[1]" mode="reference"/>
					
					<!-- Call WITH an incremented referenceCount -->
					<xsl:call-template name="output-reference-sub">
						<xsl:with-param name="find-in" select="$find-in"/>
						<xsl:with-param name="reference-count" select="$reference-count +1"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:when>
				
				<xsl:otherwise>
					<!-- Call WITHOUT an incremented referenceCount -->
					<xsl:call-template name="output-reference-sub">
						<xsl:with-param name="find-in" select="$find-in"/>
						<xsl:with-param name="reference-count" select="$reference-count"/>
						<xsl:with-param name="link-index" select="$link-index + 1"/>
						<xsl:with-param name="link-count" select="$link-count"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="reference"></xsl:template>

	<xsl:template match="link[@type='reference']" mode="reference" priority="2">
		<xsl:variable name="link-target"><xsl:value-of select="@target"/></xsl:variable>
		<xsl:element name="reference" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
			<xsl:attribute name="id">ce_t_<xsl:value-of select="generate-id(key('reference-link-keys', $link-target)[1])"></xsl:value-of></xsl:attribute>
			<xsl:element name="p" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
				<xsl:apply-templates select="reference/clinical-citation"/>
			</xsl:element>
		</xsl:element>			
	</xsl:template>
	

	<xsl:template match="link[@type='reference']" priority="1">
		<xsl:if test="$debug='true'">
			<xsl:comment>reference link</xsl:comment>
		</xsl:if>	
		<xsl:variable name="link-target"><xsl:value-of select="@target"/></xsl:variable>
		<xsl:if test="$debug='true'">
		<xsl:comment>reference link 1 <xsl:value-of select="@target"/></xsl:comment>
			</xsl:if>
		<xsl:element name="link" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
			<xsl:attribute name="target">#xpointer(id('ce_t_<xsl:value-of select="generate-id(key('reference-link-keys', $link-target)[1])"/>'))</xsl:attribute>
			<xsl:attribute name="class">reference</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="link[@type='option']" priority="2">

		<!-- 
			<link type="option" target="../options/option-1177063210233.xml" optid="_op0102">urine	analgesics</link>
			<link type="option" target="../options/_op0807_I6.xml" optid="_op0807">
		-->

		<xsl:variable name="opId" select="concat('_op',substring-after((/section[@class='systematic-review']/@id),'_'))" />


		<!-- get id of option from the link -->
		<xsl:variable name="interIdStr">
			<xsl:choose>
				<xsl:when test="contains(@target,'-')">
					<xsl:call-template name="substring-after-last">
						<xsl:with-param name="string" select="@target"/>
						<xsl:with-param name="delimiter">-</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="substring-after-last">
						<xsl:with-param name="string" select="@target"/>
						<xsl:with-param name="delimiter">_</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="interId" select="substring-before($interIdStr,'.xml')" />

		<!-- get the option id from the option doc -->
		

		<xsl:variable name="extopicId">
			<xsl:call-template name="substring-after-last">
				<xsl:with-param name="string" select="@optid"/>
				<xsl:with-param name="delimiter">_op</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<!-- hack to fix a werid bug -->
			<xsl:when test="@optid='_0'">
				<xsl:if test="$debug='true'">
					<xsl:comment>internal option link <xsl:value-of select="@target"/> - optid _0 -<xsl:value-of select="@optid"/> - optid2 -<xsl:value-of select="$opId"/></xsl:comment>
				</xsl:if>
				<xsl:element name="link" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
					<xsl:attribute name="target">#xpointer(id('_<xsl:value-of select="$interId"/>'))</xsl:attribute>
					<xsl:attribute name="class">option</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<!-- option id is for this doc - internal link -->
			<xsl:when test="@optid = $opId">
				<xsl:if test="$debug='true'">
					<xsl:comment>internal option link <xsl:value-of select="@target"/> - optid -<xsl:value-of select="@optid"/> - optid2 -<xsl:value-of select="$opId"/></xsl:comment>
				</xsl:if>
				<xsl:element name="link" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
					<xsl:attribute name="target">#xpointer(id('_<xsl:value-of select="$interId"/>'))</xsl:attribute>
					<xsl:attribute name="class">option</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<!-- option id is blank so assume - internal link -->
			<xsl:when test="@optid=''">
				<xsl:if test="$debug='true'">
					<xsl:comment>internal option link <xsl:value-of select="@target"/> - optid blank -<xsl:value-of select="@optid"/> - optid2 -<xsl:value-of select="$opId"/></xsl:comment>
				</xsl:if>
				<xsl:element name="link" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
					<xsl:attribute name="target">#xpointer(id('_<xsl:value-of select="$interId"/>'))</xsl:attribute>
					<xsl:attribute name="class">option</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<!-- option id is for another doc - external link -->
			<xsl:otherwise>
				<xsl:if test="$debug='true'">
					<xsl:comment>external option link <xsl:value-of select="@target"/> - optid -<xsl:value-of select="@optid"/> - optid2 -<xsl:value-of select="$opId"/></xsl:comment>
				</xsl:if>
				<xsl:element name="link" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
					<xsl:attribute name="target">_<xsl:value-of select="$extopicId"/>.xml#xpointer(id('_<xsl:value-of select="$interId"/>'))</xsl:attribute>
					<xsl:attribute name="class">option</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>
	
	<xsl:template match="em">
		<xsl:element name="i" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>

		
<!--
	<xsl:template match="key">
		<xsl:element name="key" namespace="http://www.bmjgroup.com/2007/05/OAK-BMJK-CE-OEN">
			<xsl:attribute name="ce:name"><xsl:value-of select="@ce:name"/></xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
		</xsl:element>
	</xsl:template>
-->		

	<xsl:template match="i">
		<xsl:element name="i" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>
	

	<xsl:template match="clinical-citation">
		<xsl:apply-templates mode="#current"/>
	</xsl:template>
	
		<xsl:template match="substantive-change-marker" >
			<xsl:apply-templates mode="#current"/>
		</xsl:template>
		
	
	<xsl:template match="p">
		<!-- if this p has nothing in it, don't output it -->
		<xsl:choose>
			<xsl:when test="not(.='')">
				<xsl:element name="p" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
					<xsl:if test="$debug='true'">
						<xsl:comment>[visible p]</xsl:comment>
					</xsl:if>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$debug='true'">
					<xsl:comment>[hidden empty p]</xsl:comment>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="systematic-review-link">
		<!-- If target is empty do not include the link -->
		<xsl:choose>
			<xsl:when test="not(@target='')">
				<xsl:element name="link" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
					<xsl:variable name="srfileid">
						<xsl:call-template name="substring-after-last">
							<xsl:with-param name="string" select="@target"/>
							<xsl:with-param name="delimiter">/</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					<xsl:attribute name="target"><xsl:value-of select="$srfileid"/>#xpointer(id('<xsl:value-of select="@xpointer"/>'))</xsl:attribute>
					<xsl:attribute name="class">systematic-review</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$debug='true'">
					<xsl:if test="$debug='true'">
						<xsl:comment>missing target link</xsl:comment>
					</xsl:if>
				</xsl:if>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>


	<xsl:template match="title">
		<!-- if this title has nothing in it, don't output it -->
		
		<xsl:choose>
			<xsl:when test="not(.='')">
				<xsl:element name="title" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
					<xsl:call-template name="output-generated-id-attr"/>
					<xsl:if test="$debug='true'"><xsl:comment>[visible title]</xsl:comment></xsl:if>
					<xsl:apply-templates mode="#current"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$debug='true'">
					<xsl:if test="$debug='true'"><xsl:comment>[hidden empty title]</xsl:comment></xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="list">
		<xsl:element name="list" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
			<xsl:if test="$debug='true'">
				<xsl:comment>[list h1]</xsl:comment>
			</xsl:if>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="caption">
		<xsl:element name="caption" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
			<xsl:element name="p" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<!-- mark-up we supress -->
	<xsl:template match="element()[name()='b' or name()='i' or name()='sub'][ancestor::link or ancestor::caption or ancestor::given-names]">
		<xsl:apply-templates/>
	</xsl:template>
		
	<!-- match any other element, writing it out and calling apply-templates for any children -->
	<xsl:template match="*" priority="-1">
		<xsl:if test="$debug='true'">
			<xsl:comment select="name()"/>
		</xsl:if>

		<xsl:element name="{name()}"  namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
			
			<xsl:call-template name="output-generated-id-attr"/>
			
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>

	<xsl:template name="output-generated-id-attr">
		<xsl:if test="$debug='true'">
			<xsl:attribute name="generated-id" select="generate-id(.)"/>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>

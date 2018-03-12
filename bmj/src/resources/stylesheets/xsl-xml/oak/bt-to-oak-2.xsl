<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:bt="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"
	xmlns="http://www.bmjgroup.com/2007/07/BMJ-OAK">

	<xsl:output method="xml" indent="yes"/>

	<xsl:include href="../../xsl-lib/bmj-string-lib.xsl"/>
	
	<xsl:param name="filename"/>
	
	<xsl:param name="gloss-dir">gloss-dir</xsl:param>
	
	<!-- path to the gloss -->	
	<xsl:variable name="glossdir">file://localhost/<xsl:value-of select="translate($gloss-dir,'\','/')"/>/</xsl:variable>
	
	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:key name="reference-link-keys" match="link[@type='reference']" use="@target" />
	<xsl:key name="gloss-link-keys" match="link[@type='gloss']" use="@target" />
	
	<!-- keys for the flatfile to structured stuff -->
	<xsl:key name="Body" match="p|section|list|table"
		use="generate-id(
		(
		preceding-sibling::title |
		preceding-sibling::heading1 |
		preceding-sibling::heading2 |
		preceding-sibling::heading3 
		)
		[last()] 
		)"/>
	
	<xsl:key name="Body2" match="p|list|table"
		use="generate-id(
		(
		preceding-sibling::title |
		preceding-sibling::heading1 |
		preceding-sibling::heading2 |
		preceding-sibling::heading3 
		)
		[last()] 
		)"/>
	
	<xsl:key name="h2" match="heading2"
		use="generate-id(
			preceding-sibling::heading1[1]
			)"/>

	<xsl:key name="h3" match="heading3"
		use="generate-id(
			preceding-sibling::heading2[1]
			)"/>
	<!--  -->
	
	
	
	
	<xsl:template match="/section" priority="2">
		<section xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xmlns:bt="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"
			xmlns:oak="http://www.bmjgroup.com/2007/07/BMJ-OAK"
			
			xsi:schemaLocation="http://www.bmjgroup.com/2007/07/BMJ-OAK bmj-oak-strict.xsd"
			xmlns="http://www.bmjgroup.com/2007/07/BMJ-OAK"
			>
			
			<xsl:if test="@id"><xsl:attribute name="id" select="@id"/></xsl:if>
			
			<xsl:call-template name="output-generated-id-attr"/>			

			<xsl:apply-templates select="metadata"/>

			<xsl:apply-templates select="title"/>

			<xsl:apply-templates select="key('Body',generate-id(title))" mode="Body"/>
			<xsl:apply-templates select="heading1" mode="h1"/>
			
			<xsl:call-template name="output-glossary"></xsl:call-template>
			<xsl:call-template name="output-references"></xsl:call-template>
		</section>
	</xsl:template>

	<xsl:template match="section[@class='introduction']" priority="2" mode="#all">
		<section>
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
			
			<xsl:call-template name="output-generated-id-attr"/>
			
			<xsl:apply-templates select="title"/>
			
			<xsl:if test="$debug='true'">
				<xsl:comment>Finding all body elements that have title #<xsl:value-of select="generate-id(title)"/># as a prec-sib</xsl:comment>
				
				<xsl:comment>Count is <xsl:value-of select="count(key('Body2',generate-id(title)))"/></xsl:comment>
				
				<xsl:comment>
					Elements: <xsl:for-each select="key('Body2',generate-id(title))">
						<xsl:value-of select="name()"/>#<xsl:value-of select="generate-id()"/>#<xsl:text> </xsl:text>
					</xsl:for-each>
				</xsl:comment>
			</xsl:if>
			
			<xsl:apply-templates select="key('Body2',generate-id(title))" mode="Body"/>
			<xsl:apply-templates select="heading1" mode="h1"/>
			
			<!-- if there are no heading1s, then go straight onto heading2 -->
			<xsl:if test="not(heading1)">
				<xsl:apply-templates select="heading2" mode="h2"/>
			</xsl:if>
		</section>
	</xsl:template>
	
	<xsl:template match="section" priority="1" mode="#all">
		<section>
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
			
			<xsl:call-template name="output-generated-id-attr"/>
			
			<xsl:apply-templates select="metadata"/>
			
			<xsl:apply-templates select="title"/>

			<xsl:if test="$debug='true'">
				<xsl:comment>Finding all body elements that have title #<xsl:value-of select="generate-id(title)"/># as a prec-sib</xsl:comment>
	
				<xsl:comment>Count is <xsl:value-of select="count(key('Body',generate-id(title)))"/></xsl:comment>
				
				<xsl:comment>
					Elements: <xsl:for-each select="key('Body',generate-id(title))">
						<xsl:value-of select="name()"/>#<xsl:value-of select="generate-id()"/>#<xsl:text> </xsl:text>
					</xsl:for-each>
				</xsl:comment>
			</xsl:if>
			
			<xsl:choose>
				<xsl:when test="title">
					<xsl:apply-templates select="key('Body',generate-id(title))" mode="Body"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="p" mode="#current"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:apply-templates select="heading1" mode="h1"/>

			<!-- if there are no heading1s, then go straight onto heading2 -->
			<xsl:if test="not(heading1)">
				<xsl:apply-templates select="heading2" mode="h2"/>
			</xsl:if>
			
		</section>
	</xsl:template>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	<!-- glossary stuff -->
	
	<xsl:template name="output-glossary">
		<xsl:if test="//link[@type='gloss']">
			<section class="glossary">
				<xsl:call-template name="output-gloss-sub">
					<xsl:with-param name="find-in" select="/"/>
					<xsl:with-param name="reference-count" select="1"/>
					<xsl:with-param name="link-index" select="1"/>
					<xsl:with-param name="link-count" select="count(//link[@type='gloss'])+1"/>
				</xsl:call-template>	
			</section>
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
			
			<!--
				<xsl:text>[link-id=</xsl:text><xsl:value-of select="$link-id"/>
				<xsl:text> link-index=</xsl:text><xsl:value-of select="$link-index"/>
				<xsl:text> key-id=</xsl:text><xsl:value-of select="$key-id"/>
				<xsl:text>] </xsl:text>
				[1]
				<xsl:comment><xsl:value-of select="$find-in"/></xsl:comment>
			-->
			
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

<!--
		<xsl:variable name="gloss-doc">
			<xsl:copy-of select="document(concat('file:///C:/dev/docato-install/BMJ/content/repository/en-gb/bmjk/patient-topics/', @target))"/>
		</xsl:variable>
-->
		
		<xsl:variable name="fileid">
			<xsl:call-template name="substring-after-last">
				<xsl:with-param name="string" select="@target"/>
				<xsl:with-param name="delimiter">/</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:comment>gloss doc: <xsl:value-of select="concat($gloss-dir,$fileid)"/></xsl:comment>
		
		<xsl:variable name="gloss-doc" select="document(concat($gloss-dir,$fileid))" />
		
			<gloss>
				<xsl:attribute name="id">bt_t_<xsl:value-of select="generate-id(key('gloss-link-keys', $link-target)[1])"></xsl:value-of></xsl:attribute>
				
				<p class="term"><b><xsl:apply-templates select="$gloss-doc//term/node()"/></b></p>
				<p class="definition"><xsl:apply-templates select="$gloss-doc//definition/node()"/></p>
			</gloss>
	</xsl:template>
	
	<xsl:template match="link[@type='gloss']"  mode="#all" priority="1">
		<xsl:if test="$debug='true'">
			<xsl:comment>gloss link</xsl:comment>
		</xsl:if>
		<xsl:variable name="link-target"><xsl:value-of select="@target"/></xsl:variable>
		<link>
			<xsl:attribute name="target">#xpointer(id('bt_t_<xsl:value-of select="generate-id(key('gloss-link-keys', $link-target)[1])"/>'))</xsl:attribute>
			<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="@bt:oen"/></xsl:attribute>
			<xsl:apply-templates/>
		</link>
	</xsl:template>
	
	<xsl:template match="gloss-link" mode="#all" priority="1">
		<xsl:variable name="link-var">
			<link>
				<xsl:attribute name="type">gloss</xsl:attribute>
				<xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
				
				<xsl:apply-templates mode="#current"/>
			</link>
		</xsl:variable>
		
		<xsl:apply-templates select="$link-var/link" mode="#current"/>
	</xsl:template>	
	
	<xsl:template match="gloss" mode="#all"></xsl:template>
	
	<xsl:template match="strong" mode="#all">
		<b><xsl:apply-templates mode="#current"/></b>
	</xsl:template>
	
	<xsl:template match="em" mode="#all">
		<i><xsl:apply-templates mode="#current"/></i>
	</xsl:template>
	
	
	
	
	
	
	
	
	
	
	<!-- reference stuff -->
	
	<xsl:template name="output-references">
		<xsl:if test="//link[@type='reference']">
			<references>
				<xsl:call-template name="output-reference-sub">
					<xsl:with-param name="find-in" select="/"/>
					<xsl:with-param name="reference-count" select="1"/>
					<xsl:with-param name="link-index" select="1"/>
					<xsl:with-param name="link-count" select="count(//link[@type='reference'])+1"/>
				</xsl:call-template>	
			</references>
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
			
			<!--
				<xsl:text>[link-id=</xsl:text><xsl:value-of select="$link-id"/>
				<xsl:text> link-index=</xsl:text><xsl:value-of select="$link-index"/>
				<xsl:text> key-id=</xsl:text><xsl:value-of select="$key-id"/>
				<xsl:text>] </xsl:text>
				[1]
				<xsl:comment><xsl:value-of select="$find-in"/></xsl:comment>
			-->
			
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
	
	<xsl:template match="reference" mode="#all"></xsl:template>
	
	<xsl:template match="link[@type='reference']" mode="reference" priority="2">
		<xsl:variable name="link-target"><xsl:value-of select="@target"/></xsl:variable>
		<reference>
			<xsl:attribute name="id">bt_t_<xsl:value-of select="generate-id(key('reference-link-keys', $link-target)[1])"></xsl:value-of></xsl:attribute>
			<xsl:if test="reference/unique-id[@source='medline']!=''">
				<xsl:attribute name="pubmed-id"><xsl:apply-templates select="reference/unique-id[@source='medline']/node()"/></xsl:attribute>
			</xsl:if>
			<p>
				<xsl:apply-templates select="reference/patient-citation/primary-authors/node()"/>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="reference/patient-citation/primary-title/node()"/>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="reference/patient-citation/source/node()"/>
			</p>
		</reference>
	</xsl:template>

	<xsl:template match="link[@type='reference']" mode="#all" priority="1">
		<xsl:if test="$debug='true'">
			<xsl:comment>reference link</xsl:comment>
		</xsl:if>	
		<xsl:variable name="link-target"><xsl:value-of select="@target"/></xsl:variable>
		<link>
			<xsl:attribute name="target">#xpointer(id('bt_t_<xsl:value-of select="generate-id(key('reference-link-keys', $link-target)[1])"/>'))</xsl:attribute>
			<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="@bt:oen"/></xsl:attribute>
		</link>
	</xsl:template>
	
	<xsl:template match="uri-link" mode="#all">
		<link>
			<xsl:attribute name="target"><xsl:value-of select="@target"/></xsl:attribute>
			<xsl:attribute name="oen" namespace="http://www.bmjgroup.com/2007/07/BMJ-OAK-BT"><xsl:value-of select="name(.)"/></xsl:attribute>
			<xsl:apply-templates mode="#current"/>
		</link>
	</xsl:template>	
<!--
	<xsl:template match="link[@type='reference']" mode="h1">
		<xsl:apply-templates select="."/>
	</xsl:template>
	
	<xsl:template match="link[@type='reference']" mode="h2">
		<xsl:apply-templates select="."/>
	</xsl:template>-->
	
	
	
	
	
	
	
	
	
	
	
	
	
	<!-- body text stuff -->
	
	
	<xsl:template match="heading1 | heading2 | heading3" mode="h1">
		<section>
			
			<xsl:if test="$debug='true'">
				<!--<xsl:attribute name="id">heading-h1-<xsl:value-of select="generate-id()"></xsl:value-of></xsl:attribute>-->
			</xsl:if>
			
			<xsl:call-template name="output-generated-id-attr"/>
			
			<title bt:oen="heading1">
				<xsl:apply-templates/>
			</title>

			<xsl:variable name="id">
				<xsl:value-of select="generate-id(.)"/>
			</xsl:variable>

			<xsl:apply-templates select="key('Body',generate-id())" mode="Body"/>
			<xsl:apply-templates select="key('h2',generate-id())" mode="h2"/>
		
		</section>
	</xsl:template>
	
	<xsl:template match="heading1 | heading2 | heading3" mode="h2">
		<section>
			<xsl:if test="$debug='true'">
				<!--<xsl:attribute name="id"><xsl:value-of select="generate-id()"/></xsl:attribute>-->
			</xsl:if>	
			
			<title bt:oen="heading2">
				<xsl:call-template name="output-generated-id-attr"/>
				<xsl:apply-templates/>
			</title>
			
			<xsl:variable name="id">
				<xsl:value-of select="generate-id(.)"/>
			</xsl:variable>
			
			<xsl:apply-templates select="key('Body',generate-id())" mode="Body"/>
			<xsl:apply-templates select="key('h3',generate-id())" mode="h3"/>
		</section>
	</xsl:template>
	
	<xsl:template match="p" mode="#all">
		<!-- if this p has nothing in it, don't output it -->
		<xsl:choose>
			<xsl:when test="not(.='')">
				<p>
					<xsl:if test="$debug='true'"><xsl:comment>[visible p]</xsl:comment></xsl:if>
					<xsl:apply-templates mode="#current"/></p>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$debug='true'">
					<xsl:if test="$debug='true'"><xsl:comment>[hidden empty p]</xsl:comment></xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="title" mode="#all">
		<!-- if this title has nothing in it, don't output it -->
		
		<xsl:choose>
			<xsl:when test="not(.='')">
				<title>
					<xsl:call-template name="output-generated-id-attr"/>
					
					<xsl:if test="$debug='true'"><xsl:comment>[visible title]</xsl:comment></xsl:if>
					<xsl:apply-templates mode="#current"/></title>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:if test="$debug='true'">
					<xsl:if test="$debug='true'"><xsl:comment>[hidden empty title]</xsl:comment></xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="list" mode="#all">
		<list>
			<xsl:if test="$debug='true'">
				<xsl:comment>[list h1]</xsl:comment>
			</xsl:if>
			
			<xsl:apply-templates/>
		</list>
	</xsl:template>



	<!-- elements we supress -->

	<xsl:template match="b[ancestor::link | ancestor::caption]" mode="#all">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="i[ancestor::link | ancestor::caption]" mode="#all">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	<!-- match any other element, writing it out and calling apply-templates for any children -->
	<xsl:template match="*" mode="#all" priority="-1">
		<xsl:if test="$debug='true'">
			<xsl:comment>[*<xsl:value-of select="name()"/>]</xsl:comment>
		</xsl:if>

		<xsl:element name="{name()}">

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

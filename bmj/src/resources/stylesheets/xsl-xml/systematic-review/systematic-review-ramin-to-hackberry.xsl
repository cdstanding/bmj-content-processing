<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cals="http://www.oasis-open.org/specs/tm9502.html"
	xmlns:saxon="http://icl.com/saxon"
	exclude-result-prefixes="saxon">
	
	<!--<xsl:include href="sharedToKms.xsl"/>-->
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:strip-space elements="term"/>
	<xsl:key name="link-key" match="link" use="@refid" />
	
	<xsl:param name="makefile-xml"/>
	
	<xsl:variable name="pagenum-text">, p 000</xsl:variable>
	<xsl:variable name="condition-id" select="/condition/@id"/>

    <xsl:variable name="makefile" select="document($makefile-xml)/CONDITIONS" />
    
    <xsl:variable name="pubdate" select="$makefile//CONDITION[@DOCTYPE = 'condition' and @ID = $condition-id]/@PUBDATE"/>
    
	<xsl:variable name="weight">
		<xsl:value-of select="
			( count( /condition[@status = 'new'] ) * 15 ) + 
			( count( //substantive-change/p[@status = 'new-option'] ) * 10 ) +
			( count( //substantive-change/p[@status = 'new-evidence-conclusions-changed'] ) * 7 ) +
			( count( //substantive-change/p[@status = 'new-evidence-conclusions-confirmed'] ) * 5 ) +
			( count( //substantive-change/p[@status = 'no-new-evidence'] ) * 1 )"/>
	</xsl:variable>
	
	<!-- add: band? -->
    
    <!-- on perch, xml is a symbolic link _either_ to the regular content folder, _or_ to the issue-n content folder -->
    <!--<xsl:variable name="external-xml-root">./xml/xml-new-template</xsl:variable>-->
	<xsl:param name="external-xml-root"/>

	<xsl:template match="condition">
	
		<condition>
			<xsl:attribute name="id" select="@id"/>
			<xsl:choose>
				<xsl:when test="@status='new'">
					<xsl:attribute name="is-new" select="'true'"/>
				</xsl:when>
				<xsl:when test="@status='update'">
					<xsl:attribute name="is-updated" select="'true'"/>
				</xsl:when>
				<xsl:when test="@status='non-update'">
					<!-- <xsl:attribute name="is-non-update" select="'true'"/> -->
				</xsl:when>
				<xsl:when test="@status='web-only'">
					<xsl:attribute name="is-archived" select="'true'"/>
				</xsl:when>
			</xsl:choose>
			<xsl:attribute name="xsi:noNamespaceSchemaLocation">http://schema.bmj.com/delivery/hackberry/condition.xsd</xsl:attribute>
			
			<xsl:comment>pubdate=<xsl:value-of select="$pubdate"/></xsl:comment>
			<xsl:comment>weight=<xsl:value-of select="$weight"/></xsl:comment>

			<xsl:variable name="section-details">
				<xsl:copy-of select="document(concat($external-xml-root, '/section/', section/@id, '.xml'))/SECTION-DETAILS"/>
			</xsl:variable>

			<primary-section-info>
				<xsl:attribute name="id"><xsl:value-of select="section/@id"/></xsl:attribute>

				<section-long-title><xsl:copy-of select="$section-details/SECTION-DETAILS/SECTIONTITLE/node()"/></section-long-title>
				<section-abridged-title><xsl:copy-of select="$section-details/SECTION-DETAILS/SHORTSECTION/node()"/></section-abridged-title>
				
				<xsl:apply-templates select="$section-details/SECTION-DETAILS/SECTIONADVISOR" mode="lc_generic"/>
			</primary-section-info>

			<!-- secondary-section-details -->
			<xsl:for-each select="$makefile//SECTION[CONDITION[@DOCTYPE = 'cross_ref' and @ID = $condition-id]]">
				<xsl:variable name="secondary-section-details">
					<xsl:copy-of select="document(concat($external-xml-root, '/section/', @ID, '.xml'))/SECTION-DETAILS"/>
				</xsl:variable>
			
				<secondary-section-info>
					<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
	
					<section-long-title>
						<xsl:value-of select="$secondary-section-details/SECTION-DETAILS/SECTIONTITLE"/>
					</section-long-title>
					
					<section-abridged-title>
						<xsl:value-of select="$secondary-section-details/SECTION-DETAILS/SHORTSECTION"/>
					</section-abridged-title>
					
					<xsl:apply-templates select="$secondary-section-details/SECTION-DETAILS/SECTIONADVISOR" mode="lc_generic"/>
				</secondary-section-info>
			</xsl:for-each>
			
			<condition-info>
				<xsl:apply-templates select="condition-long-title"/>
				<xsl:apply-templates select="condition-abridged-title"/>
				<xsl:apply-templates select="search-date"/>
				<xsl:apply-templates select="collective-name"/>
				
				<xsl:variable name="author-document"><xsl:copy-of select="document(concat($external-xml-root, '/author/', /condition/@id, '_authors.xml'))/CONTRIBDETAILS-COMPINTERESTS/*"/></xsl:variable>
				
				<!-- authors-->
				<xsl:apply-templates select="$author-document/CONTRIBDETAILS" mode="lc_generic"/>
	
				<!-- competing interests -->
				<competing-interests>
					<xsl:apply-templates select="$author-document/COMPINTERESTS" mode="lc_generic">
						<xsl:with-param name="childrenOnly">true</xsl:with-param>					
					</xsl:apply-templates>
				</competing-interests>
				
				<xsl:if test="string-length(summary-footnote/p[1])">
					<footnote>
						<xsl:apply-templates select="summary-footnote/node()"/>
					</footnote>
				</xsl:if>
				
				<xsl:if test="string-length(covered-elsewhere/p[1])">
					<covered-elsewhere>
						<xsl:apply-templates select="covered-elsewhere/node()"/>
					</covered-elsewhere>
				</xsl:if>
				
				<xsl:if test="string-length(subsequent-update/p[1])">
					<future-updates>
						<xsl:apply-templates select="subsequent-update/node()"/>
					</future-updates>
				</xsl:if>
			</condition-info>

			<!-- new key-points/one page summary section -->			
			<xsl:apply-templates select="key-point"/>
				
			<xsl:apply-templates select="background"/>
			
			<!-- key-message over-arching -->
			<xsl:for-each select="key-message">
				<xsl:comment>over-arching key-message to condition</xsl:comment>
				<key-message>
					<xsl:apply-templates/>
				</key-message>
			</xsl:for-each>
			
			<questions>
				<xsl:apply-templates select="question-section/node()"/>				
			</questions>
			
			<xsl:if test="substantive-change">
				<xsl:apply-templates select="substantive-change"/>
			</xsl:if>
			
			<xsl:if test="glossary/p[starts-with(@id, 'G')]">
				<glossary>
					<xsl:for-each select="glossary/p">
						<gloss>
							<xsl:attribute name="id"><xsl:value-of select="/condition/@id"/>_<xsl:value-of select="@id"/></xsl:attribute>
							<xsl:apply-templates select="node()"/>
						</gloss>
					</xsl:for-each>
				</glossary>
			</xsl:if>
			
			<references>
				<xsl:for-each select="reference-section/reference">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
				
				<!-- add: web-only references -->
				<xsl:for-each select="/condition/additional-note/sys-link[@type='web-table']">
				
					<xsl:variable name="table-ref" select="document(concat($external-xml-root, '/table/', /condition/@id, '_table_', substring-after(@refid,'table_'), '.xml'))//TABLEREF/node()"/>
					<xsl:variable name="reference-count" select="count(document(concat($external-xml-root, '/table/', /condition/@id, '_table_', substring-after(@refid,'table_'), '.xml'))//REFERENCE)"/>

					<!-- <test>table=<xsl:value-of select="$table-ref"/> ref=<xsl:value-of select="$reference-count"/></test> -->
						
					<xsl:for-each select="document(concat($external-xml-root, '/table/', /condition/@id, '_table_', substring-after(@refid,'table_'), '.xml'))//REFERENCE">
						
						<reference>
							<xsl:attribute name="id">
								<xsl:value-of select="concat($condition-id, '_T', $table-ref, '_REF', substring-after(REFERENCEDETAILS/@ID, 'WEB-REF'))"/>
							</xsl:attribute>
							<xsl:attribute name="media">
								<xsl:text>web</xsl:text>
							</xsl:attribute>
							<xsl:apply-templates select="REFERENCEDETAILS/node()" mode="lc_generic"/>
						</reference>
						
					</xsl:for-each>
				</xsl:for-each>
				
			</references>
			
			<xsl:if test="//link[@type='web-figure'] or /condition/additional-note/sys-link[@type='system-figure']">
				<figures>
					<!-- output print figures -->
					<xsl:for-each select="/condition/additional-note/sys-link[@type='system-figure']">
						<xsl:apply-templates select="document(concat($external-xml-root, '/figure/', /condition/@id, '_figure_', substring(@refid,2), '.xml'))/*">
							<xsl:with-param name="condition-id" select="$condition-id"/>
						</xsl:apply-templates>
					</xsl:for-each>
				
					<!-- output unique web figures -->
					<xsl:for-each select="//link[@type='web-figure' and generate-id()=generate-id(key('link-key',@refid)[1])]">
						<figure>
							<xsl:attribute name="id">
								<xsl:value-of select="/condition/@id"/>
								<xsl:text>_F</xsl:text>
								<xsl:value-of select="substring-after(@refid, '_')"/>
							</xsl:attribute>
							<xsl:attribute name="media">
								<xsl:text>web</xsl:text>
							</xsl:attribute>

							<graphic>
								<xsl:attribute name="url">
									<xsl:text>http://www.clinicalevidence.com/images/</xsl:text>
									<xsl:value-of select="/condition/@id"/>
									<xsl:text>_figure_</xsl:text>
									<xsl:value-of select="substring-after(@refid, '_')"/>
									<xsl:text>.jpg</xsl:text>
								</xsl:attribute>
							</graphic>

                            <!-- currently empty: we can't convert web figures -->
						</figure>
					</xsl:for-each>
				</figures>
			</xsl:if>

			<xsl:if test="//link[@type='web-table'] or /condition/additional-note/sys-link[@type='system-table']">
				<tables>
					<!-- output print tables -->
					<xsl:for-each select="/condition/additional-note/sys-link[@type='system-table']">
						<xsl:apply-templates select="document(concat($external-xml-root, '/table/', /condition/@id, '_table_', substring(@refid,2), '.xml'))/*">
							<xsl:with-param name="condition-id" select="$condition-id"/>
						</xsl:apply-templates>
					</xsl:for-each>
					<!-- output unique web tables -->
					<xsl:for-each select="//link[@type='web-table' and generate-id()=generate-id(key('link-key',@refid)[1])]">
						<xsl:apply-templates select="document(concat($external-xml-root, '/table/', /condition/@id, '_table_', substring-after(@refid,'table_'), '.xml'))/*">
							<xsl:with-param name="condition-id" select="$condition-id"/>
						</xsl:apply-templates>
					</xsl:for-each>
				</tables>
			</xsl:if>
			
		</condition>
	</xsl:template>
	
	<xsl:template match="/condition/key-point">
		<keypoint-list>
			<xsl:attribute name="id"><xsl:value-of select="/condition/@id"/>_KEYPOINT</xsl:attribute>
			<xsl:for-each select="*">
				<xsl:if test="name() = 'title'">
					<p>
						<xsl:apply-templates select="node()"/>
					</p>
				</xsl:if>
				<xsl:if test="name() = 'p'">
					<xsl:if test="preceding-sibling::*[1][name() = 'title']">
						<xsl:text disable-output-escaping="yes">&lt;ul&gt;</xsl:text>
					</xsl:if>
					<li>
						<xsl:apply-templates select="node()"/>
					</li>
					<xsl:if test="following-sibling::*[1][name() = 'title'] or not(following-sibling::*[1])">
						<xsl:text disable-output-escaping="yes">&lt;/ul&gt;</xsl:text>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>
		</keypoint-list>
	</xsl:template>
	
	<xsl:template match="//option/key-point">
		<!-- do nothing -->
	</xsl:template>
	
	<!-- todo add diagnosis back into the list below -->
	<xsl:template match="diagnosis">
		<xsl:choose>
		   <xsl:when test='.!=""'>
				<xsl:element name="{name()}">
					<xsl:attribute name="id"><xsl:value-of select="/condition/@id"/>_<xsl:value-of select="translate(name(), $lower, $upper)"/></xsl:attribute>
					<xsl:apply-templates select="node()"/>
				</xsl:element>
		   </xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="definition | incidence | aetiology | prognosis | aims | outcomes | methods">
		<xsl:element name="{name()}">
			<xsl:attribute name="id"><xsl:value-of select="/condition/@id"/>_<xsl:value-of select="translate(name(), $lower, $upper)"/></xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="benefits | harms | comment">
		<xsl:element name="{name()}">
			<xsl:attribute name="id"><xsl:value-of select="/condition/@id"/>_<xsl:value-of select="ancestor::option/@id"/>_<xsl:value-of select="translate(name(), $lower, $upper)"/></xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="drug-safety-alert">
		<xsl:element name="{name()}">
			<xsl:attribute name="id"><xsl:value-of select="/condition/@id"/>_<xsl:value-of select="ancestor::option/@id"/>_ALERT</xsl:attribute>
			<xsl:for-each select="p">
				<p>
					<xsl:apply-templates select="node()"/>
				</p>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<!-- output a single reference -->
	<xsl:template match="reference">
		<reference>
			<xsl:attribute name="id"><xsl:value-of select="$condition-id"/>_<xsl:value-of select="@id"/></xsl:attribute>
			<xsl:if test="number(@pubmed-id) and (string-length(@pubmed-id) &gt; 5)">
				<xsl:attribute name="pubmed-id"><xsl:value-of select="@pubmed-id"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</reference>
	</xsl:template>

	
	<xsl:template match="link[@type='internal-target']">
		<link>
			<xsl:choose>

				<!-- todo: inverse -->
				<xsl:when test="@refid='Definition'"><xsl:attribute name="type">background</xsl:attribute></xsl:when>
				<xsl:when test="@refid='Incidence'"><xsl:attribute name="type">background</xsl:attribute></xsl:when>
				<xsl:when test="@refid='Aetiology'"><xsl:attribute name="type">background</xsl:attribute></xsl:when>
				<xsl:when test="@refid='Diagnosis'"><xsl:attribute name="type">background</xsl:attribute></xsl:when>
				<xsl:when test="@refid='Prognosis'"><xsl:attribute name="type">background</xsl:attribute></xsl:when>
				<xsl:when test="@refid='Aims'"><xsl:attribute name="type">background</xsl:attribute></xsl:when>
				<xsl:when test="@refid='Outcomes'"><xsl:attribute name="type">background</xsl:attribute></xsl:when>				
				<xsl:when test="@refid='Methods'"><xsl:attribute name="type">background</xsl:attribute></xsl:when>				
				
				<xsl:when test="contains(@refid, '_benefits')"><xsl:attribute name="type">option-benefits</xsl:attribute></xsl:when>
				<xsl:when test="contains(@refid, '_harms')"><xsl:attribute name="type">option-harms</xsl:attribute></xsl:when>
				<xsl:when test="contains(@refid, '_comment')"><xsl:attribute name="type">option-comment</xsl:attribute></xsl:when>
				<xsl:when test="starts-with(@refid, 'I')"><xsl:attribute name="type">option</xsl:attribute></xsl:when>
				<xsl:when test="starts-with(@refid, 'T')"><xsl:attribute name="type">table</xsl:attribute></xsl:when>
				<xsl:when test="starts-with(@refid, 'F')"><xsl:attribute name="type">figure</xsl:attribute></xsl:when>
				<xsl:when test="starts-with(@refid, 'Q')"><xsl:attribute name="type">question</xsl:attribute></xsl:when>
				
				<xsl:otherwise><xsl:attribute name="type">todo</xsl:attribute></xsl:otherwise>
			</xsl:choose>
			
			<xsl:attribute name="target"><xsl:value-of select="/condition/@id"/>_<xsl:value-of select="translate(@refid, $lower, $upper)"/></xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</link>
	</xsl:template>
	
	<xsl:template match="ext-link[@type='external-condition']">
		<link>
			<xsl:attribute name="type">condition</xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="@refid"/></xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</link>
	</xsl:template>
	
	<xsl:template match="link">
		<link>
			<xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute>
			<xsl:if test="@refid"><xsl:attribute name="target"><xsl:value-of select="/condition/@id"/>_<xsl:value-of select="@refid"/></xsl:attribute></xsl:if>
			<xsl:apply-templates select="node()"/>
		</link>
	</xsl:template>

	<xsl:template match="link[@type='web-table']">
		<link>
			<xsl:attribute name="type">table</xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="/condition/@id"/>_T<xsl:value-of select="translate(substring-after(@refid, '_'), $lower, $upper)"/></xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</link>
	</xsl:template>
	
	<xsl:template match="link[@type='web-figure']">
		<link>
			<xsl:attribute name="type">figure</xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="/condition/@id"/>_F<xsl:value-of select="translate(substring-after(@refid, '_'), $lower, $upper)"/></xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</link>
	</xsl:template>

	<xsl:template match="link[@type='internal-table']">
		<link>
			<xsl:attribute name="type">table</xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="/condition/@id"/>_<xsl:value-of select="translate(@refid, $lower, $upper)"/></xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</link>
	</xsl:template>

	<xsl:template match="link[@type='internal-figure']">
		<link>
			<xsl:attribute name="type">figure</xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="/condition/@id"/>_<xsl:value-of select="translate(@refid, $lower, $upper)"/></xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</link>
	</xsl:template>

	<xsl:template match="link[@type='internal-glossary']">
		<link>
			<xsl:attribute name="type">glossary</xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="/condition/@id"/>_<xsl:value-of select="translate(@refid, $lower, $upper)"/></xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</link>
	</xsl:template>
	
	<!-- todo: the inverse -->
	<xsl:template match="question">
		<question>
			<xsl:if test="@status='new'">
				<xsl:attribute name="is-new">true</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="id"><xsl:value-of select="/condition/@id"/>_<xsl:value-of select="@id"/></xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</question>
	</xsl:template>

	<!-- todo: the inverse -->
	<xsl:template match="option">
		<option>
			<xsl:if test="@status='new'">
				<xsl:attribute name="is-new">true</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="id"><xsl:value-of select="/condition/@id"/>_<xsl:value-of select="@id"/></xsl:attribute>
			
			<xsl:apply-templates select="node()"/>
		</option>
	</xsl:template>

	<!-- todo: do the inverse -->
	<xsl:template match="contributor">
		<xsl:choose>
			<xsl:when test="name(ancestor::node()[1])='question'"><question-contributor><xsl:apply-templates select="node()"/></question-contributor></xsl:when>
			<xsl:when test="name(ancestor::node()[1])='option'"><option-contributor><xsl:apply-templates select="node()"/></option-contributor></xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="summary">
		<intervention-summary>
			<xsl:apply-templates select="node()"/>
		</intervention-summary>
	</xsl:template>

	<!-- todo: the inverse -->
	<xsl:template match="substantive-change">
		<xsl:if test="normalize-space(p[1])!='' or p[1]/@status">
			<substantive-changes>
				<xsl:for-each select="p">
					<substantive-change>
						<xsl:if test="@id">
							<xsl:attribute name="id" select="@id"/>
						</xsl:if>
						<xsl:if test="@status">
							<xsl:attribute name="status" select="@status"/>
						</xsl:if>
						<xsl:apply-templates select="node()"/>
					</substantive-change>
				</xsl:for-each>
			</substantive-changes>
		</xsl:if>
	</xsl:template>

	<!-- don't show p tags in options -->
	<xsl:template match="p">
		<xsl:choose>
			<xsl:when test="ancestor::*[name() = 'option']"><xsl:apply-templates select="node()"/></xsl:when>
			<xsl:otherwise><p><xsl:apply-templates select="node()"/></p></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- todo: the inverse -->
	<xsl:template match="ext-link[@type='external-url']">
		<link>
			<xsl:attribute name="type">url</xsl:attribute>
			<xsl:attribute name="target"><xsl:value-of select="@refid"/></xsl:attribute>
			<xsl:apply-templates select="node()"/>
		</link>
	</xsl:template>
	
	<!-- strip diagnosis tags including contents: Todo: ? -->
	<!--xsl:template match="diagnosis|unknown-paragraph"-->
	<xsl:template match="unknown-paragraph">
	</xsl:template>

	<!-- strip u tags, but show contents: Todo: ? -->
	<xsl:template match="u">
		<xsl:apply-templates select="node()"/>
	</xsl:template>

	<xsl:template name="process-text">
		<xsl:param name="str"/>

        <xsl:choose>
			<xsl:when test="contains($str,'[')">
				<xsl:variable name="target" select="substring-before(substring-after($str, '['), ']')"/>
				
				<!-- if the stuff in square brackets is an integer, add a reference link -->
				<xsl:choose>
					<xsl:when test="matches($target, '^\d+$')">
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-before($str,'[')"/>
						</xsl:call-template>
						<xsl:text/>
						<link type="reference">
							<xsl:attribute name="target">
								<xsl:value-of select="/condition/@id"/>
								<xsl:text>_REF</xsl:text>
								<xsl:value-of select="$target"/>
							</xsl:attribute>
							<!--xsl:attribute name="remainder" select="substring-after(substring-after($str, '['), ']')"/-->
						</link>
						<xsl:text/>
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-after(substring-after($str, '['), ']')"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<!-- there might be more square brackets later... -->
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-before($str,'[')"/>
						</xsl:call-template>
						<xsl:text>[</xsl:text>
						<xsl:call-template name="process-text">
							<xsl:with-param name="str" select="substring-after($str,'[')"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:when>
			<xsl:when test="contains($str, $pagenum-text)">
				<xsl:call-template name="process-text">
					<xsl:with-param name="str" select="substring-before($str, $pagenum-text)"/>
				</xsl:call-template>
				<!--xsl:processing-instruction name="pagenum"/--> 
				<!-- todo we need to decide what to do with page numbers -->
				<xsl:call-template name="process-text">
					<xsl:with-param name="str" select="substring-after($str, $pagenum-text)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$str"/>
			</xsl:otherwise>
        </xsl:choose>
	</xsl:template>

	<xsl:template match="text()">
		<!--xsl:variable name="references-expanded"></xsl:variable-->
		<xsl:call-template name="process-text">
			<xsl:with-param name="str"><xsl:value-of select="."/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<!-- generic template to copy an element -->
	<xsl:template match="*">
		<xsl:element name="{name()}">
			<xsl:for-each select="@*">
				<xsl:choose>
					<xsl:when test="name()='id'"><xsl:attribute name="{name()}"><xsl:value-of select="/condition/@id"/>_<xsl:value-of select="."/></xsl:attribute></xsl:when>
					<xsl:otherwise><xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute></xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

			<xsl:apply-templates select="node()"/>
		</xsl:element>
	</xsl:template>	

	<xsl:template match="intervention-title">
		<intervention-title>
			<xsl:choose>
				<xsl:when test="@type='categorisation'"><xsl:attribute name="efficacy">not-given</xsl:attribute></xsl:when>
				<xsl:otherwise><xsl:attribute name="efficacy"><xsl:value-of select="@type"/></xsl:attribute></xsl:otherwise>
			</xsl:choose>
			
			
			<xsl:apply-templates select="node()"/>
		</intervention-title>
	</xsl:template>

	<!-- if the strong is in a glossary, replace it with a term tag, otherwise just output the strong -->
	<xsl:template match="strong">
		<xsl:choose>
			<xsl:when test="name(ancestor::node()[2])='glossary'"><term><xsl:apply-templates select="node()"/></term></xsl:when>
			<xsl:otherwise><strong><xsl:apply-templates select="node()"/></strong></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
		<!--
	===================================================
		tables and figures
	===================================================
	-->
	<!-- output a single figure -->
	<xsl:template match="FIGURE">
		<xsl:param name="condition-id"/>
		
		<figure>
			<!-- get the id attrib from the FIGUREREF child -->
			<xsl:attribute name="id"><xsl:value-of select="$condition-id"/>_<xsl:value-of select="FIGUREREF/@ID"/></xsl:attribute>
			<xsl:attribute name="media">print, web</xsl:attribute>

			<!-- output the graphic -->
			<graphic>
				<xsl:attribute name="url"><xsl:value-of select="concat('http://www.clinicalevidence.com/images/', substring(GRAPHIC/@FILENAME, 1, 4), '_figure_',  substring(GRAPHIC/@FILENAME, 7, 10), '.jpg')"/></xsl:attribute>
			</graphic>
			<!-- output the caption -->
			<caption>
				<xsl:apply-templates select="FIGURECAPTION" mode="lc_generic">
					<xsl:with-param name="childrenOnly">true</xsl:with-param>
				</xsl:apply-templates>
			</caption>
		</figure>
	</xsl:template>
	
	<!-- output a single table -->
	<xsl:template match="TABLEDATA">
		<xsl:param name="condition-id"/>
		
		<table-data>
			<!-- get ID from the TABLEREF child -->
			<xsl:attribute name="id"><xsl:value-of select="$condition-id"/>_<xsl:value-of select="TABLEREF/@ID"/></xsl:attribute>
			<!-- if tableref integer handle as print+web otherwise as web-only -->
			<xsl:choose>
				<xsl:when test="string(number(TABLEREF))!='NaN'">
					<xsl:attribute name="media">print, web</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="media">web</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>						
			<!-- output caption -->
			<caption>
				<xsl:apply-templates select="TABLECAPTION" mode="lc_generic">
					<xsl:with-param name="childrenOnly">true</xsl:with-param>
				</xsl:apply-templates>
			</caption>
			<!-- output the CALS table -->
			<xsl:apply-templates select="TABLE" mode="lc_generic">
				<xsl:with-param name="calsNamespace">true</xsl:with-param>
			</xsl:apply-templates>
		</table-data>
	</xsl:template>

	<!--
	===================================================
		general templates to lower case elements
	===================================================
	-->
	<!--
		constants for the upper- and lowercase alphabets. These are used when
		converting from upper to lowercase
	-->
	<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'"/>
	<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz-'"/>
	
	<!-- generalised template to lower case the element and all children -->
	<xsl:template match="*" mode="lc_generic">
		<xsl:param name="noPIs" select="false"/>
		<xsl:param name="childrenOnly" select="false"/>
		<xsl:param name="noParentAttribs" select="false"/>
		<xsl:param name="noLinks" select="false"/>
		<xsl:param name="noInternalLinks" select="false"/>
		<xsl:param name="calsNamespace" select="false"/>
		
		<!--
		<debug>
			<xsl:attribute name="noPIs"><xsl:value-of select="$noPIs"/></xsl:attribute>
			<xsl:attribute name="childrenOnly"><xsl:value-of select="$childrenOnly"/></xsl:attribute>
			<xsl:attribute name="noParentAttribs"><xsl:value-of select="$noParentAttribs"/></xsl:attribute>
			<xsl:attribute name="noLinks"><xsl:value-of select="$noLinks"/></xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="name()"/></xsl:attribute>
			<xsl:attribute name="atcount"><xsl:value-of select="count(@*)"/></xsl:attribute>
		</debug>
		-->
		
		<xsl:choose>
			<xsl:when test="$noLinks='true' and name()='XREF'">
				<supress></supress>
				<!-- supress elements -->
			</xsl:when>
			<xsl:when test="$noLinks='true' and name()='EXTREF'">
				<supress></supress>
				<!-- supress elements -->
			</xsl:when>
			<xsl:when test="$childrenOnly='true'">
				<!-- lowercase children -->
				<xsl:for-each select="node()">
					<xsl:apply-templates select="." mode="lc_generic">
						<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
						<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
						<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
					</xsl:apply-templates>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="$calsNamespace='true'">
				<!-- lowercase the element name -->
				<xsl:element name="cals:{translate(name(), $upper, $lower)}">
					<!-- lowercase each attribute -->
					<xsl:for-each select="@*">
						<xsl:attribute name="{translate(name(), $upper, $lower)}"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
					<!-- lowercase children -->
					<xsl:for-each select="node()">
						<xsl:apply-templates select="." mode="lc_generic">
							<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
							<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
							<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
							<xsl:with-param name="calsNamespace">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
			
				<!-- lowercase the element name -->
				<xsl:element name="{translate(name(), $upper, $lower)}">
					<xsl:choose>
						<xsl:when test="$noParentAttribs='true' or name()='P'">
							<!-- craziness going on when I try to do != 'true' -->
							<!-- also don't output attributes for P tags -->
						</xsl:when>
						<xsl:otherwise>
							<!-- lowercase each attribute -->
							<xsl:for-each select="@*">
								<xsl:choose>
									<xsl:when test="name()='ID'"><xsl:attribute name="id"><xsl:value-of select="$condition-id"/>_<xsl:value-of select="."/></xsl:attribute></xsl:when>
									<xsl:otherwise><xsl:attribute name="{translate(name(), $upper, $lower)}"><xsl:value-of select="."/></xsl:attribute></xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					
					<!-- lowercase children -->
					<xsl:for-each select="node()">
						<xsl:apply-templates select="." mode="lc_generic">
						<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
						<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
						<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
						</xsl:apply-templates>
					</xsl:for-each>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- replace xpp qa PIs with br slash-->
	<xsl:template match="processing-instruction('xpp')" mode="lc_generic">
		<xsl:if test=".='qa' and ancestor::*[name()='TABLEDATA']">
			<cals:br />
		</xsl:if>
	</xsl:template>

	<!-- discard newitem PIs -->
	<xsl:template match="processing-instruction('newitem')" mode="lc_generic">
	</xsl:template>

	<!-- discard all PIs -->
	<xsl:template match="processing-instruction()" mode="lc_generic">
	<!--
		<xsl:param name="noPIs" select="false"/>
		
		<xsl:choose>
			<xsl:when test="$noPIs='true'"></xsl:when>
			<xsl:otherwise>
				<xsl:processing-instruction name="{name()}" xml:space="default">
					<xsl:value-of select="normalize-space(.)"/>
				</xsl:processing-instruction>
			</xsl:otherwise>
		</xsl:choose>
-->
	</xsl:template>


	<!-- XREFs are in the shared file because of external files used in new template XML -->
	<!-- takes an xref and turns it into a link tag -->
	<xsl:template match="XREF" mode="lc_generic">
		<xsl:param name="noPIs" select="false"/>
		<xsl:param name="childrenOnly" select="false"/>
		<xsl:param name="noParentAttribs" select="false"/>
		<xsl:param name="noLinks" select="false"/>
		<xsl:param name="noInternalLinks" select="false"/>
		
		<xsl:choose>

			
			<xsl:when test="$noLinks='true'"></xsl:when>
			<xsl:when test="$noInternalLinks='true'"></xsl:when>
			<xsl:otherwise>
				<link>
					<xsl:choose>
						<xsl:when test="starts-with(@REFID, 'REF')">
							<xsl:attribute name="type">reference</xsl:attribute>
						</xsl:when>
						<xsl:when test="starts-with(@REFID, 'WEB-REF')">
							<xsl:attribute name="type">reference</xsl:attribute>
						</xsl:when>
						<xsl:when test="starts-with(@REFID, 'T')">
							<xsl:attribute name="type">table</xsl:attribute>
						</xsl:when>
						<xsl:when test="starts-with(@REFID, 'F')">
							<xsl:attribute name="type">figure</xsl:attribute>
						</xsl:when>
						<xsl:when test="starts-with(@REFID, 'G')">
							<xsl:attribute name="type">glossary</xsl:attribute>
						</xsl:when>
						<!-- link to a question -->
						<xsl:when test="starts-with(@REFID, 'Q')">
							<!-- TODO how do we handle this? -->
							<xsl:attribute name="type">question</xsl:attribute>
						</xsl:when>
						<!-- todo: should these point to individual sections rather than just the summary? -->
						<xsl:when test="@REFID='DEFINITION'">
							<xsl:attribute name="type">background</xsl:attribute>
						</xsl:when>
						<xsl:when test="@REFID='AETIOLOGY'">
							<xsl:attribute name="type">background</xsl:attribute>
						</xsl:when>
						<xsl:when test="@REFID='PROGNOSIS'">
							<xsl:attribute name="type">background</xsl:attribute>
						</xsl:when>
						<xsl:when test="@REFID='METHODS'">
							<xsl:attribute name="type">background</xsl:attribute>
						</xsl:when>
						<xsl:when test="@REFID='OUTCOMES'">
							<xsl:attribute name="type">background</xsl:attribute>
						</xsl:when>
						<xsl:when test="@REFID='INCIDENCE'">
							<xsl:attribute name="type">background</xsl:attribute>
						</xsl:when>
						<xsl:when test="starts-with(@REFID, 'I')">
							<!-- Intervention links (starting with I) can be benefits, harms or comments -->
							<!-- constants for benefits, harms and comment -->
							<xsl:variable name="benefits">BENEFITS</xsl:variable>
							<xsl:variable name="harms">HARMS</xsl:variable>
							<xsl:variable name="comment">COMMENT</xsl:variable>
							<xsl:variable name="sumstatement">SUMSTATEMENT</xsl:variable>
							<!-- XSL has a starts-with but not an ends-with function. stupid. -->
							<xsl:choose>
								<xsl:when test="substring(@REFID, 1 - string-length($benefits) + string-length(@REFID))=$benefits">
									<xsl:attribute name="type">option-benefits</xsl:attribute>
								</xsl:when>
								<xsl:when test="substring(@REFID, 1 - string-length($harms) + string-length(@REFID))=$harms">
									<xsl:attribute name="type">option-harms</xsl:attribute>
								</xsl:when>
								<xsl:when test="substring(@REFID, 1 - string-length($comment) + string-length(@REFID))=$comment">
									<xsl:attribute name="type">option-comment</xsl:attribute>
								</xsl:when>
								<xsl:when test="substring(@REFID, 1 - string-length($sumstatement) + string-length(@REFID))=$sumstatement">
									<xsl:attribute name="type">option-key-messages</xsl:attribute>
								</xsl:when>
								<!-- if the string consists of I followed by a number then it's a link to an intervention -->
								<xsl:when test="string(number(substring(@REFID, 2)))!='NaN'">
									<xsl:attribute name="type">option</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="type">unknown-intervention-xref-type</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="type">unknown-xref-type</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:choose>
						<xsl:when test="starts-with(@REFID, 'WEB-REF')">
							<xsl:variable name="table-ref" select="ancestor::TABLEDATA/TABLEREF"/>
							<xsl:attribute name="target">
								<xsl:value-of select="concat($condition-id, '_T', $table-ref, '_REF', substring-after(@REFID, 'WEB-REF'))"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="target"><xsl:value-of select="$condition-id"/>_<xsl:value-of select="translate(@REFID, $lower, $upper)"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					
					<!-- convert children to lowercase -->
					<xsl:apply-templates select="node()" mode="lc_generic">
						<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
						<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
						<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
					</xsl:apply-templates>
				</link>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- specific template to replace i with em -->
	<xsl:template match="I" mode="lc_generic">
		<xsl:param name="noPIs" select="false"/>
		<xsl:param name="noLinks" select="false"/>
		<xsl:param name="noInternalLinks" select="false"/>
		<xsl:param name="calsNamespace" select="false"/>

		<xsl:choose>
			<xsl:when test="$calsNamespace='true'">
				<cals:i>
					<!-- lowercase children -->
					<xsl:for-each select="node()">
						<xsl:apply-templates select="." mode="lc_generic">
							<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
							<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
							<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
							<xsl:with-param name="calsNamespace">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:for-each>
				</cals:i>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<!-- convert children to lowercase -->
					<xsl:apply-templates select="node()" mode="lc_generic">
						<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
						<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
						<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
					</xsl:apply-templates>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
 
	<!-- strip SMCAP tags, but show contents: Todo: ? -->
	<xsl:template match="SMCAP" mode="lc_generic">
		<xsl:apply-templates select="node()" mode="lc_generic"/>
	</xsl:template>
	
	<!-- strip U tags, but show contents: Todo: ? -->
	<xsl:template match="U" mode="lc_generic">
		<xsl:apply-templates select="node()" mode="lc_generic"/>
	</xsl:template>

	<!-- specific template to replace b with strong -->
	<xsl:template match="B" mode="lc_generic">
		<xsl:param name="noPIs" select="false"/>
		<xsl:param name="noLinks" select="false"/>
		<xsl:param name="noInternalLinks" select="false"/>
		<xsl:param name="calsNamespace" select="false"/>
		
		<xsl:choose>
			<xsl:when test="$calsNamespace='true'">
				<cals:b>
					<!-- lowercase children -->
					<xsl:for-each select="node()">
						<xsl:apply-templates select="." mode="lc_generic">
							<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
							<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
							<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
							<xsl:with-param name="calsNamespace">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:for-each>
				</cals:b>
			</xsl:when>
			<xsl:otherwise>
				<strong>
					<!-- convert children to lowercase -->
					<xsl:apply-templates select="node()" mode="lc_generic">
						<xsl:with-param name="noPIs"><xsl:value-of select="$noPIs"/></xsl:with-param>
						<xsl:with-param name="noLinks"><xsl:value-of select="$noLinks"/></xsl:with-param>
						<xsl:with-param name="noInternalLinks"><xsl:value-of select="$noInternalLinks"/></xsl:with-param>
					</xsl:apply-templates>
				</strong>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- specific template for CONTRIBDETAILS -->
	<xsl:template match="CONTRIBDETAILS" mode="lc_generic">
		<contributors>
			<xsl:for-each select="CONTRIBUTOR">
				<contributor>
					<xsl:attribute name="id"><xsl:value-of select="$condition-id"/>_<xsl:value-of select="@ID"/></xsl:attribute>
					<nomen>
						<xsl:apply-templates select="NOMEN" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</nomen>
					<first-name>
						<xsl:apply-templates select="FIRSTNAME" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</first-name>
					<middle-name>
						<xsl:apply-templates select="MIDDLENAME" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</middle-name>
					<last-name>
						<xsl:apply-templates select="LASTNAME" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</last-name>
					<pedigree>
						<xsl:apply-templates select="PEDIGREE" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</pedigree>
					<honorific>
						<xsl:apply-templates select="HONORIFIC" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</honorific>
					<title>
						<xsl:apply-templates select="AUTHORTITLE" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</title>
					<affiliation>
						<xsl:apply-templates select="following-sibling::*[name() = 'AFFILIATION' and normalize-space(.)!=''][1]"  mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</affiliation>
					<city>
						<xsl:apply-templates select="following-sibling::*[name() = 'CITY' and normalize-space(.)!=''][1]"  mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</city>
					<country>
						<xsl:apply-templates select="following-sibling::*[name() = 'COUNTRY' and normalize-space(.)!=''][1]" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</country>
				</contributor>
			</xsl:for-each>
		</contributors>
	</xsl:template>


	<!-- specific template for SECTIONADVISOR -->
	<xsl:template match="SECTIONADVISOR" mode="lc_generic">
		<section-advisors>
			<xsl:for-each select="CONTRIBDETAILS/CONTRIBUTOR">
				<advisor>
					<nomen>
						<xsl:apply-templates select="NOMEN" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</nomen>
					<first-name>
						<xsl:apply-templates select="FIRSTNAME" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</first-name>
					<middle-name>
						<xsl:apply-templates select="MIDDLENAME" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</middle-name>
					<last-name>
						<xsl:apply-templates select="LASTNAME" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</last-name>
					<pedigree>
						<xsl:apply-templates select="PEDIGREE" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</pedigree>
					<honorific>
						<xsl:apply-templates select="HONORIFIC" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</honorific>
					<title>
						<xsl:apply-templates select="AUTHORTITLE" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</title>
					<affiliation>
						<xsl:apply-templates select="following-sibling::*[name() = 'AFFILIATION' and normalize-space(.)!=''][1]" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</affiliation>
					<city>
						<xsl:apply-templates select="following-sibling::*[name() = 'CITY' and normalize-space(.)!=''][1]" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</city>
					<country>
						<xsl:apply-templates select="following-sibling::*[name() = 'COUNTRY' and normalize-space(.)!=''][1]" mode="lc_generic">
							<xsl:with-param name="childrenOnly">true</xsl:with-param>
						</xsl:apply-templates>
					</country>
				</advisor>
			</xsl:for-each>
		</section-advisors>
	</xsl:template>
	
</xsl:stylesheet>
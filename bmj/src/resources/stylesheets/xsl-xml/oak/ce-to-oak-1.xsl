<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:ce="http://www.bmjgroup.com/2007/05/OAK-BMJK-CE-OEN"
	xmlns:refman="http://www.bmj.com/bmjk/behive/refman/2006-10">
	
	<xsl:output
		encoding="UTF-8"
		method="xml" 
		indent="yes"/>
	
	<xsl:param name="lang"/>
	<xsl:param name="media"/>
	<xsl:param name="components"/>
	
	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:include href="../../xsl-lib/bmj-string-lib.xsl"/>
	<xsl:include href="../../systematic-review-params.xsl"/>	

	<xsl:template match="/*">
		<xsl:element name="section">
			<xsl:attribute name="class" select="name()"/>
			<xsl:attribute name="id" select="substring-after(@id, '_')"/>
			
			<xsl:element name="title">
				<xsl:apply-templates select="/*/info/title/node()"/>
			</xsl:element>
			<!--<xsl:element name="abridged-title">
				<xsl:apply-templates select="/*/info/abridged-title/node()"/>
			</xsl:element>-->

			<xsl:element name="metadata">
				<xsl:element name="key">
					<xsl:attribute name="ce:name">search-date</xsl:attribute>
					<xsl:attribute name="value" select="/*/info/search-date"/>
				</xsl:element>
				<xsl:element name="key">
					<xsl:attribute name="ce:name">publication-date</xsl:attribute>
					<xsl:attribute name="value" select="/*/info/search-date"/>
				</xsl:element>
			</xsl:element>

			<xsl:call-template name="process-person-group"/>
			<xsl:apply-templates select="/*/info/collective-name"/>
			<xsl:apply-templates select="/*/info/competing-interests"/>

			<xsl:apply-templates select="/*/abstract"/>
			<xsl:apply-templates select="/*/key-point-list"/>
			<xsl:apply-templates select="/*/background"/>

			<xsl:apply-templates select="/*/question-list"/>
			<xsl:apply-templates select="/*/info/footnote"/>
			<xsl:apply-templates select="/*/info/covered-elsewhere"/>
			
			<xsl:apply-templates select="/*/serna-xi-includes"/>

		</xsl:element>
	</xsl:template>

	<xsl:template name="process-person-group">
		<xsl:element name="person-group">
			<xsl:element name="person">
				<xsl:element name="given-names">
					<!--<xsl:apply-templates select="node()"/>-->
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="abstract">
		<xsl:element name="section">
			<xsl:variable name="name" select="name()"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="ce:eon" select="$name"/>
			<xsl:attribute name="id" select="$name"/>
			<xsl:element name="title">
				<xsl:value-of select="$glue-text//element()[name()=$name][contains(@lang, $lang)]"/>
			</xsl:element>
			
			<xsl:for-each select="element()">
				<xsl:element name="section">
					<xsl:variable name="name" select="name()"/>
					<xsl:attribute name="class" select="$name"/>
					<xsl:attribute name="ce:eon" select="$name"/>
					<!--<xsl:attribute name="id" select="$name"/>-->
					<xsl:element name="title">
						<xsl:value-of select="$glue-text//element()[name()=concat('abstract-', $name)][contains(@lang, $lang)]"/>
					</xsl:element>
					<xsl:element name="p">
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
			
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="background">
		<xsl:element name="section">
			<xsl:variable name="name" select="name()"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="ce:eon" select="$name"/>
			<xsl:attribute name="id" select="$name"/>
			<xsl:element name="title">
				<xsl:value-of select="$glue-text//element()[name()=$name][contains(@lang, $lang)]"/>
			</xsl:element>
			
			<xsl:for-each select="element()[string-length(.)!=0]">
				<xsl:element name="section">
					<xsl:variable name="name" select="name()"/>
					<xsl:attribute name="class" select="$name"/>
					<xsl:attribute name="ce:eon" select="$name"/>
					<!--<xsl:attribute name="id" select="$name"/>-->
					<xsl:element name="title">
						<xsl:value-of select="$glue-text//element()[name()=$name][contains(@lang, $lang)]"/>
					</xsl:element>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="key-point-list | question-list">
		<xsl:element name="section">
			<xsl:variable name="name" select="name()"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="ce:eon" select="$name"/>
			<xsl:attribute name="id" select="$name"/>
			<xsl:element name="title">
				<xsl:value-of select="$glue-text//element()[name()=$name][contains(@lang, $lang)]"/>
			</xsl:element>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="collective-name | competing-interests | footnote | covered-elsewhere">
		<xsl:element name="section">
			<xsl:variable name="name" select="name()"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="ce:eon" select="$name"/>
			<!--<xsl:attribute name="id" select="$name"/>-->
			<xsl:element name="title">
				<xsl:value-of select="$glue-text//element()[name()=$name][contains(@lang, $lang)]"/>
			</xsl:element>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	
	
	<xsl:template match="question">
		<xsl:element name="section">
			<xsl:variable name="name" select="name()"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="ce:eon" select="$name"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="intervention-set">
		<xsl:element name="section">
			<xsl:variable name="name" select="name()"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="ce:eon" select="$name"/>
			<!--<xsl:attribute name="id" select="$name"/>-->
			<!--<xsl:element name="title">
				<xsl:value-of select="$glue-text//element()[name()=$name][contains(@lang, $lang)]"/>
				</xsl:element>-->
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="intervention">
		<xsl:element name="section">
			<xsl:variable name="name" select="name()"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="ce:eon" select="$name"/>
			<!--<xsl:attribute name="id" select="$name"/>-->
			
			<xsl:element name="metadata">
				<xsl:element name="key">
					<xsl:attribute name="ce:name">efficacy</xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="./@efficacy"/></xsl:attribute>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="title">
				<xsl:value-of select="$glue-text//element()[name()=$name][contains(@lang, $lang)]"/>
			</xsl:element>
			<xsl:element name="p">
				<xsl:apply-templates select="summary-statement/node()"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="summary-statement">
		<xsl:element name="section">
			<xsl:variable name="name" select="name()"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="ce:eon" select="$name"/>
			<!--<xsl:attribute name="id" select="$name"/>-->
			<xsl:element name="title">
				<xsl:value-of select="$glue-text//element()[name()=$name][contains(@lang, $lang)]"/>
			</xsl:element>
			<xsl:element name="p">
				<xsl:apply-templates select="node()"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="benefits | harms | comment">
		<xsl:element name="section">
			<xsl:variable name="name" select="name()"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="ce:eon" select="$name"/>
			<!--<xsl:attribute name="id" select="$name"/>-->
			<xsl:element name="title">
				<xsl:value-of select="$glue-text//element()[name()=$name][contains(@lang, $lang)]"/>
			</xsl:element>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="substantive-change-set">
		<xsl:element name="section">
			<xsl:variable name="name" select="name()"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="ce:eon" select="$name"/>
			<!--<xsl:attribute name="id" select="$name"/>-->
			<xsl:element name="title">
				<xsl:value-of select="$glue-text//element()[name()=$name][contains(@lang, $lang)]"/>
			</xsl:element>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="substantive-change">
		<xsl:element name="section">
			<xsl:variable name="name" select="name()"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="ce:eon" select="$name"/>
			<!--<xsl:attribute name="id" select="$name"/>-->
			
			<xsl:element name="metadata">
				<xsl:element name="key">
					<xsl:attribute name="ce:name">status</xsl:attribute>
					<xsl:attribute name="value" select="@status"/>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="p">
				<xsl:apply-templates select="node()"/>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="definition" mode="inside-gloss" priority="2">
		<definition>
			<xsl:apply-templates mode="inside-gloss"/>
		</definition>
	</xsl:template>
	
	<xsl:template match="strong">
		<xsl:element name="b">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="em">
		<xsl:element name="i">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="table-link">
		<xsl:element name="link">
			<xsl:variable name="name" select=" substring-before(name(), '-')"/>
			<xsl:attribute name="type" select="$name"/>
			<xsl:attribute name="ce:eon" select="name()"/>
			<xsl:attribute name="target" select="@target"/>
			<xsl:apply-templates/>
			<!-- copy the whole references document into here -->
			<xsl:apply-templates select="document(@target, .)" mode="inside-table"/>
		</xsl:element>
	</xsl:template>	
	<xsl:template match="table-link" mode="inside-table">
		<xsl:element name="link">
			<xsl:variable name="name" select=" substring-before(name(), '-')"/>
			<xsl:attribute name="type" select="$name"/>
			<xsl:attribute name="ce:eon" select="name()"/>
			<xsl:attribute name="target" select="@target"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>	
	
	<xsl:template match="figure-link">
		<xsl:element name="link">
			<xsl:variable name="name" select=" substring-before(name(), '-')"/>
			<xsl:attribute name="type" select="$name"/>
			<xsl:attribute name="ce:eon" select="name()"/>
			<xsl:attribute name="target" select="@target"/>
			<xsl:apply-templates/>
			<!-- copy the whole references document into here -->
			<xsl:apply-templates select="document(@target, .)" mode="inside-figure"/>
		</xsl:element>
	</xsl:template>	
	<xsl:template match="figure-link" mode="inside-figure">
		<xsl:element name="link">
			<xsl:variable name="name" select=" substring-before(name(), '-')"/>
			<xsl:attribute name="type" select="$name"/>
			<xsl:attribute name="ce:eon" select="name()"/>
			<xsl:attribute name="target" select="@target"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>	
	
	<xsl:template match="gloss-link" mode="inside-gloss" priority="2">
		<xsl:element name="link">
			<xsl:variable name="name" select=" substring-before(name(), '-')"/>
			<xsl:attribute name="type" select="$name"/>
			<xsl:attribute name="ce:eon" select="name()"/>
			<xsl:attribute name="target" select="@target"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>	
	<xsl:template match="gloss-link" priority="1">
		<xsl:element name="link">
			<xsl:variable name="name" select=" substring-before(name(), '-')"/>
			<xsl:attribute name="type" select="$name"/>
			<xsl:attribute name="ce:eon" select="name()"/>
			<xsl:attribute name="target" select="@target"/>
			<xsl:apply-templates/>
			<xsl:apply-templates select="document(@target, .)" mode="inside-gloss"/>
		</xsl:element>
	</xsl:template>	
	
	<xsl:template match="person-link | uri-link">
		<xsl:element name="link">
			<xsl:variable name="name" select=" substring-before(name(), '-')"/>
			<xsl:attribute name="type" select="$name"/>
			<xsl:attribute name="ce:eon" select="name()"/>
			<xsl:attribute name="target" select="@target"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>	

	<xsl:template match="option-link"  priority="1">
		<xsl:comment>option link <xsl:value-of select="@target"/></xsl:comment>
		<xsl:choose>
			<xsl:when test="starts-with(@target, '../options/')">
				<xsl:variable name="opt-file" select="document(@target, .)" />
				<xsl:element name="link">
					<xsl:attribute name="type">option</xsl:attribute>
					<xsl:attribute name="target" select="@target"/>
					<xsl:attribute name="optid" select="substring-after($opt-file/option/@id, '_')"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="target-file" select="concat('../options/', @target)"/>
				<xsl:variable name="opt-file" select="document($target-file, .)" />
				<xsl:element name="link">
 					<xsl:attribute name="type">option</xsl:attribute>
					<xsl:attribute name="target" select="$target-file"/>
					<xsl:attribute name="optid" select="substring-after($opt-file/option/@id, '_')"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	

	<xsl:template match="systematic-review-link">
		<!-- If target is empty do not include the link -->
		<xsl:choose>
			<xsl:when test="not(@target='')">
				<xsl:element name="link">
					<xsl:variable name="srfileid">
						<xsl:call-template name="substring-after-last">
							<xsl:with-param name="string" select="@target"/>
							<xsl:with-param name="delimiter">/</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					<xsl:attribute name="target">
						<xsl:value-of select="$srfileid"/>
						<xsl:text>#xpointer(id('</xsl:text>
						<xsl:value-of select="@xpointer"/>
						<xsl:text>'))</xsl:text>
					</xsl:attribute>
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

	<xsl:template match="reference-link" mode="inside-gloss" priority="2">
		<xsl:element name="link">
			<xsl:variable name="name" select=" substring-before(name(), '-')"/>
			<xsl:attribute name="type" select="$name"/>
			<xsl:attribute name="ce:eon" select="name()"/>
			<xsl:attribute name="target" select="@target"/>
			<xsl:apply-templates/>
			<!-- copy the whole references document into here -->
			<xsl:apply-templates select="document(@target, .)" mode="inside-reference"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="reference-link" mode="inside-table" priority="3">
		<xsl:element name="link">
			<xsl:variable name="name" select=" substring-before(name(), '-')"/>
			<xsl:attribute name="type" select="$name"/>
			<xsl:attribute name="ce:eon" select="name()"/>
			<xsl:attribute name="target" select="@target"/>
			<xsl:apply-templates/>
			<!-- copy the whole references document into here -->
			<xsl:apply-templates select="document(@target, .)" mode="inside-reference"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="reference-link" mode="inside-reference" priority="4">
		<xsl:element name="link">
			<xsl:variable name="name" select=" substring-before(name(), '-')"/>
			<xsl:attribute name="type" select="$name"/>
			<xsl:attribute name="ce:eon" select="name()"/>
			<xsl:attribute name="target" select="@target"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="reference-link">
		<xsl:element name="link">
			<xsl:variable name="name" select=" substring-before(name(), '-')"/>
			<xsl:attribute name="type" select="$name"/>
			<xsl:attribute name="ce:eon" select="name()"/>
			<xsl:attribute name="target" select="@target"/>
			<xsl:apply-templates/>
			<!-- copy the whole references document into here -->
			<xsl:apply-templates select="document(@target, .)" mode="inside-reference"/>
		</xsl:element>
	</xsl:template>	

	<xsl:template match="substantive-change-marker">
		<xsl:apply-templates/>
	</xsl:template>	
	
	<xsl:template match="th">
		<xsl:element name="td">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="p">
		<xsl:choose>
			<!-- if the first child is a text node, open a p tag -->
			<xsl:when test="not(name(node()[1])) and normalize-space(node()[1]) != ''">
				<xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
				<!-- open p1 -->
			</xsl:when>

			<!-- if the first child isn't a list or a heading, open a p tag -->
			<xsl:when test="not(name(child::*[1]) = 'list') and 
				not(name(child::*[1]) = 'heading1') and 
				not(name(child::*[1]) = 'heading2') and 
				not(name(child::*[1]) = 'table')">
				<!-- yes: open the p tag -->
				<xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
				<!-- open p2 -->
			</xsl:when>
		</xsl:choose>
		
		<xsl:apply-templates select="node()" mode="para1"/>
		
		<!-- if the last element is a list, we don't need to close the p tag -->
		<xsl:choose>
			<xsl:when test="not(name(node()[last()])) and normalize-space(node()[last()]) != ''">
				<xsl:text disable-output-escaping="yes">&lt;/p&gt;&#13;</xsl:text>
				<!-- close p1 -->
			</xsl:when>

			<!-- if the last child isn't a list, close a p tag -->
			<xsl:when test="not(name(child::*[last()]) = 'list') and 
				not(name(child::*[last()]) = 'heading1') and 
				not(name(child::*[last()]) = 'heading2') and
				not(name(child::*[last()]) = 'table')">
				<!-- yes: close the p tag -->
				<xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
				<!-- close p2 -->
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	

	<!-- go through every node before us
		if any of them are element nodes, or non-empty text nodes we need to 
		close the previous p-tag
	-->
	<xsl:template name="close-p-tags">
		<xsl:param name="node-set"/>
		
		<xsl:choose>
			<xsl:when test="name($node-set[last()])">
				<!-- it's an element, output the p tag and don't go any further back -->
				<xsl:text disable-output-escaping="yes">&lt;/p&gt;&#13;</xsl:text>
				<xsl:if test="$debug='true'">
				<xsl:comment>close p2</xsl:comment>
				</xsl:if>
			</xsl:when>
			
			<xsl:otherwise>
				<!-- it's a text node -->
				
				<!--xsl:comment>
					<xsl:text>prior text node is </xsl:text>
					<xsl:value-of select="$node-set[last()]"/>
					</xsl:comment-->
				
				<xsl:choose>
					<xsl:when test="normalize-space($node-set[last()]) != ''">
						<xsl:text disable-output-escaping="yes">&lt;/p&gt;&#13;</xsl:text>
						<xsl:if test="$debug='true'">
						<xsl:comment>close p3</xsl:comment>
						</xsl:if>
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:if test="$node-set/preceding-sibling::node()">
							<!--
								<xsl:comment>would recurse with <xsl:value-of select="$node-set/preceding-sibling::node()"></xsl:value-of></xsl:comment>
							-->
							
							<xsl:call-template name="close-p-tags">
								<xsl:with-param name="node-set" select="$node-set/preceding-sibling::node()"/>
							</xsl:call-template>
						</xsl:if>
						
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	<!-- wrap lists in p tags -->
	
	
	
	<!-- go through every node before us
		if any of them are element nodes, or non-empty text nodes we need to 
		close the previous p-tag
	-->
	<xsl:template name="open-p-tags">
		<xsl:param name="node-set"/>
		
		<xsl:choose>
			<xsl:when test="name($node-set[1])">
				<!-- it's an element, output the p tag and don't go any further forward -->
				<xsl:text disable-output-escaping="yes">&lt;p&gt;&#13;</xsl:text>
				<xsl:if test="$debug='true'">
				<xsl:comment>open p2</xsl:comment>
				</xsl:if>
			</xsl:when>
			
			<xsl:otherwise>
				<!-- it's a text node -->
				
				<!--xsl:comment>
					<xsl:text>prior text node is </xsl:text>
					<xsl:value-of select="$node-set[last()]"/>
					</xsl:comment-->
				
				<xsl:choose>
					<xsl:when test="normalize-space($node-set[1]) != ''">
						<xsl:text disable-output-escaping="yes">&lt;p&gt;&#13;</xsl:text>
						<xsl:if test="$debug='true'">
						<xsl:comment>open p3</xsl:comment>
						</xsl:if>
					</xsl:when>
					
					<xsl:otherwise>
						<xsl:if test="$node-set/following-sibling::node()">
							<!--
								<xsl:comment>would recurse with <xsl:value-of select="$node-set/preceding-sibling::node()"></xsl:value-of></xsl:comment>
							-->
							
							<xsl:call-template name="open-p-tags">
								<xsl:with-param name="node-set" select="$node-set/following-sibling::node()"/>
							</xsl:call-template>
						</xsl:if>
						
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="ul">
		<xsl:element name="list">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="item">
		<xsl:element name="li">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="serna-xi-includes">
		<xsl:apply-templates select="xi:include"/>
	</xsl:template>

	<xsl:template match="xi:include">
		
		<xsl:if test="$debug='true'">
			<xsl:comment>
				<xsl:text>xi:include </xsl:text>
				<xsl:value-of select="@href"/>
			</xsl:comment>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="contains(@href,'tables')">
				<xsl:if test="$debug='true'">
					<xsl:comment>table link <xsl:value-of select="@target"/></xsl:comment>
				</xsl:if>
				<!--xsl:apply-templates select="document(@href, .)/*[1]"/-->
			</xsl:when>
			<xsl:when test="contains(@href,'figures')">
				<xsl:if test="$debug='true'">
					<xsl:comment>figures link <xsl:value-of select="@target"/></xsl:comment>
				</xsl:if>
				<!--xsl:apply-templates select="document(@href, .)/*[1]"/-->
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$debug='true'">
					<xsl:comment>option link <xsl:value-of select="@target"/></xsl:comment>
				</xsl:if>
				<xsl:variable name="opt-file" select="document(@href, .)" />

				<xsl:variable name="fileid">
					<xsl:choose>
						<xsl:when test="contains(@href,'-')">
							<xsl:call-template name="substring-after-last">
								<xsl:with-param name="string" select="@href"/>
								<xsl:with-param name="delimiter">-</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="substring-after-last">
								<xsl:with-param name="string" select="@href"/>
								<xsl:with-param name="delimiter">_</xsl:with-param>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
			
				<!-- 
					two formats of option link
					<option-link xpointer="option" target="../options/_op1508_I6.xml">
					<option-link xpointer="option" target="../options/option-1177063210233.xml">
				-->
				<xsl:element name="section">
					<xsl:variable name="name" select="'option'"/>
					<xsl:attribute name="class" select="$name"/>
					<xsl:attribute name="ce:eon" select="$name"/>
					<xsl:attribute name="id" select="substring-before($fileid,'.xml')"/>
					<xsl:apply-templates select="$opt-file/option/node()"/>
				</xsl:element>
			
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="$debug='true'">
			<xsl:comment>end xi:include</xsl:comment>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="abridged-title"/>
	
	<xsl:template match="pi-comment"/>
	
	<!-- match any other element, writing it out and calling apply-templates for any children -->
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

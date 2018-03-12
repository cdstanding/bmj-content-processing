<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://schema.bmj.com/delivery/oak"
	xmlns:ce="http://schema.bmj.com/delivery/oak-ce"
	xmlns:tr="http://schema.bmj.com/delivery/oak-tr">
	
	<xsl:template name="process-table">
		<xsl:param name="target"/>
		
		<xsl:variable name="filename" select="concat(translate($systematic-review-xml-input, '\\', '/'), substring-after($target, '../'))"/>
		<xsl:variable name="table" select="document($filename)/*"/>
		
		<xsl:element name="table">
			<xsl:attribute name="id" select="concat($id-lead-text, $cid, '-t', position())"/>
			<xsl:if test="$table//table/@grade='true' or contains($table//caption, 'GRADE')">
				<xsl:attribute name="class">grade-table</xsl:attribute>	
			</xsl:if>
			
			<xsl:element name="caption">
				
				<xsl:element name="p">
					
					<xsl:element name="inline">
						<xsl:attribute name="class">label</xsl:attribute>
						<xsl:text>Table</xsl:text>
						<xsl:choose>
							<xsl:when test="$table//table/@grade='true' or contains($table//caption, 'GRADE')">
								<!-- do nothing -->
							</xsl:when>
							<xsl:otherwise>
								<xsl:text disable-output-escaping="yes"> </xsl:text>
								<xsl:value-of select="position()"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text disable-output-escaping="yes"> </xsl:text>
					</xsl:element>
					
					<xsl:apply-templates select="$table//caption/node()"/>
					
				</xsl:element>
				
			</xsl:element>
				
			<xsl:for-each select="$table//(thead|tbody)">
				<xsl:element name="{name()}">
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="tr">
		
		<xsl:choose>
			
			<xsl:when test="count(.//*:th | *:td) = 0">
				<xsl:comment>empty row removed</xsl:comment>
			</xsl:when>
			
			<xsl:otherwise>
				
				<xsl:element name="tr">
					
					<xsl:for-each select="th|td">
						
						<xsl:element name="td">
							<xsl:if test="@align[string-length(.)!=0]">
								<xsl:attribute name="align" select="translate(@align, $upper, $lower)"/>
							</xsl:if>
							<xsl:if test="@colspan[string-length(.)!=0]">
								<xsl:attribute name="colspan" select="@colspan"/>
							</xsl:if>
							
							<xsl:apply-templates/>
							
						</xsl:element>
						
					</xsl:for-each>
					
				</xsl:element>
				
			</xsl:otherwise>
			
		</xsl:choose>
		
		
	</xsl:template>
	
	<!--default oak templates-->
	<xsl:template match="*" mode="abstract">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="abstract">
			<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>-->
			
			<!--FIX: add test if exisits in glue-text-->
			<!--<xsl:element name="title">
				<xsl:value-of select="$glue-text//element()[name()=$name][contains(@lang, $lang)]"/>
			</xsl:element>-->
			
			<xsl:apply-templates/>
			
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="*" mode="section">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			<xsl:if test="@id">
				<xsl:attribute name="id" select="concat($id-lead-text, name())"/>
			</xsl:if>
			
			<!--FIX: add test if exisits in glue-text-->
			<xsl:element name="title">
				<xsl:value-of select="$glue-text//element()[name()=$name][contains(@lang, $lang)]"/>
			</xsl:element>
				
			<xsl:choose>
				
				<xsl:when test="p">
					<xsl:apply-templates/>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:element name="p">
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:otherwise>
				
			</xsl:choose>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="*" mode="section-list">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			<xsl:if test="@id">
				<xsl:attribute name="id" select="concat($id-lead-text, name())"/>
			</xsl:if>
			
			<xsl:element name="title">
				<!--<xsl:value-of select="$glue-text//element()[name()=$name][contains(@lang, $lang)]"/>-->
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:choose>
				
				<xsl:when test="p">
					<xsl:element name="list">
						<xsl:for-each select="p">
							<xsl:element name="li">
								<xsl:apply-templates select="node()"/>		
							</xsl:element>	
						</xsl:for-each>
					</xsl:element>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:element name="list">
						<xsl:element name="li">
							<xsl:apply-templates/>		
						</xsl:element>
					</xsl:element>
				</xsl:otherwise>
				
			</xsl:choose>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="*" mode="summary">
		<xsl:element name="summary">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>
			
			<xsl:apply-templates select="."/>
			
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="*" mode="title">
		<xsl:element name="title">
			<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="name()"/>-->
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="process-abridged-title-escaped-markup">
		<xsl:param name="abridged-title" />
		<xsl:for-each select="$abridged-title/node()">
			<xsl:choose>
				<xsl:when test="self::element()">
					<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
					<xsl:value-of select="name()" />
					<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
					<xsl:value-of select="." />
					<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
					<xsl:value-of select="name()" />
					<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="." />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	
	<!--blocks-->
	<xsl:template match="p" mode="para-title">
		<xsl:element name="section">
			<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="'block'"/>-->
			<xsl:attribute name="class" select="string('section')"/>
			<xsl:element name="title">
				<xsl:apply-templates select="strong[1]/node()"/>
				<!--<xsl:value-of select="
					replace(
					normalize-space(strong),
					'^(.+):?$$',
					'$1')
					"/>-->
			</xsl:element>
			<xsl:if test="strong[1]/following-sibling::node()[string-length(normalize-space(.))!=0]">
				<xsl:comment>forcing sibling nodes of strong withought own para to new para markup</xsl:comment>
				<xsl:element name="p">
					<xsl:apply-templates select="strong[1]/following-sibling::node()"/>
				</xsl:element>
			</xsl:if>
			<!--<xsl:key name="para" match="p[not(strong)]" use="generate-id((preceding-sibling::p[strong])[last()])" />-->
			<xsl:apply-templates select="key('para',generate-id())" mode="para"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="p" mode="para">
		<xsl:element name="{name()}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="p[strong]">
		<xsl:element name="title">
			<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="'strong'"/>
			<xsl:attribute name="class" select="'strong'"/>-->
			<xsl:apply-templates select="strong[1]/node()"/>
		</xsl:element>
		<xsl:if test="strong[1]/following-sibling::node()[string-length(normalize-space(.))!=0]">
			<xsl:comment>forcing sibling nodes of strong withought own para to new para markup</xsl:comment>
			<xsl:for-each select="strong[1]/following-sibling::node()">
				<xsl:choose>
					<xsl:when test="self::*[name()='strong']">
						<xsl:element name="title">
							<xsl:apply-templates select="."/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="p">
							<xsl:apply-templates select="strong[1]/following-sibling::node()"/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="p">
		<xsl:element name="{name()}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="ul">
		<xsl:element name="list">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="li">
		<xsl:element name="li">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	
	<!--links-->
	<xsl:template 
		match="
		option-link[contains(@target, 'MISSING_LINK') or string-length(@target)=0] | 
		gloss-link[contains(@target, 'MISSING_LINK') or string-length(@target)=0] |
		figure-link[contains(@target, 'MISSING_LINK') or string-length(@target)=0] |
		table-link[contains(@target, 'MISSING_LINK') or string-length(@target)=0] |
		reference-link[contains(@target, 'MISSING_LINK') or string-length(@target)=0]
		">
		<xsl:if test="self::element()[string-length(normalize-space(.))!=0]">
			<xsl:apply-templates />	
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="table-link | figure-link | gloss-link | reference-link">
		
		<xsl:element name="link">
			
			<xsl:variable name="name" select=" substring-before(name(), '-')"/>
			<xsl:variable name="target" select="@target"/>
			
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="$name"/>
			
			<xsl:for-each select="$links//*[name()=concat($name, '-link')]">
				
				<xsl:if test="@target=$target">
					
					<xsl:choose>
						
						<xsl:when test="$name='table'">
							<xsl:attribute name="target">
								<xsl:text>#xpointer(id('</xsl:text>
								<xsl:value-of select="concat($id-lead-text, $cid, '-t', position())"/>
								<xsl:text>'))</xsl:text>
							</xsl:attribute>
						</xsl:when>
						
						<xsl:when test="$name='figure'">
							<xsl:attribute name="target">
								<xsl:text>#xpointer(id('</xsl:text>
								<xsl:value-of select="concat($id-lead-text, $cid, '-f', position())"/>
								<xsl:text>'))</xsl:text>
							</xsl:attribute>
						</xsl:when>
						
						<xsl:when test="$name='gloss'">
							<xsl:attribute name="target">
								<xsl:text>#xpointer(id('</xsl:text>
								<xsl:value-of select="concat($id-lead-text, $cid, '-g', position())"/>
								<xsl:text>'))</xsl:text>
							</xsl:attribute>
						</xsl:when>
						
						<xsl:when test="$name='reference'">
							<xsl:attribute name="target">
								<xsl:text>#xpointer(id('</xsl:text>
								<xsl:value-of select="concat($id-lead-text, $cid, '-ref', position())"/>
								<xsl:text>'))</xsl:text>
							</xsl:attribute>
						</xsl:when>
						
					</xsl:choose>
					
				</xsl:if>
				
			</xsl:for-each>
			
			<xsl:if test="$name != 'reference'">
				<xsl:apply-templates/>	
			</xsl:if>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="option-link">
		
		<!--<xsl:variable name="iid" select="concat($cid, '_', substring-after(substring-after(substring-before(@target, '.xml'), '_op'), '_'))"/>-->
		<!-- chpping '../options/_op1003_I1.xml' or 
		'../options/option-1179218159900_en-gb.xml' to get option id -->
		
		<xsl:variable name="name" select=" substring-before(name(), '-')"/>
		<xsl:variable 
			name="iid" 
			select="
			concat($cid, '-i', 
			replace(@target, '^.*?[I\-](\d+).*?$', '$1'))
			"/>

		<xsl:element name="link">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="target">
				<xsl:text>#xpointer(id('</xsl:text>
				<xsl:value-of select="concat($id-lead-text, $iid)"/>
				<xsl:if test="string-length(normalize-space(@xpointer))!=0 and @xpointer!='option'">
					<xsl:value-of select="concat('-', @xpointer)"/>
				</xsl:if>
				<xsl:text>'))</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="systematic-review-link">
		<xsl:element name="link">
			<xsl:variable name="srfileid">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="string" select="@target"/>
					<xsl:with-param name="delimiter">/</xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:attribute name="class" select="string('systematic-review-link')"/>
			<xsl:attribute name="target">
				<xsl:value-of select="$srfileid"/>
				<xsl:text>#xpointer(id('</xsl:text>
				<xsl:value-of select="@xpointer"/>
				<xsl:text>'))</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="uri-link">
		
		<xsl:variable name="name" select="substring-before(name(), '-')"/>
		<xsl:variable name="target" select="normalize-space(@target)"/>
		<xsl:variable name="display" select="normalize-space(.)"/>
		
		<xsl:variable name="url">
			<xsl:choose>
				
				<xsl:when test="string-length($target)!=0">
					<xsl:choose>
						<xsl:when test="starts-with($target, 'www')">
							<xsl:text>http://</xsl:text>
							<xsl:value-of select="$target"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$target"/>
						</xsl:otherwise>
					</xsl:choose>	
				</xsl:when>
				
				<xsl:when test="
					string-length($target)=0 
					and (contains($display, 'www') 
						or contains($display, 'http'))
					">
					<xsl:choose>
						<xsl:when test="starts-with($display, 'www')">
							<xsl:text>http://</xsl:text>
							<xsl:value-of select="$display"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$display"/>
						</xsl:otherwise>
					</xsl:choose>	
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:text>MISSING_LINK</xsl:text>
				</xsl:otherwise>
				
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$url!='MISSING_LINK'">
				<xsl:element name="link">
					<xsl:attribute name="{concat($xmlns, ':oen')}" select="name()"/>
					<xsl:attribute name="class" select="'uri-link'"/>
					<xsl:attribute name="target" select="$url"/>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<!--inline-->
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
	
	<xsl:template match="sub | sup | br">
		<xsl:element name="{name()}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="substantive-change-marker">
		<!--do nothing-->
	</xsl:template>

</xsl:stylesheet>
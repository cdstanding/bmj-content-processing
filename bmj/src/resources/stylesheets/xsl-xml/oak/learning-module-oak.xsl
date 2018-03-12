<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns="http://schema.bmj.com/delivery/oak" 
	xmlns:lm="http://schema.bmj.com/delivery/oak-lm" 
	xmlns:xi="http://www.w3.org/2001/XInclude" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xlink="http://www.w3.org/1999/xlink">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="lang"/>
	<xsl:param name="xmlns"/>
	<xsl:param name="strings-variant-fileset"/>
	
	<xsl:param name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝ'"/>
	<xsl:param name="lower" select="'abcdefghijklmnopqrstuvwxyzáâãäåæçèéêëìíîïðñòóôõöøùúûüý'"/>

	<xsl:param name="number" select="'123456789'"/>
	<xsl:param name="alpha" select="'abcdefghi'"/>
	
	<xsl:include href="../../xsl-lib/strings/process-strings-variant-shared.xsl"/>
	
	<xsl:template match="/learning-module">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:namespace name="lm">http://schema.bmj.com/delivery/oak-lm</xsl:namespace>
			<xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
			<xsl:attribute name="xsi:schemaLocation">http://schema.bmj.com/delivery/oak http://schema.bmj.com/delivery/oak/bmj-oak-strict.xsd</xsl:attribute>
			<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
			<xsl:attribute name="class" select="$name"/>
			<xsl:attribute name="id" select="concat('_', @id)"/>
			<!--<xsl:attribute name="xml:lang" select="$lang"/>-->
			
			<xsl:element name="title">
				<!--<xsl:value-of select="/learning-module/metadata/key[@name='module-title']/@value"/>-->
				<xsl:value-of select="title/node()"/>
			</xsl:element>
			
			<xsl:element name="p">
				<xsl:value-of select="description/node()"/>
			</xsl:element>
			
			<xsl:apply-templates select="homepage-image/img" />
			<xsl:apply-templates select="partner-logos" />
											
			<xsl:element name="metadata">
				
				<xsl:for-each select="@id | @provider | @module-type "><!--@status-->
					<xsl:variable name="name" select="name()"/>
					
					<xsl:element name="key">
						<xsl:attribute name="name" select="$name" />
						<xsl:attribute name="value" select="." />
					</xsl:element>
				</xsl:for-each>
				
				<xsl:apply-templates select="metadata"/>				
				
			</xsl:element>
			
			<xsl:apply-templates select="notes[p[1][string-length(normalize-space(.))!=0]]"/>
			
			<xsl:element name="section">
				<xsl:attribute name="class" select="string('authors')"/>
				
				<xsl:element name="title">
					<xsl:call-template name="process-string-variant">
						<xsl:with-param name="name" select="string('authors')"/>
					</xsl:call-template>
				</xsl:element>
				
				<!-- the following apply template is  redundant and only kept incase there is the odd module that is not uptodate-->
				<xsl:apply-templates select="author | document(xi:include/@href)/author"/>
				
				<!-- Contributors heading -->
				<xsl:element name="title">
					<xsl:text>Contributors</xsl:text> 
				</xsl:element>
				
				<xsl:apply-templates select="//contributor"/>				
				
			</xsl:element>
			
			
			<xsl:apply-templates select="html-screen | question-set | article-references"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="contributor">	  
		<xsl:element name="title">
			<xsl:value-of select="title"/>
			<xsl:text> </xsl:text>
		    <xsl:value-of select="name"/>
	  	</xsl:element>
	  	
	  	<xsl:for-each select="description"> 
		  	<p><xsl:apply-templates select="*"/></p>
	  	</xsl:for-each>	
	  	
	  	<xsl:for-each select="disclosure">
		  	<p><xsl:apply-templates select="*"/></p>
		</xsl:for-each>
	  		
	</xsl:template>
	
	
	<xsl:template match="homepage-image/img">
		<xsl:element name="homepage-image">
			<xsl:element name="figure">
				<xsl:attribute name="image" select="@src"/>
			</xsl:element>
		</xsl:element>		
	</xsl:template>
	
	<xsl:template match="partner-logos">
		<xsl:element name="p">
			<xsl:value-of select="local-name(.)"/>
		</xsl:element>
		<xsl:for-each select="partner-logo">
			<xsl:apply-templates />
		</xsl:for-each>
	</xsl:template>	
	
	<xsl:template match="logo-text">
		<xsl:element name="logo-text">
			<xsl:value-of select="local-name(.)"/>
		</xsl:element>
		
		<xsl:apply-templates />
	</xsl:template>	
	
	<xsl:template match="logo-image">
		<xsl:element name="logo-image">
			<xsl:value-of select="local-name(.)"/>
		</xsl:element>
		
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="objectives | contributors | faculty-disclosure"/>
	
	<xsl:template match="notes">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			
			<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:apply-templates select="p"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="author">
		<xsl:variable name="name" select="name()"/>
		
		<!-- todo: not able to squeeze learning-module to oak person-group data at this time -->
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:variable name="class" select="name()"/>
			
			<!--<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name" />
				</xsl:call-template>
			</xsl:element>-->
			
			<xsl:apply-templates select="name | bio" mode="author" />
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="name" mode="author">
		<xsl:variable name="name" select="name()" />
		
		<xsl:element name="p">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:variable name="class" select="concat('author-', name())"/>
			
			<xsl:element name="strong">
				<xsl:apply-templates />
			</xsl:element>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="bio" mode="author">
		<xsl:variable name="name" select="name()" />
		
		<xsl:element name="p">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:variable name="class" select="concat('author-', name())"/>
			
			<xsl:apply-templates />
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="html-screen">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			
			<xsl:element name="title">
				
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
				
				<xsl:text> (</xsl:text>
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="string('section')"/>
				</xsl:call-template>
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:value-of select="count(preceding-sibling::*[self::html-screen or self::question-set]) +1"/>
				<xsl:text> of </xsl:text>
				<xsl:value-of select="count(//html-screen | //question-set)"/>
				<xsl:text>)</xsl:text>
			</xsl:element>
			
			<xsl:apply-templates select="main-html/node()"/>
			<xsl:apply-templates select="reference-html"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<!-- normal question-set -->
	<xsl:template match="question-set">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			
			<xsl:element name="title">
				
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
				
				<!-- todo: question-set position -->
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:number/>
				
				<xsl:text disable-output-escaping="yes"> (</xsl:text>
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="string('section')"/>
				</xsl:call-template>
				<xsl:text disable-output-escaping="yes"> </xsl:text>
				<xsl:value-of select="count(preceding-sibling::*[self::html-screen or self::question-set]) +1"/>
				<xsl:text> of </xsl:text>
				<xsl:value-of select="count(//html-screen | //question-set)"/>
				<xsl:text>)</xsl:text>
				
			</xsl:element>
			
			<xsl:element name="metadata">
				
				<xsl:for-each select="@answer-type | @test-type | @show-test-results | @scorable | @pass-mark">
					<xsl:variable name="name" select="name()"/>
					
					<xsl:element name="key">
						<xsl:attribute name="name" select="$name" />
						<xsl:attribute name="value" select="." />
					</xsl:element>
					
				</xsl:for-each>
				
			</xsl:element>
			
			<xsl:apply-templates select="question|question-dropdown-group"/>
			
		</xsl:element>
		
	</xsl:template>
	
	
	
	<xsl:template match="question">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			
			<xsl:element name="title">
				
				<xsl:value-of select="position()"/>
				<xsl:text disable-output-escaping="yes">. </xsl:text>
				
				<xsl:apply-templates select="question-text"/>
			
			</xsl:element>
			
			<xsl:apply-templates select="answer"/>					
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="question-text">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	<xsl:template match="question-dropdown-group">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			
			<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:apply-templates select="question-group-text" />
			<xsl:apply-templates select="question-group-option-list" />
			<xsl:apply-templates select="question" />
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="question-group-option-list">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			
			<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
			</xsl:element>
			
			<xsl:apply-templates select="parent::*/text-preceding-options" />
			
			<xsl:element name="list">
				<xsl:for-each select="question-group-option">
					<xsl:element name="li">
						<xsl:apply-templates select="question-group-option-text/node()" />
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
			
			<xsl:apply-templates select="parent::*/text-following-options" />
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="question-group-text|text-preceding-options|text-following-options">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="p">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			
			<xsl:apply-templates />	
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="answer">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			
			<xsl:choose>
				
				<xsl:when test="@correct">
					
					<xsl:element name="p">
						
						<xsl:element name="inline">
							<xsl:attribute name="class" select="string('alpha-list-label')" />
							
							<xsl:element name="strong">
								<xsl:value-of select="translate(string(position()), $number, $alpha)"/>
								<xsl:text>. </xsl:text>
							</xsl:element>
							
						</xsl:element>
						
						<xsl:apply-templates select="answer-text/p/node()"/>
						<xsl:apply-templates select="answer-text/text()"/>
						<xsl:apply-templates select="answer-text/i"/>
						<xsl:apply-templates select="answer-text/em"/>
						
						<xsl:if test="@correct='true'">
							
							<xsl:text disable-output-escaping="yes"> </xsl:text>
							
							<xsl:element name="inline">
								<xsl:attribute name="class" select="string('correct-answer')" />
								
								<xsl:element name="strong">
									
									<xsl:text>[</xsl:text>
									<xsl:call-template name="process-string-variant">
										<xsl:with-param name="name" select="concat('correct-', @correct)"/>
									</xsl:call-template>
									<xsl:text>]</xsl:text>
									
								</xsl:element>
								
							</xsl:element>
							
						</xsl:if>
						
					</xsl:element>
					
				</xsl:when>
				
				<xsl:when test="ancestor::question-dropdown-group/question-group-option-list != ''">
					
					<xsl:element name="p">
						<xsl:variable name="current-option-id" select="@option-id"/>
						
						<xsl:value-of select="ancestor::question-dropdown-group/question-group-option-list/question-group-option[@id=$current-option-id]/question-group-option-text//text()"/>
						
						<xsl:text disable-output-escaping="yes"> </xsl:text>
						
						<xsl:element name="inline">
							<xsl:attribute name="class" select="string('correct-answer')" />
							
							<xsl:element name="strong">
								
								<xsl:text>[</xsl:text>
								<xsl:call-template name="process-string-variant">
									<xsl:with-param name="name" select="string('correct-true')"/>
								</xsl:call-template>
								<xsl:text>]</xsl:text>
								
							</xsl:element>
							
						</xsl:element>
						
					</xsl:element>
							
				</xsl:when>
				
			</xsl:choose>
			
			<xsl:apply-templates select="correct-reason"/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="correct-reason[string-length(normalize-space(.))!=0]">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			
			<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>		
				<!--xsl:text>: </xsl:text-->
			</xsl:element>
			
			<xsl:apply-templates/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="reference-html">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="$name"/>
			
			<!--<xsl:element name="title">
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
				</xsl:call-template>
			</xsl:element>-->
			
			<xsl:apply-templates>
				<xsl:with-param name="parent-name" select="$name" />
			</xsl:apply-templates>
			
		</xsl:element>
		
	</xsl:template>
	
	<!-- Article References heading and the associated article refeerce code
	     this just coppies the elements accross to the oak xml format and leaves the
	     oak.fo to do the processing -->
	<xsl:template match="article-references">
			<xsl:element name="title">
				<xsl:text>Article References</xsl:text> 
			</xsl:element>
			<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="article-reference">
		<xsl:element name="article-reference">
			<xsl:attribute name="id" select="@id"/>
			<xsl:attribute name="type" select="@type"/>
		</xsl:element>
		<!-- do the lower level things --> 		
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="pubmed-id">
		<xsl:element name="pubmed-id">
	        <xsl:copy-of select="text()"/>
     	</xsl:element>    		
	</xsl:template>
	
	<xsl:template match="url">
		<xsl:element name="url">
	         <xsl:copy-of select="text()"/>
     	</xsl:element> 	
	</xsl:template>
	
	<xsl:template match="citation">	
	    <xsl:copy-of select="."/>     		
	</xsl:template>
	
	<xsl:template match="resource-title">
		<xsl:element name="resource-title">
	         <xsl:copy-of select="text()"/>
     	</xsl:element> 	
	</xsl:template>
	
	<xsl:template match="resource-text">
		<xsl:element name="resource-text">
	         <xsl:copy-of select="text()"/>
     	</xsl:element> 	
	</xsl:template>
	
	<xsl:template match="reference-link">
		<xsl:element name="reference-link">
	         <xsl:attribute name="id" select="@id"/>
			 <xsl:attribute name="type" select="@type"/>
     	</xsl:element> 	
	</xsl:template>
	
	<!-- Article References END -->
	
	<xsl:template match="table">
		<xsl:element name="table">
			<xsl:copy-of select="@class" />
			
			<xsl:element name="tbody">
				<xsl:apply-templates />
			</xsl:element>
			
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="tbody">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="tr|td">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@colspan|@align|@valign" />
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="div">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="@class"/>
			
			<xsl:apply-templates/>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="h1 | h2 | h3 | h4 | h5">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="title">
			<xsl:attribute name="class" select="$name"/>
			<xsl:apply-templates/>
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="p">
		<xsl:param name="parent-name" />
		<xsl:element name="{name()}">
			<xsl:apply-templates>
				<xsl:with-param name="parent-name" select="$parent-name" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="ul">
		<xsl:element name="list">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="ol">
		<xsl:param name="parent-name" />
		<xsl:choose>
			<xsl:when test="$parent-name='reference-html'">
				<xsl:element name="references">
					<xsl:for-each select="li">
						<xsl:element name="reference">
							<xsl:apply-templates/>
						</xsl:element>
					</xsl:for-each>
				</xsl:element>
			</xsl:when>
		
			<xsl:otherwise>
				<xsl:element name="list">
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="li">
		<xsl:element name="{name()}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="strong|b|bold">
		<xsl:element name="strong">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="em|i|italic|blockquote">
		<xsl:element name="em">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="sup|sub|u">
		<xsl:element name="{name()}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="a">
		<xsl:element name="link">
			<xsl:attribute name="class">url?</xsl:attribute>
			<xsl:attribute name="target" select="@href"/>
			<xsl:attribute name="newwin" select="@target"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="img">
		<!--<img src="../images/heartlogo_default.gif"/>-->
		<xsl:element name="figure">
			<xsl:attribute name="image" select="@src"/>
			
			<!--xsl:element name="caption">
				<xsl:element name="p"/>
			</xsl:element-->
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="metadata">			
               	<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="key">
		<xsl:choose>
			<xsl:when test="@name='channel-id'"></xsl:when>
			<xsl:when test="@name='bundle-id'"></xsl:when>
			<xsl:otherwise>
				<xsl:element name="{name()}">
					<xsl:copy-of select="@*" />
					<xsl:apply-templates />
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- dev output test -->
	<xsl:template match="element()|@*">
		<xsl:comment select="concat('unmatched-', name())"/>
	</xsl:template>
	
</xsl:stylesheet>

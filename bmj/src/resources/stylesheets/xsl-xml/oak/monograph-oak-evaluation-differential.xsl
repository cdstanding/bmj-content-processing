<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:html="http://www.w3.org/HTML/1998/html4"
	xmlns:uci="http://www.infinity-loop.de/namespace/2006/upcast-internal"
	xmlns="http://schema.bmj.com/delivery/oak"
	xmlns:bp="http://schema.bmj.com/delivery/oak-bp"
	version="2.0">
	
	<xsl:template name="process-level-2-section-with-heading-and-with-implied-grouping-differential-history-and-exam">
		<xsl:variable name="name" select="name()" />
		<xsl:variable name="parent-name" select="name(parent::*)" />
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class">differentials-history-and-exam</xsl:attribute>
			
			<xsl:element name="title">
				<!-- we concat the level-1 section name to our level-2 headings -->
				<!--<xsl:if test="$parent-name">
					<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$parent-name"/>
					</xsl:call-template>
					<xsl:text>: </xsl:text>
				</xsl:if>-->
				<!--<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
					</xsl:call-template>-->
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="string('differentials-history-and-exam')"/>
				</xsl:call-template>
				
			</xsl:element>
			
			<!-- TODO order these enumerations the same in schema as here -->
			<xsl:for-each 
				select="
				differential[@common='true'][1] | 
				differential[@common='false'][1] 
				">
				<xsl:variable name="section" select="name()"/>
				<xsl:variable name="group" select="@common"/>
				<xsl:variable name="name" select="concat($group, '-', $section, '-group')"/>
				
				<xsl:element name="section">
					<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$section" />-->
					<xsl:attribute name="class" select="concat($group, '-', $section, '-history-and-exam-group')" />
					
					<xsl:element name="title">
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="$name"/>
						</xsl:call-template>
					</xsl:element>
					
					<xsl:apply-templates select="parent::*/*[name()=$section and @*=$group]" mode="differential-history-and-exam">
						<xsl:sort select="ddx-name" />
					</xsl:apply-templates>
					
				</xsl:element>
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template name="process-level-2-section-with-heading-and-with-implied-grouping-differential-tests">
		<xsl:variable name="name" select="name()" />
		<xsl:variable name="parent-name" select="name(parent::*)" />
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class">differentials-tests</xsl:attribute>
			
			<xsl:element name="title">
				<!-- we concat the level-1 section name to our level-2 headings -->
				<!--<xsl:if test="$parent-name">
					<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$parent-name"/>
					</xsl:call-template>
					<xsl:text>: </xsl:text>
				</xsl:if>-->
				<!--<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="$name"/>
					</xsl:call-template>-->
				<xsl:call-template name="process-string-variant">
					<xsl:with-param name="name" select="string('differentials-tests')"/>
				</xsl:call-template>
			</xsl:element>
			
			<!-- TODO order these enumerations the same in schema as here -->
			<xsl:for-each 
				select="
				differential[@common='true'][1] | 
				differential[@common='false'][1]
				">
				<xsl:variable name="section" select="name()"/>
				<xsl:variable name="group" select="@common"/>
				<xsl:variable name="name" select="concat($group, '-', $section, '-group')"/>
				
				<xsl:element name="section">
					<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
					<xsl:attribute name="class" select="$name" />
					
					<xsl:element name="title">
						<xsl:call-template name="process-string-variant">
							<xsl:with-param name="name" select="$name"/>
						</xsl:call-template>
					</xsl:element>
					
					<xsl:apply-templates select="parent::*/*[name()=$section and @*=$group]" mode="differential-tests">
						<xsl:sort select="ddx-name" />
					</xsl:apply-templates>
					
				</xsl:element>
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="differential[parent::differentials and ancestor::monograph-eval]" mode="differential-history-and-exam">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="group" select="@common"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="concat($name, '-history-and-exam')" />
			<xsl:if test="string-length(normalize-space($group))!=0 and position()=1">
				<xsl:attribute name="id" select="concat('first-in-', $group, '-', $name, '-history-and-exam-group')" />
			</xsl:if>
			
			<xsl:element name="title">
				<xsl:apply-templates select="ddx-name/node()"/>
				<!--<xsl:apply-templates select="monograph-link"/>-->
				<xsl:if test="@red-flag = 'true'">
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:apply-templates select="$exclamation"/>
				</xsl:if>
			</xsl:element>
			
			<!--<xsl:apply-templates select="monograph-link"/>-->
			<!--<xsl:apply-templates select="category"/>-->
			
			<xsl:apply-templates select="history"/>
			<xsl:apply-templates select="exam"/>
			
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="differential[parent::differentials and ancestor::monograph-eval]" mode="differential-tests">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="group" select="@common"/>
		
		<xsl:element name="section">
			<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>
			<xsl:attribute name="class" select="concat($name, '-tests')" />
			<xsl:if test="string-length(normalize-space($group))!=0 and position()=1">
				<xsl:attribute name="id" select="concat('first-in-', $group, '-', $name, '-tests-group')" />
			</xsl:if>
			
			<xsl:element name="title">
				<xsl:apply-templates select="ddx-name/node()"/>
				<!--<xsl:apply-templates select="monograph-link"/>-->
				<xsl:if test="@red-flag = 'true'">
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:apply-templates select="$exclamation"/>
				</xsl:if>
			</xsl:element>
			
			<!--<xsl:apply-templates select="monograph-link"/>-->
			<!--<xsl:apply-templates select="category"/>-->
			
			<xsl:for-each select="tests">
				<xsl:for-each 
					select="
					test[@first='true'][1] | 
					test[@first='false'][1]
					">
					<xsl:variable name="section" select="name()"/>
					<xsl:variable name="group" select="@first"/>
					<xsl:variable name="name" select="concat($group, '-', $section, '-group')"/>
					
					<xsl:element name="section">
						<!--<xsl:attribute name="{concat($xmlns, ':oen')}" select="$name"/>-->
						<xsl:attribute name="class" select="$name" />
						<xsl:element name="title">
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="$name"/>
							</xsl:call-template>
						</xsl:element>
						<xsl:element name="list">
							<xsl:apply-templates select="parent::*/*[name()=$section and @*=$group]" mode="differential-tests-test" />
						</xsl:element>
					</xsl:element>
					
				</xsl:for-each>
				
				<xsl:if test="not(test[@first='false'])">
					<xsl:element name="section">
						<xsl:attribute name="class">false-test-group</xsl:attribute>
					</xsl:element>
				</xsl:if>
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="test[ancestor::differential and ancestor::monograph-eval]" mode="differential-tests-test">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="li">
			
			<xsl:element name="inline">
				<xsl:attribute name="class">prompt</xsl:attribute>
				<xsl:apply-templates select="name/node()"/>			
				<xsl:if test="@red-flag = 'true'">
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:apply-templates select="$exclamation"/>
				</xsl:if>
				<xsl:text>:</xsl:text>
			</xsl:element>
			
			<xsl:text disable-output-escaping="yes"> </xsl:text>
			<xsl:apply-templates select="result/node()"/>
			
		</xsl:element>
		
		<xsl:if test="comments/para[string-length(normalize-space(.))!=0]">
			<xsl:element name="list">
				<xsl:for-each select="comments/para">
					<xsl:element name="li">
						<xsl:apply-templates/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:if>
		
	</xsl:template>
	
</xsl:stylesheet>

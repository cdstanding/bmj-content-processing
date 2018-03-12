<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:rx="http://www.renderx.com/XSL/Extensions"
	xmlns:legacytag="com.bmj.behive.extensions.xslextensions.BTLegacyXslExt"
	version="2.0">
	
	<xsl:template name="process-level-2-section-with-heading-and-with-implied-grouping-differential-history-and-exam">
		<xsl:variable name="name" select="name()" />
		<xsl:variable name="parent-name" select="name(parent::*)" />
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:element name="fo:block" use-attribute-sets="">
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
				
				<xsl:element name="fo:block" use-attribute-sets="">
					
					<xsl:element name="fo:block" use-attribute-sets="">
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
		
		<xsl:element name="fo:block" use-attribute-sets="">
			
			<xsl:element name="fo:block" use-attribute-sets="">
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
				
				<xsl:element name="fo:block" use-attribute-sets="">
					
					<xsl:element name="fo:block" use-attribute-sets="">
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
		
		<xsl:element name="fo:block" use-attribute-sets="">

			
			<xsl:element name="fo:block" use-attribute-sets="h3">
				<xsl:apply-templates select="ddx-name/node()"/>
			</xsl:element>
			
			<xsl:apply-templates select="history"/>
			<xsl:apply-templates select="exam"/>
			
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="differential[parent::differentials and ancestor::monograph-eval]" mode="differential-tests">
		<xsl:variable name="name" select="name()"/>
		<xsl:variable name="group" select="@common"/>
		
		<xsl:element name="fo:block" use-attribute-sets="">

			<xsl:element name="fo:block" use-attribute-sets="h3">
				<xsl:apply-templates select="ddx-name/node()"/>
			</xsl:element>
			
			
			<xsl:for-each select="tests">
				<xsl:for-each 
					select="
					test[@first='true'][1] | 
					test[@first='false'][1]
					">
					<xsl:variable name="section" select="name()"/>
					<xsl:variable name="group" select="@first"/>
					<xsl:variable name="name" select="concat($group, '-', $section, '-group')"/>
					
					<xsl:element name="fo:block" use-attribute-sets="">

						<xsl:element name="fo:block" use-attribute-sets="">
							<xsl:call-template name="process-string-variant">
								<xsl:with-param name="name" select="$name"/>
							</xsl:call-template>
						</xsl:element>
						<xsl:element name="fo:list-block" use-attribute-sets="">
							<xsl:apply-templates select="parent::*/*[name()=$section and @*=$group]" mode="differential-tests-test" />
						</xsl:element>
					</xsl:element>
					
				</xsl:for-each>
				
				<xsl:if test="not(test[@first='false'])">
					<xsl:element name="fo:block" use-attribute-sets="">
					</xsl:element>
				</xsl:if>
				
			</xsl:for-each>
			
		</xsl:element>
		
	</xsl:template>
	
	<xsl:template match="test[ancestor::differential and ancestor::monograph-eval]" mode="differential-tests-test">
		<xsl:variable name="name" select="name()"/>
		
		<xsl:element name="fo:list-item" use-attribute-sets="">
			
			<xsl:element name="fo:list-item-label" use-attribute-sets="">
				<xsl:attribute name="end-indent">label-end()</xsl:attribute>
				
				<xsl:element name="fo:block"/>
				
			</xsl:element>
			
			<xsl:element name="fo:list-item-body" use-attribute-sets="">
				<xsl:attribute name="start-indent">body-start()</xsl:attribute>
				
				<xsl:element name="fo:block" use-attribute-sets="">
					
					<xsl:element name="fo:inline" use-attribute-sets="">
						<xsl:apply-templates select="name/node()"/>			
						<xsl:text>:</xsl:text>
					</xsl:element>
					
					<xsl:text disable-output-escaping="yes"> </xsl:text>
					<xsl:apply-templates select="result/node()"/>
					
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
		<xsl:if test="comments/para[string-length(normalize-space(.))!=0]">
			
			<xsl:element name="fo:list-item" use-attribute-sets="">
				
				<xsl:element name="fo:list-item-label" use-attribute-sets="">
					<xsl:attribute name="end-indent">label-end()</xsl:attribute>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						
					</xsl:element>
					
				</xsl:element>
				
				<xsl:element name="fo:list-item-body" use-attribute-sets="">
					<xsl:attribute name="start-indent">body-start()</xsl:attribute>
					
					<xsl:element name="fo:block" use-attribute-sets="">
						<xsl:text>more:</xsl:text>
					</xsl:element>
					
				</xsl:element>
				
			</xsl:element>
			

			<xsl:for-each select="comments/para">
				
				<xsl:element name="fo:list-item" use-attribute-sets="">
					
					<xsl:element name="fo:list-item-label" use-attribute-sets="">
						<xsl:attribute name="end-indent">label-end()</xsl:attribute>
						
						<xsl:element name="fo:block" use-attribute-sets="">
							
						</xsl:element>
						
					</xsl:element>
					
					<xsl:element name="fo:list-item-body" use-attribute-sets="">
						<xsl:attribute name="start-indent">body-start()</xsl:attribute>
						
						<xsl:element name="fo:block" use-attribute-sets="">
							<xsl:apply-templates/>
						</xsl:element>
						
					</xsl:element>
					
				</xsl:element>
				
			</xsl:for-each>
			
			
		</xsl:if>
		
	</xsl:template>
	
</xsl:stylesheet>

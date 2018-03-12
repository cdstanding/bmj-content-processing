<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

	<xsl:output 
		method="xml" 
		encoding="UTF-8" 
		indent="yes"/>
    
	<xsl:template match="/">
	    
	    <xsl:element name="fo:root">
	        
	        <xsl:element name="fo:layout-master-set">
	            
	            <xsl:element name="fo:simple-page-master">
	                <xsl:attribute name="master-name">default</xsl:attribute>
	                
	                <xsl:element name="fo:region-body">
		                <xsl:attribute name="region-name">default</xsl:attribute>
		                <xsl:attribute name="margin-top">2.5cm</xsl:attribute>
		                <xsl:attribute name="margin-bottom">2.5cm</xsl:attribute>
		                <xsl:attribute name="margin-left">2.0cm</xsl:attribute>
		                <xsl:attribute name="margin-right">2.0cm</xsl:attribute>
	                </xsl:element>
	                
	            </xsl:element>
	            
	        </xsl:element>
			
			<xsl:element name="fo:page-sequence">
				<xsl:attribute name="master-reference">default</xsl:attribute>
				
				<xsl:element name="fo:flow">
					<xsl:attribute name="flow-name">default</xsl:attribute>
					
					<xsl:element name="fo:block">
					    <xsl:attribute name="font-size" select="string('10pt')"/>
					    
					    <!--<xsl:element name="fo:block">
					        <xsl:text>title</xsl:text>
					    </xsl:element>-->
						
					    <xsl:apply-templates select="/*" mode="worksheet" />
						
					</xsl:element>
				    
				</xsl:element>
			    
			</xsl:element>
			
		</xsl:element>
	    
	</xsl:template>
	
	
    <xsl:template match="*" mode="worksheet">
        
        <fo:table table-layout="fixed" width="100%">
            <fo:table-column column-width="50pt"/>
            <fo:table-column column-width="400pt"/>
            
            <fo:table-body>
                <xsl:apply-templates select="*" mode="row" />
            </fo:table-body>
            
        </fo:table>
        
    </xsl:template>
    
    <xsl:template match="*" mode="row">
            
        <xsl:apply-templates select="*" mode="cell" />
        
    </xsl:template>
    
    <xsl:template match="*" mode="cell">
        <xsl:param name="position">
            <xsl:variable name="generate-id" select="generate-id()"/>
            <xsl:for-each select="parent::*/element()">
                <xsl:if test="generate-id()=$generate-id">
                    <xsl:value-of select="position()"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:param>
        
        <fo:table-row>
        
            <fo:table-cell>
                
                <xsl:if test="$position='1'">
                    <xsl:attribute name="border-top-style" select="string('solid')"/>
                    <xsl:attribute name="border-top-color" select="string('black')"/>
                    <xsl:attribute name="border-top" select="string('1px')"/>
                </xsl:if>
                
                <xsl:if test="$position='5'">
                    <xsl:attribute name="padding-bottom" select="string('20px')"/>    
                </xsl:if>
                
                <xsl:element name="fo:block">
                    <xsl:attribute name="font-weight" select="string('bold')"/>
                    <xsl:value-of select="name()"/>
                    <xsl:text>: </xsl:text>
                </xsl:element>
                
            </fo:table-cell>
            
            <fo:table-cell>
                
                <xsl:if test="$position='1'">
                    <xsl:attribute name="border-top-style" select="string('solid')"/>
                    <xsl:attribute name="border-top-color" select="string('black')"/>
                    <xsl:attribute name="border-top" select="string('1px')"/>
                </xsl:if>
                
                <xsl:if test="$position='5'">
                    <xsl:attribute name="padding-bottom" select="string('20px')"/>    
                </xsl:if>
                
                <xsl:element name="fo:block">
                    <xsl:apply-templates mode="change-markup"/>
                </xsl:element>
                
            </fo:table-cell>
            
        </fo:table-row>
                
    </xsl:template>
    
    <xsl:template match="span[@class]" mode="change-markup">
        
        <xsl:element name="fo:inline">
            
            <xsl:choose>
                
                <xsl:when test="@class='redline-insert'">
                    <xsl:attribute name="color" select="string('green')"/>
                    <xsl:attribute name="text-decoration" select="string('underline')"/>
                </xsl:when>
                
                <xsl:when test="@class='redline-delete'">
                    <xsl:attribute name="color" select="string('red')"/>
                    <xsl:attribute name="text-decoration" select="string('line-through')"/>
                </xsl:when>
                
                <xsl:when test="@class='redline-comment'">
                    <xsl:attribute name="color" select="string('yellow')"/>
                </xsl:when>
                
            </xsl:choose>
            
            <xsl:apply-templates/>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="processing-instruction()[name()='break']" mode="change-markup">
        <xsl:text disable-output-escaping="yes">&#13;&#10;&#09;</xsl:text>
        <xsl:element name="fo:block"/>
    </xsl:template>
    
    <xsl:template match="node()" mode="change-markup">
        <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>

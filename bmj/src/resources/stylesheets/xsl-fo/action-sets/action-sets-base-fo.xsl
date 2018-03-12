<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

    <xsl:param name="image-action-set-check-box"/>
    <xsl:param name="image-action-set-ec-logo"/>
    <xsl:param name="image-action-set-icon"/>
    <xsl:param name="image-action-set-label"/>
    <xsl:param name="image-action-set-logo"/>
    
    <xsl:param name="base-url"/>
    <xsl:param name="format"/>
    <!-- Added the below parameter for mantis ID 12636 to retrieve the corresponding evidence summary-->
    <xsl:param name="xmlstore-url"/> 
	<xsl:output 
		method="xml"  
		encoding="UTF-8" 
		indent="yes"
		doctype-public="-//BMJ//DTD FO:ROOT//EN"
		doctype-system="http://www.renderx.com/Tests/validator/fo2000.dtd"/>
    
	<xsl:template match="/">
	    
	    <xsl:element name="fo:root">
	        
	        <xsl:element name="fo:layout-master-set">
	           
	           <!-- For all pages apart from the last one-->
	            <xsl:element name="fo:simple-page-master">
	                <xsl:attribute name="master-name">all-pages</xsl:attribute>
	               
	               <!-- Main Content page details-->
	                <xsl:element name="fo:region-body">
	                    <xsl:attribute name="region-name">body</xsl:attribute>
	                    <xsl:attribute name="margin-top">120pt</xsl:attribute>
	                    <xsl:attribute name="margin-bottom">75pt</xsl:attribute>
	                </xsl:element>
	               
	               <!-- Header Region -->
	                <xsl:element name="fo:region-before">	                    
	                    <xsl:attribute name="extent">1pt</xsl:attribute>
	                    <xsl:attribute name="region-name">header</xsl:attribute>
	                    <!--  <xsl:attribute name="extent">50pt</xsl:attribute>
	                    <xsl:attribute name="background-color">#0D519F</xsl:attribute>  --> 
	                </xsl:element>
	                
	                <!-- Footer Region-->
	                <xsl:element name="fo:region-after">	                    
	                     <xsl:attribute name="region-name">footer</xsl:attribute>
	                    <xsl:attribute name="extent">75pt</xsl:attribute>
	                    <!--  <xsl:attribute name="background-color">#0D519F</xsl:attribute> -->  
	                </xsl:element>
	                
	            </xsl:element>
	           
	        </xsl:element>
	        	
			<xsl:element name="fo:page-sequence">
			    <xsl:attribute name="master-reference">all-pages</xsl:attribute>
			   			        
			    <!-- THE HEADER -->
			    <fo:static-content flow-name="header">
			         <fo:block>
			            <xsl:call-template  name="header-contents"/>                                                                
			         </fo:block>			      
			    </fo:static-content>	
			    
			    <!-- THE FOOTER  -->
			    <fo:static-content flow-name="footer">
			        <fo:block>	
			            <xsl:call-template  name="footer-contents"/>     
			        </fo:block>	
			        </fo:static-content>				    
			    
		   	    <xsl:element name="fo:flow">
		   	        <xsl:attribute name="flow-name">body</xsl:attribute>
		   	   
			            <xsl:element name="fo:block">
				  <xsl:attribute name="font-size" select="string('10pt')"/>
			                <xsl:attribute name="display-align">center</xsl:attribute>
			            </xsl:element>       
				
				<!-- example of xsl output for debugging -->
				<xsl:message>NO WIDTH ATTRIBUTE!</xsl:message>
		   	        
			   	<!-- Table within a table is the only way to fix the problem with borders -->
        			   	<fo:table table-layout="fixed" width="100%">
        			   	     <fo:table-column column-width="proportional-column-width(1)"/>
        			   	     <fo:table-column column-width="550pt"/>
        			   	     <fo:table-column column-width="proportional-column-width(1)"/>
        			   	      <fo:table-body>
        			   	          <fo:table-row>
        			   	              <!-- The margin-->
        			   	              <fo:table-cell>
        			   	                  <fo:block>
        			   	                   </fo:block>
        			   	                </fo:table-cell>
        			   	            
        			   	                <!-- the part of the table where the content goes -->       			   	            
         			   	                <fo:table-cell >
         			   	                    <fo:block>
         			   	                        <!--Where the 'known allergies' etc grey boxes go  -->    
         			   	                            <xsl:call-template  name="first-page-sub-header"/>     			   	                        
         			   	                    </fo:block>
         			   	                    
        			   	                    <fo:block>
        			   	                        <fo:table table-layout="fixed" width="100%">
        			   	                            
        			   	                            <fo:table-column column-width="20pt"/>
        			   	                            <fo:table-column column-width="20pt"/>
        			   	                            <fo:table-column column-width="500pt"/>
        			   	                            <fo:table-column column-width="10pt"/>
        			   	                            
        			   	                            <fo:table-body>
        			   	                         <!--        <xsl:apply-templates select="//action-set/caption"/>
        			   	                                <xsl:apply-templates select="//category-list/category"/>
        			   	                              -->
        			   	                                <!-- Added the below template for Mantis ID 12636 to display the value of Scope from the evidence summary in the Action sets page -->
        			   	                                <xsl:apply-templates select="//esp-ids/esp-id"/>
        			   	                               <xsl:apply-templates select="//category-list/category[./caption/text()!='Condition']"/>
        			   	                                <!-- <xsl:apply-templates select="//category-list/category"/>-->
        			   	                                
        			   	                                <xsl:call-template  name="Bottom-Level-Of-Table"/>
        			   	                            </fo:table-body>
        			   	                            
        			   	                        </fo:table>
        			   	                    
        			   	                    </fo:block>
        			   	                </fo:table-cell>
        			   	                
        			   	              <!-- The margin-->
        			   	                <fo:table-cell>
        			   	                    <fo:block>
        			   	                    </fo:block>			   	                    
        			   	                </fo:table-cell>
        			   	              
        			   	            </fo:table-row>
        			   	        </fo:table-body>
        			   	</fo:table>
		   	        
		   	        
		   	        
			   	    <!-- for the page numbers, identifies the end of the document -->
			   	    <fo:block id="terminator"/>
			   	    
			   	</xsl:element>
			    
			</xsl:element>
			
		</xsl:element>
	    
	</xsl:template>
    
    
    <!-- Creates a three column table to start off with to provide a left and right margin
           The middle column of 550px is then subdivided into three columns for the header images-->
    <xsl:template name="header-contents">
        <fo:table table-layout="fixed" width="100%">
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-column column-width="550pt"/>            
            <fo:table-column column-width="proportional-column-width(1)"/>
            
            <fo:table-body>
                <fo:table-row>
                    
                    <!-- Spacer column-->
                    <fo:table-cell>
                        <fo:block><!-- The margin-->
                        </fo:block>
                    </fo:table-cell>                   
                        			   	            
                    <fo:table-cell >
                        <fo:block>
                            <fo:table table-layout="fixed" width="100%">
                                <fo:table-column column-width="165pt"/>
                                <fo:table-column column-width="165pt"/>
                                <fo:table-column column-width="220pt"/>
                                
                                <fo:table-body>
                                    
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block>                                                
                                                <!--<fo:external-graphic src="url('../images/action-set-logo_default.jpg')" width="165px" content-height="105px" scaling="uniform"/>
                                                <fo:external-graphic src="url('Action_Sets_images2/action-set-logo.jpg')" width="165px" content-height="105px" scaling="uniform"/> -->
                                                <!-- example of xsl output for debugging -->
				                                <xsl:message>the location of the image = <xsl:value-of select="$image-action-set-logo"/></xsl:message>
                                                
												<xsl:element name="fo:external-graphic">
												    <xsl:attribute name="content-height">26%</xsl:attribute>
													<xsl:attribute name="content-height">26%</xsl:attribute>													
													<xsl:attribute name="src">
														<xsl:text>url('</xsl:text><xsl:value-of select="$image-action-set-logo"/><xsl:text>')</xsl:text>
													</xsl:attribute>
												</xsl:element>		
                                            </fo:block>                                            
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block>
                                                <!-- this will be where the external company logo goes -->
                                                <!--<fo:external-graphic src="url('Action_Sets_images2/action-set-logo.jpg')" width="165px" content-height="105px" scaling="uniform"/> -->
			
                                            </fo:block>                                            
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block>
                                                <!--<fo:external-graphic src="url('../images/action-set-label_default.jpg')" width="165px" content-height="105px" scaling="uniform"/>
                                                <fo:external-graphic src="url('Action_Sets_images2/action-set-label.jpg')" width="220px" content-height="105px" scaling="uniform"/> -->
                                                <xsl:element name="fo:external-graphic">
													<xsl:attribute name="content-height">30%</xsl:attribute>
													<xsl:attribute name="content-height">30%</xsl:attribute>
													<xsl:attribute name="src">
														<xsl:text>url('</xsl:text><xsl:value-of select="$image-action-set-label"/><xsl:text>')</xsl:text>
													</xsl:attribute>
												</xsl:element>	
                                                
                                            </fo:block>                                            
                                        </fo:table-cell>
                                    </fo:table-row>
                                    <xsl:call-template  name="three-column-10px-whiteline"/>
                                </fo:table-body>
                                
                            </fo:table>
                       
                        </fo:block>
                    </fo:table-cell>
                    
                    <!-- Spacer column-->
                    <fo:table-cell>
                        <fo:block><!-- The margin-->
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <!-- displays the grey boxes and text on the first page just below the header (images) -->
    <xsl:template name="first-page-sub-header">
        <fo:table table-layout="fixed" width="100%">
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-column column-width="550pt"/>            
            <fo:table-column column-width="proportional-column-width(1)"/>
            
            <fo:table-body>
                <fo:table-row>
                    
                    <!-- Spacer column-->
                    <fo:table-cell>
                        <fo:block><!-- The margin-->
                        </fo:block>
                    </fo:table-cell>                   
                    
                    <fo:table-cell >
                        <fo:block>
                            <fo:table table-layout="fixed" width="100%">
                                <!-- need four coulumn that 'float' to the width of the text -->
                                <fo:table-column column-width="80pt"/>
                                <fo:table-column column-width="230pt"/>
                                <fo:table-column column-width="80pt"/>
                                <fo:table-column column-width="160pt"/>
                                
                                <fo:table-body>
                                    
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                                <xsl:text>Known Allergies:</xsl:text>
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>
                                            <xsl:attribute name="number-columns-spanned"> 3 </xsl:attribute>
                                            <xsl:attribute name='background-color'>#FAFAFA</xsl:attribute>
                                            
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                            </xsl:element>
                                        </fo:table-cell>
                                    </fo:table-row>   
                                    <fo:table-row>
                                        <fo:table-cell><!-- White thin, cut through line -->
                                            <xsl:attribute name="number-columns-spanned">4 </xsl:attribute>
                                            <xsl:attribute name='background-color'>white</xsl:attribute>
                                            
                                            <xsl:element name="fo:block">  <!-- block required to satisfy parser -->
                                                <xsl:attribute name="font-size" select="string('3pt')"/>
                                                <xsl:text>&#160;</xsl:text>
                                            </xsl:element>
                                        </fo:table-cell>
                                    </fo:table-row>         
                                    
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                                <xsl:text>Diagnosis and co-morbidities:</xsl:text>
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>  <!-- Grey background blank cell -->                                          
                                            <xsl:attribute name='background-color'>#FAFAFA</xsl:attribute>
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                                <xsl:text>&#160;&#160;Code Status:</xsl:text>
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>  <!-- Grey background blank cell -->                                          
                                            <xsl:attribute name='background-color'>#FAFAFA</xsl:attribute>                                            
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                    </fo:table-row>         
                                    
                                    <!-- separation line white, grey, white, white (covers the four colums)-->
                                    <fo:table-row>
                                        <fo:table-cell>  <!-- Grey background blank cell -->                                            
                                            <xsl:element name="fo:block">   
                                                <xsl:attribute name="font-size" select="string('3pt')"/>
                                            </xsl:element>
                                        </fo:table-cell>
                                        <fo:table-cell>  <!-- Grey background blank cell -->                                          
                                            <xsl:attribute name='background-color'>#FAFAFA</xsl:attribute>
                                            <xsl:element name="fo:block"> 
                                                <xsl:attribute name="font-size" select="string('3pt')"/>
                                            </xsl:element>
                                        </fo:table-cell>
                                        <fo:table-cell><!-- White thin, cut through line -->
                                            <xsl:attribute name="number-columns-spanned">2 </xsl:attribute>
                                            <xsl:attribute name='background-color'>white</xsl:attribute>
                                            
                                            <xsl:element name="fo:block">  <!-- block required to satisfy parser -->
                                                <xsl:attribute name="font-size" select="string('3pt')"/>
                                                <xsl:text>&#160;</xsl:text>
                                            </xsl:element>
                                        </fo:table-cell>
                                    </fo:table-row>         
                                    
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                                <xsl:text></xsl:text>
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>  <!-- Grey background blank cell -->                                          
                                            <xsl:attribute name='background-color'>#FAFAFA</xsl:attribute>
                                            
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                                <xsl:text>&#160;&#160;Service:</xsl:text>
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>  <!-- Grey background blank cell -->                                          
                                            <xsl:attribute name='background-color'>#FAFAFA</xsl:attribute>
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                            </xsl:element>
                                        </fo:table-cell>                                        
                                    </fo:table-row>  
                                    <fo:table-row><!-- The bottom seperator line -->
                                        <fo:table-cell><!-- White thin, cut through line -->
                                            <xsl:attribute name="number-columns-spanned">4 </xsl:attribute>
                                            <xsl:attribute name='background-color'>white</xsl:attribute>
                                            
                                            <xsl:element name="fo:block">  <!-- block required to satisfy parser -->
                                                <xsl:attribute name="font-size" select="string('15pt')"/>
                                                <xsl:text>&#160;</xsl:text>
                                            </xsl:element>
                                        </fo:table-cell>
                                    </fo:table-row>         
                                    
                                </fo:table-body>
                                
                            </fo:table>
                            
                        </fo:block>
                    </fo:table-cell>
                    
                    <!-- Spacer column-->
                    <fo:table-cell>
                        <fo:block><!-- The margin-->
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>
  
    
    
    <xsl:template name="footer-contents">
        <fo:table table-layout="fixed" width="100%">
            <fo:table-column column-width="proportional-column-width(1)"/>
            <fo:table-column column-width="550pt"/>            
            <fo:table-column column-width="proportional-column-width(1)"/>
            
            <fo:table-body>
                <xsl:call-template  name="three-column-15px-whiteline"/>
                
                <fo:table-row>
                    
                    <!-- Spacer column-->
                    <fo:table-cell>
                        <fo:block><!-- The margin-->
                        </fo:block>
                    </fo:table-cell>
                    
                    <!-- the part of the table where the content goes -->       			   	            
                    <fo:table-cell >
                        <fo:block>
                            <fo:table table-layout="fixed" width="100%">
                                <!-- need six columns for the text and grey boxes -->
                                <fo:table-column column-width="80pt"/>
                                <fo:table-column column-width="90pt"/><!-- Physician name -->
                                <fo:table-column column-width="40pt"/>
                                <fo:table-column column-width="80pt"/><!-- Date -->
                                <fo:table-column column-width="40pt"/>
                                <fo:table-column column-width="80pt"/><!-- Time -->
                                <fo:table-column column-width="60pt"/>
                                <fo:table-column column-width="80pt"/><!-- Signature -->
                                <fo:table-body>
                                    
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                                  <xsl:text>Physician name:</xsl:text>
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>                                            
                                            <xsl:attribute name='background-color'>#FAFAFA</xsl:attribute>
                                            
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                                <xsl:text>&#160;&#160;Date:</xsl:text>
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>                                            
                                            <xsl:attribute name='background-color'>#FAFAFA</xsl:attribute>
                                            
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                                <xsl:text>&#160;&#160;Time:</xsl:text>
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>                                            
                                            <xsl:attribute name='background-color'>#FAFAFA</xsl:attribute>
                                            
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                                <xsl:text>&#160;&#160;Signature:</xsl:text>
                                            </xsl:element>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>                                            
                                            <xsl:attribute name='background-color'>#FAFAFA</xsl:attribute>
                                            
                                            <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding">
                                            </xsl:element>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                                
                            </fo:table>
                        </fo:block>
                    </fo:table-cell>
                    
                    <!-- Spacer column-->
                    <fo:table-cell>
                        <fo:block><!-- The margin-->
                        </fo:block>			   	                    
                    </fo:table-cell>
                </fo:table-row>
                
                <!-- The blank seperator line between the text and grey boxes and the images -->
                <!-- The bottom seperator line 10px -->
                <xsl:call-template  name="three-column-10px-whiteline"/>
                
                <!-- the last part with the BMJ image on the left, page number in the middle and document bmjId on the right -->
                <fo:table-row>
                    
                    <!-- Spacer column-->
                    <fo:table-cell>
                        <fo:block><!-- The margin-->
                        </fo:block>
                    </fo:table-cell>
                    
                    <fo:table-cell><!-- The contents -->
                        <fo:block>
                            <fo:table table-layout="fixed" width="100%">
                                <!-- need three columns for the bmj image, page count and bmjid -->
                                <fo:table-column column-width="180pt"/>
                                <fo:table-column column-width="190pt"/>
                                <fo:table-column column-width="180pt"/>
                               
                                <fo:table-body>
                                    
                                    <fo:table-row>
                                        <fo:table-cell><!-- the BMJ image -->
                                            <fo:block>
                                                <!-- <fo:external-graphic src="url('../../../images/action-set-ec-logo_default.jpg)" width="180px" content-height="21px" scaling="uniform"/> 
                                                <fo:external-graphic src="url('Action_Sets_images2/action-set-ec-logo-default.jpg')" width="180px" content-height="21px" scaling="uniform"/>-->
                                                <xsl:element name="fo:external-graphic">
												    <xsl:attribute name="content-height">20%</xsl:attribute>
													<xsl:attribute name="content-height">20%</xsl:attribute>
													<xsl:attribute name="src">
														<xsl:text>url('</xsl:text><xsl:value-of select="$image-action-set-ec-logo"/><xsl:text>')</xsl:text>
													</xsl:attribute>
												</xsl:element>	
                                            </fo:block>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell><!-- the page count -->
                                            <xsl:element name="fo:block">
                                                <xsl:attribute name="font-size" select="string('8pt')"/>
                                                <xsl:attribute name='text-align' select="string('center')"/>
                                                <xsl:attribute name="font-family" select="string('Arial')"/>
                                                Page <fo:page-number/>
                                                of <fo:page-number-citation ref-id="terminator"/>
                                            </xsl:element>	
                                        </fo:table-cell>
                                        
                                        <fo:table-cell><!-- The document bmjId -->
                                            <fo:block>
                                                <xsl:apply-templates select="//@bmj-id"/>
                                            </fo:block>
                                        </fo:table-cell>
                                        
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:block>                        
                    </fo:table-cell>
                    
                    <fo:table-cell>
                        <fo:block><!-- The margin-->
                        </fo:block>
                    </fo:table-cell>
                    
                </fo:table-row>
                
            </fo:table-body>
        </fo:table>
    </xsl:template>
  
   <!-- The highest level blue header containing the document title-->
    <xsl:template match="action-set/caption">
        
        <fo:table-row>
            <fo:table-cell>
                <xsl:attribute name="number-columns-spanned"> 4 </xsl:attribute>
                
                <xsl:attribute name='background-color'>#00A6D6</xsl:attribute>
                
                <xsl:element name="fo:block">
                    <xsl:attribute name="padding-top" select="string('2pt')"/>
                    <xsl:attribute name="padding-bottom" select="string('2pt')"/>                    
                    <xsl:attribute name='color' select="string('white')"/>
                    <xsl:attribute name="font-size" select="string('13pt')"/>
                    <xsl:attribute name=' text-align' select="string('left')"/>
                    <xsl:attribute name="font-family" select="string('Arial')"/>                    
                    &#160;<xsl:value-of select="."/>                     
               </xsl:element>
                
            </fo:table-cell>           
        </fo:table-row>
        
    </xsl:template>
    
    
    <!-- The high level green header bars with the white text-->
    <xsl:template match="category-list/category">
        
        <xsl:call-template  name="four-column-10px-whiteline"/>
        
        <fo:table-row>           
            <fo:table-cell>
                <xsl:attribute name="number-columns-spanned"> 4 </xsl:attribute>
                <xsl:attribute name='background-color'>#00A567</xsl:attribute>
                
                
                <xsl:element name="fo:block">
                    <xsl:attribute name="padding-top" select="string('2pt')"/>
                    <xsl:attribute name="padding-bottom" select="string('2pt')"/>                    
                    <xsl:attribute name="font-weight" select="string('normal')"/>
                    <xsl:attribute name="font-family" select="string('Arial')"/>   
                    <xsl:attribute name='color' select="string('white')"/>
                    <xsl:attribute name="font-size" select="string('11pt')"/>
                                       
                    &#160;<xsl:value-of select="caption"/>
                    <xsl:text> </xsl:text>
                    
                    <xsl:if test="evidence-summary-link">
                        <!-- Ah, evidence-summary-link is present process it -->
                        <xsl:call-template name="evidence-summary-link-image-green">
                            <xsl:with-param name="evidence-summary-link" />
                        </xsl:call-template>
                    </xsl:if>
                    
                </xsl:element>
                
            </fo:table-cell>
        </fo:table-row> 
        
        <xsl:apply-templates select="component-list/component">
            <!--<xsl:sort select="bundle-group-id"/>-->
        </xsl:apply-templates>
        
        <xsl:apply-templates select="sub-category-list/sub-category"/>
        
    </xsl:template>
    
    <!-- The highest level content boxes, these appear below the green category/caption boxes -->
    <xsl:template match="category/component-list/component">
        <xsl:variable name="bundle-group-id" select="normalize-space(bundle-group-id)"/>
        <xsl:variable name="bundle-group-count" select="count(parent::component-list/component/bundle-group-id[normalize-space(.)=$bundle-group-id])"/>
        
        <!-- find catgory name -->
        <xsl:variable name="cat"><xsl:value-of select="ancestor::category/caption"/></xsl:variable>
        
        <xsl:variable name="bundle-group-first">
            <xsl:choose>
                <xsl:when 
                    test="
                    string-length($bundle-group-id)!=0
                    and $bundle-group-count &gt; 1
                    and (
                    not(preceding-sibling::component[1])
                    or preceding-sibling::component[1][normalize-space(bundle-group-id)!=$bundle-group-id]
                    )
                    ">
                    <xsl:text>true</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>false</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="bundle-group-last">
            <xsl:choose>
                <xsl:when 
                    test="
                    string-length($bundle-group-id)!=0
                    and $bundle-group-count &gt; 1
                    and following-sibling::component[1]/bundle-group-id[string-length(normalize-space(.))!=0 and normalize-space(.)!=$bundle-group-id]
                    ">
                    <xsl:text>true</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>false</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="bundle-group">
            <xsl:choose>
                <xsl:when 
                    test="
                    string-length($bundle-group-id)!=0
                    and $bundle-group-count &gt; 1
                    ">
                    <xsl:text>true</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>false</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <fo:table-row>
            
            <!-- the checkbox cell -->
            <fo:table-cell>
                
                <xsl:attribute name="border-left-style" select="string('solid')"/>
                <xsl:attribute name="border-left-color" select="string('#DBE0E4')"/>
                <xsl:attribute name="border-left" select="string('1px')"/>
                <xsl:attribute name='background-color'>#FCFCFC</xsl:attribute>
                
                <!-- Make sure the cells are surrounded by a border but have no internal borders  -->
                <xsl:if test="position()=last()">
                    <xsl:attribute name="border-bottom-style" select="string('solid')"/>
                    <xsl:attribute name="border-bottom-color" select="string('#DBE0E4')"/>                     
                    <xsl:attribute name="border-bottom" select="string('1px')"/>                    
                </xsl:if>
                
                <xsl:attribute name='text-align' select="string('center')"/>
                <xsl:attribute name='display-align' select="string('center')"/>
                                
                    <fo:block>
                        
                        <xsl:if 
                            test="
                            (following-sibling::component[1][normalize-space(bundle-group-id)=$bundle-group-id] 
                            and $bundle-group-first='true')
                            
                            or (orderable-type='O' and $bundle-group='false')
                            ">
                            <xsl:element name="fo:external-graphic">
                                <xsl:attribute name="content-height">12%</xsl:attribute>
                                <xsl:attribute name="content-height">12%</xsl:attribute>
                                <xsl:attribute name="src">
                                    <xsl:text>url('</xsl:text><xsl:value-of select="$image-action-set-check-box"/><xsl:text>')</xsl:text>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        
                    </fo:block>
                
            </fo:table-cell>
            
            <!-- the text cell -->
            <fo:table-cell>
                <xsl:attribute name="number-columns-spanned"> 3 </xsl:attribute>
                <xsl:attribute name="border-right-style" select="string('solid')"/>
                <xsl:attribute name="border-right-color" select="string('#DBE0E4')"/>
                <xsl:attribute name="border-right" select="string('1pt')"/>
                <xsl:attribute name='background-color'>#FCFCFC</xsl:attribute>
                
                <!-- Make sure the cells are surrounded by a border but have no internal borders -->               
                <xsl:if test="position()=last()">
                    <xsl:attribute name="border-bottom-style" select="string('solid')"/>
                    <xsl:attribute name="border-bottom-color" select="string('#DBE0E4')"/>
                    <xsl:attribute name="border-bottom" select="string('1px')"/>                    
                </xsl:if>
               
                <xsl:attribute name="font-family" select="string('Arial')"/>
                <xsl:attribute name="font-size" select="string('10pt')"/>
                <xsl:attribute name='display-align' select="string('center')"/>
                                
                <xsl:element name="fo:block">
                    <xsl:choose>
                        <xsl:when test="default-selected=1">
                                <xsl:attribute name="font-weight" select="string('bold')"/>
                          </xsl:when>                        
                          <xsl:otherwise>
                                <xsl:attribute name="font-weight" select="string('normal')"/>
                          </xsl:otherwise>
                    </xsl:choose>
                    
                   <xsl:if test="orderable-type='L'">
                       <xsl:attribute name="padding-top" select="string('3px')"/>
                       <xsl:attribute name="font-style" select="string('italic')"/>
                       <xsl:attribute name="padding-bottom" select="string('3px')"/>                    
                    </xsl:if> 
                    
                    <xsl:if test="$bundle-group-first='true'">
                        <xsl:attribute name="font-weight" select="string('bold')"/>
                    </xsl:if>
                    
                    <xsl:if test="$bundle-group-first!='true' and $bundle-group='true'">
                        <xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
                    </xsl:if>
                    
                    <xsl:value-of select="caption"/>
                    
                    <xsl:choose>
                        <xsl:when test="($cat = 'Medications') or ($cat = 'IV Fluids')">
                            <xsl:choose>
                                <xsl:when test="sentence-list/sentence/details-list/details[child::field-mean[text() = 'SPECINX']]">
                                    
                                    <!-- Is there a PRN -->
                                    <xsl:choose>
                                        <!-- PRN found -->
                                        <xsl:when test="sentence-list/sentence/details-list/details[child::field-mean[text() = 'SCH/PRN']]">
                                            <!-- Does the PRN have a reason  -->
                                            <xsl:choose>
                                                <xsl:when test="sentence-list/sentence/details-list/details[child::field-mean[text() = 'PRNREASON']]">
                                                    
                                                    <xsl:text> </xsl:text>
                                                    <fo:inline font-weight="normal">
                                                        <xsl:text>(</xsl:text>
                                                            <xsl:choose>
                                                                <xsl:when test="string-length(normalize-space(sentence-list/sentence/display-line))!=0">
                                                                    <xsl:apply-templates select="sentence-list/sentence/display-line"/>
                                                                    <xsl:text>, </xsl:text>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                        <xsl:value-of select="sentence-list/sentence/details-list/details[child::field-mean[text() = 'SPECINX']]/field-display-value"/>
                                                        <xsl:text>; </xsl:text>
                                                        <xsl:value-of select="sentence-list/sentence/details-list/details[child::field-mean[text() = 'PRNREASON']]/field-display-value"/>
                                                        <xsl:text>)</xsl:text>
                                                    </fo:inline>
                                                    <xsl:text> </xsl:text>
                                                    
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <!-- This the as needed version -->
                                                    
                                                    <xsl:text> </xsl:text>
                                                    <fo:inline font-weight="normal">
                                                        <xsl:text>(</xsl:text>
                                                        <xsl:choose>
                                                            <xsl:when test="string-length(normalize-space(sentence-list/sentence/display-line))!=0">
                                                                <xsl:apply-templates select="sentence-list/sentence/display-line"/>
                                                                <xsl:text>, </xsl:text>
                                                            </xsl:when>
                                                        </xsl:choose>                                                        
                                                        <xsl:value-of select="sentence-list/sentence/details-list/details[child::field-mean[text() = 'SPECINX']]/field-display-value"/>
                                                        <xsl:text>; as needed)</xsl:text>
                                                    </fo:inline>
                                                    <xsl:text> </xsl:text>
                                                    
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text> </xsl:text>
                                            <fo:inline font-weight="normal">
                                                <xsl:text>(</xsl:text>            
                                                <xsl:choose>
                                                    <xsl:when test="string-length(normalize-space(sentence-list/sentence/display-line))!=0">
                                                        <xsl:apply-templates select="sentence-list/sentence/display-line"/>
                                                        <xsl:text>, </xsl:text>
                                                    </xsl:when>
                                                </xsl:choose>
                                                <xsl:value-of select="sentence-list/sentence/details-list/details[child::field-mean[text() = 'SPECINX']]/field-display-value"/>
                                                <xsl:text>)</xsl:text>
                                            </fo:inline>
                                            <xsl:text> </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- Is there a PRN ? -->
                                    <xsl:choose>
                                        <xsl:when test="sentence-list/sentence/details-list/details[child::field-mean[text() = 'SCH/PRN']]">

                                            <!-- Does the PRN have a reason  -->
                                            <xsl:choose>
                                                <xsl:when test="sentence-list/sentence/details-list/details[child::field-mean[text() = 'PRNREASON']]">
                                                    
                                                    <xsl:text> </xsl:text>
                                                    <fo:inline font-weight="normal">
                                                        <xsl:text>(</xsl:text>            
                                                        <xsl:choose>
                                                            <xsl:when test="string-length(normalize-space(sentence-list/sentence/display-line))!=0">
                                                                <xsl:apply-templates select="sentence-list/sentence/display-line"/>
                                                                <xsl:text>; </xsl:text>
                                                            </xsl:when>
                                                        </xsl:choose>
                                                        <xsl:value-of select="sentence-list/sentence/details-list/details[child::field-mean[text() = 'PRNREASON']]/field-display-value"/>
                                                        <xsl:text>)</xsl:text>
                                                    </fo:inline>
                                                    <xsl:text> </xsl:text>
                                                    
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <!-- This the as needed version -->
                                                    
                                                    <xsl:text> </xsl:text>
                                                    <fo:inline font-weight="normal">
                                                        <xsl:text>(</xsl:text>            
                                                        <xsl:choose>
                                                            <xsl:when test="string-length(normalize-space(sentence-list/sentence/display-line))!=0">
                                                                <xsl:apply-templates select="sentence-list/sentence/display-line"/>
                                                                <xsl:text></xsl:text>
                                                            </xsl:when>
                                                        </xsl:choose>
                                                        <xsl:text>; as needed)</xsl:text>
                                                    </fo:inline>
                                                    <xsl:text> </xsl:text>
                                                    
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            
                                            
                                        </xsl:when>
                                        <!--  No PRN -->
                                        <xsl:otherwise>
                                            
                                            <xsl:text> </xsl:text>
                                            <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(sentence-list/sentence/display-line))!=0">
                                                    <fo:inline font-weight="normal">
                                                        <xsl:text>(</xsl:text>            
                                                        <xsl:apply-templates select="sentence-list/sentence/display-line"/>
                                                        <xsl:text>) </xsl:text>
                                                    </fo:inline>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    
                                    
                                    
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> </xsl:text>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(sentence-list/sentence/display-line))!=0">
                                    <fo:inline font-weight="normal">
                                        <xsl:text>(</xsl:text>            
                                        <xsl:apply-templates select="sentence-list/sentence/display-line"/>
                                        <xsl:text>) </xsl:text>
                                    </fo:inline>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:if test="evidence-summary-link">
                        <!-- Ah, evidence-summary-link is present process it -->
                        <xsl:call-template name="evidence-summary-link-image">
                            <xsl:with-param name="evidence-summary-link" />
                        </xsl:call-template>
                    </xsl:if>
                    
                </xsl:element>
                
            </fo:table-cell>
        </fo:table-row>
        
        <xsl:if 
            test="
            string-length($bundle-group-id)!=0
            and $bundle-group-count &gt; 1
            and sentence-list/sentence/display-line[string-length(normalize-space(.))!=0]
            and following-sibling::component[1]
            [
            normalize-space(bundle-group-id) = $bundle-group-id
            and sentence-list/sentence/display-line[string-length(normalize-space(.))!=0]
            ]
            ">
            <xsl:call-template name="four-column-3px-whiteline"/>
        </xsl:if>
        
        <xsl:if test="$bundle-group-last='true'">
            <xsl:call-template name="four-column-10px-whiteline"/>
        </xsl:if>
        
    </xsl:template>
   
   <!-- The lowest level main headings (in gray with black lettering)-->
    <xsl:template match="sub-category-list/sub-category">
        
        <xsl:call-template name="four-column-3px-whiteline"/>
        
        <fo:table-row>
            
            <!-- the spacer column on the left -->
            <fo:table-cell>
                <xsl:attribute name="border-left-style" select="string('solid')"/>
                <xsl:attribute name="border-left-color" select="string('#DBE0E4')"/>
                <xsl:attribute name="border-left" select="string('1px')"/>
                <xsl:attribute name='background-color'>#FCFCFC</xsl:attribute>
                
                <xsl:element name="fo:block">
                    <fo:block></fo:block>                    
                </xsl:element>                
            </fo:table-cell>
            
            <!-- The grey backed sub heading -->
            <fo:table-cell>
                <xsl:attribute name="number-columns-spanned"> 2 </xsl:attribute>
                <xsl:attribute name='background-color'>#DBE0E4</xsl:attribute>
                
                <xsl:element name="fo:block">
                    <xsl:attribute name="font-weight" select="string('normal')"/>
                    <xsl:attribute name='color' select="string('black')"/>
                    <xsl:attribute name="font-family" select="string('Arial')"/>
                    <xsl:attribute name="font-size" select="string('10pt')"/>
                    
                    &#160;<xsl:value-of select="caption"/>
                    <xsl:text> </xsl:text>
                    
                    <xsl:if test="evidence-summary-link">
                        <!-- Ah, evidence-summary-link is present process it -->
                        <xsl:call-template name="evidence-summary-link-image-grey">
                            <xsl:with-param name="evidence-summary-link" />
                        </xsl:call-template>                       
                    </xsl:if>
                </xsl:element>                
            </fo:table-cell>
            
            <!-- the spacer column on the right -->
            <fo:table-cell>
                <xsl:attribute name="border-right-style" select="string('solid')"/>
                <xsl:attribute name="border-right-color" select="string('#DBE0E4')"/>
                <xsl:attribute name="border-right" select="string('1px')"/>
                <xsl:attribute name='background-color'>#FCFCFC</xsl:attribute>
                
                <xsl:element name="fo:block">
                    <fo:block></fo:block>                    
                </xsl:element>                
            </fo:table-cell>
            
        </fo:table-row>    
        
        <xsl:apply-templates select="component-list/component"/>
        
        <!-- try something, this is to finish off the border round the grey boxes.. basically the line at the bottom
              of the green headers-->
            
            <xsl:if test="position()=last()">    
        <fo:table-row>
            
            <fo:table-cell>
                <xsl:attribute name="number-columns-spanned"> 4 </xsl:attribute>
                <xsl:attribute name="border-left-style" select="string('solid')"/>
                <xsl:attribute name="border-left-color" select="string('#DBE0E4')"/>
                <xsl:attribute name="border-left" select="string('1px')"/>
                
                <xsl:attribute name="border-right-style" select="string('solid')"/>
                <xsl:attribute name="border-right-color" select="string('#DBE0E4')"/>
                <xsl:attribute name="border-right" select="string('1px')"/>
                <xsl:attribute name='background-color'>#FCFCFC</xsl:attribute>
                
                <xsl:attribute name="border-bottom-style" select="string('solid')"/>
                <xsl:attribute name="border-bottom-color" select="string('#DBE0E4')"/>
                <xsl:attribute name="border-bottom" select="string('1px')"/>
                <xsl:attribute name='background-color'>#FCFCFC</xsl:attribute>
                
                <xsl:element name="fo:block">
                    <fo:block></fo:block>                    
                </xsl:element>                
            </fo:table-cell>
        </fo:table-row> 
                </xsl:if>
        
    </xsl:template> 
    
    <!-- The lowest level under the low level grey background black text headings -->
    <xsl:template match="sub-category/component-list/component">
        <xsl:variable name="bundle-group-id" select="normalize-space(bundle-group-id)"/>
        <xsl:variable name="bundle-group-count" select="count(parent::component-list/component/bundle-group-id[normalize-space(.)=$bundle-group-id])"/>
        
        <!-- find catgory name -->
        <xsl:variable name="cat"><xsl:value-of select="ancestor::category/caption"/></xsl:variable>
        
        <xsl:variable name="bundle-group-first">
            <xsl:choose>
                <xsl:when 
                    test="
                    string-length($bundle-group-id)!=0
                    and $bundle-group-count &gt; 1
                    and (
                    not(preceding-sibling::component[1])
                    or preceding-sibling::component[1][normalize-space(bundle-group-id)!=$bundle-group-id]
                    )
                    ">
                    <xsl:text>true</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>false</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="bundle-group-last">
            <xsl:choose>
                <xsl:when 
                    test="
                    string-length($bundle-group-id)!=0
                    and $bundle-group-count &gt; 1
                    and following-sibling::component[1]/bundle-group-id[string-length(normalize-space(.))!=0 and normalize-space(.)!=$bundle-group-id]
                    ">
                    <xsl:text>true</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>false</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="bundle-group">
            <xsl:choose>
                <xsl:when 
                    test="
                    string-length($bundle-group-id)!=0
                    and $bundle-group-count &gt; 1
                    ">
                    <xsl:text>true</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>false</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <fo:table-row>
            
            <!-- the spacer column on the left -->
            <fo:table-cell> 
                <xsl:attribute name="border-left-style" select="string('solid')"/>
                <xsl:attribute name="border-left-color" select="string('#DBE0E4')"/>
                <xsl:attribute name="border-left" select="string('1px')"/>
                <xsl:attribute name='background-color'>#FCFCFC</xsl:attribute>
               
                <xsl:element name="fo:block">
                    <fo:block></fo:block>                    
                </xsl:element>                
            </fo:table-cell>
            
            <!-- the checkbox column -->
            <fo:table-cell>
                <xsl:attribute name='text-align' select="string('center')"/>
                <xsl:attribute name='display-align' select="string('center')"/>
                <xsl:attribute name='background-color'>#FCFCFC</xsl:attribute>
                
                <fo:block>
                    
                    <xsl:if 
                        test="
                        (following-sibling::component[1][normalize-space(bundle-group-id)=$bundle-group-id] 
                        and $bundle-group-first='true')
                        
                        or (orderable-type='O' and $bundle-group='false')
                        ">
                        <xsl:element name="fo:external-graphic">
                            <xsl:attribute name="content-height">12%</xsl:attribute>
                            <xsl:attribute name="content-height">12%</xsl:attribute>
                            <xsl:attribute name="src">
                                <xsl:text>url('</xsl:text><xsl:value-of select="$image-action-set-check-box"/><xsl:text>')</xsl:text>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                    
                </fo:block>   
                
            </fo:table-cell>
            
            <!-- the text column -->
            <fo:table-cell>
                <xsl:attribute name="font-family" select="string('Arial')"/>
                <xsl:attribute name="font-size" select="string('10pt')"/>
                <xsl:attribute name='background-color'>#FCFCFC</xsl:attribute>
                <xsl:attribute name='display-align' select="string('center')"/>
                
                <xsl:element name="fo:block">
                    <xsl:choose>
                        <xsl:when test="default-selected=1">
                            <xsl:attribute name="font-weight" select="string('bold')"/>
                        </xsl:when>                        
                        <xsl:otherwise>
                            <xsl:attribute name="font-weight" select="string('normal')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:if test="orderable-type='L'">
                        <xsl:attribute name="padding-top" select="string('3px')"/>
                        <xsl:attribute name="font-style" select="string('italic')"/> 
                        <xsl:attribute name="padding-bottom" select="string('3px')"/>                   
                    </xsl:if>
                    
                    <xsl:if test="$bundle-group-first='true'">
                        <xsl:attribute name="font-weight" select="string('bold')"/>
                    </xsl:if>
                    
                    <xsl:if test="$bundle-group-first!='true' and $bundle-group='true'">
                        <xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
                    </xsl:if>
                    
                    <!-- Indent any occurence of 'AND' or 'OR' -->
                    <xsl:if test="caption='AND:' or caption='OR:' ">                        
                        &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
                    </xsl:if> 
                    
                    <xsl:value-of select="caption"/>
                    
                    <xsl:choose>
                        <xsl:when test="($cat = 'Medications') or ($cat = 'IV Fluids')">
                            <xsl:choose>
                                <xsl:when test="sentence-list/sentence/details-list/details[child::field-mean[text() = 'SPECINX']]">
                                    
                                    <!-- Is there a PRN -->
                                    <xsl:choose>
                                        <!-- PRN found -->
                                        <xsl:when test="sentence-list/sentence/details-list/details[child::field-mean[text() = 'SCH/PRN']]">
                                            <!-- Does the PRN have a reason  -->
                                            <xsl:choose>
                                                <xsl:when test="sentence-list/sentence/details-list/details[child::field-mean[text() = 'PRNREASON']]">
                                                    
                                                    <xsl:text> </xsl:text>
                                                    <fo:inline font-weight="normal">
                                                        <xsl:text>(</xsl:text>            
                                                        <xsl:choose>
                                                            <xsl:when test="string-length(normalize-space(sentence-list/sentence/display-line))!=0">
                                                                <xsl:apply-templates select="sentence-list/sentence/display-line"/>
                                                                <xsl:text>, </xsl:text>
                                                            </xsl:when>
                                                        </xsl:choose>
                                                        <xsl:value-of select="sentence-list/sentence/details-list/details[child::field-mean[text() = 'SPECINX']]/field-display-value"/>
                                                        <xsl:text>; </xsl:text>
                                                        <xsl:value-of select="sentence-list/sentence/details-list/details[child::field-mean[text() = 'PRNREASON']]/field-display-value"/>
                                                        <xsl:text>)</xsl:text>
                                                    </fo:inline>
                                                    <xsl:text> </xsl:text>
                                                    
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <!-- This the as needed version -->
                                                    
                                                    <xsl:text> </xsl:text>
                                                    <fo:inline font-weight="normal">
                                                        <xsl:text>(</xsl:text>            
                                                        <xsl:choose>
                                                            <xsl:when test="string-length(normalize-space(sentence-list/sentence/display-line))!=0">
                                                                <xsl:apply-templates select="sentence-list/sentence/display-line"/>
                                                                <xsl:text>, </xsl:text>
                                                            </xsl:when>
                                                        </xsl:choose>
                                                        <xsl:value-of select="sentence-list/sentence/details-list/details[child::field-mean[text() = 'SPECINX']]/field-display-value"/>
                                                        <xsl:text>; as needed)</xsl:text>
                                                    </fo:inline>
                                                    <xsl:text> </xsl:text>
                                                    
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text> </xsl:text>
                                            <fo:inline font-weight="normal">
                                                <xsl:text>(</xsl:text>            
                                                <xsl:choose>
                                                    <xsl:when test="string-length(normalize-space(sentence-list/sentence/display-line))!=0">
                                                        <xsl:apply-templates select="sentence-list/sentence/display-line"/>
                                                        <xsl:text>, </xsl:text>
                                                    </xsl:when>
                                                </xsl:choose>
                                                <xsl:value-of select="sentence-list/sentence/details-list/details[child::field-mean[text() = 'SPECINX']]/field-display-value"/>
                                                <xsl:text>)</xsl:text>
                                            </fo:inline>
                                            <xsl:text> </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- Is there a PRN ? -->
                                    <xsl:choose>
                                        <xsl:when test="sentence-list/sentence/details-list/details[child::field-mean[text() = 'SCH/PRN']]">
                                            
                                            <!-- Does the PRN have a reason  -->
                                            <xsl:choose>
                                                <xsl:when test="sentence-list/sentence/details-list/details[child::field-mean[text() = 'PRNREASON']]">
                                                    
                                                    <xsl:text> </xsl:text>
                                                    <fo:inline font-weight="normal">
                                                        <xsl:text>(</xsl:text>            
                                                        <xsl:choose>
                                                            <xsl:when test="string-length(normalize-space(sentence-list/sentence/display-line))!=0">
                                                                <xsl:apply-templates select="sentence-list/sentence/display-line"/>
                                                                <xsl:text>; </xsl:text>
                                                            </xsl:when>
                                                        </xsl:choose>
                                                        <xsl:value-of select="sentence-list/sentence/details-list/details[child::field-mean[text() = 'PRNREASON']]/field-display-value"/>
                                                        <xsl:text>)</xsl:text>
                                                    </fo:inline>
                                                    <xsl:text> </xsl:text>
                                                    
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <!-- This the as needed version -->
                                                    
                                                    <xsl:text> </xsl:text>
                                                    <fo:inline font-weight="normal">
                                                        <xsl:text>(</xsl:text>            
                                                        <xsl:choose>
                                                            <xsl:when test="string-length(normalize-space(sentence-list/sentence/display-line))!=0">
                                                                <xsl:apply-templates select="sentence-list/sentence/display-line"/>
                                                                <xsl:text></xsl:text>
                                                            </xsl:when>
                                                        </xsl:choose>
                                                        <xsl:text>; as needed)</xsl:text>
                                                    </fo:inline>
                                                    <xsl:text> </xsl:text>
                                                    
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            
                                            
                                        </xsl:when>
                                        <!--  No PRN -->
                                        <xsl:otherwise>
                                            <xsl:text> </xsl:text>
                                            <xsl:choose>
                                                <xsl:when test="string-length(normalize-space(sentence-list/sentence/display-line))!=0">
                                                    <fo:inline font-weight="normal">
                                                        <xsl:text>(</xsl:text>            
                                                        <xsl:apply-templates select="sentence-list/sentence/display-line"/>
                                                        <xsl:text>) </xsl:text>
                                                    </fo:inline>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    
                                    
                                    
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> </xsl:text>
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(sentence-list/sentence/display-line))!=0">
                                    <fo:inline font-weight="normal">
                                        <xsl:text>(</xsl:text>            
                                        <xsl:apply-templates select="sentence-list/sentence/display-line"/>
                                        <xsl:text>) </xsl:text>
                                    </fo:inline>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    
                    
                    <xsl:if test="evidence-summary-link">
                        <!-- Ah, evidence-summary-link is present process it -->
                        <xsl:call-template name="evidence-summary-link-image">
                            <xsl:with-param name="evidence-summary-link" />
                        </xsl:call-template>
                    </xsl:if>
                    
                </xsl:element>                
            </fo:table-cell>
            
            <!-- the spacer column on the right -->
            <fo:table-cell> 
                <xsl:attribute name="border-right-style" select="string('solid')"/>
                <xsl:attribute name="border-right-color" select="string('#DBE0E4')"/>
                <xsl:attribute name="border-right" select="string('1px')"/>
                <xsl:attribute name='background-color'>#FCFCFC</xsl:attribute>
                
                <xsl:element name="fo:block">
                    <fo:block></fo:block>                    
                </xsl:element>                
            </fo:table-cell>
            
        </fo:table-row>
        
        <xsl:if 
            test="
            string-length($bundle-group-id)!=0
            and $bundle-group-count &gt; 1
            and sentence-list/sentence/display-line[string-length(normalize-space(.))!=0]
            and following-sibling::component[1]
            [
            normalize-space(bundle-group-id) = $bundle-group-id
            and sentence-list/sentence/display-line[string-length(normalize-space(.))!=0]
            ]
            ">
            <xsl:call-template name="four-column-3px-whiteline"/>
        </xsl:if>
        
        <xsl:if test="$bundle-group-last='true'">
            <xsl:call-template name="four-column-10px-whiteline"/>
        </xsl:if>
        
    </xsl:template> 
    
    <!-- Displays the bmjid at the top of the page  just below the main title (That is displayed in blue)
           Right justified-->
    <xsl:template match="@bmj-id">
               
                <xsl:element name="fo:block">
                    <xsl:attribute name='color' select="string('#D6006E')"/>
                    <xsl:attribute name="font-size" select="string('9pt')"/>
                    <xsl:attribute name=' text-align' select="string('right')"/>
                    <xsl:attribute name="font-family" select="string('Arial')"/>
                    
                    <xsl:value-of select="."/>
                </xsl:element>
      
    </xsl:template>
    
    <xsl:template name="Bottom-Level-Of-Table">
        <fo:table-row>
            <fo:table-cell>                
                <xsl:attribute name="number-columns-spanned"> 4 </xsl:attribute>
                <xsl:attribute name='background-color'>white</xsl:attribute>
               
                <!-- A 16px high blank line is required here -->
                <xsl:element name="fo:block" use-attribute-sets="font-16px"> 
                    <xsl:text>&#160;</xsl:text>
                </xsl:element>
                
                <xsl:element name="fo:block" use-attribute-sets="font-16px">  
       		        <xsl:text>Â© BMJ Publishing Group Limited 2012. All rights reserved.</xsl:text>
                </xsl:element>
                
                <xsl:element name="fo:block">
                    <xsl:attribute name="font-weight" select="string('normal')"/>
                    <xsl:attribute name="font-size" select="string('7pt')"/>
                    <xsl:attribute name="font-family" select="string('Arial')"/>
                    <!--  <xsl:attribute name="keep-together">always</xsl:attribute>-->
                    <xsl:text>Disclaimer: This content is meant for use by medical professionals. The BMJ Publishing Group Ltd (â€˜BMJ Groupâ€™) tries to ensure that the information provided is accurate and up-to-date, 
                        but we do not warrant that it is. The BMJ Group does not advocate or endorse the use of any drug or therapy contained within nor does it diagnose patients. 
                        Medical professionals should use their own professional judgement in using this information and caring for their patients and the information herein should not be considered a substitute for that. 
                        This information is not intended to cover all possible diagnosis methods, evidence, treatments, follow up, drugs and any contraindications or side effects. 
                        We strongly recommend that users independently verify specified diagnosis, evidence, treatments and follow up and ensure it is up to date and appropriate for your patient.
                        This information is provided on as â€˜as isâ€™ basis and to the fullest extent permitted by law the BMJ Group assumes no responsibility for any aspect of healthcare administered with the 
                        aid of this information or any other use of this information.</xsl:text>
                </xsl:element>
                
            </fo:table-cell>
        </fo:table-row>
      
    </xsl:template> 
    
    <!-- Displays the evidence link (EDV) as an image (the default version)
        We recieve an element that looks like this:    <evidence-summary-link hash="164817-3" id=""  target="../evidence-summary/evidence-summary-1241532732311_en-gb.xml"/>
        And want to make a link that looks like this: http://evidencesummary.bmj.com/x/en-us/evidence-summary-1241532732311.html#164817-3
        The language is obtained from the root attribute 'language'
    -->
    <xsl:template name="evidence-summary-link-image">
        <xsl:param name="evidence-summary-link" />
        
        <xsl:variable name="substringURL" select="substring-after(evidence-summary-link/@target, '../evidence-summary')"/>
        
        <xsl:element name="fo:basic-link">
            
            <xsl:attribute name="external-destination">
                
                <xsl:if test="$format='rtf'">
                    <xsl:value-of select="$base-url"/>
                    <xsl:text>/x/</xsl:text>
                    <xsl:text>sign-in.html?fwdUrl=</xsl:text>
                </xsl:if>
                
                <xsl:value-of select="$base-url"/>
                <xsl:text>/x/</xsl:text>
                <xsl:value-of select="//action-set/@language"/>
                
                <!-- In some instances the '_en-gb' portion of the target will not be present - handle this accordingly -->
                <xsl:choose>
                    <xsl:when test="contains(evidence-summary-link/@target , '_en-gb' )">
                        <xsl:value-of select="substring-before($substringURL,'_en-gb.xml')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-before($substringURL,'.xml')"/>        
                    </xsl:otherwise>
                </xsl:choose>
                
                <xsl:text>.html#</xsl:text>
                <xsl:value-of select="evidence-summary-link/@hash"/>
                
            </xsl:attribute>
            
            <xsl:attribute name="font-size" select="string('6pt')" />
            <xsl:attribute name="font-weight" select="string('normal')" />
            <xsl:attribute name="font-style" select="string('italic')"/>
            <xsl:attribute name="text-decoration" select="string('underline')" />
            
            <xsl:text>EVD</xsl:text>  
            
        </xsl:element>
        
    </xsl:template>
  
    <!-- Displays the evidence link (EDV) as an image (the green version)
           We recieve an element that looks like this:    <evidence-summary-link hash="164817-3" id=""  target="../evidence-summary/evidence-summary-1241532732311_en-gb.xml"/>
           And want to make a link that looks like this: http://evidencesummary.bmj.com/x/en-us/evidence-summary-1241532732311.html#164817-3
           The language is obtained from the root attribute 'language'
    -->
    <xsl:template name="evidence-summary-link-image-green">
        <xsl:param name="evidence-summary-link" />
        
        <xsl:variable name="substringURL" select="substring-after(evidence-summary-link/@target, '../evidence-summary')"/>
        
        <xsl:element name="fo:basic-link">
            
            <xsl:attribute name="external-destination">
                
                <xsl:if test="$format='rtf'">
                    <xsl:value-of select="$base-url"/>
                    <xsl:text>/x/</xsl:text>
                    <xsl:text>sign-in.html?fwdUrl=</xsl:text>
                </xsl:if>
                
                <xsl:value-of select="$base-url"/>
                <xsl:text>/x/</xsl:text>
                <xsl:value-of select="//action-set/@language"/>
                
                <!-- In some instances the '_en-gb' portion of the target will not be present - handle this accordingly -->
                <xsl:choose>
                    <xsl:when test="contains(evidence-summary-link/@target , '_en-gb' )">
                        <xsl:value-of select="substring-before($substringURL,'_en-gb.xml')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-before($substringURL,'.xml')"/>        
                    </xsl:otherwise>
                </xsl:choose>
                
                <xsl:text>.html#</xsl:text>
                <xsl:value-of select="evidence-summary-link/@hash"/>
                
            </xsl:attribute>
            
	        <xsl:attribute name="font-size" select="string('6pt')" />
            <xsl:attribute name="font-weight" select="string('normal')" />
            <xsl:attribute name="font-style" select="string('italic')"/>
            <xsl:attribute name="text-decoration" select="string('underline')" />
            
            <xsl:text>EVD</xsl:text>
            
        </xsl:element>
            
    </xsl:template>
    
    <!-- Displays the evidence link (EDV) as an image (the grey version)
        We recieve an element that looks like this:    <evidence-summary-link hash="164817-3" id=""  target="../evidence-summary/evidence-summary-1241532732311_en-gb.xml"/>
        And want to make a link that looks like this: http://evidencesummary.bmj.com/x/en-us/evidence-summary-1241532732311.html#164817-3
        The language is obtained from the root attribute 'language'
    -->
    <xsl:template name="evidence-summary-link-image-grey">
        <xsl:param name="evidence-summary-link" />
        
        <xsl:variable name="substringURL" select="substring-after(evidence-summary-link/@target, '../evidence-summary')"/>
        
        <xsl:element name="fo:basic-link">
            
            <xsl:attribute name="external-destination">
                
                <xsl:if test="$format='rtf'">
                    <xsl:value-of select="$base-url"/>
                    <xsl:text>/x/</xsl:text>
                    <xsl:text>sign-in.html?fwdUrl=</xsl:text>
                </xsl:if>
                
                <xsl:value-of select="$base-url"/>
                <xsl:text>/x/</xsl:text>
                <xsl:value-of select="//action-set/@language"/>
                
                <!-- In some instances the '_en-gb' portion of the target will not be present - handle this accordingly -->
                <xsl:choose>
                    <xsl:when test="contains(evidence-summary-link/@target , '_en-gb' )">
                        <xsl:value-of select="substring-before($substringURL,'_en-gb.xml')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-before($substringURL,'.xml')"/>        
                    </xsl:otherwise>
                </xsl:choose>
                
                <xsl:text>.html#</xsl:text>
                <xsl:value-of select="evidence-summary-link/@hash"/>
                
            </xsl:attribute>
            
            <xsl:attribute name="font-size" select="string('6pt')" />
            <xsl:attribute name="font-weight" select="string('normal')" />
            <xsl:attribute name="font-style" select="string('italic')"/>
            <xsl:attribute name="text-decoration" select="string('underline')" />
            
            <xsl:text>EVD</xsl:text>
            
        </xsl:element>  
        
    </xsl:template>
    
    
    <!-- Creates a four column wide wite line for seperating content 3px high-->
    <xsl:template name="four-column-3px-whiteline">
        
        <fo:table-row> 
            <fo:table-cell><!-- White thin, cut through line -->
                <xsl:attribute name="number-columns-spanned">4 </xsl:attribute>
                <xsl:attribute name='background-color'>#FCFCFC</xsl:attribute>
                
                <xsl:attribute name="border-left-style" select="string('solid')"/>
                <xsl:attribute name="border-left-color" select="string('#DBE0E4')"/>
                <xsl:attribute name="border-left" select="string('1pt')"/>
                
                <xsl:attribute name="border-right-style" select="string('solid')"/>
                <xsl:attribute name="border-right-color" select="string('#DBE0E4')"/>
                <xsl:attribute name="border-right" select="string('1pt')"/>
                
                <xsl:element name="fo:block">  <!-- block required to satisfy parser -->
                    <xsl:attribute name="font-size" select="string('3pt')"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:element>
            </fo:table-cell>
        </fo:table-row> 
        
    </xsl:template>
    
    <!-- Creates a three column wide white line for seperating content 10px high-->
    <xsl:template name="three-column-10px-whiteline">
        
        <fo:table-row> 
            <fo:table-cell><!-- White thin, cut through line -->
                <xsl:attribute name="number-columns-spanned">3 </xsl:attribute>
                <xsl:attribute name='background-color'>white</xsl:attribute>
                
                <xsl:element name="fo:block">  <!-- block required to satisfy parser -->
                    <xsl:attribute name="font-size" select="string('8pt')"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:element>
            </fo:table-cell>
        </fo:table-row> 
        
    </xsl:template>
    
    <!-- Creates a four column wide white line for seperating content 10px high-->
    <xsl:template name="four-column-10px-whiteline">
        
        <fo:table-row> 
            <fo:table-cell><!-- White thin, cut through line -->
                <xsl:attribute name="number-columns-spanned">4 </xsl:attribute>
                <xsl:attribute name='background-color'>white</xsl:attribute>
                
                <xsl:element name="fo:block">  <!-- block required to satisfy parser -->
                    <xsl:attribute name="font-size" select="string('10pt')"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:element>
            </fo:table-cell>
        </fo:table-row> 
        
    </xsl:template>
    
    <!-- Creates a three column wide white line for seperating content 15px high-->
    <xsl:template name="three-column-15px-whiteline">
        
        <fo:table-row> 
            <fo:table-cell><!-- White thin, cut through line -->
                <xsl:attribute name="number-columns-spanned">3 </xsl:attribute>
                <xsl:attribute name='background-color'>white</xsl:attribute>
                
                <xsl:element name="fo:block">  <!-- block required to satisfy parser -->
                    <xsl:attribute name="font-size" select="string('15pt')"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:element>
            </fo:table-cell>
        </fo:table-row> 
        
    </xsl:template>
    
    <!-- This displays the extra text that is sometimes present in normal weight surrounded by brackets -->
    <xsl:template match="display-line">
        
        <xsl:variable name="disline"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
        
        <xsl:choose>
            <!-- has a duration and duration unit - need to tart them up -->
            <xsl:when test="./parent::node()/details-list/details[child::field-mean[normalize-space(text()) = 'DURATION']] and ./parent::node()/details-list/details[child::field-mean[normalize-space(text()) = 'DURATIONUNIT']]">

                <xsl:variable name="duration"><xsl:value-of select="normalize-space(./parent::node()/details-list/details[child::field-mean[normalize-space(text()) = 'DURATION']]/field-display-value)"/></xsl:variable>
                <xsl:variable name="dur-unit"><xsl:value-of select="normalize-space(./parent::node()/details-list/details[child::field-mean[normalize-space(text()) = 'DURATIONUNIT']]/field-display-value)"/></xsl:variable>
                <xsl:variable name="space-dur-unit"><xsl:value-of select="concat(' ',$dur-unit)"/></xsl:variable>
                

                <xsl:choose>
                    
                    <!-- Only carry on if the display line actually contains the data if not we will not be able to manipulate it -->
                    <xsl:when test="contains($disline, $duration) and contains($disline, $dur-unit)">
                        
                        <!-- does it have frequency? -->
                        <xsl:choose>
                            
                            <!-- has frequency -->
                            <xsl:when test="./parent::node()/details-list/details[child::field-mean[normalize-space(text()) = 'FREQ']]">
                                
                                <xsl:variable name="freq"><xsl:value-of select="normalize-space(./parent::node()/details-list/details[child::field-mean[normalize-space(text()) = 'FREQ']]/field-display-value)"/></xsl:variable>
                                <xsl:variable name="space-freq"><xsl:value-of select="concat(' ',$freq)"/></xsl:variable>

                                <!-- Only carry on if the display line actually contains the data if not we will not be able to manipulate it -->
                                <xsl:choose>
                                    
                                    <xsl:when test="contains($disline, $freq)">

                                        <!-- is freq the last item -->
                                        <xsl:choose>
                                            <!-- freq is last item -->
                                            
                                            <xsl:when test="substring($disline, (string-length($disline) - string-length($space-freq)) + 1) = $space-freq">
                                                
                                                <!-- no other data so returning FREQ + " for " + DURATION + DURATIONUNIT -->
                                                <xsl:value-of select="concat($freq,' for ',$duration,$dur-unit)"/>
                                                
                                            </xsl:when>
                                            
                                            <!-- freq is Not last item -->
                                            <xsl:otherwise>
                                                
                                                <!-- there is other data so need to remove this  before rebuilding the string -->
                                                
                                                <!-- remove duration; -->
                                                <xsl:variable name="string1" select="replace($disline, concat($duration,';'),'')"/>
                                                <!-- remove duration unit; -->
                                             <!--    <xsl:variable name="string2" select="replace($string1, concat(' ',$dur-unit,';'),'')"/> -->
                                                <!-- remove freq; -->
                                                <!-- <xsl:variable name="string3" select="normalize-space(replace($string2, concat($freq,';'),''))"/>-->
                                                <!--  updated string2 and string3 values to escape the ( and ) charecters if present in dur-unit and freq -->
                                                 <xsl:variable name="rb">(</xsl:variable>
                                                <xsl:variable name="lb">)</xsl:variable>
                                                <xsl:variable name="string2" select="replace($string1, concat(' ',replace(replace ($dur-unit, concat('\', $rb), concat('\\', $rb)), concat('\', $lb), concat('\\', $lb)),';'),'')"/>
                                                <!-- remove freq; -->
                                                <xsl:variable name="string3" select="normalize-space(replace($string2, concat(replace(replace ($freq, concat('\', $rb), concat('\\', $rb)), concat('\', $lb), concat('\\', $lb)),';'),''))"/>
                                              
                                                <!-- reconstruct in preferred format FREQ + " for " + DURATION + DURATIONUNIT + "; " + String -->   
                                                <xsl:value-of select="concat($freq,' for ',$duration,$dur-unit,'; ',$string3)"/>
                                                
                                            </xsl:otherwise>
                                            
                                        </xsl:choose>                                        
                                    </xsl:when>
                                    
                                    <!-- display line does not contain the data so no action -->
                                    <xsl:otherwise>
                                        <xsl:value-of select="$disline"/>
                                    </xsl:otherwise>
                                    
                                </xsl:choose>
                                
                            </xsl:when>
                            
                            <!-- no frequency -->
                            <xsl:otherwise>
                                
                                <!-- is dur unit the last item -->
                                <xsl:choose>
                                    <!-- dur unit is last item -->
                                    <xsl:when test="substring($disline, (string-length($disline) - string-length($space-dur-unit)) + 1) = $space-dur-unit">
                                        
                                        <!-- no other data so returning "for " + DURATION + DURATIONUNIT -->
                                        <xsl:value-of select="concat('for ',$duration,$dur-unit)"/>
                                        
                                    </xsl:when>
                                    
                                    <!-- dur unit is Not last item -->
                                    <xsl:otherwise>
                                        
                                        <!-- there is other data so need to remove this  before rebuilding the string -->
                                        
                                        <!-- remove duration; -->
                                        <xsl:variable name="string1" select="replace($disline, concat($duration,';'),'')"/>
                                        <!-- remove duration unit; -->
                                        <!-- <xsl:variable name="string2" select="normalize-space(replace($string1, concat(' ',$dur-unit,';'),''))"/> -->
                                        <!-- Updated for Mantis ID 12636 -->
                                         <xsl:variable name="rb">(</xsl:variable>
                                                <xsl:variable name="lb">)</xsl:variable>
                                                <xsl:variable name="string2" select="replace($string1, concat(' ',replace(replace ($dur-unit, concat('\', $rb), concat('\\', $rb)), concat('\', $lb), concat('\\', $lb)),';'),'')"/>
                                              
                                         
                                        <!-- reconstruct in preferred format " for " + DURATION + DURATIONUNIT + "; " + String -->   
                                        <xsl:value-of select="concat('for ',$duration,$dur-unit,'; ',$string2)"/>
                                        
                                    </xsl:otherwise>
                                    
                                </xsl:choose>
                                
                                
                                
                            </xsl:otherwise>
                            
                        </xsl:choose>                        
                        
                    </xsl:when>
                    
                    <!-- display line does not contain the data so no action -->
                    <xsl:otherwise>
                        <xsl:value-of select="$disline"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:when>
            
            <!-- no duration and unit so return data as is -->
            <xsl:otherwise>
                <xsl:value-of select="$disline"/>
            </xsl:otherwise>

        </xsl:choose>
        
        

    </xsl:template>
    
  <!-- Added the below template for Mantis ID 12636 to display the Scope from the evidence summary into Action sets page -->
    <xsl:template match="//esp-ids/esp-id">
    <xsl:call-template  name="four-column-10px-whiteline"/>
   
    	<xsl:apply-templates select="//action-set/caption"/> 
      	
             <fo:table-row>
            <fo:table-cell number-columns-spanned=" 4 " border-left-style="solid" border-left-color="#DBE0E4" border-left="1px"
            border-right-style="solid" border-right-color="#DBE0E4" border-right="1px"
                                                background-color="#FCFCFC"
                                                text-align="center"
                                                display-align="center">
                                    <fo:block> &#160;</fo:block>
                                 </fo:table-cell></fo:table-row>
   
   
  <!--   <fo:table-row>
                                 <fo:table-cell number-columns-spanned=" 4 " background-color="#00A6D6">
                                    <fo:block padding-top="2pt" padding-bottom="2pt" font-weight="normal" font-family="Arial"
                                              color="white"
                                              font-size="11pt">
                                       
                     Scope </fo:block></fo:table-cell></fo:table-row>
                                   
         
        
        <fo:table-row>     
             <fo:table-cell border-left-style="solid" border-left-color="#DBE0E4" border-left="1px"
                                                background-color="#FCFCFC"
                                                text-align="center"
                                                display-align="center">
                                    <fo:block/>
                                 </fo:table-cell>
            
                 <fo:table-cell number-columns-spanned=" 3 " border-right-style="solid"
                                                border-right-color="#DBE0E4"
                                                border-right="1pt"
                                                background-color="#FCFCFC"
                                                font-family="Arial"
                                                font-size="10pt"
                                                display-align="center">
                                   <fo:block font-weight="normal" padding-top="3px" font-style="italic" padding-bottom="3px">
                    &#160; <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
              
                    <xsl:variable name="includedFileName">
                        <xsl:value-of disable-output-escaping="yes" select="concat($xmlstore-url, '/getDocument.html?id=evidence-summary-', ., '&amp;db=BMJK', '&amp;library=ESP/', //action-set/@language)" >
                    </xsl:value-of>
                    
                     </xsl:variable>
                     	<xsl:choose>
						<xsl:when test="document($includedFileName)">
						<xsl:value-of select="document($includedFileName)//summary-info/scope" disable-output-escaping="yes"></xsl:value-of>
						</xsl:when>
						<xsl:otherwise> -->
						<!-- If document does not exist then display not able to open  message -->
					<!-- 	<xsl:value-of select="'Not able to open the evidence summary '"></xsl:value-of>
						
						</xsl:otherwise>
						
					</xsl:choose>
					    <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
              </fo:block>
            
                
            </fo:table-cell>
                       
        </fo:table-row> -->
        
  <xsl:apply-templates select="//category-list/category[./caption/text()='Condition']/component-list/component">
          
        </xsl:apply-templates>
        
       
       
       
        </xsl:template>
  
  
    <!-- Look into using attribute-sets to reduce the code complexity 
        <xsl:element name="fo:block" use-attribute-sets="font-16px">-->
    <xsl:attribute-set name="font-16px">
        <xsl:attribute name="font-weight" select="string('normal')"/>
        <xsl:attribute name="font-size" select="string('16pt')"/>
        <xsl:attribute name='color' select="string('#00A6D6')"/>
        <xsl:attribute name="font-family" select="string('Arial')"/>
    </xsl:attribute-set>
    
    <!-- 9px font with a 4pt padding top and bottom 
        <xsl:element name="fo:block" use-attribute-sets="font-9px-with-4px-padding"> -->
    <xsl:attribute-set name="font-9px-with-4px-padding">
        <xsl:attribute name="padding-top" select="string('4pt')"/>
        <xsl:attribute name="padding-bottom" select="string('4pt')"/>  
        <xsl:attribute name="font-size" select="string('9pt')"/>
        <xsl:attribute name='text-align' select="string('left')"/>
        <xsl:attribute name="font-family" select="string('Arial')"/>
    </xsl:attribute-set>
    
</xsl:stylesheet>
                                                                                                                                                                                                                                         

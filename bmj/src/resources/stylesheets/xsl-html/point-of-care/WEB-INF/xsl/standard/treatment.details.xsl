<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    version="2.0">

  <xsl:import href="../libs/general-lib.xsl" />
  <xsl:import href="../libs/functions-lib.xsl" />

  <!-- request context path -->
  <xsl:param name="ctxPath" />

  <!-- text for title bar -->
  <xsl:param name="monographTitle" />
  <xsl:param name="monographId" />
  
  <xsl:output method="html" omit-xml-declaration="yes" />
  
  <xsl:template match="*:xquery-result">
    <html>
      <head>                      
        <title>
          <xsl:value-of select="$monographTitle" />
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">treatment</xsl:with-param>
					</xsl:call-template>
		          - <xsl:call-template name="translate">
						<xsl:with-param name="messagekey">treatment.details</xsl:with-param>
					</xsl:call-template>	
				  -
          <xsl:value-of select="'Best Practice'" />
        </title>
      </head>
      <body>
        <div class="body-copy">
            <div class="treatment-options allopenable expandable-section" id="treatment-options"> 
                    <h2>Treatment Options</h2>
                    <xsl:apply-templates/>
            </div>  
        </div>
        <!-- /body copy -->
        <div class="clear">
          <!-- x -->
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="timeframes">
       <xsl:for-each select="timeframe">
         <xsl:if test="./*">
           <xsl:variable name="timeframe">
             <xsl:value-of select="@type" />
           </xsl:variable>
           <div>
           <table>
               <thead></thead>
               <caption>
                    <xsl:attribute name="class">
                        <xsl:call-template name="to-lower">
				          <xsl:with-param name="toconvert" select="$timeframe"/>
				        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:value-of select="$timeframe"/>
               </caption>
               <tbody>
                   <tr>
                       <th class="first-column">Patient Group</th>
                       <th class="second-column"><p>Tx Line</p></th>
                       <th class="third-column">Treatment <span tabindex="45" class="showall expand-all" style="cursor: pointer;">show all</span></th>
                   </tr>
                   <xsl:for-each select="pt-groups/pt-group">
                       <xsl:call-template name="patient-group-template">
                            <xsl:with-param name="ptGroup" select="." />
                       </xsl:call-template>
                   </xsl:for-each>
               </tbody>
            </table>  
            </div>
          </xsl:if>
            
       </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="treatment-line">
    <xsl:param name="treatmentLine"/>
    
      <xsl:choose>
          <xsl:when test="$treatmentLine='1'">1st</xsl:when>
          <xsl:when test="$treatmentLine='2'">2nd</xsl:when>
          <xsl:when test="$treatmentLine='3'">3rd</xsl:when>
          <xsl:when test="$treatmentLine='4'">4th</xsl:when>
          <xsl:when test="$treatmentLine='5'">5th</xsl:when>
          <xsl:when test="$treatmentLine='6'">6th</xsl:when>
          <xsl:when test="$treatmentLine='7'">7th</xsl:when>
          <xsl:when test="$treatmentLine='8'">8th</xsl:when>
          <xsl:when test="$treatmentLine='9'">9th</xsl:when>
          <xsl:when test="$treatmentLine='10'">10th</xsl:when>
          <xsl:when test="$treatmentLine='A'">
              <xsl:variable name="tooltip1">
                  <xsl:call-template name="translate">
                      <xsl:with-param name="messagekey">body.treatment.details.patientgroup.tooltip1</xsl:with-param>
                  </xsl:call-template>
              </xsl:variable>
              <xsl:element name="div">
                  <xsl:attribute name="class">treatment-line jstooltip</xsl:attribute>
                  <xsl:attribute name="title"><xsl:value-of select="$tooltip1"/></xsl:attribute>
                  <xsl:call-template name="translate">
                      <xsl:with-param name="messagekey">body.treatment.details.patientgroup.adjunct</xsl:with-param>
                  </xsl:call-template>            
                  <p class="info"><span>[?]</span></p>
              </xsl:element>
          </xsl:when>
          <xsl:when test="$treatmentLine='P'">
              <xsl:variable name="tooltip2">
                  <xsl:call-template name="translate">
                      <xsl:with-param name="messagekey">body.treatment.details.patientgroup.tooltip2</xsl:with-param>
                  </xsl:call-template>
              </xsl:variable>
              <xsl:element name="div">
                  <xsl:attribute name="class">treatment-line jstooltip</xsl:attribute>
                  <xsl:attribute name="title"><xsl:value-of select="$tooltip2"/></xsl:attribute>
                  <xsl:call-template name="translate">
                      <xsl:with-param name="messagekey">body.treatment.details.patientgroup.plus</xsl:with-param>
                  </xsl:call-template>                        
                  <p class="info"><span>[?]</span></p>
              </xsl:element>    
          </xsl:when>
          <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
      
  </xsl:template>
  
  <xsl:template name="treatment-template">
      <xsl:param name="ptGroupName"/>
      <xsl:param name="ptGroupPos"/>
      <xsl:param name="ptGroupLastPos"/>
      <xsl:param name="ptGroupType"/>
      <xsl:param name="hasChildren"/>
      <xsl:param name="isLastParentPtGroup"/>
      
      <tr>
           <xsl:choose>
                <xsl:when test="$ptGroupType='parent'">
                   <xsl:choose>
	                   <xsl:when test="position()=last() and $isLastParentPtGroup = 'false' and $hasChildren = 'false'">
	                      <xsl:choose>
				              <xsl:when test="position()=1">
					              <xsl:attribute name="class">
					                 <xsl:value-of select="'patient-group-first group-end'"/>
					              </xsl:attribute>
				              </xsl:when>   
				              <xsl:otherwise>
				                 <xsl:attribute name="class">
	                                 <xsl:value-of select="'group-end'"/>
	                              </xsl:attribute>
	                          </xsl:otherwise>
	                      </xsl:choose>
			           </xsl:when>
			           <xsl:when test="position()=1">
	                       <xsl:attribute name="class">
	                          <xsl:value-of select="'patient-group-first'"/>
	                       </xsl:attribute>
	                   </xsl:when>   
                   </xsl:choose>         
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="position()=last() and $ptGroupPos = $ptGroupLastPos and $isLastParentPtGroup != 'true'">
                      <xsl:attribute name="class">
                         <xsl:value-of select="'group-end'"/>
                      </xsl:attribute>
                   </xsl:if>
                </xsl:otherwise>
           </xsl:choose>
          <td>
            <xsl:choose>
                <xsl:when test="$ptGroupType='parent'">
                    <xsl:choose>
		                <xsl:when test="position() = 1 and $hasChildren = 'false'">
		                    <xsl:attribute name="class">
                                <xsl:value-of select="'patient-group-parent patient-group-parent-single'"/>
                            </xsl:attribute>
                            <p><xsl:value-of select="$ptGroupName"/></p>
		                </xsl:when>
		                <xsl:when test="position() = 1 and $hasChildren = 'true'">
                            <xsl:attribute name="class">
                                <xsl:value-of select="'patient-group-parent'"/>
                            </xsl:attribute>
                            <p><xsl:value-of select="$ptGroupName"/></p>
                        </xsl:when>
		                <xsl:otherwise>
		                    <xsl:choose>
			                    <xsl:when test="position()!= 1 and $hasChildren = 'false'">
	                                <xsl:attribute name="class">
	                                    <xsl:value-of select="'middle blank-end'"/>
	                                </xsl:attribute>
	                            </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="'middle'"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
		                </xsl:otherwise>
		            </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="position()= 1">
                            <xsl:choose>
                                <xsl:when test="$ptGroupPos = $ptGroupLastPos">
                                    <xsl:attribute name="class">
		                                <xsl:value-of select="'patient-subgroup-end'"/>
		                            </xsl:attribute>     
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="'patient-subgroup-middle'"/>
                                    </xsl:attribute>   
                                </xsl:otherwise>
                            </xsl:choose>
                            <p><xsl:value-of select="$ptGroupName"/></p>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="class">
                                <xsl:value-of select="'middle'"/>
                            </xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="position()!= 1 and $ptGroupPos = $ptGroupLastPos">
		                            <xsl:attribute name="class">
		                                <xsl:value-of select="'middle blank-end'"/>
		                            </xsl:attribute>
	                            </xsl:when>
	                            <xsl:otherwise>
	                               <xsl:attribute name="class">
                                        <xsl:value-of select="'middle'"/>
                                    </xsl:attribute>
	                            </xsl:otherwise>
	                        </xsl:choose>
	                        
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    
                </xsl:otherwise>
            </xsl:choose>
            
                  
            
          </td>
          
          <td>  
                <xsl:call-template name="treatment-line">
                     <xsl:with-param name="treatmentLine" select="../@tx-line" as="xs:string" />
                </xsl:call-template>
          </td>
          <td class="third-column">
            <dl class="expandable">
                <dt tabindex="45">
                  <xsl:apply-templates select="tx-type" />
                  <a class="expandable-anchor">
                    <xsl:attribute name="id">
                      <xsl:value-of select="'expsec-'" />
                      <xsl:value-of select="@id" />
                    </xsl:attribute>
                    <xsl:attribute name="name">
                      <xsl:value-of select="'expsec-'" />
                      <xsl:value-of select="@id" />
                    </xsl:attribute>
                  </a>
                </dt>
                <dd class="and-or">
                  <xsl:apply-templates select="comments" />
                  <!-- Apply template to display the regimens-->
                  <xsl:for-each select="regimens">
                    <xsl:apply-templates select="." />
                  </xsl:for-each>
                </dd>
            </dl>
          </td>
      </tr>
  </xsl:template>
  
  <xsl:template name="patient-group-template">
      <xsl:param name="ptGroup"/>
      <xsl:variable name="patientGroupName" select="name"/>
      <xsl:variable name="ptGroupLastPos" select="last()"/>
      <xsl:variable name="hasChildren">
	       <xsl:choose>
	           <xsl:when test="./pt-groups/*">
	               <xsl:text>true</xsl:text>
	           </xsl:when>
	           <xsl:otherwise>
	               <xsl:text>false</xsl:text>
	           </xsl:otherwise>
	       </xsl:choose>
	  </xsl:variable>
	  
      <xsl:variable name="isLastParentPtGroup">
           <xsl:choose>
               <xsl:when test="position() = last()">
                   <xsl:text>true</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                   <xsl:text>false</xsl:text>
               </xsl:otherwise>
           </xsl:choose>
      </xsl:variable>
      
      
      <xsl:choose>
        <xsl:when test="./tx-options/*"> <!--  If there are parent treatments -->
	      <xsl:for-each select="./tx-options/tx-option">
	         <xsl:call-template name="treatment-template">
	             <xsl:with-param name="ptGroupPos" select="position()" />
	             <xsl:with-param name="ptGroupLastPos" select="$ptGroupLastPos" />
	             <xsl:with-param name="ptGroupName" select="$patientGroupName" />
	             <xsl:with-param name="ptGroupType" select="'parent'" />
	             <xsl:with-param name="hasChildren" select="$hasChildren" />
	             <xsl:with-param name="isLastParentPtGroup" select="$isLastParentPtGroup" />
	         </xsl:call-template>
	      </xsl:for-each>
	      
	      <!-- Now process child patient groups -->
	      <xsl:for-each select="./pt-groups/pt-group">
	         <xsl:variable name="childPtGroupPos" select="position()"/>
	         <xsl:variable name="childPtGroupLastPos" select="last()"/>
	         <xsl:variable name="childPtGroupName" select="name"/>
	         <xsl:for-each select="./tx-options/tx-option">
		         <xsl:call-template name="treatment-template">
		             <xsl:with-param name="ptGroupPos" select="$childPtGroupPos" />
		             <xsl:with-param name="ptGroupLastPos" select="$childPtGroupLastPos" />
		             <xsl:with-param name="ptGroupName" select="$childPtGroupName" />
		             <xsl:with-param name="ptGroupType" select="'child'" />
		             <xsl:with-param name="hasChildren" select="$hasChildren" />
		             <xsl:with-param name="isLastParentPtGroup" select="$isLastParentPtGroup" />
		         </xsl:call-template>
		      </xsl:for-each>
	      </xsl:for-each>
        </xsl:when>
        <xsl:otherwise> <!-- No parent treatments -->
            <tr><td class="patient-group-parent"><p><xsl:value-of select="$patientGroupName" /></p></td><td></td><td class="third-column"> </td></tr>
            <!-- Now process child patient groups -->
	        <xsl:for-each select="./pt-groups/pt-group">
	             <xsl:variable name="childPtGroupPos" select="position()"/>
	             <xsl:variable name="childPtGroupLastPos" select="last()"/>
	             <xsl:variable name="childPtGroupName" select="name"/>
	             <xsl:for-each select="./tx-options/tx-option">
	                 <xsl:call-template name="treatment-template">
	                     <xsl:with-param name="ptGroupPos" select="$childPtGroupPos" />
	                     <xsl:with-param name="ptGroupLastPos" select="$childPtGroupLastPos" />
	                     <xsl:with-param name="ptGroupName" select="$childPtGroupName" />
	                     <xsl:with-param name="ptGroupType" select="'child'" />
	                     <xsl:with-param name="hasChildren" select="$hasChildren" />
	                     <xsl:with-param name="isLastParentPtGroup" select="$isLastParentPtGroup" />
	                 </xsl:call-template>
	              </xsl:for-each>
	       </xsl:for-each>
	  </xsl:otherwise>
     </xsl:choose>
  </xsl:template>
 
  <xsl:template match="regimens">
    <xsl:choose>
      <xsl:when test="@tier=1">
        <p><h4>
            <xsl:call-template name="translate">
                <xsl:with-param name="messagekey">body.treatment.details.patientgroup.primary-options</xsl:with-param>
            </xsl:call-template>          
        </h4></p>
      </xsl:when>
      <xsl:when test="@tier=2">
        <p><h4>
            <xsl:call-template name="translate">
                <xsl:with-param name="messagekey">body.treatment.details.patientgroup.secondary-options</xsl:with-param>
            </xsl:call-template>                  
        </h4></p>
      </xsl:when>
      <xsl:otherwise>
        <p><h4>
            <xsl:call-template name="translate">
                <xsl:with-param name="messagekey">body.treatment.details.patientgroup.tertiary-options</xsl:with-param>
            </xsl:call-template>    
        </h4></p>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each select="regimen">
        <xsl:value-of select="./regimen-name"/>
        <xsl:for-each select="components/component">
            <xsl:call-template name="componentTemplate"/>
        </xsl:for-each>
        
        <xsl:variable name="lastModifier" select="./components[last()]/component[last()]/@modifier"/>
        <xsl:if test="position()!=last() and $lastModifier!='AND' and $lastModifier!='AND/OR' 
                                         and $lastModifier!='and' and $lastModifier!='and/or' and $lastModifier!='or'" >
            <div class="big-or"><strong> OR </strong></div>
        </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="comments">
    <ul>
      <xsl:for-each select="./para">
        <li>
          <xsl:apply-templates select="." />
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>
  
  
  <xsl:template name="componentTemplate">
    <xsl:if test="position()=1">
        <xsl:call-template name="open-treatmentwrap-template"/>
        <xsl:call-template name="open-treatmentbox-template"/>
    </xsl:if>
    
    <xsl:variable name="compId">
        <xsl:value-of select="./@id"/>
    </xsl:variable>
    <p class="treatment">
        <xsl:apply-templates select="name" />
        <xsl:if test="details">
          :
          <xsl:apply-templates select="details" />
        </xsl:if>
        <!-- Comments popup -->
    </p>  
    
    <div style="display:none">
        <xsl:attribute name="id">
            <xsl:value-of select="'drug-link-content-'" />
            <xsl:value-of select="$compId"/>
        </xsl:attribute>
        <xsl:attribute name="class">
            <xsl:value-of select="'popover'" />
        </xsl:attribute>
        <h3>Choose your formulary:</h3>
        <ul>
            <xsl:call-template name="drug-database-list"/>
        </ul>
        <p class="edit-formulary"><a href="/best-practice/mybp/mybp.html?category=drugdb">Edit formulary settings</a></p>
    </div>
    
    <xsl:if test="comments">
        <a tabindex="45" href="#" class="reflink more-link">
            <xsl:attribute name="id">
                <xsl:value-of select="'popuplink-diff-comment_'" />
                <xsl:value-of select="generate-id(name)" />
            </xsl:attribute>
            <span>
            <xsl:call-template name="translate">
                <xsl:with-param name="messagekey">more</xsl:with-param>
            </xsl:call-template>                
            </span>
        </a>

        <!-- Hidden comments popup div -->
        <div style="display:none">
            <xsl:attribute name="id">
              <xsl:value-of select="'popup-content_'" />
              <xsl:value-of select="generate-id(name)" />
            </xsl:attribute>
            <div class="head">
              <h4>
                <xsl:value-of select="name" />
              </h4>
              <div>
                 <xsl:attribute name="id">
                  <xsl:value-of select="'close_'" />
                  <xsl:value-of select="generate-id(name)" />
                 </xsl:attribute>
                  <xsl:attribute name="class">
                  <xsl:value-of select="'button'" />
                 </xsl:attribute>
              </div>
            </div>
            <div class="body">
              <xsl:apply-templates select="comments" />
            </div><!-- /Hidden comments popup div -->
        </div>
    </xsl:if>

    <xsl:text> </xsl:text>
    <xsl:choose>
        
        <xsl:when test="@modifier='and' or @modifier='or' or @modifier='and/or'" >
            <xsl:choose>
                <!-- If this is not the last component in the regimen then display the 'and' 'or'.
                                                 Ideally this should not have happened because the last component should either not
                                                 have a modifier or have a modifier of 'unset', however there are some
                                                 monographs that dont abide by this rule.
                                            -->
                <xsl:when test="position()!=last()">
                    <xsl:call-template name="little-and-or-template-template"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Close treatmentwrap div> -->
                    <xsl:call-template name="close-div-template"/>
                    <!-- Close treatmentbox div> -->
                    <xsl:call-template name="close-div-template"/>
                     
                    <xsl:call-template name="little-and-or-template-template"/>
                    
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
      
        <xsl:when test="@modifier='AND' or @modifier='AND/OR'">
            <!-- Close treatmentwrap div> -->
            <xsl:if test="position()=last()">
                <xsl:call-template name="close-div-template"/>    
            </xsl:if>
            <!-- Close treatmentbox div> -->
            <xsl:call-template name="close-div-template"/>
        
            <xsl:choose>
                <xsl:when test="@modifier='AND'">
                    <div class="big-and"><strong> -- AND -- </strong></div>
                </xsl:when>
                <xsl:otherwise>
                    <div class="big-and"><strong> -- AND/OR -- </strong></div>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:if test="position()!=last()">
                <!--  <xsl:call-template name="open-treatmentwrap-template"/> -->
                <xsl:call-template name="open-treatmentbox-template"/>
            </xsl:if>
        </xsl:when>
        <xsl:otherwise>
            <!-- Close treatmentwrap div> -->
            <xsl:call-template name="close-div-template"/>
            <!-- Close treatmentbox div> -->
            <xsl:call-template name="close-div-template"/>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
 
  <xsl:template name="little-and-or-template-template">
        <!--<xsl:if test="position()!=last()">-->
            <xsl:choose>
                <xsl:when test="@modifier='and'">
                    <div class="small-and"><strong><em>and</em></strong></div>
                </xsl:when>
                <xsl:when test="@modifier='or'">
                    <div class="small-or"><strong><em>or</em></strong></div>
                </xsl:when>
                <xsl:otherwise>
                    <div class="small-or"><strong><em>and/or</em></strong></div>
                </xsl:otherwise>
            </xsl:choose>
        <!--</xsl:if>-->
  </xsl:template>
  
  <xsl:template name="open-treatmentwrap-template">
        <xsl:text disable-output-escaping="yes">
            &lt;div class="treatment-wrap"&gt;
        </xsl:text>
  </xsl:template>
  
  <xsl:template name="open-treatmentbox-template">
        <xsl:text disable-output-escaping="yes">
            &lt;div class="treatment-box"&gt;
        </xsl:text>
  </xsl:template>
    
  <xsl:template name="close-div-template">
        <xsl:text disable-output-escaping="yes">
            &lt;/div&gt;
        </xsl:text>
  </xsl:template>
</xsl:stylesheet>

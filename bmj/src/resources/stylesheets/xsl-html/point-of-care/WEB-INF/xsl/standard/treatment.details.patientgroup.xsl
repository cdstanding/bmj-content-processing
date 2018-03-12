<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../libs/general-lib.xsl" />

  <!-- request context path -->
  <xsl:param name="ctxPath" />

  <!-- text for title bar -->
  <xsl:param name="monographTitle" />
  <xsl:param name="monographId" />
  <xsl:variable name="url">
    <xsl:value-of select="$ctxPath" />
    <xsl:value-of select="'/monograph/'" />
    <xsl:value-of select="$monographId" />
    <xsl:value-of select="'/treatment/details.html'" />
  </xsl:variable>

  <xsl:variable name="patientGroupUrl">
    <xsl:value-of select="$ctxPath" />
    <xsl:value-of select="'/monograph/'" />
    <xsl:value-of select="$monographId" />
    <xsl:value-of select="'/treatment/details/patientgroup/'" />
  </xsl:variable>

  <xsl:output method="html" omit-xml-declaration="yes" />

  <xsl:template match="*:xquery-result">
    <xsl:variable name="patientGroupLevel" select=".//timeframe/selected-patient-group-level"/>
    <xsl:variable name="parentPatientGroupName" select=".//timeframe/pt-group/name"/>
    <xsl:variable name="childPatientGroupName" select=".//timeframe/pt-group/pt-groups/pt-group/name"/>
    <xsl:variable name="hasParentTreatments" select=".//timeframe/contains-parent-treatments"/>
    
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
               <xsl:call-template name="selected-patient-group-title-template">
                    <xsl:with-param name="patientGroupLevel" select="$patientGroupLevel" />
                    <xsl:with-param name="parentPatientGroupName" select="$parentPatientGroupName" />
                    <xsl:with-param name="childPatientGroupName" select="$childPatientGroupName" />
                    <xsl:with-param name="htmlHead" select="'true'" />
                </xsl:call-template>
            - <xsl:value-of select="'Best Practice'" /> 
        </title>
      </head>
      <body>
        <div class="body-copy">
          <h2>
			<xsl:call-template name="translate">
				<xsl:with-param name="messagekey">body.treatment.details.patientgroup.treatment-details</xsl:with-param>
			</xsl:call-template>          
          </h2> 
            <h2>
              <xsl:call-template name="selected-patient-group-title-template">
                <xsl:with-param name="patientGroupLevel" select="$patientGroupLevel" />
                <xsl:with-param name="parentPatientGroupName" select="$parentPatientGroupName" />
                <xsl:with-param name="childPatientGroupName" select="$childPatientGroupName" />
                <xsl:with-param name="hasParentTreatments" select="$hasParentTreatments" />
              </xsl:call-template>
              <span class="time-frame"><xsl:value-of select="' '" /><xsl:apply-templates select=".//timeframe/@type" /></span>
            </h2>  
          <p>
            <a tabindex="45">
                <xsl:attribute name="href">
                    <xsl:value-of select="$url" />
                </xsl:attribute>
              &#171; 
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.treatment.details.patientgroup.back-to-patient-groups</xsl:with-param>
				</xsl:call-template>                        
            </a>
          </p>
          
          <div class="allopenable expandable-section">
              <xsl:choose>      
                <!--  If parent patient group selected then show only parent level treatments -->
                <xsl:when test="$patientGroupLevel ='parent'">
                  <table class="default treatment-options" border="0" cellspacing="0" cellpadding="5">
			        <caption>
						<xsl:call-template name="translate">
							<xsl:with-param name="messagekey">body.treatment.details.patientgroup.select-treatment</xsl:with-param>
						</xsl:call-template>			        
			        </caption>
			        <tr>
			          <!-- <th class="patient-group">Patient Group</th> -->
			          <th class="treatment-line">
						<xsl:call-template name="translate">
							<xsl:with-param name="messagekey">body.treatment.details.patientgroup.treatment-line</xsl:with-param>
						</xsl:call-template>				          
			          </th>
			          <th class="treatment">
						<xsl:call-template name="translate">
							<xsl:with-param name="messagekey">body.treatment.details.patientgroup.treatment</xsl:with-param>
						</xsl:call-template>					          
			          	<span tabindex="45" class="showall"/>
			          </th>
			        </tr>  
                    <xsl:call-template name="display-patientgroup-template">
	                    <xsl:with-param name="pt-group" select=".//timeframe/pt-group" />
                    </xsl:call-template>
                  </table>
                </xsl:when>
                
                <xsl:otherwise>
                  <!--  Show parent treatments if there are any -->
                  <xsl:if test="$hasParentTreatments ='true'">
		              <table class="default treatment-options" border="0" cellspacing="0" cellpadding="5">
	                    <caption><xsl:value-of select="$parentPatientGroupName" /></caption>
	                    <tr>
	                      <th class="treatment-line">
							<xsl:call-template name="translate">
								<xsl:with-param name="messagekey">body.treatment.details.patientgroup.treatment-line</xsl:with-param>
							</xsl:call-template>	                      
	                      </th>
	                      <th class="treatment">
							<xsl:call-template name="translate">
								<xsl:with-param name="messagekey">body.treatment.details.patientgroup.treatment</xsl:with-param>
							</xsl:call-template>					          
				          	<span tabindex="45" class="showall"/>	                      
	                      </th>
	                    </tr>  
	                    <xsl:call-template name="display-patientgroup-template">
	                        <xsl:with-param name="pt-group" select=".//timeframe/pt-group" />
	                    </xsl:call-template>
		              </table>
                  </xsl:if>        
                
                  <!-- Now show the child treatments -->
                  <table class="default treatment-options" border="0" cellspacing="0" cellpadding="5">
                    <xsl:choose>      
                        <xsl:when test="$hasParentTreatments ='false'">
                            <caption>
								<xsl:call-template name="translate">
									<xsl:with-param name="messagekey">body.treatment.details.patientgroup.select-treatment</xsl:with-param>
								</xsl:call-template>                            
                            </caption>
                            <tr>
                                <th class="treatment-line">
									<xsl:call-template name="translate">
										<xsl:with-param name="messagekey">body.treatment.details.patientgroup.treatment-line</xsl:with-param>
									</xsl:call-template>	                                
                                </th>
                                <th class="treatment">
									<xsl:call-template name="translate">
										<xsl:with-param name="messagekey">body.treatment.details.patientgroup.treatment</xsl:with-param>
									</xsl:call-template>					          
						          	<span tabindex="45" class="showall"/>                                
                                </th>
                            </tr> 
                        </xsl:when>
                        <xsl:otherwise>
                            <caption><span class="child-patient-group"><xsl:apply-templates select="$childPatientGroupName"/></span></caption>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:call-template name="display-patientgroup-template">
	                    <xsl:with-param name="pt-group" select=".//timeframe/pt-group/pt-groups/pt-group" />
	                </xsl:call-template>
	              </table>
                </xsl:otherwise>
              </xsl:choose>
          </div>
           
          <p><a tabindex="45"><xsl:attribute name="href"><xsl:value-of select="$url" /></xsl:attribute>&#171; 
   				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.treatment.details.patientgroup.back-to-patient-groups</xsl:with-param>
				</xsl:call-template>         
          </a></p>
          
          <!-- List the child patient groups at the bottom if they exist-->
          <xsl:if test="$patientGroupLevel ='parent'">
            <xsl:if test=".//timeframe/pt-group/pt-groups/*">
              <p><strong>
				<xsl:call-template name="translate">
					<xsl:with-param name="messagekey">body.treatment.details.patientgroup.other-patient-groups-within-this-group</xsl:with-param>
				</xsl:call-template>                       
              </strong></p>
              <ul>
                <xsl:apply-templates select=".//timeframe/pt-group/pt-groups" />
              </ul>
            </xsl:if>
          </xsl:if>

        </div>
        <!-- /body copy -->
        <div class="clear">
          <!-- x -->
        </div>
      </body>
    </html>
  </xsl:template>
  
  <!-- Show selected patient group title -->
  <xsl:template name="selected-patient-group-title-template">
    <xsl:param name="patientGroupLevel" />
    <xsl:param name="parentPatientGroupName" />
    <xsl:param name="childPatientGroupName" />
    <xsl:param name="hasParentTreatments" />
    <xsl:param name="htmlHead" />
    
    <xsl:choose>
	    <xsl:when test="$patientGroupLevel ='parent'">
	        <xsl:call-template name="display-patientgroup-name-template">
                <xsl:with-param name="patientgroupName" select="$parentPatientGroupName" />
                <xsl:with-param name="htmlHead" select="$htmlHead" />
            </xsl:call-template>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:call-template name="display-patientgroup-name-template">
                <xsl:with-param name="patientgroupName" select="$parentPatientGroupName" />
                <xsl:with-param name="htmlHead" select="$htmlHead" />
            </xsl:call-template>
	      <xsl:text> - </xsl:text>
	      <xsl:choose>
	        <xsl:when test="$hasParentTreatments ='true'">
	            <span class="child-patient-group">
	               <xsl:call-template name="display-patientgroup-name-template">
		                <xsl:with-param name="patientgroupName" select="$childPatientGroupName" />
		                <xsl:with-param name="htmlHead" select="$htmlHead" />
		           </xsl:call-template>
	            </span>
	        </xsl:when>
	        <xsl:otherwise>
	            <xsl:call-template name="display-patientgroup-name-template">
                     <xsl:with-param name="patientgroupName" select="$childPatientGroupName" />
                     <xsl:with-param name="htmlHead" select="$htmlHead" />
                </xsl:call-template>
	        </xsl:otherwise>
	      </xsl:choose>
	    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="display-patientgroup-name-template">
    <xsl:param name="patientgroupName"/>
    <xsl:param name="htmlHead"/>
    <xsl:choose>
        <xsl:when test="$htmlHead ='true'">
            <xsl:value-of select="$patientgroupName" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$patientgroupName" />
        </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  <!-- -Template that displays the patient group and treatments-->
  <xsl:template name="display-patientgroup-template">
    <xsl:param name="pt-group" />
        <xsl:for-each select="$pt-group/tx-options/tx-option">
            <tr>
		        <xsl:choose>
		          <xsl:when test="position()=last()">
		            <xsl:call-template name="treatment-template">
		              <xsl:with-param name="classStyle" select="'end'" />
		            </xsl:call-template>
		          </xsl:when>
		          <xsl:otherwise>
		            <xsl:call-template name="treatment-template">
		              <xsl:with-param name="classStyle" select="''" />
		            </xsl:call-template>
		          </xsl:otherwise>
		        </xsl:choose>
		   </tr>
        </xsl:for-each>
  </xsl:template>

  <!-- This template displays all the treatment options-->
  <xsl:template name="treatment-template">
    <xsl:param name="classStyle" />
    <td>
        <xsl:attribute name="class">
            <xsl:value-of select="'treatment-line '" />
            <xsl:value-of select="$classStyle" />
        </xsl:attribute>
        <!-- Apply template to display the description of the treatment line-->
        <xsl:apply-templates select="." />
    </td>
    <td>
        <xsl:attribute name="class">
            <xsl:value-of select="'treatment '" />
            <xsl:value-of select="$classStyle" />
        </xsl:attribute>
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
              <xsl:apply-templates select="./comments" />
              <!-- Apply template to display the regimens-->
              <xsl:for-each select="regimens">
                <xsl:apply-templates select="." />
              </xsl:for-each>
            </dd>
        </dl>
    </td>
  </xsl:template>

  <xsl:template match="tx-option">
    <xsl:choose>
      <xsl:when test="../@tx-line=1">1st</xsl:when>
      <xsl:when test="../@tx-line=2">2nd</xsl:when>
      <xsl:when test="../@tx-line=3">3rd</xsl:when>
      <xsl:when test="../@tx-line=4">4th</xsl:when>
      <xsl:when test="../@tx-line=5">5th</xsl:when>
      <xsl:when test="../@tx-line=6">6th</xsl:when>
      <xsl:when test="../@tx-line='A'">
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
      	<!-- div class="treatment-line jstooltip" title="$tooltip1">adjunct <p class="info"><span>[?]</span></p></div-->
      </xsl:when>
      <xsl:when test="../@tx-line='P'">
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
      	<!-- div class="treatment-line jstooltip" title="$tooltip2">plus <p class="info"><span>[?]</span></p></div-->
      	</xsl:when>
      <xsl:otherwise></xsl:otherwise>
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
  
  <!-- This template displays the list of subpatient groups when the patient group being displayed is a parent -->
  <xsl:template match="pt-groups">
    <xsl:for-each select="pt-group">
      <li>
        <a tabindex="45">
            <xsl:attribute name="href">
                <xsl:value-of select="$patientGroupUrl" />
                <xsl:value-of select="../../@generated-id" />
                <xsl:value-of select="'/'" />
                <xsl:value-of select="@generated-id" />
                <xsl:value-of select="'.html'" />
            </xsl:attribute>
          <xsl:apply-templates select="name" />
        </a>
      </li>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="componentTemplate">
    <xsl:if test="position()=1">
        <xsl:call-template name="open-treatmentwrap-template"/>
        <xsl:call-template name="open-treatmentbox-template"/>
    </xsl:if>
    
    <p class="treatment">
        <xsl:apply-templates select="name" />
        <xsl:if test="details">
          :
          <xsl:apply-templates select="details" />
        </xsl:if>
        <!-- Comments popup -->
    </p>  
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

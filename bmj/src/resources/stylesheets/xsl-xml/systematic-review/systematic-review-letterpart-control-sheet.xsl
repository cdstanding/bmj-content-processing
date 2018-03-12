<?xml version="1.0"?>

<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output 
		method="xml" 
		encoding="UTF-8" 
		indent="yes" 
		omit-xml-declaration="no"/>

	<xsl:template match="/">

		<xsl:element name="LPWSBuildList">
			
			<xsl:element name="LPWSFilesInBatch">
				<xsl:for-each select=".//SECTION[@DOCTYPE!='cross-ref']">
					<!--<xsl:sort select="@TITLE"/>-->
					<xsl:for-each select=".//CONDITION[@DOCTYPE='condition' and @PUBSTATUS!='pulled']">
						<!--<xsl:sort select="@TITLE"/>-->
						<xsl:element name="LPWSTextFile">
							<xsl:text>CE_</xsl:text>
							<xsl:value-of select="@ID"/>
							<xsl:text>.xml</xsl:text>
						</xsl:element>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:element>
			
			<xsl:element name="LPWSInfo">
				<xsl:element name="LPWSCustomer">
					<xsl:text>BMJ</xsl:text>
				</xsl:element>
				<xsl:element name="LPWSJobName">
					<xsl:text>Clinical Evidence Handbook</xsl:text>
				</xsl:element>
				<xsl:element name="LPWSEditor">
					<xsl:text>Jennie Wilkinson</xsl:text>
				</xsl:element>
				<xsl:element name="LPWSEmail">
					<xsl:text>JWilkinson@bmjgroup.com</xsl:text>
				</xsl:element>
				<xsl:element name="LPWSPhone">
					<xsl:text>+44 020 7383 6814</xsl:text>
				</xsl:element>
				<xsl:element name="LPWSVolume">
					<xsl:text>18</xsl:text>
				</xsl:element>
				<xsl:element name="LPWSSubVolume"/>
				<xsl:element name="LPWSPubMonth">
					<xsl:text>July</xsl:text>
				</xsl:element>
				<xsl:element name="LPWSPubYear">
					<xsl:text>2009</xsl:text>
				</xsl:element>
			</xsl:element>
			
			<xsl:element name="LPWSPublication">
				<xsl:for-each select=".//SECTION[@DOCTYPE!='cross-ref']">
					<!--<xsl:sort select="@TITLE"/>-->
					<xsl:for-each select=".//CONDITION[@DOCTYPE='condition' and @PUBSTATUS!='pulled']">
						<!--<xsl:sort select="@TITLE"/>-->
						<xsl:element name="LPWSDivision">
							<xsl:element name="LPWSDivName">
								<xsl:text>CE_</xsl:text>
								<xsl:value-of select="@ID"/>
							</xsl:element>
							<xsl:element name="LPWSAutoGenerate">
								<xsl:text>no</xsl:text>
							</xsl:element>
							<xsl:element name="LPWSDivPageStart">
								<xsl:choose>
									<xsl:when test="parent::SECTION[position()=1] and position()=1">
										<xsl:text>start</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>continued</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
							<xsl:element name="LPWSDivPageEnd">
								<xsl:text>any</xsl:text>
							</xsl:element>
							
							
							<xsl:element name="LPWSDivP1">
								<xsl:text>0</xsl:text>
							</xsl:element>
							<xsl:element name="LPWSDivFMT1">
								<xsl:text>0</xsl:text>
							</xsl:element>
							<xsl:element name="LPWSDivP2">
								<xsl:text>0</xsl:text>
							</xsl:element>
							<xsl:element name="LPWSDivFMT2">
								<xsl:text>0</xsl:text>
							</xsl:element>
							<xsl:element name="LPWSDivP3">
								<xsl:text>0</xsl:text>
							</xsl:element>
							<xsl:element name="LPWSDivFMT3">
								<xsl:text>0</xsl:text>
							</xsl:element>
							<xsl:element name="LPWSDivP4">
								<xsl:text>continued</xsl:text>
							</xsl:element>
							<xsl:element name="LPWSDivFMT4">
								<xsl:text>rn</xsl:text>
							</xsl:element>
							
						</xsl:element>
					</xsl:for-each>
				</xsl:for-each>
				
				<xsl:element name="LPWSProcesses">
					<xsl:element name="LPWSProcess">
						<xsl:element name="LPWSName">
							<xsl:text>none</xsl:text>
						</xsl:element>
						<xsl:element name="LPWSName">
							<xsl:text>none</xsl:text>
						</xsl:element>
						<xsl:element name="LPWSDivisionName">
							<xsl:text>none</xsl:text>
						</xsl:element>
						<xsl:element name="LPWSCommand">
							<xsl:text>none</xsl:text>
						</xsl:element>
						<xsl:element name="LPWSOptions">
							<xsl:text>none</xsl:text>
						</xsl:element>
						<xsl:element name="LPWSFileList">
							<xsl:element name="LPWSDivision">
								<xsl:text>none</xsl:text>
							</xsl:element>
						</xsl:element>
					</xsl:element>
				</xsl:element>
				
			</xsl:element>
			
		</xsl:element>
		
	</xsl:template>

</xsl:stylesheet>

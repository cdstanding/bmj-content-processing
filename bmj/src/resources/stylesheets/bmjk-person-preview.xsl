<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xi="http://www.w3.org/2001/XInclude">
              
  <xsl:import href="bmjk-generic-html.xsl"/>
  
  <!-- this template processes the persons file(s) -->	    
  <xsl:template match="person">
    <html>
      <head>
        <style>
          td { border-color: #ccc; }
        </style>
        <title>Person</title>
      </head>
      
      <body>
      <h1>person</h1>
        <table border="1" cellpadding="5" cellspacing="5">
          <tr>
            <td width="10" style="background: #ccc;" valign="top"><b>ID</b></td>
            <td width="15%" style="background: #ccc;" valign="top"><b>Name</b></td>
            <td width="25%" style="background: #ccc;" valign="top"><b>Title</b></td>
            <td width="50%" style="background: #ccc;" valign="top"><b>Affiliation<br/>City/Country</b></td>
          </tr>
          <tr>
			  <td><xsl:value-of select="@id"/></td>
				<xsl:choose>
					<xsl:when test="normalize-space(middle-name) != ''">
						<td><xsl:value-of select="concat(normalize-space(first-name),' ',normalize-space(middle-name),' ',normalize-space(last-name))"/></td>
					</xsl:when>
					<xsl:otherwise>
						<td><xsl:value-of select="concat(normalize-space(first-name),' ',normalize-space(last-name))"/></td>
					</xsl:otherwise>
				</xsl:choose>
			  <td><xsl:value-of select="title"/></td>
			  <td>
				<xsl:if test="normalize-space(affiliation) != ''"><xsl:value-of select="affiliation"/><br/></xsl:if>
				<xsl:if test="normalize-space(city) != ''"><xsl:value-of select="city"/></xsl:if>
				  <xsl:if test="normalize-space(country) != ''">,<xsl:value-of select="country"/></xsl:if>
			  </td>
			</tr>
        </table>
      </body>
    </html>
  </xsl:template>
  
  
    
  

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xi="http://www.w3.org/2001/XInclude">
              
  <xsl:import href="bmjk-generic-html.xsl"/>
  
  <!-- this template processes the persons file(s) -->	    
  <xsl:template match="section">
    <html>
      <head>
        <xsl:call-template name="insert-style"/>
        <style>
		td { border-color: #ccc; }
	</style>
        <title>Section</title>
      </head>
      <body>
        <table border="1" cellpadding="5" cellspacing="5">
          <tr>
            <td width="10" style="background: #ccc;" valign="top"><b>ID</b></td>
            <td width="50%" style="background: #ccc;" valign="top"><b>Title</b></td>
            <td width="50%" style="background: #ccc;" valign="top"><b>Abridged Title</b></td>
          </tr>
	   <tr>
	      <td><xsl:value-of select="@id"/></td>
	      <td><xsl:value-of select="section-title"/></td>
	      <td><xsl:value-of select="section-abridged-title"/></td>
	</tr>
        </table>
      </body>
    </html>
  </xsl:template>
  

</xsl:stylesheet>

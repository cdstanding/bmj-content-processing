<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xi="http://www.w3.org/2001/XInclude">
  
  <xsl:output 
    method="html"
    encoding="utf-8"
    indent="yes"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>
    
  <!-- SERVER REQUESTS -->
  <xsl:param name="getLinkTargetsAsXML">/getLinkTargetAsXML.do</xsl:param>
  <xsl:param name="dav-uri"/>
  <xsl:param name="document-id"/>
  <xsl:param name="sessionid" select="substring-after($dav-uri,'/dav/ses=')"/>
  <xsl:param name="docato-server" select="substring-before($dav-uri,'/dav/ses=')"/>

  <xsl:strip-space elements="*"/>
  
  <xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	    
  <xsl:template name="insert-style">
    <style type="text/css">
      
      body {
      font-family: Arial, sans-serif;
      font-size: 15px;
      }
      
      ul {
      list-style-type:  square;
      }
      
      .blueHeader {          
      color: #AAAAEE;
      font-weight: bold;
      font-size: 18px;
      line-height: 30px;
      }
      
      .category {
      font-size: 12px;
      line-height: 16px;
      line-height: 18px;
      color: #003366;
      border-color: #cccccc;
      border-style: solid;
      border-width: 0px 0px 1px 0px;
      margin-bottom: 7px;
      font-style: italic;
      }
      
      .page_title {
      font-size: 25px;
      font-weight: bolder;
      line-height: 18px;
      color: #003366;
      margin-bottom: 10px;
      }
      
      .normal {	
      font-size: 12px;
      line-height: 12px;
      margin-bottom: 7px;
      }
      
      .collective-name {	
      font-style: italic;
      font-size: 10px;
      line-height: 10px;
      margin-bottom: 7px;
      }
      
      .questionshead
      {
      text-align: center;
      background-color:#000;
      color:white;
      line-height: 30px;
      font-weight: bold;
      }
      
      .questions
      {
      background-color:#ccc;
      color:black;
      font-size: 15px;
      line-height: 18px;
      padding: 2px 10px;
      }
      
      .interventionshead
      {
      text-align: center;
      background-color:#2222AA;
      color:white;
      line-height: 30px;
      font-weight: bold;
      }
      
      .interventions
      {
      background-color:#AAAAEE;
      color:black;
      line-height: 18px;
      padding: 2px 10px;
      }
      
      .blackLinedBox {
      border-top: 3px solid black;
      background-color: white;
      width:100%
      }
      
      .blackBox {
      font-weight: bold;
      background-color: black; 
      color: white; 
      line-height: 30px;
      padding: 10px;
      }	          
      
      .greyLinedBox {
      border-top: 3px solid #ccc;
      background-color: white;
      width:100%
      }
      
      .greyBox {
      font-weight: bold;
      background-color: #ccc; 
      color: black; 
      line-height: 30px;
      padding: 10px;
      }	
      
      #contentLeft {
      width:125px;
      padding:0px;
      float:left;
      }
      
      #contentRight {
      padding:0px;
      float:left;
      }
      
      .grayBox {
      background-color: #ccc;
      }
      
      .blueLinedBox {
      border-top: 3px solid #AAAAEE;
      margin-top: 10px;
      padding-top: 7px;
      background-color: white;
      width:100%;
      }
      
      .blueLetters {
      color: #AAAAEE;
      font-weight: bold;
      }
      
      .persons {
      width: 40%;
      margin-top: 10px;
      }
      
    </style>
  </xsl:template>
	
</xsl:stylesheet>

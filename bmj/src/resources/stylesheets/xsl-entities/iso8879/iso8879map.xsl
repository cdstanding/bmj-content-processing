<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0">
    
   <xsl:import href="isoamsamap.xsl"/>
   <xsl:import href="isoamsbmap.xsl"/>
   <xsl:import href="isoamscmap.xsl"/>
   <xsl:import href="isoamsnmap.xsl"/>
   <xsl:import href="isoamsomap.xsl"/>
   <xsl:import href="isoamsrmap.xsl"/>
   <xsl:import href="isoboxmap.xsl"/>
   <xsl:import href="isocyr1map.xsl"/>
   <xsl:import href="isocyr2map.xsl"/>
   <xsl:import href="isodiamap.xsl"/>
   <xsl:import href="isogrk1map.xsl"/>
   <xsl:import href="isogrk2map.xsl"/>
   <xsl:import href="isogrk3map.xsl"/>
   <xsl:import href="isogrk4map.xsl"/>
   <xsl:import href="isolat1map.xsl"/>
   <xsl:import href="isolat2map.xsl"/>
   <xsl:import href="isonummap.xsl"/>
   <xsl:import href="isopubmap.xsl"/>
   <xsl:import href="isotechmap.xsl"/>
    
   <xsl:character-map 
       name="iso8879" 
       use-character-maps="isoamsa isoamsb isoamsc isoamsn isoamso isoamsr isobox isocyr1 isocyr2 isodia isogrk1 isogrk2 isogrk3 isogrk4 isolat1 isolat2 isonum isopub isotech"/>
    
</xsl:stylesheet>
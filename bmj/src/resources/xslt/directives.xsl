<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:param name="journal-id"/>
    
    <xsl:output method="xml" indent="yes" />
    <xsl:template match="/">
        <!--<xsl:text disable-output-escaping='yes'>
&lt;!DOCTYPE directives PUBLIC "-//HIGHWIRE//DTD HighWire Directives DTD//EN" "http://schema.highwire.org/public/hwx/directives/directives.dtd"&gt;</xsl:text>-->
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="metadata">
        <directives>
            <arts>
                <sitecode>
                    <xsl:value-of select="$journal-id"/>
                </sitecode>
                <volume>
                    <xsl:value-of select="meta[@name='Volume']"/>
                </volume>
                <batch action="close"/>
                <xsl:if test="not(meta[@name='embargo.date'])">
                    <release_protocol>go_on_green</release_protocol>
                </xsl:if>
                <xsl:if test="meta[@name='embargo.date']">
                    <release_protocol>after_embargo_without_approval</release_protocol>
                    <release_datetime>
                        <date>
                            <year><xsl:value-of select="meta[@name='embargo.date']/replace(text(), '^(\d+)(.)(\d+)(.)(\d+)' , '$5')"/></year>
                            <month><xsl:value-of select="meta[@name='embargo.date']/replace(text(), '^(\d+)(.)(\d+)(.)(\d+)' , '$3')"/></month>
                            <day><xsl:value-of select="meta[@name='embargo.date']/replace(text(), '^(\d+)(.)(\d+)(.)(\d+)' , '$1')"/></day>
                        </date>
                        <time>
                            <hour><xsl:value-of select="meta[@name='embargo.time']/substring-before(.,':')"/></hour>
                            <minute><xsl:value-of select="meta[@name='embargo.time']/substring-after(.,':')"/></minute>
                            <timezone>Europe/London</timezone>
                        </time>
                    </release_datetime>
                </xsl:if>
            </arts>
        </directives>
    </xsl:template>
</xsl:stylesheet>
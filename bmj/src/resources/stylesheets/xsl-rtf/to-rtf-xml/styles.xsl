<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:attribute-set name="document" use-attribute-sets="">
        <!---ilx-default-font-family: arial;--> 
        <!--<xsl:attribute name="style">-ilx-endnote-style-type: decimal; -ilx-endnote-numbering-policy: continuous; -ilx-endnote-position: documentbottom; </xsl:attribute>-->
        <!--<xsl:attribute name="style">-ilx-endnote-position: documentbottom; </xsl:attribute>-->
    </xsl:attribute-set>
    
    <xsl:attribute-set name="toc" use-attribute-sets="">
        <xsl:attribute name="data">
            <xsl:text disable-output-escaping="no">\o &amp;quot;1-2&amp;quot; \h \z</xsl:text>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="section" use-attribute-sets="">
        <xsl:attribute name="style">margin-left: 1.5em; </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="margin" use-attribute-sets="">
        <xsl:attribute name="style">margin-left: 1.5em; </xsl:attribute>
    </xsl:attribute-set>
    
    <!--note: use non-breaking space in style names (alt+255)-->
    <xsl:attribute-set name="title" use-attribute-sets="">
        <xsl:attribute name="class">heading 1</xsl:attribute>
        <!--<xsl:attribute name="level">1</xsl:attribute>-->
    </xsl:attribute-set>
    
    <xsl:attribute-set name="heading-1" use-attribute-sets="">
        <xsl:attribute name="class">heading 1</xsl:attribute>
        <xsl:attribute name="level">1</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="heading-2" use-attribute-sets="">
        <xsl:attribute name="class">heading 2</xsl:attribute>
        <xsl:attribute name="level">2</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="heading-3" use-attribute-sets="">
        <xsl:attribute name="class">heading 3</xsl:attribute>
        <xsl:attribute name="level">3</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="heading-4" use-attribute-sets="">
        <xsl:attribute name="class">heading 4</xsl:attribute>
        <xsl:attribute name="level">4</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="normal" use-attribute-sets="">
        <xsl:attribute name="class">Normal</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="reference" use-attribute-sets="">
        <xsl:attribute name="class">Reference</xsl:attribute>
        <xsl:attribute name="style">color: gray; </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="endnote" use-attribute-sets="">
        <xsl:attribute name="style">color: gray; </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="annotation" use-attribute-sets="">
        <xsl:attribute name="style">color: gray; </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="instruction" use-attribute-sets="">
        <xsl:attribute name="style">color: green; </xsl:attribute><!-- font-size: 66%; font-family: Courier New;  -->
    </xsl:attribute-set>
    
    <xsl:attribute-set name="list-i" use-attribute-sets="">
        <xsl:attribute name="style">list-style-type: lower-roman; margin-left: 1.5em; </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="list-1" use-attribute-sets="">
        <xsl:attribute name="style">list-style-type: decimal; margin-left: 1.5em; </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="list-I" use-attribute-sets="">
        <xsl:attribute name="style">list-style-type: upper-roman; margin-left: 1.5em; </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="list-a" use-attribute-sets="">
        <xsl:attribute name="style">list-style-type: lower-alpha; margin-left: 1.5em; </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="list-A" use-attribute-sets="">
        <xsl:attribute name="style">list-style-type: upper-alpha; margin-left: 1.5em; </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="list-bullet" use-attribute-sets="">
        <xsl:attribute name="style">list-style-type: disc; margin-left: 1.5em; </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="list-none" use-attribute-sets="">
        <xsl:attribute name="style">list-style-type: none; margin-left: 1.5em; </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="thead-entry" use-attribute-sets="">
        <xsl:attribute name="style">font-weight: bold; font-size: 66%; border-top-width: 0.1em; border-right-width: 0.1em; border-bottom-width: 0.1em; border-left-width: 0.1em; border-left-width: 0.1em; border-top-color: black; border-right-color: black; border-bottom-color: black; border-left-color: black; </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="tbody-entry" use-attribute-sets="">
        <xsl:attribute name="style">font-size: 66%; border-top-width: 0.1em; border-right-width: 0.1em; border-bottom-width: 0.1em; border-left-width: 0.1em; border-top-color: black; border-right-color: black; border-bottom-color: black; border-left-color: black; </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="para-prompt" use-attribute-sets="">
        <xsl:attribute name="style">font-weight: bold; </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="link" use-attribute-sets="">
        <xsl:attribute name="style">color: red; background-color: yellow; </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="reference-link" use-attribute-sets="">
        <!--<xsl:attribute name="style">\-ilx-reference-presentation-type: number; vertical-align: super; </xsl:attribute>-->
        <xsl:attribute name="style">color: blue; vertical-align: super; </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="organism" use-attribute-sets="">
        <xsl:attribute name="style">color: blue; background-color: yellow; </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="drug" use-attribute-sets="">
        <xsl:attribute name="style">color: green; background-color: yellow; </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="formdropdown" use-attribute-sets="">
        <xsl:attribute name="hasListbox">true</xsl:attribute>
        <xsl:attribute name="protected">true</xsl:attribute>
        <!--<xsl:attribute name="style"></xsl:attribute>-->
    </xsl:attribute-set>
    
</xsl:stylesheet>
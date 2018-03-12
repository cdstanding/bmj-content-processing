<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0">
    <!--
        from epocrates style guide
        6. SPECIAL CHARACTERS
        Avoid most special characters. These are characters that aren't represented on the keyboard and must be inserted through special settings or keystrokes, or through the Insert menu. 
        Often, Word is set to automatically insert special characters such as curly/smart quotes (’ and ”) and em dashes (—). Before working on a monograph, be sure to check your settings. Go to Tools/AutoCorrect Options, and click the tab AutoFormat As You Type. Make sure all the Replace as you type options are not selected and click OK. 
        Below is a list of special characters and what to replace them with. If these symbols are already in a monograph, do Find/Replace to insert these alternatives.
        replace this	    with this
        “ ”	                = " "
        ‘ ’                 = ' '
        — (em dash/rule)    = -/-
        – (en dash/rule)	= -
        µ (e.g., µg)	    = mc (e.g., mcg)
        Greek letters (eg ß)= words (e.g., beta)
        Fractions (eg ½)	= write out (e.g., 1/2)
        …	                = 3 periods (i.e., ...)
        A few special characters/symbols are acceptable: ≤ ≥ ® © ± and the ASCII symbol for degrees: °. Temperatures should be written in Fahrenheit using the following style: 100.4°F. Note: Actual symbols must be used for ≤ ≥ and ° (i.e., do not create < > by underlining <>, and do not use a superscripted O for °). 
        Common accents (e.g., left and right accents, tildas, umlauts and cedillas) can be used for the names of authors/editors/peer reviewers. Do not use them elsewhere in the monograph text or references.
    -->
    
    <xsl:character-map name="isolat1-hexadecimal-character-entity-map">
        <xsl:output-character character="`" string="&amp;#x60;"/>
        <xsl:output-character character="~" string="&amp;#x7E;"/> 
        <xsl:output-character character="¿" string="&amp;#xBF;"/>
        <xsl:output-character character="À" string="&amp;#xC0;"/> 
        <xsl:output-character character="Á" string="&amp;#xC1;"/> 
        <xsl:output-character character="Â" string="&amp;#xC2;"/> 
        <xsl:output-character character="Ã" string="&amp;#xC3;"/> 
        <xsl:output-character character="Ä" string="&amp;#xC4;"/> 
        <xsl:output-character character="Å" string="&amp;#xC5;"/> 
        <xsl:output-character character="Æ" string="&amp;#xC6;"/> 
        <xsl:output-character character="Ç" string="&amp;#xC7;"/> 
        <xsl:output-character character="È" string="&amp;#xC8;"/> 
        <xsl:output-character character="É" string="&amp;#xC9;"/> 
        <xsl:output-character character="Ê" string="&amp;#xCA;"/> 
        <xsl:output-character character="Ë" string="&amp;#xCB;"/> 
        <xsl:output-character character="Ì" string="&amp;#xCC;"/> 
        <xsl:output-character character="Í" string="&amp;#xCD;"/> 
        <xsl:output-character character="Î" string="&amp;#xCE;"/> 
        <xsl:output-character character="Ï" string="&amp;#xCF;"/> 
        <xsl:output-character character="Ð" string="&amp;#xD0;"/> 
        <xsl:output-character character="Ñ" string="&amp;#xD1;"/> 
        <xsl:output-character character="Ò" string="&amp;#xD2;"/> 
        <xsl:output-character character="Ó" string="&amp;#xD3;"/> 
        <xsl:output-character character="Ô" string="&amp;#xD4;"/> 
        <xsl:output-character character="Õ" string="&amp;#xD5;"/> 
        <xsl:output-character character="Ö" string="&amp;#xD6;"/> 
        <xsl:output-character character="Ø" string="&amp;#xD8;"/>
        <xsl:output-character character="Ù" string="&amp;#xD9;"/> 
        <xsl:output-character character="Ú" string="&amp;#xDA;"/> 
        <xsl:output-character character="Û" string="&amp;#xDB;"/> 
        <xsl:output-character character="Ü" string="&amp;#xDC;"/> 
        <xsl:output-character character="Ý" string="&amp;#xDD;"/> 
        <xsl:output-character character="Þ" string="&amp;#xDE;"/>
        <xsl:output-character character="ß" string="&amp;#xDF;"/>
        <xsl:output-character character="à" string="&amp;#xE0;"/>
        <xsl:output-character character="á" string="&amp;#xE1;"/> 
        <xsl:output-character character="â" string="&amp;#xE2;"/> 
        <xsl:output-character character="ã" string="&amp;#xE3;"/> 
        <xsl:output-character character="ä" string="&amp;#xE4;"/>
        <xsl:output-character character="å" string="&amp;#xE5;"/> 
        <xsl:output-character character="æ" string="&amp;#xE6;"/>
        <xsl:output-character character="ç" string="&amp;#xE7;"/>
        <xsl:output-character character="è" string="&amp;#xE8;"/>
        <xsl:output-character character="é" string="&amp;#xE9;"/>
        <xsl:output-character character="ê" string="&amp;#xEA;"/> 
        <xsl:output-character character="ë" string="&amp;#xEB;"/> 
        <xsl:output-character character="ì" string="&amp;#xEC;"/> 
        <xsl:output-character character="í" string="&amp;#xED;"/> 
        <xsl:output-character character="î" string="&amp;#xEE;"/> 
        <xsl:output-character character="ï" string="&amp;#xEF;"/> 
        <xsl:output-character character="ð" string="&amp;#xF0;"/> 
        <xsl:output-character character="ñ" string="&amp;#xF1;"/> 
        <xsl:output-character character="ò" string="&amp;#xF2;"/> 
        <xsl:output-character character="ó" string="&amp;#xF3;"/> 
        <xsl:output-character character="ô" string="&amp;#xF4;"/> 
        <xsl:output-character character="õ" string="&amp;#xF5;"/> 
        <xsl:output-character character="ö" string="&amp;#xF6;"/>
        <xsl:output-character character="ø" string="&amp;#xF8;"/>
        <xsl:output-character character="ù" string="&amp;#xF9;"/> 
        <xsl:output-character character="ú" string="&amp;#xFA;"/> 
        <xsl:output-character character="û" string="&amp;#xFB;"/> 
        <xsl:output-character character="ü" string="&amp;#xFC;"/>
        <xsl:output-character character="ý" string="&amp;#xFD;"/> 
        <xsl:output-character character="þ" string="&amp;#xFE;"/>
        <xsl:output-character character="ÿ" string="&amp;#xFF;"/> 
        <xsl:output-character character="Œ" string="&amp;#x0152;"/> 
        <xsl:output-character character="œ" string="&amp;#x0153;"/>
        <xsl:output-character character="Š" string="&amp;#x0160;"/> 
        <xsl:output-character character="š" string="&amp;#x0161;"/> 
        <xsl:output-character character="Ÿ" string="&amp;#x0178;"/>
    </xsl:character-map>

    <!-- force specific characters to string as defined by poc style guide -->
    <xsl:character-map name="poc-custom-character-map">
        <xsl:output-character character="“" string="&amp;quot;"/>
        <xsl:output-character character="”" string="&amp;quot;"/>
        <xsl:output-character character="‘" string="&amp;apos;"/>
        <xsl:output-character character="’" string="&amp;apos;"/>
        <xsl:output-character character="'" string="&amp;apos;"/>
        <xsl:output-character character="—" string="--"/>
        <xsl:output-character character="–" string="-"/>
        <xsl:output-character character="µ" string="mc"/>
        <xsl:output-character character="μ" string="mc"/>
        <xsl:output-character character="Μ" string="mc"/>
        <xsl:output-character character="α" string="alpha"/>
        <xsl:output-character character="Α" string="alpha"/>
        <xsl:output-character character="β" string="beta"/>
        <xsl:output-character character="Β" string="beta"/>
        <xsl:output-character character="½" string="1/2"/>
        <xsl:output-character character="⅓" string="1/3"/>
        <xsl:output-character character="⅔" string="2/3"/>
        <xsl:output-character character="¼" string="1/4"/>
        <xsl:output-character character="⅛" string="1/8"/>
        <xsl:output-character character="¾" string="3/4"/>
        <xsl:output-character character="⅜" string="3/8"/>
        <xsl:output-character character="⅝" string="5/8"/>
        <xsl:output-character character="⅞" string="7/8"/>
        <xsl:output-character character="…" string="..."/>
        <xsl:output-character character="≤" string="&amp;#x2264;"/>
        <xsl:output-character character="≥" string="&amp;#x2265;"/>
        <xsl:output-character character="®" string="&amp;#xAE;"/>
        <xsl:output-character character="©" string="&amp;#xA9;"/>
        <xsl:output-character character="±" string="&amp;#xB1;"/>
        <xsl:output-character character="°" string="&amp;#xB0;"/>
    </xsl:character-map>
    
</xsl:stylesheet>
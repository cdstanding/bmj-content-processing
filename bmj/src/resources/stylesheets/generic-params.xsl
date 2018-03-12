<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	
	<!-- file.separator solution taken from http://www-128.ibm.com/developerworks/xml/library/x-tipproc.html -->	
	<xsl:param name="file.separator">
		<xsl:variable name="vendor" select="system-property('xsl:vendor')"/>
		<xsl:choose>
			<!-- two well-known XSLT processors for Windows -->
			<xsl:when test="contains($vendor,'Microsoft') or contains($vendor,'Altova')">
				<xsl:text>\</xsl:text>
			</xsl:when>
			<!-- the processor returns Java properties -->
			<xsl:when test="string-length(system-property('java.version')) != 0">
				<xsl:value-of select="system-property('file.separator')"/>
			</xsl:when>
			<!-- the processor is XT, use an extension -->
			<xsl:when 
				test="contains($vendor,'James Clark') and function-available('xt-sys:getProperty')"
				xmlns:xt-sys="http://www.jclark.com/xt/java/java.lang.System">
				<xsl:value-of select="xt-sys:getProperty('file.separator')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">unknown file separator</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>
	
	<!-- Returns the substring after the last given character. For example, calling with 
		
		<xsl:call-template name="substring-after-last">
		<xsl:with-param name="string" select="$file" />
		<xsl:with-param name="delimiter" select="'.'" />
		</xsl:call-template>
		
		Would return the file extension.
		
		Returns the whole string if the delimiter is not found.
	-->
	<xsl:template name="substring-after-last">
		<xsl:param name="string"/>
		<xsl:param name="delimiter"/>
		<xsl:choose>
			<xsl:when test="contains($string, $delimiter)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="string" select="substring-after($string, $delimiter)" />
					<xsl:with-param name="delimiter" select="$delimiter" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:param 
		name="upper" 
		select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝ'"/>
	<xsl:param 
		name="lower" 
		select="'abcdefghijklmnopqrstuvwxyzáâãäåæçèéêëìíîïðñòóôõöøùúûüý'"/>
	
	<xsl:param 
		name="double-space" 
		select="'  '"/>
	<xsl:param 
		name="single-space" 
		select="' '"/>
	
	<xsl:param name="warning">
		<xsl:text>warning-data-incorrect</xsl:text>
	</xsl:param>
	
	<xsl:param name="pubmed-url">
		<xsl:text>http://www.ncbi.nlm.nih.gov/pubmed/</xsl:text>
	</xsl:param>
	
	<xsl:template name="date-convert">
		<xsl:param name="date-value"/>
		
		<!-- year -->
		<xsl:variable 
			name="year" 
			select="
			replace(
			$date-value
			, '^.*?(\d+)$', '$1')
			"/>
		
		<xsl:if test="(string-length($year) = 2)">
			<xsl:value-of select="20"/>
		</xsl:if>
		<xsl:value-of select="$year"/>
		
		<xsl:value-of select="'-'"/>

		<!-- month -->
		<xsl:choose>
			<!-- name -->
			<xsl:when test="matches($date-value, '^(\d+\s*[stndrh]*\s+)?([a-zA-Z]+)\s+\d+$')">
				
				<xsl:variable 
					name="month" 
					select="
					replace(
					$date-value
					, '^(\d+\s*[stndrh]*\s+)?([a-zA-Z]+)\s+\d+$', '$2')
					"/>
				
				<xsl:choose>
					<!-- short -->
					<xsl:when test="contains(translate($month, $upper, $lower), 'jan')">01</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'feb')">02</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'mar')">03</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'apr')">04</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'may')">05</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'jun')">06</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'jul')">07</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'aug')">08</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'sep')">09</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'oct')">10</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'nov')">11</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'dec')">12</xsl:when>
					<!-- full -->
					<xsl:when test="contains(translate($month, $upper, $lower), 'january')">01</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'february')">02</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'march')">03</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'april')">04</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'may')">05</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'june')">06</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'july')">07</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'august')">08</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'september')">09</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'october')">10</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'november')">11</xsl:when>
					<xsl:when test="contains(translate($month, $upper, $lower), 'december')">12</xsl:when>
				</xsl:choose>
				
			</xsl:when>
			
			<!-- number -->
			<xsl:when test="matches($date-value, '^.*?[\.\s/-]+(\d+)[\.\s/-]+.*?$')">

				<xsl:variable 
					name="month" 
					select="
					replace(
					$date-value
					, '^.*?[\.\s/-]+(\d+)[\.\s/-]+.*?$', '$1')
					"/>
				
				<xsl:if test="(string-length($month) &lt; 2)">
					<xsl:value-of select="0"/>
				</xsl:if>
				<xsl:value-of select="$month"/>
				
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:element name="{$warning}"/>
			</xsl:otherwise>
			
		</xsl:choose>
		
		<xsl:text>-</xsl:text>
		
		<!-- day -->
		<xsl:variable 
			name="day" 
			select="
			replace(
			$date-value
			, '^\s*(\d+)[\.\s/-]+.*?$', '$1')
			"/>
		
		<xsl:if test="(string-length($day) &lt; 2)">
			<xsl:value-of select="0"/>
		</xsl:if>
		<xsl:value-of select="$day"/>
		
	</xsl:template>
	
	<xsl:param name="month-order">		
		<January/>
		<February/>
		<March/>
		<April/>
		<May/>
		<June/>
		<July/>
		<August/>
		<September/>
		<October/>
		<November/>
		<December/>
	</xsl:param>
	
</xsl:stylesheet>

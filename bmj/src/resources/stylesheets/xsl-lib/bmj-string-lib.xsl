<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<!-- Returns the substring after the last given character. For example, calling with 

		<xsl:call-template name="substring-after-last">
			<xsl:with-param name="string" select="$file" />
			<xsl:with-param name="delimiter" select="'.'" />
		</xsl:call-template>
		
		Would return the file extension.
		
		Returns the whole string if the delimiter is not found.
	-->
	<xsl:template name="substring-after-last">
		<xsl:param name="string" />
		<xsl:param name="delimiter" />
		<xsl:choose>
			<xsl:when test="contains($string, $delimiter)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="string"
						select="substring-after($string, $delimiter)" />
					<xsl:with-param name="delimiter" select="$delimiter" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$string" /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
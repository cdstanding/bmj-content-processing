<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink">

	<xsl:output 
		method="xml" 
		version="1.0" 
		encoding="UTF-8" 
		indent="yes"
		doctype-public="-//infinity-loop//DTD upCast 5.0//EN"
		doctype-system="http://www.infinity-loop.de/DTD/upcast/5.0/upcast.dtd"
		/>
	
	<xsl:strip-space elements="foot images image link organism drug"/>
	
	<xsl:param name="path"/>
	<xsl:param name="server"/>
	
	<xsl:param name="lang">en-gb</xsl:param>
	<xsl:param name="mode">author</xsl:param>
	
	<xsl:param name="prompt-separator">
		<!--<xsl:text disable-output-escaping="yes">&#x9;</xsl:text>-->
		<xsl:text disable-output-escaping="yes"> - </xsl:text>
	</xsl:param>
	<xsl:param name="pubmed-url">http://www.ncbi.nlm.nih.gov/pubmed/</xsl:param>

	<xsl:include href="monograph-downcast-inline-elements.xsl"/>
	<xsl:include href="monograph-shared-reference-lists.xsl"/>
	<xsl:include href="monograph-shared-outline-match.xsl"/>
	<xsl:include href="monograph-downcast-outline-output.xsl"/>
	<xsl:include href="monograph-downcast-standard-treatment-option.xsl"/>
	<xsl:include href="../styles.xsl"/>
	<xsl:include href="../../../xsl-lib/xinclude.xsl"/>
	<xsl:include href="../../../xsl-lib/strings/monograph-strings.xsl"/>
	
	<xsl:variable name="monograph-type" select="name(/*)"/>
	<xsl:variable name="monograph-plan" select="document(//monograph-plan-link/@target)"/>

	<xsl:template match="/*">
		<xsl:variable name="name" select="name()"/>
		<xsl:processing-instruction name="xml-stylesheet">
			<xsl:text> type="text/css"</xsl:text>
			<xsl:text> href="file:///C:/dev/docato-install/BMJ/content/repository/bmjk/stylesheets/xsl-rtf/to-rtf-xml/styles.css"</xsl:text>
		</xsl:processing-instruction>
		<xsl:element name="document" use-attribute-sets="document">
			<xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>
			<!-- TODO: from monograph-plan-link target document which is not xinclude -->
			<xsl:element name="documentinfo" use-attribute-sets="">
				<xsl:element name="property" use-attribute-sets="">
					<xsl:attribute name="name">company</xsl:attribute>
					<xsl:attribute name="value">BMJ Group</xsl:attribute>
					<xsl:attribute name="type">text</xsl:attribute>
				</xsl:element>
				<xsl:apply-templates select="$monograph-plan//authors" />
				<xsl:apply-templates select="$monograph-plan//peer-reviewers" />
				<xsl:apply-templates select="$monograph-plan//editors" />
				<!--<xsl:apply-templates select="$monograph-plan//deadline-date" />-->
			</xsl:element>
			<xsl:element name="part" use-attribute-sets="">
				<xsl:apply-templates select="monograph-info"/>
				<xsl:element name="section" use-attribute-sets="section">
					<xsl:apply-templates select="*[name()!='evidence-scores'][name()!='figures']"/>
					
					<!--<xsl:call-template name="process-reference-sections"/>-->
					
					<xsl:variable name="combined-references">
						<xsl:element name="references">
							<xsl:element name="combined-references">
								<xsl:call-template name="process-reference-links">
									<xsl:with-param name="item-count" select="1"/>
									<xsl:with-param name="link-index" select="1"/>
									<xsl:with-param name="link-count" select="count(//reference-link) + 1"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:element>
					</xsl:variable>
					<xsl:if test="//reference-link">
						<xsl:apply-templates select="$combined-references//combined-references"/>
					</xsl:if>
					
					<xsl:variable name="evidence-scores">
						<xsl:element name="references">
							<xsl:element name="evidence-scores">
								<xsl:call-template name="process-evidence-score-links">
									<xsl:with-param name="item-count" select="1"/>
									<xsl:with-param name="link-index" select="1"/>
									<xsl:with-param name="link-count" select="count(//evidence-score-link) + 1"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:element>
					</xsl:variable>
					<xsl:if test="//evidence-score-link">
						<xsl:apply-templates select="$evidence-scores//evidence-scores"/>
					</xsl:if>
					
					<xsl:variable name="figures">
						<xsl:element name="references">
							<xsl:element name="figures">
								<xsl:call-template name="process-figure-links">
									<xsl:with-param name="item-count" select="1"/>
									<xsl:with-param name="link-index" select="1"/>
									<xsl:with-param name="link-count" select="count(//figure-link) + 1"/>
								</xsl:call-template>
							</xsl:element>
						</xsl:element>
					</xsl:variable>					
					<xsl:if test="//figure-link">
						<xsl:apply-templates select="$figures//figures"/>
					</xsl:if>
					
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="monograph-info">
		<xsl:element name="section" use-attribute-sets="section">
			<!--<xsl:apply-templates select="monograph-plan-link"/>-->
			<xsl:element name="heading" use-attribute-sets="title">
				<xsl:apply-templates select="title/node()" />
			</xsl:element>
			<xsl:apply-templates select="../@dx-id" />
			<xsl:element name="par" use-attribute-sets="normal">
				<xsl:element name="inline" use-attribute-sets="para-prompt">
					<xsl:value-of select="$strings//str[@name='type']/friendly"/>
					<xsl:text>: </xsl:text>
				</xsl:element>
				<xsl:value-of select="$strings//str[@name=$monograph-type]/friendly" />
			</xsl:element>
			<xsl:element name="par" use-attribute-sets="normal">
				<xsl:element name="inline" use-attribute-sets="para-prompt">
					<xsl:value-of select="$strings//str[@name='authors']/friendly"/>
					<xsl:text>: </xsl:text>
				</xsl:element>
				<xsl:element name="inline" use-attribute-sets="">
					<xsl:for-each select="document($monograph-plan//authors/person-link/@target)/monograph-person/author/name">
						<xsl:apply-templates select="node()"/>
						<xsl:text> </xsl:text>
					</xsl:for-each>
				</xsl:element>
			</xsl:element>
			<!--<xsl:element
				name="annotation" use-attribute-sets="">
				<xsl:element name="par" use-attribute-sets="annotation">
				<xsl:text>annotation test annotation test annotation test </xsl:text>
				</xsl:element>
			</xsl:element>-->
			<xsl:element name="toc" use-attribute-sets="toc"/>
			<xsl:element name="section" use-attribute-sets="section">
				<xsl:element name="heading" use-attribute-sets="heading-1">
					<xsl:value-of select="$strings//str[@name='monograph-info']/friendly" />
				</xsl:element>
				<xsl:apply-templates select="topic-synonyms" />
				<xsl:apply-templates select="related-topics[monograph-link]" />
				<xsl:apply-templates select="statistics" /><!-- used?-->
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="authors | peer-reviewers | editors">
		<!--<xsl:variable name="name" select="name()"/>
		<xsl:element name="section" use-attribute-sets="section">
			<xsl:element name="heading" use-attribute-sets="heading-2">
				<xsl:value-of select="$strings//str[@name=$name]/friendly"/>
			</xsl:element>
			<xsl:apply-templates select="author | peer-reviewer | editor"/>
			</xsl:element>-->
		<!--<xsl:for-each select="person-link">
			<xsl:apply-templates select="document(@target)/monograph-person/node()"/>	
		</xsl:for-each>-->
	</xsl:template>
	
	<!-- documentinfo property -->
	<xsl:template match="author | peer-reviewer | editor">
		<xsl:variable name="person-id" select="concat(name(), '-', position())"/>
		<xsl:element name="property" use-attribute-sets="">
			<xsl:attribute name="name" select="concat($person-id, 'name')"/>
			<xsl:attribute name="value" select="name"/>
			<xsl:attribute name="type">text</xsl:attribute>
		</xsl:element>
	</xsl:template>
	
	<!-- documentinfo property -->
	<xsl:template match="deadline-date">
		<xsl:variable name="name" select="name()"/>
		<xsl:element name="property" use-attribute-sets="">
			<xsl:attribute name="name" select="$name"/>
			<xsl:attribute name="value" select="."/>
			<xsl:attribute name="type">date</xsl:attribute>
		</xsl:element>
	</xsl:template>
	
	<!-- documentinfo property -->
	<xsl:template match="version-history">
		<xsl:variable name="history-id" select="concat(name(), '-', position())"/>
		<xsl:for-each select="history[position()=last()]">
			<xsl:element name="property" use-attribute-sets="">
				<xsl:attribute name="name" select="concat($history-id, '-date')"/>
				<xsl:attribute name="value" select="date"/>
				<xsl:attribute name="type">date</xsl:attribute>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="section">
		<xsl:element name="block" use-attribute-sets="margin">
			<xsl:element name="section" use-attribute-sets="section">
				<xsl:apply-templates />
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="section-header">
		<xsl:element name="heading" use-attribute-sets="heading-3">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="section-text">
		<xsl:apply-templates />
	</xsl:template>

	<!-- para prompt _not_ enumerated -->
	<xsl:template match="source[parent::figure] | source[parent::guideline] | 
		url | abstract-url | fulltext-url | bmj-url | last-published | 
		tx-type | parent-pt-group | pt-group | filename | category">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="par" use-attribute-sets="normal">
			<xsl:element name="inline" use-attribute-sets="para-prompt">
				<xsl:value-of select="$strings//str[@name=$name]/friendly" />
				<xsl:text>: </xsl:text>
			</xsl:element>
			<xsl:element name="inline" use-attribute-sets="">
				<xsl:apply-templates />
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="reference">
		<xsl:element name="item">
			<xsl:attribute name="id">
				<xsl:text>ref</xsl:text>
				<xsl:value-of select="processing-instruction()[name()='position']"/>
			</xsl:attribute>
			<xsl:element name="par" use-attribute-sets="reference">
				<xsl:apply-templates select="poc-citation/citation"/>
				<xsl:value-of select="$prompt-separator"/>
				<xsl:apply-templates select="poc-citation/@key-article"/>
				<xsl:value-of select="$prompt-separator"/>
				<xsl:apply-templates select="poc-citation/@type"/>
				<xsl:value-of select="$prompt-separator"/>
				<xsl:if test="unique-id[@source='medline' and string-length(normalize-space(.))!=0]">
					<xsl:element name="link">
						<xsl:attribute name="xlink:href">
							<xsl:value-of select="concat($pubmed-url, unique-id)"/>
						</xsl:attribute>
						<xsl:element name="inline" use-attribute-sets="link">
							<xsl:text>[PubMed]</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:element>
		</xsl:element>					
	</xsl:template>
	
	<xsl:template match="figure">
		<xsl:element name="item">
			<xsl:attribute name="id">
				<xsl:text>fig</xsl:text>
				<xsl:value-of select="processing-instruction()[name()='position']"/>
			</xsl:attribute>
			<xsl:element name="par" use-attribute-sets="reference">
				<xsl:apply-templates select="image-link"/>
				<xsl:value-of select="$prompt-separator"/>
				<xsl:apply-templates select="caption"/>
			</xsl:element>
		</xsl:element>					
	</xsl:template>
	
	<xsl:template match="evidence-score">
		<xsl:element name="item">
			<xsl:attribute name="id">
				<xsl:text>evid</xsl:text>
				<xsl:value-of select="processing-instruction()[name()='position']"/>
			</xsl:attribute>
			<xsl:element name="par" use-attribute-sets="reference">
				<xsl:apply-templates select="@score"/>
				<xsl:value-of select="$prompt-separator"/>
				<xsl:apply-templates select="comments"/>
				<xsl:value-of select="$prompt-separator"/>
				<xsl:apply-templates select="bmj-url"/>
			</xsl:element>
		</xsl:element>					
	</xsl:template>
	
	<!-- para prompt attribute -->
	<xsl:template match="@dx-id | @id">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="par" use-attribute-sets="">
			<xsl:element name="inline" use-attribute-sets="para-prompt">
				<xsl:value-of select="$strings//str[@name=$name]/friendly" />
				<xsl:text>: </xsl:text>
			</xsl:element>
			<xsl:element name="inline" use-attribute-sets="">
				<xsl:value-of select="." />
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- para prompt monograph-link -->
	<xsl:template match="monograph-link">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="par" use-attribute-sets="normal">
			<xsl:element name="inline" use-attribute-sets="para-prompt">
				<xsl:value-of select="$strings//str[@name=$name]/friendly" />
				<xsl:text>: </xsl:text>
			</xsl:element>
			<xsl:element name="inline" use-attribute-sets="">
				<xsl:apply-templates/>
				<xsl:text> [</xsl:text>
				<xsl:value-of select="@target"/>
				<xsl:text>]</xsl:text>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<!-- inline prompt _not_ enumerated -->
	<xsl:template match="citation | caption">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline" use-attribute-sets="para-prompt">
			<xsl:value-of select="$strings//str[@name=$name]/friendly" />
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline" use-attribute-sets="">
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>

	<!-- inline prompt _with_ bollean -->
	<xsl:template match="@key-article | @common | @red-flag | @first | @key-factor">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline" use-attribute-sets="para-prompt">
			<xsl:value-of select="$strings//str[@name=$name]/friendly" />
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline" use-attribute-sets="">
			<xsl:element name="formdropdown" use-attribute-sets="formdropdown">
				<xsl:attribute name="defaultValue" select="."/>
				<xsl:element name="choiceList">
					<xsl:element name="choice">
						<xsl:text>true</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>false</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- inline prompt _with_ enumeration -->
	<xsl:template match="@type[parent::factor]">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline" use-attribute-sets="para-prompt">
			<xsl:value-of select="$strings//str[@name=$name]/friendly" />
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline" use-attribute-sets="">
			<xsl:element name="formdropdown" use-attribute-sets="formdropdown">
				<xsl:attribute name="defaultValue" select="."/>
				<xsl:element name="choiceList">
					<xsl:element name="choice">
						<xsl:text>historical</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>symptom</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>sign</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- inline prompt _with_ enumeration -->
	<xsl:template match="@type[parent::test]">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline" use-attribute-sets="para-prompt">
			<xsl:value-of select="$strings//str[@name=$name]/friendly" />
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline" use-attribute-sets="">
			<xsl:element name="formdropdown" use-attribute-sets="formdropdown">
				<xsl:attribute name="defaultValue" select="."/>
				<xsl:element name="choiceList">
					<xsl:element name="choice">
						<xsl:text>laboratory</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>physiologic</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>theraputic trial</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>endoscopy</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>pathology</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>other</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>imaging</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- inline prompt _with_ enumeration -->
	<xsl:template match="@type[parent::poc-citation]">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline" use-attribute-sets="para-prompt">
			<xsl:value-of select="$strings//str[@name=$name]/friendly" />
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline" use-attribute-sets="">
			<xsl:element name="formdropdown" use-attribute-sets="formdropdown">
				<xsl:attribute name="defaultValue" select="."/>
				<xsl:element name="choiceList">
					<xsl:element name="choice">
						<xsl:text>article</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>online</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- inline prompt _with_ enumeration -->
	<xsl:template match="@timeframe[parent::tx-option]">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline" use-attribute-sets="para-prompt">
			<xsl:value-of select="$strings//str[@name=$name]/friendly" />
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline" use-attribute-sets="">
			<xsl:element name="formdropdown" use-attribute-sets="formdropdown">
				<xsl:attribute name="defaultValue" select="."/>
				<xsl:element name="choiceList">
					<xsl:element name="choice">
						<xsl:text>presumptive</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>ongoing</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>acute</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- inline prompt _with_ enumeration -->
	<xsl:template match="@timeframe[parent::complication]">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline" use-attribute-sets="para-prompt">
			<xsl:value-of select="$strings//str[@name=$name]/friendly" />
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline" use-attribute-sets="">
			<xsl:element name="formdropdown" use-attribute-sets="formdropdown">
				<xsl:attribute name="defaultValue" select="."/>
				<xsl:element name="choiceList">
					<xsl:element name="choice">
						<xsl:text>short term</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>long term</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>variable</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- inline prompt _with_ enumeration -->
	<xsl:template match="@strength">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline" use-attribute-sets="para-prompt">
			<xsl:value-of select="$strings//str[@name=$name]/friendly" />
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline" use-attribute-sets="">
			<xsl:element name="formdropdown" use-attribute-sets="formdropdown">
				<xsl:attribute name="defaultValue" select="."/>
				<xsl:element name="choiceList">
					<xsl:element name="choice">
						<xsl:text>strong</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>weak</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- inline prompt _with_ enumeration -->
	<xsl:template match="@frequency">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline" use-attribute-sets="para-prompt">
			<xsl:value-of select="$strings//str[@name=$name]/friendly" />
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline" use-attribute-sets="">
			<xsl:element name="formdropdown" use-attribute-sets="formdropdown">
				<xsl:attribute name="defaultValue" select="."/>
				<xsl:element name="choiceList">
					<xsl:element name="choice">
						<xsl:text>common</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>uncommon</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- inline prompt _with_ enumeration -->
	<xsl:template match="@order">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline" use-attribute-sets="para-prompt">
			<xsl:value-of select="$strings//str[@name=$name]/friendly" />
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline" use-attribute-sets="">
			<xsl:element name="formdropdown" use-attribute-sets="formdropdown">
				<xsl:attribute name="defaultValue" select="."/>
				<xsl:element name="choiceList">
					<xsl:element name="choice">
						<xsl:text>initial</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>subsequent</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>emerging</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- inline prompt _with_ enumeration -->
	<xsl:template match="@tx-line">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline" use-attribute-sets="para-prompt">
			<xsl:value-of select="$strings//str[@name=$name]/friendly" />
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline" use-attribute-sets="">
			<xsl:element name="formdropdown" use-attribute-sets="formdropdown">
				<xsl:attribute name="defaultValue" select="."/>
				<xsl:element name="choiceList">
					<xsl:element name="choice">
						<xsl:text>1</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>2</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>3</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>4</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>5</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>6</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>7</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>8</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>9</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>A</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>P</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- inline prompt _with_ enumeration -->
	<xsl:template match="@modifier">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline" use-attribute-sets="para-prompt">
			<xsl:value-of select="$strings//str[@name=$name]/friendly" />
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline" use-attribute-sets="">
			<xsl:element name="formdropdown" use-attribute-sets="formdropdown">
				<xsl:attribute name="defaultValue" select="."/>
				<xsl:element name="choiceList">
					<xsl:element name="choice">
						<xsl:text>AND</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>or</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>and/or</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>and</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>AND/OR</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- inline prompt _with_ enumeration -->
	<xsl:template match="@likelihood">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline" use-attribute-sets="para-prompt">
			<xsl:value-of select="$strings//str[@name=$name]/friendly" />
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline" use-attribute-sets="">
			<xsl:element name="formdropdown" use-attribute-sets="formdropdown">
				<xsl:attribute name="defaultValue" select="."/>
				<xsl:element name="choiceList">
					<xsl:element name="choice">
						<xsl:text>high</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>medium</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>low</xsl:text>
					</xsl:element>
				</xsl:element>
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
	<!-- inline prompt _with_ enumeration -->
	<xsl:template match="@tier">
		<xsl:variable name="name" select="name()" />
		<xsl:element name="inline" use-attribute-sets="para-prompt">
			<xsl:value-of select="$strings//str[@name=$name]/friendly" />
			<xsl:text>: </xsl:text>
		</xsl:element>
		<xsl:element name="inline" use-attribute-sets="">
			<xsl:element name="formdropdown" use-attribute-sets="formdropdown">
				<xsl:attribute name="defaultValue" select="."/>
				<xsl:element name="choiceList">
					<xsl:element name="choice">
						<xsl:text>1</xsl:text>
					</xsl:element>
					<xsl:element name="choice">
						<xsl:text>2</xsl:text>
					</xsl:element>
					<!-- TODO: more numbers? -->
				</xsl:element>
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>

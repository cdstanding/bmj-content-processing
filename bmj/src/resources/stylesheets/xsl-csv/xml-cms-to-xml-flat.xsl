<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:saxon="http://saxon.sf.net/"

	xmlns:change="http://change.bmj.com" version="2.0">
	<!--xmlns:docato="http://docato.bmj.com" -->

	<xsl:output method="xml" indent="yes" encoding="UTF-8" />

	<xsl:strip-space elements="*" />

	<xsl:include href="../xsl-lib/xinclude.xsl" />

	<xsl:include
		href="../xsl-fo/point-of-care/monograph-shared-reference-lists.xsl" />
	<xsl:include href="../xsl-xml/bh/bh-shared-reference-lists.xsl" />

	<xsl:param name="lang" />
	<xsl:param name="id" />
	<xsl:param name="name" />
	<xsl:param name="date" />

	<xsl:param name="diff-instance-compared-uri" />
	<xsl:param name="custom-paths" />

	<xsl:param name="resourse-export-path" />
	<xsl:param name="server" />
	<xsl:param name="pub-resource-type" />
	<xsl:param name="pub-resource-root" select="name(/*)" />

	<xsl:param name="diff-instance-self-doc"><!-- source -->
		<xsl:apply-templates select="/"
			mode="xinclude-implementation" />
	</xsl:param>
	<xsl:param name="diff-instance-compared-doc"><!-- target -->
		<xsl:apply-templates
			select="document(replace($diff-instance-compared-uri, '\\', '/'))"
			mode="xinclude-implementation" />
	</xsl:param>

	<xsl:param name="resource-level-metadata">

		<xsl:element name="lang">
			<xsl:value-of select="$lang" />
		</xsl:element>

		<xsl:element name="id">
			<xsl:value-of select="$id" />
		</xsl:element>

		<xsl:element name="name">
			<xsl:choose>
				<xsl:when test="//monograph-info/title">
					<xsl:value-of select="normalize-space(//monograph-info/title)" />
				</xsl:when>
				<xsl:when test="/article/front/article-meta/title-group/article-title">
					<xsl:value-of
						select="normalize-space(/article/front/article-meta/title-group/article-title)" />
				</xsl:when>
				<xsl:when test="/systematic-review/info/title">
					<xsl:value-of select="normalize-space(/systematic-review/info/title)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($name)" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>

		<xsl:element name="date">
			<xsl:value-of select="$date" />
		</xsl:element>

		<xsl:element name="ver-old">
			<xsl:value-of
				select="$diff-instance-compared-doc/*/processing-instruction()[contains(name(), 'version-number')]" /><!-- 
				target -->
		</xsl:element>

		<xsl:element name="ver-new">
			<xsl:value-of
				select="/*/processing-instruction()[contains(name(), 'version-number')]" /><!-- 
				self/source -->
		</xsl:element>

	</xsl:param>

	<xsl:template match="/*">

		<xsl:element name="root">
			<xsl:namespace name="xi"
				select="string('http://www.w3.org/2001/XInclude')" />
			<xsl:namespace name="change" select="string('http://change.bmj.com')" />
			<xsl:namespace name="docato" select="string('http://docato.bmj.com')" />

			<xsl:variable name="xpath-strings-1">

				<xsl:for-each select="tokenize($custom-paths, ',')">
					<xsl:variable name="custom-path" select="normalize-space(.)" />

					<xsl:for-each
						select="$diff-instance-compared-doc/saxon:evaluate($custom-path)"><!-- target -->
						<xsl:variable name="xpath">
							<xsl:call-template name="process-xpath" />
						</xsl:variable>

						<xsl:element name="xpath">
							<xsl:attribute name="xpath-end-nodes"
								select="replace($xpath, '^.*?([^/]+?)(\[[0-9]+\])?/([^/]+?)(\[[0-9]+\])?$', '$1/$3')" />

							<xsl:value-of
								select="replace($xpath, '^(.+?)/([^/]+?)(\[[0-9]+\])?$', '$1')" />
							<xsl:text>/(</xsl:text>
							<xsl:value-of
								select="replace($xpath, '^(.+?)/([^/]+?)(\[[0-9]+\])?$', '$2')" />
							<xsl:text>|</xsl:text>
							<xsl:text>processing-instruction()[name()='diff-instance-compared-doc-matched-node-id']</xsl:text>
							<xsl:text>)</xsl:text>

						</xsl:element>

					</xsl:for-each>




				</xsl:for-each>

			</xsl:variable>

			<!-- Added the below variable for Mantis ID 11686 Not displaying the newly 
				added elements in the change report -->

			<xsl:variable name="xpath-strings-2">

				<xsl:for-each select="tokenize($custom-paths, ',')">
					<xsl:variable name="custom-path" select="normalize-space(.)" />

					<xsl:for-each
						select="$diff-instance-self-doc/saxon:evaluate($custom-path)"><!-- source -->
						<xsl:variable name="xpath">
							<xsl:call-template name="process-xpath" />
						</xsl:variable>

						<xsl:element name="xpath">
							<xsl:attribute name="xpath-end-nodes"
								select="replace($xpath, '^.*?([^/]+?)(\[[0-9]+\])?/([^/]+?)(\[[0-9]+\])?$', '$1/$3')" />

							<xsl:value-of
								select="replace($xpath, '^(.+?)/([^/]+?)(\[[0-9]+\])?$', '$1')" />
							<xsl:text>/(</xsl:text>
							<xsl:value-of
								select="replace($xpath, '^(.+?)/([^/]+?)(\[[0-9]+\])?$', '$2')" />
							<xsl:text>|</xsl:text>
							<xsl:text>processing-instruction()[name()='diff-instance-compared-doc-matched-node-id']</xsl:text>
							<xsl:text>)</xsl:text>

						</xsl:element>

					</xsl:for-each>




				</xsl:for-each>

			</xsl:variable>

			<!-- Added the below variable for Mantis ID 11686 Not displaying the newly 
				added elements in the change report -->
			<xsl:comment>
				merging data 1 and data 2
			</xsl:comment>

			<xsl:variable name="xpath-strings">

				<xsl:variable name="data1-joined">
					<xsl:value-of select="string-join(($xpath-strings-1//xpath),',')" />
				</xsl:variable>
				<!-- Get the xpath strings that are present in diff-instance-self-doc 
					and not in diff-instance-compared-doc -->
				<xsl:for-each select="$xpath-strings-2/xpath">
					<xsl:if
						test="
                    @xpath-end-nodes != preceding-sibling::xpath[1]/@xpath-end-nodes
                    or not(preceding-sibling::xpath[1]/@xpath-end-nodes)
                    ">

						<xsl:variable name="xpath-string-b" select="." />

						<xsl:if test="not(contains($data1-joined,$xpath-string-b))">
							<xsl:element name="xpath">
								<xsl:value-of select="$xpath-string-b" />
							</xsl:element>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>

			</xsl:variable>

			<!-- Traverse through the xpath strings in the compared document -->
			<xsl:for-each select="$xpath-strings-1/xpath">
				<xsl:variable name="xpath-string" select="." />
				<xsl:variable name="xpath-end-nodes" select="@xpath-end-nodes" />

				<!-- <xsl:message select="concat('xpath-end-nodes:', @xpath-end-nodes, 
					' ', preceding-sibling::xpath[1]/@xpath-end-nodes)"/> -->

				<xsl:if
					test="
                    @xpath-end-nodes != preceding-sibling::xpath[1]/@xpath-end-nodes
                    or not(preceding-sibling::xpath[1]/@xpath-end-nodes)
                    ">

					<xsl:message>
						<xsl:text>xpath-passed-1: </xsl:text>
						<xsl:value-of select="$xpath-string" />
					</xsl:message>

					<xsl:for-each
						select="$diff-instance-compared-doc/saxon:evaluate($xpath-string)"><!-- target -->
						<xsl:variable name="diff-instance-compared-doc-matched-node-id"
							select="self::processing-instruction()[name()='diff-instance-compared-doc-matched-node-id']" />
						<xsl:variable name="xpath">
							<xsl:call-template name="process-xpath" />
						</xsl:variable>

						<xsl:message>
							<xsl:text>xpath-passed-2: </xsl:text>
							<xsl:value-of select="$xpath" />
						</xsl:message>

						<xsl:choose>

							<xsl:when test="self::processing-instruction()">

								<xsl:for-each
									select="
                                    $diff-instance-self-doc//processing-instruction()
                                    [
                                    name()='xh-diff-pi'
                                    and substring-after(., 'id:') = $diff-instance-compared-doc-matched-node-id
                                    ]
                                    /following-sibling::element()[1][name()=substring-after($xpath-end-nodes, '/')]
                                    ">

									<xsl:call-template name="process-row">
										<xsl:with-param
											name="diff-instance-compared-doc-matched-node-inverse"
											select="string('true')" />
										<xsl:with-param
											name="diff-instance-compared-doc-matched-node-id-matched"
											select="$diff-instance-compared-doc-matched-node-id" />
									</xsl:call-template>

								</xsl:for-each>

							</xsl:when>

							<xsl:otherwise>

								<xsl:for-each select="self::element()">

									<xsl:call-template name="process-row" />

								</xsl:for-each>

							</xsl:otherwise>

						</xsl:choose>

						<!-- TODO: not working? -->
						<xsl:if
							test="
                            not($diff-instance-compared-doc/saxon:evaluate($xpath))
                            and $diff-instance-self-doc/saxon:evaluate($xpath)
                            ">

							<xsl:message>
								<xsl:text>xpath-passed-5: </xsl:text>
								<xsl:value-of select="$xpath" />
							</xsl:message>

							<xsl:for-each select="$diff-instance-self-doc/saxon:evaluate($xpath)"><!-- source -->

								<xsl:comment>
									diff-instance-compared-doc-matched-node-id-matched
								</xsl:comment>

								<xsl:call-template name="process-row">
									<xsl:with-param
										name="diff-instance-compared-doc-matched-node-inverse" select="string('true')" />
									<xsl:with-param
										name="diff-instance-compared-doc-matched-node-id-matched"
										select="self::processing-instruction()[name()='diff-instance-compared-doc-matched-node-id']" />
								</xsl:call-template>

							</xsl:for-each>

						</xsl:if>

					</xsl:for-each>

				</xsl:if>

			</xsl:for-each>
			<!-- Traverse through the xpath strings that are present only in self 
				document -->
			<!-- Added the below section for Mantis ID 11686 Not displaying the newly 
				added elements in the change report -->

			<xsl:for-each select="$xpath-strings/xpath">
				<xsl:variable name="xpath-string" select="." />
				<xsl:variable name="xpath-end-nodes" select="@xpath-end-nodes" />

				<!-- <xsl:message select="concat('xpath-end-nodes:', @xpath-end-nodes, 
					' ', preceding-sibling::xpath[1]/@xpath-end-nodes)"/> -->


				<xsl:message>
					<xsl:text>xpath-passed-1: </xsl:text>
					<xsl:value-of select="$xpath-string" />
				</xsl:message>

				<xsl:for-each
					select="$diff-instance-self-doc/saxon:evaluate($xpath-string)"><!-- target -->
					<xsl:variable name="diff-instance-compared-doc-matched-node-id"
						select="self::processing-instruction()[name()='diff-instance-compared-doc-matched-node-id']" />
					<xsl:variable name="xpath">
						<xsl:call-template name="process-xpath" />
					</xsl:variable>


					<xsl:message>
						<xsl:text>xpath-passed-5: </xsl:text>
						<xsl:value-of select="$xpath" />
					</xsl:message>

					<xsl:for-each select="$diff-instance-self-doc/saxon:evaluate($xpath)"><!-- source -->

						<xsl:comment>
							diff-instance-compared-doc-matched-node-id-matched
						</xsl:comment>

						<xsl:call-template name="process-row">
							<xsl:with-param name="diff-instance-compared-doc-matched-node-inverse"
								select="string('true')" />
							<xsl:with-param
								name="diff-instance-compared-doc-matched-node-id-matched"
								select="self::processing-instruction()[name()='diff-instance-compared-doc-matched-node-id']" />
						</xsl:call-template>

					</xsl:for-each>



				</xsl:for-each>



			</xsl:for-each>

			<xsl:choose>

				<xsl:when
					test="
                    contains($pub-resource-type, 'patient')
                    or $pub-resource-type='systematic-review'
                    ">

					<xsl:call-template name="process-glosses" />
					<xsl:call-template name="process-references" />
					<xsl:call-template name="process-tables" />
					<xsl:call-template name="process-figures" />

				</xsl:when>

				<xsl:otherwise>
					<xsl:call-template name="process-references" />
				</xsl:otherwise>

			</xsl:choose>

		</xsl:element>

	</xsl:template>

	<xsl:template name="process-row">
		<xsl:param name="diff-instance-compared-doc-matched-node-inverse" />
		<xsl:param name="diff-instance-compared-doc-matched-node-id-matched" />

		<xsl:param name="xpath">
			<xsl:variable name="process-xpath">
				<xsl:call-template name="process-xpath" />
			</xsl:variable>

			<xsl:choose>

				<xsl:when test="name()='article'">
					<xsl:value-of select="$process-xpath" />
					<xsl:text>/front[1]/article-meta</xsl:text>
				</xsl:when>

				<xsl:when
					test="
                    @*:id 
                    and name()!='figure' 
                    and name()!='option'					
                    ">
					<!-- and name()!='gloss', etc. ?? -->
					<xsl:value-of select="replace($process-xpath, '\[\d+\]$', '')" />
					<xsl:text>[@id='</xsl:text>
					<xsl:value-of select="@*:id" />
					<xsl:text>']</xsl:text>
				</xsl:when>

				<xsl:when test="name()='option'">
					<xsl:value-of select="$process-xpath" />
				</xsl:when>

				<!-- or name()='gloss', etc. ?? -->
				<!--<xsl:when test=" name()='figure' and not(@*:id) "> <xsl:value-of 
					select="replace($process-xpath, '\[\d+\]$', '')" /> <xsl:text>[@id='</xsl:text> 
					<xsl:value-of select="processing-instruction()[name()='target']" /> <xsl:text>']</xsl:text> 
					</xsl:when> -->

				<!-- TODO: imply better figure @id, position() not useful in comparing 
					moving xpaths later -->

				<xsl:otherwise>
					<xsl:value-of select="$process-xpath" />
				</xsl:otherwise>

			</xsl:choose>

		</xsl:param>

		<!-- instance-compared when inverse not true -->
		<xsl:param name="diff-instance-compared-doc-xh-diff-pi"
			select="
            preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            
            /preceding-sibling::node()[1]
            [
            self::comment() 
            and contains(., 'including')
            ]
            
            /preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            
            /preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'xh-diff-pi'
            ]
            
            |
            
            preceding-sibling::node()[1]
            [
            self::comment() 
            and contains(., 'including')
            ]
            
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'xh-diff-pi'
            ]
            
            |
            
            preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            
            /preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'xh-diff-pi'
            ]
            
            |
            
            preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'xh-diff-pi'
            ]
            " />

		<xsl:param name="diff-instance-compared-doc-matched-node-id"
			select="
            preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            /preceding-sibling::node()[1]
            [
            self::comment() 
            and contains(., 'including')
            ]
            /preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'diff-instance-compared-doc-matched-node-id'
            ]
            
            |
            
            preceding-sibling::node()[1]
            [
            self::comment() 
            and contains(., 'including')
            ]
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'diff-instance-compared-doc-matched-node-id'
            ]
            
            |
            
            preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'diff-instance-compared-doc-matched-node-id'
            ]
            
            |
            
            preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'diff-instance-compared-doc-matched-node-id'
            ]
            " />

		<xsl:param
			name="xpath-diff-instance-self-doc-matched-new-only-merged-with-old">

			<xsl:choose>

				<xsl:when
					test="
                    $diff-instance-self-doc//processing-instruction()
                    [
                    name()='xh-diff-pi'
                    and
                    (
                    substring-after(., 'id:') = substring-before(substring-after($diff-instance-compared-doc-xh-diff-pi, 'mId:'), ' id:')
                    and substring-before(substring-after(., 'mId:'), ' id:') = substring-after($diff-instance-compared-doc-xh-diff-pi, 'id:')  
                    )
                    ]
                    /following-sibling::element()[1]/@*:id
                    ">

					<xsl:value-of select="replace($xpath, '^(.+?)\[[^\]]\]$', '$1')" />

					<xsl:text>[@id='</xsl:text>

					<xsl:value-of
						select="
                        $diff-instance-self-doc//processing-instruction()
                        [
                        name()='xh-diff-pi'
                        and
                        (
                        substring-after(., 'id:') = substring-before(substring-after($diff-instance-compared-doc-xh-diff-pi, 'mId:'), ' id:')
                        and substring-before(substring-after(., 'mId:'), ' id:') = substring-after($diff-instance-compared-doc-xh-diff-pi, 'id:')  
                        )
                        ]
                        /following-sibling::element()[1]/@*:id
                        " />

					<xsl:text>']</xsl:text>

				</xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="$xpath" />
				</xsl:otherwise>

			</xsl:choose>

		</xsl:param>


		<xsl:param
			name="xpath-diff-compared-self-doc-matched-new-merged-with-old-no-change"
			select="
            
            $diff-instance-compared-doc-matched-node-inverse!='true'
            
            and
            
            not(
            preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            
            |
            
            preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            )
            
            and 
            
            (
            $diff-instance-self-doc/saxon:evaluate($xpath)/preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            
            |
            
            $diff-instance-self-doc/saxon:evaluate($xpath)/preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            )
            " />

		<xsl:param
			name="xpath-diff-instance-self-doc-matched-new-merged-with-old-with-change"
			select="
            
            $diff-instance-compared-doc-matched-node-inverse='true'
            
            and
            
            (
            preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            
            |
            
            preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            )
            
            and 
            
            $diff-instance-compared-doc/saxon:evaluate($xpath)
            
            and 
            
            not(
            $diff-instance-compared-doc/saxon:evaluate($xpath)/preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            
            |
            
            $diff-instance-compared-doc/saxon:evaluate($xpath)/preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            )
            " />

		<xsl:param name="xpath-diff-instance-self-doc-not-matched-with-old"
			select="
            
            $diff-instance-compared-doc-matched-node-inverse='true'
            
            and
            
            (
            preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            
            |
            
            preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            )
            
            and 
            
            not($diff-instance-compared-doc/saxon:evaluate($xpath)/preceding-sibling::node()[1])
            " />



		<!-- NOTE: removed testing and processing sibling pi row as now done higher 
			up in new for-each -->
		<!--<xsl:if test="$diff-instance-compared-doc-matched-node-id[string-length(normalize-space(.))!=0]"> 
			<xsl:for-each select=" $diff-instance-self-doc//processing-instruction() 
			[ name()='xh-diff-pi' and substring-after(., 'id:') = $diff-instance-compared-doc-matched-node-id 
			] /following-sibling::element()[1] "> <xsl:comment>diff-instance-compared-doc-matched-node-id-matched</xsl:comment> 
			<xsl:call-template name="process-row"> <xsl:with-param name="diff-instance-compared-doc-matched-node-inverse" 
			select="string('true')"/> <xsl:with-param name="diff-instance-compared-doc-matched-node-id-matched" 
			select="$diff-instance-compared-doc-matched-node-id"/> </xsl:call-template> 
			</xsl:for-each> </xsl:if> -->

		<!-- TODO: add test if both old/new no string-length then ignore, consider 
			inverse and pi placements -->

		<xsl:element name="row">

			<xsl:copy-of select="$resource-level-metadata" />

			<xsl:element name="section-path">
				<xsl:value-of select="$xpath" />
			</xsl:element>

			<xsl:choose>

				<!-- diff-instance-compared-doc-matched-node-inverse -->
				<xsl:when
					test="
                    $diff-instance-compared-doc-matched-node-inverse='true'
                    
                    and
                    
                    $diff-instance-self-doc//processing-instruction()
                    [
                    name()='xh-diff-pi'
                    and substring-after(., 'id:') = $diff-instance-compared-doc-matched-node-id-matched
                    and string-length(substring-before(substring-after(., 'mId:'), ' id:')) != 0
                    and substring-before(substring-after(., 'matched:'), ' mId:') = 'ma'
                    ]
                    
                    ">

					<xsl:comment>
						<xsl:text>diff-instance-compared-doc-matched-node-inverse </xsl:text>
						<xsl:value-of select="$xpath" />
					</xsl:comment>

					<xsl:element name="details-of-change-old" />

					<xsl:element name="details-of-change-new">

						<xsl:element name="change:div">

							<xsl:choose>

								<xsl:when test="$diff-instance-compared-doc/saxon:evaluate($xpath)">
									<xsl:attribute name="class" select="string('redline-moved')" />
								</xsl:when>

								<xsl:otherwise>
									<xsl:attribute name="class" select="string('redline-insert')" />
									<xsl:comment>
										redline-insert forced as diff confused and merged new with old
										xpath
									</xsl:comment>
								</xsl:otherwise>

							</xsl:choose>

							<xsl:apply-templates
								select="
                                $diff-instance-self-doc//processing-instruction()
                                [
                                name()='xh-diff-pi'
                                and substring-after(., 'id:') = $diff-instance-compared-doc-matched-node-id-matched
                                ]
                                /following-sibling::element()[1]
                                ">
								<xsl:with-param name="xpath-root" select="string('true')" />
								<xsl:with-param name="redline-moved" select="string('true')" />
							</xsl:apply-templates>

						</xsl:element>

					</xsl:element>

				</xsl:when>

				<!-- xpath-diff-instance-self-doc-matched-new-only-merged-with-old -->
				<xsl:when
					test="
                    $xpath-diff-instance-self-doc-matched-new-only-merged-with-old != $xpath
                    and not($diff-instance-compared-doc/saxon:evaluate($xpath-diff-instance-self-doc-matched-new-only-merged-with-old))
                    ">

					<xsl:comment>
						<xsl:text>xpath-diff-instance-self-doc-matched-new-only-merged-with-old </xsl:text>
						<xsl:value-of
							select="$xpath-diff-instance-self-doc-matched-new-only-merged-with-old" />
					</xsl:comment>

					<xsl:element name="details-of-change-old">

						<!-- target -->
						<xsl:apply-templates
							select="$diff-instance-compared-doc/saxon:evaluate($xpath)">
							<xsl:with-param name="xpath-root" select="string('true')" />
							<xsl:with-param name="redline-moved" select="string('true')" />
						</xsl:apply-templates>

					</xsl:element>

					<xsl:element name="details-of-change-new">

						<!-- source -->
						<xsl:apply-templates
							select="$diff-instance-self-doc/saxon:evaluate($xpath)">
							<xsl:with-param name="xpath-root" select="string('true')" />
							<xsl:with-param name="redline-moved" select="string('true')" />
						</xsl:apply-templates>

					</xsl:element>

				</xsl:when>

				<!-- xpath-diff-compared-self-doc-matched-new-merged-with-old-no-change -->
				<xsl:when
					test="$xpath-diff-compared-self-doc-matched-new-merged-with-old-no-change">

					<xsl:comment>
						<xsl:text>xpath-diff-compared-self-doc-matched-new-merged-with-old-no-change </xsl:text>
						<xsl:value-of select="$xpath" />
					</xsl:comment>

					<xsl:element name="details-of-change-old">

						<xsl:element name="change:div">
							<xsl:attribute name="class" select="string('redline-moved')" />

							<!-- target -->
							<xsl:apply-templates
								select="$diff-instance-compared-doc/saxon:evaluate($xpath)">
								<xsl:with-param name="xpath-root" select="string('true')" />
								<xsl:with-param name="redline-moved" select="string('true')" />
							</xsl:apply-templates>

						</xsl:element>

					</xsl:element>

					<xsl:element name="details-of-change-new" />

				</xsl:when>

				<!-- xpath-diff-instance-self-doc-matched-new-merged-with-old-with-change -->
				<xsl:when
					test="$xpath-diff-instance-self-doc-matched-new-merged-with-old-with-change">

					<xsl:comment>
						<xsl:text>xpath-diff-instance-self-doc-matched-new-merged-with-old-with-change </xsl:text>
						<xsl:value-of select="$xpath" />
					</xsl:comment>

					<xsl:element name="details-of-change-old" />

					<xsl:element name="details-of-change-new">

						<xsl:element name="change:div">
							<xsl:attribute name="class" select="string('redline-moved')" />

							<!-- source -->
							<xsl:apply-templates
								select="$diff-instance-self-doc/saxon:evaluate($xpath)">
								<xsl:with-param name="xpath-root" select="string('true')" />
								<xsl:with-param name="redline-moved" select="string('true')" />
							</xsl:apply-templates>

						</xsl:element>

					</xsl:element>

				</xsl:when>

				<!--xpath-diff-instance-self-doc-not-matched-with-old -->
				<xsl:when test="$xpath-diff-instance-self-doc-not-matched-with-old">

					<xsl:comment>
						<xsl:text>xpath-diff-instance-self-doc-not-matched-with-old </xsl:text>
						<xsl:value-of select="$xpath" />
					</xsl:comment>

					<xsl:element name="details-of-change-old" />

					<xsl:element name="details-of-change-new">

						<xsl:element name="change:div">
							<xsl:attribute name="class" select="string('redline-insert')" />

							<!-- source -->
							<xsl:apply-templates
								select="$diff-instance-self-doc/saxon:evaluate($xpath)">
								<xsl:with-param name="xpath-root" select="string('true')" />
								<xsl:with-param name="redline-moved" select="string('true')" />
							</xsl:apply-templates>

						</xsl:element>

					</xsl:element>

				</xsl:when>

				<!-- diff-instance-compared-doc-matched-?? -->
				<xsl:when
					test="
                    $diff-instance-self-doc//processing-instruction()
                    [
                    name()='xh-diff-pi'
                    and
                    (
                    substring-after(., 'id:') = substring-before(substring-after($diff-instance-compared-doc-xh-diff-pi, 'mId:'), ' id:')
                    and substring-before(substring-after(., 'mId:'), ' id:') = substring-after($diff-instance-compared-doc-xh-diff-pi, 'id:')  
                    )
                    ]
                    ">

					<xsl:comment>
						<xsl:text>diff-instance-compared-doc-matched-?? </xsl:text>
						<xsl:value-of select="$xpath" />
					</xsl:comment>

					<xsl:element name="details-of-change-old">

						<xsl:element name="change:div">
							<xsl:attribute name="class" select="string('redline-moved')" />

							<!-- target -->
							<xsl:apply-templates
								select="$diff-instance-compared-doc/saxon:evaluate($xpath)">
								<xsl:with-param name="xpath-root" select="string('true')" />
								<xsl:with-param name="redline-moved" select="string('true')" />
							</xsl:apply-templates>

						</xsl:element>

					</xsl:element>

					<xsl:element name="details-of-change-new" />

				</xsl:when>

				<xsl:otherwise>

					<xsl:comment>
						<xsl:text>xpath-diff-instance-compared-doc-matched-default </xsl:text>
						<xsl:value-of select="$xpath" />
					</xsl:comment>

					<xsl:element name="details-of-change-old">
						<!-- target -->
						<xsl:apply-templates
							select="$diff-instance-compared-doc/saxon:evaluate($xpath)">
							<xsl:with-param name="xpath-root" select="string('true')" />
						</xsl:apply-templates>
					</xsl:element>

					<xsl:element name="details-of-change-new">
						<!-- source -->
						<xsl:apply-templates
							select="$diff-instance-self-doc/saxon:evaluate($xpath)">
							<xsl:with-param name="xpath-root" select="string('true')" />
						</xsl:apply-templates>
					</xsl:element>

				</xsl:otherwise>

			</xsl:choose>

		</xsl:element>

		<!-- here on we try process xincluded derived sub-article row's -->
		<xsl:for-each
			select="
            
            self::tx-option/tx-options/
                (tx-option | processing-instruction()[name()='diff-instance-compared-doc-matched-node-id'])
                
            | self::treatments/
                (
                (article | processing-instruction()[name()='diff-instance-compared-doc-matched-node-id'])
                |(article/*/(element()[name()!='article-meta'] | processing-instruction()[name()='diff-instance-compared-doc-matched-node-id']))
                )
            ">

			<!--| self::question/ (option | processing-instruction()[name()='diff-instance-compared-doc-matched-node-id']) -->

			<xsl:variable name="diff-instance-compared-doc-matched-node-id"
				select="self::processing-instruction()[name()='diff-instance-compared-doc-matched-node-id']" />

			<xsl:choose>

				<xsl:when test="self::processing-instruction()">

					<xsl:for-each
						select="
                        $diff-instance-self-doc//processing-instruction()
                        [
                        name()='xh-diff-pi'
                        and substring-after(., 'id:') = $diff-instance-compared-doc-matched-node-id
                        ]
                        /
                        (
                        following-sibling::element()[1][name()='tx-option' or name()='option']
                        | following-sibling::element()[1][name()='article']
                        | following-sibling::element()[1][name()='article']/*/element()[name()!='article-meta']
                        )
                        ">

						<xsl:call-template name="process-row">
							<xsl:with-param name="diff-instance-compared-doc-matched-node-inverse"
								select="string('true')" />
							<xsl:with-param
								name="diff-instance-compared-doc-matched-node-id-matched"
								select="$diff-instance-compared-doc-matched-node-id" />
						</xsl:call-template>

					</xsl:for-each>

				</xsl:when>

				<xsl:otherwise>

					<!-- TODO: try to avoid re-used xincluded derived sub-article rows -->
					<xsl:for-each
						select="
                        self::element()[1][name()='tx-option' or name()='option']
                        | self::element()[1][name()='article']
                        | self::element()[1][name()='article']/*/element()[name()!='article-meta']
                        ">

						<xsl:call-template name="process-row" />

					</xsl:for-each>

				</xsl:otherwise>

			</xsl:choose>

		</xsl:for-each>

		<!-- add missing block if last and preseding node -->
		<!--<xsl:variable name="diff-instance-compared-doc-matched-node-id" select=" 
			following-sibling::node()[1] [ self::text() and string-length(normalize-space(.))=0 
			] /following-sibling::node()[1] [ self::processing-instruction() and name() 
			= 'diff-instance-compared-doc-matched-node-id' ] | following-sibling::node()[1] 
			[ self::processing-instruction() and name() = 'diff-instance-compared-doc-matched-node-id' 
			] "/> -->
		<!--<xsl:if test="$diff-instance-compared-doc-matched-node-id[string-length(normalize-space(.))!=0] 
			and position()=last()"> <xsl:for-each select=" $diff-instance-self-doc//processing-instruction() 
			[ name()='xh-diff-pi' and substring-after(., 'id:') = $diff-instance-compared-doc-matched-node-id 
			] /following-sibling::element()[1] "> <xsl:comment>diff-instance-compared-doc-matched-node-id-matched</xsl:comment> 
			<xsl:call-template name="process-row"> <xsl:with-param name="diff-instance-compared-doc-matched-node-inverse" 
			select="string('true')"/> <xsl:with-param name="diff-instance-compared-doc-matched-node-id-matched" 
			select="$diff-instance-compared-doc-matched-node-id"/> </xsl:call-template> 
			</xsl:for-each> </xsl:if> -->

	</xsl:template>

	<xsl:template match="element()">
		<xsl:param name="xpath-root" />
		<xsl:param name="redline-moved" />

		<!-- ### todo: add condition to avoid repeat display of reused child tx-options 
			### -->

		<xsl:if
			test="
            $xpath-root = 'true'
            and $redline-moved != 'true'
            
            and 
            (
            
            (
            preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            
            /preceding-sibling::node()[1]
            [
            self::comment() 
            and contains(., 'including')
            ]
            
            /preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            )
            
            or
            preceding-sibling::node()[1]
            [
            self::comment() 
            and contains(., 'including')
            ]
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            
            or
            (
            preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            )
            or
            (
            preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            )
            )
            
            and
            
            (
            (
            following-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            /following-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-end'
            ]
            )
            or
            (
            following-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-end'
            ]
            )
            
            )
            ">

			<xsl:apply-templates
				select="
                preceding-sibling::node()[1]
                [
                self::text() 
                and string-length(normalize-space(.))=0
                ]
                /preceding-sibling::node()[1]
                [
                self::comment() 
                and contains(., 'including')
                ]                
                /preceding-sibling::node()[1]
                [
                self::text() 
                and string-length(normalize-space(.))=0
                ]
                /preceding-sibling::node()[1]
                [
                self::processing-instruction() 
                and name() = 'serna-redline-start'
                ]
                
                |
                
                preceding-sibling::node()[1]
                [
                self::comment() 
                and contains(., 'including')
                ]                
                /preceding-sibling::node()[1]
                [
                self::processing-instruction() 
                and name() = 'serna-redline-start'
                ]
                
                |
                
                preceding-sibling::node()[1]
                [
                self::text() 
                and string-length(normalize-space(.))=0
                ]
                /preceding-sibling::node()[1]
                [
                self::processing-instruction() 
                and name() = 'serna-redline-start'
                ]
                
                |
                
                preceding-sibling::node()[1]
                [
                self::processing-instruction() 
                and name() = 'serna-redline-start'
                ]
                ">
				<xsl:with-param name="div" select="string('true')" />
				<xsl:with-param name="redline-moved" select="$redline-moved" />
			</xsl:apply-templates>

		</xsl:if>

		<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
		<xsl:value-of select="name()" />
		<xsl:call-template name="process-attributes" />

		<xsl:choose>

			<xsl:when
				test="count(child::node())=0 or (count(child::node())=1 and child::node()[self::text() and string-length(normalize-space(.))=0])">

				<xsl:text disable-output-escaping="yes"> /&gt;</xsl:text>

			</xsl:when>

			<xsl:otherwise>

				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>

				<!-- TODO: add more specific condition test by assuming parent(s) name -->
				<xsl:choose>

					<xsl:when
						test="
                        substring-after(preceding-sibling::comment()[1], 'including ')
                        and 
                        (
                        name()='tx-option'
                        or name()='article'
                        or name()='option'
                        or name()='figure' 
                        or name()='table'
                        or name()='evidence-score'
                        )
                        ">
						<xsl:processing-instruction name="target"
							select="substring-after(preceding-sibling::comment()[1], 'including ')" />
					</xsl:when>

					<xsl:when
						test="
                        substring-after(parent::front/parent::article/preceding-sibling::comment()[1], 'including ')
                        and 
                        name()='article-meta'
                        ">
						<xsl:processing-instruction name="target"
							select="substring-after(parent::front/parent::article/preceding-sibling::comment()[1], 'including ')" />
					</xsl:when>

				</xsl:choose>

				<!-- TODO: do something smart avoid processing children if xpath matches 
					section-list passed -->
				<xsl:apply-templates
					select="
                    node()
                    [
                    name()!='tx-options'
                    and name()!='article'
                    and name()!='option'					
					]
                    " />
				<!--and not(parent::article) and self::article/front/article-meta -->

				<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
				<xsl:value-of select="name()" />
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>

			</xsl:otherwise>

		</xsl:choose>

		<xsl:if
			test="
            (
            
            (
            preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            /preceding-sibling::node()[1]
            [
            self::comment() 
            and contains(., 'including')
            ]
            /preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            )
            or
            (
            preceding-sibling::node()[1]
            [
            self::comment() 
            and contains(., 'including')
            ]
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            )
            
            or
            
            (
            preceding-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            /preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            )
            or
            (
            preceding-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-start'
            ]
            )
            )
            
            and
            
            (
            (
            following-sibling::node()[1]
            [
            self::text() 
            and string-length(normalize-space(.))=0
            ]
            /following-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-end'
            ]
            )
            or
            (
            following-sibling::node()[1]
            [
            self::processing-instruction() 
            and name() = 'serna-redline-end'
            ]
            )
            )
            
            and $xpath-root = 'true'
            and $redline-moved != 'true'
            ">

			<xsl:apply-templates
				select="
                following-sibling::node()[1]
                [
                self::text() 
                and string-length(normalize-space(.))=0
                ]
                /following-sibling::node()[1]
                [
                self::processing-instruction() 
                and name() = 'serna-redline-end'
                ]
                
                |
                
                following-sibling::node()[1]
                [
                self::processing-instruction() 
                and name() = 'serna-redline-end'
                ]
                ">
				<xsl:with-param name="div" select="string('true')" />
				<xsl:with-param name="redline-moved" select="$redline-moved" />
			</xsl:apply-templates>

		</xsl:if>

	</xsl:template>

	<xsl:template name="process-glosses">

		<xsl:variable name="linked-elements">

			<xsl:for-each select="$diff-instance-self-doc">

				<xsl:call-template name="process-gloss-xref-links">
					<xsl:with-param name="item-count" select="1" />
					<xsl:with-param name="link-index" select="1" />
					<xsl:with-param name="link-count"
						select="count(//xref[@ref-type='gloss']) + 1" />
				</xsl:call-template>

				<xsl:call-template name="process-gloss-links">
					<xsl:with-param name="item-count" select="1" />
					<xsl:with-param name="link-index" select="1" />
					<xsl:with-param name="link-count" select="count(//gloss-link) + 1" />
				</xsl:call-template>

			</xsl:for-each>

		</xsl:variable>

		<xsl:for-each select="$linked-elements/*">

			<xsl:element name="row">

				<xsl:copy-of select="$resource-level-metadata" />

				<!-- TODO: could this be made generic?! -->
				<xsl:element name="section-path">
					<xsl:value-of
						select="concat('/', $pub-resource-root, '/glosses/gloss[', processing-instruction()[name()='position'], ']')" />
				</xsl:element>

				<xsl:element name="details-of-change-old">
					<xsl:variable name="diff-instance-self-target"
						select="processing-instruction()[name()='target']" />
					<xsl:variable name="details-of-change-old-linked-element-filename"
						select="concat(replace(translate($resourse-export-path, '\\', '/'), 'source', 'target'), $diff-instance-self-target)" />

					<xsl:choose>

						<xsl:when
							test="count(processing-instruction()[name()='serna-redline-start'])=3">

							<xsl:apply-templates
								select="processing-instruction()[name() = 'serna-redline-start'][1]">
								<xsl:with-param name="div" select="string('true')" />
							</xsl:apply-templates>

							<xsl:element name="{name()}">
								<xsl:copy-of select="@*" />
								<xsl:apply-templates
									select="document($details-of-change-old-linked-element-filename)/*/*" />
							</xsl:element>

							<xsl:apply-templates
								select="processing-instruction()[name() = 'serna-redline-end'][1]">
								<xsl:with-param name="div" select="string('true')" />
							</xsl:apply-templates>

						</xsl:when>

						<xsl:otherwise>

							<xsl:element name="{name()}">
								<xsl:copy-of select="@*" />
								<xsl:apply-templates
									select="document($details-of-change-old-linked-element-filename)/*/*" />
							</xsl:element>

						</xsl:otherwise>

					</xsl:choose>

				</xsl:element>

				<xsl:element name="details-of-change-new">

					<xsl:choose>

						<xsl:when
							test="count(processing-instruction()[name()='serna-redline-start'])=3">

							<xsl:apply-templates
								select="processing-instruction()[name() = 'serna-redline-start'][1]">
								<xsl:with-param name="div" select="string('true')" />
							</xsl:apply-templates>

							<xsl:element name="{name()}">
								<xsl:copy-of select="@*" />
								<xsl:apply-templates />
							</xsl:element>

							<xsl:apply-templates
								select="processing-instruction()[name() = 'serna-redline-end'][1]">
								<xsl:with-param name="div" select="string('true')" />
							</xsl:apply-templates>

						</xsl:when>

						<xsl:otherwise>

							<xsl:element name="{name()}">
								<xsl:copy-of select="@*" />
								<xsl:apply-templates />
							</xsl:element>

						</xsl:otherwise>

					</xsl:choose>

				</xsl:element>

			</xsl:element>

		</xsl:for-each>

	</xsl:template>

	<xsl:template name="process-references">

		<xsl:variable name="diff-instance-self-doc-references">

			<xsl:for-each select="$diff-instance-self-doc">

				<xsl:choose>

					<xsl:when test="contains($pub-resource-type, 'patient')">
						<xsl:call-template name="process-nlm-reference-links">
							<xsl:with-param name="item-count" select="1" />
							<xsl:with-param name="link-index" select="1" />
							<xsl:with-param name="link-count"
								select="count(//xref[@ref-type='bibr']) + 1" />
						</xsl:call-template>
					</xsl:when>

					<xsl:otherwise>
						<xsl:call-template name="process-reference-links">
							<xsl:with-param name="item-count" select="1" />
							<xsl:with-param name="link-index" select="1" />
							<xsl:with-param name="link-count" select="count(//reference-link) + 1" />
						</xsl:call-template>
					</xsl:otherwise>

				</xsl:choose>

			</xsl:for-each>

		</xsl:variable>

		<xsl:variable name="diff-instance-compared-doc-references">

			<xsl:for-each select="$diff-instance-compared-doc">

				<xsl:choose>

					<xsl:when test="contains($pub-resource-type, 'patient')">
						<xsl:call-template name="process-nlm-reference-links">
							<xsl:with-param name="item-count" select="1" />
							<xsl:with-param name="link-index" select="1" />
							<xsl:with-param name="link-count"
								select="count(//xref[@ref-type='bibr']) + 1" />
						</xsl:call-template>
					</xsl:when>

					<xsl:otherwise>
						<xsl:call-template name="process-reference-links">
							<xsl:with-param name="item-count" select="1" />
							<xsl:with-param name="link-index" select="1" />
							<xsl:with-param name="link-count" select="count(//reference-link) + 1" />
						</xsl:call-template>
					</xsl:otherwise>

				</xsl:choose>

			</xsl:for-each>

		</xsl:variable>

		<xsl:element name="row">

			<xsl:copy-of select="$resource-level-metadata" />

			<xsl:element name="section-path">
				<xsl:value-of select="concat('/', $pub-resource-root, '/', 'references')" />
			</xsl:element>

			<xsl:element name="details-of-change-old">

				<xsl:element name="references">

					<xsl:for-each select="$diff-instance-compared-doc-references/reference">

						<xsl:variable name="target"
							select="processing-instruction()[name()='target']" />
						<xsl:variable name="filename"
							select="replace(processing-instruction()[name()='filename'], '^(.+?)source(.+?)$', '$1target$2')" />

						<xsl:choose>

							<xsl:when
								test="$diff-instance-self-doc-references/reference/processing-instruction()[name()='target'] = $target">
								<xsl:copy-of select="self::reference" />
							</xsl:when>

							<xsl:otherwise>

								<xsl:element name="change:span">
									<xsl:attribute name="class" select="string('redline-delete')" />

									<xsl:element name="reference">
										<xsl:attribute name="id"
											select="processing-instruction()[name()='position']" />

										<xsl:processing-instruction name="filename"
											select="$filename" />
										<xsl:processing-instruction name="target"
											select="$target" />
										<xsl:processing-instruction name="position"
											select="processing-instruction()[name()='position']" />

										<xsl:copy-of
											select="document($filename)/reference/processing-instruction()[name()='target-version-number']" />
										<xsl:copy-of select="document($filename)/reference/element()" />

									</xsl:element>

								</xsl:element>

							</xsl:otherwise>

						</xsl:choose>

					</xsl:for-each>

				</xsl:element>

			</xsl:element>

			<xsl:element name="details-of-change-new">

				<xsl:element name="references">

					<xsl:for-each select="$diff-instance-self-doc-references/reference">

						<xsl:variable name="target"
							select="processing-instruction()[name()='target']" />

						<xsl:choose>

							<xsl:when
								test="$diff-instance-compared-doc-references/reference/processing-instruction()[name()='target'] = $target">
								<xsl:copy-of select="self::reference" />
							</xsl:when>

							<xsl:otherwise>

								<xsl:element name="change:span">
									<xsl:attribute name="class" select="string('redline-insert')" />

									<xsl:copy-of select="self::reference" />

								</xsl:element>

							</xsl:otherwise>

						</xsl:choose>

					</xsl:for-each>

				</xsl:element>

			</xsl:element>

		</xsl:element>

	</xsl:template>


	<!-- TODO: process-tables, process-figures, etc. should pass as xpath top 
		of xsl?! -->

	<xsl:template name="process-tables">

		<xsl:variable name="linked-elements">

			<xsl:for-each select="$diff-instance-self-doc">

				<xsl:call-template name="process-table-xref-links">
					<xsl:with-param name="item-count" select="1" />
					<xsl:with-param name="link-index" select="1" />
					<xsl:with-param name="link-count"
						select="count(//xref[@ref-type='table']) + 1" />
				</xsl:call-template>

				<xsl:call-template name="process-table-links">
					<xsl:with-param name="item-count" select="1" />
					<xsl:with-param name="link-index" select="1" />
					<xsl:with-param name="link-count" select="count(//table-link) + 1" />
				</xsl:call-template>

			</xsl:for-each>

		</xsl:variable>

		<xsl:for-each select="$linked-elements/*">

			<xsl:element name="row">

				<xsl:copy-of select="$resource-level-metadata" />

				<!-- TODO: could this be made generic?! -->
				<xsl:element name="section-path">
					<xsl:value-of
						select="concat('/', $pub-resource-root, '/tables/table[', processing-instruction()[name()='position'], ']')" />
				</xsl:element>

				<xsl:element name="details-of-change-old">
					<xsl:variable name="diff-instance-self-target"
						select="processing-instruction()[name()='target']" />
					<xsl:variable name="details-of-change-old-linked-element-filename"
						select="concat(replace(translate($resourse-export-path, '\\', '/'), 'source', 'target'), $diff-instance-self-target)" />

					<xsl:choose>

						<xsl:when
							test="count(processing-instruction()[name()='serna-redline-start'])=3">

							<xsl:apply-templates
								select="processing-instruction()[name() = 'serna-redline-start'][1]">
								<xsl:with-param name="div" select="string('true')" />
							</xsl:apply-templates>

							<xsl:element name="{name()}">
								<xsl:copy-of select="@*" />
								<xsl:apply-templates
									select="document($details-of-change-old-linked-element-filename)/*/*" />
							</xsl:element>

							<xsl:apply-templates
								select="processing-instruction()[name() = 'serna-redline-end'][1]">
								<xsl:with-param name="div" select="string('true')" />
							</xsl:apply-templates>

						</xsl:when>

						<xsl:otherwise>

							<xsl:element name="{name()}">
								<xsl:copy-of select="@*" />
								<xsl:apply-templates
									select="document($details-of-change-old-linked-element-filename)/*/*" />
							</xsl:element>

						</xsl:otherwise>

					</xsl:choose>

				</xsl:element>

				<xsl:element name="details-of-change-new">

					<xsl:choose>

						<xsl:when
							test="count(processing-instruction()[name()='serna-redline-start'])=3">

							<xsl:apply-templates
								select="processing-instruction()[name() = 'serna-redline-start'][1]">
								<xsl:with-param name="div" select="string('true')" />
							</xsl:apply-templates>

							<xsl:element name="{name()}">
								<xsl:copy-of select="@*" />
								<xsl:apply-templates />
							</xsl:element>

							<xsl:apply-templates
								select="processing-instruction()[name() = 'serna-redline-end'][1]">
								<xsl:with-param name="div" select="string('true')" />
							</xsl:apply-templates>

						</xsl:when>

						<xsl:otherwise>

							<xsl:element name="{name()}">
								<xsl:copy-of select="@*" />
								<xsl:apply-templates />
							</xsl:element>

						</xsl:otherwise>

					</xsl:choose>

				</xsl:element>

			</xsl:element>

		</xsl:for-each>

	</xsl:template>

	<xsl:template name="process-figures">

		<xsl:variable name="linked-elements">

			<xsl:for-each select="$diff-instance-self-doc">

				<xsl:call-template name="process-figure-xref-links">
					<xsl:with-param name="item-count" select="1" />
					<xsl:with-param name="link-index" select="1" />
					<xsl:with-param name="link-count"
						select="count(//xref[@ref-type='fig']) + 1" />
				</xsl:call-template>

				<xsl:call-template name="process-figure-links">
					<xsl:with-param name="item-count" select="1" />
					<xsl:with-param name="link-index" select="1" />
					<xsl:with-param name="link-count" select="count(//figure-link) + 1" />
				</xsl:call-template>

			</xsl:for-each>

		</xsl:variable>

		<xsl:for-each select="$linked-elements/*">

			<xsl:element name="row">

				<xsl:copy-of select="$resource-level-metadata" />

				<!-- TODO: could this be made generic?! -->
				<xsl:element name="section-path">
					<xsl:value-of
						select="concat('/', $pub-resource-root, '/figures/figure[', processing-instruction()[name()='position'], ']')" />
				</xsl:element>

				<xsl:element name="details-of-change-old">
					<xsl:variable name="diff-instance-self-target"
						select="processing-instruction()[name()='target']" />
					<xsl:variable name="details-of-change-old-linked-element-filename"
						select="concat(replace(translate($resourse-export-path, '\\', '/'), 'source', 'target'), $diff-instance-self-target)" />

					<xsl:choose>

						<xsl:when
							test="count(processing-instruction()[name()='serna-redline-start'])=3">

							<xsl:apply-templates
								select="processing-instruction()[name() = 'serna-redline-start'][1]">
								<xsl:with-param name="div" select="string('true')" />
							</xsl:apply-templates>

							<xsl:element name="{name()}">
								<xsl:copy-of select="@*" />
								<xsl:apply-templates
									select="document($details-of-change-old-linked-element-filename)/*/*" />
							</xsl:element>

							<xsl:apply-templates
								select="processing-instruction()[name() = 'serna-redline-end'][1]">
								<xsl:with-param name="div" select="string('true')" />
							</xsl:apply-templates>

						</xsl:when>

						<xsl:otherwise>

							<xsl:element name="{name()}">
								<xsl:copy-of select="@*" />
								<xsl:apply-templates
									select="document($details-of-change-old-linked-element-filename)/*/*" />
							</xsl:element>

						</xsl:otherwise>

					</xsl:choose>

				</xsl:element>

				<xsl:element name="details-of-change-new">

					<xsl:choose>

						<xsl:when
							test="count(processing-instruction()[name()='serna-redline-start'])=3">

							<xsl:apply-templates
								select="processing-instruction()[name() = 'serna-redline-start'][1]">
								<xsl:with-param name="div" select="string('true')" />
							</xsl:apply-templates>

							<xsl:element name="{name()}">
								<xsl:copy-of select="@*" />
								<xsl:apply-templates />
							</xsl:element>

							<xsl:apply-templates
								select="processing-instruction()[name() = 'serna-redline-end'][1]">
								<xsl:with-param name="div" select="string('true')" />
							</xsl:apply-templates>

						</xsl:when>

						<xsl:otherwise>

							<xsl:element name="{name()}">
								<xsl:copy-of select="@*" />
								<xsl:apply-templates />
							</xsl:element>

						</xsl:otherwise>

					</xsl:choose>

				</xsl:element>

			</xsl:element>

		</xsl:for-each>



		<!-- TODO: and parent link is new insert?! argh...!! add to other link 
			types -->
		<xsl:for-each select="$linked-elements/*">
			<xsl:variable name="target"
				select="processing-instruction()[name()='target']" />

			<xsl:message
				select="concat('/', $pub-resource-root, '/figures/figure[', processing-instruction()[name()='position'], ']')" />

			<xsl:if
				test="not($linked-elements/*/processing-instruction()[name()='target' and . = $target])">

				<xsl:element name="row">

					<xsl:copy-of select="$resource-level-metadata" />

					<xsl:element name="section-path">
						<xsl:value-of
							select="concat('/', $pub-resource-root, '/figures/figure[', processing-instruction()[name()='position'], ']')" />
					</xsl:element>

					<xsl:element name="details-of-change-old">

						<xsl:element name="change:div">
							<xsl:attribute name="class" select="string('redline-delete')" />

							<xsl:element name="figure">
								<xsl:copy-of select="@*|processing-instruction()[name()='target']" />
								<xsl:apply-templates />
							</xsl:element>

						</xsl:element>

					</xsl:element>

					<xsl:element name="details-of-change-new" />

				</xsl:element>

			</xsl:if>

		</xsl:for-each>



	</xsl:template>

	<xsl:template
		match="processing-instruction()[name()='serna-redline-start' or name()='serna-redline-end']">
		<xsl:param name="div" />
		<xsl:param name="redline-moved" />

		<xsl:choose>

			<xsl:when test="$redline-moved='true'" />

			<xsl:when test="$div='true'">

				<xsl:choose>

					<xsl:when test="name()='serna-redline-start' and .= '1000 '">
						<xsl:text disable-output-escaping="yes">&lt;change:div class="redline-insert"&gt;</xsl:text>
					</xsl:when>

					<xsl:when test="name()='serna-redline-start' and .= '400 '">
						<xsl:text disable-output-escaping="yes">&lt;change:div class="redline-delete"&gt;</xsl:text>
					</xsl:when>

					<xsl:when test="name()='serna-redline-start' and .= '0 '">
						<xsl:text disable-output-escaping="yes">&lt;change:div class="redline-comment"&gt;</xsl:text>
					</xsl:when>

					<xsl:when test="name()='serna-redline-end'">
						<xsl:text disable-output-escaping="yes">&lt;/change:div&gt;</xsl:text>
					</xsl:when>

				</xsl:choose>

			</xsl:when>

			<xsl:otherwise>

				<xsl:choose>

					<xsl:when test="name()='serna-redline-start' and .= '1000 '">
						<xsl:text disable-output-escaping="yes">&lt;change:span class="redline-insert"&gt;</xsl:text>
					</xsl:when>

					<xsl:when test="name()='serna-redline-start' and .= '400 '">
						<xsl:text disable-output-escaping="yes">&lt;change:span class="redline-delete"&gt;</xsl:text>
					</xsl:when>

					<xsl:when test="name()='serna-redline-start' and .= '0 '">
						<xsl:text disable-output-escaping="yes">&lt;change:span class="redline-comment"&gt;</xsl:text>
					</xsl:when>

					<xsl:when test="name()='serna-redline-end'">
						<xsl:text disable-output-escaping="yes">&lt;/change:span&gt;</xsl:text>
					</xsl:when>

				</xsl:choose>

			</xsl:otherwise>

		</xsl:choose>

		<xsl:if
			test="
            name()='serna-redline-start' 
            and following-sibling::node()[1]
            [
            self::processing-instruction() and name()='serna-redline-end'
            or 
            (
            self::text() 
            and string-length(normalize-space(.))=0 
            and following-sibling::node()[1][self::processing-instruction() and name()='serna-redline-end']
            )
            ]
            ">
			<xsl:comment>
				single white space saved
			</xsl:comment>
			<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
			<!--<xsl:text disable-output-escaping="yes"> </xsl:text> -->
		</xsl:if>

		<xsl:if
			test="
            name()='serna-redline-start' 
            and following-sibling::node()[1][self::text() and string-length(normalize-space(.))=0]
            ">
			<!--<xsl:text disable-output-escaping="yes"> </xsl:text> -->
			<xsl:text disable-output-escaping="yes">&#160;</xsl:text>
		</xsl:if>

	</xsl:template>

	<xsl:template name="process-attributes">

		<xsl:param name="attribute-change">
			<xsl:for-each
				select="processing-instruction()[contains(name(), 'attribute-change')]">
				<xsl:element name="{name()}">
					<xsl:attribute name="{replace(., '^(.+)=.(.*).$', '$1')}"
						select="replace(., '^(.+)=.(.*).$', '$2')" />
				</xsl:element>
			</xsl:for-each>
		</xsl:param>

		<xsl:for-each select="attribute()">
			<xsl:variable name="name" select="name()" />

			<xsl:choose>

				<xsl:when
					test="$attribute-change/(attribute-change-in-source|attribute-change-in-target)/attribute()[name()=$name] and $name!='target'">

					<xsl:text disable-output-escaping="no"> </xsl:text>
					<xsl:value-of select="name()" />
					<xsl:text disable-output-escaping="no">="</xsl:text>
					<xsl:value-of select="." />
					<xsl:text disable-output-escaping="no">"</xsl:text>

					<xsl:text disable-output-escaping="no"> change:</xsl:text>
					<xsl:value-of select="name()" />
					<xsl:text disable-output-escaping="no">="</xsl:text>
					<xsl:value-of
						select="$attribute-change/(attribute-change-in-source|attribute-change-in-target)/attribute()[name()=$name]" />
					<xsl:text disable-output-escaping="no">"</xsl:text>

				</xsl:when>

				<xsl:otherwise>
					<xsl:text disable-output-escaping="no"> </xsl:text>
					<xsl:value-of select="name()" />
					<xsl:text disable-output-escaping="no">="</xsl:text>
					<xsl:value-of select="." />
					<xsl:text disable-output-escaping="no">"</xsl:text>
				</xsl:otherwise>

			</xsl:choose>

		</xsl:for-each>

	</xsl:template>

	<xsl:template name="process-xpath">
		<xsl:variable name="name" select="name()" />

		<xsl:for-each select="ancestor::*">
			<xsl:variable name="name" select="name()" />
			<xsl:variable name="generate-id" select="generate-id()" />

			<xsl:text>/</xsl:text>
			<xsl:value-of select="$name" />

			<!-- todo: also avoid if no preceding and following elements same name -->
			<xsl:if test="count(ancestor::*)!=0">
				<!--and //* [ generate-id()=$generate-id and preceding-sibling::*[1][name()=$name] 
					or following-sibling::*[1][name()=$name] ] -->
				<xsl:text>[</xsl:text>
				<xsl:number />
				<xsl:text>]</xsl:text>
			</xsl:if>

		</xsl:for-each>

		<xsl:choose>
			<xsl:when
				test="self::processing-instruction()[name()='diff-instance-compared-doc-matched-node-id']">
				<xsl:text>/processing-instruction()[name()='diff-instance-compared-doc-matched-node-id']</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="$name" />
			</xsl:otherwise>
		</xsl:choose>

		<!-- TODO: preceding-sibling::element() perhaps not valid xpath?? -->
		<xsl:if
			test="
            preceding-sibling::*[self::element()][1][name()=$name]
            or following-sibling::element()[1][name()=$name]
            ">
			<!--or self::processing-instruction()[name()='diff-instance-compared-doc-matched-node-id'] -->

			<xsl:text>[</xsl:text>
			<xsl:number />
			<xsl:text>]</xsl:text>
		</xsl:if>

	</xsl:template>



</xsl:stylesheet>

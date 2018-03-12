declare option xhive:fts-analyzer-class "com.docato.util.analyzers.nla.impl.NLAAnalyzer";
declare option xhive:return-blobs "true";
declare namespace docato = "www.docato.com";
declare namespace content="http://purl.org/rss/1.0/modules/content/";

for $doc in document('/repository/content')[(xhive:metadata(., 'docato-type')='XML_RESOURCE_TYPE')
        and (xhive:fts(xhive:metadata(., 'docato-uri'), 'bmj'))
        and (//ref/citation/lpage[not(preceding-sibling::fpage)])]
let $document := $doc/article
return $document
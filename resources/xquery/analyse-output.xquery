declare namespace  xlink="http://www.w3.org/1999/xlink";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "indent=no";

(:for $x in collection('file:/C:/dev/projects/sbmj-export-wordpress/source/student-live-content-20170914/root-library?select=*.xml;recurse=yes'):)
(:for $x in collection('file:/C:/dev/projects/careers-export/careers-live-content-20170914/root-library?select=*.xml;recurse=yes'):)
 (:let $file-uri := replace(normalize-space(document-uri($x)),'^(file:/C:/dev/projects/sbmj-export-wordpress/source/student-live-content-20170914/root-library)(.*?)$','$2')
 :)
 
 for $x in collection('file:/C:/dev/projects/careers-export/_output/?select=*.xml;recurse=yes')

(: let $file-uri := replace(normalize-space(document-uri($x)),'^(file:/C:/dev/projects/sbmj-export-wordpress/output-nostructure/xml)(.*?)$','$2'):)
 let $file-uri := replace(normalize-space(document-uri($x)),'^(file:/C:/dev/projects/careers-export/_output)(.*?)$','$2')
 
 
 let $collectiondate := $x//pub-date[@pub-type='collection']/year/text()
 let $pub-date-type1 := data($x//pub-date[1]/@pub-type)
 let $pub-date-type2 := data($x//pub-date[2]/@pub-type)
 let $year := $x//pub-date[not(@pub-type='collection')]/year/text()
 let $month := $x//pub-date[not(@pub-type='collection')]/month/text()
 let $day := $x//pub-date[not(@pub-type='collection')]/day/text()
 let $doi := $x//article-id[@pub-id-type="doi"]/text()
 let $id := $x//article-id[@pub-id-type="publisher-id"]/text()
 let $elocation-id := $x//elocation-id/text()
 let $volume-id := $x//article/front/article-meta/volume/text()
 let $fpage := 
                 if (string-length(normalize-space($x//article/front/article-meta/fpage/@seq))ne 0) then
                    concat($x//article/front/article-meta/fpage/text(),'-',$x//article/front/article-meta/fpage/@seq)
                    else
                    $x//article/front/article-meta/fpage/text()
 let $issue-id := $x//article/front/article-meta/issue/text()
 let $lpage := $x//article/front/article-meta/lpage/text()
 let $art-title := normalize-space($x/article/front[1]/article-meta[1]/title-group/article-title)
 let $au1 := concat($x/article/front[1]/article-meta[1]/contrib-group[1]/contrib[1]/name/given-names/text(),' ',$x/article/front[1]/article-meta[1]/contrib-group[1]/contrib[1]/name/surname/text())
 let $aulast := $x/article/front[1]/article-meta[1]/contrib-group[1]/contrib[1]/name/surname/text()
 let $auemail := string-join($x//email[ancestor::article-meta])
 let $section := normalize-space($x/article/front[1]/article-meta[1]/article-categories[1]/subj-group[1]/subject/text())
 let $series-title := $x/article/front[1]/article-meta[1]/article-categories[1]/series-title[1]/text()
 let $images := data($x//graphic/@xlink:href)
 let $topic-codes := string-join($x/article/front[1]/article-meta[1]/article-categories[1]/subj-group[@subj-group-type='hwp-journal-coll']/subject/text(),' ')
 let $citeline :=$x//text()[matches(.,'cite this as','i')]
 let $batchno :=replace($file-uri,'^.*/\d+/(\d+)/.*?$','$1')
 let $links :=string-join($x//@xlink:href,' ')
 
return($file-uri,"|",$id,"|",$elocation-id,"|",$doi,"|",$volume-id,"|",$issue-id,"|",$batchno,"|",$fpage,"|",$lpage,"|",$aulast,"|",$art-title,"|",$au1,"|",$section,"|",$series-title,"|",$topic-codes,"|",$year,"|",$year,"-",$month,"-",$day,"|",$images,"|",$auemail,"|",$links,"|",$collectiondate,"|",$pub-date-type1,"|",$pub-date-type2,"
")
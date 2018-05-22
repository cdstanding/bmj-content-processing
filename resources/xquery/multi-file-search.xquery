

for $file in collection('file:///C:/Users/CStanding/Desktop/ipad-floats?select=*.xml;recurse=yes')
let $item := $file//floats-wrap
where $item[preceding-sibling::floats-wrap]
return ($file//article-id[@pub-id-type='doi'],"|",base-uri($file))

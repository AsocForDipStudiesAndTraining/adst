xquery version "3.1";

let $adst-collection := xmldb:create-collection('/db/apps', 'adst')
let $data-collection := xmldb:create-collection($adst-collection, 'data')
let $toc-collection := xmldb:create-collection($data-collection, 'toc')

for $n in (1 to 70)
let $url := "https://www.loc.gov/collections/foreign-affairs-oral-history/?sp=" || $n || "&amp;fo=json"
return
    let $request := <hc:request href="{$url}" method="get"/>
    let $response := hc:send-request($request)
    let $response-head := $response[1]
    let $response-body := $response[2]
    let $json-string := util:binary-to-string($response-body)
    return 
        (
            xmldb:store($toc-collection, 'loc-adst-toc-' || format-number($n, '000') || '.xml', $response-head),
            xmldb:store($toc-collection, 'loc-adst-toc-' || format-number($n, '000') || '.json', $json-string)
        )
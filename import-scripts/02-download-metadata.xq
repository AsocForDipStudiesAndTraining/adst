xquery version "3.1";

import module namespace console="http://exist-db.org/xquery/console" at "java:org.exist.console.xquery.ConsoleModule";

let $metadata-collection := xmldb:create-collection("/db/apps/adst/data", "metadata")
let $toc-collection := "/db/apps/adst/data/toc"
for $resource in xmldb:get-child-resources($toc-collection)[ends-with(., '.json')]
let $json := json-doc($toc-collection || "/" || $resource)
let $results := $json?results?*
let $results-to-request := $results
for $result in $results
let $url := $result?url
let $id := substring-before(substring-after($url, 'item/'), '/')
let $json-url := $url || "?fo=json"
let $request := <hc:request href="{$json-url}" method="get"/>
let $log := console:log("requesting " || $json-url)
let $response := hc:send-request($request)
let $response-head := $response[1]
let $response-body := $response[2]
let $json-string := util:binary-to-string($response-body)
return 
    (
        xmldb:store($metadata-collection, $id || ".xml", $response-head),
        xmldb:store($metadata-collection, $id || ".json", $json-string)
    )
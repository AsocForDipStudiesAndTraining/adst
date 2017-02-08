xquery version "3.1";

import module namespace console="http://exist-db.org/xquery/console" at "java:org.exist.console.xquery.ConsoleModule";

let $xml-collection := xmldb:create-collection("/db/apps/adst/data", "interviews")
let $pdf-collection := xmldb:create-collection("/db/apps/adst/data", "pdf")

let $metadata-collection := "/db/apps/adst/data/metadata"
let $resources := 
    for $resource in xmldb:get-child-resources($metadata-collection)[ends-with(., '.json')]
    let $json := json-doc($metadata-collection || "/" || $resource)
    let $url := $json?item?url
    let $id := substring-before(substring-after($url, 'item/'), '/')
    let $tei-url := $json?resources?1?fulltext_file
    let $pdf-url := $json?resources?1?pdf
    let $tei-download := 
        try { 
            let $request := <hc:request href="{$tei-url}" method="get"><hc:header name="Connection" value="close"/></hc:request>
            let $log := console:log("requesting " || $tei-url)
            let $response := hc:send-request($request)
            let $response-head := $response[1]
            let $response-body := $response[2]
            return 
                (
                    xmldb:store($xml-collection, $id || "-request.xml", $response-head),
                    xmldb:store($xml-collection, $id || ".xml", $response-body)
                )
        } catch * { xmldb:store($xml-collection, $id || "-tei-error.xml", <response status="fail">
            <message>There was an unexpected problem downloading the TEI for {$resource}. {concat($err:code, ": ", $err:description, ' (', $err:module, ' ', $err:line-number, ':', $err:column-number, ')')}</message>
                        </response>) }
    let $pdf-download := 
        try {
            let $request := <hc:request href="{$pdf-url}" method="get"><hc:header name="Connection" value="close"/></hc:request>
            let $log := console:log("requesting " || $pdf-url)
            let $response := hc:send-request($request)
            let $response-head := $response[1]
            let $response-body := $response[2]
            return 
                (
                    xmldb:store($pdf-collection, $id || ".xml", $response-head),
                    xmldb:store($pdf-collection, $id || ".pdf", $response-body)
                )
        } catch * { xmldb:store($pdf-collection, $id || "-pdf-error.xml", <response status="fail">
            <message>There was an unexpected problem downloading the PDF for {$resource}. {concat($err:code, ": ", $err:description, ' (', $err:module, ' ', $err:line-number, ':', $err:column-number, ')')}</message>
                        </response>) 
        }
    return
        $resource
return
    'completed download of resources identified by ' || count($resources) || ' files in the metadata folder'
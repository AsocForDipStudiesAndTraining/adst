xquery version "3.1";

declare variable $local:tei-ns { "http://www.tei-c.org/ns/1.0" };

declare function local:recurse($node) {
    local:loc-to-teip5($node/node())
};

declare function local:loc-to-teip5($nodes) {
    for $node in $nodes
    return
        typeswitch ( $node )
        case document-node() return local:recurse($node)
        case text() return $node
        case element(tei2) return element { QName($local:tei-ns, "TEI") } { attribute xml:id { $node/teiheader/filedesc/titlestmt/document_id }, local:recurse($node) } 
        
        case element(teiheader) return 
            element { QName($local:tei-ns, "teiHeader") } 
                { 
                    local:recurse($node), 
                    element { QName($local:tei-ns, "revisionDesc") } 
                        {
                            element { QName($local:tei-ns, "listChange") } {
                                element { QName($local:tei-ns, "change") } {
                                    attribute type { "encoding" },
                                    attribute when { replace($node/encodingdesc/encodingdate, '^(\d{2})/(\d{2})/(\d{4})$', '$3-$1-$2') }
                                },
                                element { QName($local:tei-ns, "change") } {
                                    attribute type { "rev" },
                                    attribute when { replace($node/encodingdesc/revdate, '^(\d{2})/(\d{2})/(\d{4})$', '$3-$1-$2') }
                                },
                                element { QName($local:tei-ns, "change") } {
                                    attribute type { "rev" },
                                    attribute when { adjust-date-to-timezone(current-date(), ()) },
                                    attribute who { "WicentowskiJC@state.gov" },
                                    "Migrate from AMMEM2.DTD to basic TEI P5"
                                } 
                            }
                        }
                }
        case element(filedesc) return element { QName($local:tei-ns, "fileDesc") } { local:recurse($node) }
        case element(titlestmt) return element { QName($local:tei-ns, "titleStmt") } { local:recurse($node) }
        case element(title) return element { QName($local:tei-ns, "title") } { attribute type { "interview" }, local:recurse($node) }
        case element(amcol) return element { QName($local:tei-ns, "title") } { attribute type { "series" }, local:recurse($node/amcolname) }
        case element(publicationstmt) return element { QName($local:tei-ns, "publicationStmt") } { local:recurse($node) }
        
        case element(sourcedesc) return element { QName($local:tei-ns, "sourceDesc") } { $node/* ! element { QName($local:tei-ns, "p") } { attribute type {./name()}, ./string() } }
        
        case element(respstmt) return element { QName($local:tei-ns, "respStmt") } { local:recurse($node) }
        case element(resp) return element { QName($local:tei-ns, "resp") } { local:recurse($node) }
        case element(name) return element { QName($local:tei-ns, "name") } { local:recurse($node) }
        case element(encodingdesc) return element { QName($local:tei-ns, "encodingDesc") } { local:recurse($node) }
        case element(projectdesc) return element { QName($local:tei-ns, "projectDesc") } { local:recurse($node) }
        case element(editorialdecl) return element { QName($local:tei-ns, "editorialDecl") } { local:recurse($node) }
        
        case element(text) return element { QName($local:tei-ns, "text") } { local:recurse($node) }
        case element(body) return element { QName($local:tei-ns, "body") } { local:recurse($node) }
        case element(div) return element { QName($local:tei-ns, "div") } { local:recurse($node) }
        case element(p) return element { QName($local:tei-ns, "p") } { local:recurse($node) }
        case element(hi) return element { QName($local:tei-ns, "hi") } { $node/@*, local:recurse($node) }
        case element(pageinfo) return element { QName($local:tei-ns, "pb") } { attribute facs { $node/controlpgno/string() }, attribute n { $node/controlpgno/@entity } }
        default return ()
};

let $interviews-tei-collection := xmldb:create-collection('/db/apps/adst/data', 'interviews-tei-p5')
for $doc in collection('/db/apps/adst/data/interviews')/tei2
let $tei-p5 := local:loc-to-teip5($doc)
return 
    xmldb:store($interviews-tei-collection, util:document-name($doc), $tei-p5)
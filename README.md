# ADST Oral Histories

A prototype app for browsing and searching Association for Diplomatic Studies and Training (ADST) Oral History Interviews.

## Current status

- [x] Obtain all 1,724 interviews (text and metadata) from https://www.loc.gov/collections/foreign-affairs-oral-history/about-this-collection/
    - [x] Download source XML and JSON data. For example, for the [Interview with L. Bruce Laingen](https://www.loc.gov/item/mfdipbib000651), see its original [XML source data](https://cdn.loc.gov/service/mss/mfdip/2004/2004lai01/2004lai01.xml) and [JSON-encoded metadata](https://www.loc.gov/item/mfdipbib000651?fo=json). The XQuery scripts used to download the data are in the `import-scripts` directory)
    - [x] Place JSON-encoded metadata in `data/metadata`
    - [x] Place full text XML-encoded interviews in `data/interviews`
    - [x] Convert LOC's P4(?)-era TEI XML to P5-conformant TEI XML (referencing American Memory DTD documentation at https://memory.loc.gov/ammem/amdtd.html; see XQuery scripts in `import-scripts`)
- [x] Generate eXist app with [TEI Publisher](http://teipublisher.com) 
    - [x] Make customizations to `modules/config.xqm`, all supported by TEI Publisher: set `$config:address-by-id` to `true()`, set `$config:search-default` to `tei:body`, set `$config:login-domain` to `org.adst`, set `$config:data-root` to `$config:app-root || "/data/interviews"` 

## Next steps

- [ ] Extract subject headings and other useful metadata from `data/metadata`
- [ ] Remove unneeded filters and columns (author, title)
- [ ] Show columns with relevant info: interviewee name, date, subject
- [ ] Add filtering and sorting by interviewee name, date, subject

## Dependencies

- eXist-db 3.0.3 (required for TEI Publisher libraries)
- Apache Ant

## Installation

- Call `ant` to build an application package (deposited in the `build` directory)
- Install the package via eXist Dashboard > Package Manager
- Access via <http://localhost:8080/exist/apps/adst/>

## Screenshots

1. Landing Page

    > ![ADST Oral Histories app Landing Page](https://cloud.githubusercontent.com/assets/59118/22748854/73aa063e-edf9-11e6-86d1-f3ccc03e2e79.png)

1. Document View

    > ![ADST Oral Histories app Document View](https://cloud.githubusercontent.com/assets/59118/22748919/adca23d0-edf9-11e6-8477-0a74df8e526b.png)

1. Search Autosuggest

    > ![ADST Oral Histories app Search Autosuggest View](https://cloud.githubusercontent.com/assets/59118/22749072/16c6bcfe-edfa-11e6-8217-381857747a4b.png)

1. Keyword Search Results

    > ![ADST Oral Histories app Keyword Search Results View](https://cloud.githubusercontent.com/assets/59118/22749074/18b9a36e-edfa-11e6-8d3e-5da493d813f5.png)

1. App-generated PDF (via XSL-FO) ([Download PDF](https://github.com/joewiz/adst/files/761449/mfdipbib000972.pdf))

    > ![ADST Oral Histories app App-generated PDF](https://cloud.githubusercontent.com/assets/59118/22749269/b2fd2eb4-edfa-11e6-931a-4885a0db75c6.png)

# ADST Oral Histories

A prototype app for browsing and searching Association for Diplomatic Studies and Training (ADST) Oral History Interviews.

## About the sources

From the [ADST Oral History](http://adst.org/oral-history/) homepage:

> Since 1986, the Foreign Affairs Oral History Program of the Association for Diplomatic Studies and Training (ADST) has recorded more than 2500 interviews with former participants in the U.S. foreign affairs process. Collectively, these oral histories span over 80 years. About 60 new interviews are added annually. The series also contains some significant oral histories dealing with American diplomacy, which were provided by universities and presidential libraries.
> 
> The oral history collection has become one of the largest in the country on any subject and the most significant collection on foreign affairs.
>
> The Oral History Collection is a part of the Library of Congress American Memory collection. It is unclassified and available to the public and can be found at Library’s [Front Line Diplomacy](http://memory.loc.gov/ammem/collections/diplomacy/) website. It is also available on ADST’s site under [Oral History Interviews](http://adst.org/oral-history/oral-history-interviews/).

The Library of Congress (LOC) hosts the ADST interview transcripts at https://www.loc.gov/collections/foreign-affairs-oral-history/about-this-collection/. ADST's site has these, as well as some newer interviews not yet posted on LOC's site, in PDF form, at http://adst.org/oral-history/oral-history-interviews/. Some of the ADST PDFs contain tables of contents not found in the LOC edition. The LOC edition is available in basic TEI (P4-era?) XML and PDF, and is enriched with subject headings available in JSON-encoded metadata.

For example, the LOC makes the ADST [Interview with L. Bruce Laingen](https://www.loc.gov/item/mfdipbib000651) available in [TEI XML](https://cdn.loc.gov/service/mss/mfdip/2004/2004lai01/2004lai01.xml) and [JSON-encoded metadata](https://www.loc.gov/item/mfdipbib000651?fo=json). These were adapted and enriched from the [original ADST manuscript (PDF)](http://www.adst.org/OH%20TOCs/Laingen,%20L.%20Bruce%20.toc.pdf).

## Current status

- [x] Obtain all 1,724 interviews (text and metadata) from LOC link above.
    - [x] Download source XML and JSON data. The XQuery scripts used to download the data are in the `import-scripts` directory.
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

- eXist-db 3.1.0+ (required for TEI Publisher libraries)
- Apache Ant (required to build a package from source code)

## Installation

- Download the latest release via <https://github.com/joewiz/adst/releases>, or clone this repository and build an installer package by calling `ant` to build an application package (deposited in the `build` directory)
- Install the package (the .xar file that you download or build) via eXist Dashboard > Package Manager
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

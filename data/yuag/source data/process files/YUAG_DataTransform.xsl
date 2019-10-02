<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

<xsl:output method="text"/>
    
<xsl:template match="yuag-data">{
    "works": [<xsl:for-each select="work"><xsl:variable name="baseURI">https://artdata.yale.edu/collections/object/</xsl:variable><xsl:variable name="id"><xsl:value-of select="objectID"/></xsl:variable><xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
        {
            "<xsl:value-of select="objectID"/>": {
                "@context": "https://linked.art/ns/v1/linked-art.json",
                "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>",
                "type": "HumanMadeObject",
                "_label": "<xsl:copy-of select="$title"/>",
                "classified_as": [
                    {
                        "id": "http://vocab.getty.edu/aat/300133025",
                        "type": "Type",
                        "_label": "works of art"
                    },<xsl:if test="class = 'Paintings'">
                    {
                        "id": "http://vocab.getty.edu/aat/300033618",
                        "type": "Type",
                        "_label": "paintings (visual works)"
                    }</xsl:if><xsl:if test="class = 'Drawings'">
                    {
                        "id": "http://vocab.getty.edu/aat/300033973",
                        "type": "Type",
                        "_label": "drawings (visual works)"
                    }</xsl:if><xsl:if test="class = 'Prints'">
                    {
                        "id": "http://vocab.getty.edu/aat/300041273",
                        "type": "Type",
                        "_label": "prints (visual works)"
                    }</xsl:if><xsl:if test="class = 'Photographs'">
                    {
                        "id": "http://vocab.getty.edu/aat/300046300",
                        "type": "Type",
                        "_label": "photographs"
                    }</xsl:if><xsl:if test="class = 'Watercolors'">
                    {
                        "id": "http://vocab.getty.edu/aat/300078925",
                        "type": "Type",
                        "_label": "watercolors (paintings)"
                    }</xsl:if><xsl:if test="class = 'Books'">
                    {
                        "id": "http://vocab.getty.edu/aat/300028051",
                        "type": "Type",
                        "_label": "books"
                    }</xsl:if><xsl:if test="medium = 'Gelatin silver print'">,
                    {
                        "id": "http://vocab.getty.edu/aat/300128695",
                        "type": "Type",
                        "_label": "gelatin silver prints"
                    }
                    </xsl:if><xsl:if test="medium = 'Chromogenic print'">,
                    {
                        "id": "http://vocab.getty.edu/aat/300236285",
                        "type": "Type",
                        "_label": "chromogenic color prints"
                    }</xsl:if><xsl:if test="medium = 'Platinum print'">,
                    {
                        "id": "http://vocab.getty.edu/aat/300127145",
                        "type": "Type",
                        "_label": "platinum prints"
                    }</xsl:if><xsl:if test="medium = 'Photogravures'">,
                    {
                        "id": "http://vocab.getty.edu/aat/300154382",
                        "type": "Type",
                        "_label": "photogravures (prints"
                    }</xsl:if><xsl:if test="medium = 'Offset lithograph'">,
                    {
                        "id": "http://vocab.getty.edu/aat/300192896",
                        "type": "Type",
                        "_label": "offset lithographs"
                    }
                    </xsl:if>
                ],
                "identified_by": [
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/id",
                        "type": "Identifier",
                        "_label": "YUAG Collections Database Number for the Object",
                        "content": "<xsl:copy-of select="$id"/>",
                        "classified_as": [
                            {
                                "id": "http://vocab.getty.edu/aat/300404621",
                                "type": "Type",
                                "_label": "repository numbers"
                            }
                        ]
                    },
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/accession-number",
                        "type": "Identifier",
                        "_label": "YUAG Accession Number for the Object",
                        "content": "<xsl:value-of select="objectNumber"/>",
                        "classified_as": [
                            {
                                "id": "http://vocab.getty.edu/aat/300312355",
                                "type": "Type",
                                "_label": "accession numbers"
                            }
                        ]
                    },
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/title",
                        "type": "Name",
                        "_label": "Primary Title for the Object",
                        "content": "<xsl:copy-of select="$title"/>",
                        "classified_as": [
                            {
                                "id": "http://vocab.getty.edu/aat/300404670",
                                "type": "Type",
                                "_label": "preferred terms"
                            }
                        ]
                    }
                ],<xsl:if test="medium = 'Oil on canvas'">
                "made_of": [
                    {
                        "id": "http://vocab.getty.edu/aat/300015050",
                        "type": "Material",
                        "_label": "oil paint (paint)"
                    },
                    {
                        "id": "http://vocab.getty.edu/aat/300014078",
                        "type": "Material",
                        "_label": "canvas (textile material)"
                    }
                ],</xsl:if><xsl:if test="medium = 'Watercolor'">
                "made_of": [
                    {
                        "id": "http://vocab.getty.edu/aat/300015045",
                        "type": "Type",
                        "_label": "watercolor (paint)"
                    }
                ],</xsl:if><xsl:if test="medium = 'Oil on panel'">
                "made_of": [
                    {
                        "id": "http://vocab.getty.edu/aat/300015050",
                        "type": "Material",
                        "_label": "oil paint (paint)"
                    }
                ],</xsl:if><xsl:if test="medium = 'Graphite'">
                "made_of": [
                    {
                        "id": "http://vocab.getty.edu/aat/300011098",
                        "type": "Material",
                        "_label": "graphite (mineral)"
                    }
                ],</xsl:if>
                "produced_by": {
                    "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/production",
                    "type": "Production",
                    "_label": "Production of the Object",
                    "carried_out_by": [<xsl:if test="contains(artist, 'Georgia ')">
                        {
                            "id": "http://vocab.getty.edu/ulan/500018666",
                            "type": "Actor",
                            "_label": "O'Keeffe, Georgia"
                        }</xsl:if><xsl:if test="contains(displayName, 'Alfred ')">
                        {
                            "id": "http://vocab.getty.edu/ulan/500024301",
                            "type": "Actor",
                            "_label": "Stieglitz, Alfred"
                        }</xsl:if><xsl:if test="contains(displayName, 'Ansel ')">
                        {
                            "id": "http://vocab.getty.edu/ulan/500026108",
                            "type": "Actor",
                            "_label": "Adams, Ansel"
                        }</xsl:if><xsl:if test="contains(displayName, 'Joe ')">
                        {
                            "id": "http://vocab.getty.edu/ulan/500348111",
                            "type": "Actor",
                            "_label": "Munroe, Joe"
                        }</xsl:if><xsl:if test="contains(displayName, 'Ralph ')">
                        {
                            "id": "http://vocab.getty.edu/ulan/500346656",
                            "type": "Actor",
                            "_label": "Looney, Ralph"
                        }</xsl:if><xsl:if test="contains(displayName, 'Tony ')">
                        {
                            "id": "http://vocab.getty.edu/ulan/500339954",
                            "type": "Actor",
                            "_label": "Vaccaro, Tony"
                        }</xsl:if><xsl:if test="contains(displayName, 'Dan ')">
                        {
                            "id": "http://vocab.getty.edu/ulan/500349012",
                            "type": "Actor",
                            "_label": "Budnik, Dan"
                        }</xsl:if><xsl:if test="contains(displayName, 'Vince ')">
                        {
                            "id": "https://artdata.yale.edu/collections/actor/vince-maggiora",
                            "type": "Actor",
                            "_label": "Maggiora, Vince"
                        }</xsl:if><xsl:if test="contains(displayName, 'Unknown')">
                        {
                            "id": "http://vocab.getty.edu/ulan/500460304",
                            "type": "Actor",
                            "_label": "Unknown Artist"
                        }</xsl:if>
                    ],
                    "timespan": {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/production/timespan",
                        "type": "TimeSpan",
                        "_label": "<xsl:value-of select="date"/>",
                        "begin_of_the_begin": "<xsl:value-of select="beginDate"/>-01-01T00:00:00",
                        "end_of_the_end": "<xsl:value-of select="endDate"/>-12-31T00:00:00"
                    }
                },
                "current_owner": {
                    "id": "http://vocab.getty.edu/ulan/500303559",
                    "type": "Group",
                    "_label": "Yale University Art Gallery",
                    "classified_as": [
                        {
                            "id": "http://vocab.getty.edu/aat/300312243",
                            "type": "Type",
                            "_label": "art galleries (institutions)"
                        }
                    ],
                    "acquired_title_through": [
                        {
                            "id": "<xsl:copy-of select="$baseURI"/>YUAG-acquisition",
                            "type": "Acquisition",
                            "_label": "PMA Acquisition of the Object",
                            "classified_as": [
                                {
                                    "id": "http://vocab.getty.edu/aat/300157782",
                                    "type": "Type",
                                    "_label": "acquisition (collections management)"
                                }
                            ]
                        }
                    ]
                },
                "shows": [
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/visual-item-1",
                        "type": "VisualItem",
                        "_label": "<xsl:value-of select="genre"/>",
                        "classified_as": [
                            {
                                "id": "http://vocab.getty.edu/aat/<xsl:value-of select="genredID"/>",
                                "type": "Type",
                                "_label": "<xsl:value-of select="genre"/>"
                            }
                        ]
                    }<xsl:if test="subject1 != '' and geography != ''">,
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/visual-item-2",
                        "type": "VisualItem",
                        "_label": "Visual Item Depicted in the Work",
                        "classified_as": [
                            {
                                "id": "http//vocab.getty.edu/aat/300404126",
                                "type": "Type",
                                "_label": "subjects (content of works)"
                            }
                        ],
                        "represents": [
                            {
                                "id": "http://vocab.getty/edu/ulan/500018666",
                                "type": "Actor",
                                "_label": "O'Keeffe, Georgia"
                            }
                        ]
                    },
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/visual-item-3",
                        "type": "VisualItem",
                        "_label": "<xsl:value-of select="geography"/>",
                        "classified_as": [
                            {
                                "id": "http//vocab.getty.edu/aat/300404126",
                                "type": "Type",
                                "_label": "subjects (content of works)"
                            }
                        ],
                        "represents": [
                            {
                                "id": "<xsl:if test="tgnID != ''">http://vocab.getty.edu/tgn/<xsl:value-of select="tgnID"/></xsl:if><xsl:if test="geonamesID != ''">https://geonames.org/<xsl:value-of select="geonamedID"/></xsl:if>",
                                "type": "Place",
                                "_label": "<xsl:value-of select="replace(replace(geography, 'Depicted: ', ''), 'Depicted, possibly: ', '')"/>"
                            }
                        ]
                    }</xsl:if><xsl:if test="subject1 != '' and geography = ''">,
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/visual-item-2",
                        "type": "VisualItem",
                        "_label": "Visual Item Depicted in the Work",
                        "classified_as": [
                            {
                                "id": "http//vocab.getty.edu/aat/300404126",
                                "type": "Type",
                                "_label": "subjects (content of works)"
                            }
                        ],
                        "represents": [
                            {
                                "id": "http://vocab.getty/edu/ulan/500018666",
                                "type": "Actor",
                                "_label": "O'Keeffe, Georgia"
                            }
                        ]
                    }</xsl:if><xsl:if test="subject1 = '' and geography != ''">,
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/visual-item-2",
                        "type": "VisualItem",
                        "_label": "<xsl:value-of select="geography"/>",
                        "classified_as": [
                            {
                                "id": "http//vocab.getty.edu/aat/300404126",
                                "type": "Type",
                                "_label": "subjects (content of works)"
                            }
                        ],
                        "represents": [
                            {
                                "id": "<xsl:if test="tgnID != ''">http://vocab.getty.edu/tgn/<xsl:value-of select="tgnID"/></xsl:if><xsl:if test="geonamesID != ''">https://geonames.org/<xsl:value-of select="geonamedID"/></xsl:if>",
                                "type": "Place",
                                "_label": "<xsl:value-of select="replace(replace(geography, 'Depicted: ', ''), 'Depicted, possibly: ', '')"/>"
                            }
                        ]
                    }</xsl:if>
                ],
                "referred_to_by": [
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/credit-line",
                        "type": "LinguisticObject",
                        "_label": "YUAG Credit Line for the Object",
                        "content": "<xsl:value-of select="replace(creditLine, '\n', '\\n')"/>",
                        "classified_as": [
                            {
                                "id": "http://vocab.getty.edu/aat/300026687",
                                "type": "Type",
                                "_label": "acknowledgments"
                            },
                            {
                                "id": "http://vocab.getty.edu/aat/300418049",
                                "type": "Type",
                                "_label": "brief texts"
                            }
                        ]
                    },
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/dimension-statement",
                        "type": "LinguisticObject",
                        "_label": "Notes about the Dimensions of the Object",
                        "content": "<xsl:value-of select="replace(dimensions, '\n', '\\n')"/>",
                        "classified_as": [
                            {
                                "id": "http://vocab.getty.edu/aat/300266036",
                                "type": "Type",
                                "_label": "dimensions"
                            },
                            {
                                "id": "http://vocab.getty.edu/aat/300418049",
                                "type": "Type",
                                "_label": "brief texts"
                            }
                        ]
                    },
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/materials-statement",
                        "type": "LinguisticObject",
                        "_label": "Notes about the Materials in the Object",
                        "content": "<xsl:value-of select="replace(medium, '\n', '\\n')"/>",
                        "classified_as": [
                            {
                                "id": "http://vocab.getty.edu/aat/300010358",
                                "type": "Type",
                                "_label": "materials (substances)"
                            },
                            {
                                "id": "http://vocab.getty.edu/aat/300418049",
                                "type": "Type",
                                "_label": "brief texts"
                            }
                        ]
                    },
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/provenance-statement",
                        "type": "LinguisticObject",
                        "_label": "Notes about the Provenance of the Object",
                        "content": "<xsl:value-of select="replace(provenance, '\n', '\\n')"/>",
                        "classified_as": [
                            {
                                "id": "http://vocab.getty.edu/aat/300055863",
                                "type": "Type",
                                "_label": "provenance (history of ownership)"
                            },
                            {
                                "id": "http://vocab.getty.edu/aat/300418049",
                                "type": "Type",
                                "_label": "brief texts"
                            }
                        ]
                    }<xsl:if test="subjects != ''">,
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/subject-statement",
                        "type": "LinguisticObject",
                        "_label": "Notes about the Sujects Depicted in the Object",
                        "content": "<xsl:value-of select="replace(subjects, '\n', '\\n')"/>",
                        "classified_as": [
                            {
                                "id": "http://vocab.getty.edu/aat/300404126",
                                "type": "Type",
                                "_label": "subjects (content of works)"
                            },
                            {
                                "id": "http://vocab.getty.edu/aat/300418049",
                                "type": "Type",
                                "_label": "brief texts"
                            }
                        ]
                    }</xsl:if>
                ],
                "subject_of": [
                    {
                        "id": "<xsl:value-of select="url"/>",
                        "type": "LinguisticObject",
                        "_label": "Homepage for the Object",
                        "classified_as": [
                            {
                                "id": "http://vocab/getty.edu/aat/300264578",
                                "type": "Type",
                                "_label": "Web pages (documents)"
                            },
                            {
                                "id": "http://vocab.getty.edu/aat/300266277",
                                "type": "Type",
                                "_label": "home pages"
                            }
                        ],
                        "format": "text/html"
                    }
                ]<xsl:if test="image != ''">,
                "representation": [
                    {
                        "id": "<xsl:value-of select="image"/>",
                        "type": "VisualItem",
                        "_label": "Primary Image of the Object",
                        "classified_as": [
                            {
                                "id": "http://vocab.getty.edu/aat/300215302",
                                "type": "Type",
                                "_label": "digital images"
                            }
                        ],
                        "format": "image/jpeg"
                    }
                ]</xsl:if>
            }        
        }<xsl:if test="position() != last()">,</xsl:if>
</xsl:for-each>
    ]
}
</xsl:template>

</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

<xsl:output method="text"/>
    
<xsl:template match="pma-data">
{
    "works": [<xsl:for-each select="work"><xsl:variable name="baseURI">https://data.philamuseum.org/work/</xsl:variable><xsl:variable name="id"><xsl:value-of select="objectID"/></xsl:variable><xsl:variable name="title"><xsl:value-of select="title"/></xsl:variable>
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
                    },<xsl:if test="classification = 'Paintings'">
                    {
                        "id": "http://vocab.getty.edu/aat/300033618",
                        "type": "Type",
                        "_label": "paintings (visual works)"
                    }</xsl:if><xsl:if test="classification = 'Drawings'">
                    {
                        "id": "http://vocab.getty.edu/aat/300033973",
                        "type": "Type",
                        "_label": "drawings (visual works)"
                    }</xsl:if><xsl:if test="classification = 'Prints'">
                    {
                        "id": "http://vocab.getty.edu/aat/300041273",
                        "type": "Type",
                        "_label": "prints (visual works)"
                    }</xsl:if><xsl:if test="classification = 'Photographs'">
                    {
                        "id": "http://vocab.getty.edu/aat/300046300",
                        "type": "Type",
                        "_label": "photographs"
                    }</xsl:if>
                ],
                "identified_by": [
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/id",
                        "type": "Identifier",
                        "_label": "PMA Collections Database Number for the Work",
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
                        "_label": "PMA Accession Number for the Work",
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
                        "_label": "Primary Title for the Work",
                        "content": "<xsl:copy-of select="$title"/>",
                        "classified_as": [
                            {
                                "id": "http://vocab.getty.edu/aat/300404670",
                                "type": "Type",
                                "_label": "preferred terms"
                            }
                        ]
                    }
                ],
                "made_of": [
                <xsl:value-of select="medium"/>
                ],
                "produced_by": {
                    "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/production",
                    "type": "Production",
                    "_label": "Production of the Work",
                    "carried_out_by": [<xsl:if test="contains(displayName, 'Georgia ')">
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
                        }</xsl:if><xsl:if test="contains(displayName, 'Arnold ')">
                        {
                            "id": "http://vocab.getty.edu/ulan/500025420",
                            "type": "Actor",
                            "_label": "Newman, Arnold"
                        }</xsl:if><xsl:if test="contains(displayName, 'Carl ')">
                        {
                            "id": "http://vocab.getty.edu/ulan/500058409",
                            "type": "Actor",
                            "_label": "Van Vechten, Carl"
                        }</xsl:if><xsl:if test="contains(displayName, 'Dorothy ')">
                        {
                            "id": "http://vocab.getty.edu/ulan/500071933",
                            "type": "Actor",
                            "_label": "Norman, Dorothy"
                        }</xsl:if><xsl:if test="contains(displayName, 'Paul ')">
                        {
                            "id": "http://vocab.getty.edu/ulan/500003133",
                            "type": "Actor",
                            "_label": "Strand, Paul"
                        }</xsl:if><xsl:if test="contains(displayName, 'Henri ')">
                        {
                            "id": "https://data.philamuseum.org/artist/1",
                            "type": "Actor",
                            "_label": "Marceau, Henri"
                        }</xsl:if>
                    ],
                    "timespan": {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/production/timespan",
                        "type": "TimeSpan",
                        "_label": "<xsl:value-of select="dated"/>"
                    }
                },
                "current_owner": {
                    "id": "http://vocab.getty.edu/ulan/500214534",
                    "type": "Group",
                    "_label": "Philadelphia Museum of Art",
                    "classified_as": [
                        {
                            "id": "http://vocab.getty.edu/aat/300312281",
                            "type": "Type",
                            "_label": "museums (institutions)"
                        }
                    ],
                    "acquired_title_through": [
                        {
                            "id": "<xsl:copy-of select="$baseURI"/>PMA-acquisition",
                            "type": "Acquisition",
                            "_label": "PMA Acquisition of the Work",
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
                "member_of": [
                    {
                        "id": "https://data.philamuseum.org/collection/department/<xsl:value-of select="department"/>",
                        "type": "Set",
                        "_label": "<xsl:if test="department = 'AA'">American Art</xsl:if><xsl:if test="department = 'PDP'">Prints, Drawings, and Photographs</xsl:if>",
                        "classified_as": [
                            "id": "http://vocab.getty.edu/aat/300025976",
                            "type": "Type",
                            "_label": "collections (object groupings)"
                        ]
                    }
                ],
                "referred_to_by": [
                    {
                        "id": "<xsl:copy-of select="$baseURI"/><xsl:copy-of select="$id"/>/credit-line",
                        "type": "LinguisticObject",
                        "_label": "PMA Credit Line for the Work",
                        "content": "<xsl:value-of select="creditLine"/>",
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
                        "_label": "Notes about the Dimensions of the Work",
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
                        "_label": "Notes about the Materials in the Work",
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
                    }
                ],
                "subject_of": [
                    {
                        "id": "https://www.philamuseum.org/collections/permanent/<xsl:copy-of select="$id"/>.html",
                        "type": "LinguisticObject",
                        "_label": "Homepage for the Work",
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
                ]
            }        
        }<xsl:if test="position() != last()">,</xsl:if>
</xsl:for-each>
    ]
}
</xsl:template>

</xsl:stylesheet>
//  Created by Kevin Chen on 2/29/20.
//

import Foundation

struct TruliaGraphQLQuery: Encodable {
    // Passing the raw query as a string since I don't have the schema
    let query: String = """
        query GetHomeDetailsByUrl($url: String!) {
            homeDetailsByUrl(url: $url) {
                __typename
                url
                sharableUrl: url(pathOnly: false)
                
                location {
                    ...HomeDetailsLocationMapDirectionsFragment
                }
                bedrooms {
                    __typename
                    shareBedrooms: formattedValue(formatType: TWO_LETTER_ABBREVIATION)
                    raw: formattedValue(formatType: NO_SUFFIX)
                }
                bathrooms {
                    __typename
                    shareBathrooms: formattedValue(formatType: TWO_LETTER_ABBREVIATION)
                    raw: formattedValue(formatType: NO_SUFFIX)
                }
                floorSpace {
                    __typename
                    formattedDimension
                    shareFloorSpace: formattedDimension(formatType: SHORT_ABBREVIATION)
                    raw: formattedDimension(formatType: NO_SUFFIX)
                }
                tracking {
                    __typename
                    key
                    value
                }
                features {
                    __typename
                    attributes {
                        ...HomeFeatureAttributeFragment
                    }
                }
                ... on HOME_Property {
                    priceHistory {
                        __typename
                        formattedDate
                        source
                        event
                        attributes {
                            __typename
                            formattedAttribute
                            key
                        }
                        ... on HOME_PriceHistoryStandardEvent {
                            price {
                                __typename
                                formattedPrice(formatType: SHORT_ABBREVIATION)
                                }
                            }
                        ... on HOME_PriceHistoryChangeEvent {
                            price {
                                __typename
                                formattedPrice(formatType: SHORT_ABBREVIATION)
                            }
                            priceChange {
                                __typename
                                priceChangeValue {
                                    __typename
                                    formattedPrice(formatType: SHORT_ABBREVIATION)
                                }
                            }
                        }
                    }
                    hoaFee {
                        __typename
                        ...HomeHoaFragment
                    }
                }
            }
        }

        fragment HomeDetailsLocationMapDirectionsFragment on HOME_Location {
            __typename
            city
            stateCode
            zipCode
            streetAddress
            formattedLocation
            neighborhoodName
            coordinates {
                __typename
                latitude
                longitude
            }
        }

        fragment HomeFeatureAttributeFragment on HOME_FeatureAttributeValue {
            __typename
            ... on HOME_FeatureAttributeGenericNameValue {
                formattedName
                formattedValue
                
            }
            ... on HOME_FeatureAttributeLink {
                formattedName
                formattedValue
                linkURL
            }
            ... on HOME_FeatureAttributeGenericValueOnly {
                formattedValue
            }
        }

        fragment HomeHoaFragment on HOME_HoaFee {
            __typename
            totalAmount {
                __typename
                ... on HOME_SinglePrice {
                    price
                    currencyCode
                }
                ... on HOME_PriceRange {
                    min
                    max
                    currencyCode
                }
                formattedPrice
            }
            period
        }
        """
    let variables: Variables
}

extension TruliaGraphQLQuery {
    struct Variables: Encodable {
        // Path url
        let url: String
    }
}

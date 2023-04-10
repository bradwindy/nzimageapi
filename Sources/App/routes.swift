import OrderedCollections
import Vapor

let collectionWeights: OrderedDictionary = ["Auckland Libraries Heritage Images Collection": 0.1546,
                                            "Auckland Museum Collections": 0.1291,
                                            "Te Papa Collections Online": 0.1193,
                                            "TAPUHI": 0.1125,
                                            "Nelson Provincial Museum": 0.088,
                                            "Puke Ariki": 0.0812,
                                            "Canterbury Museum": 0.0505,
                                            "Kura Heritage Collections Online": 0.0408,
                                            "Antarctica NZ Digital Asset Manager": 0.0317,
                                            "Kete Christchurch": 0.0246,
                                            "MOTAT": 0.0178,
                                            "Hawke's Bay Knowledge Bank": 0.0148,
                                            "Kete New Plymouth": 0.0146,
                                            "Picture Wairarapa": 0.0141,
                                            "Te Ara - The Encyclopedia of New Zealand": 0.0133,
                                            "Auckland Art Gallery Toi o Tāmaki": 0.0099,
                                            "Ministry for Culture and Heritage Te Ara Flickr": 0.0095,
                                            "MTG Hawke's Bay": 0.0092,
                                            "Europeana": 0.0084,
                                            "Howick Historical Village NZMuseums": 0.0065,
                                            "Te Awamutu Museum": 0.0064,
                                            "Hamilton Heritage Collections": 0.0056,
                                            "The James Wallace Arts Trust": 0.0053,
                                            "Christchurch City Libraries Heritage Images Collection": 0.0045,
                                            "Culture Waitaki": 0.0044,
                                            "NZHistory": 0.0041,
                                            "Archives Central": 0.004,
                                            "Waikato Museum Te Whare Taonga o Waikato": 0.0038,
                                            "Tairāwhiti Museum Te Whare Taonga o Tairāwhiti": 0.0037,
                                            "Archives New Zealand Te Rua Mahara o te Kāwanatanga Flickr": 0.0029,
                                            "Otago University Research Heritage": 0.0028,
                                            "Sarjeant Gallery Te Whare o Rehua Whanganui": 0.0026]

let requestManager = ValidatedRequestManager()

let digitalNZAPIDataSource = DigitalNZAPIDataSource(requestManager: requestManager, collectionWeights: collectionWeights)

func routes(_ app: Application) throws {
    app.get { _ async throws -> NZRecordsResult in
        do {
            let result = try await digitalNZAPIDataSource.newResult()
            return result
        }
        catch {
            throw Abort(.internalServerError)
        }
    }
}

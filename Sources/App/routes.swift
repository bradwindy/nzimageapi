import Vapor

let digitalNZAPIDataSource = DigitalNZAPIDataSource()

func routes(_ app: Application) throws {
    app.get { req async throws -> NZRecordsResult in
        do {
            let result = try await digitalNZAPIDataSource.newResult()
            return result
        }
        catch {
            throw Abort(.internalServerError)
        }
    }
}

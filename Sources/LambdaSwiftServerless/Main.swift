import Foundation

struct HelloResponse: Codable {
  let msg: String
}

struct WorldResponse: Codable {
  let msg: String
  let body: String
}

@main
struct Main {
  static func main() async throws {
    let _ = try await Serverless.Lambda
      .Handler(
        name: "hello",
        callback: { (event: Serverless.LambdaAPIGatewayRequest) -> Serverless.LambdaResponse in
          let body = try Serverless.Json.Encoder(
            input: HelloResponse(
              msg: "財布ないわ"
            )
          )

          return Serverless.LambdaResponse(
            statusCode: 200,
            body: body
          )
        }
      )
      .Handler(
        name: "world",
        callback: { (event: Serverless.LambdaAPIGatewayRequest) -> Serverless.LambdaResponse in
          let body = try Serverless.Json.Encoder(
            input: WorldResponse(
              msg: "財布ないわ",
              body: event.body!
            )
          )

          return Serverless.LambdaResponse(
            statusCode: 200,
            body: body
          )
        }
      )
  }
}

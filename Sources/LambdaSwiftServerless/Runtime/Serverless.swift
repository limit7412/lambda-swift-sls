import AsyncHTTPClient
import Foundation
import NIOCore
import NIOFoundationCompat

struct Serverless {
  struct LambdaAPIGatewayRequest: Codable {
    let body: String?
  }

  struct LambdaResponse: Codable {
    let statusCode: Int
    let body: String
  }

  struct ErrorResponse: Codable {
    let msg: String
    let err: String
  }

  struct Json {
    static func Encoder<T: Encodable>(input: T) throws -> String {
      let encoder = JSONEncoder()
      let data = try encoder.encode(input)

      return String(data: data, encoding: .utf8)!
    }
    static func Decoder<T: Decodable>(json: String) throws -> T {
      let decoder = JSONDecoder()
      guard let data = json.data(using: .utf8) else {
        throw NSError(domain: "Invalid JSON format", code: 0, userInfo: nil)
      }
      return try decoder.decode(T.self, from: data)
    }
  }
  struct Lambda {
    static func Handler<T: Decodable>(
      name: String, callback: (T) async throws -> LambdaResponse
    )
      async throws
      -> Lambda.Type
    {
      if name != ProcessInfo.processInfo.environment["_HANDLER"]! {
        return self
      }

      let api = ProcessInfo.processInfo.environment["AWS_LAMBDA_RUNTIME_API"]!

      while true {
        let request = HTTPClientRequest(url: "http://\(api)/2018-06-01/runtime/invocation/next")
        let response = try await HTTPClient.shared.execute(request, timeout: .seconds(30))
        let request_id = response.headers.first(name: "Lambda-Runtime-Aws-Request-Id")!

        do {
          var byteBody = try await response.body.collect(upTo: 1024 * 1024)
          let responseData = byteBody.readData(length: byteBody.readableBytes) ?? Data()
          let stringBody = String(data: responseData, encoding: .utf8)!
          let body: T = try Json.Decoder(json: stringBody)

          let result = try await callback(body)
          let resBody = try Json.Encoder(input: result)

          var request = HTTPClientRequest(
            url: "http://\(api)/2018-06-01/runtime/invocation/\(request_id)/response")
          request.method = .POST
          request.body = .bytes(ByteBuffer(string: resBody))
          let _ = try await HTTPClient.shared.execute(request, timeout: .seconds(30))
        } catch {
          print(error)

          let errBody = try Json.Encoder(
            input: ErrorResponse(
              msg: "Internal Lambda Error",
              err: error.localizedDescription
            )
          )
          let resBody = try Json.Encoder(
            input: LambdaResponse(
              statusCode: 500,
              body: errBody
            )
          )

          var request = HTTPClientRequest(
            url: "http://\(api)/2018-06-01/runtime/invocation/\(request_id)/error")
          request.method = .POST
          request.body = .bytes(ByteBuffer(string: resBody))
          let _ = try await HTTPClient.shared.execute(request, timeout: .seconds(30))
        }
      }
    }
  }
}

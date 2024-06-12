import AsyncHTTPClient
import Foundation
import NIOCore
import NIOFoundationCompat

struct Serverless {
  struct Lambda {
    static func Handler(name: String, callback: (String) async throws -> String) async throws
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
          let body = String(data: responseData, encoding: .utf8)!

          let result = try await callback(body)

          var request = HTTPClientRequest(
            url: "http://\(api)/2018-06-01/runtime/invocation/\(request_id)/response")
          request.method = .POST
          request.body = .bytes(ByteBuffer(string: result))
          let _ = try await HTTPClient.shared.execute(request, timeout: .seconds(30))
        } catch {
          print(error)

          var request = HTTPClientRequest(
            url: "http://\(api)/2018-06-01/runtime/invocation/\(request_id)/error")
          request.method = .POST
          request.body = .bytes(
            ByteBuffer(string: "{\"statusCode\": 500, \"body\": \"Internal Lambda Error\"}"))
          let _ = try await HTTPClient.shared.execute(request, timeout: .seconds(30))
        }
      }
    }
  }
}

@main
struct Main {
  static func main() async throws {
    let _ = try await Serverless.Lambda
      .Handler(
        name: "hello",
        callback: { event in
          "{\"statusCode\": 200, \"body\": \"財布ないわ\"}"
        }
      )
      .Handler(
        name: "world",
        callback: { event in
          "{\"statusCode\": 200, \"body\": \"財布ないわ  \(event)\"}"
        }
      )
  }
}

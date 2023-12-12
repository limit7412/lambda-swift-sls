
@main
struct Main {
    static func main() throws {
      Serverless.Lambda.Handler(name: "hello", f: { event in
        "財布ないわ"
      })
    }
}
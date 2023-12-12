
struct Serverless {
  struct Lambda {
    static func handler(name: String, f: (String)-> String) {
      let result = f(name)
      print(result)
    }
  }
}
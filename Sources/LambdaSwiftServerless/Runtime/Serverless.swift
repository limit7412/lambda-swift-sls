struct Serverless {
  struct Lambda {
    static func Handler(name: String, f: (String)-> String) {
      let result = f(name)
      print(result)
    }
  }
}
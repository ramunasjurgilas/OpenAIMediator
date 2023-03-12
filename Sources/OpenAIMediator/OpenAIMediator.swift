import Foundation

private var apiKey = ""

public struct OpenAIMediator {
    public private(set) var text = "Hello, World!"

    public static func setApiKey(key: String) {
        apiKey = key
    }

    init() {
    }

    static func completions(prompt: String, model: String, temperature: Int = 0) {

    }

    public static func listModels() async throws -> ListModelsResponse {
        let request = try Endpoint.listModels.request()
        let (data, response) = try await URLSession.shared.data(for: request)

        let httpResponse = response as? HTTPURLResponse
        if httpResponse?.statusCode != 200 {
            let responseString = String(decoding: data, as: UTF8.self)
            throw OpenAIMediatorError.responseError(response, responseString)
        }
        return try JSONDecoder().decode(ListModelsResponse.self, from: data)
    }
}


enum Endpoint {
    case listModels
    case completions

    var path: String {
        switch self {
        case .listModels:
            return "/models"
        case .completions:
            return "/completions"
        }
    }

    func request() throws -> URLRequest {
        let url = try url(for: self)
        var result = URLRequest(url: url)
        if apiKey.isEmpty {
            throw OpenAIMediatorError.missingApiKey
        }
        result.httpMethod = httpMethod
        result.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        return result
    }

    var httpMethod: String {
        switch self {
        case .listModels:
            return "GET"
        case .completions:
            return "POST"
        }
    }
    func url(for endpoint: Endpoint) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openai.com"
        components.path = "/v1" + endpoint.path

        if let url = components.url {
            return url
        }
        throw OpenAIMediatorError.badURL
    }
}

enum OpenAIMediatorError: Error {
    case badURL
    case missingApiKey
    case responseError(URLResponse, String)
}

/*
 curl https://api.openai.com/v1/completions \
   -H 'Content-Type: application/json' \
   -H 'Authorization: Bearer YOUR_API_KEY' \
   -d '{
   "model": "text-davinci-003",
   "prompt": "Say this is a test",
   "max_tokens": 7,
   "temperature": 0
 }'

 curl https://api.openai.com/v1/chat/completions \
   -H 'Content-Type: application/json' \
   -H 'Authorization: Bearer YOUR_API_KEY' \
   -d '{
   "model": "gpt-3.5-turbo",
   "messages": [{"role": "user", "content": "Hello!"}]
 }'

 curl https://api.openai.com/v1/edits \
   -H 'Content-Type: application/json' \
   -H 'Authorization: Bearer YOUR_API_KEY' \
   -d '{
   "model": "text-davinci-edit-001",
   "input": "What day of the wek is it?",
   "instruction": "Fix the spelling mistakes"
 }'

 curl https://api.openai.com/v1/images/generations \
   -H 'Content-Type: application/json' \
   -H 'Authorization: Bearer YOUR_API_KEY' \
   -d '{
   "prompt": "A cute baby sea otter",
   "n": 2,
   "size": "1024x1024"
 }'


 */

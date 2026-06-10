# Networking

A lightweight and modern networking layer built with Swift.
It simplifies making API requests, handling responses, and managing errors in iOS apps.

## Requirements

- 1. Platform: `iOS 16+`.
- 2. Swift-Version:`Swift 6+`.

## Features
- 🚀 Simple and clean API for network requests
- 🌐 Built on top of `URLSession`
- 📦 Supports GET, POST, PUT, DELETE, and custom HTTP methods
- 🛡️ Built-in error handling and response decoding
- 🔄 async-await support for modern iOS apps
- 🧩 Easily extendable for custom interceptors, headers, and logging

## Installation

- 1. Create xcconfig file then write this line `base_url = "https:/$()/example.com/api/"` in it.
- 2. Add new property in info.plist:
     <key>`BaseURL`</key>
     <string>`$(base_url)`</string>

## Global Configuration

## Usage

### 1 — Global Configuration: Configure once at app startup (optional)

Implement `NetworkConfigProtocol` to set global defaults applied to every request.
Skip this step if you don't need global headers, parameters, or custom settings.

```swift
struct AppNetworkConfig: NetworkConfigProtocol {

    var headers: Headers {[
        "Accept-Language": "en",
        "deviceOs": "ios"
    ]}
    
    var parameters: Parameters {[
        "version": "1"
    ]}
    
    var retries: Int { 3 }
    var timeInterval: TimeInterval { 30 }
    var dateFormat: String? { "yyyy-MM-dd" }
}
```

---


Register once in your app entry point:

```swift
@main
struct MyApp: App {

    init() {
        Networking.configure(with: AppNetworkConfig())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

---


### 2 — Create a service

```swift
struct MoviesService: ServiceProtocol {
    var path: String { "/movies" }
    var method: HTTPMethod { .GET }
    var parameters: Parameters? { ["page": page] }
    
    private let page: Int
    init(page: Int) { self.page = page }
}
```

---


### 3 — Make a request
Just create type and conform to Repository Protocol
therefore call provider

```swift
struct MoviesRepositoryAPI: Repository {
    
    func getMovies(page: Int) async -> Result<PageModel<MovieModel>, APIError> {
        let service = MoviesService(page: page)
        return await provider.request(service: service)
    }
    
    func getCategories() async -> Result<CategoriesModel, APIError> {
        let service = CategoriesService()
        return await provider.request(service: service)
    }
}
```

---


## HTTP Methods

```swift
struct CreatePostService: ServiceProtocol {
    var path: String { "/posts" }
    var method: HTTPMethod { .POST }
}

struct UpdatePostService: ServiceProtocol {
    var path: String { "/posts/\(id)" }
    var method: HTTPMethod { .PUT }
}

struct DeletePostService: ServiceProtocol {
    var path: String { "/posts/\(id)" }
    var method: HTTPMethod { .DELETE }
}
```

---

## Request Body

Pass any `Codable & Sendable` struct as the body.

```swift
struct LoginRequest: Encodable, Sendable {
    let email: String
    let password: String
}

struct LoginService: ServiceProtocol {
    var path: String { "/auth/login" }
    var method: HTTPMethod { .POST }
    var body: (any Encodable & Sendable)?
        
    init(email: String, password: String) {
        body =  LoginRequest(email: "email", password: "password")
    }
}
```

---

Set any `Dictionary` inside `AnyBody`.

```swift
struct LoginService: ServiceProtocol {
    var path: String { "/auth/login" }
    var method: HTTPMethod { .POST }
    var body: (any Encodable & Sendable)?
        
    init(email: String) {
        body = AnyBody(["email": email])
    }
}
```

---

## Media Upload

Upload single or multiple files using `media` property.
Parameters from config and service are merged into the multipart body automatically.

### Single file

```swift
struct UploadAvatarService: ServiceProtocol {
    var path: String { "/user/avatar" }
    var method: HTTPMethod { .POST }
    var media: [MediaFile]?
    
    init(image: Data) {
        media = [ MediaFile(data: image, mimeType: .jpeg) ]
    }
}
```

### Multiple files

```swift
struct UploadPostService: ServiceProtocol {
    var path: String { "/posts/media" }
    var method: HTTPMethod { .POST }
    var parameters: Parameters?
    var media: [MediaFile]?
    
    init(images: [Data], caption: String) {
        media = images.map { 
            MediaFile(data: $0, mimeType: .jpeg, fieldName: "images[]") 
        }
        parameters = ["caption": caption]
    }
}
```

### Supported media types

| Case | MIME Type |
|---|---|
| `.jpeg` | `image/jpeg` |
| `.png` | `image/png` |
| `.gif` | `image/gif` |
| `.mp4` | `video/mp4` |
| `.mov` | `video/quicktime` |
| `.pdf` | `application/pdf` |

---

## Per-request overrides

Override any global default for a specific service.

```swift
struct SensitiveService: ServiceProtocol {
    var path: String { "/secure/data" }
    var method: HTTPMethod { .GET }
    
    // override global timeout for this request only
    var timeInterval: TimeInterval? { 10 }
    
    // override global retries for this request only
    var repeats: Int? { 0 }
    
    // add extra headers on top of global headers
    var headers: Headers? {[
        "Authorization": "Bearer \(token)"
    ]}
}
```

---

## Error Handling

```swift
switch error.type {
case .network:       // no internet, timeout, DNS failure
case .server:        // 5xx server error
case .unAuthorized:  // 401 — token expired
case .notFound:      // 404 — endpoint not found
case .client:        // 4xx client error
case .parsing:       // JSON decode failed
case .noResponse:    // invalid response
case .noData:        // empty response body
case .badUrl:        // malformed URL
case .unknown:       // unclassified error
}
```

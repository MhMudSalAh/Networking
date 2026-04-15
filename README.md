# Networking

A lightweight and modern networking layer built with Swift.
It simplifies making API requests, handling responses, and managing errors in iOS apps.

## Features
- 🚀 Simple and clean API for network requests
- 🌐 Built on top of `URLSession`
- 📦 Supports GET, POST, PUT, DELETE, and custom HTTP methods
- 🛡️ Built-in error handling and response decoding
- 🔄 async-await support for modern iOS apps
- 🧩 Easily extendable for custom interceptors, headers, and logging

## Installation

- 1. Create config file by set base_url = "https://example.com/api/"
- 2. Add new property in info.plist:
     <key>BaseURL</key>
     <string>$(base_url)</string>

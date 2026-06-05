//
//  Console.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

public class Console {
    
    static func logAPI(
        url: String?,
        headers: [String: String]?,
        body: String?,
        parameters: Parameters?,
        statusCode: Int,
        response: String?,
        requestTime: TimeInterval,
        error: APIError?
    ) {
        
        lineStart()
        
        switch statusCode {
        case 200 ... 299:
            LOG("✅ Server State", "🏆 Success")
        default:
            LOG("❌ Server State", "🔥 Error:- \(error?.message ?? "")")
        }
        
        if let type = error?.type?.rawValue {
            LOG("🔥 API Error", "💥 \(type)")
        }
        
        if let parsing = error?.parsing {
            print("   📍 Key Path: \(parsing.keyPath)")
            print("   ⚠️ Expected: \(parsing.expectedType)")
//            print("   📋 Description : \(parsing.debugDescription)")
        }
        
        LOG("🔗 Url", url)
        LOG("⏳ Time", "\(requestTime)s")
        LOG("🎰 Status Code", statusCode)
        LOG("🎩 Headers", headers)
        LOG("🧰 Parameters", parameters)
        LOG("💭 Body", body)
        LOG("📬 Response", response)
        
        lineEnd()
    }
        
    static func LOG(_ tag: String, _ text: Any?) {
        print("\(tag): \(text ?? "🚫")")
    }
    
    static func lineStart() {
        print("\n↘️----------------------------------------------↙️\n")
    }
    
    static func lineEnd() {
        print("\n↗️----------------------------------------------↖️\n")
    }
}

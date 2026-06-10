//
//  Console.swift
//  Networking
//
//  Created by MhMuD SalAh on 13/04/2026.
//

import Foundation

enum Console {
    
    static func logAPI(
        url: String?,
        headers: Headers?,
        body: String?,
        parameters: Parameters?,
        statusCode: Int,
        response: String?,
        requestTime: TimeInterval,
        error: APIError?
    ) {
        
        lineStart()
        
        if let type = error?.type {
            LOG("❌ State", "💥 BoOoOm!")
            LOG("   🔥 Error", type.rawValue)
            LOG("   📮 Message", error?.message)
            
            if let parsing = error?.parsing {
                LOG("   📍 Key", parsing.keyPath)
                LOG("   ⚠️ Expected", parsing.expectedType)
//                LOG("   📋 Description", parsing.debugDescription)
            }
        } else {
            LOG("✅ State", "🏆 Success")
        }
        
        LOG("🔗 Url", url)
        LOG("⏳ Time", "\(requestTime)s")
        LOG("🎰 Status Code", "\(statusCode)")
        if let headers, !headers.isEmpty {
            LOG("🎩 Headers", headers)
        }
        if let parameters, !parameters.isEmpty {
            LOG("🧰 Parameters", parameters)
        }
        LOG("💭 Body", body)
        LOG("📬 Response", response)
        
        lineEnd()
    }
        
    static private func LOG(_ tag: String, _ text: Any?) {
        guard let text else { return }
        print("\(tag): \(text)")
    }
    
    static private func lineStart() {
        print("\n🛩️🛩️🛩️🛩️🛩️🛩️🛩️🛩️🛩️🛩️🛩️🛩️🛩️🛩️🛩️🛩️🛩️🛩️\n")
    }
    
    static private func lineEnd() {
        print("\n🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀🚀\n")
    }
}

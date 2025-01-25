//
//  MusicKitManager.swift
//  musicplus
//
//  Created by oein on 1/18/25.
//
import MusicKit
import Foundation

enum NetworkData<T> {
    case success(data: T)
    case failure
}

class MusicKitManager {
    
    static let shared = MusicKitManager()
    private init() {
    }
    
    var requiredsearchmore = false;
    var infscrollTimer: Timer? = nil;
    
    func requestAuth() async -> Bool {
        let status = await MusicAuthorization.request()
        switch status {
        case .denied:
            print("Denied")
            return false;
        case .authorized:
            print("Authorized")
            return true
        default:
            print(status)
            return false;
        }
    }
    
    func hasPermission() -> Bool {
        return MusicAuthorization.currentStatus == .authorized;
    }
    
    func getRecommend() async -> NetworkData<MusicItemCollection<MusicPersonalRecommendation>> {
        let request = MusicPersonalRecommendationsRequest()
        do {
            let response = try await request.response()
            return .success(data: response.recommendations)
        } catch {
            print("Error in requesting for recommendations: \(error)")
            return .failure
        }
    }
}

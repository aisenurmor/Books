//
//  ErrorView.swift
//
//
//  Created by Aise Nur Mor on 17.02.2025.
//

import SwiftUI

public struct ErrorView: View {
    public typealias RetryAction = () -> Void
    
    private let message: String
    private let retryAction: RetryAction
    
    public init(message: String, retryAction: @escaping RetryAction) {
        self.message = message
        self.retryAction = retryAction
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Button("Retry", action: retryAction)
                .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

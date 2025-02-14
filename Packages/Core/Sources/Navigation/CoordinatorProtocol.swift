//
//  CoordinatorProtocol.swift
//
//
//  Created by Aise Nur Mor on 15.02.2025.
//

import SwiftUI

public protocol CoordinatorProtocol: ObservableObject {
    var path: NavigationPath { get set }
    func push(_ destination: NavigationDestination)
    func pop()
    func popToRoot()
}

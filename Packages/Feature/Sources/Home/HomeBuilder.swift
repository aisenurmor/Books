//
//  File.swift
//  
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Navigation
import SwiftUI

public enum HomeBuilder {
    
    public static func build(with coordinator: any CoordinatorProtocol) -> some View {
        let entity: HomeEntityProtocol = HomeEntity()
        let networkService = HomeServiceLive()
        let interactor = HomeInteractor(
            entity: entity,
            networkService: networkService
        )
        let router = HomeRouter(coordinator: coordinator)
        let presenter = HomePresenter(
            interactor: interactor,
            router: router
        )
        
        return HomeView(presenter: presenter)
    }
}

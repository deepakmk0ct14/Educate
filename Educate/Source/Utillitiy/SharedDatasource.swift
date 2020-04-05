//
//  SharedDatasource.swift
//  Educate
//
//  Created by Deepak on 4/6/20.
//  Copyright © 2020 Deepak. All rights reserved.
//

import Foundation
class SharedDatasource {
    static let datasource = SharedDatasource()
    var userDetails: UserDetails?
    private init() {
        
    }
}

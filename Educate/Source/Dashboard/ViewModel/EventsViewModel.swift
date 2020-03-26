//
//  EventsViewModel.swift
//  Educate
//
//   3/26/20.
//  Copyright © 2020  All rights reserved.
//

import Foundation
class EventsViewModel {
     private var service: ServicesType

       init(service : ServicesType = Services()) {
           self.service = service
       }

    func getEvents(onCompletion: @escaping (([Event])->Void)) {
        service.getEventsList(onCompletion: onCompletion)
    }
}

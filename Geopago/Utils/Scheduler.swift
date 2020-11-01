//
//  Scheduler.swift
//  Geopago
//
//  Created by Lion User on 13/08/2020.
//  Copyright © 2020 Risso Pablo. All rights reserved.
//

import Foundation

final class Scheduler {

    static var backgroundWorkScheduler: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = QualityOfService.userInitiated
        return operationQueue
    }()

    static let mainScheduler = RunLoop.main

}

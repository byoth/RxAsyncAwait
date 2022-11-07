// Created by byo.

import Foundation
import XCTest

extension XCTestCase {
    func sleep(timeout: TimeInterval) {
        let expt = expectation(description: "wait for \(timeout)s")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            expt.fulfill()
        }
        
        wait(for: [expt], timeout: timeout)
    }
}

enum TestError: Error {
    case stringIsNotNum
}

func powAsync(_ num: Int) async -> Int {
    let task = Task<Int, Never> {
        return num * num
    }
    return await task.value
}

func getNumAsyncThrows(_ string: String) async throws -> Int {
    let task = Task<Int, Error> {
        guard let num = Int(string) else {
            throw TestError.stringIsNotNum
        }
        return num
    }
    return try await task.value
}

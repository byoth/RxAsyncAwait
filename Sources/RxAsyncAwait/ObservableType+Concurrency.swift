// Created by byo.

import Foundation
import RxSwift

extension ObservableType {
    public func await<Result>(_ selector: @escaping (Element) async -> Result) -> Observable<Result> {
        flatMap { element in
            Observable.create { observer in
                let task = Task {
                    let result = await selector(element)
                    observer.onNext(result)
                    observer.onCompleted()
                }
                
                return Disposables.create { task.cancel() }
            }
        }
    }
    
    public func tryAwait<Result>(_ selector: @escaping (Element) async throws -> Result) -> Observable<Result> {
        flatMap { element in
            Observable.create { observer in
                let task = Task {
                    do {
                        let result = try await selector(element)
                        observer.onNext(result)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create { task.cancel() }
            }
        }
    }
}

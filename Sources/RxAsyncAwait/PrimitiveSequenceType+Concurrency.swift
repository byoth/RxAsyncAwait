// Created by byo.

import Foundation
import RxSwift

extension PrimitiveSequenceType {
    public func await<Result>(_ transform: @escaping (Element) async -> Result)
    -> Single<Result> where Trait == SingleTrait {
        _await { await transform($0) }
            .asSingle()
    }
    
    public func await<Result>(_ transform: @escaping (Element) async -> Result)
    -> Maybe<Result> where Trait == MaybeTrait {
        _await { await transform($0) }
            .asMaybe()
    }
    
    private func _await<Result>(_ transform: @escaping (Self.Element) async -> Result)
    -> Observable<Result> {
        primitiveSequence
            .asObservable()
            .await { await transform($0) }
    }
}

extension PrimitiveSequenceType {
    public func tryAwait<Result>(_ transform: @escaping (Element) async throws -> Result)
    -> Single<Result> where Trait == SingleTrait {
        _tryAwait { try await transform($0) }
            .asSingle()
    }
    
    public func tryAwait<Result>(_ transform: @escaping (Element) async throws -> Result)
    -> Maybe<Result> where Trait == MaybeTrait {
        _tryAwait { try await transform($0) }
            .asMaybe()
    }
    
    private func _tryAwait<Result>(_ transform: @escaping (Self.Element) async throws -> Result)
    -> Observable<Result> {
        primitiveSequence
            .asObservable()
            .tryAwait { try await transform($0) }
    }
}

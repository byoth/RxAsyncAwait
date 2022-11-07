import XCTest
import RxSwift
import RxTest
@testable import RxAsyncAwait

final class RxAsyncAwaitTests: XCTestCase {
    private static let defaultTimeout: TimeInterval = 0.1
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        scheduler = nil
        disposeBag = nil
    }
    
    func test_ObservableAwait_Completed() throws {
        let observer = scheduler.createObserver(Int.self)
        
        scheduler
            .createColdObservable([
                .next(1, 1),
                .next(2, 2),
                .next(3, 3),
                .completed(4)
            ])
            .await { await powAsync($0) }
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        sleep(timeout: Self.defaultTimeout)
        
        XCTAssertTrue(
            Set(observer.events.map { $0.value.element }).isSuperset(of: [1, 4, 9])
        )
    }
    
    func test_ObservableTryAwait_Error() throws {
        let observer = scheduler.createObserver(Int.self)
        
        scheduler
            .createColdObservable([
                .next(1, "1"),
                .next(2, "2"),
                .next(3, "three")
            ])
            .tryAwait { try await getNumAsyncThrows($0) }
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        sleep(timeout: Self.defaultTimeout)
        
        XCTAssertFalse(
            observer.events.compactMap { $0.value.error }.isEmpty
        )
    }
    
    func test_SingleAwait_Success() throws {
        let xs = Single.just(10)
            .await { await powAsync($0) }
        var events = [SingleEvent<Int>]()
        
        _ = xs.subscribe { events.append($0) }
        sleep(timeout: Self.defaultTimeout)
        
        XCTAssertEqual(events, [.success(100)])
    }
    
    func test_SingleTryAwait_Success() throws {
        let xs = Single.just("123")
            .tryAwait { try await getNumAsyncThrows($0) }
        var events = [SingleEvent<Int>]()
        
        _ = xs.subscribe { events.append($0) }
        sleep(timeout: Self.defaultTimeout)
        
        XCTAssertEqual(events, [.success(123)])
    }
    
    func test_SingleTryAwait_Failure() throws {
        let xs = Single.just("hello")
            .tryAwait { try await getNumAsyncThrows($0) }
        var events = [SingleEvent<Int>]()
        
        _ = xs.subscribe { events.append($0) }
        sleep(timeout: Self.defaultTimeout)
        
        XCTAssertEqual(events, [.failure(TestError.stringIsNotNum)])
    }
    
    func test_MaybeAwait_Success() throws {
        let xs = Maybe.just(10)
            .await { await powAsync($0) }
        var events = [MaybeEvent<Int>]()
        
        _ = xs.subscribe { events.append($0) }
        sleep(timeout: Self.defaultTimeout)
        
        XCTAssertEqual(events, [.success(100)])
    }
    
    func test_MaybeTryAwait_Success() throws {
        let xs = Maybe.just("123")
            .tryAwait { try await getNumAsyncThrows($0) }
        var events = [MaybeEvent<Int>]()
        
        _ = xs.subscribe { events.append($0) }
        sleep(timeout: Self.defaultTimeout)
        
        XCTAssertEqual(events, [.success(123)])
    }
    
    func test_MaybeTryAwait_Failure() throws {
        let xs = Maybe.just("hello")
            .tryAwait { try await getNumAsyncThrows($0) }
        var events = [MaybeEvent<Int>]()
        
        _ = xs.subscribe { events.append($0) }
        sleep(timeout: Self.defaultTimeout)
        
        XCTAssertEqual(events, [.error(TestError.stringIsNotNum)])
    }
}

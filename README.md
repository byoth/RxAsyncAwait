# RxAsyncAwait

[![SwiftPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
[![Version](https://img.shields.io/cocoapods/v/RxAsyncAwait.svg?style=flat)](https://cocoapods.org/pods/RxAsyncAwait)
[![Version](https://img.shields.io/codecov/c/github/byoth/RxAsyncAwait.svg)](https://codecov.io/gh/byoth/RxAsyncAwait/)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fbyoth%2FRxAsyncAwait&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)

RxAsyncAwait is an extension for using asynchronous functions on streams in [RxSwift](https://github.com/ReactiveX/RxSwift).

I don't think it's preferred, but if you need to use asynchronous functions in the RxSwift streams, you'll have to write some annoying code to handle it because RxSwift operators don't support easy use for asynchronous functions.

This library can keep your code simple even if that happens.

## Usage

### TryAwait

```Swift
Observable.just("https://github.com/byoth")
    .compactMap { URL(string: $0) }
    .tryAwait { try await URLSession.shared.data(from: $0) }
    .subscribe()
    .disposed(by: disposeBag)
```

### Await

```Swift
Observable.just("https://github.com/byoth")
    .compactMap { URL(string: $0) }
    .await { await getData(from: $0) }
    .subscribe()
    .disposed(by: disposeBag)

func getData(from url: URL) async -> (Data, URLResponse)? {
    try? await URLSession.shared.data(from: url)
}
```

## Installation

### Swift Package Manager

```Swift
import PackageDescription

let package = Package(
    name: "Your App",
    dependencies: [
        .package(url: "https://github.com/byoth/RxAsyncAwait.git", .upToNextMajor(from: "0.1.0")),
    ]
)
```

### CocoaPods

```Ruby
target 'Your Target' do
    pod 'RxAsyncAwait', '~> 0.1'
end
```

## Requirements

- Xcode 13.2
- Swift 5.5

## Dependencies

- [RxSwift](https://github.com/ReactiveX/RxSwift) ~> 6.0.0

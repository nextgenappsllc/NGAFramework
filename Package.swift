import PackageDescription


let package = Package(
    name: "NGAFramework",
    dependencies: [
        .Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", majorVersion: 0)
    ]
)

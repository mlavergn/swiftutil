import PackageDescription

let package = Package(
    name: "Util",
    dependencies: [
    ]
)

let libUtil = Product(name: "Util", type: .Library(.Dynamic), modules: "Util")
products.append(libUtil)

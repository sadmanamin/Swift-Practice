// swift-tools-version:5.3
import PackageDescription

let package = Package(
	name: "Swift-Project-1",
	products: [
		.executable(name: "Swift-Project-1", targets: ["Swift-Project-1"]),
	],
	dependencies: [
		.package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax.git", .exact("0.50300.0")),
	],
	targets: [
		.target(name: "Swift-Project-1", dependencies: ["SwiftSyntax"])
	]
)

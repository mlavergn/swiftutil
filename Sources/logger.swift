import Foundation

/**
Keeping these for easy reference
#if os(iOS) / os(OSX) / os(tvOS)
*/
#if os(Linux)
import Glibc
#else
import Darwin
#endif

public enum LogLevel: Int {
	case ALL = 0
	case DEBUG
	case INFO
	case WARN
	case ERROR
	case FATAL
	case OFF
}

public enum LogDestination: Int {
	case STDOUT = 0
	case STDERR
	case FILE
	case SYSTEM
}

/**
@TODO 
Ideally this would leverage the unified logging system but
it appears to be broken in 3.0.2

if #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) {
	logInstance = OSLog(subsystem:subsystem, category:category)
	os_log("demo", log:logInstance, type:.error)
}

produces no output
*/

public struct Log {
	static var logLevel: LogLevel = LogLevel.ALL
	static var logDestination: LogDestination = LogDestination.STDOUT

	static var timeMark: DispatchTime?

	/**
	Configures the logging
	*/
	public static func configure(level: LogLevel, destination: LogDestination) {
		logLevel = level
		logDestination = destination
	}

	/**
	Outputs data to a destination
	*/
 	@inline(__always) public static func output(_ message: String) {
		switch(logDestination) {
			case .STDERR:
				fputs("\(message)\n", __stderrp)
			default:
				print(message)
		}
	}

	/**
	Debug level messages
	*/
 	@inline(__always) public static func debug(_ message: String) {
		if logLevel.rawValue <= LogLevel.DEBUG.rawValue {
			output("DEBUG: \(message)")
		}
	}

	/**
	Info level messages
	*/
	@inline(__always) public static func info(_ message: String) {
		if logLevel.rawValue <= LogLevel.INFO.rawValue {
			output("INFO: \(message)")
		}
	}

	/**
	Warn level messages
	*/
	@inline(__always) public static func warn(_ message: String) {
		if logLevel.rawValue <= LogLevel.WARN.rawValue {
			output("WARN: \(message)")
		}
	}

	/**
	Error level messages
	*/
	static public func error(_ message: String) {
		if logLevel.rawValue <= LogLevel.ERROR.rawValue {
			output("ERROR: \(message)")
		}
	}

	/**
	Fatal level messages
	*/
	static public func fatal(_ message: String) {
		output("FATAL: \(message)")
	}

	/**
	Outputs the file, function, and line stamp to stdout
	*/
	@inline(__always) public static func stamp(function: String = #function, file: String = #file, line: Int = #line) {
		if logLevel.rawValue <= LogLevel.DEBUG.rawValue {
			 output("[File:\(file), Function:\(function), Line:\(line)]")
		}
	}

	/**
	Measures elapsed time and prints a nanosecond resolution time to stdout
	*/
	public static func dumpFile(output: String) {
		if #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) {
			var pathURL = FileManager.default.homeDirectoryForCurrentUser
			pathURL = pathURL.appendingPathComponent("log/swift")
			do {
				try FileManager.default.createDirectory(atPath: pathURL.path, withIntermediateDirectories: true, attributes: nil)
				let epoch = NSDate().timeIntervalSince1970
				pathURL = pathURL.appendingPathComponent("\(epoch).log")
				try output.write(to:pathURL, atomically:false, encoding:String.Encoding.utf8)
			} catch let error as NSError {
				print(error.localizedDescription)
			}
		}
	}

	/**
	Measures elapsed time and prints a nanosecond resolution time to stdout
	*/
	public static var timerMark: Void {
		timeMark = DispatchTime.now()
	}

	/**
	Measures elapsed time and prints a nanosecond resolution time to stdout
	*/
	public static var timerMeasure: Void {
		if timeMark != nil {
			let timeInterval = Double(DispatchTime.now().uptimeNanoseconds - timeMark!.uptimeNanoseconds) / 1_000_000
			output("ELAPSED [\(timeInterval)]ms")
		}
	}
}

/// Persistence via NSUserDefaults
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT
import Foundation

public class Task: NSObject {

    /// Execute an OS command and return the captured stdout
    func execute(_ command: String, _ args: [String]) -> String {
        let process = Process()
        let pipe = Pipe()

        process.launchPath = command
        process.arguments = args
        process.standardOutput = pipe

        process.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data)!
        
        return output
    }
}

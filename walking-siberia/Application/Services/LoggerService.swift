import SwiftyBeaver

public let log = SwiftyBeaver.self

public struct LoggerService {
    
    public static func setup() {
        #if DEBUG
            let consoleDestination = ConsoleDestination()
            log.addDestination(consoleDestination)
        #endif

        let fileDestination = FileDestination()
        log.addDestination(fileDestination)

        log.info("Logger: start \(Bundle.main.version)")
    }
    
}

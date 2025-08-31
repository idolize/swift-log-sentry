import Foundation
import Logging
import Sentry

public struct SentryLogHandler: LogHandler {
    private let label: String
    private let client: BreadcrumbTracker

    public var metadata = Logger.Metadata()
    public var logLevel: Logger.Level = .info

    public init(label: String, client: BreadcrumbTracker = .live) {
        self.label = label
        self.client = client
    }

    /// This method is called when a `LogHandler` must emit a log message. There is no need for the `LogHandler` to
    /// check if the `level` is above or below the configured `logLevel` as `Logger` already performed this check and
    /// determined that a message should be logged.
    ///
    /// - parameters:
    ///     - level: The log level the message was logged at.
    ///     - message: The message to log. To obtain a `String` representation call `message.description`.
    ///     - metadata: The metadata associated to this log message.
    ///     - source: The source where the log message originated, for example the logging module.
    ///     - file: The file the log message was emitted from.
    ///     - function: The function the log line was emitted from.
    ///     - line: The line the log message was emitted from.
    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        let crumb = Breadcrumb()

        crumb.category = label

        switch level {
        case .critical:
            crumb.level = .fatal
        case .debug:
            crumb.level = .debug
        case .info:
            crumb.level = .info
        case .notice:
            crumb.level = .warning
        case .warning:
            crumb.level = .warning
        case .trace:
            crumb.level = .debug
        case .error:
            crumb.level = .error
        }

        crumb.type = "log"
        crumb.message = message.description
        crumb.timestamp = Date()

        crumb.data = (metadata ?? self.metadata).reduce(into: [:]) { data, metadata in
            data[metadata.key] = metadata.value.description
        }

        crumb.data?["source"] = source
        crumb.data?["file"] = file
        crumb.data?["function"] = function
        crumb.data?["line"] = line

        client.addBreadcrumb(crumb)
    }

    /// Add, remove, or change the logging metadata.
    /// - parameters:
    ///    - metadataKey: the key for the metadata item.
    public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { self.metadata[key] }
        set { self.metadata[key] = newValue }
    }
}

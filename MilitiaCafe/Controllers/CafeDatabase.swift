import Foundation

/// Simple on-device persistence for the café app. Codable records are written as
/// atomic JSON files in Application Support, so this works without adding an
/// external SQLite module or package. Each device keeps its own data.
enum CafeDatabase {
    private static let directoryName = "MilitiaCafeDatabase"
    private static let lock = NSRecursiveLock()

    static func load<Value: Codable>(
        _ type: Value.Type,
        from key: String,
        default fallback: Value
    ) -> Value {
        lock.lock()
        defer { lock.unlock() }

        if let url = fileURL(for: key),
           let data = try? Data(contentsOf: url),
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }

        // Migrate orders saved by the app's original UserDefaults implementation.
        if key == "orders.json",
           let data = UserDefaults.standard.data(forKey: "militiaOrders"),
           let value = try? JSONDecoder().decode(type, from: data) {
            write(value, to: key)
            return value
        }

        return fallback
    }

    static func save<Value: Encodable>(_ value: Value, to key: String) {
        lock.lock()
        defer { lock.unlock() }
        write(value, to: key)
    }

    private static func write<Value: Encodable>(_ value: Value, to key: String) {
        guard let url = fileURL(for: key),
              let data = try? JSONEncoder().encode(value) else {
            return
        }
        try? data.write(to: url, options: .atomic)
    }

    private static func fileURL(for key: String) -> URL? {
        guard let root = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else {
            return nil
        }

        let directory = root.appendingPathComponent(directoryName, isDirectory: true)
        do {
            try FileManager.default.createDirectory(
                at: directory,
                withIntermediateDirectories: true
            )
        } catch {
            return nil
        }

        // Restrict the key to a plain filename within our app's data directory.
        let filename = URL(fileURLWithPath: key).lastPathComponent
        guard !filename.isEmpty else { return nil }
        return directory.appendingPathComponent(filename, isDirectory: false)
    }
}

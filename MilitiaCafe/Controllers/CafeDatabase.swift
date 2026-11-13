import Foundation

/// Lightweight on-device persistence for the café demo. Data is stored as JSON
/// files in Application Support and survives app restarts. A hosted database is
/// required to share changes between separate customer and admin devices.
enum CafeDatabase {
    private static let directoryName = "MilitiaCafeDatabase"

    static func load<Value: Decodable>(_ type: Value.Type, from filename: String, default fallback: Value) -> Value {
        guard let url = fileURL(for: filename),
              let data = try? Data(contentsOf: url),
              let value = try? JSONDecoder().decode(type, from: data) else {
            return fallback
        }
        return value
    }

    static func save<Value: Encodable>(_ value: Value, to filename: String) {
        guard let url = fileURL(for: filename),
              let data = try? JSONEncoder().encode(value) else { return }
        try? data.write(to: url, options: .atomic)
    }

    private static func fileURL(for filename: String) -> URL? {
        guard let root = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        let directory = root.appendingPathComponent(directoryName, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            return directory.appendingPathComponent(filename)
        } catch {
            return nil
        }
    }
}

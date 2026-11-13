import Foundation
import SQLite3

/// SQLite-backed on-device database. Records are JSON-encoded and stored in a
/// keyed table, keeping the existing Codable models and controller API intact.
/// This database is private to this app installation; cross-device sync needs a
/// hosted backend and project credentials (for example, Firebase or Supabase).
enum CafeDatabase {
    private static let directoryName = "MilitiaCafeDatabase"
    private static let databaseName = "militia-cafe.sqlite"
    private static let lock = NSRecursiveLock()
    private static var connection: OpaquePointer?
    private static let transient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

    static func load<Value: Decodable>(
        _ type: Value.Type,
        from key: String,
        default fallback: Value
    ) -> Value {
        lock.lock()
        defer { lock.unlock() }

        guard let database = openDatabase() else {
            return loadLegacyFile(type, key: key) ?? fallback
        }

        var statement: OpaquePointer?
        let sql = "SELECT payload FROM cafe_records WHERE record_key = ? LIMIT 1;"
        guard sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK,
              let statement else {
            return loadLegacyFile(type, key: key) ?? fallback
        }
        defer { sqlite3_finalize(statement) }

        let result = key.withCString { keyPointer in
            sqlite3_bind_text(statement, 1, keyPointer, -1, transient)
            return sqlite3_step(statement)
        }

        if result == SQLITE_ROW,
           let text = sqlite3_column_text(statement, 0) {
            let json = String(cString: text)
            if let value = try? JSONDecoder().decode(type, from: Data(json.utf8)) {
                return value
            }
        }

        // Migrate data written by the previous JSON-file implementation.
        if let legacyValue = loadLegacyFile(type, key: key) {
            save(legacyValue, to: key)
            return legacyValue
        }
        return fallback
    }

    static func save<Value: Encodable>(_ value: Value, to key: String) {
        lock.lock()
        defer { lock.unlock() }

        guard let database = openDatabase(),
              let data = try? JSONEncoder().encode(value),
              let json = String(data: data, encoding: .utf8) else {
            return
        }

        let sql = "INSERT INTO cafe_records (record_key, payload, updated_at) VALUES (?, ?, ?) ON CONFLICT(record_key) DO UPDATE SET payload = excluded.payload, updated_at = excluded.updated_at;"
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK,
              let statement else { return }
        defer { sqlite3_finalize(statement) }

        key.withCString { keyPointer in
            json.withCString { jsonPointer in
                sqlite3_bind_text(statement, 1, keyPointer, -1, transient)
                sqlite3_bind_text(statement, 2, jsonPointer, -1, transient)
                sqlite3_bind_double(statement, 3, Date().timeIntervalSince1970)
            }
        }
        sqlite3_step(statement)
    }

    private static func openDatabase() -> OpaquePointer? {
        if let connection { return connection }
        guard let root = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else { return nil }

        let directory = root.appendingPathComponent(directoryName, isDirectory: true)
        do {
            try FileManager.default.createDirectory(
                at: directory,
                withIntermediateDirectories: true
            )
        } catch {
            return nil
        }

        let databaseURL = directory.appendingPathComponent(databaseName)
        var openedDatabase: OpaquePointer?
        let openResult = databaseURL.path.withCString { pathPointer in
            sqlite3_open(pathPointer, &openedDatabase)
        }
        guard openResult == SQLITE_OK, let openedDatabase else {
            if let openedDatabase { sqlite3_close(openedDatabase) }
            return nil
        }

        let createTableSQL = "CREATE TABLE IF NOT EXISTS cafe_records (record_key TEXT PRIMARY KEY NOT NULL, payload TEXT NOT NULL, updated_at REAL NOT NULL);"
        guard sqlite3_exec(openedDatabase, createTableSQL, nil, nil, nil) == SQLITE_OK else {
            sqlite3_close(openedDatabase)
            return nil
        }
        connection = openedDatabase
        return openedDatabase
    }

    private static func loadLegacyFile<Value: Decodable>(
        _ type: Value.Type,
        key: String
    ) -> Value? {
        guard let root = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else { return nil }
        let url = root
            .appendingPathComponent(directoryName, isDirectory: true)
            .appendingPathComponent(key)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}

# Militia Café database

The iOS app stores its products, cart, and orders in a local SQLite database named `militia-cafe.sqlite` under the app's Application Support directory. Records are JSON-encoded in the `cafe_records` table so the existing Swift `Codable` models remain compatible. Older JSON-file records are migrated the first time they are read.

This is persistent on-device storage, not a shared online database: data is not synchronized between customer and admin devices. To enable multi-device accounts, product updates, and order sync, configure a hosted service such as Firebase or Supabase, including its project URL/keys and access rules. Do not put secret service credentials in public source code.

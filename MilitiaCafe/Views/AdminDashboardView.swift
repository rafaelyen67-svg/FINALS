import SwiftUI

/// Kept as a compatibility wrapper for existing navigation references.
struct AdminDashboardView: View {
    let admin: Admin?

    var body: some View {
        AdminView(admin: admin)
    }
}

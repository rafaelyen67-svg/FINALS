//
//  OrderConfirmationView.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//
import SwiftUI

struct OrderConfirmationView: View {

    let order: Order

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        ScrollView {

            VStack(spacing: 20) {

                Text("☕")
                    .font(.system(size: 60))

                Text("Order Confirmed!")
                    .font(
                        .system(
                            size: 32,
                            weight: .bold,
                            design: .serif
                        )
                    )
                    .foregroundStyle(AppTheme.brown)

                Text("Thank you, \(order.customerName)!")
                    .font(.title3)

                Text("Your coffee is being prepared.")
                    .foregroundStyle(.secondary)

                QRCodeView(
                    code: order.orderNumber
                )
                .padding()
                .background(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20)
                )

                Text("Order #\(order.orderNumber)")
                    .font(.headline)
                    .foregroundStyle(AppTheme.brown)

                Text("Total")
                    .font(.headline)

                Text(
                    "₱\(order.total, specifier: "%.0f")"
                )
                .font(.title2)
                .bold()

                VStack(spacing: 8) {

                    Text("Pickup Branch")
                        .font(.headline)

                    Text(order.branch)

                    Text("Payment")
                        .font(.headline)
                        .padding(.top, 5)

                    Text(order.payment)
                }

                Text(
                    "Show this QR code when you pick up your coffee."
                )
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

                Button {

                    NotificationCenter.default.post(
                        name: .goToHome,
                        object: nil
                    )

                    dismiss()

                } label: {

                    Text("Back to Home")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.brown)
                        .foregroundStyle(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 18)
                        )
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .background(
            AppTheme.cream
                .ignoresSafeArea()
        )
        .navigationTitle("Order Confirmed")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension Notification.Name {

    static let goToHome =
        Notification.Name("goToHome")
}

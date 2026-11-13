//
//  CheckoutView.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import SwiftUI

struct CheckoutView: View {

    @EnvironmentObject var cartController: CartController
    @EnvironmentObject var orderController: OrderController

    @State private var name = ""
    @State private var phone = ""
    @State private var branch = "Main Branch"
    @State private var payment = "Cash"
    @State private var errorMessage = ""
    @State private var createdOrder: Order?

    let branches = [
        "Main Branch",
        "Lucena Branch",
        "Quezon Branch"
    ]

    let payments = [
        "Cash",
        "GCash"
    ]

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                Text("Checkout")
                    .font(
                        .system(
                            size: 32,
                            weight: .bold,
                            design: .serif
                        )
                    )
                    .foregroundStyle(AppTheme.brown)

                TextField("Your Name", text: $name)
                    .padding()
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )

                TextField("Phone Number", text: $phone)
                    .keyboardType(.phonePad)
                    .padding()
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )

                Text("Pickup Branch")
                    .font(.headline)

                Picker("Branch", selection: $branch) {
                    ForEach(branches, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)

                Text("Payment")
                    .font(.headline)

                Picker("Payment", selection: $payment) {
                    ForEach(payments, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                }

                Divider()

                HStack {

                    Text("Total")
                        .font(.title2)
                        .bold()

                    Spacer()

                    Text(
                        "₱\(cartController.total, specifier: "%.0f")"
                    )
                    .font(.title2)
                    .bold()
                    .foregroundStyle(AppTheme.brown)
                }

                Button("Place Order") {

                    if name.isEmpty {
                        errorMessage = "Please enter your name."
                        return
                    }

                    if phone.isEmpty {
                        errorMessage = "Please enter your phone number."
                        return
                    }

                    if cartController.items.isEmpty {
                        errorMessage = "Your cart is empty."
                        return
                    }

                    createdOrder = orderController.createOrder(
                        name: name,
                        phone: phone,
                        items: cartController.items,
                        branch: branch,
                        payment: payment
                    )

                    if createdOrder != nil {
                        cartController.clearCart()
                        errorMessage = ""
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.brown)
                .foregroundStyle(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 18)
                )

                if let order = createdOrder {

                    NavigationLink {
                        OrderConfirmationView(
                            order: order
                        )
                    } label: {

                        Text("View Order Confirmation")
                            .frame(maxWidth: .infinity)
                    }
                    .foregroundStyle(AppTheme.brown)
                }
            }
            .padding()
        }
        .background(
            AppTheme.cream
                .ignoresSafeArea()
        )
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
    }
}



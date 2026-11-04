import SwiftUI

struct MoneyKeypadView: View {
    @Binding var amount: MoneyAmountEntry

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(amount.currencyCode)
                Spacer()
                Text(amount.text.isEmpty ? "0" : amount.text)
                    .monospacedDigit()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
            .font(.largeTitle.weight(.semibold))
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text(String(format: NSLocalizedString("Amount: %@", comment: "VoiceOver description of the payment amount, including currency"), amount.formattedAmount)))
            .padding()
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(1...9, id: \.self) { digit in
                    key(String(digit)) { amount.appendDigit(digit) }
                }
                key(".") { amount.appendDecimalSeparator() }
                key("0") { amount.appendDigit(0) }
                Button { amount.deleteLastCharacter() } label: {
                    Image(systemName: "delete.left")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .accessibilityLabel(Text(NSLocalizedString("Delete last digit", comment: "VoiceOver label for the amount keypad backspace button")))
                .buttonStyle(.bordered)
            }
            .font(.title2)

            Button(NSLocalizedString("Clear amount", comment: "Clear the entire payment amount entered on the keypad")) { amount.clear() }
        }
    }

    private func key(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity, minHeight: 44)
        }
        .buttonStyle(.bordered)
    }
}

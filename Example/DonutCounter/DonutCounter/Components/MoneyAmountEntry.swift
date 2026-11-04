import Foundation

/// Keeps keypad arithmetic in minor units so the displayed amount and charge cannot diverge through floating-point rounding.
struct MoneyAmountEntry {
    let currencyCode: String
    let locale: Locale
    private(set) var text = ""

    init(currencyCode: String = "AUD", locale: Locale = Locale(identifier: "en_AU")) {
        self.currencyCode = currencyCode
        self.locale = locale
    }

    var payableAmount: UInt? {
        guard let value = minorUnits(in: text), value > 0 else { return nil }
        return value
    }

    var formattedAmount: String {
        let value = Decimal(minorUnits(in: text) ?? 0) / Decimal(scale)
        return formatter.string(from: NSDecimalNumber(decimal: value)) ?? currencyCode
    }

    mutating func appendDigit(_ digit: Int) {
        guard (0...9).contains(digit) else { return }
        let candidate = text == "0" ? String(digit) : text + String(digit)
        guard minorUnits(in: candidate) != nil else { return }
        text = candidate
    }

    mutating func appendDecimalSeparator() {
        guard fractionDigits > 0, !text.contains(".") else { return }
        text = text.isEmpty ? "0." : text + "."
    }

    mutating func deleteLastCharacter() {
        if !text.isEmpty { text.removeLast() }
    }

    mutating func clear() {
        text = ""
    }

    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currencyISOCode
        formatter.currencyCode = currencyCode
        return formatter
    }

    private var fractionDigits: Int { formatter.maximumFractionDigits }

    private var scale: UInt {
        (0..<fractionDigits).reduce(UInt(1)) { value, _ in value * 10 }
    }

    private func minorUnits(in text: String) -> UInt? {
        let parts = text.split(separator: ".", omittingEmptySubsequences: false)
        guard parts.count <= 2, let whole = UInt(parts.first.map(String.init) ?? "0") else { return nil }
        let fraction = parts.count == 2 ? String(parts[1]) : ""
        guard fraction.count <= fractionDigits else { return nil }
        let paddedFraction = fraction + String(repeating: "0", count: fractionDigits - fraction.count)
        let (scaled, multiplyOverflow) = whole.multipliedReportingOverflow(by: scale)
        let (amount, addOverflow) = scaled.addingReportingOverflow(UInt(paddedFraction) ?? 0)
        guard !multiplyOverflow, !addOverflow, amount <= UInt(Int64.max) else { return nil }
        return amount
    }
}

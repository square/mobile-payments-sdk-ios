import Foundation
import Testing
@testable import DonutCounterAmount

struct MoneyAmountEntryTests {
    @Test func `Charges the exact decimal amount entered`() {
        var amount = MoneyAmountEntry()
        amount.appendDigit(2)
        amount.appendDigit(0)
        amount.appendDigit(0)
        amount.appendDecimalSeparator()
        amount.appendDigit(2)
        amount.appendDigit(9)
        #expect(amount.payableAmount == 20029)
        #expect(amount.formattedAmount.contains("AUD"))
        #expect(amount.formattedAmount.contains("200.29"))
    }

    @Test func `Rejects a third fractional digit and a second decimal point`() {
        var amount = MoneyAmountEntry()
        amount.appendDecimalSeparator()
        amount.appendDigit(2)
        amount.appendDecimalSeparator()
        amount.appendDigit(9)
        amount.appendDigit(9)
        #expect(amount.payableAmount == 29)
        #expect(amount.text == "0.29")
    }

    @Test func `Empty and zero amounts cannot be charged`() {
        var amount = MoneyAmountEntry()
        #expect(amount.payableAmount == nil)
        amount.appendDigit(0)
        amount.appendDecimalSeparator()
        amount.appendDigit(0)
        #expect(amount.payableAmount == nil)
    }

    @Test func `Deleting allows correcting the amount`() {
        var amount = MoneyAmountEntry()
        amount.appendDigit(0)
        amount.appendDigit(2)
        amount.appendDecimalSeparator()
        amount.appendDigit(9)
        amount.deleteLastCharacter()
        amount.appendDigit(1)
        #expect(amount.payableAmount == 210)
        amount.clear()
        amount.deleteLastCharacter()
        #expect(amount.payableAmount == nil)
    }

    @Test func `Long input cannot overflow the SDK money amount`() {
        var amount = MoneyAmountEntry()
        for _ in 0..<100 { amount.appendDigit(9) }
        #expect(amount.payableAmount == 999999999999999900)
        #expect(amount.text == "9999999999999999")
    }

    @Test func `Currency metadata controls minor unit precision`() {
        var amount = MoneyAmountEntry(currencyCode: "JPY", locale: Locale(identifier: "ja_JP"))
        amount.appendDigit(5)
        amount.appendDecimalSeparator()
        amount.appendDigit(9)
        #expect(amount.payableAmount == 59)
        #expect(amount.text == "59")
    }

    @Test func `Yen has no fractional units in a US locale`() {
        var amount = MoneyAmountEntry(currencyCode: "JPY", locale: Locale(identifier: "en_US"))
        amount.appendDigit(5)
        amount.appendDecimalSeparator()
        amount.appendDigit(9)
        #expect(amount.payableAmount == 59)
        #expect(!amount.allowsFractionalAmount)
    }

    @Test(arguments: ["AUD", "CAD", "EUR", "GBP", "USD"])
    func `Decimal currencies preserve exact minor units in a Japanese locale`(code: String) {
        var amount = MoneyAmountEntry(currencyCode: code, locale: Locale(identifier: "ja_JP"))
        amount.appendDigit(5)
        amount.appendDecimalSeparator()
        amount.appendDigit(2)
        amount.appendDigit(9)
        #expect(amount.payableAmount == 529)
        #expect(amount.allowsFractionalAmount)
    }
}

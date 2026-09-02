enum PaymentMethod {
  cash,
  creditCard,
  debitCard,
  bankTransfer,
  digitalWallet,
  other,
}

extension PaymentMethodExtension on PaymentMethod {
  String get value {
    switch (this) {
      case PaymentMethod.cash:
        return 'CASH';
      case PaymentMethod.creditCard:
        return 'CREDIT_CARD';
      case PaymentMethod.debitCard:
        return 'DEBIT_CARD';
      case PaymentMethod.bankTransfer:
        return 'BANK_TRANSFER';
      case PaymentMethod.digitalWallet:
        return 'DIGITAL_WALLET';
      case PaymentMethod.other:
        return 'OTHER';
    }
  }

  static PaymentMethod fromValue(String value) {
    switch (value.toUpperCase()) {
      case 'CASH':
        return PaymentMethod.cash;
      case 'CREDIT_CARD':
        return PaymentMethod.creditCard;
      case 'DEBIT_CARD':
        return PaymentMethod.debitCard;
      case 'BANK_TRANSFER':
        return PaymentMethod.bankTransfer;
      case 'DIGITAL_WALLET':
        return PaymentMethod.digitalWallet;
      case 'OTHER':
        return PaymentMethod.other;
      default:
        return PaymentMethod.other;
    }
  }
}
enum CardType {
  number,
  triangle,
  square,
  prime,
}

class NumbaCard {
  final CardType type;
  final int? value;
  final String id;

  NumbaCard({
    required this.type,
    this.value,
    required this.id,
  });

  String get displayName {
    switch (type) {
      case CardType.number:
        return value?.toString() ?? '';
      case CardType.triangle:
        return 'Triangle';
      case CardType.square:
        return 'Square';
      case CardType.prime:
        return 'Prime';
    }
  }

  String get displaySymbol {
    switch (type) {
      case CardType.number:
        return value?.toString() ?? '';
      case CardType.triangle:
        return '△';
      case CardType.square:
        return '□';
      case CardType.prime:
        return 'P';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NumbaCard && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
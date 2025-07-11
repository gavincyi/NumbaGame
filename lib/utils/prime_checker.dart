class PrimeChecker {
  static bool isPrime(int number) {
    if (number < 2) return false;
    if (number == 2) return true;
    if (number % 2 == 0) return false;
    
    for (int i = 3; i * i <= number; i += 2) {
      if (number % i == 0) return false;
    }
    
    return true;
  }
  
  static bool isComposite(int number) {
    return number > 1 && !isPrime(number);
  }
  
  // Get all prime numbers up to a given limit (for reference)
  static List<int> getPrimesUpTo(int limit) {
    final primes = <int>[];
    for (int i = 2; i <= limit; i++) {
      if (isPrime(i)) {
        primes.add(i);
      }
    }
    return primes;
  }
}
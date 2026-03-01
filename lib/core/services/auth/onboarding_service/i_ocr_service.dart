abstract class IOcrService {
  Future<bool> hasCompletedOCR();
  Future<void> markOCRComplete();
}
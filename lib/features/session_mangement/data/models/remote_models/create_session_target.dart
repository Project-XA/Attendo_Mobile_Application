sealed class CreateSessionTarget {
  const CreateSessionTarget();
}

class HallTarget extends CreateSessionTarget {
  final int hallId;
  const HallTarget(this.hallId);
}

class SectionTarget extends CreateSessionTarget {
  final int sectionId;
  const SectionTarget(this.sectionId);
}
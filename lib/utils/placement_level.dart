/// Maps onboarding placement score (0.0–1.0) to allowed curriculum level.
/// Below 50% → 1; from 50% through 75% → 2; above 75% → 3.
int placementLevelFromScoreFraction(double fraction) {
  if (fraction < 0.5) return 1;
  if (fraction <= 0.75) return 2;
  return 3;
}

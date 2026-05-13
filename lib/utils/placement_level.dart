int placementLevelFromScoreFraction(double fraction) {
  if (fraction < 0.5) return 1;
  if (fraction <= 0.75) return 2;
  return 3;
}

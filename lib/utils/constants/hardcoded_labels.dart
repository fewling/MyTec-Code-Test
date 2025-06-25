part of 'constants.dart';

// Use this enum to define hardcoded labels used across the app while developing.
// This helps in maintaining consistency and easier to find where hardcoded strings are used.
// When development works are done, consider replacing these with localized strings.
enum HardcodedLabels {
  floorIndicator('L'),
  filterChip('Filter'),
  datePickerChip('Today'),
  timePickerChip('Now'),
  seatPickerChip('Seats'),
  alLCentresSelected('All Centres'),
  multipleCentresSelected('Centres Selected'),
  pricePerHour(' / hour'),
  noRoomsFound('No rooms found'),
  roomUnavailable('UNAVAILABLE'),
  noCentresSelected('No Centres Selected'),
  filterDateTitle('Date'),
  filterStartTimeTitle('Start Time'),
  filterEndTimeTitle('End Time'),
  filterCapacityTitle('Capacity'),
  filterCentreTitle('Centres'),
  filterVideoConferenceTitle('Video Conference'),
  filterCentreSelection('{0} in {1}'),
  filterCentreSelectPrompt('Select Centres');

  const HardcodedLabels(this.label);
  final String label;
}

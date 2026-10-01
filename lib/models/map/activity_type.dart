enum TrackerActivityType { running, walking, cycling }

TrackerActivityType activityTypeFromString(String s) {
  switch (s) {
    case "running":
      return TrackerActivityType.running;
    case "walking":
      return TrackerActivityType.walking;
    case "cycling":
      return TrackerActivityType.cycling;
    default:
      return TrackerActivityType.running;
  }
}

String activityTypeToString(TrackerActivityType type) {
  switch (type) {
    case TrackerActivityType.running:
      return "running";
    case TrackerActivityType.walking:
      return "walking";
    case TrackerActivityType.cycling:
      return "cycling";
  }
}

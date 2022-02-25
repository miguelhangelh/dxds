enum NOTIFICATION {
  TRAVEL_PAID,
  TRAVEL_NEW,
  NEWS,
  BENEFITS,
  LOCATION,
  REJECT_TASK,
  VALIDATE_TASK,
  POSTULATION_ACCEPTED,
  ASSIGNED_LOAD_ORDER,
  CANCEL_LOAD_ORDER,
  UPDATE_USER,
}

notificationType(NOTIFICATION type) {
  switch (type) {
    case NOTIFICATION.TRAVEL_PAID:
      return "travelPaid";
    case NOTIFICATION.TRAVEL_NEW:
      return "travel";
    case NOTIFICATION.NEWS:
      return "news";
    case NOTIFICATION.BENEFITS:
      return "benefits";
    case NOTIFICATION.LOCATION:
      return "location";
    case NOTIFICATION.REJECT_TASK:
      return "rejecttasks";
    case NOTIFICATION.VALIDATE_TASK:
      return "tasks";
    case NOTIFICATION.POSTULATION_ACCEPTED:
      return "postulationAccepted";
    case NOTIFICATION.ASSIGNED_LOAD_ORDER:
        return "AssignedLoadOrder";
    case NOTIFICATION.CANCEL_LOAD_ORDER:
      return "cancelLoadingOrder";
    case NOTIFICATION.UPDATE_USER:
      return "updateuser";
    default:
      return "";
  }
}

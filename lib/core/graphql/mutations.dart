const String createEventMutation = '''
  mutation CreateEvent(\$input: CreateEventInput!) {
    createEvent(input: \$input) {
      id
      description
      startDate
      creator {
        displayName
      }
    }
  }
''';

const String updateEventMutation = '''
  mutation UpdateEvent(\$id: ID!, \$input: UpdateEventInput!) {
    updateEvent(id: \$id, input: \$input) {
      id
      description
      startDate
      endDate
    }
  }
''';

const String deleteEventMutation = '''
  mutation DeleteEvent(\$id: ID!) {
    deleteEvent(id: \$id)
  }
''';

const String createFigureMutation = '''
  mutation CreateFigure(\$input: CreateFigureInput!) {
    createFigure(input: \$input) {
      id
      name
      description
      creator {
        displayName
      }
    }
  }
''';

const String createCommentMutation = '''
  mutation CreateComment(\$input: CreateCommentInput!) {
    createComment(input: \$input) {
      id
      text
      user {
        displayName
      }
      createdAt
    }
  }
''';

const String toggleLikeMutation = '''
  mutation ToggleLike(\$input: LikeDislikeInput!) {
    toggleLikeDislike(input: \$input) {
      id
      isLike
      entityType
      entityId
    }
  }
''';

const String createReportMutation = '''
  mutation CreateReport(\$input: CreateReportInput!) {
    createReport(input: \$input) {
      id
      reason
      description
      entityType
    }
  }
''';

const String uploadImageMutation = '''
  mutation UploadImage(\$file: Upload!, \$folder: String) {
    uploadImage(file: \$file, folder: \$folder)
  }
''';

const String markAsViewedMutation = '''
  mutation MarkAsViewed(\$entityType: EntityType!, \$entityId: ID!) {
    markAsViewed(entityType: \$entityType, entityId: \$entityId)
  }
''';

const String getRegionsQuery = '''
  query GetRegions {
    regions {
      id
      name
      geoBoundary
    }
  }
''';

const String getEventsQuery = '''
  query GetEvents(\$input: GetEventsInput!) {
    events(input: \$input) {
      events {
        id
        description
        startDate
        endDate
        imageUrl
        likesCount
        dislikesCount
        creator {
          displayName
        }
        region {
          name
        }
      }
      pagination {
        totalCount
        hasNextPage
        hasPreviousPage
      }
    }
  }
''';

const String getEventQuery = '''
  query GetEvent(\$id: ID!) {
    event(id: \$id) {
      id
      description
      startDate
      endDate
      imageUrl
      sourceUrl
      likesCount
      dislikesCount
      creator {
        id
        displayName
      }
      region {
        name
      }
      comments {
        id
        text
        user {
          displayName
        }
        createdAt
      }
    }
  }
''';

const String getFiguresQuery = '''
  query GetFigures(\$limit: Int, \$offset: Int) {
    figures(limit: \$limit, offset: \$offset) {
      figures {
        id
        name
        description
        imageUrl
        likesCount
        dislikesCount
        creator {
          displayName
        }
        eventRelations {
          relationDescription
          event {
            description
            startDate
          }
        }
      }
      pagination {
        totalCount
        hasNextPage
        hasPreviousPage
      }
    }
  }
''';

const String getFigureQuery = '''
  query GetFigure(\$id: ID!) {
    figure(id: \$id) {
      id
      name
      description
      imageUrl
      sourceUrl
      likesCount
      dislikesCount
      creator {
        id
        displayName
      }
      comments {
        id
        text
        user {
          displayName
        }
        createdAt
      }
      eventRelations {
        relationDescription
        event {
          id
          description
          startDate
          endDate
        }
      }
    }
  }
''';

const String meQuery = '''
  query Me {
    me {
      id
      firebaseUid
      email
      displayName
      reportCount
    }
  }
''';

const String myEventsQuery = '''
  query MyEvents {
    myEvents {
      id
      description
      startDate
      endDate
      likesCount
      dislikesCount
      region {
        name
      }
    }
  }
''';

const String discoverEventsQuery = '''
  query DiscoverEvents(\$limit: Float) {
    discoverEvents(limit: \$limit) {
      id
      description
      startDate
      imageUrl
      likesCount
      creator {
        displayName
      }
      region {
        name
      }
    }
  }
''';

const String discoverFiguresQuery = '''
  query DiscoverFigures(\$limit: Float) {
    discoverFigures(limit: \$limit) {
      id
      name
      description
      imageUrl
      likesCount
      creator {
        displayName
      }
    }
  }
''';

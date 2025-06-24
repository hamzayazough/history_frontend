# Historical Timeline Backend API

## GraphQL Schema Overview

This document provides a comprehensive overview of the GraphQL API for the Historical Timeline Backend.

## Core Types

### User

```graphql
type User {
  id: ID!
  firebaseUid: String!
  email: String
  displayName: String
  reportCount: Int!
  events: [Event!]!
  figures: [Figure!]!
  comments: [Comment!]!
  createdAt: DateTime!
  updatedAt: DateTime!
}
```

### Event

```graphql
type Event {
  id: ID!
  creatorUserId: String!
  regionId: String!
  startDate: DateTime!
  endDate: DateTime
  description: String!
  imageUrl: String
  sourceUrl: String
  likesCount: Int!
  dislikesCount: Int!
  creator: User!
  region: Region!
  comments: [Comment!]!
  createdAt: DateTime!
  updatedAt: DateTime!
}
```

### Figure

```graphql
type Figure {
  id: ID!
  creatorUserId: String!
  name: String!
  description: String!
  imageUrl: String
  sourceUrl: String
  likesCount: Int!
  dislikesCount: Int!
  creator: User!
  comments: [Comment!]!
  eventRelations: [EventFigureRelation!]!
  createdAt: DateTime!
  updatedAt: DateTime!
}
```

### Region

```graphql
type Region {
  id: ID!
  name: String!
  geoBoundary: JSON!
  events: [Event!]!
  createdAt: DateTime!
  updatedAt: DateTime!
}
```

### Comment

```graphql
type Comment {
  id: ID!
  userId: String!
  entityType: EntityType!
  entityId: String!
  text: String!
  user: User!
  createdAt: DateTime!
  updatedAt: DateTime!
}
```

## Enums

### EntityType

```graphql
enum EntityType {
  EVENT
  FIGURE
  USER
}
```

### ReportReason

```graphql
enum ReportReason {
  INAPPROPRIATE_CONTENT
  SPAM
  HARASSMENT
  FALSE_INFORMATION
  COPYRIGHT_VIOLATION
  OTHER
}
```

### DiscoverType

```graphql
enum DiscoverType {
  EVENT
  FIGURE
}
```

## Queries

### Public Queries (No Authentication Required)

#### Get All Regions

```graphql
query GetRegions {
  regions {
    id
    name
    geoBoundary
  }
}
```

#### Get Events with Filtering and Pagination

```graphql
query GetEvents($input: GetEventsInput!) {
  events(input: $input) {
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
```

#### Get Single Event

```graphql
query GetEvent($id: ID!) {
  event(id: $id) {
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
```

#### Get Figures with Pagination

```graphql
query GetFigures($limit: Int, $offset: Int) {
  figures(limit: $limit, offset: $offset) {
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
```

### Protected Queries (Authentication Required)

#### Get Current User Profile

```graphql
query Me {
  me {
    id
    firebaseUid
    email
    displayName
    reportCount
  }
}
```

#### Get User's Events

```graphql
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
```

#### Discovery Feed - Events

```graphql
query DiscoverEvents($limit: Float) {
  discoverEvents(limit: $limit) {
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
```

#### Discovery Feed - Figures

```graphql
query DiscoverFigures($limit: Float) {
  discoverFigures(limit: $limit) {
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
```

## Mutations

### Event Mutations

#### Create Event

```graphql
mutation CreateEvent($input: CreateEventInput!) {
  createEvent(input: $input) {
    id
    description
    startDate
    creator {
      displayName
    }
  }
}
```

#### Update Event

```graphql
mutation UpdateEvent($id: ID!, $input: UpdateEventInput!) {
  updateEvent(id: $id, input: $input) {
    id
    description
    startDate
    endDate
  }
}
```

#### Delete Event

```graphql
mutation DeleteEvent($id: ID!) {
  deleteEvent(id: $id)
}
```

### Figure Mutations

#### Create Figure

```graphql
mutation CreateFigure($input: CreateFigureInput!) {
  createFigure(input: $input) {
    id
    name
    description
    creator {
      displayName
    }
  }
}
```

### Comment Mutations

#### Add Comment

```graphql
mutation CreateComment($input: CreateCommentInput!) {
  createComment(input: $input) {
    id
    text
    user {
      displayName
    }
    createdAt
  }
}
```

### Like/Dislike Mutations

#### Toggle Like/Dislike

```graphql
mutation ToggleLike($input: LikeDislikeInput!) {
  toggleLikeDislike(input: $input) {
    id
    isLike
    entityType
    entityId
  }
}
```

### Report Mutations

#### Report Content or User

```graphql
mutation CreateReport($input: CreateReportInput!) {
  createReport(input: $input) {
    id
    reason
    description
    entityType
  }
}
```

### Upload Mutations

#### Upload Image

```graphql
mutation UploadImage($file: Upload!, $folder: String) {
  uploadImage(file: $file, folder: $folder)
}
```

### Discovery Mutations

#### Mark Content as Viewed

```graphql
mutation MarkAsViewed($entityType: EntityType!, $entityId: ID!) {
  markAsViewed(entityType: $entityType, entityId: $entityId)
}
```

## Input Types

### CreateEventInput

```graphql
input CreateEventInput {
  regionId: String!
  startDate: String!
  endDate: String
  description: String!
  imageUrl: String
  sourceUrl: String
}
```

### UpdateEventInput

```graphql
input UpdateEventInput {
  startDate: String
  endDate: String
  description: String
  imageUrl: String
  sourceUrl: String
}
```

### GetEventsInput

```graphql
input GetEventsInput {
  regionId: String
  limit: Int = 20
  offset: Int = 0
}
```

### LikeDislikeInput

```graphql
input LikeDislikeInput {
  entityType: EntityType!
  entityId: String!
  isLike: Boolean!
}
```

### CreateCommentInput

```graphql
input CreateCommentInput {
  entityType: EntityType!
  entityId: String!
  text: String!
}
```

### CreateReportInput

```graphql
input CreateReportInput {
  entityType: EntityType!
  entityId: String!
  reason: ReportReason!
  description: String!
}
```

## Resolvers and DTOs

### Comments Module

- **CreateCommentInput**: Input type for creating a comment. Fields:
  - `entityType`: The type of entity being commented on (e.g., Event, Figure).
  - `entityId`: The ID of the entity.
  - `text`: The content of the comment.

### Discover Module

- **DiscoverFeedInput**: Input type for fetching a discovery feed. Fields:
  - `type`: The type of discovery feed (e.g., Event, Figure).
  - `limit`: The maximum number of items to fetch (default: 10).

### Events Module

- **CreateEventInput**: Input type for creating an event. Fields:
  - `regionId`: The ID of the region where the event occurred.
  - `startDate`: The start date of the event.
  - `endDate`: The end date of the event (optional).
  - `description`: A detailed description of the event.
  - `imageUrl`: A URL to an image representing the event (optional).
  - `sourceUrl`: A URL to the source of the event information (optional).
  - `typeLabels`: Labels categorizing the event (optional).

### Figures Module

- **CreateFigureInput**: Input type for creating a figure. Fields:
  - `name`: The name of the historical figure.
  - `description`: A detailed description of the figure.
  - `imageUrl`: A URL to an image representing the figure (optional).
  - `sourceUrl`: A URL to the source of the figure information (optional).
  - `typeLabels`: Labels categorizing the figure (optional).

### Likes Module

- **LikeDislikeInput**: Input type for liking or disliking an entity. Fields:
  - `entityType`: The type of entity being liked or disliked (e.g., Event, Figure).
  - `entityId`: The ID of the entity.
  - `isLike`: A boolean indicating whether the action is a like or dislike.

### Reports Module

- **CreateReportInput**: Input type for creating a report. Fields:
  - `entityType`: The type of entity being reported (e.g., Event, Figure, User).
  - `entityId`: The ID of the entity.
  - `reason`: The reason for the report.
  - `description`: A detailed description of the report.

## Authentication

All protected mutations and queries require a valid Firebase JWT token in the Authorization header:

```
Authorization: Bearer <firebase-jwt-token>
```

The token will be validated and the user context will be available in resolvers.

## Error Handling

The API returns structured errors with the following format:

```json
{
  "errors": [
    {
      "message": "Error description",
      "code": "ERROR_CODE",
      "path": ["fieldName"]
    }
  ]
}
```

Common error codes:

- `UNAUTHORIZED`: Invalid or missing authentication
- `FORBIDDEN`: Insufficient permissions
- `NOT_FOUND`: Resource not found
- `BAD_REQUEST`: Invalid input data
- `INTERNAL_ERROR`: Server error

## Rate Limiting

The API implements GraphQL complexity analysis to prevent expensive queries. Complex nested queries may be rejected to maintain performance.

## Pagination

List queries support cursor-based pagination with the following pattern:

```graphql
type PaginationInfo {
  totalCount: Int!
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
}
```

## File Uploads

File uploads use the GraphQL multipart request specification. Files are uploaded to S3 and the URL is returned.

Supported formats:

- Images: JPEG, PNG, WebP
- Maximum size: 5MB

## Development Tools

### GraphQL Playground

Available at `http://localhost:3000/graphql` in development mode.

### Schema Introspection

Enabled in all environments for development and documentation purposes.

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:history_timeline/core/constants/app_constants.dart';

class GraphQLService {
  static GraphQLClient? _client;

  static GraphQLClient get client {
    if (_client == null) {
      throw Exception(
          'GraphQL client not initialized. Call initialize() first.');
    }
    return _client!;
  }

  static Future<void> initialize() async {
    final HttpLink httpLink = HttpLink(AppConstants.graphqlEndpoint);
    final AuthLink authLink = AuthLink(
      getToken: () async {
        final User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final String? token = await user.getIdToken();
          return token != null ? 'Bearer $token' : '';
        }
        return '';
      },
    );

    final Link link = authLink.concat(httpLink);

    _client = GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: link,
    );
  }

  static void dispose() {
    _client = null;
  }

  static Future<QueryResult> query(
    String query, {
    Map<String, dynamic>? variables,
    FetchPolicy? fetchPolicy,
  }) async {
    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: variables ?? {},
      fetchPolicy: fetchPolicy ?? FetchPolicy.cacheAndNetwork,
    );

    return await client.query(options);
  }

  static Future<QueryResult> mutate(
    String mutation, {
    Map<String, dynamic>? variables,
  }) async {
    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: variables ?? {},
    );

    return await client.mutate(options);
  }

  static Stream<QueryResult> subscribe(
    String subscription, {
    Map<String, dynamic>? variables,
  }) {
    final SubscriptionOptions options = SubscriptionOptions(
      document: gql(subscription),
      variables: variables ?? {},
    );

    return client.subscribe(options);
  }
}

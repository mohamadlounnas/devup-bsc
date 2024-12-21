import 'package:app/main.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey;
  late final GenerativeModel _model;
  late ChatSession _chat;
  Map<String, dynamic> _userData = {};

  GeminiService({required this.apiKey}) {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    _initChat();
  }

  Future<void> _fetchUserData() async {
    try {
      final userHistoryData = await pb.collection('hostels').getFullList();
      final userEventsData =
          await pb.collection('facilities_events').getFullList();
      final userFacilityHistory =
          await pb.collection('facilities').getFullList();
      final reservationsHistory = await pb
          .collection('hostels_reservations')
          .getFullList(filter: 'user = "${pb.authStore.model?.id}"');

      _userData = {
        'currentUser': pb.authStore.model,
        'reservations': reservationsHistory,
        'hostels': userHistoryData,
        'events': userEventsData,
        'facilities': userFacilityHistory,
      };
    } catch (e) {
      print('Error fetching user data: $e');
      _userData = {};
    }
  }

  void _initChat() {
    _chat = _model.startChat(
      history: [
        Content(
          'user',
          [
            TextPart(
                '''You are a knowledgeable travel assistant for Boumerdes, Algeria. 
            Your responses should be based on the actual user data that will be provided in each message.
            Focus on:
            1. Personalized recommendations based on user's reservation history
            2. Relevant events and facilities based on user's interests
            3. Local attractions and points of interest
            4. Available accommodation options
            5. Cultural insights and customs'''),
          ],
        ),
      ],
    );
  }

  Future<String> getTravelSuggestions(String message) async {
    try {
      // Fetch fresh user data before each response
      await _fetchUserData();

      // Create a context-rich message with user data
      final contextMessage = '''
      Using the following real user data:
      Current User: ${_userData['currentUser']}
      Reservations: ${_userData['reservations']}
      Available Hostels: ${_userData['hostels']}
      Current Events: ${_userData['events']}
      Available Facilities: ${_userData['facilities']}

      User Question: $message
      ''';

      final response = await _chat.sendMessage(
        Content('user', [TextPart(contextMessage)]),
      );

      final reply = response.text;
      if (reply == null) {
        throw Exception('No response from Gemini');
      }

      return reply;
    } catch (e) {
      return 'Sorry, I encountered an error: $e';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:streamed_mobile/data/datasources/match_datasource.dart';
import 'package:streamed_mobile/data/models/match_model.dart';
import 'package:streamed_mobile/presentation/stream/stream_screen.dart';

class HomeViewmodel extends ChangeNotifier {
  final MatchDatasource matchDatasource = MatchDatasource();


  List<MatchModel> matches = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> NavigateToStreamScreen(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const StreamScreen()));
  }

  Future<void> fetchMatches() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      matches = await matchDatasource.fetchAllMatches();
    } catch (e) {
      print('Error fetching matches: $e');
      print('Fetched ${matches.length} matches');
      errorMessage = 'Error fetching matches. Please try again later.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
}
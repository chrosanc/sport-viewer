import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamed_mobile/app/theme/text_theme.dart';
import 'package:streamed_mobile/presentation/home/home_viewmodel.dart';
import 'package:streamed_mobile/presentation/home/widget/streamcard_widget.dart';
import 'package:streamed_mobile/presentation/stream/stream_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch matches after the first frame
    Future.microtask(
      () => Provider.of<HomeViewmodel>(context, listen: false).fetchMatches(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final streamViewmodel = Provider.of<StreamViewmodel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Streamed')),
      body: Consumer<HomeViewmodel>(
        builder: (context, viewmodel, child) {
          if (viewmodel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewmodel.errorMessage.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: viewmodel.fetchMatches,
              child: Center(child: Text(viewmodel.errorMessage)),
            );
          }

          return RefreshIndicator(
            onRefresh: viewmodel.fetchMatches,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Live Matches',
                    style: AppTextTheme.darkTextTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 6,
                          ),
                      itemCount: viewmodel.matches.length,
                      itemBuilder: (context, index) {
                        final item = viewmodel.matches[index];

                        return StreamcardWidget(
                          title: item.title,
                          description: item.category,
                          posterUrl: item.poster ?? '',
                          onTap: () async {
                            streamViewmodel.setSelectedMatch(item);
                            viewmodel.NavigateToStreamScreen(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

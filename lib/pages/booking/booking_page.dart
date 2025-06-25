import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/auth/data/app_user.dart';
import '../../modules/auth/views/authentication/authentication_bloc.dart';
import '../../modules/cities/views/city_pool/select_city_button.dart';
import '../../modules/meeting_rooms/views/filter_result/filter_result_listview.dart';
import '../../modules/meeting_rooms/views/map/map_widget.dart';
import '../../modules/meeting_rooms/views/room_filter/filter_room_panel.dart';
import 'booking_page_dependencies.dart';
import 'booking_page_listeners.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  static const _minHeight = 0.15;

  final _sheetController = DraggableScrollableController();
  final _innerScrollController = ScrollController();
  final _sheetControllerStream = StreamController<double>.broadcast();

  ScrollPhysics? _scrollPhysics;

  @override
  void initState() {
    super.initState();

    _sheetController.addListener(() {
      _sheetControllerStream.add(_sheetController.size);
      if (_sheetController.size < 1) return;

      setState(() => _scrollPhysics = const NeverScrollableScrollPhysics());
    });
  }

  @override
  void dispose() {
    _sheetControllerStream.close();
    _sheetController.dispose();
    _innerScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final user = context.select((AuthenticationBloc b) => b.state.user);

    final isGuest = switch (user) {
      null || GuestUser() => true,
      NormalUser() => false,
    };

    return BookingPageDependencies(
      builder: (context) => BookingPageListeners(
        builder: (context) => StreamBuilder(
          stream: _sheetControllerStream.stream,
          builder: (context, asyncSnapshot) {
            final sheetSize = asyncSnapshot.data ?? _minHeight;
            final isSheetExpanded = sheetSize >= 1;

            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                leading: const Icon(Icons.chevron_left_rounded),
                title: const SelectCityButton(),
                actions: [
                  IconButton(
                    onPressed: () => _onViewModeToggled(isSheetExpanded),
                    icon: isSheetExpanded
                        ? const Icon(Icons.map_outlined)
                        : const Icon(Icons.menu_outlined),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48),
                  child: SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          [
                                ('Meeting Room', isGuest),
                                ('Coworking', !isGuest),
                                ('Day Office', !isGuest),
                                ('Event Space', !isGuest),
                              ]
                              .map(
                                (e) => InkWell(
                                  onTap: e.$2 ? () {} : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        e.$1,
                                        style: TextStyle(
                                          color: e.$2
                                              ? colorScheme.primary
                                              : colorScheme.outlineVariant,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ),
              body: Stack(
                children: [
                  const Positioned.fill(child: MapWidget()),
                  DraggableScrollableSheet(
                    initialChildSize: _minHeight,
                    minChildSize: _minHeight,
                    snap: true,
                    snapSizes: const [_minHeight, 0.7, 1],
                    controller: _sheetController,
                    builder: (context, scrollController) => ColoredBox(
                      color: Theme.of(context).colorScheme.surface,
                      child: CustomScrollView(
                        controller: scrollController,
                        physics: _scrollPhysics,
                        slivers: [
                          if (!isSheetExpanded)
                            const SliverToBoxAdapter(
                              child: Divider(
                                height: 24,
                                thickness: 2,
                                indent: 100,
                                endIndent: 100,
                              ),
                            ),

                          const SliverToBoxAdapter(child: FilterRoomPanel()),

                          const SliverFillRemaining(
                            child: Scaffold(body: FilterResultListView()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _onViewModeToggled(bool isSheetExpanded) async {
    if (isSheetExpanded) {
      await _sheetController.animateTo(
        _minHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      setState(() => _scrollPhysics = null);
    } else {
      _sheetController.animateTo(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

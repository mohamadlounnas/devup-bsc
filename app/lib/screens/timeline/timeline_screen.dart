import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/timeline_logic.dart';
import '../../logic/data/timeline_data.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final ScrollController _scrollController = ScrollController();
  final _currentYear = ValueNotifier<int>(2023);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _currentYear.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final timelineLogic = context.read<TimelineLogic>();
    // Calculate current year based on scroll position
    final scrollFraction = _scrollController.position.pixels / _scrollController.position.maxScrollExtent;
    final yearRange = timelineLogic.events.last.year - timelineLogic.events.first.year;
    final currentYear = timelineLogic.events.first.year + (yearRange * scrollFraction).round();
    _currentYear.value = currentYear;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timelineLogic = context.watch<TimelineLogic>();

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary.withOpacity(0.1),
                  colorScheme.secondary.withOpacity(0.1),
                ],
              ),
            ),
          ),

          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App bar
              SliverAppBar(
                floating: true,
                title: const Text('University Timeline'),
                centerTitle: true,
                backgroundColor: colorScheme.surface.withOpacity(0.8),
              ),

              // Era label
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ValueListenableBuilder<int>(
                    valueListenable: _currentYear,
                    builder: (context, year, _) {
                      return Text(
                        timelineLogic.getEraText(year),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
              ),

              // Timeline events
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final event = timelineLogic.events[index];
                    return _TimelineEventCard(
                      event: event,
                      isFirst: index == 0,
                      isLast: index == timelineLogic.events.length - 1,
                    );
                  },
                  childCount: timelineLogic.events.length,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 100), // Bottom padding
              ),
            ],
          ),

          // Bottom timeline scrubber
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: colorScheme.surface.withOpacity(0.8),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _TimelineScrubber(
                          startYear: timelineLogic.events.first.year,
                          endYear: timelineLogic.events.last.year,
                          currentYear: _currentYear.value,
                          onYearChanged: (year) {
                            final yearRange = timelineLogic.events.last.year - timelineLogic.events.first.year;
                            final scrollFraction = (year - timelineLogic.events.first.year) / yearRange;
                            _scrollController.jumpTo(
                              scrollFraction * _scrollController.position.maxScrollExtent,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEventCard extends StatelessWidget {
  final TimelineEvent event;
  final bool isFirst;
  final bool isLast;

  const _TimelineEventCard({
    required this.event,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Timeline line and dot
            SizedBox(
              width: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Vertical line
                  if (!isFirst || !isLast)
                    Positioned(
                      top: isFirst ? 40 : 0,
                      bottom: isLast ? 40 : 0,
                      child: Container(
                        width: 2,
                        color: colorScheme.primary.withOpacity(0.5),
                      ),
                    ),
                  // Event dot
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Event content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 0,
                  color: colorScheme.surface.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Year and icon
                        Row(
                          children: [
                            Text(
                              event.year.toString(),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            if (event.icon != null)
                              Icon(
                                event.icon,
                                color: colorScheme.primary,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Title
                        Text(
                          event.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Description
                        Text(
                          event.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineScrubber extends StatelessWidget {
  final int startYear;
  final int endYear;
  final int currentYear;
  final ValueChanged<int> onYearChanged;

  const _TimelineScrubber({
    required this.startYear,
    required this.endYear,
    required this.currentYear,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Selected year display
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            currentYear.toString(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Year slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: colorScheme.primary,
              inactiveTrackColor: colorScheme.primary.withOpacity(0.2),
              thumbColor: colorScheme.primary,
              overlayColor: colorScheme.primary.withOpacity(0.1),
              trackHeight: 4.0,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 8.0,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 16.0,
              ),
            ),
            child: Slider(
              min: startYear.toDouble(),
              max: endYear.toDouble(),
              value: currentYear.toDouble(),
              onChanged: (value) => onYearChanged(value.round()),
            ),
          ),
        ),

        // Year markers
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                startYear.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              Text(
                endYear.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
} 
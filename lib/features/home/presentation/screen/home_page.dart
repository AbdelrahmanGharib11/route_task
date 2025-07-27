import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:selfdep/core/cache/custom_cache_manager.dart';
import 'package:selfdep/core/di/service_locator.dart';
import 'package:selfdep/core/widgets/show_connectivity.dart';
import 'package:selfdep/core/widgets/toggleswitcher.dart' hide Theme;
import 'package:selfdep/features/home/domain/entities/photo_entity.dart';
import 'package:selfdep/features/home/presentation/cubit/photo_cubit.dart';
import 'package:selfdep/features/home/presentation/cubit/photo_states.dart';
import 'package:selfdep/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PhotoCubit>()..initializePhotos(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final connectivityResult = await Connectivity().checkConnectivity();
      final isConnected =
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile);

      if (isConnected) {
        context.read<PhotoCubit>().loadMorePhotos();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PhotoCubit, PhotoState>(
        builder: (context, state) {
          if (state is PhotoLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppTheme.babyblue),
            );
          }

          if (state is PhotoError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<PhotoCubit>().refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PhotoErrorWithCache) {
            final photos = state.photos;

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  color: Colors.orange[100],
                  child: Row(
                    children: [
                      Icon(Icons.wifi_off, color: Colors.orange[700]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Showing cached photos. ${state.message}',
                          style: TextStyle(color: Colors.orange[700]),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.read<PhotoCubit>().refresh(),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<PhotoCubit>().refresh();
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                            left: 8,
                            right: 8,
                          ),
                          sliver: SliverToBoxAdapter(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Image.asset(
                                    'assets/image/route.png',
                                    height: 45,
                                    width: 135,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    children: [
                                      ToggleSwitcher(),
                                      SizedBox(height: 8),
                                      ShowConnectivity(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SliverToBoxAdapter(
                        //   child: CacheDebugWidget(),
                        // ),
                        SliverPadding(
                          padding: const EdgeInsets.all(8.0),
                          sliver: SliverMasonryGrid.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            childCount: photos.length,
                            itemBuilder: (context, index) {
                              return PhotoCard(photo: photos[index]);
                            },
                          ),
                        ),
                        if (state is PhotoLoadingMore)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.babyblue,
                                  strokeWidth: 4,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          if (state is PhotoLoaded || state is PhotoLoadingMore) {
            final photos = state is PhotoLoaded
                ? state.photos
                : (state as PhotoLoadingMore).photos;

            if (photos.isEmpty) {
              return Center(
                child: Text(
                  'No photos found',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<PhotoCubit>().refresh();
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 8,
                      right: 8,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/image/route.png',
                              height: 45,
                              width: 135,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                ToggleSwitcher(),
                                SizedBox(height: 8),
                                ShowConnectivity(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SliverToBoxAdapter(
                  //   child: CacheDebugWidget(),
                  // ),
                  SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childCount: photos.length,
                      itemBuilder: (context, index) {
                        return PhotoCard(photo: photos[index]);
                      },
                    ),
                  ),
                  if (state is PhotoLoadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.babyblue,
                            strokeWidth: 4,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          return const Center(child: Text('Welcome! Photos will load here.'));
        },
      ),
    );
  }
}

class PhotoCard extends StatelessWidget {
  final PhotoEntity photo;

  const PhotoCard({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/photo', arguments: photo),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: photo.src.medium,
              cacheManager: CustomCacheManager(),
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                direction: ShimmerDirection.ttb,
                baseColor: Colors.grey[400]!,
                highlightColor: Colors.grey[300]!,
                child: Container(height: 200, color: Colors.white),
              ),
              errorWidget: (context, url, error) => Container(
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         photo.alt.isNotEmpty ? photo.alt : 'Untitled',
            //         style: Theme.of(context).textTheme.bodyMedium,
            //         maxLines: 2,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //       const SizedBox(height: 4),
            //       Text(
            //         'by ${photo.photographer}',
            //         style: Theme.of(
            //           context,
            //         ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            //       ),
            //     ],
            //   ),
            //),
          ],
        ),
      ),
    );
  }
}

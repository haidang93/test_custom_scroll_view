part of 'project.library.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double get paddingTop => MediaQuery.paddingOf(context).top;
  double get paddingBottom => MediaQuery.paddingOf(context).bottom;
  double get screenWidth => MediaQuery.sizeOf(context).width;
  double get screenHeight => MediaQuery.sizeOf(context).height;

  final scrollController = ScrollController();
  late TabController tabController;
  final search = TextEditingController();
  List<Data> data = [];
  bool isListEnd = false;
  int page = 1;
  int limit = 100;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    refresh();
  }

  Future refresh() async {
    page = 1;
    data = [];
    await getData();
  }

  Future getData() async {
    final res = await simulateCallApi(page: page, limit: limit);
    setState(() {
      isListEnd = res.length < limit;
      data.addAll(res);
    });
    page++;
  }

  void loadMore(int index) {
    if (!isListEnd && (index == data.length - limit)) {
      getData();
      log('load more page: $page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // remove textfield focus (dismiss keyboard)
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color.fromARGB(255, 217, 224, 228),
        body: RefreshIndicator(
          notificationPredicate: (notification) {
            if (notification is OverscrollNotification || Platform.isIOS) {
              return notification.depth == 2;
            }
            return notification.depth == 0;
          },
          onRefresh: refresh,
          child: ExtendedNestedScrollView(
            onlyOneScrollInBody: true,
            controller: scrollController,
            headerSliverBuilder: (context, extanded) => [
              SliverOverlapAbsorber(
                handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                    context),
                sliver: SliverAppBar(
                  toolbarHeight: 5,
                  pinned: true,
                  elevation: 0,
                  expandedHeight: TEXTFIELD_HEIGHT +
                      (screenWidth / BANNER_ASPECTRATIO) +
                      (TEXTFIELD_VERTICLE_MARGIN * 2) +
                      TABBAR_HEIGHT,
                  scrolledUnderElevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: appBar(),
                  ),
                  bottom: tabbar(),
                ),
              ),
            ],
            body: TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [about(), menu()],
            ),
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: TABBAR_HEIGHT,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextField(controller: search),
          Banner(),
        ],
      ),
    );
  }

  PreferredSize tabbar() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, TABBAR_HEIGHT),
      child: TabBar(
        controller: tabController,
        unselectedLabelColor: Colors.black26,
        automaticIndicatorColorAdjustment: false,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.only(bottom: 1),
        indicator: ShapeDecoration(
          shape: Border(
            bottom: BorderSide(
              width: 1.5,
            ),
          ),
        ),
        tabs: [
          Tab(
            child: Text("About"),
          ),
          Tab(
            child: Text("Menu"),
          ),
        ],
      ),
    );
  }

  Widget about() {
    /// The Builder is used here to obtain the context
    /// from its parent and pass to the CustomScrollView
    return Builder(builder: (context) {
      return CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                context),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  "Description:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(8),
                  child: Text(
                    STARBUCKS_DESCRIPTION,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ]),
            ),
          ),
        ],
      );
    });
  }

  Widget menu() {
    /// The Builder is used here to obtain the context
    /// from its parent and pass to the CustomScrollView
    return Builder(builder: (context) {
      return CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                context),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: paddingBottom + 10,
            ),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 10,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                loadMore(index);
                return MenuCard(
                  key: ObjectKey(data[index].id),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

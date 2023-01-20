import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:financial_mobile_app/models/hits_page.dart';
import 'package:financial_mobile_app/models/search_metadata.dart';
import 'package:financial_mobile_app/models/stock.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InstrumentSearch extends StatefulWidget {
  const InstrumentSearch({Key? key}) : super(key: key);

  @override
  State<InstrumentSearch> createState() => _InstrumentSearchState();
}

class _InstrumentSearchState extends State<InstrumentSearch> {
  final _stocksSearcher = HitsSearcher(
      applicationID: 'M1AUX10BAL',
      apiKey: 'a00f96473be8e51ae78646bbc37d799e',
      indexName: 'dev_demo');
  final _searchTextController = TextEditingController();

  final PagingController<int, Stock> _pagingController =
      PagingController(firstPageKey: 0);

  Stream<SearchMetadata> get _searchMetadata =>
      _stocksSearcher.responses.map(SearchMetadata.fromResponse);

  Stream<HitsPage> get _searchPage =>
      _stocksSearcher.responses.map(HitsPage.fromResponse);

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(
      () => _stocksSearcher.applyState(
        (state) => state.copyWith(
          query: _searchTextController.text,
          page: 0,
        ),
      ),
    );
    _searchPage.listen((page) {
      if (page.pageKey == 0) {
        _pagingController.refresh();
      }
      _pagingController.appendPage(page.items, page.nextPageKey);
    }).onError((error) => _pagingController.error = error);
    _pagingController.addPageRequestListener((pageKey) =>
        _stocksSearcher.applyState((state) => state.copyWith(page: pageKey)));
  }

  Widget _hits(BuildContext context) => PagedListView<int, Stock>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Stock>(
          noItemsFoundIndicatorBuilder: (_) => const Center(
            child: Text('No results found'),
          ),
          itemBuilder: (_, item, __) {
            if (_searchTextController.text.isNotEmpty) {
              return Container(
                color: Colors.white,
                height: 80,
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {
                    context.push("/details/${item.ticker}");
                  },
                  child: Ink(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(item.name),
                        SizedBox(
                          width: 20,
                        ),
                        Text(item.ticker, style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Financial Mobile App"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 20.0),
              child: Row(
                children: <Widget>[
                  const Text(
                    "Search",
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 44,
              child: TextField(
                controller: _searchTextController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter ticker/common name',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            StreamBuilder<SearchMetadata>(
              stream: _searchMetadata,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                if (_searchTextController.text.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${snapshot.data!.nbHits} hits'),
                  );
                } else {
                  return Container();
                }
              },
            ),
            Expanded(
              child: _hits(context),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arrivo/features/posts/bloc/posts_bloc.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final PostsBloc postsBloc = PostsBloc();
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    postsBloc.add(PostsInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<PostsBloc, PostsState>(
          bloc: postsBloc,
          listenWhen: (previous, current) => current is PostsActionState,
          buildWhen: (previous, current) => current is! PostsActionState,
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.runtimeType) {
              case PostsFetchingLoadingState:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case PostFetchingSuccessfulState:
                final successState = state as PostFetchingSuccessfulState;
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: PaginatedDataTable2(
                    source: RowSource(
                      myData: successState.posts,
                      count: successState.posts.length,
                    ),
                    rowsPerPage: _rowsPerPage,
                    onRowsPerPageChanged: (value) {
                      _rowsPerPage = value!;
                    },
                    availableRowsPerPage:const [5,10,15,20,25],
                    headingRowColor: MaterialStateProperty.all<Color>(Colors.grey.shade200),
                    headingRowHeight: 40.0,
                    columnSpacing: 8,
                    columns: const [
                      DataColumn(
                        label: Text(
                          "Id",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "User Id",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Title",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Body",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              default:
                return const SizedBox();
            }
          },
        ));
  }
}

class RowSource extends DataTableSource {
  var myData;
  final count;
  RowSource({
    required this.myData,
    required this.count,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(myData![index]);
    } else
      return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(var data) {
  return DataRow(
    cells: [
      DataCell(Text(data.id.toString())),
      DataCell(Text(data.userId.toString())),
      DataCell(Text(data.title)),
      DataCell(Text(data.body)),
    ],
  );
}

import 'package:bookz/Screens/books_repo_screen.dart';
import 'package:bookz/Screens/login_screen.dart';
import 'package:bookz/Screens/read_book.dart';
import 'package:bookz/services/database.dart';
import 'package:bookz/widgets/book_card.dart';
import 'package:bookz/widgets/custom_text_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Database db;
  bool isLoading = true;
  List userBooks = [];
  List userBooksURL = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void dispose() {
    // TODO: implement dispose
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    userBooks = await db.readFromUser();
    userBooksURL = await db.Userbooks['URLs'];
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  initialize() async {
    db = Database();
    await db.initialize();
    userBooks = await db.readFromUser();
    userBooksURL = await db.Userbooks['URLs'];
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  _showDialog("Are you sure?", "Logging out of the application",
                      context);
                },
                icon: Icon(Icons.logout))
          ],
          centerTitle: true,
          title: Text(
            "Welcome to BookZ",
            style: GoogleFonts.lobster(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Color.fromRGBO(237, 128, 38, 1),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              CustomText(
                text: "Home",
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(116, 169, 56, 0.7),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(179, 179, 179, 1),
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = Text("pull up load");
                      } else if (mode == LoadStatus.loading) {
                        body = CircularProgressIndicator();
                      } else if (mode == LoadStatus.failed) {
                        body = Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = Text("release to load more");
                      } else {
                        body = Text("No more Data");
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: GridView.builder(
                    padding: EdgeInsets.all(10.0),
                    shrinkWrap: true,
                    itemCount: userBooks.length + 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return books(index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget books(int index) {
    if (index == 0) {
      return roundedRectBorderWidget(context);
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReadBook(
                bookName: userBooks[index - 1], url: userBooksURL[index - 1])));
      },
      child: BookCard(
        name: userBooks[index - 1],
      ),
    );
  }

  Widget roundedRectBorderWidget(BuildContext context) {
    return DottedBorder(
      color: Color.fromRGBO(237, 128, 38, 1),
      dashPattern: const [10, 10, 0, 3],
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: InkWell(
          onTap: () {
            print(userBooks);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => BooksRepo()));
          },
          splashColor: Colors.grey,
          child: Ink(
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_circle_outline,
                  color: Color.fromRGBO(237, 128, 38, 1),
                ),
                Center(
                  child: CustomText(
                    text: "Buy a book",
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDialog(title, text, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: CustomText(
              text: title,
            ),
            content: CustomText(
              text: text,
              fontSize: 18,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen())),
                child: CustomText(text: "Logout"),
              )
            ],
          );
        });
  }
}

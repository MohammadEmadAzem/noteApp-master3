import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/note_model.dart';
import '../repository/sql_helper.dart';
import 'show_note_view.dart';


class PageOne extends StatefulWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {


  SqlHelper sqlHelper = SqlHelper();

  List<NoteModel> allNotes = [];


  @override
  void didChangeDependencies() async {
    allNotes = await sqlHelper.getAllNotes();
    setState(() {
      // ignore: avoid_print
      print(allNotes);
    });
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/addNote');
        },
        child: const Icon(Icons.add,),
      ),
      appBar: AppBar(
        title: const Text('Notes',style: TextStyle(fontSize: 30,),),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(),);
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xff232420),
      body: Column(
        children: [
           Container(
             margin: const EdgeInsets.all(10),
             padding: const EdgeInsets.symmetric(horizontal: 20),
             decoration: BoxDecoration(
               color: Colors.grey[300],
               borderRadius: BorderRadius.circular(30),
             ),
      child: TextField(
               cursorColor: Colors.greenAccent,
              decoration: const InputDecoration(
              icon: Icon(Icons.search),
                iconColor: Colors.grey,
    hintText: 'Search',
                 hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,

               ),
             ),
           ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: allNotes.isEmpty ?
              Center(
                child: SvgPicture.asset(
                  'images/undraw_add_notes_re_ln36.svg',
                  height: 300,
                  width: 300,
                ),
              )
                  :

              ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: allNotes.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShowNoteView(note: allNotes[index],)));
                      },
                      child: Dismissible(
                        key: Key(allNotes[index].id.toString()),
                        onDismissed: (direction) async {
                          await sqlHelper.deleteData(allNotes[index]);
                          setState(() {
                            allNotes.removeAt(index);
                          });
                        },
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Icon(Icons.delete,color: Colors.white,),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(Icons.delete,color: Colors.white,),
                              ),
                            ],
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: allNotes[index].color == 1 ? Colors.orangeAccent : allNotes[index].color == 2 ? Colors.deepPurpleAccent : allNotes[index].color == 3 ? Colors.pinkAccent : Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 3.0,
                                spreadRadius: 1.0,
                                offset: Offset(2.0, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  allNotes[index].title!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(allNotes[index].note!.replaceAll('\n', '').length > 50 ? '${allNotes[index].note!.replaceAll('\n', '').substring(0, 50)}...' : allNotes[index].note!.replaceAll('\n', ''),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),),
                              ),
                              Text(
                                allNotes[index].date!,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 12,
                                ),
                              ),

                            ],
                          ),


                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],

      ),
    );
  }
}


class DataSearch extends SearchDelegate{


  SqlHelper sqlHelper = SqlHelper();
  List<NoteModel> allNotes = [];

  DataSearch(){
    sqlHelper.getAllNotes().then((value) {
      allNotes = value;
    });
  }


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    List filteredNames = allNotes.where((element) => element.title!.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: query.isEmpty ? allNotes.length : filteredNames.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: allNotes[index].color == 1 ? Colors.orangeAccent : allNotes[index].color == 2 ? Colors.deepPurpleAccent : allNotes[index].color == 3 ? Colors.pinkAccent : Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 3.0,
                spreadRadius: 1.0,
                offset: Offset(2.0, 2.0), // shadow direction: bottom right
              )
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  allNotes[index].title!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(allNotes[index].note!.replaceAll('\n', '').length > 50 ? '${allNotes[index].note!.replaceAll('\n', '').substring(0, 50)}...' : allNotes[index].note!.replaceAll('\n', ''),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),),
              ),
              Text(
                allNotes[index].date!,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),

            ],
          ),
        );
      },
    );
  }

}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_recipe_app/recipe_model.dart';
import 'package:food_recipe_app/recipeview.dart';
import 'package:http/http.dart';

class Search extends StatefulWidget {
  late String item;

  Search(this.item);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isloading = true;
  TextEditingController searchController = TextEditingController();
  List<RecipeModel> Recipelist = <RecipeModel>[];

  getRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=c598798e&app_key=2cdafc89faf2ecf1224c883140eaf91d";
    var response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    data["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      Recipelist.add(recipeModel);
    });
    setState(() {
      isloading = false;
    });
    print(Recipelist);

    Recipelist.forEach((Recipe) {
      print(Recipe.appLabel);
      print(Recipe.appcalories);
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipe(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff213A50),
                Color(0xff071938),
              ]),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      margin:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if ((searchController.text).replaceAll(" ", "") ==
                                  "") {
                                print("Blank search");
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Search(searchController.text),
                                  ),
                                );
                              }
                            },
                            child: Container(
                             
                              child: Icon(
                                Icons.search,
                                color: Colors.blueAccent,
                              ),
                              margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Let's cook Something",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: isloading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: Recipelist.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecipeView(Recipelist[index].appurl),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: EdgeInsets.all(10),
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          Recipelist[index].appimgurl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 200,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black26,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 10,
                                          ),
                                          child: Text(
                                            Recipelist[index].appLabel,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        height: 40,
                                        width: 100,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                              )),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons
                                                    .local_fire_department),
                                                Text(
                                                  Recipelist[index]
                                                      .appcalories
                                                      .toString()
                                                      .substring(0, 6),
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

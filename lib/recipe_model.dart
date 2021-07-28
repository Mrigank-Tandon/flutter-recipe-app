class RecipeModel {
  late String appLabel;
  late String appimgurl;
  late double appcalories;
  late String appurl;

  RecipeModel(
      {this.appLabel = "Label",
      this.appimgurl = "imgurl",
      this.appcalories = 0.00,
      this.appurl = "appurl"});

  factory RecipeModel.fromMap(Map recipe) {
    return RecipeModel(
      appLabel: recipe["label"],
      appimgurl: recipe["image"],
      appcalories: recipe["calories"],
      appurl: recipe["url"],
    );
  }
}

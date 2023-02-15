import 'package:flutter/material.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final navigation = Navigator.of(context);
    return Card(
      elevation: 3,
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName, arguments: id);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  )),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text('Are you sure?'),
                            content: Text('Do you want to delete this item?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('No')),
                              TextButton(
                                  onPressed: () async {
                                    // REASON FOR USING navigation and scaffold variables is of(context) doesnt work properly inside a Function wrapped by a future.
                                    try {
                                      await Provider.of<Products>(context,
                                              listen: false)
                                          .deleteProduct(id);
                                      navigation.pop();
                                    } catch (error) {
                                      navigation.pop();
                                      scaffold.showSnackBar(SnackBar(
                                          content: Text(
                                        error.toString(),
                                        textAlign: TextAlign.center,
                                      )));
                                    }
                                  },
                                  child: Text('Yes')),
                            ],
                          );
                        });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

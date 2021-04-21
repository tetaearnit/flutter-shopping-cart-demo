import 'package:flutter/material.dart';
import 'package:flutter_app/src/config/app_route.dart';
import 'package:flutter_app/src/constants/api.dart';
import 'package:flutter_app/src/constants/app_setting.dart';
import 'package:flutter_app/src/constants/asset.dart';
import 'package:flutter_app/src/model/product_response.dart';
import 'package:flutter_app/src/pages/login/background_theme.dart';
import 'package:flutter_app/src/services/network.dart';
import 'package:flutter_app/src/view_model/menu_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  // HomePage({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: CommonDrawer(),
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(
      //         'Singh Counter:',
      //       ),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headline4,
      //       ),
      //     ],
      //   ),
      // ),
      // body: GridView.builder(
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 2, childAspectRatio: 0.8),
      //   itemBuilder: (context, index) => LayoutBuilder(
      //       builder: (context, constraint) => ShopListItem(
      //             constraint.maxHeight,
      //             press: () {
      //               // todo
      //             },
      //           )),
      //   itemCount: 100,
      // ),
      body: FutureBuilder<List<ProductResponse>>(
        future: NetworkService().productAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final productList = snapshot.data;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4),
              itemBuilder: (context, index) => LayoutBuilder(
                  builder: (context, constraint) => ShopListItem(
                    constraint.maxHeight,
                    productList[index],
                    press: () async {
                      await Navigator.pushNamed(
                        context,
                        AppRoute.managementRoute,
                        arguments: productList[index], // send a data to new page
                      );
                      setState(() {

                      });
                    },
                  )),
              itemCount: productList.length,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoute.managementRoute);
          setState(() {
            // เสร็จแล้ว ให้ refresh หน้าใหม่
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Singh'),
            accountEmail: Text('Singh@gmail.com'),
            currentAccountPicture: CircleAvatar(
              // เรียกจาก assets
              // backgroundImage: AssetImage(
              //   'assets/images/cdgs_logo.png'
              // ),
              // เรียกจาก network
              backgroundImage: NetworkImage(
                  'https://c.files.bbci.co.uk/12A9B/production/_111434467_gettyimages-1143489763.jpg'),
            ),
            decoration: BoxDecoration(gradient: BackGroundTheme.gradient),
          ),
          ...MenuViewModel()
              .items
              .map((item) => ListTile(
            onTap: () {
              item.onTap(context);
            },
            leading: Icon(
              item.icon,
              color: item.iconColor,
            ),
            title: Text(item.title),
          ))
              .toList(),
          Spacer(), // การดันไปล้างสุด หรือบนสุด
          ListTile(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove(AppSetting.tokenSetting);
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoute.loginRoute, (route) => false);
            },
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
          )
        ],
      ),
    );
  }
}

class ShopListItem extends StatelessWidget {
  final Function press;
  final double maxHeight;
  final ProductResponse product;

  const ShopListItem(this.maxHeight, this.product, {Key key, this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // GestureDetector ใช้ในกรนี้ที่ function นั้นกดไม่ได้ให้เอาตัวนี้ไปครอบ
    return GestureDetector(
      onTap: press,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            _buildImage(),
            Expanded(
              child: _buildInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildInfo() => Padding(
    padding: EdgeInsets.all(6),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          product.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '\$ ${product.price}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${product.stock} prices',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
            )
          ],
        ),
      ],
    ),
  );

  Stack _buildImage() {
    final height = maxHeight * 0.7; // ทำให้เป็น %
    final productImage = product.image;
    return Stack(
      children: [
        productImage != null && productImage.isNotEmpty
            ? Image.network(
          '${API.IMAGE_URL}/$productImage',
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
        )
            : Image.asset(
          Asset.noPhotoImage,
          height: height,
          width: double.infinity,
        ),
        if (product.stock <= 0)
          Positioned(
            top: 1,
            right: 1,
            child: Card(
              color: Colors.white70,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.box,
                      size: 15.0,
                      color: Colors.black,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'out of stock',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
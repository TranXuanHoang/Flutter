import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context).settings.arguments;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: ProductTitle(
                loadedProduct: loadedProduct,
                scrollController: _scrollController,
              ),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(
                  '\$${loadedProduct.price}',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.grey,
                      ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 800),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductTitle extends StatefulWidget {
  const ProductTitle({
    Key key,
    @required this.loadedProduct,
    @required this.scrollController,
  }) : super(key: key);

  final Product loadedProduct;
  final ScrollController scrollController;

  @override
  _ProductTitleState createState() => _ProductTitleState();
}

class _ProductTitleState extends State<ProductTitle> {
  ScrollController _scrollController;
  Color _backgroundColor;

  @override
  void initState() {
    _scrollController = widget.scrollController;
    _scrollController.addListener(_scrollListener);
    _backgroundColor = Colors.black45;
    super.initState();
  }

  @override
  void dispose() {
    if (_scrollController != null) {
      _scrollController.removeListener(_scrollListener);
      _scrollController.dispose();
    }
    super.dispose();
  }

  _scrollListener() {
    setState(() {
      _backgroundColor = _dynamicBackgroundColor();
    });
  }

  _dynamicBackgroundColor() {
    // Offset = 0 --> color = Colors.black45
    // Offset = 300 - kToolbarHeight --> color = Theme.of(context).primaryColor
    Color beginColor = Colors.black45;
    Color endColor = Theme.of(context).primaryColor;
    double offset = min(_scrollController.offset, 300 - kToolbarHeight);
    double ratio = offset / (300 - kToolbarHeight);

    int red =
        beginColor.red + ((endColor.red - beginColor.red) * ratio).floor();
    int green = beginColor.green +
        ((endColor.green - beginColor.green) * ratio).floor();
    int blue =
        beginColor.blue + ((endColor.blue - beginColor.blue) * ratio).floor();
    double opacity =
        beginColor.opacity + (endColor.opacity - beginColor.opacity) * ratio;

    return Color.fromRGBO(red, green, blue, opacity);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.loadedProduct.title),
      color: _backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    );
  }
}

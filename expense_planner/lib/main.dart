import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './models/transaction.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Planner',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(
                color: Colors.white,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 63.52,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Groceries',
    //   amount: 10.36,
    //   date: DateTime.now(),
    // )
  ];

  var _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction({String title, double amount, DateTime date}) {
    final newTransaction = Transaction(
        title: title,
        amount: amount,
        date: date,
        id: new DateTime.now().toString());

    setState(() {
      this._userTransactions.add(newTransaction);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    // Show the widget allowing user to enter new transactions at
    // the bottom of the screen
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return GestureDetector(
          child: NewTransaction(
            addNewTransactionHandler: _addNewTransaction,
          ),
          // catch the tap event and avoid
          // the tap here on this gesture detector
          onTap: () {},
          // also catch the tap event and avoid the tap hits on
          // any underlying widgets (modal bottom sheet in this case)
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransactionHandler(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  Widget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text("Expense Planer"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: const Text("Expense Planer"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );
  }

  List<Widget> _buildPortraitContent(
    Widget chartWidget,
    Widget transactionListWidget,
  ) {
    return [
      chartWidget,
      transactionListWidget,
    ];
  }

  List<Widget> _buildLandscapeContent(
    Widget chartWidget,
    Widget transactionListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Show Chart'),
          Switch.adaptive(
            value: _showChart,
            onChanged: (newValue) {
              setState(() {
                _showChart = newValue;
              });
            },
          ),
        ],
      ),
      _showChart ? chartWidget : transactionListWidget,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = _buildAppBar();

    final chartWidget = Container(
      height: (mediaQuery.size.height -
              mediaQuery.viewPadding.top -
              appBar.preferredSize.height) *
          (isLandscape ? 0.8 : 0.35),
      child: Chart(_recentTransactions),
    );

    final transactionListWidget = Container(
      height: (mediaQuery.size.height -
              mediaQuery.viewPadding.top -
              appBar.preferredSize.height) *
          (isLandscape ? 0.8 : 0.65),
      child: TransactionList(
        transactions: _userTransactions,
        deleteTransactionHandler: _deleteTransactionHandler,
      ),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(chartWidget, transactionListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(chartWidget, transactionListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddNewTransaction(context),
                    child: Icon(
                      Icons.add,
                    ),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() { _notification = state; });
    print("state: $state");
    print("notification: $_notification");
  }
}

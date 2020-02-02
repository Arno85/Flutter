import 'package:expense_app/transactions/widgets/new_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'charts/widgets/chart.dart';
import 'transactions/models/transaction.dart';
import 'transactions/widgets/transaction_list.dart';

void main() {
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  //#region Properties

  bool _showChart = false;

  List<Transaction> _transactions = [];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  //#endregion

  //#region Methods

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime selectedDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: selectedDate,
    );

    setState(() {
      _transactions.insert(0, newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  //#endregion

  //#region Widget Builder Methods

  Widget _buildAppBar() {
    final appTitle = 'Personal Expenses';

    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(appTitle),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon((CupertinoIcons.add)),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text(appTitle),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );
  }

  Widget _buildChartContent(double availableHeight, double screenSpacePct) {
    return Container(
              height: availableHeight * screenSpacePct,
              child: Chart(_transactions),
            );
  }

  Widget _buildTransactionsListContent(double availableHeight, double screenSpacePct) {
    return Container(
              height: availableHeight * screenSpacePct,
              child: TransactionList(
                _recentTransactions,
                _deleteTransaction,
              ),
            );
  }

  List<Widget> _buildLandscapeContent(double availableHeight) {
    return [
      Container(
        height: availableHeight * 0.15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Show Shart',
              style: Theme.of(context).textTheme.title,
            ),
            Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (val) {
                setState(() => _showChart = val);
              },
            ),
          ],
        ),
      ),
      _showChart
          ? _buildChartContent(availableHeight, 0.85)
          : _buildTransactionsListContent(availableHeight, 0.85),
    ];
  }

  List<Widget> _buildPortraitContent(double availableHeight) {
    return [
      _buildChartContent(availableHeight, 0.3),
      _buildTransactionsListContent(availableHeight, 0.7)
    ];
  }

  Widget _buildBody(bool isLandscape, double availableHeight) {
   return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) ..._buildLandscapeContent(availableHeight),
            if (!isLandscape) ..._buildPortraitContent(availableHeight)
          ],
        ),
      ),
    );
  }

  //#endregion

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = _buildAppBar();

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: _buildBody(isLandscape, availableHeight),
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: _buildBody(isLandscape, availableHeight),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sort_magic/PopUpItem.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(appBarTitle: 'Bubble Sort'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.appBarTitle}) : super(key: key);

  String appBarTitle;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int sortType = 1;
  bool isSorting = false;

  StreamController<List<int>> streamController;
  StreamController<String> timerStreamController;
  Stream<String> timerStream;
  Stream<List<int>> stream;
  List<int> _number;
  int _counter = 0;
  int sampleSize = 500;


  void randomize() {
    _number = [];
    for (int i = 0; i < sampleSize; ++i) {
      _number.add(Random().nextInt(sampleSize));
    }
    streamController.add(_number);
  }

  /*
  
  Merge SOrt
  
   */
  merge(int l, int m, int r) async {
    int n1 = m - l + 1;
    int n2 = r - m;

    List<int> L = List<int>(n1);
    List<int> R = List<int>(n2);

    for (int i = 0; i < n1; ++i) L[i] = _number[l + i];
    for (int j = 0; j < n2; ++j) R[j] = _number[m + 1 + j];

    int i = 0, j = 0;@override
void dispose() { 
  
  super.dispose();
}

    int k = l;
    while (i < n1 && j < n2) {
      if (L[i] <= R[j]) {
        _number[k] = L[i];

        i++;
      } else {
        _number[k] = R[j];

        j++;
      }
      k++;
      await Future.delayed(_getDelayed(), () {});
      streamController.add(_number);
    }

    while (i < n1) {
      _number[k] = L[i];
      await Future.delayed(_getDelayed(), () {});
      streamController.add(_number);
      i++;
      k++;
    }

    while (j < n2) {
      _number[k] = R[j];
      await Future.delayed(_getDelayed(), () {});
      streamController.add(_number);
      j++;
      k++;
    }
  }

  _mergeSort(int l, int r) async {
    if (l < r) {
      int m = (l + r) ~/ 2;

      await _mergeSort(l, m);
      await _mergeSort(m + 1, r);
      await merge(l, m, r);
    }
  }

  /*
        Bubble sort 

        */
  _bubbleSort() async {
    int i, j;
    for (i = 0; i < sampleSize - 1; i++) {
      for (j = 0; j < sampleSize - i - 1; j++) {
        if (_number[j] > _number[j + 1]) {
          int temp = _number[j];
          _number[j] = _number[j + 1];
          _number[j + 1] = temp;
        }

        await Future.delayed(_getDelayed(), () {});
        streamController.add(_number);
      }
    }
    // print(_number);
  }

  /*Selection Sort*/
  _selectionSort() async {
    int n = _number.length;

    for (int i = 0; i < n - 1; i++) {
      int min_idx = i;
      for (int j = i + 1; j < n; j++) {
        if (_number[j] < _number[min_idx]) min_idx = j;
        await Future.delayed(_getDelayed(), () {});
        streamController.add(_number);
      }

      // Swap the found minimum element with the first
      // element
      int temp = _number[min_idx];
      _number[min_idx] = _number[i];
      _number[i] = temp;

      // await Future.delayed(_getDelayed(), () {});
      // streamController.add(_number);
    }
  }

  /*
  Insertion sort
  */
  _insertionSort() async {
    int n = _number.length;
    for (int i = 1; i < n; ++i) {
      int key = _number[i];
      int j = i - 1;
      while (j >= 0 && _number[j] > key) {
        _number[j + 1] = _number[j];
        j = j - 1;
        await Future.delayed(_getDelayed(), () {});
        streamController.add(_number);
      }
      _number[j + 1] = key;
    }
  }

  /*
  Quick Sort
  */

  Future<int> _partition(int low, int high) async {
    int pivot = _number[high];
    int i = (low - 1);
    for (int j = low; j < high; j++) {
      if (_number[j] < pivot) {
        i++;

        int temp = _number[i];
        _number[i] = _number[j];
        _number[j] = temp;
        await Future.delayed(_getDelayed(), () {});
        streamController.add(_number);
      }
    }
    int temp = _number[i + 1];
    _number[i + 1] = _number[high];
    _number[high] = temp;
    await Future.delayed(_getDelayed(), () {});
    streamController.add(_number);

    return i + 1;
  }

  _quickSort(int low, int high) async {
    if (low < high) {
      int pi = await _partition(low, high);

      await _quickSort(low, pi - 1);
      await _quickSort(pi + 1, high);
    }
  }

/*

Heap Sort  

*/

  _heapsort() async {
    int n = _number.length;

    // Build heap (re_numberange _numberay)
    for (int i = n ~/ 2 - 1; i >= 0; i--) await heapify(n, i);

    // One by one extract an element from heap
    for (int i = n - 1; i > 0; i--) {
      // Move current root to end
      int temp = _number[0];
      _number[0] = _number[i];
      _number[i] = temp;
      await Future.delayed(_getDelayed(), () {});
      streamController.add(_number);
      // call max heapify on the reduced heap
      await heapify(i, 0);
    }
  }

  // To heapify a subtree rooted with node i which is
  // an index in _number[]. n is size of heap
  heapify(int n, int i) async {
    int largest = i; // Initialize largest as root
    int l = 2 * i + 1; // left = 2*i + 1
    int r = 2 * i + 2; // right = 2*i + 2

    // If left child is larger than root
    if (l < n && _number[l] > _number[largest]) {
      largest = l;
      await Future.delayed(_getDelayed(), () {});
      streamController.add(_number);
    }

    // If right child is larger than largest so far
    if (r < n && _number[r] > _number[largest]) {
      largest = r;
      await Future.delayed(_getDelayed(), () {});
      streamController.add(_number);
    }

    // If largest is not root
    if (largest != i) {
      int swap = _number[i];
      _number[i] = _number[largest];
      _number[largest] = swap;

      // Recursively heapify the affected sub-tree
      await Future.delayed(_getDelayed(), () {});
      streamController.add(_number);
      await heapify(n, largest);
    }
  }

  /*
  
  Shell Sort

  */

  _shellSort() async {
    int n = _number.length;

    for (int gap = n ~/ 2; gap > 0; gap = gap ~/ 2) {
      for (int i = gap; i < n; i += 1) {
        int temp = _number[i];

        int j;
        for (j = i; j >= gap && _number[j - gap] > temp; j -= gap) {
          _number[j] = _number[j - gap];
          await Future.delayed(_getDelayed(), () {});
          streamController.add(_number);
        }

        _number[j] = temp;
        await Future.delayed(_getDelayed(), () {});
        streamController.add(_number);
      }
    }
  }

  Duration _getDelayed() {
    return Duration(microseconds: 1);
  }

  @override
  void initState() {
    streamController = StreamController();
    stream = streamController.stream;
    randomize();
    super.initState();
  }

  _getSortingAlgo(int type) async {
    switch (type) {
      case 1:
        _bubbleSort();
        break;
      case 2:
        await _mergeSort(0, _number.length - 1);
        break;
      case 3:
        _selectionSort();
        break;
      case 4:
        _insertionSort();
        break;
      case 5:
        await _quickSort(0, _number.length - 1);
        break;
      case 6:
        _heapsort();
        break;
      case 7:
        _shellSort();
        break;
    }
  }

  _getMenuItemSelected(String choice) {
    print(choice);
    if (choice == PopUpItems.bubble) {
      if (!isSorting) {
        setState(() {
          widget.appBarTitle = choice;
        });
        sortType = 1;
      }
    } else if (choice == PopUpItems.merge) {
      if (!isSorting) {
        setState(() {
          widget.appBarTitle = choice;
        });
        sortType = 2;
      }
    } else if (choice == PopUpItems.selection) {
      if (!isSorting) {
        setState(() {
          widget.appBarTitle = choice;
        });
        sortType = 3;
      }
    } else if (choice == PopUpItems.insertion) {
      if (!isSorting) {
        setState(() {
          widget.appBarTitle = choice;
        });
        sortType = 4;
      }
    } else if (choice == PopUpItems.quick) {
      if (!isSorting) {
        setState(() {
          widget.appBarTitle = choice;
        });
        sortType = 5;
      }
    } else if (choice == PopUpItems.heap) {
      if (!isSorting) {
        setState(() {
          widget.appBarTitle = choice;
        });
        sortType = 6;
      }
    } else if (choice == PopUpItems.shell) {
      if (!isSorting) {
        setState(() {
          widget.appBarTitle = choice;
        });
        sortType = 7;
      }
    }
  }
@override
void dispose() { 
  streamController.close();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (context) {
              return PopUpItems.sortsList.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            onSelected: _getMenuItemSelected,
          )
        ],
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
              int counter = 0;
              return Row(
                  children: _number.map((val) {
                counter++;
                return CustomPaint(
                    painter: BarPainter(
                        widht: MediaQuery.of(context).size.width / sampleSize,
                        value: val,
                        index: counter));
              }).toList());
        },
      ),
      // StreamBuilder(stream: timerStream,
      // builder: (context,snapshot){

      //   return Text(snapshot.data.toString());
        
      // },)
            ],
          )),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              onPressed: randomize,
              child: Text("Randomize"),
            ),
          ),
          Expanded(
            child: FlatButton(
              onPressed: () async {
                print(isSorting);
                if (!isSorting) {
                  isSorting = true;

                  await _getSortingAlgo(sortType);
                  isSorting = false;
                } else {
                  // showBottomSheet(context: context, builder: (context){
                  //   return SnackBar(
                  //     duration: Duration(seconds: 2),
                  //     content: Text("Already Sorting"),);
                  // });

                }
              },
              child: Text("Sort"),
            ),
          )
        ],
      ),
    );
  }
}




class BarPainter extends CustomPainter {
  double widht;
  int value;
  int index;
  BarPainter({this.widht, this.value, this.index});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.red;
    paint.strokeWidth = widht;
    paint.strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(index * widht, 0),
        Offset(index * widht, value*1.5), paint);
  }

  @override
  bool shouldRepaint(CustomPainter customPainter) {
    return true;
  }
}

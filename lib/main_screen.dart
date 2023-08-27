import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'container_box.dart';
import 'data_container.dart';

const activeColor = Color(0xFF0073dd);
const inactiveColor = Color(0xFF212121);

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Color maleBoxColor = activeColor;
  Color femaleBoxColor = inactiveColor;
  Color resultColor = const Color(0xFF00E676);

  int height = 180;
  int weight = 50;
  int age = 20;
  String result = '';
  String body_type = '';
  String resultDetail = "Result will be printed Here";
  double bmi = 0;

  void updateBoxColor(int gender) {
    if (gender == 1) {
      if (maleBoxColor == inactiveColor) {
        maleBoxColor = activeColor;
        femaleBoxColor = inactiveColor;
      } else {
        maleBoxColor = inactiveColor;
        femaleBoxColor = activeColor;
      }
    } else {
      if (femaleBoxColor == inactiveColor) {
        femaleBoxColor = activeColor;
        maleBoxColor = inactiveColor;
      } else {
        femaleBoxColor = inactiveColor;
        maleBoxColor = activeColor;
      }
    }
  }

  String calculateBMI(int weight, int height) {
    bmi = weight / pow(height / 100, 2);
    return bmi.toStringAsFixed(1);
  }

  String getDetails(double bmi) {
    if (bmi >= 25) {
      body_type = 'Overweight';
      resultColor = Colors.red;
      return "You have a higher than Normal Body Weight. Try to Excercise More!!";
    } else if (bmi > 18.5) {
      body_type = 'Normal';
      resultColor = const Color(0xFF00E676);
      return "You have a Normal Body Weight. Good Job!!";
    } else {
      body_type = 'Underweight';
      resultColor = Colors.red;
      return "You have a lower than usual body weight. You can eat a bit more!!";
    }
  }

  Timer? _timer;
  bool _longPressCanceled = false;

  void _cancelIncrease() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _longPressCanceled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "BMI Calculator",
            style: TextStyle(
              fontSize: 22.0,
            ),
          ),
          backgroundColor: const Color(0xFF000000),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 10),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            updateBoxColor(1);
                          });
                        },
                        child: ContainerBox(
                          boxColor: maleBoxColor,
                          childWidget: const DataContainer(
                            icon: FontAwesomeIcons.mars,
                            title: 'MALE',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            updateBoxColor(2);
                          });
                        },
                        child: ContainerBox(
                          boxColor: femaleBoxColor,
                          childWidget: const DataContainer(
                            icon: FontAwesomeIcons.venus,
                            title: 'FEMALE',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ContainerBox(
                  boxColor: inactiveColor,
                  childWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "HEIGHT",
                        style: DataContainer.textStyle1,
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            height.toString(),
                            style: DataContainer.textStyle2,
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          const Text(
                            "cm",
                            style: DataContainer.textStyle1,
                          ),
                        ],
                      ),
                      Slider(
                        value: height.toDouble(),
                        min: 130,
                        max: 210,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                        onChanged: (double newValue) {
                          setState(() {
                            height = newValue.round();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ContainerBox(
                        boxColor: inactiveColor,
                        childWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "WEIGHT",
                              style: DataContainer.textStyle1,
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              weight.toString(),
                              style: DataContainer.textStyle2,
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  child: FloatingActionButton(
                                    backgroundColor: activeColor,
                                    onPressed: () {
                                      setState(() {
                                        if (weight > 0) {
                                          weight--;
                                        }
                                      });
                                    },
                                    child: const Icon(FontAwesomeIcons.minus,
                                        color: Colors.white),
                                  ),
                                  onLongPressEnd:
                                      (LongPressEndDetails longPressEndDetails) {
                                    _cancelIncrease();
                                  },
                                  onLongPress: () {
                                    _longPressCanceled = false;
                                    Future.delayed(
                                        const Duration(milliseconds: 100), () {
                                      if (!_longPressCanceled) {
                                        _timer = Timer.periodic(
                                            const Duration(milliseconds: 140),
                                            (timer) {
                                          setState(() {
                                            if (weight > 0) {
                                              weight--;
                                            }
                                          });
                                        });
                                      }
                                    });
                                  },
                                  onLongPressUp: () {
                                    _cancelIncrease();
                                  },
                                  onLongPressMoveUpdate:
                                      (LongPressMoveUpdateDetails
                                          longPressMoveUpdateDetails) {
                                    if (longPressMoveUpdateDetails
                                            .localOffsetFromOrigin.distance >
                                        20) {
                                      _cancelIncrease();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                GestureDetector(
                                  child: FloatingActionButton(
                                    backgroundColor: activeColor,
                                    onPressed: () {
                                      setState(() {
                                        weight++;
                                      });
                                    },
                                    child: const Icon(FontAwesomeIcons.plus,
                                        color: Colors.white),
                                  ),
                                  onLongPressEnd:
                                      (LongPressEndDetails longPressEndDetails) {
                                    _cancelIncrease();
                                  },
                                  onLongPress: () {
                                    _longPressCanceled = false;
                                    Future.delayed(
                                        const Duration(milliseconds: 100), () {
                                      if (!_longPressCanceled) {
                                        _timer = Timer.periodic(
                                            const Duration(milliseconds: 140),
                                            (timer) {
                                          setState(() {
                                            weight++;
                                          });
                                        });
                                      }
                                    });
                                  },
                                  onLongPressUp: () {
                                    _cancelIncrease();
                                  },
                                  onLongPressMoveUpdate:
                                      (LongPressMoveUpdateDetails
                                          longPressMoveUpdateDetails) {
                                    if (longPressMoveUpdateDetails
                                            .localOffsetFromOrigin.distance >
                                        20) {
                                      _cancelIncrease();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ContainerBox(
                        boxColor: inactiveColor,
                        childWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "AGE",
                              style: DataContainer.textStyle1,
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              age.toString(),
                              style: DataContainer.textStyle2,
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  child: FloatingActionButton(
                                    backgroundColor: activeColor,
                                    onPressed: () {
                                      setState(() {
                                        if (age > 0) {
                                          age--;
                                        }
                                      });
                                    },
                                    child: const Icon(FontAwesomeIcons.minus,
                                        color: Colors.white),
                                  ),
                                  onLongPressEnd:
                                      (LongPressEndDetails longPressEndDetails) {
                                    _cancelIncrease();
                                  },
                                  onLongPress: () {
                                    _longPressCanceled = false;
                                    Future.delayed(
                                        const Duration(milliseconds: 100), () {
                                      if (!_longPressCanceled) {
                                        _timer = Timer.periodic(
                                            const Duration(milliseconds: 140),
                                            (timer) {
                                          setState(() {
                                            if (age > 0) {
                                              age--;
                                            }
                                          });
                                        });
                                      }
                                    });
                                  },
                                  onLongPressUp: () {
                                    _cancelIncrease();
                                  },
                                  onLongPressMoveUpdate:
                                      (LongPressMoveUpdateDetails
                                          longPressMoveUpdateDetails) {
                                    if (longPressMoveUpdateDetails
                                            .localOffsetFromOrigin.distance >
                                        20) {
                                      _cancelIncrease();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                GestureDetector(
                                  child: FloatingActionButton(
                                    backgroundColor: activeColor,
                                    onPressed: () {
                                      setState(() {
                                        age++;
                                      });
                                    },
                                    child: const Icon(FontAwesomeIcons.plus,
                                        color: Colors.white),
                                  ),
                                  onLongPressEnd:
                                      (LongPressEndDetails longPressEndDetails) {
                                    _cancelIncrease();
                                  },
                                  onLongPress: () {
                                    _longPressCanceled = false;
                                    Future.delayed(
                                        const Duration(milliseconds: 100), () {
                                      if (!_longPressCanceled) {
                                        _timer = Timer.periodic(
                                            const Duration(milliseconds: 140),
                                            (timer) {
                                          setState(() {
                                            age++;
                                          });
                                        });
                                      }
                                    });
                                  },
                                  onLongPressUp: () {
                                    _cancelIncrease();
                                  },
                                  onLongPressMoveUpdate:
                                      (LongPressMoveUpdateDetails
                                          longPressMoveUpdateDetails) {
                                    if (longPressMoveUpdateDetails
                                            .localOffsetFromOrigin.distance >
                                        20) {
                                      _cancelIncrease();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              SizedBox(
                height: 60,
                width: 350,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  splashColor: Colors.black,
                  shape: const StadiumBorder(
                    side: BorderSide(color: Colors.red, width: 4),
                  ),
                  elevation: 10.0,
                  child: const Text(
                    "Calculate",
                    style: DataContainer.textStyle3,
                  ),
                  onPressed: () {
                    Future.delayed(const Duration(milliseconds: 80), () {
                      setState(() {
                        result = calculateBMI(weight, height);
                        resultDetail = getDetails(bmi);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: inactiveColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Container(
                                  color: inactiveColor,
                                  height: 330.0,
                                  margin: const EdgeInsets.all(10.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        const Text(
                                          'Result',
                                          style: DataContainer.textStyle3,
                                        ),
                                        const SizedBox(
                                          height: 0.0,
                                        ),
                                        Text(
                                          body_type,
                                          style: TextStyle(
                                            fontSize: 30.0,
                                            color: resultColor,
                                          ),
                                        ),
                                        Text(
                                          result.toString(),
                                          style: DataContainer.textStyle2,
                                        ),
                                        Text(
                                          resultDetail,
                                          style: DataContainer.textStyle1,
                                        ),
                                        const SizedBox(
                                          height: 2.0,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: FloatingActionButton(
                                            splashColor: Colors.black,
                                            onPressed: () {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 80), () {
                                                Navigator.pop(context);
                                              });
                                            },
                                            // onPressed: () => Navigator.pop(context),
                                            shape: const StadiumBorder(
                                              side: BorderSide(
                                                  color: Colors.blue, width: 4),
                                            ),
                                            elevation: 10.0,
                                            child: const Text(
                                              "OK",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      });
                    });
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

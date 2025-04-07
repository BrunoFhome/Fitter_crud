import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Principal"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Bem Vindo ao",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "FITTER",
              style: TextStyle(
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 70),
                textStyle: TextStyle(fontSize: 20, color: Colors.blue),
                foregroundColor: Colors.blue,
              ),
              child: Text("Sua Planilha"),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) => WorkoutScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 70),
                textStyle: TextStyle(fontSize: 20, color: Colors.blue),
                foregroundColor: Colors.blue,
              ),
              child: Text("Configurações"),
              onPressed: () {
                // nao faz nada por enquanto
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final List<String> days = [
    "Segunda-feira",
    "Terça-feira",
    "Quarta-feira",
    "Quinta-feira",
    "Sexta-feira",
    "Sabádo",
    "Domingo"
  ];
  int selectedDayIndex = 0;

  final List<String> availableExercises = [
    "Flexões",
    "Agachamento",
    "Supino Reto",
    "Levantamento Terra",
    "Biceps Rosca",
    "Leg press"
  ];
  final Map<String, List<String>> workoutPlans = {};
  final TextEditingController _exerciseController = TextEditingController();

  final Map<String, String> exerciseExplanations = {
    "Flexões":
        "As flexões são um exercício que fortalece os músculos da parte superior do corpo...",
    "Agachamento":
        "O agachamento é um exercício de força que serve para fortalecer os músculos das pernas...",
    // adicionar mais depois.
  };

  @override
  void initState() {
    super.initState();
    for (var day in days) {
      workoutPlans[day] = [];
    }
  }

  void _addNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Novo Exercício"),
        content: TextField(
          controller: _exerciseController,
          decoration: InputDecoration(hintText: "Digite o nome do exercício"),
        ),
        actions: [
          TextButton(
            child: Text("Cancelar"),
            onPressed: () {
              _exerciseController.clear();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Adicionar"),
            onPressed: () {
              if (_exerciseController.text.isNotEmpty) {
                setState(() {
                  availableExercises.add(_exerciseController.text);
                });
              }
              _exerciseController.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _editExercise(int index) {
    _exerciseController.text = availableExercises[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Editar Exercício"),
        content: TextField(
          controller: _exerciseController,
          decoration: InputDecoration(hintText: "Digite o novo nome"),
        ),
        actions: [
          TextButton(
            child: Text("Cancelar"),
            onPressed: () {
              _exerciseController.clear();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Salvar"),
            onPressed: () {
              if (_exerciseController.text.isNotEmpty) {
                setState(() {
                  availableExercises[index] = _exerciseController.text;
                });
              }
              _exerciseController.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FITTER"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                days.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(days[index]),
                    selected: selectedDayIndex == index,
                    onSelected: (selected) {
                      setState(() {
                        selectedDayIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: const Color.fromARGB(255, 129, 230, 255),
                    child: Column(
                      children: [
                        Text(
                          "Exercicios Disponiveis",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: availableExercises.length,
                            itemBuilder: (context, index) {
                              final exerciseName = availableExercises[index];
                              return Draggable<String>(
                                data: exerciseName,
                                feedback: Material(
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    color: Colors.blue,
                                    child: Text(
                                      exerciseName,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(exerciseName),
                                  onTap: () {
                                    final explanation =
                                        exerciseExplanations[exerciseName] ??
                                            "Nenhuma explicação fornecida.";
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(exerciseName),
                                        content: Text(explanation),
                                        actions: [
                                          TextButton(
                                            child: Text("Fechar"),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  trailing: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => _editExercise(index),
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
                
                Expanded(
                  child: DragTarget<String>(
                    onAccept: (exercise) {
                      if (workoutPlans[days[selectedDayIndex]]!
                          .contains(exercise)) {
                        showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Exercicio Duplicado"),
                            content: Text(
                                "Este exercicio ja foi incluido, gostaria de adiciona-lo novamente?"),
                            actions: [
                              TextButton(
                                child: Text("Não"),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: Text("Sim"),
                                onPressed: () => Navigator.of(context).pop(true),
                              ),
                            ],
                          ),
                        ).then((proceed) {
                          if (proceed == true) {
                            setState(() {
                              workoutPlans[days[selectedDayIndex]]!
                                  .add(exercise);
                            });
                          }
                        });
                      } else if (workoutPlans[days[selectedDayIndex]]!
                              .length >=
                          8) {
                        showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Limite de exercícios"),
                            content: Text(
                                "Você já adicionou 8 exercícios. Que é uma boa média diária. Deseja adicionar mais?"),
                            actions: [
                              TextButton(
                                child: Text("Não"),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: Text("Sim"),
                                onPressed: () => Navigator.of(context).pop(true),
                              ),
                            ],
                          ),
                        ).then((exceed) {
                          if (exceed == true) {
                            setState(() {
                              workoutPlans[days[selectedDayIndex]]!
                                  .add(exercise);
                            });
                          }
                        });
                      } else {
                        setState(() {
                          workoutPlans[days[selectedDayIndex]]!.add(exercise);
                        });
                      }
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        color: const Color.fromARGB(255, 0, 204, 255),
                        child: Column(
                          children: [
                            Text(
                              "Treino ${days[selectedDayIndex]}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    workoutPlans[days[selectedDayIndex]]!
                                        .length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(workoutPlans[days[
                                            selectedDayIndex]]![index]),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          workoutPlans[days[selectedDayIndex]]!
                                              .removeAt(index);
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            backgroundColor: Colors.white,
          ),
          onPressed: _addNewExercise,
          icon: Icon(Icons.add, color: Colors.blue),
          label: Text(
            "Adicionar exercício",
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
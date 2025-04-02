import 'package:flutter/material.dart';

void main() {
  runApp(GymWorkoutApp());
}

class GymWorkoutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WorkoutScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final List<String> days = ["Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sabádo", "Domingo"];
  int selectedDayIndex = 0;
  
  final List<String> availableExercises = ["Flexões", "Agachamento", "Supino Reto", "Levantamento Terra", "Biceps Rosca", "Leg press"];
  final Map<String, List<String>> workoutPlans = {};

  // Controller to manage text input for new or edited exercises
  final TextEditingController _exerciseController = TextEditingController();

  // Add a map to hold custom explanations for each exercise
  final Map<String, String> exerciseExplanations = {
    "Flexões": "As flexões são um exercício que fortalece os músculos da parte superior do corpo, como ombros, braços e peitorais. Elas também ajudam a melhorar a estabilidade do core, a resistência e o equilíbrio. ",
    "Agachamento": "O agachamento é um exercício de força que serve para fortalecer os músculos das pernas e do core, além de melhorar a mobilidade e o equilíbrio. ",
    "Supino Reto": "A modalidade conhecida como supino reto, é o exercício que mais caracteriza o levantamento de peso. Definitivamente é um dos principais para quem deseja fortalecer ou ganhar massa muscular na região do peitoral.",
    "Levantamento Terra": "Trabalhos multiarticulares, como o 'terra', são os mais eficazes para promover o ganho de força, pois possibilitam um maior incremento de carga. Além disso, há também o fato de que ele aumenta o gasto energético. ",
    "Biceps Rosca": "A rosca direta é um exercício indicado para fortalecer e hipertrofiar os bíceps e trabalhar também outros músculos dos membros superiores ",
    "Leg press": "O Leg Press estimula a hipertrofia dos músculos dos membros inferiores. ",

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
      builder: (context) {
        return AlertDialog(
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
        );
      },
    );
  }

  void _editExercise(int index) {
    _exerciseController.text = availableExercises[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FITTER"),centerTitle: true,),
      body: Column(
        children: [
          // Day selection
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
                // LISTA DE EXERCICIOS PARA USUARIO ESCOLHER
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: const Color.fromARGB(255, 129, 230, 255),
                    child: Column(
                      children: [
                        Text("Exercicios Disponiveis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: availableExercises.length,
                            itemBuilder: (context, index) {
                              return Draggable<String>(
                                data: availableExercises[index],
                                feedback: Material(
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    color: Colors.blue,
                                    child: Text(availableExercises[index], style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(availableExercises[index]),
                                  onTap: () {
                                    // Use the map to retrieve a custom explanation
                                    final exerciseName = availableExercises[index];
                                    final explanation = exerciseExplanations[exerciseName] ?? "Nenhuma explicação fornecida.";
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(exerciseName),
                                        content: Text(explanation),
                                        actions: [
                                          TextButton(
                                            child: Text("Fechar"),
                                            onPressed: () => Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  trailing: IconButton(
                                    icon: Icon(Icons.edit, color: const Color.fromARGB(255, 0, 0, 0)),
                                    onPressed: () {
                                      _editExercise(index);
                                    },
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
                // Workout Plan
                Expanded(
                  child: DragTarget<String>(
                    onAccept: (exercise) {
                      if (workoutPlans[days[selectedDayIndex]]!.contains(exercise)) {
                        showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Exercicio Duplicado"),
                            content: Text("Este exercicio ja foi incluido, gostaria de adiciona-lo novamente?"),
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
                              workoutPlans[days[selectedDayIndex]]!.add(exercise);
                            });
                          }
                        });
                      } else if (workoutPlans[days[selectedDayIndex]]!.length >= 8) {
                        showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Limite de exercícios"),
                            content: Text("Você já adicionou 8 exercícios. Que é uma boa média diária. Deseja adicionar mais?"),
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
                              workoutPlans[days[selectedDayIndex]]!.add(exercise);
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
                            Text("Treino ${days[selectedDayIndex]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: ListView.builder(
                                itemCount: workoutPlans[days[selectedDayIndex]]!.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(workoutPlans[days[selectedDayIndex]]![index]),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          workoutPlans[days[selectedDayIndex]]!.removeAt(index);
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewExercise,
      ),
    );
  }
}

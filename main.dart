
import 'package:flutter/material.dart';

void main() {
  runApp(BecBoApp());
}

class BecBoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bec Bo Inteligente',
      theme: ThemeData.dark(),
      home: BecBoHomePage(),
    );
  }
}

class BecBoHomePage extends StatefulWidget {
  @override
  _BecBoHomePageState createState() => _BecBoHomePageState();
}

class _BecBoHomePageState extends State<BecBoHomePage> {
  final List<List<int>> resultados = [];

  void _adicionarResultado(List<int> novoResultado) {
    setState(() {
      resultados.add(novoResultado);
    });
  }

  void _mostrarAdicionarResultadoDialog() {
    final dadosController = List.generate(3, (_) => TextEditingController());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Adicionar Resultado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return TextField(
              controller: dadosController[i],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Dado ${i + 1}'),
            );
          }),
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text('Salvar'),
            onPressed: () {
              final numeros = dadosController.map((c) => int.tryParse(c.text) ?? 0).toList();
              if (numeros.every((n) => n > 0 && n <= 6)) {
                _adicionarResultado(numeros);
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }

  void _analisarResultados() {
    final contagem = List.filled(7, 0); // index 1-6

    for (var resultado in resultados) {
      for (var num in resultado) {
        if (num >= 1 && num <= 6) {
          contagem[num]++;
        }
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Análise de Estratégia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(6, (i) {
            return Text('Número ${i + 1}: ${contagem[i + 1]}x');
          }),
        ),
        actions: [
          TextButton(
            child: Text('Fechar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bec Bo Inteligente'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _mostrarAdicionarResultadoDialog,
            child: Text('Adicionar Resultado'),
          ),
          ElevatedButton(
            onPressed: _analisarResultados,
            child: Text('Analisar Estratégia'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: resultados.length,
              itemBuilder: (context, index) {
                final r = resultados[index];
                return ListTile(
                  title: Text('Resultado: ${r.join(", ")}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

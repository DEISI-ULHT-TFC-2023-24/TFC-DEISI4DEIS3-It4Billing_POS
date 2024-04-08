import 'package:flutter/material.dart';
import 'dart:async';
import '../../main.dart';
import '../../objetos/setupObj.dart';

class GeralPage extends StatefulWidget {
  @override
  _GeralPageState createState() => _GeralPageState();
}

class _GeralPageState extends State<GeralPage> {
  TextEditingController urlController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  SetupObj setup = database.getAllSetup()[0];
  bool ischanged = false;
  bool _showConfirmation = false;
  bool _isDropdownChanged = false;
  bool _isButtonDisabled = false;

  String? _selectedStore;
  String? _selectedPos;
  String? _selectedDocInvoice;
  String? _selectedDocRefund;
  String? _selectedDocCurrentAccount;

  final List<String> _stores = [
    'Selecione a loja',
    'Loja 1',
    'Loja 2',
    'Loja 3'
  ];
  final List<String> _poss = ['Selecione o POS', 'POS 1', 'POS 2', 'POS 3'];

  final List<String> _invoices = [
    'Documento da faturação',
    'F 1',
    'F 2',
    'F 3'
  ];
  final List<String> _refunds = ['Documento do reembolso', 'R 1', 'R 2', 'R 3'];

  final List<String> _cunrrentAccount = [
    'Documento da conta corrente',
    'Cc 1',
    'Cc 2',
    'Cc 3'
  ];

  bool isTablet = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkDeviceType();
  }

  void checkDeviceType() {
    // Getting the screen size
    final screenSize = MediaQuery.of(context).size;
    // Arbitrarily defining screen size greater than 600 width and height as tablet
    setState(() {
      isTablet = screenSize.width > 600 && screenSize.height > 600;
    });
  }

  @override
  void initState() {
    super.initState();
    urlController.text = setup.url;
    passwordController.text = setup.password;

    // Controladores para monitorar as alterações nos campos de texto
    urlController.addListener(updateButtonState);
    passwordController.addListener(updateButtonState);

    _selectedStore = setup.nomeLoja;
    _selectedPos = setup.pos;

    _selectedDocInvoice = setup.faturacao;
    _selectedDocRefund = setup.reembolso;
    _selectedDocCurrentAccount = setup.contaCorrente;
  }

  // Função para iniciar o temporizador
  void startTimer() {
    const duration = Duration(seconds: 5);
    Timer(duration, () {
      setState(() {
        _showConfirmation = false;
      });
    });
  }

  // Função para atualizar o estado com base no texto dos campos de entrada
  void updateButtonState() {
    setState(() {
      ischanged = passwordController.text.length >= 6 &&
          (urlController.text != setup.url ||
              passwordController.text != setup.password);

      // Verifica se houve alteração em algum dos dropdowns
      _isDropdownChanged = (_selectedStore != 'Selecione a loja' && _selectedStore != setup.nomeLoja) ||
                           (_selectedPos != 'Selecione o POS' && _selectedPos != setup.pos) ||
                           (_selectedDocInvoice != 'Documento da faturação' && _selectedDocInvoice != setup.faturacao) ||
                           (_selectedDocRefund != 'Documento do reembolso' && _selectedDocRefund != setup.reembolso) ||
                           (_selectedDocCurrentAccount != 'Documento da conta corrente' && _selectedDocCurrentAccount != setup.contaCorrente)
      ;

      if (ischanged == false && _isDropdownChanged == false) {
        _showConfirmation = ischanged;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //isTablet ? TabletLayout() : PhoneLayout(),
    return isTablet
        ? Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: 'URL',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: ischanged
                          ? () {
                        /// colocar na BD a nova info
                        setup.url = urlController.text;
                        setup.password = passwordController.text;
                        print(database.getAllSetup().length);
                        //database.removeAllSetup();
                        database.addSetup(setup);
                        print(database.getAllSetup().length);
                        setState(() {
                          _showConfirmation = true;
                          ischanged = false;
                        });

                        // Inicie o temporizador ao pressionar o botão
                        startTimer();
                      }
                          : null,
                      style: ButtonStyle(
                        backgroundColor: ischanged
                            ? MaterialStateProperty.all(const Color(0xff00afe9))
                            : MaterialStateProperty.all(Colors.grey),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      child: Text(
                        ischanged ? 'CONECTAR' : 'CONECTADO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ischanged ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  if (_showConfirmation)
                    const Row(
                      children: [
                        SizedBox(width: 20),
                        Icon(Icons.check_circle, color: Colors.green),
                      ],
                    )
                ],
              ),

              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedStore,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      // Definir a cor da borda quando em foco
                      color: Color(0xff00afe9), // Substitua pela cor desejada
                    ),
                  ),
                  label: const Text('Loja', style: TextStyle(fontSize: 20)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                hint: const Text('Selecione a loja'),
                onChanged: (newValue) {
                  setState(() {
                    _selectedStore = newValue!;
                    updateButtonState(); // Chama a função para verificar alterações
                  });
                },
                icon: Icon(Icons.arrow_drop_down),
                items: _stores.map<DropdownMenuItem<String>>((String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedPos,
                hint: const Text('Selecione o POS'),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      // Definir a cor da borda quando em foco
                      color: Color(0xff00afe9), // Substitua pela cor desejada
                    ),
                  ),
                  label: const Text('POS', style: TextStyle(fontSize: 20)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedPos = newValue!;
                    updateButtonState(); // Chama a função para verificar alterações
                  });
                },
                items: _poss.map<DropdownMenuItem<String>>((String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedDocInvoice,
                hint: const Text('Documento da faturação'),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        // Definir a cor da borda quando em foco
                        color: Color(0xff00afe9), // Substitua pela cor desejada
                      ),
                    ),
                    label: const Text('Documento para faturação', style: TextStyle(fontSize: 20)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDocInvoice = newValue!;
                    updateButtonState();
                  });
                },
                items: _invoices.map<DropdownMenuItem<String>>((String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedDocRefund,
                hint: const Text('Documento do reembolso'),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        // Definir a cor da borda quando em foco
                        color: Color(0xff00afe9), // Substitua pela cor desejada
                      ),
                    ),
                    label: const Text('Documento para reembolso', style: TextStyle(fontSize: 20)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDocRefund = newValue!;
                    updateButtonState();
                  });
                },
                items: _refunds.map<DropdownMenuItem<String>>((String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedDocCurrentAccount,
                hint: const Text('Documento da conta corrente'),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        // Definir a cor da borda quando em foco
                        color: Color(0xff00afe9), // Substitua pela cor desejada
                      ),
                    ),
                    label: const Text('Documento para conta corrente', style: TextStyle(fontSize: 20)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDocCurrentAccount = newValue!;
                    updateButtonState();
                  });
                },
                items: _cunrrentAccount
                    .map<DropdownMenuItem<String>>((String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),
              if (_isDropdownChanged)
                SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isButtonDisabled
                          ? Colors.grey
                          : const Color(0xff00afe9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    onPressed: _isButtonDisabled
                        ? null
                        : () {
                      if (_selectedStore != null && _selectedStore != 'Selecione a loja' &&
                          _selectedPos != null && _selectedPos != 'Selecione o POS' &&
                          _selectedDocInvoice != null && _selectedDocInvoice != 'Documento da faturação' &&
                          _selectedDocRefund != null && _selectedDocRefund != 'Documento do reembolso' &&
                          _selectedDocCurrentAccount != null && _selectedDocCurrentAccount != 'Documento da conta corrente') {
                        setState(() {
                          _isButtonDisabled = true;
                        });

                        // Lógica para confirmar seleção da loja e do POS
                        setup.nomeLoja = _selectedStore!;
                        setup.pos = _selectedPos!;
                        setup.faturacao = _selectedDocInvoice!;
                        setup.reembolso = _selectedDocRefund!;
                        setup.contaCorrente = _selectedDocCurrentAccount!;
                        print(database.getAllSetup().length);
                        //database.removeAllSetup();
                        database.addSetup(setup);
                        // Temporizador para reativar o botão após 5 segundos
                        Timer(const Duration(seconds: 5), () {
                          setState(() {
                            _isDropdownChanged =
                                _isButtonDisabled = false;
                          });
                        });
                      }
                    },
                    child: Text(
                      _isButtonDisabled ? 'SELECIONADO' : 'CONFIRMAR SELEÇÕES',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isButtonDisabled ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    )
        : Scaffold(
      appBar: AppBar(
        title: const Text('Geral'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: 'URL',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: ischanged
                          ? () {
                              /// colocar na BD a nova info
                              setup.url = urlController.text;
                              setup.password = passwordController.text;
                              print(database.getAllSetup().length);
                              //database.removeAllSetup();
                              database.addSetup(setup);
                              print(database.getAllSetup().length);
                              setState(() {
                                _showConfirmation = true;
                                ischanged = false;
                              });

                              // Inicie o temporizador ao pressionar o botão
                              startTimer();
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor: ischanged
                            ? MaterialStateProperty.all(const Color(0xff00afe9))
                            : MaterialStateProperty.all(Colors.grey),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      child: Text(
                        ischanged ? 'CONECTAR' : 'CONECTADO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ischanged ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  if (_showConfirmation)
                    const Row(
                      children: [
                        SizedBox(width: 20),
                        Icon(Icons.check_circle, color: Colors.green),
                      ],
                    )
                ],
              ),

              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedStore,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      // Definir a cor da borda quando em foco
                      color: Color(0xff00afe9), // Substitua pela cor desejada
                    ),
                  ),
                  label: const Text('Loja', style: TextStyle(fontSize: 20)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                hint: const Text('Selecione a loja'),
                onChanged: (newValue) {
                  setState(() {
                    _selectedStore = newValue!;
                    updateButtonState(); // Chama a função para verificar alterações
                  });
                },
                icon: Icon(Icons.arrow_drop_down),
                items: _stores.map<DropdownMenuItem<String>>((String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedPos,
                hint: const Text('Selecione o POS'),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      // Definir a cor da borda quando em foco
                      color: Color(0xff00afe9), // Substitua pela cor desejada
                    ),
                  ),
                  label: const Text('POS', style: TextStyle(fontSize: 20)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedPos = newValue!;
                    updateButtonState(); // Chama a função para verificar alterações
                  });
                },
                items: _poss.map<DropdownMenuItem<String>>((String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedDocInvoice,
                hint: const Text('Documento da faturação'),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        // Definir a cor da borda quando em foco
                        color: Color(0xff00afe9), // Substitua pela cor desejada
                      ),
                    ),
                    label: const Text('Documento para faturação', style: TextStyle(fontSize: 20)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDocInvoice = newValue!;
                    updateButtonState();
                  });
                },
                items: _invoices.map<DropdownMenuItem<String>>((String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedDocRefund,
                hint: const Text('Documento do reembolso'),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        // Definir a cor da borda quando em foco
                        color: Color(0xff00afe9), // Substitua pela cor desejada
                      ),
                    ),
                    label: const Text('Documento para reembolso', style: TextStyle(fontSize: 20)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDocRefund = newValue!;
                    updateButtonState();
                  });
                },
                items: _refunds.map<DropdownMenuItem<String>>((String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedDocCurrentAccount,
                hint: const Text('Documento da conta corrente'),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        // Definir a cor da borda quando em foco
                        color: Color(0xff00afe9), // Substitua pela cor desejada
                      ),
                    ),
                    label: const Text('Documento para conta corrente', style: TextStyle(fontSize: 20)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDocCurrentAccount = newValue!;
                    updateButtonState();
                  });
                },
                items: _cunrrentAccount
                    .map<DropdownMenuItem<String>>((String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value!),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20,),
              if (_isDropdownChanged)
                SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isButtonDisabled
                          ? Colors.grey
                          : const Color(0xff00afe9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    onPressed: _isButtonDisabled
                        ? null
                        : () {
                      if (_selectedStore != null && _selectedStore != 'Selecione a loja' &&
                          _selectedPos != null && _selectedPos != 'Selecione o POS' &&
                          _selectedDocInvoice != null && _selectedDocInvoice != 'Documento da faturação' &&
                          _selectedDocRefund != null && _selectedDocRefund != 'Documento do reembolso' &&
                          _selectedDocCurrentAccount != null && _selectedDocCurrentAccount != 'Documento da conta corrente') {
                        setState(() {
                          _isButtonDisabled = true;
                        });

                        // Lógica para confirmar seleção da loja e do POS
                        setup.nomeLoja = _selectedStore!;
                        setup.pos = _selectedPos!;
                        setup.faturacao = _selectedDocInvoice!;
                        setup.reembolso = _selectedDocRefund!;
                        setup.contaCorrente = _selectedDocCurrentAccount!;
                        print(database.getAllSetup().length);
                        //database.removeAllSetup();
                        database.addSetup(setup);
                        // Temporizador para reativar o botão após 5 segundos
                        Timer(const Duration(seconds: 5), () {
                          setState(() {
                            _isDropdownChanged =
                                _isButtonDisabled = false;
                          });
                        });
                      }
                    },
                    child: Text(
                      _isButtonDisabled ? 'SELECIONADO' : 'CONFIRMAR SELEÇÕES',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isButtonDisabled ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

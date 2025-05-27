import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/errors/errors_classes.dart';
import '../../../common/patterns/command.dart';
import '../../../common/domain/entities/student_info_entity.dart';

class EditingStudantForm extends StatefulWidget {
  final StudentInfoEntity student;
  final Command1<void, Failure, StudentInfoEntity> onSaveCommand;
  final VoidCallback onCancel;
  final VoidCallback toggleEditMode;

  const EditingStudantForm(
    {
      super.key,
      required this.student,
      required this.onSaveCommand,
      required this.onCancel,
      required this.toggleEditMode});

  @override
  State<EditingStudantForm> createState() => _EditingStudantFormState();
}

class _EditingStudantFormState extends State<EditingStudantForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late StudentInfoEntity _studant;

  @override
  void initState(){
    super.initState();
    _studant = widget.student;
    _nameController = TextEditingController(text: _studant.name);
    _ageController = TextEditingController(text: _studant.age.toString());
    _emailController = TextEditingController(text: _studant.email);
    _addressController = TextEditingController(text: _studant.address);
    _phoneController = TextEditingController(text: _studant.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Dados do Estudante',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _nameController,
              label: 'Nome Completo',
              icon: Icons.person,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _ageController,
              label: 'Idade',
              icon:Icons.cake,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                final age = int.tryParse(value);
                if(age == null || age <= 0) {
                  return 'Please enter a valid age';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'E-mail',
              icon:Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if(!RegExp(r'^[w-\.]+@([w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _addressController,
              label: 'Endereço',
              icon:Icons.location_on,
              maxLines: 2,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              }
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: 'Telefone',
              icon:Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              }
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 16),
                ListenableBuilder(
                  listenable: widget.onSaveCommand,
                  builder: (context, _) {
                    return ElevatedButton(
                      onPressed: widget.onSaveCommand.running
                        ? null 
                        : () async {
                          if(_formKey.currentState?.validate() ??
                          false) {
                            final updateInfo = StudentInfoEntity(
                              name: _nameController.text,
                              age: int.tryParse(_ageController.text) ?? 0,
                              email: _emailController.text,
                              address: _addressController.text,
                              phone: _phoneController.text
                            );

                            await widget.onSaveCommand
                              .execute(updateInfo);

                            widget.toggleEditMode();

                            if(widget.onSaveCommand.error) {
                              if(mounted) {
                                ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text('Erro ao salvar!')),
                                  );
                              }
                            } else {
                              if(mounted) {
                                ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Informações atualizadas com sucesso!',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                              }
                            }
                          }
                        },
                      child: widget.onSaveCommand.running
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.save),
                          SizedBox(width: 8),
                          Text('Salvar'),
                        ],
                      ),
                    );
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }
}
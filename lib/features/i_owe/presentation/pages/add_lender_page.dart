import 'package:flutter/material.dart';

import 'package:debts_app/core/domain/entities/person.dart';
import 'package:debts_app/core/locale/app_localizations.dart';
import 'package:debts_app/core/presentation/bloc/inherited_bloc.dart';
import 'package:debts_app/core/presentation/widgets/widgets.dart';
import 'package:debts_app/features/i_owe/presentation/bloc/add_lender_bloc.dart';

class AddLenderPage extends StatefulWidget {
  final Person person;

  const AddLenderPage({Key key, this.person}) : super(key: key);

  @override
  _AddLenderPageState createState() => _AddLenderPageState();
}

class _AddLenderPageState extends State<AddLenderPage> {
  Person _initialPerson;
  final AddLenderBloc _bloc = AddLenderBloc();
  final _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialPerson = widget.person;
    if (_initialPerson != null) {
      _editingController.text = _initialPerson.name;
      _bloc.changeName(_initialPerson.name);
    }
  }

  @override
  void dispose() {
    _bloc.dispose();
    _editingController.dispose();
    super.dispose();
  }

  Future<void> _saveLender() async {
    final bloc = InheritedBloc.of(context);
    if (_initialPerson == null) {
      final lender = Person(name: _bloc.name);
      await bloc.lendersBloc.addLender(lender);
    } else {
      final lender = _initialPerson.copyWith(name: _bloc.name);
      await bloc.lendersBloc.updateLender(lender);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlueHeaderContainer(
        child: Column(
          children: <Widget>[
            _buildHeader(context),
            Expanded(
              child: RoundedShadowContainer(
                child: _buildContent(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final text = _initialPerson != null
        ? 'Editar persona'
        : AppLocalizations.of(context).translate('add_person');
    return CustomAppBar(
      titleText: text,
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28.0, 28.0, 28.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[_buildTextField(), const Spacer(), _buildButton()],
      ),
    );
  }

  Widget _buildTextField() {
    return DecoratedTextField(
      autofocus: true,
      titleText: AppLocalizations.of(context).translate('name'),
      hintText: AppLocalizations.of(context).translate('name_hint'),
      controller: _editingController,
      textCapitalization: TextCapitalization.words,
      onChanged: _bloc.changeName,
    );
  }

  Widget _buildButton() {
    return StreamBuilder(
      stream: _bloc.nameStream,
      builder: (context, snapshot) {
        return LargeButton(
          onPressed: snapshot.hasData ? _saveLender : null,
        );
      },
    );
  }
}

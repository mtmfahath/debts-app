import 'package:debts_app/features/i_owe/presentation/bloc/add_loan_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:debts_app/core/data/models/index.dart';
import 'package:debts_app/core/locale/app_localizations.dart';
import 'package:debts_app/core/presentation/bloc/inherited_bloc.dart';
import 'package:debts_app/core/presentation/widgets/index.dart';
import 'package:debts_app/core/utils/index.dart' as utils;

class AddLoanPage extends StatefulWidget {
  final LenderModel lender;
  final LoanModel loan;

  const AddLoanPage({
    Key key,
    this.loan,
    @required this.lender,
  }) : super(key: key);

  @override
  _AddLoanPageState createState() => _AddLoanPageState();
}

class _AddLoanPageState extends State<AddLoanPage> {
  final AddLoanBloc _bloc = AddLoanBloc();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.loan != null) {
      final value = utils.formatCurrency(widget.loan.value, '#,###');
      final description = widget.loan.description;
      _bloc.changeValue(value);
      _bloc.changeNote(description);
    }
  }

  void _onSavePressed() {
    if (widget.loan != null) {
      _updateLoan();
    } else {
      _addLoan();
    }
  }

  Future<void> _addLoan() async {
    final bloc = InheritedBloc.of(context);
    final loan = LoanModel(
      lenderId: widget.lender.id,
      value: double.parse(_bloc.value),
      description: _bloc.note,
      date: DateTime.now().toString(),
    );
    await bloc.lendersBloc.addLoan(loan, widget.lender);
    Navigator.of(context).pop();
  }

  Future<void> _updateLoan() async {
    final bloc = InheritedBloc.of(context);
    final loan = LoanModel(
      id: widget.loan.id,
      lenderId: widget.lender.id,
      value: double.parse(_bloc.value),
      description: _bloc.note,
      date: widget.loan.date,
    );
    await bloc.lendersBloc.updateLoan(loan, widget.lender);
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(child: _buildContent()),
                    ),
                    _buildButton(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return CustomAppBar(
      titleText: widget.loan != null
          ? localizations.translate('edit_debt')
          : localizations.translate('add_debt'),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const FractionallySizedBox(widthFactor: 1.0),
          Text(
            AppLocalizations.of(context).translate('value'),
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6.0),
          _buildValueTextField(),
          const SizedBox(height: 24.0),
          Text(
            AppLocalizations.of(context).translate('note'),
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6.0),
          _buildNoteTextField(),
        ],
      ),
    );
  }

  Widget _buildValueTextField() {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: utils.Colors.towerGray),
      child: TextFormField(
        autofocus: true,
        initialValue: _bloc.value,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        cursorColor: utils.Colors.towerGray,
        onChanged: _bloc.changeValue,
        maxLength: 11,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          utils.NumberFormatter(),
        ],
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).translate('value_hint'),
          counterText: null,
        ),
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_focusNode);
        },
      ),
    );
  }

  Widget _buildNoteTextField() {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: utils.Colors.towerGray),
      child: TextFormField(
        focusNode: _focusNode,
        initialValue: _bloc.note,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: utils.Colors.towerGray,
        onChanged: _bloc.changeNote,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).translate('note_hint'),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return StreamBuilder<bool>(
      stream: _bloc.validStream,
      builder: (context, snapshot) {
        return Container(
          margin: const EdgeInsets.only(bottom: 30.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: FlatButton(
              onPressed:
                  snapshot.hasData && snapshot.data ? _onSavePressed : null,
              color: utils.Colors.brightGray,
              textColor: Colors.white,
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context).translate('save'),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

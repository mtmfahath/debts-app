import 'package:flutter/material.dart';
import 'package:debts_app/src/bloc/inherited_bloc.dart';
import 'package:debts_app/src/models/index.dart';
import 'package:debts_app/src/widgets/index.dart';
import 'package:debts_app/src/pages/add_loan/add_loan_page.dart';
import 'package:debts_app/src/pages/loans/widgets/loan_card.dart';
import 'package:debts_app/src/utils/index.dart' as utils;

class LoansPage extends StatelessWidget {
  final Debtor debtor;

  LoansPage({@required this.debtor});

  @override
  Widget build(BuildContext context) {
    final bloc = InheritedBloc.of(context);
    bloc.debtorsBloc.getDebtsByDebtor(debtor);

    return Scaffold(
      body: BlueHeaderContainer(
        child: Column(
          children: <Widget>[
            CustomAppBar(
              titleText: debtor.name,
            ),
            Expanded(
              child: RoundedShadowContainer(
                child: _buildContent(bloc),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 30.0),
        child: AddButton(
          onPressed: () => _addDebt(context),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildContent(InheritedBloc bloc) {
    return StreamBuilder(
      stream: bloc.debtorsBloc.debtsStream,
      builder: (BuildContext context, AsyncSnapshot<List<Debt>> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data.isEmpty) return _buildEmptyState();
          return ListView.builder(
            itemCount: data.length,
            padding: EdgeInsets.only(bottom: 110.0, top: 20.0),
            itemBuilder: (BuildContext context, int i) {
              return LoanCard(
                debt: data[i],
                onDismissed: (Debt d) => _deleteDebt(d, bloc),
              );
            },
          );
        } else {
          return _buildEmptyState();
        }
      },
    );
  }

  void _addDebt(BuildContext context) {
    Navigator.push(context, FadeRoute(page: AddLoanPage(debtor: debtor)));
  }

  void _deleteDebt(Debt debt, InheritedBloc bloc) async {
    await bloc.debtorsBloc.deleteDebt(debt, debtor);
    await bloc.debtorsBloc.getDebtsByDebtor(debtor);
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.sentiment_satisfied,
      message: 'No tienes deudas pendientes',
    );
  }
}

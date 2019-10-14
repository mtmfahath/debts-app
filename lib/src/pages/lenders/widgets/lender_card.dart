import 'package:flutter/material.dart';

import 'package:debts_app/src/models/index.dart';
import 'package:debts_app/src/utils/index.dart' as utils;

class LenderCard extends StatelessWidget {
  final Lender lender;
  final Function(Lender) onTap;
  final Function(Lender) onDismissed;

  LenderCard({this.lender, this.onTap, this.onDismissed});

  void _onTap() {
    onTap(lender);
  }

  void _onDismissed(DismissDirection direction) {
    onDismissed(lender);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: _onDismissed,
        direction: DismissDirection.endToStart,
        dismissThresholds: {DismissDirection.startToEnd: 200.0},
        background: _buildDismissibleBackground(),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0.0, 6.0),
                blurRadius: 6.0,
                spreadRadius: 4.0,
                color: Color.fromRGBO(0, 0, 0, 0.03),
              ),
            ],
          ),
          child: Material(
            color: utils.Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: _onTap,
              child: _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.symmetric(horizontal: 26.0, vertical: 5.0),
      child: Icon(Icons.delete, color: utils.Colors.towerGray,),
    );
  }

  Container _buildContent() {
    final debt = utils.formatCurrency(lender.loan);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: utils.Colors.athensGray,
            child: Text(
              lender.getInitials(),
              style: TextStyle(
                color: utils.Colors.towerGray,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              lender.name,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 12.0,
          ),
          Text(
            debt,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

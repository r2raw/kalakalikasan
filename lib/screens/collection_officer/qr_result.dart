import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kalakalikasan/provider/manual_collection_provider.dart';
import 'package:kalakalikasan/provider/user_qr_provider.dart';
import 'package:kalakalikasan/screens/collection_officer/collect_materials.dart';
import 'package:kalakalikasan/screens/collection_officer/material_selections.dart';
import 'package:kalakalikasan/screens/collection_officer/physical_cashout.dart';
import 'package:kalakalikasan/screens/eco_actor/officer_claim_receipt.dart';
import 'package:kalakalikasan/util/text_casing.dart';
import 'package:kalakalikasan/widgets/error_single.dart';

class QrResultScreen extends ConsumerStatefulWidget {
  const QrResultScreen({super.key});

  @override
  ConsumerState<QrResultScreen> createState() {
    return _QrResultScreen();
  }
}

class _QrResultScreen extends ConsumerState<QrResultScreen> {
  String? _error;
  void _onWithdraw() {
    final userInfo = ref.read(userQrProvider);
    final points = userInfo[UserQr.points];

    if (points < 100) {
      setState(() {
        _error = 'Insufficient points.';
      });
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _error = null;
        });
      });

      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => QrResultScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.read(userQrProvider);
    final fullName =
        '${userInfo[UserQr.firstName]} ${userInfo[UserQr.lastName]}';
    final points = userInfo[UserQr.points];
    return Container(
      margin: EdgeInsets.only(bottom: 100),
      child: Center(
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: (MediaQuery.of(context).size.width * 0.8),
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        toTitleCase(fullName),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/token-img.png',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            points.toString(),
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  children: [
                    if(_error != null)ErrorSingle(errorMessage: _error),
                    ElevatedButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                      onPressed: _onWithdraw,
                      label: Text('Withdraw'),
                      icon: Icon(IonIcons.cash),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => OfficerClaimReceiptScreen()));
                      },
                      label: Text('Claim receipt'),
                      icon: Icon(Icons.receipt_long),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                      onPressed: () {
                        ref.read(manualCollectProvider.notifier).reset();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => CollectMaterialsScreen()));
                      },
                      label: Text('Collect materials'),
                      icon: Icon(Clarity.recycle_line),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

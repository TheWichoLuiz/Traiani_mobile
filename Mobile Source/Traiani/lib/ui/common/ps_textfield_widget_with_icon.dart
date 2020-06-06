import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';

class PsTextFieldWidgetWithIcon extends StatelessWidget {
  const PsTextFieldWidgetWithIcon(
      {this.textEditingController,
      this.hintText,
      this.height = PsDimens.space44,
      this.keyboardType = TextInputType.text,
      this.psValueHolder});

  final TextEditingController textEditingController;
  final String hintText;
  final double height;
  final TextInputType keyboardType;
  final PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    final ProductParameterHolder productParameterHolder =
        ProductParameterHolder().getLatestParameterHolder();
    final Widget _productTextFieldWidget = TextField(
        keyboardType: TextInputType.text,
        maxLines: null,
        controller: textEditingController,
        style: Theme.of(context).textTheme.body1,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: PsDimens.space12,
            bottom: PsDimens.space8,
            top: PsDimens.space10,
          ),
          border: InputBorder.none,
          hintText: hintText,
          suffixIcon: InkWell(
              child: Icon(
                Icons.search,
                color: Colors.red,
              ),
              onTap: () {
                productParameterHolder.searchTerm = textEditingController.text;
                productParameterHolder.lat = psValueHolder.locationLat;
                productParameterHolder.lng = psValueHolder.locationLng;
                productParameterHolder.mile = PsConst.MAP_MILES;
                Utils.psPrint(productParameterHolder.searchTerm);
                Navigator.pushNamed(context, RoutePaths.filterProductList,
                    arguments: ProductListIntentHolder(
                        appBarTitle: Utils.getString(
                            context, 'home_search__app_bar_title'),
                        productParameterHolder: productParameterHolder));
              }),
        ));

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: height,
          margin: const EdgeInsets.all(PsDimens.space12),
          decoration: BoxDecoration(
            color: Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
            borderRadius: BorderRadius.circular(PsDimens.space4),
            border: Border.all(
                color: Utils.isLightMode(context)
                    ? Colors.grey[200]
                    : Colors.black87),
          ),
          child: _productTextFieldWidget,
        ),
      ],
    );
  }
}

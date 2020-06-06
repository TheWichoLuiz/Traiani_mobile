// import 'package:flutterbuyandsell/config/ps_colors.dart';
// import 'package:flutterbuyandsell/constant/ps_dimens.dart';

// import 'package:flutterbuyandsell/viewobject/holder/tag_object_holder.dart';
// import 'package:flutter/material.dart';

// class RelatedTagsHorizontalListItem extends StatelessWidget {
//   const RelatedTagsHorizontalListItem({
//     Key key,
//     @required this.tagParameterHolder,
//     @required this.onTap,
//   }) : super(key: key);

//   final TagParameterHolder tagParameterHolder;
//   final Function onTap;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         onTap();
//       },
//       // child:
//       // Card(
//       //   elevation: 0,
//       // shape: const BeveledRectangleBorder(
//       //   borderRadius: BorderRadius.all(Radius.circular(7.0)),
//       // ),
//       child: Card(
//         elevation: 0,
//         shape: BeveledRectangleBorder(
//             side: BorderSide(color: PsColors.mainColor, width: 0.6),
//             borderRadius: const BorderRadius.all(Radius.circular(7.0))),
//         child: Container(
//           margin: const EdgeInsets.all(PsDimens.space4),
//           padding: const EdgeInsets.only(left: PsDimens.space8, right: PsDimens.space8),

//           // decoration:
//           //     UnderlineTabIndicator(borderSide: BorderSide(color: Colors.red), ),

//           // foregroundDecoration: ShapeDecoration(
//           //   shape: const BeveledRectangleBorder(
//           //     borderRadius: BorderRadius.all(Radius.circular(7.0)),
//           //   ),
//           // ),
//           // decoration: ShapeDecoration(
//           //   shape:
//           // )
//           // // BoxDecoration(
//           // color: Utils.isLightMode(context) ? Colors.white : Colors.black12,

//           // borderRadius: const BeveledRectangleBorder(
//           //     left: Radius.circular(PsDimens.space8)),
//           // shape: BoxShape.circle,
//           //borderRadius: BorderRadiusTween(begin: const BorderRadius.only(topLeft: Radius.circular(PsDimens.space8))),
//           // border: Border.all(
//           //     color: PsColors.mainColor, width: PsDimens.space1)
//           // ),
//           child: Center(
//             child: Text(
//               tagParameterHolder.tagName,
//               style: Theme.of(context).textTheme.body1.copyWith(color: PsColors.mainColor),
//             ),
//           ),
//         ),
//       ),
//       // ),
//     );
//   }
// }

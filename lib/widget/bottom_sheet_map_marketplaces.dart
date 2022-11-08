import 'package:egorka/core/bloc/market_place/market_place_bloc.dart';
import 'package:egorka/helpers/text_style.dart';
import 'package:egorka/model/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottomMarketPlacesMap extends StatefulWidget {
  TextEditingController fromController;
  PanelController panelController;
  BottomMarketPlacesMap({
    Key? key,
    required this.fromController,
    required this.panelController,
  });

  @override
  State<BottomMarketPlacesMap> createState() =>
      _BottomMarketPlacesMaptate();
}

class _BottomMarketPlacesMaptate
    extends State<BottomMarketPlacesMap> {
  FocusNode focusFrom = FocusNode();

  Address? address;

  @override
  Widget build(BuildContext context) {
    return _floatingPanel(context);
  }

  Widget _floatingPanel(BuildContext context) {
    // var bloc = BlocProvider.of<MarketPlacePageBloc>(context);
    return Container(
      margin:
          MediaQuery.of(context).viewInsets + const EdgeInsets.only(top: 15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Colors.black12,
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 10,
                left: (MediaQuery.of(context).size.width * 45) / 100,
                right: (MediaQuery.of(context).size.width * 45) / 100,
                bottom: 10),
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey,
              ),
            ),
          ),
          Text('Выберите адрес', style: CustomTextStyle.black15w700,)
          
        ],
      ),
    );
  }

  Widget _searchList() {
    return Column(
      children: [
        const SizedBox(height: 10),
        SizedBox(
          height: 215,
          child: BlocBuilder<MarketPlacePageBloc, MarketPlaceState>(
            buildWhen: (previous, current) {
              if (current is MarketPlaceSuccess) {
                address = current.address;
              }
              return true;
            },
            builder: ((context, state) {
              if (state is MarketPlaceStated) {
                return const SizedBox();
              } else if (state is MarketPlaceLoading) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                );
              } else if (state is MarketPlaceSuccess) {
                return address != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: state.address!.result.suggestions!.length,
                          itemBuilder: (context, index) {
                            return _pointCard(state, index, context);
                          },
                        ),
                      )
                    : Container();
              } else {
                return const Text('');
              }
            }),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Container _pointCard(
      MarketPlaceSuccess state, int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      height: 50,
      child: InkWell(
        onTap: () {
          widget.fromController.text =
              state.address!.result.suggestions![index].name;
          BlocProvider.of<MarketPlacePageBloc>(context).add(
              MarketPlaceStatedCloseBtmSheet(
                  state.address!.result.suggestions![index].name));

          focusFrom.unfocus();
          widget.panelController.close();
        },
        child: Row(
          children: [
            // Expanded(
            //     flex: 1,
            //     child: Align(
            //         alignment: Alignment.centerLeft,
            //         child: CustomWidget.iconGPSSmall(
            //             color: widget.typeAdd == TypeAdd.sender
            //                 ? Colors.red
            //                 : Colors.blue))),
            const SizedBox(width: 15),
            Expanded(
              flex: 10,
              child: Text(
                state.address!.result.suggestions![index].name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

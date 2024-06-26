import 'package:appartapp/entities/like_from_user.dart';
import 'package:appartapp/utils_classes/runtime_store.dart';
import 'package:appartapp/widgets/tab_widget_lessor.dart';
import 'package:appartapp/widgets/tab_widget_loading.dart';
import 'package:appartapp/widgets/tab_widget_tenant.dart';
import 'package:appartapp/widgets/tenant_model.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TenantViewer extends StatefulWidget {
  final bool tenantLoaded;
  final bool lessor; //if you want to visualize a lessor set true,
  final LikeFromUser? currentLikeFromUser;
  final Function(bool value) updateUI;
  final bool match;

  const TenantViewer(
      {Key? key,
      required this.tenantLoaded,
      required this.lessor,
      this.currentLikeFromUser,
      required this.updateUI,
      required this.match})
      : super(key: key);

  @override
  _TenantViewer createState() => _TenantViewer();
}

class _TenantViewer extends State<TenantViewer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: RuntimeStore.backgroundColor,
        child: RuntimeStore().useMobileLayout
            ? mobileLayout(widget.tenantLoaded, widget.lessor, widget.match,
                widget.currentLikeFromUser, widget.updateUI)
            : tabletLayout(widget.tenantLoaded, widget.lessor, widget.match,
                widget.currentLikeFromUser, widget.updateUI));
  }
}

SlidingUpPanel mobileLayout(bool tenantLoaded, lessor, match,
    LikeFromUser? currentLikeFromUser, Function(bool value) updateUI) {
  return SlidingUpPanel(
    color: Colors.transparent.withOpacity(0.7),
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    ),
    isDraggable: tenantLoaded && currentLikeFromUser != null,
    panelBuilder: (scrollController) =>
    !tenantLoaded
        ? const TabWidgetLoading()
        : (lessor
            ? TabWidgetLessor(
                scrollController: scrollController,
                currentLessor: currentLikeFromUser!.user)
            : TabWidgetTenant(
                scrollController: scrollController,
                currentTenant: currentLikeFromUser!.user,
                apartment: currentLikeFromUser.apartment,
                match: match,
                updateUi: updateUI,
              )),
    body: tenantLoaded
        ? TenantModel(
            currentTenant: currentLikeFromUser!.user,
            lessor: lessor,
            match: match)
        : const Center(
            child: CircularProgressIndicator(
            value: null,
          )),
    defaultPanelState:
        lessor || !tenantLoaded ? PanelState.CLOSED : PanelState.OPEN,
  );
}

Row tabletLayout(tenantLoaded, lessor, match, currentLikeFromUser, updateUI) {
  return Row(children: [
    Expanded(
      flex: 100,
      child: tenantLoaded
          ? TenantModel(
              currentTenant: currentLikeFromUser!.user,
              lessor: lessor,
              match: match)
          : const Center(
              child: CircularProgressIndicator(
              value: null,
            )),
    ),
    Expanded(
        flex: 1,
        child: Blur(
            child: Container(
          color: Colors.brown,
        ))),
    Expanded(
      flex: 50,
      child: !tenantLoaded
          ? const TabWidgetLoading()
          : lessor
              ? TabWidgetLessor(
                  scrollController: ScrollController(),
                  currentLessor: currentLikeFromUser!.user)
              : TabWidgetTenant(
                  scrollController: ScrollController(),
                  currentTenant: currentLikeFromUser!.user,
                  apartment: currentLikeFromUser.apartment,
                  match: match,
                  updateUi: updateUI,
                ),
    )
  ]);
}

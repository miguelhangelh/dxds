part of 'global_widget.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  UserPreference userPreference = UserPreference();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Container(
        color: Colors.white,
        child: ListView(
          primary: true,
          shrinkWrap: true,
          children: <Widget>[
            Container(
              height: 72,
              color: Colors.white,
              child: DrawerHeader(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () async {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('home');
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (userPreference.getUserMenu?.profile?.pathPhoto != null)
                          ? photoUser()
                          : Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: ExactAssetImage('assets/user.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userPreference.getUserMenu?.profile?.firstName ?? 'Invitado',
                              style: TextStyle(fontSize: 10.0.sp, color: Colors.black, fontWeight: FontWeight.w500)),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: primaryColor,
                                size: 13,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                userPreference.getUserMenu?.ratingPercentage ?? "0.0",
                                style: TextStyle(fontSize: 10.0.sp, color: Colors.black, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Text(
                            'Mi Cuenta',
                            style: TextStyle(fontSize: 10.0.sp, color: primaryColor, fontWeight: FontWeight.w400),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            itemMenu(
              context,
              route: 'opportunity',
              event: const OpportunityPage(),
              title: 'Oportunidades',
              initialRoute: ModalRoute.of(context)!.settings.name == "/",
              icon: 'search',
              iconData: Icons.search,
            ),
            userPreference.transportUnit != null
                ? itemMenu(context,
                    route: TravelPastPage.routeName,
                    title: 'Operaciones',
                    event: const OperationPage(),
                    icon: 'activity',
                    iconData: Icons.folder_open_outlined)
                : const SizedBox.shrink(),
            userPreference.transportUnit != null
                ? itemMenu(context,
                    route: 'notification',
                    title: 'Notificaciones',
                    event: OperationPageState(),
                    iconData: Icons.notifications_none,
                    icon: 'notification')
                : const SizedBox.shrink(),
            itemMenu(
              context,
              route: 'benefits',
              title: 'Beneficios',
              icon: 'gifts',
              iconData: Icons.wallet_giftcard_outlined,
              event: OperationPageState(),
            ),
            userPreference.transportUnit != null
                ? itemMenu(
                    context,
                    route: 'payment',
                    title: 'Mis pagos',
                    icon: 'wallet',
                    iconData: Icons.account_balance_wallet_outlined,
                    event: OperationPageState(),
                  )
                : const SizedBox.shrink(),
            itemMenu(
              context,
              route: 'Soporte',
              title: 'Soporte',
              event: OperationPageState(),
              icon: 'whatsapp',
              iconData: Icons.contact_support,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: CustomSubTitleWidget(
                text: dotenv.env['VERSION'],
                color: Colors.black45,
                size: 8.0.sp, //13px
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  CachedNetworkImage photoUser() {
    return CachedNetworkImage(
      imageUrl: photoHasToken(userPreference.getUserMenu?.profile?.pathPhoto ?? ""),
      imageBuilder: (context, imageProvider) => Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFD9D9D9),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(11),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
        ),
        child: const Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child:
                CircularProgressIndicator(backgroundColor: Colors.white, strokeWidth: 5.0, valueColor: AlwaysStoppedAnimation<Color>(primaryColor)),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent,
          ),
          image: const DecorationImage(
            image: ExactAssetImage('assets/user.jpg'),
            fit: BoxFit.cover,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
        ),
      ),
    );
  }

  Widget itemMenu(
    BuildContext context, {
    required String route,
    bool initialRoute = false,
    required dynamic event,
    required String title,
    String icon = 'search',
    IconData? iconData,
  }) {
    // final AuthenticationState state = context.watch<AuthenticationBloc>().state;
    return Container(
      color: initialRoute
          ? const Color(0xfffdf2e6)
          : _isSelect(route, context)
              ? const Color(0xfffdf2e6)
              : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: ListTile(
          selected: _isSelect(route, context),
          title: Row(
            children: [
              Icon(
                iconData,
                color: initialRoute
                    ? primaryColor
                    : _isSelect(route, context)
                        ? primaryColor
                        : const Color(0xffBCBCBC),
                size: 30,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                title,
                style: TextStyle(
                  color: initialRoute
                      ? Colors.black
                      : _isSelect(route, context)
                          ? Colors.black
                          : const Color(0xffBCBCBC),
                  fontSize: 14.0.sp,
                  fontWeight: initialRoute
                      ? FontWeight.w600
                      : _isSelect(route, context)
                          ? FontWeight.w600
                          : FontWeight.w500,
                ),
              ),
            ],
          ),
          onTap: () async {
            if (route == 'Soporte') {
              var url = "whatsapp://send?phone=+59176699908&text=Hola! me gustaría recibir asistencia sobre la App DeltaX.";
              _launchInBrowser(url, context);
              return;
            }
            Navigator.pop(context);
            await Navigator.pushNamed(context, route);
          },
        ),
      ),
    );
  }
}

bool _isSelect(String routeName, BuildContext context) {
  return ModalRoute.of(context)!.settings.name == routeName;
}

Future<void> _launchInBrowser(String url, context) async {
  await launch(url);
}

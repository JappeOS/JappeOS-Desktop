//  JappeOS-Desktop, The desktop environment for JappeOS.
//  Copyright (C) 2025  Jappe02
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.

// ignore_for_file: library_private_types_in_public_api

part of jappeos_desktop.base;

typedef LoginError = String;
typedef UserList = List<String>;

class LoginScreen extends StatefulWidget {
  final UserList usersList;
  final LoginError? Function(String username, String password) onLogin;

  const LoginScreen({Key? key, required this.usersList, required this.onLogin}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _timeString = '';
  Timer? _timer;
  Timer? _backToMainPageTimer;
  _Page _currentPage = _Page.main;
  bool _initialBaseBuild = true;
  String _selectedUser = "";
  String _currentPassword = "";
  LoginError? _currentLoginError;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    final formattedTime = DateFormat('HH:mm').format(now);
    setState(() {
      _timeString = formattedTime;
    });
  }

  void _beginBackToMainPageTimer() {
    _backToMainPageTimer?.cancel();
    _backToMainPageTimer = Timer(const Duration(seconds: 15), () => setState(() => _currentPage = _Page.main));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _backToMainPageTimer?.cancel();
    super.dispose();
  }

  Widget _buildBase(Widget child) {
    final w = WidgetAnimator(
      incomingEffect: _initialBaseBuild ? null : WidgetTransitionEffects.incomingSlideInFromBottom(),
      outgoingEffect: WidgetTransitionEffects.outgoingSlideOutToTop(),
      child: child,
    );
    _initialBaseBuild = false;
    return w;
  }

  Widget _buildMainPage() => Column(
    key: const ValueKey('main-page'),
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: BPPresets.medium,
    children: [
      Text(
        _timeString,
        style: Theme.of(context).textTheme.displayMedium,
      ),
      TextAnimator(
        "Press any key to unlock.",
        atRestEffect: WidgetRestingEffects.wave(),
      ),
    ],
  );

  Widget _buildUsersList() => Center(
    child: Material(
      key: const ValueKey('users-list'),
      color: Colors.transparent,
      child: SizedBox(
        width: 250,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.usersList.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(left: BPPresets.small, right: BPPresets.small, bottom: BPPresets.small),
            child: ListTile(
              leading: const Icon(Icons.account_circle_rounded),
              title: Text(widget.usersList[index]),
              onTap: () => setState(() {
                _currentPage = _Page.user;
                _selectedUser = widget.usersList[index];
                _beginBackToMainPageTimer();
              }),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildUserPage() => Column(
    key: const ValueKey('user-page'),
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Icon(
        Icons.account_circle_rounded,
        size: 100,
      ),
      const SizedBox(height: BPPresets.small),
      Text(
        _selectedUser,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: BPPresets.medium),
      SizedBox(
        width: 250,
        child: TextField(
          decoration: InputDecoration(
            hintText: "Password",
            errorText: _currentLoginError,
          ),
          textAlign: TextAlign.center,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          autofocus: true,
          onChanged: (str) {
            _currentPassword = str;
            _beginBackToMainPageTimer();
          },
          onSubmitted: (p0) {
            _currentPassword = p0;
            _currentLoginError = widget.onLogin(_selectedUser, _currentPassword);
          },
        ),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    if (_currentPage == _Page.user) _currentLoginError = null;

    return TapRegion(
      onTapInside: (_) {
        if (_currentPage == _Page.main) {
          setState(() {
            _currentPage = _Page.list;
            _beginBackToMainPageTimer();
          });
        }
      },
      child: ShadeContainer.transparent(
        backgroundBlur: true,
        child: _buildBase(switch (_currentPage) {
          _Page.main => _buildMainPage(),
          _Page.list => _buildUsersList(),
          _Page.user => _buildUserPage(),
        }),
      ),
    );
  }
}

enum _Page {
  main,
  list,
  user,
}
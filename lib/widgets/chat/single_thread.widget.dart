import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_mobile/enum/roles.enum.dart';
import 'package:varenya_mobile/models/chat/chat_thread/chat_thread.dart';
import 'package:varenya_mobile/models/user/server_user.model.dart';
import 'package:varenya_mobile/pages/chat/chat_page.dart';
import 'package:varenya_mobile/providers/user_provider.dart';
import 'package:varenya_mobile/services/user_service.dart';
import 'package:varenya_mobile/utils/palette.util.dart';
import 'package:varenya_mobile/widgets/common/profile_picture_widget.dart';

import '../../exceptions/server.exception.dart';
import '../../utils/logger.util.dart';

class SingleThread extends StatefulWidget {
  final ChatThread chatThread;

  const SingleThread({
    Key? key,
    required this.chatThread,
  }) : super(key: key);

  @override
  _SingleThreadState createState() => _SingleThreadState();
}

class _SingleThreadState extends State<SingleThread> {
  ServerUser? _user;

  late final UserService _userService;

  @override
  void initState() {
    super.initState();

    this._userService = Provider.of<UserService>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder:
          (BuildContext context, UserProvider userProvider, Widget? child) {
        String requiredUserId = this.widget.chatThread.participants.firstWhere(
              (element) => element != userProvider.user.uid,
            );
        return FutureBuilder(
          future: this._userService.findUserById(
                requiredUserId,
              ),
          builder: _buildServerUserFuture,
        );
      },
    );
  }

  Widget _buildServerUserFuture(
    BuildContext context,
    AsyncSnapshot<ServerUser> snapshot,
  ) {
    if (snapshot.hasError) {
      switch (snapshot.error.runtimeType) {
        case ServerException:
          {
            ServerException exception = snapshot.error as ServerException;
            return Text(exception.message);
          }
        default:
          {
            log.e(
              "SingleThread Error",
              snapshot.error,
              snapshot.stackTrace,
            );
            return Text("Something went wrong, please try again later");
          }
      }
    }

    if (snapshot.connectionState == ConnectionState.done) {
      this._user = snapshot.data!;

      return _buildThread();
    }

    return this._user == null ? _onLoadingData() : this._buildThread();
  }

  Widget _onLoadingData() {
    return ListTile(
      leading: ProfilePictureWidget(
        imageUrl: '',
        size: MediaQuery.of(context).size.width * 0.2,
      ),
      title: Container(
        height: MediaQuery.of(context).size.height * 0.06,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.01,
              width: MediaQuery.of(context).size.width * 0.2,
              color: Palette.secondary,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.01,
              width: MediaQuery.of(context).size.width * 0.5,
              color: Palette.secondary,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.01,
              width: MediaQuery.of(context).size.width * 0.5,
              color: Palette.secondary,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.01,
              width: MediaQuery.of(context).size.width * 0.5,
              color: Palette.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThread() {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          ChatPage.routeName,
          arguments: this.widget.chatThread.id,
        );
      },
      leading: ProfilePictureWidget(
        imageUrl: _getImageUrl(),
        size: MediaQuery.of(context).size.width * 0.2,
      ),
      title: _getUserName(),
      subtitle: Text(
        _getLatestMessage(),
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }

  String _getLatestMessage() => this.widget.chatThread.messages.length > 0
      ? this.widget.chatThread.messages.last.message
      : "";

  Text _getUserName() {
    return this._user!.role == Roles.MAIN
        ? Text(
            this._user!.randomName!.randomName,
            style: TextStyle(
              color: Colors.white,
            ),
          )
        : Text(
            "Dr. ${this._user!.doctor!.fullName}",
            style: TextStyle(
              color: Colors.white,
            ),
          );
  }

  String _getImageUrl() =>
      this._user!.role == Roles.MAIN ? '' : this._user!.doctor!.imageUrl;
}

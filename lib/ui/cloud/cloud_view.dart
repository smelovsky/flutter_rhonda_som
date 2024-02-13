import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../freezed/responses/movie_response.dart';
import '../../providers/settings_notifier_provider.dart';
import '../../utils/validators.dart';
import 'cloud_bloc.dart';



class CloudView extends StatefulWidget {
  final WidgetRef ref;

  const CloudView(this.ref, {Key? key}) : super(key: key);

  final String restorationId = 'password_field';

  @override
  _CloudViewState createState() => _CloudViewState();
}

class _CloudViewState extends State<CloudView> with RestorationMixin  {
  CloudBloc? _cloudBloc;

  TextEditingController? _phoneEditingController;
  TextEditingController? _hostEditingController;
  TextEditingController? _emailEditingController;
  TextEditingController? _passwordEditingController;

  final RestorableBool _obscureText = RestorableBool(true);

  @override
  void dispose(){
    _phoneEditingController?.dispose();
    _hostEditingController?.dispose();
    _emailEditingController?.dispose();
    _passwordEditingController?.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _cloudBloc =  BlocProvider.of<CloudBloc>(context);

    final url = (widget.ref.read(settingsProvider).isCloudTestMode)
      ? widget.ref.read(settingsProvider).restUrlTest
      : widget.ref.read(settingsProvider).restUrlRhondaCloud;

    final email = (widget.ref.read(settingsProvider).isCloudTestMode)
        ? widget.ref.read(settingsProvider).restEmailTest
        : widget.ref.read(settingsProvider).restEmailRhondaCloud;

    final password = (widget.ref.read(settingsProvider).isCloudTestMode)
        ? widget.ref.read(settingsProvider).restPasswordTest
        : widget.ref.read(settingsProvider).restPasswordRhondaCloud;

    _phoneEditingController = TextEditingController(text: '(908) 440-7619');
    _hostEditingController = TextEditingController(text: url);
    _emailEditingController = TextEditingController(text: email);
    _passwordEditingController = TextEditingController(text: password);

  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_obscureText, 'obscure_text');
  }

  @override
  Widget build(BuildContext context) {

    final isCloudTestMode = widget.ref.read(settingsProvider).isCloudTestMode;

    return BlocConsumer<CloudBloc, CloudState>(
      bloc: _cloudBloc,
      listener: (BuildContext context, CloudState cloudState) {
        if (cloudState.viewState == CloudViewState.failed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Connection failed"), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        } else {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar();
        }
      },

      builder: (context, cloudState) {

        if (isCloudTestMode) {

          switch(cloudState.viewState) {

            case CloudViewState.initial:
            case CloudViewState.aborted:
            case CloudViewState.failed:
              return _initialViewCloudTestMode();

            case CloudViewState.inprogress:
              return _inprogressViewCloudTestMode();

            case CloudViewState.success:
              //return _successCloudTestMode(cloudState.result);
              return _successCloudTestMode(cloudState.list);

            default:
              return Container();
          }

        } else {

          return Container();
        }

      },
    );
    //);
  }

////////////////////////////////////////////////////////////////////////////////

  Widget _hostViewCloudTestMode() {
    return TextFormField(
            controller: _hostEditingController,
            autovalidateMode : AutovalidateMode.always,
            validator: (str) => isValidHost(str) ? null : 'Invalid hostname',
            decoration: InputDecoration(
              helperText: 'The ip address or hostname of the TCP server',
              hintText: 'Enter the address here, e. g. 10.0.2.2',
            ),
    );
  }

  Widget _actionViewCloudTestMode() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        child: Text('Connect'),
        onPressed: isValidHost(_hostEditingController!.text)
            ? () {
          _cloudBloc!.add(
              ConnectTestCloudEvent(
                host: _hostEditingController!.text,
              )
          );

        }
            : null,
      ),
    );
  }

  Widget _initialViewCloudTestMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Column(
        children: [
          _hostViewCloudTestMode(),
          _actionViewCloudTestMode(),
        ],
      ),
    );
  }

  Widget _inprogressViewCloudTestMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Connecting...'),
          ),

          ElevatedButton(
            child: Text('Abort'),
            onPressed: () {
              _cloudBloc?.add(AbortTestCloudEvent());
            },
          )
        ],
      ),
    );
  }

  Widget _successCloudTestMode(List<MovieResponse> list) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Column(
        children: [
          _hostViewCloudTestMode(),
          _actionViewCloudTestMode(),
          //Flexible(
          //  child:Text(result),
          //),
          Flexible(
            child:
            Center(
              child:
              ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(list[index].name.toString()),
                      subtitle: Text(list[index].createdby.toString()),
                    );
                  }
              )
            ),
          ),

        ],
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////

}

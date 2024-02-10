import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  final _UsNumberTextInputFormatter _phoneNumberFormatter =
  _UsNumberTextInputFormatter();

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
              return _successCloudTestMode(cloudState.result);

            default:
              return Container();
          }

        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Column(
              children: [
/*
              TextFormField(
                controller: _phoneEditingController,
                autovalidateMode : AutovalidateMode.always,
                validator: (str) => isValidPhoneNumber(str) ? null : 'Invalid phone number',
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  // Fit the validating format.
                  _phoneNumberFormatter,
                ],
                decoration: InputDecoration(
                  helperText: 'Phone number',
                  hintText: 'Phone number for SMS',
                  prefixText: '+7 ',
                ),
                maxLength: 14,
                maxLengthEnforcement: MaxLengthEnforcement.none,
                keyboardType: TextInputType.phone,
              ),
*/
                TextFormField(
                  controller: _hostEditingController,
                  autovalidateMode : AutovalidateMode.always,
                  validator: (str) => isValidHost(str) ? null : 'Invalid hostname',
                  decoration: InputDecoration(
                    helperText: 'The ip address or hostname of the TCP server',
                    hintText: 'Enter the address here, e. g. 10.0.2.2',
                  ),
                ),

                TextFormField(
                  controller: _emailEditingController,
                  autovalidateMode : AutovalidateMode.always,
                  validator: (str) => isValidEmail(str) ? null : 'Invalid email',
                  decoration: InputDecoration(
                    helperText: 'Email',
                    hintText: 'Enter email here, e. g. test@test.com',
                  ),
                ),

                TextFormField(
                  controller: _passwordEditingController,
                  autovalidateMode : AutovalidateMode.always,
                  //validator: (str) => isValidPassword(str) ? null : 'Invalid password',
                  obscureText: _obscureText.value,
                  decoration: InputDecoration(

                    helperText: 'Password',
                    hintText: 'Enter password here, e. g. test',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText.value = !_obscureText.value;
                        });
                      },
                      hoverColor: Colors.transparent,
                      icon: Icon(
                        _obscureText.value ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    child: Text('Login'),
                    onPressed: isValidHost(_hostEditingController!.text)
                        ? () {
                      _cloudBloc!.add(
                          LoginCloudEvent(
                            host: _hostEditingController!.text,
                            email: _emailEditingController!.text,
                            password: _passwordEditingController!.text,
                          )
                      );

                    }
                        : null,
                  ),
                ),

              ],
            ),
          );
        }

      },
    );
    //);
  }

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

  Widget _successCloudTestMode(String result) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Column(
        children: [
          _hostViewCloudTestMode(),
          _actionViewCloudTestMode(),
          Flexible(
            child:Text(result),
          ),
        ],
      ),
    );
  }

}

/// Format incoming numeric text to fit the format of (###) ###-#### ##
class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newTextLength = newValue.text.length;
    final newText = StringBuffer();
    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write('${newValue.text.substring(0, usedSubstringIndex = 3)}) ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write('${newValue.text.substring(3, usedSubstringIndex = 6)}-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write('${newValue.text.substring(6, usedSubstringIndex = 10)} ');
      if (newValue.selection.end >= 10) selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
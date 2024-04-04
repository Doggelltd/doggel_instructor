// ignore_for_file: use_build_context_synchronously

import 'package:doggel_instructor/models/common_functions.dart';
import 'package:doggel_instructor/models/zoom_settings.dart';
import 'package:doggel_instructor/providers/fetch_data.dart';
import 'package:doggel_instructor/providers/shared_pref_helper.dart';
import 'package:doggel_instructor/widgets/custom_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';

class ZoomSettingsScreen extends StatefulWidget {
  const ZoomSettingsScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ZoomSettingsScreenState createState() => _ZoomSettingsScreenState();
}

class _ZoomSettingsScreenState extends State<ZoomSettingsScreen> {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool hidePassword = true;
  bool _isLoading = false;
  bool _isInit = true;
  ZoomSettings zoomSettings = ZoomSettings();

  final sdkKeyController = TextEditingController();
  final sdkSecretController = TextEditingController();
  final zoomEmailController = TextEditingController();
  final zoomPasswordController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<FetchData>(context).fetchZoomSettings().then((_) {
        setState(() {
          zoomSettings =
              Provider.of<FetchData>(context, listen: false).zoomSettings;
        });
        if (zoomSettings.status == 200) {
          sdkKeyController.text = '${zoomSettings.sdkKey}';
          sdkSecretController.text = '${zoomSettings.sdkSecretKey}';
          zoomEmailController.text = '${zoomSettings.email}';
          zoomPasswordController.text = '${zoomSettings.password}';
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submit() async {
    final token = await SharedPreferenceHelper().getAuthToken();
    if (!globalFormKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    globalFormKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    const url = "$BASE_URL/api_instructor/live_class_settings";
    try {
      FormData formData = FormData.fromMap({
        'auth_token': token,
        'sdk_key': sdkKeyController.text,
        'sdk_secret_key': sdkSecretController.text,
        'email': zoomEmailController.text,
        'password': zoomPasswordController.text,
      });

      await Dio().post(url, data: formData);

      setState(() {
        _isLoading = false;
      });

      CommonFunctions.showSuccessToast('Live class updated Successfully');
    } catch (error) {
      const errorMsg = 'Update failed!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  // ignore: deprecated_member_use
  void _launchURL(String url) async => await canLaunch(url)
      // ignore: deprecated_member_use
      ? await launch(url, forceSafariVC: false)
      : throw 'Could not launch $url';

  InputDecoration getInputDecoration(String hintext, IconData iconData) {
    return InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(color: Color(0xFF3862FD)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(color: Color(0xFFF65054)),
      ),
      filled: true,
      hintStyle: const TextStyle(color: kTextColor),
      hintText: hintext,
      fillColor: Colors.white,
      prefixIcon: Icon(
        iconData,
        color: const Color(0xFFc7c8ca),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 17),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Form(
            key: globalFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    "Zoom Settings",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.info_outline),
                  label: const Text('View Documentation'),
                  onPressed: () {
                    const url =
                        'https://creativeitem.com/docs/doggel-lms/zoom-live-class';
                    _launchURL(url);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SDK Key',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: getInputDecoration(
                    'SDK Key',
                    Icons.vpn_key_outlined,
                  ),
                  keyboardType: TextInputType.text,
                  controller: sdkKeyController,
                  validator: (input) =>
                      input!.isEmpty ? "SDK Key cannot be empty" : null,
                  onSaved: (value) {
                    setState(() {
                      sdkKeyController.text = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SDK Secret',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: getInputDecoration(
                    'SDK Secret',
                    Icons.vpn_key,
                  ),
                  keyboardType: TextInputType.text,
                  controller: sdkSecretController,
                  validator: (input) =>
                      input!.isEmpty ? "SDK Secret cannot be empty" : null,
                  onSaved: (value) {
                    setState(() {
                      sdkSecretController.text = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Zoom Email Id',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: getInputDecoration(
                    'Email Id',
                    Icons.email_outlined,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: zoomEmailController,
                  validator: (input) =>
                      input!.isEmpty ? "Email cannot be empty" : null,
                  onSaved: (value) {
                    setState(() {
                      zoomEmailController.text = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Zoom Password',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  keyboardType: TextInputType.text,
                  controller: zoomPasswordController,
                  onSaved: (input) => zoomPasswordController.text = input!,
                  validator: (input) =>
                      input!.isEmpty ? "Password cannot be empty" : null,
                  obscureText: hidePassword,
                  cursorColor: Colors.blueAccent,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Color(0xFF3862FD)),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Color(0xFFF65054)),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Color(0xFFF65054)),
                    ),
                    filled: true,
                    hintStyle: const TextStyle(color: kTextColor),
                    hintText: "Zoom Password",
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.lock_outlined,
                      color: Color(0xFFc7c8ca),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 17),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      color: Colors.black,
                      icon: Icon(hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : MaterialButton(
                            onPressed: _submit,
                            color: kGreenColor,
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            splashColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: kGreenColor),
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

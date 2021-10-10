import 'package:flutter/material.dart';
import 'package:github_1/home_page2.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Formのkeyを指定する場合は<FormState>としてGlobalKeyを定義する
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        // Formのkeyに指定する
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TRECA',
                  style: Theme.of(context).textTheme.headline4,
                ),

                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ニックネーム',
                  ),
                  keyboardType: TextInputType.name,
                  // ニックネームのバリデーション
                  validator: (String? value) {
                    // ニックネームが入力されていない場合
                    if (value?.isEmpty == true) {
                      // 問題があるときはメッセージを返す
                      return 'ニックネームを入力して下さい';
                    }
                    // 問題ないときはnullを返す
                    return null;
                  },
                ),

                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // ログインボタンをタップしたときの処理
                    onPressed: () => _onSignIn(),
                    child: Text('はじめる'),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSignIn() {
    // 入力内容を確認する
    if (_formKey.currentState?.validate() != true) {
      // エラーメッセージがあるため処理を中断する
      return;
    }
    // 画像一覧画面に切り替え
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => Migileft(),
      ),
    );
  }

}


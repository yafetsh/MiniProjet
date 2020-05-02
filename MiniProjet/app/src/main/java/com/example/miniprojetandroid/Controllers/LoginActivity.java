package com.example.miniprojetandroid.Controllers;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import com.example.miniprojetandroid.R;
import com.example.miniprojetandroid.Retrofit.INodeJS;
import com.example.miniprojetandroid.Retrofit.RetrofitClient;
import com.google.android.material.button.MaterialButton;
import com.rengwuxian.materialedittext.MaterialEditText;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Retrofit;
import com.facebook.accountkit.AccountKit;
import com.facebook.accountkit.AccessToken;

public class LoginActivity extends AppCompatActivity {
    INodeJS myAPI;
    CompositeDisposable compositeDisposable = new CompositeDisposable();

    MaterialEditText email,password;
    MaterialButton btn_register,btn_login;
    AccessToken accessToken = AccountKit.getCurrentAccessToken();



    @Override
    protected void onStop() {
        compositeDisposable.clear();
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        compositeDisposable.clear();
        super.onDestroy();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        //Init API
        Retrofit retrofit = RetrofitClient.getInstance();
        myAPI = retrofit.create(INodeJS.class);

        //View
        btn_login = findViewById(R.id.login_button);
        btn_register = findViewById(R.id.register_button);
        email = findViewById(R.id.edt_email);
        password = findViewById(R.id.edt_password);

        //Button action
        btn_login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String e = email.getText().toString();
                String p = password.getText().toString();
                //System.out.println(e);
                if (e.equals("")||p.equals("")){
                    Toast.makeText(LoginActivity.this, "Vérifier Votre Données",Toast.LENGTH_SHORT).show();
                }else {
                loginUser(email.getText().toString(),password.getText().toString());

            }}
        });

        btn_register.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(LoginActivity.this, RegisterActivity.class);
                startActivity(i);
            }
        });
    }
    private void loginUser(String email, String password) {
        compositeDisposable.add(myAPI.loginUser(email,password)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Consumer<String>() {
                    @Override
                    public void accept(String s) throws Exception {
                        if (s.contains("encrypted_password")){
                            Toast.makeText(LoginActivity.this,"Login Successfully",Toast.LENGTH_SHORT).show();
                        Intent i = new Intent(LoginActivity.this, MenuActivity.class);
                        startActivity(i);

                        }



                        else
                            Toast.makeText(LoginActivity.this,""+s,Toast.LENGTH_SHORT).show(); //Show error from API

                    }
                })
        );
    }
    }



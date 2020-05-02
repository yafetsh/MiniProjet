package com.example.miniprojetandroid.Controllers;

import androidx.appcompat.app.AppCompatActivity;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Toast;

import com.example.miniprojetandroid.MainActivity;
import com.example.miniprojetandroid.R;
import com.example.miniprojetandroid.Retrofit.INodeJS;
import com.example.miniprojetandroid.Retrofit.RetrofitClient;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.dialog.MaterialAlertDialogBuilder;
import com.rengwuxian.materialedittext.MaterialEditText;

import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.functions.Consumer;
import io.reactivex.schedulers.Schedulers;
import retrofit2.Retrofit;

public class RegisterActivity extends AppCompatActivity {

    INodeJS myAPI;
    CompositeDisposable compositeDisposable = new CompositeDisposable();

    MaterialEditText email,password,name,prenom,tel,Copassword;
    MaterialButton enregistrer;




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
        setContentView(R.layout.activity_register);



        //Init API
        Retrofit retrofit = RetrofitClient.getInstance();
        myAPI = retrofit.create(INodeJS.class);

        //View
        Copassword = findViewById(R.id.edt_Copassword);
        email = findViewById(R.id.edt_email);
        name = findViewById(R.id.edt_name);
        password = findViewById(R.id.edt_password);
        prenom = findViewById(R.id.edt_prenom);
        tel = findViewById(R.id.edt_tel);
        enregistrer =findViewById(R.id.enregistrer);

        enregistrer.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String cp = Copassword.getText().toString();
                String p = password.getText().toString();
                if (cp.equals(p)){

                registerUser(email.getText().toString(),name.getText().toString(),prenom.getText().toString(),tel.getText().toString(),p);
                    Intent i = new Intent(RegisterActivity.this, MenuActivity.class);
                    startActivity(i);
            }else  Toast.makeText(RegisterActivity.this, "Confirmer mot de passe",Toast.LENGTH_SHORT).show();}

        });




    }


    private void registerUser(final String email, final String name, final String prenom, final String tel, final String password) {


                        compositeDisposable.add(myAPI.registerUser(email,name,prenom,tel,password)
                                .subscribeOn(Schedulers.io())
                                .observeOn(AndroidSchedulers.mainThread())
                                .subscribe(new Consumer<String>() {
                                    @Override
                                    public void accept(String s) throws Exception {
                                        Toast.makeText(RegisterActivity.this,""+s,Toast.LENGTH_SHORT).show();
                                    }
                                })
                        );

                    }
    }





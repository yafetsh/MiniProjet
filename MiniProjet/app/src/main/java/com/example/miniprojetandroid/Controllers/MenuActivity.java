package com.example.miniprojetandroid.Controllers;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.Toast;

import com.example.miniprojetandroid.Entities.CampEvent;
import com.example.miniprojetandroid.Entities.pubAdapter;
import com.example.miniprojetandroid.R;
import com.special.ResideMenu.ResideMenu;
import com.special.ResideMenu.ResideMenuItem;

import java.util.ArrayList;
import java.util.List;

public class MenuActivity extends AppCompatActivity {

    ImageButton menu ;
    ResideMenu resideMenu;
    ImageView acceuil1,profileuser;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_menu);



// affichage pub event et action menu
        RecyclerView recyclerView = findViewById(R.id.publications);
        List<CampEvent> mlist = new ArrayList<>();
        mlist.add(new CampEvent(R.drawable.images,"haythem boudokhane",R.drawable.images));
        mlist.add(new CampEvent(R.drawable.images,"haythem boudokhane",R.drawable.images));
        mlist.add(new CampEvent(R.drawable.images,"haythem boudokhane",R.drawable.images));
        pubAdapter adapter = new pubAdapter(this,mlist );
        recyclerView.setAdapter(adapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        profileuser = findViewById(R.id.userProfile);
        acceuil1 = findViewById(R.id.acceuil1);


        acceuil1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(MenuActivity.this, MenuActivity.class);
                startActivity(i);
            }
        });

        profileuser.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Fragment fragg = new Profile();
                FragmentManager fragmentManager = getSupportFragmentManager();
                FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                fragmentTransaction.replace(R.id.details, fragg);
                fragmentTransaction.commit();

            }
        });






        menu = findViewById(R.id.menu);
        setMenu();


    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {

        return resideMenu.dispatchTouchEvent(ev);
    }


    public void setMenu() {
        // attach to current activity;
        resideMenu = new ResideMenu(this);
        resideMenu.setBackground(R.color.mapboxBlue);


        resideMenu.setShadowVisible(true);
        resideMenu.attachToActivity(this);

        // create menu items;

        String titles[] = {"Profil", "Add camp","Add materiel", "Logout"};
        int icon[] = {R.drawable.profile, R.drawable.add, R.drawable.add, R.drawable.logout};

        for (int i = 0; i < titles.length; i++) {
            ResideMenuItem item = new ResideMenuItem(this, icon[i], titles[i]);
            if (titles[i].equals("Profil") ) {
                item.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Fragment fragg = new Profile();
                        FragmentManager fragmentManager = getSupportFragmentManager();
                        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
                        fragmentTransaction.replace(R.id.details, fragg);
                        fragmentTransaction.commit();
                        resideMenu.closeMenu();
                    }
                });
            } else if (titles[i].equals("Add camp") ) {
                    item.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {



                        }
                    });
                } else if (titles[i].equals("Add materiel") ) {
                    item.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {

                        }
                    });

                }


            resideMenu.addMenuItem(item, ResideMenu.DIRECTION_LEFT); // or  ResideMenu.DIRECTION_RIGHT
        }




        menu.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                resideMenu.openMenu(ResideMenu.DIRECTION_LEFT);
            }
        });






        ResideMenu.OnMenuListener menuListener = new ResideMenu.OnMenuListener() {
            @Override
            public void openMenu() {
                Toast.makeText(getApplicationContext(), "Menu is opened!", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void closeMenu() {
                Toast.makeText(getApplicationContext(), "Menu is closed!", Toast.LENGTH_SHORT).show();
            }
        };
        resideMenu.setMenuListener(menuListener);


    }





}

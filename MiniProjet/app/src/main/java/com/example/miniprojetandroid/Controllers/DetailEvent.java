package com.example.miniprojetandroid.Controllers;


import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;

import com.example.miniprojetandroid.R;

/**
 * A simple {@link Fragment} subclass.
 */
public class DetailEvent extends Fragment {

    Button gotop;
    ImageView imdu;


    public DetailEvent() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
       View rootView = inflater.inflate(R.layout.fragment_detail_event, container, false);

        gotop = rootView.findViewById(R.id.gotoprofil);
        imdu = rootView.findViewById(R.id.imguser);
        imdu.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Fragment fragg = new ProfilePub();
                ((AppCompatActivity)getContext()).getSupportFragmentManager().beginTransaction().replace(R.id.details, fragg).commit();

            }
        });





       return rootView;
    }

}

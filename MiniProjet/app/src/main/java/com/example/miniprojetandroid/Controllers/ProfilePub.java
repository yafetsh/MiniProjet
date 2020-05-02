package com.example.miniprojetandroid.Controllers;


import android.content.Intent;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.example.miniprojetandroid.R;

/**
 * A simple {@link Fragment} subclass.
 */
public class ProfilePub extends Fragment {

    Button gotop;


    public ProfilePub() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.fragment_profile_pub, container, false);












        return rootView;
    }

}

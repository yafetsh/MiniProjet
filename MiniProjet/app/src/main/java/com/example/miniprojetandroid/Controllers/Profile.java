package com.example.miniprojetandroid.Controllers;


import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import androidx.fragment.app.Fragment;

import com.example.miniprojetandroid.R;

/**
 * A simple {@link Fragment} subclass.
 */
public class Profile extends Fragment {

    Button gotop;


    public Profile() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.fragment_profile, container, false);












        return rootView;
    }

}

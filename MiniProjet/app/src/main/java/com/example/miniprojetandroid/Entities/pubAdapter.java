package com.example.miniprojetandroid.Entities;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.miniprojetandroid.Controllers.DetailEvent;
import com.example.miniprojetandroid.Controllers.RegisterActivity;
import com.example.miniprojetandroid.Controllers.test;
import com.example.miniprojetandroid.R;

import java.util.List;

public class pubAdapter extends RecyclerView.Adapter<pubAdapter.myViewHolder>  {

    Context mContext;
    List<CampEvent> mData;
    FragmentManager fragmentManager;


    public pubAdapter(Context mContext, List<CampEvent> mData, FragmentManager fragmentManager) {
        this.mContext = mContext;
        this.mData = mData;
        this.fragmentManager = fragmentManager;
    }
    public pubAdapter(Context mContext, List<CampEvent> mData) {
        this.mContext = mContext;
        this.mData = mData;
    }

    @NonNull
    @Override
    public myViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {


        LayoutInflater inflater = LayoutInflater.from(mContext);
        View v = inflater.inflate(R.layout.card_item,parent,false);
        return new myViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull myViewHolder holder, int position) {


        holder.background_img.setImageResource(mData.get(position).getBackground());
        holder.profile_photo.setImageResource(mData.get(position).getProfilePhoto());
        holder.pr_title.setText(mData.get(position).getProfilrName());


    }

    @Override
    public int getItemCount() {
        return mData.size();
    }

    public class myViewHolder  extends RecyclerView.ViewHolder implements View.OnClickListener {

        ImageView profile_photo, background_img;
        TextView pr_title;

        public myViewHolder(View itemView) {
            super(itemView);
            profile_photo = itemView.findViewById(R.id.profile);
            background_img = itemView.findViewById(R.id.card_background);
            pr_title = itemView.findViewById(R.id.tv_title);

            itemView.setOnClickListener(this);

        }

        @Override
        public void onClick(View v) {
            int position = getAdapterPosition(); // gets item position
            if (position != RecyclerView.NO_POSITION) { // Check if an item was deleted, but the user clicked it before the UI removed it
                CampEvent ce = mData.get(position);
                // We can access the data within the views
                Toast.makeText(mContext, "okkkkkk", Toast.LENGTH_SHORT).show();

      /*          Intent i = new Intent(mContext, RegisterActivity.class);
                mContext.startActivity(i);*/

                                        Fragment fragg = new DetailEvent();
                ((AppCompatActivity)mContext).getSupportFragmentManager().beginTransaction().replace(R.id.details, fragg).commit();


            }
        }
    }}

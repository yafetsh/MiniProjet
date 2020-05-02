package com.example.miniprojetandroid.Entities;

public class CampEvent {

    int background;
    String profilrName;
    int profilePhoto;
     public CampEvent(){

     }

    public CampEvent(int background, String profilrName, int profilePhoto) {
        this.background = background;
        this.profilrName = profilrName;
        this.profilePhoto = profilePhoto;
    }

    public int getBackground() {
        return background;
    }

    public void setBackground(int background) {
        this.background = background;
    }

    public String getProfilrName() {
        return profilrName;
    }

    public void setProfilrName(String profilrName) {
        this.profilrName = profilrName;
    }

    public int getProfilePhoto() {
        return profilePhoto;
    }

    public void setProfilePhoto(int profilePhoto) {
        this.profilePhoto = profilePhoto;
    }
}

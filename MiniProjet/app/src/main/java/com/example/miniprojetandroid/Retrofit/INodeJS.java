package com.example.miniprojetandroid.Retrofit;


import io.reactivex.Observable;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.POST;

public interface INodeJS {
    @POST("register")
    @FormUrlEncoded
    Observable<String> registerUser (@Field("email") String email,
                                     @Field("name") String name,
                                     @Field("prenom") String prenom,
                                     @Field("tel_user") String tel_user,
                                     @Field("password") String password);
    @POST("login")
    @FormUrlEncoded
    Observable<String> loginUser (@Field("email") String email,
                                     @Field("password") String password);

}

//package com.example.georeal;
//
//import androidx.appcompat.app.AppCompatActivity;
//import androidx.recyclerview.widget.LinearLayoutManager;
//import androidx.recyclerview.widget.RecyclerView;
//
//import android.graphics.Bitmap;
//import android.os.Bundle;
//import android.widget.TextView;
//
//import com.example.georeal.Fragments.MapsFragment;
//import com.example.georeal.Structures.GeoCircle;
//
//import java.lang.reflect.Array;
//import java.util.ArrayList;
//
//public class CirclePhotoList extends AppCompatActivity {
//    TextView circleID;
//    RecyclerView recyclerView;
//
//    private ArrayList<Bitmap> list;
//
//
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_circle_photo_list);
//
//        circleID = findViewById(R.id.circleID);
//        String value = getIntent().getExtras().getString("ID");
//        ArrayList<GeoCircle> circleSArrayList = MapsFragment.geoCircles;
//        circleID.setText(value);
//
//
//        // Inflate the layout for this fragment
//        recyclerView = findViewById(R.id.rvPosts);
//
//        GeoCircle c = circleSArrayList.get(0);
//        for(GeoCircle g : circleSArrayList)
//            if(g.getId() == value)
//                c = g;
//
//
//
//        mAdapter = new PicturesAdapter(getApplicationContext(),c.getImage());
//
//        recyclerView.setAdapter(mAdapter);
//        recyclerView.setLayoutManager(new LinearLayoutManager(getApplicationContext()));
//        mAdapter.notifyDataSetChanged();
//    }
//
////    public void queryPosts(){
////        for()
////    }
//
//
//}
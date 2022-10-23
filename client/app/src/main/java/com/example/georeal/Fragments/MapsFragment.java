package com.example.georeal.Fragments;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;

import android.Manifest;
import android.app.Activity;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.TaskStackBuilder;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.location.Location;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.example.georeal.Circle1;
import com.example.georeal.Circle2;
import com.example.georeal.Circle3;
import com.example.georeal.CircleFinal1;
import com.example.georeal.MapScreen;
import com.example.georeal.R;
import com.example.georeal.StartScreen;
import com.example.georeal.Structures.GeoCircle;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.Circle;
import com.google.android.gms.maps.model.CircleOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.MapStyleOptions;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

import java.util.ArrayList;

public class MapsFragment extends Fragment implements View.OnClickListener {
    double marketLat = -33.8651;
    double markerLong = 151.2099;
    LocationManager mLocationManager;
    Location gps_loc;
    Location network_loc;
    Location final_loc;
    double userLongitude;
    double userLatitute;
    Circle polyline1;
    boolean clicked = false;
    Button addButton;
    View view;
    String userCountry, userAddress;
    GoogleMap mGoogleMap;
    Button checkButton;
    Circle currentCircle;
    Marker marker;
    Button takePicture;
    boolean touched = false;
    public static ArrayList<GeoCircle> geoCircles;
    int counter = 0;

    private FusedLocationProviderClient mFusedLocationClient;
    int color = (45 & 0xff) << 24 | (255 & 0xff) << 16 | (255 & 0xff) << 8 | (255 & 0xff);
    private LocationCallback locationCallback;
    private OnMapReadyCallback callback = new OnMapReadyCallback() {


        /**
         * Manipulates the map once available.
         * This callback is triggered when the map is ready to be used.
         * This is where we can add markers or lines, add listeners or move the camera.
         * In this case, we just add a marker near Sydney, Australia.
         * If Google Play services is not installed on the device, the user will be prompted to
         * install it inside the SupportMapFragment. This method will only be triggered once the
         * user has installed Google Play services and returned to the app.
         */
        @Override
        public void onMapReady(GoogleMap googleMap) {
            boolean success = googleMap.setMapStyle(new MapStyleOptions(getResources()
                    .getString(R.string.style_json)));
            mGoogleMap = googleMap;
            if (!success) {
                Log.e("TAG", "Style parsing failed.");
            }

            mGoogleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(marketLat, markerLong), 16));


            for(GeoCircle g : geoCircles)
            {
                Circle circle = mGoogleMap.addCircle(new CircleOptions()
                        .clickable(true)
                        .center(new LatLng(g.getLatitude(), g.getLogitude()))
                        .radius(g.getRadius())
                        .fillColor(color)
                        .strokeColor(color));
                g.setId(circle.getId());
            }

            mGoogleMap.setOnCircleClickListener(new GoogleMap.OnCircleClickListener() {
                @Override
                public void onCircleClick(@NonNull Circle circle) {
                    String name = "current";
                    for(GeoCircle c : geoCircles)
                        if(c.getId() == circle.getId())
                        {
                            name = c.getFlag();
                        }

                    System.out.println(circle.getId());
                    currentCircle = circle;


                    //myIntent.putExtra("array", geoCircles);
                    Intent i;
                    if(counter == 2)
                    {
                        i = new Intent(getActivity(), Circle3.class);
                    }


                   else  if(touched) {
                         i = new Intent(getActivity(), Circle2.class);
                        System.out.println("TEST!@#");
                        touched = !touched;
                        counter++;

                    }
                    else
                    {
                        touched = !touched;
                        i = new Intent(getActivity(), Circle1.class);
                        System.out.println("TEST!@#");
                        counter++;
                    }

                    startActivity(i);

                }
            });

        }




    };

    public void showMarker(){
        LatLng sydney = new LatLng(marketLat, markerLong);
        marker = mGoogleMap.addMarker(new MarkerOptions().position(sydney));
        marker.setDraggable(true);
        LatLngBounds australiaBounds = new LatLngBounds(
                new LatLng(marketLat, markerLong + 0.01), // SW bounds
                new LatLng(marketLat, markerLong - 0.01)  // NE bounds
        );


        mGoogleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(new LatLng(marketLat, markerLong), 16));




        polyline1 = mGoogleMap.addCircle(new CircleOptions()
                .clickable(true)
                .center(new LatLng(marketLat, markerLong))
                .radius(150)
                .fillColor(color)
                .strokeColor(color)
        );
        polyline1.setVisible(false);
        if (clicked)
            polyline1.setVisible(true);

        mGoogleMap.setOnMarkerDragListener(new GoogleMap.OnMarkerDragListener() {
            @Override
            public void onMarkerDragStart(@NonNull Marker marker) {

            }

            @Override
            public void onMarkerDrag(@NonNull Marker marker) {
                marketLat = marker.getPosition().latitude;
                markerLong = marker.getPosition().longitude;
                polyline1.setCenter(new LatLng(marketLat, markerLong));
            }

            @Override
            public void onMarkerDragEnd(@NonNull Marker marker) {

            }
        });
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater,
                             @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {

        view = inflater.inflate(R.layout.fragment_maps, container, false);
        geoCircles = new ArrayList<>();
        geoCircles.add(new GeoCircle(47.605384, -122.3355372, 150, "Seattle"));
        geoCircles.add(new GeoCircle(47.6503265, -122.3037946, 150, "Stadium"));
        checkButton = view.findViewById(R.id.checkButton);
        checkButton.setVisibility(View.INVISIBLE);
        addButton = view.findViewById(R.id.doneButton);

        takePicture = view.findViewById(R.id.takePicture);
        takePicture.setVisibility(View.INVISIBLE);

        addButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                checkButton.setVisibility(View.VISIBLE);
                clicked = true;
                System.out.println("clicked");
                showMarker();
                polyline1.setVisible(true);

            }
        });

        checkButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Circle circle = mGoogleMap.addCircle(new CircleOptions()
                        .clickable(true)
                        .center(new LatLng(marketLat, markerLong))
                        .radius(150)
                        .fillColor(color)
                        .strokeColor(color));
                currentCircle = circle;
                    GeoCircle g1 = new GeoCircle(marketLat, markerLong, 150, "Current");
                    geoCircles.add(g1);
                    g1.setId(circle.getId());


                    for(GeoCircle g : geoCircles)
                        System.out.println(g);

                marker.setVisible(false);
                checkButton.setVisibility(View.INVISIBLE);
                String str = isInACircle();
                if(!str.equals(""))
                {
                    if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
                        NotificationChannel channel = new NotificationChannel("My notification", "My notification", NotificationManager.IMPORTANCE_DEFAULT);
                        NotificationManager manager = getActivity().getSystemService(NotificationManager.class);
                        manager.createNotificationChannel(channel);
                    }


                    NotificationCompat.Builder builder = new NotificationCompat.Builder(getContext(), "My notification");
                    builder.setContentTitle("TAKE YOUR GeoREAL!");



                    takePicture.setVisibility(View.VISIBLE);


//                    ActivityResultLauncher<String> mGetContent = registerForActivityResult(new ActivityResultContracts.GetContent(),
//                            new ActivityResultCallback<Uri>() {
//                                @Override
//                                public void onActivityResult(Uri uri) {
////                                    mItemPicture.setImageURI(uri);
////                                    mSaveUriPic[0] = uri;
//                                }
//                            });


//                    takePicture.setOnClickListener(new View.OnClickListener() {
//                        @Override
//                        public void onClick(View v) {
//                            mGetContent.launch("image/*");
//                        }
//                    });



                    if(ContextCompat.checkSelfPermission(getActivity(), Manifest.permission.CAMERA)!=PackageManager.PERMISSION_GRANTED){
                        ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.CAMERA}, 101);
                    }


                    takePicture.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            Intent i = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                            startActivityForResult(i, 101);
                            takePicture.setVisibility(View.INVISIBLE);
                        }
                    });

//                   Intent resultIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
//// Create the TaskStackBuilder and add the intent, which inflates the back stack
//                    TaskStackBuilder stackBuilder = TaskStackBuilder.create(getContext());
//                    Intent secondIntent = new Intent(getActivity(), CirclePhotoList.class);
//                    //stackBuilder.addNextIntentWithParentStack(secondIntent);
//                    stackBuilder.addNextIntentWithParentStack(resultIntent);
//
//// Get the PendingIntent containing the entire back stack
//                    PendingIntent resultPendingIntent =
//                            stackBuilder.getPendingIntent(0,
//                                    PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

                   // builder.setContentIntent(resultPendingIntent);
                    builder.setContentText("Click here to add your photo to this location! ");
                    builder.setSmallIcon(R.drawable.ic_baseline_monochrome_photos_24);
                    builder.setAutoCancel(true);
                    System.out.println("In the IF statement");

                    NotificationManagerCompat managerCompact = NotificationManagerCompat.from(getContext());
                    managerCompact.notify(1, builder.build());

//                    ActivityResultLauncher<String> mGetContent = registerForActivityResult(new ActivityResultContracts.GetContent(),
//                            new ActivityResultCallback<Uri>() {
//                                @Override
//                                public void onActivityResult(Uri uri) {
////                                    Intent i = new Intent(getActivity(), CirclePhotoList.class);
////                                    startActivity(i);
//                                }
//                            });
//                    //mGetContent.launch("image/*");


                }
            }
        });

        return view;
    }



    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {


        mFusedLocationClient = LocationServices.getFusedLocationProviderClient(getActivity());
        if (ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(getActivity(), Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            ActivityResultLauncher<String[]> locationPermissionRequest =
                    registerForActivityResult(new ActivityResultContracts
                                    .RequestMultiplePermissions(), result -> {
                                Boolean fineLocationGranted = result.getOrDefault(
                                        Manifest.permission.ACCESS_FINE_LOCATION, false);
                                Boolean coarseLocationGranted = result.getOrDefault(
                                        Manifest.permission.ACCESS_COARSE_LOCATION, false);
                                if (fineLocationGranted != null && fineLocationGranted) {
                                    // Precise location access granted.
                                } else if (coarseLocationGranted != null && coarseLocationGranted) {
                                    // Only approximate location access granted.
                                } else {
                                    // No location access granted.
                                }
                            }
                    );


            locationPermissionRequest.launch(new String[]{
                    Manifest.permission.ACCESS_FINE_LOCATION,
                    Manifest.permission.ACCESS_COARSE_LOCATION
            });
            return;
        }

        try {
            LocationManager locationManager = (LocationManager) getActivity().getSystemService(Context.LOCATION_SERVICE);

            gps_loc = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
            network_loc = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (gps_loc != null) {
            final_loc = gps_loc;
            userLatitute = final_loc.getLatitude();
            userLongitude = final_loc.getLongitude();
        }
        else if (network_loc != null) {
            final_loc = network_loc;
            userLatitute = final_loc.getLatitude();
            userLongitude = final_loc.getLongitude();
        }
        else {
            userLatitute = 0.0;
            userLongitude = 0.0;
        }

        markerLong = userLongitude;
        marketLat = userLatitute;

        System.out.println("Long " + userLongitude + " Lat: " + userLatitute);


        super.onViewCreated(view, savedInstanceState);
        if(getArguments() != null) {
            marketLat = getArguments().getDouble("Lat");
            markerLong = getArguments().getDouble("Long");
        }
        SupportMapFragment mapFragment =
                (SupportMapFragment) getChildFragmentManager().findFragmentById(R.id.map);
        if (mapFragment != null) {
            mapFragment.getMapAsync(callback);
        }
    }
    @Override
    public void onActivityResult(int requestCode, int responseCode, @Nullable Intent data){
        super.onActivityResult(requestCode, responseCode, data);
        if(requestCode == 101)
        {
            Bitmap bitmap = (Bitmap) data.getExtras().get("data");
            for(GeoCircle c : geoCircles)
            {
                if(c.getId() == currentCircle.getId()) {
                    System.out.println("added");
                    c.addImage(bitmap);
                }
            }
        }
    }


    @Override
    public void onClick(View view) {
        System.out.println("hello");
    }

    public String isInACircle(){
        for(GeoCircle c : geoCircles)
        {
            //(x - center_x)² + (y - center_y)² < radius².

            System.out.println("TESTS");
            System.out.println(userLongitude);
            System.out.println(userLatitute);
            System.out.println(c.getLatitude());
            System.out.println(c.getLogitude());

            float[] results = new float[1];
            Location.distanceBetween(userLatitute, userLongitude, c.getLatitude(), c.getLogitude(), results);
            //double addition = Math.pow((userLongitude - c.getLogitude()),2) + Math.pow((userLatitute - c.getLatitude()),2);
            float distanceInMeters = results[0];
            System.out.println("Distance in meters: "+distanceInMeters);
            if(distanceInMeters < c.getRadius()){
                return c.getId();
            }
        }
        return "";
    }
}
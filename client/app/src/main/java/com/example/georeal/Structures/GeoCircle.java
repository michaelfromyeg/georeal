package com.example.georeal.Structures;

import android.graphics.Bitmap;

import java.util.ArrayList;

public class GeoCircle {

    private double latitude;
    private double logitude;
    private double radius;
    private ArrayList<Bitmap> images;
    private String id;
    private String flag;

    public GeoCircle(double latitude, double logitude, int radius, String flag) {
        this.latitude = latitude;
        this.logitude = logitude;
        this.radius = radius;
        this.flag = flag;
    }

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLogitude() {
        return logitude;
    }

    public String getId() {
        return id;
    }

    public void addImage(Bitmap bitmap)
    {
        images.add(bitmap);
    }

    public int imageSize(){
        return images.size();
    }

    public ArrayList<Bitmap> getImage(){
        return images;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setLogitude(double logitude) {
        this.logitude = logitude;
    }

    public double getRadius() {
        return radius;
    }

    public void setRadius(double radius) {
        this.radius = radius;
    }

    @Override
    public String toString() {
        return "GeoCircle{" +
                "latitude=" + latitude +
                ", logitude=" + logitude +
                ", radius=" + radius +
                '}';
    }
}

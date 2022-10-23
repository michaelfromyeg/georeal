//package com.example.georeal.Adapter;
//
//import android.content.Context;
//import android.graphics.Bitmap;
//import android.util.Log;
//import android.view.View;
//import android.view.ViewGroup;
//import android.widget.ImageView;
//
//import androidx.annotation.NonNull;
//import androidx.recyclerview.widget.RecyclerView;
//
//import com.example.georeal.R;
//
//import java.util.List;
//
//public class PicturesAdapter extends RecyclerView.Adapter<PicturesAdapter.ViewHolder>{
//
//
//    private final Context mContext;
//    private final List<Bitmap> mAllPhotots;
//
//    public PicturesAdapter(Context mContext, List<Bitmap> images) {
//        this.mContext = mContext;
//        this.mAllPhotots = images;
//    }
//
//
//    @NonNull
//    @Override
//    public PicturesAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
//        return null;
//    }
//
//    @Override
//    public void onBindViewHolder(@NonNull PicturesAdapter.ViewHolder holder, int position) {
//        int counter = 0;
//        while(counter < 3) {
//            if (position + counter < mAllPhotots.size()) {
//                Bitmap image = mAllPhotots.get(position);
//                System.out.println("In OnBind");
//                holder.bind(image, counter);
//                counter++;
//            }
//            else {
//                break;
//            }
//        }
//    }
//
//    @Override
//    public int getItemCount() {
//        return 0;
//    }
//
//    class ViewHolder extends RecyclerView.ViewHolder{
//
//        private final ImageView image1;
//        private final ImageView image2;
//        private final ImageView image3;
//
//
//        public ViewHolder(@NonNull View itemView) {
//            super(itemView);
//            image1 = itemView.findViewById(R.id.imagePhoto);
//            image2 = itemView.findViewById(R.id.imagePhoto2);
//            image3 = itemView.findViewById(R.id.imagePhoto3);
//
//        }
//
//        public void bind(Bitmap image, int counter) {
//            if(image == null)
//                Log.i("LostItemAdapter" , "URI is null");
//            if(counter == 0)
//                image1.setImageBitmap(image);
//            else if(counter == 1)
//                image2.setImageBitmap(image);
//            else
//                image3.setImageBitmap(image);
//        }
//    }
//}

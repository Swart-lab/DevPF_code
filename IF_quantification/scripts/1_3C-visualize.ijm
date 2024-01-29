//this script is for multi channel images (z-planes are not taken into account)
//it makes contrast visible. No saving. No closing.
//open the images form .lif file in fiji

//select open images one by one and auto adjust contrast for all channels
for (i=0;i<nImages;i++) {
        selectImage(i+1);
        //go through all channels and "auto adjust" contrast
        Stack.getDimensions(width, height, nChannels, slices, frames);
        for (j=0; j<nChannels; j++){
        	k = j + 1;
        	Stack.setChannel(k);
        	run("Enhance Contrast", "saturated=0.35");
        }  
        // choose the colors for the channels. Channel 2 will be selected last
        Stack.setChannel(1); 
        run("Red");
        Stack.setChannel(3); 
        run("Grays");
        Stack.setChannel(2); 
        run("Cyan");
        //Stack.setChannel(4); 
        //run("Magenta");  
}



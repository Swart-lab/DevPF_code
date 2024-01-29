for (i=0;i<nImages;i++) {
        selectImage(i+1);
        //go through all channels and "auto adjust" contrast
        Stack.getDimensions(width, height, nChannels, slices, frames);
        Stack.setChannel(1);
        run("Specify...", "width=58 height=53 x=114 y=114 slice=1 oval");
        waitForUser("drag the ROI into one of the new MACs");
        Stack.setChannel(2);
        run("Measure");
        close();  
}

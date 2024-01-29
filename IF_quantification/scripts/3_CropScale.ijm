//this script should be used on stacks
//in a pipeline: visualize > TIFgenerateor > this script > SavingStackSlices
//this script mainly automaizes saving the checkpoitns as .tiff files

//get the path and the title of the current image
path = getDir("image"); 
imageTitle = getTitle();


//you need to crop the stack
makeRectangle(96, 139, 309, 206);
run("Specify...", "width=50 height=50 x=5.77 y=8.36 slice=1 scaled");
waitForUser("Place where to crop, then hit OK");
run("Crop");
saveAs("Tiff", path+File.separator+"crop-"+imageTitle);

// The scale bar will be set in the first channel
// Dialog to ask where to locate the scale bar
Stack.setChannel(1);
locations = newArray("Lower Right","Lower Left","Upper Right","Upper Left");
Dialog.create("Scale Bar Location");
	Dialog.addChoice("Choose the scale bar location", locations);
Dialog.show();
loc = Dialog.getChoice();
run("Scale Bar...", "width=10 height=8 thickness=20 font=0 color=White background=None location=["+loc+"] horizontal bold");
saveAs("Tiff", path+File.separator+"crop-scale-"+imageTitle);

//you need to include arrows
//waitForUser("Include arrows, then hit OK");
//saveAs("Tiff", path+File.separator+"crop-scale-arrow-"+imageTitle);

//to save the individual images as .tiff files use the SavingStackSlices script, please
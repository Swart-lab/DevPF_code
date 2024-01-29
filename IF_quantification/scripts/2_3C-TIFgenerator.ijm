//this script is to create a stack with merged overlay of a 3 channel (Max-)Projection 
//Adjust brightness and contrast for each channel as you want to have it
//operations done: split, merge channels, create stack, save stack and slices in new folder
//a dialog will ask you for the new image Title
//this script works on the currently selected image

//get the path and the title of the current image
path = getDir("image"); 
imageTitle = getTitle();

// Dialog to ask the user for a new Name
Dialog.create("New Name");
	Dialog.addString("How should the output images be saved?", "raw_");
Dialog.show();
imageTitle = Dialog.getString();
rename(imageTitle);
print(imageTitle);

//make an empty array to store the names of the channel slices
Stack.getDimensions(width, height, nChannels, slices, frames);
windowNames=newArray(nChannels);

//fill the empty array with the window names
for (i=0;i<nChannels;i++) {
	j = i + 1;
    windowNames[i] = "C" + j + "-" + imageTitle;
}

//merge Channels 1+2 and create stack with 3 Channels + overlay
run("Split Channels");
selectWindow(windowNames[0]);
run("Merge Channels...", "c1=["+windowNames[0]+"] c2=["+windowNames[1]+"] create keep");
run("Flatten");
run("Images to Stack", "name=Stack title=[] use");

//create a new folder and save the stack as a checkpoint
newfolder = path + File.separator + imageTitle;
File.makeDirectory(newfolder);
saveAs("Tiff", newfolder+File.separator+"stack-"+imageTitle);

//select the stack
stack = "stack-" + imageTitle + ".tif";
selectWindow(stack);

//make an empty array to store the names of the slices 
n=nSlices;
slices=newArray(n);

//fill the empty array with the slice labels
for (i=0;i<nSlices;i++) {
 setSlice(i+1);
 slices[i]=getInfo("slice.label");
}

//save all individual images as .tiff files in the new folder
run("Stack to Images");
for (i = 0; i < n; i++) {
	selectWindow(slices[i]); //selects windows named as the slices of the stack
	j = i + 1;
	//if-statement to give last channel the "overlay" name and other channels C1-, C2-, ...
	if (j == n) {
		saveAs("Tiff", newfolder+File.separator+"overlay-"+imageTitle); //saves overlay 
	} else {
		saveAs("Tiff", newfolder+File.separator+"C"+ j + "-" + imageTitle); //saves channels 
	}
	close();
}

selectWindow(imageTitle);
close();
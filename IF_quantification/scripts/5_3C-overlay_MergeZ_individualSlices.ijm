//this script is for multichannel images with multiple z-slices
//in advance: ajust brigthness and contrast for each channel. 
//this scrpit:
//splits hyperstack into individual stacks (each z-slice 1 stack)
//creates a composite of selected channels
//saves individual z-planes of all channel as individual images
//note: if more than 100 z-stacks another if-line needs to be added for filling Slices[i] 

//get the path of the current image
path = getDir("image"); 

// Dialog to ask the user for a new Name how the image should be saved
Dialog.create("New Name");
	Dialog.addString("How should the output images be saved?", "Z-slices_");
Dialog.show();
imageTitle = Dialog.getString();
rename(imageTitle);

//make an empty array to store the names of the channel slices
Stack.getDimensions(width, height, nChannels, slices, frames);
windowNames=newArray(nChannels);

//fill the empty array with the window names
for (i=0;i<nChannels;i++) {
	j = i + 1;
    windowNames[i] = "C" + j + "-" + imageTitle;
}

//split hyperstack in individual channel-stacks and merge Channels 1+2 
run("Split Channels");
selectWindow(windowNames[0]);
run("Merge Channels...", "c1=["+windowNames[0]+"] c2=["+windowNames[1]+"] c4=["+windowNames[3]+"] create keep");

//the overlays for each z-slices are stored in a stack called as the imageTitel
selectWindow(imageTitle);

//create a new folder to save the indivudual slices
newfolder = path + File.separator + imageTitle;
File.makeDirectory(newfolder);

//loop through all z-slices of the merge stack (still selected) and flatten each slice, save and close
for (i = 0; i<slices;i++) {
	j = i + 1;
	Stack.setSlice(j);
	run("Flatten");
	SliceName = imageTitle + "-" + j;
	saveAs("Tiff", newfolder+File.separator+"overlay-"+SliceName); //saves overlay
	close();
	selectWindow(imageTitle);
}

//now to the channel stacks
// select them one by one
print("Start");

for (k=0; k<windowNames.length; k++) {
	selectWindow(windowNames[k]);
	print(windowNames.length);
	Name = getTitle();
	print(Name);
	
	//make an empty array to store the names of the slices 
	n=nSlices;
	Slices=newArray(n);

	//fill the empty array with the slice labels
	for (i=0;i<nSlices;i++) {
 		j = i + 1;
 		print(j);
 		setSlice(j);
 		if (i < 9) {
			Slices[i]= Name + "-000" + j;
		} else {
			Slices[i]= Name + "-00" + j; 
		}
	}

	//save all individual images as .tiff files in location of the stack
	run("Stack to Images");
	for (i = 0; i < n; i++) {
		selectWindow(Slices[i]); //selects windows named as the slices of the stack
		run("RGB Color");
		saveAs("Tiff", newfolder+File.separator+Slices[i]); //saves overlay 
		close();
	}

}

//closes the last window
selectWindow(imageTitle);
close();









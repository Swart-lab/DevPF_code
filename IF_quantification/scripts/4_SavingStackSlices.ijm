//this scipt is to save all the slices of a stack into individual .tiff images 
//Files will be saved as C1-imageTitle, C2-, ... , overlay-imageTitle
//a dialog will ask you for the image Title

//get the path and the title of the current image
path = getDir("image"); 

// Dialog to ask the user for a new Name
Dialog.create("New Name");
	Dialog.addString("How should the output images be saved?", "labelled_");
Dialog.show();
imageTitle = Dialog.getString();

//make an empty array to store the names of the slices 
n=nSlices;
slices=newArray(n);

//fill the empty array with the slice labels
for (i=0;i<nSlices;i++) {
 setSlice(i+1);
 slices[i]=getInfo("slice.label");
}

//save all individual images as .tiff files in location of the stack
run("Stack to Images");
for (i = 0; i < n; i++) {
	selectWindow(slices[i]); //selects windows named as the slices of the stack
	j = i + 1;
	//if-statement to give last channel the "overlay" name and other channels C1-, C2-, ...
	if (j == n) {
		saveAs("Tiff", path+File.separator+"overlay-"+imageTitle); //saves overlay 
	} else {
		saveAs("Tiff", path+File.separator+"C"+ j + "-" + imageTitle); //saves channels 
	}
	close();
}
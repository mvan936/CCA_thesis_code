// ==== Ilastik Probability → % Cover (rectangle on original, argmax, verbose, null-free) ==== 
// Channel order: Ch1 = Green algae, Ch2 = Coralline algae, Ch3 = Background

path = File.openDialog("Pick any file inside the folder with your Ilastik probability TIFFs");
if (path=="") exit("Cancelled.");
sep = File.separator;
dir = File.getParent(path) + sep;
list = getFileList(dir);
if (lengthOf(list)==0) exit("No files found in: " + dir);

// NEW: set CSV path + ensure header exists on disk
csvPath = dir + "Probability_Percentages_Cropped.csv";
if (!File.exists(csvPath)) {
    File.saveString("Filename,Green%,Coralline%,Background%\n", csvPath);
}

run("Clear Results");
setResult("Filename", 0, ""); updateResults(); run("Clear Results");
print("\\Clear");
print("=== Starting batch for folder: " + dir + " ===");

// keep building in-memory CSV as before (used for final overwrite when batch completes)
csv = "Filename,Green%,Coralline%,Background%\n";

// ---------- Helper functions ----------
function getOpenImageTitles() {
    n = nImages; arr = newArray(n);
    for (ii=1; ii<=n; ii++) { selectImage(ii); arr[ii-1]=getTitle(); }
    return arr;
}
function closeAllImagesButResults() {
    titles = getOpenImageTitles();
    for (j=0; j<lengthOf(titles); j++) {
        if (titles[j]!="Results") { selectWindow(titles[j]); close(); }
    }
}
function safeOpenBF(p) {
    run("Bio-Formats Importer", "open=["+p+"] view=Hyperstack stack_order=XYCZT open_files_individually");
    return getTitle();
}
function geMask(A,B,outTitle) {
    imageCalculator("Subtract create", A, B);
    rename(outTitle);
    run("32-bit");
    setThreshold(0, 1e12);
    run("Convert to Mask");
}
function whitePixels(win) {
    selectWindow(win);
    getStatistics(area, mean);
    return getWidth()*getHeight()*(mean/255.0);
}

// ---------- Main loop ----------
for (i=0; i<list.length; i++) {
    name = list[i];
    if (!(endsWith(name,".tif")||endsWith(name,".tiff"))) continue;
    print("\n["+(i+1)+"/"+list.length+"] Opening: "+name);

    // Open original probability TIFF
    orig = safeOpenBF(dir+name);
    getDimensions(w,h,c,z,t);
    if (c<=1 && z<=1) {
        showMessage("Not multichannel","File "+name+" lacks multiple channels/slices.\nRe-export from Ilastik (Source=Probabilities).");
        closeAllImagesButResults(); 
        continue;
    }

    // Draw RECTANGLE on ORIGINAL
    setBatchMode(false);
    selectWindow(orig); resetMinAndMax(); setTool("rectangle");
    do { waitForUser("Draw a RECTANGLE around the rhodolith on the ORIGINAL image, then click OK."); typ=selectionType(); } while (typ==-1);

    // Crop
    run("Crop");
    cropped=getTitle();
    getDimensions(wc,hc,cc,zc,tc);
    print("  Cropped: "+wc+"x"+hc+"  C="+cc+"  Z="+zc);

    // Split
    planes=newArray(0);
    if (cc>1) {
        run("Split Channels");
        planes=newArray(cc);
        for (k=1;k<=cc;k++) planes[k-1]="C"+k+"-"+cropped;
    } else if (zc>1) {
        run("Stack to Images");
        planes=getOpenImageTitles();
    } else {
        showMessage("Not multichannel","After crop, "+name+" still has one plane.");
        closeAllImagesButResults(); 
        continue;
    }

    // Rename planes (1=Green, 2=Coralline, 3=Background)
    for (k=0;k<lengthOf(planes)&&k<3;k++) {
        selectWindow(planes[k]);
        if (k==0) rename("Ch1"); // Green
        if (k==1) rename("Ch2"); // Coralline
        if (k==2) rename("Ch3"); // Background
        planes[k]=getTitle();
    }

    // ---------- ARG-MAX masks ----------
    // Background wins ties: (Ch3 >= Ch1, Ch3 >= Ch2)
    geMask("Ch3","Ch1","BG_ge_G1");
    geMask("Ch3","Ch2","BG_ge_G2");
    imageCalculator("AND create","BG_ge_G1","BG_ge_G2"); rename("BGmask");

    // Coralline on remaining: NOT BG AND (Ch2 >= Ch1, Ch2 >= Ch3)
    geMask("Ch2","Ch1","C2_ge_C1");
    geMask("Ch2","Ch3","C2_ge_C3");
    imageCalculator("AND create","C2_ge_C1","C2_ge_C3"); rename("C2_ge_both");
    selectWindow("BGmask"); run("Duplicate...","title=NOT_BG"); run("Invert");
    imageCalculator("AND create","NOT_BG","C2_ge_both"); rename("CORmask");

    // Green = NOT (BG OR COR)
    imageCalculator("OR create","BGmask","CORmask"); rename("BG_OR_COR");
    selectWindow("BG_OR_COR"); run("Invert"); rename("GRmask");

    // ---------- Measure ----------
    grnCount=whitePixels("GRmask");
    corCount=whitePixels("CORmask");
    bgCount=whitePixels("BGmask");
    totalA=bgCount+corCount+grnCount; if(totalA==0) totalA=1;

    grnP=(grnCount/totalA)*100.0;
    corP=(corCount/totalA)*100.0;
    bgP=(bgCount/totalA)*100.0;

    print("  → Green: "+d2s(grnP,2)+"%   Coralline: "+d2s(corP,2)+"%   Background: "+d2s(bgP,2)+"%");

    // ---------- Record ----------
    row=nResults;
    setResult("Filename",row,name);
    setResult("Green%",row,grnP);
    setResult("Coralline%",row,corP);
    setResult("Background%",row,bgP);
    updateResults();

    // keep in-memory CSV (for final overwrite)
    csv+=name+","+grnP+","+corP+","+bgP+"\n";

    // NEW: append this row immediately to disk (checkpoint)
    File.append(name + "," + grnP + "," + corP + "," + bgP + "\n", csvPath);

    closeAllImagesButResults();
    run("Collect Garbage");
}

// ---------- Save CSV (final clean file if batch completes) ----------
File.saveString(csv, csvPath);
print("\n=== Saved CSV → "+csvPath+" ===");
selectWindow("Results");

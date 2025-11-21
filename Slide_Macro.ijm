requires("1.53");

dir = getDirectory("Choose folder with 10x slide images");
out = dir + "percent_cover_per_image.csv";

hMin = getNumber("Hue min (0-255)", 17);
hMax = getNumber("Hue max (0-255)", 255);
sMin = getNumber("Saturation min (0-255)", 0);
sMax = getNumber("Saturation max (0-255)", 250);
bMin = getNumber("Brightness min (0-255)", 180);
bMax = getNumber("Brightness max (0-255)", 255);

setOption("BlackBackground", false);
run("Set Measurements...", "area area_fraction redirect=None decimal=3");

if (isOpen("Results")) {
    selectWindow("Results");
    run("Clear Results");
}

list = getFileList(dir);
File.saveString("slide_id,image_name,cover_pct\n", out);

for (i = 0; i < list.length; i++) {

    name = list[i];
    lower = toLowerCase(name);

    if (endsWith(lower, ".jpg") || endsWith(lower, ".jpeg") ||
        endsWith(lower, ".tif") || endsWith(lower, ".tiff") ||
        endsWith(lower, ".png")) {

        open(dir + name);
        title = getTitle();

        slideID = title;
        u = indexOf(title, "_");
        if (u != -1) slideID = substring(title, 0, u);

        run("HSB Stack");
        run("Stack to Images");

        imageTitles = getList("image.titles");

        hueWin = "";
        satWin = "";
        briWin = "";

        for (j = 0; j < imageTitles.length; j++) {
            t = imageTitles[j];
            if (indexOf(t, "Hue") != -1) hueWin = t;
            if (indexOf(t, "Saturation") != -1) satWin = t;
            if (indexOf(t, "Brightness") != -1) briWin = t;
        }

        if (hueWin == "" || satWin == "" || briWin == "") {
            print("Error: Could not find Hue, Saturation, or Brightness for " + title);
            close("*");
            continue;
        }

        selectWindow(hueWin);
        setThreshold(hMin, hMax);
        run("Convert to Mask");
        rename("hMask");

        selectWindow(satWin);
        setThreshold(sMin, sMax);
        run("Convert to Mask");
        rename("sMask");

        selectWindow(briWin);
        setThreshold(bMin, bMax);
        run("Convert to Mask");
        rename("bMask");

        imageCalculator("AND create", "hMask", "sMask");
        rename("hsMask");
        imageCalculator("AND create", "hsMask", "bMask");
        rename("finalMask");

        selectWindow("finalMask");
        run("Measure");

        index = nResults - 1;
        coverPct = getResult("%Area", index);

        File.append(slideID + "," + title + "," + d2s(coverPct, 3) + "\n", out);

        close("finalMask");
        close("hsMask");
        close("hMask");
        close("sMask");
        close("bMask");
        close(hueWin);
        close(satWin);
        close(briWin);
        close(title);
    }
}

print("Done. Results saved to:");
print(out);

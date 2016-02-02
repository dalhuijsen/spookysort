
String fn = "source.jpg";
int maxsteps = 36;  //maximum fade length in px
int minsteps = 2;   //minimum fade length in px
Boolean brightmode = false;  //if enabled will fade light over dark
Boolean autotoggle = true;  //switch brightmode at pivot point
float autotogglepivot = 0.85;  //where on the y axis (0-1) to switch
Boolean alternatetoggle = false;
Boolean interactive = true;
PImage img, img1;
float scale = 1.0;
void setup() { 
  PImage _img1 = loadImage(fn);
  img1 = createImage((int)((float)_img1.width*scale), (int)((float)_img1.height*scale), RGB);
  img1.copy(_img1,0,0,_img1.width,_img1.height,0,0,img1.width,img1.height);
  size(img1.width, img1.height, P2D);
  //image(img, 0, 0);
  if ( !interactive)
    noLoop();
  else 
    frameRate(1);
}

void draw() { 
  background(0);
  img = createImage(img1.width, img1.height, RGB);
  img.copy(img1, 0, 0, img1.width, img1.height, 0, 0, img.width, img.height);
  img.loadPixels();
  int steps;
  if ( interactive ) { 
    autotogglepivot = map(mouseY, 0, height, 0, 1);
    maxsteps = (int)map(mouseX, 0, width, minsteps, height);
  }
  for ( int x = 0, w = img.width; x<w; x++) { 
    for ( int h = img.height, y = h-1; y>-1; y--) { 
      if ( alternatetoggle ) { 
        brightmode = !brightmode;
      } else { 
        if ( autotoggle ) { 
          brightmode = y > (h*autotogglepivot);
        }
      }

      float rat = 1.0;
      int pos = x + y * w;
      color c = img.pixels[pos];
      int ty = y;
      steps = (int)map(random(1), 0, 1, minsteps, maxsteps);
      while ( rat > 1.0/steps*2 ) { 
        ty++;
        if ( ty >= h ) break;
        int tpos = x + ty * w;
        color tc = img.pixels[tpos];
        if ( 
        ( !brightmode && brightness(tc) < brightness(c) ) 
          || ( brightmode && brightness(tc) > brightness(c) )
          ) break;
        img.pixels[tpos] = blendC(tc, c, rat);
        rat-= rat/steps;
      }
    }
  }
  img.updatePixels();
  image(img, 0, 0);
  if ( !interactive ) 
    save("result.png");
}
color blendC(color tc, color sc, float rat) { 
  return color(
  (red(tc)*(1.0-rat))+(red(sc)*rat), 
  (green(tc)*(1.0-rat))+(green(sc)*rat), 
  (blue(tc)*(1.0-rat))+(blue(sc)*rat)
    );
}

void keyPressed() { 
  if ( key == ' ' ) { 
    img.save("result.png");
    println("saved");
  }
}


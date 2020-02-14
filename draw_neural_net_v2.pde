/**
 * Draws a simple perceptron and saves it as a PNG as well as an SVG file.
 * Each element of `neurons` array represent a layer of perceptron, denoting the number of neurons
 * in that layer. 
 */

int[] neurons = {5, 3, 5};
int gap = 50;
int w, h;

PGraphics pg;
PrintWriter output;

final String PNG_FILE_PATH = new String("neural_network.png");
final String SVG_FILE_PATH = new String("neural_network.svg");
final String SVG_XMLNS = new String("http://www.w3.org/2000/svg");

// top-left coordinate of the SVG viewbox 
final int X = 0;
final int Y = 0;

/**
 * computes the required space for drawing and set that to width & height
 */
void computeScreenDimensions() {
  w = (neurons.length * gap) + ((neurons.length-1) * gap);
  h = max(neurons) * gap;
}

/**
 * @param axis either 0 or 1. 0 means 'rows' and 1 means 'columns' 
 */
int[] getDimenCentres(int axis, int gap) {
  int dimension = axis * width + (1-axis) * height;
  int boxes = dimension / gap;
  int[] dimen_centres = new int[boxes];
  
  // initialize
  dimen_centres[0] = gap / 2;
  
  for (int i=1;i<boxes;i++) {
    dimen_centres[i] = dimen_centres[i-1] + gap;
  }
  
  return dimen_centres;
}

/**
 * returns a random integer in range [min, max)
 * @param min minimum value
 * @param max maximum value - 1
 */
int getRandomInt(int min, int max) {
  return floor(random(min, max));
}

/**
 * returns a color object with random color
 * @param shade '0' for red, '1' fror green, '2' for blue
 */
color getRandomColor(int shade) {
  shade = (shade + 3) % 3;
  color c = color(0, 0, 0);
  switch (shade) {
    case 0 :
      c = color(getRandomInt(150, 256), getRandomInt(0, 121), getRandomInt(0, 121));
    break;
    case 1 :
      c = color(getRandomInt(0, 121), getRandomInt(150, 256), getRandomInt(0, 121));
    break;	
    case 2 :
      c = color(getRandomInt(0, 121), getRandomInt(0, 121), getRandomInt(150, 256));
    break;
    default :
      c = color(getRandomInt(0, 256), getRandomInt(0, 256), getRandomInt(0, 256));	
  }

  return c;
}

void addSVGHeader(PrintWriter output) {
  String header = String.format("<svg xmlns='%s' viewBox='%d %d %d %d'>", SVG_XMLNS, X, Y, w, h);
  output.println(header);
}

void finaliseSVG(PrintWriter output) {
  String footer = "</svg>";
  output.println(footer);
  output.flush();
  output.close();
}

void svgEllipse(int x, int y, int rx, int ry) {
  String line = String.format("<ellipse cx='%d' cy='%d' rx='%d' ry='%d' style='fill:white;stroke:black;stroke-width:2' />", x, y, rx, ry);
  output.println(line);
}

void svgLine(int x1, int y1, int x2, int y2) {
  String line = String.format("<line x1='%d' y1='%d' x2='%d' y2='%d' style='stroke:rgb(255,0,0);stroke-width:2' />", x1, y1, x2, y2);
  output.println(line);
}

void settings() {
  computeScreenDimensions();
  size(w, h);
}

void setup() {
  pg = createGraphics(width, height, JAVA2D);
  
  // initialising SVG code
  output = createWriter(SVG_FILE_PATH);
  addSVGHeader(output);

  noLoop();
}

void draw() {
  background(0);

  // drawing the picture
  pg.beginDraw();
  drawConnections(neurons, gap);
  drawNodes(neurons, gap);
  pg.endDraw();

  // write close tag and close writer
  finaliseSVG(output);
  println("SVG processed!");

  // saving picture
  pg.save(PNG_FILE_PATH);
  println("Image saved!");
}

void drawMatrix(int gap_x, int gap_y) {
  int x1, y1, x2, y2;
  stroke(0, 0, 90);
  
  // draw vertical lines
  y1=0; y2=height;
  x1 = gap_x;
  while (x1 <= width) {
    line(x1, y1, x1, y2);
    x1 += gap_x;
  }
  
  // draw horizontal lines
  x1 = 0; x2 = width;
  y1 = gap_y;
  while (y1 <= height) {
    line(x1, y1, x2, y1);
    y1 += gap_y;
  }
}

void drawNodes(int[] neurons, int gap) {
  int gap_size = 1;
  int max_layer_size = max(neurons);

  // getting dimension centres
  int[] row_indices = getDimenCentres(0, gap);
  int[] col_indices = getDimenCentres(1, gap);

  // ellipse parameters
  int x, y;
  int r = int(0.7 * gap);

  // FOR DEBUGGING
  int r_svg = 15;

  /* drawing nodes */
  pg.pushStyle();

  pg.strokeWeight(4);
  pg.fill(#f1f1f1);
  int layer_index=0, node_row_index;
  for (int layer=0;layer<neurons.length;layer++) {
    pg.stroke(getRandomColor(layer));
    node_row_index = (max_layer_size - neurons[layer]) / 2;
    for (int i=0;i<neurons[layer];i++) {
      y = row_indices[node_row_index++];
      x = col_indices[layer_index];
      pg.ellipse(x, y, r, r);
      svgEllipse(x, y, r_svg, r_svg);
    }
    layer_index += 1 + gap_size;
  }

  pg.popStyle();
}

void drawConnections(int[] neurons, int gap) {
  // TODO: Clean gap_size and gap;
  int gap_size = 1;

  // getting dimension centres
  int[] row_indices = getDimenCentres(0, gap);
  int[] col_indices = getDimenCentres(1, gap);

  // finding which layer has maximum neurons
  int max_layer_size = max(neurons);

  /* drawing connections */
  pg.pushStyle();
  pg.strokeWeight(3);
  pg.stroke(0);

  // stores the starting row index of the layer
  int[] layer_row_index = new int[neurons.length];
  for (int i=0;i<neurons.length;i++) {
    layer_row_index[i] = (max_layer_size - neurons[i]) / 2;
  }

  // stores the column index of the layer
  int[] layer_col_index = new int[neurons.length];
  for (int i=0;i<neurons.length;i++) {
    layer_col_index[i] = i * (1 + gap_size);
  }

  // draw
  for (int layer=0;layer<neurons.length-1;layer++) {
    for (int i=0;i<neurons[layer];i++) {
      for (int j=0;j<neurons[layer+1];j++) {
        pg.line(col_indices[layer_col_index[layer]], row_indices[layer_row_index[layer]],
        col_indices[layer_col_index[layer+1]], row_indices[layer_row_index[layer+1]]);

        svgLine(col_indices[layer_col_index[layer]], row_indices[layer_row_index[layer]],
        col_indices[layer_col_index[layer+1]], row_indices[layer_row_index[layer+1]]);

        layer_row_index[layer+1] += 1;
      }

      // reset the next layer row index to restart drawing from top node
      layer_row_index[layer+1] = (max_layer_size - neurons[layer+1]) / 2;

      // updating the row_index to start drawing connections from next node
      layer_row_index[layer] += 1;
    }
  }

  pg.popStyle();
}

// styling variables
PFont montserrat;

// algorithm variables
int N = 200;
String TARGET = "The Dark Knight Rises";
float MUTATION_RATE = 0.01f;
Population p = new Population(N, TARGET, MUTATION_RATE);

// counter/metrics variables
int generations = 0;

void setup() {
  size(900, 640);
  background(255);
  //frameRate(30);
  montserrat = loadFont("Montserrat-Medium-24.vlw");
}

void draw() {
  background(255);
  
  // computing fitness
  p.computeFitness();
  
  // creating mating pool
  p.createMatingPool();
  
  // coitus
  p.reproduce();
  
  // recomputing fitness as a new generation has seen light
  p.computeFitness();
  String bestPhrase = p.getBestPhrase();
  String everything = "";
  for (int i = 0; i < N; i++) {
    everything += p.elements[i].getPhrase() + "\n";
  }
  
  // display metrics
  fill(100);
  textSize(20);
  text("Best phrase:", 50, 50);
  
  textSize(48);
  fill(20);
  text(bestPhrase, 50, 100);
  
  textSize(14);
  fill(100);
  text("Everything:", 700, 50);
  text(everything, 700, 70);
  
  text("total generations: " + (++generations), 50, 500);
  text("average fitness: " + p.getAverageFitness(), 50, 520);
  text("total population: " + N, 50, 540);
  text("mutation rate: " + (MUTATION_RATE * 100) + "%", 50, 560);
  
  if (bestPhrase.equals(TARGET)) {
    println(bestPhrase);
    println("total generations: " + generations);
    println("average fitness: " + p.getAverageFitness());
    println("total population: " + N);
    println("mutation rate: " + (MUTATION_RATE * 100));
    noLoop();
  }
}

/**
 * In this Population class, the new child replaces the old Population class
 * as new Population. We'll not be returning a new Population because I'm not going
 * to pay for extra memory!
 * So, recompute fitness to get the best phrase of the child.
 */
public class Population {
  DNA[] elements;
  ArrayList<DNA> matingPool = new ArrayList<DNA>();
  float MUTATION_RATE = 0.0f;
  String target;
  
  int max_index = 0;
  float average_fitness;
  
  public Population(int N, String target, float mutation_rate) {
    elements = new DNA[N];
    
    // initialize elements
    for (int i=0;i<N;i++) { elements[i] = new DNA(); }
    
    this.target = target;
    this.MUTATION_RATE = mutation_rate;
  }
  
  /*
   * computes fitness
   */
  public void computeFitness() {
    float max_fitness = -1.0f;
    average_fitness = 0.0f;
    for (int i=0;i<elements.length;i++) {
      elements[i].fitness(target);
      
      average_fitness += elements[i].fitness / elements.length;    // for average fitness
      
      if (elements[i].fitness > max_fitness) {                     // for max fitness
        max_fitness = elements[i].fitness;
        max_index = i;
      }
    }
  }
  
  /*
   * creates mating pool according to the `wheel of fortune` method.
   */
  public void createMatingPool() {
    matingPool.clear();                                            // a new mating pool for every generation
    for (int i=0;i<elements.length;i++) {
      int n = int(elements[i].fitness * 100);
      for (int j=0;j<n;j++) {
        // adding each member of population n times. Implementing `wheel of fortune`.
        matingPool.add(elements[i]);
      }
    }
  }
  
  /*
   * reproduce according to crossover method.
   */
  public void reproduce() {
    for (int i=0;i<elements.length;i++) {
      // picking up two parents for coitus
      int a, b;
      DNA parentA, parentB;
      a = int(random(matingPool.size()));
      b = int(random(matingPool.size()));
      parentA = matingPool.get(a);
      parentB = matingPool.get(b);
  
      // performing crossover
      DNA child = parentA.crossover(parentB);
  
      // performing mutation
      child.mutate(MUTATION_RATE);
    
      elements[i] = child;
    }
  }
  
  /*
   * returns best phrase of the population
   */
  public String getBestPhrase() {
    return elements[max_index].getPhrase();
  }
  
  public float getAverageFitness() {
    return this.average_fitness;
  }
}
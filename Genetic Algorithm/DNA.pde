public class DNA {
  String TARGET = "The Dark Knight Rises";
  char[] genes = new char[TARGET.length()];
  float fitness;
  
  public DNA() {
    for (int i=0;i<genes.length;i++) {
      genes[i] = (char) random(32, 128);
    }
  }
  
  /*
   * Matching up corresponding characters.
   */
  void fitness(String target) {
    int score = 0;
    for (int i=0;i<genes.length;i++) {
      if (genes[i] == target.charAt(i)) {
        score++;
      }
    }
    
    fitness = float(score)/target.length();  // fitness is the percentage score
  }
  
  /*
   * Using the `random midpoint` method to produce offspring
   */
   DNA crossover(DNA partner) {
     DNA child = new DNA();
     
     int midpoint = int(random(genes.length));
     
     for (int i=0;i<genes.length;i++) {
       if (i > midpoint)
         child.genes[i] = this.genes[i];
       else
         child.genes[i] = partner.genes[i];
     }
     
     return child;
   }
   
   /*
    * perform mutation according to a given rate random method.
    */
   void mutate(float mutationRate) {
     for (int i=0;i<genes.length;i++) {
       if (random(1) < mutationRate) {
         genes[i] = (char) random(32, 128);    // mutation
       }
     }
   }
   
   // converting genes to PHENOTYPE
   String getPhrase() {
     return new String(genes);
   }
}

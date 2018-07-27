class Node {
  color clr;
  boolean deleteMe;
  ArrayList<Node> nextNodes = new ArrayList<Node>();
  ArrayList<Node> prevNodes = new ArrayList<Node>();
  
  void RemoveNodeRelation(Node delNode) {
//    println("OMGWTFBBQ: '" + delNode.toString() + "'");
    for(Node n : nextNodes) {
      if(n == delNode)
        n.deleteMe = true;
    }   
      
    for(Node n : prevNodes) {
//      println("if node '" + n.toString() + "' == '" + delNode.toString() + "'");
      if(n == delNode)        
        n.deleteMe = true;
    }
    
    ArrayList<Node> newNextNodes = new ArrayList<Node>();
    ArrayList<Node> newPrevNodes = new ArrayList<Node>();    
    for(Node n : nextNodes) {
      if(!n.deleteMe)
        newNextNodes.add(n);
    } 
    for(Node n : prevNodes) {
      if(!n.deleteMe)
        newPrevNodes.add(n);
    }    
    nextNodes = newNextNodes;
    prevNodes = newPrevNodes;
  }
  
  void CopyAndUpdatePrevNodes(Node oldNode) {
    for(Node prev : oldNode.prevNodes) {
      prev.nextNodes.add(this);
    }
  }  
  
  void CopyAndUpdateNextNodes(Node oldNode) {
    for(Node next : oldNode.nextNodes) {
      next.prevNodes.add(this);
    }    
  }
}

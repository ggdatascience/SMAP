# Construct neighbours list (graph) from sf polygons
# but without disjoint connected subgraphs in the graph
sf2nb <- function(x, sparse = TRUE) {
  
  # Require packages
  require(igraph)
  require(RANN)
  
  # Get centroid coordinates
  x.coords <- x %>% st_centroid %>% st_coordinates
  
  # Create rook-type adjacency matrix
  x.adj <- st_relate(x, x, pattern = "F***1****", sparse = FALSE)
  
  # Get connected components
  x.comp <- x.adj %>% graph.adjacency %>% components
  
  # While the number of subgraphs is > 1, connect subgraphs by connecting closest neighbours
  # Result: spatial neighbours list without islands
  while(x.comp$no > 1) {
    
    # Split coordinates by subgraph
    x.coords.split <- data.frame(x.coords) %>% split(f = x.comp$membership)
    
    # Distance matrix between all subgraphs
    dist.subgraph <- matrix(Inf, x.comp$no, x.comp$no)
    for (i in 1:(x.comp$no - 1)) {
      for (j in (i + 1):x.comp$no) {
        # Get distances between all points in x.coords.split[[j]] and nearest point in x.coords.split[[i]]
        # Use nn2 function from RANN package for fast nearest neighbour search
        nn.list <- nn2(
          data  = x.coords.split[[i]],
          query = x.coords.split[[j]],
          k = 1)
        # Return nearest distance between x.coords.split[[i]] and x.coords.split[[j]]
        dist.subgraph[i, j] <- with(nn.list, nn.dists[which.min(nn.dists)])
      }
    }

    # Which two subgraphs are the closest to eachother and should be connected?
    index1 <- which(dist.subgraph == min(dist.subgraph), arr.ind = TRUE)
    
    # Which nodes between the two subgraphs should be connected?
    nn.list1 <- nn2(
      data  = x.coords.split[[index1[1]]],
      query = x.coords.split[[index1[2]]],
      k = 1)
    nn.list2 <- nn2(
      data   = x.coords.split[[index1[2]]],
      query = x.coords.split[[index1[1]]],
      k = 1)
    index2 <- c(
      with(nn.list1, nn.idx[which.min(nn.dists)]),
      with(nn.list2, nn.idx[which.min(nn.dists)]))
    
    # Get index number of THE nodes within each subgraph
    x.comp$node.index <- x %>% nrow %>% integer
    for (i in seq_len(x.comp$no)) {
      x.comp <- within(x.comp, node.index[membership == i] <- csize[i] %>% seq_len)
    }
    
    # These two nodes are to be connected
    add <- with(x.comp, c(
      which(membership == index1[1] & node.index == index2[1]),
      which(membership == index1[2] & node.index == index2[2])))
    
    # Make the connection. Should be symmetric
    x.adj[add[1], add[2]] <- x.adj[add[2], add[1]] <- TRUE
    
    # Update connect subgraphs
    x.comp <- x.adj %>% graph.adjacency %>% components
    
  }
  
  # Return adjacency list or matrix
  if (sparse) {
    # sparse = TRUE -> list
    return(x.adj %>% apply(MARGIN = 1, FUN = which))
  } else {
    # sparse = FALSE -> matrix
    return(x.adj)
  }
  
}

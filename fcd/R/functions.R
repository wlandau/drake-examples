# Functions#

#####

## Exp Condition function
fcdConds <- function(nPeople, pEdge, topN) {
  expand.grid(
    nPeople = nPeople,
    pEdge = pEdge,
    topN = topN,
    stringsAsFactors = F
  )
}

#####

# Single function for FCD Network or "True" Network
fcd <- function(nPeople, pEdge, topN) {
  graph_dat <- erdos.renyi.game(
    n = nPeople,
    p.or.m = pEdge,
    directed = F
  ) %>%
    as_edgelist() %>%
    as.data.frame() %>%
    arrange(V1) %>%
    mutate(
      n_connections = sequence(rle(.[, 1])$lengths)
    ) %>%
    group_by(V1)

  if (missing(topN) | is.na(topN)) {
    graph_dat %>%
      .[, c(1, 2)] %>%
      graph_from_data_frame(., directed = F) %>%
      degree_distribution() %>%
      matrix(nrow = 1) %>%
      as.data.frame()
  } else if (!missing(topN)) {
    graph_dat %>%
      top_n(-topN) %>%
      .[, c(1, 2)] %>%
      graph_from_data_frame(., directed = F) %>%
      degree_distribution() %>%
      matrix(nrow = 1) %>%
      as.data.frame()
  }
}

#####

# Experimental function for simulations
fcdSim <- function(nSims = 100, nPeople, pEdge, topN) {
  replicate(n = nSims, expr = fcd(nPeople, pEdge, topN)) %>%
    bind_rows() %>%
    set_names(c(seq_len(ncol(.)))) %>%
    tidyr::gather(key = "deg", value = "freq") %>%
    transmute(deg = as.numeric(deg), freq = as.numeric(freq)) %>%
    cbind(simRun = rep(c(1:nSims), max(.[, 1])), .) %>%
    arrange(deg, simRun) %>%
    cbind(nPeople, pEdge, topN, .)
}

#####

# Plotting Function
plotFunc <- function(x) {
  ggplot(data = x) +
    geom_line(aes(x = deg, y = freq, group = simRun)) +
    xlim(c(0, 100))
}

#Experimental Conditions

conds <- fcdConds(nPeople = c(1000,100,10), pEdge = c(0.75,0.5,0.25), topN = c(NA, 5, 10))

plan <- drake_plan(
  ddist_i = target(
    fcdSim(nSims = 100, nPeople = nPeople,pEdge = pEdge, topN = topN),
    transform = map(nPeople, pEdge, topN, .data = !!conds)
  ),
  ddist = target(
    bind_rows(ddist_i),
    transform = combine(ddist_i)
  )
)
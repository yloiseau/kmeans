
module perfs

import kmeans

function main = |args| {
  let points = loadDatafile("../points.json")
  let iterations = 100 # 100
  let start = System.currentTimeMillis()
  iterations: times(-> run(points, 10, 15))
  let total = (System.currentTimeMillis() - start) / iterations
  println("Made %d iterations with an average of %d milliseconds": format(iterations, total))
}

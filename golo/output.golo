
module output

import kmeans

function main = |args| {
  let prt = |p| -> String.format(java.util.Locale("C"), "(%.6f,%.6f)", p: x(), p: y())
  let ptsrt = asInterfaceInstance(java.util.Comparator.class, |p1, p2| -> match {
    when p1: x() > p2: x() then 1
    when p1: x() < p2: x() then -1
    otherwise match {
      when p1: y() > p2: y() then 1
      when p1: y() < p2: y() then -1
      otherwise 0
    }
  })
  let points = loadDatafile("../points.json")
  let result = run(points, 10, 15)
  foreach k in java.util.ArrayList(result: keySet()): ordered(ptsrt) {
    println("==")
    println("# " + prt(k) + " #")
    foreach v in result: get(k): ordered(ptsrt) {
      println("  " + prt(v))
    }
  }
}


module kmeans

import java.lang.Math
import java.util

struct Point = {x, y}
augment Point {
  function scale = |this, s| -> Point(this: x() / s, this: y() / s)
}

let ORIGIN = Point(0.0, 0.0)

function pointFromCouple = |c| -> Point(c: get(0), c: get(1))

function add = |p1, p2| -> Point(p1: x() + p2: x(), p1: y() + p2: y())

function sq = |x| -> x * x

function distance = |p1, p2| -> sqrt(sq(p1: x() - p2: x()) + sq(p1: y() - p2: y()))

function compareDistance = |ref| -> |p1, p2| -> match {
  when distance(ref, p1) < distance(ref, p2) then p1
  otherwise p2
}

function closest = |p, ps| -> ps: tail(): reduce(ps: head(), compareDistance(p))

function average = |points| -> points: reduce(ORIGIN, ^add): scale(points: size())

function groupBy = |points, centroids| {
  let groups = map[]
  foreach point in points {
    let center = closest(point, centroids)
    groups: addIfAbsent(center, list[])
    groups: get(center): add(point)
  }
  return groups
}

# Map: values() is not a list, so it can't be mapped... grrrr
function update = |points, centroids| ->
  LinkedList(groupBy(points, centroids): values()): map(^average)


function run = |xs, n, iters| {
  var centroids = xs: subList(0, n)
  foreach i in range(0, iters) {
    centroids = update(xs, centroids)
  }
  return groupBy(xs, centroids)
}

function main = |args| {
  let points = JSON.parse(fileToText("../points.json", "UTF-8")): map(^pointFromCouple)
  let iterations = 1000
  let start = System.currentTimeMillis()
  iterations: times(-> run(points, 10, 15))
  let total = (System.currentTimeMillis() - start) / iterations
  println("Made %d iterations with an average of %d milliseconds": format(iterations, total))
}

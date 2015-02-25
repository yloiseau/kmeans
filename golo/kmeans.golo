
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

#function closest = |p, ps| -> ps: tail(): reduce(ps: head(), compareDistance(p))
function closest = |p, ps| {
  let tail = ps: tail()
  var acc = ps: head()
  foreach point in tail {
    if distance(p, acc) > distance(p, point) {
      acc = point
    }
  }
  return acc
}

# function average = |points| -> points: reduce(ORIGIN, ^add): scale(points: size())
function average = |points| {
  var acc = ORIGIN
  let size = points: size()
  foreach point in points {
    acc = add(acc, point)
  }
  return acc: scale(size)
} 

function groupBy = |points, centroids| {
  let groups = map[]
  foreach point in points {
    let center = closest(point, centroids)
    groups: addIfAbsent(center, -> list[])
    groups: get(center): add(point)
  }
  return groups
}

#function update = |points, centroids| ->
 # LinkedList(groupBy(points, centroids): values()): map(^average)
function update = |points, centroids| {
  let values = groupBy(points, centroids): values()
  let result = list[]
  foreach value in values {
    result: add(average(value))
  }
  return result
}

function run = |xs, n, iters| {
  var centroids = xs: subList(0, n)
  foreach i in range(0, iters) {
    centroids = update(xs, centroids)
  }
  return groupBy(xs, centroids)
}

function loadDatafile = |file| -> JSON.parse(fileToText(file, "UTF-8")): map(^pointFromCouple)

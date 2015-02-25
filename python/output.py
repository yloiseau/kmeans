
import json

from kmeans import Point, run

if __name__ == "__main__":
    sortedPoints = lambda ps: sorted(ps, key=lambda p: (p.x, p.y))
    with open("../points.json") as f:
        points = map(lambda x: Point(x[0],x[1]),json.loads(f.read()))
    result = run(points, 10)
    for k in sortedPoints(result.keys()):
        print "==\n# %s #" % k
        print '\n'.join("  " + str(p) for p in sortedPoints(result[k]))

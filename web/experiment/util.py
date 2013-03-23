# -*- coding: utf-8 -*-

import math

def color_distance(c1, c2):
    d = 0
    for i in range(3):
        d += math.sqrt(abs(pow(c1[i], 2) - pow(c2[i], 2)))
    return d

def palette_distance(p1, p2):
    d = 0
    for i in range(3):
        d += color_distance(p1[i], p2[i])
    return d

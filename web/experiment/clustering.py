# -*- coding: utf-8 -*-

import itertools
import json
from util import *

class Cluster:
    def __init__(self, centroid):
        self.centroid = centroid

    def update(self, palettes):
        self.palettes = palettes
        old = self.centroid
        new = self.calculateCentroid()
        if new:
            self.centroid = new
            return palette_distance(old, self.centroid)
        return 0

    def calculateCentroid(self):
        if len(self.palettes) == 0:
            return None
            
        centroid = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]        
        for palette_key in self.palettes:
            palette = self.palettes[palette_key]
            for i, color in enumerate(palette):
                for j, val in enumerate(color):
                    centroid[i][j] += val
        for i in range(3):
            for j in range(3):
                centroid[i][j] /= len(self.palettes)
        return centroid


def kmeans():
    
    palettes = None
    with open('palette.json') as f:
        palettes = json.load(f)

    # k = 6C3 = 20
    RED = [255, 0, 0]
    GREEN = [0, 255, 0]
    BLUE = [0, 0, 255]
    PURPLE = [255, 0, 255]
    ORANGE = [255, 127, 0]
    YELLOW = [255, 255, 0]
    CREAM = [255, 255, 127]
    CYAN = [0, 255, 255]
    BLACK = [0, 0, 0]    
    GRAY = [128, 128, 128]
    WHITE = [255, 255, 255]

    colors = [BLACK, RED, GREEN, BLUE, PURPLE, ORANGE, YELLOW, CREAM, CYAN, GRAY, WHITE]
    base_palettes = [sorted(base_palette, key=lambda x:((x[0]<<16)+(x[1]<<8)+x[2]))
                     for base_palette in itertools.combinations(colors, 3)]
    print base_palettes
    clusters = [Cluster(bp) for bp in base_palettes]

    prev_shift = 0
    idle = 0
    while True:
        lists = []
        for c in clusters: lists.append({})
        for palette_key in palettes:
            palette = palettes[palette_key]
            cluster_index = 0
            nearest = palette_distance(clusters[0].centroid, palette)
            for i, cluster in enumerate(clusters[1:]):
                d = palette_distance(cluster.centroid, palette)
                if nearest > d:
                    nearest = d
                    cluster_index = i
            lists[cluster_index][palette_key] = palette

        shift = 0
        for i, cluster in enumerate(clusters):
            shift = max(shift, cluster.update(lists[i]))

        print shift, prev_shift, idle
        if shift < prev_shift:
            idle = 0
        else:
            idle += 1

        prev_shift = shift
        if idle >= 3:
            break


    # for c in clusters:
    #     print c.centroid, len(c.palettes)

    return clusters

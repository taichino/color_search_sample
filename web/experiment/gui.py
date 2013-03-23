#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from PySide import QtCore, QtGui

from clustering import kmeans

from itertools import islice, chain

def batch(iterable, size):
    sourceiter = iter(iterable)
    while True:
        batchiter = islice(sourceiter, size)
        yield chain([batchiter.next()], batchiter)

class MainWidget(QtGui.QWidget):
    def __init__(self):
        super(MainWidget, self).__init__()
        self.setWindowTitle('Clustering')
        
        cw = ClustersWidget()
        scroll = QtGui.QScrollArea()
        scroll.setWidget(cw)

        layout = QtGui.QVBoxLayout()
        layout.addWidget(scroll)
        self.setLayout(layout)

        self.resize(800, 600)

class ClustersWidget(QtGui.QWidget):
    def __init__(self):
        super(ClustersWidget, self).__init__()

        layout = QtGui.QVBoxLayout()
        clusters = kmeans()
        for cluster in clusters:
            if len(cluster.palettes) == 0: continue
            cw = ClusterWidget(cluster)
            layout.addWidget(cw)
        self.setLayout(layout)


class ClusterWidget(QtGui.QWidget):
    def __init__(self, cluster):
        super(ClusterWidget, self).__init__()
        
        p = PaletteWidget(cluster.centroid)
        layout = QtGui.QVBoxLayout()
        layout.addWidget(p)
        for group in batch(cluster.palettes.items(), 4):
            row_layout = QtGui.QHBoxLayout()
            for filename, palette in group:
                tw = ThumbnailWidget(filename, palette)
                row_layout.addWidget(tw)
            layout.addLayout(row_layout)
        self.setLayout(layout)


class ThumbnailWidget(QtGui.QWidget):
    def __init__(self, filename, palette):
        super(self.__class__, self).__init__()
        
        layout = QtGui.QVBoxLayout()
        path = 'img/{0}'.format(filename)
        image = QtGui.QImage(path)
        self.imageLabel = QtGui.QLabel()
        self.imageLabel.setPixmap(QtGui.QPixmap.fromImage(image).scaledToHeight(100))
        self.paletteWidget = PaletteWidget(palette, box_size=15)
        layout.addWidget(self.imageLabel)
        layout.addWidget(self.paletteWidget)
        self.setLayout(layout)


class PaletteWidget(QtGui.QPushButton):

    def __init__(self, colors, box_size=25):
        super(self.__class__, self).__init__()
        self.box_size = box_size
        self.setSizePolicy(
            QtGui.QSizePolicy(QtGui.QSizePolicy.Fixed,
                              QtGui.QSizePolicy.Fixed,
                              QtGui.QSizePolicy.PushButton))
        self.colors = colors
        self.update()

    def sizeHint(self):
        return QtCore.QSize(self.box_size * len(self.colors) * 2, self.box_size * 2)

    def paintEvent(self, e):
        ctx = QtGui.QPainter()
        ctx.begin(self)

        w = h = self.box_size
        for i, color in enumerate(self.colors):
            x = (w + 5) * i + 3
            y = 10
            ctx.setBrush(QtGui.QColor(*color))
            ctx.drawRect(x, y, w, h)

        ctx.end()



if __name__ == '__main__':
    app = QtGui.QApplication(sys.argv)
    mw = MainWidget()
    mw.show()
    sys.exit(app.exec_())
    

# -*- coding: utf-8 -*-

import os

from django.db import models

import requests
from PIL import Image as PIL_Image

class Color(models.Model):
    R = models.IntegerField(default=0)
    G = models.IntegerField(default=0)
    B = models.IntegerField(default=0)

    @staticmethod
    def get_nearest(R, G, B):
        R = int((R + 16) / 32) * 32
        G = int((G + 16) / 32) * 32
        B = int((B + 16) / 32) * 32

        return Color.objects.filter(R=R, G=G, B=B)[0]

    def __str__(self):
        return '<Color R={0}, G={1}, B={2}>'.format(self.R, self.G, self.B)


class ImageManager(models.Manager):
    def get_or_create_or_update(self, url, num):
        resp = requests.get(url)
        if resp.status_code != 200:
            raise "ERR status code: %s" % (resp.status_code)
        
        filename = '{0:03d}.jpg'.format(num)
        path = os.path.join('media', 'img', filename)
        with open(path, 'wb') as f:
            for chunk in resp.iter_content():
                f.write(chunk)

        pil_image = PIL_Image.open(path)
        orig_width = pil_image.size[0]
        factor = float(150) / orig_width
        width = int(pil_image.size[0] * factor)
        height = int(pil_image.size[1] * factor)
        
        pil_image = pil_image.resize([width, height])
        pil_image.save(path)
        
        obj, created = self.get_or_create(path=path)
        obj.width = width
        obj.height = height
        obj.orig_url = url

        return obj
        

class Image(models.Model):
    objects = ImageManager()
    
    path = models.CharField(max_length=128, unique=True)
    orig_url = models.TextField()
    width = models.IntegerField(default=0)
    height = models.IntegerField(default=0)
    dominant_color = models.ForeignKey(Color, related_name='dominant_color', blank=True, null=True)
    colors = models.ManyToManyField(Color)


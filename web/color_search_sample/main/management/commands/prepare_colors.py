# -*- coding: utf-8 -*-

from django.core.management.base import BaseCommand, CommandError
from main.models import Color

class Command(BaseCommand):
    def handle(self, *args, **kwargs):
        print 'Preparing color data...'

        for R in range(0, 256 + 1, 16):
            for G in range(0, 256 + 1, 16):
                for B in range(0, 256 + 1, 16):
                    try:
                        Color.objects.get(R=R, G=G, B=B)
                    except:
                        c = Color(R=R, G=G, B=B)
                        c.save()

        print 'Done...'
                    

# -*- coding: utf-8 -*-

import json
from django.conf import settings
from django.http import HttpResponse

def mono_color(request):
    catalog = []
    for i in range(10):
        catalog.append('/media/img/{0:03d}.jpg'.format(i))
    
    return HttpResponse(json.dumps(catalog), mimetype='application/json')

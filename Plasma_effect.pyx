###cython: boundscheck=False, wraparound=False, nonecheck=False

import pygame
import numpy
cimport cython
from cython.parallel cimport prange

from libc.math cimport sin, sqrt, cos, atan2, pi, round, floor, fmax, fmin, pi, tan, exp, ceil, fabs

DEF ONE_TWELVE = 1.0/12.0
DEF ONE_TENTH = 1.0/10.0
DEF ONE_FIFTH = 1.0/5.0
DEF ONE_SIXTH = 1.0/6.0
DEF ONE_HEIGHT = 1.0/8.0
DEF ONE_FOURTH = 1.0/4.0
DEF HALF = 1.0/2.0

def plasma(width, height, frame):
    return plasma_c(width, height, frame)
@cython.boundscheck(False)
@cython.wraparound(False)
@cython.nonecheck(False)
@cython.cdivision(True)
cdef inline plasma_c(int width, int height, int frame):
    cdef:
        float xx, yy, t
        float h, s, v
        unsigned char [:, :, ::1] pix = numpy.zeros([width, height, 3], dtype=numpy.uint8)
        int i = 0, x, y
        float f, p, q, t_
        float hue, r, g, b

    t = float(frame)
    with nogil:
        for x in prange(width):
            for y in range(height):
                xx = float(x * HALF)
                yy = float(y * HALF)

                hue = 4 + sin((xx * ONE_FOURTH + t) * ONE_TWELVE) + sin((yy + t) * ONE_TENTH) \
                      + sin((xx* HALF + yy * HALF) * ONE_TENTH) + sin(sqrt(xx * xx + yy * yy + t) * ONE_TWELVE)
                h, s, v = hue * ONE_SIXTH, hue * ONE_SIXTH, hue * ONE_HEIGHT


                # hue =  sin((xx/4.0 + t) * 0.05) + sin((yy + t) * 0.05) \
                #          + sin((xx/2.0 + yy/2.0) * 0.05)
                # hue = hue + sin(sqrt(((xx - width/4) * (xx - width/4) + (yy - height/4)*(yy - height/4))+ t ) * 1/12)
                #
                # h, s, v = hue/4, hue * 1/5, hue/3

                # h = 0
                i = <int>(h * 6.0)
                f = (h * 6.0) - i
                p = v*(1.0 - s)
                q = v*(1.0 - s * f)
                t_ = v*(1.0 - s * (1.0 - f))
                i = i % 6

                if i == 0:
                    r, g, b =  v, t, p
                if i == 1:
                     r, g, b = q, v, p
                if i == 2:
                     r, g, b = p, v, t
                if i == 3:
                     r, g, b = p, q, v
                if i == 4:
                     r, g, b = t_, p, v
                if i == 5:
                     r, g, b = v, p, q

                if s == 0.0:
                     r, g, b = v, v, v

                pix[x, y, 0], pix[x, y, 1], pix[x, y, 2] = <unsigned char>(r * 255.0),\
                                                           <unsigned char>(g * 255.0),\
                                                           <unsigned char>(b * 255.0)
    # return the array
    return numpy.asarray(pix)


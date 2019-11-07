import pygame
import numpy
import time

from Plasma_effect import plasma

if __name__ == "__main__":
    pygame.init()
    w, h = 1280, 1024
    SCREENRECT = pygame.Rect(0, 0, w, h)
    screen = pygame.display.set_mode(SCREENRECT.size, pygame.FULLSCREEN, 32)
    frame = 0
    # palette_ = palette(w, h)
    CLOCK = pygame.time.Clock()
    while 1:
        keys = pygame.key.get_pressed()
        pygame.event.pump()
        if keys[pygame.K_F8]:
            pygame.image.save(screen, 'screenshot.png')
        if keys[pygame.K_ESCAPE]:
            break
        pygame.surfarray.blit_array(screen, plasma(w, h, frame))
        frame += 5
        TIME_PASSED_SECONDS = CLOCK.tick(60)

        pygame.display.flip()

    pygame.quit()

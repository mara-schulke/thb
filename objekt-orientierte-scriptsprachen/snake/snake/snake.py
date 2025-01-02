# 20215853, mara.schulke@th-brandenburg.de

import random

import pygame

# colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
CYAN = (0, 255, 255)
MAGENTA = (255, 0, 255)
RED = (255, 0, 0)
GREEN = (0, 255, 0)
BLUE = (0, 0, 255)

CHROMA_OFFSET_BLOCKS = 1
CHROMA_OFFSET_TEXT = 2

# window size
WIDTH, HEIGHT = 600, 400

# game settings
SNAKE_SPEED = 20
SCORE_STEP = 100
BLOCK_SIZE = 20


class Snake:
    def __init__(self):
        self.size = BLOCK_SIZE
        self.list = [[WIDTH // 2, HEIGHT // 2]]
        self.direction = "RIGHT"

    def move(self):
        head = self.list[-1].copy()

        if self.direction == "RIGHT":
            head[0] += self.size
        elif self.direction == "LEFT":
            head[0] -= self.size
        elif self.direction == "UP":
            head[1] -= self.size
        elif self.direction == "DOWN":
            head[1] += self.size

        head[0] = head[0] % WIDTH
        head[1] = head[1] % HEIGHT

        self.list.append(head)
        self.list.pop(0)

    def grow(self):
        head = self.list[-1].copy()
        if self.direction == "RIGHT":
            head[0] += self.size
        elif self.direction == "LEFT":
            head[0] -= self.size
        elif self.direction == "UP":
            head[1] -= self.size
        elif self.direction == "DOWN":
            head[1] += self.size

        self.list.append(head)

    def change_direction(self, direction):
        self.direction = direction

    def draw(self, surface):
        for part in self.list:
            pygame.draw.rect(surface, RED, [part[0] - CHROMA_OFFSET_BLOCKS, part[1], self.size, self.size])
            pygame.draw.rect(surface, GREEN, [part[0] - CHROMA_OFFSET_BLOCKS / 2, part[1], self.size, self.size])
            pygame.draw.rect(surface, BLUE, [part[0] + CHROMA_OFFSET_BLOCKS, part[1], self.size, self.size])
            pygame.draw.rect(surface, CYAN, [part[0], part[1], self.size, self.size])

class Fruit:
    def __init__(self):
        self.size = BLOCK_SIZE
        self.position = [random.randrange(1, (WIDTH // self.size)) * self.size, random.randrange(1, (HEIGHT // self.size)) * self.size]

    def draw(self, surface):
        pygame.draw.rect(surface, RED, [self.position[0] - CHROMA_OFFSET_BLOCKS, self.position[1], self.size, self.size])
        pygame.draw.rect(surface, GREEN, [self.position[0], self.position[1] - CHROMA_OFFSET_BLOCKS, self.size, self.size])
        pygame.draw.rect(surface, BLUE, [self.position[0] + CHROMA_OFFSET_BLOCKS, self.position[1], self.size, self.size])
        pygame.draw.rect(surface, MAGENTA, [self.position[0] + CHROMA_OFFSET_BLOCKS, self.position[1], self.size, self.size])

    def respawn(self):
        self.position = [random.randrange(1, (WIDTH // self.size)) * self.size, random.randrange(1, (HEIGHT // self.size)) * self.size]

class Game:
    def __init__(self):
        # pygame
        pygame.display.set_caption('Snake')
        self.font = pygame.font.SysFont("Courier", BLOCK_SIZE, bold=True)
        self.clock = pygame.time.Clock()
        self.display = pygame.display.set_mode((WIDTH, HEIGHT))

        # state
        self.snake = Snake()
        self.fruit = Fruit()
        self.score = 0
        self.paused = False

    def toggle_pause(self):
        self.paused = not self.paused

    def reset(self):
        self.snake = Snake()
        self.fruit = Fruit()
        self.score = 0
        self.paused = False

    def draw_text(self, text, x, y):
        red = self.font.render(text, True, RED)
        green = self.font.render(text, True, GREEN)
        blue = self.font.render(text, True, BLUE)

        self.display.blit(red, (x - CHROMA_OFFSET_TEXT, y))
        self.display.blit(green, (x, y - CHROMA_OFFSET_TEXT))
        self.display.blit(blue, (x + CHROMA_OFFSET_TEXT, y))

        white = self.font.render(text, True, WHITE)
        self.display.blit(white, (x, y))

    def draw_score(self, score):
        score_text = 'Score: {}'.format(score)
        self.draw_text(score_text, 10, HEIGHT - 30)

    def draw_scanlines(self, line_spacing):
        for y in range(0, HEIGHT, line_spacing):
            pygame.draw.line(self.display, (5, 5, 5), (0, y), (WIDTH, y))

    def run(self):
        game_over = False

        while not game_over:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    game_over = True
                elif event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_LEFT and self.snake.direction != "RIGHT":
                        self.snake.change_direction("LEFT")
                    elif event.key == pygame.K_RIGHT and self.snake.direction != "LEFT":
                        self.snake.change_direction("RIGHT")
                    elif event.key == pygame.K_UP and self.snake.direction != "DOWN":
                        self.snake.change_direction("UP")
                    elif event.key == pygame.K_DOWN and self.snake.direction != "UP":
                        self.snake.change_direction("DOWN")
                    elif event.key == pygame.K_SPACE:
                        self.toggle_pause()
                    elif event.key == pygame.K_r:
                        self.reset()
                    elif event.key == pygame.K_q:
                        game_over = True

            if not self.paused:
                self.snake.move()

                if self.snake.list[-1] == self.fruit.position:
                    self.snake.grow()
                    self.fruit.respawn()
                    self.score += SCORE_STEP

                self.display.fill(BLACK)
                self.snake.draw(self.display)
                self.fruit.draw(self.display)
                
                self.draw_score(self.score)
                self.draw_scanlines(2)

                pygame.display.update()

                for block in self.snake.list[:-1]:
                    if block == self.snake.list[-1]:
                        game_over = True
                        break
            else:
                self.display.fill(BLACK)
                self.draw_text("GAME PAUSED", WIDTH // 2 - 65, 50)

                self.draw_text("** MENU **", WIDTH // 2 - 57.5, 100)
                self.draw_text("PRESS SPACE TO UNPAUSE", WIDTH // 2 - 135, 150)
                self.draw_text("PRESS R TO RESTART", WIDTH // 2 - 110, 175)
                self.draw_text("PRESS Q TO QUIT", WIDTH // 2 - 90, 200)
                self.draw_scanlines(2)

                pygame.display.update()

            self.clock.tick(SNAKE_SPEED)

        print("")
        print(f"====== SCORED {self.score} POINTS ======")
        print("")

        pygame.quit()

def main():
    pygame.init()
    game = Game()
    game.run()

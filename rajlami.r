draw.board <- function(game) {
  xo <- c("X", " ", "O") # Symbols
  par(mar = rep(1,4))
  plot.new()
  plot.window(xlim = c(0,30), ylim = c(0,30))
  abline(h = c(10, 20), col = "darkgrey", lwd = 4)
  abline(v = c(10, 20), col = "darkgrey", lwd = 4)
  text(rep(c(5, 15, 25), 3), c(rep(25, 3), rep(15,3), rep(5, 3)), 
       xo[game + 2], cex = 4)
  # Identify location of any three in a row
  square <- matrix(game, nrow = 3, byrow = TRUE)
  hor <- abs(rowSums(square))
  if (any(hor == 3)) 
    hor <- (4 - which(hor == 3)) * 10 - 5 
  else 
    hor <- 0
  ver <- abs(colSums(square))
  if (any(ver == 3)) 
    ver <- which(ver == 3) * 10 - 5 
  else
    ver <- 0
  diag1 <- sum(diag(square))
  diag2 <- sum(diag(t(apply(square, 2, rev)))) 
  # Draw winning lines 
  if (all(hor > 0))
    for (i in hor)
      lines(c(0, 30), rep(i, 2), lwd = 10, col="red")
  if (all(ver > 0))
    for (i in ver)
      lines(rep(i, 2), c(0, 30), lwd = 10, col="red")
  if (abs(diag1) == 3)
    lines(c(2, 28), c(28, 2), lwd = 10, col = "red")
  if (abs(diag2) == 3)
    lines(c(2, 28), c(2, 28), lwd = 10, col = "red")
}
move.human <- function(game) {
  text(4, 0, "Click on screen to move", col = "grey", cex=.7)
  empty <- which(game == 0)
  move <- 0
  while (!move %in% empty) {
    coords <- locator(n = 1) # add lines
    coords$x <- floor(abs(coords$x) / 10) + 1
    coords$y <- floor(abs(coords$y) / 10) + 1
    move <- coords$x + 3 * (3 - coords$y)
  }
  return(move)
}
ganador <- function(juego, player) {
  game <- matrix(juego, nrow = 3, byrow = T)
  hor <- rowSums(game)
  ver <- colSums(game)
  diag <- c(sum(diag(game)), sum(diag(apply(game, 1, rev))))
  if (-3 %in% c(hor, ver, diag))
    return(-10)
  if (3 %in% c(hor, ver, diag))
    return(10)
  else
    return(0)
}
minimax <- function(juego, player) {
  free <- which(juego == 0)
  if(length(free) == 1) {
    juego[free] <- player
    return(list(move = free, U = ganador(juego, player)))
  }
  poss.results <- rep(0, 9)
  for(i in free) {
    game <- juego
    game[i] <- player
    poss.results[i] <- ganador(game, player)
  }
  mm <- ifelse(player == -1, "which.min", "which.max")
  if(any(poss.results == (player * 10))) {
    move <- do.call(mm, list(poss.results))
    return(list(move = move, U = poss.results[move]))
  }
  for(i in free) {
    game <- juego
    game[i] <- player
    poss.results[i] <- minimax(game, -player)$U
  }
  random <- runif(9, 0, 0.1)
  poss.results[-free] <- 100 * -player
  poss.results <- poss.results + (player * random)
  move <- do.call(mm, list(poss.results))
  return(list(move = move, U = poss.results[move]))
}
tic.tac.toe <- function(player1 = "human", player2 = "computer") {
  game <- rep(0, 9) # Empty board
  winner <- 0 # Define winner
  player <- 1 # First player
  players <- c(player1, player2)
  draw.board(game)
  while (0 %in% game & winner == 0) { # Keep playing until win or full board
    if (players[(player + 3) %% 3] == "human") # Human player
      move <- move.human(game)
    else { # Computer player
      move <- minimax(game, player)[[1]]
    }
    game[move] <- player # Change board
    draw.board(game)
    winner <- ganador(game, player)
    player <- -player # Change player
  }
  if (winner == 0)
    text(15, 15 , "DRAW", col = "red", cex = 10)
}

tic.tac.toe()
library(animation)

## WAR GAMES TIC TAC TOE
draw.board.wargames <- function(game) {
  xo <- c("X", " ", "O") # Symbols
  par(mar = rep(1,4), bg = "#050811")
  plot.new()
  plot.window(xlim = c(0,30), ylim = c(0,30))
  abline(h = c(10, 20), col = "#588fca", lwd = 20)
  abline(v = c(10, 20), col = "#588fca", lwd = 20)
  text(rep(c(5, 15, 25), 3), c(rep(25, 3), rep(15,3), rep(5, 3)), xo[game + 2],
       cex = 20, col = "#588fca")
  text(0, 0, "lucidmanager.org", col = "#588fca", cex = 2, adj = 0)
  ## Identify location of any three in a row
  square <- t(matrix(game, nrow = 3))
  hor <- abs(rowSums(square))
  if (any(hor == 3)) 
    hor <- (4 - which(hor == 3)) * 10 - 5 
  else 
    hor <- 0
  ver <- abs(colSums(square))
  if (any(ver == 3)) 
    ver <- which(ver == 3) * 10 - 5 
  else
    ver <- 0
  diag1 <- sum(diag(square))
  diag2 <- sum(diag(t(apply(square, 2, rev)))) 
  ## Draw winning lines 
  if (all(hor > 0)) for (i in hor) lines(c(0, 30), rep(i, 2), lwd = 20, col="#588fca")
  if (all(ver > 0)) for (i in ver) lines(rep(i, 2), c(0, 30), lwd = 20, col="#588fca")
  if (abs(diag1) == 3) lines(c(2, 28), c(28, 2), lwd = 20, col = "#588fca")
  if (abs(diag2) == 3) lines(c(2, 28), c(2, 28), lwd = 20, col = "#588fca")
}
saveGIF ({
  for (i in 1:10) {
    game <- rep(0, 9) # Empty board
    winner <- 0 # Define winner
    player <- -1 # First 
    while (0 %in% game & winner == 0) {
      empty <- which(game == 0) # Define empty squares
      if (length(empty) == 9)
        move <- empty[sample(length(empty), 1)] # Random move
      else
        move <- minimax(game, player)[[1]]
      game[move] <- player # Change board
      draw.board.wargames(game)
      winner <- ganador(game) # Evaulate game
      player <- -player) # Change player
    }
  }
}


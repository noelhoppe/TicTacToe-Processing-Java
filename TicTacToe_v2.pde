/*
Kodierung und Repräsentation
+1 --> X
-1 --> O
0 --> leeres Feld
*/

int boardSize = 600; // playground's width and height in px
TicTacToe ttt;

void setup() {
  windowResize(boardSize, boardSize);
  background(0);  // schwarzer Hintergrund
  ttt = new TicTacToe();
}

void draw() {
  ttt.drawGrid();
  ttt.displayWinner();
}

void mousePressed() {
  ttt.drawSymbols();
}

void keyPressed() {
 if (ttt.isDraw() || ttt.checkWin() == 1 || ttt.checkWin() == -1) // das Spiel muss beendet sein, ansonsten kann man nicht neustarten
   restartGame();
}

void restartGame() {
  background(0);
  ttt = new TicTacToe();
}


class TicTacToe {
  int[] board = new int[9];
  int player = int(random(2)) == 0 ? -1 : 1; // lege zufällig ersten Spieler (1 --> X oder -1 --> O) fest
  int cellSize = boardSize / 3;
  
  void drawGrid() { // draw board's basic structure (lines)
    if (boardSize % 3 != 0)  // cellSize ist eine Ganzzahl
      throw new IllegalArgumentException("boardSize has to be multiple of 3");
    for (int i = 1; i <= 2; i++) { // zeichne Linien
     stroke(255);  // Linien sind weiß
     line(i * cellSize, 0, i * cellSize, boardSize);  // vertical
     line(0, i *  cellSize, boardSize, i * cellSize); //horizontal
    }
  }
  
  int getIndex() { // get field index depending on mouse's x and y position
    if (mouseY <= cellSize) { // first line
      if (mouseX <= cellSize)
        return 0;
      if (mouseX <= 2 * cellSize) 
        return 1;
      if (mouseX <= boardSize) 
        return 2;
    }
    if (mouseY <= 2 * cellSize) { // second line
      if (mouseX <= cellSize)
        return 3;
      if (mouseX <= 2 * cellSize) 
        return 4;
      if (mouseX <= boardSize) 
        return 5;
    }
    if (mouseY <= boardSize) { // third line
      if (mouseX <= cellSize)
        return 6;
      if (mouseX <= 2 * cellSize) 
        return 7;
      if (mouseX <= boardSize) 
        return 8;
    }
    return -1;
  }
  
  boolean isEmpty(int index) {
    return board[index] == 0;
  }
  
  boolean isDraw() { // prüfe auf unentschieden
   for (int player : board) {
     if (player == 0)
       return false;  // board enthält mindestens ein leeres Feld
   }
   return checkWin() == 0; // prüfe, ob auch wirklich kein anderer Spieler gewonne hat
  }
  
  void drawSymbols() {
    int space = cellSize / 10;
    int posX = (getIndex() * cellSize) % boardSize;
    int posY = getIndex() <= 2 ? 0 : getIndex() <= 5 ? cellSize : 2 * cellSize;
    if (isEmpty(getIndex())) { // draw in empty fields only
      strokeWeight(10);
      if (player == -1) { // draw 'O'
        board[getIndex()] = -1;
        stroke(0, 0, 255); // blaue Umrandung
        fill(0); // schwarze Füllung
        circle(posX + cellSize / 2, posY + cellSize / 2, cellSize - space);
      }
      if (player == 1) {
        board[getIndex()] = 1;
        stroke(255, 0, 0); // rote Linien
        line(posX + space, posY + space, posX + cellSize - space, posY + cellSize - space); // oben links nach unten rechts
        line(posX + cellSize - space, posY + space, posX + space, posY + cellSize - space); // oben rechts nach unten links
      }
      strokeWeight(1); // reset strokeWeight
      togglePlayer();
    }
  }
  
  void togglePlayer() {
     player = player == 1 ? -1 : 1; 
  }
  
  int checkWin() {
    int[][] winCombinations = {
      {0, 1, 2}, {3, 4, 5}, {6, 7, 8}, // drei in Reihe
      {0, 3, 6}, {1, 4, 7}, {2, 5, 8}, // drei in Spalte
      {0, 4, 8}, {2, 4, 6} // diagonal
    };
    for (int i = 0; i <= winCombinations.length - 1; i++) { // iterate each single winCombination
      // pick indizes
      int firstIndex = winCombinations[i][0];
      int secondIndex = winCombinations[i][1];
      int thirdIndex = winCombinations[i][2];
      if (board[firstIndex] != 0 && board[firstIndex] == board[secondIndex] && board[secondIndex] == board[thirdIndex]) { // == ist transitiv, erste Prüfung stellt sicher, dass die Felder nicht leer sind
        return board[firstIndex];
      }
    }
    return 0; // Kein Gewinner gefunden
  }
  
  void displayWinner() {
      switch(checkWin()) { // Ein Spieler hat gewonnen
       case -1: 
         resetField();
         text("Spieler O hat gewonnen. Drücke eine Taste, um neuzustarten.", boardSize / 2, boardSize / 2);
         break;
       case +1: 
         resetField();
         text("Spieler X hat gewonnen. Drücke eine Taste, um neuzustarten.", boardSize / 2, boardSize / 2);
         break;
      }
      if (isDraw()) { // das Spiel endete unentschieden
         resetField();
         text("Das Spiel endete unentschieden. Drücke eine Taste, um neuzustarten.", boardSize / 2, boardSize / 2);
      }
    }
    
  void resetField() { // reset playground visually
    delay(500);  // time delay 500ms = 0.5s
    background(0); // reset field
    textAlign(CENTER, CENTER);
    textSize(20);
    fill(0, 255, 0); // grüne Farbe 
  }
} //<>//

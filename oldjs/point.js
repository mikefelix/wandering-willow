function Point(x, y, grid){
    this.x = x;
    this.y = y;
    this.realX = this.x * grid.cellSize + 1;
    this.realY = this.y * grid.cellSize + 1;
}

Point.prototype.toString = function(){ return this.x + "/" + this.y; };

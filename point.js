function Point(x, y){
    if (typeof y != 'undefined') {
        this.x = x;
        this.y = y;
    }
    else {
        var s = x.split('/');
        this.x = s[0];
        this.y = s[1];
    }

    this.realX = this.x * 16 + 1;
    this.realY = this.y * 16 + 1;
}

Point.prototype.toString = function(){ return this.x + "/" + this.y; };

/*Point.prototype.getPointInDir = function(dir){
    var x = parseInt(this.x);
    var y = parseInt(this.y);
    switch (dir){
        case 0: return y > 0 ? new Point(this.grid, x, y - 1) : null;
        case 1: return x < maxX && y > 0 ? new Point(this.grid, x + 1, y - 1) : null;
        case 2: return x < maxX ? new Point(this.grid, x + 1, y) : null;
        case 3: return x < maxX && y < maxY ? new Point(this.grid, x + 1, y + 1) : null;
        case 4: return y < maxY ? new Point(this.grid, x, y + 1) : null;
        case 5: return x > 0 && y < maxY ? new Point(this.grid, x - 1, y + 1) : null;
        case 6: return x > 0 ? new Point(this.grid, x - 1, y) : null;
        case 7: return x > 0 && y > 0 ? new Point(this.grid, x - 1, y - 1) : null;
    };
}

Point.prototype.getAdjacentValidPoint = function(selectStartDirection){
    var start = selectStartDirection();
    for (var i = 0; i < 8; i++){
        var point = this.getPointInDir((start + i) % 8);
        if (point && !this.grid.hasDrawn(point))
            return point;
    }

    return null;
};

Point.prototype.isSurrounded = function(){
};
 */

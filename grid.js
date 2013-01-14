function resizeCanvas(){
    var canvas = document.getElementById('canvas');
}

function Grid(canvas, cellSize, getDirection) {
    var windowHeight = window.innerHeight;
    var windowWidth = window.innerWidth;

    this.canvas = canvas;
    canvas.width = canvas.style.width = windowWidth;
    canvas.height = canvas.style.height = windowHeight;

    this.pixelWidth = parseInt(canvas.style.width.replace(/\D/, ''));
    this.pixelHeight = parseInt(canvas.style.height.replace(/\D/, ''));
    this.cellSize = cellSize;
    this.width = Math.floor(this.pixelWidth / cellSize);
    this.height = Math.floor(this.pixelHeight / cellSize);
    this.count = 0;
    this.drawn = new Set();
    this.surrounded = new Set();
    this.center = new Point(Math.floor(this.width / 2), Math.floor(this.height / 2), this);
    this.origin = this.center;
    this.connections = {};
    this.getDirection = getDirection;
}

Grid.prototype.debug = function(where, msg){
    var elem = document.getElementById(where);
    if (elem){
        if (where == 'news')
            elem.value = msg + elem.value;    
        else
            elem.value = msg;
    }
};

Grid.prototype.hasDrawn = function (point) {
    return this.drawn.contains(point);
};

Grid.prototype.hasSurrounded = function (point) {
    return this.surrounded.contains(point);
};

Grid.prototype.getDirectionToCenter = function(){
    var center = this.center;
    var point = this.origin;
    if (point.x > center.x){
        if (point.y > center.y)
            return 7;
        else if (point.y < center.y)
            return 5;
        else 
            return 6;
    }
    else if (point.x < center.x){
        if (point.y > center.y)
            return 1;
        else if (point.y < center.y)
            return 3;
        else 
            return 2;
    }
    else {
        if (point.y > center.y)
            return 0;
        else if (point.y < center.y)
            return 4;
        else 
            return null;
    }
}


Grid.prototype.getNeighboringPoint = function (origin, dir) {
    var x = parseInt(origin.x);
    var y = parseInt(origin.y);
    switch (dir) {
        case 0:
            return y > 0 ? new Point(x, y - 1, this) : null;
        case 1:
            return x < this.width && y > 0 ? new Point(x + 1, y - 1, this) : null;
        case 2:
            return x < this.width ? new Point(x + 1, y, this) : null;
        case 3:
            return x < this.width && y < this.height ? new Point(x + 1, y + 1, this) : null;
        case 4:
            return y < this.height ? new Point(x, y + 1, this) : null;
        case 5:
            return x > 0 && y < this.height ? new Point(x - 1, y + 1, this) : null;
        case 6:
            return x > 0 ? new Point(x - 1, y, this) : null;
        case 7:
            return x > 0 && y > 0 ? new Point(x - 1, y - 1, this) : null;
    }
};

Grid.prototype.getOpenNeighboringPoint = function (origin, getStartDirection) {
    var start = getStartDirection(origin);
    var toReturn = null;
    for (var i = 0; i < 8; i++) {
        var dir = (start + i) % 8;
        var point = this.getNeighboringPoint(origin, dir);

        if (point && !this.hasDrawn(point) && !this.hasSurrounded(point)){
            var intersects = false;
            if (point && dir % 2 == 1){
                var intersector1 = this.getNeighboringPoint(origin, (dir + 1) % 8);
                var intersector2 = this.getNeighboringPoint(origin, (dir - 1) % 8);
                if (intersector1 && intersector2){
                    var conn1 = this.connections[intersector1];
                    var conn2 = this.connections[intersector2];
                    intersects = (conn1 && conn1.filter(function(a){return a.toString() == intersector2.toString()}).length > 0) || (conn2 && conn2.filter(function(a){return a.toString() == intersector1.toString()}).length > 0);
                }
            }

            if (!intersects){
                var s = this.hasSurrounded(point) ? 's' : (this.hasDrawn(point) ? 'd' : '');
                var v = point ? point.toString() + s : ''
                this.debug('p' + ((start + i) % 8), v);
                toReturn = toReturn || point;
            }
            else {
               this.debug('news', "Rejecting " + point + " for intersection.\n");
            }
        }
    }

    return toReturn;
};

Grid.prototype.markSurrounded = function (point) {
    this.drawn.remove(point);
    this.surrounded.add(point);
    this.debug('surrounded', this.surrounded.toString());
    this.debug('drawn', this.drawn.toString());
};

Grid.prototype.markDrawn = function (point) {
    if (this.drawn.contains(point) || this.surrounded.contains(point))
        return;

    this.drawn.add(point);
    this.count++;
    this.debug('drawn', this.drawn.toString());
    this.debug('surrounded', this.surrounded.toString());
};

Grid.prototype.done = function () {
    return this.count >= (this.width + 1) * (this.height + 1);
};

Grid.prototype.drawLine = function (origin, dest) {
    this.c.beginPath();
    this.c.moveTo(origin.realX, origin.realY);
    this.c.lineTo(dest.realX, dest.realY);
    this.c.closePath();
    this.c.stroke();
    this.c.stroke();

    this.markDrawn(origin);
    this.markDrawn(dest);
    if (!this.connections[origin]) this.connections[origin] = new Array();
    this.connections[origin].push(dest);

    this.checkSurrounded(origin);
    this.checkSurrounded(dest);

    for (var i = 0; i < 8; i++) {
        var origNeighbor = this.getNeighboringPoint(origin, i);
        var destNeighbor = this.getNeighboringPoint(dest, i);
        if (origNeighbor)
            this.checkSurrounded(origNeighbor);

        if (destNeighbor)
            this.checkSurrounded(destNeighbor);
    }
};

Grid.prototype.checkSurrounded = function (point) {
    if (this.surrounded.contains(point))
        return true;

    if (!this.drawn.contains(point))
        return false;

    var surrounded = true;
    for (var i = 0; i < 8; i++) {
        var pointInDir = this.getNeighboringPoint(point, i);
        surrounded &= !pointInDir || this.hasDrawn(pointInDir);
    }

    if (surrounded){
        if (!this.surrounded.contains(point))
            this.debug('news', point + " is now surrounded.\n");

        this.markSurrounded(point);
    }

    return surrounded;
};

Grid.prototype.invalid = function (point) {
    if (this.hasSurrounded(point)){
        this.debug('news', this.origin + " is now surrounded!\n");
        return true;
    }

    if (!this.getOpenNeighboringPoint(point, this.getDirection)){
        this.debug('news', this.origin + " has no open neighbors.\n");
        return true;
    }

    return false;
};

Grid.prototype.getBranchPoint = function(){
    var xy = this.drawn.getRandomElement().split('/');
    return new Point(xy[0], xy[1], this);
//    return new Point(this.drawn.first());
};

Grid.prototype.draw = function () {
    this.c = this.canvas.getContext('2d');
    this.c.lineWidth = 1;
    this.c.strokeStyle = 'black';

    this.markDrawn(this.origin);

    this.drawOne();
}

Grid.prototype.drawOne = function() {
    if (this.done()) {
        //alert("reached " + this.count);
        return;
    }

    while (this.invalid(this.origin)) {
        this.origin = this.getBranchPoint();
        this.debug('news', "New branch point " + this.origin + ".\n");
        if (this.origin === null) {
            alert("No available branch point found.");
            return;
        }
    }

    var dest = this.getOpenNeighboringPoint(this.origin, this.getDirection);
    this.debug('next', dest ? dest.toString() : 'null');
    this.debug('current', this.origin ? this.origin.toString() : 'null');

    if (!dest) {
        alert("found no valid neighbor for " + this.origin);
        return;
    }

    this.drawLine(this.origin, dest);
    this.debug('news', this.origin + ' -> ' + dest + "\n");

    this.origin = dest;

    setTimeout("window.grid.drawOne()",0);
};

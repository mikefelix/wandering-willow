function getRandomDirection(point){
    //return getTrulyRandomDirection();
    return getRandomCenteredDirection(point);
}

function getDirectionWithFavored(point, favored) {
    var r = Math.random();
    if (r < 0.6)
        return favored;
    else
        return getTrulyRandomDirection(point);
}

function getRandomCenteredDirection(point) {
    var toCenter = getDirectionToCenter(point, window.grid.getOrigin());
    var r = Math.random();
    if (r < 0.4)
        return toCenter;
    else
        return getTrulyRandomDirection(point);
}

function getDirectionToCenter(point, center){
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

function getTrulyRandomDirection(point) {
    return Math.floor(Math.random() * 8);
}

function Grid(canvas, cellSize) {
    this.canvas = canvas;
    this.pixelWidth = parseInt(canvas.style.width.replace(/\D/, ''));
    this.pixelHeight = parseInt(canvas.style.height.replace(/\D/, ''));
    this.cellSize = cellSize;
    this.width = Math.floor(this.pixelWidth / cellSize);
    this.height = Math.floor(this.pixelHeight / cellSize);
    this.count = 0;
    this.drawn = new Set();
    this.surrounded = new Set();
    this.origin = this.getOrigin();
    this.connections = {};
}

Grid.prototype.getOrigin = function(){
    return new Point(Math.floor(this.width / 2), Math.floor(this.height / 2));
};

Grid.prototype.hasDrawn = function (point) {
    return this.drawn.contains(point);
};

Grid.prototype.hasSurrounded = function (point) {
    return this.surrounded.contains(point);
};

Grid.prototype.getNeighboringPoint = function (origin, dir) {
    var x = parseInt(origin.x);
    var y = parseInt(origin.y);
    switch (dir) {
        case 0:
            return y > 0 ? new Point(x, y - 1) : null;
        case 1:
            return x < this.width && y > 0 ? new Point(x + 1, y - 1) : null;
        case 2:
            return x < this.width ? new Point(x + 1, y) : null;
        case 3:
            return x < this.width && y < this.height ? new Point(x + 1, y + 1) : null;
        case 4:
            return y < this.height ? new Point(x, y + 1) : null;
        case 5:
            return x > 0 && y < this.height ? new Point(x - 1, y + 1) : null;
        case 6:
            return x > 0 ? new Point(x - 1, y) : null;
        case 7:
            return x > 0 && y > 0 ? new Point(x - 1, y - 1) : null;
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
                var intersector1 = this.getNeighboringPoint(origin, dir + 1);
                var intersector2 = this.getNeighboringPoint(origin, dir - 1);
                if (intersector1 && intersector2){
                    var conn1 = this.connections[intersector1];
                    var conn2 = this.connections[intersector2];
                    intersects = (conn1 && conn1.filter(function(a){return a.toString() == intersector2.toString()}).length > 0) || (conn2 && conn2.filter(function(a){return a.toString() == intersector1.toString()}).length > 0);
                }
            }

            if (!intersects){
                var s = this.hasSurrounded(point) ? 's' : (this.hasDrawn(point) ? 'd' : '');
                var v = point ? point.toString() + s : ''
                document.getElementById('p' + ((start + i) % 8)).value = v;
                toReturn = point;
            }
        }
    }

    return toReturn;
};

Grid.prototype.markSurrounded = function (point) {
    this.drawn.remove(point);
    this.surrounded.add(point);
    document.getElementById('surrounded').value = this.surrounded.toString();
    document.getElementById('drawn').value = this.drawn.toString();
};

Grid.prototype.markDrawn = function (point) {
    if (this.drawn.contains(point))
        return;

    this.drawn.add(point);
    this.count++;
    document.getElementById('drawn').value = this.drawn.toString();
    document.getElementById('surrounded').value = this.surrounded.toString();
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
            document.getElementById('news').value += point + " is now surrounded.\n";

        this.markSurrounded(point);
    }

    return surrounded;
};

Grid.prototype.invalid = function (point) {
    if (this.hasSurrounded(point)){
        document.getElementById('news').value += this.origin + " is surrounded!\n";
        return true;
    }

    if (!this.getOpenNeighboringPoint(point, getRandomDirection)){
        document.getElementById('news').value += this.origin + " has no open neighbors.\n";
        return true;
    }

    return false;
};

Grid.prototype.getBranchPoint = function(){
    return new Point(this.drawn.getRandomElement());
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
//    while (true) {
        if (this.done()) {
            //alert("reached " + this.count);
            return;
        }

        while (this.invalid(this.origin)) {
            this.origin = this.getBranchPoint();
            document.getElementById('news').value += "New branch point " + this.origin + ".\n";
            if (this.origin === null) {
                alert("No available branch point found.");
                return;
            }
        }

        var dest = this.getOpenNeighboringPoint(this.origin, getRandomDirection);
        document.getElementById('next').value = dest ? dest.toString() : 'null';
        document.getElementById('current').value = this.origin ? this.origin.toString() : 'null';

        if (!dest) {
            alert("found no valid neighbor for " + this.origin);
            return;
        }

        this.drawLine(this.origin, dest);
        document.getElementById('news').value += this.origin + ' -> ' + dest + "\n";
        //document.getElementById('news').value = '';

//        this.count++;
        this.origin = dest;
//    }

    setTimeout("window.grid.drawOne()",0);
};

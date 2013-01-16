var DirectionFunctions = {
    random: function(){
        return function(point, grid){
            return Math.floor(Math.random() * 8);
        };
    },
    favorDirection: function(dir, weight){
        return function(point, grid){
            return Math.random() < weight ? dir : Math.floor(Math.random() * 8);
        };
    },
    trendToCenter: function(weight){
        return function(point, grid){
            return Math.random() < weight ? window.grid.getDirectionToCenter() : Math.floor(Math.random() * 8);
        };
    },
    star: function(weight){
        return function(point, grid){
            var distanceFromSpoke = Math.abs(point.x - point.y);

            return Math.random() * 8;
        }
    },
    bounce: function(startDir, weight){
        return function(point, grid){
        };
    }
};

function getRandomCenteredDirection(point) {
}

function getTrulyRandomDirection(point) {
}



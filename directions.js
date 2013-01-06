var DirectionFunctions = {
    random: function(){
        return function(point, grid){
            return Math.floor(Math.random() * 8);
        };
    },
    favorDirection: function(dir, weight){
        return function(point, grid){
            return Math.random() < weight ? favored : Math.floor(Math.random() * 8);
        };
    },
    trendToCenter: function(weight){
        return function(point, grid){
            return Math.random() < weight ? grid.getDirectionToCenter() : Math.floor(Math.random() * 8);
        };
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



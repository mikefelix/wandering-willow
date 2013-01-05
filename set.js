function Set(){
    this.elements = {};
}

Set.prototype.contains = function(elem){
//    return this.elements[elem] === true;
    return this.elements.hasOwnProperty(elem);
};

Set.prototype.add = function(elem){
    this.elements[elem] = true;
};

Set.prototype.remove = function(elem){
    delete this.elements[elem];
};

Set.prototype.first = function(){
    for (var item in this.elements){
        return item;
    }
};

Set.prototype.getRandomElement = function(suchThat){
    var keys = Object.keys(this.elements);
    var idx = Math.floor(Math.random() * keys.length);
    var i = 0;
    for (var item in this.elements){
        if (!this.elements.hasOwnProperty(item))
            continue;

        if (i == idx)
            return item;

        i++;
    }

//    alert(i + "/" + idx);
    return null;
};

Set.prototype.size = function(){
    var keys = Object.keys(this.elements);
    return keys.length;
};

Set.prototype.toString = function(){
    var text = '';
    for (var item in this.elements){
        if (!this.elements.hasOwnProperty(item))
            continue;

        text += item + "\n";
    }

    return text;
};

function assert(that){
    if (!that)
        throw that;
}

function testSets(){
    var set = new Set();
    set.add("hey");
    assert(set.contains("hey"));
    assert(!set.contains("heyo"));
    set.remove("hey");
    assert(!set.contains("hey"));
    assert(!set.contains("heyo"));
}
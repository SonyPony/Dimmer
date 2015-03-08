function calcSize(relation, componenentSize) {
    var standart = {};

    standart.width = 480;
    standart.height = 854;

    return Math.round(root[relation] / standart[relation] * componenentSize);
}

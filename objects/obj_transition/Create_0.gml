persistent = true;

rectangle = [new Vector2(0 ,0), new Vector2(0, RES_H)];
transition_acc = .08;
room_target = -1;

in = function () {
    rectangle[1].x = lerp(rectangle[1].x, RES_W, transition_acc);
    transition_acc *= 1.02;
    if (approached(rectangle[1].x, RES_W, .1)) {
        room_goto(room_target);
        state = out;
    }
    
}

out = function () {
    transition_acc *= 1.02;
    rectangle[0].x = lerp(rectangle[0].x, RES_W, transition_acc);
    if (approached(rectangle[0].x, RES_W, .1)) {
        instance_destroy();
    }
}



state = in;
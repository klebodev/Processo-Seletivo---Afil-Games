function transition_create (_room_target) {
    with (instance_create_depth(0, 0, -999, obj_transition)) {
        room_target = _room_target;
    }
}
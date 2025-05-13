function inside = PointInTriangle(P, A, B, C)

PA = P - A;
PB = P - B;
PC = P - C;

AB = B - A;
BC = C - B;
CA = A - C;

cross1 = AB(1)*PA(2) - AB(2)*PA(1);
cross2 = BC(1)*PB(2) - BC(2)*PB(1);
cross3 = CA(1)*PC(2) - CA(2)*PC(1);

has_neg = (cross1 < 0) || (cross2 < 0) || (cross3 < 0);
has_pos = (cross1 > 0) || (cross2 > 0) || (cross3 > 0);

inside = ~(has_neg && has_pos);
end

function res = eliminateComplexNumber(matrix)

    unreal = matrix ~= real(matrix);
    res = matrix
    res(unreal) = NaN

end
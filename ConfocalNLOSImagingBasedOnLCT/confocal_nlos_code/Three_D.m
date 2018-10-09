function Three_D(data)
    figure
    v = data;
    h = vol3d('cdata',v,'texture','2D');
    view(3); 
    colormap('gray');
    % % Update view since 'texture' = '2D'
    vol3d(h);
    alphamap('rampdown'), alphamap('decrease'), alphamap('decrease')
end
function batch_plot_inundation

i=65:5:165;
i=165
for k=1:length(i)
    if i(k)<100
        run=['00' num2str(i(k))];
    else
        run=['0' num2str(i(k))];
    end
    plot_inundation(run);
end
import pandas as pd 
import matplotlib.pyplot as plt
import seaborn as sns

from pylab import *

cmap = cm.get_cmap('Pastel1', 5)    # PiYG
colors=[]
for i in range(cmap.N):
    rgba = cmap(i)
    # rgb2hex accepts rgb or rgba
    colors.append(matplotlib.colors.rgb2hex(rgba))

# reverse colors list
# colors = colors[::-1]
colors.pop(4)

def plot_time_series(data:pd.DataFrame, xlabel:str = '', ylabel = '', save_path:str='time_series.pdf')-> None:
    """ Plot time series data

    Args:
        data (pd.DataFrame): Dataframe with time series data
        xlabel (str, optional): X label. Defaults to ''.
        ylabelstr (str, optional): Y label. Defaults to ''.
        save (bool, optional): Save plot. Defaults to False.
        save_path (str): Path to save plot

    Returns:
        None
    """
    fig, ax = plt.subplots(figsize=(8,6))

    cols = data.columns

    for i, col in enumerate(cols):
        ax.plot(data[col], label=col, color=colors[i], linewidth=2)



    ax.spines.right.set_visible(False)
    ax.spines.top.set_visible(False)
    legend = ax.legend()
    ax.set_xlabel('')
    ax.set_ylabel(ylabel)
    fig.savefig(save_path, bbox_inches='tight')
    plt.show()


def plot_stack_bar(data:pd.DataFrame,x:str, xlabel:str = '', ylabel = '', save_path:str='stack_bar.pdf')-> None:
    """ Plot stack bar

    Args:
        data (pd.DataFrame): Dataframe with time series data
        xlabel (str, optional): X label. Defaults to ''.
        ylabelstr (str, optional): Y label. Defaults to ''.
        save (bool, optional): Save plot. Defaults to False.
        save_path (str): Path to save plot

    Returns:
        None
    """
    fig, ax = plt.subplots(figsize=(8,6))

    cols = data.columns
    data.plot.bar(x=x, stacked=True, ax=ax)
    


    ax.spines.right.set_visible(False)
    ax.spines.top.set_visible(False)
    # legend to the right of the plot
    legend = ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))
    ax.set_xlabel('')
    ax.set_ylabel(ylabel)
    fig.savefig(save_path, bbox_inches='tight')
    plt.show()

# compute row percentages and print result as latex
def print_latex_table(df:pd.DataFrame, save_path:str='latex_table.tex', caption:str='')-> None:
    """ Print latex table

    Args:
        df (pd.DataFrame): Dataframe with data
        save_path (str, optional): Path to save latex table. Defaults to 'latex_table.tex'.

    Returns:
        None
    """
    # compute row percentages
    df = df.div(df.sum(axis=1), axis=0)
    # print result as latex and float format as percentage
    print(df.to_latex(float_format=lambda x: "{0:.1f}%".format(x*100)))
    # save result as latex
    df.to_latex(save_path, float_format=lambda x: "{0:.1f}%".format(x*100), caption=caption)


# plot percentile distribution by group
def plot_percentile_distribution(data:pd.DataFrame, group:str, save_path:str='percentile_distribution.pdf')-> None:
    """ Plot percentile distribution

    Args:
        data (pd.DataFrame): Dataframe with time series data
        group (str): Group to plot
        save_path (str): Path to save plot

    Returns:
        None
    """
    fig, ax = plt.subplots(figsize=(8,6))

    # plot percentile distribution by group
    sns.boxplot(x=group, y='percentile', data=data, ax=ax)


    # show xtick labels only from 10 to 90
    ax.set_xticklabels(ax.get_xticklabels(), rotation=45, horizontalalignment='right')
    ax.set_xticks([0,1,2,3,4,5,6,7,8,9])
    ax.set_xticklabels([10,20,30,40,50,60,70,80,90])
    
    

    ax.spines.right.set_visible(False)
    ax.spines.top.set_visible(False)
    ax.set_xlabel('')
    ax.set_ylabel('Percentile')
    fig.savefig(save_path, bbox_inches='tight')
    plt.show()

import click
from pathlib import Path
import glob
import pandas as pd
PROJECT_DIR = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_DIR / "data"
RESULTS_DIR = PROJECT_DIR / "results"
SUBJECT_ID = "subject_id"
OBJECT_ID = "object_id"
PREDICATE_ID = "predicate_id"


@click.group()
def main():
    pass

@main.command()
@click.option("-o", "--outfile", default=RESULTS_DIR / "report_pivot_table.md")
def reports(outfile: str):
    """Run reports."""
    # import all tsv files using pandas and just 3 columns
    tsv_files = glob.glob(str(DATA_DIR / "*.tsv"))
    
    # Read and concatenate dataframes in one step
    dfs = (pd.read_csv(file, sep='\t', usecols=['subject_id', 'predicate_id', 'object_id'], comment="#") for file in tsv_files)
    large_df = pd.concat(dfs, ignore_index=True).drop_duplicates()
    
    # Split subject_id and object_id
    large_df[['subject_prefix', 'subject_id']] = large_df['subject_id'].str.split(":", expand=True)
    large_df[['object_prefix', 'object_id']] = large_df['object_id'].str.split(":", expand=True)

    # unique_object_prefixes = list(large_df['object_prefix'].unique())
    # unique_subject_prefixes = list(large_df['subject_prefix'].unique())

    # # Group by subject_prefix and object_prefix
    # grouped_df = large_df.groupby(['subject_prefix', 'object_prefix'])

    # mondo_ncit_df = grouped_df.get_group(('MONDO', 'NCIT')).drop_duplicates()
    # hsapdv_mmusdv_df = grouped_df.get_group(('HsapDv', 'MmusDv')).drop_duplicates()
    # fbbt_wbbt_df = grouped_df.get_group(('FBbt', 'WBbt')).drop_duplicates()
    # fbbt_zfa_df = grouped_df.get_group(('FBbt', 'ZFA')).drop_duplicates()

    # Create a pivot table
    pivot_table = large_df.pivot_table(index='subject_prefix', columns='object_prefix', aggfunc='size', fill_value=0)
    
    # Convert the pivot table to markdown
    markdown_table = pivot_table.to_markdown()
    
    # Write the markdown table to a file
    with open(str(outfile), 'w') as f:
        f.write(markdown_table)
    


if __name__ == "__main__":
    reports()

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Column
{
    char typeToken[256];
    char nameToken[256];
    char valueToken[256];
    int columnNumber;
    struct Column *nextColumn;
} Column;

typedef struct Row
{
    int rowNumber;
    Column *columns;
    struct Row *nextRow;
} Row;

extern Column *allocateColumn()
{
    Column *col = (Column *)malloc(sizeof(Column));

    col->columnNumber = 1;
    col->nextColumn = NULL;

    return col;
}

extern Row *allocateRow()
{
    Row *row = (Row *)malloc(sizeof(Row));

    row->columns = NULL;
    row->rowNumber = 1;
    row->nextRow = NULL;

    return row;
}

extern Row *insertRow(Row **rows, int rowNumber)
{
    Row *row, *newRow;
    if (*rows == NULL)
    {
        newRow = allocateRow();
        return newRow;
    }
    else
    {
        row = *rows;
        while (row->nextRow != NULL)
        {
            row = row->nextRow;
        }
        newRow = allocateRow();
        row->nextRow = newRow;
        newRow->rowNumber = rowNumber;
        return newRow;
    }
}

extern void insertColumn(Row *row, char *typeToken, char *nameToken, char *valueToken, int columnNumber)
{
    Column *col, *currentColumn = row->columns;
    if (currentColumn == NULL)
    {
        col = allocateColumn();
        strcpy(col->typeToken, typeToken);
        strcpy(col->nameToken, nameToken);
        strcpy(col->valueToken, valueToken);
        col->columnNumber = columnNumber;
        row->columns = col;
    }
    else
    {
        while (currentColumn->nextColumn != NULL)
        {
            currentColumn = currentColumn->nextColumn;
        }
        col = allocateColumn();
        strcpy(col->typeToken, typeToken);
        strcpy(col->nameToken, nameToken);
        strcpy(col->valueToken, valueToken);
        col->columnNumber = columnNumber;
        currentColumn->nextColumn = col;
    }
}

Column *get_id(Row *row, char id[])
{
    Column *col = row->columns;
    int stop = 0;
    while (stop == 0 && col != NULL)
    {
        if (strcmp(col->nameToken, id) == 0)
        {
            stop = 1;
        }
        else
        {
            col = col->nextColumn;
        }
    }
    return col;
}
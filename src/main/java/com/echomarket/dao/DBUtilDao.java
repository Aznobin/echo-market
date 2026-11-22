package com.echomarket.dao;

import com.mchange.v2.c3p0.ComboPooledDataSource;

import javax.sql.DataSource;

public class DBUtilDao {
    private static final DataSource DS = new ComboPooledDataSource();

    public static DataSource getDataSource() {
        return DS;
    }
}

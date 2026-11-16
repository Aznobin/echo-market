package com.echomarket.dao;

import com.mchange.v2.c3p0.ComboPooledDataSource;

import javax.sql.DataSource;

/** c3p0 数据源，启动时读 classpath 下的 c3p0.properties */
public class DBUtil {

    private static final DataSource DS = new ComboPooledDataSource();

    public static DataSource getDataSource() {
        return DS;
    }
}

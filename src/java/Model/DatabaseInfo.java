package Model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseInfo {
    private Connection connection;

    public DatabaseInfo(){
        try {
            String DBURL="jdbc:sqlserver://PJM-PC\\MINH;databaseName=Fruit_shop";
            String USERDB="sa";
            String PASSDB="1234";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(DBURL, USERDB, PASSDB);
            System.out.println("Database connection established.");
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println("Error establishing database connection: " + ex.getMessage());
            ex.printStackTrace();
        }
    }

    public Connection getConnection() {
        return connection;
    }
}
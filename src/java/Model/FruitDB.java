package Model;

import java.sql.*;
import java.util.ArrayList;
import java.util.function.Predicate;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FruitDB extends DatabaseInfo {

    public static ArrayList<Fruit> listAll() {
        ArrayList<Fruit> list = new ArrayList<>();
        try (Connection con = new DatabaseInfo().getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT ProductID, ProductName, Description, Price, ProductImage FROM Products");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Fruit(
                    rs.getInt("ProductID"),
                    rs.getString("ProductName"),
                    rs.getString("Description"),
                    rs.getDouble("Price"),
                    rs.getString("ProductImage")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static Fruit getFruit(int id) {
        Fruit s = null;
        try (Connection con = new DatabaseInfo().getConnection()) {
            PreparedStatement stmt = con.prepareStatement("SELECT ProductName, Description, Price, ProductImage FROM Products WHERE ProductID=?");
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String name = rs.getString(1);
                String description = rs.getString(2);
                double price = rs.getDouble(3);
                String image = rs.getString(4);
                s = new Fruit(id, name, description, price, image);
            }
        } catch (Exception ex) {
            Logger.getLogger(FruitDB.class.getName()).log(Level.SEVERE, null, ex);
        }
        return s;
    }

    public static String login(String email) throws Exception {
        String pw = null;
        try (Connection con = new DatabaseInfo().getConnection()) {
            PreparedStatement stmt = con.prepareStatement("SELECT Password FROM Customers WHERE Email=?");
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                pw = rs.getString(1);
            }
        } catch (Exception ex) {
            Logger.getLogger(FruitDB.class.getName()).log(Level.SEVERE, null, ex);
        }
        return pw;
    }

    public static int newFruit(Fruit s) {
        int id = -1;
        try (Connection con = new DatabaseInfo().getConnection()) {
            PreparedStatement stmt = con.prepareStatement("INSERT INTO Products (ProductName, Description, Price, ProductImage) OUTPUT INSERTED.ProductID VALUES (?, ?, ?, ?)");
            stmt.setString(1, s.getProductName());
            stmt.setString(2, s.getDescription());
            stmt.setDouble(3, s.getPrice());
            stmt.setString(4, s.getImage());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                id = rs.getInt(1);
            }
        } catch (Exception ex) {
            Logger.getLogger(FruitDB.class.getName()).log(Level.SEVERE, null, ex);
        }
        return id;
    }

    public static Fruit update(Fruit s) {
        try (Connection con = new DatabaseInfo().getConnection()) {
            PreparedStatement stmt = con.prepareStatement("UPDATE Products SET ProductName=?, Description=?, Price=?, ProductImage=? WHERE ProductID=?");
            stmt.setString(1, s.getProductName());
            stmt.setString(2, s.getDescription());
            stmt.setDouble(3, s.getPrice());
            stmt.setString(4, s.getImage());
            stmt.setInt(5, s.getProductId());
            int rc = stmt.executeUpdate();
            return s;
        } catch (Exception ex) {
            Logger.getLogger(FruitDB.class.getName()).log(Level.SEVERE, null, ex);
            throw new RuntimeException("Invalid data");
        }
    }

    public static int delete(int id) {
        try (Connection con = new DatabaseInfo().getConnection()) {
            PreparedStatement stmt = con.prepareStatement("DELETE FROM Products WHERE ProductID=?");
            stmt.setInt(1, id);
            int rc = stmt.executeUpdate();
            return rc;
        } catch (Exception ex) {
            Logger.getLogger(FruitDB.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public static ArrayList<Fruit> search(Predicate<Fruit> p) {
        ArrayList<Fruit> list = listAll();
        ArrayList<Fruit> res = new ArrayList<>();
        for (Fruit s : list)
            if (p.test(s)) res.add(s);
        return res;
    }

    public static void main(String[] a) {
        ArrayList<Fruit> list = FruitDB.listAll();
        for (Fruit item : list) {
            System.out.println(item);
        }
    }
}
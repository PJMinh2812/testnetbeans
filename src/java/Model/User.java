package Model;
import java.io.Serializable;

public class User implements Serializable {
    private String username;
    private String password;
    private int customerID;

    // No-argument constructor (required for JavaBeans)
    public User() {}

    // Getters and Setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }
}

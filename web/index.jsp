<%@page import="Model.User"%>
<%@page import="Model.DatabaseInfo"%>
<%@page import="Model.FruitDB"%>
<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<jsp:useBean id="user" class="Model.User" scope="session" />
<jsp:setProperty name="user" property="*" />

<%
    // Handle POST request for login
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username != null && password != null) {
            try {
                DatabaseInfo dbInfo = new DatabaseInfo();
                Connection conn = dbInfo.getConnection();
                if (conn == null) {
                    out.println("<p>Error: Unable to establish database connection.</p>");
                } else {
                    out.println("<p>Database connection established.</p>");
                    
                    String sql = "SELECT CustomerID FROM Customers WHERE Username=? AND Password=?";
                    PreparedStatement statement = conn.prepareStatement(sql);
                    statement.setString(1, username);
                    statement.setString(2, password);
                    ResultSet resultSet = statement.executeQuery();

                    if (resultSet.next()) {
                        // Valid login: Set user details in session
                        user.setUsername(username);
                        user.setPassword(password);
                        user.setCustomerID(resultSet.getInt("CustomerID"));
                        session.setAttribute("user", user);
                        response.sendRedirect("index.jsp"); // Redirect to the same page to show products
                        return;
                    } else {
                        // Invalid login: Clear session attributes
                        session.removeAttribute("user");
                        out.println("<p>Invalid username or password. Please try again.</p>");
                    }

                    conn.close();
                }
            } catch (Exception e) {
                out.println("<p>Error connecting to the database: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        }
    }

    // Handle logout request
    if (request.getParameter("logout") != null) {
        session.invalidate(); // Clear the session
        response.sendRedirect("index.jsp"); // Redirect to the login page
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login - Fruit Shop</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <%@ include file="/Includes/header.jsp" %>
    <%@ include file="/Includes/banner.jsp" %>

    <section class="container mt-5">
        <h2>Login</h2>
        <form action="index.jsp" method="post">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <button type="submit" class="btn btn-primary">Login</button>
        </form>

        <%
            // Display welcome message if user is logged in
            User sessionUser = (User) session.getAttribute("user");
            if (sessionUser != null && sessionUser.getUsername() != null) {
                out.println("<p>Welcome, " + sessionUser.getUsername() + "!</p>");
                out.println("<a href='index.jsp?logout=true' class='btn btn-danger'>Logout</a>");

                // Retrieve and display orders
                try {
                    DatabaseInfo dbInfo = new DatabaseInfo();
                    Connection conn = dbInfo.getConnection();
                    if (conn == null) {
                        out.println("<p>Error: Unable to establish database connection for retrieving orders.</p>");
                    } else {
                        out.println("<p>Database connection established for retrieving orders.</p>");

                        String orderSql = "SELECT * FROM Orders WHERE CustomerID=?";
                        PreparedStatement orderStatement = conn.prepareStatement(orderSql);
                        orderStatement.setInt(1, sessionUser.getCustomerID());
                        ResultSet orderResultSet = orderStatement.executeQuery();

                        out.println("<h3>Your Orders:</h3>");
                        out.println("<table class='table table-striped'>");
                        out.println("<thead><tr><th>Order ID</th><th>Product</th><th>Quantity</th><th>Total Price</th></tr></thead>");
                        out.println("<tbody>");
                        while (orderResultSet.next()) {
                            out.println("<tr>");
                            out.println("<td>" + orderResultSet.getInt("OrderID") + "</td>");
                            out.println("<td>" + orderResultSet.getString("Product") + "</td>");
                            out.println("<td>" + orderResultSet.getInt("Quantity") + "</td>");
                            out.println("<td>" + orderResultSet.getDouble("TotalPrice") + "</td>");
                            out.println("</tr>");
                        }
                        out.println("</tbody>");
                        out.println("</table>");

                        conn.close();
                    }
                } catch (Exception e) {
                    out.println("<p>Error retrieving orders: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                }
            }
        %>
    </section>

    <%@ include file="/Includes/list_product.jsp" %>
    <%@ include file="/Includes/footer.jsp" %>
</body>
</html>
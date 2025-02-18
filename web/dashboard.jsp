<%-- 
    Document   : dashboard
    Created on : Feb 18, 2025, 6:44:40 PM
    Author     : Admin
--%>

<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<jsp:useBean id="user" class="User" scope="session" />
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Dashboard</title>
</head>
<body>
    <h2>Welcome to Your Dashboard</h2>

    <%
        if (user.getUsername() != null) {
            out.println("<p>Hello, " + user.getUsername() + "!</p>");
        } else {
            response.sendRedirect("index.jsp"); // Redirect to login if session expired
        }
    %>

    <a href="logout.jsp">Logout</a>
</body>
</html>

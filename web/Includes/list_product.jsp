<%-- 
    Document   : list_product
    Created on : Dec 13, 2023, 8:48:11 AM
    Author     : Dell
--%>

<%@page contentType="text/html" import="Model.Fruit,java.util.ArrayList" pageEncoding="UTF-8"%>

<!-- Product Listings Section -->
<div class="container">
    <% 
        ArrayList<Fruit> allFruits = (ArrayList<Fruit>) request.getAttribute("fruits");
        if (allFruits != null && !allFruits.isEmpty()) { 
            for (Fruit o : allFruits) { %>
                <div class='row'>
                    <div class='col-md-4' align='center'>
                        <div class='card'>
                            <img src="<%= o.getImage() %>" class='card-img-top' alt='Product Image' width='100'>
                            <div class='card-body'>
                                <h5 class='card-title'><%= o.getProductName() %></h5>
                                <p class='card-text'><%= o.getDescription() %></p>
                                <p class='card-text'>Price: <%= o.getPrice() %> VND/kg</p>
                                <a href='#' class='btn btn-primary'>Add to Cart</a>
                            </div>
                        </div>
                    </div>
                </div>
            <% }
        } else { %>
            <p>Không có sản phẩm nào.</p>
        <% } %>
</div>

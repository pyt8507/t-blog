<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="sessionBean" class="save.data.Login" scope="session"/>
<!DOCTYPE html>
<html>

<head>
    <title>用户管理 | t-blog</title>
</head>
<style>
    html {
        background-color:skyblue;
    }

    body {
        margin: 0px 0px 0px 0px;
    }

    a{
        color:black;
        text-decoration: none;
    }

    #main {
        width: 900px;
        margin: 20px auto;
        background-color: white;
        padding: 0 20px 20px 20px;
        border: 2px solid #CDCDCD;
    }

    #navigation_bar {
        background-color: white;
        list-style-type: none;
        margin: 0;
        padding: 0 20px 0 20px;
        overflow: hidden;
        border-bottom: 1px solid #afafaf;

    }

    .navigation_bar_li_home {
        float: left;
    }

    .navigation_bar_li_nothome {
        float: right;
    }

    #navigation_bar_a {
        display: block;
        padding: 8px;
    }

    #navigation_current {
        background-color: darkorange;
    }

    #quit {
        background-color: rgb(255, 64, 64);
    }

    #title {
        margin: 30px;
    }

    #list {
        margin: 30px;
    }

    .info {
        font-size: 12px;
        color: #666;
    }

    .list_button{
        font-size: .875rem;
        font-weight: 400;
        background-clip: padding-box;
        border: 1px solid;
        border-radius: .2rem;
        background-color: white;
        margin-left: 3px;
    }

    #delete{
        border-color:rgb(255, 64, 64);
        color: rgb(255, 64, 64);
    }

    #online{
        border-color:green;
        color: green;
    }
</style>

<body>
<ul id="navigation_bar">
    <li class="navigation_bar_li_home"><a id="navigation_bar_a" href="index.jsp">主页</a></li>
    <% if(sessionBean.getUsername()==null){%>
    <li class="navigation_bar_li_nothome"><a id="navigation_bar_a" href="register.jsp">注册</a></li>
    <li class="navigation_bar_li_nothome"><a id="navigation_bar_a" href="login.jsp">登录</a></li>
    <% } else {%>
    <li class="navigation_bar_li_nothome"  id="quit"><a id="navigation_bar_a" href="exitServlet">退出</a></li>
    <li class="navigation_bar_li_nothome"><a id="navigation_bar_a" href="<%="spaceServlet?userid="+ sessionBean.getId()%>"><%= sessionBean.getUsername()%></a></li>
    <% } %>
    <% if(sessionBean.getRole()!=null && sessionBean.getRole().equals("管理员")){%>
    <li class="navigation_bar_li_nothome" id="navigation_current"><a id="navigation_bar_a" href="usermanage.jsp">用户管理</a></li>
    <% } %>
</ul>
<div id="main">
    <div id="title">
        <h1>用户管理</h1>
    </div>
    <hr>

    <%
        Context context = new InitialContext();
        Context contextNeeded = (Context) context.lookup("java:comp/env");
        DataSource ds = (DataSource) contextNeeded.lookup("blogConn");
        Connection con = null;
        Statement sql;
        ResultSet rs;
        try{
            con=ds.getConnection();
            sql=con.createStatement();
            String query = "select * from user";
            rs=sql.executeQuery(query);
            String posterName="";
            int id;
            String name;
            String role;
            String register_time;
            if(rs.next()){
                id = rs.getInt(1);
                name = rs.getString(2);
                role = rs.getString(4);
                register_time = rs.getString(5);
                out.println("<div id=\"list\">");
                out.println("<h3><a href=\"spaceServlet?userid="+id+"\">" + name + "</a>"+ "<a href=\"deleteUserServlet?userId="+id+"\" class=\"list_button\" id=\"delete\">删除</a>" +"</h3>");
                out.println("<p class=\"info\">账号类型："+ role +"&nbsp;&nbsp;|&nbsp;&nbsp;注册日期：" + register_time + "</p>");
                out.println("</div>");
            }
            while (rs.next()){
                id = rs.getInt(1);
                name = rs.getString(2);
                role = rs.getString(4);
                register_time = rs.getString(5);
                out.println("<div id=\"list\">");
                out.println("<hr>");
                out.println("<h3><a href=\"spaceServlet?userid="+id+"\">" + name + "</a>"+ "<a href=\"deleteUserServlet?userId="+id+"\" class=\"list_button\" id=\"delete\">删除</a>" +"</h3>");
                out.println("<p class=\"info\">账号类型："+ role +"&nbsp;&nbsp;|&nbsp;&nbsp;注册日期：" + register_time + "</p>");
                out.println("</div>");
            }
            con.close();
        }
        catch (SQLException exp){}
        finally {
            try{
                con.close();
            }
            catch (Exception ee){}
        }
    %>
</div>
</body>

</html>
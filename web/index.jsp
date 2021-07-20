<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="sessionBean" class="save.data.Login" scope="session"/>
<!DOCTYPE html>
<html>
<head>
    <title>t博客 t-blog</title>
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
</style>

<body>
<ul id="navigation_bar">
    <li class="navigation_bar_li_home" id="navigation_current"><a id="navigation_bar_a" href="index.jsp">主页</a></li>
    <% if(sessionBean.getUsername()==null){%>
    <li class="navigation_bar_li_nothome"><a id="navigation_bar_a" href="register.jsp">注册</a></li>
    <li class="navigation_bar_li_nothome"><a id="navigation_bar_a" href="login.jsp">登录</a></li>
    <% } else {%>
    <li class="navigation_bar_li_nothome"  id="quit"><a id="navigation_bar_a" href="exitServlet">退出</a></li>
    <li class="navigation_bar_li_nothome"><a id="navigation_bar_a" href="<%="spaceServlet?userid="+ sessionBean.getId()%>"><%= sessionBean.getUsername()%></a></li>
    <% } %>
    <% if(sessionBean.getRole()!=null && sessionBean.getRole().equals("管理员")){%>
    <li class="navigation_bar_li_nothome"><a id="navigation_bar_a" href="usermanage.jsp">用户管理</a></li>
    <% } %>
</ul>
<div id="main">
    <div id="title">
        <h1>博客</h1>
    </div>
    <hr>
    <%
        Context context = new InitialContext();
        Context contextNeeded = (Context) context.lookup("java:comp/env");
        DataSource ds = (DataSource) contextNeeded.lookup("blogConn");
        Connection con = null;
        Statement sql,sql2;
        ResultSet rs;
        try{
            con=ds.getConnection();
            sql=con.createStatement();
            sql2=con.createStatement();
            String query = "";
            if (sessionBean.getRole()==null)
                query="select * from article where open_read='all' order by post_time desc";
            else if (sessionBean.getRole().equals("会员"))
                query="select * from article where open_read='all' or open_read='member' or (open_read='private' and userid='"+sessionBean.getId()+"') order by post_time desc";
            else if (sessionBean.getRole().equals("管理员"))
                query="select * from article order by post_time desc";
            rs=sql.executeQuery(query);
            String posterName="";
            int id;
            String title;
            int userid;
            String post_time;
            String keywords;
            if(rs.next()){
                id = rs.getInt(1);
                title = rs.getString(2);
                userid = rs.getInt(3);
                post_time = rs.getString(4);
                keywords = rs.getString(7);
                ResultSet rs2=sql2.executeQuery("select * from user where userid='"+userid+"'");
                if(rs2.next())
                    posterName=rs2.getString(2);
                out.println("<div id=\"list\">");
                out.println("<h3><a href=\"articleServlet?articleId="+id+"\">"+title+"</a>");
                if (sessionBean.getId() == userid || sessionBean.getRole()!=null && sessionBean.getRole().equals("管理员"))
                    out.println("<a href=\"deleteArticleServlet?articleId="+id+"&from=index"+"\" class=\"list_button\" id=\"delete\">删除</a>");
                out.println("</h3>");
                out.println("<p class=\"info\">发布人：<a href=\"spaceServlet?userid="+userid+"\">"+posterName+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;发布时间："+post_time+"&nbsp;&nbsp;|&nbsp;&nbsp;关键词："+keywords+"</p>");
                out.println("</div>");
            }
            while (rs.next()){
                id = rs.getInt(1);
                title = rs.getString(2);
                userid = rs.getInt(3);
                post_time = rs.getString(4);
                keywords = rs.getString(7);
                ResultSet rs2=sql2.executeQuery("select * from user where userid='"+userid+"'");
                if(rs2.next())
                    posterName=rs2.getString(2);
                out.println("<div id=\"list\">");
                out.println("<hr>");
                out.println("<h3><a href=\"articleServlet?articleId="+id+"\">"+title+"</a>");
                if (sessionBean.getId() == userid || sessionBean.getRole()!=null && sessionBean.getRole().equals("管理员"))
                    out.println("<a href=\"deleteArticleServlet?articleId="+id+"&from=index"+"\" class=\"list_button\" id=\"delete\">删除</a>");
                out.println("</h3>");
                out.println("<p class=\"info\">发布人：<a href=\"spaceServlet?userid="+userid+"\">"+posterName+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;发布时间："+post_time+"&nbsp;&nbsp;|&nbsp;&nbsp;关键词："+keywords+"</p>");
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
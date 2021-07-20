<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="sessionBean" class="save.data.Login" scope="session"/>
<jsp:useBean id="articleBean" class="save.data.Article" scope="request"/>
<jsp:useBean id="commentBean" class="save.data.Comment" scope="request"/>
<!DOCTYPE html>
<html>
<head>
    <title><%=articleBean.getTitle()%> | t博客 t-blog</title>
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

    #quit {
        background-color: rgb(255, 64, 64);
    }

    #title {
        margin: 30px;
    }

    .list {
        margin: 30px;
    }

    .info {
        font-size: 12px;
        color: #666;
        margin: 0;
    }

    .inputbutton{
        height: calc(1.5em + .9rem + 2px);
        padding: .45rem .9rem;
        font-size: .875rem;
        font-weight: 400;
        line-height: 1.5;
        color: black;
        background-color:darkorange;
        background-clip: padding-box;
        border: 1px solid #aeb3b8;
        border-radius: .2rem;
        margin: 20px 0 0 0;

    }

    textarea{
        width: 840px;
        max-width: 840px;
        min-width: 840px;
        max-height: 200px;
        min-height: 200px;
        height: 150px;
    }

    .comment{
        font-size: 13px;
    }

    #subscribe{
        margin: 5px 5px 5px 5px;
        float: right;
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
    <li class="navigation_bar_li_home"><a id="navigation_bar_a" href="index.jsp">主页</a></li>
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
        <h1><%=articleBean.getTitle()%>
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
                String query = "";
                query="select * from subscribe where userid = '" + sessionBean.getId() + "' and id = '" + articleBean.getId() +"'";
                rs=sql.executeQuery(query);
                if(!rs.next())
                    out.println("<a href=\"subscribeArticleServlet?userid=" + sessionBean.getId() + "&articleId=" + articleBean.getId() +"\" class=\"inputbutton\" id=\"subscribe\">收藏</a>");
                else
                    out.println("<a href=\"unsubscribeArticleServlet?userid=" + sessionBean.getId() + "&articleId=" + articleBean.getId() + "&from=article" + "\" class=\"inputbutton\" id=\"subscribe\">取消收藏</a>");
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
        </h1>
        <p class="info">发布人：<a href="spaceServlet?userid=<%=articleBean.getUserId()%>"><%=articleBean.getUserName()%></a>&nbsp;&nbsp;|&nbsp;&nbsp;发布时间：<%=articleBean.getPostTime()%>&nbsp;&nbsp;|&nbsp;&nbsp;关键词：<%=articleBean.getKeywords()%></p>
    </div>
    <hr>
    <div class="list">
        <p>
            <%=articleBean.getContent()%>
        </p>
    </div>
    <hr>
    <div class="list">
        <h2>评论</h2>
        <%
            if (articleBean.getComment().equals("open")){
                try{
                    con=ds.getConnection();
                    sql=con.createStatement();
                    sql2=con.createStatement();
                    String query = "";
                    query="select * from comment where articleId='"+articleBean.getId()+"'";
                    rs=sql.executeQuery(query);
                    String posterName="";
                    String comment="";
                    int userid;
                    String post_time;
                    int commentId;
                    while (rs.next()){
                        commentId = rs.getInt(1);
                        comment = rs.getString(5);
                        userid = rs.getInt(3);
                        post_time = rs.getString(4);
                        ResultSet rs2=sql2.executeQuery("select * from user where userid='"+userid+"'");
                        if(rs2.next())
                            posterName=rs2.getString(2);
                        out.println("<div>");
                        out.println("<hr>");
                        out.println("<p class=\"info\"><a href=\"spaceServlet?userid="+userid+"\">"+posterName+"</a>&nbsp;&nbsp;"+post_time);
                        if (sessionBean.getId() == articleBean.getUserId() || sessionBean.getId() == userid || sessionBean.getRole()!=null && sessionBean.getRole().equals("管理员"))
                            out.println("<a href=\"deleteCommentServlet?articleId="+articleBean.getId()+"&id="+commentId+"\" class=\"list_button\" id=\"delete\">删除</a>");
                        out.println("<p class=\"comment\">"+comment+"</p>");
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
            }
        %>

    </div>
    <div class="list">
        <% if (articleBean.getComment().equals("open")){%>
        <% if (sessionBean.getUsername()!=null){%>
        发表评论：
        <form action="commentServlet" meth="post">
            <input type="text" name="userid" hidden="true" value=<%=sessionBean.getId()%>>
            <input type="text" name="id" hidden="true" value=<%=articleBean.getId()%>>
            <textarea name="comment"></textarea>
            <br>
            <input type="submit" value="发表" class="inputbutton">
        </form>
        <p>
            <% if(commentBean.getResult()!=null){%>
            <jsp:getProperty name="commentBean" property="result"/>
            <% } %>
        </p>
        <%}
        else
            out.print("请<a href=\"login.jsp\">登录</a>，以发表评论");
        %>
        <%}
        else
            out.print("评论区已关闭");
        %>
    </div>
</div>
</body>
</html>
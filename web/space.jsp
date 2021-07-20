<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="sessionBean" class="save.data.Login" scope="session"/>
<jsp:useBean id="spaceBean" class="save.data.Space" scope="request"/>
<!DOCTYPE html>
<html>
<head>
    <title><%= spaceBean.getUsername()%>的个人空间 | t-blog</title>
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
        width: 700px;
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

    .list {
        margin: 30px;
    }

    .info {
        font-size: 12px;
        color: #666;
    }

    #inputbox{
        width: 80%;
        height: 1em;
        padding: .45rem .9rem;
        font-size: .875rem;
        color: #69727a;
        background-color: #fff;
        background-clip: padding-box;
        border: 1px solid #aeb3b8;
        border-radius: .2rem;
        margin: 5px;
    }

    #inputbutton{
        width: 100%;
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
        width: 100%;
        margin: 20px 0 0 0;
    }

    .selectbox{
        width: 95%;
        height: 2em;
        padding-left: .9rem;
        font-size: .875rem;
        color: #69727a;
        background-color: #fff;
        background-clip: padding-box;
        border: 1px solid #aeb3b8;
        border-radius: .2rem;
        margin: 5px;
    }

    table{
        margin: 20px 20px;
        font-size: 14px;
    }

    .personal_info{
        margin-top: 5px;
    }

    .my_list{
        margin: auto 20px;
    }

    .list_button{
        font-size: .875rem;
        font-weight: 400;
        background-clip: padding-box;
        border: 1px solid;
        border-radius: .2rem;
        float: right;
        background-color: white;
        margin-left: 3px;
    }

    #edit{
        border-color:darkorange;
        padding: 1px 6px 1px 6px;
        color: darkorange;
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
    <li class="navigation_bar_li_nothome"<%if (sessionBean.getId() == spaceBean.getUserId()){out.print("id=\"navigation_current\"");}%>><a id="navigation_bar_a" href="<%="spaceServlet?userid="+ sessionBean.getId()%>"><%= sessionBean.getUsername()%></a></li>
    <% } %>
    <% if(sessionBean.getRole()!=null && sessionBean.getRole().equals("管理员")){%>
    <li class="navigation_bar_li_nothome"><a id="navigation_bar_a" href="usermanage.jsp">用户管理</a></li>
    <% } %>
</ul>
<div id="main">
    <div id="title">
        <h1><%=spaceBean.getUsername()%>的个人空间</h1>
    </div>
    <hr>
    <div class="list">
        <h3>
            个人资料
            <% if (sessionBean.getId() == spaceBean.getUserId()){%>
            <a href="password.jsp" class="list_button" id="edit">修改密码</a>
            <% } %>
            <% if (sessionBean.getId() == spaceBean.getUserId() || sessionBean.getRole()!=null && sessionBean.getRole().equals("管理员")){%>
            <a href=<% out.print("showProfileServlet?userid="+spaceBean.getUserId());%> class="list_button" id="edit">编辑</a>
            <% } %>
        </h3>
        <hr>
        <table>
            <tr>
                <td><p class="personal_info">用户名：</p></td>
                <td width=50%><p class="personal_info"><%= spaceBean.getUsername()%></p></td>
                <td><p class="personal_info">账号类型：</p></td>
                <td><p class="personal_info"><%= spaceBean.getRole()%></p></td>
            </tr>
            <tr>
                <td><p class="personal_info">性别：</p></td>
                <td width=50%><p class="personal_info"><%= spaceBean.getGender()%></p></td>
                <td><p class="personal_info">生日：</p></td>
                <td><p class="personal_info"><%if (spaceBean.getBirthday()==null){out.println("-");}else{%><%=spaceBean.getBirthday()%><%}%></p></td>
            </tr>
            <tr>
                <td><p class="personal_info">邮箱：</p></td>
                <td width=50%><p class="personal_info"><%= spaceBean.getEmail()%></p></td>
                <td><p class="personal_info">手机：</p></td>
                <td><p class="personal_info"><%= spaceBean.getPhone()%></p></td>
            </tr>
            <tr>
                <td><p class="personal_info">注册时间：</p></td>
                <td width=50%><p class="personal_info"><%= spaceBean.getRegisterTime()%></p></td>
            </tr>
        </table>
    </div>
    <div class="list">
        <h3>我的文章
            <% if(sessionBean.getId() == spaceBean.getUserId()){%>
            <a href="post.jsp"> [+]</a>
            <% }%>
        </h3>
        <hr>

        <%
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("blogConn");
            Connection con = null;
            Statement sql;
            Statement sql2,sql3;
            ResultSet rs;
            try{
                con=ds.getConnection();
                sql=con.createStatement();
                String query = "";
                if (sessionBean.getRole()==null)
                    query="select * from article where open_read='all' and userid = '" + spaceBean.getUserId() + "' order by post_time desc";
                else if (sessionBean.getRole().equals("会员")){
                    if(sessionBean.getId() == spaceBean.getUserId())
                        query="select * from article where userid = '" + spaceBean.getUserId() + "' order by post_time desc";
                    else
                        query="select * from article where (open_read='all' or open_read='member') and userid = '" + spaceBean.getUserId() + "' order by post_time desc";
                }
                else if (sessionBean.getRole().equals("管理员"))
                    query="select * from article where userid = '" + spaceBean.getUserId() + "' order by post_time desc";
                rs=sql.executeQuery(query);
                String posterName="";
                int id;
                String title;
                String post_time;
                String keywords;
                String open_read;
                String open_comment;
                if(rs.next()){
                    id = rs.getInt(1);
                    title = rs.getString(2);
                    post_time = rs.getString(4);
                    keywords = rs.getString(7);
                    open_read = rs.getString(5);
                    open_comment = rs.getString(6);
                    out.println("<div class=\"my_list\">");
                    out.println("<a href=\"articleServlet?articleId="+id+"\">"+title+"</a>");
                    if(sessionBean.getId() == spaceBean.getUserId() || sessionBean.getRole()!=null && sessionBean.getRole().equals("管理员"))
                        out.println("<a href=\"deleteArticleServlet?articleId="+id+"&from=spaceServlet?userid="+spaceBean.getUserId()+"\" class=\"list_button\" id=\"delete\">删除</a>");
                    out.print("<p class=\"info\">发布时间："+ post_time +"&nbsp;&nbsp;|&nbsp;&nbsp;关键词："+ keywords +"&nbsp;&nbsp;|&nbsp;&nbsp;阅读权限：");
                    if (open_read.equals("all"))
                        out.print("所有人");
                    else if (open_read.equals("member"))
                        out.print("会员");
                    else if (open_read.equals("private"))
                        out.print("私密");
                    out.print("&nbsp;&nbsp;|&nbsp;&nbsp;评论权限：");
                    if (open_comment.equals("open"))
                        out.print("开启");
                    else if (open_comment.equals("close"))
                        out.print("关闭");
                    out.println("</p>");
                    out.println("</div>");
                }
                while (rs.next()){
                    id = rs.getInt(1);
                    title = rs.getString(2);
                    post_time = rs.getString(4);
                    keywords = rs.getString(7);
                    open_read = rs.getString(5);
                    open_comment = rs.getString(6);
                    out.println("<div class=\"my_list\">");
                    out.println("<hr>");
                    out.println("<a href=\"articleServlet?articleId="+id+"\">"+title+"</a>");
                    if(sessionBean.getId() == spaceBean.getUserId() || sessionBean.getRole()!=null && sessionBean.getRole().equals("管理员"))
                        out.println("<a href=\"deleteArticleServlet?articleId="+id+"&from=spaceServlet?userid="+spaceBean.getUserId()+"\" class=\"list_button\" id=\"delete\">删除</a>");
                    out.print("<p class=\"info\">发布时间："+ post_time +"&nbsp;&nbsp;|&nbsp;&nbsp;关键词："+ keywords +"&nbsp;&nbsp;|&nbsp;&nbsp;阅读权限：");
                    if (open_read.equals("all"))
                        out.print("所有人");
                    else if (open_read.equals("member"))
                        out.print("会员");
                    else if (open_read.equals("private"))
                        out.print("私密");
                    out.print("&nbsp;&nbsp;|&nbsp;&nbsp;评论权限：");
                    if (open_comment.equals("open"))
                        out.print("开启");
                    else if (open_comment.equals("close"))
                        out.print("关闭");
                    out.println("</p>");
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
    <div class="list">
        <h3>我的收藏</h3>
        <hr>

        <%
            try{
                ResultSet rs2,rs3;
                con=ds.getConnection();
                sql=con.createStatement();
                String query = "select * from subscribe where userid = '" + spaceBean.getUserId() + "'";
                rs2=sql.executeQuery(query);
                sql2=con.createStatement();
                sql3=con.createStatement();
                int id;
                if (rs2.next()){
                    id = rs2.getInt(1);
                    rs3=sql2.executeQuery("select * from article where id="+id);
                    String posterName="";
                    String title;
                    int userid;
                    String post_time;
                    String keywords;
                    while (rs3.next()){
                        title = rs3.getString(2);
                        userid = rs3.getInt(3);
                        post_time = rs3.getString(4);
                        keywords = rs3.getString(7);
                        ResultSet rs4=sql3.executeQuery("select * from user where userid='"+userid+"'");
                        if(rs4.next())
                            posterName=rs4.getString(2);
                        out.println("<div class=\"my_list\">");
                        out.println("<a href=\"articleServlet?articleId="+id+"\">"+title+"</a>");
                        if(sessionBean.getId() == spaceBean.getUserId())
                            out.println("<a href=\"unsubscribeArticleServlet?userid="+ spaceBean.getUserId() +"&articleId=" + id +"&from=spaceServlet?userid=" + spaceBean.getUserId() + "\" class=\"list_button\" id=\"delete\">取消收藏</a>");
                        out.println("<p class=\"info\">发布人：<a href=\"spaceServlet?userid="+userid+"\">"+posterName+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;发布时间："+post_time+"&nbsp;&nbsp;|&nbsp;&nbsp;关键词："+keywords+"</p>");
                        out.println("</div>");
                    }
                }
                while (rs2.next()){
                    id = rs2.getInt(1);
                    rs3=sql2.executeQuery("select * from article where id="+id);
                    String posterName="";
                    String title;
                    int userid;
                    String post_time;
                    String keywords;
                    while (rs3.next()){
                        title = rs3.getString(2);
                        userid = rs3.getInt(3);
                        post_time = rs3.getString(4);
                        keywords = rs3.getString(7);
                        ResultSet rs4=sql3.executeQuery("select * from user where userid='"+userid+"'");
                        if(rs4.next())
                            posterName=rs4.getString(2);
                        out.println("<div class=\"my_list\">");
                        out.println("<hr>");
                        out.println("<a href=\"articleServlet?articleId="+id+"\">"+title+"</a>");
                        if(sessionBean.getId() == spaceBean.getUserId())
                            out.println("<a href=\"unsubscribeArticleServlet?userid="+ spaceBean.getUserId() +"&articleId=" + id +"&from=spaceServlet?userid=" + spaceBean.getUserId() + "\" class=\"list_button\" id=\"delete\">取消收藏</a>");
                        out.println("<p class=\"info\">发布人：<a href=\"spaceServlet?userid="+userid+"\">"+posterName+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;发布时间："+post_time+"&nbsp;&nbsp;|&nbsp;&nbsp;关键词："+keywords+"</p>");
                        out.println("</div>");
                    }
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
</div>
</body>
</html>
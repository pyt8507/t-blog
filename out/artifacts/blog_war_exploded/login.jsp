<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="registerBean" class="save.data.Register" scope="request"/>
<jsp:useBean id="loginBean" class="save.data.Login" scope="request"/>
<jsp:useBean id="sessionBean" class="save.data.Login" scope="session"/>
<!DOCTYPE html>
<html>
<head>
    <title>登录 | t博客 t-blog</title>
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
        width: 400px;
        margin: 20px auto;
        background-color: white;
        padding: 0 20px 30px 20px;
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

    #inputbox{
        width: 80%;
        height: 1.5em;
        padding: .45rem .9rem;
        font-size: .875rem;
        color: #69727a;
        background-color: #fff;
        background-clip: padding-box;
        border: 1px solid #aeb3b8;
        border-radius: .2rem;
        margin: 10px;
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
    }

    form{
        margin: 20px 40px 0px 40px;
    }

    p{
        font-size: .875rem;
    }

    #registerResult{
        text-align: center;
        margin-top: 10px;
    }
</style>

<body>
<ul id="navigation_bar">
    <li class="navigation_bar_li_home"><a id="navigation_bar_a" href="index.jsp">主页</a></li>
    <% if(sessionBean.getUsername()==null){%>
    <li class="navigation_bar_li_nothome"><a id="navigation_bar_a" href="register.jsp">注册</a></li>
    <li class="navigation_bar_li_nothome" id="navigation_current"><a id="navigation_bar_a" href="login.jsp">登录</a></li>
    <% } else {%>
    <li class="navigation_bar_li_nothome"  id="quit"><a id="navigation_bar_a" href="exitServlet">退出</a></li>
    <li class="navigation_bar_li_nothome"><a id="navigation_bar_a" href="<%="spaceServlet?userid="+ sessionBean.getId()%>"><%= sessionBean.getUsername()%></a></li>
    <% } %>
</ul>
<div id="main">
    <div id="registerResult">
        <% if(registerBean.getResult()!=null){%>
        <p><jsp:getProperty name="registerBean" property="result"/></p>
        <hr>
        <% } %>
    </div>
    <div id="title">
        <h1>登录</h1>
    </div>
    <hr>
    <form action="loginServlet" meth="post">
        <table>
            <tr>
                <td>用户名：</td>
                <td><input type="text" name="username" id="inputbox"></td>
            </tr>
            <tr>
                <td>密码：</td>
                <td><input type="password" name="password" id="inputbox"></td>
            </tr>
            <tr>
                <td>验证码：</td>
                <td><input type="text" name="checkcode" id="inputbox"></td>
                <td></td>
            </tr>
        </table>
        <p>还没有注册？
            <a href="register.jsp">立即注册</a></p>
        <input type="submit" value="登录" id="inputbutton">
    </form>
    <p>
        <% if(loginBean.getResult()!=null){%>
        <jsp:getProperty name="loginBean" property="result"/>
        <% } %>
    </p>
</div>
</body>
</html>
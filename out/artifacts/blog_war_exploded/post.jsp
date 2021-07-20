<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="postBean" class="save.data.Post" scope="request"/>
<jsp:useBean id="sessionBean" class="save.data.Login" scope="session"/>
<!DOCTYPE html>
<html>
<head>
    <title>发布文章 | t博客 t-blog</title>
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
        margin: 20px 30px;
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
        min-height: 700px;
        min-height: 700px;
        height: 150px;
    }

    .comment{
        font-size: 13px;
        margin: 0;
    }

    #subscribe{
        margin: 5px 5px 5px 5px;
        float: right;
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
    <li class="navigation_bar_li_nothome" id="navigation_current"><a id="navigation_bar_a" href="<%="spaceServlet?userid="+ sessionBean.getId()%>"><%= sessionBean.getUsername()%></a></li>
    <% } %>
    <% if(sessionBean.getRole()!=null && sessionBean.getRole().equals("管理员")){%>
    <li class="navigation_bar_li_nothome"><a id="navigation_bar_a" href="usermanage.jsp">用户管理</a></li>
    <% } %>
</ul>
<div id="main">
    <div id="title">
        <h1>发布文章</h1>
    </div>
    <hr>
    <form action="postServlet" meth="post">
        <input type="text" name="userid" hidden="true" value=<%=sessionBean.getId()%>>
        <div class="list">
            <table>
                <tr>
                    <td><p>标题</p></td>
                    <td><input type="text" name="title" id="inputbox" width="600px"></td>
                </tr>
            </table>
        </div>
        <hr>
        <div class="list">
            <table>
                <tr>
                    <td><p>关键字</p></td>
                    <td><input type="text" name="keywords" id="inputbox" width="600px"></td>
                </tr>
            </table>
        </div>
        <hr>
        <div class="list">
            <p>正文</p>
            <textarea name="text"></textarea>
        </div>
        <hr>
        <div class="list">
            <p>设置</p>
            <table>
                <tr>
                    <td><p>阅读权限</p></td>
                    <td><input type="radio" name="readingPermission" value="all" checked>所有人</td>
                    <td><input type="radio" name="readingPermission" value="member">会员</td>
                    <td><input type="radio" name="readingPermission" value="private">私密</td>
                </tr>
                <tr>
                    <td><p>评论区</p></td>
                    <td><input type="radio" name="commentPermission" value="open" checked>开启</td>
                    <td><input type="radio" name="commentPermission" value="close">关闭</td>
                </tr>
            </table>
            <input type="submit" value="发布" class="inputbutton">
        </div>
    </form>
    <p>
        <% if(postBean.getResult()!=null){%>
        <jsp:getProperty name="postBean" property="result"/>
        <% } %>
    </p>
</div>
</body>
</html>
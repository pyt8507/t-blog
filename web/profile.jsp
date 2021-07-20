<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="sessionBean" class="save.data.Login" scope="session"/>
<jsp:useBean id="profileBean" class="save.data.Profile" scope="request"/>
<!DOCTYPE html>
<html>
<head>
    <title>修改资料 | t-blog</title>
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
    <li class="navigation_bar_li_nothome"<%if (sessionBean.getId() == profileBean.getUserid()){out.print("id=\"navigation_current\"");}%>><a id="navigation_bar_a" href="<%="spaceServlet?userid="+ sessionBean.getId()%>"><%= sessionBean.getUsername()%></a></li>
    <% } %>
    <% if(sessionBean.getRole()!=null && sessionBean.getRole().equals("管理员")){%>
    <li class="navigation_bar_li_nothome"><a id="navigation_bar_a" href="usermanage.jsp">用户管理</a></li>
    <% } %>
</ul>
<div id="main">
    <div id="title">
        <h1>修改资料</h1>
    </div>
    <hr>
    <div class="list">
        <form action="setProfileServlet" meth="post">
            <table>
                <tr>
                    <input type="text" name="userid" hidden="true" value=<%=profileBean.getUserid()%>>
                    <td>用户名：</td>
                    <td><input type="text" name="username" id="inputbox" value=<%=profileBean.getUsername()%>></td>
                    <% if(sessionBean.getRole()!=null && sessionBean.getRole().equals("管理员")){%>
                    <td>用户类型：</td>
                    <td>
                        <select name="role" class="selectbox">
                            <option value ="管理员" <% if (profileBean.getRole().equals("管理员")) out.print("selected");%> >管理员</option>
                            <option value ="会员" <% if (profileBean.getRole().equals("会员")) out.print("selected");%> >会员</option>
                        </select>
                    </td>
                    <% }else{%>
                        <input type="hidden" name="role" value="<%=profileBean.getRole()%>" >
                    <% } %>
                </tr>
                <tr>
                    <td>性别：</td>
                    <td>
                        <select name="gender" class="selectbox" value=<%=profileBean.getGender()%>>
                            <option value ="男" <% if (profileBean.getGender().equals("男")) out.print("selected");%> >男</option>
                            <option value ="女" <% if (profileBean.getGender().equals("女")) out.print("selected");%> >女</option>
                            <option value="-" <% if (profileBean.getGender().equals(null) || profileBean.getGender().equals("-")) out.print("selected");%>>-</option>
                        </select>
                    </td>
                    <td>生日：</td>
                    <td><input type="date" name="birthday" id="inputbox" value=<%=profileBean.getBirthday()%>></td>
                </tr>
                <tr>
                    <td>邮箱：</td>
                    <td><input type="text" name="email" id="inputbox" value=<%=profileBean.getEmail()%>></td>
                    <td>手机：</td>
                    <td><input type="text" name="phone" id="inputbox" value=<%=profileBean.getPhone()%>></td>
                </tr>
            </table>
            <input type="submit" value="修改" id="inputbutton">
        </form>
        <p>
            <% if(profileBean.getResult()!=null){%>
            <jsp:getProperty name="profileBean" property="result"/>
            <% } %>
        </p>
    </div>
</div>
</body>
</html>
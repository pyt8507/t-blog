package handle.data;
import save.data.Register;
import java.sql.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.sql.DataSource;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import java.util.*;
import java.text.*;
public class HandleRegister extends HttpServlet{
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
    }
    public void service(HttpServletRequest request,HttpServletResponse response)
        throws ServletException,IOException {
        response.setCharacterEncoding("utf-8");
        Connection con = null;
        PreparedStatement sql = null;
        Statement sql2;
        Register registerBean = new Register();
        request.setAttribute("registerBean", registerBean);
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();
        String again_password = request.getParameter("again_password").trim();
        String checkcode = request.getParameter("checkcode").trim();

        if (username == null) {
            String result = "用户名不能为空！";
            fail(request,response,registerBean,result);
            return;
        }
        if (password == null) {
            String result = "密码不能为空！";
            fail(request,response,registerBean,result);
            return;
        }
        if (!password.equals(again_password)) {
            String result = "两次输入的密码不相同，请重新输入！";
            fail(request,response,registerBean,result);
            return;
        }

        boolean isLD = true;
        for (int i = 0; i < username.length(); i++) {
            char c = username.charAt(i);
            if (!(Character.isLetterOrDigit(c) || c == '_'))
                isLD = false;
        }
        boolean boo = username.length() > 0 && password.length() > 0 && isLD;
        String result = "";
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("blogConn");
            con = ds.getConnection();
            ResultSet rs = null;
            sql2 = con.createStatement();
            rs = sql2.executeQuery("select * from user where username='"+username+"'");
            if (rs.next()){
                result = "该用户名已被使用";
                fail(request,response,registerBean,result);
                con.close();
                return;
            }
            String insertCondition = "INSERT INTO user (username,password,role,registertime,gender,email,phone) VALUES(?,?,?,?,?,?,?)";
            sql = con.prepareStatement(insertCondition);
            if (boo) {
                sql.setString(1, username);
                sql.setString(2, password);
                sql.setString(3, "会员");
                sql.setTimestamp(4, new java.sql.Timestamp(System.currentTimeMillis()));
                sql.setString(5, "-");
                sql.setString(6, "-");
                sql.setString(7, "-");
                int m = sql.executeUpdate();
                if (m != 0)
                    registerBean.setResult("注册成功！请登录");
            } else
                registerBean.setResult("信息填写不完整或名字中有非法字符！");
            con.close();
        } catch (SQLException exp) {
            registerBean.setResult("这个用户名已经被使用" + exp);
        } catch (NamingException exp) {
            registerBean.setResult("没有设置连接池" + exp);
        } finally {
            try {
                con.close();
            } catch (Exception ee) {
            }
        }
        if(registerBean.getResult()=="注册成功！请登录"){
            response.sendRedirect("login.jsp");
        }
        else{
            RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
            dispatcher.forward(request, response);
        }
    }

    public void fail(HttpServletRequest request,HttpServletResponse response,Register registerBean,String result)
            throws ServletException,IOException {
        registerBean.setResult(result);
        RequestDispatcher dispatcher =
                request.getRequestDispatcher("register.jsp");
        dispatcher.forward(request, response);
    }
}
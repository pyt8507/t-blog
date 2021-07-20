package handle.data;
import save.data.Password;
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
public class HandlePassword extends HttpServlet{
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
    }
    public void service(HttpServletRequest request,HttpServletResponse response)
        throws ServletException,IOException {
        response.setCharacterEncoding("utf-8");
        Connection con = null;
        PreparedStatement sql = null;
        Statement sql2;
        Password passwordBean = new Password();
        request.setAttribute("passwordBean", passwordBean);
        String userid = request.getParameter("userid").trim();
        String oldPassword = request.getParameter("oldPassword").trim();
        String newPassword = request.getParameter("newPassword").trim();
        String again_Password = request.getParameter("again_Password").trim();

        if (oldPassword == null) {
            String result = "旧密码不能为空！";
            fail(request,response,passwordBean,result);
            return;
        }
        if (newPassword == null) {
            String result = "新密码不能为空！";
            fail(request,response,passwordBean,result);
            return;
        }
        if (again_Password == null) {
            String result = "确认密码不能为空！";
            fail(request,response,passwordBean,result);
            return;
        }
        if (!newPassword.equals(again_Password)) {
            String result = "两次输入的密码不相同，请重新输入！";
            fail(request,response,passwordBean,result);
            return;
        }

        boolean boo = newPassword.length() > 0;
        String result = "";
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("blogConn");
            con = ds.getConnection();
            sql2 = con.createStatement();
            ResultSet rs = null;
            rs = sql2.executeQuery("select * from user where userid='"+userid+"'");
            String insertCondition = "update user set password =? where userid = " + userid;
            sql = con.prepareStatement(insertCondition);
            if (!rs.next() || !rs.getString(3).equals(oldPassword))
                passwordBean.setResult("旧密码错误！");
            else if (boo) {
                sql.setString(1, newPassword);
                int m = sql.executeUpdate();
                if (m != 0)
                    passwordBean.setResult("修改成功！");
            } else
                passwordBean.setResult("修改失败");
            con.close();
        } catch (SQLException exp) {
            passwordBean.setResult("修改失败！" + exp);
        } catch (NamingException exp) {
            passwordBean.setResult("没有设置连接池" + exp);
        } finally {
            try {
                con.close();
            } catch (Exception ee) {
            }
        }
        if(passwordBean.getResult()=="修改成功！"){
            RequestDispatcher dispatcher = request.getRequestDispatcher("spaceServlet?userid="+userid);
            dispatcher.forward(request, response);
        }
        else{
            RequestDispatcher dispatcher = request.getRequestDispatcher("password.jsp");
            dispatcher.forward(request, response);
        }
    }

    public void fail(HttpServletRequest request,HttpServletResponse response,Password passwordBean,String result)
            throws ServletException,IOException {
        passwordBean.setResult(result);
        RequestDispatcher dispatcher =
                request.getRequestDispatcher("password.jsp");
        dispatcher.forward(request, response);
    }
}
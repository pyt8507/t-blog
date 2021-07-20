package handle.data;
import save.data.Login;
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
public class HandleLogin extends HttpServlet{
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
    }
    public void service(HttpServletRequest request,HttpServletResponse response)
        throws ServletException,IOException {
        request.setCharacterEncoding("utf-8");
        Connection con = null;
        Statement sql;
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();
        boolean boo = (username.length()>0)&&(password.length()>0);
        Login loginBean = new Login();
        try{
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("blogConn");
            con = ds.getConnection();
            String condition = "select * from user where username='"
                    + username +
                    "' and password='" + password + "'";
            sql = con.createStatement();
            if (boo){
                ResultSet rs = sql.executeQuery(condition);
                boolean m =rs.next();
                if (m==true){
                    success(request,response,username,password,sql);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
                    dispatcher.forward(request,response);
                }
                else {
                    String result = "用户名不存在或密码不匹配";
                    fail(request,response,loginBean,result);
                }
            }
            else {
                String result="请输入用户名和密码";
                fail(request,response,loginBean,result);
            }
            con.close();
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request,response);
        }
        catch (SQLException exp){
            String result =""+exp;
            fail(request,response,loginBean,result);
        }
        catch (NamingException exp){
            String result = "没有设置连接池"+exp;
            fail(request,response,loginBean,result);
        }
        finally {
            try {
                con.close();
            }
            catch (Exception ee){
            }
        }
    }
    public void success(HttpServletRequest request,
                        HttpServletResponse response,
                        String username,String password,
                        Statement sql){
        Login sessionBean = null;
        HttpSession session = request.getSession(true);
        try {
            sessionBean = (Login) session.getAttribute("sessionBean");
            if (sessionBean==null){
                sessionBean = new Login();
                session.setAttribute("sessionBean",sessionBean);
                sessionBean = (Login) session.getAttribute("sessionBean");
            }
            String name = sessionBean.getUsername();
            if(name!=null && name.equals(username)){
                sessionBean.setResult(username+"已经登录了");
                sessionBean.setUsername(username);
            }
            else {
                sessionBean.setResult(username+"登录成功");
                sessionBean.setUsername(username);
            }
            ResultSet rs2 = sql.executeQuery("select * from user where username='"+username+"'");
            if(rs2.next()){
                sessionBean.setId(rs2.getInt(1));
                sessionBean.setRole(rs2.getString(4));
            }
        }
        catch (Exception ee){
            sessionBean = new Login();
            session.setAttribute("sessionBean",sessionBean);
            sessionBean.setResult(ee.toString());
            sessionBean.setUsername(username);
        }
    }
    public void fail(HttpServletRequest request,
                        HttpServletResponse response,
                        Login loginBean,String result)
            throws ServletException,IOException{
        request.setAttribute("loginBean", loginBean);
        loginBean.setResult(result);
        RequestDispatcher dispatcher =
                request.getRequestDispatcher("login.jsp");
        dispatcher.forward(request, response);
    }
}
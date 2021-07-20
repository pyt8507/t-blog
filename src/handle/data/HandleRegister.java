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
            String result = "�û�������Ϊ�գ�";
            fail(request,response,registerBean,result);
            return;
        }
        if (password == null) {
            String result = "���벻��Ϊ�գ�";
            fail(request,response,registerBean,result);
            return;
        }
        if (!password.equals(again_password)) {
            String result = "������������벻��ͬ�����������룡";
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
                result = "���û����ѱ�ʹ��";
                fail(request,response,registerBean,result);
                con.close();
                return;
            }
            String insertCondition = "INSERT INTO user (username,password,role,registertime,gender,email,phone) VALUES(?,?,?,?,?,?,?)";
            sql = con.prepareStatement(insertCondition);
            if (boo) {
                sql.setString(1, username);
                sql.setString(2, password);
                sql.setString(3, "��Ա");
                sql.setTimestamp(4, new java.sql.Timestamp(System.currentTimeMillis()));
                sql.setString(5, "-");
                sql.setString(6, "-");
                sql.setString(7, "-");
                int m = sql.executeUpdate();
                if (m != 0)
                    registerBean.setResult("ע��ɹ������¼");
            } else
                registerBean.setResult("��Ϣ��д���������������зǷ��ַ���");
            con.close();
        } catch (SQLException exp) {
            registerBean.setResult("����û����Ѿ���ʹ��" + exp);
        } catch (NamingException exp) {
            registerBean.setResult("û���������ӳ�" + exp);
        } finally {
            try {
                con.close();
            } catch (Exception ee) {
            }
        }
        if(registerBean.getResult()=="ע��ɹ������¼"){
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
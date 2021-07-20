package handle.data;
import save.data.Profile;
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
public class HandleSetProfile extends HttpServlet{
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
    }
    public void service(HttpServletRequest request,HttpServletResponse response)
        throws ServletException,IOException {
        response.setCharacterEncoding("utf-8");
        Connection con = null;
        PreparedStatement sql = null;
        Statement sql2;
        Profile profileBean = new Profile();
        request.setAttribute("profileBean", profileBean);
        String userid = request.getParameter("userid").trim();
        String username = request.getParameter("username").trim();
        String role = request.getParameter("role").trim();
        String gender = request.getParameter("gender").trim();
        String birthday = request.getParameter("birthday").trim();
        String email = request.getParameter("email").trim();
        String phone = request.getParameter("phone").trim();

        if (username == null) {
            String result = "�û�������Ϊ�գ�";
            fail(request,response,profileBean,result);
            return;
        }

        boolean isLD = true;
        for (int i = 0; i < username.length(); i++) {
            char c = username.charAt(i);
            if (!(Character.isLetterOrDigit(c) || c == '_'))
                isLD = false;
        }
        boolean boo = username.length() > 0 && isLD;
        String result = "";
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("blogConn");
            con = ds.getConnection();
            ResultSet rs = null;
            sql2 = con.createStatement();
            rs = sql2.executeQuery("select * from user where username='"+username+"'");
            if (rs.next() && !userid.equals(rs.getString(1))){
                result = "���û����ѱ�ʹ��";
                fail(request,response,profileBean,result);
                con.close();
                return;
            }
            String insertCondition = "update user set username =?,role = ?,gender = ?,email = ?,phone= ?,birthday = ? where userid = " + request.getParameter("userid");
            if (birthday.equals(""))
                insertCondition = "update user set username =?,role = ?,gender = ?,email = ?,phone= ?,birthday = null where userid = " + request.getParameter("userid");
            sql = con.prepareStatement(insertCondition);
            if (boo) {
                sql.setString(1, username);
                sql.setString(2, role);
                sql.setString(3, gender);
                sql.setString(4, email);
                sql.setString(5, phone);
                if (!birthday.equals(""))
                    sql.setString(6, birthday);
                int m = sql.executeUpdate();
                if (m != 0)
                    profileBean.setResult("�޸ĳɹ���");
            } else
                profileBean.setResult("��Ϣ��д���������������зǷ��ַ���");
            con.close();
        } catch (SQLException exp) {
            profileBean.setResult("����û����Ѿ���ʹ��" + exp);
        } catch (NamingException exp) {
            profileBean.setResult("û���������ӳ�" + exp);
        } finally {
            try {
                con.close();
            } catch (Exception ee) {
            }
        }
        if(profileBean.getResult()=="�޸ĳɹ���"){
            RequestDispatcher dispatcher = request.getRequestDispatcher("spaceServlet?userid="+userid);
            dispatcher.forward(request, response);
        }
        else{
            RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
            dispatcher.forward(request, response);
        }
    }

    public void fail(HttpServletRequest request,HttpServletResponse response,Profile profileBean,String result)
            throws ServletException,IOException {
        profileBean.setResult(result);
        RequestDispatcher dispatcher =
                request.getRequestDispatcher("profile.jsp");
        dispatcher.forward(request, response);
    }
}
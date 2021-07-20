package handle.data;
import save.data.Post;
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
public class HandlePost extends HttpServlet{
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
    }
    public void service(HttpServletRequest request,HttpServletResponse response)
        throws ServletException,IOException {
        response.setCharacterEncoding("utf-8");
        Connection con = null;
        PreparedStatement sql = null;
        Post postBean = new Post();
        request.setAttribute("postBean", postBean);
        String title = request.getParameter("title").trim();
        String userid = request.getParameter("userid").trim();
        String keywords = request.getParameter("keywords").trim();
        String text = request.getParameter("text");
        String readingPermission = request.getParameter("readingPermission").trim();
        String commentPermission = request.getParameter("commentPermission").trim();

        if (title == null) {
            String result = "���ⲻ��Ϊ�գ�";
            fail(request,response,postBean,result);
            return;
        }
        if (userid == null) {
            String result = "��¼���ڣ������µ�¼��";
            fail(request,response,postBean,result);
            return;
        }
        if (keywords == null) {
            String result = "�ؼ��ʲ���Ϊ�գ�";
            fail(request,response,postBean,result);
            return;
        }
        if (text == null) {
            String result = "���Ĳ���Ϊ�գ�";
            fail(request,response,postBean,result);
            return;
        }
        if (readingPermission == null) {
            String result = "�������Ķ�Ȩ�ޣ�";
            fail(request,response,postBean,result);
            return;
        }
        if (commentPermission == null) {
            String result = "����������Ȩ�ޣ�";
            fail(request,response,postBean,result);
            return;
        }

        String result = "";
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("blogConn");
            con = ds.getConnection();
            ResultSet rs = null;
            String insertCondition = "INSERT INTO article (title,userid,post_time,open_read,open_comment,keywords,content) VALUES(?,?,?,?,?,?,?)";
            sql = con.prepareStatement(insertCondition);
            sql.setString(1, title);
            sql.setString(2, userid);
            sql.setTimestamp(3, new java.sql.Timestamp(System.currentTimeMillis()));
            sql.setString(4, readingPermission);
            sql.setString(5, commentPermission);
            sql.setString(6, keywords);
            sql.setString(7, text);
            int m = sql.executeUpdate();
            if (m != 0)
                postBean.setResult("�����ɹ���");
        } catch (SQLException exp) {
            postBean.setResult("����ʧ�ܣ�" + exp);
        } catch (NamingException exp) {
            postBean.setResult("û���������ӳ�" + exp);
        } finally {
            try {
                con.close();
            } catch (Exception ee) {
            }
        }
        if(postBean.getResult()=="�����ɹ���"){
            RequestDispatcher dispatcher = request.getRequestDispatcher("spaceServlet?userid="+ userid);
            dispatcher.forward(request, response);
        }
        else{
            RequestDispatcher dispatcher = request.getRequestDispatcher("post.jsp");
            dispatcher.forward(request, response);
        }
    }

    public void fail(HttpServletRequest request,HttpServletResponse response,Post postBean,String result)
            throws ServletException,IOException {
        postBean.setResult(result);
        RequestDispatcher dispatcher =
                request.getRequestDispatcher("post.jsp");
        dispatcher.forward(request, response);
    }
}
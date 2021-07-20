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
            String result = "标题不能为空！";
            fail(request,response,postBean,result);
            return;
        }
        if (userid == null) {
            String result = "登录过期，请重新登录！";
            fail(request,response,postBean,result);
            return;
        }
        if (keywords == null) {
            String result = "关键词不能为空！";
            fail(request,response,postBean,result);
            return;
        }
        if (text == null) {
            String result = "正文不能为空！";
            fail(request,response,postBean,result);
            return;
        }
        if (readingPermission == null) {
            String result = "请设置阅读权限！";
            fail(request,response,postBean,result);
            return;
        }
        if (commentPermission == null) {
            String result = "请设置评论权限！";
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
                postBean.setResult("发布成功！");
        } catch (SQLException exp) {
            postBean.setResult("发布失败！" + exp);
        } catch (NamingException exp) {
            postBean.setResult("没有设置连接池" + exp);
        } finally {
            try {
                con.close();
            } catch (Exception ee) {
            }
        }
        if(postBean.getResult()=="发布成功！"){
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
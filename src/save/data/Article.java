package save.data;
public class Article {
    int userid;
    String title,post_time,keywords,content,username,id,comment;
    public void setTitle(String title){
        this.title=title;
    }
    public String getTitle(){
        return this.title;
    }
    public void setPostTime(String post_time){
        this.post_time=post_time;
    }
    public String getPostTime(){
        return this.post_time;
    }
    public void setKeywords(String keywords){
        this.keywords=keywords;
    }
    public String getKeywords(){
        return this.keywords;
    }
    public void setContent(String content){
        this.content=content;
    }
    public String getContent(){
        return this.content;
    }
    public void setUserName(String username){
        this.username=username;
    }
    public String getUserName(){
        return this.username;
    }
    public void setUserId(int userid){
        this.userid=userid;
    }
    public int getUserId(){
        return this.userid;
    }
    public void setId(String id){
        this.id=id;
    }
    public String getId(){
        return this.id;
    }
    public void setComment(String comment){
        this.comment=comment;
    }
    public String getComment(){
        return this.comment;
    }
}
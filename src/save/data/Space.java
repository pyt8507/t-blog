package save.data;
public class Space {
    String username,role,registerTime,birthday,gender,email,phone;
    int userid;
    public void setUserId(int userid){
        this.userid=userid;
    }
    public int getUserId(){
        return this.userid;
    }
    public void setUsername(String username){
        this.username=username;
    }
    public String getUsername(){
        return this.username;
    }
    public void setRole(String role){
        this.role=role;
    }
    public String getRole(){
        return this.role;
    }
    public void setRegisterTime(String registerTime){
        this.registerTime=registerTime;
    }
    public String getRegisterTime(){
        return this.registerTime;
    }
    public void setBirthday(String birthday){
        this.birthday=birthday;
    }
    public String getBirthday(){
        return this.birthday;
    }
    public void setGender(String gender){
        this.gender=gender;
    }
    public String getGender(){
        return this.gender;
    }
    public void setEmail(String email){
        this.email=email;
    }
    public String getEmail(){
        return this.email;
    }
    public void setPhone(String phone){
        this.phone=phone;
    }
    public String getPhone(){
        return this.phone;
    }
}
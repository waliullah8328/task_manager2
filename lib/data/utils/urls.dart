class Urls{
  static const _baseUrl = "http://35.73.30.144:2005/api/v1";


  static const registration = "$_baseUrl/Registration";
  static const login = "$_baseUrl/Login";
  static const createTask = "$_baseUrl/createTask";
  static const newTaskList = "$_baseUrl/listTaskByStatus/New";
  static const completedTaskList = "$_baseUrl/listTaskByStatus/Completed";
  static const canceledTaskList = "$_baseUrl/listTaskByStatus/Canceled";
  static const progressTaskList = "$_baseUrl/listTaskByStatus/Progress";
  static const forgotEmail = "$_baseUrl/RecoverVerifyEmail";
  static const forgotOTP = "$_baseUrl/RecoverVerifyOtp";
  static const recoverResetPassword = "$_baseUrl/RecoverResetPassword";
  static updateTaskStatus(String taskId, String status) => "$_baseUrl/updateTaskStatus/$taskId/$status";
  static deleteTask(String taskId) => "$_baseUrl/deleteTask/$taskId";
  static const taskStatusCount = "$_baseUrl/taskStatusCount";
  static const profileUpdate = "$_baseUrl/ProfileUpdate";

}
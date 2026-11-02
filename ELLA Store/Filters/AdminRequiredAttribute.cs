using System.Web.Mvc;
using System.Web.Routing;

namespace ELLA_Store.Filters
{
    // Gắn lên controller/action quản trị: chỉ tài khoản Role = "Admin" mới vào được.
    public class AdminRequiredAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            var session = filterContext.HttpContext.Session;

            if (session["UserID"] == null)
            {
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new
                {
                    controller = "Home",
                    action = "DangNhap",
                    returnUrl = filterContext.HttpContext.Request.RawUrl
                }));
            }
            else if ((string)session["Role"] != "Admin")
            {
                filterContext.Result = new HttpStatusCodeResult(403, "Bạn không có quyền truy cập trang này");
            }
        }
    }
}

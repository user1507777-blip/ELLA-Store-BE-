using System.Web.Mvc;
using System.Web.Routing;

namespace ELLA_Store.Filters
{
    // Gắn lên action cần đăng nhập; chưa đăng nhập thì chuyển sang trang Đăng nhập.
    public class LoginRequiredAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (filterContext.HttpContext.Session["UserID"] == null)
            {
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new
                {
                    controller = "Home",
                    action = "DangNhap",
                    returnUrl = filterContext.HttpContext.Request.RawUrl
                }));
            }
        }
    }
}

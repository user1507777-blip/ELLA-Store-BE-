using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core.EntityClient;
using System.Data.SqlClient;
using System.Reflection;

namespace ELLA_Store.Helpers
{
    // Tu do server SQL khi khoi dong web.
    // Neu chuoi ket noi trong Web.config khong mo duoc thi thu lan luot:
    // .\SQLEXPRESS, ., (local), (localdb)\MSSQLLocalDB va dung cai mo duoc database MyStore.
    // Chi thay doi trong bo nho, khong sua file Web.config.
    public static class DbAutoConnect
    {
        public static void Run()
        {
            try
            {
                var cs = ConfigurationManager.ConnectionStrings["MyStoreEntities"];
                if (cs == null) return;

                var ecsb = new EntityConnectionStringBuilder(cs.ConnectionString);
                var goc = new SqlConnectionStringBuilder(ecsb.ProviderConnectionString);

                var ungVien = new List<string>
                {
                    goc.DataSource, @".\SQLEXPRESS", ".", "(local)", @"(localdb)\MSSQLLocalDB"
                };

                foreach (var ds in ungVien)
                {
                    var thu = new SqlConnectionStringBuilder(goc.ConnectionString)
                    {
                        DataSource = ds,
                        ConnectTimeout = 3
                    };
                    if (!MoDuoc(thu.ConnectionString)) continue;

                    // Server trong Web.config da dung: khong can sua gi
                    if (string.Equals(ds, goc.DataSource, StringComparison.OrdinalIgnoreCase)) return;

                    var moi = new SqlConnectionStringBuilder(goc.ConnectionString) { DataSource = ds };
                    ecsb.ProviderConnectionString = moi.ConnectionString;

                    var f = typeof(ConfigurationElement).GetField("_bReadOnly",
                        BindingFlags.Instance | BindingFlags.NonPublic);
                    f.SetValue(cs, false);
                    cs.ConnectionString = ecsb.ConnectionString;
                    return;
                }
            }
            catch { /* khong de loi do tim server lam hong viec khoi dong web */ }
        }

        private static bool MoDuoc(string chuoi)
        {
            try
            {
                using (var c = new SqlConnection(chuoi)) { c.Open(); return true; }
            }
            catch { return false; }
        }
    }
}

using System;
using System.Security.Cryptography;

namespace ELLA_Store.Helpers
{
    // Băm mật khẩu bằng PBKDF2 + salt ngẫu nhiên. Định dạng lưu: "lặp.salt.hash" (Base64).
    public static class PasswordHasher
    {
        private const int Iterations = 10000;
        private const int SaltSize = 16;
        private const int HashSize = 32;

        public static string Hash(string password)
        {
            using (var kdf = new Rfc2898DeriveBytes(password, SaltSize, Iterations))
            {
                byte[] salt = kdf.Salt;
                byte[] hash = kdf.GetBytes(HashSize);
                return Iterations + "." + Convert.ToBase64String(salt) + "." + Convert.ToBase64String(hash);
            }
        }

        public static bool Verify(string password, string stored)
        {
            if (string.IsNullOrEmpty(stored)) return false;
            var parts = stored.Split('.');
            if (parts.Length != 3) return false;

            int iterations = int.Parse(parts[0]);
            byte[] salt = Convert.FromBase64String(parts[1]);
            byte[] expected = Convert.FromBase64String(parts[2]);

            using (var kdf = new Rfc2898DeriveBytes(password, salt, iterations))
            {
                byte[] actual = kdf.GetBytes(expected.Length);
                int diff = 0;                                   // so sánh không rò thời gian
                for (int i = 0; i < expected.Length; i++) diff |= expected[i] ^ actual[i];
                return diff == 0;
            }
        }
    }
}

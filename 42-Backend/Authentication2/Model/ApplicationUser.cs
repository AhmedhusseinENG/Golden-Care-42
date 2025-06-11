using Microsoft.AspNetCore.Identity;

namespace Authentication2.Model
{
    public class ApplicationUser : IdentityUser
    {
        public string Gender { get; set; }
        //public IFormFile ImagePath { get; set; }
        public string ImagePath { get; set; }
        public string? PatientId { get; set; }
        //public string? PatientId { get; set; }

        //public virtual ICollection<ApplicationUser>? Patient { get; set; }
        public virtual Patient? Patient { get; set; }
        public virtual ICollection<Companion>? Companions { get; set; }
    }
}

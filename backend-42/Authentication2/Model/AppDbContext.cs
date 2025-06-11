using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Authentication2.Model
{
    public class AppDbContext  : IdentityDbContext<ApplicationUser>
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Patient> Patients { get; set; }
        public DbSet<Companion> Companions { get; set; }
        public DbSet<Medicine> Medicines { get; set; }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            //builder.Entity<Patient>()
            //    .HasMany(p => p.Companions)
            //    .WithOne(c => c.Patient)
            //    .HasForeignKey(c => c.PatientId);
            //    //.IsRequired(false);

     //       builder.Entity<ApplicationUser>()
     //.HasMany<Companion>()
     //.WithOne<Patient>()
     //.HasForeignKey(u => u.PatientId)
     //.OnDelete(DeleteBehavior.Restrict);


        }
    }
}

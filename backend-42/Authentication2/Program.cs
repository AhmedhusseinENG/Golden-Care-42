using Authentication2.Model;
using Microsoft.AspNetCore.Hosting.Server;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.FileProviders;

var builder = WebApplication.CreateBuilder(args);

// This tells ASP.NET to read from environment variables
builder.Configuration
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
    .AddJsonFile($"appsettings.{builder.Environment.EnvironmentName}.json", optional: true)
    .AddEnvironmentVariables();

// Add DB Context
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Add services to the container.
//builder.Services.AddIdentityCore<ApplicationUser>()
builder.Services.AddIdentity<ApplicationUser, IdentityRole>()
    .AddEntityFrameworkStores<AppDbContext>()
    .AddDefaultTokenProviders();

builder.Services.ConfigureApplicationCookie(options =>
{
    options.LoginPath = "/api/auth/login";
    options.LogoutPath = "/api/auth/logout";
});

//Server = (localdb)\\ProjectModels; Database = Authentication2; Trusted_Connection = True;
// not must encrupt in hosting to be true
//Server=db17964.public.databaseasp.net; Database=db17964; User Id=db17964; Password=z?7D5fR=C6_i; Encrypt=True; TrustServerCertificate=True; MultipleActiveResultSets=True;
builder.Services.AddAuthentication();
builder.Services.AddAuthorization();
builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
// logging erros
builder.Logging.ClearProviders();
builder.Logging.AddConsole();


// Serve multiple folders under /images
var uploadesPath = Path.Combine(builder.Environment.WebRootPath, "uploads");
var medicineImagesPath = Path.Combine(builder.Environment.WebRootPath, "MedicineImages");

var compositeProvider = new CompositeFileProvider(

                new PhysicalFileProvider(uploadesPath),
                new PhysicalFileProvider(medicineImagesPath));

var app = builder.Build();


// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage(); // Show detailed errors
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// one URL => all folders images

// Serve default static files from wwwroot
app.UseStaticFiles();

app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = compositeProvider,
    RequestPath = "/images"
});

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();


app.Run();

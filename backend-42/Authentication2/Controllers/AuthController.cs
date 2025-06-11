using Authentication2.DTOs;
using Authentication2.Model;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.Data;
using System.Diagnostics;

namespace Authentication2.Controllers
{

    

    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;

        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly IWebHostEnvironment _env;

        public AuthController(UserManager<ApplicationUser> userManager, SignInManager<ApplicationUser> signInManager, IWebHostEnvironment env, AppDbContext context)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _env = env;
            _context = context;
        }

        private async Task<string> SaveImageAsync(IFormFile image)
        {
            var uploads = Path.Combine(_env.WebRootPath ?? "wwwroot", "uploads");
            Directory.CreateDirectory(uploads);
            var filePath = Path.Combine(uploads, image.FileName);

            using var stream = new FileStream(filePath, FileMode.Create);
            await image.CopyToAsync(stream);

            return $"/uploads/{image.FileName}";
            //return $"/images/{image.FileName}";
        }

        [HttpPost("register/patient")]
        public async Task<IActionResult> RegisterPatient([FromForm] PatientRegisterDto model)
        {
            var imagePath = await SaveImageAsync(model.Image);
            var patient = new Patient
            {
                UserName = model.Username,
                Email = model.Email,
                Gender = model.Gender,
                ImagePath = imagePath,
                PatientId = null
            };

            var result = await _userManager.CreateAsync(patient, model.Password);
            if (!result.Succeeded)
                return BadRequest(result.Errors);

            //await _userManager.AddToRoleAsync(patient, "Patient");
            return Ok("Patient registered");
        }

        [HttpPost("register/companion")]
        public async Task<IActionResult> RegisterCompanion([FromForm] CompanionRegisterDto model)
        {
            var imagePath = await SaveImageAsync(model.Image);
            var companion = new Companion
            {
                UserName = model.Username,
                Email = model.Email,
                Gender = model.Gender,
                ImagePath = imagePath,
                PatientId = model.PatientId
            };

            var result = await _userManager.CreateAsync(companion, model.Password);
            if (!result.Succeeded)
                return BadRequest(result.Errors);

            //await _userManager.AddToRoleAsync(companion, "Companion");
            return Ok("Companion registered");
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginDto model)
        {
            var user = await _userManager.FindByEmailAsync(model.Email);
            //var user = await _userManager.FindByEmailAsync(model.Email);
            if (user == null)
                return Unauthorized("Invalid username or password");
            //var table= _context.Users.Select(m => new SpecialLoginDto { Username = m.UserName });
            model.Username = user.UserName;
            var result = await _signInManager.PasswordSignInAsync(model.Username, model.Password, false, false);
            //var result = await _signInManager.PasswordSignInAsync(model.Email, model.Password, false, false);
        
            if (!result.Succeeded)
            {
                //Microsoft.AspNetCore.Identity.SignInResult r = result;
                return Unauthorized("Invalid credentials");
                //return (Microsoft.AspNetCore.Identity.SignInResult)result;
            }

            //var name = _context.Roles.EntityType.Name;
            //Debug.WriteLine("This is ", name);


            //using var dataStream = new MemoryStream();
            //await user.ImagePath.CopyToAsync(dataStream);

            //Debug.WriteLine("My second error message.", category);
            //Debug.WriteLine("User Type", User.HasClaim( c=> c.Type.ToLower() == "patient" ) );
            //var value = User.HasClaim(c => c.Type.ToLower() == "patient");
            //(user.PatientId) != null ? ((Companion)user).PatientId : null

            // string foreginKey = null ;
            // var x = (((Companion)user)).PatientId.IsNullOrEmpty();
            //if (!x)
            //    foreginKey = (((Companion)user)).PatientId;

            //string foreginKey = "ahmed";
            //var x = user.PatientId.IsNullOrEmpty();
            //if (!x)
            //    foreginKey = user.PatientId;



            // Return user data
            return Ok(new LoginDetailsDto
            {
                Username = user.UserName,
                Id =  user.Id,
                Email = user.Email,
                Gender = user.Gender,
                Image = user.ImagePath,
                PatientId = user.PatientId
            });
        }
    }
}

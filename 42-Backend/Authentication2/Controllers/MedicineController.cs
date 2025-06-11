using Authentication2.DTOs;
using Authentication2.Model;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace Authentication2.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MedicineController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IWebHostEnvironment _env;
        public MedicineController(AppDbContext context, IWebHostEnvironment env)
        {
            _context = context;
            _env = env;
        }
        //MedicineImages
        private async Task<string>  SaveImageAsync(IFormFile image)
        {
            var MedicineImages = Path.Combine(_env.WebRootPath ?? "wwwroot", "MedicineImages");
            Directory.CreateDirectory(MedicineImages);
            var filePath = Path.Combine(MedicineImages, image.FileName);

            using var stream = new FileStream(filePath, FileMode.Create);
            await image.CopyToAsync(stream);

            //return $"/uploads/{image.FileName}";
            return $"/MedicineImages/{image.FileName}";
            //return $"/images/{image.FileName}";
        }

        [HttpGet("getAllMedicines/{id}")]


        public async Task<IActionResult>  GetALllMedicines(string id)
        {
            var isValid = await _context.Patients.AnyAsync(m => m.Id == id);


            if (!isValid)
                return NotFound($"Not found Patiend with id:{id} in Database");

            var patientMedcines = await _context.Medicines.Where(m => m.PatientID == id).ToListAsync();

            return Ok(patientMedcines);
        }

        [HttpPost("addMedicine")]

        public async Task<IActionResult> AddMedicine([FromForm] MedicineDto medicine)
        {
            try
            {
                var MedicineImagesPath = await SaveImageAsync(medicine.MedicineImage);

                var newMedicine = new Medicine
                {
                    MedicineName = medicine.MedicineName,
                    PatientID = medicine.PatientID,
                    MedicineDosage = medicine.MedicineDosage,
                    StartTime = medicine.StartTime,
                    MedicineNumTimes = medicine.MedicineNumTimes,
                    MedicineImagePath = MedicineImagesPath


                };

                await _context.AddAsync(newMedicine);
                _context.SaveChanges();

                return Ok(newMedicine);
            }
            catch (Exception ex)
            {

                return StatusCode(500, $"ERROR: {ex.Message}");
            }

        
        }

        [HttpPut("updateMedicine/{id}")]
        public async Task<IActionResult> UpdateMedicine(int id , [FromForm]  UpdateMedicineDto dto )
        {
            var medicine = await _context.Medicines.FindAsync(id);

            //if (dto.MedicineImage != null)
            //{

            //    var MedicineImagesPath = await SaveImageAsync(dto.MedicineImage);
            //    medicine.MedicineImagePath = MedicineImagesPath;

            //}


            var MedicineImagesPath = await SaveImageAsync(dto.MedicineImage);

            if (medicine == null)
                return NotFound($"Not found Medicine with id:{id} To Update");


            medicine.MedicineName = dto.MedicineName;
            medicine.PatientID = dto.PatientID;
            medicine.MedicineDosage = (int)dto.MedicineDosage;
            medicine.StartTime = (DateTime)dto.StartTime;
            medicine.MedicineNumTimes = (int)dto.MedicineNumTimes;
            medicine.MedicineImagePath = MedicineImagesPath;


            _context.Update(medicine);
            _context.SaveChanges();

            return Ok(medicine);

        }

        [HttpDelete("deleteMedicine/{id}")]

        public async Task<IActionResult> DeleteMedicine(int id)
        {

            var medicine = await _context.Medicines.FindAsync(id);

            if (medicine == null)
                return NotFound($"Not found medicine with id:{id} To Delete");

            _context.Remove(medicine);
            _context.SaveChanges();

            return Ok(medicine);

        }

    }
}

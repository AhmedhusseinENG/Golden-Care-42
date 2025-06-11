namespace Authentication2.DTOs
{
    public class PatientRegisterDto
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public string Gender { get; set; }
        public IFormFile Image { get; set; }
        //public string PatientId { get; set; }

    }
}

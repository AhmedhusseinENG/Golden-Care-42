namespace Authentication2.DTOs
{
    public class LoginDetailsDto
    {
        public string Username { get; set; }
        public string Id { get; set; }

        public string Email { get; set; }
        public string Gender { get; set; }
        public string Image { get; set; }

        public string? PatientId { get; set; }

        //public IFormFile Image { get; set; }
        //public System.Type Discreminator { get; set; }

        //public string? PatientId { get; set; }
    }
}

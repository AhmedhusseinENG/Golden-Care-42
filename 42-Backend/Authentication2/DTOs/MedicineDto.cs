namespace Authentication2.DTOs
{
    public class MedicineDto
    {
        //public int MedicineID { get; set; }
        public string MedicineName { get; set; }
        public string PatientID { get; set; }
        public int MedicineDosage { get; set; }
        public DateTime StartTime { get; set; }
        public int MedicineNumTimes { get; set; }
        public IFormFile MedicineImage { get; set; }
    }
}

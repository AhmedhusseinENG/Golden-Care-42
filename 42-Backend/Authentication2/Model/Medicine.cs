namespace Authentication2.Model
{
    public class Medicine
    {

        public int MedicineID { get; set; }
        public string PatientID { get; set; }
        public string MedicineName { get; set; }
        public int MedicineDosage { get; set; }
        public int MedicineNumTimes { get; set; }
        public string MedicineImagePath { get; set; }

        //StartTimeUtc
        public DateTime StartTime { get; set; }
        //public DateTime NextTime { get; set; }



    }
}

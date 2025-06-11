using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Authentication2.Migrations
{
    /// <inheritdoc />
    public partial class linkMedicineWithPatientID : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "PatientID",
                table: "Medicines",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PatientID",
                table: "Medicines");
        }
    }
}

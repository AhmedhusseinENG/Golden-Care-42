using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Authentication2.Migrations
{
    /// <inheritdoc />
    public partial class AddImageToMedicine : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "MedicineImagePath",
                table: "Medicines",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "MedicineImagePath",
                table: "Medicines");
        }
    }
}

using Santander.SQL.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Santander.SQL.EFServices
{
    public class SantanderContext : DbContext
    {
        public SantanderContext(string connectionString) : base(connectionString)
        {
            Database.SetInitializer<SantanderContext>(null);
        }

        public DbSet<AccountOperation> AccountOperations { get; set; }
        public DbSet<OperationType> OperationTypes { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.HasDefaultSchema("Santander");


            modelBuilder.Entity<AccountOperation>().Property(p => p.Id).HasColumnName("AccountOperationId");

            modelBuilder.Entity<OperationType>().Property(p => p.Id).HasColumnName("OperationTypeId");

            base.OnModelCreating(modelBuilder);
        }




    }
}

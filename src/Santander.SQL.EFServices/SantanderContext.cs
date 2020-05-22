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

            this.Configuration.AutoDetectChangesEnabled = false;
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

        public override int SaveChanges()
        {

            // Audit
            var modifiedEntities = ChangeTracker.Entries().Where(p => p.State == EntityState.Modified);

            foreach (var entity in modifiedEntities)
            {
                var entityName = entity.Entity.GetType().Name;

                foreach (var prop in entity.OriginalValues.PropertyNames)
                {
                    var originalValue = entity.OriginalValues[prop];
                    var currentValue = entity.CurrentValues[prop];

                    if (originalValue != currentValue)
                    {
                        Console.WriteLine($"Entity {entityName} property {prop} has changed {originalValue} -> {currentValue}");

                    }

                }
            }

            var accountOperationEntities = ChangeTracker.Entries<AccountOperation>().Select(p=>p.Entity).ToList();

            


            return base.SaveChanges();
        }




    }
}

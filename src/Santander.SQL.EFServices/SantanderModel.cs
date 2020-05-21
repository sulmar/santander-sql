namespace Santander.SQL.EFServices
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class SantanderModel : DbContext
    {
        public SantanderModel()
            : base("name=SantanderModel")
        {
        }

        public virtual DbSet<AccountOperations> AccountOperations { get; set; }
        public virtual DbSet<OperationTypes> OperationTypes { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<AccountOperations>()
                .Property(e => e.Account)
                .IsUnicode(false);

            modelBuilder.Entity<AccountOperations>()
                .Property(e => e.OperationStatus)
                .IsFixedLength()
                .IsUnicode(false);

            modelBuilder.Entity<OperationTypes>()
                .HasMany(e => e.AccountOperations)
                .WithRequired(e => e.OperationTypes)
                .WillCascadeOnDelete(false);
        }
    }
}

using Santander.SQL.Models;

namespace Santander.SQL.IServices
{
    public interface IOperationTypeService
    {
        OperationType Get(int id);

        void Update(OperationType operationType);

        void Add(OperationType operationType);
    }
}

@IsTest
public class WorkflowPathServiceStubProvider implements System.StubProvider  {

    private CrudPermissions permissions;
    private Map<Id, CrudPermissions> permissionsByIds;
    private Map<WorkflowObjectPrototype, CrudPermissions> permissionsByPrototype;

    public WorkflowPathServiceStubProvider(CrudPermissions permission) {
        this.permissions = permission;
    }

    public WorkflowPathServiceStubProvider(Map<Id, CrudPermissions> permissionsByIds) {
        this.permissionsByIds = permissionsByIds;
    }

    public WorkflowPathServiceStubProvider(Map<WorkflowObjectPrototype, CrudPermissions> permissionsByPrototype) {
        this.permissionsByPrototype = permissionsByPrototype;
    }

    public Object handleMethodCall(Object stubbedObject,
            String stubbedMethodName,
            System.Type returnType,
            List<System.Type> listOfParamTypes,
            List<String> listOfParamNames,
            List<Object> listOfArgs) {

        if (stubbedMethodName == 'getCrudPermissions') {
            if (returnType == Type.forName('CrudPermissions')) {
                return this.permissions;
            } else if (returnType == Map<Id, CrudPermissions>.Class) {
                return this.permissionsByIds;
            } else if (returnType == Map<WorkflowObjectPrototype, CrudPermissions>.class) {
                return this.permissionsByPrototype;
            }
        }

        return null;
    }
}
/**
 * Created by YaroslavDehtiar on 17.09.2019.
 */

({
    handleComponent : function (cmp, event) {
        var inputFields = event.getParam("fieldsInInput");
        cmp.set("v.fieldsInInput", inputFields);
        var inputOperations = event.getParam("inputOperations");
        cmp.set("v.inputOperations", inputOperations);
    }
});
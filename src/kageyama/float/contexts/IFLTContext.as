/**
 * Created by MEGNAE on 2013/12/21.
 */
package kageyama.float.contexts
{
    import flash.utils.ByteArray;

    public interface IFLTContext
    {
        function toJSON():String;
        function toString():String;
        function toObject():Object;
        function toMsgPack():ByteArray;
        function fromObject(obj:Object):IFLTContext;
    }
}

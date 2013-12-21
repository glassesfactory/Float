/**
 * Created by MEGNAE on 2013/12/21.
 */
package kageyama.float.core.structures {
    public class Enum {

        public function name():String{ return _name; }
        private var _name:String;

        public function Enum( name: String )
        {
            _name = name;
        }

        public function toString():String
        {
            return _name;
        }
    }
}

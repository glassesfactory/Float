/**
 * Created by MEGNAE on 2013/12/21.
 *
 * 基本となる Model クラス。
 */
package kageyama.float.models
{
    public class FLTBaseModel
    {
        public function FLTBaseModel()
        {
        
        }

        public function save():void
        {

        }



        public function update():void
        {

        }



        public function del():void
        {

        }


        public function get(id:uint):void
        {

        }




        /**
         * 生でクエリをぶっこむ
         * @param queryStr
         */
        public function query(queryStr:String):void
        {

        }

        public function filter():FLTBaseModel
        {
            return this
        }

        public function order():FLTBaseModel
        {
            return this;
        }

        public function fetch():void
        {

        }
    }
}

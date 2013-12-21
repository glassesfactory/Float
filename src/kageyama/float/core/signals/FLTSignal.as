/**
 * Created by MEGNAE on 2013/12/21.
 */
package kageyama.float.core.signals
{
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;
    import flash.utils.Timer;

    import kageyama.float.core.structures.Enum;

    public class FLTSignal
    {
        //デフォルトのシグナルとか
        public static const SIG_ALRM:Enum = new Enum("sig_alrm");

        //コールバック格納庫
        public static var subscriber:Dictionary = new Dictionary();

        private static var _timer:Timer;
        private static var _isTimerRunning:Boolean = false;



        /**
         * シグナルを通知する
         */
        public static function notify(signal:String):void
        {
            var cbs:Vector.<Function> = subscriber[signal];
            //callback が登録されていなければ返す。
            if(!cbs || cbs.length < 1){ return }

            var i:int = cbs.length;
            for(i; i > 0; i--) cbs[i](signal);
            return
        }



        /** 登録する*/
        public static function subscribe(signal:String, callback:Function):void
        {
            if(!(signal in subscriber)) subscriber[signal] = new Vector.<Function>();
            subscriber[signal].push(callback);
        }



        /** 登録を解除する */
        public static function unsubscribe(signal:String, callback:Function):void
        {
            //登録がなければ返す
            if(!(signal in subscriber)){ return; }

            var cbs:Vector.<Function> = subscriber[signal];
            if(!cbs || cbs.length < 1){ return; }

            var i:uint = cbs.length;

            for(i; i > 0; i--)
            {
                var cb:Function = cbs[i];
                if(cb == callback)
                {
                    //0になる時はシグナルごと削除する
                    cbs.splice(i,1);
                    break
                }
            }
            if(cbs.length < 1)
                delete subscriber[signal];
        }



        /**
         * 指定秒数後に SIG_ALRM を送出する。
         * @param timeout 秒数(単位は秒)
         *
         * 0 を指定された場合はalarmのスケジューリングをキャンセルします。
         */
        public static function alarm(timeout:uint=0):void
        {
            if( timeout == 0 || _isTimerRunning)
                _removeTimer();

            //0を指定された場合は返す
            if( timeout == 0)
                return
            //ミリ秒にする
            var delay:uint = timeout * 1000 | 0;
            _timer = new Timer(delay);
            _timer.addEventListener( TimerEvent.TIMER_COMPLETE, _timerHandler );
            _timer.start();

        }



        /**
         * タイマーが完了した
         * @param event
         */
        private static function _timerHandler(event:TimerEvent):void
        {
            _removeTimer();
            notify(SIG_ALRM as String);
        }



        /**
         * タイマーを消す
         */
        private static function _removeTimer():void
        {
            _timer.stop();
            _timer.removeEventListener( TimerEvent.TIMER_COMPLETE, _timerHandler );
            _timer = null;
            //稼動状態を解除する
            _isTimerRunning = false;
        }
    }
}

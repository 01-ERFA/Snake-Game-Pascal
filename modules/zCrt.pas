UNIT zCrt;

    INTERFACE
        USES Crt;

        CONST 
            Black        = Crt.Black;
            Blue         = Crt.Blue;
            Green        = Crt.Green;
            Cyan         = Crt.Cyan;
            Red          = Crt.Red;
            Magenta      = Crt.Magenta;
            Brown        = Crt.Brown;
            LightGray    = Crt.LightGray;
            DarkGray     = Crt.DarkGray;
            LightBlue    = Crt.LightBlue;
            LightGreen   = Crt.LightGreen;
            LightCyan    = Crt.LightCyan;
            LightRed     = Crt.LightRed;
            LightMagenta = Crt.LightMagenta;
            Yellow       = Crt.Yellow;
            White        = Crt.White;
            Blink        = Crt.Blink;

        VAR 
            KeyPressed     : function : System.Boolean;
            ReadKey        : function : System.Char;

            TextMode       : procedure(Mode : System.Word);
            Window         : procedure(X1, Y1, X2, Y2 : System.Byte);
            ClrScr         : procedure;
            ClrEol         : procedure;
            InsLine        : procedure;
            DelLine        : procedure;
            TextColor      : procedure(Color : System.Byte);
            TextBackground : procedure(Color : System.Byte); 
            LowVideo       : procedure;
            HighVideo      : procedure;
            NormVideo      : procedure;

            CursorOn       : procedure;
            CursorOff      : procedure;
            CursorBig      : procedure;
            GotoXY         : procedure(X, Y : Crt.tcrtcoord);
            WhereX         : function : Crt.tcrtcoord;
            WhereY         : function : Crt.tcrtcoord;

            Sound          : procedure(Hz : System.Word);
            NoSound        : procedure;

            Delay          : procedure(Ms : System.Word);

            ScreenWidth    : System.Integer;
            ScreenHeight   : System.Integer;


    IMPLEMENTATION

    INITIALIZATION

        KeyPressed     := @Crt.KeyPressed;
        ReadKey        := @Crt.ReadKey;

        TextMode       := @Crt.TextMode;
        Window         := @Crt.Window;
        ClrScr         := @Crt.ClrScr;
        ClrEol         := @Crt.ClrEol;
        InsLine        := @Crt.InsLine;
        DelLine        := @Crt.DelLine;
        TextColor      := @Crt.TextColor;
        TextBackground := @Crt.TextBackground;
        LowVideo       := @Crt.LowVideo;
        HighVideo      := @Crt.HighVideo;
        NormVideo      := @Crt.NormVideo;

        CursorOn       := @Crt.CursorOn;
        CursorOff      := @Crt.CursorOff;
        CursorBig      := @Crt.CursorBig;
        GotoXY         := @Crt.GotoXY;
        WhereX         := @Crt.WhereX;
        WhereY         := @Crt.WhereY;

        Sound          := @Crt.Sound;
        NoSound        := @Crt.NoSound;

        Delay          := @Crt.Delay;

        ScreenWidth    := Crt.ScreenWidth;
        ScreenHeight   := Crt.ScreenHeight;
        
END.
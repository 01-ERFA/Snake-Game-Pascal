PROGRAM ViperGame;

    USES SysUtils, zCrt in './modules/zCrt';

    TYPE 
        TCoords = Array[0..1] of System.Integer;
        TViper = Record
            Body   : Array OF TCoords;
            Header : TCoords;
            Tail   : TCoords;
            Color  : System.Byte;
            Draw   : System.Char;
            ID     : System.Integer;
        END;
        TBoard = Record
            BdLogic : Array OF Array OF System.Integer;
            Rows    : System.Integer;
            Cols    : System.Integer;
            RowsI   : System.Integer;
            ColsI   : System.Integer;
        END;
        TPoint = Record
            Body  : TCoords;
            Color : System.Byte;
            Draw  : System.Char;
            ID    : System.Integer;
        END;
        TEnvironment = Record
            ID    : System.Integer;
            Color : System.Byte;
            Draw  : System.Char;
        END;
        TBackground = Record
            ID    : System.Integer;
            Color : System.Byte;
            Draw  : System.Char;
        END;
        TDirections = Record
            Top    : System.Char;
            Bottom : System.Char;
            Left   : System.Char;
            Right  : System.Char;
        END;
        TControls = Record
            Top    : System.Char;
            Bottom : System.Char;
            Left   : System.Char;
            Right  : System.Char;
            GoOut  : System.Char;
        END;
        TTime = Record
            Delay   : System.Integer;
            Start   : System.DWord;
            WaitKey : System.Integer;
        END;
        TGame = Record 
            Title      : System.String;
            Score      : System.Integer;
            NotRunning : System.Boolean;
            GameOver   : System.Boolean;
            Board      : TBoard;
            Viper      : TViper;
            Point      : TPoint;
            EnvBoard   : TEnvironment;
            Bground    : TBackground;
            Controls   : TControls;
            Directions : TDirections;
            MoveDir    : System.Char;
            Time       : TTime;
        END;

    
    VAR Game  : TGame; 
        i, j  : System.Integer;
        DrawX : System.Integer;
        DrawY : System.Integer;
        Key   : System.Char;

    PROCEDURE DrawGame; BEGIN    
        FOR i := 0 TO Game.Board.RowsI DO FOR j := 0 TO Game.Board.ColsI DO BEGIN
            DrawX := j;
            DrawY := i;
            zCrt.GotoXY(DrawX, DrawY);
            IF Game.Board.BdLogic[i][j] = Game.EnvBoard.ID THEN BEGIN
                zCrt.TextColor(Game.EnvBoard.Color);
                Write (Game.EnvBoard.Draw);
            END;
            IF Game.Board.BdLogic[i][j] = Game.Bground.ID THEN BEGIN
                zCrt.TextColor(Game.Bground.Color);
                Write (Game.Bground.Draw);
            END;
        END;
    END;

    PROCEDURE DrawSnakeAndPoint; BEGIN
        zCrt.TextColor(Game.Viper.Color);
        FOR i := 0 TO System.High(Game.Viper.Body) DO BEGIN
            DrawX := Game.Viper.Body[i][0];
            DrawY := Game.Viper.Body[i][1];
            zCrt.GotoXY(DrawX, DrawY);
            Write (Game.Viper.Draw);
        END;

        zCrt.TextColor(Game.Point.Color);
        DrawX := Game.Point.Body[0];
        DrawY := Game.Point.Body[1];
        zCrt.GotoXY(DrawX, DrawY);
        Write (Game.Point.Draw);
    END;

    BEGIN

    Game.Title             := 'Viper Game';
    Game.Score             := 0;

    Game.Bground.ID        := 0;
    Game.Bground.Color     := zCrt.DarkGray;
    Game.Bground.Draw      := ' ';

    Game.Point.ID          := 2;
    Game.Point.Color       := zCrt.Magenta;
    Game.Point.Draw        := '@';

    Game.Viper.ID          := 8;
    Game.Viper.Color       := zCrt.Green;
    Game.Viper.Draw        := '#';

    Game.EnvBoard.ID       := 1;
    Game.EnvBoard.Color    := zCrt.Red;
    Game.EnvBoard.Draw     := '&';

    Game.Controls.Top      := #72;
    Game.Controls.Bottom   := #80;
    Game.Controls.Left     := #75;
    Game.Controls.Right    := #77;
    Game.Controls.GoOut    := #27;

    Game.Directions.Top    := 'T';
    Game.Directions.Bottom := 'B';
    Game.Directions.Left   := 'L';
    Game.Directions.Right  := 'R';

    Game.Time.Delay        := 25;
    Game.Time.WaitKey      := 100;
    
    (* GAME *)

    System.Randomize;

    zCrt.TextBackground(Game.Bground.Color);
    zCrt.ClrScr;

    Game.NotRunning := System.False;
    Game.GameOver   := System.False;
    Game.MoveDir    := Game.Directions.Top;

    Game.Board.Rows := zCrt.ScreenHeight -1;
    Game.Board.Cols := zCrt.ScreenWidth  -1;

    System.SetLength(Game.Board.BdLogic, Game.Board.Rows, Game.Board.Cols);

    Game.Board.RowsI := System.High(Game.Board.BdLogic);
    Game.Board.ColsI := System.High(Game.Board.BdLogic[0]);

    FOR i := 0 TO Game.Board.RowsI DO FOR j := 0 TO Game.Board.ColsI DO Game.Board.BdLogic[i][j] := Game.Bground.ID;

    
    j := Game.Board.RowsI;
    FOR i := 0 TO Game.Board.ColsI DO Game.Board.BdLogic[1, i] := Game.EnvBoard.ID;
    FOR i := 0 TO Game.Board.RowsI DO Game.Board.BdLogic[i, 0] := Game.EnvBoard.ID;
    FOR i := 0 TO Game.Board.ColsI DO Game.Board.BdLogic[j, i] := Game.EnvBoard.ID;
    FOR i := 0 TO Game.Board.RowsI DO Game.Board.BdLogic[i, 1] := Game.EnvBoard.ID;


    System.SetLength (Game.Viper.Body, 2);

    Game.Viper.Header[0] := Game.Board.ColsI DIV 2;
    Game.Viper.Header[1] := Game.Board.RowsI DIV 2;

    Game.Viper.Tail[0] := Game.Viper.Header[0];
    Game.Viper.Tail[1] := Game.Viper.Header[1] + 1;

    Game.Viper.Body[0] := Game.Viper.Header;
    Game.Viper.Body[1] := Game.Viper.Tail;

    i := Game.Viper.Body[0][1];
    j := Game.Viper.Body[0][0];
    Game.Board.BdLogic[i][j] := Game.Viper.ID;

    i := Game.Viper.Body[1][1];
    j := Game.Viper.Body[1][0];
    Game.Board.BdLogic[i][j] := Game.Viper.ID;


    REPEAT 
        Game.Point.Body[0] := System.Random(Game.Board.ColsI);
        Game.Point.Body[1] := System.Random(Game.Board.RowsI);
        i := Game.Point.Body[1];
        j := Game.Point.Body[0];
    UNTIL Game.Board.BdLogic[i, j] = Game.Bground.ID;

    Game.Board.BdLogic[i, j] := Game.Point.ID;
    DrawGame;

    REPEAT
        DrawSnakeAndPoint;
        Game.Time.Start := SysUtils.GetTickCount64;

        REPEAT
            IF zCrt.KeyPressed() THEN Key := zCrt.ReadKey();
            zCrt.Delay(Game.Time.Delay);
        UNTIL (SysUtils.GetTickCount64 - Game.Time.Start >= Game.Time.WaitKey);

        IF Key = Game.Controls.GoOut  THEN Game.NotRunning := System.True;

        IF Key = Game.Controls.Top    THEN IF Game.MoveDir <> Game.Directions.Bottom THEN Game.MoveDir := Game.Directions.Top;
        IF Key = Game.Controls.Bottom THEN IF Game.MoveDir <> Game.Directions.Top    THEN Game.MoveDir := Game.Directions.Bottom;  
        IF Key = Game.Controls.Left   THEN IF Game.MoveDir <> Game.Directions.Right  THEN Game.MoveDir := Game.Directions.Left;
        IF Key = Game.Controls.Right  THEN IF Game.MoveDir <> Game.Directions.Left   THEN Game.MoveDir := Game.Directions.Right;  

        IF Game.MoveDir = Game.Directions.Top    THEN Game.Viper.Header[1] := Game.Viper.Header[1] -1;
        IF Game.MoveDir = Game.Directions.Bottom THEN Game.Viper.Header[1] := Game.Viper.Header[1] +1;
        IF Game.MoveDir = Game.Directions.Left   THEN Game.Viper.Header[0] := Game.Viper.Header[0] -1;
        IF Game.MoveDir = Game.Directions.Right  THEN Game.Viper.Header[0] := Game.Viper.Header[0] +1;

        j := System.High(Game.Viper.Body);
        Game.Viper.Tail[0] := Game.Viper.Body[i][0];
        Game.Viper.Tail[1] := Game.Viper.Body[i][1];

        FOR i := j DOWNTO 1 DO Game.Viper.Body[i] := Game.Viper.Body[i -1];
        
        Game.Viper.Body[0][0] := Game.Viper.Header[0];
        Game.Viper.Body[0][1] := Game.Viper.Header[1];

        i := Game.Viper.Tail[1];
        j := Game.Viper.Tail[0];
        Game.Board.BdLogic[i, j] := Game.Bground.ID;
        zCrt.TextColor(Game.Bground.Color);
        DrawX := j;
        DrawY := i;
        zCrt.GotoXY(DrawX, DrawY);
        Write (Game.Bground.Draw);

        i := Game.Viper.Body[0][1];
        j := Game.Viper.Body[0][0];
        IF (Game.Board.BdLogic[i, j] = Game.EnvBoard.ID) or (Game.Board.BdLogic[i, j] = Game.Viper.ID) THEN Game.GameOver := System.True;

        IF (Game.Board.BdLogic[i, j] = Game.Point.ID) THEN BEGIN 
            Game.Score := Game.Score + 1;

            i := System.Length(Game.Viper.Body) +1;
            SetLength (Game.Viper.Body, i);
            
            Game.Viper.Body[i -1][0] := Game.Viper.Tail[0];
            Game.Viper.Body[i -1][1] := Game.Viper.Tail[1];

            i := Game.Viper.Tail[1];
            j := Game.Viper.Tail[0];
            Game.Board.BdLogic[i, j] := Game.Viper.ID;
            
            REPEAT 
                Game.Point.Body[0] := System.Random(Game.Board.ColsI);
                Game.Point.Body[1] := System.Random(Game.Board.RowsI);
                i := Game.Point.Body[1];
                j := Game.Point.Body[0];
            UNTIL Game.Board.BdLogic[i, j] = Game.Bground.ID;
            Game.Board.BdLogic[i, j] := Game.Point.ID;
        END;

        FOR i := 0 TO System.High(Game.Viper.Body) DO Game.Board.BdLogic[Game.Viper.Body[i][1], Game.Viper.Body[i][0]] := Game.Viper.ID;

        zCrt.Delay(Game.Time.Delay);
        IF Game.GameOver = System.True THEN Game.NotRunning := System.True;
    UNTIL Game.NotRunning;
        
    zCrt.TextColor(zCrt.White);
    zCrt.TextBackground(zCrt.Black);

    zCrt.ClrScr;
    WriteLn ('Your Score is: ', Game.Score);

    System.SetLength(Game.Board.BdLogic, 0, 0);
    System.SetLength(Game.Viper.Body, 0);
END.
unit HodovayaUnit; // Ezda-Shum-Perestuk

interface

uses Types, Common;

type
  Hodovaya = class(TObject)

  published
    constructor create();

  private type
    TPQueueEntry = record
      axisIdx: byte;
      time: Integer;
      fileId: byte;
      sound: TSound;
    end;

    THodovaya = record
      perestuk: record
        queueSize: byte;
        startIdx: byte;
        endIdx: byte;
        queue: array of TPQueueEntry;
      end;

      brake: TSound;
      ezda: TSound;
      shum: TSound;
    end;

  procedure HandleEzda(var entity: THodovaya; loco: string; speed: Double);

  procedure HandlePerestuk(var entity: THodovaya; speed: Double; track: TValue<Integer>; consist: TConsist;
    isStaticEntityY: Boolean = False; staticEntityY: Double = 0; ourOrdinateCurrent: Double = 0;
    ourOrdinatePrev: Double = 0);
  end

implementation

end.

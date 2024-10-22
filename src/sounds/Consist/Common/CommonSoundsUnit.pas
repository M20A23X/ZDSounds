unit CommonSoundsUnit;

interface

type

  // Camera
  TEnvEnum = (ENV_CAB, ENV_LOCO, ENV_MASH, ENV_COM);

  TCamera = record
    x: Single;
    y: Single;
    z: Single;
    aZ: Single;
    aX: Single;
    zoom: Single;
    env: TEnvEnum;
  end;

  // Entity
  TCoord = record
    x: Double;
    y: Double;
    z: Double;
  end;

  TEntity = record
    coords: TCoord;
    env: TEnvEnum;
    volume: Double;
  end;

  // Sound
  TFXAttrs = record
    volume: Double;
    tempo: Double;
    pitch: Double;
    pan: Double;
  end;

  TFX = record
    default: Cardinal;
    tempo: Cardinal;
    attrs: TFXAttrs;
  end;

  TSound = record
    id: String;
    entity: TEntity;
    channels: array of TFX;
    states: array of Boolean;
    timers: array of Integer;

    procedure getInit(id: string; channels: byte = 1; states: byte = 0; timers: byte = 0);
    procedure restart(idx: byte; FileName: String; flags: byte = 0);
    procedure pause(idx: byte);
    procedure resume(idx: byte);
    function check(idx: byte; isPlaying: Boolean = True): Boolean;
    procedure free(idx: byte);
    procedure updateAttrs(idx: byte; check: Boolean = False);
    procedure update();
  end;

  // Misc
  TPneumaticIDEnum = (P_ZARYADKA, P_VPUSK, P_VIPUSK, PN_TORM, PN_DT, PN_TC, PN_CL_254, PN_CL_395);
  TKMStateIDEnum = (KM_AP = 2, KM_P = 1, KM_N = 0, KM_M = 255, KM_AM = 254);

implementation

end.

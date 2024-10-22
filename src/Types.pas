unit Types;

interface

type
  // Values
  TValue<T> = record
    current: T;
    previous: T;
  end;

  // Consist
  TConsistTypeEnum = (CON_PASS, CON_FREIGHT, CON_RESERV);

  TConsistUnit = record
    axesAmount: Integer;
    axes: TArray<Integer>;
    length: Integer;
  end;

  TConsist = record
    loco: string;
    sectionsAmt: byte;
    type_: TConsistTypeEnum;
    length: Single;
    wagonsAmount: byte;
    axesAmt: Integer;
    locoUnit: TConsistUnit;
    wagonUnit: TConsistUnit;
  end;

  // Stations
  TStation = record
    startTrack: Integer;
    endTrack: Integer;
  end;

implementation

end.

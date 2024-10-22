unit Vstrech;

interface

uses Types, Common, HodovayaUnit, Generics.Collections;

type
  Vstrech_ = class(TObject)

  private
    constructor Create;

  private type
    TVstrechMovingEnum = (VST_ONC, VST_HEAD_PASSED_OUR_HEAD, VST_TAIL_PASSED_OUR_HEAD, VST_PASSED);

  var
    consist: TConsist;

    staticEntityY: Double;
    entity: TSound;
    mvEntity: TSound;
    svistokEntity: TSound;
    tifonEntity: TSound;
    hodovaya: hodovaya;

    isSvistok: byte;
    isTifon: byte;

    shouldReinit: Boolean;
    shouldReset: Boolean;
    ordinateDelta: Double;
    ordinateDiff: Double;
    track: TValue<Integer>;
    ordinate: Double;
    speeds: TQueue<Single>;
    speed: Single;
    movingStatus: TVstrechMovingEnum;

    procedure Reinit(FreightWagonUnit: TConsistUnit; PassWagonUnit: TConsistUnit);
    procedure HandleSignals();
    procedure HandleEntities(consistLength: Single; route: String; naprav: String; napravSign: byte; ordinata: Double);
    procedure HandleSounds(speed: Double; napravSign: byte; ordinate: TValue<Double>);

  public
    procedure Handle(napravSign: byte; ordinate: TValue<Double>; track: Integer; ordinata: Double;
      consistLength: Single; speed: Single; FreightWagonUnit: TConsistUnit; PassWagonUnit: TConsistUnit);

  end;

implementation

uses UnitMain, soundManager, SysUtils, Bass;

constructor Vstrech_.Create;
begin
  Vstrech.entity.getInit('vstrech-main');
  Vstrech.mvEntity.getInit('vstrech-mv');
  Vstrech.svistokEntity.getInit('vstrech-svistok', 1, 1);
  Vstrech.tifonEntity.getInit('vstrech-tifon', 1, 1);
  Vstrech.hodovaya.ezda.getInit('vstrech-ezda');
  Vstrech.hodovaya.shum.getInit('vstrech-shum');

  self.shouldReinit := True;
end;

procedure Reinit(FreightWagonUnit: TConsistUnit; PassWagonUnit: TConsistUnit);
begin

  if self.shouldReinit then
  begin
    self.shouldReinit := False;
    self.speed := self.speeds.Dequeue();
    self.movingStatus := VST_ONC;
    self.ordinate := ReadOrdinateByTrack(route, naprav, self.track.current);

    // Consist
    self.consist.sectionsAmt := ReadConsistUnit(self.consist.loco, self.consist.locoUnit);

    if self.consist.wagonsAmount > 2 then
    begin
      if self.consist.wagonUnit.length <= 23 then
      begin
        self.consist.type_ := CON_FREIGHT;
        self.consist.wagonUnit := FreightWagonUnit;
      end
      else
      begin
        self.consist.type_ := CON_PASS;
        self.consist.wagonUnit := PassWagonUnit;
      end;
    end
    else
      self.consist.type_ := CON_RESERV;

    self.consist.axesAmt := self.consist.locoUnit.axesAmount + (self.consist.wagonsAmount - self.consist.sectionsAmt) *
      self.consist.wagonUnit.axesAmount;

    self.hodovaya.perestuk.queue := nil;
    hodovaya.perestuk.queueSize := 0;
    SetLength(self.hodovaya.perestuk.queue, self.consist.axesAmt);
    for var o := 0 to self.consist.axesAmt - 1 do
      self.hodovaya.perestuk.queue[o].sound.getInit('vstrech-perestuk', 8);
  end;
end;

procedure TVstrech.HandleEntities(consistLength: Single; route: String; naprav: String; napravSign: Short;
  ordinata: Double);
begin
  // SVT
  self.ordinateDelta := -napravSign * 0.000278 * self.speed * MainCycleFreq;
  self.ordinate := self.ordinate + self.ordinateDelta;
  self.ordinateDiff := napravSign * (self.ordinate - ordinata);

  // Moving status
  if ordinateDiff > 6.35 then
    self.movingStatus := VST_ONC
  else
  begin
    if -ordinateDiff + 6.35 < self.consist.length then
      self.movingStatus := VST_HEAD_PASSED_OUR_HEAD
    else if -ordinateDiff + 6.35 >= self.consist.length + 0.001 * consistLength then
      self.movingStatus := VST_PASSED
    else
      self.movingStatus := VST_TAIL_PASSED_OUR_HEAD;
  end;

  // Entities coord
  if self.movingStatus <> VST_HEAD_PASSED_OUR_HEAD then
    self.staticEntityY := self.ordinateDiff
  else if self.movingStatus = VST_TAIL_PASSED_OUR_HEAD then
    self.staticEntityY := self.staticEntityY - self.ordinateDelta;

  self.hodovaya.shum.entity.coords.y := self.staticEntityY;
  self.entity.entity.coords.y := self.staticEntityY;

  self.mvEntity.entity.coords.y := self.ordinateDiff;
  self.hodovaya.ezda.entity.coords.y := self.ordinateDiff;
  self.svistokEntity.entity.coords.y := self.ordinateDiff;
  self.tifonEntity.entity.coords.y := self.ordinateDiff;
end;

procedure TVstrech.HandleSelfSignals();
begin
  randomize();
  randomize();
  const
    signalRandom = random();
  if signalRandom > 0.998 then
    self.isSvistok := 1;
  if signalRandom > 0.9997 then
    self.isTifon := 1;

  if checkOnStation(self.track.current) then
  begin
    if signalRandom < 0.01 then
    begin
      self.isSvistok := 0;
      self.isTifon := 0;
    end;
  end
  else if 200 <= Abs(self.ordinateDiff) then
  begin
    if signalRandom < 0.1 then
    begin
      self.isSvistok := 0;
      self.isTifon := 0;
    end;
  end;
end;

procedure TVstrech.HandleSounds(speed: Double; napravSign: Short; ordinate: TValue<Double>);
var
  soundFile: String;
begin
  if self.entity.check(0, False) and (self.consist.type_ <> CON_RESERV) then
  begin
    if self.consist.type_ = CON_PASS then
      soundFile := 'TWS/consist/passenger/vstrech.wav'
    else if self.consist.type_ = CON_FREIGHT then
      soundFile := 'TWS/consist/freight/vstrech.wav';

    self.entity.channels[0].attrs.volume := self.entity.entity.volume * 0.2 * ln(self.speed - 3);
    self.entity.channels[0].attrs.tempo := 10 * ln(self.speed + 1) - 20;
    self.entity.channels[0].attrs.pitch := 0.4 * ln(self.speed + 1) - 1;

    // self.entity.restart(0, soundFile, BSL);
  end;
  // if self.mvEntity.check(0, False) then
  // self.mvEntity.restart(0, 'TWS/consist/' + self.consist.loco + '/mv-x-loop.wav', BSL);

  // HandleSignals(self.isSvistok, self.svistokEntity, self.consist.loco, 'svistok');
  // HandleSignals(self.isTifon, self.tifonEntity, self.consist.loco, 'tifon');

  // self.HandleSelfSignals();
  // HandleEzda(self.hodovaya, self.consist.loco, self.speed);

  // if (self.ordinateDiff < 0) and (-self.ordinateDiff > self.consist.length) then
  HandlePerestuk(self.hodovaya, self.speed, self.track, self.consist, True, self.ordinateDiff, ordinate.current,
    ordinate.previous);
end;

procedure TVstrech.Handle(napravSign: Short; ordinate: TValue<Double>; track: Integer; ordinata: Double;
  consistLength: Single; speed: Single; FreightWagonUnit: TConsistUnit; PassWagonUnit: TConsistUnit);
begin
  if self.track.current <> 0 then
  begin
    if naprav = '1' then
      self.shouldReset := self.track.current > self.track.previous
    else
      self.shouldReset := self.track.current < self.track.previous;

    if self.shouldReset then
    begin
      self.entity.free(0);
      self.shouldReinit := True;
      self.shouldReset := False;
    end
    else
    begin
      self.Reinit(FreightWagonUnit, PassWagonUnit);
      self.HandleEntities(consistLength, route, naprav, napravSign, ordinata);
      self.HandleSounds(speed, napravSign, ordinate);

      self.entity.update();
      self.mvEntity.update();
      self.svistokEntity.update();
      self.tifonEntity.update();
      self.hodovaya.ezda.update();
      self.hodovaya.shum.update();
    end;
  end;
end;

end.

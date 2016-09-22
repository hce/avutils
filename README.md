[![Build Status](https://travis-ci.org/hce/avwx.svg?branch=master)](https://travis-ci.org/hce/avwx)

avwx
====

Fetch and parse aviation weather reports.

METARs and TAFs are quite well parseable; however, they were designed primarily
to be easily read by humans, not machines. Subtle differences between countries
(and even between weather stations) and lack of comprehensive documentation
make it very difficult to create a reliable parser. This is subject to ongoing
testing. Patches and success reports are most welcome!

Important: "For educational purposes only, *not* for flight planning! Use at
your own risk."

Example session
===============

     ~> metar --metar edny
    Parsing "METAR EDNY 220820Z 02005KT 5000 BR SCT008 OVC010 10/09 Q1022"
    METAR
      { _metardate = Date { _dayOfMonth = 22 , _hour = 8 , _minute = 20 }
      , _station = ICAO "EDNY"
      , _flags = []
      , _metarwind =
          Just
            Wind
              { _winddirection = Just (Degrees 20)
              , _velocity = Just (Knots 5)
              , _gusts = Nothing
              }
      , _metarvisibility = [ SpecificVisibility (Metres 5000) Nothing ]
      , _runwayvis = []
      , _runwaycond = []
      , _wx =
          [ Phenomenon
              { _intensity = Moderate
              , _desc = Nothing
              , _prec = Nothing
              , _obfus = Just Mist
              , _other = Nothing
              }
          ]
      , _clouds =
          [ ObservedCloud SCT (Height 800) Unclassified
          , ObservedCloud OVC (Height 1000) Unclassified
          ]
      , _metarpressure = Just (QNH 1022)
      , _temperature = Just 10
      , _dewPoint = Just 9
      , _weathertrend = NOTAVAIL
      , _remark = Nothing
      , _maintenance = False
      }

    ~> metar --taf edny
    Parsing "TAF        AMD EDNY 220900Z 2209/2306 24005KT 6000 BKN010        BECMG 2209/2211 SCT020"
    Right
      TAF
        { _tafissuedat =
            Date { _dayOfMonth = 22 , _hour = 9 , _minute = 0 }
        , _flags = [ AMD ]
        , _station = ICAO "EDNY"
        , _tafvalidfrom =
            Date { _dayOfMonth = 22 , _hour = 9 , _minute = 0 }
        , _tafvaliduntil =
            Date { _dayOfMonth = 23 , _hour = 6 , _minute = 0 }
        , _tafinitialconditions =
            [ TransWind
                Wind
                  { _winddirection = Just (Degrees 240)
                  , _velocity = Just (Knots 5)
                  , _gusts = Nothing
                  }
            , TransVis [ SpecificVisibility (KM 6) Nothing ]
            , TransRunwayVis []
            , TransWX []
            , TransClouds [ ObservedCloud BKN (Height 1000) Unclassified ]
            , TransPressure []
            ]
        , _tafchanges =
            [ BECMG
                (Just Date { _dayOfMonth = 22 , _hour = 9 , _minute = 0 })
                (Just Date { _dayOfMonth = 22 , _hour = 11 , _minute = 0 })
                [ TransClouds [ ObservedCloud SCT (Height 2000) Unclassified ] ]
            ]
        }


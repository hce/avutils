module Main where

import WX
import Data.Text (pack)

main :: IO ()
main = do
        print . parseWeather . pack $ "METAR EDDF 062020Z 05003KT CAVOK 04/02 Q1029 NOSIG="
        print . parseWeather . pack $ "METAR EDFE 061720Z 04002KT 8000 NSC 09/01 Q1028="
        print . parseWeather . pack $ "METAR EDFE 061720Z 04002KT 8000 3000NE NSC 09/01 Q1028 TEMPO +TSRA="
        print . parseWeather . pack $ "METAR EDFE 061720Z 04002KT 5000 RERA +SHRA VCRATS NSC 09/01 Q1028$"
        print . parseWeather . pack $ "METAR EDFE 061720Z 04002KT 50SM RERA +SHRA VCRATS NSC 09/M01 Q1028$"
        print . parseWeather . pack $ "METAR KORD 062051Z 14005KT 10SM SCT210 BKN250 00/M09 A3018 RMK AO2 SLP229 T00001094 56030 $"
        print . parseWeather . pack $ "METAR EDDP 062020Z 26001KT 0100 R08R/0200N R08L/0225N FG VV/// 02/02 Q1030 NOSIG="
        print . parseWeather . pack $ "METAR EDDV 062020Z 14005KT 2000 1400N R09L/P2000N R09R/P2000N MIFG BR NSC 05/04 Q1028 BECMG 1200 BCFG="
        print . parseWeather . pack $ "METAR EDFE 061720Z 04002KT CAVOK 09/01 Q1028 BECMG +TSRA BR BKN002CB="
        print . parseWeather . pack $ "METAR EDFE 061720Z 04002KT CAVOK 09/01 Q1028 PROB30 BECMG +TSRA BR BKN002CB="
        print . parseWeather . pack $ "METAR KORD 071051Z 18004KT 7SM CLR M08/M12 A2999 RMK AO2 SLP164 T10831117 $"
        print . parseWeather . pack $ "METAR KORD 071051Z 18004KT 7SM R08R/590242 CLR M08/M12 A2999 RMK AO2 SLP164 T10831117 $"
        print . parseWeather . pack $ "METAR LIBE 071255Z 35014G26KT 9999 SCT015 07/00 Q1015 RMK BKN SCT080 MON LIB VAL NIL VIS MIN 9999="
        putStrLn "======================================================================"
        putStrLn ""
        putStrLn "Enter METARs, one per line:"
        interact $ unlines . map (show . parseWeather . pack) . lines
              